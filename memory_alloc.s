# IMPLEMENTAÇÃO COM OPÇÃO 1

# %rdi == tamanho requirido (8 bytes)
# %rsi == estratégia (1 byte)

# void* memory_alloc(unsigned long int bytes, unsigned char strategy) {
    
    #Procura bloco livre com tamanho igual ou maior que a requisição

    #endereco atual = brk_original
    movq brk_original, %rdx

    # seta best-fit atual e worst-fit atual
    movq %rdx, %r10         #best-fit
    movq %rdx, %r11         #worst-fit

# Enquanto endereco atual estiver na heap
_busca_bloco:

    #verifica se endereco atual está dentro dos limites da heap
    cmpq %rdx, brk_atual
    jle "fim loop"         #se brk <= endereco atual, desvia
    
        # O bloco está livre? (primeiro byte == 0)
        cmpb $0, (%rdx)
        jne _proximo_bloco

            # tamanho do bloco atual >= tamanho requisitado?
            cmpq %rdi, 1(%rdx)
            jl _proximo_bloco

                #best_fit atual > bloco atual?
                cmpq 1(%rdx), 1(%r10)
                jle _busca_fit_else

                    movq %rdx, %10      #best_fit atual = bloco atual
                    jmp _proximo_bloco

                _busca_fit_else:

                #Se não: worst_fit atual < bloco atual?
                cmpq 1(%rdx), 1(%r11)
                jge _proximo_bloco

                    movq %rdx, %11      #worst_fit atual = bloco atual
                    jmp _proximo_bloco

_proximo_bloco:

    #endereco atual = endereco atual + tamanho do bloco atual
    addq %rdx, 1(%rdx)

    jmp _busca_bloco

#----

    #Verifica se foi encontrado -> não sei como

    #Se sim:

        #.if (strategy == 1)

            #endereco_escolhido = best_fit atual

        #caso contrario

            #endereco_escolhido = worst_fit atual     

        #marca ocupação
        if (/* tamanho do bloco encontrado >= tamanho do bloco requistado + 10 (8 + 1 + 1) */)

            #cria novo registro

                #endereço (começo do bloco atual + tamanho requisitado) = 0
                
                #endereço (começo do bloco atual + tamanho requisitado + 1) = tamanho bloco atual - tam. requisitado

                #muda tamanho do bloco atual para tamanho requisitado

    #se não encontrado nenhum bloco: novo bloco

        #endereco_escolhido = brk atual

        #avança brk na quantidade necessaria pela nova alocação

    #aloca bloco no endereco escolhido

        #primeiro byte = 1

        #segundo byte = quadword  

        #retorna endereco escolhido

}