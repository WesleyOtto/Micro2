.include 'consts.s'
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

	movia r4, ENTER_ASCII
	beq r10, r4, EXECUTE	# If ENTER is hit, execute COMMAND
	movia r4, BACKSPACE_ASCII
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
	movia r4, DISPLAY_BASE_ADDRESS
	movia r10, SWITCH_BASE_ADDRESS
	movia r11, MAP

	# Read SWITCH number on r6
	ldwio r6, 0(r10)			
	# R5 = R6 + 1		
	addi r5, r6, 1
	# R6 = R6 * R5 [n * (n+1)]
	mul r6, r6, r5
	# R6 = R6 / 2
	srli r6, r6, 1
	
	add r15, r0, r0
	add r16, r0, r0
	addi r10, r0, 10
	
	LOOP:		
		div r8, r6, r10
		mul r9, r8, r10
		sub r9, r6, r9 
    	add r6, r8, r0

		add r2, r11, r9			 	    # Add base address to map
		ldb r2, 0(r2)					# Load the array value on r2

		sll r2, r2, r15					# Shift to save value at the right position

		addi r15, r15, 8				# Increment to the next display (number of shift)
		or r16, r16, r2					# This OR is used to preserve previous value

		stwio r16, 0(r4)				# Set Display value

		bne r6, r0, LOOP 				# Compare r6 to 0, if r6 ==0, the number is over

	br BEGIN

DISPLAY_MSG:

	br BEGIN

CANCEL_ROT:

	br 	BEGIN