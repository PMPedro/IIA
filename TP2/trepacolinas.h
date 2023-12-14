#ifndef TREPACOLINAS_H
#define TREPACOLINAS_H

#include <time.h>
#include <stdlib.h>
#include <stdio.h>
#include "auxili.h"
#include <stdbool.h>

void geraSolInicial(int *solucao, int tam);
bool solucaoValida(Caminho *caminho, int tam, int *sol);
int avaliaSolucao(Caminho *caminhos, int tam, int *solucao);
void vizinhancaTroca(int *solucao, int tam);
void vizinhancaReparacao(int *solucao, int tam, Caminho *caminhos, int valorK);
void trepaColinas(Caminho *caminhos, int tam, int valorK, int Its);
void recombinacao (int tam, int crossover, int *sol1, int *sol2, int *solatual);
void trepaColinasEvolutivo(Caminho *caminhos, int tam, int valorK, int Its);


#endif /* TREPACOLINAS_H */
