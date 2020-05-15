;Average

.386
.MODEL FLAT

INCLUDE io.h

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

.STACK 4096

EXTRN			averageFun:NEAR32

.DATA
prompt1			BYTE		"Enter number: ",0
number			BYTE		11 DUP(?)
array			DWORD		10 DUP(?)
result			BYTE		0dh,0ah,"Average is"
answer			DWORD		?
				BYTE		0dh,0ah,0

.CODE
_start:
				mov			ecx,10
				lea			ebx,array
until:			output		prompt1
				input		number,11
				atod		number
				mov			[ebx],eax
				add			ebx,4
				loop		until
				lea			ebx,array
				mov			ecx,10
				lea			edx,answer
				push		ebx
				push		ecx
				push		edx
				call		averageFun
				pop			eax
				add			esp,8
				dtoa		answer,eax
				output		result
				INVOKE		ExitProcess,0

PUBLIC _start
END