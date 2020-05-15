;Maximum

.386
.MODEL FLAT

INCLUDE io.h

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

.STACK 4096

.DATA
prompt1			BYTE		"Enter three numbers: ",0
number			BYTE		11 DUP(?)
result			BYTE		0dh,0ah,"Maximum is"
answer			DWORD		?
				BYTE		0dh,0ah,0
				
.CODE
Max3			PROC		NEAR32
				push		ebp
				mov			ebp,esp
				sub			esp,4
				pushad
				pushfd
				
				mov			ebx,[ebp+8]
				mov			ecx,[ebp+12]
				mov			edx,[ebp+16]
				cmp			ebx,ecx
				jl			level2
				cmp			ebx,edx
				jl			edxIS
				mov			[ebp-4],ebx
				jmp			_end
level2:			cmp			ecx,edx
				jg			ecxIS
				cmp			edx,ebx
				jg			edxIS
				mov			[ebp-4],ebx
				jmp			_end

ecxIs:			mov			[ebp-4],ecx
				jmp			_end
edxIs:			mov			[ebp-4],edx
				jmp			_end

_end:			popfd
				popad
				pop			eax
				pop			ebp
				ret			12
Max3			ENDP

_start:
				output		prompt1
				input		number,11
				atod		number
				push		eax
				input		number,11
				atod		number
				push		eax
				input		number,11
				atod		number
				push		eax
				call		Max3
				dtoa		answer,eax
				output		result
				INVOKE		ExitProcess,0

PUBLIC _start
END