%{
#include <stdio.h>
#include "ast.h" //���ļ������˳����﷨�����������������ݽṹ
#include "errormsg.h"
#define YYDEBUG 1 
/* ������ٴ�����%debug������ͬ */

int yylex(void); /* function prototype */

/* �ú�����ʾ������Ϣs����ʾʱ�����˴�������λ�á�*/
void yyerror(char *s)
{
 EM_error(EM_tokPos, "%s", s);
}

/* ��ų����﷨���� "����" ���ݽṹ�ı��� */
a_prog program = NULL;

%}


 /* ��������ֵջ�����ͣ����һ��ʵ�������Ҫ�޸Ĵ˴�  */
%union {
	int ival;
	double fval;
	string sval;
  a_exp exp;
  a_stm_list stms;
  a_prog prog;
  a_dec_list decl;
}

 /* ��������ս�����Լ����ǵ�����ֵ�����ͣ����һ��ʵ�������Ҫ�޸Ĵ˴� */
%token <sval> ID /* id */
%token <ival> INT  /*������*/
%token <fval> FLOAT /*������*/
%token INTEGER REAL  /*���������������͡�ʵ��*/
%token 
  COMMA COLON SEMICOLON LPAREN RPAREN PERIOD /* ���� , : ; ( ) . */
  PROGRAM BEGINN END VAR IF WHILE DO   /* �ؼ��֣�PROGRAM BEGIN END VAR IF WHILE Do */
  /* ����Ϊʲô������ΪBEGIN�� */
  THEN ELSE /* �ؼ��֣�THEN ELSE */
  ASSIGN EQ NEQ LT LE GT GE /* ���� :=	 =  <>  <  <=  >  >= */
  PLUS MINUS TIMES DIVIDE /* ���� + = * / */
%start program

  /* ����������ս��������ֵ���ͣ����һ��ʵ�������Ҫ�޸Ĵ˴�  */
%type <prog> program
%type <decl> declist vardec
%type <stms> stmts
%type <exp> exp



%%
 /* �ķ���program--> PROGRAM ID; vardec BEGIN stmts END. 
  *       vardec-->   VAR declist 
  *       declist-->  ID:INTEGER;
  *       stmts--> ID := exp
  *       exp--> INT
  *
  * ���һ��ʵ����Ҫ�޸�����ķ�
  */
program	:	PROGRAM ID SEMICOLON vardec BEGINN stmts END PERIOD	
					{program = A_Prog(EM_tokPos, $2, $4, $6);}
				;

vardec 	: VAR declist 	{$$ = $2;}
				;
declist : ID COLON INTEGER SEMICOLON	
          {$$ = A_DecList(A_VarDec(EM_tokPos, 
                                   A_VarList(A_Id(EM_tokPos, $1), NULL), 
                                   T_int),
                          NULL);}
				;

stmts : ID ASSIGN exp	{$$ = A_StmList(A_Assign(EM_tokPos, 
                                               A_Id(EM_tokPos, $1), 
                                               $3), 
                                      NULL);}
                                      
			;
			
exp : INT	{$$ = A_IntExp(EM_tokPos, $1);}
		;
 
