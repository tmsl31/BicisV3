function [YPredict,intervalos] = defIntervalo(model,alpha,XTest,YTest)
    %Funci�n que realice el calculo de los intervalos de confianza para la
    %muestra zi.

    %Parametros:
    %model: Parametros y variables del modelo de Takagi-Sugeno.
    %XTest: Entradas del modelo de test.
    %alpha: Par�metro de sintonia, relacionado con la probabilidad de
    %encerrar los valores buscados.
    
    %Obtenci�n de las predicciones.
    YPredict = evaluacionTS(XTest,model);
    
    %Busqueda de los intervalos de confianza.
    intervalo = incerteza(XTest,YTest,model);

    %Definicion de intervalos superiores e inferiores.
    intervalos.superior = YPredict + alpha*intervalo;
    intervalos.inferior = YPredict - alpha*intervalo;

end