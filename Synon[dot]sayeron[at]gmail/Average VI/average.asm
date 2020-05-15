;Average

.386
.MODEL FLAT

INCLUDE io.h

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

.STACK	4096

.DATA
prompt1		BYTE	"Enter number: ",0
number		BYTE	11 DUP(?)
result		BYTE	"Sum is"
sum			DWORD	?
			BYTE	"                 Average is"
average		DWORD	?
			BYTE	0dh,0ah,0
			
.CODE
_start:
			mov		eax,0
			mov		ebx,0
			mov		ecx,0
while_loop:	output	prompt1
			input	number,11
			atod	number
			cmp		eax,-9999
			je		end_while
			add		ebx,eax
			inc		ecx
			jmp		while_loop
end_while:
			dtoa	sum,ebx
			mov		eax,ebx
			cdq
			idiv	ecx
			dtoa	average,eax
			output	result
			
			INVOKE	ExitProcess,0
PUBLIC _start
END