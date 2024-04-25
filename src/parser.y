%{
    #include <stdio.h>
    #include <stdlib.h>
    
    extern int yylineno;
    extern int yylex();
    
    void yyerror(char *s) 
    {
        fprintf(stderr, "syntax error, line : %d\n", yylineno);
        exit(1);
    }
    #define YY_INPUT(buf,result,max_size)  {\
    result = GetNextChar(buf, max_size); \
    if (  result <= 0  ) \
    	result = YY_NULL; \
    }
%}


%token IF ELSE WHILE RETURN
%token EQ LE GE NE
%token AND OR 
%token STRING NUM ID
%token PRINT

%%

PROGRAM: OPS

OPS:    OP
|       OPS OP

OP:    '{' OPS '}'
|       EXPR ';'
|       IF '(' EXPR ')' '{' OPS '}'
|       IF '(' EXPR ')' '{' OPS '}' ELSE '{' OPS '}'
|       WHILE '(' EXPR ')' OP
|       RETURN ';'
|       RETURN FUNCTOR


EXPR:   EXPR_LOGIC_1
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
|   UNARY VAL
|   '(' EXPR ')' 
|   ID 
|   FUNCTION FUNCTOR

UNARY:
    '-'
|   '+'
|   '!'

ARGS: | ARG | ARGS ',' ARG ;
ARG:   EXPR | STRING
