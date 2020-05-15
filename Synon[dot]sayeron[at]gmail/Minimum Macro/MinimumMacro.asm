;Minimum Macro

.386
.MODEL FLAT

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

INCLUDE io.h

.STACK 4096

.DATA
prompt				BYTE				"Enter an integer: ",0
inString			BYTE				16 DUP(?)
result				BYTE				"Minimum is "
answer				DWORD				?
					BYTE				0dh,0ah,0
					
.CODE
min3				MACRO				number1,number2,number3
					LOCAL				endIf1,endIf2
					mov					eax,number1
					cmp					eax,number2
					jle					endIf1
					mov					eax,number2
endIf1:				cmp					eax,number3
					jle					endIf2
					mov					eax,number3
endIf2:				
					ENDM

_start:
					output				prompt
					input				inString,16
					atod				inString
					mov					ebx,eax
					output				prompt
					input				inString,16
					atod				inString
					mov					ecx,eax
					output				prompt
					input				inString,16
					atod				inString
					mov					edx,eax
					
					min3				ebx,ecx,edx
					dtoa				answer,eax
					output				result
					INVOKE				ExitProcess,0
					
PUBLIC _start
END