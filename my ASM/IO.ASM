.586
.MODEL FLAT, syscall
;-----------------------------------------------------------------------
STD_OUTPUT EQU -11
STD_INPUT  EQU -10
false     EQU  0
true      EQU  1
C3 EQU 0100000000000000b
C2 EQU 0000010000000000b
C0 EQU 0000000100000000b
GetStdHandle PROTO NEAR32 stdcall,
    nStdHandle:DWORD

ReadFile PROTO NEAR32 stdcall,
    hFile:DWORD, lpBuffer:NEAR32, nNumberOfCharsToRead:DWORD,
    lpNumberOfBytesRead:NEAR32, lpOverlapped:NEAR32

WriteFile PROTO NEAR32 stdcall,
    hFile:DWORD, lpBuffer:NEAR32, nNumberOfCharsToWrite:DWORD,
    lpNumberOfBytesWritten:NEAR32, lpOverlapped:NEAR32
;-----------------------------------------------------------------------
.DATA
written    DWORD  ?
read       DWORD  ?
strAddr    DWORD  ?
strLength  DWORD  ?
hStdOut    DWORD  ?
hStdIn     DWORD  ?

sign1      BYTE  ?
exponent1  WORD  ?
fraction1  DWORD ?
sign2      BYTE  ?
exponent2  WORD  ?
fraction2  DWORD ?
sign3      BYTE  ?
exponent3  WORD  ?
fraction3  DWORD ?

value     REAL4  ?
ten       REAL4  10.0
one       REAL4  1.0
round     REAL4  0.000005
digit     WORD   ?
exponent  WORD   ?
controlWd WORD   ?
byteTen   BYTE   10

point     BYTE   ?
minus     BYTE   ?
;-----------------------------------------------------------------------
combine  MACRO  destination, sign, exponent, fraction
		  LOCAL  endZero
          push eax             ; save EAX
          push ebx             ;   and EBX
          mov  eax, 0          ; zero result
          cmp  fraction, 0     ; zero value?
          je   endZero         ; skip if so
          mov  al, sign        ; get sign
          ror  eax, 1          ; rotate sign into position
          mov  bx, exponent    ; get exponent
          add  bx, 127         ; add bias
          shl  ebx, 23         ; shift to exponent position
          or   eax, ebx        ; combine with sign
          mov  ebx, fraction   ; get fraction
          and  ebx, 7fffffh    ; remove leading 1 bit
          or   eax, ebx        ; combine with sign and exponent
endZero:
          mov  destination, eax ;store result
          pop  ebx             ; restore registers
          pop  eax
          ENDM
;-----------------------------------------------------------------------		  
normalize  MACRO sign, exponent, fraction
		  LOCAL  endZero, while1, while2, endWhile1, endWhile2
          push eax             ; save EAX
          cmp  fraction, 0     ; zero fraction?
          je   endZero         ; exit if so
while1:   mov  eax, fraction   ; copy fraction
          and  eax, 0ff000000h ; non-zero leading byte?
          jz   endWhile1       ; exit if zero
          shr  fraction, 1     ; shift fraction bits right
          inc  exponent        ; subtract 1 from exponent
          jmp  while1          ; repeat
endWhile1:
while2:   mov  eax, fraction   ; copy fracton
          and  eax, 800000h    ; check bit 23
          jnz  endWhile2       ; exit if 1
          shl  fraction, 1     ; shift fraction bits left
          dec  exponent        ; subtract 1 from exponent
          jmp  while2          ; repeat
endWhile2:
endZero:
          pop  eax             ; restore EAX
          ENDM
;-----------------------------------------------------------------------		  
expand    MACRO  source, sign, exponent, fraction
		  LOCAL  addOne, endAddOne
          push eax             ; save EAX
          mov  eax, source     ; get source
          rol  eax, 1          ; sign to bit 0
          mov  sign, 0         ; clear sign
          mov  sign, al        ; get byte with sign bit
          and  sign, 1         ; mask all but sign bit
          rol  eax, 8          ; shift exponent to bits 0-7
          mov  exponent, ax    ; get word with biased exponent
          and  exponent, 0ffh  ; mask all but exponent
          sub  exponent, 127   ; subtract bias
          shr  eax, 9          ; shift fraction to right
          test eax, eax        ; is fraction zero?
          jnz  addOne          ; add leading 1 bit if non-zero
          cmp  exponent, -127  ; was original exponent 0?
          je   endAddOne       ; if so, leave fraction at zero
AddOne:   or   eax, 800000h    ; add leading 1 bit
endAddOne:
          mov  fraction, eax   ; store fraction
          pop  eax             ; restore EAX
          ENDM
