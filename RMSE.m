function [RootMSE] = RMSE(vec1,vec2)
    %Funcion que calcule el RMSE
    RootMSE = sqrt(mean((vec1 - vec2).^2));
end