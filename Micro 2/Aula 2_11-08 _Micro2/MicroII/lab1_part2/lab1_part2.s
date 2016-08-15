.equ LIST, 0x1000 /* Starting address of the list */
.global start

start:
	movia r4, LIST /* r4 points to the start of the list */	
	ldw r5,(r4) /* r5 é o contador */	
	ldw r6, 4(r4) /* 0 */
	ldw r7, 8(r4) /* 1 */
	addi r8, r4, 4 /* r8 aponta para a primeira posição de escrita */
	
	LOOP:
	addi r8, r8, 4
	subi r5, r5, 1
	beq r5,r0,STOP
	add r9, r6, r7 /* r9 contém a soma dos dois elementos anteriores */
	stw r8, (r9)
	add r6,r0,r7 /* atualiza as posições anteriores */
	add r7,r0,r9 /* atualiza as posições anteriores */
	br LOOP
	STOP:
	br STOP
	
.org 0x1000
N:
.word 7 /* Numero de elementos */
NUMBERS:
.word 0, 1 /*Dois primeiros valores da sequencia*/
.end