;-----------------------------------------------------------------------
PUBLIC 	itoaproc,
		dtoaproc,
		atoiproc,
		atodproc,
		outproc,
		inproc,
		fAddProc,
		fMultProc,
		ftoaproc,
		atofproc,
		addUnp,
		mulUnp1,
		divUnp1,
		ptoaProc,
		atopProc,
		addBcd1,
		subBcd1,
		addBcd

.CODE
;-----------------------------------------------------------------------
itoaproc    PROC   NEAR32
            push   ebp
            mov    ebp, esp             ; establish stack frame
            push   eax                  ; Save registers
            push   ebx                  ;   used by
            push   ecx                  ;   procedure
            push   edx
            push   edi
            pushf                      ; save flags

            mov    ax, [ebp+12]        ; first parameter (source integer)
            mov    edi, [ebp+8]        ; second parameter (dest offset)
ifSpecial:  cmp    ax,8000h            ; special case -32,768?
            jne    EndIfSpecial        ; if not, then normal case
            mov    BYTE PTR [edi],'-'  ; manually put in ASCII codes
            mov    BYTE PTR [edi+1],'3'  ;   for -32,768
            mov    BYTE PTR [edi+2],'2'
            mov    BYTE PTR [edi+3],'7'
            mov    BYTE PTR [edi+4],'6'
            mov    BYTE PTR [edi+5],'8'
            jmp    ExitIToA            ; done with special case
EndIfSpecial:
            mov    dx, ax              ; save source number
			mov    al,' '              ; put blanks in
            mov    ecx,5               ;   first five
            cld                        ;   bytes of
            rep stosb                  ;   destination field    
            mov    ax, dx              ; copy source number
            mov    cl,' '              ; default sign (blank for +)
IfNeg:      cmp    ax,0                ; check sign of number
            jge    EndIfNeg            ; skip if not negative
            mov    cl,'-'              ; sign for negative number
            neg    ax                  ; number in AX now >= 0
EndIfNeg:
            mov    bx,10               ; divisor
WhileMore:  mov    dx,0                ; extend number to doubleword
            div    bx                  ; divide by 10
            add    dl,30h              ; convert remainder to character
            mov    [edi],dl            ; put character in string
            dec    edi                 ; move forward to next position
            cmp    ax,0                ; check quotient
            jnz    WhileMore           ; continue if quotient not zero
            mov    [edi],cl            ; insert blank or "-" for sign
ExitIToA:   popf                       ; restore flags and registers
            pop    edi
            pop    edx
            pop    ecx
            pop    ebx 
            pop    eax
            pop    ebp 
            ret    6                   ;exit, discarding parameters
itoaproc    ENDP
;-----------------------------------------------------------------------
dtoaproc    PROC   NEAR32
            push   ebp                 ; save base pointer
            mov    ebp, esp            ; establish stack frame
            push   eax                 ; Save registers
            push   ebx                 ;   used by
            push   ecx                 ;   procedure
            push   edx
            push   edi
            pushf                      ; save flags

            mov    eax, [ebp+12]         ; first parameter (source double)
            mov    edi, [ebp+8]          ; second parameter (dest addr)
ifSpecialD: cmp    eax,80000000h       ; special case -2,147,483,648?
            jne    EndIfSpecialD       ; if not, then normal case
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
            jmp    ExitDToA            ; done with special case
EndIfSpecialD:

            mov    edx, eax            ; save source number
            mov    al,' '              ; put blanks in
            mov    ecx,10              ;   first ten
            cld                        ;   bytes of
            rep stosb                  ;   destination field    

            mov    eax, edx            ; copy source number
            mov    cl,' '              ; default sign (blank for +)
IfNegD:     cmp    eax,0               ; check sign of number
            jge    EndIfNegD           ; skip if not negative
            mov    cl,'-'              ; sign for negative number
            neg    eax                 ; number in EAX now >= 0
EndIfNegD:
            mov    ebx,10              ; divisor
WhileMoreD: mov    edx,0               ; extend number to doubleword
            div    ebx                 ; divide by 10
            add    dl,30h              ; convert remainder to character
            mov    [edi],dl            ; put character in string
            dec    edi                 ; move forward to next position
            cmp    eax,0               ; check quotient
            jnz    WhileMoreD          ; continue if quotient not zero
            mov    [edi],cl            ; insert blank or "-" for sign
ExitDToA:   popf                       ; restore flags and registers
            pop    edi
            pop    edx
            pop    ecx
            pop    ebx 
            pop    eax
            pop    ebp 
            ret    8                   ;exit, discarding parameters
