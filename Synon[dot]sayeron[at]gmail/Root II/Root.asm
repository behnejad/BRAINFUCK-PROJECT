;Root

.386
.MODEL FLAT

INCLUDE io.h

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

.STACK 4096

.DATA
prompt1			BYTE		"Enter a number:",0
number			BYTE		11 DUP(?)
prompt2			BYTE		0dh,0ah,"Root is: "
answer			DWORD		?
				BYTE		0dh,0ah,0

EXTRN			Root:NEAR32

.CODE
_start:
				output		prompt1
				input		number,11
				atod		number
				call		Root
				dtoa		answer,eax
				output		prompt2
				INVOKE		ExitProcess,0
				
PUBLIC _start
END