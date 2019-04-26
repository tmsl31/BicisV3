function [XTrain,XVal,XTest,YTrain,YVal,YTest] = divConjuntos(entradas,salida,porcentajeTrain,porcentajeVal,norm)
    %Funcion que dados los porcentajes de entrenamiento, validación y test,
    %realiza la division en estos conjuntos.
    
    %Razones.
    razonTrain = porcentajeTrain/100;
    razonVal = porcentajeVal/100;
    %Total de datos
    totalDatos = length(salida);
    %Division
    %Train
    nElementosTrain = floor(totalDatos*razonTrain);
    XTrain = entradas(1:nElementosTrain,:);
    YTrain = salida(1:nElementosTrain,1);
    %Validacion
    nElementosVal = floor(totalDatos*razonVal);
    XVal = entradas(nElementosTrain+1:nElementosTrain + nElementosVal,:);
    YVal = salida(nElementosTrain+1:nElementosTrain + nElementosVal,1);
    %Test
    XTest = entradas(nElementosTrain + nElementosVal + 1:end,:);
    YTest = salida(nElementosTrain + nElementosVal + 1:end,1);
    %Normalizacion
    if norm==1
        [XTrain,XVal,XTest,YTrain,YVal,YTest] = normalize(XTrain,XVal,XTest,YTrain,YVal,YTest);
    end
end

function [XTrain,XVal,XTest,YTrain,YVal,YTest] = normalize(XTrain,XVal,XTest,YTrain,YVal,YTest)
    %Funcion que normaliza.

    %Estadisticos de entrenamiento
    muXTrain = mean(XTrain);
    stdXTrain = std(XTrain);
    %
    muYTrain = mean(YTrain);
    stdYTrain = std(YTrain);
    %Normalizar
    XTrain = (XTrain - muXTrain)./stdXTrain;
    XVal = (XVal-muXTrain)./stdXTrain;
    XTest = (XTest-muXTrain)./stdXTrain;
    %
    YTrain = (YTrain - muYTrain)./stdYTrain;
    YVal = (YVal - muYTrain)./stdYTrain;
    YTest = (YTest - muYTrain)./stdYTrain;
end