dtoaproc    ENDP
;-----------------------------------------------------------------------
atoiproc    PROC   NEAR32
            push   ebp                 ; save base pointer
            mov    ebp, esp            ; establish stack frame
            sub    esp, 2              ; local space for sign
            push   ebx                 ; Save registers
            push   ecx
            push   edx
            pushf                      ; save flags
            mov    esi,[ebp+8]         ; get parameter (source addr)
WhileBlank: cmp    BYTE PTR [esi],' '  ; space?
            jne    EndWhileBlank       ; exit if not
            inc    esi                 ; increment character pointer
            jmp    WhileBlank          ; and try again
EndWhileBlank:
            mov    ax,1                ; default sign multiplier
IfPlus:     cmp    BYTE PTR [esi],'+'  ; leading + ?
            je     SkipSign            ; if so, skip over
IfMinus:    cmp    BYTE PTR [esi],'-'  ; leading - ?
            jne    EndIfSign           ; if not, save default +
            mov    ax,-1               ; -1 for minus sign
SkipSign:   inc    esi                 ; move past sign
EndIfSign:
            mov    [ebp-2],ax          ; save sign multiplier
            mov    ax,0                ; number being accumulated
            mov    cx,0                ; count of digits so far

WhileDigit: cmp    BYTE PTR [esi],'0'  ; compare next character to '0'
            jl     EndWhileDigit       ; not a digit if smaller than '0'
            cmp    BYTE PTR [esi],'9'  ; compare to '9'
            jg     EndWhileDigit       ; not a digit if bigger than '9'
            imul   ax,10               ; multiply old number by 10
            jo     overflow            ; exit if product too large
            mov    bl,[esi]            ; ASCII character to BL
            and    bx,000Fh            ; convert to single-digit integer
            add    ax,bx               ; add to sum
            jc     overflow            ; exit if sum too large
            inc    cx                  ; increment digit count
            inc    esi                 ; increment character pointer
            jmp    WhileDigit          ; go try next character
EndWhileDigit:

            cmp    cx,0                ; no digits?
            jz     overflow            ; if so, set overflow error flag

            cmp    ax,8000h            ; 8000h ?
            jne    TooBig?
            cmp    WORD PTR [ebp-2],-1 ; multiplier -1 ?
            je     ok1                 ; if so, return 8000h

TooBig?:    test   ax,ax               ; check sign flag
            jns    ok                  ; will be set if number > 32,767

overflow:   pop    ax                  ; get flags
            or     ax,0000100001000100B  ; set overflow, zero & parity flags
            and    ax,1111111101111110B  ; reset sign and carry flags
            push   ax                  ; push new flag values
            mov    ax,0                ; return value of zero
            jmp    AToIExit            ; quit
ok:         imul   WORD PTR [ebp-2]    ; make signed number
ok1:        popf                       ; get original flags
            test   ax,ax               ; set flags for new number
            pushf                      ; save flags
AToIExit:   popf                       ; get flags
            pop    edx                 ; restore registers
            pop    ecx
            pop    ebx
            mov    esp, ebp            ; delete local variable space
            pop    ebp 
            ret    4                   ; exit, removing parameter
atoiproc    ENDP
;-----------------------------------------------------------------------
atodproc    PROC   NEAR32
            push   ebp                 ; save base pointer
            mov    ebp, esp            ; establish stack frame
            sub    esp, 4              ; local space for sign
            push   ebx                 ; Save registers
            push   ecx
            push   edx
            pushf                      ; save flags
            mov    esi,[ebp+8]         ; get parameter (source addr)
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

            mov    [ebp-4],eax         ; save sign multiplier
            mov    eax,0               ; number being accumulated
            mov    cx,0                ; count of digits so far

WhileDigitD:cmp    BYTE PTR [esi],'0'  ; compare next character to '0'
            jl     EndWhileDigitD      ; not a digit if smaller than '0'
            cmp    BYTE PTR [esi],'9'  ; compare to '9'
            jg     EndWhileDigitD      ; not a digit if bigger than '9'
            imul   eax,10              ; multiply old number by 10
            jo     overflowD           ; exit if product too large
            mov    bl,[esi]            ; ASCII character to BL
            and    ebx,0000000Fh       ; convert to single-digit integer
            add    eax,ebx             ; add to sum
            jc     overflowD           ; exit if sum too large
            inc    cx                  ; increment digit count
            inc    esi                 ; increment character pointer
            jmp    WhileDigitD         ; go try next character
EndWhileDigitD:

            cmp    cx,0                ; no digits?
            jz     overflowD           ; if so, set overflow error flag
