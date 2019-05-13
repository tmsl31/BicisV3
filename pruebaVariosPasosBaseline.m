function [vecRMSE] = pruebaVariosPasosBaseline(parametros,nPasos,XTest,YTest,muYTrain,stdYTrain,tipoModelo) 
    %Realiza evaluacion de RMSE para diferentes numeros de pasos.
    
    %Numero Predicciones
    nPredicciones = length(nPasos);
    %Vector RMSE
    vecRMSE = zeros(nPredicciones,1);
    %Loop
    count = 1;
    for pasos = nPasos
        [YPredict,Y] = predictPasosBaseline(parametros,pasos,XTest,YTest,muYTrain,stdYTrain,tipoModelo);
        vecRMSE(count) = RMSE(YPredict,Y);
        count = count + 1;
    end
    
    if (tipoModelo == 0)
        %Modelo Autoregresivo.
        modelo = 'Autoregresivo';       
    elseif(tipoModelo == 1)
        %Auto regresivo + velocidad
        modelo = 'Autoregresivo+Velocidad';
    else
        disp('NOOOOOOOOOOOOOOOO')
    end
    %Plot
    figure()
    hold on
    plot(vecRMSE,'-o')
    xlabel('Número de pasos')
    ylabel('RMSE')
    title(strcat('RMSE versus horizonte de predicción. Modelo: ',modelo))
    hold off
end

