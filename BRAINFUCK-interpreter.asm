.686
.MODEL		FLAT
.STACK		4096
INCLUDE		io.h
.DATA
	sample	BYTE	'++++++++++[>+++++++>++++++++++>+++>+<<<<-]>++.>+.+++++++..+++.>++.<<+++++++++++++++.>.+++.------.--------.>+.>.'
	string	BYTE	1000 DUP (?)
	var		BYTE	250 DUP (?)
	prompt	BYTE	'#',0
	temp	BYTE	11 DUP (?)
	last	DWORD	?
	outp	BYTE	?
			BYTE    0
	whelp	DWORD	0
.CODE
_main		PROC
			
			input	string, 1000
			;mov		eax, offset sample
			mov		eax, offset string	;put in eax start point of string
			lea		ebx, var			;put in ebx start point of internal variables
			mov		last, offset temp
			add		last, 11
			;mov		ecx, 0
			mov		ecx, 1000
	forloop:
			cmp		BYTE PTR [eax], '+'
			je		ADDTO
			cmp		BYTE PTR [eax], '-'
			je		SUBTO
			cmp		BYTE PTR [eax], '>'
			je		GOONE
			cmp		BYTE PTR [eax], '<'
			je		BACK1
			cmp		BYTE PTR [eax], ','
			je		GETCH
			cmp		BYTE PTR [eax], '.'
			je		PUTCH
			cmp		BYTE PTR [eax], '['
			je		WHILESTART
			cmp		BYTE PTR [eax], ']'
			je		WHILEEND


	ENDOF:	dec		ecx
			inc		eax					;skiping one character in string
			;cmp		ecx, 1000
			;je		endpoint
			cmp		ecx, 0
			je	ENDPOINT
			jmp		forloop

;-----------------------------------------
	ADDTO:	inc		BYTE PTR [ebx]
			jmp		ENDOF

	SUBTO:	dec		BYTE PTR [ebx]
			jmp		ENDOF

	GOONE:	inc		ebx
			jmp		ENDOF
			
	BACK1:	dec		ebx
			jmp		ENDOF

	GETCH:	;output	prompt
			input	temp, 11
			mov		dl, BYTE PTR [last - 11]
			mov		BYTE PTR [ebx], dl
			jmp		ENDOF

	PUTCH:	mov		dl, BYTE PTR [ebx]
			mov		outp, dl
			output	outp
			jmp		ENDOF

	WHILESTART:
			mov		dl, BYTE PTR [ebx]
			cmp		dl, 0
			je		WHILESFNP
			jmp		ENDOF

	WHILESFNP:
			inc		eax
			mov		dl, BYTE PTR [eax]
			cmp		dl, ']'
			je		ENDOF
			jmp		WHILESFNP

	WHILEEND:
			push	ecx
			mov		ecx, 0
			mov		whelp, 0
	WHILEENDX0:
			mov		dl, BYTE PTR [eax]
			cmp		dl, ']'
			je		WHILEENDX2
			cmp		dl, '['
			jne		WHILEENDX3		

			WHILEENDX1:
				inc ecx
				jmp	WHILEENDX3
			
			WHILEENDX2:
				dec ecx
			
			WHILEENDX3:
				dec		eax
				inc		whelp
				cmp		ecx, 0
	
			jne		WHILEENDX0
			pop		ecx
			add		ecx, whelp
			jmp		ENDOF			
;-----------------------------------------

ENDPOINT:	mov		eax, 0
			ret
_main		ENDP
END