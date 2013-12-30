ml /c /coff %1.asm
link /subsystem:console /entry:main %1.obj io.obj kernel32.lib