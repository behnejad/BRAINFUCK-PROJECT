.586
.MODEL FLAT

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

INCLUDE io.h

.STACK 4096
.DATA
	instring	BYTE	11 DUP(?)
	innum1		DWORD	?
	innum2		DWORD	?
	sign		DWORD	?
	ot1			BYTE	"Enter the first number:", 0
	ot2			BYTE	"Enter the second number:", 0
	ot3			BYTE	"Enter the operation sign:", 0
	ot4			BYTE	"Result is:"
	outps		BYTE	11 DUP(?), 0
	
	errm		BYTE	"Bad sign!", 0
	errz		BYTE	"Div by 0!", 0
.CODE

addProc			PROC		NEAR32
	push		ebp
	mov			ebp, esp
	pushf
	mov			eax, [ebp+12]
	add			eax, [ebp+8]
	popf
	pop			ebp
	ret
addProc			ENDP

mulProc			PROC		NEAR32
	push		ebp
	mov			ebp, esp
	pushf
	mov			eax, [ebp+12]
	mul			DWORD PTR [ebp+8]
	popf
	pop			ebp
	ret
mulProc			ENDP


subProc			PROC		NEAR32
	push		ebp
	mov			ebp, esp
	pushf
	mov			eax, [ebp+12]
	sub			eax, [ebp+8]
	popf
	pop			ebp
	ret
subProc			ENDP

divProc			PROC		NEAR32
	push		ebp
	mov			ebp, esp
	pushf
	push 		ebx
	mov			eax, [ebp+12]
	mov			ebx, [ebp+8]
	cmp			ebx, 0
	jne			zero
	mov			ebx, 1
	zero:
	cdq
	div			ebx
	pop			ebx
	popf
	pop			ebp
	ret
divProc			ENDP


_main:
	
	; get the first number
	output		ot1
	input		instring, 11
	
	; edi determines which number we are changing to dword first. 0 means first number
	mov			edi, 0
	
	
	
	
	
ChangeNumber:lea    esi, instring		; turns the string in instring into a number in eax

WhileBlankD:cmp    BYTE PTR [esi],' '  ; space?
            jne    EndWhileBlankD      ; exit if not
            inc    esi                 ; increment character pointer
            jmp    WhileBlankD         ; and try again
EndWhileBlankD:

            mov    eax,1               ; default sign multiplier
IfPlusD:    cmp    BYTE PTR [esi],'+'  ; leading + ?
            je     SkipSignD           ; if so, skip over
IfMinusD:   cmp    BYTE PTR [esi],'-'  ; leading - ?
            jne    EndIfSignD          ; if not, save default +
            mov    eax,-1              ; -1 for minus sign
SkipSignD:  inc    esi                 ; move past sign
EndIfSignD:

            mov    sign, eax         ; save sign multiplier
            mov    eax,0               ; number being accumulated
            mov    cx,0                ; count of digits so far

WhileDigitD:cmp    BYTE PTR [esi],'0'  ; compare next character to '0'
            jl     EndWhileDigitD      ; not a digit if smaller than '0'
            cmp    BYTE PTR [esi],'9'  ; compare to '9'
            jg     EndWhileDigitD      ; not a digit if bigger than '9'
            imul   eax,10              ; multiply old number by 10
            mov    bl,[esi]            ; ASCII character to BL
            and    ebx,0000000Fh       ; convert to single-digit integer
            add    eax,ebx             ; add to sum
            inc    cx                  ; increment digit count
            inc    esi                 ; increment character pointer
            jmp    WhileDigitD         ; go try next character
EndWhileDigitD:
			imul   sign
		


	cmp		edi, 0 ;if edi was 1, jump to the part where we will input the sign (+, -, *, /)
	jne		Parameter
	
	mov		innum1, eax ;save the number that was changed to dword
	inc		edi			;set edi as 1 to show that we are inputting the second number
	
	output		ot2		
	input		instring, 11
	
	jmp			ChangeNumber ;now it is time to change the second number into a dword

	
Parameter:	
	
	mov			innum2, eax ;save the second number
	
	output		ot3
	input		instring, 3	; get the sign (+, -, *, /)
	
	cmp			instring, '+' ;in case it was +
	jne			minus
	push		innum1
	push		innum2
	call		addProc		; call the add prodedure
	sub			esp, 8
	jmp			ChangeSrting
	
	minus:
	cmp			instring, '-'
	jne			multi
	push		innum1
	push		innum2
	call		subProc
	sub			esp, 8
	jmp			ChangeSrting
	
	multi:
	cmp			instring, '*'
	jne			divi
	push		innum1
	push		innum2
	call		mulProc
	sub			esp, 8
	jmp			ChangeSrting
	
	divi:
	cmp			instring, '/'
	jne			badsign
	cmp			innum2, 0
	je			divisonbyz
	push		innum1
	push		innum2
	call		divProc
	sub			esp, 8
	
	
	
	
	
	ChangeSrting: ;now we have a number in eax which we will turn into a string
            lea    edi, outps          ; second parameter (dest addr)
ifSpecialD2: cmp    eax,80000000h       ; special case -2,147,483,648?
            jne    EndIfSpecialD2       ; if not, then normal case
            mov    BYTE PTR [edi],'-'   ; manually put in ASCII codes
            mov    BYTE PTR [edi+1],'2' ;   for -2,147,483,648
            mov    BYTE PTR [edi+2],'1'
            mov    BYTE PTR [edi+3],'4'
            mov    BYTE PTR [edi+4],'7'
            mov    BYTE PTR [edi+5],'4'
            mov    BYTE PTR [edi+6],'8'
            mov    BYTE PTR [edi+7],'3'
            mov    BYTE PTR [edi+8],'6'
            mov    BYTE PTR [edi+9],'4'
            mov    BYTE PTR [edi+10],'8'
            jmp    endofall            ; done with special case
EndIfSpecialD2:

            mov    edx, eax            ; save source number

            mov    al,' '              ; put blanks in
            mov    ecx,10              ;   first ten
            cld                        ;   bytes of
            rep stosb                  ;   destination field    

            mov    eax, edx            ; copy source number
            mov    cl,' '              ; default sign (blank for +)
IfNegD2:     cmp    eax,0               ; check sign of number
            jge    EndIfNegD2           ; skip if not negative
            mov    cl,'-'              ; sign for negative number
            neg    eax                 ; number in EAX now >= 0
EndIfNegD2:

            mov    ebx,10              ; divisor

WhileMoreD2: mov    edx,0               ; extend number to doubleword
            div    ebx                 ; divide by 10
            add    dl,30h              ; convert remainder to character
            mov    [edi],dl            ; put character in string
            dec    edi                 ; move forward to next position
            cmp    eax,0               ; check quotient
            jnz    WhileMoreD2          ; continue if quotient not zero

            mov    [edi],cl            ; insert blank or "-" for sign
			
			
			
			
	jmp			endofall
	badsign:	;when someone typed a bad sign
		lea		esi, errm
		lea		edi, outps
		mov		ecx, 10
		rep		movsb
		jmp		endofall
	divisonbyz:
		lea		esi, errz
		lea		edi, outps
		mov		ecx, 10
		rep		movsb
	endofall:	;output the result
		output		ot4
	INVOKE 			ExitProcess, 0

PUBLIC _main



END
