.equ MASK_CPU_INTERRUP,		0x1
.equ MASK_START, 					0x7
.equ TIMER_BASEADRESS,		0x10002000
.equ TIME_COUNTERH, 			0x017d 				#25 MILION high
.equ TIME_COUNTERL, 			0x7840  			#25 MILION LOW
.equ REDLED_BASEADDRESS,	0x10000000

.org 0x20
/*********************************************************/
/**********************INTERRUP****************************/
/*********************************************************/

 /* Exception Handler */

	rdctl et, ipending
	beq et, r0, OTHER_EXCEPTIONS

HARDWARE_EXCEPTION:					# Standard program

	andi r22, et, 0b1 				#interval timer is interrupt level 0
	beq r22,r0,END_HANDLER

	sthio r0,0(r12) 					#clear Time Out ( clear the interrupt )
	addi r16,r0,0x10

	########TESTE#########
		addi r16,r0,0x5
	 addi r10, r0, 1
  ########TESTE########

	ON:
		bne	r15,r0,OFF
		stwio r7, 0(r8)
		addi r15, r0, 1
 		br END_HANDLER

	OFF:
		stwio r0, 0(r8)
		add r15, r0, r0

	OTHER_EXCEPTIONS:
	END_HANDLER:
		eret

.global LEDFLASH
LEDFLASH:

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
/**********************LEDFLASH*****************************/
/*********************************************************/

movia r8,  REDLED_BASEADDRESS
movia r9,  MASK_CPU_INTERRUP
movia r12, TIMER_BASEADRESS
movia r13, TIME_COUNTERH
movia r17, TIME_COUNTERL
movia r14, MASK_START

add r15,r0,r0						 #Flag to LED ON or LED OFF

########TESTE#########

movia r7, 0x1
xor r16,r16,r16

######****** Start interval timer, enable its interrupts ******######

sthio r13, 8(r12)  			#Set to low value
sthio r17, 12(r12)  		# Set to high Value
sthio r14, 4(r12)			  # Set, START, CONT, E ITO = 1

######******enable Nios II processor interrupts******######

wrctl ienable, r9 		  #Set IRQ bit 0
wrctl status, r9 			  #turn on Nios II interrupt processing ( SET PIE = 1 )

END:

br END

/********************************************************/
/*********************EPILOGO****************************/
/********************************************************/

 /*Restore ra, fp, sp, and registers */

	mov sp, fp
	ldw ra, 4(sp)
	ldw fp, 0(sp)
	addi sp, sp, 0
/* Return from subroutine */
ret
