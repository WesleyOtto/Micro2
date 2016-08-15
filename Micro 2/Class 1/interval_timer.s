.include "nios_macros.s"
.include "address_map.s"

/*****************************************************************************
 * Interval Timer - Interrupt Service Routine                                
 *   Must write to the Interval Timer to clear it. 
 *                                                                          
 * Shifts the text being displayed in the hex displays, either right or left.
 * Also toggles the values of the green LEDs so that they will flash.
 * 
 * r2 - display shift direction; parameter passed in and out
 * r3 - Green LED pattern; parameter passed in and out 
 * r4 - display buffer pointer parameter; passed in
******************************************************************************/
.global INTERVAL_TIMER_ISR
INTERVAL_TIMER_ISR:					
	subi		sp,  sp, 20		# reserve space on the stack 
   stw		ra, 0(sp)
   stw		fp, 4(sp)
   stw		r10, 8(sp)
   stw		r16, 12(sp)
   stw		r17, 16(sp)
	addi		fp,  sp, 20

	movia		r10, INTERVAL_TIMER_BASE
	sthio		r0,  0(r10)				# Clear the interrupt 

	/* current Green LED states are passed in r3 */
	xori		r3, r3, 0xFFFF
	xorhi		r3, r3, 0xFFFF
	movia		r10, GREEN_LED_BASE
	stwio		r3, 0(r10)

CHECK_SHIFT:
	/* if the current shift direction is to the right, then the shift should be reversed
	 * when the first and second words are zero; the shift should be reversed for the left
	 * shift direction when the third word is zero and the least significant half of the
	 * second word is zero.
	 */

	/* DISPLAY_BUFFER address is passed in r4, shift direction is in r2 */
	mov		r16, r4
	ldw		r17, 4(r16)				# second word 
	
	
	beq	r2, zero, GOING_LEFT		# If r2 is zero, we are going left, check second and third words.
GOING_RIGHT:						# Otherwise we are going right, so check the first and second words.
	cmpeq r17, r17, zero			# If r17 is not 0, end program.
	beq	r17, zero, SRS_DONE			# So we go to done.
	ldw	r17, 0(r16)					#Load in the first word
	beq	r17, zero, DO_REVERSE_SHIFT	#if r17 is 0, we can do reverse shift
	br SRS_DONE							#Otherwise we are done
	
GOING_LEFT:
	andi r17, r17, 0x0000FFFF		#Check only bottom half of second word if travelling left
	cmpeq r17, r17, zero			# If r17 is not 0, end program.
	beq	r17, zero, SRS_DONE			# So we go to done.
	ldw	r17, 8(r16)					#Load in the third word
	beq	r17, zero, DO_REVERSE_SHIFT	#if r17 is 0, we can do reverse shift
	br SRS_DONE						#Otherwise we are done

SRS_DONE:
	br		DO_SHIFT				# Make the shift not change

DO_REVERSE_SHIFT:
	xori		r2, r2, 1					# toggle shift direction 

DO_SHIFT:
	beq 		r2, zero, DO_LEFT_SHIFT

DO_RIGHT_SHIFT:
	call 		SHIFT_BUFFER_RIGHT			# buffer pointer passed in r4 
	br 		END_INTERVAL_TIMER_ISR

DO_LEFT_SHIFT:
	call		SHIFT_BUFFER_LEFT			# buffer pointer passed in r4 

END_INTERVAL_TIMER_ISR:
   ldw		ra, 0(sp)				# Restore all used register to previous 
   ldw		fp, 4(sp)
   ldw		r10, 8(sp)
   ldw		r16, 12(sp)
   ldw		r17, 16(sp)
   addi		sp,  sp, 20			# release the reserved space on the stack 

	ret

/********************************************************************************
 * Shifts the buffer by one hex digit to the right.
 *
 * r4 is used to pass display buffer pointer
 */
.global SHIFT_BUFFER_RIGHT
SHIFT_BUFFER_RIGHT:
	/* save registers */
	subi		sp, sp, 20		# reserve space on the stack 
	stw 		ra, 0(sp)
	stw 		fp, 4(sp)
	stw		r16, 8(sp)
	stw		r17, 12(sp)
	stw		r18, 16(sp)
	addi 		fp, sp, 20

	mov		r16, r4

	/* shift third word */
	ldw		r17, 8(r16)				# third word 
	ldw		r18, 4(r16)				# second word 
	srli		r17, r17, 4
	slli		r18, r18, 28			# put least significant nibble of second word at the 
	or			r17, r17, r18			# most significant nibble of third word 
	stw		r17, 8(r16)

	/* shift second word */
	ldw		r17, 4(r16)				# second word 
	ldw		r18, 0(r16)				# first word 
	srli		r17, r17, 4
	slli		r18, r18, 28			# put least significant nibble of second word at the 
	or			r17, r17, r18			# most significant nibble of third word 
	stw		r17, 4(r16)

	/* shift first word */
	ldw		r17, 0(r16)				# first word 
	srli		r17, r17, 4
	stw		r17, 0(r16)

	/* restore registers */
	ldw		ra, 0(sp)
	ldw		fp, 4(sp)
	ldw		r16, 8(sp)
	ldw		r17, 12(sp)
	ldw		r18, 16(sp)
	addi		sp, sp, 20			# release the reserved space on the stack 

	ret

/********************************************************************************
 * Shifts the buffer by one hex digit to the left.
 *
 * r4 is used to pass display buffer pointer
 */
.global SHIFT_BUFFER_LEFT
SHIFT_BUFFER_LEFT:
	/* save registers */
	subi		sp, sp, 20				# reserve space on the stack 
	stw 		ra, 0(sp)
	stw 		fp, 4(sp)
	stw		r16, 8(sp)
	stw		r17, 12(sp)
	stw		r18, 16(sp)
	addi 		fp, sp, 20

	mov		r16, r4

	/* shift first word */
	ldw		r17, 0(r16)				# first word 
	ldw		r18, 4(r16)				# second word 
	slli		r17, r17, 4
	srli		r18, r18, 28			# put most significant nibble of second word at the 
	or			r17, r17, r18			# least significant nibble of first word 
	stw		r17, 0(r16)

	/* shift second word */
	ldw		r17, 4(r16)				# second word 
	ldw		r18, 8(r16)				# third word 
	slli		r17, r17, 4
	srli		r18, r18, 28			# put most significant nibble of third word at the 
	or			r17, r17, r18			# least significant nibble of second word 
	stw		r17, 4(r16)

	/* shift third word */
	ldw		r17, 8(r16)				# third word 
	slli		r17, r17, 4
	stw		r17, 8(r16)

	/* restore registers */
	ldw		ra, 0(sp)
	ldw		fp, 4(sp)
	ldw		r16, 8(sp)
	ldw		r17, 12(sp)
	ldw		r18, 16(sp)
	addi		sp, sp, 20			# release the reserved space on the stack 

	ret

.end
	
