import sys
asm = """.686
.MODEL		FLAT
.STACK		4096
ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD
INCLUDE		io.h
.DATA
data		BYTE {0} DUP (0)

.CODE
_main:
    mov eax, offset data
"""
if len(sys.argv) == 1:
    exit()
filename = sys.argv[1]

a = 1000
if len(sys.argv) >= 3:
    a = int(sys.argv[2])

asm = asm.format(a)

f = open (filename,'r')
bf = f.read()
f.close()

coff = 0
for i in bf:
    if (i == '<'):
        if (coff):
            coff -= 1
            asm = asm + "\ndec eax"
        else:
            coff = a - 1
            asm = asm + "\nadd eax, " + str(a-1)
    elif (i == '>'):
        if (coff == a - 1):
            coff = 0
            asm = asm + "\nmov eax, offset data"            
        else:
            coff += 1
            asm = asm + "\ninc eax"
    elif (i == '+'):
        asm = asm + "\ninc BYTE PTR [eax]"
    elif (i == '-'):
        asm = asm + "\ndec BYTE PTR [eax]"
    elif (i == ','):
        
