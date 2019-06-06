//
// Created by tlara on 05-06-2019.
//

#ifndef UNTITLED2_TSTYPES_H
#define UNTITLED2_TSTYPES_H

//Estrutura especifica para el esquema de control desarrollado. No extendible.
struct modeloTS {
    // a: Inverso de varianzas.
    double a[5][2];
    // b: Medias de MF
    double b[5][2];
    // g: Parametros de salida
    double g[5][3];
    double P[3][3][5];
    double h[330][5];
    double mu;
    double std;
    double sigma[5];
} ;

#endif //UNTITLED2_TSTYPES_H