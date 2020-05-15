;procedure AVG
.386
.MODEL FLAT

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

INCLUDE io.h 
.STACK  4096 ;4 kb
.DATA
prompt	BYTE	"Enter a number",0
inString	BYTE	11 DUP(?)
array	DWORD	10 DUP(?)
res		BYTE	"ave="
answer	BYTE	11 DUP(?),0dh,0ah,0


.CODE
avg		proc	NEAR32
		push	ebp
		mov		ebp,esp
		
		mov		ecx,[ebp+8];jayi ke number of elements gharar dare
		mov		ebx,[ebp+12];jayi ke address shoro gharar dare
		mov		eax,0
	

addLoop:
		add		eax,[ebx]
		add		ebx,4
		dec		ecx
		cmp		ecx,0
		je		endAddLoop
		jmp		addLoop
		
endAddLoop:
		mov		ecx,[ebp+8]
		cdq
		div		ecx
		pop		ebp
		ret
		
avg		endp
_start:
		lea		ebx,array
		mov		ecx,10
		
whileLoop:		output	prompt
				input	inString,11
				atod	inString
				mov		[ebx],eax
				add		ebx,4
				dec		ecx
				cmp		ecx,0
				je		endWhile
				jmp		whileLoop
				
endWhile:  		
				lea		ebx,array
				push	ebx ; gharadan address shoro dar stack(4 byte)
				mov		ecx,10
				push	ecx;gharadan tedad anasor array dar stack
				call	avg;4 byte address call dar stack 
				dtoa	answer,eax
				output	res
				
				INVOKE  ExitProcess, 0 

PUBLIC _start              

END 
