f = open("io.asm", "r")
ff = f.readline()
string = "PUBLIC \t"
while ff:
    ff = ff.split()
    if len(ff) >= 2 and ff[1] == "PROC":
        string += ff[0] + ",\n\t"
    
    ff = f.readline()
f.close()
print string
