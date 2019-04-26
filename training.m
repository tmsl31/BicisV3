function M=training(Datos_y,reglas,regresores)
close all
Datos=Datos_y;       % Load Data
cluster=reglas;      % numbers of rules   

%%
%This vector indicated the inputs of the model. 1 is input and NaN is not input.
%eg. y(k)=f(y(k-1),y(k-2),y(k-7))
%then e=[1 1 NaN NaN NaN NaN 1]
nmax=max(regresores);
%Model for Load 
e=NaN*ones(1,nmax);
e(regresores)=1;
% e=[1 1 1 1 NaN*ones(1,87) 1 1 NaN 1 1 NaN NaN NaN 1]; % 
%e=ones(1,96);
%model for eolic
%e=[1 1 NaN NaN 1 NaN*ones(1,45) 1 NaN*ones(1,37) 1 NaN NaN 1 1 NaN 1 NaN*ones(1,4) 1];
%e=ones(1,96);


NY      =  size(e,2);                     % Maximum inputs number of model
tamy    =  length(Datos);                 % Size of Data
%% Data partitions
D_t     =  50;            % Percentage of each set 
D_test  =  20;            
%val=25;

yt     =  Datos(1:round((tamy*D_t)/100));                                        
ytest  =  Datos(round((tamy*D_t)/100)+1:round((tamy*(D_test+D_t))/100));        
yval   =  Datos(round((tamy*(D_test+D_t))/100)+1:tamy);                            
%%
[y_t,y_test,y_val,x_t, x_test, x_val]=Autoregresor(NY, yt, ytest, yval);    % Call of function that organizes data input and output Data based on NY
y  =  y_t;                         % Output Data Training
%y=y_test;
%y=y_val;

X  =  x_t;                        % Input Data Training
% X=x_test;
%X=x_val;
f  = size(X);
%%
%Only inputs of the model
D_EE=ones(f(1),1)*e;
D_C=isnan(X.*D_EE);
i=1;
for w=1:f(1)
    for z=1:NY
        if D_C(w,z)==0
            x_in(w,i)=X(w,z);
            i=i+1;
        end
    end
    i=1;
end
%keyboard
%% Call Takagi-sugeno function
opcion=[1 2 1];                            
[model_E, result_E]=TakagiSugeno(y,x_in,cluster,opcion);
model_E.e = e;

n_input=size(x_in,2);
for i=1:cluster
    for j=1:n_input
        ant=gaussmf(sort(x_in(:,j)),[1./model_E.a(i,j) model_E.b(i,j)]);
        figure(19+i)
        plot(sort(x_in(:,j)),ant,'r');
        hold on
    end
end

beta=model_E.h; 
yE=ysim(x_in,model_E.a,model_E.b,model_E.g);

e_i=y-yE;

[N_R,N_P]=size(model_E.g);

n=N_R*N_P;

e_mean=(e_i'*beta)./sum(beta);

miu=sum(beta.^2);
aux_d=(miu-(n+1));
beta_2=beta.^2;
err_2=(repmat(e_i,[1,N_R])-repmat(e_mean,[f(1),1])).^2;

for j=1:N_R
    std_j(j)=err_2(:,j)'*beta_2(:,j)./(aux_d(j));
end


errorE=sqrt(mean((yE-y).^2));
%% format graphic
figure()
hold on
plot(y,'b')
plot(yE,'r')
legend('Real Output','Model output','Location', 'NorthWest'  );
ylabel('Power[kw]');
xlabel('Time [Hours]');
%xlim([1000-pasos 1450-pasos])
%ylim([4 23])
%%
model_E.ereg=regresores;
%% Outputs
M.model=model_E;
M.model.std_j=std_j;
M.result=result_E;
M.RMSE=errorE;


