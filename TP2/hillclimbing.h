//
// Created by pmanu on 06/12/2023.
//

#ifndef TP2_HILLCLIMBING_H
#define TP2_HILLCLIMBING_H

#include "auxili.h"
#include "stdlib.h"
#include "math.h"
#include "time.h"

void generateInicialSol(Caminho *data, int size, int k, int partida, Caminho *Sol);
int calculaValor(Caminho *sol, int size);
void hillClimb(Caminho *data, int size, int valork, int ITs );



#endif //TP2_HILLCLIMBING_H
