function s=Sintonizacion_n_arx(yin,xin, Model,Ny,Nu, steps_c, confidence)
%La funcion Sintonizacion_n_arx(yin,xin, Model,Ny,Nu, steps_c, confidence) se
%encarga de sintonizar los intervalos obtenidos con el metodo de la covarianza
%para el caso donde el modelo difuso recibe como entrada los regresores de 
%una variables exogena u.
%* Nota: Se asume que los valores futuros de la entrada exogena son conocidas
%
%Entradas de la funcion
%   yin: Vector con mediciones de la salida del sistema
%   xin: Matriz con entradas del modelo, donde las primeras Ny columnas
%        corresponden a regresores de y, y las Nu columnas siguientes son
%        regresores de u.
%   Model: Modelo difuso obtenido con funcion TakagiSugeno()
%   Ny: Cantidad de regresores de y que componen a la matriz de entrada X
%   Nu: Cantidad de regresores de u que componen a la matriz de entrada X
%   steps_c: cantidad de pasos para el intervalo de prediccion
%   confidence: probabilidad de cobertura deseada para el intervalo a
%               sintonizar
%
%* Programado por Oscar Cartagena el 10 de abril del 2019

%% se cargan los datos disponibles para la validación
model   = Model.model;
a1      = 0.001;
am      = 0.001;
pasos   = steps_c;        % Número de pasos para la predicción
CP      = confidence;
% Inputs Model


%%Particionando Datos
tamy=length(yin); %Tamaño de los datos
entr=75;            % porcentaje de datos a utilizar como entrenamiento
test=0;             % porcentaje de datos a utilizar como test
%val=25;             % porcentaje de datos a utilizar como Validación

yent  = yin(1:round((tamy*entr)/100));                                       %particionando datos según porcentaje establecido
ytest = yin(round((tamy*entr)/100)+1:round((tamy*(test+entr))/100));        %particionando datos según porcentaje establecido
yval  = yin(round((tamy*(test+entr))/100)+1:tamy);                           %particionando datos según porcentaje establecido

xent  = xin(1:round((tamy*entr)/100),:);                                       %particionando datos según porcentaje establecido
xtest = xin(round((tamy*entr)/100)+1:round((tamy*(test+entr))/100),:);        %particionando datos según porcentaje establecido
xval  = xin(round((tamy*(test+entr))/100)+1:tamy,:);

%%
y=yent;                         % Datos para comparar (Entrenamiento, Test o Validación)
%y=y_test;
%y=y_val;

X=xent;                         % selecciona los datos a usar en la validación de la predicción, entre entrenamiento, test y validación
%X=x_test;
%X=x_val;
f=size(X);
%%
y_outp=[];      % Salida del Predicción
y_Up=[];        % Salida Superior de Predicción
y_Lp=[];        % Salida Inferior de Predicción

% Se realiza la predicción a N pasos
for j=1:f(1)-(pasos-1)
    x_aux=X(j,:);     % Datos de entrada
    for i=1:pasos
        r=1;
        input_m=x_aux;
        interval_d = Intervalo(model,a1,input_m);  % Calcula valor superior e inferior, previa sintonización y obtención de a1
        y_out      = ysim(input_m,model.a,model.b,model.g);  % Calcula la salida
        if Ny>1
            x_aux      = [y_out x_aux(1:Ny-1) X(j+i,Ny+1:Ny+Nu)];  % Actualiza Datos de entrada completo
        else
            x_aux      = [y_out X(j+i,1:Ny+Nu)];  % Actualiza Datos de entrada completo
        end
    end
    y_outp(j,1)=y_out;                 %Almacena la salida de predicción
    int(j,1)=interval_d.interv;    
     
end % Fin predicción a N pasos

%% Filtro 
%     for j=1:f(1)-(pasos-1)    %% evitar valores negativos
%         if y(j+(pasos-1))<0
%             y_outp(j,1)=0;
%         end
%     end

