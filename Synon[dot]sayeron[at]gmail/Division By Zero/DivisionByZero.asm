;Division By Zero

.386
.MODEL FLAT

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

include io.h

.STACK 4096

.DATA
label1		BYTE	"This program will rise an exception when trying to divide 1 by 0 !",0

.CODE
_start:
			output	label1
			mov		bl,0
			mov		ax,0
			div		bl
			INVOKE	ExitProcess,0

PUBLIC _start
END