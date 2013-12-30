; in macro if you use label you must declear as this : LOCAL [label]
;-------------------------------------------------------------------
.NOLIST
INCLUDE			io.h
EXTRN			isPrimeProc	:	PROC,
				bubbleProc	:	PROC,
				facProc		:	PROC

isPrime			MACRO	source		;this is macro to determine that the source is prime or not
									;if it is prime ebx will change to 1 and if not it will change to 2
				push	eax
				push	ecx
				push	edx
				mov		ebx, source
				call	isPrimeProc
				pop		edx
				pop		ecx
				pop		eax
				ENDM

AddToList		MACRO	source, desIndex, tempstr	;[source is DWORD],[destination is array]
				LOCAL	forloop
				LOCAL	Lexit		
				dtoa	tempstr, source
				mov		ecx, 11
				mov		eax, offset tempstr
	forloop:
				cmp		[eax+ecx], ' '
				je		Lexit
				mov		[desIndex], [eax+ecx]
				inc		desIndex
				loop	forloop
	Lexit:		mov		[desIndex], '-'
				inc		desIndex
				ENDM

bubble			MACRO	array, index
				pushad
				push	index
				push	array
				call	bubbleProc
				add		esp, 8
				popad
				ENDM

factorial		MACRO	source
				;pushfd
				;pushad
				push	source
				mov		eax, 1
				call	facProc
				mov		source, eax
				;popad
				;popfd
				
				ENDM

.NOLISTMACRO
.LIST