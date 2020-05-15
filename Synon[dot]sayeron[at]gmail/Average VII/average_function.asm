;Average Function

.386
.MODEL FLAT

PUBLIC averageFun

.CODE
averageFun		PROC		NEAR32
				push		ebp
				mov			ebp,esp
				sub			esp,8
				pushad
				pushfd
				
				mov			ebx,[ebp+16]
				mov			ecx,[ebp+12]
				mov			DWORD PTR [ebp-4],0
				
until:			mov			eax,[ebx]
				add			[ebp-4],eax
				add			ebx,4
				loop		until
				mov			eax,[ebp-4]
				cdq
				idiv		DWORD PTR [ebp+12]
				mov			[ebp+8],eax
				
				popfd
				popad
				mov			esp,ebp
				pop			ebp
				ret
averageFun		ENDP
END		