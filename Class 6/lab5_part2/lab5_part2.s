.equ MASK_RVALID, 	0x00008000	
.equ MASK_DATA, 	0x000000FF
.equ MASK_WSPACE, 	0xFFFF0000
.equ KEYBOARD, 		0x10001000

.global _start
_start:

	movia r2, MASK_WSPACE
	movia r3, MASK_RVALID
	movia r4, MASK_DATA
	movia r5, KEYBOARD

READ:
	ldwio r9, 0(r5)					# R9 <- JTAG UART
	and r10, r9, r3					# Verify availability [RVALID]
	beq r10, r0, READ 				# if not avaiable, wait... 

	and r10, r9, r4					# Get data from input 

WRITE:
	ldwio r6, 4(r5)					# Read control register
	and r7, r2, r6					# Verify space availability [WSPACE]
	beq r0, r7, WRITE				# While there's no space, wait...

	stwio r10, 0(r5)				# Print char on the terminal (using Data Register)
	br READ