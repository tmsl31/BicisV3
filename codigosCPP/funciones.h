//
// Created by tlara on 08-06-2019.
//

#ifndef CODIGOSCPP_FUNCIONES_H
#define CODIGOSCPP_FUNCIONES_H

#include "tsType.h"
#include<bits/stdc++.h>
#include "Galgo.hpp"
#include "constantesRMPC.h"
#include <vector>

/*
 * Funciones de GALGO.
 */

//Definicion de la funcion objetivo
template <class T>
class MyObjective
{
public:
    //Definicion de la funcion objetivo, para el caso del controlador RMPC utilizado se realizan las pruebas utilizando
    //predicciones a cinco pasos, por lo que este es el numero de pasos escogidos para la funcion de costos.

    static std::vector<T> Objective(const std::vector<T>& x)
    {
        // NB: GALGO maximize by default so we will maximize -f(x,y)
        T obj = -(Wx*(pow(x[0]-x[2]+factX,2) + pow(x[4]-x[6]+factX,2)+ pow(x[8]-x[10]+factX,2) + pow(x[12]-x[14]+factX,2) + pow(x[16]-x[18]+factX,2)) + Wv*(pow(x[1]-vl,2) + pow(x[5]-vl,2) + pow(x[9]-vl,2) + pow(x[13]-vl,2) + pow(x[17]-vl,2)) + Wu*(pow(x[21]-x[20],2) + pow(x[22]-x[21],2) + pow(x[23]-x[22],2) + pow(x[24]-x[23],2)));

    }//Fin de static.
};//Fin de Public.

