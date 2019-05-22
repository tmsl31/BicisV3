function [sigmar] = calculoSigma(model,XTrain,YTrain,linealidad)
    %Funcion que realiza el calculo de los valores de sigma para cada regla
    %Para el calculo de la incerteza por metodo de covarianza.
    
    %Parametros:
    %model -> Modelo de Takagi - Sugeno.
    %XTrain -> Entradas del conjunto de entrenamiento.
    %YTrain -> Salida del conjunto de entrenamiento.
    %linealidad ->  Define si el modelo es lineal (sin bias) o afin (con
    %bias).
    
    %Parametros del modelo. 
    %h Corresponde a los grados de activacion normalizados del conjunto de
    %train
    h = model.h;
    
    %Calculo del parametro \greek{v}, 'suma de activaciones'
    vr = vRegla(h);
    
    %Calculo de mu
    mu = mu2(h);
    
    %Calculo de \bar{e} %Columna.
    [e2,~]= eBarra(vr,XTrain,YTrain,model,h);
    
    %Numero de entradas.
    nEntradas = size(XTrain,2);

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
    %sigma2
    beta2 = h.^2;    
    sigma2 = (1./(mu-n)).* (transpose(e2) * beta2);
    %simar 
    sigmar = sqrt(sigma2);
end


%% FUNCIONES AUXILIARES.

function [vr] = vRegla(h)
    %Funcion que calcule los v para una cierta regla
    
    %Numero de reglas
    [~,nReglas] = size(h);
    %Construccion del vr
    vr = zeros(nReglas,1);
    %Calculo de la suma
    count = 1;
    while count <= nReglas
        vr(count,1) = sum(h(:,count));
    end
end

function [mu] = mu2(h)
    %Parametro mu de las formulas.
    
    %Numero de reglas
    [~,nReglas] = size(h);
    %Construccion del vr
    mu = zeros(nReglas,1);
    %Calculo de la suma
    count = 1;
    while count <= nReglas
        mu(count,1) = sum(h(:,count).^2);
    end
end

function [e2,errorBarra] = eBarra(vr,XTrain,YTrain,model,h)
    %Funcion que calcule el parametro e barra de las ecuaciones para la
    %determinacion de la incerteza.
    %RETORNA UNA COLUMNA PARA CADA REGLA.
    
    %Determinacion del error con las predicciones.
    %Predicciones.
    YPredict = evaluacionTS(XTrain,model);
    %Error.
    error = YTrain-YPredict;
    
    %Calculo de error medio
    suma = transpose(error) * h;
    errorBarra = suma./vr;
    
    %e2
    e2 = (error-errorBarra).^2;
    %Para que quede como columna.
    e2 = transpose(e2);
end

