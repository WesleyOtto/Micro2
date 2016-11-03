.equ MASK_TIME_OUT,			0x1
.equ MASK_START, 			0x7
.equ TIMER_BASEADRESS,	   	0x10002000
.equ TIME_COUNTERH, 		0x017d 	#25 Milhões parte alta
.equ TIME_COUNTERL, 		0x7840  #25 milhões parte baixa
.equ REDLED_BASEADDRESS, 	0x10000000

.org 0x20
/*********************************************************/
/**********************INTERRUP****************************/
/*********************************************************/

	addi r16,r0,0x15

/* Exception Handler */
	rdctl et, ipending
	beq et, r0, OTHER_EXCEPTIONS

HARDWARE_EXCEPTION:					# Standard program

	addi r16,r0,0x10

	subi ea, ea, 4
	ldwio r11, 0(r12)					#Load Reg Control
	and r11, r11, r9
	bne r9, r11, END_HANDLER	#Verifico se Time_out está setado

	#Status Register Counter (TO, RUN)
	addi r16,r0,0x5
	addi r10, r0, 1 						# Number 1 to SHIFT

	ON:
		bne	r15,r0,OFF
		stwio r7, 0(r8)
		addi r15, r0, 1
 		br END_HANDLER

	OFF:
		stwio r0, 0(r8)
		add r15, r0, r0

	# Counter registers
	  sthio r14, 4(r12)			# Set to start the Counter -

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
movia r9,  MASK_TIME_OUT
movia r12, TIMER_BASEADRESS
movia r13, TIME_COUNTERH
movia r17, TIME_COUNTERL
movia r14, MASK_START

add r15,r0,r0
movia r7, 0x1
xor r16,r16,r16

sthio r13, 8(r12)  #Set to Counter start Value with 25 MILION
sthio r17, 12(r12) #

# Start interval timer, enable its interrupts
sthio r14, 4(r12)			# Set to start the Counter 
wrctl ienable, r9
wrctl status, r9


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
