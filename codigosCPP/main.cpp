#include <iostream>
#include "tsType.h"
#include "funciones.h"
#include "Galgo.hpp"
#include <cmath>
#include "constantesRMPC.h"
using namespace std;





// NB: a penalty will be applied if one of the constraints is > 0
// using the default adaptation to constraint(s) method




/*
 * Definicion de variables globales.
 */
double bufferError[5] = {0,0,0,0,0};
int contador = 1;


// NB: a penalty will be applied if one of the constraints is > 0
// using the default adaptation to constraint(s) method


/*
 * Metodos.
 */



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

