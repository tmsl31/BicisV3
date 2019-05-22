function I = incertezaUnaEntrada(X,YTrain,XTrain,model)
    %Funcion que calcule los valores de la incertidumbre (I) del modelo
    %para una entrada(i.e una fila de X).

    %Parametros:
    %model -> Parametros del modelo de Takagi - Sugeno.
    %X -> Valores de X cuya incerteza se quiera calcular.
    %Y -> Valores de Y reales. Estos corresponden al conjuntos de test.
    %XTrain -> Valores de X del conjunto de entrnamiento
    %YTrain -> Valores de Y del conjunto de entrnamiento. Necesarios para el
    %calculo de sigma.

    %Obtencion de parametros del modelo.
    a = model.a;
    b = model.b;
    P = model.P;
    g = model.g;

    % calculo de sigma. Retorna una fila.
    sigmas = calculoSigma(model,XTrain,YTrain,1);

    % Numero de entradas y regresores.
    [~,nRegresores] = size(X);
    
    %Determinacion de la linealidad del modelo.
    %Dimensiones de g.
    [~,nParametrosG] = size(g);
    linealidad = nParametrosG - nRegresores;

    %Grado de activacion de las reglas con la entrada X.
    
    %Calculo de la proyección de le entrada.
    %Determinacion de tipo de modelo.
    if (linealidad == 1)
        %Caso de modelo afin.
        z = [1,X];
    elseif (linealidad == 0)
        %Caso modelo lineal.
        z = X;
    else
        disp('Error en incerteza una entrada')
    end
    %Columna de grados de activacion  normalizados.
    betar = gradosActivacion(a,b,X);
    %Calcular la proyeccion de la entrada. phi transpuesto.
    %En cada fila, se encuentra el phi asociado a una regla.
    phiT = proyeccionEntrada(betar,z);
    %Calculo de Ir para las distintas reglas.
    Ir = calculoIr(phiT,P,sigmas);
    %Calculo de I para la entrada X.
    I = betar' * Ir;
end

%% Funciones Auxiliares.
function [Ir] = calculoIr(phiT,P,sigmas)
    %Calculo de la incerteza asociada a cada regla.
    
    %Numero de reglas
    nReglas = size(phiT,1);
    %Valores de Ir
    Ir = zeros(nReglas,1);
    %Ciclo de evaluacion.
    count = 1;
    for phi = phiT
        factor = (1 + phi * P(:,:,count) * transpose(phi))^2;
        Ir(count) = sigmas(count) * factor;
        count = count + 1;
    end
end

function [phiT] = proyeccionEntrada(betar,z)
    %Funcion que calcule la proyeccion de la entrada para cada regla.
    
    %Numero de reglas.
    nReglas = size(betar,1);
    %Numero de entradas.
    nIn = size(z,2);
    %Vector de salida.
    phiT = zeros(nReglas,nIn);
    %Ciclo de evaluacion.
    count = 1;
    for beta = betar
        phiT(count,:) = beta * z;
        count = count + 1;
    end
end


function [betar] = gradosActivacion(a,b,X)
    %Funcion que calcule los grados de activacion normalizados para la
    %entrada X y los valores de a y b de los conjuntos difusos.
    
    %Numero de reglas.
    rulesNumber = size(a,1);
    %Numero de entradas.
    nEntradas = size(X,2);
    %Vector que almacene la activacion de cada regla.
    betar = ones(rulesNumber,1);
    %Evaluacion de cada regla.
    for regla = 1:rulesNumber
        %Por cada regla.
        for entrada = 1:nEntradas
            %Por cada entrada
            muEntrada = gaussiana(b(regla,entrada),a(regla,entrada),X(regla,entrada));
            betar(regla) = betar(regla) * muEntrada;
        end
    end
    %Realizar la normalizacion de los grados de activacion.
    betar = activacionNorm(betar);
end

function [valor] = gaussiana(mu,sigma,x)
    %Funcion que evalue la funcion gaussiana.

    valor = exp(-0.5*(sigma*(x-mu))^2);
end

function [Wn] = activacionNorm(W)
    %Activacion normalizada de la regla.
    if (sum(W)==0)
        Wn = W;
    else
        Wn = W/sum(W);
    end   
end