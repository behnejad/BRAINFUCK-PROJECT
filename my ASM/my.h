; in macro if you use label you must declear as this : LOCAL [label]
;-------------------------------------------------------------------
.NOLIST
INCLUDE			io.h
EXTRN			isPrimeProc	:	PROC,
				bubbleProc	:	PROC,
				facProc		:	PROC,
				selectionProc:  PROC	

;------------------------------------------------------------------
selection		MACRO	source, count ;this will give count * 4 [10 number of element equal to 40 mjst push]
									  ;and source must be address or offset

				IFB		<source>
				.ERR	<missing operand(s) in selection>
				EXITM
				ENDIF

				IFB		<count>
				.ERR	<missing operand(s) in selection>
				EXITM
				ENDIF

				push	count
				push	source
				call	selectionProc

				ENDM
;------------------------------------------------------------------
isPrime			MACRO	source		;this is macro to determine that the source is prime or not
									;if it is prime ebx will change to 1 and if not it will change to 2
				
				IFB		<source>
				.ERR	<missing operand(s) in isPrime>
				EXITM
				ENDIF

				push	eax
				push	ecx
				push	edx
				mov		ebx, source
				call	isPrimeProc
				pop		edx
				pop		ecx
				pop		eax

				ENDM
;------------------------------------------------------------------
AddToList		MACRO	source, desIndex, tempstr	;[source is DWORD],[destination is array]

				IFB		<source>
				.ERR	<missing operand(s) in AddToList>
				EXITM
				ENDIF

				IFB		<destIndex>
				.ERR	<missing operand(s) in AddToList>
				EXITM
				ENDIF

				IFB		<tempstr>
				.ERR	<missing operand(s) in AddToList>
				EXITM
				ENDIF
				
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
;------------------------------------------------------------------
bubble			MACRO	array, index

				IFB		<array>
				.ERR	<missing operand(s) in bubble>
				EXITM
				ENDIF

				IFB		<index>
				.ERR	<missing operand(s) in bubble>
				EXITM
				ENDIF

				pushad
				push	index
				push	array
				call	bubbleProc
				add		esp, 8
				popad

				ENDM
;------------------------------------------------------------------
factorial		MACRO	source

				IFB		<source>
				.ERR	<missing operand(s) in factorial>
				EXITM
				ENDIF

				push	source
				mov		eax, 1
				call	facProc
				mov		source, eax

				ENDM
;------------------------------------------------------------------
.NOLISTMACRO
.LIST