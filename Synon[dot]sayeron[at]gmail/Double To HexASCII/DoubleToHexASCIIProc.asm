;Double To HexASCII Proc

.386
.MODEL FLAT

PUBLIC hexStringProc

.CODE
hexStringProc		PROC		NEAR32
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
					mov			ecx,7
					rep			stosb
					mov			eax,edx
					mov			ecx,8
					mov			ebx,16
while_loop:			mov			edx,0
					div			ebx
					cmp			dx,10
					jl			below_ten
					add			dx,37h
					mov			[edi],dl
					dec			edi
					loop		while_loop
					jmp			final_level
below_ten:			add			dx,30h
					mov			[edi],dl
					dec			edi
					loop		while_loop
final_level:		popf
					pop			edx
					pop			ecx
					pop			ebx
					pop			eax
					pop			ebp
					ret			8
hexStringProc		ENDP
END