.equ MASK_RVALID,		0x00008000
.equ MASK_DATA, 		0x000000FF
.equ MASK_WSPACE, 	0xFFFF0000
.equ KEYBOARD, 			0x10001000
.equ ENTER,					0x0000000A
.equ BACKSPACE,			0x00000008
.equ STACK, 				0x00002000

.global _start
_start:

/********************** PRINT **********************/

	movia sp, STACK 		# Set stack registers and
  mov fp, sp	      	# frame pointer.
	call PRINTF					# Call Function PRINTF

	movia sp, STACK     # Set stack registers and
  mov fp, sp         	# frame pointer.
  call LEDFLASH	    	#	Call Function LEDFLASH who sets INTERRUPTION

BEGIN:
	movia r8, LASTCMD		# After ENTER rewrite these addresses

READ:
	movia r2, MASK_WSPACE
	movia r3, MASK_RVALID
	movia r4, MASK_DATA
	movia r5, KEYBOARD

	ldwio r9, 0(r5)				# R9 <- JTAG UART
	and r10, r9, r3				# Verify availability [RVALID]
	beq r10, r0, READ 		# if not avaiable, wait...

	and r10, r9, r4				# Get data from input

WRITE:
	ldwio r6, 4(r5)				# Read control register
	and r3, r2, r6				# Verify space availability [WSPACE]
	beq r0, r3, WRITE			# While there's no space, wait...

	stwio r10, 0(r5)			# Print char on the terminal (using Data Register)

	movia r4, ENTER
	beq r10, r4, EXECUTE	# If ENTER is hit, execute COMMAND
	movia r4, BACKSPACE
	beq r10, r4, ERASE		# If BACKSPACE is hit, erase last char from memory

	stw r10, 0(r8)				# Keep command value on memory
	addi r8, r8, 4

	br READ

ERASE:
	subi r8, r8, 4
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

/********************** FUNCTIONS **********************/

LED_ON:
	# Get LED number (0x30 is the ASCII base value)
	ldw r9, 8(r8)
	subi r9, r9, 0x30
	ldw r10, 12(r8)
	subi r10, r10, 0x30

	# Multiply r9 by 10 and add to r10
	slli r11, r9, 3
	slli r12, r9, 1
	add r9, r11, r12
	add r9, r9, r10

	# Set bit to turn ON the LED
	addi r10, r0, 1
	sll r10, r10, r9
	or r7, r7, r10

	br BEGIN

LED_OFF:
	# Get LED number (0x30 is the ASCII base value)
	ldw r9, 8(r8)
	subi r9, r9, 0x30
	ldw r10, 12(r8)
	subi r10, r10, 0x30

	# Multiply r9 by 10 and add to r10
	slli r11, r9, 3
	slli r12, r9, 1
	add r9, r11, r12
	add r9, r9, r10

	# Unset bit to turn OFF the LED
	addi r10, r0, 1
	sll r10, r10, r9
	nor r10, r10, r10
	and r7, r7, r10

	br BEGIN

TRIANG_NUM:

	br BEGIN

DISPLAY_MSG:

	br BEGIN

CANCEL_ROT:

	br 	BEGIN

/********************** COMMAND BUFFER **********************/
.org 0x2500
LASTCMD:
