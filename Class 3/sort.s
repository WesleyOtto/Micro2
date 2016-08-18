.global SORT
SORT:

/*********************************************************/
/**********************PRÓLOGO****************************/
/*********************************************************/

/* Adjust the stack pointer */
	addi sp, sp, -8 	/* make a 8-byte frame */

/* Store registers to the frame */
	stw ra, 4(sp) 	/* store the return address */
	stw fp, 0(sp) 	/* store the frame pointer*/

/* Set the new frame pointer */
	addi fp, sp, 0


/*********************************************************/
/**********************CÓDIGO*****************************/
/*********************************************************/

	mov r8, r4  /* lists lenght */
	mov r9, r5  /* address to the first element */ 

	mov r10, r0  /* i = 0 */

FOR_I:
	bgeu r10, r8, DONE_I  /* done if I >= lists lenght */
	mov r15, r10 	/* indice_max = i */

	addi r11, r10, 1  /* j = i+1 */
	FOR_J:
		bgeu r11, r8, DONE_J /* done if J >= lists lenght */
		
		/* VECTOR[j] */
		slli r13, r11, 2  /* r13 = r11 * 4   /   adress to vector[j] */
		add r13, r13, r9  /* r13 = &vector[j] */
		ldw r13, 0(r13)	  /* r13 = vector[j] */

		/* VECTOR[indice_max] */
		slli r14, r15, 2  /* r14 = r11 * 4   /   adress to vector[indice_max] */
		add r14, r14, r9  /* r14 = &vector[indice_max] */
		ldw r12, 0(r14)	  /* r12 = vector[indice_max] */

		bgeu r12, r13, INC_J /* if r12 >= r13 / if vector[indice_max] >= vector[j] */
		mov r15, r11	/* indice_max = j */
		INC_J:
		addi r11, r11, 1 /* j++ */
		br FOR_J 

	DONE_J:
		beq r10, r15, INC_I

		/* I dont need to load vector[indice_max] cause it is loaded when it leaves the FOR_J LOOP */
		
		/* VECTOR[i] */
		slli r15, r10, 2  /* r15 = r10 * 4   /   adress to vector[i] */
		add r15, r15, r9  /* r15 = &vector[i] */
		ldw r11, 0(r15)	  /* r11 = vector[i] */

		stw r11, 0(r14) /* vector[indice_max] = vector[i] */
		stw r12, 0(r15) /* vector[i] = vector[indice_max] */


		INC_I:
		addi r10, r10, 1
		br FOR_I

DONE_I:



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
