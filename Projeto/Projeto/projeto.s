
.global _start
_start:

	movia r7, MSG
	movia r8, MSG_SIZE

	ldw r8, 0(r8)						# Get Message Size

PRINT:
	ldw r4, 0(r7)						# Load letter from memory

	SPACE_LOOP:

		ldwio r3, 4(r1)					# Read control register
		and r5, r2, r3					# Verify space availability [WSPACE]
		beq r0, r5, SPACE_LOOP			# While there's no space, wait...

		stwio r4, 0(r1)					# Print on the terminal (using Data Register)

		addi r7, r7, 4					# Next letter
		subi r8, r8, 1					# Counter to word size
		bne r8, r0, PRINT

END:
	br END

.org 0x500
MSG_SIZE:
.word 20
MSG:
.word 'E', 'N', 'T', 'R', 'E', ' ', 'C', 'O', 'M', ' ', 'O', ' ', 'C', 'O', 'M', 'A', 'N', 'D', 'O', ':'