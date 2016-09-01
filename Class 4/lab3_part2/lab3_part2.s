.equ TEST_NUM, 0xffba		/* The number to be tested */
.equ MASK, 0x01

.global _start
_start:
	movia	r8, TEST_NUM		/* Load r8 with the number to be tested */
	mov	r9, r8			/* Copy the number to r9 */
	movia 	r13, MASK	/* Load r13 with the masks number*/ 
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
		ble r10, r15, STRING_COUNTER_LOOP /* If r10 < r15, jmp to loop*/
		mov r15, r10 						/* Updating the backup*/
		br STRING_COUNTER_LOOP

END_STRING_COUNTER:
	mov	r12, r15			/* Store the result into r12 */

END:
	br	END				/* Wait here when the program has completed */
.end

