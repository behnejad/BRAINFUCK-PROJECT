;Maximum And Minimum

.386
.MODEL FLAT

INCLUDE io.h

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

.STACK 4096

.DATA
prompt1		BYTE	"Enter first number: ",0
number		BYTE	11 DUP(?)
prompt2		BYTE	"Enter number: ",0
prompt3		BYTE	0dh,0ah,"Maximum is"
max			DWORD 	?
			BYTE	"        and minimum is"
min			DWORD	?
			BYTE	".",0dh,0ah,0

.CODE
_start:
			output	prompt1
			input	number,11
			atod	number
			mov		ebx,eax
			mov		ecx,eax
			mov		edx,1
while_loop:	cmp		eax,ebx
			jle     checkLess
			mov		ebx,eax
			jmp		getNumber
checkLess:	cmp		eax,ecx
			jge		getNumber
			mov		ecx,eax
			jmp		getNumber
			
getNumber:	inc		edx
			cmp		edx,10
			jg		end_while
			output  prompt2
			input	number,11
			atod	number
			jmp		while_loop
			
end_while:	dtoa	max,ebx
			dtoa	min,ecx
			output	prompt3
			
			INVOKE	ExitProcess,0
PUBLIC _start
END