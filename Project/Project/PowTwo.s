.global POW_TWO
POW_TWO:

/*********************************************************/
/**********************PROLOGUE***************************/
/*********************************************************/

# Adjust the stack pointer
  addi  sp, sp, -8                # make a 8-byte frame

# Store registers to the frame
  stw   ra, 4(sp)                 # store the return address
  stw   fp, 0(sp)                 # store the frame pointer

# Set the new frame pointer
  addi  fp, sp, 0

/**********************POW_TWO**********************/

addi  r3, r0, 0x1                 # r3 <-  1
addi  r5, r0, 0x20                # r5 Controls amount of shifts (32 shifts is the max)
add   r8, r0, r0                  # r8 is  acumulator (start with 0)

LOOP:
  andi  r6, r4, 0x1
  bne   r6, r3, NAO_INCREMENTA    # If (r4 AND 0x1) == 0,  doesn't inc r8
  addi  r8, r8, 0x1               # Increments
  bgt   r8, r3, END_LOOP
NAO_INCREMENTA:
  srli  r4, r4, 0x1               # shift right 1
  subi  r5, r5, 0x1               # DEC 1 from control register
  beq   r5, r0, END_LOOP
  br    LOOP                      # Checks the next bit (shift)
END_LOOP:

beq   r8, r3, POW                 # If r8 has only one 1, the input is power of 2
addi  r2, r0, 0x0
br    END1

POW:
	addi  r2,r0, 0x1

END1:

/********************************************************/
/*********************EPILOGUE***************************/
/********************************************************/

# Restore ra, fp, sp, and registers
	mov 	sp, fp							      # sp points to fp
	ldw 	ra, 4(sp)						      # loads back ra
	ldw 	fp, 0(sp)						      # loads back fp
	addi 	sp, sp, 0						      # sp for the empty stack
	ret
