.data
m1: .word 3 12 15 4 9 24 16 10 2
m2: .word 7 4 11 18 32 7 4 8 1
mr: .word 0 0 0 0 0 0 0 0 0


.text

li a5, 3

jal sum
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
    ret

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
    ret

transp:
    li t5, 1
    li t6, 1
    
loop_transp
    mv a0, t5
    mv a1, t6
    la, a2, m1
    addi sp, sp, -4
    sw ra, 0(sp)
    jal read_cel
    addi sp, sp, 4
    mv t2, a0
    
    mv a0, t6
    mv a1, t5
    mv a2, t0
    la a2, t0
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
    ret    
    
                          
imprime:
    li t5, 1
    li t6, 1
loop_imprime:
    mv a0, t5
    mv a1, t6
    la a3, m1
    addi sp, sp, -4
    sw ra, 0(sp)
    jal write_cel
    lw ra, 0(sp)
    addi sp, sp, 4
    mv a0, a0
    
    jal ra, print_int
    
     li a0, ' '
     jal ra, print_char
     
    beq t6, a5, last_column_imprime
    addi, t6, t6, 1
    j loop_imprime
    
last_column_imprime:
    beq t5, a5, end_imprime
    addi t5, t5, 1
    li t6, 1
    j loop_imprime
end_timprime:
    ret    
         