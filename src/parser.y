%locations
%{
    #include "GuineaLang.h"

    #define YYERROR_VERBOSE 1

    extern int yylineno;
    extern char * yytext;
    extern int yylex();
    extern YYLTYPE yylloc;

    extern void yyerror(char *s) 
    {
        PrintError(s);
    }

    #define YY_INPUT(buf,result,max_size)  {\
    result = GetNextChar(buf, max_size); \
    if (  result <= 0  ) \
    	result = YY_NULL; \
    }
%}
%defines
%define parse.error verbose


%token IF ELSE WHILE DO FOR RETURN
%token EQ LE GE NE
%token AND OR 
%token STRING NUM ID
%token PRINT

%%

PROGRAM: OPS

OPS:    OP
|       OPS OP

OP:     BODY
|       ';'
|       EXPR ';'
|       IF '(' EXPR ')' '{' OPS '}'
|       IF '(' EXPR ')' '{' OPS '}' ELSE '{' OPS '}'
|       FOR '(' FOR_EXPR ';' FOR_EXPR ';' FOR_EXPR ')' OP
|       WHILE '(' EXPR ')' OP
|       DO OP WHILE '(' EXPR ')' ';'
|       RETURN ';'
|       RETURN FUNCTOR ';'
|       EXPR error ';'      { yyerrok; }
|       error '\n'          { yyerrok; }
|       '(' error ')'       { yyerrok; }
|       '{' error '}'       { yyerrok; }

FOR_EXPR:
|   EXPR

BODY:
    '{'     '}'
|   '{' OPS '}'

EXPR:
        EXPR_LOGIC_1
|       ID '=' EXPR

FUNCTION:
    PRINT

FUNCTOR: '(' ARGS ')'


EXPR_LOGIC_1:
        EXPR_LOGIC_2
|       EXPR_LOGIC_1 AND EXPR_LOGIC_2
|       EXPR_LOGIC_1 OR  EXPR_LOGIC_2

EXPR_LOGIC_2:  EXPR_SUM
|       EXPR_LOGIC_2 EQ EXPR_SUM
|       EXPR_LOGIC_2 NE EXPR_SUM
|       EXPR_LOGIC_2 LE EXPR_SUM
|       EXPR_LOGIC_2 GE EXPR_SUM
|       EXPR_LOGIC_2 '>' EXPR_SUM
|       EXPR_LOGIC_2 '<' EXPR_SUM

EXPR_SUM: 
        EXPR_MUL
|       EXPR_SUM '+' EXPR_MUL
|       EXPR_SUM '-' EXPR_MUL

EXPR_MUL:   
        VAL
|       EXPR_MUL '*' VAL 
|       EXPR_MUL '/' VAL
|       EXPR_MUL '%' VAL

VAL: 
    NUM
|   STRING
|   UNARY VAL
|   '(' EXPR ')' 
|   ID 
|   FUNCTION FUNCTOR


UNARY:
    '-'
|   '+'
|   '!'

ARGS: | ARG | ARGS ',' ARG ;
ARG:   EXPR
