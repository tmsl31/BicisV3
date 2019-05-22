function [vectorI] = incertezaVectorEntradas(matX,YTrain,XTrain,model)
    %Calcula los valores de I para un vector vector de vectores de entrada.
    
    %Parametros:
    
    %Numero de entradas.
    nEntradas = size(X,1);
    %vector que almacene los valores de I como columna.
    vectorI = zeros(nEntradas,1);
    
    %Ciclo de computo.
    count = 1;
    while count < nEntradas  
        I = incertezaUnaEntrada(matX(count,:),YTrain,XTrain,model);
        vectorI(count,1) = I;
        count = count + 1;
    end
end