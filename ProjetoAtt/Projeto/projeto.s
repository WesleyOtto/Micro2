.equ	STACK, 0x20000
.global _start
_start:

/*********************************************************/
/**********************PRINT******************************/
/*********************************************************/

	movia	sp, STACK          /* Set stack registers and    */
    mov fp, sp         		   /* frame pointer.             */
	call PRINTF						  /*  Call Function PRINTF		 */

/**********************LEDRXX*****************************/
/*********************************************************/
/*********************************************************/

	movia	sp, STACK          /* Set stack registers and   */
    mov fp, sp         		  /* frame pointer.             */
    call LEDFLASH	     	  /* Call Function LEDRXX		*/



END:
	br END
