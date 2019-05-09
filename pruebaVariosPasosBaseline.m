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

