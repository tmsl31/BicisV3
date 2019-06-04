function [bdes2] = comprimirRestricciones(bdes,Iinf,Isup)
    % Funcion que comprima las restricciones de acuerdo a la determinacion
    % de parametros del modelo de Takagi - Sugeno
    
    
    %Creacion de bdes2.
    bdes2 = zeros(size(bdes));
    
    %Numero de pasos
    nPasos = (length(bdes)+4)/8;
    
    %Cotas inferiores.
    nCotasInf = nPasos * 2;
    
    %Modificacion de la cota inferior.
    count = 1;
    for cotaInf = Iinf'
        countAux = count;
        while(countAux <= nCotasInf) 
            bdes2(countAux) = bdes(countAux) + cotaInf;%????????
            countAux = countAux + 2;
        end
        count = count + 1;
    end
    
    %Modificacion de la cota superior.
    count2 = nCotasInf + 1;
    for cotaSup = Isup'
        countAux = count2;
        while(countAux <= nCotasInf*2)
            bdes2(countAux) = bdes(countAux) - cotaSup;
            countAux = countAux + 2;
        end
        count2 = count2 + 1;
    end
    
    %Copiar el resto
    bdes2(2*nCotasInf+1:end) = bdes(2*nCotasInf+1:end);
end