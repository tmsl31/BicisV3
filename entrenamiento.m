function [M,XTrain,XVal,XTest,YTrain,YVal,YTest,muYTrain,muXTrain] = entrenamiento()  
    %Funcion que realice el entrenamiento del modelo de Takagi Sugeno.
    
    %% Estructuracion de datos.
    disp('<<Generacion del modelo>>')
    
    tipoModelo = input('Tipo de modelo (0->Autoregresivo; 1->Con Velocidad de lider)');
    nRegresores = input('Numero de regresores:');
    
    %Generacion de la estrutura del modelo. 
    [out,in] = estructuraModelo(nRegresores, tipoModelo);
    
    %% Division de conjuntos.
    
    %Division en conjuntos de entrenamiento validacion y test.
    disp('<<Division en Train,Val,Test>>')
    %Parametros
    %norm = input('Normalizacion? (0 -> NO; 1 -> SI):');
    %Normalizacion se realiza dentro de cluster_optimo.
    norm  = 0;
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
    [eTrainCluster1,eValCluster1] = clusters_optimo(YVal,YTrain,XVal,XTrain,maximoReglas);
    %Numero de reglas determinado mediante la visualización del error de
    %validacion
    optimoReglas = input('Numero de reglas optimo segun error de validacion:');
    
    %% Análisis de sensibilidad.
    
    disp('<<Analisis de Sensibilidad>>')
    %Calculo del error
    [vecErrorVal,matricesTrain,matricesVal,indicesEliminacion,matIndices] = variablesRelevantes(XTrain,YTrain,XVal,YVal,optimoReglas);
    disp('orden de eliminacion:')
    disp(indicesEliminacion)
    
    %% Construccion del modelo.
    
    disp('<<Construccion del modelo de T&S>>')
    %Generacion del modelo  resultado con el numero de reglas deseado.
    [M,result] = TySConSeleccion(XTrain,XVal,XTest,YTrain,YVal,YTest,maximoReglas,nRegresores);
    
end