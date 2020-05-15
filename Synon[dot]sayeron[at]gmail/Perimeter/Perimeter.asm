; Perimeter of A Rectangular

.386
.MODEL FLAT

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

include io.h

.DATA
prompt1	BYTE	"This program will evaluate perimeter of a rectangular",0Dh,0Ah,"Enter length: ",0
prompt2		BYTE	"Enter width: ",0
value		BYTE	16 DUP (?)
answer		BYTE	"perimeter is "
result		BYTE	6 DUP (?),0Dh,0Ah,0

.CODE
_start:
			output	prompt1
			input	value,16
			atod	value
			add		eax,eax
			mov		ebx,eax
			output	prompt2
			input	value,16
			atod	value
			add		eax,eax
			add		ebx,eax
			dtoa	result,ebx
			output	answer
			INVOKE	ExitProcess,0
			
PUBLIC _start
END