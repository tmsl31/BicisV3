
function [in,out] = estructuraModelo3(nRegresores, tipoModelo)
    %Funcion que permita obtener la estructura de modelo, dada una cierta
    %estructura y el numero de autoregresores deseado.
    
    %% Estructura 
    
    %Importar los datos.
    %Orden de los datos: [None, Orden, Acceleration, CACC, LeaderSpeed, 
    %Instant Speed, HumanError]
    data = importarDatosNuevos();
    
    %DATOS: Velocidades baja, media y alta. Datos de velocidad asociados a
    %cada dataset.
    lowSpeed = 2.77;
    mediumSpeed = 4.16;
    highSpeed = 5.00;
    
    %Obtener los datos de error.
    [datosLow,datosMid,datosHi]= separarDatos (data,lowSpeed,mediumSpeed,highSpeed);
    %Distincion entre tipos de modelos.
    if (tipoModelo == 0)
        %Caso unicamente autoregresivo.
        disp('<<Generacion de estructura autoregresiva.>>')
        %Generacion de la estructura autoregresiva. Se utilizan datos
        %desordenados por defecto.
        [in,out] = estructuraAutoregresiva(datosLow,datosMid,datosHi,nRegresores,1);
        disp('Estructura Autoregresiva')
        disp(strcat('Se utilizan inicialmente '," ",string(nRegresores)," " ,'regresores'))
    elseif (tipoModelo == 1)
        %Modelo autoregresivo con la velocidad instantanea.
        disp('<<Generacion de estructura autoregresiva + Velocidad instantanea>>')
        %Generacion de la estructura.
        [in,~,out,~] = estructuraRegresoresVelocidad(datosErrorLow, datosErrorMid, datosErrorHi,datosVelLow,datosVelMid, datosVelHi,nRegresores,1);
        disp('Estructura con autoregresores y velocidad.')
        disp(strcat('Se utilizan inicialmente '," ",string(nRegresores)," " ,'Regresores inicialmente'))
    elseif(tipoModelo == 2)
        %Modelo autoregresivo con la velocidad instantanea.
        disp('<<Generación de estructura autoregresiva + CACC>>')
        %Generacion de la estructura.
        [in,out] = estructuraAutoregresivaCACC(datosLow,datosMid,datosHi,nRegresores,1);
        disp('Estructura con autoregresores y velocidad')
        disp(strcat('Se utilizan inicialmente '," ",string(nRegresores)," " ,'Regresores inicialmente'))
    else
        disp('Opcion Erronea')
    end
end

%% Funciones Auxiliares.

function [datosLow,datosMid,datosHi]= separarDatos (data,lowSpeed,mediumSpeed,highSpeed)
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
end

%ESTRUCTURA DE LOS MODELOS.
function [in,out] = estructuraAutoregresivaCACC(dataLow,dataMid,dataHi,nRegresores,shuffle)
    %Funcion que entregue la estructura de entrada para el modelo
    %autregresivo con indicaciones del CACC.
    
    %Obtener los vectores de error y CACC
    %Error.
    datosErrorLow = dataLow(:,7);
    datosErrorMid = dataMid(:,7);
    datosErrorHi = dataHi(:,7); 
    %CACC.
    datosCACCLow = dataLow(:,4);
    datosCACCMid = dataMid(:,4);
    datosCACCHi = dataHi(:,4);  
    
    %Generar entrada salida para el error.
    dataError = [datosErrorLow;datosErrorMid;datosErrorHi];
    dataCACC = [datosCACCLow;datosCACCMid;datosCACCHi];
    
    %Numero de datos
    [nDatos,~] = size(dataError);
    %Salida del Modelo.
    out = dataError(nRegresores+1:nDatos,1);
    %Dimensiones de la salida.
    [altoSalida,~] = size(out);
    
    %Entrada del modelo.
    %Construccion de la matriz.
    in1 = zeros(altoSalida,nRegresores);
    in2 = zeros(altoSalida,nRegresores);
    %Llenado
    count = 1;
    while count<=nRegresores
        in1(:,count) = dataError(nRegresores-count+1:nDatos-count,1);
        in2(:,count) = dataCACC(nRegresores-count+1:nDatos-count,1);
        count = count + 1;
    end
    
    %Union de los regresores.
    in = [in1,in2];
    %Opcion de realiza shuffle.
    if shuffle == 1
        %Juntar salidas y entradas.
        matConjunta = [out,in];
        %Shuffle.
        [out,in] = shuffleFilas(matConjunta);
    end 
