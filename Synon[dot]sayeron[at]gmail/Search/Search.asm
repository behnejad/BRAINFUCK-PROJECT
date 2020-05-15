;Search

.386
.MODEL FLAT

INCLUDE io.h

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

.STACK 4096

EXTRN			searchFun:NEAR32


.DATA
array			DWORD		10 DUP(?)
number			BYTE		11 DUP(?)
key				DWORD		?
prompt1			BYTE		"Enter a number: ",0
prompt2			BYTE		0dh,0ah,"Enter the value you looking for? ",0
result			BYTE		0dh,0ah,"Value found at"
answer			DWORD		?
				BYTE		0dh,0ah,0
				

.CODE
_start:
				lea			ebx,array
				mov			ecx,10
				
until:			output		prompt1
				input		number,11
				atod		number
				mov			[ebx],eax
				add			ebx,4
				loop		until
				
				output		prompt2
				input		number,11
				atod		number
				mov			key,eax
				lea			ebx,array
				mov			ecx,10
				push		key
				push		ebx
				push		ecx
				call		searchFun
				dtoa		answer,eax
				output		result
				INVOKE		ExitProcess,0
				
PUBLIC _start
END