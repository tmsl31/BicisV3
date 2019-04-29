function [salida,entrada] = estructuraRegresoresVelocidad(datos1,datos2,datos3,v1,v2,v3,nRegresores,shuffle)
    %Funcion que entregue las matrices de entrada salida para las tres
    %velocidades de lider utilizada (en m/s).

    %Generar Entradas/Salidas.
    %Low
    [salida1,entrada1] = estructuraAutoregresiva(datos1,nRegresores,shuffle);
    %Medium
    [salida2, entrada2] = estructuraAutoregresiva(datos2,nRegresores,shuffle);
    %High
    [salida3,entrada3] = estructuraAutoregresiva(datos3,nRegresores,shuffle);
    %Agregar velocidad como entrada.
    %Low
    [nFilas1,~] = size(entrada1);
    entrada1 = [entrada1,v1*ones(nFilas1,1)];
    %Medium
    [nFilas2,~] = size(entrada2);
    entrada2 = [entrada2,v2*ones(nFilas2,1)];
    %High
    [nFilas3,~] = size(entrada3);
    entrada3 = [entrada3,v3*ones(nFilas3,1)];
    %Juntar
    salida = [salida1;salida2;salida3];
    entrada = [entrada1;entrada2;entrada3];
    if shuffle == 1
        %Juntar salidas y entradas.
        matConjunta = [salida,entrada];
        %Shuffle.
        [salida,entrada] = shuffleFilas(matConjunta);
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