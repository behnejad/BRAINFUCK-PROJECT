; Omid Davoodi's standard library

.586
.MODEL FLAT, syscall

PUBLIC oqtoaproc

.CODE
oqtoaproc   PROC   NEAR32
            push   ebp                 ; save base pointer
            mov    ebp, esp            ; establish stack frame
            push   eax                 ; Save registers
            push   ebx                 ;   used by
            push   ecx                 ;   procedure
            push   edx
            push   edi
            push   esi
            pushf                      ; save flags
			
			mov    eax, [ebp+16]		 ; first parameter (source double)
            mov    edx, [ebp+12]         ; second parameter (source double)
            mov    ebx, [ebp+8]          ; third parameter (dest addr)
			
			mov    ecx, 20
BlankLoop:
			mov    BYTE PTR [ebx], ' '
			inc	   ebx
			loop   BlankLoop
			
			mov ecx, [ebp+8]
			add ecx, 19
DivideLoop:
			push ecx
			mov	ebx, 10
			mov ecx, eax           ;save lower 32 bit
			mov eax, edx
			xor edx, edx           ;now edx:eax contains 0:hi32 
			div ebx
			mov esi, eax           ;hi 32 bit of result, save to esi
			mov eax, ecx           ;now edx:eax contains r:lo32, where r is the remainder
			div ebx
			mov ebx, edx
			mov edx, esi           ;restore hi32
			mov	ecx, eax
			or	ecx, edx
			cmp ecx, 0
			je HardExit
			pop ecx
			
			add ebx, 30h
			mov    BYTE PTR [ecx],bl
			dec ecx
			cmp ecx, [ebp+8]
			jne DivideLoop
			jmp ExitDToA
			
HardExit:
			pop ecx
			add ebx, 30h
			mov    BYTE PTR [ecx],bl
			
ExitDToA:   popf                       ; restore flags and registers
            pop    esi
            pop    edi
            pop    edx
            pop    ecx
            pop    ebx 
            pop    eax
            pop    ebp 
            ret                       ;exit, discarding parameters
oqtoaproc    ENDP

            END