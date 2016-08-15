.equ MEM, 0x1000
.equ N, 15

.global _start
_start:
	movia r5, MEM	
	movia r8, N
	
	add r6, r0, r0	 
	stw r6, 0(r5)
	addi r5, r5, 4

 	addi r7, r0, 1
	stw r7, 0(r5)
	addi r5, r5, 4
 
	subi r8, r8, 2

	LOOP:
	     subi r8, r8, 1
	     beq r8, r0, DONE  
	     
	     add r9, r7, r0
	     add r7, r6, r7
	     add r6, r9, r0
	     
	     stw r7, 0(r5)
	     addi r5, r5, 4
	     
	     br LOOP
	          
	DONE:
	
.end
