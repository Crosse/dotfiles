set disassembly-flavor intel
display/i $eip

define vmdebug
target remote localhost:8832
advance *0x7c00
end
document vmdebug
Debug a VMware instance on port 8832
end

define flags
if (($eflags >> 0xB) & 1 )
printf "O "
else
printf "o "
end
if (($eflags >> 0xA) & 1 )
printf "D "
else
printf "d "
end
if (($eflags >> 9) & 1 )
printf "I "
else
printf "i "
end
if (($eflags >> 8) & 1 )
printf "T "
else
printf "t "
end
if (($eflags >> 7) & 1 )
printf "S "
else
printf "s "
end
if (($eflags >> 6) & 1 )
printf "Z "
else
printf "z "
end
if (($eflags >> 4) & 1 )
printf "A "
else
printf "a "
end
if (($eflags >> 2) & 1 )
printf "P "
else
printf "p "
end
if ($eflags & 1)
printf "C "
else
printf "c "
end
printf "\n"
end
document flags
Print flags register
end

define reg
printf " eax:%08X ebx:%08X ecx:%08X edx:%08X eflags:%08X\n", $eax, $ebx, $ecx, $edx, $eflags
printf " esi:%08X edi:%08X esp:%08X ebp:%08X eip:%08X\n", $esi, $edi, $esp, $ebp, $eip
printf " cs:%04X ds:%04X es:%04X", $cs, $ds, $es
printf " fs:%04X gs:%04X ss:%04X ", $fs, $gs, $ss
flags
end
document reg
Print CPU registers
end

