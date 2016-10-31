.equ MASK_TIME_OUT,			 0x1
.equ MASK_START, 				 0x4
.equ TEMP_BASEADRESS,	   0x10002000
.equ TIME_COUNTER , 		 0x17D7840 	#25 Milhões
.equ REDLED_BASEADDRESS, 0x10000000

.org 0x200
/*********************************************************/
/**********************INTERRUP****************************/
/*********************************************************/

HARDWARE_EXCEPTION:					# Standard program

	subi ea, ea, 4
	ldwio r11, 4(12)					#Load Reg Control
	and r11, r11, r9
	bne r9, r11, END_HANDLER	#Verifico se Time_out está setado

	#Status Register Counter (TO, RUN)

	addi r10, r0, 1 						# Number 1 to SHIFT

	ON:
		bne	r15,r0,OFF
		sll r10, r10, r4        # SHIFT the r4 value to get the value to set LEDS
		stwio r10, 0(r8)
		addi r15,r0,1
 		br AGAIN_COUNT

	OFF:
		mov r10,r0
		stwio r10, 0(r8)
		addi r15,r0,-1

	AGAIN_COUNT:
	  stwio r13, 8(r12)  #Set to Counter start Value with 25 MILION

	# Counter registers
	  stwio r14, 4(r12)			# Set to start the Counter -

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
movia r12, TEMP_BASEADRESS
movia r13, TIME_COUNTER
movia r14, MASK_START
add r15,r0,r0

stwio r13, 8(r12)  #Set to Counter start Value with 25 MILION

# Counter registers
stwio r14, 4(r12)			# Set to start the Counter -

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
