#include <stdbool.h>
#include "functions.h"

//funcao para encontrar todas as sols possiveis
void encontraSol(Caminho *data, int size, int Its) {
    int i = 0, partida = 0, sol = 0;

    int counter = 0;
    partida = data[counter].from;
    counter++;
    Caminho *solEncontrado = malloc(Its * sizeof(Caminho));
    Caminho **soluencontrada = malloc(size * sizeof(Caminho *)); // Fix: Allocate memory for soluencontrada
    for (int i = 0; i < size; i++) {
        soluencontrada[i] = malloc(Its * sizeof(Caminho));
    }
    int x = 0, y = 0;

    printf("\nA Pensar...");

    while (i < size) {

        if (partida ==
            data[i].from) { //se encontrar um caminho possivel, associao ao melhor caminho, aumenta o sol e recomeça
            if (sol == Its) {}
            else {
                partida = data[i].to;
                solEncontrado[sol].from = data[i].from;
                solEncontrado[sol].to = data[i].to;
                solEncontrado[sol].custo = data[i].custo;
                sol++;
                i = 0;
            }

        }


        if (sol == Its) { //caso ja tenha encontrado as x soluções
            counter++;
            partida = data[counter].from;
            for (int a = 0; a < sol; a++) {
                soluencontrada[x][y].from = solEncontrado[a].from;
                soluencontrada[x][y].to = solEncontrado[a].to;
                soluencontrada[x][y].custo = solEncontrado[a].custo;
                y++;
            }
            x++;
            i = 0;
            y = 0;
            sol = 0;
        }

        if (i == size - 1) {
            i = 0;
            counter++;
            partida = data[counter].from;
        }

        if (counter == (size - Its)) {
            break;

        }

        i++;
        printf(".");
    }
    analizaSols(soluencontrada, x, Its);
}

//analisa todas as sols encontradas e envia a que tem menor custo
void analizaSols(Caminho **Sols, int x, int y) {
    int guardax = 0, custo = 0, menor = 1000000;

    for (int i = 0; i <= x; i++) {
        for (int j; j < y; j++) {
            if (Sols[i][y].from == 0) {

            } else {
                custo = Sols[i][y].custo + custo;
            }

        }
        if (custo < menor) {
            menor = custo;
            guardax = i;
        }

    }
    custo = 0;
    for (int l = 0; l < y; l++) {
        printf("\n[D:  %d  |P:  %d  |C:  %d  ]", Sols[guardax][l].from, Sols[guardax][l].to, Sols[guardax][l].custo);
        custo = Sols[guardax][l].custo + custo;

    }
    printf("\nCom custo [%d]", custo);
}