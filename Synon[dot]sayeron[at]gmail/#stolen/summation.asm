;Summation Program
;SynoN SayeroN

.386
.MODEL FLAT

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

INCLUDE io.h

Cr EQU 0Dh
Lf EQU 0Ah

.STACK 4096

.DATA

number1		DWORD	?
number2		DWORD	?
prompt1		BYTE	"Enter first number: ",0
prompt2		BYTE	"Enter second number: ",0
string		BYTE	40 DUP(?)
label1		BYTE	Cr,Lf,"The sum is "
sum			BYTE	11 DUP(?)
			BYTE	Cr,Lf,0

.CODE
_START:
			output	prompt1
			input	string,40
			atod	string
			mov		number1,eax
			output	prompt2
			input	string,40
			atod	string
			mov		number2,eax
			mov		eax,number1
			add		eax,number2
			dtoa	sum,eax
			output	label1
	INVOKE	ExitProcess,0
PUBLIC _START
END