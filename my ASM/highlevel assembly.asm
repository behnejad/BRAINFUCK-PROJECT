.686
.MODEL		FLAT
.STAck		4096
INCLUDE		io.h
INCLUDE		my.h
.DATA
prompt		BYTE	"salam",0dh, 0ah, 0
prompt2		BYTE	"pashmak", 0dh, 0ah, 0
ste			EQU		size prompt
number		BYTE	11 DUP(?), 0dh, 0ah, 0
.CODE
main		PROC
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
					factorial	eax
					dtoa		number, eax
					output		number
				.endif
			.endif

			xor		eax, eax
			ret
main		ENDP
END