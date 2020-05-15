;Summation Macro

.386
.MODEL FLAT

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

INCLUDE io.h

.STACK 4096

.DATA
prompt				BYTE			"Enter an integer: ",0
inString			BYTE			16 DUP(?)
result				BYTE			0dh,0ah,"Summation is: "
answer				DWORD			?
					BYTE			0dh,0ah,0
					
.CODE
add3				MACRO			number1,number2,number3
mov					eax,number1
add					eax,number2
add					eax,number3
					ENDM

_start:
					output			prompt
					input			inString,16
					atod			inString
					mov				ecx,eax
					output			prompt
					input			inString,16
					atod			inString
					mov				ebx,eax
					output			prompt
					input			inString,16
					atod			inString
					add3			eax,ebx,ecx
					dtoa			answer,eax
					output			result
					INVOKE			ExitProcess,0
PUBLIC _start
END