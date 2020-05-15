; program to input numbers and display running average and sum
; author:  R. Detmer
; date:  revised 9/97

.386
.MODEL FLAT
INCLUDE io.h

cr          EQU    0dh   ; carriage return character
Lf          EQU    0ah   ; linefeed character

.STACK  4096             ; reserve 4096-byte stack

.DATA                    ; reserve storage for data
sum         DWORD    ?
explain     BYTE     cr,Lf,"As you input numbers one at a time, this",cr,Lf
            BYTE     "program will report the count of numbers so far,",cr,Lf
            BYTE     "the sum so far, and the average.",cr,Lf,Lf,0
prompt      BYTE     "number  "
counter		WORD	 ?
			BYTE	 "     ?",0
number      BYTE     16 DUP (?)
countLabel  BYTE     "count",0
sumLabel    BYTE     "sum",0
avgLabel    BYTE     "       average",0
value       BYTE     11 DUP (?), 0
nextPrompt  BYTE     cr,Lf,Lf,"next ",0

.CODE                               ; start of main program code
_start:
            output explain          ; initial instructions
            mov    sum,0            ; sum := 0
            mov    ebx,0            ; count := 0
            mov	   cx,1

forever:    itoa   counter,cx
			output prompt           ; prompt for number
			inc    cx
            input  number,16        ; read ASCII characters
            atod   number           ; convert to integer

            add    sum,eax          ; add number to sum
            inc    ebx              ; add 1 to count

;           dtoa   value,ebx        ; convert count to ASCII
;           output countLabel       ; display label for count
;           output value            ; display count

            dtoa   value,sum        ; convert sum to ASCII
            output sumLabel         ; display label for sum
            output value            ; display sum

            mov    eax,sum          ; get sum
            cdq                     ; extend sum to 64 bits
            idiv   ebx              ; sum / count
            dtoa   value,eax        ; convert average to ASCII
            output avgLabel         ; display label for average
            output value            ; output average

            output nextPrompt       ; skip down, start next prompt
            jmp    forever          ; repeat
PUBLIC _start                       ; make entry point public
            END
