.386
.MODEL FLAT
.STACK 4096
include io.h
ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD


.DATA
		inp		BYTE		"Enter:",0
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
		output		inp 
		input		instring, 100
		lea			eax , instring 
		push		eax 
	
 
		mov			eax , 0 
		mov			eax , ' ' 
		push		eax 
		mov			ecx, 0 
		call		index 
		add			esp , 8 

	
		dec			ecx 
		lea			edi	, family 
		lea			esi , instring 
		rep			movsb 


		mov			ecx, 0
		
	
loop_1:; esi -> start of name 
		
		cmp		BYTE PTR[esi], ' '	
		jnz		end_space
		inc		esi 
		jmp		loop_1
end_space:
		push	esi 
		mov		ecx, 0 
loop_2:
		cmp		BYTE PTR [esi], ' ' 
		jz		end_s
		cmp		BYTE PTR [esi], 0 
		jz		end_s
		inc		ecx 
		inc		esi 
		jmp		loop_2

end_s:
		pop		esi 
		
		lea		edi , n
		rep		movsb 
		



		; vahid kharazi 
		lea		eax, n 
		push	eax 
		call	strlen 
		add		esp , 4


		lea		esi	, n
		lea		edi	, exe
		rep		movsb

		mov		eax , ' '
		stosb
			 

		lea		eax, family  
		push	eax 
		call	strlen 
		add		esp , 4

		lea		esi , family 
		rep		movsb


		output	exe
	

		INVOKE	ExitProcess,0

PUBLIC		_start
END 