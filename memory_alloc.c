//Esqueleto comentado da função

//eh_Heap

    //endereço do bloco atual >= brk?

        //Se sim, acabou a heap

        //Se não, não

void* memory_alloc(unsigned long int bytes, unsigned char strategy) {
    //Procura bloco livre com tamanho igual ou maior que a requisição

    //endereco atual = brk_original

    while (eh_Heap(/*endereço do bloco atual*/)) {
    
        //O bloco está livre? (primeiro byte == 0)

            //tamanho do bloco atual >= tamanho requisitado?

                /* OPÇÃO 1: Guarda os dois "fits" e decide no final =========================== */

                    //best_fit atual > bloco atual?

                        //best_fit atual = bloco atual

                    //Se não: worst_fit atual < bloco atual

                        //worst_fit atual = bloco atual

                /* ============================================================================ */

                /* OPÇÃO 2: Verifica na hora qual fit é  ====================================== */

                    //É best_fit?

                        //tam. bloco escolhido atual > bloco atual?

                            //tam. bloco escolhido atual = bloco atual

                    //Se não

                        //tam. bloco escolhido atual < bloco atual?

                            //tam. bloco escolhido atual = bloco atual

                /* ============================================================================ */


        //Próximo bloco

            //endereco atual = endereco atual + tamanho do bloco atual
    }

    //Verifica se foi encontrado -> não sei como

    //Se sim:

        /* OPÇÃO 1: Guarda os dois "fits" e decide no final =========================== */

            //if (strategy == 1)

                //endereco_escolhido = best_fit atual

            //caso contrario

                //endereco_escolhido = worst_fit atual     

        /* ============================================================================ */

        /* OPÇÃO 2: Verifica na hora qual fit é  ====================================== */

        /* ============================================================================ */

        //marca ocupação
        if (/* tamanho do bloco encontrado >= tamanho do bloco requistado + 10 (8 + 1 + 1) */)

            //cria novo registro

                //endereço (começo do bloco atual + tamanho requisitado) = 0
                
                //endereço (começo do bloco atual + tamanho requisitado + 1) = tamanho bloco atual - tam. requisitado

                //muda tamanho do bloco atual para tamanho requisitado

    //se não encontrado nenhum bloco: novo bloco

        //endereco_escolhido = brk atual

        //avança brk na quantidade necessaria pela nova alocação

    //aloca bloco no endereco escolhido

        //primeiro byte = 1

        //segundo byte = quadword  

        //retorna endereco escolhido

}