%{
    #include "parser.tab.h"

    #define YYSTYPE std::string

    void yyerror(char *s);
    void InvalidToken();

%}

%option yylineno
%option noyywrap

%x STR
%x ML_COMMENT

%%

[/][/].*\n      ; // comment
<INITIAL>"/*"                   BEGIN(ML_COMMENT);
<ML_COMMENT>.*\n*                ;
<ML_COMMENT>"*/"                BEGIN(INITIAL);
if              return IF;
else            return ELSE;
for             return FOR;
while           return WHILE;
do              return DO;
return          return RETURN;
print           return PRINT;
==              return EQ;
[<]=            return LE;
>=              return GE;
!=              return NE;
&&              return AND;
[|][|]              return OR;

[0-9]+          { 
                  yylval = yytext;
                  return NUM;
                }

[a-zA-Z_][a-zA-Z0-9_]*  { 
                          yylval = yytext;
                          return ID;
                        }

["]             { yylval = ""; BEGIN(STR); }

<STR>[^\\\n"]+  yylval += yytext;

<STR>\\n        yylval += '\n';

<STR>\\["]      yylval += '"';

<STR>\\         yyerror("Invalid escape sequence");

<STR>\n         yyerror("Newline in string literal");

<STR>["]        { BEGIN(INITIAL); return STRING; }

[ \t\r\n]       ; // whitespace

[-{};()=<>+*/!,] { return *yytext; }

.               {InvalidToken();}

%%
