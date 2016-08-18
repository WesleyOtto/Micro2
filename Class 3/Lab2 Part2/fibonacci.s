.global FIBONACCI
FIBONACCI:

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
/**********************CÓDIGO*****************************/
/*********************************************************/
	
	ldw r16, r8 /* N value */
	addi r17, r0, 1
	addi r18, r0, 2 

	bne r16, r17, ELSE
	bnw r16, r18, ELSE
	addi r2, r0, 1
	br END

	ELSE:
	addi r4, r16, -1

	call FIBONACCI
	mov r19, r2

	addi r4, r16, -1

	call FIBONACCI
	mov r20, r2

	add r2, r19, r20


	END:



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
