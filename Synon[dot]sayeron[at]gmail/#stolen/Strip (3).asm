;Strip

.386
.MODEL FLAT

INCLUDE io.h

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

.STACK 4096

.DATA
prompt1			BYTE		"Enter a sentence: ",0
sentence		BYTE		80 DUP(?)
prompt2			BYTE		"Enter a word: ",0
key				BYTE		15 DUP(?)
keyLength		DWORD		?
result			BYTE		80 DUP(?)

.CODE
_start:
				output		prompt1
				input		sentence,80
				output		prompt2
				input		key,15
				lea			eax,key
				push		eax
				call		strLen
				mov			keyLength,eax
				lea			eax,sentence
				push		eax
				call		strLen
				mov			edx,eax
				sub			edx,keyLength
				inc			edx
				mov			ecx,keyLength
				lea			esi,sentence
				lea			edi,key
				lea			ebx,result
				mov			eax,0
				
while_loop:		cmp			edx,0
				je			quit
				repe		cmpsb
				jz			isIn
				sub			ecx,keyLength
				neg			ecx
				sub			esi,ecx
				sub			edi,ecx
				mov			cl,[esi]
				mov			BYTE PTR [ebx],cl
				inc			ebx
				mov			ecx,keyLength
				lea			esi,sentence
				inc			eax
				add			esi,eax
				lea			edi,key
				dec			edx
				jmp			while_loop
isIn:			lea			edi,key
				mov			ecx,keyLength
				add			eax,keyLength
				dec			edx
				jmp			while_loop
quit:			inc			ebx
				mov			BYTE PTR [ebx],0
				output		result
				
				
				
strLen			PROC		NEAR32
				push		ebp
				mov			ebp,esp
				pushfd
				push		ebx
				
				mov			ebx,[ebp+8]
				mov			eax,0
while_loopP:	cmp			BYTE PTR [ebx],0
				je			endProc
				inc			ebx
				inc			eax
				jmp			while_loopP
endProc:		pop			ebx
				popfd
				pop			ebp
				ret			4
strLen			ENDP

PUBLIC _start
END