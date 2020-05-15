;Grades

.386
.MODEL FLAT

INCLUDE io.h

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

.STACK 4096

.DATA
prompt1		BYTE	"Enter grade: ",0
number		BYTE	11 DUP(?)
result		BYTE	0dh,0ah,"Number of As"
ACount		DWORD	'0'
			BYTE	0dh,0ah,"      .Number of Bs"
BCount		DWORD	'0'
			BYTE	0dh,0ah,"      .Number of Cs"
CCount		DWORD	'0'
			BYTE	0dh,0ah,"      .Number of Ds"
DCount		DWORD	'0'
			BYTE	0dh,0ah,"      .Number of Fs"
FCount		DWORD	'0'
			BYTE	0dh,0ah,0
			
.CODE
_start:
			mov		ACount,0
while_loop:	output	prompt1
			input	number,11
			atod	number
			cmp		eax,0
			js		end_while
			cmp		eax,90
			jge		ACounted
			cmp		eax,80
			jge		BCounted
			cmp		eax,70
			jge		CCounted
			cmp		eax,60
			jge		DCounted
			jmp		FCounted

ACounted:	atod	ACount
			inc		eax
			dtoa	ACount,eax
			jmp		while_loop
BCounted:	atod	BCount
			inc		eax
			dtoa	BCount,eax
			jmp		while_loop
CCounted:	atod	CCount
			inc		eax
			dtoa	CCount,eax
			jmp		while_loop
DCounted:	atod	DCount
			inc		eax
			dtoa	DCount,eax
			jmp		while_loop
FCounted:	atod	FCount
			inc		eax
			dtoa	FCount,eax
			jmp		while_loop
end_while:
			output	result
			INVOKE	ExitProcess,0
PUBLIC _start
END