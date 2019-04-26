function [y_ent1,y_test1,y_val1,x_ent1, x_test1, x_val1] = Autoregresor( NY, datose, datost,datosv )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%keyboard
na=NY;
D_ent=datose;
D_test=datost;
D_val=datosv;

le=length(D_ent);
lt=length(D_test);
lv=length(D_val);

j=1;
k=0;
w=na+1;

if le~=0
    for z=1:na+1;
        for i=w:length(D_ent)-k
            D_E(j,z)=D_ent(i);
            j=j+1;
        end
        j=1;
        w=w-1;
        k=k+1;
    end
end

j=1;
k=0;
w=na+1;
if lt~=0
    for z=1:na+1;
        for i=w:length(D_test)-k
            D_T(j,z)=D_test(i);
            j=j+1;
        end
        j=1;
        w=w-1;
        k=k+1;
    end
end

j=1;
k=0;
w=na+1;

if lv~=0
    for z=1:na+1;
        for i=w:length(D_val)-k
            D_V(j,z)=D_val(i);
            j=j+1;
        end
        j=1;
        w=w-1;
        k=k+1;
    end
end

    if le~=0
        y_ent1=D_E(:,1);
        x_ent1=D_E(:,2:end);
    else
        y_ent1=[];
        x_ent1=[];
    end

    if lt~=0
        y_test1=D_T(:,1);
        x_test1=D_T(:,2:end);
    else
        y_test1=[];
        x_test1=[];
    end

    if lv~=0
        y_val1=D_V(:,1);
        x_val1=D_V(:,2:end);
    else
        y_val1=[];
        x_val1=[];
    end


end

