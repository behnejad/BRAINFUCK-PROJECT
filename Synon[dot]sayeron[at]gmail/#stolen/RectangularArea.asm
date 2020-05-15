;Rectangle Area

.386
.MODEL FLAT

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

INCLUDE io.h

.STACK 4096


.DATA
resultA				BYTE			"The points are inside the rectangle!",0dh,0ah,0
resultB				BYTE			"The points are in the same side of rectangle!",0dh,0ah,0
resultC				BYTE			"The outcode is "
answer				WORD			?
					BYTE			0dh,0ah,0


.CODE
setCode				PROC			NEAR32
					push			ebp
					mov				ebp,esp
					pushfd
					
					mov				bx,[ebp+18]
					mov				cx,[ebp+16]
					mov				eax,0
					
					cmp				bx,WORD PTR [ebp+12]
					jle				label1
					or				al,00000001b
label1:				cmp				bx,WORD PTR[ebp+14]
					jge				label2
					or				al,00000010b
label2:				cmp				cx,WORD PTR[ebp+8]
					jle				label3
					or				al,00000100b
label3:				cmp				cx,WORD PTR[ebp+10]
					jge				label4
					or				al,00001000b
label4:
					popfd
					pop				ebp
					ret				12							
setCode				ENDP				
					
_start:
					mov				al,00001010b
					mov				bl,00001001b
					
					test			al,00001111b
					jnz				end1
					test			bl,00001111b
					jnz				end1
					output			resultA
end1:				
					test			al,bl
					jz				end2
					output			resultB
end2:
					pushw			-2
					pushw			-3
					pushw			-1
					pushw			2
					pushw			-2
					pushw			1
					call			setCode
					itoa			answer,ax
					output			resultC
					
					INVOKE			ExitProcess,0
PUBLIC _start
END