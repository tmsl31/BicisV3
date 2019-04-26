%% result = GKclustering(data,param)
%
% Clustering Gustafson-Kessel (Basado en paper "Improved covariance estimation for Gustafson-Kessel clustering")
% OBS: Para sistemas SISO
%
% Inputs:
%   * data: Datos para hacer clustering (salida,entradas)
%   * param: Parámetros para hacer clustering
%       * param.c: Número de clusters
%       * param.e: Tolerancia de término
%       * param.m: Exponente de peso para determinar difusidad
%       * param.ro: Vector de volumen de clusters (1,c)
%       * param.gamma: Ponderador [0,1] para forzar a los clusters a tener la
%                   misma forma
%       * param.beta: Umbral del condition number de la matriz de covarianza difusa (evita singularidad)
% Outputs:
%   * result: Resultado del clustering
%       * result.data.U: Matriz de partición (grados de pertenencia) (N,c)
%       * result.data.d: Matriz de distancias entre datos y centros (N,c)
%       * result.cluster.v: Matriz de centros de los clusters (c,n)
%       * result.cluster.F: Matrices de covarianza difusa de cada cluster (n,n,c)
%       * result.cluster.A: Matrices de normas inducidas de los clusters (n,n,c)
%       * result.cluster.V: Vectores propios de cada cluster (n,n,c)
%       * result.cluster.D: Valores propios de cada cluster (c,n)
%       * result.iter: Número de iteraciones
%       * result.cost: Función de Costos 

function result = FCMclustering(data,param)

%% Chequeo parámetros
% exist = 1 -> Si param.X esta en el workspace
if exist('param.m') == 1        % Índice de difusidad
    m = param.m;
else
    m = 2;
end

if exist('param.e') == 1        % Tolerancia
    e = param.e; 
else
    e = 1e-4;
end

if exist('param.ro') == 1       % Volumen Ai
    rho = param.ro;
else 
	rho = ones(1,param.c);
end

if exist('param.gamma') == 1    % Ponderador
    gamma = param.gamma;
else
    gamma = 0;
end

if exist('param.beta') == 1     % Umbral de condition number de matriz de covarianza
    beta = param.beta; 
else
    beta = 1e15;
end

%% Inicialización
rand('state',0)

Z = data.X;
%keyboard
[N,n] = size(Z);        % N: Número de puntos. n: Número de variables

c = param.c;                                              	% Número de clusters

%% Iteraciones
ops=[2, 100, 1e-5,0];
[v,U] = fcm(Z,c,ops);

%% Matrices Finales
U=U';
Um = U.^m;
sumU = sum(Um);

for i=1:c
    data_clusters{i}=[];
end
for i=1:length(Z(:,1))
    [ma,loc]=max(U(i,:));
    clust(i)=loc;
    data_clusters{loc}=[data_clusters{loc};data.X(i,:)];
end

for i=1:c
    for j=1:length(Z(1,:))
        varianza(i,j)=var(data_clusters{i}(:,j));
    end
end
sigma=sqrt(varianza);
std1=sigma.^-1; 
   

%v=v';



F = zeros(n,n,c);       % Matriz de covarianza difusa
A = zeros(n,n,c);       % Matriz de normas inducidas
V = zeros(n,n,c);     	% Vectores propios de F
D = zeros(c,n);        	% Valores propios de F

for i = 1:c
    Zvi = Z - ones(N,1)*v(i,:);
    Fi = ones(n,1)*Um(:,i)'.*Zvi'*Zvi/sumU(i);
    [eig_vec,eig_val] = eig(Fi);
    eig_val = diag(eig_val)';

	F(:,:,i) = Fi;
    A(:,:,i) = (rho(i)*det(Fi))^(1/n)*pinv(Fi);
    V(:,:,i) = eig_vec;
    D(i,:) = eig_val;
end

result.data.U = U;              % Grados de pertenencia         
% result.data.d = distout;        % Distancias entre datos y centros
result.cluster.v = v;           % Centros de los clusters
result.cluster.F = F;          	% Matrices de covarianza difusa
result.cluster.std1 = std1;   % Matriz con la desviacion estandar por regla y variables de entrada

result.cluster.A = A;         	% Matrices de normas inducidas
result.cluster.V = V;          	% Vectores propios de F
result.cluster.D = D;          	% Valores propios de F
% result.iter = iter;            	% Número de iteraciones
% result.cost = J;               	% Función de Costos
%keyboard
end

