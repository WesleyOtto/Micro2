/*************************** CONSTS ***************************/
.equ MASK_RVALID,		0x00008000
.equ MASK_DATA, 		0x000000FF
.equ MASK_WSPACE, 	0xFFFF0000
.equ MASK_CPU_INTERRUP,		0x1
.equ MASK_START, 					0x7

.equ KEYBOARD, 			0x10001000
.equ ENTER_ASCII,					0x0000000A
.equ BACKSPACE_ASCII,			0x00000008
.equ TIMER_BASEADRESS,		0x10002000
.equ TIME_COUNTERH, 			0x017d 				# 25 MILION high (before change 0x017d)
.equ TIME_COUNTERL, 			0x7840  			# 25 MILION LOW
.equ REDLED_BASEADDRESS,	0x10000000
.equ SWITCH_BASE_ADDRESS, 0x10000040
.equ DISPLAY_BASE_ADDRESS, 0x10000020

/********************** MEMORY STORAGE **********************/
.equ STACK, 				0x00002000

.org 0x2500

MAP:
.byte 0b111111,0b110,0b1011011,0b1001111,0b1100110,0b1101101,0b1111101,0b111,0b1111111,0b1100111

.skip 0x100

MSG_SIZE:
.word 21
MSG:
.word 'E', 'N', 'T', 'R', 'E', ' ', 'C', 'O', 'M', ' ', 'O', ' ', 'C', 'O', 'M', 'A', 'N', 'D', 'O', ':', 0xA

.skip 0x100

LASTCMD:
