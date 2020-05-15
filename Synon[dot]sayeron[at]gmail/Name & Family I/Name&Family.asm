;Name & Family

.386
.MODEL FLAT

INCLUDE io.h

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

.STACK 4096

.DATA
prompt1			BYTE		"Enter your family and name (family, name) :",0
inString		BYTE		80 DUP(?)
result			BYTE		80 DUP(?)

.CODE
_start:
				output		prompt1
				input		inString,80
				
				lea			edi,inString
				mov			al,' '
				mov			ecx,80
				repne		scasb
				lea			esi,result
while_loop:		cmp			BYTE PTR [edi],0
				je			end_while
				mov			cl,[edi]
				mov			BYTE PTR [esi],cl
				inc			esi
				inc			edi
				jmp			while_loop
end_while:		mov			BYTE PTR [esi],' '
				inc			esi
				lea			edi,inString
while_loop2:	cmp			BYTE PTR [edi],','
				je			end_while2
				mov			cl,[edi]
				mov			BYTE PTR [esi],cl
				inc			edi
				inc			esi
				jmp			while_loop2
end_while2:		mov			BYTE PTR[esi],0
				output		result
				INVOKE		ExitProcess,0
PUBLIC _start
END