
#include "trepacolinas.h"

void geraSolInicial(int *solucao, int tam) {
    for (int i = 0; i < tam; ++i) {
        solucao[i] = rand() % 2; // Gera 0 ou 1 aleatoriamente
    }
}

bool solucaoValida(Caminho *caminho, int tam, int *sol) {
    bool checker = true;
    int partida;
    int guardapos;
    for(int i = 0; i < tam; i ++){
        if(sol[i] == 1){
            partida = caminho->to;
            guardapos = i;
        }
    }

    for(guardapos; guardapos < tam; guardapos ++){
        if(caminho[guardapos].from == partida){
            checker = true;

            break;
        }
    }
    return checker;
}


int avaliaSolucao(Caminho *caminhos, int tam, int *solucao) {
    // Implemente a função de avaliação adequada ao seu problema
    // Retorna o custo da solução
    // Esta é uma implementação de exemplo, substitua-a pela lógica real
    int custoTotal;
    for(int i = 0; i < tam; i ++){
        if(solucao[i] == 1){
            custoTotal = caminhos[i].custo;
        }
    }

    if(solucaoValida(caminhos, tam, solucao) == true){
        printf("\nSolucao e valida");
    }
    printf("\nDebug\n\tCusto avaliado [%d]",custoTotal);
    return custoTotal; // Apenas um valor aleatório para exemplo
}

void vizinhancaTroca(int *solucao, int tam) {
    int posicao = rand() % tam; // Escolhe uma posição aleatória
    solucao[posicao] = 1 - solucao[posicao]; // Troca 0 por 1 ou 1 por 0
}

void vizinhancaReparacao(int *sol, int tam, Caminho *caminho, int valorK) {
    // Implemente a estratégia de reparação adequada ao seu problema
    // Pode ajustar a solução para garantir que atende às restrições
    // Esta é uma implementação de exemplo, substitua-a pela lógica real
    bool check = false;
    int partida;
    int guardapos;
    while (!check){
    for(int i = 0; i < tam; i ++){
        if(sol[i] == 1){
            partida = caminho->to;
            guardapos = i;
        }
    }
        sol[guardapos] = 0;

    for(guardapos; guardapos < tam; guardapos ++){
        int rando = rand() % 2;
        sol[guardapos] = rando;
        if(rando == 1)
            check = solucaoValida(caminho,tam,sol);

    }
    }
}

void trepaColinas(Caminho *caminhos, int tam, int valorK, int Its) {
    int *solucao_atual = malloc(tam * sizeof(int));
    int *melhor_solucao = malloc(tam * sizeof(int));
    int custo_atual, melhor_custo;
    int iteracoes_sem_melhora = 0;
    const int max_iter_sem_melhora = 100;

    geraSolInicial(solucao_atual, tam);
    custo_atual = avaliaSolucao(caminhos, tam, solucao_atual);

    // Inicializa a melhor solução com a solução inicial
    for (int i = 0; i < tam; ++i) {
        melhor_solucao[i] = solucao_atual[i];
    }
    melhor_custo = custo_atual;
    int i = 0;
    while (i < Its) {
        // Gera uma solução na vizinhança da solução atual
        vizinhancaTroca(solucao_atual, tam);

        // Verifica se a nova solução viola alguma restrição e repara se necessário
        vizinhancaReparacao(solucao_atual, tam, caminhos, valorK);

        // Avalia a nova solução
        int novo_custo = avaliaSolucao(caminhos, tam, solucao_atual);

        // Compara com a melhor solução encontrada até agora
        if (novo_custo < melhor_custo) {
            // Atualiza a melhor solução
            for (int i = 0; i < tam; ++i) {
                melhor_solucao[i] = solucao_atual[i];
            }
            melhor_custo = novo_custo;
            iteracoes_sem_melhora = 0; // Reseta contador de iterações sem melhora
        } else {
            iteracoes_sem_melhora++;
        }
        i++;
    }

    // Exibe a melhor solução encontrada
    printf("Melhor Solucao encontrada: ");
    for (int i = 0; i < tam; ++i) {
        printf("%d ", melhor_solucao[i]);
    }
    printf("\nCusto final: %d\n", melhor_custo);

    // Libera a memória alocada
    free(solucao_atual);
    free(melhor_solucao);
}
void recombinacao (int tam, int crossover, int *sol1, int *sol2, int *solatual){

    for(int i = 0; i < crossover; i ++){
        solatual[i] = sol1[i];
    }
    for(int i = crossover; i < tam; i++){
        solatual[i] = sol2[i];
    }

}

void trepaColinasEvolutivo(Caminho *caminhos, int tam, int valorK, int Its) {
    int *solucao_atual = malloc(tam * sizeof(int));
    int *vizi1 = malloc(tam * sizeof(int));
    int *vizi2 = malloc(tam * sizeof(int));
    int *melhor_solucao = malloc(tam * sizeof(int));
    int custo_atual, melhor_custo;
    int iteracoes_sem_melhora = 0;
    const int max_iter_sem_melhora = 100;

    geraSolInicial(solucao_atual, tam);
    custo_atual = avaliaSolucao(caminhos, tam, solucao_atual);

    // Inicializa a melhor solução com a solução inicial
    for (int i = 0; i < tam; ++i) {
        melhor_solucao[i] = solucao_atual[i];
    }
    melhor_custo = custo_atual;
    int i = 0;
    while (i < Its) {
        // Gera uma solução na vizinhança da solução atual


        geraSolInicial(vizi1, tam);
        geraSolInicial(vizi2, tam);
        recombinacao(tam,tam/2,vizi1,vizi2,solucao_atual);


        // Verifica se a nova solução viola alguma restrição e repara se necessário
        if(!solucaoValida(caminhos, tam, solucao_atual)){
            vizinhancaReparacao(solucao_atual,tam, caminhos, valorK);
        }

        // Avalia a nova solução
        int novo_custo = avaliaSolucao(caminhos, tam, solucao_atual);

        // Compara com a melhor solução encontrada até agora
        if (novo_custo < melhor_custo) {
            // Atualiza a melhor solução
            for (int i = 0; i < tam; ++i) {
                melhor_solucao[i] = solucao_atual[i];
            }
            melhor_custo = novo_custo;
            iteracoes_sem_melhora = 0; // Reseta contador de iterações sem melhora
        } else {
            iteracoes_sem_melhora++;
        }
        i++;
    }


    // Exibe a melhor solução encontrada
    printf("Melhor Solucao encontrada: ");
    for (int i = 0; i < tam; ++i) {
        printf("%d ", melhor_solucao[i]);
    }
    printf("\nCusto final: %d\n", melhor_custo);

    // Libera a memória alocada
    free(solucao_atual);
    free(melhor_solucao);
}
