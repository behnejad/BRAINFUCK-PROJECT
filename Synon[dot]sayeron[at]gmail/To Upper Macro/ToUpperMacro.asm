;To Upper Macro

.386
.MODEL FLAT

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

INCLUDE io.h

.STACK 4096

.DATA
prompt				BYTE			"Enter a character: ",0
result				BYTE			"Upper Case is : "
inString			BYTE			3 DUP(?)
					BYTE			0dh,0ah,0
					
					
.CODE
toUpper				MACRO			characterAddress
					and				BYTE PTR [characterAddress],11011111b
					ENDM
					
_start:
					output			prompt
					input			inString,3
					lea				eax,inString
					toUpper			eax
					output			result
					INVOKE			ExitProcess,0
PUBLIC _start
END