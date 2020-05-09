%{
#include <stdio.h>
#include "util.h" 
#include "errormsg.h"


int yylex(void); /* function prototype */

/* �ú�����ʾ������Ϣs����ʾʱ�����˴�������λ�á�*/
void yyerror(char *s)
{
 EM_error(EM_tokPos, "%s", s);
}


%}


 /* ��������ֵջ�����ͣ�����ʵ���������Ҫ�洢��ͬ���͵�����ֵ������Ҫ�޸Ĵ˴� */
%union {
	int ival;
	double fval;
	string sval;
}

 /* ��������ս�����Լ����ǵ�����ֵ�����ͣ�����ʵ���������Ҫ�洢��ͬ���͵�����ֵ������Ҫ�޸Ĵ˴� */
%token <sval> ID /* id */
%token <ival> INT  /*������*/
%token <fval> FLOAT /*������*/
%token INTEGER REAL  /*���������������͡�ʵ��*/
%token 
  COMMA COLON SEMICOLON LPAREN RPAREN PERIOD /* ���� , : ; ( ) . */
  PROGRAM BEGINN END VAR IF WHILE DO   /* �ؼ��֣�PROGRAM BEGIN END VAR IF WHILE DO */
  /* ����Ϊʲô������ΪBEGIN�� */
  THEN ELSE /* �ؼ��֣�THEN ELSE */
  ASSIGN EQ NEQ LT LE GT GE /* ���� :=	 =  <>  <  <=  >  >= */
  PLUS MINUS TIMES DIVIDE /* ���� + = * / */
%start program /* ��ʼ����Ϊprogram */



%debug /* ������ٴ��� */

%%
 /* �ķ���program--> PROGRAM ID; vardec BEGIN stmts END. 
  *       vardec-->   VAR declist 
  *       declist-->  ID:INTEGER;
  *       stmts--> ID := exp
  *       exp--> INT
  *
  * ����ʵ�������Ҫ�޸�����ķ�
  */

program	:	PROGRAM ID SEMICOLON vardec BEGINN stmts END PERIOD	
				;

vardec 	: VAR declist 
				;
declist : ID COLON INTEGER SEMICOLON
				;

stmts : ID ASSIGN exp	                
			;
			
exp : INT	
		;
 
