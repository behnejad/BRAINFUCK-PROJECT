;GCD

.386
.MODEL FLAT

INCLUDE	io.h

ExitProcess	PROTO NEAR32 stdcall, dwExitCode:DWORD

.STACK	4096

.DATA
prompt1		BYTE	"Enter first number: ",0
prompt2		BYTE	"Enter second number: ",0
inString	BYTE	11 DUP(?)
result		BYTE	"Greatest Common Divisor is"
GCD			DWORD	?
			BYTE	0dh,0ah,0

.CODE
_start:
			output	prompt1
			input	inString,11
			atod	inString
			mov		ecx,eax
			output	prompt2
			input	inString,11
			atod	inString
			mov		ebx,eax
			mov		eax,ecx
			
until:		mov		edx,0
			idiv	ebx
			mov		eax,ebx
			mov		ebx,edx
			cmp		ebx,0
			jne		until

end_until:	
			dtoa	GCD,eax
			output	result
			INVOKE	ExitProcess,0
PUBLIC _start
END