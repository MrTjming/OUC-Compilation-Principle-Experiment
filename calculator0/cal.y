%{
	#include <ctype.h>
	#include <stdio.h>
	int yylex();
	int yyerror(char* s);  /* yyerror ������ʹ�ÿ��е�ʵ�֣�Ϊ�������warning */
  #define YYSTYPE double /* ��Yaccջ����Ϊdouble���� */
  #define YYDEBUG 1      /* ����debugģʽ */
%}

%token NUM LPAREN RPAREN ENTER PLUS MINUS TIMES DIVIDE

%%

  /* ����дprog�����÷�����ÿ�ζ���һ�н��з�������һ�����·���expr */

prog : prog expln
		 | expln
		 ;

expln 	: expr ENTER {printf("\nThe value of the expression is %lf.\n", $1);}
			 	;
		 	
expr  : expr PLUS term	{$$ = $1 + $3;}
			| expr MINUS term {$$ = $1 - $3;}
			| term	
			;
 
term	:	term TIMES factor  {$$ = $1 * $3;}
			| term DIVIDE factor {$$ = $1 / $3;}
			| factor
			;
			
factor  : LPAREN expr RPAREN {$$ = $2;}
				| MINUS factor 	{$$ = - $2;}
				| NUM						{$$ = $1;}
				;
 
%%

/* ��cд��ʶ���������ʽ�Ĵʷ���������
 * ���Կո���Ʊ��
 * �ܹ�ʶ��+��-��*��/��(��)�����з�
 * ���ܹ�ʶ�𸡵���������Ҳʶ��Ϊ��������
 */

int yylex(){
  int c;
  do{
    c=getchar();
  } while(c==' ' || c=='\t');
  switch(c){
  case '+': return PLUS;
  case '-': return MINUS;
  case '*': return TIMES;
  case '/': return DIVIDE;
  case '(': return LPAREN;
  case ')': return RPAREN;
  case '\n': return ENTER;
  default: 
    if ((c=='.')||(isdigit(c))){
      ungetc(c,stdin);
      scanf("%lf", &yylval);
      return NUM;
    } else {
      printf("\nLEX:ERROR! c=%c\n", c);
  	  return -1;}
  }
}

int main(){
  // yydebug = 1;
	yyparse();
	return 0;
}
