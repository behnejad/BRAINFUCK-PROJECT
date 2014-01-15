.686
.MODEL		FLAT
.STACK		4096
INCLUDE		io.h
.DATA
str1		BYTE	11 DUP(' '),0
str2		BYTE	11 DUP(' '),0
ope			BYTE	11 DUP(' '),0
num			DWORD	0
num2		DWORD	0
prompt4		BYTE	"not define.",0
prompt2		BYTE	"enter operand: ", 0
prompt		BYTE	"enter second value: ",0
prompt3		BYTE	"enter first value: ",0
prompt5		BYTE	"division by zero", 0dh, 0ah, 0
result		BYTE	11 dup(?), 0dh, 0ah, 0
ten			DWORD	10
.CODE
_main		PROC
			
			output	prompt3
			input	str1, 11
			output	prompt
			input	str2, 11
			output	prompt2
			input	ope, 11
			nop
			cmp		ope, '/'
			jne		next
			cmp		str2, '0'
			je		exitp2
next:
				mov		ebx, offset str1
				push	ebx
				mov		ecx, 0
		first1:
				cmp		BYTE PTR [ebx], 0h
				je		endloop1
				inc		ebx
				inc		ecx
				cmp		ecx, 11
				jle		first1
		endloop1:
				pop		ebx
		for1:
					mov		eax, num
					mul		ten
					xor		edx, edx
					mov		dl,  BYTE PTR [ebx]
					sub		dl, '0'
					add		eax, edx
					mov		num, eax
					inc 	ebx
					xor		eax, eax
					loop	for1

				mov		ebx, offset str2
				push	ebx
				mov		ecx, 0
		first2:
				cmp		BYTE PTR [ebx], 0h
				je		endloop2
				inc		ebx
				inc		ecx
				cmp		ecx, 11
				jle		first2
		endloop2:
				pop		ebx
		for2:
					mov		eax, num2
					mul		ten
					xor		edx, edx
					mov		dl,  BYTE PTR [ebx]
					sub		dl, '0'
					add		eax, edx
					mov		num2, eax
					inc 	ebx
					xor		eax, eax
					loop	for2
		jmp		exitp

exitp2:
				output	prompt5
				jmp		exitpp
exitp:
			cmp		ope, '/'
			je		divp
			cmp		ope, '*'
			je		mulp
			cmp		ope, '+'
			je		addp
			cmp		ope, '-'
			je		subp
			output	prompt4
			jmp		exitpp


divp:
			push	num
			push	num2
			call	divproc
			jmp		exit

addp:
			push	num
			push	num2
			call	addproc
			jmp		exit
mulp:
			push	num
			push	num2
			call	mulproc
			jmp		exit

subp:
			push	num
			push	num2
			call	subproc
exit:
			mov		ebx, offset	result
			mov		ecx, 11
			add		ebx, 10
			mov		edx, eax
		LD:
				cdq
				idiv	ten
				add		dl, 30h
				mov		BYTE PTR [ebx], dl
				dec		ebx
				loop	LD

		LD2:
			output		result
exitpp:		xor		eax, eax
			ret
_main		ENDP
;---------------------------------------------------------------
divproc		PROC	NEAR32
			push	ebp
			mov		ebp, esp
			mov		eax, DWORD PTR [ebp+12]
			cdq
			mov		ebx, DWORD PTR [ebp+8]
			div		ebx

			pop		ebp
			ret		8
divproc		ENDP

subproc		PROC	NEAR32
			push	ebp
			mov		ebp, esp
			mov		eax, DWORD PTR [ebp+12]
			mov		ebx, DWORD PTR [ebp+8]
			sub		eax, ebx
				
			pop		ebp
			ret		8
subproc		ENDP

mulproc		PROC	NEAR32
			push	ebp
			mov		ebp, esp
			mov		eax, DWORD PTR [ebp+12]
			mov		ebx, DWORD PTR [ebp+8]
			mul		ebx
				
			pop		ebp
			ret		8
mulproc		ENDP

addproc		PROC	NEAR32
			push	ebp
			mov		ebp, esp
			mov		eax, DWORD PTR [ebp+12]
			mov		ebx, DWORD PTR [ebp+8]
			add		eax, ebx
				
			pop		ebp
			ret		8
addproc		ENDP

;--------------------------------------------------------------------

END