function [vecRMSE] = pruebaVariosPasosBaseline(parametros,nPasos,XTest,YTest,muYTrain,stdYTrain) 
    %Realiza evaluacion de RMSE para diferentes numeros de pasos.
    
    %Numero Predicciones
    nPredicciones = length(nPasos);
    %Vector RMSE
    vecRMSE = zeros(nPredicciones,1);
    %Loop
    count = 1;
    for pasos = nPasos
        [YPredict,Y] = predictPasosBaseline(parametros,pasos,XTest,YTest,muYTrain,stdYTrain);
        vecRMSE(count) = RMSE(YPredict,Y);
        count = count + 1;
    end
end

function [YPredict,Y] = predictPasosBaseline(parametros,nPasos,XTest,YTest,muYTrain,stdYTrain) 
    %Realiza el calculo de las predicciones a varios pasos.
    
    %Numero de regresores.
    [nMuestras,nRegresores] = size(XTest);
    %Casos
    if (nPasos==1)
       %Un paso
       YPredict =  XTest * parametros; 
       Y = YTest;
    elseif(nPasos == 2)
        %Dos Pasos
        %Prediccion paso 1
        X1 = XTest * parametros;
        %Nuevo vector de entrada
        X = [X1(1:nMuestras-1),XTest(2:nMuestras,1:nRegresores-1)];
        %Nuevo vector Salidas.
        Y = YTest(2:nMuestras);
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
        X = [X1(1:nMuestras-1),XTest(2:nMuestras,1:nRegresores-1)];
   
        %Prediccion a dos pasos.
        X2 = X * parametros;
        %Nuevo vector de entrada
        X = [X2(1:end-1),X(2:end,1:end-1)];
 
        %Prediccion a tres pasos.
        YPredict = X * parametros;
        %Nuevo vector Salidas.
        Y = YTest(nPasos:nMuestras);
        %Denormalizacion
        Y = desnorm(Y,muYTrain,stdYTrain);
        YPredict = desnorm(YPredict,muYTrain,stdYTrain);  
    end
    
    
    % 
end
