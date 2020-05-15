;Greatest Common Divisor

.386
.MODEL FLAT

INCLUDE io.h

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

.STACK 4096

.DATA
prompt1			BYTE		"Enter two numbers: ",0
number			BYTE		11 DUP(?)
result			BYTE		0dh,0ah,"GCD is"
answer			DWORD		?
				BYTE		0dh,0ah,0
				
.CODE
GCD				PROC		NEAR32
				push		ebp
				mov			ebp,esp
				pushfd
				
				mov			eax,[ebp+12]
				mov			ebx,[ebp+8]
				cmp			ebx,0
				jle			eaxIs
				mov			ecx,ebx
				cdq
				div			ebx
				mov			ebx,edx
				mov			eax,ecx
				push		eax
				push		ebx
				call		GCD
				popfd
				pop			ebp
				ret			8
				
				
eaxIs:			
				popfd
				pop			ebp
				ret			8
GCD				ENDP

_start:
				output		prompt1
				input		number,11
				atod		number
				push		eax
				input		number,11
				atod		number
				push		eax
				call		GCD
				dtoa		answer,eax
				output		result
				INVOKE		ExitProcess,0

PUBLIC _start
END