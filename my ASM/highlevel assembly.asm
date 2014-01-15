.686
.MODEL		FLAT
.STAck		4096
INCLUDE		io.h
;INCLUDE		hsl.h
.DATA
INFO		STRUCT	
	salam	BYTE	?
	pro		BYTE	11 DUP(?)
	num		REAL10	56465.32646
INFO		ENDS
prompt		BYTE	"salam",0dh, 0ah, 0
prompt2		BYTE	"pashmak", 0dh, 0ah, 0
ste			EQU		size prompt
number		BYTE	11 DUP(?), 0dh, 0ah, 0
.CODE
main2		PROC
			mov		eax, 50
			mov		ebx, 59

			.if		eax >= ebx
				output	prompt
			.elseif	eax < 0
				.if ebx  != 8
				dtoa	number, ste
				output	number
				.endif
			.else
				output	prompt2
				.if		ebx != 1
					mov		eax, 5
					;factorial	eax
					dtoa		number, eax
					output		number
				.endif
			.endif

			.REPEAT 
				inc		ecx 
			.UNTIL ecx == 0

			.while	ecx > 5
				dec	ecx
			.ENDW

			xor		eax, eax
			ret
main2		ENDP
END