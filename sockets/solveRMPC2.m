function [uDes] = solveRMPC2(datos, model, Ades, bdes)
    %Problema de optimizacion con sockets.    
    
    %Variables globales.
    global Ldes nPasos
    %Obtencion de variables para la optimizacion.
    
    %Optimizar.
    [uDes] = solveRMPC(xi,vi,xAnterior,vAnterior,vLider,errorAnterior,model,nPasos,Ldes,Ades,bdes);
end
