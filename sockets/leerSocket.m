function [datos] = leerSocket(Rx)
    %Funcion que obtenga los datos del socket desde Omnet.
    
    %<<Posible procesamiento>>
    %Esperar por datos.
    cond = true;
    while (cond)
        a = fread(Rx);
        if (~isempty(a))
            datos = a;
            %datos = str2double(a);
            cond = false;
        end
    end
end