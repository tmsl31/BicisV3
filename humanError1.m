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
[out,in] = estructuraAutoregresiva(data,nRegresores,1);
[outOrdenada,inOrdenada] = estructuraAutoregresiva(data,nRegresores,0);
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
[XTrainOrdenado,XValOrdenado,XTestOrdenado,YTrainOrdenado,YValOrdenado,YTestOrdenado,~,~,~,~] = divConjuntos(in,out,porcentajeTrain,porcentajeVal,norm);
%% Busqueda de numero de reglas.
disp('<<Numero de Reglas>>')
%Fuzzy C-Means.
%Input
maximoReglas = input('Numero Maximo de reglas:');
%Grafica de la evolucion del error.
[eTrainCluster1,eValCluster1] = clusters_optimo(YVal,YTrain,XVal,XTrain,maximoReglas);
%Numero de reglas determinado mediante la visualización del error de
%validacion
optimoReglas = input('Numero de reglas optimo:');

%% Analisis de sensibilidad.
disp('<<Analisis de Sensibilidad>>')
%Calculo del error
[vecErrorVal,matricesTrain,matricesVal,indicesEliminacion,matIndices] = variablesRelevantes(XTrain,YTrain,XVal,YVal,optimoReglas);
disp(strcat('orden de eliminacion:'))
disp(indicesEliminacion)
%% Construccion del modelo.
disp('<<Construccion del modelo de T&S>>')
%Vector de indices a mantener en entrada.
indicesMantener = input('Vector de indices a mantener en entrada:');
%Eliminacion de regresores.
[XTrain2,XVal2,XTest2] = seleccionCaracteristicas(XTrain,XVal,XTest,indicesMantener);
%Nueva prueba de numero de clusters con el numero de regresores utilizados.
[eTrainCluster2,eValCluster2] = clusters_optimo(YVal,YTrain,XVal2,XTrain2,maximoReglas);
%Numero de reglas a utilizar
optimoReglas2 = input('Numero de reglas a utilizar: ');
%Entrenamiento del modelo de Takagi-Sugeno con el numero de reglas
%determinado.
[model,result] = TakagiSugeno(YTrain,XTrain2,optimoReglas2,[1 2 2]);

%% Predicciones.
%Prediccion a un paso.
[YEstimadoTest,YRealTest] = estimacionUnPaso(model,XTest2,YTest,YTest,muXTrain,stdXTrain,muYTrain,stdYTrain);
%Des normalizacion
YEstimado = desnorm(YEstimadoTest,muYTrain,stdYTrain);
YRealTest = desnorm(YRealTest,muYTrain,stdYTrain);
%Calculo de RMSE
RMSESalida = RMSE(YEstimado,YRealTest);
