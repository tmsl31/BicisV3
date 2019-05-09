function [params,XTrain,XTest,YTrain,YTest,YPredict,muYTrain,stdYTrain] = baseline () 
    %Representacion lineal para el error.
    
    
    %% Estructuracion de datos.
    disp('<<Generacion del modelo>>')
    
    tipoModelo = input('Tipo de modelo (0->Autoregresivo; 1->Con Velocidad de lider)');
    nRegresores = input('Numero de regresores Maximo inicial:');
    
    %Generacion de la estrutura del modelo. 
    [out,in] = estructuraModelo(nRegresores, tipoModelo);
    
    %% Division de conjuntos.
    
    %Division en conjuntos de entrenamiento validacion y test.
    disp('<<Division en Train,Val,Test>>')
    %Parametros
    %norm = input('Normalizacion? (0 -> NO; 1 -> SI):');
    norm = 1;
    %Porcentajes
    porcentajeTrain = 60;
    porcentajeVal = 20;
    disp(strcat('Porcentaje Train:'," ",string(porcentajeTrain),'%;Porcentaje Val:'," ",string(porcentajeVal),'%'))
    %Division de conjuntos
    [XTrain,XVal,~,YTrain,YVal,YTest,~,~,muYTrain,stdYTrain] = divConjuntos(in,out,porcentajeTrain,porcentajeVal,norm);
    
    %%Estadisticas.
    estadisticosError(YTrain,YVal,YTest);
    
    %% ANALISIS DE SENSIBILIDAD
    sensibilidadRegresores(XTrain,XVal,YTrain,YVal,muYTrain,stdYTrain);
    nRegresoresOptimo = input('Numero Optimo de Regresores: ');
    
    %% Construccion del modelo lineal -> Ojo: sin termino libre.
    
    %Estructura
    [out,in] = estructuraModelo(nRegresoresOptimo, tipoModelo);
    %Division de los conjuntos
    [XTrain,~,XTest,YTrain,~,YTest,~,~,muYTrain,stdYTrain] = divConjuntos(in,out,porcentajeTrain,porcentajeVal,norm);
    % Obtencion de los par�metros utilizando LMS. Se utiliza el conjunto de
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
    %Funcion que realice la de normalizacion en base a las estad�sticas de
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