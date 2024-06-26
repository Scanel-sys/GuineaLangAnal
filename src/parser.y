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
        DumpRow();
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

%start PROGRAM
%token IF ELSE WHILE DO FOR RETURN
%token EQ LE GE NE
%token AND OR 
%token STRING NUM ID
%token PRINT
%token INT CHAR FLOAT DOUBLE VOID BOOL
%%

PROGRAM: OPS

OPS:    OP
|       OPS OP

OP:     BODY
|       ';'
|       EXPR ';'
|       IF '(' EXPR ')' '{' OPS '}'
|       IF '(' EXPR ')' '{' OPS '}' ELSE '{' OPS '}'
|       FOR '(' FOR_EXPR_1 ';' FOR_EXPR_2 ';' FOR_EXPR_3 ')' OP
|       WHILE '(' EXPR ')' OP
|       DO OP WHILE '(' EXPR ')' ';'
|       RETURN ';'
|       RETURN FUNCTOR ';'
|       VAR_DECL    ';'
|       FUNCTION_DECL
|       FOR error ';'           { yyerrok; }
|       EXPR error OP           { yyerrok; }
|       error OP                { yyerrok; }
|       VAR_DECL error ';'      { yyerrok; }

FOR_EXPR_1:
|   EXPR
|   VAR_DECL
|   FOR_EXPR_1 ',' EXPR
|   FOR_EXPR_1 ',' VAR_DECL

FOR_EXPR_2:
|       EXPR_LOGIC_1

FOR_EXPR_3:
|       ID '=' EXPR     

BODY:
    '{'     '}'
|   '{' OPS '}'

EXPR:
        EXPR_LOGIC_1
|       ID '=' EXPR

TYPES:
        INT
|       CHAR
|       FLOAT
|       DOUBLE
|       VOID
|       BOOL

cmp_symbols:
        EQ 
|       NE 
|       LE 
|       GE 
|       '>' 
|       '<' 


FUNCTION_DECL: 
        TYPES ID FUNCTION_DECL_FUNCTOR BODY
|       TYPES ID FUNCTION_DECL_FUNCTOR ';'

VAR_DECL:
        TYPES ID
|       TYPES ID '=' EXPR

FUNCTION:
    PRINT


FUNCTION_DECL_FUNCTOR: '(' DECL_ARGS ')'
DECL_ARGS: | DECL_ARG | DECL_ARGS ',' DECL_ARG
DECL_ARG:  VAR_DECL 


FUNCTOR: '(' ARGS ')'


EXPR_LOGIC_1:
        EXPR_LOGIC_2
|       EXPR_LOGIC_1 AND EXPR_LOGIC_2
|       EXPR_LOGIC_1 OR  EXPR_LOGIC_2

EXPR_LOGIC_2:  
        EXPR_SUM
|       EXPR_LOGIC_2 cmp_symbols EXPR_SUM


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

ARGS: | ARG | ARGS ',' ARG
ARG:   EXPR
