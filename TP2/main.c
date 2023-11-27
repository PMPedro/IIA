#include <stdio.h>
#include <string.h>
#include "aux.h"

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
    getData(data, fh.size,filename);
    //printf("%d",data[fh.size-1].custo);





        return 0;
}