; if value is 80000000h and sign is '-',  want to return 80000000h (-2^32)
            cmp    eax,80000000h       ; 80000000h ?
            jne    TooBigD?
            cmp    DWORD PTR [ebp-4],-1 ; multiplier -1 ?
            je     ok1D                ; if so, return 8000h
TooBigD?:   test   eax,eax             ; check sign flag
            jns    okD                 ; will be set if number > 2^32 - 1
overflowD:  pop    ax                  ; get flags
            or     ax,0000100001000100B  ; set overflow, zero & parity flags
            and    ax,1111111101111110B  ; reset sign and carry flags
            push   ax                  ; push new flag values
            mov    eax,0               ; return value of zero
            jmp    AToDExit            ; quit

okD:        imul   DWORD PTR [ebp-4]   ; make signed number
ok1D:       popf                       ; get original flags
            test   eax,eax             ; set flags for new number
            pushf                      ; save flags

AToDExit:   popf                       ; get flags
            pop    edx                 ; restore registers
            pop    ecx
            pop    ebx
            mov    esp, ebp            ; delete local variable space
            pop    ebp 
            ret    4                   ; exit, removing parameter
atodproc    ENDP
;-----------------------------------------------------------------------
outproc     PROC   NEAR32
            push   ebp                 ; save base pointer
            mov    ebp, esp            ; establish stack frame
            pushad
            pushfd                     ; save flags

            mov    esi,[ebp+8]         ; source address
            mov    strAddr, esi

; find string length
            mov    strLength, 0        ; initialize string length
WhileChar:  cmp    BYTE PTR [esi], 0   ; character = null?
            jz     EndWhileChar        ; exit if so
            inc    strLength           ; increment character count
            inc    esi                 ; point at next character
            jmp    WhileChar
EndWhileChar:

            INVOKE GetStdHandle,       ; get handle for console output
              STD_OUTPUT
            mov    hStdOut, eax

            INVOKE WriteFile,
              hStdOut,                 ; file handle for screen
              strAddr,                 ; address of string
              strLength,               ; length of string
              NEAR32 PTR written,      ; bytes written
              0                        ; overlapped mode

            popfd                      ; restore flags
            popad                      ; restore registers
            pop    ebp
            ret    4                   ;exit, discarding parameter
outproc     ENDP
;-----------------------------------------------------------------------
inproc      PROC   NEAR32
            push   ebp                 ; save base pointer
            mov    ebp, esp            ; establish stack frame
            pushad                     ; save all registers
            pushfd                     ; save flags

            INVOKE GetStdHandle,       ; get handle for console
              STD_INPUT
            mov    hStdIn, eax

            mov    ecx, [ebp+8]        ; string length
            mov    strLength, ecx

            mov    esi, [ebp+12]       ; source address
            mov    strAddr, esi

            INVOKE ReadFile,
              hStdIn,                  ; file handle for keyboard
              strAddr,                  ; address of string
              strLength,                ; length of string
              NEAR32 PTR read,          ; bytes read
              0                         ; overlapped mode

            mov    ecx, read           ; number of bytes read
            mov    BYTE PTR [esi+ecx-2],0 ; replace CR/LF by trailing null

            popfd                      ; restore flags
            popad                      ; restore registers
            pop    ebp 
            ret    8                   ; exit, discarding parameters
inproc      ENDP
;-----------------------------------------------------------------------
fAddProc   PROC NEAR32
           push    ebp            ; save base pointer
           mov     ebp,esp        ; copy stack pointer
           push    eax            ; save registers
           push    edx
           expand  [ebp+16], sign1, exponent1, fraction1
           expand  [ebp+12], sign2, exponent2, fraction2
           mov     ax, exponent1  ; copy exponent1
while1:    cmp     ax, exponent2  ; exponent1 < exponent2?
           jnl     endWhile1      ; exit if not
           inc     ax             ; add 1 to exponent1
           shr     fraction1,1    ; shift fraction1 1 bit right
           jmp     while1         ; repeat
endWhile1: mov     exponent1, ax  ; put fraction1 back in memory
           mov     ax, exponent2  ; copy exponent2
while2:    cmp     ax, exponent1  ; exponent2 < exponent1?
           jnl     endWhile2      ; exit if not
           inc     ax             ; add 1 to exponent1
           shr     fraction2,1    ; shift fraction2 1 bit right
           jmp     while2         ; repeat
endWhile2: mov     exponent2, ax  ; put fraction2 back in memory
           mov     exponent3, ax  ; save common exponent
           cmp     sign1, 1       ; sign1 = minus?
           jne     notNeg1        ; skip if not
           neg     fraction1      ; negate fraction1
