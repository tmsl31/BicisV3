function [Iinf,Isup] = intervalosSimulacion(model,nPasos)
    %Funcion que calcula los intervalos para un cierto numero de pasos
    %definido por la simulacion, realizando las predicciones de TS en caso
    %de ser necesario.
    
    %Parametros:
    % model -> Modelo de Takagi Sugeno.
    % nPasos -> Numero de Pasos de prediccion del RMPC.
    
    %Variables globales.
    global bufferError alpha
    
    %Copiar el buffer de error para trabajar sobre el sin modificar el
    %original.
    copiaBuffer = bufferError;
   
    %Casos para el numero de pasos (se implementa una cantidad fija.
    if (nPasos == 1)
        %Caso de un paso.
        X = copiaBuffer([1, 5]);
        [~,intervalos] = defIntervalo(model,alpha,X);
        %Agregar los valores de intervalo
        Iinf = [intervalos.inferior];
        Isup = [intervalos.superior];
    elseif (nPasos == 2)
        %Caso dos Pasos.
        %Primer paso
        X = copiaBuffer([1, 5]);
        [~,intervalos] = defIntervalo(model,alpha,X);
        %Agregar los valores de intervalo
        Iinf = [intervalos.inferior];
        Isup = [intervalos.superior];
        %Segundo Paso.
        ek = evaluacionTS(X,model);
        copiaBuffer = actualizarBufferError(ek,copiaBuffer);
        X = copiaBuffer([1, 5]);
        [~,intervalos] = defIntervalo(model,alpha,X);
        %Agregar los valores de intervalo
        Iinf = [Iinf;intervalos.inferior];
        Isup = [Isup;intervalos.superior];
    elseif (nPasos == 3)
        %Caso tres Pasos.
        %Primer paso
        X = copiaBuffer([1, 5]);
        [~,intervalos] = defIntervalo(model,alpha,X);
        %Agregar los valores de intervalo
        Iinf = [intervalos.inferior];
        Isup = [intervalos.superior];
        %Segundo Paso.
        ek = evaluacionTS(X,model);
        copiaBuffer = actualizarBufferError(ek,copiaBuffer);
        X = copiaBuffer([1, 5]);
        [~,intervalos] = defIntervalo(model,alpha,X);
        %Agregar los valores de intervalo
        Iinf = [Iinf;intervalos.inferior];
        Isup = [Isup;intervalos.superior];
        %Tercer Paso.
        ek = evaluacionTS(X,model);
        copiaBuffer = actualizarBufferError(ek,copiaBuffer);
        X = copiaBuffer([1, 5]);
        [~,intervalos] = defIntervalo(model,alpha,X);
        %Agregar los valores de intervalo
        Iinf = [Iinf;intervalos.inferior];
        Isup = [Isup;intervalos.superior];
    elseif (nPasos == 4)
        %Caso 4 Pasos.
        %Primer paso
        X = copiaBuffer([1, 5]);
        [~,intervalos] = defIntervalo(model,alpha,X);
        %Agregar los valores de intervalo
        Iinf = [intervalos.inferior];
        Isup = [intervalos.superior];
        %Segundo Paso.
        ek = evaluacionTS(X,model);
        copiaBuffer = actualizarBufferError(ek,copiaBuffer);
        X = copiaBuffer([1, 5]);
        [~,intervalos] = defIntervalo(model,alpha,X);
        %Agregar los valores de intervalo
        Iinf = [Iinf;intervalos.inferior];
        Isup = [Isup;intervalos.superior];
        %Tercer Paso.
        ek = evaluacionTS(X,model);
        copiaBuffer = actualizarBufferError(ek,copiaBuffer);
        X = copiaBuffer([1, 5]);
        [~,intervalos] = defIntervalo(model,alpha,X);
        %Agregar los valores de intervalo
        Iinf = [Iinf;intervalos.inferior];
        Isup = [Isup;intervalos.superior];
        %Cuarto Paso.
        ek = evaluacionTS(X,model);
        copiaBuffer = actualizarBufferError(ek,copiaBuffer);
        X = copiaBuffer([1, 5]);
        [~,intervalos] = defIntervalo(model,alpha,X);
        %Agregar los valores de intervalo
        Iinf = [Iinf;intervalos.inferior];
        Isup = [Isup;intervalos.superior];
    elseif (nPasos ==5)
        %Caso 5 Pasos.
        %Primer paso
        X = copiaBuffer([1, 5]);
        [~,intervalos] = defIntervalo(model,alpha,X);
        %Agregar los valores de intervalo
        Iinf = [intervalos.inferior];
        Isup = [intervalos.superior];
        %Segundo Paso.
        ek = evaluacionTS(X,model);
        copiaBuffer = actualizarBufferError(ek,copiaBuffer);
        X = copiaBuffer([1, 5]);
        [~,intervalos] = defIntervalo(model,alpha,X);
        %Agregar los valores de intervalo
        Iinf = [Iinf;intervalos.inferior];
        Isup = [Isup;intervalos.superior];
        %Tercer Paso.
        ek = evaluacionTS(X,model);
        copiaBuffer = actualizarBufferError(ek,copiaBuffer);
        X = copiaBuffer([1, 5]);
        [~,intervalos] = defIntervalo(model,alpha,X);
        %Agregar los valores de intervalo
        Iinf = [Iinf;intervalos.inferior];
        Isup = [Isup;intervalos.superior];
        %Cuarto Paso.
        ek = evaluacionTS(X,model);
        copiaBuffer = actualizarBufferError(ek,copiaBuffer);
        X = copiaBuffer([1, 5]);
        [~,intervalos] = defIntervalo(model,alpha,X);
        %Agregar los valores de intervalo
        Iinf = [Iinf;intervalos.inferior];
        Isup = [Isup;intervalos.superior];
        %Quinto Paso.
        ek = evaluacionTS(X,model);
        copiaBuffer = actualizarBufferError(ek,copiaBuffer);
        X = copiaBuffer([1, 5]);
        [~,intervalos] = defIntervalo(model,alpha,X);
        %Agregar los valores de intervalo
        Iinf = [Iinf;intervalos.inferior];
        Isup = [Isup;intervalos.superior];
    else
        disp ('Numero de pasos no implementado')
    end
end


%% Funciones auxiliares.
function [buffer] = actualizarBufferError(error,buffer)
    %Funcion que con un nuevo valor del error realice la actualizacion del
    %buffer de error, moviendo en un espacio todos los valores.
   
    %Params:    bufferError0->Buffer sin actualizar.
    %           error->Nuevo valor de error.
    
    %Extraer los cuatro valores mas nuevos del buffer original y agregar
    %nuevo error en k-1.
    buffer = [error,buffer(1:4)];
end