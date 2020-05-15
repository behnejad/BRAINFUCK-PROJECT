;Double To Binary

.386
.MODEL FLAT

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

INCLUDE io.h

.STACK 4096


.DATA
prompt				BYTE			"Enter an integer: ",0
inString			BYTE			11 DUP(?)
result				BYTE			"Binary form is: "
answer				BYTE			32 DUP(?)
					BYTE			0dh,0ah,0

.CODE
binaryString		PROC			NEAR32
					push			ebp
					mov				ebp,esp
					pushad
					pushfd
					
					mov				ebx,[ebp+8]
					mov				eax,[ebp+12]
					mov				ecx,32
while_loop:			cmp				ecx,0
					je				end_while
					rol				eax,1
					jnc				label1
					mov				BYTE PTR [ebx],31h
					dec				ecx
					inc				ebx
					jmp				while_loop
label1:				mov				BYTE PTR [ebx],30h
					dec				ecx
					inc				ebx
					jmp				while_loop
end_while:
					popfd
					popad
					pop				ebp
					ret				8
binaryString		ENDP

_start:
					output			prompt
					input			inString,11
					atod			inString
					push			eax
					lea				ebx,answer
					push			ebx
					call			binaryString
					output			result
					INVOKE			ExitProcess,0
PUBLIC _start
END