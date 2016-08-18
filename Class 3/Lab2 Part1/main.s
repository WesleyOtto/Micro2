/* Arquivo principal - parte 1 do laboratorio 2 */

.equ	STACK, 0x10000


/*****************************************************************************/
/* Program principal                                                         */
/*   Invoca sub-rotina para ordenar lista de valores em ordem decrescente.   */
/*                                                                           */
/* r8  - Endereco do tamanho da lista de numeros                             */
/* r9  - Endereco do primeiro numero na lista                                */
/*****************************************************************************/
.global _start
_start:
    movia	sp, STACK          /* Configura registradores da pilha e    */
    mov		fp,  sp            /* e frame pointer.                      */

    movia	r8,  SIZE          /* Endereço do tamanho                   */
    movia	r9,  LIST          /* Endereço do primeiro elemento         */

    ldw     	r4, 0(r8)          /* Carrega os parâmetros para sub-rotina */
    mov	    	r5, r9
    
    call	SORT

END:
    br		END              /* Espera aqui quando o programa terminar  */


.org	0x500
LIST_FILE:
SIZE:
.word	0
LIST:
.skip   300*4

.end

