function [Ydesnorm] = desnorm(Y,mu,std)
    %Funcion que realiza la desnormalizacion de la salida
    Ydesnorm = Y*std + mu;
end