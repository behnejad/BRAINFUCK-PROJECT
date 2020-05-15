;Minimum

.386
.MODEL FLAT

INCLUDE io.h

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

.STACK 4096

.DATA
prompt1			BYTE		"Enter two numbers: ",0
number			BYTE		11 DUP(?)
result			BYTE		0dh,0ah,"Minimum is:"
answer			WORD		?
				BYTE		0dh,0ah,0


.CODE
Min2			PROC		NEAR32
				push		ebp
				mov			ebp,esp
				sub			esp,2
				pushfd
				pushad
				
				mov			bx,[ebp+8]
				mov			cx,[ebp+10]
				cmp			bx,cx
				jg			bxGreater
				mov			ax,bx
				jmp			_end
bxGreater:		mov			ax,cx
_end:			mov			[ebp-2],ax
				popad
				popfd
				pop			ax
				pop			ebp
				ret			4
Min2			ENDP

_start:
				output		prompt1
				input		number,11
				atoi		number
				push		ax
				input		number,11
				atoi		number
				push		ax
				call		Min2
				itoa		answer,ax
				output		result
				INVOKE		ExitProcess,0
				
PUBLIC _start
END