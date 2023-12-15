#include <stdio.h>
#include <stdlib.h>
#include "trepacolinas.h"

int main() {
    char filename[50];
    int op;
    printf("Introduza o nome do ficheiro: ");
    gets(&filename);

    FILE* fpcheck;
    fpcheck = fopen(filename, "r");
    if(!fpcheck){
        perror("\nEsse ficheiro e invalido!");
        return -1;
    }


    // Menu
    printf("1- Trepa Colinas\n");
    printf("2- Algoritmo Evolutivo\n");
    printf("3- Algoritmo Hibrido\n");

    printf("Escolha uma opcao: ");
    scanf("%d", &op);

    // Inicia números aleatórios
    init_rand();

    if (op == 1) {
        fichHelper fh;
        fh = leDadosInicial(filename);
        fh.caminhos = contarLinhas(filename) - 2; // 2 por causa do k e do p edges
        Caminho *data = malloc(fh.caminhos * sizeof(Caminho));
        if (data == NULL) {
            perror("Erro na alocação de memória");
            return -1;
        }

        leDados(data, fh.caminhos, filename);

        // Chama a função Trepa Colinas
        int Its;
        printf("\nQts Its? \n\t:"); scanf("%d",&Its);
        trepaColinas(data, fh.caminhos, fh.valorK,Its);

        free(data);
    } else if (op == 2) {
        // Adicione código para a opção 2 (Algoritmo Evolutivo) aqui, se necessário

        fichHelper fh;
        fh = leDadosInicial(filename);
        fh.caminhos = contarLinhas(filename) - 2; // 2 por causa do k e do p edges
        Caminho *data = malloc(fh.caminhos * sizeof(Caminho));
        if (data == NULL) {
            perror("Erro na alocação de memória");
            return -1;
        }

        leDados(data, fh.caminhos, filename);

        // Chama a função Trepa Colinas
        int Its;
        printf("\nQts Its? \n\t:"); scanf("%d",&Its);
        trepaColinasEvolutivo(data, fh.caminhos, fh.valorK,Its);

        free(data);

    } else if (op == 3) {
        // Adicione código para a opção 2 (Algoritmo Evolutivo) aqui, se necessário

        fichHelper fh;
        fh = leDadosInicial(filename);
        fh.caminhos = contarLinhas(filename) - 2; // 2 por causa do k e do p edges
        Caminho *data = malloc(fh.caminhos * sizeof(Caminho));
        if (data == NULL) {
            perror("Erro na alocação de memória");
            return -1;
        }

        leDados(data, fh.caminhos, filename);

        // Chama a função Trepa Colinas
        int Its;
        printf("\nQts Its? \n\t:"); scanf("%d",&Its);
        trepaColinasHibrido(data, fh.caminhos, fh.valorK,Its);

        free(data);
    } else {
        printf("Opcao Invalida\n");
    }

    return 0;
}
