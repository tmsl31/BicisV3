%--------Confidence Interval-------------------------------------
function ci= CI(y_vl,up,lw)
d=[]; %Variable binaria que indica si la muestra pertenece al intervalo
for i=1:length(up)
    if y_vl(i)<=up(i) && y_vl(i)>=lw(i)
        d(i)=1;
    else
        d(i)=0;
    end
end
ci=sum(d)/length(y_vl);