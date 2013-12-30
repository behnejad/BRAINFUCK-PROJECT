.686
.MODEL		FLAT
.STACK		4096
INCLUDE		io.h
.DATA
prompt		BYTE	"ye adad bezan wollek: ", 0
string		BYTE	11 DUP(?), 0dh, 0ah, 0
num			DWORD	?
result		DWORD	0
.CODE
_main		PROC
			output	prompt
			input	string, 11
			atod	string

			mov		num, eax
			cmp		eax, 2
			jbe		b2
			mov		eax, 0
			dec		num
			push	num
			call	fib
			mov		edx, eax
			dec		num
			push	num
			call	fib
			add		edx, eax
			jmp		b3

b2:			mov		result, 1

b3:			dtoa	string, edx
			output	string
			mov		eax, 0
			ret
_main		ENDP
;---------------------------------
fib			PROC
			push	ebp
			mov		ebp, esp
			push	ebx
			push	edx
			mov		ebx, [ebp+8]
			cmp		ebx, 2
			jle		b
			mov		edx, 0
			dec		ebx
			push	ebx
			call	fib
			add		edx, eax
			dec		ebx
			push	ebx
			call	fib
			add		eax, edx
			jmp		b5

	b:
			mov		eax, 1
	b5:		pop		edx
			pop		ebx
			pop		ebp
			ret		4
fib			ENDP
END