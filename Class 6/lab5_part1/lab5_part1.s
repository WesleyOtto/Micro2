.equ BASE_ADDRESS, 0x10001000
.equ MASK, 0xFFFF0000
.equ FIVE_MILLION, 0x4c4b40

.global _start
_start:

	movia r1, BASE_ADDRESS
	movia r2, MASK
	movi r4, 'Z'
	movia r6, FIVE_MILLION			# R6 is the counter for the wait_loop

SPACE_LOOP:

	ldwio r3, 4(r1)					# Read conrol register
	and r5, r2, r3					# Verify space availability [WSPACE]
	beq r0, r5, SPACE_LOOP			# While there's no space, wait...

	movia r6, FIVE_MILLION			# Restore R6 value
	WAIT_LOOP:
		subi r6, r6, 1
		bne r6, r0, WAIT_LOOP  

	stwio r4, 0(r1)					# Print z on the terminal (using Data Register)
	br SPACE_LOOP					# Keep printing Z


END:
	br END