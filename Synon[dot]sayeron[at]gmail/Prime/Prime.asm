;Prime

.386
.MODEL FLAT

INCLUDE io.h

ExitProcess	PROTO NEAR32 stdcall, dwExitCode:DWORD

.STACK 4096

.DATA
primes			DWORD			100 DUP(?)
result			BYTE			0dh,0ah
number			DWORD			?
				BYTE			0dh,0ah,0
counter			DWORD			?

.CODE
_start:

				lea				ebx,primes
				mov				ecx,2
				mov				[ebx],ecx
				add				ebx,4
				mov				ecx,3
				mov				[ebx],ecx
				add				ebx,4
				mov				counter,2
				mov				number,4
				
while_loop:		cmp				counter,100
				jge				end_while
				mov				ecx,2
				
while_loop2:	cmp				ecx,number
				je				Is
				mov				eax,number
				cdq
				idiv			ecx
				cmp				edx,0
				je				IsNot
				inc				ecx
				jmp				while_loop2
				
Is:				mov				ecx,number
				mov				[ebx],ecx
				add				ebx,4
				inc				counter
				inc				number
				jmp				while_loop

IsNot:			inc				number
				jmp				while_loop

end_while:		lea				ebx,primes
				mov				ecx,100
until:			
				dtoa			number,[ebx]
				output			result
				add				ebx,4
				loop			until
				
				INVOKE			ExitProcess,0
PUBLIC _start
END