function [XTrain,XVal,XTest,YTrain,YVal,YTest,muXTrain,stdXTrain,muYTrain,stdYTrain] = divConjuntos(in,out,porcentajeTrain,porcentajeVal,norm)
    %Funcion que dados los porcentajes de entrenamiento, validación y test,
    %realiza la division en estos conjuntos.
    
    %Razones.
    razonTrain = porcentajeTrain/100;
    razonVal = porcentajeVal/100;
    %Total de datos
    totalDatos = length(out);
    %Division
    %Train
    nElementosTrain = floor(totalDatos*razonTrain);
    XTrain = in(1:nElementosTrain,:);
    YTrain = out(1:nElementosTrain,1);
    %Validacion
    nElementosVal = floor(totalDatos*razonVal);
    XVal = in(nElementosTrain+1:nElementosTrain + nElementosVal,:);
    YVal = out(nElementosTrain+1:nElementosTrain + nElementosVal,1);
    %Test
    XTest = in(nElementosTrain + nElementosVal + 1:end,:);
    YTest = out(nElementosTrain + nElementosVal + 1:end,1);
    %Valores si no se realiza la normalizacion.
    muXTrain = []; stdXTrain = []; muYTrain = []; stdYTrain = [];
    %Normalizacion
    if norm==1
        [XTrain,XVal,XTest,YTrain,YVal,YTest,muXTrain,stdXTrain,muYTrain,stdYTrain] = normalize(XTrain,XVal,XTest,YTrain,YVal,YTest);
    end
end

function [XTrain,XVal,XTest,YTrain,YVal,YTest,muXTrain,stdXTrain,muYTrain,stdYTrain] = normalize(XTrain,XVal,XTest,YTrain,YVal,YTest)
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