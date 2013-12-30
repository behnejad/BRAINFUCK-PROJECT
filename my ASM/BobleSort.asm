.586
.MODEL FLAT
.STACK 4096

include io.h

.DATA
prompt1			BYTE		"Enter for element of array" ,0
inString		BYTE		11 DUP(?)
array			DWORD		10 DUP(?)

.CODE
;in below macro op1 != ecx
movm		MACRO		op1 , op2
			push		ecx
			mov			ecx , op2
			mov			op1  , ecx
			pop			ecx
ENDM

xchgm		MACRO		op1 , op2
			push		op1
			push		op2
			pop			op1
			pop			op2
ENDM

addm		MACRO		op1 , op2
			push		ecx
			mov			ecx , op2
			add			op1 , ecx
			pop			ecx
ENDM


subm		MACRO		op1 , op2
			push		ecx
			mov			ecx , op2
			sub			op1 , ecx
			pop			ecx
ENDM

cmpm		MACRO		op1 , op2
			push		ecx
			mov			ecx , op2
			cmp			op1 , ecx
			pop			ecx
ENDM

bSort			PROC
				push		ebp
				mov			ebp , esp
				sub			esp , 8				
				push		ecx
				push		ebx
				push		edx
				
				movm		[ebp - 4] , [ebp + 8] ;[ebp - 4] is array
				movm		[ebp - 8] ,  [ebp + 12] ; [ebp - 8] is size
				
				
loop1:	
				cmpm		[ebp - 8] , 0
				je			endLoop1
				subm		[ebp - 8] , 1
								
				mov			ecx , [ebp + 12]
				sub			ecx , 1
				mov			ebx , [ebp + 8]
				mov			edx , [ebp - 4]
loop2:			
				cmpm		[edx] , [edx + 4]
				jng			notChange
				xchgm		[edx] , [edx + 4]
				add			edx , 4
notChange:
				loop		loop2
				
				jp			loop1
				
endLoop1:				
				pop			edx
				pop			ebx
				pop			ecx
				mov 		esp , ebp
				pop			ebp
				ret			8
				
bSort			ENDP

_main			PROC
				mov		ecx , 10
				lea		ebx , array
				
loopForGetData:
				output	prompt1
				input	inString ,11
				atod	inString
				mov		[ebx] , eax
				add		ebx , 4
				
				loop	loopForGetData
;------------------------start sorting-----------------------

				pushd	10
				lea		ebx , array
				push	ebx
				call	bSort
				
				
;_-----------------------array is sorted---------------------
				
				mov		ecx , 10
				lea		ebx , array
				
printSorted:		
				dtoa	inString , [ebx]
				output	inString
				
				add		ebx , 4
				loop	printSorted

				mov		eax , 0
				ret
_main			ENDP
END