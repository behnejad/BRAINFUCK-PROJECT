.586
.MODEL FLAT

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

INCLUDE io.h

.STACK 4096
.DATA
	prompt			BYTE	"ye adad bezan volek ", 0
	inputnumber		DWORD	?
	tempnum1		DWORD	2
	tempnum2		DWORD	1
	inputstring		BYTE	11 DUP (?)
	outputstring	BYTE	11 DUP (?)
					BYTE	0ah, 0dh, 0

.CODE
_main:
	output		prompt
	input		inputstring, 11
	atod		inputstring
	mov			inputnumber, eax

	cmp			eax, 1
	je			PrintResult
	jb			endl

MultiplactionLoop:
	mov			eax, tempnum2
	mul			tempnum1
	mov			tempnum2, eax
		
	mov			eax, tempnum1
	add			eax,	
	mov			tempnum1, eax

	cmp			eax, inputnumber
	jna			MultiplactionLoop
	
PrintResult:
	dtoa		outputstring, tempnum2
	output		outputstring
	mov			tempnum1, 2
	mov			tempnum2, 1
	jmp			_main

endl:
	INVOKE 			ExitProcess, 0

PUBLIC _main

END
