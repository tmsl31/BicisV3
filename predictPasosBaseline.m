function [YPredict,Y] = predictPasosBaseline(M,nPasos,XTest,YTest,tipoModelo) 
    %Funcion que realiza el calculo de predicciones a varios pasos para dos
    %tipos de modelos distintos.
    disp(nPasos)
    if(tipoModelo == 0)
        %Caso de modelo auto regresivo.
        paramsError = M.paramsError;
        muYTrain = M.muError;
        stdYTrain = M.stdError;
        [YPredict,Y] = predictAuto(paramsError,nPasos,XTest,YTest,muYTrain,stdYTrain);
    elseif(tipoModelo == 1)
        %Caso de modelo auto regresivo con velocidad.
        paramsError = M.paramsError;
        paramsVel = M.paramsVel;
        muYTrain = M.muError;
        stdYTrain = M.stdError;
        [YPredict,Y] = predictVel(paramsError,paramsVel,nPasos,XTest,YTest,muYTrain,stdYTrain);
    else
        disp('Error predictPasosBaseline')
    end
    
end

%% FUNCIONES AUXILIARES.
function [YPredict,Y] = predictAuto(parametros,nPasos,XTest,YTest,muYTrain,stdYTrain)
    %Realiza el calculo de las predicciones a varios pasos Modelo
    %Autoregresivo.    
    
    %Casos
    if (nPasos==1)
       %Un paso
       YPredict =  XTest * parametros; 
       Y = YTest;
       %Denormalizacion
       Y = desnorm(Y,muYTrain,stdYTrain);
       YPredict = desnorm(YPredict,muYTrain,stdYTrain);  
    elseif(nPasos == 2)
        %Dos Pasos
        %Prediccion paso 1
        X1 = XTest * parametros;
        %Nuevo vector de entrada
        X = [X1(1:end-1),XTest(2:end,1:end-1)];
        %Nuevo vector Salidas.
        Y = YTest(2:end);
        %Predicciones
        YPredict = X * parametros;
        %Denormalizacion
        Y = desnorm(Y,muYTrain,stdYTrain);
        YPredict = desnorm(YPredict,muYTrain,stdYTrain);  
    elseif(nPasos == 3)
        %Prediccion tres pasos
        
        %Prediccion paso 1
        X1 = XTest * parametros;
        %Nuevo vector de entrada
        X = [X1(1:end-1),XTest(2:end,1:end-1)];
   
        %Prediccion a dos pasos.
        X2 = X * parametros;
        %Nuevo vector de entrada
        X = [X2(1:end-1),X(2:end,1:end-1)];
 
        %Prediccion a tres pasos.
        YPredict = X * parametros;
        %Nuevo vector Salidas.
        Y = YTest(nPasos:end);
        %Denormalizacion
        Y = desnorm(Y,muYTrain,stdYTrain);
        YPredict = desnorm(YPredict,muYTrain,stdYTrain); 
    elseif(nPasos==4)
        %Caso de 4 Pasos.
        
        %Prediccion paso 1
        X1 = XTest * parametros;
        %Nuevo vector de entrada
        X = [X1(1:end-1),XTest(2:end,1:end-1)];
   
        %Prediccion a dos pasos.
        X2 = X * parametros;
        %Nuevo vector de entrada
        X = [X2(1:end-1),X(2:end,1:end-1)];
 
        %Prediccion a tres pasos.
        X3 = X * parametros;
        %Nuevo vector de entrada
        X = [X3(1:end-1),X(2:end,1:end-1)];
        
        %Prediccion a 4 pasos.
        YPredict = X * parametros;
        %Nuevo vector Salidas.
        Y = YTest(nPasos:end);
        %Denormalizacion
        Y = desnorm(Y,muYTrain,stdYTrain);
        YPredict = desnorm(YPredict,muYTrain,stdYTrain);
        
    elseif(nPasos==5)
        %Caso de 5 Pasos
        
        %Prediccion paso 1
        X1 = XTest * parametros;
        %Nuevo vector de entrada
        X = [X1(1:end-1),XTest(2:end,1:end-1)];
   
        %Prediccion a 2 pasos.
        X2 = X * parametros;
        %Nuevo vector de entrada
        X = [X2(1:end-1),X(2:end,1:end-1)];
 
        %Prediccion a 3 pasos.
        X3 = X * parametros;
        %Nuevo vector de entrada
        X = [X3(1:end-1),X(2:end,1:end-1)];
        
        %Prediccion a 4 pasos.
        X4 = X * parametros;
        %Nuevo vector de entrada
        X = [X4(1:end-1),X(2:end,1:end-1)];
        
        %Prediccion a 5 pasos.
        YPredict = X * parametros;
        %Nuevo vector Salidas.
        Y = YTest(nPasos:end);
        %Denormalizacion
        Y = desnorm(Y,muYTrain,stdYTrain);
        YPredict = desnorm(YPredict,muYTrain,stdYTrain);        
    else
        disp('NO PROGRAMADO PARA MAS PASOS')
    end
