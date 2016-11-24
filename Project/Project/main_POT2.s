	.equ STACK,    0x00002000
	.equ TESTE, 0x3 
	.equ ADRESS_LCD, 0x10003050
	.equ ADRESS_DATA, 0x10003051
	.equ SET_FIRST_LINE, 0b10000000
	.equ SET_SECOND_LINE, 0b11000000
	.equ CLEAR_DISPLAY, 0x1

	.global _start
_start:

	movia sp, STACK     			# Set stack registers and
	mov fp, sp         				# frame pointer.
	movia r4, TESTE
	call POT_TWO

	movia r5, ADRESS_LCD
	movia r6, ADRESS_DATA
	movia r7, SET_FIRST_LINE
	movia r9, CLEAR_DISPLAY
	addi  r10, r0, 0xD	# 14 positions for the N_POW message (first line)


	stbio r9, 0(r5)     #Clear the display 
	stbio r7, 0(r5)	    #Set cursor 0 Location
	
	addi r11, r0, -1		#Start the counter	   				
	bne r2, r0, POW_DISPLAY # if is pow

	N_POW_LOOP:
		addi r11, r11, 0x1
		movia r8, N_POW		# R8 gets adress N_POW
		add r8, r8, r11
		ldbio r8, 0(r8)   # R8 gets the right position 
		stbio r8, 0(r6)     # Write P in display
	bne r11, r10, N_POW_LOOP	# If not equal 14 positions for the message, continue writing in display

   	movia r7, SET_SECOND_LINE  # MASK to set second line
   	stbio r7, 0(r5)	    #Set cursor second line
   	addi  r10, r0, 0x12	# 4 positions for the rest of the message (N_POW message (second line))

   	addi r11, r11, 0x1
 	N_POW_LOOP2: 
 		movia r8, N_POW		# R8 gets adress N_POW
 		add r8, r8, r11
 		ldbio r8, 0(r8)   # R8 gets the right position 
		stbio r8, 0(r6)    # Write P in display
		addi r11, r11, 0x1
	bne r11, r10, N_POW_LOOP2	# If not equal 14 positions for the message, continue writing in display

	br END		

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


END:

br END

POW: 
.ascii "e potencia de 2"	
N_POW: 
.ascii "Nao e potenciade 2"


