;Search Array

.386
.MODEL FLAT

INCLUDE io.h

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

.STACK 4096

.DATA
prompt1		BYTE		"Enter a number: ",0
number		BYTE		11 DUP(?)
array		DWORD		100 DUP(?)
prompt2		BYTE		0dh,0ah,0ah,"Search for? ",0
nResult		BYTE		0dh,0ah,0ah,"Value not found!",0
result		BYTE		0dh,0ah,0ah,"Value found at"
counter		DWORD		?
			BYTE		0dh,0ah,0


.CODE
_start:
			lea			ebx,array
			mov			ecx,0
			
while_loop:	output		prompt1
			input		number,11
			atod		number
			cmp			eax,0
			jl			end_while
			inc			ecx
			mov			[ebx],eax
			add			ebx,4
			jmp			while_loop
end_while:
			dtoa		counter,ecx
			lea			ebx,array
			atod		counter
			mov			ecx,eax
			mov			edx,1
			output		prompt2
			input		number,11
			atod		number
for_loop:	cmp			edx,ecx
			jg			not_found
			cmp			[ebx],eax
			je			found
			add			ebx,4
			inc			edx
			jmp			for_loop
found:		dtoa		counter,edx
			output		result
			jmp			end_for
not_found:	output		nResult
end_for:	INVOKE		ExitProcess,0

PUBLIC _start
END