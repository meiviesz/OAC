.data
#m1: .word 1 2 8 7 3 4 0 2 3 4 5 6 7 8 9 2
#m2: .word 2 3 4 5 6 7 8 9 10
#mr: .word 0 0 0 0 0 0 0 0 0
m1: .space 100
m2: .space 100
mr: .space 100

qts_lados: .ascii "Quantos lados tem suas matrizes? (1 a 10)\n\0"
invalido: .ascii "Entrada inválida, encerrando funcao\0"
texto_valor1: .ascii "Insira valor do elemento \0"
texto_valor2: .ascii " da matriz \0"
texto_valor3: .ascii ":\n\0"
menu_text: .ascii "Selecione uma das opções a seguir:\n\n1) Somar elementos das matrizes 1 e 2\n2) Multiplicar elementos das matrizes 1 e 2\n3) Transportar elementos da matriz 1 para a matriz 2\n4) Exibir uma matriz\n5) Sair\n\0"
op_inv: .ascii "Opção invalida, tente novamente\n\0"
print_text: .ascii "Qual matriz que exibir? (1 - Matriz 1; 2 - Matriz 2; 3 - Matriz Resultado\n\0"

.text

    li t0, 4
    la t1, m1
    sw t0, 0(t1)
    li t0, 8
    la t1, m2
    sw t0, 0(t1)

    li a7, 4
    la a0, qts_lados
    ecall

    li a7, 5
    ecall
    mv a5, a0

    jal fill_matrix
    
    jal menu

    li a7, 10
    ecall

#a5 - reservado para valor do lado da matriz
read_cel: #a0 = linha. a1 = coluna. a2 = matriz.
    addi t0, a0, -1
    addi t1, a1, -1
    mul t0, t0, a5 #Endereço do primeiro elemento da linha
    add t0, t0, t1 #Endereço do elemento correto na matriz
    slli t0, t0, 2
    add t0, t0, a2 #Endereço do elemento correto na memória
    lw a0, 0(t0)
    ret

write_cel: #a0 = linha. a1 = coluna. a2 = valor. a3 = matriz
    addi t0, a0, -1
    addi t1, a1, -1
    mul t0, t0, a5
    add t0, t0, t1
    slli t0, t0, 2
    add t0, t0, a3
    sw a2, 0(t0)
    ret
    
menu:
    li a7, 4 #Escreve texto do menu
    la a0, menu_text
    ecall
    
    li a7, 5
    mv a0, t0
    ecall
    mv a4, a0
    
    li t1, 1
    li t2, 2
    li t3, 3
    li t3, 3
    li t4, 4
    li t5, 5
    
    beq a4, t1, sum
    beq a4, t2, multi
    beq a4, t3, transp
    beq a4, t4, print
    beq a4, t5, exit
    
    li a7, 4
    la a0, op_inv
    ecall
    j menu
    
exit:
    li a7, 10
    ecall
    
fill_matrix:
    li t4, 0 #contador de matrix
    li t5, 1 #contador de linha
    li t6, 1 #contador de coluna
loop_fill:
    addi t0, t5, -1
    mul t0, t0, a5
    add t0, t0, t6 #Elemento atual

    li a7, 4 #Escreve texto pra inserir cada elemento
    la a0, texto_valor1
    ecall
    li a7, 1
    mv a0, t0
    ecall
    li a7, 4
    la a0, texto_valor2
    ecall
    li a7, 1
    addi a0, t4, 1
    ecall
    li a7, 4
    la a0, texto_valor3
    ecall
    
    li a7, 5
    ecall
    mv a2, a0
    
    mv a0, t5
    mv a1, t6
    beqz t4, mat1
    la a3, m2
    j write
mat1:
    la a3, m1
write:
    addi sp, sp, -4
    sw ra, 0(sp)
    jal write_cel
    lw ra, 0(sp)
    addi sp, sp, 4

    beq t6, a5, last_column_fill
    addi t6, t6, 1
    j loop_fill
last_column_fill:
    beq t5, a5, last_row_fill
    addi t5, t5, 1
    li t6, 1
    j loop_fill
