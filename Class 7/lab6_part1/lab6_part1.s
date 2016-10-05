
.equ PUSHBUTTON_BASE_ADDRESS, 0x10000050
.equ AUDIO_BASE_ADDRESS, 0x10003040	
.equ MASK, 0x06 					# 00000110 Button flag
.equ SAMPLES, 0x46500

.org 0x20
	/* Exception Handler */
	rdctl et, ipending
	beq et, r0, OTHER_EXCEPTIONS

HARDWARE_EXCEPTION:					# Standard program

	subi ea, ea, 4

	#Check if button 1 was pressed
	ldwio r9, 12(r4)				
	andi r9, r9, 0x2				
	bne r9, r0, KEY1

	#Check if button 2 was pressed
	ldwio r9, 12(r4)
	andi r9, r9, 0x4
	bne r9, r0, KEY2
	br END_HANDLER					

KEY1:

	# Set CR to 1 to clear the samples
	ldwio r9, 0(r3)
	ori r9, r9, 0x4
	stwio r9, 0(r3)

	# Set CR to 0 to clear the samples
	ldwio r9, 0(r3)
	addi r8, r0, 0x4
	nor r8, r8, r8
	and r9, r9, r8
	stwio r9, 0(r3)

	add r6, r6, r0					# Sample quantity
	WAIT_SAMPLE:
		ldwio r10, 4(r3)
		andi r10, r10, 0xFF
		beq r10, r0, WAIT_SAMPLE

		ldwio r10, 8(r3)
		stw r10, 0(r2)
		addi r3, r3, 4 
		addi r6, r6, 1
		bne r6, r7, WAIT_SAMPLE

	stwio r0, 12(r4)				# seta 0 no edge capture do pushbutton para poder ser pressionado novamente
	br END_HANDLER

KEY2:


	stwio r0, 12(r4)				# seta 0 no edge capture do pushbutton para poder ser pressionado novamente
	br END_HANDLER


OTHER_EXCEPTIONS:

END_HANDLER:
	eret

.global _start
_start:

	movia r2, BUFFER
	movia r3, AUDIO_BASE_ADDRESS
	movia r4, PUSHBUTTON_BASE_ADDRESS
	movia r5, MASK
	movia r7, SAMPLES

	stwio r5, 8(r4)				# habilita a instrução de interrupção no botao 2
	wrctl ienable, r5				# enable control registrer to puhsbutton 2
	movi r5, 1						# Set second pushbutton to be valid
	wrctl status, r5				# status == CTL0 # set PIE to 1
	movia r5, MASK

END:
	br END

.org 0x500
.data
BUFFER:  
.word
.skip 0x46500	
