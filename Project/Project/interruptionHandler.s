.include "consts.s"
.org 0x20
/*********************************************************/
/**********************INTERRUP***************************/
/*********************************************************/

/* Exception Handler */
	rdctl et, ipending
	beq et, r0, OTHER_EXCEPTIONS

HARDWARE_EXCEPTION:						# Standardized code

	subi ea, ea, 4

	andi r13, et, 0b1 					# interval timer is interrupt level 0
	beq r13, r0, END_HANDLER

	movia r14, TIMER_BASEADRESS
	sthio r0, 0(r14) 						# clear Time Out ( clear the interrupt )

/********************** LED FLASH **********************/
	movia r16, REDLED_BASEADDRESS
	beq	r15, r0, OFF
	addi r14, r0, 2
	beq r15, r14, DISPLAY

	ON:
		stwio r7, 0(r16)
		add r15, r0, r0
 		br END_HANDLER

	OFF:
		stwio r0, 0(r16)
		addi r15, r0, 1
		br END_HANDLER

/********************* DISPLAY ROTATE *****************/
	DISPLAY:
		movia r16, MSG_DISPLAY1
		movia r14, DISPLAY_BASE_ADDRESS1
		ldw r17, 0(r16)					# Load the array value on r17
		stwio r17, 0(r14)				# Set Display value

		movia r16, MSG_DISPLAY2
		movia r14, DISPLAY_BASE_ADDRESS2
		ldw r18, 0(r16)					# Load the array value on r18
		stwio r18, 0(r14)				# Set Display value

		/*Swift first character of messages*/
		#Message 2
		srli r19, r17, 24
		slli r20, r18, 8
		or r20, r20, r19
		stw r20, 0(r16)

		#Message 1
		movia r16, MSG_DISPLAY1
		srli r19, r18, 24
		slli r20, r17, 8
		or r20, r20, r19
		stw r20, 0(r16)

OTHER_EXCEPTIONS:
END_HANDLER:
	eret

.global SET_INTERRUPTION
SET_INTERRUPTION:

/*********************************************************/
/**********************PROLOGUE***************************/
/*********************************************************/

# Adjust the stack pointer
	addi sp, sp, -8									# make a 8-byte frame

# Store registers to the frame
	stw ra, 4(sp)										# store the return address
	stw fp, 0(sp) 									# store the frame pointer

# Set the new frame pointer
	addi fp, sp, 0

/**********************SET INTERRUPTION*******************/
	movia r9,  MASK_CPU_INTERRUP
	movia r12, TIMER_BASEADRESS
	movia r13, TIME_COUNTERH
	movia r17, TIME_COUNTERL
	movia r14, MASK_START

	bne r15, 2, SKIP_DISPLAY_TIMER
	#movia r13, TIME_COUNTERH_ROTATE - TO DO
	#movia r17, TIME_COUNTERL_ROTATE - TO DO

	SKIP_DISPLAY_TIMER:

	######****** Start interval timer, enable its interrupts ******######
	sthio r17, 8(r12)  							# Set to low value
	sthio r13, 12(r12)  						# Set to high Value
	sthio r14, 4(r12)								# Set, START, CONT, E ITO = 1

	######******enable Nios II processor interrupts******######
	wrctl ienable, r9 		  				# Set IRQ bit 0
	wrctl status, r9 		  					# turn on Nios II interrupt processing ( SET PIE = 1 )

/********************************************************/
/*********************EPILOGUE***************************/
/********************************************************/

# Restore ra, fp, sp, and registers
	mov sp, fp
	ldw ra, 4(sp)
	ldw fp, 0(sp)
	addi sp, sp, 0
ret															# Return from subroutine

MSG_DISPLAY1:
.byte 0b00010000, 0b00111111, 0b00000000, 0b00000000

MSG_DISPLAY2:
.byte 0b01111101, 0b00000110, 0b00111111, 0b01011011
