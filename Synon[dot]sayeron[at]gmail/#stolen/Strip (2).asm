;Strip

.386
.MODEL FLAT

INCLUDE io.h

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

.STACK 4096

.DATA
prompt1			BYTE		"Enter a string: ",0
inString		BYTE		80 DUP(?)
prompt2			BYTE		"Enter a character: ",0
inChar			BYTE		5 DUP(?)
result			BYTE		80 DUP(?)

.CODE
_start:
				output		prompt1
				input		inString,80
				output		prompt2
				input		inChar,5
				lea			esi,inString
				lea			edi,inChar
				mov			cl,[edi]
				lea			edi,result
while_loop:		cmp			BYTE PTR [esi],0
				je			quit
				cmp			BYTE PTR [esi],cl
				je			isIn
				mov			dl,[esi]
				mov			BYTE PTR [edi],dl
				inc			esi
				inc			edi
				jmp			while_loop
isIn:			inc			esi
				jmp			while_loop
quit:			mov			BYTE PTR [esi],0
				output		result
				INVOKE		ExitProcess,0
PUBLIC _start
END