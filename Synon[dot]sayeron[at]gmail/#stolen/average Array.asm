.386
.MODEL FLAT
.STACK 4096
include io.h
ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

.DATA
list				DWORD		1,2,3,4,5,50 DUP(?)
len					DWORD		5
answer				DWORD		?	

.CODE

_start:
					mov			eax,0
					lea			ebx,list
					mov			ecx,len	
					jecxz		quit
for1:
					add			eax, [ebx]
					add			ebx,4
					loop		for1

					cdq			
					idiv		len
					dtoa		answer,eax
					output		answer

quit:
					
					INVOKE	ExitProcess,0

PUBLIC		_start
END 