.386
.MODEL FLAT
.STACK 4096
include io.h
ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD


.DATA
		inp		BYTE		"    Enter:    ",0
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


strip   PROC
		push		ebp 
		mov			ebp  , esp 
		
		push		ebx ; counter 
		push		ecx
		push		edx 
		mov			edx , [ebp + 8]

		mov			ecx , 0 
		mov			ebx , 0
loop_char:
		inc			ecx ; ecx = i 
		cmp			edx , ' ' 
		jz			counter

counter:
		inc			ebx 



		pop			edx
		pop			ecx 
		pop			ebx
		
		
		
		
		pop			ebp
		ret 		
strip   ENDP
_start:
		lea			eax , inp 
		push		eax 
		call		strip 
		add			esp ,4 
 
	

		INVOKE	ExitProcess,0

PUBLIC		_start
END 
END 