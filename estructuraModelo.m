%% Funcion principal.

function [out,in] = estructuraModelo(nRegresores, tipoModelo)
    %Funcion que permita obtener la estructura de modelo, dada una cierta
    %estructura y el numero de autoregresores deseado.
    
    %Importar los datos.
    lowData = csvread('C:\Users\tlara\OneDrive\Documentos\GitHub\BicisV3\datosError\lowSpeed.csv');
    mediumData = csvread('C:\Users\tlara\OneDrive\Documentos\GitHub\BicisV3\datosError\mediumSpeed.csv');
    highData = csvread('C:\Users\tlara\OneDrive\Documentos\GitHub\BicisV3\datosError\highSpeed.csv');
    
    %DATOS: Velocidades baja, media y alta. Datos de velocidad asociados a
    %cada dataset.
    lowSpeed = 2.77;
    mediumSpeed = 4.16;
    highSpeed = 5.00;
    
    %Distincion entre tipos de modelos.
    if (tipoModelo == 1)
        %Caso unicamente autoregresivo.
        disp('<<Generacion de estructura autoregresiva.>>')
        %Generacion de la estructura autoregresiva. Se utilizan datos
        %desordenados por defecto.
        [out,in] = estructuraAutoregresiva(lowData,mediumData,highData,nRegresores,1);
        disp('Estructura Autoregresiva')
        disp(strcat('Se utilizan inicialmente '," ",string(nRegresores)," " ,'Regresores inicialmente'))
    elseif (tipoModelo == 2)
        %Modelo autoregresivo con la velocidad de lider.
        disp('<<Generacion de estructura autoregresiva + Velocidad de lider..>>')
        %Generacion de la estructura.
        [out,in] = estructuraRegresoresVelocidad(lowData,mediumData,highData,lowSpeed,mediumSpeed,highSpeed,nRegresores,1);
        disp('Estructura con autoregresores y velocidad.')
        disp(strcat('Se utilizan inicialmente '," ",string(nRegresores)," " ,'Regresores inicialmente'))

    else
        disp('Opcion Erronea')
    end
end

%% Funciones Auxiliares.

function [output,input] = estructuraAutoregresiva(lowData,mediumData,highData,nRegresores,shuffle)
    %Funcion que entregue la matriz de datos tal que se tenga la salida del
    %modelo y las entradas, con el número de autoregresores
    %correspondiente.

    %Concatenacion de los datos.
    data = [lowData;mediumData;highData];
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