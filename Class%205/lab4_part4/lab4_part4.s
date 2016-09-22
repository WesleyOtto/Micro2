.equ DISPLAY_BASE_ADDRESS, 0x10000020
.equ SWITCH_BASE_ADDRESS, 0x10000040
.equ PUSHBUTTON_BASE_ADDRESS, 0x10000050
.equ LED_BASE_ADDRESS, 0x10000010
.equ MASK, 0x02 					# 00000010 Button flag
.equ MASK2, 0xf						# 00001111 digit separator

.org 0x20
	/* Exception Handler */
	rdctl et, ipending
	beq et, r0, OTHER_EXCEPTIONS

HARDWARE_EXCEPTION:					# Standard program

	subi ea, ea, 4
	ldwio r9, 12(r8)					# Word to buttons flags
	and r9, r9, r10
	bne r9, r10, END_HANDLER		# When the button is pushed, the loop ends

	stwio r0, 12(r8)				# seta 0 no edge capture do pushbutton para poder ser pressionado novamente

	ldwio r7, 0(r5)					# First value of the switch
	add r6, r6, r7					# Accumulating value

	add r14, r6, r0					# Save the r6
	stwio r6, 0(r18)				# set green leds

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

	#stwio r0, 0(r8)					# Set to 0 the value of the button

OTHER_EXCEPTIONS:

END_HANDLER:
	eret

.global _start
_start:

	movia r4, DISPLAY_BASE_ADDRESS
	movia r5, SWITCH_BASE_ADDRESS
	movia r8, PUSHBUTTON_BASE_ADDRESS
	movia r10, MASK
	movia r11, MAP
	movia r12, MASK2
	movia r18, LED_BASE_ADDRESS

	xor r6, r6, r6 					# Putting initial value zero at the Accumulator

	stwio r10, 8(r8)				# habilita a instrução de interrupção no botao 2
	wrctl ienable, r10				# enable control registrer to puhsbutton 2
	movi r10, 1						# Set second pushbutton to be valid
	wrctl status, r10				# status == CTL0 # set PIE to 1
	movia r10, MASK

END:
	br END


.org 0x500

MAP:
.byte 0b111111,0b110,0b1011011,0b1001111,0b1100110,0b1101101,0b1111101,0b111,0b1111111,0b1100111,0b1110111,0b1111100,0b111001,0b1011110,0b1111001,0b1110001