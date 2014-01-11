; IO.H -- header file for I/O macros
; 32-bit version for flat memory model
; R. Detmer   last revised 8/2000
.NOLIST     ; turn off listing
.586
;---------------------------------------------------------------------------
EXTRN		itoaproc:near32,
			dtoaproc:near32,
			atoiproc:near32,
			atodproc:near32,
			outproc:near32,
			inproc:near32,
			fAddProc:near32,
			fMultProc:near32,
			ftoaproc:near32,
			atofproc:near32,
			addUnp:near32,
			mulUnp1:near32,
			divUnp1:near32,
			ptoaProc:near32,
			atopProc:near32,
			addBcd1:near32,
			subBcd1:near32,
			addBcd:near32

;---------------------------------------------------------------------------
addAll MACRO  nbr1, nbr2, nbr3, nbr4, nbr5
; add up to 5 doubleword integers, putting sum in EAX
       mov   eax, nbr1    ; first operand
       IFNB  <nbr2>
       add   eax, nbr2    ; second operand
       ENDIF
       IFNB  <nbr3>
       add   eax, nbr3    ; third operand
       ENDIF
       IFNB  <nbr4>
       add   eax, nbr4    ; fourth operand
       ENDIF
       IFNB  <nbr5>
       add   eax, nbr5    ; fifth operand
       ENDIF
       ENDM
;---------------------------------------------------------------------------
swap     MACRO  dword1, dword2
; exchange two doublewords in memory
         push   eax
         mov    eax, dword1
         xchg   eax, dword2
         mov    dword1, eax
         pop    eax
         ENDM
;---------------------------------------------------------------------------			
min2     MACRO  first, second
         LOCAL  endIfMin
; put smaller of two doublewords in the EAX register
         mov    eax, first
         cmp    eax, second
         jle    endIfMin
         mov    eax, second
endIfMin:
         ENDM
;---------------------------------------------------------------------------
expand    MACRO  source, sign, exponent, fraction
			LOCAL  addOne, endAddOne
			
			IFB    <source>
            .ERR <missing operand(s) in expand>
            EXITM
            ENDIF
			
			IFB    <sign>
            .ERR <missing operand(s) in expand>
            EXITM
            ENDIF
			
			IFB    <exponent>
            .ERR <missing operand(s) in expand>
            EXITM
            ENDIF
			
			IFB    <fraction>
            .ERR <missing operand(s) in expand>
            EXITM
            ENDIF
			
; take the 32-bit floating point value source and expand it into 
; separate pieces:
;   sign: byte
;   exponent: word (bias removed)
;   fraction: doubleword (with leading 1)
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
;---------------------------------------------------------------------------
combine  MACRO  destination, sign, exponent, fraction
			LOCAL  endZero
			IFB    <destination>
            .ERR <missing operand(s) in combine>
            EXITM
            ENDIF
			
			IFB    <sign>
            .ERR <missing operand(s) in combine>
            EXITM
            ENDIF
			
			IFB    <exponent>
            .ERR <missing operand(s) in combine>
            EXITM
            ENDIF
			
			IFB    <fraction>
            .ERR <missing operand(s) in combine>
            EXITM
            ENDIF
			
; take the separate pieces:
;   sign: byte
;   exponent: word (bias removed)
;   fraction: doubleword (with leading 1)
; of a floating point value and combine them into a 32-bit
; IEEE result at destination
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
;---------------------------------------------------------------------------
normalize  MACRO sign, exponent, fraction
		  LOCAL  endZero, while1, while2, endWhile1, endWhile2
			IFB    <sign>
            .ERR <missing operand(s) in normalize>
            EXITM
            ENDIF
			
			IFB    <exponent>
            .ERR <missing operand(s) in normalize>
            EXITM
            ENDIF
			
			IFB    <fraction>
            .ERR <missing operand(s) in normalize>
            EXITM
            ENDIF
			
; Normalize floating point number represented by separate pieces:
;   sign: byte
;   exponent: word (bias removed)
;   fraction: doubleword (with leading 1)
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
;---------------------------------------------------------------------------
itoa        MACRO  dest,source,xtra    ;; convert integer to ASCII string

            IFB    <source>
            .ERR <missing operand(s) in ITOA>
            EXITM
            ENDIF

            IFNB   <xtra>
            .ERR <extra operand(s) in ITOA>
            EXITM
            ENDIF

            push   ebx                  ;; save EBX
            mov    bx, source
            push   bx                   ;; source parameter
            lea    ebx,dest             ;; destination address
            push   ebx                  ;; destination parameter
            call   itoaproc             ;; call itoaproc(source,dest)
            pop    ebx                  ;; restore EBX
            ENDM
;---------------------------------------------------------------------------
atoi        MACRO  source,xtra          ;; convert ASCII string to integer in AX
                                        ;; offset of terminating character in ESI

            IFB    <source>
            .ERR <missing operand in ATOI>
            EXITM
            ENDIF

            IFNB   <xtra>
            .ERR <extra operand(s) in ATOI>
            EXITM
            ENDIF

            push   ebx                 ;; save EBX
            lea    ebx,source          ;; source address to EBX
            push   ebx                 ;; source parameter on stack
            call   atoiproc            ;; call atoiproc(source)
            pop    ebx                 ;; parameter removed by ret
            ENDM
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
atod        MACRO  source,xtra         ;; convert ASCII string to integer in EAX
                                       ;; offset of terminating character in ESI

            IFB    <source>
            .ERR <missing operand in ATOD>
            EXITM
            ENDIF

            IFNB   <xtra>
            .ERR <extra operand(s) in ATOD>
            EXITM
            ENDIF

            lea    eax,source          ;; source address to EAX
            push   eax                 ;; source parameter on stack
            call   atodproc            ;; call atodproc(source)
                                       ;; parameter removed by ret
            ENDM
;---------------------------------------------------------------------------
output      MACRO  string,xtra         ;; display string

            IFB    <string>
            .ERR <missing operand in OUTPUT>
            EXITM
            ENDIF

            IFNB   <xtra>
            .ERR <extra operand(s) in OUTPUT>
            EXITM
            ENDIF

            push   eax                 ;; save EAX
            lea    eax,string          ;; string address
            push   eax                 ;; string parameter on stack
            call   outproc             ;; call outproc(string)
            pop    eax                 ;; restore EAX
            ENDM
;---------------------------------------------------------------------------
input       MACRO  dest,length,xtra    ;; read string from keyboard

            IFB    <length>
            .ERR <missing operand(s) in INPUT>
            EXITM
            ENDIF

            IFNB   <xtra>
            .ERR <extra operand(s) in INPUT>
            EXITM
            ENDIF

            push   ebx                 ;; save EBX
            lea    ebx,dest            ;; destination address
            push   ebx                 ;; dest parameter on stack
            mov    ebx,length          ;; length of buffer
            push   ebx                 ;; length parameter on stack
            call   inproc              ;; call inproc(dest,length)
            pop    ebx                 ;; restore EBX
            ENDM

;---------------------------------------------------------------------------
.NOLISTMACRO ; suppress macro expansion listings
.LIST        ; begin listing
