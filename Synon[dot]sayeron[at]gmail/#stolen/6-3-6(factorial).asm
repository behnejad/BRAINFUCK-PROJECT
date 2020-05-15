.386
.MODEL FLAT
.STACK 4096
include io.h
ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD


.DATA
		promptn			BYTE		"Enter N :",0
		inString		BYTE		11 DUP(?)
		answer			DWORD		?
						BYTE		0dh,0ah,0
.CODE

f  PROC ;
		push		ebp
		mov			ebp , esp
		 
		push		eax 
		push		ecx 
		mov			eax , [ebp + 8]
		cmp			eax , 0
		 
		jnz			else_1
		mov			ebx , 1 
		jmp			end_p
else_1:
		mov			ecx, eax 
		dec			ecx 
		push		ecx
		call		f 
		add			esp	, 4	

		imul		ebx  , eax  








end_p:	pop			
		pop			eax 
		pop			ebp 
		ret
f  ENDP


_start:



		output			promptn
		input			instring ,11
		atod			instring
		push			eax 


		call			f
		add				esp , 4

		dtoa		answer,ebx
		output		answer

			
		INVOKE	ExitProcess,0

PUBLIC		_start
END 