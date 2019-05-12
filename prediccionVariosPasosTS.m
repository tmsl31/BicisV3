function [YPredict,Y] = prediccionVariosPasosTS(nPasos,XTest,YTest,modelos,tipoModelo)
    %Funcion que realiza la prediccion a varios pasos utilizando el modelo
    %de Takagi Sugeno ingresado.
    
    %Casos
    if (tipoModelo == 0)
        %Caso de modelo autoregresivo.
        model = modelos(1);
        [YPredict,Y] = variosPasosAutoregresivo(nPasos,XTest,YTest,model);
    elseif(tipoModelo == 1)
        modeloError = modelos(1);
        modeloVel  = modelos(2);
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
end

function [YPredict,Y] = variosPasosVelocidad(nPasos,XTest,YTest,modeloError,modeloVel)
    %Prediccion a varios pasos para el caso de un modelo con entradas de
    %autoregresores y velocidad instantanea.
end