%% Se realiza la sintonización
t=true;
while t==true
       
    for j=1:f(1)-(pasos-1)
         y_Up(j,1)=y_outp(j,1)+a1*int(j,1);
         y_Lp(j,1)=y_outp(j,1)-a1*int(j,1);
    end
           
    ci=CI(y(pasos:end),y_Up(1:end),y_Lp(1:end))
    if  ci>CP
        a=a1;
        t=false;
    else
        a1=a1+am;
    end
end
%%

figure ()
ciplot(y_Lp,y_Up,'b');              
hold on
plot(y_outp,'--r')
plot(y(pasos:end),'*b')
plot(y_Up,'k','LineWidth',1.2)
plot(y_Lp,'k','LineWidth',1.2)
grid

%% Formato del Gráfico
legend('Intervalo de Predicción','Predicción','Dato Real');
ylabel('Señal modelada');
xlabel('Tiempo [n° de muestras]');
xlim([1 100])
ylim([0.7 1])
%% Métricas
RMSE=sqrt(mean((y_outp-y(pasos:end)).^2));                                       %Root Mean Square Error
MAE=mean(abs((y(pasos:end)-y_outp)));                                            %Mean Absolute Error  
MAPE=100*(mean(abs((y(pasos:end)-y_outp))./abs(y(pasos:end))));                  %Mean Absolute Percentage Error
MSE=mean(abs((y(pasos:end)-y_outp)).^2);                                         %Mean Square Error
R2=1-(sum((y(pasos:end)-y_outp).^2)/sum((y(pasos:end)-mean(y(pasos:end))).^2));  %Determination Index
[train.PICP,train.PINAW,train.NORM,train.J]= PI(y_outp,y(pasos:end),y_Up,y_Lp,CP);                       %PICP: Prediction Interval Coverage Probability

y_up_tr=y_Up;
y_lw_tr=y_Lp;
y_p_tr=y_outp;
y_r_tr=y(pasos:end);

y_outp=[];      % Salida del Predicción
y_Up=[];        % Salida Superior de Predicción
y_Lp=[];        % Salida Inferior de Predicción
int=[];
y=yval;
X=xval;                         % selecciona los datos a usar en la validación de la predicción, entre entrenamiento, test y validación
%X=x_test;
%X=x_val;
f=size(X);
% Se realiza la predicción a N pasos
for j=1:f(1)-(pasos-1)
    x_aux=X(j,:);     % Datos de entrada
    for i=1:pasos
        r=1;
        input_m=x_aux;
        interval_d = Intervalo(model,a1,input_m);                  % Calcula valor superior e inferior, previa sintonización y obtención de a1
        y_out      = ysim(input_m,model.a,model.b,model.g);                    % Calcula la salida
        x_aux      = [y_out x_aux(1:end-1)];                                   % Actualiza Datos de entrada completo
    end
    y_outp(j,1)=y_out;                 %Almacena la salida de predicción
    int(j,1)=interval_d.interv;    
     
end % Fin predicion

for j=1:f(1)-(pasos-1)
         y_Up(j,1)=y_outp(j,1)+a*int(j,1);
         y_Lp(j,1)=y_outp(j,1)-a*int(j,1);
end

[val.PICP,val.PINAW,val.NORM,val.J]= PI(y_outp,y(pasos:end),y_Up,y_Lp,CP);    %% Gráficas intervalo, predicción y dato real

y_up_val=y_Up;
y_lw_val=y_Lp;
y_p_val=y_outp;
y_r_val=y(pasos:end);


%% Output
s.alfa  = a;
s.conf  = CP;
s.pasos = pasos;
s.RMSE  = RMSE;
s.MAE   = MAE;
s.MSE   = MSE;
s.MAPE  = MAPE;
s.R2    = R2;
s.m_ent= train;

s.m_val= val;
% s.PICP  = PICP;
% s.PINAW = PINAW;
s.train.y_lp=y_lw_tr;
s.train.y_up=y_up_tr;
s.train.int=y_up_tr-y_p_tr;
s.train.yp=y_p_tr;
s.train.yr=y_r_tr;

s.val.y_lp=y_lw_val;
s.val.y_up=y_up_val;
s.val.int=y_up_val-y_p_val;
s.val.yp=y_p_val;
s.val.yr=y_r_val;
end