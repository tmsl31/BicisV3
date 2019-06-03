function [model] = agregarSigmaModelo(model,XTrain,YTrain)
    %Funcion que realiza el calculo del valor de sigma 
    
    %Calculo de la linealidad.
    %Numero de entradas.
    nEntradas = size(model.a,2);
    %Numero de salidas.
    nSalidas = size(model.g,2);
    %Linealidad
    linealidad = nSalidas - nEntradas;
    %Calcular los valores de sigma para las distintas reglas.
    sigmar = calculoSigma(model,XTrain,YTrain,linealidad);
    %Agregar al modelo
    model.sigma = sigmar;
end