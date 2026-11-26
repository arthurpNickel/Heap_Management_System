# IMPLEMENTAÇÃO COM OPÇÃO 1

# Manual de registradores
# %rax : endereço escolhido para a alocação
# %rdx : ponteiro para 'endereço atual' de verificação da heap
# %rsi : estratégia (1 para best, 0 para worst)
# %rdi : tamanho da nova alocação (em bytes)
# %r10 : guarda endereço da alocação best-fit atual
# %r11 : guarda endereço da alocação worst-fit atual

# void* memory_alloc(unsigned long int bytes, unsigned char strategy) {
memory_alloc:
    #Procura bloco livre com tamanho igual ou maior que a requisição

    # endereco atual = brk_original
    movq brk_original, %rdx
    #Q: addq $1, %rdx ? para acertar rdx? -> o brk original marca um byte antes da heap ou o byte do início da heap?

    # seta best-fit atual e worst-fit atual com valor inicial inválido
    movq %rdx, %r10         #best-fit
    addq $-2, %r10
    movq %rdx, %r11         #worst-fit
    addq $-2, %r11

# Enquanto endereco atual estiver na heap
_busca_bloco:

    #verifica se endereco atual está dentro dos limites da heap
    cmpq %rdx, brk_atual
    jle "fim loop"         #se brk <= endereco atual, não está
    
        # O bloco está livre? (primeiro byte == 0)
        cmpb $0, (%rdx)
        jne _proximo_bloco

            # tamanho do bloco atual >= tamanho requisitado?
            cmpq %rdi, 1(%rdx)
            jl _proximo_bloco

                #best_fit atual > bloco atual?
                cmpq 1(%rdx), 1(%r10)
                jle _busca_fit_else

                    movq %rdx, %r10      #best_fit atual = bloco atual
                    jmp _proximo_bloco

                _busca_fit_else:

                #Se não: worst_fit atual < bloco atual?
                cmpq 1(%rdx), 1(%r11)
                jge _proximo_bloco

                    movq %rdx, %r11      #worst_fit atual = bloco atual
                    jmp _proximo_bloco

_proximo_bloco:

    #endereco atual = endereco atual + tamanho do bloco atual + 9 (tam. do registro)
    addq %rdx, 1(%rdx)
    addq $9, %rdx

    jmp _busca_bloco

#----

#_algum_nome:
    # Verifica se foi encontrado bloco para reaproveitamento

    #.if (strategy == 1)
    cmpb $1, %rs1
    jne _else_estrategia

        # Verifica se foi encontrado algum bloco para reaproveitamento
        cmp brk_original, %r10      # Se best_fit <= brk_original, não foi encontrado
        jle _cria_novo_bloco

            #endereco_escolhido = best_fit atual
            movq %r10, %rax
            jmp _divide_bloco

    #caso contrario, é worst-fit
    _else_estrategia:

        # Verifica se foi encontrado algum bloco para reaproveitamento
        cmp brk_original, %r11      # Se worst_fit <= brk_original, não foi encontrado
        jle _cria_novo_bloco

            #endereco_escolhido = worst_fit atual
            movq %r10, %rax
            jmp _divide_bloco   

# Se o tamanho do bloco encontrado >= tamanho do bloco requistado + 10 (8 + 1 + 1), divide bloco e cria outro registro
_divide_bloco:

    # %rcx = tamanho do bloco requisitado + 10 (registro de alocação + 1 byte)
    movq %rdi, %rcx
    movq 10, %rcx

    # Se tamanho do bloco encontrado for menor que %rcx, não divide bloco
    cmp %rcx, 1(%rax)
    jl _aloca_bloco_escolhido

        # Cria novo registro

        # %rcx = endereço do registro do novo bloco
        movq %rax, %rcx
        addq $9, %rcx
        addq %rdi, %rcx    

        # Seta novo bloco como desocupado
        movb $0, (%rcx)
            
        # Seta tamanho do novo bloco (tamanho do bloco escolhido - tamanho requisitado - tamanho do registro)
        movq 1(%rax), %r8
        subq %rdi, %r8
        subq $9, %r8
        movq %r8, 1(%rcx)       # Seta
        
        # Atualiza tamanho do bloco escolhido (passa a ser o tamanho requisitado)
        movq %rdi, 1(%rax)

        jmp aloca_bloco_escolhido

#----

# Se não encontrado nenhum bloco: novo bloco
_cria_novo_bloco:

    # Avança brk na quantidade necessaria pela nova alocação

    # %rdi = novo brk
    movq %rdi, %r8
    addq brk_atual, %rdi
    addq $9, %rdi

    movq $12, %rax
    syscall

    # Atualiza brk atual
    movq brk_atual, %rdx
    movq %rdx, brk_atual

    # %rax aponta para novo registro de alocação
    movq %rdx, %rax
    addq $1, %rax

    # Atualiza tamanho do bloco (tamanho requisitado)
    movq %rdi, 1(%rax)

# Recebe %rax apontando para o registro do bloco escolhido
_aloca_bloco_escolhido:

    movq $1, (%rax)         # Marca bloco como ocupado
    ret