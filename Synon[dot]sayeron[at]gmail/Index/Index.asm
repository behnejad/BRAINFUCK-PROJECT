;Index

.386
.MODEL FLAT

INCLUDE io.h

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

.STACK 4096

.DATA
string			BYTE			"SynoN Sayeron",0
result			BYTE			"Character found at"
answer			DWORD			?
				BYTE			0dh,0ah,0

.CODE
index			PROC			NEAR32
				push			ebp
				mov				ebp,esp
				pushfd
				
				mov				ebx,[ebp+8]
				mov				dx,[ebp+12]
				mov				cl,dl
				mov				eax,1
while_loop:		cmp				BYTE PTR [ebx],cl
				je				quit
				inc				ebx
				cmp				BYTE PTR [ebx],0
				je				notIn
				inc				eax
				jmp				while_loop
notIn:			mov				eax,0
quit:			popfd
				pop				ebp
				ret
index			ENDP

_start:
				mov				al,'o'
				push			ax
				lea				eax,string
				push			eax
				call			index
				dtoa			answer,eax
				output			result
				INVOKE			ExitProcess,0
PUBLIC _start
END