notNeg1:
           cmp     sign2, 1       ; sign1 = minus?
           jne     notNeg2        ; skip if not
           neg     fraction2      ; negate fraction2
notNeg2:
           mov     eax, fraction1 ; add fractions
           add     eax, fraction2
           mov     fraction3, eax ; and save
           mov     sign3, 0       ; plus
           cmp     eax, 0         ; fraction3 < 0?
           jnl     notNegResult   ; skip if not
           mov     sign3, 1       ; minus
           neg     fraction3      ; make fraction3 positive
notNegResult:
           normalize sign3, exponent3, fraction3
           mov     edx, [ebp+8]   ; address for result
           combine [edx], sign3, exponent3, fraction3
           pop    edx            ; restore registers
           pop    eax 
           pop    ebp           ; restore base pointer
           ret    12            ; return, removing parameters
fAddProc   ENDP
;-----------------------------------------------------------------------
fMultProc  PROC		NEAR32
           push		ebp            ; save base pointer
           mov		ebp,esp        ; copy stack pointer
           push		eax            ; save registers
           push		edx

           expand  [ebp+16], sign1, exponent1, fraction1
           expand  [ebp+12], sign2, exponent2, fraction2
           mov     al, sign1      ; combine signs
           xor     al, sign2
           mov     sign3, al      ; and save
           mov     ax, exponent1  ; add exponents
           add     ax, exponent2
           mov     exponent3, ax  ; and save
           mov     eax, fraction1 ; multiply fractions
           mul     fraction2
           shrd    eax, edx, 23   ; discard extra bits
           mov     fraction3, eax ; and save
           normalize sign3, exponent3, fraction3
           mov     edx, [ebp+8]   ; address for result
           combine [edx], sign3, exponent3, fraction3
           pop    edx             ; restore registers
           pop    eax 
           pop    ebp             ; restore base pointer
           ret    12              ; return, removing parameters
fMultProc  ENDP
;-----------------------------------------------------------------------
ftoaproc  PROC		NEAR32  ; convert floating point number to ASCII string 
          push		ebp              ; establish stack frame
          mov		ebp, esp
          push		eax              ; save registers
          push		ebx
          push		ecx
          push		edi

          fstcw controlWd       ; get control word
          push controlWd        ; save control word
          or   controlWd, 0000110000000000b
          fldcw controlWd       ; set control to chop
          mov  edi, [ebp+8]     ; destination string address
          mov  eax, [ebp+12]    ; value to convert
          mov  exponent, 0      ; exponent := 0
          mov  value, eax       ; value to ST via memory
          fld  value
          ftst                  ; value >= 0?
          fstsw  ax             ; status word to AX
          and  ax, C0           ; check C0
          jnz  elseNeg          ; skip if set (value negative)
          mov  BYTE PTR [edi], ' '  ; blank for positive
          jmp  endifNeg
elseNeg:  mov  BYTE PTR [edi], '-'  ; minus for negative
          fchs                  ; make number positive
endifNeg:
          inc  edi              ; point at next destination byte
          mov  exponent, 0      ; exponent := 0
          ftst                  ; value = 0?
          fstsw ax              ; status word to AX
          and  ax, C3           ; check C3
          jne  endifZero        ; skip if zero
          fcom ten              ; value > 10?
          fstsw ax              ; status word to AX
          and  ax, C3 or C2 or C0   ; check for all C3=C2=C0=0
          jnz  elseLess         ; skip if value not > 10
untilLess:
          fdiv ten              ; value := value/10
          inc  exponent         ; add 1 to exponent
          fcom ten              ; value < 10
          fstsw ax              ; status word to AX
          and  ax, C0           ; check C0
          jnz  untilLess        ; continue until value < 10
          jmp  endifBigger      ; exit if
elseLess:
whileLess:
          fcom one              ; value < 1
          fstsw ax              ; status word to AX
          and  ax, C0           ; check C0
          jz   endwhileLess     ; exit if not less
          fmul ten              ; value := 10*value
          dec  exponent         ; subtract 1 from exponent
          jmp  whileLess        ; continue while value < 1
endwhileLess:
endifBigger:
endifZero:
          fadd round            ; add rounding value
          fcom ten              ; value > 10?
          fstsw ax              ; status word to AX
          and  ax, C3 or C2 or C0  ; C3=C2=C0=0? (value > 10?)
          jnz  endifOver        ; skip if not
          fdiv ten              ; value := value/10
          inc  exponent         ; add 1 to exponent
endifOver:

