.686
.MODEL		FLAT
.STACK		4096
include		io.h
cr		EQU			0Dh
lf		EQU			0Ah
.DATA
prompt	BYTE	"ye adad bezan wolek: ", 0
prompt2	BYTE	"inam az masahat janebi moka'bi ke zadi wolek"
string	BYTE	11 DUP (?), cr, lf, 0
x		DWORD	?
y		DWORD	?
z		DWORD	?

.CODE
_main		PROC
		
			output	prompt
			input	string, 11
			atod	string
			mov		x, eax
			mov		ebx, eax

			output	prompt
			input	string, 11
			atod	string
			mov		y, eax

			output	prompt
			input	string, 11
			atod	string
			mov		z, eax

			mul		x		; eax = x*z
			mov		x, eax	; x = x*z

			mov		eax, y
			mul		z
			mov		z, eax	; z = y*z

			mov		eax, y
			mul		ebx		; eax = y*x

			add		eax, z
			add		eax, x

			add		eax, eax
			dtoa	string, eax

			output	prompt2

			xor		eax, eax
			ret
_main		ENDP
END