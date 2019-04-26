

function interval= Intervalo(model,a,val_x)
%Modificado por Fernanda Avila
%Noviembre-2012

%Model : T&S [model result] 
%a: alpha
%val_x,val_y : Datos validacion
%keyboard
yts    = ysim(val_x,model.a,model.b,model.g);
%keyboard
interv = ysim2(val_x,model.a,model.b,model.P,model.std_j);

interval.yts=yts;
interval.interv=interv;

%yy=0.5*(sign(yts')+1).*yts';

%figure
%t=15:15:length(yts)*15;
%plot(t', yts,'b-.','LineWidth',2)
%hold on
%plot(t',val_y','r')
%hold off
%xlabel('Time t (min)')
%legend('TS model', 'Real-data')
%ylabel('Load (kW)')


%figure
%t=15:15:length(interval.yts)*15;
%ciplot(interval.yts-a*interval.interv,interval.yts+a*interval.interv,t',[0.85 0.7 1])
interval.up=interval.yts+a*interval.interv;
interval.lw=interval.yts-a*interval.interv;
%hold on
%plot(t',val_y','k.')
%hold off
%ylabel('Load (kW)')
%xlabel('Time t (min)')
%title(strcat('Intervalo para a=',num2str(a)));














