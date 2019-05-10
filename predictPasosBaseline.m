function [YPredict,Y] = predictPasosBaseline(parametros,nPasos,XTest,YTest,muYTrain,stdYTrain) 
    %Realiza el calculo de las predicciones a varios pasos.
    
    %Casos
    if (nPasos==1)
       %Un paso
       YPredict =  XTest * parametros; 
       Y = YTest;
       %Denormalizacion
       Y = desnorm(Y,muYTrain,stdYTrain);
       YPredict = desnorm(YPredict,muYTrain,stdYTrain);  
    elseif(nPasos == 2)
        %Dos Pasos
        %Prediccion paso 1
        X1 = XTest * parametros;
        %Nuevo vector de entrada
        X = [X1(1:end-1),XTest(2:end,1:end-1)];
        %Nuevo vector Salidas.
        Y = YTest(2:end);
        %Predicciones
        YPredict = X * parametros;
        %Denormalizacion
        Y = desnorm(Y,muYTrain,stdYTrain);
        YPredict = desnorm(YPredict,muYTrain,stdYTrain);  
    elseif(nPasos == 3)
        %Prediccion tres pasos
        
        %Prediccion paso 1
        X1 = XTest * parametros;
        %Nuevo vector de entrada
        X = [X1(1:end-1),XTest(2:end,1:end-1)];
   
        %Prediccion a dos pasos.
        X2 = X * parametros;
        %Nuevo vector de entrada
        X = [X2(1:end-1),X(2:end,1:end-1)];
 
        %Prediccion a tres pasos.
        YPredict = X * parametros;
        %Nuevo vector Salidas.
        Y = YTest(nPasos:end);
        %Denormalizacion
        Y = desnorm(Y,muYTrain,stdYTrain);
        YPredict = desnorm(YPredict,muYTrain,stdYTrain); 
    elseif(nPasos==4)
        %Caso de 4 Pasos.
        
        %Prediccion paso 1
        X1 = XTest * parametros;
        %Nuevo vector de entrada
        X = [X1(1:end-1),XTest(2:end,1:end-1)];
   
        %Prediccion a dos pasos.
        X2 = X * parametros;
        %Nuevo vector de entrada
        X = [X2(1:end-1),X(2:end,1:end-1)];
 
        %Prediccion a tres pasos.
        X3 = X * parametros;
        %Nuevo vector de entrada
        X = [X3(1:end-1),X(2:end,1:end-1)];
        
        %Prediccion a 4 pasos.
        YPredict = X * parametros;
        %Nuevo vector Salidas.
        Y = YTest(nPasos:end);
        %Denormalizacion
        Y = desnorm(Y,muYTrain,stdYTrain);
        YPredict = desnorm(YPredict,muYTrain,stdYTrain);
        
    elseif(nPasos==5)
        %Caso de 5 Pasos
        
        %Prediccion paso 1
        X1 = XTest * parametros;
        %Nuevo vector de entrada
        X = [X1(1:end-1),XTest(2:end,1:end-1)];
   
        %Prediccion a 2 pasos.
        X2 = X * parametros;
        %Nuevo vector de entrada
        X = [X2(1:end-1),X(2:end,1:end-1)];
 
        %Prediccion a 3 pasos.
        X3 = X * parametros;
        %Nuevo vector de entrada
        X = [X3(1:end-1),X(2:end,1:end-1)];
        
        %Prediccion a 4 pasos.
        X4 = X * parametros;
        %Nuevo vector de entrada
        X = [X4(1:end-1),X(2:end,1:end-1)];
        
        %Prediccion a 5 pasos.
        YPredict = X * parametros;
        %Nuevo vector Salidas.
        Y = YTest(nPasos:end);
        %Denormalizacion
        Y = desnorm(Y,muYTrain,stdYTrain);
        YPredict = desnorm(YPredict,muYTrain,stdYTrain);        
    else
        disp('NO PROGRAMADO PARA MAS PASOS')
    end
    
    % 
end
