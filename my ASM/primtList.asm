.686
.MODEL		FLAT
.STACK		40960
INCLUDE		io.h
INCLUDE		my.h
.DATA
string		BYTE	11 DUP(?)
prompt		BYTE	"enter number: ", 0
result		BYTE	20240 DUP(' '), 0

.CODE
main		PROC
			output	prompt
			input	string, 11
			atod	string
			mov		ecx, eax
			lea		edx, result

here:		isPrime	ecx
			cmp		ebx, 2
			je		next
			dtoa	string, ecx
			push	ecx
				
				mov		ecx, 11
				lea		eax, string
forloop:		
				cmp		BYTE PTR [eax], ' '
				je		here2				
				push	ecx
				mov		cl, BYTE PTR [eax]
				mov		BYTE PTR [edx], cl
				pop		ecx
				inc		edx
		here2:	
					inc		eax
					loop	forloop
Lexit:			
			inc		edx
			pop		ecx
next:		
			loop	here
			output	result
			xor		eax, eax
			ret
main		ENDP
END