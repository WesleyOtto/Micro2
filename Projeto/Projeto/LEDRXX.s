#change R9 to do
.equ REDLED_BASEADDRESS, 0x10000000

.global LEDRXX
LEDRXX:

/*********************************************************/
/**********************PRÓLOGO****************************/
/*********************************************************/

/* Adjust the stack pointer */
	addi sp, sp, -8	/* make a 8-byte frame */

/* Store registers to the frame */
	stw ra, 4(sp) 	/* store the return address */
	stw fp, 0(sp) 	/* store the frame pointer*/

/* Set the new frame pointer */
	addi fp, sp, 0

/*********************************************************/
/**********************LEDRXX*****************************/
/*********************************************************/

  	movia r8, REDLED_BASEADDRESS
    addi r9, r0, 9						# For a while this number is a constant. But we need to get this number from user
    addi r10, r0, 1						# Number 1 to SHIFT

		# SHIFT the r9 value to get the value to set LEDS

		SHIFT:
    	beq r9, r0, NOT_SHIFT
    	slli r10, r10, 1
    	subi r9, r9, 1
    	br SHIFT

		NOT_SHIFT:
	stwio r10, 0(r8)

/*********************************************************/
/**********************EPILOGO****************************/
/*********************************************************/
/* Restore ra, fp, sp, and registers */
	mov sp, fp
	ldw ra, 4(sp)
	ldw fp, 0(sp)
	addi sp, sp, 0
/* Return from subroutine */
ret
