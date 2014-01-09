.686
.MODEL		FLAT
.STACK		4096
INCLUDE		io.h
.DATA
array		BYTE	250,3,60,50,4,1,7,8,9,0,255
n			DWORD	10
.CODE
_main		PROC
			xor		eax, eax
			xor		ebx, ebx
			xor		ecx, ecx
			mov		edx, offset array
		L1:
				mov		al,  BYTE PTR [edx+ecx]
				mov		bl, cl
				push	ecx
				inc		ecx

				L2:
						cmp		al, BYTE PTR [edx+ecx]
						ja		N1
						jb		N2
					N1:
						mov		al, BYTE PTR [edx+ecx]
						mov		bl, cl
					N2:
						inc		ecx
						cmp		ecx, n
						jb		L2
				
					push	edx
					mov		edx, [esp+4]
					add		edx, [esp]
					push	ebx
					add		ebx, [esp+4]
					mov		al, BYTE PTR [edx]
					mov		cl, BYTE PTR [ebx]
					xchg	al,cl
					mov		BYTE PTR [edx], al
					mov		BYTE PTR [ebx], cl
					pop		ebx
					pop		edx

				pop		ecx
				inc		ecx
				cmp		ecx, n
				jb		L1
				
			xor		eax, eax
			ret
_main		ENDP
END