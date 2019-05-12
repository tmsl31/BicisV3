function [MError,MVel,XTrain2,XVal2,XTest2,YTrain,YVal,YTest] = entrenamiento()  
    %Funcion que realice el entrenamiento del modelo de Takagi Sugeno.
    
    %% Estructuracion de datos.
    disp('<<Generacion del modelo>>')
    
    tipoModelo = input('Tipo de modelo (0->Autoregresivo; 1->Con Velocidad de lider)');
    nRegresores = input('Numero de regresores:');
    
    %Generacion de la estrutura del modelo. 
    [in,inV,out,outV] = estructuraModelo2(nRegresores, tipoModelo);
    
    %% Division de conjuntos.
    
    %Division en conjuntos de entrenamiento validacion y test.
    disp('<<Division en Train,Val,Test>>')
    %Parametros
    %norm = input('Normalizacion? (0 -> NO; 1 -> SI):');
    %Normalizacion. Se indica no normalizar en TakagiSugeno.
    norm  = 1;
    %Porcentajes
    porcentajeTrain = 60;
    porcentajeVal = 20;
    disp(strcat('Porcentaje Train:'," ",string(porcentajeTrain),'%;Porcentaje Val:'," ",string(porcentajeVal),'%'))
    %Division de conjuntos
    [XTrain,XVal,XTest,YTrain,YVal,YTest,~,~,muYTrain,stdYTrain] = divConjuntos(in,out,porcentajeTrain,porcentajeVal,norm);

    %% Busqueda de numero de reglas.
    
    disp('<<Numero de Reglas>>')
    %Fuzzy C-Means.
    %Input
    maximoReglas = input('Numero Maximo de reglas:');
    %Grafica de la evolucion del error.
    [~,~] = clusters_optimo(YVal,YTrain,XVal,XTrain,maximoReglas);
    %Numero de reglas determinado mediante la visualización del error de
    %validacion
    optimoReglas = input('Numero de reglas optimo segun error de validacion:');
    
    %% Análisis de sensibilidad.
    
    disp('<<Analisis de Sensibilidad>>')
    %Calculo del error
    [~,indicesEliminacion] = variablesRelevantes(XTrain,YTrain,XVal,YVal,optimoReglas,tipoModelo);
    disp('orden de eliminacion:')
    disp(indicesEliminacion)
    
    %% Construccion del modelo.
    
    disp('<<Construccion del modelo de T&S>>')
    %Generacion del modelo  resultado con el numero de reglas deseado.
    [MError,XTrain2,XVal2,XTest2] = TySConSeleccion(XTrain,XVal,XTest,YTrain,YVal,YTest,maximoReglas,nRegresores);
    %Almacenar los datos para la desnormalizacion.
    MError.mu = muYTrain;
    MError.std = stdYTrain;
    %% Caso en que se requiera un modelo lineal para la velociadad
    if (tipoModelo == 1)
        %Construccion del modelo lineal.
        [params,~,~,~,~,~,muYTrainVel,stdYTrainVel] = modeloLineal(inV,outV);
        %Modelo de velocidad
        MVel.params = params;
        MVel.mu = muYTrainVel;
        MVel.std = stdYTrainVel; 
    else
        MVel = [];
    end
end




