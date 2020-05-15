;recursive factorial
.386
.MODEL FLAT

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

INCLUDE io.h 
.STACK  4096 
.DATA
prompt		BYTE	"Enter a number",0
number		BYTE	11 DUP(?)
result		BYTE	"result="
answer		BYTE	11 DUP(?),0dh,0ah,0

.CODE
fac		proc	NEAR32
		push	ebp
		mov		ebp,esp
		pushfd
		
		mov		ebx,[ebp+8]
		cmp		ebx,1
		jle		base
		
		mul		ebx
		dec		ebx
		push	ebx
		call	fac
		popfd	
		pop		ebp
		ret		4
		
base:
		popfd
		pop		ebp
		ret		4;address bargasht bardashte mish 4 ta ham az stak khali mishe
fac		ENDP
_start:
		output	prompt
		input	number,11
		atod	number
		push	eax
		mov		eax,1
		call	fac
		dtoa	answer,eax
		output	result
INVOKE  ExitProcess, 0 

PUBLIC _start              

END 
