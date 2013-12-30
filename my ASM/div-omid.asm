.586
.MODEL FLAT

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

INCLUDE io.h

.STACK 4096
.DATA
	prompt			BYTE		"Enter a number:", 0
	number			DWORD		?
	divisor			DWORD		?
	ten				DWORD		10
	inputstring		BYTE		11 DUP (?)
	outputstring	BYTE		11 DUP (?)
	dot				BYTE		'.'
	outputd1		BYTE		0
	outputd2		BYTE		0
					BYTE		0

.CODE
_main:
	output			prompt
	input			inputstring, 11
	atod			inputstring
	mov				number, eax
	
	output			prompt
	input			inputstring, 11
	atod			inputstring
	mov				divisor, eax

	mov				eax, number
	cdq
	idiv			divisor
	dtoa			outputstring, eax
	
	mov				eax, edx
	imul			ten
	
	;cdq
	idiv			divisor
	add				al, 30h
	mov				outputd1, al
	
	mov				eax, edx
	imul			ten
	
	;cdq
	idiv			divisor
	add				al, 30h
	mov				outputd2, al
	
	output			outputstring
	
	INVOKE 			ExitProcess, 0

PUBLIC _main

END
