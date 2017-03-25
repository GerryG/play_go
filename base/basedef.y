%{
/* from basedef.y */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
 
#define YYDEBUG 1

int yyerror(char *s);
int yylex(void);

extern int debug; /* defined in lexer */
#define LEXDEBUGFLAG 1
#define BISONDEBUGFLAG 2
#define LEXDEBUG debug & LEXDEBUGFLAG
#define BISONDEBUG debug & BISONDEBUGFLAG

extern int yyparse(void);
extern int yylineno;
extern char *yytext;

int yywrap() { return 1; } 
int yyerror(char *s) {
  fprintf(stderr, "ERROR: %s at symbol \"%s\" on line %d\n", s, yytext, yylineno);
  printf("exitting now (error)\n");
  exit(1);
}
int main() {
 int yyres = yyparse();
  printf("exitting now (falling out of main) %d\n", yyres);
  return 0;
} 

%}

%error-verbose

%start directives

%union {
  int int_val;
  char *str_val;
}

%token CONTEXT DATA DECLARE GLOBALDATA LABEL PROCESS PROCESSL PROTOCOL STRUCTURE
%token SYMBOL WORD ARGS COMMA COLON SEMI_EOL NUMBER D_QUOTE S_QUOTE B_QUOTE
%token OPEN_PAREN CLOSE_PAREN OPEN_BRACE CLOSE_BRACE OPEN_SQ_BRACKET CLOSE_SQ_BRACKET
%token OPEN_ANGLE_BRACKET CLOSE_ANGLE_BRACKET SEMICOLON PERIOD QUESTION STAR PLUS
%token MINUS EQUAL TILDA CAROT AT VERTICAL_BAR AND PERCENT BANG SHARP SLASH BACKSLASH
%token NEWLINE STRING CHAR

%type <str_val> wordlist process_args
%type <str_val> WORD STRING
%type <int_val> NUMBER CHAR

%%

directives: directives directive| directive;

directive: CONTEXT COLON WORD SEMI_EOL
         {
           if(BISONDEBUG){
             //printf("%d: 1:%s: 2:%s 3:%s\n", yylineno, $<str_val>1, $<str_val>2, $<str_val>3);
             printf("%d: ctx: %s\n", yylineno, $<str_val>3);
           }
         }
         | DATA COLON WORD COMMA balanced SEMI_EOL
         {
           if(BISONDEBUG){
             printf("%d: data: %s =\n", yylineno, $<str_val>3);
           }
         }
         | DECLARE COLON wordlist SEMI_EOL
         {
           if(BISONDEBUG){
             //printf("%d: 1:%s: 2:%s 3:%s 4:%s\n", yylineno, $<str_val>1, $<str_val>2, $<str_val>3, $<str_val>4);
             //printf("%d: declare: %s\n", yylineno, $<str_val>3);
             printf("%d: declare\n", yylineno);
           }
         }
         | GLOBALDATA COLON WORD COMMA balanced SEMI_EOL
         {
           if(BISONDEBUG){
             printf("%d: 1:%s: 3:%s\n", yylineno, $<str_val>1, $<str_val>3);
             //printf("%d: gdata: %s = %s\n", yylineno, $<str_val>3, $<str_val>5);
           }
         }
         | LABEL COLON WORD COMMA WORD COMMA STRING SEMI_EOL
         {
           if(BISONDEBUG){
             //printf("%d: 1:%s: 2:%s 3:%s 4:%s 5:%s\n", yylineno, $<str_val>1, $<str_val>2, $<str_val>3, $<str_val>4, $<str_val>5);
             printf("%d: 3:%s 5:%s 7:%s\n", yylineno, $<str_val>3, $<str_val>5, $<str_val>7);
             //printf("%d: label: %s = %s\n", yylineno, $<str_val>3, $<str_val>5);
           }
         }
         | PROCESS COLON process_args SEMI_EOL
         {
           if(BISONDEBUG){
             printf("%d: process: %s\n", yylineno, $<str_val>3);
           }
         }
         | PROCESSL COLON process_args SEMI_EOL
         {
           if(BISONDEBUG){
             printf("%d: processl: %s\n", yylineno, $<str_val>3);
           }
         }
         | PROTOCOL COLON wordlist SEMI_EOL
         {
           if(BISONDEBUG){
             printf("%d: protocol: %s\n", yylineno, $<str_val>3);
           }
         }
         | STRUCTURE COLON WORD COMMA balanced SEMI_EOL
         {
           if(BISONDEBUG){
             printf("%d: structure: %s =\n", yylineno, $<str_val>3);
           }
         }
         | SYMBOL COLON WORD COMMA WORD SEMI_EOL
         {
           if(BISONDEBUG){
             printf("%d: sym: %s\n", yylineno, $<str_val>3);
             //printf("%d: sym: %s = %s\n", yylineno, $<str_val>3, $<str_val>5);
           }
         }
         | SYMBOL COLON WORD COMMA bracketted SEMI_EOL
         {
           if(BISONDEBUG){
             //printf("%d: symb: %s = %s\n", yylineno, $<str_val>3, $<str_val>5);
             printf("%d: symb: %s\n", yylineno, $<str_val>3);
           }
         }
         ;

