function [p, indice]=sensibilidad(yent,Xent,reglas)
%keyboard
%se ingresa número de reglas
%la sálida del modelo: yent
% la matriz con las variables candidatas: Xent
%i: variable de entrada xi, r:numero de regla, j:numero de datos
%normalización de variabldes candidatas
for  i=1:length(Xent(1,:))
    Xent(:,i)=(Xent(:,i)-mean(Xent(:,i)))./std(Xent(:,i));
end
% %normalizacion de salida
yent=(yent-mean(yent))./std(yent);
%se genera el modelo takagi sugeno con el set de entradas cadidatas
%keyboard
[model, result]=TakagiSugeno(yent,Xent,reglas,[1 2]);
% se definen los parametros del modelo obtenido   
a=model.a;% rxi
b=model.b; %rxi
g=model.g; %r x i+1
%mu ixrxj, Xent jxi
%se obtienen los valores de  grado de pertenencia mu
%keyboard
muu=zeros(length(Xent(1,:)),length(a(:,1)),length(Xent(:,1)));
for i=1:length(Xent(1,:))
    for r=1:length(a(:,1))
        for j=1:length(Xent(:,1))
            muu(i,r,j)=exp(-0.5*(a(r,i)*(Xent(j,i)-b(r,i)))^2);
        end
    end
end

%w jxr

 %se obtienen los grados de activación a partir de los mu   
w=ones(length(Xent(:,1)),length(a(:,1)));
for j=1:length(Xent(:,1))
    for r=1:length(a(:,1))
        for i=1:length(Xent(1,:))
            aux=muu(i,r,j);
            w(j,r)=w(j,r)*aux;
        end
    end
end
%c ixrxj
%se obtiene el c asociado a las derivadas
c=zeros(length(Xent(1,:)),length(a(:,1)),length(Xent(:,1)));
for i=1:length(Xent(1,:))
    for r=1:length(a(:,1))
        for j=1:length(Xent(:,1))
            c(i,r,j)=-(a(r,i)*(Xent(j,i)-b(r,i)))*a(r,i);
        end
    end
end
%se obtienen las salidas para cada regla
%yr jxr
yr=[ones(length(Xent(:,1)),1),Xent]*g';

%se obtienen los chi para cada candidata
%chi jxi
chi=zeros(length(Xent(:,1)),length(Xent(1,:)));
suma1=0;
suma2=0;
suma3=0;
suma4=0;

for i=1:length(Xent(1,:))
    for j=1:length(Xent(:,1))
        
        for r=1:length(a(:,1))
            
            suma1=suma1+w(j,r)*c(i,r,j)*yr(j,r)+g(r,i+1)*w(j,r); %ojo con g!!
            suma2=suma2+w(j,r);
            suma3=suma3+w(j,r)*c(i,r,j);
            suma4=suma4+w(j,r)*yr(j,r);
            if suma2^2>1e-10
                chi(j,i)=(suma1*suma2-suma3*suma4)/((suma2)^2);
            else
                chi(j,i)=(suma1*suma2-suma3*suma4);
            end
%             if isnan (chi(j,i))==1
%                 chi(j,i)=0;
%             end
%                
            
        end
        suma1=0;
        suma2=0;
        suma3=0;
        suma4=0;
    end
end
%keyboard
%indice 1 x i
%se obtiene finalmente el indice para cada candidata
indice=zeros(1,length(Xent(1,:)));
for  i=1:length(Xent(1,:))
    indice(i)=mean(chi(:,i))^2+std(chi(:,i))^2;
end
p=find(indice==min(indice));
%se grafican los indices obtenidos para compararse
% figure ()
% bar(indice)
% ylabel('Índice de sensibilidad')
% xlabel('Entrada del modelo')  
end