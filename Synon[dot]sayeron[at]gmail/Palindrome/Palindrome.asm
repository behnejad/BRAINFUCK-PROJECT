;Palindrome

.386
.MODEL FLAT

.STACK 4096

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD
GetStdHandle PROTO NEAR32 stdcall, nStdHandle:DWORD
WriteFile PROTO NEAR32 stdcall, hfile:DWORD, lpBuffer:NEAR32, numberOfCharsToWrite:DWORD, numberOfCharsWritten:NEAR32, lpOverlapped:NEAR32
ReadFile PROTO NEAR32  stdcall ,hfile:DWORD, lpBuffer:NEAR32, numberOfCharsToRead:DWORD, numberOfCharsRead:NEAR32, lpOverLapped:NEAR32

.DATA
inputHandle					DWORD					?
outputHandle				DWORD					?
read						DWORD					?
write						DWORD					?
prompt						BYTE					"Enter a string: "
promptLen					DWORD					16
inputString					BYTE					80 DUP(?)
result1						BYTE					"The string is Palindrome!",0dh,0ah
result2						BYTE					"The string is not Palindrome!",0dh,0ah

.CODE
_start:
							INVOKE					GetStdHandle,-11
							mov						outputHandle,eax
							
							INVOKE					WriteFile,outputHandle,NEAR32 PTR prompt,promptlen,NEAR32 PTR write,0
							
							INVOKE					GetStdHandle,-10
							mov						inputHandle,eax
							
							INVOKE					ReadFile,inputHandle,NEAR32 PTR inPutString,80,NEAR32 PTR read,0
							
							mov						ecx,read
							sub						ecx,3
							lea						esi,inPutString
							lea						edi,inPutString
							add						edi,ecx
							mov						ecx,read
							sub						ecx,2
							shr						ecx,1
							
forLoop:					mov						al,BYTE PTR [esi]
							cmp						al,BYTE PTR [edi]
							jne						endForLoop
							inc						esi
							dec						edi
							loop					forLoop
							jmp						isPalindrome
							
endForLoop:					INVOKE					WriteFile,outputHandle,NEAR32 PTR result2,80,NEAR32 PTR write,0
							INVOKE					ExitProcess,0
							
isPalindrome:				INVOKE					WriteFile,outputHandle,NEAR32 PTR result1,27,NEAR32 PTR write,0
							INVOKE					ExitProcess,0

PUBLIC _start
END