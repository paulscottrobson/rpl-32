while true;
do
python scripts/testgen.py 1 >generated/testcode.inc
sh exec.sh 1
python scripts/testgen.py 2 >generated/testcode.inc
sh exec.sh 1
python scripts/testgen.py 3 >generated/testcode.inc
sh exec.sh 1
done
