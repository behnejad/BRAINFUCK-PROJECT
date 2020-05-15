;Root

.386
.MODEL FLAT

INCLUDE io.h

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

.STACK 4096


.DATA
prompt1			BYTE		"Enter an number:",0
number			BYTE		11 DUP(?)
prompt2			BYTE		0dh,0ah,"Root is: "
answer			DWORD		?
				BYTE		0dh,0ah,0

.CODE
; procedure to compute the integer square root of number Nbr
; Nbr is passed to the procedure in EAX
; The square root SqRt is returned in EAX
; Other registers are unchanged.
; author:  R. Detmer    revised:  10/97

Root      PROC  NEAR32
          push  ebx          ; save registers
          push  ecx
          mov   ebx, 0       ; SqRt := 0
WhileLE:  mov   ecx, ebx     ; copy SqRt
          imul  ecx, ebx     ; SqRt*SqRt
          cmp   ecx, eax     ; SqRt*SqRt <= Nbr ?
          jnle  EndWhileLE   ; exit if not
          inc   ebx          ; add 1 to SqRt
          jmp   WhileLE      ; repeat
EndWhileLE:
          dec   ebx          ; subtract 1 from SqRt
          mov   eax, ebx     ; return SqRt in AX
          pop   ecx          ; restore registers
          pop   ebx
          ret               ; return
Root      ENDP

_start:
				output		prompt1
				input		number,11
				atod		number
				call		Root
				dtoa		answer,eax
				output		prompt2
				INVOKE		ExitProcess,0
PUBLIC _start
END