.data
m1: .word 1 2 3 4 5 6 7 8 9
m2: .word 9 8 7 6 5 4 3 2 1
mr: .word 0 0 0 0 0 0 0 0 0


.text

#a5 - reservado para valor do lado da matriz
read_cel:
    addi t0, a0, -1
    addi t1, a1, -1
    mul t0, t0, a5 #Endereço do primeiro elemento da linha
    add t0, t0, t1 #Endereço do elemento correto na matriz
    add t0, t0, m1 #Endereço do elemento correto na memória
    lw a0, 0(t0)
    ret

#write_cel(lin, col, val):


#soma(m1, m2, mr, lado):
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
# imprime o conte�do da matriz
