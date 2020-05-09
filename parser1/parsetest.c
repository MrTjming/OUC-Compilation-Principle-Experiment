/* ���ļ����﷨�����������س��� */
#include <stdio.h>
#include <stdlib.h>
#include "ast.h"
#include "errormsg.h"
#include "prast.h"


extern int yyparse(void);//yacc���ɵ��﷨������������
extern a_prog program;//program�ķ���������ڴ�
extern FILE * yyout;

/* �﷨������������������ɹ��������﷨������������ʧ�ܣ�����NULL��
 * �����������ļ���fname������ļ���output��
 * ����ֵ���﷨������ 
 */
a_prog parse(string fname, string output) {  
	int yy ;
	EM_reset(fname, output);
	//EM_yydebug();/*������ע��ȥ��������ʱ����������״̬��*/
	yy = yyparse();
  if (yy == 0) {/* parsing worked */
 	  printf("\nParse Successful!\n");
    return program;
  }
  else return NULL;
}


int main(int argc, char **argv) {
	int i;
	a_prog prog; //prog���program�ķ�������
	/* ��ȱ�ٲ���������ʾʹ�÷�����*/
 	if ((argc!=2)&&(argc!=3)) {fprintf(stderr,"usage: a.exe inputfile [outputfile]\n"); exit(1);}
 	/* ��ֻ�������ļ����������ʾ����Ļ�� */
 	else if (argc == 2){
 		printf("\nParsing begin: %s\n", argv[1]);
 		prog = parse(argv[1], "");
 		pr_prog(yyout, prog); //pr_prog�ǽ�program��������ӡ�����ĺ�����
 		printf("\nParsing end: %s\n", argv[1]);
 	} else { /* ���롢����ļ���ȫ����� */
 	  printf("\nParsing begin: %s\n", argv[1]);
 		prog = parse(argv[1], argv[2]);
 		pr_prog(yyout, prog);
 		printf("Parsing end: %s\n", argv[1]);
	}
 	
 	return 0;
}

