function s=Sintonizacion(Datos_c, Model, confidence,steps_c)

Datos   = Datos_c;      % se cargan los datos disponibles para la validaci�n
model   = Model.model;
a1      = 0.001;
am      = 0.001;
pasos   = steps_c;        % N�mero de pasos para la predicci�n
CP      = confidence;
% Inputs Model
e=model.e;

%%Particionando Datos
tamy=length(Datos); %Tama�o de los datos
entr=75;            % porcentaje de datos a utilizar como entrenamiento
test=0;             % porcentaje de datos a utilizar como test
%val=25;             % porcentaje de datos a utilizar como Validaci�n

yent  = Datos(1:round((tamy*entr)/100));                                       %particionando datos seg�n porcentaje establecido
ytest = Datos(round((tamy*entr)/100)+1:round((tamy*(test+entr))/100));        %particionando datos seg�n porcentaje establecido
yval  = Datos(round((tamy*(test+entr))/100)+1:tamy);                           %particionando datos seg�n porcentaje establecido

NY=size(e,2);  
%%
[y_ent,y_test,y_val,x_ent, x_test, x_val]=Autoregresor(NY, yent, ytest, yval);    % Llama funci�n que organiza los datos de entrada y salida teniendo en cuenta NY

y=y_ent;                         % Datos para comparar (Entrenamiento, Test o Validaci�n)
%y=y_test;
%y=y_val;

X=x_ent;                         % selecciona los datos a usar en la validaci�n de la predicci�n, entre entrenamiento, test y validaci�n
%X=x_test;
%X=x_val;
f=size(X);
%%
y_outp=[];      % Salida del Predicci�n
y_Up=[];        % Salida Superior de Predicci�n
y_Lp=[];        % Salida Inferior de Predicci�n

% Se realiza la predicci�n a N pasos
for j=1:f(1)-(pasos-1)
    x_aux=X(j,:);     % Datos de entrada
    for i=1:pasos
        %%%funci�n que deja solamente las entradas al modelo
        D_in=isnan(x_aux.*e);                     % Se indican los retardos a eliminar
        r=1;
        for z=1:f(2)
            if D_in(z)==0
                input_m(r)=x_aux(z);
                r=r+1;
            end
        end      %%Fin ordenar entradas al modelo, quedan en input_m
        interval_d = Intervalo(model,a1,input_m);                  % Calcula valor superior e inferior, previa sintonizaci�n y obtenci�n de a1
        y_out      = ysim(input_m,model.a,model.b,model.g);                    % Calcula la salida
        x_aux      = [y_out x_aux(1:end-1)];                                   % Actualiza Datos de entrada completo
    end
    y_outp(j,1)=y_out;                 %Almacena la salida de predicci�n
    int(j,1)=interval_d.interv;    
     
end % Fin predicci�n a N pasos

%% Filtro 
%     for j=1:f(1)-(pasos-1)    %% evitar valores negativos
%         if y(j+(pasos-1))<0
%             y_outp(j,1)=0;
%         end
%     end

%% Se realiza la sintonizaci�n
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

%% M�tricas
RMSE=sqrt(mean((y_outp-y(pasos:end)).^2));                                       %Root Mean Square Error
MAE=mean(abs((y(pasos:end)-y_outp)));                                            %Mean Absolute Error  
MAPE=100*(mean(abs((y(pasos:end)-y_outp))./abs(y(pasos:end))));                  %Mean Absolute Percentage Error
MSE=mean(abs((y(pasos:end)-y_outp)).^2);                                         %Mean Square Error
R2=1-(sum((y(pasos:end)-y_outp).^2)/sum((y(pasos:end)-mean(y(pasos:end))).^2));  %Determination Index
[PICP,PINAW,NORM,J]= PI(y_outp,y(pasos:end),y_Up,y_Lp,CP);                       %PICP: Prediction Interval Coverage Probability
                                                                                 %PINAW:Prediction Interval Normalized averaged Width
%% Gr�ficas intervalo, predicci�n y dato real
figure ()
ciplot(y_Lp,y_Up,'b');              
hold on
plot(y_outp,'--r')
plot(y(pasos:end),'*b')
plot(y_Up,'k','LineWidth',1.2)
plot(y_Lp,'k','LineWidth',1.2)
grid

%% Formato del Gr�fico
legend('Prediction Interval','Forecast','Real Data');
ylabel('Power [kw]');
xlabel('Time [x15min]');
%xlim([1000-pasos 1450-pasos])
%ylim([4 23])

%% Output
s.alfa  = a;
s.conf  = CP;
s.pasos = pasos;
s.RMSE  = RMSE;
s.MAE   = MAE;
s.MSE   = MSE;
s.MAPE  = MAPE;
s.R2    = R2;
s.PICP  = PICP;
s.PINAW = PINAW;
s.e=e;
end