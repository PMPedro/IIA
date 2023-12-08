//
// Created by pmanu on 06/12/2023.
//

#include "hillclimbing.h"



int calculaValor(Caminho *sol, int size){
    int totalCost = 0;
//calcula valor da solucao
    for(int i = 0; i < size; i++){
        totalCost += sol[i].custo;
    }
    return totalCost;
}

void generateInicialSol(Caminho *data, int size, int k, int partida2, Caminho *Sol){

    /*int partida = data[partida2].to;
    int helper = 0;
    Sol[0] = data[partida2];
    helper ++;*/

    int partida = data[partida2].to;
    Sol[0] = data[partida2];
    int helper = 1;


    for(int i = 0; i < size; i ++){

        if(partida == data[i].from){
            partida = data[i].to;
            Sol[helper] = data[i];
            helper++;
        }

        if(helper == k )
            break;

        printf("debug func partida i [%d %d %d %d]", Sol[i].from,Sol[i].to,Sol[i].custo);
    }
    printf("\n");


}


void hillClimb(Caminho *data, int size, int valork, int ITs ){
//    srand((unsigned int) time(NULL));
    Caminho *Sol = malloc(valork * sizeof (Caminho));

    Caminho *vizinho1 = malloc(valork * sizeof (Caminho));
    Caminho *vizinho2 = malloc(valork * sizeof (Caminho));

    generateInicialSol(data, size, valork, 0, Sol);
    int menor = calculaValor(Sol, valork);
    int vgen1 = 1, vgen2 = 2;
    int i = 0;
    int counter = 0;
   // printf("\n1_>%d", menor);


    while(1){
      //  printf("\n2_> %d", menor);
    generateInicialSol(data, size, valork,vgen1, vizinho1);
    generateInicialSol(data, size, valork, vgen2, vizinho2);

    //gera viznhos para comparar com a melhor solucao
    int valorVizinho1 = calculaValor(vizinho1,valork);
    int valorVizinho2 = calculaValor(vizinho2,valork);



    //verifica qual a melhor sol
    if(menor > valorVizinho1){
        menor = valorVizinho1;
        Sol = vizinho1;
         }
    if(menor > valorVizinho2){
       menor = valorVizinho2;
        Sol = vizinho2;
        }


    if(ITs >= size - valork){
        i = 0;
    }

    if(counter == ITs){
        break;
        }
    i++;
    counter++;
    vgen2++;
    vgen1++;

    if(vgen2 == size - valork){
        vgen1 = 0;
        vgen2 = 1;
        }

    }
   // printf("\nCusto total [%d]", menor);
    for(int j = 0; j < valork; j ++){
        printf("\n[  %d  |  %d  |  %d  ]", Sol[j].from, Sol[j].to, Sol[j].custo);

    }
}




