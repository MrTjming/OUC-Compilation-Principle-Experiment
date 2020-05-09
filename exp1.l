 /* 把讨厌的注释去掉 */

%{

#include <stdio.h> 
#define LT					1
#define	LE					2
#define GT					3
#define	GE					4
#define	EQ					5
#define NE					6

#define WHILE				18
#define	DO					19
#define ID          20
#define NUMBER      21
#define RELOP       22

#define NEWLINE     23
#define ERRORCHAR   24

 /* 实验内容 */
#define LEFTBRACES 25
#define RIGHTBRACES 26
#define LEFTBRACKET 27
#define RIGHTBRACKET 28
#define SEMICOLON 29
#define ASSIGN 30
#define IF 31
#define ELSE 32
#define NOTES 33
#define PLUS 34
#define MINUS 35
#define TIMES 36
#define DIV 37

#define STRING 38

%}

delim		[ \t \n]
ws			{delim}+
letter	[A-Za-z_]
digit		[0-9]
id			{letter}({letter}|{digit})*
number	{digit}+(\.{digit}+)?(E[+-]?{digit}+)?

chars	[A-Za-z]
instr    ((\\\\)|(\\\")|(\\{chars})|(\\{digit}))*
str      ({instr}|[^\"\'\n\\])*

/* 状态（或条件）定义可以定义在这里 
 * INITIAL是一个默认的状态，不需要定义
 */
%s COMMENT
%s NOTESEND
%s ISSTRING

%%
 /* 识别块注释 */
<INITIAL>"/*"						{ BEGIN COMMENT;}
<COMMENT>"*/"						{ BEGIN INITIAL;}
<COMMENT>.|\n						{;}

 /* 识别行注释 */
<INITIAL>"//"  						{ BEGIN NOTESEND;}
<NOTESEND>"\n" 						{BEGIN INITIAL; }
<NOTESEND>.							{;}

 /* 识别字符串 */
<INITIAL>\"{str}\"          			{return (STRING);}


 /* ECHO是一个宏，相当于 fprintf(yyout, "%s", yytext)*/
<INITIAL>"if"	          { return (IF);}
<INITIAL>"else"	          { return (ELSE);}
<INITIAL>{ws}	          {;}
<INITIAL>while					{ return (WHILE);}
<INITIAL>do		          { return (DO);}
<INITIAL>{id}	          { return (ID);}
<INITIAL>{number}	      { return (NUMBER);}
<INITIAL>"<"	          { return (LT);}
<INITIAL>"<="	          { return (LE);}
<INITIAL>"=="	          { return (EQ);}
<INITIAL>"!="	          { return (NE);}
<INITIAL>">"	          { return (GT);}
<INITIAL>">="	          { return (GE);}

<INITIAL>"{"	          { return (LEFTBRACES);}
<INITIAL>"}"	          { return (RIGHTBRACES);}
<INITIAL>"("	          { return (LEFTBRACKET);}
<INITIAL>")"	          { return (RIGHTBRACKET);}
<INITIAL>";"	          { return (SEMICOLON);}
<INITIAL>"="	          { return (ASSIGN);}

<INITIAL>"+"	          { return (PLUS);}
<INITIAL>"-"	          { return (MINUS);}
<INITIAL>"*"	          { return (TIMES);}
<INITIAL>"/"	          { return (DIV);}


<INITIAL>.							{ return ERRORCHAR;}

 
%%

int yywrap (){
  return 1;
}

void writeout(int c){
  switch(c){
  	case ERRORCHAR: fprintf(yyout, "(ERRORCHAR, \"%s\") ", yytext);break;
  	case RELOP: fprintf(yyout, "(RELOP, \"%s\") ", yytext);break;  	  
    case WHILE: fprintf(yyout, "(WHILE, \"%s\") ", yytext);break;
    case DO: fprintf(yyout, "(DO, \"%s\") ", yytext);break;
    case NUMBER: fprintf(yyout, "(NUM, \"%s\") ", yytext);break;
    case ID: fprintf(yyout, "(ID, \"%s\") ", yytext);break;
    case NEWLINE: fprintf(yyout, "\n");break;

	case LT: fprintf(yyout, "(LT, \"%s\") ", yytext);break;
    case LE: fprintf(yyout, "(LE, \"%s\") ", yytext);break;
    case EQ: fprintf(yyout, "(EQ, \"%s\") ", yytext);break;
    case NE: fprintf(yyout, "(NE, \"%s\") ", yytext);break;
    case GT: fprintf(yyout, "(GT, \"%s\") ", yytext);break;
    case GE: fprintf(yyout, "(GE, \"%s\") ", yytext);break;

	case LEFTBRACKET: fprintf(yyout, "(LEFTBRACKET, \"%s\") ", yytext);break;
    case RIGHTBRACKET: fprintf(yyout, "(RIGHTBRACKET, \"%s\") ", yytext);break;
    case LEFTBRACES: fprintf(yyout, "(LEFTBRACES, \"%s\") ", yytext);break;
    case RIGHTBRACES: fprintf(yyout, "(RIGHTBRACES, \"%s\") ", yytext);break;
    case SEMICOLON: fprintf(yyout, "(SEMICOLON, \"%s\") ", yytext);break;
    case ASSIGN: fprintf(yyout, "(ASSIGN, \"%s\") ", yytext);break;
    case NOTES: break;
    case IF: fprintf(yyout, "(IF, \"%s\") ", yytext);break;
    case ELSE: fprintf(yyout, "(ELSE, \"%s\") ", yytext);break;
	case PLUS: fprintf(yyout, "(PLUS, \"%s\") ", yytext);break;
	case MINUS: fprintf(yyout, "(MINUS, \"%s\") ", yytext);break;
	case TIMES: fprintf(yyout, "(TIMES, \"%s\") ", yytext);break;
	case DIV: fprintf(yyout, "(DIV, \"%s\") ", yytext);break;

	case STRING: fprintf(yyout, "(STRING, \"");
				for(int i=1;i<strlen(yytext)-1;i++){
					fprintf(yyout, "%c",*(yytext+i));
				}
				fprintf(yyout, "\") ", yytext);
				break;
    default:break;
  }
  return;
}


int main (int argc, char ** argv){
	int c,j=0;
	if (argc>=2){
	  if ((yyin = fopen(argv[1], "r")) == NULL){
	    printf("Can't open file %s\n", argv[1]);
	    return 1;
	  }
	  if (argc>=3){
	    yyout=fopen(argv[2], "w");
	  }
	}

	while (c = yylex()){
		writeout(c);
		j++;
		if (j%5 == 0) writeout(NEWLINE);
	}
	if(argc>=2){
	  fclose(yyin);
	  if (argc>=3) fclose(yyout);
	}
	return 0;
}