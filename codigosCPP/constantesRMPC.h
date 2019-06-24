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

#endif //CODIGOSCPP_CONSTANTESRMPC_H
