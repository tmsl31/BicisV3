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
    disp('None, Orden, Acceleration, CACC, LeaderSpeed, Instant Speed, HumanError.')
end