
function [out,in] = estructuraModelo2(nRegresores, tipoModelo)
    %Funcion que permita obtener la estructura de modelo, dada una cierta
    %estructura y el numero de autoregresores deseado.
    
    %% Estructura 
    
    %Importar los datos.
    data = importarDatosNuevos();
    
    %DATOS: Velocidades baja, media y alta. Datos de velocidad asociados a
    %cada dataset.
    lowSpeed = 2.77;
    mediumSpeed = 4.16;
    highSpeed = 5.00;
    
    %Obtener los datos de error.
    [datosErrorLow, datosErrorMid, datosErrorHi,datosVelLow,datosVelMid, datosVelHi, datosLow,datosMid,datosHi]= separarDatos (data,lowSpeed,mediumSpeed,highSpeed)
        
    %Distincion entre tipos de modelos.
    if (tipoModelo == 0)
        %Caso unicamente autoregresivo.
        disp('<<Generacion de estructura autoregresiva.>>')
        %Generacion de la estructura autoregresiva. Se utilizan datos
        %desordenados por defecto.
        [out,in] = estructuraAutoregresiva(datosErrorLow,datosErrorMid,datosErrorHi,nRegresores,1);
        disp('Estructura Autoregresiva')
        disp(strcat('Se utilizan inicialmente '," ",string(nRegresores)," " ,'regresores'))
    elseif (tipoModelo == 1)
%         %Modelo autoregresivo con la velocidad de lider.
%         disp('<<Generacion de estructura autoregresiva + Velocidad de lider..>>')
%         %Generacion de la estructura.
%         [out,in] = estructuraRegresoresVelocidad(lowData,mediumData,highData,lowSpeed,mediumSpeed,highSpeed,nRegresores,1);
%         disp('Estructura con autoregresores y velocidad.')
%         disp(strcat('Se utilizan inicialmente '," ",string(nRegresores)," " ,'Regresores inicialmente'))

    else
        disp('Opcion Erronea')
    end
end

%% Funciones Auxiliares.
% INCORPORACION DE DATOS.
function [data] = importarDatosNuevos()
    %Funcion que realice la importacion y separacion de los nuevos datos.
    %Se tiene una matriz con los datos existentes en .csv
    Rinit = 1;
    Cinit = 0;
    datos = csvread('C:\Users\tlara\OneDrive\Documentos\GitHub\BicisV3\datosError\datoserrorhumano.csv',Rinit,Cinit);
    %Agregar el error de actuacion
    data = agregarErrorActuacion(datos);
end

function [datosConError] = agregarErrorActuacion(data)
    %Funcion que calcule el error de actuacion a partir de los datos.
    
    %Dimensiones del vector de data.
    [nMuestras,nCols] = size(data);
    %Vector que almacene los datos con error.
    datosConError = zeros(nMuestras,nCols+1);
    %Calcular el vector de error de actuacion
    vectorError = data(:,6)-data(:,4);
    %Ingresar en la nueva Matriz de datos.
    datosConError (:,1:2) = data(:,1:2);
    datosConError(:,3) = data(:,4);
    datosConError(:,4) = data(:,6);
    datosConError(:,5) = data(:,5);
    datosConError(:,6) = data(:,3);
    datosConError(:,7) = vectorError;
    disp('Estructura')
    disp('None, Orden, CACC, Acceleration, LeaderSpeed, CACC, HumanError.')
end

function [datosErrorLow, datosErrorMid, datosErrorHi,datosVelLow,...
          datosVelMid, datosVelHi, datosLow,datosMid,datosHi]= separarDatos (data,lowSpeed,mediumSpeed,highSpeed)
    %Funcion que separe los datos de acuerdo a su velocidad.
    %Funcion retorna los datos totales, y los de velocidad relativa y error
    %de aceleracion asociados a cada velocidad de lider.

    %Separacion entre datos de baja,media y alta velocidad.
    %Busqueda de indices de inicio. Por robutez incluimos la busqueda del primero.
    inicioLow = find(data(:,5) == lowSpeed,1);
    inicioMedium = find(data(:,5) == mediumSpeed,1);
    inicioHigh = find(data(:,5) == highSpeed,1);
    
    %Datos
    datosLow = data(inicioLow:end,:);
    datosMid = data(inicioMedium:inicioLow-1,:);
    datosHi = data(inicioHigh:inicioMedium-1,:);
    
    %Datos de error de aceleracion
    datosErrorLow = datosLow(:, 7);
    datosErrorMid = datosMid(:, 7);
    datosErrorHi = datosHi(:, 7);
    
    %Datos de velocidad instantanea.
    datosVelLow = datosLow(:,6);
    datosVelMid = datosMid(:,6);
    datosVelHi = datosHi(:,6);
end

%ESTRUCTURA DE LOS MODELOS.
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