;Integer To Octal


.386
.MODEL FLAT

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

INCLUDE io.h

.STACK 4096

.DATA
prompt				BYTE				"Enter an integer: ",0
number				BYTE				11 DUP(?)
result				BYTE				"Octal form is: "
answer				BYTE				6 DUP(?)
					BYTE				0dh,0ah,0

.CODE
splitOctal			PROC				NEAR32
					push				ebp
					mov					ebp,esp
					pushad
					pushfd
					
					mov					ebx,[ebp+8]
					mov					ax,[ebp+12]
					rol					ax,1
					mov					dl,al
					and					dl,00000001b
					add					dl,30h
					mov					BYTE PTR [ebx],dl
					inc					ebx
					mov					ecx,5
while_loop:			rol					ax,3
					mov					dl,al
					and					dl,00000111b
					add					dl,30h
					mov					BYTE PTR [ebx],dl
					inc					ebx
					loop				while_loop
					
					popfd
					popad
					pop					ebp
					ret					6
splitOctal			ENDP

_start:
					output				prompt
					input				number,11
					atoi				number
					push				ax
					lea					eax,answer
					push				eax
					call				splitOctal
					output				result
					INVOKE				ExitProcess,0
PUBLIC _start
END