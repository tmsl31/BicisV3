#include <iostream>
#include "tsType.h"
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


int main() {
    cout << "Hello, World!\n";
    //Declaracion del modelo TS.
    modeloTS MError;
    //Parametros del modelo de Takagi & Sugeno.
    // A.
    MError.a[0][0] = 1.2459;
    MError.a[0][1] = 0.4140;
    MError.a[1][0] = 0.8229;
    MError.a[1][1] = 1.0407;
    MError.a[2][0] = 0.5744;
    MError.a[2][1] = 2.6061;
    MError.a[3][0] = 2.126;
    MError.a[3][1] = 0.9575;
    MError.a[4][0] = 0.9914;
    MError.a[4][1] = 0.5358;
    // B.
    MError.b[0][0] = 0.0382;
    MError.b[0][1] = -0.0229;
    MError.b[1][0] = -0.4287;
    MError.b[1][1] = -0.3855;
    MError.b[2][0] = -0.0065;
    MError.b[2][1] = 0.7081;
    MError.b[3][0] = 0.7455;
    MError.b[3][1] = 0.4190;
    MError.b[4][0] = 0.2164;
    MError.b[4][1] = -0.3254;
    //g
    MError.g[0][0] = -0.0466;
    MError.g[0][1] = 0.4842;
    MError.g[0][2] = -0.0179;
    MError.g[1][0] = -0.0562;
    MError.g[1][1] = 0.4044;
    MError.g[1][2] = -0.0031;
    MError.g[2][0] = 0.1970;
    MError.g[2][1] = 0.2569;
    MError.g[2][2] = -0.3562;
    MError.g[3][0] = -0.1258;
    MError.g[3][1] = 0.7206;
    MError.g[3][2] = -0.0211;
    MError.g[4][0] = -0.0432;
    MError.g[4][1] = 0.4960;
    MError.g[4][2] = -0.0217;
    // P
    // h
    // mu
    MError.mu = 0.0072;
    //std
    MError.std = 0.3201;
    //Sigma
    double valorSigma[5] = {0.8531,1.0669,2.1429,1.2847,1.221};
    MError.sigma[0,1,2,3,4] = valorSigma[0,1,2,3,4];
    double prueba;
    double X[2] = {0.1,0.1};
    prueba = evaluacionTS(X,MError);
    cout << prueba;
    return 0;
}
