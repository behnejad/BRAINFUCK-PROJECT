;Calculator

.386
.MODEL FLAT

INCLUDE	io.h

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

.STACK 4096

.DATA
prompt1		BYTE	"Enter number: ",0
number		BYTE	11 DUP(?)
prompt2		BYTE	"Choose action (+ , - , c , q) :",0
action		BYTE	3 DUP(?)
result		BYTE	"Total is"
total		DWORD	?
			BYTE	"         .",0dh,0ah,0
prompt3		BYTE	"Invalid action!",0
			
.CODE
_start:
			mov		ebx,0
while_loop:	output	prompt1
			input	number,11
			output	prompt2
			input	action,3
			cmp		action,'+'
			je		plus
			cmp		action,'-'
			je		minus
			cmp		action,'c'
			je		clear
			cmp		action,'q'
			je		quit
			output	prompt3
			jmp		while_loop

plus:		atod	number
			add		ebx,eax
			jmp		while_loop
minus:		atod	number
			sub		ebx,eax
			jmp		while_loop
clear:		atod	number
			mov		ebx,0
			jmp		while_loop
quit:		dtoa	total,ebx
			output	result
			INVOKE	ExitProcess,0
			
PUBLIC _start
END