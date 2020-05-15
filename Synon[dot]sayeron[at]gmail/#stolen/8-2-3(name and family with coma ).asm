.386
.MODEL FLAT
.STACK 4096
include io.h
ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD


.DATA
		inputstr		BYTE		"Enter:",0
		string2			BYTE		"re2",0
		inString		BYTE		100 DUP(?)
		family			BYTE		11 DUP(?)
		n				BYTE		11 DUP(?)
		exe				BYTE		199 DUP(?)
		answer			DWORD		?
						BYTE		0dh,0ah,0
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



index	PROC
		push			ebp
		mov				ebp	, esp	

		push			eax 
		push			edi 
		pushfd 


		push		[ebp + 12]
		call		strlen 
		add			esp , 4 

		push		ecx 
	

		mov			eax , [ebp + 8]
		mov			edi	, [ebp + 12 ]
		repne		scasb
		
		

		pop			eax 
		sub			eax,ecx
		mov			ecx , eax 
	

		popfd 
		pop			edi 
		pop			eax 
		pop				ebp		
		ret 


index	ENDP

_start:

	
		output			inputstr
		input			instring , 100
		
		lea				eax , instring 
		push			eax 

		pushd			','

		call			index 
		add				esp , 8
		mov				ebx , ecx 
	
		cld 


	

		 ; family, vahid

		; set family
		dec				ecx
		lea				esi	, instring 
		lea				edi	, family 
		rep				movsb
		
		; setname

		lea				eax , instring 
		push			eax 
		call			strlen 
		add				esp , 4 
		


		sub				ecx, ebx 

		lea				esi	, instring 
		lea				edi , n
		add				esi , ebx 
		inc				esi
		rep				movsb
		

	

		; export :
		; name family 

		lea				eax , n 
		push			eax 
		call			strlen 
		add				esp , 4 


		lea				edi ,exe
		lea				esi	, n 
		rep				movsb	
				
		
		mov				al , ' ' 
		stosb			


		;inc				edi		

		
		lea				eax , family
		push			eax 
		call			strlen 
		add				esp , 4 


		lea				esi , family 
		rep				movsb 


		output exe

		INVOKE	ExitProcess,0

PUBLIC		_start
END 