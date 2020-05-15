;Name & Family III

.386
.MODEL FLAT

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

GetStdHandle PROTO NEAR32 stdcall, nStdHandle:DWORD

ReadFile PROTO NEAR32 stdcall, hfile:DWORD, lpBuffer:NEAR32, numberOfCharsToRead:DWORD, numberOfCharsRead:NEAR32, lpOverlapped:NEAR32

WriteFile PROTO NEAR32 stdcall, hfile:DWORD, lpBuffer:NEAR32, numberOfCharsToWrite:DWORD, numberOfCharsWritten:NEAR32, lpOverlapped:NEAR32

.STACK 4096

.DATA
outputHandle				DWORD				?
inputHandle					DWORD				?
read						DWORD				?
write						DWORD				?
prompt						BYTE				"Enter your family and your name (family, name) :  "
answer						BYTE				80 DUP(?),0dh,0ah,0
result						BYTE				80 DUP(?)

							
							
.CODE
_start:
							INVOKE				GetStdHandle,-11
							mov					outputHandle,eax
							
							INVOKE				WriteFile,outputHandle,NEAR32 PTR prompt,50,NEAR32 PTR write,0
							
							INVOKE				GetStdHandle,-10
							mov					inputHandle,eax
							
							INVOKE				ReadFile,inputHandle,NEAR32 PTR result,80,NEAR32 PTR read,0
							
							lea					ebx,result
							lea					ecx,answer
whileLoop:					cmp					BYTE PTR [ebx],','
							je					forLoop1
							inc					ebx
							jmp					whileLoop					
forLoop1:					inc					ebx
							inc					ebx
forLoop:					cmp					BYTE PTR [ebx],0dh
							je					endFor
							mov					al,BYTE PTR [ebx]
							mov					BYTE PTR [ecx],al
							inc					ebx
							inc					ecx
							jmp					forLoop
endFor:						mov					BYTE PTR [ecx],' '
							inc					ecx
							lea					ebx,result
endForLoop:					cmp					BYTE PTR [ebx],','
							je					endProc
							mov					al, BYTE PTR [ebx]
							mov					BYTE PTR [ecx],al
							inc					ebx
							inc					ecx
							jmp					endForLoop
							
							mov					BYTE PTR [ecx],0dh
							inc					ecx
							mov					BYTE PTR [ecx],0ah
							inc					ecx
endProc:					INVOKE				WriteFile,outputHandle,NEAR32 PTR answer,80,NEAR32 PTR write,0
							INVOKE				ExitProcess,0
PUBLIC _start
END