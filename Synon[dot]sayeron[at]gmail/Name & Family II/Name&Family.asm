;Name & Family

.386
.MODEL FLAT

INCLUDE io.h

ExitProcess PROTO NEAR32 stdcall dwExitCode:DWORD

.STACK 4096

.DATA
prompt			BYTE		"Enter your family and name (family  name) : ",0
inString		BYTE		80 DUP(?)
result			BYTE		80 DUP(?)

.CODE
_start:
				output		prompt
				input		inString,80
				lea			edi,inString
				mov			al,' '
				mov			ecx,80
				repne		scasb
				dec			edi
while1:			cmp			BYTE PTR [edi],' '
				jne			end1
				inc			edi
				jmp			while1
end1:			lea			esi,result
while2:			cmp			BYTE PTR [edi],' '
				je			end2
				mov			cl,[edi]
				mov			BYTE PTR [esi],cl
				inc			edi
				inc			esi
				jmp			while2
end2:			mov			BYTE PTR [esi],' '
				inc			esi
				lea			edi,inString
while3:			cmp			BYTE PTR [edi],' '
				je			end3
				mov			cl,[edi]
				mov			BYTE PTR [esi],cl
				inc			esi
				inc			edi
				jmp			while3
end3:			mov			BYTE PTR [esi],0
				output		result
				INVOKE		ExitProcess,0
PUBLIC _start
END 