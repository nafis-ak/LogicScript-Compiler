#include <stdio.h>
#include <string.h>

int yyparse();
int yylex_destroy();

int main() {

    printf("\033[1;36m======================================================\n");
    printf("                 Welcome to LogicScript               \n");
    printf("======================================================\033[0m\n\n");

    printf("\033[1;34mDeveloper:\033[0m\n");
    printf("  • Md. Asif Khandoker\n\n");

    printf("\033[1;33mProject Overview:\033[0m\n");
    printf("  LogicScript is a custom-designed mini programming language\n");
    printf("  developed using Flex and Bison. It demonstrates core\n");
    printf("  concepts of compiler design including lexical analysis,\n");
    printf("  syntax parsing, and interpretation.\n\n");

    printf("\033[1;32mKey Features:\033[0m\n");
    printf("  • Variable declaration and assignment (let)\n");
    printf("  • Arithmetic operations (+, -, *, /, %% )\n");
    printf("  • Boolean logic (AND, OR, NOT)\n");
    printf("  • Conditional statements (if, else)\n");
    printf("  • Multiple output functions (print, print_red, print_green, print_blue)\n\n");

    printf("\033[1;35mInstructions:\033[0m\n");
    printf("  • End every statement with a semicolon (;)\n");
    printf("  • Follow proper syntax for expressions and conditions\n");
    printf("  • Enter valid LogicScript commands to execute\n\n");

    printf("\033[1;36m======================================================\033[0m\n\n");

    while(1) {
        if (yyparse() != 0) {
            printf("Parse error. Restarting parser...\n");
        }
        yylex_destroy();  
    }

    return 0;
}