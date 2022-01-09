.include "m328pdef.inc"

;----------------------------------------------------------
.EQU KEY_PORT = PORTB
.EQU KEY_PIN = PINB
.EQU KEY_DDR = DDRB

LDI R20, HIGH(RAMEND)
OUT SPH, R20
LDI R20, LOW(RAMEND)
OUT SPL, R20

LDI R21, 0xFF
OUT DDRD, R21
LDI R20, 0xF0
OUT KEY_DDR , R20

GROUND_ALL_ROWS:
LDI R20, 0x0F
OUT KEY_PORT, R20

WAIT_FOR_RELEASE:
NOP 
IN R21, KEY_PIN
ANDI R21, 0x0F
CPI R21, 0X0F
BRNE WAIT_FOR_RELEASE

WAIT_FOR_KEY:
NOP
IN R21, KEY_PIN
ANDI R21, 0x0F
CPI R21, 0x0F
BREQ WAIT_FOR_KEY
CALL WAIT15ms
IN R21, KEY_PIN
ANDI R21, 0x0F
CPI R21, 0x0F
BREQ WAIT_FOR_KEY
LDI R21, 0b01111111
OUT KEY_PORT, R21
NOP
IN R21, KEY_PIN
ANDI R21, 0x0F
CPI R21, 0x0F
BRNE COL1

LDI R21, 0b10111111
OUT KEY_PORT, R21
NOP
IN R21,KEY_PIN
ANDI R21, 0x0F
CPI R21, 0X0F
BRNE COL2

LDI R21, 0b11011111
OUT KEY_PORT, R21
NOP 
IN R21, KEY_PIN
ANDI R21, 0x0F
CPI R21, 0x0F
BRNE COL3

LDI R21, 0b11101111
OUT KEY_PORT, R21
NOP
IN R21, KEY_PIN
ANDI R21, 0x0F
CPI R21, 0x0F
BRNE COL4

COL1:
LDI R30, LOW(KCODE0<<1)
LDI R31, HIGH(KCODE0<<1)
RJMP FIND

COL2:
LDI R30, LOW(KCODE1<<1)
LDI R31, HIGH(KCODE1<<1)
RJMP FIND

COL3:
LDI R30, LOW(KCODE2<<1)
LDI R31, HIGH(KCODE2<<1)
RJMP FIND

COL4:
LDI R30, LOW(KCODE3<<1)
LDI R31, HIGH(KCODE3<<1)
RJMP FIND

FIND:
LSR R21
BRCC MATCH 
LPM R20, Z+ 
RJMP FIND

MATCH: 
LPM R20, Z
OUT PORTD, R20
RJMP GROUND_ALL_ROWS
	
WAIT15ms:
LDI R26, 240
DELAY1: 
LDI R25, 250 
DELAY2:
DEC R25
NOP
BRNE DELAY2
DEC R26
BRNE DELAY1
RET

.ORG 0x300
KCODE0:		.DB '7' , '8' , '9' , '/'	;ROW 0 
KCODE1:		.DB '4' , '5' , '6' , '*'	;ROW 1
KCODE2:		.DB '1' , '2' , '3' , '-'	;ROW 2
KCODE3:		.DB 'C' , '0' , '=' , '+'	;ROW 3
