;Square

.386
.MODEL FLAT

INCLUDE io.h

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

.STACK 4096

.DATA
prompt1		BYTE	"Enter an integer: ",0
N			BYTE	11 DUP(?)
prompt2		BYTE	"Number",09h,09h,"Square",0dh,0ah,0
result		BYTE	0dh,0ah
number		WORD	?
			BYTE	"      ",09h
square		WORD	?
			BYTE	0dh,0ah,0

.CODE
_start:
			output	prompt1
			input	N,11
			output	prompt2
			atoi	N
			mov		cx,ax
			mov		bx,1
for_loop:	itoa	number,bx
			mov		ax,bx
			mul		ax
			itoa	square,ax
			output	result
			inc		bx
			loop	for_loop
			
			INVOKE	ExitProcess,0
PUBLIC _start
END