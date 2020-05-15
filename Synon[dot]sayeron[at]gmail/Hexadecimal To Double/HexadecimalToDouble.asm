;Hexadecimal To Double

.386
.MODEL FLAT

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

INCLUDE io.h

.Stack 4096


.DATA
prompt					BYTE				"Enter your number in hexadecimal form: ",0
inString				BYTE				12 DUP(?)
result					BYTE				"Number is "
answer					DWORD				?
						BYTE				0dh,0ah,0


EXTRN					hexToInt:NEAR32

.CODE
_start:
						output				prompt
						input				inString,12
						lea					eax,inString
						push				eax
						call				hexToInt
						dtoa				answer,eax
						output				result
						INVOKE				ExitProcess,0
PUBLIC _start
END