.equ DISPLAY_BASE_ADDRESS1, 0x10000030
.equ DISPLAY_BASE_ADDRESS2, 0x10000020
.equ TIMER_BASEADRESS,		0x10002000
.equ TIME_COUNTERH, 		0x017d 				# 25 MILION high (before change 0x017d)
.equ TIME_COUNTERL, 		0x7840  			# 25 MILION LOW
.equ MASK_CPU_INTERRUP,		0x1
.equ MASK_START, 			0x7

.org 0x20

/*********************************************************/
/**********************INTERRUP***************************/
/*********************************************************/

/* Exception Handler */
	rdctl et, ipending
	beq et, r0, OTHER_EXCEPTIONS

HARDWARE_EXCEPTION:						# Standardized code

	subi ea, ea, 4

	andi r13, et, 0b1
	beq r13, r0, END_HANDLER

	movia r14, TIMER_BASEADRESS
	sthio r0, 0(r14)


##############

	movia r5, MSG_DISPLAY1
	movia r4, DISPLAY_BASE_ADDRESS1
	ldw r7, 0(r5)					# Load the array value on r7	
    stwio r7, 0(r4)				    # Set Display value

	movia r5, MSG_DISPLAY2	
	movia r4, DISPLAY_BASE_ADDRESS2
	ldw r8, 0(r5)					# Load the array value on r8
	stwio r8, 0(r4)				    # Set Display value

	/*Swift first character of messages*/
	#Message 2
	srli r9, r7, 24
    slli r10, r8, 8
    or r10, r10, r9
    stw r10, 0(r5)

    #Message 1
	movia r5, MSG_DISPLAY1
	srli r9, r8, 24
    slli r10, r7, 8
    or r10, r10, r9
    stw r10, 0(r5)


OTHER_EXCEPTIONS:
END_HANDLER:
	eret

.global _start
_start:
/**********************SET INTERRUPTION*******************/

movia r9,  MASK_CPU_INTERRUP
movia r12, TIMER_BASEADRESS
movia r13, TIME_COUNTERH
movia r17, TIME_COUNTERL
movia r14, MASK_START

add r15, r0, r0						 			# Flag to LED ON or LED OFF

######****** Start interval timer, enable its interrupts ******######
sthio r17, 8(r12)  							# Set to low value
sthio r13, 12(r12)  						# Set to high Value
sthio r14, 4(r12)								# Set, START, CONT, E ITO = 1

######******enable Nios II processor interrupts******######
wrctl ienable, r9 		  				# Set IRQ bit 0
wrctl status, r9 		     			# turn on Nios II interrupt processing ( SET PIE = 1 )
    									# Return from subroutine

END:
	br END


.org 0x2500
MSG_DISPLAY1:
.byte 0b00010000, 0b00111111, 0b00000000, 0b00000000

MSG_DISPLAY2:
.byte 0b01111101, 0b00000110, 0b00111111, 0b01011011
