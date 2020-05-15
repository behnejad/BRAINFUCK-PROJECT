;Money

.386
.MODEL FLAT

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

include io.h

.STACK 4096

.DATA
prompt1		BYTE	"This program will count your money!",0Dh,0Ah,"Enter number of pennies: ",0
prompt2		BYTE	"Enter number of nickels: ",0
prompt3		BYTE	"Enter number of dimes: ",0
prompt4		BYTE	"Enter number of quaters: ",0
prompt5		BYTE	"Enter number of fifty cents: ",0
prompt6		BYTE	"Ente number of dollars: ",0
value		BYTE	16 DUP(?)
answer		BYTE	"There are "
noOfCoins	WORD	?
			BYTE	0Dh,0Ah,0
			BYTE	"        coins worth "
dollars		DWORD	?
			BYTE	0Dh,0Ah,0

.CODE
_start:
			output	prompt1
			input	value,16
			atod	value
			mov		ebx,eax
			mov		ecx,eax
			
			output	prompt2
			input	value,16
			atod	value
			add		ebx,eax
			imul	eax,5
			add		ecx,eax
			
			output	prompt3
			input	value,16
			atod	value
			add		ebx,eax
			imul	eax,10
			add		ecx,eax
			
			output	prompt4
			input	value,16
			atod	value
			add		ebx,eax
			imul	eax,25
			add		ecx,eax
			
			output	prompt5
			input	value,16
			atod	value
			add		ebx,eax
			imul	eax,50
			add		ecx,eax
			
			output	prompt6
			input	value,16
			atod	value
			add		ebx,eax
			imul	eax,100
			add		ecx,eax
			
			dtoa	noOfCoins,ebx
			dtoa	dollars,ecx
			output	answer
			INVOKE	ExitProcess,0

PUBLIC _start
END