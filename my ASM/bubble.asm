TITLE Insertion Sort (main.asm)
INCLUDE Irvine32.inc

.data
myArray  SDWORD 12, 9, 15, 5
str1 byte "Enter the array: " ,0
str2 byte "The sorted array is: ",0

.code
main PROC
    call Clrscr
    ;call enterArray
    call InsertionSort
    exit
main ENDP


enterArray PROC
;reads the array from the console
    pushad
    mov edi, OFFSET myArray
    mov edx, OFFSET str1
    call WriteString
    call ReadInt
    mov [edi], eax
    add edi, 4
    popad
    ret
enterArray ENDP

InsertionSort PROC
    pushad

    mov ecx, SIZEOF myArray -1
    mov eax, OFFSET myArray

    outterloop:
    mov edx,myArray[eax]
    mov ebx,eax

    beginwhile:
        cmp ebx,0
        JE endwhile
        cmp myArray[ebx-4],edx
        JNG endwhile
        mov edx,myArray[ebx]
        mov myArray[ebx-4],edx
        sub edx,4
        JMP beginwhile
    endwhile:
    add eax,4
    LOOP outterloop

    popad
    ret
InsertionSort ENDP

END main
;-------------------------------------------
BubbleSort PROC USES eax ebx ecx edx esi

    mov ecx, 0 
    mov ecx, 15

    OUTER_LOOP: 
        push ecx
        mov ecx,0
        mov ecx,14
        mov esi, OFFSET arr

        COMPARE:
            mov ebx,0
            mov edx,0
            mov bl, [esi]
            mov dl, [esi+1]
            cmp bl,dl
            jg SWAP 

            CONTINUE:      
                add esi,4      
                loop COMPARE

        mov esi, OFFSET arr

        pop ecx     
        loop OUTER_LOOP

    jmp FINISHED

    SWAP:
        mov bl, [esi]
        mov dl, [esi+1]
        xchg bl,dl 
        mov [esi],dl 
        mov [esi+1],bl
        jmp CONTINUE 

    FINISHED:
    ret

BubbleSort ENDP
;----------------------------------------
mov esi, offset list
top:
    mov edi, esi
inner:
    mov eax, [edi]
    cmp eax, [edi+4]
    jle no_swap
    xchg eax, [edi+4]
    mov [edi], eax
no_swap:
    add edi, 4
    cmp edi, list_end - 4
    jb inner
    add esi, 4
    cmp esi, list_end - 4
    jb top
;-----------------------------------------
mov eax, list                   ;store list in eax
mov edx,[eax+4*edi-4]           ;temp = var1
cmp edx,[eax+edi*4]             ;compare
JLE SECOND_LOOP                 ;jump if var1 < var2
mov [eax+4*edi-4],[eax+edi*4]   ;var1 = var2
mov [eax+edi*4], edx            ;var2 = temp
jmp SECOND_LOOP
;-----------------------------------------
.386
public  _Sort
.model flat
.code
.data

_Sort       proc
        push    ebp
        mov     ebp, esp
        push    esi
        push    edi
        mov     ecx, [ebp + 16]     
        add     ecx, 3
        sar     ecx, 2
        sal     ecx, 2
        sub     esp, ecx    
        mov     edx, esp    

        mov     edi, [ebp + 8]  
        mov     esi, edi

        L1:
        push    ecx
        mov     esi, [ebp +8]

        L2:
        mov     al, [esi]
        cmp     [esi + 20], al
        jg      L3
        mov     eax, [esi]
        xchg    eax, [esi +20]
        mov     [esi], eax

        L3:
        add     esi, 20
        loop    L2
        pop     ecx
        loop    L1

        L4:
        pop     edi
        pop     esi
        pop     ebp
        ret
_Sort       endp

    end
	;---------------------------------------------------------------------
	.DATA
n			DWORD	10
list_end	DWORD	0
array		BYTE	1,2,3,4,5,6,7,8,9,0
.CODE

_main4		PROC
;			mov	edi, 10
;			mov eax, offset array           ;store list in eax
;			mov edx,[eax+4*edi-4]           ;temp = var1
;			cmp edx,[eax+edi*4]             ;compare
			;JLE SECOND_LOOP                 ;jump if var1 < var2
;			mov [eax+4*edi-4],[eax+edi*4]   ;var1 = var2
;			mov [eax+edi*4], edx            ;var2 = temp
			;jmp SECOND_LOOP

			mov		eax, 0
			ret
_main4		ENDP

;--------------------------------------------------------------------------------------
_main6		PROC
			mov	list_end, offset array
			add list_end, 40
			mov esi, offset array
		top:
			mov edi, esi
		inner:
			mov eax, [edi]
			cmp eax, [edi+4]
			jle no_swap
			xchg eax, [edi+4]
			mov [edi], eax
		no_swap:
			add edi, 4
			cmp edi, list_end - 4
			jb inner
			add esi, 4
			cmp esi, list_end - 4
			jb top

			mov		eax, 0
			ret
_main6		ENDP
;-------------------------------------must be compilite-----------------------