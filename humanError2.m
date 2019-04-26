%Generacion de modelo para error humano.
%Modelos de Takagi Sugeno.
%Tomas Lara A.
%<<Se omiten tildes>>

%Modelo 2: Autoregresores y velocidad.
clear
%% Estructuracion de los datos.
%Importar datos.
lowData = csvread('C:\Users\tlara\OneDrive\Documentos\GitHub\BicisV3\datosError\lowSpeed.csv');
mediumData = csvread('C:\Users\tlara\OneDrive\Documentos\GitHub\BicisV3\datosError\mediumSpeed.csv');
highData = csvread('C:\Users\tlara\OneDrive\Documentos\GitHub\BicisV3\datosError\highSpeed.csv');

%DATOS: Velocidades baja, media y alta.
lowSpeed = 2.77;
mediumSpeed = 4.16;
highSpeed = 5.00;

%Agregar Velocidad a los datos.
data = agregarVelocidad(lowData,mediumData,highData,lowSpeed,mediumSpeed,highSpeed);

%Formar estructura de entrada y salida.
%Valores de input
nRegresores = input('Numero de regresores:');

%Generar estructura
[out,in] = estructuraRegresoresVelocidad(lowData,mediumData,highData,lowSpeed,mediumSpeed,highSpeed,nRegresores,1);

%Dividir en conjuntos
%Valores de input.
norm = input('Normalizacion? (0 -> NO; 1 -> SI)');

%% Division en conjuntos
%Parametros
norm = input('Normalizacion? (0 -> NO; 1 -> SI):');

disp('<<Division en Train,Val,Test>>')
%Porcentajes
porcentajeTrain = 60;
porcentajeVal = 20;
disp(strcat('Porcentaje Train:'," ",string(porcentajeTrain),'%;Porcentaje Val:'," ",string(porcentajeVal),'%'))
%Division de conjuntos
[XTrain,XVal,XTest,YTrain,YVal,YTest,muXTrain,stdXTrain,muYTrain,stdYTrain] = divConjuntos(in,out,porcentajeTrain,porcentajeVal,norm);

%% Busqueda de numero de reglas.
disp('<<Numero de Reglas>>')
%Fuzzy C-Means.
%Input
maximoReglas = input('Numero Maximo de reglas:');
%Grafica de la evolucion del error.
[eTrainCluster1,eValCluster1] = clusters_optimo(YVal,YTrain,XVal,XTrain,nMax);
