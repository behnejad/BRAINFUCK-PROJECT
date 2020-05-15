;SynoN Sayeorn
;Summation of three integers

.386
.MODEL FLAT

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

INCLUDE io.h

.DATA	
number1 	DWORD	?
number2 	DWORD	?
number3 	DWORD	?
prompt1 	BYTE	"Enter first number: ",0
prompt2		BYTE	"Enter second number: ",0
prompt3		BYTE	"Enter third number: ",0
string		BYTE	10 DUP(?)
result		BYTE	0Dh,0Ah,"Sum is ",0
sum			BYTE	11 DUP(?)
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
			output	prompt3
			input	string,10
			atod	string
			mov		number3,eax
			mov		eax,number1
			add		eax,number2
			add		eax,number3
			dtoa	sum,eax
			output	result
			output	sum
	INVOKE	ExitProcess,0

PUBLIC _start
END	