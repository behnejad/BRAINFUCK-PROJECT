;Factorial

.386
.MODEL FLAT

INCLUDE io.h

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

.STACK 4096

.DATA
prompt1			BYTE		"Enter a number: ",0
number			BYTE		11 DUP(?)
result			BYTE		0dh,0ah,"Factorial is"
answer			DWORD		?
				BYTE		0dh,0ah,0
				
.CODE
Fac				PROC		NEAR32
				push		ebp
				mov			ebp,esp
				pushfd
				
				mov			ebx,[ebp+8]
				cmp			ebx,1
				jle			base
				mul			ebx
				dec			ebx
				push		ebx
				call		Fac
				popfd
				pop			ebp
				ret			4
base:			popfd
				pop			ebp
				ret			4
Fac				ENDP

_start:			output		prompt1
				input		number,11
				atod		number
				push		eax
				mov			eax,1
				call		Fac
				dtoa		answer,eax
				output		result
				INVOKE		ExitProcess,0
				
PUBLIC _start
END