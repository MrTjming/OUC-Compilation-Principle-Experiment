%{
	#include <stdio.h>
	int yylex();
  #define YYSTYPE double /* ��Yaccջ����Ϊdouble���� */
  int yyerror(char *);   /* �������ú���������warning */
%}

%token NUM LPAREN RPAREN ENTER PLUS
%left  MINUS
%left  TIMES DIVIDE
%right UMINUS

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
			| MINUS expr  {$$ = -$2;}
			| NUM							{$$ = $1;}
			;


%%

int main(){
	yyparse();
	return 0;
}
