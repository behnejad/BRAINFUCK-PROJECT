;Append

.386
.MODEL FLAT

INCLUDE io.h

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

.STACK 4096

.DATA
string1				BYTE			"SynoN",0
					BYTE			40 DUP(?)
string2				BYTE			"Sayeron",0
result				BYTE			80 DUP(?)

.CODE
append				PROC			NEAR32
					push			ebp
					mov				ebp,esp
					pushfd
					pushad
					
					mov				ecx,[ebp+8]
					mov				ebx,[ebp+12]
					
while_loop:			cmp				BYTE PTR [ebx],0
					je				continue
					inc				ebx
					jmp				while_loop

continue:			mov				BYTE PTR [ebx],20h
					inc				ebx
while_loop2:		cmp				BYTE PTR [ecx],0
					je				quit
					mov				al , BYTE PTR [ecx]
					mov				[ebx],al
					inc				ebx
					inc				ecx
					jmp				while_loop2
quit:				mov				BYTE PTR [ebx],0dh
					inc				ebx
					mov				BYTE PTR [ebx],0ah
					popad
					popfd
					pop				ebp
					ret
append				ENDP

_start:
					lea				eax,[string1]
					push			eax
					lea				eax,[string2]
					push			eax
					call			append
					output			string1
					INVOKE			ExitProcess,0
PUBLIC _start
END