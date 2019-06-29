function [aDes] = slidingFunction(xAnterior,vAnterior,aAnterior,vLeader,aLeader,xi,vi,Ldes)
    %Funcion que calcule la aceleracion deseada utilizando sliding control.
    
    %Error de espaciamiento.
    epsilon = xi-xAnterior+Ldes;
    %Velocidad relativa.
    epsilonPunto = vi - vAnterior;
    %Valores de alpha definidos en la simulacion del sistema en Omnetpp.
    alpha1 = 0.5;
    alpha2 = 0.5;
    alpha3 = 0.3;
    alpha4 = 0.1;
    alpha5 = 0.04;
    %Terminos de la funcion.
    t1 = alpha1 * aAnterior;
    t2 = alpha2 * aLeader;
    t3 = alpha3 * epsilonPunto;
    t4 = alpha4 * (vi - vLeader);
    t5 = alpha5 * epsilon;
    %Aceleracion deseada de acuerdo a sliding window
    aDes = t1+t2-t3-t4-t5;

end