%% SIMULACION SLIDING CONTROL

%% Parametros.

%Espaciamiento deseado (m)
Ldes = 2;
%Aceleracion del lider
leaderAcceleration = 1;
%Limitaciones aceleracion
aUB = 1.0;
aLB = -1.5;
%% Parametros modificables.
%Aceleración perfecta del lider.
perf = input('Tipo de lider (perfecto(1), ruidoso(0)):');
v0Leader = input('Velocidad lider (m/s)(2.7,4.16,5)');
tSimul = 60 * input('Tiempo de simulacion (min):');
ts = 0.1;
d = 0;
%Parametros de la velocidad.
[meanError,varError] = errorActuacion(v0Leader);

%Matrices de sistema en varaibles de estado.
Acont = [0 1;0 0];     %Matriz A
Bcont = [0;1];         %Matriz B
Ccont = eye(2);         %Matriz C
Dcont = [0;0];          %Matriz D

%Posiciones y velocidades iniciales.
%Definicion de las posiciones y velocidades iniciales de las bicicletas.
%Lider
x0Leader = 0;

%Bicicleta seguidora 1.
x0Bici1 = -10;
v0Bici1 = 1;

%Bicicleta seguidora 2.
x0Bici2 = -20;
v0Bici2 = 1;

%Bicicleta seguidora 3.
x0Bici3 = -30;
v0Bici3 = 1;
%% Simular.
sim('slidingSimulationSaturado.slx')

function [meanError,varError] = errorActuacion(v0Leader)
    %Funcion que defina la varianza del error de actuacion de acuerdo a la
    %velocidad del lider.
    
    %Casos de velocidad
    if (v0Leader == 2.7)
        meanError = 0.0164;
        varError = 0.3829;
    elseif (v0Leader == 4.16)
        meanError = 0.0437;
        varError = 0.4173;
    elseif (v0Leader == 5)
        meanError = -0.0091;
        varError = 0.3975;
    else
        disp('Velocidad no Implementada')
    end
    %Varianza
    varError = varError^2;
end