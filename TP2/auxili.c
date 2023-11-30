//
// Created by pmanu on 23/11/2023.
//
#include "auxili.h"



fichHelper get_file_size(char *filename) {
    FILE *fp;
    fichHelper aux;
    fp = fopen(filename, "r");
/*teste para git*/
    if(!fp){
        perror("\nErro ao abrir ficheiro!");
    }else{
        char k[10], inidata[10], inidata2[10];
        int tam, ares, valork;

        fscanf(fp,"%c %d", k, &valork);
        fscanf(fp, "%s %s %d %d", inidata, inidata2, &ares, &tam);
        fclose(fp);

        aux.valorK = valork;
        aux.size = tam;
        return aux;
    }
}

void getData(Caminho *caminho, int tam, char *filename){
    FILE *fp;
    fp = fopen(filename, "r");
    if(!fp){
        perror("Erro ao abrir ficheiro");
    }else{
        char k[10], inidata[10], inidata2[10];
        int tam, ares, valork;
        fscanf(fp,"%c %d", k, &valork);
        fscanf(fp, "%s %s %d %d", inidata, inidata2, &ares, &tam);
        for(int i; i < tam; i++){
            fscanf(fp, "%s %s %d %d", inidata, &caminho[i].to, &caminho[i].from, &caminho[i].custo);
        }
    }
}
