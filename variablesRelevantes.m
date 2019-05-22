function [vecErrorVal,indicesEliminacion] = variablesRelevantes(XTrain,YTrain,XVal,YVal,nReglas, tipoModelo)
    %Funcion que realiza la evaluacion de las variables de entrada,
    %eliminando paso a paso las menos relevantes.
    
    %Casos
    if (tipoModelo == 0)
        %Caso de modelo autoregresivo.
        [vecErrorVal,indicesEliminacion] = variablesRelevantesAutoregresivo(XTrain,YTrain,XVal,YVal,nReglas);
    elseif (tipoModelo == 1)
        %Caso de modelo de autoregresores y Velocidad
         [vecErrorVal,indicesEliminacion] = variablesRelevantesVelocidad(XTrain,YTrain,XVal,YVal,nReglas);
    elseif(tipoModelo == 2)
        %Caso de modelo de autoregresores e indicacion de CACC.
        [vecErrorVal,indicesEliminacion] = variablesRelevantesCACC(XTrain,YTrain,XVal,YVal,nReglas);           
    else
        disp('Error seleccion de variables.')
    end

end


%% FUNCIONES DE CASOS.

%MODELO AUTOREGRESIVO.
function [vecErrorVal,indicesEliminacion] = variablesRelevantesAutoregresivo(XTrain,YTrain,XVal,YVal,nReglas)
    %Evaluacion de varibles relevantes a partir de considerar un modelo
    %autoregresivo.

    %Numero de regresores original.
    [~,nRegresores] = size(XTrain);
    %Vector de errores de Test
    vecErrorVal = zeros(1,nRegresores);
    %Vector para los indices de eliminacion
    indicesEliminacion = zeros(1,nRegresores);
    %Evaluacion del error de test.
    count = 1;
    while nRegresores > 0
        %Calcular error
        errVal=errortest(YTrain,XTrain,YVal,XVal,nReglas);
        %Agregar a vector
        vecErrorVal(1,count) = errVal;
        %Analisis de sensibilidad
        [p, ~] = sensibilidad(YTrain,XTrain,nReglas);
        %Eliminar
        indicesEliminacion(1,count) = p;
        %Eliminar Columna
        XTrain(:,p) = [];
        XVal(:,p) = [];
        %Nueva Dimension
        [~,nRegresores] = size(XTrain);
        %
        count = count + 1;
    end
    %Grafica del error de validacion
    figure()
    hold on 
    plot(vecErrorVal)
    title('Error de validacion para numero de entradas eliminadas')
    ylabel('RMSE')
    xlabel('Numero de variables eliminadas')
    hold off
end

%MODELO AUTOREGRESIVO + VELOCIDAD.
function [vecErrorVal,indicesEliminacion] = variablesRelevantesVelocidad(XTrain,YTrain,XVal,YVal,nReglas)
    % Funcion que realiza el análisis de sensibilidad para el modelo con
    % autoregresores y velocidad. Para esto, se utiliza la misma forma
    % explorada anteriormente donde se considera la eliminacion de un
    % autoregresor y muestras anteriores de la velocidad.
    % Puede no ser optimo.
    
    %Numero de regresores original.
    [~,entradas] = size(XTrain);
    nRegresores = entradas/2;
    %Vector de errores de Test
    vecErrorVal = zeros(1,nRegresores);
    %Vector para los indices de eliminacion
    indicesEliminacion = [];
    %Evaluacion del error de test.
    vectorNumeroRegresores = nRegresores:-1:1;
    %Numero de entradas eliminadas
    numeroEliminadas = 0:1:nRegresores-1;
    %Loop.
    count = 1;
    for num = vectorNumeroRegresores
        %Entradas.
        %Entrenamiento.
        XTrain1 = XTrain(:,1:num);
        YTrain1 = YTrain;
        %Validacion
        XVal1 = XVal(:,1:num);
        YVal1 = YVal;
        %Calcular el error de test.
        error = errortest(YTrain1,XTrain1,YVal1,XVal1,nReglas);
        %Agregar el error de validacion al vector
        vecErrorVal(count) = error;
        count = count + 1;  
    end
    %Grafica del error de validacion
    figure()
    hold on 
    plot(numeroEliminadas,vecErrorVal)
    title('Error de validacion para numero de entradas eliminadas')
    ylabel('RMSE')
    xlabel('Numero de variables eliminadas')
    hold off
end

function [vecErrorVal,indicesEliminacion2] = variablesRelevantesCACC(XTrain,YTrain,XVal,YVal,nReglas)
    %Funcion que realice el análisis de sensibilidada para el modelo con
    %autoregresores y CACC.
    
    %Numero de regresores original.
    [~,nEntradas] = size(XTrain);
    %Vector de errores de validacion
    vecErrorVal = zeros(1,nEntradas-1);
    %Vector de indices de eliminacion
    indicesEliminacion = zeros(1,nEntradas);
    %Matriz de indices de eliminacion
    matEliminacion = ones(nEntradas);
    %Ciclo
    count = 1;
    while count < nEntradas
        %Calcular error
        errVal=errortest(YTrain,XTrain,YVal,XVal,nReglas);
        %Agregar a vector
        vecErrorVal(1,count) = errVal;
        %Analisis de sensibilidad
        [p, ~] = sensibilidad(YTrain,XTrain,nReglas);
        %Agregar al registro.
        indicesEliminacion(1,count) = p;
        matEliminacion = ordenEliminacion(matEliminacion,p,count);
        %Eliminar Columna
        XTrain(:,p) = [];
        XVal(:,p) = [];
        count = count + 1;

    end
    indicesEliminacion2.indices = indicesEliminacion;
    indicesEliminacion2.orden = matEliminacion;
    %Grafica del error de validacion
    figure()
    hold on 
    plot(vecErrorVal,'-+')
    title('Error de validacion para numero de entradas eliminadas. Autoregresores + CACC')
    ylabel('RMSE')
    xlabel('Numero de variables eliminadas')
    hold off
end

function [mat] = ordenEliminacion(mat,indice,fila)
    %Funcion que muestra el orden de eliminacion de las variables.
    
    %Numero de elementos nulos en la fila anterior
    if(fila ~= 1)
        cambioIndice = sum(mat(fila,1:indice) == 0);
        count = 0;
        indice2 = indice;
        while (count ==0)
            if(mat(fila:end,indice2+cambioIndice) == 0)
                indice2 = indice2 + 1;
                cambioIndice = cambioIndice + 1;
            else
                count = 1;
            end
        end
    end
    %Eliminar.
    if(fila==1)
        mat(fila:end,indice) = 0;
    else
        mat(fila:end,indice+cambioIndice) = 0;
    end

end