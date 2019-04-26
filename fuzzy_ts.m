function [ p,y_Up,y_Lp] = fuzzy_ts(Datos_c, Model, Interval, horizon)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
Datos  = Datos_c;
model  = Model.model;
pasos  = Interval.pasos;      % Número de pasos para la predicción
CP     = Interval.conf;
a1     = Interval.alfa;
% Inputs Model
e=model.e;


for j=1:horizon
    if j==1
        input_m=Datos(model.ereg)';
        int=Intervalo(model,a1,input_m);                  % Calcula valor superior e inferior, previa sintonización y obtención de a1
        y_out=int.yts;                      % Calcula la salida
        Datos=[y_out;Datos(1:end-1)];
        Datos_up=[int.up;Datos(1:end-1)];
        Datos_lp=[int.lw;Datos(1:end-1)];
        y_Up(j,1)=int.up;
        y_Lp(j,1)=int.lw;
    else
        input_m=Datos(model.ereg)';
        int=Intervalo(model,a1,input_m);                  % Calcula valor superior e inferior, previa sintonización y obtención de a1
        y_out=int.yts; 
        Datos=[y_out;Datos(1:end-1)];
        
        input_m1=Datos_up(model.ereg)';
        int1=Intervalo(model,a1,input_m1);
        y_Up(j,1)=int1.up;
        Datos_up=[int1.up;Datos_up(1:end-1)];
        
        input_m2=Datos_lp(model.ereg)';
        int2=Intervalo(model,a1,input_m2);
        y_Lp(j,1)=int2.lw;  
        Datos_lp=[int2.lw;Datos_lp(1:end-1)];
        % Actualiza Datos de entrada completo
    end
    p(j,1)=y_out;
    
    %Almacena la salida de predicción
    
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
% Fin predicción a N pasos

end

