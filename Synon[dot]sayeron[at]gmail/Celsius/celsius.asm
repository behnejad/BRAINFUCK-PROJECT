;Celsius

.386
.MODEL FLAT

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

include io.h

.STACK 4096

.DATA
prompt1		BYTE	"This program will conver a fahrenheit temperature to the celsius scale.",0Dh,0Ah,"Enter fahrenheit temperature: ",0
value		BYTE	10 DUP(?)
answer		BYTE	0Dh,0Ah,"The temperature is "
result		BYTE	6 DUP(?)
			BYTE	" celsius.",0Dh,0Ah,0
			
.CODE
_start:
			output	prompt1
			input	value,10
			atod	value
			sub		eax,32
			imul	eax,5
			mov		bx,9
			mov		edx,0
			idiv	bx
			itoa	result,ax
			output	answer
			INVOKE	ExitProcess,0

PUBLIC _start
END