%% AUXILIARES PARA VELOCIDAD.
function [params,XTrain,XTest,YTrain,YTest,YPredict,muYTrainVel,stdYTrainVel] = modeloLineal(inV,outV)
%% Division de conjuntos.
    
    %Division en conjuntos de entrenamiento validacion y test.
    disp('<<Division en Train,Val,Test>>')
    %Parametros
    norm = 1;
    %Porcentajes
    porcentajeTrain = 60;
    porcentajeVal = 20;
    disp(strcat('Porcentaje Train:'," ",string(porcentajeTrain),'%;Porcentaje Val:'," ",string(porcentajeVal),'%'))
    %Division de conjuntos
    %Modelo ERROR.
    [XTrain,XVal,XTest,YTrain,YVal,YTest,muXTrain,stdXTrain,muYTrain,stdYTrain] = divConjuntos(in,out,porcentajeTrain,porcentajeVal,norm);
    %Modelo VELOCIDAD.
    if tipoModelo == 1
        [XTrainV,XValV,XTestV,YTrainV,YValV,YTestV,muXTrainV,stdXTrainV,muYTrainV,stdYTrainV] = divConjuntos(inV,outV,porcentajeTrain,porcentajeVal,norm);
    end
    %%Estadisticas.
    estadisticosError(YTrain,YVal,YTest);
    
    %% ANALISIS DE SENSIBILIDAD
    analisisSensibilidad(XTrain,XVal,YTrain,YVal,muYTrain,stdYTrain,tipoModelo)
    nRegresoresOptimo = input('Numero Optimo de Regresores: ');
    
    %% Construccion del modelo lineal -> Ojo: sin termino libre.
    
    %Estructura
    [in,inV,out,outV] = estructuraModelo2(nRegresoresOptimo, tipoModelo);
    %Division de los conjuntos
    [XTrain,~,XTest,YTrain,~,YTest,~,~,muYTrain,stdYTrain] = divConjuntos(in,out,porcentajeTrain,porcentajeVal,norm);
    % Obtencion de los parámetros utilizando LMS. Se utiliza el conjunto de
    % entrenamiento.
    params = (transpose(XTrain)*XTrain)^(-1)*transpose(XTrain)*YTrain;
    
    %% Evaluacion del modelo.
    [YPredict, Y, RMSEBaseline] = evaluacionBaseline(params,XTest,YTest,muYTrain,stdYTrain);
    
    %% Display de la informacion.
    disp('<<Resultados>>')
    disp(strcat('RMSE del modelo de baseline:',string(RMSEBaseline)));
    
    % Grafico de comparacion de Y e YPredict
    figure()
    hold on
    title('Comparacion de realidad y prediccion. Baseline')
    ylabel('error de aceleracion [m/s^2]')
    xlabel('Numero de muestra')
    plot(Y,'-r')
    plot(YPredict,'-b')
    legend('Real','Prediction')
    hold off
    
end

function [YPredict, Y, RMSEBaseline] = evaluacionBaseline(params,X,Y,muYTrain,stdYTrain)
    %Funcion que realiza la evaluacion de conjunto de un conjunto
    %utilizando el modelo lineal base.
    
    %Evaluacion de entradas en el modelo.
    YPredict = X*params;
    %Desnomalizacion
    Y = denormalizacion(Y,muYTrain,stdYTrain);
    YPredict = denormalizacion(YPredict,muYTrain,stdYTrain);    
    %Calculo de RMSE entre las salidas predichas y las salidas reales.
    [RMSEBaseline] = RMSE(Y,YPredict);
end

function [Ydenorm] = denormalizacion(Y,muYTrain,stdYTrain)
    %Funcion que realice la de normalizacion en base a las estadísticas de
    %entrenamiento.
    Ydenorm = Y*stdYTrain + muYTrain;
end

function [] = estadisticosError(YTrain,YVal,YTest)
    %Funcion que analice los estadisticos de los valores de error y
    %entregue un resumen, esto con el fin de ver la utilidad del modelo. y
    %comparar con el valor RMSE.
    
    %Concatenar
    datosY = [YTrain;YVal;YTest];
    %Calcular el promedio
    mediaY = mean(datosY);
    %Calcular la desviacion estandar.
    stdY = std(datosY);
    %Minimo
    minY = min(datosY);
    %Maximo
    maxY = max(datosY);
    
    disp('<<Estadisticas de los datos.>>')
    disp(strcat('Media:',string(mediaY)))
    disp(strcat('Desviacion estandar:',string(stdY)))
    disp(strcat('Minimo:',string(minY)))
    disp(strcat('Maximo:',string(maxY)))
end


% ANALISIS DE SENSIBILIDAD

%Funcion que diferencia entre modelos puramente autoregresivo y con
%velocidad instantanea.

