;Min Macro

.386
.MODEL FLAT

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

INCLUDE io.h

.STACK 4096

.DATA
prompt				BYTE			"Enter an integer: ",0
inString			BYTE			16 DUP(?)
result				BYTE			"Minimum is "
answer				DWORD			?
					BYTE			0dh,0ah,0

.CODE
min3				MACRO			n1,n2,n3,extra
					LOCAL			endIf1,endIf2
					
					IFB				<n1>
					.ERR			<"First argument missing!">
					EXITM
					ENDIF
					
					IFB				<n2>
					.ERR			<"Second argument missing!">
					EXITM
					ENDIF
					
					IFB				<n3>
					.ERR			<"Third argument missing!">
					EXITM
					ENDIF
					
					IFNB			<extra>
					.ERR			<"More than three arguments!">
					EXITM
					ENDIF
					
					mov				eax,n1
					cmp				eax,n2
					jle				endIf1
					mov				eax,n2
endIf1:
					cmp				eax,n3
					jle				endIf2
					mov				eax,n3
endIf2:
					ENDM
					
_start:
					output			prompt
					input			inString,16
					atod			inString
					mov				edx,eax
					
					output			prompt
					input			inString,16
					atod			inString
					mov				ecx,eax
					
					output			prompt
					input			inString,16
					atod			inString
					mov				ebx,eax
					
					min3			edx,ecx,ebx
					dtoa			answer,eax
					output			result
					INVOKE			ExitProcess,0
					
PUBLIC _start
END