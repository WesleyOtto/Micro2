.equ	STACK, 0x20000

.global _start
_start:

/*********************************************************/
/**********************PRINT******************************/
/*********************************************************/

	movia	sp, STACK          /* Configura registradores da pilha e    */
    mov fp, sp         		   /* e frame pointer.                      */
	call PRINTF

/**********************LEDRXX*****************************/
/*********************************************************/
/*********************************************************/
	movia	sp, STACK          /* Configura registradores da pilha e    */
    mov fp, sp         		   /* e frame pointer.                      */
	call LEDRXX


END:
	br END

