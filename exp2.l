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
#define INT 39
#define FLOAT 40
#define COMMA 41
#define COLON 42

#define PROGRAM 43
#define BEGIN_P 44
#define VAR 45
#define THEN 46
#define REAL 47
#define INTEGER 48
#define END 49

 /* 用结构体表示 yylval */
union tokenVal{
	char char_val[32];
	int int_val;
	float float_val;
}yylval;


%}

delim		[ \t \n]
ws			{delim}+
letter	[A-Za-z_]
digit		[0-9]
 /* 识别标识符 */
id		{letter}({letter}|{digit})*
  /* 识别整数 */
int 	{digit}+(E[+-]?{digit}+)?
  /* 识别浮点数 */
float	{digit}*(\.{digit}+)(E[+-]?{digit}+)?	

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

  /* 识别关键字 */
<INITIAL>PROGRAM 				{return (PROGRAM);}
<INITIAL>BEGIN 					{return (BEGIN_P);}
<INITIAL>END 					{return (END);}
<INITIAL>END\. 					{return (END);}
<INITIAL>VAR 						{return (VAR);}
<INITIAL>INTEGER 					{return (INTEGER);}
<INITIAL>REAL 					{return (REAL);}
<INITIAL>IF	          { return (IF);}
<INITIAL>THEN 					{return (THEN);}
<INITIAL>ELSE	          { return (ELSE);}
<INITIAL>WHILE					{ return (WHILE);}
<INITIAL>DO		          { return (DO);}
<INITIAL>{ws}	          {;}

 /* 识别记号 */
<INITIAL>{id}	          {sscanf(yytext,"%s",&yylval.char_val); return (ID);}
<INITIAL>{int}	      {sscanf(yytext,"%d",&yylval.int_val); return (INT);}
<INITIAL>{float}	      {sscanf(yytext,"%f",&yylval.float_val); return (FLOAT);}

<INITIAL>"<"	          { return (LT);}
<INITIAL>"<="	          { return (LE);}
<INITIAL>"="	          { return (EQ);}
<INITIAL>"<>"	          { return (NE);}
<INITIAL>">"	          { return (GT);}
<INITIAL>">="	          { return (GE);}

<INITIAL>"{"	          { return (LEFTBRACES);}
<INITIAL>"}"	          { return (RIGHTBRACES);}
<INITIAL>"("	          { return (LEFTBRACKET);}
<INITIAL>")"	          { return (RIGHTBRACKET);}
<INITIAL>";"	          { return (SEMICOLON);}
<INITIAL>":="	          { return (ASSIGN);}
<INITIAL>":"	          {return (COLON);}
<INITIAL>","	          {return (COMMA);}

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

	case PROGRAM: fprintf(yyout, "(PROGRAM, \"%s\") ", yytext);break;
    case BEGIN_P: fprintf(yyout, "(BEGIN, \"%s\") ", yytext);break;
    case END: fprintf(yyout, "(END, \"%s\") ", yytext);break;
    case IF: fprintf(yyout, "(IF, \"%s\") ", yytext);break;
    case THEN: fprintf(yyout, "(THEN, \"%s\") ", yytext);break;
    case ELSE: fprintf(yyout, "(ELSE, \"%s\") ", yytext);break;
    case VAR: fprintf(yyout, "(VAR, \"%s\") ", yytext);break;
    case INT: fprintf(yyout, "(INT, \"%s\") ", yytext);break;
	case FLOAT: fprintf(yyout, "(FLOAT, \"%s\") ", yytext);break;
    case REAL: fprintf(yyout, "(REAL, \"%s\") ", yytext);break;
	case INTEGER: fprintf(yyout, "(INTEGER, \"%s\") ", yytext);break;
    case COMMA: fprintf(yyout, "(COMMA, \"%s\") ", yytext);break;
    case COLON: fprintf(yyout, "(COLON, \"%s\") ", yytext);break;
    
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