#include <iostream>
#include "tsType.h"
#include "funciones.h"
#include <cmath>

using namespace std;

/*
 * Metodos.
 */

//Evaluacion de la funcion de gauss.
double gauss(double mu,double sigma,double x){
    double factor;
    double output;
    factor = pow((sigma*(x-mu)),2);
    output = exp(-0.5 * factor);
    return output;
}

//Evaluacion de TS.
double evaluacionTS(double X[2] , modeloTS model){
    // Inputs:
    // X-> Vector de entrada.
    // model -> Modelo de Takagi Sugeno.

    //Definiciones de variables.
    int nEntradas = 2;
    int nReglas = 5;
    int nParametros = 3;
    double W[5] =  {1,1,1,1,1};
    double suma = 0;
    double mu[nReglas][nEntradas];
    double YPredict = 0;

    //Calculo.
    for (int regla = 0; regla < nReglas; regla++){
        //Por cada regla.
        for (int entrada = 0; entrada < nEntradas; entrada ++){
            //Por cada entrada.
            mu[regla][entrada] = gauss(model.b[regla][entrada],model.a[regla][entrada],X[entrada]);
            W[regla] = W[regla] * mu[regla][entrada];
        }
    }
    //Normalizacion
    if (!((W[0] ==0) & (W[1] ==0) & (W[2] ==0) & (W[3] ==0) & (W[4] ==0))){
        for (double i : W) {
            suma = suma + i;
        }
        for (double & i : W) {
            i = i / suma;
        }
    }
    // Calcular la prediccion
    double aux[3] = {1, X[0], X[1]};
    double yr[5];
    for (int i = 0; i < nReglas; i++) {
        yr[i] = model.g[i][0] * aux[0] + model.g[i][1] * aux[1] + model.g[i][2] * aux[2];
    }
    for (int i = 0; i < nReglas; i++) {
        YPredict = YPredict + W[i] * yr[i];
    }
    return YPredict;
}

//Funcion que calcule el valor de I para una entrada.
double incerteza(double X[2],modeloTS model){
    //
    //Declaracion de variables a utilizar.
    int nEntradas = 2;
    int nParametros = 3;
    int nReglas = 5;
    double W[5] =  {1,1,1,1,1};
    double mu[nReglas][nEntradas];
    double suma = 0;
    double phiT[nReglas][nParametros];
    double Ir[nReglas];

    // Vector de entrada con factor Bias.
    double z[3] = {1,X[0],X[1]};
    //Calculo de los grados de activacion.
    for (int regla = 0; regla < nReglas; regla++) {
        //Por cada regla.
        for (int entrada = 0; entrada < nEntradas; entrada++) {
            //Por cada entrada.
            mu[regla][entrada] = gauss(model.b[regla][entrada], model.a[regla][entrada], X[entrada]);
            W[regla] = W[regla] * mu[regla][entrada];
        }
    }
    //Normalizacion de los grados de activacion.
    if (!((W[0] ==0) & (W[1] ==0) & (W[2] ==0) & (W[3] ==0) & (W[4] ==0))){
        for (double i : W) {
            suma = suma + i;
        }
        for (double & i : W) {
            i = i / suma;
        }
    }
    //Proyeccion de la entrada.
    for (int i = 0; i<nReglas; i++){
        // Llenar vector
        phiT[i][0] = W[i] * z[0];
        phiT[i][1] = W[i] * z[1];
        phiT[i][2] = W[i] * z[2];
    }

    //Valores Ir.
    for (int count = 0; count < nReglas; count ++){
        //Por cada regla.
        //Valor de sigma.
        double valorSigma = model.sigma[count];
        //Calculo del factor.
        //P * phiT.
        double factor[3];
        for (int i= 0; i< nParametros; i++){
            double suma = 0;
            for(int j=0; j< nParametros; j++){
                suma = suma + model.P[i][j][count] * phiT[count][j];
            }
            factor[i] = suma;
        }

        double factor2 = 0;
        for (int i = 0;i<3;i++){
            factor2 = factor2 + phiT[count][i] * factor[i];
        }
        double factor3 = pow((1+factor2),2);
        Ir[count] = valorSigma * factor3;
    }
    //Calculo de I para la entrada
    double I = 0;
    for (int i =0;i<nReglas;i++){
        I = I + W[i] * Ir[i];
    }
    return I;
}

//Funcion que calcule los intervalos.
intervalos defIntervalo(modeloTS model, double alpha, double X[2]){

    //Definiciones de variables.
    double YPredict;
    double I;
    intervalos Ints;
    //Calculo de la prediccion con el modelo de Takagi & Sugeno.
    YPredict = evaluacionTS(X,model);
    //Calculo de la incerteza.
    I = incerteza(X,model);
    //Calculo de los intervalos.
    Ints.inferior = YPredict - alpha * I;
    Ints.superior = YPredict + alpha * I;
    //Output.
    return Ints;
}

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
    cout << "Hello, World!\n";
    //Declaracion del modelo TS.
    modeloTS MError = inicializarModelo();
    intervalos prueba;
    double X[2] = {1,2};
    prueba = defIntervalo(MError, 0.5 , X);
    cout << prueba.superior << '\n';
    cout << prueba.inferior << '\n';
    return 0;
}

