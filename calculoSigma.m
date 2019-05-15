function [sigmar] = calculoSigma(model,XTest,YTest,linealidad)
    %Funcion que realiza el calculo de los valores de sigma para cada regla
    %Para el calculo de la incerteza por metodo de covarianza.
    
    %Parametros del modelo.
    h = model.h;
    
    %Numero de entradas.
    nEntradas = size(XTest,2);
    
    %Calculo del parametro \greek{v}, 'suma de activaciones'
    vr = vRegla(model);
    
    %Calculo de \bar{e}
    [e2,~,~]= eBarra(vr,XTest,YTest,model);
    
    %Calculo de mu
    mu = mu2(model);
    %Numero de parametros.
    if (linealidad==0)
        %Caso de un modelo afin
        n = nEntradas;
    elseif(linealidad==1)
        %Caso de un modelo lineal
        n = nEntradas + 1;
    else
        disp('Error en calculo de sigma')
    end
    %sigmar
    beta2 = h.^2;    
    sigmar = (1./(mu-n)).* (transpose(e2) * beta2);
end


%% FUNCIONES AUXILIARES.
function [vr] = vRegla(model)
    %Funcion que calcule los v para una cierta regla
    
   %Calculo de grados de activacion por regla
   %wn(r) es el grado de activacion de la regla r.
   %mu(r,i) es el grado de activacion para la regla r ante la entrada i.
   %Debe retornar un vector de la misma dimnesion que el numero de
   %entradas
   h = model.h;
   vr = sum(h);
end

function [e2,error,errorMedio] = eBarra(vr,XTest,YTest,model)
    %Funcion que calcule el parametro e barra de las ecuaciones para la
    %determinacion de la incerteza.
    %RETORNA UNA COLUMNA PARA CADA REGLA.
    
    %Parametros del modelo.
    h = model.h;
    
    %Determinacion del error con las predicciones.
    %Predicciones.
    YPredict = evaluacionTS(XTest,model);
    %Error.
    error = YTest-YPredict;
    
    %Calculo de error medio
    suma = transpose(error) * h;
    errorMedio = suma/vr;
    
    %e2
    e2 = (error-errorMedio).^2;
end

function [mu] = mu2(model)
    %Parametro mu de las formulas.
    h = model.h;
    
    %Calculo de la suma al cuadrado.
    mu = sum(h.^2);
end