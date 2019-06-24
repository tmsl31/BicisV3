#include <iostream>
#include "tsType.h"
#include "funciones.h"
#include "Galgo.hpp"
#include <cmath>
#include "constantesRMPC.h"
using namespace std;






/*
 * Funcionamiento del algoritmo genetico.
 */



// NB: a penalty will be applied if one of the constraints is > 0
// using the default adaptation to constraint(s) method


/*
 * Metodos.
 */

// Funcion que calcule los intervalos a usar para la simulacion.
intervalos2 intervalosSimulacion(modeloTS model, int nPasos, double buffer[5],double alpha){

    //Definiciones
    double X[2];
    intervalos aux;
    intervalos2 output;

    //Entradas un paso.
    X[0] = buffer[0];
    X[1] = buffer[1];

    if (nPasos >= 1){
        aux = defIntervalo(model,alpha,X);
        output.inferior[0] = aux.inferior;
        output.superior[0] = aux.superior;
    }
    if (nPasos >= 2){
        double ek = evaluacionTS(X,model);
        //Actualizar buffer.
        buffer[0] = buffer[1];
        buffer[1] = buffer[2];
        buffer[2] = buffer[3];
        buffer[3] = buffer[4];
        buffer[4] =  ek;
        //Entrada
        X[0] = buffer[0];
        X[1] = buffer[1];
        //Calculo intervalos
        aux = defIntervalo(model,alpha,X);
        output.inferior[1] = aux.inferior;
        output.superior[1] = aux.superior;
    }
    if (nPasos >= 3) {
        double ek = evaluacionTS(X,model);
        //Actualizar buffer.
        buffer[0] = buffer[1];
        buffer[1] = buffer[2];
        buffer[2] = buffer[3];
        buffer[3] = buffer[4];
        buffer[4] =  ek;
        //Entrada
        X[0] = buffer[0];
        X[1] = buffer[1];
        //Calculo intervalos
        aux = defIntervalo(model,alpha,X);
        output.inferior[2] = aux.inferior;
        output.superior[2] = aux.superior;
    }
    if (nPasos >= 4){
        double ek = evaluacionTS(X,model);
        //Actualizar buffer.
        buffer[0] = buffer[1];
        buffer[1] = buffer[2];
        buffer[2] = buffer[3];
        buffer[3] = buffer[4];
        buffer[4] =  ek;
        //Entrada
        X[0] = buffer[0];
        X[1] = buffer[1];
        //Calculo intervalos
        aux = defIntervalo(model,alpha,X);
        output.inferior[3] = aux.inferior;
        output.superior[3] = aux.superior;
    }
    if (nPasos >= 5){
        double ek = evaluacionTS(X,model);
        //Actualizar buffer.
        buffer[0] = buffer[1];
        buffer[1] = buffer[2];
        buffer[2] = buffer[3];
        buffer[3] = buffer[4];
        buffer[4] =  ek;
        //Entrada
        X[0] = buffer[0];
        X[1] = buffer[1];
        //Calculo intervalos
        aux = defIntervalo(model,alpha,X);
        output.inferior[4] = aux.inferior;
        output.superior[4] = aux.superior;
    }
    return output;
}

//


/*
 * MAIN
 */
int main() {
    cout << "Pruebas.\n";
    //Declaracion del modelo TS.
    modeloTS MError = inicializarModelo();
    intervalos prueba;
    double X[2] = {1,2};
    prueba = defIntervalo(MError, 0.5 , X);
    cout << prueba.superior << '\n';
    cout << prueba.inferior << '\n';
    return 0;
}

