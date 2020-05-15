;Dump Program

.386
.MODEL FLAT

.STACK 4096

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD
GetStdHandle PROTO NEAR32 stdcall, nStdHandle:DWORD
ReadFile PROTO NEAR32 stdcall, hfile:DWORD, lpBuffer:NEAR32, numberOfCharsToRead:DWORD, numberOfCharsRead:NEAR32, lpOverlapped:NEAR32
WriteFile PROTO NEAR32 stdcall, hfile:DWORD, lpBuffer:NEAR32, numberOfCharsToWrite:DWORD, numberOfCharsWritten:NEAR32, lpOverlapped:NEAR32
CreateFileA PROTO NEAR32 stdcall, lpFileName:NEAR32, access:DWORD, shareMode:DWORD, securityMode:DWORD, creation:DWORD, attributes:DWORD, copyHandle:DWORD
CloseHandle PROTO NEAR32 stdcall, fHandle:DWORD

.DATA
outputHandle				DWORD					?
inputHandle					DWORD					?
fileHandle					DWORD					?
read						DWORD					?
write						DWORD					?
fileName					BYTE					60 DUP(?)
buffer						BYTE					16 DUP(?)
prompt1						BYTE					"Enter file name: "
prompt1Size					DWORD					17
prompt2						BYTE					"m[ore] or q[uit]? "
prompt2Size					DWORD					18
temp						BYTE					18 DUP(?)
errorMessage				BYTE					"Invalid file name.",0dh,0ah


.CODE
_start:
							INVOKE					GetStdHandle,-11
							mov						outputHandle,eax
							INVOKE					GetStdHandle,-10
							mov						inputHandle,eax
							INVOKE					WriteFile,outputHandle,NEAR32 PTR prompt1,prompt1Size,NEAR32 PTR write,0
							INVOKE					ReadFile,inputHandle,NEAR32 PTR fileName,60,NEAR32 PTR read,0
							mov						ecx,read
							mov						BYTE PTR filename[ecx-2],0
							INVOKE					CreateFileA,NEAR32 PTR fileName,80000000h,0,0,3,0,0
							mov						fileHandle,eax
							cmp						fileHandle,-1
							je						endProcess
							
							
forLoop:					INVOKE					ReadFile,fileHandle,NEAR32 PTR buffer,16,NEAR32 PTR read,0
							lea						eax,buffer
							lea						ebx,temp
							mov						ecx,read
whileLoop:					cmp						ecx,0
							je						endWhileLoop
							dec						ecx
							cmp						BYTE PTR [eax],'A'
							jl						putDot
							cmp						BYTE PTR [eax],'z'
							jg						putDot
							cmp						BYTE PTR [eax],'Z'
							jle						putIt
							cmp						BYTE PTR [eax],'a'
							jge						putIt

putDot:						mov						BYTE PTR [ebx],'.'
							inc						eax
							inc						ebx
							jmp						whileLoop
putIt:						mov						dl,BYTE PTR [eax]
							mov						BYTE PTR [ebx],dl
							inc						eax
							inc						ebx
							jmp						whileLoop						
							
endWhileLoop:				mov						BYTE PTR [ebx],0dh
							inc						ebx
							mov						BYTE PTR [ebx],0ah
							add						read,2
							INVOKE					WriteFile,outputHandle,NEAR32 PTR temp,read,NEAR32 PTR write,0
							cmp						read,18
							jl						endProgram
							jmp						forLoop
							
endProcess:					INVOKE					WriteFile,outputHandle,NEAR32 PTR errorMessage,20,NEAR32 PTR write,0
endProgram:					INVOKE					CloseHandle,fileHandle
							INVOKE					ExitProcess,0
							
PUBLIC _start
END