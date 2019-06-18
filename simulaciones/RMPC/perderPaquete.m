function perdida = perderPaquete(xIn,vIn,xAnterior,vAnterior,PER)

    %Funcion que dada una probabilidad simula la perdida de paquetes.
    dado = rand(1);
    if(dado <= PER)
        % Caso en que se pierde el paquete.
        perdida = 1;
    else
        %Caso en que no se pierde el paquete.
        perdida = -1;
    end

end
