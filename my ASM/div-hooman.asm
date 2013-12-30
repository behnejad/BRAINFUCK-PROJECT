.586
.MODEL	FLAT
.STACK	4096
INCLUDE	io.h
;hooman behnejad fard-91521077
.DATA
	prompt	BYTE	"enter a number wolek: ", 0
	string	BYTE	11 DUP(?)
	p1		BYTE	"division is: "
	p2		BYTE	11 DUP('0'), "."
	p3		BYTE	11 DUP('0')
	p4		BYTE	11 DUP('0'), 0Dh, 0Ah, 0
	temp1	DWORD	?
	temp2	DWORD	?
	remain	DWORD	?

.CODE
_main		PROC
		output	prompt
		input	string, 11
		atod	string
		mov		temp1, eax

		output	prompt
		input	string, 11
		atod	string
		mov		temp2, eax

		mov		eax, temp1
		cdq
		idiv	temp2

		dtoa	p2, eax
		
		mov		remain, edx

		mov		eax, 10
		cdq
		imul	remain
		idiv	temp2

		mov		remain, edx

		dtoa	p3, eax

		mov		eax, 10
		cdq
		imul	remain
		idiv	temp2

		dtoa	p4, eax

		output	p1	
		mov	eax, 0
		ret
_main		ENDP
END