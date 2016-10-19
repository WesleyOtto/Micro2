.equ KEYBOARD, 0x10001000
.equ MASK_WSPACE, 0xFFFF0000
.equ REDLED_BASEADDRESS, 0x10000000

.global _start
_start:

/*********************************************************/
/**********************PRINT******************************/
/*********************************************************/

	movia r1, KEYBOARD
	movia r2, MASK_WSPACE
	movia r7, MSG
	movia r8, MSG_SIZE

	ldw r8, 0(r8)						# Get Message Size

PRINT:
	ldw r4, 0(r7)						# Load letter from memory

	SPACE_LOOP:

		ldwio r3, 4(r1)					# Read control register
		and r5, r2, r3					# Verify space availability [WSPACE]
		beq r0, r5, SPACE_LOOP			# While there's no space, wait...

		stwio r4, 0(r1)					# Print on the terminal (using Data Register)

		addi r7, r7, 4					# Next letter
		subi r8, r8, 1					# Counter to word size
		bne r8, r0, PRINT

/*********************************************************/
/**********************LEDRXX*****************************/
/*********************************************************/

	movia r7, REDLED_BASEADDRESS

    addi r5, r0, 9						# For a while this number is a constant. But we need to get this number from user

    addi r6, r0, 1						# Number 1 to SHIFT

    # SHIFT the r5 value to get the value to set LEDS
    SHIFT:
    	beq r5, r0, NOT_SHIFT
    	slli r6, r6, 1
    	subi r5, r5, 1
    	br SHIFT

    NOT_SHIFT:	
	stwio r6, 0(r7)

END:
	br END

.org 0x500
MSG_SIZE:
.word 20
MSG:
.word 'E', 'N', 'T', 'R', 'E', ' ', 'C', 'O', 'M', ' ', 'O', ' ', 'C', 'O', 'M', 'A', 'N', 'D', 'O', ':'