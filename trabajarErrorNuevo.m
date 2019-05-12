function [] = trabajarErrorNuevo()
    %Funcion que trabaje los valores de error para los nuevos datos.
    
    %% DISPLAY DE FUNCION
    disp('Modo 1: Graficar los datos.')
    disp('Modo 2: histogramograma de valores.') 
    
   %% DATOS
    %Importar los datos.
    data = importarDatosNuevos();    
    %DATOS: Velocidades baja, media y alta. Datos de velocidad asociados a
    %cada dataset.
    lowSpeed = 2.77;
    mediumSpeed = 4.16;
    highSpeed = 5.00;
    
    %% MODOS
    modo = input('MODO: ');
    if (modo == 1)
        %Modo 1: Graficar los datos.
        graficarError(data,lowSpeed,mediumSpeed,highSpeed);
    elseif(modo == 2)
        %Modo 3: Replicar histogramogramas.
        replicarhistogramogramas(data,lowSpeed,mediumSpeed,highSpeed);
    end

end

%% FUNCIONES AUXILIARES.
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

function [] = graficarError(data,lowSpeed,mediumSpeed,highSpeed)
    %Funcion que realice grafico de los datos de error y velocidades.
    
    %Obtencion de datos ordenados.
    [datosErrorLow,datosErrorMid,datosErrorHi,datosVelLow,datosVelMid,datosVelHi,~,~,~]=separarDatos(data,lowSpeed,mediumSpeed,highSpeed);
    %Grafico del error y velocidad.
    %Numeros de datos.
    nDatosLow = length(datosErrorLow);
    nDatosMedium = length(datosErrorMid);
    nDatosHigh = length(datosErrorHi);
    %Vectores para graficar.
    vecLow = 1:1:nDatosLow;
    vecMedium = 1:1:nDatosMedium;
    vecHigh = 1:1:nDatosHigh;
    %Grafico
    figure()
    %Baja Velocidad
    yyaxis left
    plot(vecLow,datosErrorLow);
    yyaxis right
    plot(vecLow,datosVelLow);
    yyaxis left
    title(strcat('Velocidad relativa y error humano. Velocidad Líder: ',string(lowSpeed)))
    xlabel('Número de muestra')
    ylabel('Error de Actuacion [m^/s^2]')
    yyaxis right
    ylabel('velocidad relativa [m/s]')
    ylim([0 4])
    %Velocidad Media
    figure()
    yyaxis left
    plot(vecMedium,datosErrorMid)
    yyaxis right
    plot(vecMedium,datosVelMid)
    yyaxis left
    title(strcat('Velocidad relativa y error humano. Velocidad Líder: ',string(highSpeed)))
    xlabel('Número de muestra')
    ylabel('Error de Actuacion [m^/s^2')  
    yyaxis right
    ylabel('velocidad relativa [m/s]')    
    
    %Alta Velocidad.
    figure()
    yyaxis left
    plot(vecHigh,datosErrorHi)
    yyaxis right
    plot(vecHigh,datosVelHi)
    yyaxis left
    title(strcat('Velocidad relativa y error humano. Velocidad Líder: ',string(highSpeed))) 
    xlabel('Número de muestra') 
    ylabel('Error de Actuacion [m^/s^2]')  
    yyaxis right 
    ylabel('velocidad relativa [m/s]')    


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

function [] = replicarhistogramogramas(data,lowSpeed,mediumSpeed,highSpeed)
    %Funcion que replique los histogramogramas de probabilidad de error con el
    %fin de replicar las distribuciones del paper original.
    
    %
    [datosErrorLow, datosErrorMid, datosErrorHi,datosVelLow,datosVelMid, datosVelHi, ~,~,~]=separarDatos(data,lowSpeed,mediumSpeed,highSpeed);
    
    %Calculo de estadisticas Error.
    %Mu
    muLow = mean(datosErrorLow);
    muMedium = mean(datosErrorMid);
    muHigh = mean(datosErrorHi);
    %std
    stdLow = std(datosErrorLow);
    stdMedium = std(datosErrorMid);
    stdHigh = std(datosErrorHi);
    %Display.
    disp(strcat('Media Error Low Leader Speed: ',string(muLow)))
    disp(strcat('Media Error Medium Leader Speed: ',string(muMedium)))
    disp(strcat('Media Error High Leader Speed: ',string(muHigh)))
    %
    disp(strcat('Std Error Low Leader Speed: ',string(stdLow)))
    disp(strcat('Std Error Medium Leader Speed: ',string(stdMedium)))
    disp(strcat('Std Error High Leader Speed: ',string(stdHigh)))   
    
        %Calculo de estadisticas Velocidad.
    %Mu
    muLowVel = mean(datosVelLow);
    muMediumVel = mean(datosVelMid);
    muHighVel = mean(datosVelHi);
    %std
    stdLowVel = std(datosVelLow);
    stdMediumVel = std(datosVelMid);
    stdHighVel = std(datosVelHi);
    %Display.
    disp(strcat('Instant Speed Media Low Leader Speed: ',string(muLowVel)))
    disp(strcat('Instant Speed Media Medium Leader Speed: ',string(muMediumVel)))
    disp(strcat('Instant Speed Media High Leader Speed: ',string(muHighVel)))
    %
    disp(strcat('Instant Speed std High Leader Speed: ',string(stdLowVel)))
    disp(strcat('Instant Speed std High Leader Speed: ',string(stdMediumVel)))
    disp(strcat('Instant Speed std High Leader Speed: ',string(stdHighVel)))   
    
    %Muestra de graficas.
    
    %Error de aceleracion.
    figure()
    subplot(2,2,1)
    hLow = histogram(datosErrorLow,30);
    title(strcat('Error Distribution: v_l = ',string(lowSpeed),'m/s'))
    ylabel('Times of ocurrence')
    xlabel('Error [m/s^2]')
    hLow.FaceColor = 'r';
    subplot(2,2,2)
    hMedium = histogram(datosErrorMid,30);
    title(strcat('Error Distribution: v_l = ',string(mediumSpeed),'m/s'))
    ylabel('Times of ocurrence')
    xlabel('Error [m/s^2]')
    hMedium.FaceColor = 'b';
    subplot(2,2,3)
    hHigh = histogram(datosErrorHi,30);
    title(strcat('Error Distribution: v_l = ',string(highSpeed),'m/s'))
    ylabel('Times of ocurrence')
    xlabel('Error [m/s^2]')
    hHigh.FaceColor = [0.4660 0.6740 0.1880];
end