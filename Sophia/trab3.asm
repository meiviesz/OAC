.data
m1: .word 1 2 3 4 5 6 7 8 9
m2: .word 9 8 7 6 5 4 3 2 1
mr: .word 0 0 0 0 0 0 0 0 0


.text

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
    li t5, 0
    li t6, 0
loop_sum:
    mv a0, t5
    mv a1, t6
    la a2, m1
    addi sp, sp, -4
    sw ra, 0(sp)
    jal read_cel
    lw ra, 0(sp)
    
    mv t2, a0
    mv a0, t5
    la a2, m2
    addi sp, sp, -4
    sw ra, 0(sp)
    jal read_cel
    lw ra, 0(sp)
    
    add a2, t2, a0
    mv a0, t5
    la a3, mr
    addi sp, sp, -4
    sw ra, 0(sp)
    jal write_cel
    lw ra, 0(sp)

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



# 1 elemento da 1 matriz: a0
# 1 elemento da 2 matriz: a1
# 1 elemento da matriz resultado: a2
# largura da matriz: a3
# soma e coloca em mr (a3)

#multiplica(m1, m2, mr, lado):
# mesmos parametros da soma
# matriz mr recebe resultado da mult de m1 por m2

#transposta(m1, mr, lado):
# coloca o resultado em mr

#imprime(m1, lado):
# imprime o conteudo da matriz
