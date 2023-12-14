#ifndef TP2_AUX_H
#define TP2_AUX_H

#include "stdio.h"
#include "string.h"
#include "math.h"


#endif //TP2_AUX_H
typedef struct {
    int from;
    int to;
    int custo;
} Caminho;

typedef struct {
    int caminhos, valorK, arestas, vertices;
} fichHelper;

fichHelper leDadosInicial(char *filename);

void leDados(Caminho *caminho, int tam, const char *filename);

void check_data(Caminho *data, int size);

void init_rand();

int contarLinhas(const char *nomeArquivo);