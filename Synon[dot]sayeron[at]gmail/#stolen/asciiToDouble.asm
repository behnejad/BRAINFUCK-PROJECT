.386
.MODEL FLAT
.STACK 4096

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD
INCLUDE io.h

.DATA
prompt		BYTE		"enter a number",0
instring	BYTE		11 DUP (?)
result		BYTE		"The reslut is"
answer		BYTE		11 DUP (?)
			BYTE		0dh,0ah,0
			
falg		BYTE		"+"
			
.CODE
_start:

			output		prompt
			input		instring,11
			
			lea			esi,instring
			cmp			BYTE PTR [esi],'-'
			jne			continue
			mov			flag,'-'
			inc			esi
			
continue:

			mov			edx,0
whileLoop:
			cmp			BYTE PTR [esi],0
			je			EndWhileLoop
			inc			esi
			inc 		edx
			jmp			whileLoop
			
EndWhileLoop:
			mov			eax,0
			mov			ebx,1
			dec			esi
			
mainLoop:
			cmp			edx,0
			je			endMainLoop
			mov			ecx,0
			mov			cl,BYTE PTR [esi]
			sub			cl,30h
			imul		ecx,ebx
			
			add			eax,ecx
			dec			esi
			imul		ebx,10
			dec			edx
			jmp			mainLoop
			
endMainLoop:

			imul		eax,2
			
			cmp			flag,'+'
			je			endProgram
			neg			eax
			
endProgram:
			dtoa		answer,eax
			output		result
			INVOKE		ExitProcess,0
			
public _start
END
			
			