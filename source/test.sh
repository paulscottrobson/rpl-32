while true;
do
python scripts/testgen.py 1 >generated/testcode.inc
sh exec.sh
python scripts/testgen.py 2 >generated/testcode.inc
sh exec.sh
done
