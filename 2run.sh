flex exp2.l
gcc -o 2 lex.yy.c -lfl
./2.exe < parser0/testcases/test0.p
ECHO -e "\n\n"
./2.exe < parser0/testcases/test1.p
