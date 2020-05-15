;Integer To ASCII Proc

.386
.MODEL FLAT

PUBLIC itoaPro

.DATA
Plength			WORD		?
realLength		WORD		?

.CODE
itoaPro			PROC		NEAR32
				push		ebp
				mov			ebp,esp
				push		eax
				push		ebx
				push		ecx
				push		edx
				pushfd
				
				mov			ax,[ebp+14]
				mov			edi,[ebp+10]
				mov			bx,[ebp+8]
				mov			Plength,bx
				
				cmp			ax,8000h
				jne			end_special
				cmp			Plength,6
				jl			fill
				mov			BYTE PTR [edi],'-'
				mov			BYTE PTR [edi+1],'3'
				mov			BYTE PTR [edi+2],'2'
				mov			BYTE PTR [edi+3],'7'
				mov			BYTE PTR [edi+4],'6'
				mov			BYTE PTR [edi+5],'8'
				jmp			final_level
end_special:	
				mov			dx,ax
				mov			al,' '
				mov			ecx,4
				cld
				rep			stosb
				mov			ax,dx
				mov			cl,' '
				cmp			ax,0
				jge			end_neg
				mov			cl,'-'
				neg			ax
end_neg:
				mov			bx,10
				mov			realLength,1
while_loop:
				inc			realLength
				mov			dx,0
				div			bx
				add			dl,30h
				mov			[edi],dl
				dec			edi
				cmp			ax,0
				jnz			while_loop
				mov			[edi],cl
				
				mov			ax,Plength
				mov			bx,realLength
				cmp			bx,ax
				jle			final_level
fill:			
				mov			edi,[ebp+10]
				mov			ecx,0
				mov			cx,Plength
				mov			al,'#'
				rep			stosb
				mov			BYTE PTR [edi],0dh
				mov			BYTE PTR [edi+1],0ah
final_level:
				popfd
				pop			edx
				pop			ecx
				pop			ebx
				pop			eax
				pop			ebp
				ret
itoaPro			ENDP
END