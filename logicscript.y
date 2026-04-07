%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char *s);
int yylex(void);

/* symbol table */
typedef struct {
    char *name;
    int value;
} Var;

Var symtab[256];
int symcount = 0;

int setVar(const char *name, int val) {
    for (int i = 0; i < symcount; i++) {
        if (!strcmp(symtab[i].name, name)) {
            symtab[i].value = val;
            return val;
        }
    }
    symtab[symcount].name = strdup(name);
    symtab[symcount].value = val;
    symcount++;
    return val;
}

int getVar(const char *name, int *ok) {
    for (int i = 0; i < symcount; i++) {
        if (!strcmp(symtab[i].name, name)) {
            if (ok) *ok = 1;
            return symtab[i].value;
        }
    }
    if (ok) *ok = 0;
    return 0;
}
%}

%union {
    int num;
    char *id;
}

%token LET PRINT
%token PRINT_RED PRINT_GREEN PRINT_BLUE PRINT_YELLOW
%token IF ELSE
%token <num> NUM BOOL
%token <id> ID
%token AND OR NOT
%token EQ NE GE LE

%left OR
%left AND
%right NOT
%left '>' '<' GE LE EQ NE
%left '+' '-'
%left '*' '/' '%'
%right UMINUS

%type <num> expr stmt stmt_list

%%

program:
      program stmt
    | /* empty */
    ;

stmt:
      LET ID '=' expr ';'
        { setVar($2,$4); free($2); $$=1; }

    | PRINT expr ';'
        { printf("%d\n",$2); $$=1; }

    | PRINT ID ';'
        {
            int ok=0;
            int val=getVar($2,&ok);
            if(ok) printf("%d\n",val);
            else printf("Runtime error: undefined variable '%s'\n",$2);
            free($2);
            $$=1;
        }

    | PRINT_GREEN expr ';'
        { printf("\033[32m%d\033[0m\n",$2); $$=1; }

    | PRINT_RED expr ';'
        { printf("\033[31m%d\033[0m\n",$2); $$=1; }

    | PRINT_BLUE expr ';'
        { printf("\033[34m%d\033[0m\n",$2); $$=1; }

    | PRINT_YELLOW expr ';'
        { printf("\033[33m%d\033[0m\n",$2); $$=1; }

    /* IF WITHOUT ELSE */
    | IF '(' expr ')' '{' stmt_list '}' 
        {
            if($3) $$=$6;
            else $$=1;
        }

    /* IF WITH ELSE */
    | IF '(' expr ')' '{' stmt_list '}' ELSE '{' stmt_list '}' 
        {
            if($3) $$=$6;
            else $$=$10;
        }
    ;

stmt_list:
      stmt
    | stmt_list stmt
    ;

expr:
      NUM               { $$=$1; }
    | BOOL              { $$=$1; }
    | ID
        {
            int ok=0;
            int val=getVar($1,&ok);
            if(!ok){ printf("Runtime error: undefined '%s'\n",$1); $$=0; }
            else $$=val;
            free($1);
        }

    | expr '+' expr     { $$=$1+$3; }
    | expr '-' expr     { $$=$1-$3; }
    | expr '*' expr     { $$=$1*$3; }

    | expr '/' expr
        { if($3==0){printf("divide by zero\n"); $$=0;} else $$=$1/$3; }

    | expr '%' expr
        { if($3==0){printf("modulo by zero\n"); $$=0;} else $$=$1%$3; }

    | expr '>' expr     { $$=($1>$3); }
    | expr '<' expr     { $$=($1<$3); }
    | expr GE expr      { $$=($1>=$3); }
    | expr LE expr      { $$=($1<=$3); }
    | expr EQ expr      { $$=($1==$3); }
    | expr NE expr      { $$=($1!=$3); }

    | expr AND expr     { $$=($1 && $3); }
    | expr OR expr      { $$=($1 || $3); }
    | NOT expr          { $$=(!$2); }

    | '(' expr ')'      { $$=$2; }
    | '-' expr %prec UMINUS   { $$=-$2; }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr,"Parse error: %s\n",s);
}
