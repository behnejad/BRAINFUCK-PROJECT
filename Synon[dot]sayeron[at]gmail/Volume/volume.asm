;Volume

.386
.MODEL FLAT

include io.h

ExitProcess PROTO NEAR32 stdcall, dwWxitCode:DWORD

.DATA
prompt1		BYTE	"This program will evaluate volume of a cube",0Ah,0Dh,"Enter length: ",0
prompt2 	BYTE	"Enter width: ",0
prompt3		BYTE	"Enter hight: ",0
value		BYTE	16 DUP(?)
answer		BYTE	"Volume is: "
result		BYTE	6 DUP(?),0Dh,0Ah,0

.CODE
_start:
			output	prompt1
			input	value,16
			atod	value
			mov		ebx,eax
			output	prompt2
			input	value,16
			atod	value
			mul		ebx
			mov		ebx,eax
			output	prompt3
			input	value,16
			atod	value
			mul		ebx
			dtoa	result,eax
			output	answer
			INVOKE	ExitProcess,0
			
PUBLIC _start
END