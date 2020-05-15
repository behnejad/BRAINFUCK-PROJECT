;Integer To ASCII

.386
.MODEL FLAT

INCLUDE io.h

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

.STACK 4096

EXTRN 			itoaPro:NEAR32

.DATA
result			BYTE		"Number is "
answer			BYTE		4 DUP(?)
				BYTE		0dh,0ah,0

.CODE
_start:
				mov			ax,8000h
				push		ax
				lea			eax,answer
				push		eax
				mov			ax,4
				push		ax
				call		itoaPro
				output		result
				
				mov			ax,7fffh
				push		ax
				lea			eax,answer
				push		eax
				mov			ax,4
				push		ax
				call		itoaPro
				output		result
				
				mov			ax,1
				push		ax
				lea			eax,answer
				push		eax
				mov			ax,4
				push		ax
				call		itoaPro
				output		result
				
				mov			ax,-2
				push		ax
				lea			eax,answer
				push		eax
				mov			ax,4
				push		ax
				call		itoaPro
				output		result
				
				mov			ax,12
				push		ax
				lea			eax,answer
				push		eax
				mov			ax,4
				push		ax
				call		itoaPro
				output		result
				
				mov			ax,-13
				push		ax
				lea			eax,answer
				push		eax
				mov			ax,4
				push		ax
				call		itoaPro
				output		result
				
				mov			ax,123
				push		ax
				lea			eax,answer
				push		eax
				mov			ax,4
				push		ax
				call		itoaPro
				output		result
				
				mov			ax,-321
				push		ax
				lea			eax,answer
				push		eax
				mov			ax,4
				push		ax
				call		itoaPro
				output		result
				
				mov			ax,1234
				push		ax
				lea			eax,answer
				push		eax
				mov			ax,4
				push		ax
				call		itoaPro
				output		result
				
				mov			ax,-4321
				push		ax
				lea			eax,answer
				push		eax
				mov			ax,4
				push		ax
				call		itoaPro
				output		result
				
				INVOKE		ExitProcess,0
PUBLIC _start
END