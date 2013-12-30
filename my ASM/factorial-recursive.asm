.686
.MODEL		FLAT
.STACK		4096
INCLUDE		io.h
INCLUDE		my.h
cr			EQU		0dh
lf			EQU		0ah
.DATA
prompt		BYTE	"ye adad bezan wolet: ", 0
string		BYTE	11 DUP(?), cr, lf, 0 
.CODE
_main		PROC
			nop
			;output	prompt
			;input	string, 11
			;atod	string
			mov		eax, 8
			factorial	eax
			dtoa	string, eax
			output	string
			mov		eax, 0
			ret
_main		ENDP
END