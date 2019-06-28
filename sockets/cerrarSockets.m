function [] = cerrarSockets(Tx,Rx)
    %Funcion que realiza el cierre de los sockets.
    
    %Cerrar sockets.    
    fclose(Tx);
    fclose(Rx);
    %Eliminar sockets.
    delete(Tx)
    delete(Rx)
    %Clear.
    clear Tx
    clear Rx
end