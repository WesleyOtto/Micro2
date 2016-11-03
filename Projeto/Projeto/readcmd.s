.equ MASK_RVALID, 	0x00008000	
.equ MASK_DATA, 	0x000000FF
.equ MASK_WSPACE, 	0xFFFF0000
.equ KEYBOARD, 		0x10001000
.equ ENTER,			0x0000000A

.global _start
_start:

BEGIN:
	movia r8, LASTCMD				# After ENTER rewrite these addresses

READ:
	movia r2, MASK_WSPACE
	movia r3, MASK_RVALID
	movia r4, MASK_DATA
	movia r5, KEYBOARD

	ldwio r9, 0(r5)					# R9 <- JTAG UART
	and r10, r9, r3					# Verify availability [RVALID]
	beq r10, r0, READ 				# if not avaiable, wait... 

	and r10, r9, r4					# Get data from input 

WRITE:
	ldwio r6, 4(r5)					# Read control register
	and r7, r2, r6					# Verify space availability [WSPACE]
	beq r0, r7, WRITE				# While there's no space, wait...

	stwio r10, 0(r5)				# Print char on the terminal (using Data Register)

	movia r4, ENTER
	beq r10, r4, EXECUTE			# If ENTER is hit, execute COMMAND

	stw r10, 0(r8)					# Keep command value on memory
	addi r8, r8, 4

	br READ

EXECUTE:
	movia r8, LASTCMD
	ldw r9, 0(r8)
	subi r9, r9, 0x30
	ldw r10, 4(r8)
	subi r10, r10, 0x30

	# Multiply r9 by 10 and add to r10
	slli r11, r9, 3
	slli r12, r9, 1
	add r9, r11, r12
	add r9, r9, r10

	# Test which command user entered
	addi r10, r0, 00
	beq r9, r10, LED_ON
	addi r10, r0, 01
	beq r9, r10, LED_OFF
	addi r10, r0, 10
	beq r9, r10, TRIANG_NUM
	addi r10, r0, 20
	beq r9, r10, DISPLAY_MSG
	addi r10, r0, 21
	beq r9, r10, CANCEL_ROT

	br BEGIN

LED_ON:


	br BEGIN


LED_OFF:



	br BEGIN


TRIANG_NUM:



	br BEGIN


DISPLAY_MSG:



	br BEGIN


CANCEL_ROT:



	br 	BEGIN


.org 0x100
LASTCMD: