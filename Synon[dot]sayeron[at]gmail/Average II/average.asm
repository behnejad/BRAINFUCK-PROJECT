;Average II

.386
.MODEL FLAT

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

include io.h

.STACK 4096

.DATA
prompt1		BYTE	"This program will compute average of 4 grades.",0Dh,0Ah,"Enter first grade: ",0
prompt2		BYTE	"Enter second grade: ",0
prompt3		BYTE	"Enter third grade: ",0
prompt4		BYTE	"Enter fourth grade: ",0
value		BYTE	10 DUP(?)
answer		BYTE	"Sum is "
sum			BYTE	5 DUP(?)
			BYTE	"          and average is "
average		BYTE	5 DUP(?)
			BYTE	0Dh,0Ah,0

.CODE
_start:
			output	prompt1
			input	value,10
			atod	value
			mov		ebx,eax
			output	prompt2
			input	value,10
			atod	value
			add		ebx,eax
			output	prompt3
			input	value,10
			atod	value
			add		ebx,eax
			output	prompt3
			input	value,10
			atod	value
			imul	eax,2
			add		ebx,eax
			mov		eax,ebx
			dtoa	sum,ebx
			mov		bx,5
			mov		dx,0
			div		bx
			itoa	average,ax
			output	answer
			INVOKE 	ExitProcess,0

PUBLIC _start
END