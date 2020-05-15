;Maximum Macro

.386
.MODEL FLAT

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

INCLUDE io.h

.STACK 4096

.DATA
prompt			BYTE			"Enter an integer: ",0
inString		BYTE			16 DUP(?)
result			BYTE			"Maximum is "
answer			DWORD			?
				BYTE			0dh,0ah,0

.CODE
max2			MACRO			number1,number2
				LOCAL			endIf
				mov				eax,number1
				cmp				eax,number2
				jge				endIf
				mov				eax,number2
				
endIf:			
				ENDM

_start:
				output			prompt
				input			inString,16
				atod			inString
				mov				ebx,eax
				output			prompt
				input			inString,16
				atod			inString
				mov				ecx,eax
				max2			ebx,ecx
				dtoa			answer,eax
				output			result
				INVOKE			ExitProcess,0
PUBLIC _start
END