//
// DECLARE and PROTOCOL
//
wordlist: WORD
        | WORD COMMA wordlist {
          $<str_val>$ = (char *)realloc( $<str_val>1,
            strlen($<str_val>1) + strlen($<str_val>3) + 1 );
          strcat($<str_val>$, $<str_val>3);
          free($<str_val>3);
        } ;
        ;
//
// The rest have a 'WORD COMMA' prefix for an lvalue (in all cases?)
//
// SYMBOL rvalue
// (rvalue can also be just a WORD)
//
bracketted: OPEN_SQ_BRACKET balanced CLOSE_SQ_BRACKET ;

//
// DATA, GLOBALDATA and STRUCTURE rvalue
//
balanced: balanced_item
        | balanced balanced_item

balanced_item: arg_bal
        | OPEN_BRACE balanced CLOSE_BRACE
        | OPEN_PAREN balanced CLOSE_PAREN
        ;

arg_bal: NEWLINE | NUMBER | WORD | CHAR | STRING | COMMA | PERIOD | QUESTION | COLON
       | D_QUOTE | STAR | PLUS | MINUS | EQUAL | TILDA | CAROT | AT | VERTICAL_BAR
       | AND | PERCENT | BANG | SHARP | SLASH
       ;

arg_token: WORD
{ $<str_val>$ = yylval.str_val; if(BISONDEBUG){ printf("w[%d]%s\n", yylineno, $$); } }
         | NUMBER
{ $<int_val>$ = yylval.int_val; if(BISONDEBUG){ printf("n[%d]%d\n", yylineno, $<int_val>$); } }
         | CHAR
{ $<int_val>$ = yylval.int_val; if(BISONDEBUG){ printf("c[%d]%c\n", yylineno, $<int_val>$); } }
         | STRING
{ $<str_val>$ = yylval.str_val; if(BISONDEBUG){ printf("s[%d]%s\n", yylineno, $$); } }
          ;
process_args: arg_token
            | process_args COMMA arg_token {
printf("xx1 %lu\n", strlen($<str_val>1));
printf("xx3 %s\n", $<str_val>1);
printf("xx4 %s\n", $<str_val>3);
printf("xx2 %lu\n", strlen($<str_val>3));
              int new_len = strlen($<str_val>1) + strlen($<str_val>3) + 1;
printf("xxx %d %s = %s\n", new_len, $<str_val>1, $<str_val>3);
              $<str_val>$ = (char *)realloc($<str_val>1, new_len);
              strcat($<str_val>$, $<str_val>3);
              free($<str_val>3);
printf("yyy\n");
            }
            ;

%%

