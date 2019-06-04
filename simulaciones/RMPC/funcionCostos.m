function J = funcionCostos(N2,Ldes,vl,Wx,Wv,Wu)
    %Funcion que retorne la función de costos a optimizar por el algoritmo
    %genetico.
    
    %Parametros:
    %N2 -> Horizonte de control.
    
    %Declaracion de las variables globales.
    global d
    %Factor de spacing y longitud de las bicicletas.
    factX = Ldes + d;
    
    %Casos dependiendo del numero de pasos.
    if(N2==2)
        J =@(x) Wx*((x(1)-x(3)+factX)^2 + (x(5)-x(7)+factX)^2) + Wv*((x(2)-vl)^2 + (x(6)-vl)^2) + Wu*((x(10)-x(9))^2);
    elseif(N2==3)
        J =@(x) Wx*((x(1)-x(3)+factX)^2 + (x(5)-x(7)+factX)^2+ (x(9)-x(11)+factX)^2) + Wv*((x(2)-vl)^2 + (x(6)-vl)^2 +(x(10)-vl)^2) + Wu*((x(14)-x(13))^2 + (x(15)-x(14))^2);
    elseif(N2 == 4)
        J =@(x) Wx*((x(1)-x(3)+factX)^2 + (x(5)-x(7)+factX)^2+ (x(9)-x(11)+factX)^2 + (x(13)-x(15)+factX)^2) + Wv*((x(2)-vl)^2 + (x(6)-vl)^2 +(x(10)-vl)^2 + (x(14)-vl)^2) + Wu*((x(18)-x(17))^2 + (x(19)-x(18))^2 + (x(20)-x(19))^2);
    elseif(N2 == 5)
        J =@(x) Wx*((x(1)-x(3)+factX)^2 + (x(5)-x(7)+factX)^2+ (x(9)-x(11)+factX)^2 + (x(13)-x(15)+factX)^2 + (x(17)-x(19)+factX)^2) + Wv*((x(2)-vl)^2 + (x(6)-vl)^2 +(x(10)-vl)^2 + (x(14)-vl)^2 + (x(18)-vl)^2) + Wu*((x(22)-x(21))^2 + (x(23)-x(22))^2 + (x(24)-x(23))^2 + (x(25)-x(24))^2);
    elseif(N2 == 6)
        J =@(x) Wx*((x(1)-x(3)+factX)^2 + (x(5)-x(7)+factX)^2+ (x(9)-x(11)+factX)^2 + (x(13)-x(15)+factX)^2 + (x(17)-x(19)+factX)^2 + (x(21)-x(23)+factX)^2) + Wv*((x(2)-vl)^2 + (x(6)-vl)^2 +(x(10)-vl)^2 + (x(14)-vl)^2 + (x(18)-vl)^2 + (x(22)-vl)^2) + Wu*((x(26)-x(25))^2 + (x(27)-x(26))^2 + (x(28)-x(27))^2 + (x(29)-x(28))^2+(x(30)-x(29))^2);
    elseif(N2 == 7)
        J =@(x) Wx*((x(1)-x(3)+factX)^2 + (x(5)-x(7)+factX)^2+ (x(9)-x(11)+factX)^2 + (x(13)-x(15)+factX)^2 + (x(17)-x(19)+factX)^2 + (x(21)-x(23)+factX)^2 + (x(25)-x(27)+factX)^2) + Wv*((x(2)-vl)^2 + (x(6)-vl)^2 +(x(10)-vl)^2 + (x(14)-vl)^2 + (x(18)-vl)^2 + (x(22)-vl)^2 + (x(26)-vl)^2) + Wu*((x(30)-x(29))^2 + (x(31)-x(30))^2 + (x(32)-x(31))^2 + (x(33)-x(32))^2+(x(34)-x(33))^2+(x(35)-x(34))^2);
    elseif(N2 == 8)
        %Arreglar el 8
        J =@(x) Wx*((x(1)-x(3)+factX)^2 + (x(5)-x(7)+factX)^2+ (x(9)-x(11)+factX)^2 + (x(13)-x(15)+factX)^2 + (x(17)-x(19)+factX)^2 + (x(21)-x(23)+factX)^2 + (x(25)-x(27)+factX)^2 + (x(29)-x(30)+factX)^2) + Wv*((x(2)-vl)^2 + (x(6)-vl)^2 +(x(10)-vl)^2 + (x(14)-vl)^2 + (x(18)-vl)^2 + (x(22)-vl)^2 + (x(26)-vl)^2 + (x(30)-vl)^2) + Wu*((x(34)-x(33))^2 + (x(35)-x(34))^2 + (x(36)-x(35))^2 + (x(37)-x(36))^2+(x(38)-x(37))^2+(x(39)-x(38))^2 + (x(40)-x(39))^2);
    elseif(N2 == 9)
        J =@(x) Wx*((x(1)-x(3)+factX)^2 + (x(5)-x(7)+factX)^2+ (x(9)-x(11)+factX)^2 + (x(13)-x(15)+factX)^2 + (x(17)-x(19)+factX)^2 + (x(21)-x(23)+factX)^2 + (x(25)-x(27)+factX)^2 + (x(29)-x(31)+factX)^2 + (x(33)-x(35)+factX)^2)...
                + Wv*((x(2)-vl)^2 + (x(6)-vl)^2 +(x(10)-vl)^2 + (x(14)-vl)^2 + (x(18)-vl)^2 + (x(22)-vl)^2 + (x(26)-vl)^2 + (x(30)-vl)^2 + (x(34)-vl)^2)...
                + Wu*((x(38)-x(37))^2 + (x(39)-x(38))^2 + (x(40)-x(39))^2 + (x(41)-x(40))^2+(x(42)-x(41))^2+(x(43)-x(42))^2 + (x(44)-x(43))^2 + (x(45)-x(44))^2);
    elseif(N2==10)
        J =@(x) Wx*((x(1)-x(3)+factX)^2 + (x(5)-x(7)+factX)^2 + (x(9)-x(11)+factX)^2 + (x(13)-x(15)+factX)^2 + (x(17)-x(19)+factX)^2 + (x(21)-x(23)+factX)^2 + (x(25)-x(27)+factX)^2 + (x(29)-x(31)+factX)^2 + (x(33)-x(35)+factX)^2 + (x(37)-x(39)+factX)^2) ...
                + Wv*((x(2)-vl)^2 + (x(6)-vl)^2 + (x(10)-vl)^2 + (x(14)-vl)^2 + (x(18)-vl)^2 + (x(22)-vl)^2 + (x(26)-vl)^2 + (x(30)-vl)^2 + (x(34)-vl)^2 + (x(38)-vl)^2) ...
                + Wu*((x(42)-x(41))^2 + (x(43)-x(42))^2 + (x(44)-x(43))^2 + (x(45)-x(44))^2 + (x(46)-x(45))^2 + (x(47)-x(46))^2 + (x(48)-x(47))^2 + (x(49)-x(48))^2 + (x(50)-x(49))^2);
    else
        disp('Numero de pasos no implementado');
    end
end