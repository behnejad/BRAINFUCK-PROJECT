.386
.MODEL FLAT
.STACK 4096
include io.h
;include	list.h
ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD


.DATA
		prompt1				BYTE		"String to search:",0
		prompt2				BYTE		"Key:",0
	
		key					BYTE		11 DUP(?)
		target				BYTE		100 DUP(?)
		exe					BYTE		199 DUP(?)
		targetLen			DWORD		?
		keyLen				DWORD		?
		lastpos				DWORD		?
		pos					DWORD		?
		indexs				DWORD		100 DUP(?)

		
	
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

		output 		prompt1
		input		target,100

		output		prompt2 
		input		key , 11

		lea			eax, target
		push		eax
		call		strlen 
		add			esp , 4
		mov			targetLen, ecx              ; targetLen= len (target)

		
		lea			eax, key
		push		eax
		call		strlen 
		add			esp , 4
		mov			keyLen, ecx              ; keyLen = len (target)


		mov			eax, targetlen
		sub			eax, keylen
		inc			eax	; targetlen - keylen + 1 

		mov			lastpos, eax
		cld	

		mov			edx,0; number of founded
		mov			eax,1 
WhilePos:
		cmp			eax, lastpos
		jnle		endWhilePos

		lea			esi	, target
		add			esi	, eax 
		dec			esi		

		lea			edi	, key 
		mov			ecx, keylen 

		repe		cmpsb
		jz			found

		inc			eax
		jmp			WhilePos		

endWhilePos:
		jmp			quit
found:
		
		dtoa		pos, eax
		output		pos
		inc			eax 
		inc			edx
		jmp			whilePos

		
quit:
	
	

		INVOKE	ExitProcess,0

PUBLIC		_start
END 