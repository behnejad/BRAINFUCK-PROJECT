		.386
.MODEL FLAT
.STACK 4096
include io.h
ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD


.DATA
		prompta			BYTE		"Enter a :",0
		promptb			BYTE		"Enter b :",0
		promptc			BYTE		"Enter c :",0
		inString		BYTE		11 DUP(?)
		answer			DWORD		?
						BYTE		0dh,0ah,0
.CODE

discr PROC ; b*b-4*a*c
		push		ebp
		mov			ebp , esp 
		
		push		ecx 
	
	;	mov			eax , 1
		mov			eax , [ebp + 12]
		imul		eax , eax 
		
		mov			ecx , [ebp + 16]
		imul		ecx , 4
		imul		ecx , [ebp + 8 ]

		sub			eax, ecx

		pop			ecx 

		pop			ebp 
		ret

discr ENDP


_start:


		output			promptc
		input			instring ,11
		atod			instring
		push			eax 

		output			promptb
		input			instring ,11
		atod			instring
		push			eax 

		output			prompta
		input			instring ,11
		atod			instring
		push			eax 

		call			discr
		add				esp , 12

		dtoa		answer,eax
		output		answer

			
		INVOKE	ExitProcess,0

PUBLIC		_start
END 