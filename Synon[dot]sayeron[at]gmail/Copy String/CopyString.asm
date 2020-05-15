;Copy String

.386
.MODEL FLAT

INCLUDE io.h

ExitProcess	PROTO NEAR32 stdcall, dwExitCode:DWORD

.STACK 4096

.DATA
prompt1			BYTE		"Enter a string (include '$' to quit) : ",0
inString		BYTE		80 DUP(?)
prompt2			BYTE		0dh,0ah,"You have entered: ",0dh,0ah
result			BYTE		1024 DUP(?)
				

.CODE
_start:
				lea			edi,result
				cld
while_loop:		output		prompt1
				input		inString,80
				lea			esi,inString
				cmp			BYTE PTR [esi],'$'
				je			end_while
while_loop2:	cmp			BYTE PTR [esi],0
				je			end_while2
				movsb
				jmp			while_loop2
end_while2:		mov			BYTE PTR [edi],0ah
				mov			BYTE PTR [edi+1],0dh
				inc			edi
				jmp			while_loop
end_while:		mov			BYTE PTR [edi],0
				output		prompt2
				INVOKE		ExitProcess,0
PUBLIC _start
END