;Double To BinASCII Proc

.386
.MODEL FLAT

PUBLIC binaryString

.CODE
binaryString		PROC		NEAR32
					push		ebp
					mov			ebp,esp
					push		eax
					push		ebx
					push		ecx
					push		edx
					pushf
					
					mov			eax,[ebp+12]
					mov			edi,[ebp+8]
					
					mov			edx,eax
					mov			al,' '
					mov			ecx,31
					rep			stosb
					mov			eax,edx
					mov			ebx,2
					mov			ecx,32
while_loop:			mov			edx,0
					div			ebx
					add			dl,30h
					mov			[edi],dl
					dec			edi
					loop		while_loop
					
					popf
					pop			edx
					pop			ecx
					pop			ebx
					pop			eax
					pop			ebp
					ret			8
binaryString		ENDP
END