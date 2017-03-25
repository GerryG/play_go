%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "basedef.tab.h"

#define YYDEBUG 1
#define LEXDEBUGFLAG 1
#define BISONDEBUGFLAG 2
#define LEXDEBUG debug & LEXDEBUGFLAG
#define BISONDEBUG debug & BISONDEBUGFLAG
//int debug = 0;
//int debug = LEXDEBUGFLAG;
int debug = BISONDEBUGFLAG;
//int debug = LEXDEBUGFLAG|BISONDEBUGFLAG;

extern int yyerror();

%}

DIGIT [0-9]
WORDINITIAL [a-zA-Z_]
WORDREST [0-9a-zA-Z_]

%%
[ \t]*\n                   yylineno++ /* skip blank lines */;
#.*\n                      yylineno++ /* skip comment lines */;
Context                    yylval.str_val = "Context"; if(LEXDEBUG){printf("%s\n", yylval.str_val);}; return CONTEXT; 
Data                       yylval.str_val = "Data"; if(LEXDEBUG){printf("%s\n", yylval.str_val);}; return DATA;
Declare                    yylval.str_val = "Declare"; if(LEXDEBUG){printf("%s\n", yylval.str_val);}; return DECLARE;
GlobalData                 yylval.str_val = "GlobalData"; if(LEXDEBUG){printf("%s\n", yylval.str_val);}; return GLOBALDATA;
Label                      yylval.str_val = "Label"; if(LEXDEBUG){printf("%s\n", yylval.str_val);}; return LABEL;
Process                    yylval.str_val = "Process"; if(LEXDEBUG){printf("%s\n", yylval.str_val);}; return PROCESS;
ProcessL                   yylval.str_val = "ProcessL"; if(LEXDEBUG){printf("%s\n", yylval.str_val);}; return PROCESSL;
Protocol                   yylval.str_val = "Protocol"; if(LEXDEBUG){printf("%s\n", yylval.str_val);}; return PROTOCOL;
Structure                  yylval.str_val = "Structure"; if(LEXDEBUG){printf("%s\n", yylval.str_val);}; return STRUCTURE;
Symbol                     yylval.str_val = "Symbol"; if(LEXDEBUG){printf("%s\n", yylval.str_val);}; return SYMBOL;
;[^\n]*\n                  yylineno++; yylval.str_val = "; to eol"; if(LEXDEBUG){printf("%s\n", yylval.str_val);}; return SEMI_EOL;
{WORDINITIAL}{WORDREST}*   yylval.str_val = strdup(yytext); if(LEXDEBUG){printf("%s\n", yylval.str_val);}; return WORD;
{DIGIT}+                   yylval.int_val = atoi(yytext); if(LEXDEBUG){printf("n:%d\n", yylval.int_val);}; return NUMBER;
\"(\\.|[^\n"\\])*\"        yylval.str_val = strdup(yytext); if(LEXDEBUG){printf("%s\n", yylval.str_val);}; return STRING;
\'(\\\'|[^\\\'])\'          yylval.int_val = yytext[1]; if(LEXDEBUG){printf("C[%c]\n", yylval.int_val);}; return CHAR;
\"                         yylval.int_val = '"'; if(LEXDEBUG){printf("%c\n", yylval.int_val);};   return D_QUOTE;
\'                         yylval.int_val = '\''; if(LEXDEBUG){printf("%c\n", yylval.int_val);};   return S_QUOTE;
\`                         yylval.int_val = '`'; if(LEXDEBUG){printf("%c\n", yylval.int_val);};   return B_QUOTE;
\(                         yylval.int_val = '('; if(LEXDEBUG){printf("%c\n", yylval.int_val);};  return OPEN_PAREN;
\)                         yylval.int_val = ')'; if(LEXDEBUG){printf("%c\n", yylval.int_val);};  return CLOSE_PAREN;
\{                         yylval.int_val = '{'; if(LEXDEBUG){printf("%c\n", yylval.int_val);};   return OPEN_BRACE;
\}                         yylval.int_val = '}'; if(LEXDEBUG){printf("%c\n", yylval.int_val);};   return CLOSE_BRACE;
\[                         yylval.int_val = '['; if(LEXDEBUG){printf("%c\n", yylval.int_val);};   return OPEN_SQ_BRACKET;
\]                         yylval.int_val = ']'; if(LEXDEBUG){printf("%c\n", yylval.int_val);};   return CLOSE_SQ_BRACKET;
\<                         yylval.int_val = '<'; if(LEXDEBUG){printf("%c\n", yylval.int_val);};   return OPEN_ANGLE_BRACKET;
\>                         yylval.int_val = '>'; if(LEXDEBUG){printf("%c\n", yylval.int_val);};   return CLOSE_ANGLE_BRACKET;
\;                         yylval.int_val = ';'; if(LEXDEBUG){printf("%c\n", yylval.int_val);};  return SEMICOLON;
\,                         yylval.int_val = ','; if(LEXDEBUG){printf("%c\n", yylval.int_val);};   return COMMA;
\:                         yylval.int_val = ':'; if(LEXDEBUG){printf("%c\n", yylval.int_val);};   return COLON;
\.                         yylval.int_val = '.'; if(LEXDEBUG){printf("%c\n", yylval.int_val);};   return PERIOD;
\?                         yylval.int_val = '?'; if(LEXDEBUG){printf("%c\n", yylval.int_val);};     return QUESTION;
\*                         yylval.int_val = '*'; if(LEXDEBUG){printf("%c\n", yylval.int_val);};   return STAR;
\+                         yylval.int_val = '+'; if(LEXDEBUG){printf("%c\n", yylval.int_val);};   return PLUS;
\-                         yylval.int_val = '-'; if(LEXDEBUG){printf("%c\n", yylval.int_val);};   return MINUS;
\=                         yylval.int_val = '='; if(LEXDEBUG){printf("%c\n", yylval.int_val);};   return EQUAL;
\~                         yylval.int_val = '~'; if(LEXDEBUG){printf("%c\n", yylval.int_val);};   return TILDA;
\^                         yylval.int_val = '^'; if(LEXDEBUG){printf("%c\n", yylval.int_val);};   return CAROT;
\@                         yylval.int_val = '@'; if(LEXDEBUG){printf("%c\n", yylval.int_val);};    return AT;
\|                         yylval.int_val = '|'; if(LEXDEBUG){printf("%c\n", yylval.int_val);};   return VERTICAL_BAR;
\&                         yylval.int_val = '&'; if(LEXDEBUG){printf("%c\n", yylval.int_val);};   return AND;
\%                         yylval.int_val = '%'; if(LEXDEBUG){printf("%c\n", yylval.int_val);};   return PERCENT;
\!                         yylval.int_val = '!'; if(LEXDEBUG){printf("%c\n", yylval.int_val);};   return BANG;
\#                         yylval.int_val = '#'; if(LEXDEBUG){printf("%c\n", yylval.int_val);};   return SHARP;
\/                         yylval.int_val = '/'; if(LEXDEBUG){printf("%c\n", yylval.int_val);};    return SLASH;
\\                         yylval.int_val = '\\'; if(LEXDEBUG){printf("%c\n", yylval.int_val);};   return BACKSLASH;
[ \t]+                     yylval.str_val = "<white>"; if(LEXDEBUG){printf("%s\n", yylval.str_val);}; /* ignore whitespace */;
.	 { fprintf(stderr, "SCANNER "); yyerror(""); exit(1); }
%%
/* \n                         yylineno++; yylval.str_val = "<newline>"; if(LEXDEBUG){printf("%s\n", yylval.str_val);}; return NEWLINE; */
