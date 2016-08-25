.equ LED_BASE_ADDRESS, 0x10000010
.equ SWITCH_BASE_ADDRESS, 0x10000040

.global _start
_start:

	movia r4, LED_BASE_ADDRESS  
	movia r5, SWITCH_BASE_ADDRESS

	xor r6, r6, r6 					# Putting initial value zero at the Accumulator

LOOP:
	ldwio r7, 0(r5)					# First value of the switch
	add r6, r6, r7					# Accumulating value
	stwio r6, 0(r4)					# Set LEDs value
	br LOOP

END:
	br END