; x-2y+4z

.386
.MODEL FLAT

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

include io.h

.STACK 4096

.DATA
prompt1		BYTE	"This Program will evaluate the expression",0Dh,0Ah,"     x-2y+4z     ",0Dh,0Ah,"Enter value for x: ",0
prompt2		BYTE	"Enter value for y: ",0
prompt3		BYTE	"Enter value for z: ",0
value		BYTE	16 DUP(?)
answer		BYTE	"Result is "
result		BYTE	6 DUP(?),0Dh,0Ah,0

.CODE
_start:
			output	prompt1
			input	value,16
			atoi	value
			mov		bx,ax
			output	prompt2
			input	value,16
			atoi	value
			add 	ax,ax
			sub		bx,ax
			output	prompt3
			input 	value,16
			atoi	value
			add		ax,ax
			add		ax,ax
			add		bx,ax
			itoa	result,bx
			output	answer
			INVOKE	ExitProcess, 0

PUBLIC _start
END