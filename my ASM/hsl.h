;Hooman Behnejad's standard Library
;-------------------------------------------------------------------
.NOLIST
.586
EXTRN			isPrimeProc	:	PROC,
				bubbleProc	:	PROC,
				facProc		:	PROC,
				selectionProc: 	PROC,
				fibProc		:	PROC,
				divProc		:	PROC,
				matrixProc	:	PROC
				
;------------------------------------------------------------------
division		MACRO	target, first, second, long

				IFB		<target>
				.ERR	<missing operand(s) in division>
				EXITM
				ENDIF

				IFB		<first>
				.ERR	<missing operand(s) in division>
				EXITM
				ENDIF

				IFB		<second>
				.ERR	<missing operand(s) in division>
				EXITM
				ENDIF

				IFB		<long>
				.ERR	<missing operand(s) in division>
				EXITM
				ENDIF
				
				push	10
				push	long
				push	offset target
				push	first
				push	second
				call	divProc

				ENDM
;------------------------------------------------------------------
mulMatrix		MACRO	first, second, destination, count
				
				IFB		<first>
				.ERR	<missing operand(s) in mulMatrix>
				EXITM
				ENDIF

				IFB		<source>
				.ERR	<missing operand(s) in mulMatrix>
				EXITM
				ENDIF
				
				IFB		<source>
				.ERR	<missing operand(s) in mulMatrix>
				EXITM
				ENDIF

				IFB		<count>
				.ERR	<missing operand(s) in mulMatrix>
				EXITM
				ENDIF
				
				push	count
				push	destination
				push	second
				push	first
				call	matrixProc

				ENDM
;------------------------------------------------------------------
fibonachi		MACRO	 source; becareful this proc changing ecx
				
				LOCAL	L1
				LOCAL	L2
				
				IFB		<source>
				.ERR	<missing operand in fibinachi>
				EXITM
				ENDIF

				cmp		source, 2
				jbe		L1

				dec		source
				push	source
				call	fibProc
				mov		edx, eax
				dec		source
				push	source
				call	fibProc
				add		edx, eax
				mov		source, edx
				jmp		L2
	L1:
				mov		source, 1
	L2:
				ENDM
;------------------------------------------------------------------
selection		MACRO	source, count

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
isPrime			MACRO	source	
				
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
AddToList		MACRO	source, desIndex, tempstr

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