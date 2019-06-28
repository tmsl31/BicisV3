%%Script que realiza la conexion por sockets con Omnet++.

%% Sockets.
disp('Abrir sockets...')
%% Informacion.
%Puerto en Omnet.
puertoOmnet = 30000;
%Puerto en Matlab
puertoMatlab = 30001;
%Direccion IP del PC.
%ipLab = "172.17.29.96";
ipLab = "192.168.0.12";

%% Apertura de los sockets.
%Creacion de los sockets TCP.
%Transmision.
Tx = udp(ipLab,'RemotePort', puertoOmnet,'LocalPort',puertoMatlab,'Timeout',60);
%Recepcion.
Rx = udp(ipLab,'RemotePort', puertoMatlab,'LocalPort',puertoOmnet,'Timeout',60);

%Apertura.
%Tx.
fopen(Tx);
%Rx
fopen(Rx);

%% RMPC.
%Importar workspace
disp('Importar modelo de T&S...')
load('TSAutoDefinitivo2.mat');

%% Datos y restricciones.
disp('Definiciones de constantes...')

%Definicion de variables globales.
global alpha Ldes d 

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
nPasos = 5;
Ldes = 2;
ts = 1;
v0Leader = 2.7;

disp('Numero de pasos de prediccion: 5')
disp('Valor de spacing deseado (m): 2')
disp('Tiempo de muestreo (s): 1');
disp('Velocidad lider (m/s): 2.7');


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
Ccont = eye(2);        %Matriz C
Dcont = [0;0];         %Matriz D
 
%Matrices de desigualdades.
[Ades,bdes] = defRestricciones(nPasos,lb,ub,deltaULB,deltaUUB);

%% Iteraciones sobre el problema de optimizacion.
cond = true;
while (cond)
    %Leer informacion.
    datos = leerSocket(Rx);
    %Ver si el dato corresponde a secuencia de termino.
    if datos == 'fin'
        break
    end
    %Encontrar aceleracion deseada.
    uDes = solveRMPC2(datos, MError, Ades, bdes);
    %Enviar la aceleracion a Omnet.
    fwrite(Tx,uDes);    
end

%Si termina el ciclo, cerrar los sockets.
cerrarSockets(Tx,Rx);

%% Funciones.
function [uDes] = solveRMPC2(datos, model, Ades, bdes)
    %Problema de optimizacion con sockets.    
    
    %Variables globales.
    global Ldes nPasos
    %Obtencion de variables para la optimizacion.
    
    %Optimizar.
    [uDes] = solveRMPC(xi,vi,xAnterior,vAnterior,vLider,errorAnterior,model,nPasos,Ldes,Ades,bdes);
end

function [datos] = leerSocket(Rx)
    %Funcion que obtenga los datos del socket desde Omnet.
    
    %<<Posible procesamiento>>
    %Esperar por datos.
    cond = true;
    while (cond)
        a = fread(Rx);
        if (~isempty(a))
            datos = str2double(a);
            cond = false;
        end
    end
end

function [] = cerrarSockets(Tx,Rx)
    %Funcion que realiza el cierre de los sockets.
    
    %Cerrar sockets.    
    fclose(Tx);
    fclose(Rx);
    %Eliminar sockets.
    delete(Tx)
    delete(Rx)
    %Clear.
    clear Tx
    clear Rx
end