; at this point 1.0 <= value < 10.0
          fist digit            ; store integer part
          mov  bx, digit        ; copy integer to BX
          or   bx, 30h          ; convert digit to character
          mov  BYTE PTR [edi], bl  ; store character in destination
          inc  edi              ; point at next destination byte
          mov  BYTE PTR [edi], '.'     ; decimal point
          inc  edi              ; point at next destination byte
          
          mov  ecx, 5           ; count of remaining digits
forDigit: fisub digit           ; subtract integer part
          fmul ten              ; multiply by 10
          fist digit            ; store integer part
          mov  bx, digit        ; copy integer to BX
          or   bx, 30h          ; convert digit to character
          mov  BYTE PTR [edi], bl  ; store character in destination
          inc  edi              ; point at next destination byte
          loop forDigit         ; repeat 5 times

          mov  BYTE PTR [edi], 'E'  ; exponent indicator
          inc  edi              ; point at next destination byte
          mov  ax, exponent     ; get exponent
          cmp  ax, 0            ; exponent >= 0 ?
          jnge NegExp
          mov  BYTE PTR [edi], '+'  ; non-negative exponent
          jmp  endifNegExp
NegExp:   mov  BYTE PTR [edi], '-'  ; negative exponent
          neg  ax               ; change exponent to positive
endifNegExp:
          inc  edi              ; point at next destination byte

          div  byteTen          ; convert exponent to 2 digits
          or   ax, 3030h        ; convert both digits to ASCII
          mov  BYTE PTR [edi+1], ah  ; store characters in destination
          mov  BYTE PTR [edi], al

          pop  controlWd        ; restore control word
          fldcw controlWd
          pop  edi              ; restore registers
          pop  ecx
          pop  ebx
          pop  eax
          pop  ebp
          ret  8
ftoaproc  ENDP
;-----------------------------------------------------------------------
atofproc  PROC NEAR32  ; convert ASCII string to floating point number

          push ebp              ; establish stack frame
          mov  ebp, esp
          push eax              ; save registers
          push ebx
          push esi

          fld1                 ; divisor := 1.0
          fldz                 ; value := 0.0
          mov  point, false    ; no decimal point found yet
          mov  minus, false    ; no minus sign found yet
          mov  esi, [ebp+8]    ; address of first source character

          cmp  BYTE PTR [esi], '-'    ; leading minus sign?
          jne  endifMinus      ; skip if not
          mov  minus, true     ; minus sign found
          inc  esi             ; point at next source character
endifMinus:
          
whileOK:  mov  bl, [esi]       ; get next character
          cmp  bl, '.'         ; decimal point?
          jne  endifPoint      ; skip if not
          mov  point, true     ; found decimal point
          jmp  nextChar
endifPoint:
          cmp  bl, '0'         ; character a digit?
          jl   endwhileOK      ; exit if lower than '0'
          cmp  bl, '9'
          jg   endwhileOK      ; exit if higher than '9'
          and  bx, 000fh       ; convert ASCII to integer value
          mov  digit, bx       ; put integer in memory
          fmul ten             ; value := value * 10
          fiadd digit          ; value := value + digit
          cmp  point, true     ; already found a decimal point?
          jne  endifDec        ; skip if not
          fxch                 ; put divisor in ST and value in ST(1)
          fmul ten             ; divisor := divisor * 10
          fxch                 ; value back to ST; divisor back to ST(1)
endifDec:
nextChar: inc  esi             ; point at next source character
          jmp  whileOK        
endwhileOK:

          fdivr                ; value := value / divisor
          cmp  minus, true     ; was there a minus sign?
          jne  endifNeg
          fchs                 ; value := -value
endifNeg:
          pop  esi             ; restore registers
          pop  ebx
          pop  eax
          pop  ebp
          ret  4
atofproc  ENDP
;-----------------------------------------------------------------------
addUnp    PROC NEAR32
          push ebp            ; establish stack frame
          mov  ebp, esp
          push esi            ; save registers
          push edi
          push eax
          push ecx
          mov  edi, [ebp+12]  ; destination address
          mov  esi, [ebp+8]   ; source address
          add  esi, 8         ; point at byte after source
          add  edi, 8         ; byte after destination
          clc                 ; clear carry flag
          mov  ecx, 8         ; count of bytes to process
forAdd:   dec  edi            ; point at operand bytes to left
          dec  esi
          mov  al, [edi]      ; get one operand byte
          adc  al, [esi]      ; add other operand byte
          aaa                 ; adjust to unpacked BCD
          mov  [edi], al      ; save sum
          loop forAdd         ; repeat for all 8 bytes
          pop  ecx            ; restore registers
          pop  eax
          pop  edi
          pop  esi
          pop  ebp
          ret  8         ; return, discarding paramters
