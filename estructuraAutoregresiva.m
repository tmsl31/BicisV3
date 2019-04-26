function [output,input] = estructuraAutoregresiva(data,nRegresores,shuffle)
    %Funcion que entregue la matriz de datos tal que se tenga la salida del
    %modelo y las entradas, con el número de autoregresores
    %correspondiente.
    
    %Dimensiones
    [nDatos,~] = size(data);
    %Salidas
    output = data(nRegresores+1:nDatos, 1);
    [altoSalida,~] = size(output);
    %Construccion de la matriz.
    input = zeros(altoSalida,nRegresores);
    %Llenado
    count = 1;
    while count<=nRegresores
        input(:,count) = data(nRegresores-count+1:nDatos-count,1);
        count = count + 1;
    end
    %Posibilidad de reordenar las filas de la matriz de forma random.
    if shuffle == 1
        %Juntar salidas y entradas.
        matConjunta = [output,input];
        %Shuffle.
        [output,input] = shuffleFilas(matConjunta);
    end
end

function [salida,entradas] = shuffleFilas(matriz)
    %Funcion que desordene las filas.
    
    %Shuffle.
    randMatriz = matriz(randperm(size(matriz, 1)), :);
    %Division en entradas y salidas.
    salida = randMatriz(:,1);
    entradas = randMatriz(:,2:end);
end