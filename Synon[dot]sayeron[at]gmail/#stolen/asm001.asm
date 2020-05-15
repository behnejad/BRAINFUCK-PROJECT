.386
.MODEL FLAT
.STACK 4096
include io.h
ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

.DATA
promptx				BYTE		"Enter x :",0
prompty				BYTE		"Enter y :",0
promptz				BYTE		"Enter z :",0
inString			BYTE		11 DUP(?)
answer				DWORD		?
					BYTE		0dh,0ah,0


.CODE

_start:
					output		promptx
					input		inString,11
					atod		inString
					mov			ebx,eax
					
					output		prompty
					input		inString,11
					atod		inString
					mov			ecx,eax
					imul		ecx,2
					neg			ecx

					output		promptz
					input		inString,11
					atod		inString
					mov			edx,eax
					imul		edx,4
					
					mov			eax,0
					add			eax,ebx
					add			eax,ecx
					add			eax,edx
					
					dtoa		answer,eax
					output		answer
					
					INVOKE	ExitProcess,0

PUBLIC		_start
END 