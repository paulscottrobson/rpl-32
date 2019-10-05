while true;
do
python scripts/testgen.py >generated/testcode.inc
sh exec.sh
done
