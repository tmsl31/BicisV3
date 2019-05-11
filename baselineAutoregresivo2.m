function [params,XTrain,XTest,YTrain,YTest,YPredict,muYTrain,stdYTrain] = baselineAutoregresivo2 () 
    %Representacion lineal para el error.
    
    
    %% Estructuracion de datos.
    disp('<<Generacion del modelo>>')
    
    tipoModelo = input('Tipo de modelo (0->Autoregresivo; 1->Con velocidad instantanea)');
    nRegresores = input('Numero de regresores Maximo inicial:');
    
    %Generacion de la estrutura del modelo. 
    [in,inV,out,outV] = estructuraModelo2(nRegresores, tipoModelo);

    
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
    [XTrainV,XValV,XTestV,YTrainV,YValV,YTestV,muXTrainV,stdXTrainV,muYTrainV,stdYTrainV] = divConjuntos(inV,outV,porcentajeTrain,porcentajeVal,norm);
    %%Estadisticas.
    estadisticosError(YTrain,YVal,YTest);
    
    %% ANALISIS DE SENSIBILIDAD
    analisisSensibilidad(XTrain,XVal,YTrain,YVal,muYTrain,stdYTrain,tipoModelo)
    nRegresoresOptimo = input('Numero Optimo de Regresores: ');
    
    %% Construccion del modelo lineal -> Ojo: sin termino libre.
    
    %Estructura
    [in,inV,out,outV] = estructuraModelo2(nRegresoresOptimo, tipoModelo);
    %Division de los conjuntos
    [XTrain,XVal,XTest,YTrain,YVal,YTest,muXTrain,stdXTrain,muYTrain,stdYTrain] = divConjuntos(in,out,porcentajeTrain,porcentajeVal,norm);
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

%% Funciones Auxiliares

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
    %Vector que almacene los valores de RMSE
    vectorRMSE = zeros(nRegresores,1);
    
    %Ciclo de eliminacion y evaluacion.
    count = 1;
    %Vector de regresores.
    vecRegresores = nRegresosres:-1:1;
    %Loop
    for i = vecRegresores
        X1 = XTrain;
        %Eliminacion de entradas entrenamiento.
        X1(:,[nRegresores:-1:i,(nRegresores + nRegresores:-1:i)]) = [];
        Y1 = YTrain;
        %Eliminacion de entradas validacion
        X2 = XVal;
        X2(:,[nRegresores:-1:i,(nRegresores + nRegresores:-1:i)]) = [];
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

