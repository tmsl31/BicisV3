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

function result = GKclustering(data,param)

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
mm = mean(Z);                                               % Promedio de cada columna (variable)
aa = max(abs(Z - ones(N,1)*mm));                            % Puntos más alejados del promedio en cada columna
v = 2*(ones(c,1)*aa).*(rand(c,n) - 0.5) + ones(c,1)*mm;     % Centros de los clusters para cada variable (c,n)
d = zeros(N,c);                                             % Distancias al cuadrado
for i = 1:c             % i: cluster
    Zvi = Z - ones(N,1)*v(i,:);
    d(:,i) = sum((Zvi.^2),2);
end

d = (d + 1e-10).^(-1/(m-1));        % Distancias al cuadrado
U0 = (d./(sum(d,2)*ones(1,c)));     % Matriz de Partición (grados de pertenencia)

%% Iteraciones
U = zeros(N,c);                     % Grados de pertenencia                
iter = 0;                           % Número de iteraciones                 
f0 = eye(n)*det(cov(Z)).^(1/n);     % Matriz de covarianza de los datos ('identity' matrix)

J(1,1) = 10^12;                    	% Función objetivo

while  max(max(abs(U0 - U))) > e
    iter = iter + 1;
    U = U0;
    Um = U.^m;
    sumU = sum(Um);                     % Suma de todos los u^m para cada cluster
    v = (Um'*Z)./(sumU'*ones(1,n));     % Centro de los clusters (c,n)
  
    for i = 1:c                         % Cálculo Fi y d
        Zvi = Z - ones(N,1)*v(i,:);   	% Distancia al i-ésimo centro
        Fi = ones(n,1)*Um(:,i)'.*Zvi'*Zvi/sumU(i);
        Fi = (1 - gamma)*Fi + gamma*f0;
        
        if cond(Fi) > beta;                  	% cond(Fi) = max_eig_val(F)/min_eig_val(F)
            [eig_vec,eig_val] = eig(Fi);       
            edmax = max(diag(eig_val));       	% max_eig_val
            eig_val(beta*eig_val < edmax) = edmax/beta;     % Acotar min_eig_val si min_eig_val < edmax/beta
            Fi = eig_vec*diag(diag(eig_val))/(eig_vec); 	% Reconstruir Fi
        end
        A = (rho(i)*det(Fi))^(1/n)*pinv(Fi);
        d(:,i) = sum((Zvi*A.*Zvi),2);         	% Distancia^2 d = (x-v)'*A*(x-v)
    end
  
    distout = sqrt(d);                          % Distancia entre datos y centros
    
    % Evitar divergencia
    J(iter+1,1) = sum(sum(Um.*d));
    if J(iter+1,1) - J(iter,1) > 0          	
        break
    end
    
    % Cálculo grados de pertenencia
    dm = (d + 1e-10).^(-1/(m - 1));   % 1e-10 para evitar indeterminación
    U0 = (dm ./ (sum(dm,2)*ones(1,c)));  
end

%% Matrices Finales

Um = U.^m;
sumU = sum(Um);

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
result.data.d = distout;        % Distancias entre datos y centros
result.cluster.v = v;           % Centros de los clusters
result.cluster.F = F;          	% Matrices de covarianza difusa
result.cluster.A = A;         	% Matrices de normas inducidas
result.cluster.V = V;          	% Vectores propios de F
result.cluster.D = D;          	% Valores propios de F
result.iter = iter;            	% Número de iteraciones
result.cost = J;               	% Función de Costos
%keyboard
end

