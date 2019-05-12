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
    %Normalizacion. Se indica no normalizar en TakagiSugeno.
    norm  = 1;
    %Porcentajes
    porcentajeTrain = 60;
    porcentajeVal = 20;
    disp(strcat('Porcentaje Train:'," ",string(porcentajeTrain),'%;Porcentaje Val:'," ",string(porcentajeVal),'%'))
    %Division de conjuntos
    [XTrain,XVal,XTest,YTrain,YVal,YTest,muXTrain,stdXTrain,muYTrain,stdYTrain] = divConjuntos(in,out,porcentajeTrain,porcentajeVal,norm);

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
    [MError,XTrain2,XVal2,XTest2] = TySConSeleccion(XTrain,XVal,XTest,YTrain,YVal,YTest,maximoReglas,nRegresores,tipoModelo);
    %Almacenar los datos para la desnormalizacion.
    MError.mu = muYTrain;
    MError.std = stdYTrain;
    %% Caso en que se requiera un modelo lineal para la velociadad
    if (tipoModelo == 1)
        %Construccion del modelo lineal.
        [params,muYTrainVel,stdYTrainVel] = modeloLinealVelocidad(Xtrain2,muXTrain,stdXTrain);
        %Modelo de velocidad
        MVel.params = params;
        MVel.mu = muYTrainVel;
        MVel.std = stdYTrainVel; 
    else
        MVel = [];
    end
end
