.386
.MODEL FLAT
.STACK 4096
Lf			equ			0ah
cr			equ			0dh
include io.h
ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

.DATA
promptf				byte	'As you input numbers one at a time, this program will report the sum so far and the average', cr, Lf, cr, Lf, 0
sum					dword		0
count				dword		0
prompt				byte	"  enter	Number ?"
countString			byte	11 dup(?), 20h, '?', 20h, 0
strin				byte	40 dup(?)
prompt2				byte	'sum '
result				byte	11 dup(?), ' average '
avgstr				byte	11 dup(?), cr, Lf, cr, Lf, 0


.CODE

_start:

			output promptf


loopBegin:
			inc count
			dtoa countString, count
			output prompt
			input strin, 40
			atod strin
			add sum, eax
			dtoa sumstr, sum
			mov eax, sum
			cdq
			mov ebx, count
			idiv ebx
			dtoa avgstr, eax
			output prompt2
			jmp loopBegin
loopEnd:
invoke ExitProcess,0
public _start
end

	