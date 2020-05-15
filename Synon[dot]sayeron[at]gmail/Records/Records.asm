;Records

.386
.MODEL FLAT
.STACK 4096

INCLUDE io.h

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD
GetStdHandle PROTO NEAR32 stdcall, handleNO:DWORD
ReadFile PROTO NEAR32 stdcall, handleNumber:DWORD, buffer:NEAR32, numberOfCharsToRead:DWORD, numberOfCharsRead:NEAR32, lpOverlapped:DWORD
WriteFile PROTO NEAR32 stdcall, handleNumber:DWORD, buffer:NEAR32, numberOfCharsTowrite:DWORD, numberOfCharsWritten:NEAR32, lpOverlapped:DWORD
CreateFileA PROTO NEAR32 stdcall, fileName:NEAR32, access:DWORD, shareMode:DWORD, securityMode:DWORD, creation:DWORD, attributes:DWORD, copyHandle:DWORD
CloseHandle PROTO NEAR32 stdcall, handleNo:DWORD

.DATA
write							DWORD					?
read							DWORD					?
errorMessage					BYTE					"The file 'Records.dat' does not exist!"
numberOfRecords					DWORD					0
sumOfRecords					DWORD					0
nameOfMaxRecord					BYTE					20 DUP(0)
maxRecord						DWORD					0
outputHandle					DWORD					?
inputHandle						DWORD					?
fileHandle						DWORD					?
nameBuffer						BYTE					20 DUP(?)
recordBuffer					BYTE					7 DUP(?)
buffer							BYTE					27 DUP(?)
resultNumbers					BYTE					"Number of records: "
resultSum						BYTE					"Sum of records: "
resultMax						BYTE					"Maximum is for: "
fileName						BYTE					"Records.dat"
temp							BYTE					20 DUP(?)


.CODE
_start:
								INVOKE					GetStdHandle,-11
								mov						outputHandle,eax
								INVOKE					GetStdHandle,-10
								mov						inputHandle,eax
								INVOKE					CreateFileA,NEAR32 PTR fileName,80000000h,0,0,3,0,0
								mov						fileHandle,eax
								cmp						fileHandle,-1
								je						endError
								
								
forLoop:						INVOKE					ReadFile,fileHandle,NEAR32 PTR buffer,27,NEAR32 PTR read,0
								mov						ecx,read
								mov						BYTE PTR Buffer[ecx-2],0
								cmp						read,25
								jl						endProgram
								
								lea						esi,buffer
								lea						edi,nameBuffer								
								mov						ecx,20
for1:							mov						al,BYTE PTR [esi]
								mov						BYTE PTR [edi],al
								inc						esi
								inc						edi
								loop					for1
								
								lea						edi,recordBuffer
								lea						esi,buffer
								add						esi,20
								mov						ecx,5							
for2:							mov						al,BYTE PTR [esi]
								mov						BYTE PTR [edi],al
								inc						esi
								inc						edi
								loop					for2
								
								mov						BYTE PTR recordBuffer[5],0
								atod					recordBuffer
								cmp						eax,maxRecord
								jle						continue
								mov						maxRecord,eax
								lea						esi,nameBuffer
								lea						edi,nameOfMAxRecord
								mov						ecx,20
for3:							mov						dl,BYTE PTR [esi]
								mov						BYTE PTR [edi],dl
								inc						esi
								inc						edi
								loop					for3
								
continue:						inc						numberOfRecords
								add						sumOfRecords,eax
								mov						ecx,read
								mov						BYTE PTR buffer[ecx-2],0dh
								mov						BYTE PTR buffer[ecx-1],0ah
								INVOKE					WriteFile,outputHandle,NEAR32 PTR buffer,27,NEAR32 PTR write,0
								jmp						forLoop
								jmp						endProgram
								
								
endError:						INVOKE					WriteFile,outputHandle,NEAR32 PTR errorMessage,38,NEAR32 PTR write,0
								jmp						endProc

endProgram:						INVOKE					WriteFile,outputHandle,NEAR32 PTR resultNumbers,19,NEAR32 PTR write,0
								dtoa					temp,numberOfRecords
								mov						BYTE PTR temp[18],0dh
								mov						BYTE PTR temp[19],0ah
								INVOKE					WriteFile,outputHandle,NEAR32 PTR temp,20,NEAR32 PTR write,0
								
								INVOKE					WriteFile,outputHandle,NEAR32 PTR resultSum,16,NEAR32 PTR write,0
								dtoa					temp,sumOfRecords
								mov						BYTE PTR temp[18],0dh
								mov						BYTE PTR temp[19],0ah
								INVOKE					WriteFile,outputHandle,NEAR32 PTR temp,20,NEAR32 PTR write,0
								
								INVOKE					WriteFile,outputHandle,NEAR32 PTR resultMax,16,NEAR32 PTR write,0
								INVOKE					WriteFile,outputHandle,NEAR32 PTR nameOfMaxRecord,20,NEAR32 PTR write,0
								INVOKE					CloseHandle,fileHandle
endProc:						INVOKE					ExitProcess,0
PUBLIC _start
End