template<typename T>
std::vector<T> MyConstraint(const std::vector<T> &x) {
    //Restricciones deben ser colocadas en la forma f(vec(x)) <= 0.
    return { //Limites inferiores aceleracion
            -1 * x[20] - minU[0],
            -1 * x[21] - minU[1],
            -1 * x[22] - minU[2],
            -1 * x[23] - minU[3],
            -1 * x[24] - minU[4],
            -1 * x[25] - minU[0],
            -1 * x[26] - minU[1],
            -1 * x[27] - minU[2],
            -1 * x[28] - minU[3],
            -1 * x[29] - minU[4],
            //Limites superiores aceleracion.
            x[20] - maxU[0],
            x[21] - maxU[1],
            x[22] - maxU[2],
            x[23] - maxU[3],
            x[24] - maxU[4],
            x[25] - maxU[0],
            x[26] - maxU[1],
            x[27] - maxU[2],
            x[28] - maxU[3],
            x[29] - maxU[4],
            //Condiciones de igualdad.
            //Variables conocidas.
            x[0] - xActual - ts * vActual - tolIgualdad,
            x[1] - x[20] - vActual - tolIgualdad,
            x[2] - xiAnterior - ts * viAnterior - tolIgualdad,
            x[3] - x[25] - viAnterior - tolIgualdad,
            //Restricciones de posicion.
            -1*x[0] - x[1] + x[4] - tolIgualdad,
            -1*x[2] - x[3] + x[6] - tolIgualdad,
            -1*x[4] - x[5] + x[8] - tolIgualdad,
            -1*x[6] - x[7] + x[10] - tolIgualdad,
            -1*x[8] - x[9] + x[12] - tolIgualdad,
            -1*x[10] - x[11] + x[14] - tolIgualdad,
            -1*x[12] - x[13] + x[16] - tolIgualdad,
            -1*x[14] - x[15] + x[18] - tolIgualdad,
            //Restricciones de velocidad.
            -1*x[1] + x[5] - x[21] - tolIgualdad,
            -1*x[3] + x[7] - x[26] - tolIgualdad,
            -1*x[5] + x[9] - x[22] - tolIgualdad,
            -1*x[7] + x[11] - x[27] - tolIgualdad,
            -1*x[9] + x[13] - x[23] - tolIgualdad,
            -1*x[11] + x[15] - x[28] - tolIgualdad,
            -1*x[13] + x[18] - x[24] - tolIgualdad,
            -1*x[15] + x[21] - x[29] - tolIgualdad,
            //Limite inferior delta U.
            //             x[20] - x[21] - 1.5,
            //             x[21] - x[22] - 1.5,
            //             x[22] - x[23] - 1.5,
            //             x[23] - x[24] - 1.5,
            //             x[24] - x[25] - 1.5,
            //             x[25] - x[26] - 1.5,
            //             x[26] - x[27] - 1.5,
            //             x[27] - x[28] - 1.5,
            //             x[28] - x[29] - 1.5,
            //             //Limite superior delta U.
            //             x[21] - x[20] - 0.75,
            //             x[22] - x[21] - 0.75,
            //             x[23] - x[22] - 0.75,
            //             x[24] - x[23] - 0.75,
            //             x[25] - x[24] - 0.75,
            //             x[26] - x[25] - 0.75,
            //             x[27] - x[26] - 0.75,
            //             x[28] - x[27] - 0.75,
            //             x[29] - x[28] - 0.75,
            //             // Fin de las desigualdades.
    };
}





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
    //int nParametros = 3;
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
    double suma1 = 0;
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
            suma1 = suma1 + i;
        }
        for (double & i : W) {
            i = i / suma1;
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






//FUNCION QUE REALIZA LA RESOLUCION DEL PROBLEMA DE OPTIMIZACION.

//Funcion que actualiza el buffer de error.
void actualizarBufferError(double bufferError[5], double nuevoError){
    //Funcion que actualiza el buffer de error.

    //Re asignacion de valores antiguos.
    bufferError[1] = bufferError[0];
    bufferError[2] = bufferError[1];
    bufferError[3] = bufferError[2];
    bufferError[4] = bufferError[3];
    //Asignacion del nuevo valor.
    bufferError[0] = nuevoError;
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

//Metodo que realiza la modificacion de las desigualdades.
void modDesigualdades(intervalos2 intervalosError){
        // Metodo que recibe los intervalos de error y modifica las restricciones de desigualdad para la resolucion del
        // poblema de optimizacion de RMPC.

        //Modificacion de limites inferiores.
        minU[0] = minUAbs[0] + intervalosError.inferior[0];
        minU[1] = minUAbs[1] + intervalosError.inferior[1];
        minU[2] = minUAbs[2] + intervalosError.inferior[2];
        minU[3] = minUAbs[3] + intervalosError.inferior[3];
        minU[4] = minUAbs[4] + intervalosError.inferior[4];
        //Modificacion de los limites superiores.
        maxU[0] = maxUAbs[0] + intervalosError.superior[0];
        maxU[1] = maxUAbs[1] + intervalosError.superior[1];
        maxU[2] = maxUAbs[2] + intervalosError.superior[2];
        maxU[3] = maxUAbs[3] + intervalosError.superior[3];
        maxU[4] = maxUAbs[4] + intervalosError.superior[4];
        };

void modDatos(double xi, double vi, double xAnterior,  double vAnterior){
    //Metodo que modifique los datos con el fin de definir las igualdades.

    //Propia bicicleta.
    xActual = xi;
    vActual = vi;
    //Bicicleta de adelante.
    xiAnterior = xAnterior;
    viAnterior = vAnterior;
}


double solveRMPC (double xi, double vi, double xAnterior,  double vAnterior, double vLider, double errorAnterior, modeloTS model, double Ldes, double bufferError[5], int contador, double alpha){
    //Funcion que realiza la resolucion del problema de optimizacion.

    /* Parametros:_
     * xi -> Posicion de la bicicleta i (misma)
     * vi -> Velocidad de la bicicleta i (misma).
     * xAnterior -> Posicion de la bicicleta anterior.
     * vAnterior -> Velocidad de la bicicleta anterior.
     * errorAnterior -> Error de actuacion en k-1.
     * model -> Estructura que contenga los parametros del modelo de Takagi-Sugeno.
     * nPasos -> Numero de pasos de prediccion del controlador RMPC.
     * Ldes -> Spacing deseadi,
     * bufferError -> Variable global, buffer que almacena los cinco ultimos valores del error.
     * contador -> Contador del numero de iteracion, para ver cuando empezar a predecir.
     */

    //Definicion de variables.
    intervalos2 intervalosPasos;  // Variable que almacene los intervalos.
    double buffer[5];             // Copia del buffer de errores.
    double uDes;                  // Salida. Aceleracion deseada.

    //Actualizacion del buffer de error.
    actualizarBufferError(bufferError,errorAnterior);
    //Calcular prediccion si el contador llega a la sexta iteracion.
    if (contador >= 6){
        //Copiar buffer de error.
        buffer[0] = bufferError[0];
        buffer[1] = bufferError[1];
        buffer[2] = bufferError[2];
        buffer[3] = bufferError[3];
        buffer[4] = bufferError[4];
        // Calculo de los intervalos.
        intervalosPasos = intervalosSimulacion(model, nPasos, buffer, alpha);
        //Definicion de la funcion objetivo a utilizar.
        //(Cambio velocidad del lider).
        vl = vLider;
        //Definicion de las igualdades a incluir en las restricciones.
        //(Actualizacion de los valores anteriores).
        modDatos(double xi, double vi, double xAnterior,  double vAnterior);

        //Compresion de las desigualdades
        // (modificacion de los limites.
        modDesigualdades(intervalosPasos);
        //Optimizacion.
        //Definicion de los parametros a ingresar. 24
        double par1[25] = {xi,vi,xi,vi,xi,vi,xi,vi,xi,vi,xi,vi,xi,vi,xi,vi,xi,vi,xi,vi,0.5,0.5,0.5,0.5,0.5};
        // Inicializar algoritmo genetico.
        galgo::GeneticAlgorithm<double> ga(MyObjective<double>::Objective,100,50,true,par1);
        // Fijar las restricciones.
        ga.Constraint = MyConstraint;
        //Correr el algoritmo
        uDes = ga.run();
        return uDes;

    }//Fin de if.
    else{
        uDes = 0;
        return uDes;
    }
    //Aumentar el contador de iteraciones.
    contador += 1;



}// Fin de la funcion solveRMPC.

//Metodo para  la solucion a partir de algoritmos geneticos.
double solveGA(){

}


#endif //CODIGOSCPP_FUNCIONES_H
