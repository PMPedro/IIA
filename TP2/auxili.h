//
// Created by pmanu on 23/11/2023.
//

#ifndef TP2_AUX_H
#define TP2_AUX_H
#include "stdio.h"
#include "string.h"
#include "math.h"


#endif //TP2_AUX_H
typedef struct{
    int from;
    int to;
    int custo;
}Caminho;

typedef struct {
    int valorK;
    int size;
}fichHelper;


fichHelper get_file_size(char *filename);
void getData(Caminho *caminho, int tam, char *filename);

