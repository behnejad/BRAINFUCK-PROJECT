.386
.MODEL FLAT



ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

INCLUDE io.h 
INCLUDE date.h

cr EQU 0dh 
Lf EQU 0ah 

.STACK 4096 



.DATA
testm DWORD ?
.CODE
_start:	


;	mov		[ebx].year,2014

	jtom		20,3,5
	dtoa		testm,[ebx].year
	output		testm


	INVOKE ExitProcess, 0 	;exit with return code 0


PUBLIC _start 			;make entry point public

END 				;end of source code


