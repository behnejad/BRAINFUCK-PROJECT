; input a collection of numbers
; report their average and the numbers which are above average
; author:  R. Detmer
; date:  revised 9/97

.386
.MODEL FLAT

INCLUDE io.h

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

cr          EQU    0dh   ; carriage return character
Lf          EQU    0ah   ; linefeed character
maxNbrs     EQU    100   ; size of number array

.STACK      4096

.DATA
directions  BYTE     cr, Lf, 'You may enter up to 100 numbers'
            BYTE     ' one at a time.',cr,Lf
            BYTE     'Use any negative number to terminate input.',cr,Lf,Lf
            BYTE     'This program will then report the average and list',cr,Lf
            BYTE     'those numbers which are above the average.',cr,Lf,Lf,Lf,0
prompt      BYTE     'Number?  ',0
number      BYTE     20 DUP (?)
nbrArray    DWORD    maxNbrs DUP (?)
nbrElts     DWORD    ?
avgLabel    BYTE     cr,Lf,Lf,'The average is'
outValue    BYTE     11 DUP (?), cr,Lf,0
aboveLabel  BYTE     cr,Lf,'Above or below by 5 from average:',cr,Lf,Lf,0

.CODE
_start:
; input numbers into array

            output directions       ; display directions
            mov    nbrElts,0        ; nbrElts := 0
            lea    ebx,nbrArray     ; get address of nbrArray

whilePos:   output prompt           ; prompt for number
            input  number,20        ; get number
            atod   number           ; convert to integer
            jng    endWhile         ; exit if not positive
            mov    [ebx],eax        ; store number in array
            inc    nbrElts          ; add 1 to nbrElts
            add    ebx,4            ; get address of next item of array
            jmp    whilePos         ; repeat
endWhile:

; find sum and average

            mov    eax,0            ; sum := 0
            lea    ebx,nbrArray     ; get address of nbrArray
            mov    ecx,nbrElts      ; count := nbrElts

            jecxz  quit             ; quit if no numbers
forCount1:  add    eax,[ebx]        ; add number to sum
            add    ebx,4            ; get address of next item of array
            loop   forCount1        ; repeat nbrElts times

            cdq                     ; extend sum to quadword
            idiv   nbrElts          ; calculate average
            dtoa   outValue,eax     ; convert average to ASCII
            output avgLabel         ; print label and average
            output aboveLabel       ; print label for big numbers

; display numbers above average
            lea    ebx,nbrArray     ; get address of nbrArray
            mov    ecx,nbrElts      ; count := nbrElts

forCount2:  mov	   edx,[ebx]
			add	   edx,5	
			cmp    edx,eax          ; doubleword+5 = average ?
            je     Is               ; continue if average not less
            mov	   edx,[ebx]
            sub    edx,5
            cmp    edx,eax
            jne	   endIfBig
            
Is:			dtoa   outValue,[ebx]   ; convert value from array to ASCII
            output outValue         ; display value           
endIfBig:
            add    ebx,4            ; get address of next item of array
            loop   forCount2        ; repeat

quit:       INVOKE ExitProcess, 0   ; exit with return code 0

PUBLIC _start                       ; make entry point public
            END                     ; end of source code