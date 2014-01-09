.686
.MODEL		FLAT
.STACK		4096
INCLUDE		io.h
INCLUDE		my.h
.DATA
n			DWORD	10
list_end	DWORD	0
array		DWORD	9,8,7,6,0,4,3,2,1,5, 0
string		BYTE	11 DUP(?), 0dh, 0ah, 0

.CODE
_main		PROC

			mov		ecx, 10
			mov		ebx, offset array
		;Lin:
		;		input	string, 11
		;		atod	string
		;		mov		DWORD PTR [ebx], eax
		;		add		ebx, 4
		;		loop	Lin
								
			bubble	offset array, n

			mov		eax, offset array
			mov		ecx, n
		L4:
			dtoa	string, DWORD PTR[eax+ecx*4]
			output	string
			loop	L4

			ret
_main		ENDP
END