addUnp    ENDP
;-----------------------------------------------------------------------
mulUnp1   PROC NEAR32
          push ebp            ; establish stack frame
          mov  ebp, esp
          push esi            ; save registers
          push edi
          push eax
          push ebx
          push ecx
          mov  edi, [ebp+14]  ; destination address
          mov  esi, [ebp+10]  ; source address
          mov  bx, [ebp+8]    ; multiplier
          add  esi, 8         ; point at byte after source
          add  edi, 8         ; byte after destination
          mov  bh, 0          ; lastCarry := 0
          mov  ecx, 8         ; count of bytes to process
forMul:   dec  esi            ; point at operand byte to left
          dec  edi            ; and at destination byte
          mov  al, [esi]      ; digit from 8 byte number
          mul  bl             ; multiply by single byte
          aam                 ; adjust to unpacked BCD
          add  al, bh         ; add lastCarry
          aaa                 ; adjust to unpacked BCD
          mov  [edi], al      ; store units digit
          mov  bh, ah         ; store lastCarry
          loop forMul         ; repeat for all 8 bytes
          pop  ecx            ; restore registers
          pop  ebx
          pop  eax
          pop  edi
          pop  esi
          pop  ebp
          ret  10             ; return, discarding paramters
mulUnp1   ENDP
;-----------------------------------------------------------------------
divUnp1   PROC NEAR32
          push ebp            ; establish stack frame
          mov  ebp, esp
          push esi            ; save registers
          push edi
          push eax
          push ebx
          push ecx
          mov  edi, [ebp+14]  ; destination address
          mov  esi, [ebp+10]  ; source address
          mov  bx, [ebp+8]    ; divisor
          mov  ah, 0          ; lastRemainder := 0
          mov  ecx, 8         ; count of bytes to process
forDiv:   mov  al, [esi]      ; digit from 8 byte number
          aad                 ; adjust to binary
          div  bl             ; divide by single byte
          mov  [edi], al      ; store quotient
          inc  esi            ; point at next digit of dividend
          inc  edi            ; and at next destination byte
          loop forDiv         ; repeat for all 8 bytes
          pop  ecx            ; restore registers
          pop  ebx
          pop  eax
          pop  edi
          pop  esi
          pop  ebp
          ret  10             ; return, discarding paramters
divUnp1   ENDP
;-----------------------------------------------------------------------
ptoaProc  PROC NEAR
          push ebp       ; establish stack frame
          mov  ebp, esp
          push esi       ; save registers
          push edi
          push eax
          push ecx
          mov  esi, [ebp+12]  ; source address
          mov  edi, [ebp+8]   ; destination address          
          add  edi, 18   ; point to last byte of destination
          mov  ecx, 9    ; count of bytes to process
for1:     mov  al, [esi] ; byte with two bcd digits
          mov  ah, al    ; copy to high order byte of AX
          and  al, 00001111b       ; mask out higher order digit
          or   al, 30h   ; convert to ASCII character
          mov  [edi], al ; save lower order digit
          dec  edi       ; point at next destination byte to left
          shr  ah, 4     ; shift out lower order digit
          or   ah, 30h   ; convert to ASCII
          mov  [edi], ah ; save higher order digit
          dec  edi       ; point at next destination byte to left
          inc  esi       ; point at next source byte
          loop for1      ; continue for 9 bytes

          mov  BYTE PTR [edi], ' '  ; space for positive number
          and  BYTE PTR [esi], 80h  ; check sign byte
          jz   nonNeg               ; skip if not negative
          mov  BYTE PTR [edi], '-'  ; minus sign
nonNeg:
          pop ecx        ; restore registers
          pop eax
          pop esi
          pop edi
          pop ebp
          ret 8          ; return, removing parameters
ptoaProc  ENDP
;-----------------------------------------------------------------------
atopProc  PROC NEAR32
          push ebp       ; establish stack frame
          mov  ebp, esp
          push esi                   ; save registers
          push edi
          push eax
          push ecx
          mov  esi, [ebp+12]         ; source address
          mov  edi, [ebp+8]          ; destination address          
          mov  DWORD PTR [edi], 0    ; zero BCD destination
          mov  DWORD PTR [edi+4], 0
          mov  WORD PTR [edi+8], 0

          mov  ecx, 0                ; count := 0
while1:   cmp  BYTE PTR [esi], 0     ; while not end of string (null)
          jz   endwhile1
          inc  ecx                   ; add 1 to count of characters
          inc  esi                   ; point at next character
          jmp  while1                ; check again
endwhile1:

