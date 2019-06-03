function [vectorI] = incertezaVectorEntradas(matX,model)
    %Calcula los valores de I para un vector vector de vectores de entrada.
    
    %Parametros:
    
    %Numero de entradas.
    nInputs = size(matX,1);
    %vector que almacene los valores de I como columna.
    vectorI = zeros(nInputs,1);
    
    %Ciclo de computo.
    count = 1;
    while count <= nInputs  
        I = incertezaUnaEntrada(matX(count,:),model);
        vectorI(count,1) = I;
        count = count + 1;
    end
end