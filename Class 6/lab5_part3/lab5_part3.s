.equ TIMER_ADDRESS, 0x10002000
.equ MASK_TO, 0x00000001			# TimeOut mask 
.equ MASK_ITO, 0x00000001			# InterruptionTimeOut mask
.equ _25MILLION, 0x17D7840			# 25 Million 

.org 0x20
	/* Exception Handler */
	rdctl et, ipending
	beq et, r0, OTHER_EXCEPTIONS

HARDWARE_EXCEPTION:					# Standard program

	subi ea, ea, 4
	ldwio r9, 12(r8)				# Word to buttons flags
	and r9, r9, r10
	bne r9, r10, END_HANDLER		# When the button is pushed, the loop ends

	stwio r0, 12(r8)				# seta 0 no edge capture do pushbutton para poder ser pressionado novamente


OTHER_EXCEPTIONS:

END_HANDLER:
	eret

.global _start
_start:

	movia r4, TIMER_ADDRESS
	movia r5, MASK_TO
	movia r6, MASK_ITO
	movia r7, _25MILLION

	stwio r0, 0(r4)					# Set TO as 0 [TimeOut register]

	stwio r10, 8(r8)				# habilita a instrução de interrupção no botao 2
	wrctl ienable, r10				# enable control registrer to puhsbutton 2
	movi r10, 1						# Set second pushbutton to be valid
	wrctl status, r10				# status == CTL0 # set PIE to 1
	movia r10, MASK



END:
	br END