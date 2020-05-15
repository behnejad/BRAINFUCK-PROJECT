.386
.MODEL FLAT
.STACK 4096
include io.h
ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

.DATA

promptlength		BYTE		"Enter Length:",0
promptwidth			BYTE		"Enter Width:",0
promptheight		BYTE		"Enter Height:",0
l					DWORD		?
w					DWORD		?
h					DWORD		?
inString			BYTE		11 DUP(?)

answer				DWORD		?
					BYTE		0dh,0ah,0



.CODE

_start:
					output		promptlength
					input		inString,11
					atod		inString
					mov			l,eax
					
					output		promptwidth
					input		inString,11
					atod		inString
					mov			w, eax

					output		promptheight
					input		inString,11
					atod		inString
					mov			h, eax
				
					mov			eax, l
					imul		eax, w

					mov			ebx, w
					imul		ebx, h
					
					mov			ecx, h
					imul		ecx, l

					add			eax, ebx
					add			eax, ecx
	
					imul		eax, 2
	
					
					dtoa		answer,eax
					output		answer
					
					INVOKE	ExitProcess,0
					
							


PUBLIC		_start
END 