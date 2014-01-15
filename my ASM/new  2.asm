1	8	first		4
2	12	second		8
3	16	destination	12
4	20	count		16
5	-4	count**2

matrixProc		PROC	NEAR32
				push	ebp
				mov		ebp, esp
				sub		esp, 4
				
				push	eax
				mov		eax, DWORD PTR [ebp+16]
				mul		eax
				mov		DWORD PTR [ebp-4], eax
				pop		eax

				push	esi
				push	edi
				
				;----------------------
				mov		count, n
				mov		r13b, n2
			 
				mov		r8, offset A
				mov		r9, offset B
				mov		r11, offset	D
				;---------------------
				mov		rcx ,count				
		for1:
					push	rcx
					mov		rcx ,count
			for2:
						push	rcx
						mov		rcx, count
						mov		r10, 0
						mov		rax, 0
				start:
							mov		al, BYTE PTR [r8]
							mul		BYTE PTR [r9]
							add		r10, rax
							inc		r8
							add		r9, count
							loop	start

						sub		r8, count
						sub		r9, r13
						mov		BYTE PTR [r11], r10b
						inc		r11
						inc		r9
						pop		rcx
						loop	for2
				
					sub		r9, count
					add		r8, count
					pop		rcx
					loop	for1

				pop		edi
				pop		esi
				add		esp, 4
				pop		ebp
				ret
matrixProc		ENDP