function [params,muYTrainVel,stdYTrainVel] = modeloLinealVelocidad(XTrain,muXTrain,stdXTrain)
    %% Obtener velocidades.
    %Componentes 
    [~,componentes] = size(XTrain);
    %nRegresoresVelocidad
    nRegresoresVel = componentes/2;
    %Obtencion de velocidades.
    velocidades = XTrain(:,nRegresoresVel+1:componentes);
    %Estadisticas de velocidad.
    mu = muXTrain(:,nRegresoresVel+1);
    sigma = stdXTrain(:,nRegresoresVel+1);    
    %Desnormalización de valores.
    velocidades = desnorm(velocidades,mu,sigma);
    %% Generar estructura con el numero de regresores correspondiente.
    [XTrain2,YTrain2,muYTrainVel,stdYTrainVel] = estructuraAutoregresiva(velocidades,nRegresoresVel,1);
    
    %% Obtencion de los parametros.
    %Normalizacion 
    % Obtencion de los parámetros utilizando LMS. Se utiliza el conjunto de
    % entrenamiento.
    params = (transpose(XTrain2)*XTrain2)^(-1)*transpose(XTrain2)*YTrain2;
    
end

%% Funciones Auxiliares

%ESTRUCTURA DE LOS MODELOS.
function [in,out,muYTrain,stdYTrain] = estructuraAutoregresiva(data,nRegresores,shuffle)
    %Funcion que entregue la matriz de datos tal que se tenga la salida del
    %modelo y las entradas, con el número de autoregresores
    %correspondiente.

    %Dimensiones
    [nDatos,~] = size(data);
    %Salidas
    out = data(nRegresores+1:nDatos, 1);
    [altoSalida,~] = size(out);
    %Construccion de la matriz.
    in = zeros(altoSalida,nRegresores);
    %Llenado
    count = 1;
    while count<=nRegresores
        in(:,count) = data(nRegresores-count+1:nDatos-count,1);
        count = count + 1;
    end
    %Posibilidad de reordenar las filas de la matriz de forma random.
    if shuffle == 1
        %Juntar salidas y entradas.
        matConjunta = [out,in];
        %Shuffle.
        [out,in] = shuffleFilas(matConjunta);
    end
    [in,out,muYTrain,stdYTrain] = normalize(in,out);
end

function [XTrain,YTrain,muYTrain,stdYTrain] = normalize(XTrain,YTrain)
    %Funcion que normaliza.

    %Estadisticos de entrenamiento
    muXTrain = mean(XTrain);
    stdXTrain = std(XTrain);
    %
    muYTrain = mean(YTrain);
    stdYTrain = std(YTrain);
    %Normalizar
    XTrain = (XTrain - muXTrain)./stdXTrain;
    %
    YTrain = (YTrain - muYTrain)./stdYTrain;

end