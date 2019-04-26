%--------Combinación información y validez del PI + Norma infinito------------------------
function [PICP,PINAW,NORM,J]= PI(yout,y_ent,up,lw,miu)

ct   = []; %Variable binaria que indica si la muestra pertenece al intervalo
NAW  = []; % VAriable para ancho del PI
s    = length(y_ent);
R    = max(y_ent)-min(y_ent);
n    = 500;

for i=1:s
    NAW(i)=up(i)-lw(i);
    if y_ent(i)<=up(i) && y_ent(i)>=lw(i)
        ct(i)=1;
    else
        ct(i)=0;
    end
end

PICP=sum(ct)/s;        % Probabilidad de Cobertura
PINAW=sum(NAW)/(s*R);  % Ancho del intervalo normalizado
error=(y_ent-yout);
NORM=norm(error,2);

J=80*PINAW+10*NORM+exp(-n*(PICP-miu));





