.equ KEYBOARD, 0x10001000
.equ MASK_WSPACE, 0xFFFF0000

.global PRINTF
PRINTF:

/*********************************************************/
/**********************PRÓLOGO****************************/
/*********************************************************/

/* Adjust the stack pointer */
	addi sp, sp, -12	/* make a 12-byte frame */

/* Store registers to the frame */
	stw ra, 8(sp) 	/* store the return address */
	stw fp, 4(sp) 	/* store the frame pointer*/
	stw r17, 0(sp)

/* Set the new frame pointer */
	addi fp, sp, 0

/*********************************************************/
/**********************PRINT******************************/
/*********************************************************/

	movia r8, KEYBOARD
	movia r9, MASK_WSPACE

	ldw r5, 0(r5)						# Get Message Size

PRINT:
	ldw r10, 0(r4)	 				# Load letter from memory

	SPACE_LOOP:

		ldwio r11, 4(r8) 					# Read control register
		and r12, r9, r11	 				# Verify space availability [WSPACE]
		beq r0, r12, SPACE_LOOP		# While there's no space, wait...

		stwio r13, 0(r1) 					# Print on the terminal (using Data Register)

		addi r4, r4, 4					# Next letter
		subi r5, r5, 1					# Counter to word size
		bne r5, r0, PRINT

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
