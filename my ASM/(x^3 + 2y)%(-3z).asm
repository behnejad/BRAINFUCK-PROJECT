
.586
.MODEL FLAT
.STACK 4096

INCLUDE io.h

.DATA
prompt		BYTE		"ye adad bezan volek: ", 0
prompt2		BYTE		"bia adadet volek: "
string		BYTE		11 DUP(0)
			BYTE		0dh, 0ah, 0

			;	result is (x^3 + 2y)/(-3z)
.CODE

_main	PROC
	
	output	prompt
	input	string, 11	; getting x
	atod	string
	mov		ebx, eax	; ebx = eax = x
	imul	eax, ebx	; eax = x^2 , ebx = x
	imul	eax, ebx	; eax = x^3 , ebx = x
	mov		ecx, eax	; ecx = eax = x^3

	output	prompt
	input	string, 11	; getting y
	atod	string
	add		eax, eax		; eax = eax * 2 ; eax = 2 * y
	add		ecx, eax	; ecx = x^3 + eax = x^3 + 2 * y

	output	prompt
	input	string, 11	; getting z
	atod	string
	imul	eax, -3		; eax = eax * -3 ; eax = -3 * z
	mov		ebx, eax	; ebx = -3 * z 

	mov		eax, ecx	; eax = x^3 + 2 *y
	mov		edx, 0		; edx = 0
	idiv	ebx			; eax = [part] eax / -3 * z

	dtoa	string, eax

	output	prompt2

	mov		eax, 0
	ret

_main	ENDP

END 