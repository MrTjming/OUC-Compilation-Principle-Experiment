%{
	#include <ctype.h>
	#include <stdio.h>
	int yylex();
	int yyerror(char * s);
  #define YYSTYPE double /* ��Yaccջ����Ϊdouble���� */
%}

%token NUM LPAREN RPAREN ENTER
%left PLUS MINUS
%left TIMES DIVIDE
%right UMINUS

%debug

%%

 /* ����дprog�����÷�����ÿ�ζ���һ�н��з�������һ�����·���expr */
prog : prog exprp
		 | exprp
		 ;

exprp 	: expr ENTER {printf("\nThe value of the expression is %lf.\n", $1);}
			 	;
expr  : expr PLUS expr	{$$ = $1 + $3;}
			| expr MINUS expr {$$ = $1 - $3;}
			| expr TIMES expr {$$ = $1 * $3;}
			| expr DIVIDE expr {$$ = $1 / $3;}
			| LPAREN expr RPAREN {$$ = $2;}
			| MINUS expr %prec UMINUS {$$ = -$2;}
			/* %prec UMINUS ��ʾ�ò���ʽ�����ȼ��ͽ�������ս��UMINUS����ͬ��
			 * ע�⣺UMINUS ��ʵ��δ�Ӵʷ��������л�ã�ֻ��������ʾ���ȼ��ͽ���Եġ�
			 */
			| NUM							{$$ = $1;}
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
  
int yyerror(char* s){
	printf(s);
	return 0;
}  

int main(){
  //yydebug = 1;
	yyparse();
	return 0;
}
