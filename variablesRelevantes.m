function [vecErrorVal,matricesTrain,matricesVal,indicesEliminacion,matIndices] = variablesRelevantes(XTrain,YTrain,XVal,YVal,nReglas)
    %Funcion que realiza la evaluacion de las variables de entrada,
    %eliminando paso a paso las menos relevantes.

    %Numero de regresores original.
    [~,nRegresores] = size(XTrain);
    %Vector de errores de Test
    vecErrorVal = zeros(1,nRegresores);
    %Creacion de diccionario que almacene las matrices.
    matricesTrain = {};
    matricesVal = {};
    %Vector para los indices de eliminacion
    indicesEliminacion = zeros(1,nRegresores);
    %Matriz de indices
    matIndices = zeros(nRegresores);
    %Evaluacion del error de test.
    count = 1;
    while nRegresores > 0
        %Almacenar matriz
        matricesTrain{count} = XTrain;
        matricesVal{count} = XVal;
        %Calcular error
        errVal=errortest(YTrain,XTrain,YVal,XVal,nReglas);
        %Agregar a vector
        vecErrorVal(1,count) = errVal;
        %Analisis de sensibilidad
        [p, indices] = sensibilidad(YTrain,XTrain,nReglas);
        [~,nIndices] = size(indices);
        %Agregar indices a la matriz
        matIndices(count,1:nIndices) = indices;
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