//
// Created by tlara on 08-06-2019.
//

#ifndef CODIGOSCPP_FUNCIONES_H
#define CODIGOSCPP_FUNCIONES_H

#include "tsType.h"
#include<bits/stdc++.h>

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


#endif //CODIGOSCPP_FUNCIONES_H
