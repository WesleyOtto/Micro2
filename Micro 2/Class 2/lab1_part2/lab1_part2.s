/* Program that calculates the fibonacci sequence	    */

.equ LIST, 0xFFC		  /* Starting address of the list		    */

.global _start
_start:
	movia	r4, LIST	  /* r4 points to the start of the list	    */
	addi	r5, r4, 4	  /* r5 is the adress to the first element of the sequence    */
	
	add	r6, r0, r0	  /* first element is 0		    */
	stw r6, 0(r5)

 	addi r6, r0, 1	  /* second element is 1		    */
	stw r6, 4(r5)

	addi	r5, r5, 8   /* Counter of the vector */
	addi	r8, r4, r0  /* Counter of number of elements */
	subi    r8, r8, 2

	LOOP:
	     subi	r8, r8, 1
	     beq	r8, r0, DONE  /* Finished if r8 is equal to 0		    */
         
         /* TODO */


.org	0xFFC
N:
.word	8			  /* Space for the test number	    */
RESULT:
.word 			  /* Start of result memories adress    */

.end