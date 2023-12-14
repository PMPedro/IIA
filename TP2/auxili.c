#include "auxili.h"
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

fichHelper leDadosInicial(char *filename) {
    FILE *fp;
    fichHelper aux;
    fp = fopen(filename, "r");
    if (!fp) {
        perror("\nErro ao abrir ficheiro!");
    } else {

        int vertices, arestas, valork;

        fscanf(fp, "%*s %d", &valork); // ignorar a leitura de uma string
        fscanf(fp, "%*s %*s %d %d", &vertices, &arestas); // ignorar a leitura de uma string

        fclose(fp);

        aux.valorK = valork;
        aux.vertices = vertices;
        aux.arestas = arestas;

        return aux;
    }
}

void leDados(Caminho *caminho, int tam, const char *filename) {
    FILE *fp = fopen(filename, "r");
    if (!fp) {
        printf("Erro ao abrir ficheiro\n");
    } else {

        // Saltar as duas primeiras linhas
        fscanf(fp, "%*s %*d");  // Pular linha com "k"
        fscanf(fp, "%*s %*s %*d %*d");  // Pular linha com "p edge"

        for (int i = 0; i < tam; ++i)
            fscanf(fp, "%*s %d %d %d", &caminho[i].from, &caminho[i].to, &caminho[i].custo);
    }
    fclose(fp);
}


void check_data(Caminho *data, int size) {
    int i = 0;
    printf("\nTamanho %d", size);

    while (i < size) {
        printf("\n[%d] %d -> %d = %d]", i, data[i].from, data[i].to, data[i].custo);
        i++;
    }

}

void init_rand(){
    srand((unsigned)time(NULL));
}

int contarLinhas(const char *nomeArquivo) {
    FILE *arquivo = fopen(nomeArquivo, "r");

    if (arquivo == NULL) {
        fprintf(stderr, "Erro ao abrir o arquivo %s.\n", nomeArquivo);
        return -1;  // Retorna -1 para indicar erro
    }

    int numLinhas = 0;
    char buffer[1024];  // Tamanho do buffer pode ser ajustado conforme necessário

    // Leia o arquivo linha por linha
    while (fgets(buffer, sizeof(buffer), arquivo) != NULL) {

        // Se a linha não for vazia ou consistir apenas em espaços em branco, conte-a
        if (strspn(buffer, " \t\n") != strlen(buffer)) {
            numLinhas++;
        }
    }

    fclose(arquivo);

    return numLinhas;
}

