function [YEstimado,YReal] = estimacionUnPaso(model,X,Y,YTest,muXTrain,stdXTrain,muYTrain,stdYTrain)
    %Funcion que realiza la estimacion para un paso
    %utilizando el modelo de Takagi & Sugeno.
 
    %Caso base en que la estimación se realiza a un paso.
    YEstimado = ysim(X,model.a,model.b,model.g);
    YReal = Y;
    %Desnormalizar
    
end