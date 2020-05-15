;Double To BinASCII

.386
.MODEL FLAT

INCLUDE io.h

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

EXTRN			binaryString:NEAR32

.DATA
result			BYTE		"Number is "
answer			BYTE		32 DUP(?)
				BYTE		0dh,0ah,0
				
.CODE
_start:
				mov			eax,2147483647
				push		eax
				lea			eax,answer
				push		eax
				call		binaryString
				output		result
				
				mov			eax,-2147483648
				push		eax
				lea			eax,answer
				push		eax
				call		binaryString
				output		result
				
				mov			eax,1
				push		eax
				lea			eax,answer
				push		eax
				call		binaryString
				output		result
				
				mov			eax,-1
				push		eax
				lea			eax,answer
				push		eax
				call		binaryString
				output		result
				
				mov			eax,64
				push		eax
				lea			eax,answer
				push		eax
				call		binaryString
				output		result
				
				INVOKE		ExitProcess,0
PUBLIC _start
END