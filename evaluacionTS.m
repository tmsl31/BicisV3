function YPredict = evaluacionTS(X,model)
    %Funcion que realiza la evaluacion utilizando el modelo de Takagi -
    %Sugeno.
    
    %Modelo
    %model = M.model;
    
    %Parametros del modelo
    a = model.a;
    b = model.b;
    g = model.g;

    %Dimensiones.
    [nMuestras,nEntradas] = size(X);
    %Numero de parametros de consecuencia.
    [numeroReglas,nParametros] = size(g);
    %Tipo Modelo
    linealidad = nParametros-nEntradas;
    %Vector que almacene las predicciones.
    YPredict = zeros(nMuestras,1);
    
    %Evaluacion para cada una de las muestras.
    for muestra = 1:nMuestras
        %W(r) is the activation degree of rule 'r'.
        W = ones(1,numeroReglas);
        %mu(r,i) is the activation degree of rule 'r', input 'i'.
        mu = zeros(numeroReglas,nEntradas);
        %Ciclo de evalucion de reglas y entradas.
        for regla = 1:numeroReglas
            %Por cada regla
            for entrada = 1:nEntradas
                %Grado de activacion para cada entrada.
                mu(regla,entrada) = gaussiana(b(regla,entrada),a(regla,entrada),X(muestra,entrada));
                %Grado de activacion de la regla para la muestra.
                W(regla) = W(regla) * mu(regla,entrada);
            end
        end
        
        %Calculo del grado de activacion normalizado de la regla.
        Wn = activacionNorm(W);
        %Evaluacion de las consecuencias.
        if (linealidad == 1) 
            %Caso en que el modelo es afin. Con bias.
            yr=g*[1 ;X(muestra,:)'];           
        elseif(linealidad == 0)
            %Caso de modelo lineal.
            yr=g*X(muestra,:)';
        else
            disp('Error formulacion')
        end
        YPredict(muestra,1) = Wn*yr;
    end
end

%% Funciones Auxiliares.

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