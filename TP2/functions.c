//
// Created by pmanu on 27/11/2023.
//

#include <stdbool.h>
#include "functions.h"

void custo_minimo(Caminho *Data, int tam, int partida, int Its, int custoAntigo, int fc, int rep){
int menor, it=0;
Caminho sol[Its];
    if(partida = 0)
        partida = Data[0].from;
    for(int i=0; i < tam;i++){
        if(Data[i].from == partida){
            if(Data[i].custo < menor){
                menor = Data[i].custo;
                sol[it] = Data[i];
            }
            if(i == tam){
                if(it < Its)
                i = 0;
                it++;
            }
        }
    }
    if(fc == 0){
        melhorSol (custoAntigo, Data, Its, sol, tam, partida, rep);
    }else{

        printf("\nMelhor Custo: " );

        }
    }
}

void melhorSol (int cA, Caminho *Data, int ITs, Caminho *Sol, int Tam, int partida, int rep){
    //1ºcalcula vol
    int custo;


    for(int i=0; i < ITs; i++){
        custo += Sol[i].custo;
    }

    //ver se ja fez funcao antes
        if(cA == 0){
            custo_minimo(Data, Tam, partida++, ITs, custo, 0, rep++ );
        }else{
            if(custo > cA){
                custo = cA;

                custo_minimo(Data, Tam, partida++, ITs, custo, 0, rep++  );
            }else{
                if(rep == Tam){
                    custo_minimo(Data, Tam, partida++, ITs, custo, 1, rep++  );
                }
            }
        }
}

//estas 2 funceos estao em loop, faz x vezes , e so no final mostra qual a melhor solucao
//falta testar e guardar a melhor sol (o caminho da sol) ja guarda o costo

