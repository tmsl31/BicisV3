function [model,result]  = TySConSeleccion(XTrain,XVal,XTest,YTrain,YVal,YTest,maximoReglas,nRegresores)
    %Modelo de Takagi Sugeno con la seleccion de caracteristicas y numero
    %de reglas utilizando el clustering y analisis de sensibilidad.
    
    %Vector de indices a mantener en entrada.
    indicesMantener = input('Vector de indices a mantener en entrada:');
    %Eliminacion de regresores.
    [XTrain2,XVal2,XTest2] = seleccionCaracteristicas(XTrain,XVal,XTest,indicesMantener);
    %Nueva prueba de numero de clusters con el numero de regresores utilizados.
    [eTrainCluster2,eValCluster2] = clusters_optimo(YVal,YTrain,XVal2,XTrain2,maximoReglas);
    %Numero de reglas a utilizar
    optimoReglas2 = input('Numero de reglas a utilizar: ');
    %Entrenamiento del modelo de Takagi-Sugeno con el numero de reglas
    %determinado.
    [model,result] = TakagiSugeno(YTrain,XTrain2,optimoReglas2,[2 2 2]);
    %Vector de regresores utilizados.
    e = NaN * ones(1,nRegresores);
    e(indicesMantener) = 1;
    model.e = e;
    
end

function [XTrain,XVal,XTest] = seleccionCaracteristicas(XTrain,XVal,XTest,indicesEntradas)
    %Funcion que dado un vector de regresores a conservar modifica las
    %variables de entrada del modelo.
 
    XTrain = XTrain(:,indicesEntradas);
    XVal = XVal(:,indicesEntradas);
    XTest = XTest(:,indicesEntradas);
end