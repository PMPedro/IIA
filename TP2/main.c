#include <stdio.h>
#include <string.h>

#include "functions.h"

int main() {
    fichHelper fh;

    char filename[100];
    FILE *fp;
    printf("\nDiga o Nome do ficheiro: ");
    gets(filename);

    fp = fopen(filename,"r");

    if(!fp){
        perror("\nErro, esse ficheiro nao existe");
        return -1;
    }else{
        fclose(fp);
    }

    fh = get_file_size(filename);
    Caminho data[fh.size];
    getData(&data, fh.size,filename);

 //   printf("\n%d %d, test", data[0].custo, data[1].custo);
    //check_data(data, fh.size);

    encontraSolucao(5, data, fh.size, 0);
  // custo_minimo(data, fh.size, 0, 4, 0, 0, 0);
   // printf("Teste 1");
    //printf("%d",data[fh.size-1].custo);





        return 0;
}
