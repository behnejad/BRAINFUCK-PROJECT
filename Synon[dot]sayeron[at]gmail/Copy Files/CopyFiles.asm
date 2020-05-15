;Copy Files

.386
.MODEL FLAT
.STACK 4096

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD
GetStdHandle PROTO NEAR32 stdcall, nStdHandle:DWORD
ReadFile PROTO NEAR32 stdcall, handleNO:DWORD, buffer:NEAR32, numberOfCharsToRead:DWORD, numberOfCharsRead:NEAR32, lpOverlapped:NEAR32
WriteFile PROTO NEAR32 stdcall, handleNO:DWORD, buffer:NEAR32, numberOfCharsToWrite:DWORD, numberOfCharsWritten:NEAR32, lpOverlapped:NEAR32
CreateFileA PROTO NEAR32 stdcall, filename:NEAR32, access:DWORD, shareMode:DWORD, securityMode:DWORD, craetion:DWORD, attributes:DWORD, copyHandle:DWORD
CloseHandle PROTO NEAR32 stdcall, handleNo:DWORD

.DATA
prompt1					BYTE				"Enter source file name: "
prompt1Size				DWORD				24
prompt2					BYTE				"Enter destination file name: "
prompt2Size				DWORD				29
sourceFileName			BYTE				60 DUP(?)
destinationFileName		BYTE				60 DUP(?)
outputHandle			DWORD				?
inputHandle				DWORD				?
sourceFileHandle		DWORD				?
destinationFileHandle	DWORD				?
write					DWORD				?
read					DWORD				?
buffer					BYTE				128 DUP(?)
error1					BYTE				"Invalid file name!"
error2					BYTE				"The file is already exist!",0dh,0ah
prompt3					BYTE				"Do you want to over write it (y/n) ?"
tempAnswer				BYTE				3 DUP(?)


.CODE
_start:
						INVOKE				GetStdHandle,-11
						mov					outputHandle,eax
						INVOKE				GetStdHandle,-10
						mov					inputHandle,eax
						INVOKE				WriteFile,outputHandle,NEAR32 PTR prompt1,prompt1Size,NEAR32 PTR write,0
						INVOKE				ReadFile,inputHandle,NEAR32 PTR sourceFileName,60,NEAR32 PTR read,0
						mov					ecx,read
						mov					BYTE PTR sourceFileName[ecx-2],0
						INVOKE				CreateFileA,NEAR32 PTR sourceFileName,80000000h,0,0,3,0,0
						mov					sourceFileHandle,eax
						cmp					sourceFileHandle,-1
						je					endIfInvalidSF
						INVOKE				WriteFile,outputHandle,NEAR32 PTR prompt2,prompt2Size,NEAR32 PTR write,0
						INVOKE				ReadFile,inputHandle,NEAR32 PTR destinationFileName,60,NEAR32 PTR read,0
						mov					ecx,read
						mov					BYTE PTR destinationFileName[ecx-2],0
						INVOKE				CreateFileA,NEAR32 PTR destinationFileName,40000000h,0,0,1,0,0
						mov					destinationFileHandle,eax
						cmp					destinationFileHandle,-1
						je					endIfInvalidDF
continue:				INVOKE				ReadFile,sourceFileHandle,NEAR32 PTR buffer,128,NEAR32 PTR read,0
						INVOKE				WriteFile,destinationFileHandle,NEAR32 PTR buffer,read,NEAR32  PTR write,0
						cmp					read,128
						jl					endProc
						jmp					continue						
endIfInvalidSF:			INVOKE				WriteFile,outputHandle,NEAR32 PTR error1,18,NEAR32 PTR write,0
						jmp					endProc
endIfInvalidDF:			INVOKE				WriteFile,outputHandle,NEAR32 PTR error2,28,NEAR32 PTR write,0
						INVOKE				WriteFile,outputHandle,NEAR32 PTR prompt3,36,NEAR32 PTR write,0
						INVOKE				ReadFile,inputHandle,NEAR32 PTR tempAnswer,3,NEAR32 PTR read,0
						cmp					BYTE PTR tempAnswer,'n'
						je					endProc
						cmp					BYTE PTR tempAnswer,'N'
						je					endProc
						INVOKE				CreateFileA,NEAR32 PTR destinationFileName,40000000h,0,0,3,0,0
						mov					destinationFileHandle,eax
						jmp					continue				
endProc:				cmp					sourceFileHandle,-1
						je					closeDF
						INVOKE				CloseHandle,sourceFileHandle
closeDF:				cmp					destinationFileHandle,-1
						je					endProgram
						INVOKE				CloseHandle,destinationFileHandle
endProgram:				INVOKE				ExitProcess,0
PUBLIC _start
End