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
    addi r10, r0, 1						# Number 1 to SHIFT

		# SHIFT the r4 value to get the value to set LEDS

		sll r10, r10, r4
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
