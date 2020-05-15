;Translate

.386
.MODEL FLAT

INCLUDE io.h

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

.STACK 4096

.DATA
prompt			BYTE		"Enter USA number's fromat (0,000,000.00) : ",0
inString		BYTE		80 DUP(?)
table			BYTE		44 DUP(' '),2eh,2dh,2ch,2fh,'0123456789',7 DUP(' '),'ABCDEFGHIJKLMNOPQRSTUVWXYZ',6 DUP(' '),'abcdefghijklmnopqrstuvwxyz',133 DUP(' ')
result			BYTE		"EURO format is: "
answer			BYTE		80 DUP(?)
				BYTE		0dh,0ah,0

.CODE
_start:
				output		prompt
				input		inString,80
				lea			esi,inString
				lea			edi,answer
				lea			ebx,table
while_loop:		cmp			BYTE PTR [esi],0
				je			quit
				lodsb
				xlat
				stosb
				jmp			while_loop
quit:			output		result
				INVOKE		ExitProcess,0
PUBLIC _start
END