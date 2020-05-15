;Surface

.386
.MODEL FLAT

include io.h

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

.DATA
prompt1		BYTE	"This program will evalute surface of a cube.",0Dh,0Ah,"Enter length: ",0
prompt2		BYTE	"Enter width: ",0
prompt3		BYTE	"Enter heigth: ",0
value		BYTE	40 DUP(?)
answer		BYTE	"Result is: "
result		BYTE	6 DUP(?),0Dh,0Ah,0

.CODE
_start:
			output	prompt1
			input	value,40
			atod	value
			mov		ebx,eax
			output	prompt2
			input	value,40
			atod	value
			mov		ecx,eax
			output	prompt3
			input 	value,40
			atod	value
			mov		edx,eax
			
			imul	eax,ebx
			imul	ebx,ecx
			imul	ecx,edx
			add		eax,ebx
			add		eax,ecx
			add		eax,eax
			dtoa	result,eax
			output	answer
			INVOKE	ExitProcess,0
			
PUBLIC _start
END