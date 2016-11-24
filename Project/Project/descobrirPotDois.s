#PUT value in r4

.global POT_TWO
POT_TWO:

/*********************************************************/
/**********************PROLOGUE***************************/
/*********************************************************/

# Adjust the stack pointer
  addi sp, sp, -8                 # make a 8-byte frame

# Store registers to the frame
  stw ra, 4(sp)                   # store the return address
  stw fp, 0(sp)                   # store the frame pointer

# Set the new frame pointer
  addi fp, sp, 0

  /**********************POT_TWO*******************/

addi r3,r0, 0x1                   # r3 vale 1
add r8, r8, zero                  # r8 é o acumulador (inicia com 0)
addi r5, r5, 0x20                 # r5 controla quantidade de shifts (32 shifts é max pois nios2 é arquitetura 32-bit)

LOOP:
  andi r6, r4, 0x1
  bne r6, r3, NAO_INCREMENTA        # se (r4 AND 0x1) == 0, não incrementa r8
  addi r8, r8, 0x1                  # INCREMENTA
  bgt r8, r3, END_LOOP
NAO_INCREMENTA:
  srli r4, r4, 0x1                  # desloca 1 para a direita
  subi r5, r5, 0x1                  # decrementa 1 do registrador de controle
  beq r5, zero, END_LOOP
  br LOOP                         # verifica o próximo bit (desolcado)
END_LOOP:

beq r8, r3, POT                   # se tem apenas um 1 na sequencia, é potencia de 2
addi r2, r0,0x0	                  # caso contrário, não
br END1

POT: 
	addi r2,r0, 0x1

END1:



/********************************************************/
/*********************EPILOGUE***************************/
/********************************************************/

# Restore ra, fp, sp, and registers
  mov sp, fp
  ldw ra, 4(sp)
  ldw fp, 0(sp)
  addi sp, sp, 8
  ret
     