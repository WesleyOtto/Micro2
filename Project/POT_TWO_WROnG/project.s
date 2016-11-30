.include "consts.s"
.global _start
_start:

/********************** PRINT **********************/

	movia sp, STACK 		# Set stack registers and
  mov fp, sp	      	# frame pointer.
	call PRINTF					# Call Function PRINTF

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
	beq r0, r3, WRITE			# While theres no space, wait...

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
	addi r10, r0, 31
	beq r9, r10, POW_OF_TWO
	

	br BEGIN

/********************** FUNCTIONS **********************/

LED_ON:
	addi r15, r0, 1						# r15 = 1 means the LED needs to be turned ON
	movia sp, STACK     			# Set stack registers and
	mov fp, sp         				# frame pointer.
	call SET_INTERRUPTION			#	Call Function to set INTERRUPTION

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
	add r15, r0, r0					# r15 = 0 means the LED needs to be turned OFF
	movia sp, STACK     			# Set stack registers and
	mov fp, sp         				# frame pointer.
	call SET_INTERRUPTION			#	Call Function to set INTERRUPTION

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
	movia r4, DISPLAY_BASE_ADDRESS1
	stwio r0, 0(r4)									#Clear display
	movia r4, DISPLAY_BASE_ADDRESS2
	stwio r0, 0(r4)									#Clear display

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

	add r5, r0, r0
	add r12, r0, r0
	addi r10, r0, 10

	LOOP:
		div r8, r6, r10
		mul r9, r8, r10
		sub r9, r6, r9
		add r6, r8, r0

		add r2, r11, r9			 	    # Add base address to map
		ldb r2, 0(r2)					# Load the array value on r2

		sll r2, r2, r5					# Shift to save value at the right position

		addi r5, r5, 8					# Increment to the next display (number of shift)
		or r12, r12, r2					# This OR is used to preserve previous value

		stwio r12, 0(r4)				# Set Display value

		bne r6, r0, LOOP 				# Compare r6 to 0, if r6 ==0, the number is over

	br BEGIN

DISPLAY_MSG:
	addi r15, r0, 2						# r15 = 2 means the MESSAGE DISPLAYED is goint to rotate to the LEFT
	movia sp, STACK     			# Set stack registers and
	mov fp, sp         				# frame pointer.
	call SET_INTERRUPTION			#	Call Function to set INTERRUPTION

	br BEGIN

CANCEL_ROT:
	addi r9, r0, 4
	blt r15, r9, BEGIN							# Only cancel if rotating

	add r9, r0, r0
	wrctl status, r9 		  					# turn off Nios II interrupt processing ( SET PIE = 0 )

	br 	BEGIN

	
POW_OF_TWO:
		
	# Get number (0x30 is the ASCII base value)
	
	ldw r9, 8(r8)
	subi r9, r9, 0x30
	
	ldw r6, 12(r8)
	subi r6, r6, 0x30
	
	ldw r5, 16(r8)
	subi r5, r5, 0x30

	# Multiply r9 by 10 and add to r10
	
	addi r10, r0,0x64 # Multiply to 100
	mul r9, r9, r10 
	
	addi r10, r0,0xA # Multiply to  10 
	mul  r6, r6, r10
	
	add r4, r9, r6   #Add 100 + 10 
	add r4, r4, r5   #Add 110 +  1 
	
	movia sp, STACK     			# Set stack registers and
	mov fp, sp         				# frame pointer.
	call POT_TWO					# Call thefunction
	
	movia r5, ADRESS_LCD
	movia r6, ADRESS_DATA
	movia r3, SET_FIRST_LINE
	movia r9, CLEAR_DISPLAY
	addi  r10, r0, 0xD	# 14 positions for the N_POW message (first line)

	stbio r9, 0(r5)     #Clear the display 
	stbio r3, 0(r5)	    #Set cursor 0 Location
	
	addi r11, r0, -1		#Start the counter	   				
	bne r2, r0, POW_DISPLAY # if is pow

	N_POW_LOOP:
		addi r11, r11, 0x1
		movia r8, N_POW		# R8 gets adress N_POW
		add r8, r8, r11
		ldbio r8, 0(r8)   # R8 gets the right position 
		stbio r8, 0(r6)     # Write P in display
	bne r11, r10, N_POW_LOOP	# If not equal 14 positions for the message, continue writing in display

   	movia r3, SET_SECOND_LINE  # MASK to set second line
   	stbio r3, 0(r5)	    #Set cursor second line
   	addi  r10, r0, 0x12	# 4 positions for the rest of the message (N_POW message (second line))

   	addi r11, r11, 0x1
 	N_POW_LOOP2: 
 		movia r8, N_POW		# R8 gets adress N_POW
 		add r8, r8, r11
 		ldbio r8, 0(r8)   # R8 gets the right position 
		stbio r8, 0(r6)    # Write P in display
		addi r11, r11, 0x1
	bne r11, r10, N_POW_LOOP2	# If not equal 14 positions for the message, continue writing in display

	br END_POW		

POW_DISPLAY:
	
	movia r8, POW
	addi  r10, r0, 0xE	# 15 positions for the POW message   
	POW_LOOP:
		addi r11, r11, 0x1
		movia r8, POW		# R8 gets adress N_POW
		add r8, r8, r11
		ldbio r8, 0(r8)   # R8 gets the right position 
		stbio r8, 0(r6)     # Write P in display
	bne r11, r10, POW_LOOP	# If not equal 14 positions for the message, continue writing in display


END_POW:

br BEGIN

/* Numbers for 7-segments */
MAP:
.byte 0b111111,0b110,0b1011011,0b1001111,0b1100110,0b1101101,0b1111101,0b111,0b1111111,0b1100111

/* Storing last command */
LASTCMD:
.skip 0x100

POW: 
.ascii "e potencia de 2"	
N_POW: 
.ascii "Nao e potenciade 2"