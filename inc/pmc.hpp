#pragma once

#include <stdlib.h>
#include <stdio.h>
#include <assert.h>

#include <readline/readline.h>
#include <readline/history.h>

#include <libpmem.h>

#include <iostream>
using namespace std;

extern void arg(int argc, char* argv);  /// print command line argument

/// @defgroup vm FORTH Virtual Machine
/// @{

/// @name config
/// main memory size,bytes
#define Msz 0x10000
/// return stack size, cells
#define Rsz 0x100
/// data stack size, cells
#define Dsz 0x10

#define IMAGE "tmp/pmc.image"

/// main Memory, raw byte array mapped to @ref IMAGE
extern uint8_t M[Msz];
extern uint32_t Cp;  /// Compiler Pointer
extern uint32_t Ip;  /// Instruction Pointer

extern int vm();     /// run Virtual Machine
extern void step();  /// do one VM command
/// run command line interface with `libreadline`
extern int repl();

/// @defgroup command VM commands
/// @brief
/// @{

extern void dump(int addr = 0, int sz = Cp);  /// dump @ref M

/// @}

/// @}

/// @name lexical skeleton
// lexer
extern int yylex();                 /// lexer
extern int yylineno;                /// current line number
extern char* yytext;                /// current token text (lexeme)
extern FILE* yyin;                  /// source input file
extern char* yyfile;                /// current file name
extern void parsefile(char* name);  /// parse file
// parser
extern void yyerror(string msg);  /// error callback
extern int yyparse();             /// parser
#include "pmc.parser.hpp"
