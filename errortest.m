function err=errortest(yent,Xent,ytest,Xtest,reglas)
[model, result]=TakagiSugeno(yent,Xent,reglas,[2 4 2]);
y=ysim(Xtest,model.a,model.b,model.g);
err=sqrt(mean((y-ytest).^2));
end