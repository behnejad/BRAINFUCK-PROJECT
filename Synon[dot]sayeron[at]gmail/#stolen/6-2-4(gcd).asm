.386
.MODEL FLAT
.STACK 4096
include io.h
ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD


.DATA
		prompta			BYTE		"Enter a :",0
		promptb			BYTE		"Enter b :",0
		inString		BYTE		11 DUP(?)
		answer			DWORD		?
						BYTE		0dh,0ah,0
.CODE

gcd  PROC ;
		push		ebp
		mov			ebp , esp 
		
		push		ecx 
		push		eax 

		mov			ebx, [ebp + 12 ] ; gcd = number 1 
		mov			ecx , [ ebp + 8] ; remainder = number2
loop_1:
		mov			eax , ebx 
		mov			ebx , ecx 
														; gcd = ebx | remainder = ecx | 
		push		edx 
		cdq			
		idiv		ebx 
		mov			ecx , edx 
		pop			edx 


		cmp			ecx, 0 
		jnz			loop_1
		
		
		pop			eax 
		pop			ecx 
		pop			ebp 
		ret

gcd  ENDP


_start:



		output			promptb
		input			instring ,11
		atod			instring
		push			eax 

		output			prompta
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