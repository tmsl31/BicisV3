function [YPredict,Y] = prediccionVariosPasosTS(nPasos,XTest,YTest,modeloError,M)
    %Funcion que realiza la prediccion a varios pasos utilizando el modelo
    %de Takagi Sugeno ingresado.
    
    %Extraccion de variables.
    modeloError = M.paramsError;
    modeloVel = M.paramsVel;
    
    
    
    %Casos
    if (tipoModelo == 0)
        %Caso de modelo autoregresivo.
        [YPredict,Y] = variosPasosAutoregresivo(nPasos,XTest,YTest,modeloError);
    elseif(tipoModelo == 1)
        [YPredict,Y] = variosPasosVelocidad(nPasos,XTest,YTest,modeloError,modeloVel);
    end
end



%% FUNCIONES DE PASOS PARA DISTINTOS MODELOS.
%Modelo Autregresivo.
function [YPredict,Y] = variosPasosAutoregresivo(nPasos,XTest,YTest,model)
    %Casos utilizando el modelo de T&S.
    muYTrain = model.mu;
    stdYTrain = model.std;
    if (nPasos == 1)
        %Un Paso
        %Predicciones.
        YPredict = evaluacionTS(XTest,model);
        Y = YTest;
        %Desnormalizacion
        Y = desnorm(Y,muYTrain,stdYTrain);
        YPredict = desnorm(YPredict,muYTrain,stdYTrain);
        
    elseif (nPasos==2)
        %Dos Pasos.
        
        %Prediccion paso 1.
        X1 = evaluacionTS(XTest,model);
        %Nuevo vector de entrada
        X = [X1(1:end-1),XTest(2:end,1:end-1)];
        %Nuevo vector de salidas.
        Y = YTest(2:end);
        %Predicciones.
        YPredict = evaluacionTS(X,model);
        %Desnormalizacion
        Y = desnorm(Y,muYTrain,stdYTrain);
        YPredict = desnorm(YPredict,muYTrain,stdYTrain);
    
    elseif (nPasos==3)
        %Prediccion tres pasos
        
        %Prediccion paso 1
        X1 = evaluacionTS(XTest,model);
        %Nuevo vector de entrada
        X = [X1(1:end-1),XTest(2:end,1:end-1)];
   
        %Prediccion a dos pasos.
        X2 = evaluacionTS(X,model);
        %Nuevo vector de entrada
        X = [X2(1:end-1),X(2:end,1:end-1)];
 
        %Prediccion a tres pasos.
        YPredict = evaluacionTS(X,model);
        %Nuevo vector Salidas.
        Y = YTest(nPasos:end);
        
        %Desnormalizacion
        Y = desnorm(Y,muYTrain,stdYTrain);
        YPredict = desnorm(YPredict,muYTrain,stdYTrain);        

    elseif (nPasos==4)
        %Caso de 4 Pasos.
        
        %Prediccion paso 1
        X1 = evaluacionTS(XTest,model);
        %Nuevo vector de entrada
        X = [X1(1:end-1),XTest(2:end,1:end-1)];
   
        %Prediccion a dos pasos.
        X2 = evaluacionTS(X,model);
        %Nuevo vector de entrada
        X = [X2(1:end-1),X(2:end,1:end-1)];
 
        %Prediccion a tres pasos.
        X3 = evaluacionTS(X,model);
        %Nuevo vector de entrada
        X = [X3(1:end-1),X(2:end,1:end-1)];
        
        %Prediccion a 4 pasos.
        YPredict = evaluacionTS(X,model);
        %Nuevo vector Salidas.
        Y = YTest(nPasos:end);
        
        %Desnormalizacion
        Y = desnorm(Y,muYTrain,stdYTrain);
        YPredict = desnorm(YPredict,muYTrain,stdYTrain);        
    elseif (nPasos==5)
        %Caso de 5 Pasos
        
        %Prediccion paso 1
        X1 = evaluacionTS(XTest,model);
        %Nuevo vector de entrada
        X = [X1(1:end-1),XTest(2:end,1:end-1)];
   
        %Prediccion a 2 pasos.
        X2 = evaluacionTS(X,model);
        %Nuevo vector de entrada
        X = [X2(1:end-1),X(2:end,1:end-1)];
 
        %Prediccion a 3 pasos.
        X3 = evaluacionTS(X,model);
        %Nuevo vector de entrada
        X = [X3(1:end-1),X(2:end,1:end-1)];
        
        %Prediccion a 4 pasos.
        X4 = evaluacionTS(X,model);
        %Nuevo vector de entrada
        X = [X4(1:end-1),X(2:end,1:end-1)];
        
        %Prediccion a 5 pasos.
        YPredict = evaluacionTS(X,model);
        %Nuevo vector Salidas.
        Y = YTest(nPasos:end);
        %Denormalizacion
        Y = desnorm(Y,muYTrain,stdYTrain);
        YPredict = desnorm(YPredict,muYTrain,stdYTrain);   
    else
        disp('NO PROGRAMADO PARA MAS PASOS')
    end
    
    %Plot
    figure()
    hold on
    plot(Y)
    plot(YPredict)
    title('Comparación predicción y modelo real. Takagi&Sugeno autoregresivo')
    xlabel('Numero de muestra')
    ylabel('Error de Aceleración [m/s^2]')
    legend('Real','Predicción')
    hold off
