;Replace

.386
.MODEL FLAT

INCLUDE io.h

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

.STACK 4096

.DATA
temp			BYTE		1 DUP(?)
prompt1			BYTE		"Enter a sentence: ",0
sentence		BYTE		80 DUP(?)
prompt2			BYTE		"Enter keyword: ",0
keyword			BYTE		15 DUP(?)
keywordLength	DWORD		?
prompt3			BYTE		"Enter substitute word: ",0
key				BYTE		15 DUP(?)
keyLength		DWORD		?
result			BYTE		80 DUP(?)

.CODE
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

_start:
				output		prompt1
				input		sentence,80
				output		prompt2
				input		keyword,15
				output		prompt3
				input		key,15
				lea			eax,sentence
				push		eax
				call		strLen
				mov			edx,eax
				lea			eax,keyword
				push		eax
				call		strLen
				sub			edx,eax
				inc			edx
				mov			keywordLength,eax
				lea			eax,key
				push		eax
				call		strLen
				mov			keyLength,eax
				
				lea			esi,sentence
				lea			edi,keyword
				mov			ecx,keywordLength
				mov			eax,0
				lea			ebx,result
				
while_loop:		cmp			edx,0
				je			quit
				repe		cmpsb
				jz			found
				sub			ecx,keywordLength
				neg			ecx
				sub			esi,ecx
				sub			edi,ecx
				mov			cl,[esi]
				mov			BYTE PTR [ebx],cl
				inc			ebx
				lea			esi,sentence
				inc			eax
				add			esi,eax
				lea			edi,keyword
				mov			ecx,keywordLength
				dec			edx
				jmp			while_loop
found:			lea			ecx,key
while2:			cmp			BYTE PTR [ecx],0
				je			end_while2
				push		eax
				mov			al,[ecx]
				mov			BYTE PTR [ebx],al
				pop			eax
				inc			ebx
				inc			ecx
				jmp			while2
end_while2:		lea			edi,keyword
				add			eax,keywordLength
				mov			ecx,keywordLength
				dec			edx
				jmp			while_loop
quit:			mov			BYTE PTR [ebx],0
				output		result
				INVOKE		ExitProcess,0
PUBLIC _start
END