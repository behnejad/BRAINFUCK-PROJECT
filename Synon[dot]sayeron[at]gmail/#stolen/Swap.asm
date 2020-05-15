;Swap

.386
.MODEL FLAT

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

INCLUDE io.h

.STACK 4096

.DATA
prompt1				BYTE			"Enter integer#1: ",0
prompt2				BYTE			"Enter integer#2: ",0
inString			BYTE			16 DUP(?)
result				BYTE			0dh,0ah,"Integer#1: "
number1				DWORD			?
					BYTE			"        ",0ah,0dh,"Integer#2: "
number2				DWORD			?
					BYTE			0dh,0ah,0
					

.CODE
swap				MACRO			dword1,dword2,extra
					IFB				<dword1>
					.ERR			<"First argument missing!">
					EXITM
					ENDIF
					
					IFB				<dword2>
					.ERR			<"Second argument missing!">
					EXITM
					ENDIF
					
					IFNB			<extra>
					.ERR			<"More than two arguments!">
					EXITM
					ENDIF
					
					push			eax
					mov				eax,dword1
					xchg			eax,dword2
					mov				dword1,eax
					pop				eax
					ENDM
					
_start:
					output			prompt1
					input			inString,16
					atod			inString
					mov				number1,eax
					
					output			prompt2
					input			inString,16
					atod			inString
					mov				number2,eax
					
					;swap			number1
					;swap			,number2
					;swap			number1,number2,eax
					swap			number1,number2
					
					dtoa			number1,number1
					dtoa			number2,number2
					output			result
					INVOKE			ExitProcess,0
					
PUBLIC _start
END