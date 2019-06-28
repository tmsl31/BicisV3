function [Ades,bdes] = defRestricciones(nPasos,lb,ub,deltaLB,deltaUB)
%Funcion que calcula la matriz y vector de desigualdades para el numero
%de pasos indicado

%Variables globales
global ts

%.-A-.
%LB
disp(nPasos)
ALB = -1 * eye(2*nPasos,2*nPasos);
%UB
AUB = eye(2*nPasos,2*nPasos);
%DeltaLB
ADeltaLB = zeros((nPasos-1),nPasos);
%DeltaUB
ADeltaUB = zeros((nPasos-1),nPasos);

%Llenado de las matrices de deltaU
for i=1:1:(nPasos-1)
    ADeltaLB(i,i:i+1) = [1,-1];
    ADeltaUB(i,i:i+1) = [-1,1];
end

rell1 = zeros(2*nPasos,4*nPasos);
rell2 = zeros((nPasos-1),4*nPasos);
rell3 = zeros((nPasos-1),nPasos);

%Formar la matriz
Ades = [rell1,ALB;rell1,AUB;rell2,ADeltaLB,rell3;rell2,rell3,ADeltaLB;rell2,ADeltaUB,rell3;rell2,rell3,ADeltaUB];

%.-b-.
bLB  = -1.*lb .* ones(2*nPasos,1);
bUB = ub .* ones(2*nPasos,1);
bDeltaLB = -ts.*deltaLB .* ones(2*(nPasos-1),1);
bDeltaUB = ts.*deltaUB .* ones(2*(nPasos-1),1);
bdes = [bLB;bUB;bDeltaLB;bDeltaUB];
end