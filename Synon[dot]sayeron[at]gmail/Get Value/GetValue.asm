;GetValue

.386
.MODEL FLAT

INCLUDE io.h

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

.DATA
prompt1			BYTE		"Enter a number between 0 and"
maxValue		DWORD		?
				BYTE		"        :",0
number			BYTE		11 DUP(?)
prompt2			BYTE		"Enter a number: ",0
result			BYTE		0dh,0ah
goal			DWORD		?
				BYTE		0dh,0ah,0

.CODE
getValue		PROC		NEAR32
				pushfd
				pushad
				dtoa		maxValue,eax
				mov			ebx,eax
while_loop:		output		prompt1
				input		number,11
				atod		number
				cmp			eax,0
				jl			while_loop
				cmp			eax,ebx
				jg			while_loop
				popfd
				popad
				atod		number
				ret
getValue		ENDP

_start:
				output		prompt2
				input		number,11
				atod		number
				call		getValue
				dtoa		goal,eax
				output		result
				INVOKE 		ExitProcess,0
				
PUBLIC _start
END