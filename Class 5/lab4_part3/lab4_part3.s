.equ DISPLAY_BASE_ADDRESS, 0x10000020
.equ SWITCH_BASE_ADDRESS, 0x10000040
.equ PUSHBUTTON_ADDRESS, 0x1000005C
.equ MASK, 0x02 					# 00000010 Button flag
.equ MASK2, 0xf						# 00001111 digit separator

.global _start
_start:

	movia r4, DISPLAY_BASE_ADDRESS  
	movia r5, SWITCH_BASE_ADDRESS
	movia r8, PUSHBUTTON_ADDRESS
	movia r10, MASK
	movia r11, MAP
	movia r12, MASK2

	xor r6, r6, r6 					# Putting initial value zero at the Accumulator

WAIT:
	ldwio r9, 0(r8)					# Word to buttons flags
	and r9, r9, r10
	bne r9, r10, WAIT				# When the button is pushed, the loop ends

	ldwio r7, 0(r5)					# First value of the switch
	add r6, r6, r7					# Accumulating value

	add r14, r6, r0					# Save the r6

	add r15, r0, r0					# Number to shift
	add r16, r0, r0					# Auxiliar to use OR

LOOP:
	
	and r13, r6, r12				# Get the last 4 bits
	add r2, r11, r13				# Add base address to map
	ldb r2, 0(r2)					# Load the array value on r2

	sll r2, r2, r15					# Shift to save value at the right position
	addi r15, r15, 8				# Increment to the next display (number of shift)
	or r16, r16, r2					# This OR is used to preserve previous value

	stwio r16, 0(r4)				# Set Display value

	srli r6, r6, 4					# Shift goes to next number

	bne r6, r0, LOOP 				# Compare r6 to 0, if r6 ==0, the number is over 

	add r6, r14, r0					# Return the r6 value

	stwio r0, 0(r8)					# Set to 0 the value of the button
	br WAIT

END:
	br END

.org 0x500

MAP:
.byte 0b111111,0b110,0b1011011,0b1001111,0b1100110,0b1101101,0b1111101,0b111,0b1111111,0b1100111,0b1110111,0b1111100,0b111001,0b1011110,0b1111001,0b1110001
