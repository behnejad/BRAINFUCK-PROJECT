;Average III

.386
.MODEL FLAT

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

include io.h

.STACK 4096

.DATA
prompt		BYTE	"This program will evaluate average of four grades.",0Dh,0Ah,0
prompt1		BYTE	"Grade 1? ",0
prompt1_1	BYTE	"Weight 1? ",0
prompt2		BYTE	"Grade 2? ",0
prompt2_2	BYTE	"Weight 2? ",0
prompt3		BYTE	"Grade 3? ",0
prompt3_3	BYTE	"Weight 3? ",0
prompt4		BYTE	"Grade 4? ",0
prompt4_4	BYTE	"Weight 4? ",0
value		BYTE	10 DUP(?)
answer		BYTE	"Weighted sum: "
sum			BYTE	5 DUP(?)
			BYTE	0Dh,0Ah,"       Sum of weights: "
weight		BYTE	5 DUP(?)
			BYTE	0Dh,0Ah,"       Weighted average: "
result		BYTE	5 DUP(?),0Dh,0Ah,0

.CODE
_start:
			output	prompt
			output	prompt1
			input	value,10
			atod	value
			mov		edx,eax
			output	prompt1_1
			input	value,10
			atod	value
			imul	edx,eax
			mov		ebx,edx
			mov		ecx,eax
			
			output	prompt2
			input	value,10
			atod	value
			mov		edx,eax
			output	prompt2_2
			input	value,10
			atod	value
			imul	edx,eax
			add		ebx,edx
			add		ecx,eax
			
			output	prompt3
			input	value,10
			atod	value
			mov		edx,eax
			output	prompt3_3
			input	value,10
			atod	value
			imul	edx,eax
			add		ebx,edx
			add		ecx,eax
			
			output	prompt4
			input	value,10
			atod	value
			mov		edx,eax
			output	prompt4_4
			input	value,10
			atod	value
			imul	edx,eax
			add		ebx,edx
			add		ecx,eax
			
			dtoa	sum,ebx
			dtoa	weight,ecx
			mov		eax,ebx
			mov		edx,0
			idiv	ecx
			dtoa	result,eax
			output	answer
			INVOKE	ExitProcess,0
			
PUBLIC _start
END