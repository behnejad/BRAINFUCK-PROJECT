; Omid Davoodi's standard library, header file
.NOLIST     ; turn off listing
.586

            EXTRN  oqtoaproc:near32
			
oqtoa       MACRO  dest,lsource,hsource    ;; convert integer to ASCII string

            IFB    <lsource>
            .ERR <missing operand(s) in OQTOA>
            EXITM
            ENDIF

            IFB    <hsource>
            .ERR <missing operand(s) in OQTOA>
            EXITM
            ENDIF

            push   lsource                  
            push   hsource   
			push   offset dest
            call   oqtoaproc

            ENDM

.NOLISTMACRO ; suppress macro expansion listings
.LIST        ; begin listing