while2:   cmp  ecx, 0                ; while count > 0
          jz   endwhile2
          dec  esi                   ; point at next ASCII byte from right
          mov  al, BYTE PTR [esi]    ; get byte
          and  al, 00001111b         ; convert to BCD digit
          mov  BYTE PTR [edi], al    ; save BCD digit
          dec  ecx                   ; decrement count
          jz   endwhile2             ; exit loop if out of source digits
          dec  esi                   ; point at next ASCII byte from right
          mov  al, BYTE PTR [esi]    ; get byte
          shl  al, 4                 ; shift to left and convert to digit
          or   BYTE PTR [edi], al    ; combine with other BCD digit
          dec  ecx                   ; decrement count
          inc  edi                   ; point at next destination byte
          jmp  while2                ; repeat for all source characters
endwhile2:
          pop ecx                    ; restore registers
          pop eax
          pop esi
          pop edi
          pop ebp
          ret 8                      ; return, removing parameters
atopProc  ENDP
;-----------------------------------------------------------------------
addBcd1   PROC NEAR32
          push ebp            ; establish stack frame
          mov  ebp, esp
          push esi            ; save registers
          push edi
          push ecx
          push eax
          mov  edi, [ebp+12]  ; destination address
          mov  esi, [ebp+8]   ; source address

          clc                 ; clear carry flag for first add
          mov  ecx, 9         ; count of bytes to process
forAdd:   mov  al, [edi]      ; get one operand byte
          adc  al, [esi]      ; add other operand byte
          daa                 ; adjust to BCD
          mov  [edi], al      ; save sum
          inc  edi            ; point at next operand bytes
          inc  esi
          loop forAdd         ; repeat for all 9 bytes

          pop  eax            ; restore registers
          pop  ecx
          pop  edi
          pop  esi
          pop  ebp
          ret  8              ; return to caller

addBcd1   ENDP
;-----------------------------------------------------------------------
subBcd1   PROC NEAR32
          push ebp            ; establish stack frame
          mov  ebp, esp
          push esi            ; save registers
          push edi
          push ecx
          push eax
          mov  edi, [ebp+12]  ; destination address (operand 1)
          mov  esi, [ebp+8]   ; source address (operand 2)
          clc                 ; clear carry flag
          mov  ecx, 9         ; count of bytes to process
forSub:   mov  al, [edi]      ; get one operand byte
          sbb  al, [esi]      ; subtract other operand byte
          das                 ; adjust to BCD
          mov  [edi], al      ; save difference
          inc  edi            ; point at next operand bytes
          inc  esi
          loop forSub         ; repeat for all 9 bytes

          jnc  endIfBigger    ; done if destination >= source
          sub  edi, 9         ; point at beginning of destination
          mov  ecx, 9         ; count of bytes to process
forSub1:  mov  al, 0          ; subtract destination from zero
          sbb  al, [edi]
          das
          mov  [edi], al
          inc  edi            ; next byte
          loop forSub1
          mov  BYTE PTR [edi], 80h   ; negative result
endIfBigger:
          pop  eax            ; restore registers
          pop  ecx
          pop  edi
          pop  esi
          pop  ebp
          ret  8              ; return to caller
subBcd1   ENDP
;-----------------------------------------------------------------------
addBcd    PROC NEAR32
          push ebp            ; establish stack frame
          mov  ebp, esp
          push esi            ; save registers
          push edi
          mov  edi, [ebp+12]  ; destination address
          mov  esi, [ebp+8]   ; source address
          push edi            ; parameter1 for next call
          push esi            ; parameter2 for next call
          cmp  BYTE PTR [edi+9], 80h   ; operand1 >= 0?
          je   op1Neg
          cmp  BYTE PTR [esi+9], 80h   ; operand2 >= 0?
          je   op2Neg
          call addBcd1        ; add (>=0, >=0)
          jmp  endIfOp2Pos
op2Neg:   call subBcd1        ; sub (>=0, <0)
endIfOp2Pos:
          jmp  endIfOp1Pos    ; done
op1Neg:   cmp  BYTE PTR [esi+9], 80h   ; operand2 < 0 ?
          jne  op2Pos
          call addBcd1        ; add (<0, <0)
          jmp  endIfOp2Neg
op2Pos:   xor  BYTE PTR [edi+9], 80h  ; change sign byte
          call subBcd1        ; sub (<0, >=0)
          xor  BYTE PTR [edi+9], 80h  ; change sign byte
endIfOp2Neg:
endIfOp1Pos:
          pop  edi            ; restore registers
          pop  esi
          pop  ebp
          ret  8              ; return to caller
addBcd    ENDP
;-----------------------------------------------------------------------
END