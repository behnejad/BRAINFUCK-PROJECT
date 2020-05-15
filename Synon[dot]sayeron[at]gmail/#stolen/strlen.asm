.386
.MODEL FLAT
.STACK 4096
include io.h
ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD


.DATA
		promptn			BYTE		"Enter N :",0
		promptm			BYTE		"Enter M :",0
		inString		BYTE		100 DUP(?)
		answer			DWORD		?
						BYTE		0dh,0ah,0
.CODE

strlen  PROC ;
		push		ebp
		mov			ebp , esp

		push		ebx		
		mov			eax , 0  
		mov			ebx , [ebp + 8 ] ; adderss of string 
whileChar:
		cmp			BYTE PTR [ebx], 0 
		je			endWhilechar

		inc			eax
		inc			ebx ; next char
		jmp			whileChar 
endWhilechar:
		pop			ebx		
		pop			ebp 
		ret
strlen   ENDP


_start:



		output			promptn
		input			instring ,100
		lea				eax , instring 
		push			eax

		call			strlen 
		add				esp , 8 

		dtoa		answer,eax
		output		answer

			
		INVOKE	ExitProcess,0

PUBLIC		_start
END 