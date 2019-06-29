function [xva] = perdidaPaquetes(xNuevo,vNuevo,aNuevo,num,PER)
    %Funcion que actualiza el buffer y devuelve las variables cinematicas a
    %enviar.
    
    global buffer0 buffer1 buffer2 buffer3
    %Variable aleatoria.
    dado = rand(1);
    %Casos.
    if (dado >= PER)
        %Caso en que el paquete llega.
        %Actualizacion del buffer
        if(num == 0)
            buffer0(1) = xNuevo;
            buffer0(2) = vNuevo;
            buffer0(3) = aNuevo;
        elseif(num == 1)
            buffer1(1) = xNuevo;
            buffer1(2) = vNuevo;
            buffer1(3) = aNuevo;
        elseif(num == 2)
            buffer2(1) = xNuevo;
            buffer2(2) = vNuevo;
            buffer2(3) = aNuevo;
        elseif(num == 3)
            buffer3(1) = xNuevo;
            buffer3(2) = vNuevo;
            buffer3(3) = aNuevo;
        end
    end
    if (num == 0)
        x = buffer0(1);
        v = buffer0(2);
        a = buffer0(3);
    elseif(num == 1)
        x = buffer1(1);
        v = buffer1(2);
        a = buffer1(3);
    elseif(num == 2)
        x = buffer2(1);
        v = buffer2(2);
        a = buffer2(3);
    elseif(num == 2)
        x = buffer2(1);
        v = buffer2(2);
        a = buffer2(3);
    end
    xva = [x v a];
end


