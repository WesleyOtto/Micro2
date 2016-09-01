.equ TEST_NUM, 0xB51		/* The number to be tested */
.equ MASK, 0x01
.equ MASK2, 0xAAAAAAAA
.equ STACK, 0x20000


.global _start
_start:

	movia sp, STACK  		/*  Get space to use stack*/ 
	add fp, sp, r0
	movia r8, TEST_NUM		/* Load r8 with the number to be tested */
	movia r9, MASK2 		/* Copy invertion mask to r9 */ 
	movia r5, MASK 			/* Copy mask to r5 */ 
	xor r4, r9, r8          /* Make de invertion */  
	call COUNTER            
	mov r16, r2         	/* Return value to r16 /*
	nor r4, r4, r4          /* not r4 */
	call COUNTER
	mov r17, r2				/* Return value to r17 /*					 
	bgt r16, r17, END       /* if r16 is the greatest */
	mov r16, r17			

END:
	br	END				/* Wait here when the program has completed */



	COUNTER:

/********************************************************/
/********************PRÓLOGO****************************/
/*********************************************************/

/* Adjust the stack pointer */
	addi sp, sp, -16 	/* make a -16byte frame */

/* Store registers to the frame */
	stw ra, 12(sp) 	/* store the return address */
	stw fp, 8(sp) 	/* store the frame pointer*/
	stw r16, 4(sp)
	stw r17, 0(sp)

/* Set the new frame pointer */
	addi fp, sp, 8


/*********************************************************/
/**********************CÓDIGO*****************************/
/*********************************************************/


	mov	r9, r4			/* Copy the number to r9 */
	mov	r13, r5	/* Load r13 with the masks number*/ 
	mov r14, r0		/*backup*/	
	mov r15, r0			/* Counter backup*/

STRING_COUNTER:
	mov	r10, r0			/* Clear the counter to zero counter = r10*/

STRING_COUNTER_LOOP:	

	beq	r9, r0, END_STRING_COUNTER  /* Loop until r9 contains no more 1s   */
	and r14, r9, r13	
	srli r9, r9, 0x01
	beq r13, r14, INC_COUNTER  /*If found 1*/
	br STRING_COUNTER

	INC_COUNTER:
		addi r10, r10, 1		
		blt r10, r15, STRING_COUNTER_LOOP  /* If r10 < r15, jmp to loop*/
		mov r15, r10 						/* Updating the backup*/
		br STRING_COUNTER_LOOP

END_STRING_COUNTER:
	mov	r2, r15			/* Store the result into r2 */

/*********************************************************/
/**********************EPILOGO****************************/
/*********************************************************/

/* Restore ra, fp, sp, and registers */
	mov sp, fp
	ldw ra, 4(sp)
	ldw fp, 0(sp)
	ldw r16, -4(sp)
	ldw r17, -8(sp)
	addi sp, sp, 8

/* Return from subroutine */
ret

.end