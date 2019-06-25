//
// Created by sandra on 24-06-19.
//

#ifndef CODIGOSCPP_CONSTANTESRMPC_H
#define CODIGOSCPP_CONSTANTESRMPC_H

/*
 * Definicion de las constantes a utilizar en el controlador RMPC.
 * La idea seria parsear estos valores a partir de la simulacion en Omnetpp
 */

//Spacing deseado entre las bicicletas.
double Ldes = 3;
//Largo de la bicicleta.
double d = 2;
//Factor de la funcion de costo.
double factX = Ldes + d;
//Velocidad del lider
double vl = 2.7;
//Pesos de los terminos.
double Wx = 1;
double Wv = 1;
double Wu = 1;
//Numero de pasos.
int nPasos = 5;
//Tiempo de muestreo.
double ts = 0.5;
//Ya que no puedo poner igualdades en GA.
//Tolerancia de las desigualdades.
double tolIgualdad = 0.0001;
//Minimos de U
double minU[5] = {1.5,1.5,1.5,1.5,1.5};
double minUAbs[5] = {1.5,1.5,1.5,1.5,1.5};
double maxU[5] = {1,1,1,1,1};
double maxUAbs[5] = {1,1,1,1,1};
// Valores iniciales de posicion y velocidad.
double xActual = 0;
double vActual = 2;
double xiAnterior = 10;
double viAnterior = 2;

#endif //CODIGOSCPP_CONSTANTESRMPC_H
