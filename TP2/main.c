#include <stdio.h>
#include <string.h>

int main() {
    char filename[100];
    FILE *fp;
    printf("\nDiga o Nome do ficheiro: ");
    fgets(filename, sizeof(filename), stdin);

    fp = fopen(filename,"r");
    if(!fp){
        perror("\nErro, esse ficheiro nao existe");
        return -1;
    }



    return 0;
}
