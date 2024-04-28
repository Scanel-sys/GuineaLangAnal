#ifndef GUINEALANG_H
#define GUINEALANG_H

#define YYLTYPE_IS_DECLARED
typedef struct YYLTYPE
{
  int first_line;
  int first_column;
  int last_line;
  int last_column;
} YYLTYPE;

#include <stdio.h>
#include <math.h>
#include <ctype.h>
#include <string.h>
#include <memory.h>
#include <stdlib.h>
#include <stdarg.h>
#include <float.h>
#include "parser.tab.h"

/*
 * lex & parse
 */
extern int yylex(void);
extern int yyparse(void);
extern void yyerror(char*);


/*
 * GuineaLang.cpp
 */
extern void DumpRow(void);
extern void PrintSeparateLine(char * msg);
extern int GetNextChar(char *b, int maxBuffer);
extern void BeginToken(char*);
extern void PrintError(char *s, ...);

#endif /*GUINEALANG_H*/
