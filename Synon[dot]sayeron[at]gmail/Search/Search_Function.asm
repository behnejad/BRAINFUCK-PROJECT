;Search Function

.386
.MODEL FLAT

PUBLIC searchFun

.DATA
temp			DWORD		?

.CODE
searchFun		PROC		NEAR32
				push		ebp
				mov			ebp,esp
				pushfd
				pushad
				
				mov			ecx,[ebp+8]
				mov			ebx,[ebp+12]
				mov			edx,[ebp+16]
				mov			eax,0
				
until:			inc			eax
				cmp			eax,ecx
				jg			notFound
				cmp			DWORD PTR [ebx],edx
				je			found
				add			ebx,4
				jmp			until

notFound:		popad
				popfd
				pop			ebp
				mov			eax,0
				ret			12

found:			mov			temp,eax
				popad
				popfd
				pop			ebp
				mov			eax,temp
				ret			12
searchFun		ENDP
END