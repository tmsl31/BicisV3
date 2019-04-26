%Generacion de modelo para error humano.
%Modelos de Takagi Sugeno.
%Tomas Lara A.
%<<Se omiten tildes>>

%Modelo 1: Completamente autoregresivo.
clear
%% Estructuracion de los datos.
%Importar datos.
lowData = csvread('C:\Users\tlara\OneDrive\Documentos\GitHub\BicisV3\datosError\lowSpeed.csv');
mediumData = csvread('C:\Users\tlara\OneDrive\Documentos\GitHub\BicisV3\datosError\mediumSpeed.csv');
highData = csvread('C:\Users\tlara\OneDrive\Documentos\GitHub\BicisV3\datosError\highSpeed.csv');

%Concatenar datos.
data = [lowData;mediumData;highData];

%Formar estructura de entrada y salida.
%Valores de input
nRegresores = input('Numero de regresores:');

%Generar estructura
disp('<<Generacion de estructura>>')
[out,in] = estructuraAutoregresiva(data,nRegresores,0);
disp('Estructura Autoregresiva')
disp(strcat('Se utilizan inicialmente '," ",string(nRegresores)," " ,'Regresores inicialmente'))

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
[eTrainCluster1,eValCluster1] = clusters_optimo(YVal,YTrain,XVal,XTrain,maximoReglas);