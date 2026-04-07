%{
#include "logicscript.tab.h"
#include <stdlib.h>
#include <string.h>
%}

%%

[ \t\r\n]+                    { /* ignore whitespace */ }

let                           { return LET; }
print                         { return PRINT; }
print_red                     { return PRINT_RED; }
print_green                   { return PRINT_GREEN; }
print_blue                    { return PRINT_BLUE; }
print_yellow                  { return PRINT_YELLOW; }

if                            { return IF; }
else                          { return ELSE; }

true                          { yylval.num = 1; return BOOL; }
false                         { yylval.num = 0; return BOOL; }

AND                           { return AND; }
OR                            { return OR; }
[nN][oO][tT]                  { return NOT; }

">="                          { return GE; }
"<="                          { return LE; }
"=="                          { return EQ; }
"!="                          { return NE; }
">"                           { return '>'; }
"<"                           { return '<'; }

"+"                           { return '+'; }
"-"                           { return '-'; }
"*"                           { return '*'; }
"/"                           { return '/'; }
"%"                           { return '%'; }

"("                           { return '('; }
")"                           { return ')'; }
"{"                           { return '{'; }
"}"                           { return '}'; }

";"                           { return ';'; }

"="                           { return '='; }

[0-9]+                        { yylval.num = atoi(yytext); return NUM; }

[a-zA-Z_][a-zA-Z0-9_]*        {
                                yylval.id = strdup(yytext);
                                return ID;
                              }

.                             { return yytext[0]; }

%%

int yywrap(void) { return 1; }
