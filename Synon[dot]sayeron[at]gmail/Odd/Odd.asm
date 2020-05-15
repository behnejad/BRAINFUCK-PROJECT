;Odd

.386
.MODEL FLAT

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

INCLUDE io.h

.STACK 4096


.DATA
prompt1			BYTE		"Enter a number: ",0
inString		BYTE		11 DUP(?)
result			BYTE		0dh,0ah,"Is odd ?"
answer			DWORD		?
				BYTE		0dh,0ah,0

.CODE
Odd				PROC		NEAR32
				push		ebp
				mov			ebp,esp
				pushfd
				mov			eax,[ebp+8]
				and			eax,00000001h
				jz			endPoint
				mov			eax,1
endPoint:		popfd
				pop			ebp
				ret			4
Odd				ENDP

_start:
				output		prompt1
				input		inString,11
				atod		inString
				push		eax
				call		Odd
				dtoa		answer,eax
				output		result
				INVOKE		ExitProcess,0
PUBLIC _start
END