function [] = analisisSensibilidad(XTrain,XVal,YTrain,YVal,muYTrain,stdYTrain,tipoModelo)
    %Funcion que realiza el analisis de sensibilidad dependiendo del tipo
    %de modelo.
    
    %Casos.
    if(tipoModelo == 0)
        %Caso de modelo puramente autoregresivo.
        sensibilidadRegresores(XTrain,XVal,YTrain,YVal,muYTrain,stdYTrain);
    elseif(tipoModelo == 1)
        %Caso de modelo con error y velocidad instantanea.
        sensibilidadRegresoresVelocidad(XTrain,XVal,YTrain,YVal,muYTrain,stdYTrain)
    else
        disp('OPCION INCORRECTA. ANALISIS DE SENSIBILIDAD')
    end

end

%Sensibilidad Regresores.
function [] = sensibilidadRegresores(XTrain,XVal,YTrain,YVal,muYTrain,stdYTrain)
    %Buscar el numero optimo de autoregresores. Se hace esto eliminando de
    %una fila en las entradas del modelo y evaluar. Puede no alcanzarse el
    %optimo!!!!
    
    %Dimensiones originales
    [~,nRegresores] = size(XTrain);
    %Vector que almacene los valores de RMSE.
    vectorRMSE = zeros(nRegresores,1);
    % Ciclo
    count = 1;
    %Numeros regresores
    vecRegresores = nRegresores:-1:1;
    %Loop
    for i = vecRegresores
        %Re estructuracion
        X1 = XTrain(:,1:i);
        Y1 = YTrain;
        X2 = XVal(:,1:i);
        Y2 = YVal;
        %Obtencion de parametros
        params = (transpose(X1)*X1)^(-1)*transpose(X1)*Y1;
        %Evaluacion del modelo.
        [~,~,RMSEBaseline] = evaluacionBaseline(params,X2,Y2,muYTrain,stdYTrain);
        vectorRMSE(count) = RMSEBaseline;
        count = count + 1;
    end
    
    figure()
    hold on
    title('RMSE vs Numero de regresores.')
    ylabel('RMSE [m/s^2]')
    xlabel('Numero de regresores')
    plot(vecRegresores,vectorRMSE)
    hold off
end

function [] = sensibilidadRegresoresVelocidad(XTrain,XVal,YTrain,YVal,muYTrain,stdYTrain)
    %Analisis de sensibilidad para modelo con regresores y velocidad. Se
    %eliminan regresores de error y velocidad simultaneamente. No
    %necesariamente optimo.
    
    %Dimensiones originales.
    [~,nRegresores] = size(XTrain);
    nRegresores = nRegresores/2;
    %Vector que almacene los valores de RMSE
    vectorRMSE = zeros(nRegresores,1);
    
    %Ciclo de eliminacion y evaluacion.
    count = 1;
    %Vector de regresores.
    vecRegresores = nRegresores:-1:1;
    %Loop
    for i = vecRegresores
        disp(i)
        X1 = XTrain;
        %Eliminacion de entradas entrenamiento.
        X1(:,[nRegresores:-1:i,nRegresores + (nRegresores:-1:i)]) = [];
        Y1 = YTrain;
        %Eliminacion de entradas validacion
        X2 = XVal;
        X2(:,[nRegresores:-1:i,(nRegresores + nRegresores:-1:i+nRegresores)]) = [];
        Y2 = YVal;
        %Obtencion de parametros
        params = (transpose(X1)*X1)^(-1)*transpose(X1)*Y1;
        %Evaluacion del modelo.
        [~,~,RMSEBaseline] = evaluacionBaseline(params,X2,Y2,muYTrain,stdYTrain);
        vectorRMSE(count) = RMSEBaseline;
        count = count + 1;        
    end
    
    %plot
    figure()
    hold on
    title('RMSE vs Numero de regresores.')
    ylabel('RMSE [m/s^2]')
    xlabel('Numero de regresores')
    plot(vecRegresores,vectorRMSE)
    hold off
    
    
end

