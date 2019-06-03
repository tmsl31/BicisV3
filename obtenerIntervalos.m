function [alphaOptimo] = obtenerIntervalos(model,prob,XVal,XTest,YVal,YTest)
    %Funcion que realiza el calculo y grafica de los intervalos. Realiza
    %tambien la obtencion del alpha optimo que permita un cierto pocentaje
    %de inclusion de los resultados.
    
    %Definion del vector de alpha
    vectorAlpha = 0:0.01:10;
    %Calculo de optimo e intervalos.
    [~, alphaOptimo] = sintonizacionIntervalos(model, prob,vectorAlpha, XVal, YVal);
    %Intervalos para Test.
    [YPredict,intervalos] = defIntervalo(model,alphaOptimo,XTest);
    %Limites.
    down = intervalos.inferior;
    up = intervalos.superior;
    %Grafico
    figure()
    hold on
    ciplot(down,up,[0.6 0.6 0.6])
    plot(YPredict,'r+-')
    plot(YTest,'b*-')
    legend('Intervalo','Prediccion','Valor Real')
    title('')
    hold off
    
end

function ciplot(lower,upper,colour)
     
% ciplot(lower,upper)       
% ciplot(lower,upper,x)
% ciplot(lower,upper,x,colour)
%
% Plots a shaded region on a graph between specified lower and upper confidence intervals (L and U).
% l and u must be vectors of the same length.
% Uses the 'fill' function, not 'area'. Therefore multiple shaded plots
% can be overlayed without a problem. Make them transparent for total visibility.
% x data can be specified, otherwise plots against index values.
% colour can be specified (eg 'k'). Defaults to blue.

% Raymond Reynolds 24/11/06



x=1:length(lower);
for i=1:length(lower)
    x(i)=x(i);
end
% x1=(0:0.25:120)';
% x=x1(1:480);
% convert to row vectors so fliplr can work
if find(size(x)==(max(size(x))))<2
x=x'; end
if find(size(lower)==(max(size(lower))))<2
lower=lower'; end
if find(size(upper)==(max(size(upper))))<2
upper=upper'; end

%fill([x fliplr(x)],[upper fliplr(lower)],colour,'EdgeColor',colour)
fill([x fliplr(x)],[upper fliplr(lower)],colour)
end

