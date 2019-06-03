function [aDes] = slidingFunction(xAnterior,vAnterior,aAnterior,xLeader,vLeader,aLeader,xi,vi,ai,Ldes,K,chi,wn)
    %Funcion que calcule la aceleracion deseada utilizando sliding control.
    
    %Error de espaciamiento.
    epsilon = xi-xAnterior+Ldes;
    
    %Terminos funcion
    t1 = (1-K)*aAnterior;
    t2 = K*aLeader;
    t3 = -1*(2*chi-K*(chi+sqrt(chi^2-1)))*(wn*(vi-vAnterior));
    t4 = -1*(chi+sqrt(chi^2-1))*wn*K*(vi-vLeader);
    t5 = wn^2*epsilon;
    
    %Aceleracion deseada
    aDes = t1+t2+t3+t4+t5;

end