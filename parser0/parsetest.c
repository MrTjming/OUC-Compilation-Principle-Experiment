/* ���ļ����﷨�����������س��� */
#include <stdio.h>
#include <stdlib.h>
#include "util.h"
#include "errormsg.h"


extern int yyparse(void);//yacc���ɵ��﷨������������


/* �﷨������������������ɹ�������0������ʧ�ܣ�����1��
 * �����������ļ���fname������ļ���output��
 * ����ֵ������0��1 
 */
int parse(string fname) {  
	int yy ;
	EM_reset(fname, "");
	//EM_yydebug();/*������ע��ȥ��������ʱ����������״̬��*/
	yy = yyparse();
  if (yy == 0) {/* parsing worked */
 	  printf("\nParse Successful!\n");
    return 0;
  }
  else return 1;
}


int main(int argc, char **argv) {
	int i;
	/* ��ȱ�ٲ���������ʾʹ�÷�����*/
 	if (argc!=2) {fprintf(stderr,"usage: parser0.exe inputfile \n"); exit(1);}
 	/* ֻ�������ļ������ */
 	else {
 		printf("\nParsing begin: %s\n", argv[1]);
 		parse(argv[1]);
 		printf("\nParsing end: %s\n", argv[1]);
 	} 
 	return 0;
}

