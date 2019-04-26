function R=validation_T1(Datos_c, Model, Interval)

Datos  = Datos_c;
model  = Model.model;
pasos  = Interval.pasos;      % Número de pasos para la predicción
CP     = Interval.conf;
a1     = Interval.alfa;
% Inputs Model
e=model.e;

NY=size(e,2);  
%%
%%Particionando Datos
tamy=length(Datos); %Tamaño de los datos
entr=0;            % porcentaje de datos a utilizar como entrenamiento
test=0;       
%val=25;        

yent=Datos(1:round((tamy*entr)/100));                                       %particionando datos según porcentaje establecido
ytest=Datos(round((tamy*entr)/100)+1:round((tamy*(test+entr))/100));        %particionando datos según porcentaje establecido
yval=Datos(round((tamy*(test+entr))/100)+1:tamy);                           %particionando datos según porcentaje establecido

[y_ent,y_test,y_val,x_ent, x_test, x_val]=Autoregresor(NY, yent, ytest, yval);    % Llama función que organiza los datos de entrada y salida teniendo en cuenta NY
%%

%y=y_ent;                         % Datos para comparar (Entrenamiento, Test o Validación)
%y=y_test;
y=y_val;

%X=x_ent;                         % selecciona los datos a usar en la validación de la predicción, entre entrenamiento, test y validación
%X=x_test;
X=x_val;

f=size(X);
%%
y_outp=[];      % Salida del Predicción
y_Up=[];        % Salida Superior de Predicción
y_Lp=[];        % Salida Inferior de Predicción

% Se realiza la predicción a N pasos
for j=1:f(1)-(pasos-1)
    x_aux=X(j,:);     % Datos de entrada
    for i=1:pasos
        %%%función que deja solamente las entradas al modelo
        D_in=isnan(x_aux.*e);                     % Se indican los retardos a eliminar
        r=1;
        for z=1:f(2)
            if D_in(z)==0
                input_m(r)=x_aux(z);
                r=r+1;
            end
        end      %%Fin ordenar entradas al modelo, quedan en input_m
        interval_d=Intervalo(model,a1,input_m);                  % Calcula valor superior e inferior, previa sintonización y obtención de a1
        y_out=ysim(input_m,model.a,model.b,model.g);                      % Calcula la salida
        x_aux=[y_out x_aux(1:end-1)];                                   % Actualiza Datos de entrada completo
    end
    y_outp(j,1)=y_out;                 %Almacena la salida de predicción
    y_Up(j,1)=interval_d.up;
    y_Lp(j,1)=interval_d.lw;
    
     if y_Lp(j,1)<0
        y_Lp(j,1)=0;
    end 
    
%     if isnan(y_outp(j,1))==1
%         y_outp(j,1)=y_outp(j-1,1);        
%     end
%     if isnan(y_Up(j,1))==1
%         y_Up(j,1)=y_Up(j-1,1);        
%     end
%     if isnan(y_Lp(j,1))==1
%         y_Lp(j,1)=y_Lp(j-1,1);        
%     end    

end % Fin predicción a N pasos
%%

%% Métricas
RMSE=sqrt(mean((y_outp-y(pasos:end)).^2));                                       %Root Mean Square Error
MAE=mean(abs((y(pasos:end)-y_outp)));                                            %Mean Absolute Error  
MAPE=100*(mean(abs((y(pasos:end)-y_outp))./abs(y(pasos:end))));                  %Mean Absolute Percentage Error
MSE=mean(abs((y(pasos:end)-y_outp)).^2);                                         %Mean Square Error
R2=1-(sum((y(pasos:end)-y_outp).^2)/sum((y(pasos:end)-mean(y(pasos:end))).^2));  %Determination Index
[PICP,PINAW,NORM,J]= PI(y_outp,y(pasos:end),y_Up,y_Lp,CP);                       %PICP: Prediction Interval Coverage Probability
                                                                                 %PINAW:Prediction Interval Normalized averaged Width
%% Gráficas intervalo, predicción y dato real
figure ()
ciplot(y_Lp,y_Up,'b');           
hold on
%plot(y_outp,'--r')
plot(y(pasos:end),'.b','MarkerSize',10)
plot(y_Up,'k','LineWidth',1)
plot(y_Lp,'k','LineWidth',1)

%% Formato del Gráfico
%legend('Prediction Interval','Forecast','Real Data','Location', 'NorthWest');
legend('Prediction Interval','Real Data','Location', 'NorthWest');
ylabel('Power [kw]');
xlabel('Time [x15min]');
%xlim('manual')
% xlim([100-pasos 580-pasos])
% ylim([0 5.5])

%xlim([1920-pasos 2400-pasos])
% xlim([1920-pasos 2352-pasos])
% ylim([0 20])

%%outputs
R.RMSE=RMSE;
R.MAE=MAE;
R.MSE=MSE;
R.MAPE=MAPE;
R.R2=R2;
R.PICP=PICP;
R.PINAW=PINAW;
end