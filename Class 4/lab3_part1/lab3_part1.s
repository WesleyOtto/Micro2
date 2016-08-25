.equ TEST_NUM, 0x90abcdef		/* The number to be tested */

/**************************************************************************/
/* Main Program                                                           */
/*   Determines the maximum number of consecutive 1s in a data word.      */
/*                                                                        */
/* r8   - Contains the test data                                          */
/* r9   - Holds the data as it is being tested                            */
/* r10  - Counts the number of consecutive 1s                             */
/* r11  - r9 shifted right by one bit position                            */
/* r12  - Indicates the maximum number of consecutive 1s                  */
/**************************************************************************/

.global _start
_start:
	movia	r8, TEST_NUM		/* Load r8 with the number to be tested */
	mov	r9, r8			/* Copy the number to r9 */
	
STRING_COUNTER:
	mov	r10, r0			/* Clear the counter to zero */
STRING_COUNTER_LOOP:				
	beq	r9, r0, END_STRING_COUNTER  /* Loop until r9 contains no more 1s   */
	srli	r11, r9, 0x01		/* Calculate the number of 1s by shifting the number */
	and	r9, r9, r11			/*    and ANDing it with the shifted result          */
	addi	r10, r10, 0x01		/* Increment the counter */
	br	STRING_COUNTER_LOOP
END_STRING_COUNTER:
	mov	r12, r10			/* Store the result into r12 */

END:
	br	END				/* Wait here when the program has completed */
.end
