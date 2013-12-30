.586
.MODEL FLAT
.STACK 4096
INCLUDE		io.h
cr			EQU		0Ah
lf			EQU		0Dh
.DATA
	prompt	BYTE	"ye adad bezan wolek: ", 0
	prompt2	BYTE	"ino nazadi wolek:"
	string	BYTE	11 DUP (?), cr, lf, 0
	
.CODE
_main		PROC
		output	prompt
		input	string, 11
		atod	string
		mov		ecx, eax
		mov		edx, ecx
		mov		ebx, 0

LB:		add		ebx, eax
		dec		eax
		loop	LB

		mov		ecx, edx
		dec		ecx

LB2:	input	string, 11
		atod	string
		sub		ebx, eax
		loop	LB2

		dtoa	string, ebx
		output	prompt2

		mov		eax, 0
		ret
_main		ENDP
END