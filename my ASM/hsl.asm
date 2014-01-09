; Hooman Behnejad's standard Library

PUBLIC		isPrimeProc, bubbleProc, facProc, selectionProc
.586
.MODEL		FLAT
.CODE
;--------------------------------------------------------
selectionProc	PROC
				push	ebp
				mov		ebp, esp

				xor		eax, eax
				xor		ebx, ebx
				xor		ecx, ecx
				mov		edx, DWORD PTR [ebp+8]
			L1:
					mov		eax, DWORD PTR [edx+ecx]
					mov		ebx, ecx
					push	ecx
					add		ecx, 4

					L2:
							cmp		eax, DWORD PTR [edx+ecx]
							ja		N1
							jbe		N2
						N1:
							mov		eax, DWORD PTR [edx+ecx]
							mov		ebx, ecx
						N2:
							add		ecx, 4
							cmp		ecx, DWORD PTR [ebp+12]
							jb		L2
				
						push	edx
						mov		edx, [esp+4]
						add		edx, [esp]
						push	ebx
						add		ebx, [esp+4]
						mov		eax, DWORD PTR [edx]
						mov		ecx, DWORD PTR [ebx]
						xchg	eax, ecx
						mov		DWORD PTR [edx], eax
						mov		DWORD PTR [ebx], ecx
						pop		ebx
						pop		edx

				pop		ecx
				add		ecx, 4
				cmp		ecx, DWORD PTR [ebp+12]
				jb		L1

				pop		ebp
				ret		8
selectionProc	ENDP
;--------------------------------------------------------
facProc			PROC
				push	ebp
				mov		ebp, esp
				mov		ecx, DWORD PTR [ebp+8]
				cmp		ecx, 1
				jna		endf
				cdq
				mul 	ecx
				dec		ecx
				mov		DWORD PTR [ebp+8], ecx
				push	ecx
				call	facProc

		endf:
				pop		ebp
				ret		4
facProc			ENDP
;--------------------------------------------------------
bubbleProc		PROC
				push	ebp
				mov		ebp, esp

				mov		eax, [ebp+8]
				xor		ebx, ebx
				xor		ecx, ecx
				xor		edx, edx
		L1:
				push	ecx
				inc		ecx
			L2:		
					cmp		ecx, [ebp+12]
					ja		endl
					mov		ebx, DWORD PTR [eax]
					push	eax
					mov		eax, [ebp+8]
					mov		edx, DWORD PTR [eax+ecx*4]
					pop		eax
					cmp		ebx, edx
					jbe		L3
					xchg	ebx, edx
					mov		DWORD PTR [eax], ebx
					push	eax
					mov		eax, [ebp+8]
					mov		DWORD PTR [eax+ecx*4], edx
					pop		eax
										
				L3:
					inc		ecx
					cmp		ecx, [ebp+12]
					jbe		L2
				
		endl:	pop		ecx
				inc 	ecx
				add		eax, 4
				cmp		ecx, [ebp+12]
				jbe		L1

				pop		ebp
bubbleProc		ENDP
;------------------------------------------------------------------
isPrimeProc		PROC
				cmp		ebx, 3
				jbe		prime
				mov		ecx, 2
forloop1:		
				mov		eax, ebx
				cdq
				div		ecx
				cmp		ecx, ebx
				je		prime
				cmp		edx, 0
				je		notprime
				inc		ecx
				jmp		forloop1
notprime:		
				mov		ebx, 2
				ret
prime:			
				mov		ebx, 1
				ret
isPrimeProc		ENDP
;---------------------------------------------------------
END