.586
.MODEL		FLAT
.STACK		4096
ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD
INCLUDE		io.h
.DATA
prompt		BYTE	"salam volek ye adad bezan  ", 0
isp			BYTE	"volek adadet aval bood", 0ah, 0dh, 0
isnp		BYTE	"volek adadet aval nabood", 0ah, 0dh, 0
break		BYTE	"#########################", 0dh, 0ah, 0
number		DWORD	0
numberby2	DWORD	0
tempnum		DWORD	2
string		BYTE	11 DUP(?)
			BYTE	0ah, 0dh, 0

.CODE
_main:		
			; we should at first get a number from the user and put it
			; into "number"
			output		prompt				;write the prompt
			input		string, 11			;get the bytes representing 
			;the number
			atod		string				;convert the bytes into their 
			;numeric form
			mov			number, eax			;copy the result of the above 
			;into the "number"

			; now we should calculate half of it and put it into "numberby2"
			mov			edx, 0				;move 0 into the edx so that
			; we can ready the program for a division
			div			tempnum				;divide the contents of edx 
			;(which is the number) by tempnum (which is 2)
			mov			numberby2, eax		;copy the result of the division
			; into "numberby2"

			; now check if the number is 1 itself. if so, go directly and 
			;claim it as not a prime
			mov			eax, number			;copy the contents of the 
			;number into eax
			cmp			eax, 1				;if the number given was 2
			je			IsNotPrime			;it was a prime. go and 
			;directly write it

			; now check if the number is 2 itself. if so, go directly 
			;and claim it as a prime
			mov			eax, number			;copy the contents of the 
			;number into eax
			cmp			eax, 2				;if the number given was 2
			je			IsPrime				;it was a prime. go and 
			;directly write it

			; now check if the number is 3 itself. if so, go directly 
			;and claim it as a prime
			mov			eax, number			;copy the contents of the 
			;number into eax
			cmp			eax, 3				;if the number given was 2
			je			IsPrime				;it was a prime. go and 
			;directly write it

			; divide the number by 2 (tempnum) and get the reminder. 
			;declare the number "not a prime" if the reminder was 0
			mov			eax, number			;copy the contents of 
			;"number" into eax
			mov			edx, 0				;put 0 in edx to prepare
			; it for the division
			div			tempnum				;divide the contents of
			; eax (which is number) by "tempnum"
			cmp			edx, 0				;compare the remider to 0. 
			;if it was equal, the number is not a prime
			je			IsNotPrime			;it was not a prime, so 
			;declare is so

			; now add 1 to the "tempnum" to make it 3. "tempnum" is
			; the number which we are diving the number by, each turn
			mov			eax, tempnum		;move the "tempnum" into eax
			add			eax, 1				;add 1 to it, so that it is 3 now
			mov			tempnum, eax		;move the result into tempnum

			; ok. we now calculate the reminder of the division (number)/
			;(every odd number less than half of it)
			; if the reminder was ever 0, it means that "number" is not a
			; prime. else, it means that it is a prime
LoopStart:
			; divide the number by tempnum and get the reminder. declare 
			;the number "not a prime" if the reminder was 0
			mov			eax, number			;copy the contents of "number"
			; into eax
			mov			edx, 0				;put 0 in edx to prepare it 
			;for the division
			div			tempnum				;divide the contents of eax 
			;(which is number) by "tempnum"
			cmp			edx, 0				;compare the remider to 0.
			; if it was equal, the number is not a prime
			je			IsNotPrime			;it was not a prime, so
			; declare is so
			
			; now add 2 more to tempnum so that we can
			mov			eax, tempnum
			add			eax, 2
			mov			tempnum, eax
			cmp			eax, numberby2
			jae			IsPrime
			jmp			LoopStart

IsNotPrime:
			output		isnp
			jmp			EndOfProgram
IsPrime:
			output		isp
			jmp			EndOfProgram

EndOfProgram:
			output		break
			jmp			_main
			INVOKE		ExitProcess, 0

public	_main
END