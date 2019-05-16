function [model,XTrain2,XVal2,XTest2]  = TySConSeleccion(XTrain,XVal,XTest,YTrain,YVal,YTest,maximoReglas,nRegresores,tipoModelo)
    %Modelo de Takagi Sugeno con la seleccion de caracteristicas y numero
    %de reglas utilizando el clustering y analisis de sensibilidad.
    
    %Diferenciacion de indices de acuerdo al tipo de modelo a utilizar.
    if (tipoModelo == 0)
        %Vector de indices a mantener en entrada.
        indicesMantener = input('Vector de indices a mantener en entrada:');
    elseif(tipoModelo == 1)
        %Numero optimo de regresores a utilizar.
        nOptimoRegresores = input('Numero optimo de regresores modelo con velocidad');
    elseif(tipoModelo == 2)
        %Vector de indices a manetener en entrada.
        indicesMantener = input('Vector de indices a mantener en entrada:');
    else
        disp('Error en TySConSeleccion')
    end
    
    %Eliminacion de regresores.
    if (tipoModelo == 0)
        %Caso de autoregresivo.
        [XTrain2,XVal2,XTest2] = seleccionCaracteristicas(XTrain,XVal,XTest,indicesMantener,tipoModelo);
    elseif(tipoModelo == 1)
        %Caso de modelo con velocidad
        [XTrain2,XVal2,XTest2] = seleccionCaracteristicas(XTrain,XVal,XTest,nOptimoRegresores,tipoModelo);
    elseif(tipoModelo == 2)
        [XTrain2,XVal2,XTest2] = seleccionCaracteristicas(XTrain,XVal,XTest,indicesMantener,tipoModelo);
    else
        dips('Error en TySConSeleccion')
    end
    
    %Nueva prueba de numero de clusters con el numero de regresores utilizados.
    [~,~] = clusters_optimo(YVal,YTrain,XVal2,XTrain2,maximoReglas);
    %Numero de reglas a utilizar
    optimoReglas2 = input('Numero de reglas a utilizar: ');
    %Entrenamiento del modelo de Takagi-Sugeno con el numero de reglas
    %determinado.
    [model,~] = TakagiSugeno(YTrain,XTrain2,optimoReglas2,[2 4 1]);
    %Vector de regresores utilizados.
    if (tipoModelo == 0)
        %Modelo de autoregresores.
        e = NaN * ones(1,nRegresores);
        e(indicesMantener) = 1;
        model.e = e;
    elseif(tipoModelo == 1)
        %Modelo con velocidad.
        e = NaN * ones(1,nRegresores);
        e(1,1:nOptimoRegresores) = 1;
        model.e = e;
    elseif(tipoModelo == 2)
        %Modelo de autoregresores.
        e = NaN * ones(1,nRegresores);
        e(indicesMantener) = 1;
        model.e = e;
    else
        disp('ERROR')
    end
end

function [XT,XV,XTe] = seleccionCaracteristicas(XTrain,XVal,XTest,indicesEntradas,tipoModelo)
    %Funcion que dado un vector de regresores a conservar modifica las
    %variables de entrada del modelo.
    
    %Casos
    if (tipoModelo == 0)
        XT = XTrain(:,indicesEntradas);
        XV = XVal(:,indicesEntradas);
        XTe = XTest(:,indicesEntradas);
    elseif(tipoModelo == 1)
        %Asignacion
        XT = XTrain;
        XV = XVal;
        XTe = XTest;
        %NumeroAutoregresoresOriginal
        [~,nAutoOrig] = size(XTest);
        %Numero de autoregresores por variable
        nAutoCU = nAutoOrig/2;
        %Eliminacion
        XT(:,[indicesEntradas + 1:nAutoCU,nAutoCU + indicesEntradas + 1:nAutoOrig]) = [];
        XV(:,[indicesEntradas + 1:nAutoCU,nAutoCU + indicesEntradas + 1:nAutoOrig]) = [];
        XTe(:,[indicesEntradas + 1:nAutoCU,nAutoCU + indicesEntradas + 1:nAutoOrig]) = [];
    elseif(tipoModelo == 2)
        XT = XTrain(:,indicesEntradas);
        XV = XVal(:,indicesEntradas);
        XTe = XTest(:,indicesEntradas);
    else
        disp('Error Seleccion de caracteristicas')
    end
end