end

function [YPredict,Y] = predictVel(parametrosError,parametrosVel,nPasos,XTest,YTest,muYTrain,stdYTrain)
    %Funcion que realiza la prediccion a varios pasos utilizando modelo
    %lineal con la velocidad.
    
    %Numero de regresores.
    [~,totalComponentes] = size(XTest);
    nRegresores = totalComponentes/2;
    
    %Casos
    if (nPasos==1)
       %Un paso
       YPredict =  XTest * parametrosError; 
       Y = YTest;
       %Denormalizacion
       Y = desnorm(Y,muYTrain,stdYTrain);
       YPredict = desnorm(YPredict,muYTrain,stdYTrain);  
       
    elseif(nPasos == 2)
        %Dos Pasos
        %Prediccion paso 1
        X1 = XTest * parametrosError;
        V1 = prediccionVel(parametrosVel,XTest);
        %Nuevo vector de entrada.
        %[predicE,E,predictV,V]
        X = [X1(1:end-1),XTest(2:end,1:nRegresores-1),...
            V1(1:end-1),XTest(2:end,nRegresores:totalComponentes-1)];
        %Nuevo vector Salidas.
        Y = YTest(2:end);
        %Predicciones
        YPredict = X * parametrosError;
        %Denormalizacion
        Y = desnorm(Y,muYTrain,stdYTrain);
        YPredict = desnorm(YPredict,muYTrain,stdYTrain);  
        
    elseif(nPasos == 3)
        %Tres Pasos
        %Prediccion paso 1
        X1 = XTest * parametrosError;
        V1 = prediccionVel(parametrosVel,XTest);
        %Nuevo vector de entrada.
        %[predicE,E,predictV,V]
        X = [X1(1:end-1),XTest(2:end,1:nRegresores-1),...
            V1(1:end-1),XTest(2:end,nRegresores:totalComponentes-1)];
        
        
        %Prediccion a 2 pasos.
        X2 = X * parametrosError;
        V2 = prediccionVel(modeloVel,X);
        %Nuevo vector de entrada.
        %[predicE,E,predictV,V]
        X = [X2(1:end-1),X(2:end,1:nRegresores-1),...
            V2(1:end-1),X(2:end,nRegresores:totalComponentes-1)];
        
        %Nuevo vector Salidas.
        Y = YTest(2:end);
        %Predicciones 3.
        YPredict = X * parametrosError;
        %Denormalizacion
        Y = desnorm(Y,muYTrain,stdYTrain);
        YPredict = desnorm(YPredict,muYTrain,stdYTrain); 

    elseif(nPasos == 4)
        %Tres Pasos
        %Prediccion paso 1
        X1 = XTest * parametrosError;
        V1 = prediccionVel(parametrosVel,XTest);
        %Nuevo vector de entrada.
        %[predicE,E,predictV,V]
        X = [X1(1:end-1),XTest(2:end,1:nRegresores-1),...
            V1(1:end-1),XTest(2:end,nRegresores:totalComponentes-1)];
        
        
        %Prediccion a 2 pasos.
        X2 = X * parametrosError;
        V2 = prediccionVel(modeloVel,X);
        %Nuevo vector de entrada.
        %[predicE,E,predictV,V]
        X = [X2(1:end-1),X(2:end,1:nRegresores-1),...
            V2(1:end-1),X(2:end,nRegresores:totalComponentes-1)];
        
        %Prediccion a 3 pasos.
        X3 = X * parametrosError;
        V3 = prediccionVel(modeloVel,X);
        %Nuevo vector de entrada.
        %[predicE,E,predictV,V]
        X = [X3(1:end-1),X(2:end,1:nRegresores-1),...
            V3(1:end-1),X(2:end,nRegresores:totalComponentes-1)];
        
        %Nuevo vector Salidas.
        Y = YTest(2:end);
        %Predicciones 4.
        YPredict = X * parametrosError;
        %Denormalizacion
        Y = desnorm(Y,muYTrain,stdYTrain);
        YPredict = desnorm(YPredict,muYTrain,stdYTrain);    
        
    elseif(nPasos == 5)
        %Cuatro Pasos
        %Prediccion paso 1
        X1 = XTest * parametrosError;
        V1 = prediccionVel(parametrosVel,XTest);
        %Nuevo vector de entrada.
        %[predicE,E,predictV,V]
        X = [X1(1:end-1),XTest(2:end,1:nRegresores-1),...
            V1(1:end-1),XTest(2:end,nRegresores:totalComponentes-1)];
        
        
        %Prediccion a 2 pasos.
        X2 = X * parametrosError;
        V2 = prediccionVel(modeloVel,X);
        %Nuevo vector de entrada.
        %[predicE,E,predictV,V]
        X = [X2(1:end-1),X(2:end,1:nRegresores-1),...
            V2(1:end-1),X(2:end,nRegresores:totalComponentes-1)];
        
        %Prediccion a 3 pasos.
        X3 = X * parametrosError;
        V3 = prediccionVel(modeloVel,X);
        %Nuevo vector de entrada.
        %[predicE,E,predictV,V]
        X = [X3(1:end-1),X(2:end,1:nRegresores-1),...
            V3(1:end-1),X(2:end,nRegresores:totalComponentes-1)];

        %Prediccion a 3 pasos.
        X4 = X * parametrosError;
        V4 = prediccionVel(modeloVel,X);
        %Nuevo vector de entrada.
        %[predicE,E,predictV,V]
        X = [X4(1:end-1),X(2:end,1:nRegresores-1),...
            V4(1:end-1),X(2:end,nRegresores:totalComponentes-1)];        
        
        %Nuevo vector Salidas.
        Y = YTest(2:end);
        %Predicciones 4.
        YPredict = X * parametrosError;
        %Denormalizacion
        Y = desnorm(Y,muYTrain,stdYTrain);
        YPredict = desnorm(YPredict,muYTrain,stdYTrain);     
    else
        disp('Error evaluacion velocidad')
    end
end

function [VPredict] = prediccionVel(modeloVel,XTest)
    %Funcion que calcula la prediccionde velocidad.
    %XTest -> Estructura de regresores completa, no solo velocidad.
    %modeloVel -> Estructura completa de la velocidad.
    
    params = modeloVel;
    %Dimensiones de XTest.
    [~,totalRegresores] = size(XTest);
    %Numero de regresores
    nRegresores = totalRegresores/2;
    %Matriz de velocidades.
    matVelocidad = XTest(:,nRegresores+1:totalRegresores);
    %Predicciones.
    VPredict = matVelocidad * params;
    %Se mantiene normalizado puesto que de esta forma se utiliza en la
    %formulacion de Takagi Sugeno.
end