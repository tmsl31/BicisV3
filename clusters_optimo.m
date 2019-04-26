function [errtest,errent]=clusters_optimo(ytest,yent,Xtest,Xent,max_clusters)
ps1=1;
%yent, Xent: corresponden a la salida del set de entrenamiento y a la
%matriz de variables candadatas del set de entrenamiento, respectivamente
%ytest,Xtest: corresponden  a la salida del set de test y a la
%matriz de variables candadatas del set de test, respectivamente
%max_clusters corresponde al número maximo de clusters que se desea
%graficar
errtest=zeros(max_clusters-1,1); %se inicializa el vector de error de test
errent=zeros(max_clusters-1,1);% se inicializa el vector de error de entreneamiento
% se generan los errores de test y entrenamiento para los max_clusters
% clusters
pos=[];
for i=2:max_clusters
[model,result]=TakagiSugeno(yent,Xent,i,[1 4 2]);% en caso de no funcionar usar [2 2 1]
ps1=ps1+1;
pos=[pos,ps1];
y1=ysim(Xent,model.a,model.b,model.g);
y2=ysim(Xtest,model.a,model.b,model.g);
errtest(i-1)=sqrt(mean((y2-ytest).^2));
errent(i-1)=sqrt(mean((y1-yent).^2));
end
%Finalmente se grafican ambos errores
figure ()
plot(pos,errtest,'*-b','LineWidth',2)
hold on
grid on
plot(pos,errent,'+-red','LineWidth',2)
legend('Error de test','Error de entrenamiento')
xlabel('Número de clusters')
ylabel('Error cuadrático medio')
end