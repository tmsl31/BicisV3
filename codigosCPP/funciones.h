//
// Created by tlara on 08-06-2019.
//

#ifndef CODIGOSCPP_FUNCIONES_H
#define CODIGOSCPP_FUNCIONES_H

#include "tsType.h"
#include<bits/stdc++.h>
#include "Galgo.hpp"
#include "constantesRMPC.h"


//

//Metodo que inicializa el modelo de Error.
modeloTS inicializarModelo(){

    //Creacion del modelo.
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
    MError.P[0][0][0] = 0.0364;
    MError.P[0][1][0] = 0.0152;
    MError.P[0][2][0] = -0.0038;
    MError.P[1][0][0] = 0.0152;
    MError.P[1][1][0] = 0.1571;
    MError.P[1][2][0] = 0.0008;
    MError.P[2][0][0] = -0.0038;
    MError.P[2][1][0] = 0.0008;
    MError.P[2][2][0] = 0.0088;

    MError.P[0][0][1] = 0.0604;
    MError.P[0][1][1] = 0.0138;
    MError.P[0][2][1] = 0.0600;
    MError.P[1][0][1] = 0.0138;
    MError.P[1][1][1] = 0.0215;
    MError.P[1][2][1] = 0.0141;
    MError.P[2][0][1] = 0.0600;
    MError.P[2][1][1] = 0.0141;
    MError.P[2][2][1] = 0.1781;

    MError.P[0][0][2] = 0.3234;
    MError.P[0][1][2] = -0.0438;
    MError.P[0][2][2] = -0.4371;
    MError.P[1][0][2] = -0.0438;
    MError.P[1][1][2] = 0.0200;
    MError.P[1][2][2] = 0.0768;
    MError.P[2][0][2] = -0.4371;
    MError.P[2][1][2] = 0.0768;
    MError.P[2][2][2] = 0.9007;

    MError.P[0][0][3] = 0.8343;
    MError.P[0][1][3] = -0.9974;
    MError.P[0][2][3] = -0.0918;
    MError.P[1][0][3] = -0.9974;
    MError.P[1][1][3] = 1.6067;
    MError.P[1][2][3] = 0.0212;
    MError.P[2][0][3] = -0.0918;
    MError.P[2][1][3] = 0.0212;
    MError.P[2][2][3] = 0.4902;

    MError.P[0][0][4] = 0.0379;
    MError.P[0][1][4] = -0.0087;
    MError.P[0][2][4] = 0.0043;
    MError.P[1][0][4] = -0.0087;
    MError.P[1][1][4] = 0.0270;
    MError.P[1][2][4] = -0.0063;
    MError.P[2][0][4] = 0.0043;
    MError.P[2][1][4] = -0.0063;
    MError.P[2][2][4] = 0.0239;

    // h
    // mu
    MError.mu = 0.0072;
    //std
    MError.std = 0.3201;
    //Sigma
    MError.sigma[0] = 0.8531;
    MError.sigma[1] = 1.0669;
    MError.sigma[2] = 2.1429;
    MError.sigma[3] = 1.2847;
    MError.sigma[4] = 1.221;

    return MError;
}

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




//DEFINICION  DE LA FUNCION DE COSTOS A 5 PASOS.

template <typename T>
class MyObjective
{
public:
    //Definicion de la funcion objetivo, para el caso del controlador RMPC utilizado se realizan las pruebas utilizando
    //predicciones a cinco pasos, por lo que este es el numero de pasos escogidos para la funcion de costos.

    static std::vector<T> Objective(const std::vector<T>& x)
    {
        if (nPasos = 2){
            T obj = -(Wx*((x[0]-x[2]+factX)^2 + (x[4]-x[6]+factX)^2) + Wv*((x[1]-vl)^2 + (x[5]-vl)^2) + Wu*((x[9]-x[8])^2));

        }
        else if (nPasos == 5){
            T obj = -(Wx*(pow(x[0]-x[2]+factX,2) + pow(x[4]-x[6]+factX,2)+ pow(x[8]-x[10]+factX,2) + pow(x[12]-x[14]+factX,2) + pow(x[16]-x[18]+factX,2)) + Wv*(pow(x[1]-vl,2) + pow(x[5]-vl,2) + pow(x[9]-vl,2) + pow(x[13]-vl,2) + pow(x[17]-vl,2)) + Wu*(pow(x[21]-x[20],2) + pow(x[22]-x[21],2) + pow(x[23]-x[22],2) + pow(x[24]-x[23],2)));
        }

    }
    // NB: GALGO maximize by default so we will maximize -f(x,y)
};

//FUNCION QUE REALIZA LA RESOLUCION DEL PROBLEMA DE OPTIMIZACION.
double solveRMPC (){

    //Modificacion de las restricciones utilizando Takagi Sugeno (comprimir Restricciones)

    //Clase de las restricciones.
    template <typename T>
    std::vector<T> MyConstraint(const std::vector<T>& x)
    {
        return {x[0]*x[1]+x[0]-x[1]+1.5,10-x[0]*x[1]};
    }
    //


}



#endif //CODIGOSCPP_FUNCIONES_H
