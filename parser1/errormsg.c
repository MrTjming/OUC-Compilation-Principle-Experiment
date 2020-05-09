/*
 * errormsg.c - functions used in all phases of the compiler to give
 *              error messages about the program.
 *
 */

/* ���ļ�������ִ��������� */

#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include "util.h"
#include "errormsg.h"

extern void resetLexState();
extern void yyrestart(FILE * newfile);

bool anyErrors= FALSE;

static string fileName = "";

static int lineNum = 1;//�кţ����ڱ���

int EM_tokPos=0;

extern FILE *yyin;
extern FILE *yyout;

extern int yydebug;//bison�����ڲ��ı�ǣ�yydebug��0ʱ�����������Ϣ��



typedef struct intList {int i; struct intList *rest;} *IntList;

static IntList intList(int i, IntList rest) 
{IntList l= checked_malloc(sizeof *l);
 l->i=i; l->rest=rest;
 return l;
}

static IntList linePos=NULL; //����λ�ã����ڱ���

/* ����ʱ�������кź�����λ�õĺ����� */
void EM_newline(void)
{lineNum++;
 linePos = intList(EM_tokPos, linePos);
}

/* ��������message�Ǵ�����Ϣ��ʽ����pos�Ǵ���λ�á� */
void EM_error(int pos, char *message,...)
{va_list ap;//�ɱ�����б�ָ��
 IntList lines = linePos; 
 int num=lineNum;
 

  anyErrors=TRUE;
  while (lines && lines->i >= pos) 
       {lines=lines->rest; num--;}

  if (fileName) fprintf(stderr,"%s:",fileName);
  if (lines) fprintf(stderr,"%d.%d: ", num, pos-lines->i);
  va_start(ap,message);//apָ��message��������ĵ�ַ
  //��ʽ��ӡ���ļ�stderr�У���ʽ��Ϊmessage������Ĳ�����apָ��ָ��
  vfprintf(stderr, message, ap);
  va_end(ap);//apָ�����
  fprintf(stderr,"\n");

}


/* ���ù��ڴ�������һЩ���á� */
void EM_reset(string fname, string output)
{
 anyErrors=FALSE; fileName=fname; lineNum=1;
 linePos=intList(0,NULL);
 yyin = fopen(fname,"r");
 if (output){
 	yyout = fopen(output, "w");
 }
 yyrestart(yyin);//�������û�����������
 /* ��flex�У����� void yyrestart(FILE * newfile) �Ὣyyin��ָ��ָ��newfile�Ŀ�ʼ�������ң�
  * ԭlex���뻺�����е�����ȫ��Ĩ�����������������yylex()������Ϊ���ļ���ȡһ��ʱ������
  * ����yylex�Ի����ԭ�ļ���λ�÷�������ʹ�����ƶ�yyin���������ڵ�����Ҳ����ԭ�������ݣ�
  * �ú�����������lex��״̬ΪINITIAL��
  */
 resetLexState(); //����lex״̬ΪINTIAL��
 if (!yyin) {EM_error(0,"cannot open"); exit(1);}
}

/* �˺��������趨�﷨������� */
void EM_yydebug(){
	yydebug = 1;
}

