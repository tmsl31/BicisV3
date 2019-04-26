%% g = taksug1(y,Z,a,b,opcion)
%
% Identificaci�n de Par�metros de las consecuencias usando LMS global
%
% Inputs:
%   * y: Vector de salidas del modelo TS
%   * Z: Matriz de entradas del modelo TS
%   * a: (Std)^-1 de los clusters del modelo TS
%   * b: Centros de los clusters del modelo TS
%   * opcion: [Tipo de identificaci�n, Tipo de normalizaci�n]
%       * opcion(1) = 1: LMS con todos los datos
%       * opcion(1) = 4: LMS con todos los datos para consecuencias
%                        lineales
% Ouputs:
%   * g: Matriz de par�metros de las consecuencias del modelo TS

function [g, P, h] = taksug1_n(y,Z,a,b,opcion)

[N,n] = size(Z);    % N: N�mero de datos. n: N�mero de variables
Nr = size(a,1);     % N�mero de reglas
h = zeros(N,Nr);  	% Grados de activaci�n normalizados
%keyboard
%% C�lculo de grados de activaci�n
for k = 1:N             % k: Datos
	w = ones(1,Nr);
    
    for r = 1:Nr                % Recorro reglas
        w(r) = prod(exp(-0.5*(a(r,:).*(Z(k,:) - b(r,:))).^2));
    end 
%     mu=zeros(Nr,n);
%     for r=1:Nr
%      for i=1:n
%        mu(r,i)=exp(-0.5*(a(r,i)*(Z(k,i)-b(r,i)))^2);  
%        w(r)=w(r)*mu(r,i);
%      end
%     end
    
    if sum(w)==0
        h(k,:) = w;
    else
        h(k,:) = w/sum(w);
    end
    
    % Si h es NaN
    h_NaN = sum(isnan(h(k,:)));
    if h_NaN ~= 0
        h(k,:) = zeros(Nr,1);
    end
end
%keyboard
%% Formulaci�n de Z_fuzzy
Z_fuzzy = zeros(N,Nr*n);  % y_fuzzy = Z_Fuzzy*theta (theta: vector de par�metros)
for i = 1:Nr:n*Nr
     Z_fuzzy(:,i:i+Nr-1) = h.*kron(ones(1,Nr),Z(:,ceil(i/Nr)));
end

if opcion(1) == 1           % Consecuencias afines
    Z_fuzzy = [h,Z_fuzzy];
end
% size(Z_fuzzy)
% 
% rank(Z_fuzzy)
%% Par�metros
theta = Z_fuzzy\y;          % Par�metros

if opcion(1) == 4           % Consecuencias lineales
    g = reshape(theta,[Nr,n]);
elseif opcion(1) == 1     	% Consecuencias afines
    g = reshape(theta,[Nr,n+1]);
end

%% Formulaci�n Covarianza

Z=[ones(N,1) Z];
for j=1:Nr
    for k=1:N
        Z_cov(k,:,j)=h(k,j).*Z(k,:);
    end
    P(:,:,j)=inv(Z_cov(:,:,j)'*Z_cov(:,:,j));
end

%keyboard
end

