.686
.MODEL		FLAT
INCLUDE		io.h
INCLUDE		my.h
.DATA
array		DWORD	8 DUP(?)
prompt		BYTE	"enter numbers: ", 0
result		BYTE	"maximum: "
string		BYTE	11 DUP(?), 0dh, 0ah, 0
.CODE
_main		PROC
			mov		ecx, 8
			lea		ebx, array
whileloop:
			output	prompt
			input	string, 11
			atod	string
			mov		DWORD PTR [ebx], eax
			add		ebx, 4
			dec		ecx
			cmp		ecx, 0
			je		phase2
			jmp		whileloop
phase2:
			lea		ebx, array
			mov		ecx, 8
			mov		edx, DWORD PTR [ebx]

outter:		cmp		edx, DWORD PTR [ebx]
			jl		change
inner:		
			dec		ecx
			add		ebx, 4
			cmp		ecx, 0
			je		endpoint
			jmp		outter

change:
			mov		edx, [ebx]
			jmp		inner

endpoint:
			dtoa	string, edx
			output	result
			mov		eax, 0
			ret
_main		ENDP
END