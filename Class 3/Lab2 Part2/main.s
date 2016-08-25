/* Arquivo principal - parte 2 do laboratorio 2 */

.equ	STACK, 0x10000
.equ 	LIST_FILE, 0x500


/*****************************************************************************/
/* Program principal                                                         */
/*   Fibonacci Recursivo					                                 */
/*****************************************************************************/

.global _start
_start:
    movia	sp, STACK          /* Configura registradores da pilha e    */
    mov		fp,  sp            /* e frame pointer.                      */

    movia	r8, LIST_FILE           /* N address */

    ldw     	r4, 0(r8)          /* Carrega os parâmetros para sub-rotina */
    
    call	FIBONACCI

END:
    br		END              /* Espera aqui quando o programa terminar  */


.org	0x500
N:
.word	8

.end

