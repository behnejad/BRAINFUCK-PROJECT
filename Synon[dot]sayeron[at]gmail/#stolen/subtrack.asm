;SynoN SayeroN
;Subtraction Program

.386
.MODEL FLAT

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

INCLUDE io.h

.DATA
number1		DWORD	?
number2		DWORD	?
prompt1		BYTE	"Enter first number: ",0
prompt2		BYTE	"Enter second number: ",0
string		BYTE	10 DUP(?)
result		BYTE	0Dh,0Ah,"Subtrack is ",0
subtrack	BYTE	11 DUP(?)
			BYTE	0Dh,0Ah,0
			
.CODE
_START:
			output	prompt1
			input	string,10
			atod	string
			mov		number1,eax
			output	prompt2
			input	string,10
			atod	string
			mov		number2,eax
			mov		eax,number1
			sub		eax,number2
			dtoa	subtrack,eax
			output	result
			output	subtrack

	INVOKE	ExitProcess,0

PUBLIC _start
END	
			