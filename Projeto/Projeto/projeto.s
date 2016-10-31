.equ	STACK, 0x20000
.equ 	LED, 0x5
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

	movia	sp, STACK          /* Set stack registers and    */
  mov fp, sp         		   /* frame pointer.             */
  movia r4, LED            /* Number of LED to light     */
	call LEDRXX						  /* Call Function LEDRXX		 */


END:
	br END
