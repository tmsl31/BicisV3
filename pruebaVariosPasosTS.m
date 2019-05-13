function [vecRMSE] = pruebaVariosPasosTS(nPasos,XTest,YTest,modeloError,modeloVel,tipoModelo)
    %Realiza evaluacion de RMSE para diferentes numeros de pasos. Modelos
    %de Takagi-Sugeno.
    
    %Numero Predicciones
    nPredicciones = length(nPasos);
    %Vector RMSE
    vecRMSE = zeros(nPredicciones,1);
    %Loop
    count = 1;
    for pasos = nPasos
        [YPredict,Y] = prediccionVariosPasosTS(nPasos,XTest,YTest,modeloError,modeloVel,tipoModelo);
        vecRMSE(count) = RMSE(YPredict,Y);
        count = count + 1;
    end
end

