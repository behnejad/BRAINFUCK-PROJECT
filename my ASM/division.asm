.586
.MODEL		FLAT
.STACK		4096
INCLUDE		io.h
.DATA
result		BYTE	"result is:"
prompt		BYTE	11 DUP(?), '.'
remain		BYTE	48 DUP(' '), 0Dh, 0Ah, 0
num1		DWORD	?
num2		DWORD	?
ten			BYTE	10

.CODE
_main		PROC
			input	prompt, 11
			atod	prompt
			mov		num1, eax

			input	prompt, 11
			atod	prompt
			mov		num2, eax
				
			call	_start
			input	prompt, 11

			mov		eax, 0
			ret
_main		ENDP
;--------------------------------------------
_start		PROC
			mov		eax, num1
			cdq
			idiv	num2
			dtoa	prompt, eax
			mov		ecx, 47
			lea		ebx, remain
L:
			mov		eax, edx
			imul	ten
			cdq
			idiv	num2
			add		al, 30h
			mov		BYTE PTR [ebx], al
			inc		ebx
			cmp		edx, 0
			je		endloop
			loop	L
endloop:
			output	result
			ret
_start		ENDP
;--------------------------------------------
END