//
// Created by pmanu on 27/11/2023.
//

#ifndef TP2_FUNCTIONS_H
#define TP2_FUNCTIONS_H

#include "auxili.h"
#include "string.h"
#include "stdlib.h"

/*
void melhorSol (int cA, Caminho *Data, int ITs, Caminho *Sol, int Tam, int partida, int rep);
void custo_minimo(Caminho *Data, int tam, int partida, int Its,int custoAntigo, int fc, int rep);*/
void analizaSols(Caminho **Sols, int x, int y);

void encontraSol(Caminho *data, int size, int Its);
//void encontraSolucao(int Its, Caminho *data, int size, int partida);



#endif //TP2_FUNCTIONS_H