last_row_fill:
    bnez t4, end_fill
    addi t4, t4, 1
    li t5, 1
    li t6, 1
    j loop_fill
end_fill:
    ret

sum:
    li t5, 1 #contador de linha
    li t6, 1 #contador de coluna
loop_sum:
    mv a0, t5
    mv a1, t6
    la a2, m1
    addi sp, sp, -4
    sw ra, 0(sp)
    jal read_cel
    lw ra, 0(sp)
    addi sp, sp, 4
    mv t2, a0    

    mv a0, t5
    la a2, m2
    addi sp, sp, -4
    sw ra, 0(sp)
    jal read_cel
    lw ra, 0(sp)
    addi sp, sp, 4
    
    add a2, t2, a0
    mv a0, t5
    la a3, mr
    addi sp, sp, -4
    sw ra, 0(sp)
    jal write_cel
    lw ra, 0(sp)
    addi sp, sp, 4

    beq t6, a5, last_column_sum
    addi t6, t6, 1
    j loop_sum
last_column_sum:
    beq t5, a5, end_sum
    addi t5, t5, 1
    li t6, 1
    j loop_sum
end_sum:
    #ret
    j menu

multi:
    li t5, 1
    li t6, 1
    
loop_multi:
    mv a0, t5
    mv a1, t6
    la a2, m1
    addi sp, sp, -4
    sw ra, 0(sp)
    jal read_cel
    lw ra, 0(sp)
    addi sp, sp, 4
    mv t2, a0   
    
    mv a0, t5
    la a2, m2
    addi sp, sp, -4
    sw ra, 0(sp)
    jal read_cel
    lw ra, 0(sp)
    addi sp, sp, 4   
    
    mul a2, t2, a0  # multiplica os dois elementos
    mv a0, t5
    la a3, mr   
    addi sp, sp, -4
    sw ra, 0(sp)
    jal write_cel
    lw ra, 0(sp)
    addi sp, sp, 4
    
    beq t6, a5, last_column_multi
    addi, t6, t6, 1
    j loop_multi
    
last_column_multi:
    beq t5, a5, end_multi
    addi t5, t5, 1
    li t6, 1
    j loop_multi
end_multi:
    #ret
    j menu

transp:
    li t5, 1
    li t6, 1
    
loop_transp:
    mv a0, t5
    mv a1, t6
    la, a2, m1
    addi sp, sp, -4
    sw ra, 0(sp)
    jal read_cel
    lw ra, 0(sp)
    addi sp, sp, 4
    mv t0, a0
    
    mv a0, t5
    mv a1, t6
    mv a2, t0
    la a3, m2
    addi sp, sp, -4
    sw ra, 0(sp)
    jal write_cel
    lw ra, 0(sp)
    addi sp, sp, 4
 
    beq t6, a5, last_column_transp
    addi, t6, t6, 1
    j loop_transp
    
last_column_transp:
    beq t5, a5, end_transp
    addi t5, t5, 1
    li t6, 1
    j loop_transp
end_transp:
    #ret
    j menu
    
                          
print:
    li a7, 4
    la a0, print_text
    ecall
    li a7, 5
    ecall
    
    li t1, 1
    li t2, 2
    li t3, 3
    
    beq a0, t1, pmat1
    beq a0, t2, pmat2
    beq a0, t3, pmat3
    
    li a7, 4
    la a0, invalido
    ecall
    j menu
    
pmat1:
    la a2, m1
    j init_print
pmat2:
    la a2, m2
    j init_print
pmat3:
    la a2, mr
init_print:
    li t5, 1
    li t6, 1
loop_print:
    mv a0, t5
    mv a1, t6
    addi sp, sp, -4
    sw ra, 0(sp)
    jal read_cel
    lw ra, 0(sp)
    addi sp, sp, 4
    li a7, 1
    ecall
     
    beq t6, a5, last_column_print
    addi, t6, t6, 1
    li a7, 11
    li a0, 32
    ecall
    j loop_print
    
last_column_print:
    li a7, 11
    li a0, 10
    ecall
    beq t5, a5, end_print
    addi t5, t5, 1
    li t6, 1
    j loop_print
end_print:
    #ret
    j menu