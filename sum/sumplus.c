/* �ݹ��½���Ԥ�������
 * �ó��������������ӷ����ʽ�������﷨��������ʾ�﷨�����Ƿ�ɹ���
 * �ӷ����ʽ����+��(,),������ɣ��Իس���β��
 * �ó���Ӧ���������Զ���ӷ����ʽ�����﷨������
 * �ո��table�������ԣ�����Ļس�Ҳ�������ԡ�
 * �ó�����������Ϊ��׼���루���̣���Ҳ����Ϊ�����ı��ļ����������Ϊ��׼�������Ļ����Ҳ����Ϊ�����ı��ļ���
 * �����ļ���β�������������
 */
#include <ctype.h>
#include <stdio.h>

#define PLUS   		1
#define LPAREN		2
#define RPAREN		3
#define NUM				4
#define ENTER			5

#define LEXERROR  -10
//#define EOF -1

FILE *yyin; 
FILE *yyout;

int yylval;
int lookahead;

int yylex();
int match(int token);
int expr();
void print(int token);
void printError(int token);

/* �ʷ���������ÿ����һ�η���һ��token�����ܵ�token�У�+�� ���� ����\n��number�����⻹�б�ʾ�ļ���β��EOF
 * ��������ʱ����LEXERROR��
 */
int yylex(){
  int c;
  do{
    c=getc(yyin);
  } while(c==' ' || c=='\t');
  switch(c){
  case '+': return PLUS;
  case '(': return LPAREN;
  case ')': return RPAREN;
  case '\n': return ENTER;
  case EOF: return EOF;
  default: 
    if ((c=='.')||(isdigit(c))){
    	ungetc(c,yyin);
      fscanf(yyin,"%d", &yylval);
      return NUM;
    } else {
      fprintf(yyout, "\nLEX:ERROR! c=%c\n", c);
  	  return LEXERROR;}
  }
}

/* ��ӡ��ǰ token ������ļ��У������ǰtoken���ǺϷ��ģ����ӡ ERROR TOKEN
 */
void print(int token){
	switch(token){
		case LPAREN:
			fprintf(yyout, "LPAREN ");
			break;
		case RPAREN:
			fprintf(yyout, "RPAREN ");
			break; 
		case PLUS:
			fprintf(yyout, "PLUS ");
			break;
		case NUM:
			fprintf(yyout, "NUM(%d) ", yylval);
			break;
		case ENTER:
			fprintf(yyout, "ENTER\n");
			break;
		case EOF:
			fprintf(yyout, "EOF");
			break;
		default:
			fprintf(yyout, "ERROR TOKEN");
	}
}

/* �﷨��������ʱ����ӡ�����token������ļ��С�
 */
void printError(int token){
	fprintf(yyout, "PARSE_ERROR:(");
	print(token);
	fprintf(yyout, ")");
}

/* ����march()�����lookahead��tokenƥ�䣬�򷵻��棨1�������򷵻ؼ٣�0�����ɸ�����ӡ��ƥ���token����δƥ���token��
 */
int match(int token){
	if (lookahead == token){
		print(token);
		lookahead = yylex();
		return 1;
	} else{ 
		printError(lookahead);
		return 0;
	}
}

/* ����exp()���Ա��ʽ���еݹ��½���Ԥ����������ʽ���԰������֣�0����������������С���źͼӺš�
 * ��������ɹ�����ú��������棨1�������򷵻ؼ٣�0��  
 * �ú�����Ҫ��д��
 */
int expr(){
	//TODO
	return 0;
}

/* ��һ�б��ʽ���еݹ��½���Ԥ�������
 * һ�б��ʽ��һ�����ʽ����һ���س���ɡ� 
 * �����棨1����ʾ�����ɹ������ؼ٣�0����ʾ����ʧ�ܡ�
 */
int exprln(){
	return(expr() && match(ENTER));
}

int main(int argc, char ** argv){
  //����ָ����������ļ���Ĭ��Ϊ����������Ļ�����
	if (argc>=2){
	  if ((yyin = fopen(argv[1], "r")) == NULL){
	    printf("Can't open file %s\n", argv[1]);
	    return 1;
	  }
	  if (argc>=3){
	    yyout=fopen(argv[2], "w");
	  } else {
	  	yyout = stdout;
	  }
	} else {
		yyin = stdin;
		yyout =stdout;
	}
	//lookaheadָ��ǰ���뻺�����ĵ�һ��token
	lookahead = yylex();
	while(lookahead != EOF){
		while(lookahead == ENTER){
			lookahead = yylex();
		}
		if (lookahead == EOF){
			break;
		}
		//�����ɹ�����ʾ�����ɹ���������������һ�����ʽ
		//����ʧ������ʾ����ʧ�ܣ�������ǰ��token������������һ�����ʽ
		if (exprln()){
			fprintf(yyout, "Parsing Success!\n");
		} 	else {
			fprintf(yyout, "Parsing Fail!\n");
			lookahead = yylex();
		}
	}
	
	if(argc>=2){
	  fclose(yyin);
	  if (argc>=3) fclose(yyout);
	}
	return 0;
}