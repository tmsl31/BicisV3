function [uDes] = solveRMPC(xi,vi,xAnterior,vAnterior,vLider,errorAnterior,model,nPasos,Ldes,Ades,bdes)
    %Funcion que soluciona el problema de optimizacion asociado al
    %controlador RMPC del peloton de bicicletas.
    
    %Parametros:
    % xi -> Posicion de la bicicleta i (misma)
    % vi -> Velocidad de la bicicleta i (misma)
    % xAnterior -> Posicion de bicicleta anterior.
    % vAnterior -> Velocidad de bicicleta anterior.
    % vLider -> Velocidad de la bicicleta lider.
    % errorAnterior -> Error de actuacion en k-1.
    % model -> Estructura con los parametros del modelo de TS.
    % bufferErrores -> Buffer que almacena los ultimos cinco valores de e.
    
    %Variables globales.
    global Wx Wv Wu contador
    disp(contador);
    %Actualizacion del buffer de error con el nuevo error obtenido.
    actualizarBufferError(errorAnterior);
    if (contador >= 6)
    %Calculo de los intevalos.
    [Iinf,Isup] = intervalosSimulacion(model,nPasos);
    %Definicion de la funcion de costos a optimizar.
    Jmin = funcionCostos(nPasos,Ldes,vLider,Wx,Wv,Wu);
    %Posicion de la accion de control al resolver con ga.
    posU = nPasos * 4 + 1;
    %Matrices de igualdad.
    [Aeq,beq] = matIgualdades(nPasos,xi,vi,xAnterior,vAnterior);
    %Compresion de las matrices de desigualdad.
    [bdes2] = comprimirRestricciones(bdes,Iinf,Isup);
    %disp(bdes2)
    %Opciones del optimizador
    nVar = 6*nPasos;
    options = optimoptions(@ga,'CrossoverFraction',0.40,'FunctionTolerance',5e-3,'MaxGenerations',800,'MaxTime',30,'PopulationSize',50,'MaxStallGenerations',40);
    rng default;
    %Resolucion del problema de optimizacion.
    optimo = ga(Jmin,nVar,Ades,bdes2,Aeq,beq,[],[],[],options);    
    %Obtencion de uDes.
    uDes = optimo(posU);
    else
        uDes = 0;
        
    end
    contador = contador + 1;
end

%% Funciones auxiliares.
function [] = actualizarBufferError(error)
    global bufferError
    %Funcion que con un nuevo valor del error realice la actualizacion del
    %buffer de error, moviendo en un espacio todos los valores.
   
    %Params:    bufferError0->Buffer sin actualizar.
    %           error->Nuevo valor de error.
    
    %Extraer los cuatro valores mas nuevos del buffer original y agregar
    %nuevo error en k-1.
    bufferError = [error,bufferError(1:4)];
end