end

function [YPredict,Y] = variosPasosVelocidad(nPasos,XTest,YTest,modeloError,modeloVel)
    %Prediccion a varios pasos para el caso de un modelo con entradas de
    %autoregresores y velocidad instantanea.
    
    %Numero de regresores.
    [~,totalComponentes] = size(XTest);
    nRegresores = totalComponentes/2;
    %Estadísticos para desnormalizacion.
    muYTrain = modeloError.mu;
    stdYTrain = modeloError.std;
    %Casos utilizando el modelo de T&S.
    if (nPasos == 1)
        %Un Paso
        %Predicciones.
        YPredict = evaluacionTS(XTest,modeloError);
        Y = YTest;
        %Desnormalizacion
        Y = desnorm(Y,muYTrain,stdYTrain);
        YPredict = desnorm(YPredict,muYTrain,stdYTrain);
    elseif(nPasos == 2)
        %Prediccion a 2 pasos.
        %Predicciones a un paso.
        X1 = evaluacionTS(XTest,modeloError);
        V1 = prediccionVel(modeloVel,XTest);
        %Nuevo vector de entrada.
        %[predicE,E,predictV,V]
        X = [X1(1:end-1),XTest(2:end,1:nRegresores-1),...
            V1(1:end-1),XTest(2:end,nRegresores:totalComponentes-1)];
        %Nuevo vector de salidas.
        Y = YTest(2:end);
        %Predicciones.
        YPredict = evaluacionTS(X,modeloError);
        %Desnormalizacion
        Y = desnorm(Y,muYTrain,stdYTrain);
        YPredict = desnorm(YPredict,muYTrain,stdYTrain);
    elseif(nPasos == 3)
        %Prediccion tres pasos
        
        %Predicciones a un paso.
        X1 = evaluacionTS(XTest,modeloError);
        V1 = prediccionVel(modeloVel,XTest);
        %Nuevo vector de entrada.
        %[predicE,E,predictV,V]
        X = [X1(1:end-1),XTest(2:end,1:nRegresores-1),...
            V1(1:end-1),XTest(2:end,nRegresores:totalComponentes-1)];
        
        %Prediccion a 2 pasos.
        X2 = evaluacionTS(X,modeloError);
        V2 = prediccionVel(modeloVel,X);
        %Nuevo vector de entrada.
        %[predicE,E,predictV,V]
        X = [X2(1:end-1),X(2:end,1:nRegresores-1),...
            V2(1:end-1),X(2:end,nRegresores:totalComponentes-1)];
        
        %Prediccion a tres pasos.
        YPredict = evaluacionTS(X,modeloError);
        %Nuevo vector Salidas.
        Y = YTest(nPasos:end);
        
        %Desnormalizacion
        Y = desnorm(Y,muYTrain,stdYTrain);
        YPredict = desnorm(YPredict,muYTrain,stdYTrain);        

    elseif(nPasos == 4)       
        %Prediccion a cuatro pasos.

        %Predicciones a un paso.
        X1 = evaluacionTS(XTest,modeloError);
        V1 = prediccionVel(modeloVel,XTest);
        %Nuevo vector de entrada.
        %[predicE,E,predictV,V]
        X = [X1(1:end-1),XTest(2:end,1:nRegresores-1),...
            V1(1:end-1),XTest(2:end,nRegresores:totalComponentes-1)];
        
        %Prediccion a 2 pasos.
        X2 = evaluacionTS(X,modeloError);
        V2 = prediccionVel(modeloVel,X);
        %Nuevo vector de entrada.
        %[predicE,E,predictV,V]
        X = [X2(1:end-1),X(2:end,1:nRegresores-1),...
            V2(1:end-1),X(2:end,nRegresores:totalComponentes-1)];
        
        %Prediccion a 3 pasos.
        X3 = evaluacionTS(X,modeloError);
        V3 = prediccionVel(modeloVel,X);
        %Nuevo vector de entrada.
        %[predicE,E,predictV,V]
        X = [X3(1:end-1),X(2:end,1:nRegresores-1),...
            V3(1:end-1),X(2:end,nRegresores:totalComponentes-1)];
        %Prediccion a 4 pasos.
        YPredict = evaluacionTS(X,modeloError);
        %Nuevo vector Salidas.
        Y = YTest(nPasos:end);
        
        %Desnormalizacion
        Y = desnorm(Y,muYTrain,stdYTrain);
        YPredict = desnorm(YPredict,muYTrain,stdYTrain);        

    elseif(nPasos == 5)       
        %Prediccion a cinco pasos.

        %Predicciones a un paso.
        X1 = evaluacionTS(XTest,modeloError);
        V1 = prediccionVel(modeloVel,XTest);
        %Nuevo vector de entrada.
        %[predicE,E,predictV,V]
        X = [X1(1:end-1),XTest(2:end,1:nRegresores-1),...
            V1(1:end-1),XTest(2:end,nRegresores:totalComponentes-1)];
        
        %Prediccion a 2 pasos.
        X2 = evaluacionTS(X,modeloError);
        V2 = prediccionVel(modeloVel,X);
        %Nuevo vector de entrada.
        %[predicE,E,predictV,V]
        X = [X2(1:end-1),X(2:end,1:nRegresores-1),...
            V2(1:end-1),X(2:end,nRegresores:totalComponentes-1)];
        
        %Prediccion a 3 pasos.
        X3 = evaluacionTS(X,modeloError);
        V3 = prediccionVel(modeloVel,X);
        %Nuevo vector de entrada.
        %[predicE,E,predictV,V]
        X = [X3(1:end-1),X(2:end,1:nRegresores-1),...
            V3(1:end-1),X(2:end,nRegresores:totalComponentes-1)];

        %Prediccion a 4 pasos.
        X4 = evaluacionTS(X,modeloError);
        V4 = prediccionVel(modeloVel,X);
        %Nuevo vector de entrada.
        %[predicE,E,predictV,V]
        X = [X4(1:end-1),X(2:end,1:nRegresores-1),...
            V4(1:end-1),X(2:end,nRegresores:totalComponentes-1)];
        
        %Prediccion a 5 pasos.
        YPredict = evaluacionTS(X,modeloError);
        %Nuevo vector Salidas.
        Y = YTest(nPasos:end);
        
        %Desnormalizacion
        Y = desnorm(Y,muYTrain,stdYTrain);
        YPredict = desnorm(YPredict,muYTrain,stdYTrain);     
    else
        disp('Numero de pasos no implementado')
    end
    
    %Plot
    figure()
    hold on
    plot(Y)
    plot(YPredict)
    title('Comparación predicción y modelo real. Takagi&Sugeno autoregresores y velocidad')
    xlabel('Numero de muestra')
    ylabel('Error de Aceleración [m/s^2]')
    legend('Real','Predicción')
    hold off
end

function [VPredict] = prediccionVel(modeloVel,XTest)
    %Funcion que calcula la prediccionde velocidad.
    %XTest -> Estructura de regresores completa, no solo velocidad.
    %modeloVel -> Estructura completa de la velocidad.
    
    params = modeloVel.params;
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