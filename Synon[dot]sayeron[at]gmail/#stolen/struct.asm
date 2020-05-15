.386
.MODEL FLAT
.STACK 4096
include io.h
ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD






					
.DATA
RECT STRUCT
      left    DWORD  ?
      top     DWORD  ?
      right   DWORD  ?
      bottom  DWORD  ?
RECT ENDS
PUBLIC Rct
Rct		RECT <1,2,3,4> 

;PUBLIC		


answer				DWORD		?	

.CODE

_start:

				mov Rct.left,   3
    mov Rct.top,    2
    mov Rct.right,  3
    mov Rct.bottom, 4
					
					mov			eax,0
					mov			ecx,0
	

					


					dtoa		answer,Rct.left
					output		answer
					INVOKE	ExitProcess,0

PUBLIC		_start
END 