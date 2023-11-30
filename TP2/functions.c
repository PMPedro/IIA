//
// Created by pmanu on 27/11/2023.
//

#include <stdbool.h>
#include "functions.h"


void encontraSol (Caminho *data, int size, int Its){
    int i = 0, partida = 0, sol = 0;

        int counter = 0;
    partida = data[counter].from;
    counter++;
    Caminho *solEncontrado = malloc(Its * sizeof(Caminho));
    Caminho  **soluencontrada;
    int x = 0,y = 0;
    while (i < size){




        if(partida == data[i].from){ //se encontrar um caminho possivel, associao ao melhor caminho, aumenta o sol e recomeça
            partida = data[i].to;
            solEncontrado[sol].from = data[i].from;
            solEncontrado[sol].to = data[i].to;
            solEncontrado[sol].custo = data[i].custo;
            sol++;
            i = 0;
        }


        if(sol > Its){
            partida = data[counter].from;
            counter++;

            for(int a=a; a < sol; a++){
            soluencontrada[x][y].from = solEncontrado[a].from;
            soluencontrada[x][y].from = solEncontrado[a].to;
            soluencontrada[x][y].from = solEncontrado[a].;
            }

        }



        i++;
    }

}