//
// Created by pmanu on 06/12/2023.
//

#include "hillclimbing.h"


int calculaValor(Caminho *sol, int size){
    int totalCost = 0;
//calcula valor da solucao
    for(int i = 0; i < size; i++){
        totalCost = sol[i].custo;
    }
    return totalCost;
}


void generateNeighbors(Caminho *sol, int size, Caminho *neighbors[2]){
    //gera dois vizinhos aleatorios
    for(int i=0; i < 2; i++){
        for(int j = 0; j < size; j++){
            neighbors[i][j] = sol[j];
        }
    }
//acrescenta e tira 1 ao seu custo
    int randnou = rand() % size;
    neighbors[0][randnou].custo +=1;

    int randnou2 = rand() % size;
    neighbors[1][randnou2].custo -=1;
}


void hillClimb(Caminho *iniSol, int size){
//    srand((unsigned int) time(NULL));

    Caminho *curSol = iniSol;
    int valor = calculaValor(curSol,size);

    while (1){
        Caminho *neigh[2];
        generateNeighbors(curSol, size, neigh);
        int valoNeigh1 = calculaValor(neigh[0], size);
        int valorNeigh2 = calculaValor(neigh[1], size);

        int menor = valoNeigh1;
        int index = 0;
        if(valorNeigh2 < menor){
            menor = valorNeigh2;
            int index = 1;
        }

        if(menor < valor){
            for(int i; i < size; i++){
                curSol[i] = neigh[index][i];
            }
            valor = menor;
        }else{
            break;
        }
    }
    printf("Optimized Solution:\n");
    for (int i = 0; i < size; ++i) {
        printf("from: %d, to: %d, custo: %d\n", curSol[i].from, curSol[i].to, curSol[i].custo);
    }
}



