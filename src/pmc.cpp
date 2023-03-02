#include "pmc.hpp"

int main(int argc, char *argv[]) {
    arg(0, argv[0]);
    for (int i = 1; i < argc; i++) {
        arg(i, argv[i]);
        parsefile(argv[i]);
    }
    dump();
    // return repl();
    return vm();
}

void parsefile(char *name) {
    assert(yyin = fopen(name, "r"));
    yyparse();
    fclose(yyin);
}

void arg(int argc, char *argv) {  //
    printf("argv[%i] = <%s>\n", argc, argv);
}

#define YYERR "\n\n" << yylineno << ":" << msg << " [" << yytext << "]"
void yyerror(string msg) {
    cout << YYERR;
    cerr << YYERR;
    exit(-1);
}

uint8_t M[Msz];
uint32_t Cp = 0;
uint32_t Ip = 0;

int vm() { return 0; }

void dump(int addr, int sz) {}

int repl() {
    char *buf;
    while ((buf = readline(">> ")) != nullptr) {
        if (strlen(buf) > 0) add_history(buf);

        printf("[%s]\n", buf);

        free(buf);
    }
    printf("\n");
    return 0;
}
