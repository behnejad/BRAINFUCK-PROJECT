;Hexadecimal To Double Proc

.386
.MODEL FLAT

PUBLIC	hexToInt


.CODE
hexToInt				PROC				NEAR32
						push				ebp
						mov					ebp,esp
						pushf
						push				ebx
						push				ecx
						push				edx
						
						mov					esi,[ebp+8]
whileBlank:				cmp					BYTE PTR [esi],' '
						jne					endWhileBlank
						inc					esi
						jmp					whileBlank
endWhileBlank:
						mov					eax,0
						mov					cx,0
						mov					ebx,16
						
whileLoop:				cmp					BYTE PTR [esi],'0'
						jb					endWhileLoop
						cmp					BYTE PTR [esi],'9'
						ja					moreThan9
						mul					ebx
						jo					overFlow
						mov					dl,BYTE PTR [esi]
						and					edx,0Fh
						add					eax,edx
						jc					overFlow
						inc					cx
						inc					esi
						jmp					whileLoop
moreThan9:				cmp					BYTE PTR [esi],'A'
						jb					endWhileLoop
						cmp					BYTE PTR [esi],'F'
						ja					finalLevel
						mul					ebx
						jo					overFlow
						mov					edx,0
						mov					dl,BYTE PTR [esi]
						sub					dl,37h
						add					eax,edx
						jc					overFlow
						inc					cx
						inc					esi
						jmp					whileLoop
finalLevel:				cmp					BYTE PTR [esi],'a'
						jb					endWhileLoop
						cmp					BYTE PTR [esi],'f'
						ja					endWhileLoop
						mul					ebx
						jo					overFlow
						mov					edx,0
						mov					dl,BYTE PTR [esi]
						sub					dl,57h
						add					eax,edx
						jc					overFlow
						inc					cx
						inc					esi
						jmp					whileLoop
endWhileLoop:
						cmp					cx,0
						je					overFlow
						
HTDExit:				pop					edx
						pop					ecx
						pop					ebx
						popf
						pop					ebp
						ret					4

overFlow:				mov					eax,0
						pop					edx
						pop					ecx
						pop					ebx
						popf
						pop					ebp
						ret					4
hexToInt				ENDP
END