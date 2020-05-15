.386
.MODEL FLAT
.STACK 4096
include io.h
ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD


.DATA
		promptn			BYTE		"Enter N :",0
		promptm			BYTE		"Enter M :",0
		inString		BYTE		11 DUP(?)
		answer			DWORD		?
						BYTE		0dh,0ah,0
.CODE

gcd  PROC ;
		push		ebp
		mov			ebp , esp

		push		eax 
		push		ecx 

		mov			eax , [ebp + 8]; m 
		mov			ecx, [ebp + 12]; n 

		cmp			ecx , 0 
		jnz			else_1
		mov			ebx, eax 
		jmp			end_p
else_1:
		push		edx 
		cdq			
		idiv		ecx
		push		edx 
		push		ecx 
		call		gcd 
		add			esp , 8 

		pop			edx 
		
end_p:
		pop			ecx 
		pop			eax 
		pop			ebp 
		ret
gcd   ENDP


_start:



		output			promptn
		input			instring ,11
		atod			instring
		push			eax 

		output			promptm
		input			instring ,11
		atod			instring
		push			eax 

		call			gcd
		add				esp , 8

		dtoa		answer,ebx
		output		answer

			
		INVOKE	ExitProcess,0

PUBLIC		_start
END 