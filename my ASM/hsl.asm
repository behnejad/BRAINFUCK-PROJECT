; Hooman Behnejad's standard Library
.586
EXTERN		dtoaproc:near32
PUBLIC		isPrimeProc,
			bubbleProc,
			facProc,
			selectionProc,
			fibProc,
			divProc,
			matrixProc

.MODEL		FLAT
.DATA
string		BYTE		11 DUP(?)
count2		DWORD		?
;---------------------------------------------------------------------------
dtoa        MACRO  dest,source,xtra    ;; convert double to ASCII string

            IFB    <source>
            .ERR <missing operand(s) in DTOA>
            EXITM
            ENDIF

            IFNB   <xtra>
            .ERR <extra operand(s) in DTOA>
            EXITM
            ENDIF

            push   ebx                 ;; save EBX
            mov    ebx, source
            push   ebx                 ;; source parameter
            lea    ebx,dest            ;; destination address
            push   ebx                 ;; destination parameter
            call   dtoaproc            ;; call dtoaproc(source,dest)
            pop    ebx                 ;; restore EBX
            ENDM
;---------------------------------------------------------------------------
.CODE
;---------------------------------------------------------------------------
matrixProc		PROC	NEAR32
				push	ebp
				mov		ebp, esp
				push	esi
				push	edi

				mov		eax, DWORD PTR [ebp+20]
				mul		eax
				mov		count2, eax
				mov		esi, DWORD PTR [ebp+8]
				mov		edx, DWORD PTR [ebp+12]
				mov		eax, DWORD PTR [ebp+16]
				mov		ecx ,DWORD PTR [ebp+20]				
		for1:
					push	ecx
					mov		ecx, DWORD PTR [ebp+20]
			for2:
						push	ecx
						mov		ecx, DWORD PTR [ebp+20]
						xor		edi, edi
						push	eax
				start:
							xor		eax, eax
							mov		al, BYTE PTR [esi]
							mul		BYTE PTR [edx]
							add		edi, eax
							inc		esi
							add		edx, DWORD PTR [ebp+20]
							loop	start
	
						mov		ecx, edi
						pop		eax
						sub		esi, DWORD PTR [ebp+20]
						sub		edx, count2
						mov		BYTE PTR [eax], cl
						inc		eax
						inc		edx
						pop		ecx
						loop	for2
				
					sub		edx, DWORD PTR [ebp+20]
					add		esi, DWORD PTR [ebp+20]
					pop		ecx
					loop	for1

				pop		edi
				pop		esi
				pop		ebp
				ret		16
matrixProc		ENDP
;---------------------------------------------------------------------------
divProc			PROC	NEAR32
				push	ebp
				mov		ebp, esp

				mov		esi, DWORD PTR [ebp+16]
				mov		BYTE PTR [esi], ' '
				mov		edx, DWORD PTR [ebp+8]
				mov		eax, DWORD PTR [ebp+12]

				cdq
				idiv	DWORD PTR [ebp+8]
				dtoa	string, eax
				mov		ecx, 11
		dll:
					mov		al, string[ecx]
					mov		BYTE PTR [esi+ecx], al
					loop	dll

				add		esi, 11
				mov		BYTE PTR [esi], '.'
				inc		esi
				
				mov		ecx, DWORD PTR [ebp+20]
				sub		ecx, 12
				jz		endloop
	LD:
				mov		eax, edx
				imul	DWORD PTR [ebp+24]
				cdq
				idiv	DWORD PTR [ebp+8]
				add		al, 30h
				mov		BYTE PTR [esi], al
				inc		esi
				cmp		edx, 0
				je		endloop
				loop	LD

	endloop:
				pop		ebp
				ret		20
divProc			ENDP
;---------------------------------------------------------------------------
fibProc			PROC	NEAR32
				push	ebp
				mov		ebp, esp

				push	esi
				push	edx
				mov		esi, [ebp+8]
				cmp		esi, 2
				jle		fb
				mov		edx, 0
				dec		esi
				push	esi
				call	fibProc
				add		edx, eax
				dec		esi
				push	esi
				call	fibProc
				add		eax, edx
				jmp		fb2
		fb:
				mov		eax, 1
		fb2:		
				pop		edx
				pop		esi
				pop		ebp
				ret		4
fibProc			ENDP
;---------------------------------------------------------------------------
selectionProc	PROC	NEAR32
				push	ebp
				mov		ebp, esp

				sub		esp, 4
				mov		eax, DWORD PTR [ebp+12]
				shl		eax, 2
				mov		DWORD PTR [ebp-4], eax
				xor		ecx, ecx
				mov		edx, DWORD PTR [ebp+8]
			sfor1:
					mov		eax, DWORD PTR [edx+ecx]
					mov		esi, ecx
					push	ecx
					add		ecx, 4

					sfor2:
							cmp		eax, DWORD PTR [edx+ecx]
							ja		fn1
							jbe		fn2
						fn1:
							mov		eax, DWORD PTR [edx+ecx]
							mov		esi, ecx
						fn2:
							add		ecx, 4
							cmp		ecx, DWORD PTR [ebp-4]
							jbe		sfor2
				
						push	edx
						add		edx, [esp+4]
						push	esi
						add		esi, [esp+4]
						mov		eax, DWORD PTR [edx]
						mov		ecx, DWORD PTR [esi]
						xchg	eax, ecx
						mov		DWORD PTR [edx], eax
						mov		DWORD PTR [esi], ecx
						pop		esi
						pop		edx

				pop		ecx
				add		ecx, 4
				cmp		ecx, DWORD PTR [ebp-4]
				jb		sfor1
				
				add		esp, 4
				pop		ebp
				ret		8
selectionProc	ENDP
;---------------------------------------------------------------------------
facProc			PROC	NEAR32
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
;---------------------------------------------------------------------------
bubbleProc		PROC	NEAR32
				push	ebp
				mov		ebp, esp

				mov		eax, [ebp+8]
				xor		esi, esi
				xor		ecx, ecx
				xor		edx, edx
		bfor1:
				push	ecx
				inc		ecx
			bfor2:		
					cmp		ecx, [ebp+12]
					ja		bend
					mov		esi, DWORD PTR [eax]
					push	eax
					mov		eax, [ebp+8]
					mov		edx, DWORD PTR [eax+ecx*4]
					pop		eax
					cmp		esi, edx
					jbe		bfor3
					xchg	esi, edx
					mov		DWORD PTR [eax], esi
					push	eax
					mov		eax, [ebp+8]
					mov		DWORD PTR [eax+ecx*4], edx
					pop		eax
										
				bfor3:
					inc		ecx
					cmp		ecx, [ebp+12]
					jbe		bfor2
				
		bend:	pop		ecx
				inc 	ecx
				add		eax, 4
				cmp		ecx, [ebp+12]
				jbe		bfor1

				pop		ebp
bubbleProc		ENDP
;---------------------------------------------------------------------------
isPrimeProc		PROC	NEAR32
				cmp		esi, 3
				jbe		prime
				mov		ecx, 2
forloop1:		
				mov		eax, esi
				cdq
				div		ecx
				cmp		ecx, esi
				je		prime
				cmp		edx, 0
				je		notprime
				inc		ecx
				jmp		forloop1
notprime:		
				mov		esi, 2
				ret
prime:			
				mov		esi, 1
				ret
isPrimeProc		ENDP
;---------------------------------------------------------------------------
END