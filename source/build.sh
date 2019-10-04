python scripts/tables.py >generated/tables.inc
python scripts/makeprogram.py >generated/testcode.inc
rm dump.bin

64tass -q -c main.asm -o rpl32.prg -L rpl32.lst
if [ $? -eq 0 ]; then
	time ../../x16-emulator/x16emu -prg rpl32.prg -run -scale 2 -debug -dump CR
	python scripts/dump.py
fi
