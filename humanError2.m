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
%Numero de reglas determinado mediante la visualización del error de
%validacion
optimoReglas = input('Numero de reglas optimo:');

%% Analisis de sensibilidad.
disp('<<Analisis de Sensibilidad>>')
%Calculo del error
[vecErrorVal,matricesTrain,matricesVal,indicesEliminacion,matIndices] = variablesRelevantes(XTrain,YTrain,XVal,YVal,nOptimo);
%Grafica del error de validacion
figure(3)
hold on 
plot(vecErrorVal)
title('Error de validacion para numero de entradas eliminadas')
ylabel('RMSE')
xlabel('Numero de variables eliminadas')
hold off
disp(strcat('orden de eliminacion:'))
disp(indicesEliminacion)

%% Construccion del modelo.
disp('<<Construccion del modelo de T&S>>')
%Vector de indices a mantener en entrada.
indicesMantener = input('Vector de indices a mantener en entrada:');
%Nueva prueba de numero de clusters con el numero de regresores utilizados.
[eTrainCluster2,eValCluster2] = clusters_optimo(YVal,YTrain,XVal,XTrain,maximoReglas);
%Numero de reglas a utilizar
optimoReglas2 = input('Numero de reglas a utilizar');
%Entrenamiento del modelo de Takagi-Sugeno con el numero de reglas
%determinado.

