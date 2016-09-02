.equ DISPLAY_BASE_ADDRESS, 0x10000020
.equ SWITCH_BASE_ADDRESS, 0x10000040
.equ PUSHBUTTON_ADDRESS, 0x1000005C
.equ MASK, 0x02 					# 00000010

.global _start
_start:

	movia r4, DISPLAY_BASE_ADDRESS
	movia r5, SWITCH_BASE_ADDRESS
	movia r8, PUSHBUTTON_ADDRESS
	movia r10, MASK
	movia r11, MAP

	xor r6, r6, r6 					# Putting initial value zero at the Accumulator

WAIT:
	ldwio r9, 0(r8)					# Word to buttons flags
	and r9, r9, r10
	bne r9, r10, WAIT				# When the button is pushed, the loop ends


	ldwio r7, 0(r5)					# First value of the switch
	add r6, r6, r7					# Accumulating value



	stwio r6, 0(r4)					# Set Display value
	stwio r0, 0(r8)					# Set to 0 the value of the button
	br WAIT

END:
	br END

MAP:
.byte
00111111b, #0
00000011b, #1
01001011b, #2
01001111b, #3
01100110b, #4
01101101b, #5
01111101b, #6
00000111b, #7
01111111b, #8
01100111b, #9
01110111b, #A
01111100b, #B
00111001b, #C
01011110b, #D
01111001b, #E
01110001b  #F
