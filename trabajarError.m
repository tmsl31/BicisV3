function [] = trabajarError()
    %Funcion con varias opciones para trabajar distintos aspectos del
    %error.
    
    %% DISPLAY DE FUNCION
    disp('Modo 1: Graficar los datos.')
    disp('Modo 2: Cortar Colas de los datos.')
    disp('Modo 3: histogramograma de valores.') 
    disp('Modo 4: Gráfica de los datos con datos unicos') 
    
   %% DATOS
    %Importar los datos.
    lowData = csvread('C:\Users\tlara\OneDrive\Documentos\GitHub\BicisV3\datosError\lowSpeed.csv');
    mediumData = csvread('C:\Users\tlara\OneDrive\Documentos\GitHub\BicisV3\datosError\mediumSpeed.csv');
    highData = csvread('C:\Users\tlara\OneDrive\Documentos\GitHub\BicisV3\datosError\highSpeed.csv');
    
    %DATOS: Velocidades baja, media y alta. Datos de velocidad asociados a
    %cada dataset.
    lowSpeed = 2.77;
    mediumSpeed = 4.16;
    highSpeed = 5.00;
    
   
   %% MODOS
    
    
    modo = input('Modo: ');
    if (modo == 1)
        %Modo 1: Graficar los datos.
        graficarError(lowData,mediumData,highData,lowSpeed,mediumSpeed,highSpeed);
    elseif (modo == 2)
        %Modo 2: Cortar Colas de los datos.
        umbral = 0.2;
        cortarColas(lowData,mediumData,highData,lowSpeed,mediumSpeed,highSpeed,umbral);
    elseif(modo == 3)
        %Modo 3: Replicar histogramogramas.
        replicarhistogramogramas(lowData,mediumData,highData,lowSpeed,mediumSpeed,highSpeed)
    elseif(modo==4)
        %Modo 4: Gráfica de los datos con datos unicos
        graficarSinRepetidos(lowData,mediumData,highData,lowSpeed,mediumSpeed,highSpeed)
        
    end

end

function [] = graficarError(lowData,mediumData,highData,lowSpeed,mediumSpeed,highSpeed)
    
    %Numeros de datos.
    nDatosLow = length(lowData);
    nDatosMedium = length(mediumData);
    nDatosHigh = length(highData);
    %Vectores para graficar.
    vecLow = 1:1:nDatosLow;
    vecMedium = (nDatosLow+1) + (1:1:nDatosMedium);
    vecHigh = (nDatosLow+nDatosMedium+1) + (1:1:nDatosHigh);
    %Grafico
    figure()
    hold on
    plot(vecLow,lowData,'+')
    plot(vecMedium,mediumData,'*')
    plot(vecHigh,highData,'o')
    legend('Low Speed','Medium Speed','High Speed')
    title('Error de Aceleración Para las Tres Velocidades de Lider')
    xlabel('Número ficticio de muestras')
    ylabel('Error de aceleración [m/s^2]')
    hold off
end

function [] = cortarColas(lowData,mediumData,highData,lowSpeed,mediumSpeed,highSpeed,umbral)
    %Funcion que corta las colas del error dado un umbral y realiza el
    %grafico.
    
    %Umbrales
    indicesMenoresLow = find(lowData<(-1*umbral));
    indicesMenoresMedium = find(mediumData<(-1*umbral));
    indicesMenoresHigh = find(highData<(-1*umbral));
    indicesMayoresLow = find(lowData>(umbral));
    indicesMayoresMedium = find(mediumData>(umbral));
    indicesMayoresHigh = find(highData>(umbral));
    %Cotas
    cotaInfLow = indicesMenoresLow(end);
    cotaInfMedium = indicesMenoresMedium(end);
    cotaInfHigh = indicesMenoresHigh(end);
    cotaMaxLow = indicesMayoresLow(1);
    cotaMaxMedium = indicesMayoresMedium(1);
    cotaMaxHigh = indicesMayoresHigh(1);
    %Cortar.
    lowData = lowData(cotaInfLow:cotaMaxLow);
    mediumData = mediumData(cotaInfMedium:cotaMaxMedium);
    highData = highData(cotaInfHigh:cotaMaxHigh);    
    %Grafico.
    graficarError(lowData,mediumData,highData,lowSpeed,mediumSpeed,highSpeed)
end

function [] = replicarhistogramogramas(lowData,mediumData,highData,lowSpeed,mediumSpeed,highSpeed)
    %Funcion que replique los histogramogramas de probabilidad de error con el
    %fin de replicar las distribuciones del paper original.
    
    %Calculo de estadisticas.
    %Mu
    muLow = mean(lowData);
    muMedium = mean(mediumData);
    muHigh = mean(highData);
    %std
    stdLow = std(lowData);
    stdMedium = std(mediumData);
    stdHigh = std(highData);
    %Display.
    disp(strcat('Media Low Speed: ',string(muLow)))
    disp(strcat('Media Medium Speed: ',string(muMedium)))
    disp(strcat('Media High Speed: ',string(muHigh)))
    %
    disp(strcat('Std Low Speed: ',string(stdLow)))
    disp(strcat('Std Medium Speed: ',string(stdMedium)))
    disp(strcat('Std High Speed: ',string(stdHigh)))   
    
    %Muestra de graficas.
    figure()
    subplot(2,2,1)
    hLow = histogram(lowData,40);
    title('Error Distribution:Low Speed')
    ylabel('Times of ocurrence')
    xlabel('Error [m/s^2]')
    hLow.FaceColor = 'r';
    subplot(2,2,2)
    hMedium = histogram(mediumData,40);
    title('Error Distribution:Medium Speed')
    ylabel('Times of ocurrence')
    xlabel('Error [m/s^2]')
    hMedium.FaceColor = 'b';
    subplot(2,2,3)
    hHigh = histogram(highData,40);
    title('Error Distribution:High Speed')
    ylabel('Times of ocurrence')
    xlabel('Error [m/s^2]')
    hHigh.FaceColor = [0.4660 0.6740 0.1880];
end

function [] = graficarSinRepetidos(lowData,mediumData,highData,lowSpeed,mediumSpeed,highSpeed)
    %Funcion que realiza los graicos sin considerar los valores repetidos
    %de low data y mediumData.
    
    %Eliminar repetidos.    
    low = unique(lowData);
    medium = unique(mediumData);
    high = unique(highData);
    
    %Grafico
    graficarError(low,medium,high,lowSpeed,mediumSpeed,highSpeed)
    
end