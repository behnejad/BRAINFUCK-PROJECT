.386
.MODEL FLAT
.STACK 4096
include io.h
ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD


.DATA
		inchar				BYTE		"Enter Char:",0
		instring			BYTE		"Enter String:",0
	
		inputChar			BYTE		11 DUP(?)
		inputS				BYTE		100 DUP(?)
		exe					BYTE		199 DUP(?)
	
.CODE

strlen  PROC ;
		push		ebp
		mov			ebp , esp

		push		ebx		
		mov			ecx , 0  
		mov			ebx , [ebp + 8] ; adderss of string 
whileChar:
		cmp			BYTE PTR [ebx], 0 
		je			endWhilechar

		inc			ecx
		inc			ebx ; next char
		jmp			whileChar 
endWhilechar:
		pop			ebx		
		pop			ebp 
		ret
strlen   ENDP

_start:
		output			inchar
		input			inputChar,11
	
		output			instring 
		input			inputS,11
		lea				esi , inputS
		lea				edi	, exe
		cld			
		mov				bl , inputChar
loop_1:
		cmp				BYTE PTR [esi] , 0 
		jz				end_str
		lodsb
		cmp				al , bl
		jz				not_copy
		stosb			
;		inc				esi 
;		inc				edi	
		jmp				loop_1
not_copy:
		jmp				loop_1
end_str:
		output			exe

		INVOKE	ExitProcess,0

PUBLIC		_start
END 