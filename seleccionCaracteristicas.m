function [] = TySConSeleccion()
    %Modelo de Takagi Sugeno con la seleccion de caracteristicas y numero
    %de reglas utilizando el clustering y analisis de sensibilidad.

end


function [XTrain,XVal,XTest] = seleccionCaracteristicas(XTrain,XVal,XTest,indicesEntradas)
    %Funcion que dado un vector de regresores a conservar modifica las
    %variables de entrada del modelo.
 
    XTrain = XTrain(:,indicesEntradas);
    XVal = XVal(:,indicesEntradas);
    XTest = XTest(:,indicesEntradas);
end