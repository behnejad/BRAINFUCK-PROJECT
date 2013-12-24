.NOLIST     ; turn off listing
.386
.STACK 4096 


ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

includelib	 msvcrt.dll

.DATA
	
    
	g_days_in_month DWORD 31 ,28 , 31 ,30 , 31 ,30 ,31 ,31 , 30 , 31, 30 , 31
	j_days_in_month DWORD 31 ,31 ,31 , 31 , 31 , 31 , 30 , 30 , 30 , 30 , 30 , 29
	gy 			DWORD ?
	gm 			DWORD ?
	gd 			DWORD ?
	g_day_no 	DWORD ?	

.CODE


date STRUCT
			year		    DWORD 		?
			month	 		DWORD 		?
			day		        DWORD 		?
date ENDS

mtoj	macro		miladi_year,miladi_month,miladi_day					    ; Move address to eax
		push 		ebx									; save register values
		
		ASSUME 		ebx:PTR date						; ebx is miladi date object
		ASSUME 		eax:PTR date						; ebx is jalali date object

														;assign objects attributes
		mov  		[ebx].year,miladi_year				
		mov 		[ebx].month,miladi_month
		mov 		[ebx].day,miladi_day					
														;
		mov			ecx,[ebx].year						; line 69
		sub			ecx,1600
		mov			gy,ecx
		
		mov 		ecx,[ebx].month
		dec			ecx
		mov
		
;		mov		eax,ebx							;returns address of object in eax
		pop 		ebx
		
ENDM		

