.386
.MODEL		FLAT
.STACK		4096
INCLUDE		io.h
.DATA
prompt		BYTE	"enter your string: ", 0
string		BYTE	24 DUP(' '), 0
address		DWORD	?
yes			BYTE	"this could be an identifier", 0dh, 0ah, 0
noo			BYTE	"this could not be an identifier", 0dh, 0ah, 0


.CODE
_main		PROC
			output	prompt
			input   string, 22
			mov		edx, offset	string

			cmp		BYTE PTR [edx], '0'
			jb		endof
			cmp		BYTE PTR [edx], '9'
			jbe		endof
			cmp		BYTE PTR [edx], '@'
			je		endof
					

			mov		ecx, 22			
	lo:
				inc		edx
				xor		eax, eax
				mov		al, BYTE PTR [edx]
				cmp		al, 0
				je		ou
				push	eax
				call	check
				cmp		ebx, -1
				je		endof
				loop	lo
			
ou:			output	yes
			jmp		endof3
endof:		output	noo					
endof3:		xor		eax, eax
			ret
_main		ENDP
;-----------------------------------------------
check		PROC		; push char[ebp+8][=ascii], change ebx[1=ok, 2= no]
			push	ebp
			mov		ebp, esp
			mov		ebx, DWORD PTR [ebp+8]
			cmp		bl, '@'
			je		no
			cmp		bl, '!'
			je		no
			cmp		bl, '_'
			je		ok
			cmp		bl, ' '
			je		ok
			cmp		bl, '0'
			jb		no
			cmp		bl, '9'
			jbe		ok
			cmp		bl, 'A'
			jb		no
			cmp		bl, 'Z'
			jbe		ok
			cmp		bl, 'a'
			jb		no
			cmp		bl, 'z'
			jbe		ok

ok:			mov		ebx, 1
			jmp		ned	
no: 		mov		ebx, -1
ned:		pop		ebp
			ret		4
check		ENDP
END