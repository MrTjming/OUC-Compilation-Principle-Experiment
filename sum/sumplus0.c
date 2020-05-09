#include <ctype.h>
#include <stdio.h>

#define PLUS   		1
#define LPAREN		2
#define RPAREN		3
#define NUM				4
#define ENTER			0

int yylval;
int lookahead;

int yylex();
int match(int token);
int expr();


/* �ʷ�������: yylex()
 * yylex()�Ӽ��̶����ַ��������ؼǺ������ʷ������ɹ�������-1���ʷ�����ʧ�ܣ�
 */
int yylex(){
  int c;
  do{
    c=getchar();
  } while(c==' ' || c=='\t');
  switch(c){
  case '+': return PLUS;
  case '(': return LPAREN;
  case ')': return RPAREN;
  case '\n': return ENTER;
  default: 
    if ((c=='.')||(isdigit(c))){
      ungetc(c,stdin);
      scanf("%d", &yylval);
      return NUM;
    } else {
      printf("\nLEX:ERROR! c=%c\n", c);
  	  return -1;}
  }
}

/* ����march()�����lookahead��tokenƥ�䣬�򷵻��棨1�������򷵻ؼ٣�0����
 */
int match(int token){
	if (lookahead == token){
		lookahead = yylex();
		return 1;
	} else return 0;
}



/* ����exp()���Ա��ʽ���еݹ��½���Ԥ����������ʽ���԰���0��������������С���źͼӺţ����Իس���β��
 * ��������ɹ�����ú��������棨1�������򷵻ؼ٣�0��  
 * �ú�����Ҫ��д��
 */
int expr(){
	//TODO
	return 0;
}

int main(){
	lookahead = yylex();
	if (expr()){
		printf("Parsing Success!\n");
	} else {
		printf("Parsing Fail!\n");
	}
	
}