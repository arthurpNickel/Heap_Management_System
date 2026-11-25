.section .data

brk_atual: .quad 0;
brk_original: .quad 0;

.section .text

# void setup_brk(); //Obtém o endereço de brk
_setup_brk:
    movq $0, %rdi
    movq $12, %rax
    syscall

    movq %rax, brk_original
    movq %rax, brk_atual

    ret

# void dismiss_brk(); //Restaura o endereço de brk
_dismiss_brk:
    movq brk_original, %rdi
    movq $12, %rax
    syscall

    movq brk_original, brk_atual


# void* memory_alloc(unsigned long int bytes, unsigned char strategy);

    //1. Procura bloco livre com tamanho igual ou maior que a requisição

    //2. Se encontrar, marca ocupação, utiliza os bytesnecessários do bloco, retornando o endereço correspondente
    
    //3. Se não encontrar, abre espaço para um novo bloco

# int memory_free(void *pointer); //Marca um bloco ocupado como livre
_memory_free:
    movb $0, (%rdi)
