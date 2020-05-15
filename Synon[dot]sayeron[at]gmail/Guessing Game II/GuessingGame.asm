; program to implement number guessing game
; author:  R. Detmer
; date:  revised 9/97

.386
.MODEL FLAT

INCLUDE io.h

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

cr          EQU    0dh   ; carriage return character
Lf          EQU    0ah   ; linefeed character

.STACK  4096             ; reserve 4096-byte stack

.DATA                    ; reserve storage for data
prompt1     BYTE   cr,Lf,Lf,"Player 1, please enter a number:  ", 0
prompt      BYTE   "Sorry, the number is "
target1     DWORD  ?
			BYTE   "         of target",cr,Lf,0
target      DWORD  ?
clear       BYTE   24 DUP (Lf), 0
prompt2     BYTE   cr,Lf,"Player 2, your guess?   ", 0
stringIn    BYTE   20 DUP (?)
lowOutput   BYTE   "too low", cr, Lf, 0
highOutput  BYTE   "too high", cr, Lf, 0
gotItOutput BYTE   "you got it", cr, Lf, 0
countLabel  BYTE   Lf, "Number of guesses:"
countOut    BYTE   6 DUP (?)
            BYTE   cr, Lf, Lf, Lf, "Do you want to play again?  ",0
            
.CODE                               ; start of main program code
_start:

untilDone:  output prompt1          ; ask player 1 for target
            input  stringIn, 20     ; get number
            atod   stringIn         ; convert to integer
            mov    target,eax       ; store target
            output clear            ; clear screen
            mov    cx, 0            ; zero count

untilMatch: inc    cx               ; increment count of guesses
			cmp    cx,5
			jg     moreThan5
            output prompt2          ; ask player 2 for guess
            input  stringIn, 20     ; get number
            atod   stringIn         ; convert to integer

            cmp    eax, target      ; compare guess and target
            jne    ifLess           ; guess = target ?
equal:      output gotItOutput      ; display "you got it"
            jmp    endCompare
ifLess:     jnl    isGreater        ; guess < target ?
            output lowOutput        ; display "too low"
            jmp    endCompare
isGreater:  output highOutput       ; display "too high"
endCompare:
            cmp    eax, target      ; compare guess and target
            jne    untilMatch       ; ask again if guess not = target

            itoa   countOut, cx     ; convert count to ASCII
            output countLabel       ; display label, count and prompt
            input  stringIn, 20     ; get response
            cmp    stringIn, 'n'    ; response = 'n' ?
            je     endUntilDone     ; exit if so
            cmp    stringIn, 'N'    ; response = 'N' ?
            jne    untilDone        ; repeat if not
            jmp    endUntilDone
            
moreThan5:  dtoa   target1,target
			output prompt
			itoa   countOut, cx     ; convert count to ASCII
			output countLabel       ; display label, count and prompt
            input  stringIn, 20     ; get response
            cmp    stringIn, 'n'    ; response = 'n' ?
            je     endUntilDone     ; exit if so
            cmp    stringIn, 'N'    ; response = 'N' ?
            jne    untilDone        ; repeat if not
endUntilDone:

            INVOKE ExitProcess, 0   ; exit with return code 0
PUBLIC _start                       ; make entry point public
            END                     ; end of source code