end

function [in,out] = estructuraAutoregresiva(lowData,mediumData,highData,nRegresores,shuffle)
    %Funcion que entregue la matriz de datos tal que se tenga la salida del
    %modelo y las entradas, con el número de autoregresores
    %correspondiente.
    
    %Datos Error de aceleracion
    lowErrorData = lowData(:,7);
    mediumErrorData = mediumData(:,7);
    highErrorData = highData(:,7);
    %Concatenacion de los datos.
    data = [lowErrorData;mediumErrorData;highErrorData];
    %Dimensiones
    [nDatos,~] = size(data);
    %Salidas
    out = data(nRegresores+1:nDatos, 1);
    [altoSalida,~] = size(out);
    %Construccion de la matriz.
    in = zeros(altoSalida,nRegresores);
    %Llenado
    count = 1;
    while count<=nRegresores
        in(:,count) = data(nRegresores-count+1:nDatos-count,1);
        count = count + 1;
    end
    %Posibilidad de reordenar las filas de la matriz de forma random.
    if shuffle == 1
        %Juntar salidas y entradas.
        matConjunta = [out,in];
        %Shuffle.
        [out,in] = shuffleFilas(matConjunta);
    end
end

function [in,inV,out,outV] = estructuraRegresoresVelocidad(datosErrorLow, datosErrorMid, datosErrorHi,datosVelLow,datosVelMid, datosVelHi,nRegresores,shuffle)
    %Funcion que entregue las matrices de entrada salida considerando
    %nRegresores tanto para velocidad como datos error. Mismo numero de
    %regresores.

    %Entradas y salidas para los datos de velocidad.
    [inV,outV] = estructuraVelocidad(datosVelLow,datosVelMid, datosVelHi,nRegresores,shuffle);
    
    %Generar entrada salida para el error.
    data = [datosErrorLow;datosErrorMid;datosErrorHi];
    dataV = [datosVelLow;datosVelMid;datosVelHi];
    disp(size(data))
    disp(size(dataV))
    %Numero de datos
    [nDatos,~] = size(data);
    %Salida del Modelo.
    out = data(nRegresores+1:nDatos,1);
    %Dimensiones de la salida.
    [altoSalida,~] = size(out);
    
    %Entrada del modelo.
    %Construccion de la matriz.
    in1 = zeros(altoSalida,nRegresores);
    in2 = zeros(altoSalida,nRegresores);
    %Llenado
    count = 1;
    while count<=nRegresores
        in1(:,count) = data(nRegresores-count+1:nDatos-count,1);
        in2(:,count) = dataV(nRegresores-count+1:nDatos-count,1);
        count = count + 1;
    end
    
    %Union de los regresores.
    in = [in1,in2];
    %Opcion de realiza shuffle.
    if shuffle == 1
        %Juntar salidas y entradas.
        matConjunta = [out,in];
        %Shuffle.
        [out,in] = shuffleFilas(matConjunta);
    end    
end

function [in,out] = estructuraVelocidad(datosVelLow,datosVelMid, datosVelHi,nRegresores,shuffle)
    %Genera la estructura de prediccion autoregresiva de la velocidad.
    
    %Datos de velocidad
    dataV = [datosVelLow;datosVelMid;datosVelHi];
    %Numero de datos.
    [nDatos,~] = size(dataV);
    %Generar Salida
    out = dataV(nRegresores+1:nDatos,1);
    %Dimensiones de la salida.
    [altoSalida,~] = size(out);
    %Generacion de estructura de entradas
    %Construccion de la matriz.
    in = zeros(altoSalida,nRegresores);
    %Llenado
    count = 1;
    while count<=nRegresores
        in(:,count) = dataV(nRegresores-count+1:nDatos-count,1);
        count = count + 1;
    end
        %Posibilidad de reordenar las filas de la matriz de forma random.
    if shuffle == 1
        %Juntar salidas y entradas.
        matConjunta = [out,in];
        %Shuffle.
        [out,in] = shuffleFilas(matConjunta);
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