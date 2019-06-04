function [Aeq,beq] = matIgualdades(nPasos,xki,vki,xkAnterior,vkAnterior)
%function [matAeq,beq] = matEq(nPasos,ts)
%Funcion que genere las matrices de equivalencia para el número de pasos
%dado.

global ts

%Matriz a llenar.

%(i)
%.-A-.
% %Estados
%Dimension de la primera sub matriz
dimA1 = nPasos * 4;
%Creacion de la primera submatriz
A1 = eye(dimA1);
%Bloque que da la realción para el sistema en variables de estado
bloque = [-1,-1*ts,0,0;
           0,-1,0,0;
           0,0,-1,-1*ts;
           0,0,0,-1];

%Llenado con el bloque.
if nPasos > 1
    count = 1;
    for i = 5:4:(nPasos*4)
        A1(i:i+3,count:count+3) = bloque;
        count = count + 4;
    end
end

% Acciones de control

%Submatriz de acciones de control
A2 = zeros(4*nPasos,nPasos*2);

%Llenado de la submatriz
countU1 = 1;
countU2 = nPasos +1;
for i = 2:4:(nPasos*4)
    A2(i,countU1) = -ts;
    countU1 = countU1 + 1;
end

for i = 4:4:(nPasos*4)
    A2(i,countU2) = -ts;
    countU2 = countU2 + 1;
end

%Construccion de la matriz A
Aeq = [A1,A2];


% beq
% Dimension de b
dimb = 4*nPasos;
beq = zeros(dimb,1);

%LLenado
beq(1,1) = xki + ts*vki;
beq(2,1) = vki;
beq(3,1) = xkAnterior + ts*vkAnterior;
beq(4,1) = vkAnterior;

end