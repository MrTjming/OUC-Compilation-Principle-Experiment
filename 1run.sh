flex exp1.l
gcc -o 1 lex.yy.c -lfl
./1.exe < test/test1.i
ECHO -e "\n\n"
./1.exe < test/test-e1.i
