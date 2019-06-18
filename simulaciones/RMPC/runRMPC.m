%%Simulacion de sistema RMPC.
clear;
close all
% Variables globales.
global bufferError contador alpha d Wx Wv Wu ts
%%SCRIPT

%% Parametros de Takagi & Sugeno.
%Importar workspace
load('TSAutoDefinitivo2.mat');

%% Datos y restricciones.
% Definición de constantes
d = 2;              %Largo de las bicicletas (m).
%alpha = 1.5200;     %Alpha para 70% de los casos de validacion
alpha = 0.67;
contador = 0;       %Contador de pasos de la simulacion.
%Restricciones fisicas de ciclista
lb = -1.5;          %Limite inferior u (m/s^2).
ub = 1.0;           %Limite superio u (m/s^2).
deltaULB = -3.0;    %Limite inferior deltaU (m/s^2)
deltaUUB = 1.5;     %Limite superior deltaU (m/s^2)

%Datos configurables por consola.
nPasos = input('Numero de pasos prediccion: ');
Ldes = input('Valor de spacing deseado (m): ');
ts = input('Tiempo de muestreo (s): ');
tSimulacion = 60 * input('Tiempo simulacion (min): ');
v0Leader = input('Velocidad lider (m/s)(2.7,4.16,5)');

%Buffer de error (tamano 5 por los regresores)
bufferError = zeros(1,5);

%% Configuraciones de la simulacion.
%Ponderaciones de los terminos
Wx = 1;     %Peso asociado a spacing.
Wv = 1;     %Peso asociado a seguimiento de velocidad.
Wu = 1;     %Peso asociado a accion de control


%Matrices de sistema en varaibles de estado.
Acont = [0 1;0 0];     %Matriz A
Bcont = [0;1];         %Matriz B
Ccont = eye(2);         %Matriz C
Dcont = [0;0];          %Matriz D

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

%Error de actuacion
[meanError,varError] = errorActuacion(v0Leader);

%Matrices de desigualdades.
[Ades,bdes] = defRestricciones(nPasos,lb,ub,deltaULB,deltaUUB);

%% SIMULACION

%SIMULAR.
sim('simulRMPC.slx')

%% GRAFICOS SIMULACION

%Graficos.
%Spacing
figure(1)
plot(spacing)
titulo1 = strcat('Spacing, Weights: [Wx,Wv,Wu] = ',string([Wx,Wv,Wu]));
title(titulo1)
xlabel('Time (s)')
ylabel('Spacing (m)')
%legend('Bicicleta 2', 'Bicicleta 3', 'Bicicleta 4')

%Trayectoria
figure(2)
plot(position)
titulo2 = strcat('Position, Weights: [Wx,Wv,Wu] = ',string([Wx,Wv,Wu]));
title(titulo2)
xlabel('Time (s)')
ylabel('Position (m)')
%legend('Bicicleta 1 (Lider)','Bicicleta 2', 'Bicicleta 3', 'Bicicleta 4')


%% FUNCIONES AUXILIARES.

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

