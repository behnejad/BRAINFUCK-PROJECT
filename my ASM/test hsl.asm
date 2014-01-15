.686
.MODEL		FLAT
.STACK		4096
INCLUDE		io.h
INCLUDE		hsl.h
cr			EQU			0dh
lf			EQU			0ah
.DATA
string		BYTE		11 DUP(?), 0dh, 0ah, 0
n			DWORD		10
array		DWORD		255,512,70,6633,66,4,999,2,1,5
fib			DWORD		5
input1		BYTE		60 DUP('#'), cr, lf, 0
q			DWORD		17
w			DWORD		19
long		DWORD		60
A			BYTE		16 DUP(3)
B			BYTE		16 DUP(2)
D			BYTE		16 DUP(?)
count		DWORD		4
source		BYTE		"-78.375", 0
result		REAL4		?
source2     REAL4		145.8798
result2     BYTE		12 DUP (?), 0dh, 0ah, 0

.CODE
_main1		PROC
			nop
			ftoa		source2, offset result2
			output		result2
			nop
			atof		offset source, result  
			nop
			mulMatrix	offset A, offset B, offset D, count
			nop
			division	input1, q, w, long
			output		input1
			nop
			push		n
			fibonachi	n
			dtoa		string, n
			output		string
			pop			n
			nop				
			selection	offset array, n
			bubble		offset array, n
			nop 
			mov		eax, offset array
			mov		ecx, 10
		L4:
			dtoa	string, DWORD PTR[eax+ecx*4]
			output	string
			loop	L4

			xor		eax, eax
			ret
_main1		ENDP
END