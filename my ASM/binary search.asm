.686
.MODEL		FLAT
.STACK		4096
INCLUDE		io.h
.DATA
dat			BYTE	1,2,3,4,5,6,7,8,9,10
num			DWORD	10
prompt		BYTE	"OK!", 0
prompt2		BYTE	"FUCK!", 0
.CODE
_main		PROC
			xor		eax, eax
			mov		ebx, 10
			mov		ecx, num
			xor		edx, edx

	here:
			cmp		eax, ebx
			je		check




			jmp		here

	check:
			cmp		BYTE PTR dat[eax], dl
			je		find
			jmp		notfound

	find:	
			output	prompt
			jmp		exit
	
	notfound:
			output	prompt2

	exit:
			xor		eax, eax
			ret
_main		ENDP
END