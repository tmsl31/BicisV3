function [intervalo, alphaOptimo] = sintonizacionIntervalos(model, prob,vectorAlpha, XTest, YTest,XTrain,YTrain)
    %Funcion que realice variaciones del valor de alpha hasta encontrar una
    %cierta probabilidad de encerrar los valores reales de salida del
    %conjunto Test
    
    %Parametros:
    %*Model -> Modelo de Takagi & Sugeno utilizado.
    %*prob -> Probabilidad deseada de valores de YTest que se abarcan en el
    %intervalo.
    %*vectorAlpha -> Vector de valores de alpha a experimentar.
    
    %Valores default
    intervalo = [];
    alphaOptimo = 0;

    
    %Tolerancia de la probabilidad.
    tol = 0.01;
    %Pruebas
    for valorAlpha = vectorAlpha
        %Calculo del intervalo de confianza.
        [~,inter] = defIntervalo(model,valorAlpha,XTest,XTrain,YTrain);
        %Calculo de la probabilidad de cobertura
        P = probabilidadInclusion(inter,YTest);
        if(P >= prob + tol)
            %Caso en que se alcanza o supera la probabilidad
            intervalo = inter;
            alphaOptimo = valorAlpha;
            break;
        end
    end
    if(alphaOptimo == 0)
        disp('No se encontro alfa optimo.')
    end
end


function [prob] = probabilidadInclusion(inter,YTest)
    %Funcion que calcule la cobertura de valores de Y que cubre un cierto
    %intervalo, determinado para un valor de alpha.
    
    %Limites del intervalo.
    up = inter.superior;
    down = inter.inferior;
    
    %Numero de elementos de test.
    [elementosTest,~] = size(YTest);
    
    %Calculo de la probabilidad.
    count = 0;
    count2 = 1;
    while count2 <= elementosTest
        %Calculo de condicion
        prueba = ((YTest(count2,1) >= down(count2)) & (YTest(count2,1) <= up(count2)));
        if(prueba==1)
            count = count + 1;
        end
        count2 = count2 + 1;
    end
    prob = count/elementosTest;
    
end