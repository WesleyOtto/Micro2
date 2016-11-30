/*************************** CONSTS ***************************/
.equ MASK_RVALID,               0x00008000
.equ MASK_DATA,                 0x000000FF
.equ MASK_WSPACE,               0xFFFF0000
.equ MASK_CPU_INTERRUP,         0x03
.equ MASK_START,                0x7

.equ KEYBOARD,                  0x10001000
.equ ENTER_ASCII,               0x0000000A
.equ BACKSPACE_ASCII,           0x00000008
.equ TIMER_BASEADRESS,          0x10002000
.equ TIME_COUNTERH,             0x017d 				# 25 MILION HIGH
.equ TIME_COUNTERL,             0x7840  			# 25 MILION LOW
.equ TIME_COUNTERH_ROTATE,      0x0098 				# 10 MILION HIGH
.equ TIME_COUNTERL_ROTATE,      0x9680  			# 10 MILION LOW
.equ REDLED_BASEADDRESS,        0x10000000
.equ SWITCH_BASE_ADDRESS,       0x10000040
.equ DISPLAY_BASE_ADDRESS1,     0x10000030
.equ DISPLAY_BASE_ADDRESS2,     0x10000020
.equ PUSHBUTTON_BASE_ADDRESS,	0x10000050
.equ ADRESS_LCD, 				0x10003050
.equ ADRESS_DATA, 				0x10003051
.equ SET_FIRST_LINE, 			0b10000000
.equ SET_SECOND_LINE, 			0b11000000
.equ CLEAR_DISPLAY, 			0x1

/********************** MEMORY STORAGE **********************/
.equ STACK,                     0x00002000
