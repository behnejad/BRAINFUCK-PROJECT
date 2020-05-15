;factorial procedure

.386
.MODEL FLAT
INCLUDE io.h


.CODE
factorial		PROC		NEAR32
			.data 
				pnp  BYTE "11111", 	0
				psp  BYTE "222222",0
				pmp  BYTE "33333",0		
				push		ebp
				mov			ebp,esp
				mov			ebx,[ebp+8]
				
				cmp			ebx,1
				jle			endProc
				dec			ebx
				push		ebx
				call		factorial
				output     pnp
				inc			ebx
				imul		eax,ebx
				
				mov			esp,ebp
				pop			ebp
				ret
				
endProc:

				mov			eax,1
				mov			esp,ebp
				output     pmp
				pop			ebp
				output     psp
				ret
				
factorial		ENDP
public			factorial
end
