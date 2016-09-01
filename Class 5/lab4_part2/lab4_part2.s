.equ LED_BASE_ADDRESS, 0x10000010
.equ SWITCH_BASE_ADDRESS, 0x10000040
.equ PUSHBUTTON_ADDRESS, 0x1000005C # Third push button from left to right
.equ MASK, 0x02 					# 00000010
/* we use this maske because we need push button 3 active...
PUSH BUTTONS (PBs): 0 0 1 0 == PB1 PB2 PB3 PB4 (we need pb3 active) */

.global _start
_start:

	movia r4, LED_BASE_ADDRESS
	movia r5, SWITCH_BASE_ADDRESS
	movia r8, PUSHBUTTON_ADDRESS
	movia r10, MASK

	xor r6, r6, r6 					# Putting initial value zero at the Accumulator

WAIT:
	ldwio r9, 0(r8)					# Word to buttons flags
	and r9, r9, r10
	bne r9, r10, WAIT				# When the button is pushed, the loop ends


	ldwio r7, 0(r5)					# First value of the switch
	add r6, r6, r7					# Accumulating value
	stwio r6, 0(r4)					# Set LEDs value
	stwio r0, 0(r8)					# Set to 0 the value of the button
	br WAIT

END:
	br END
