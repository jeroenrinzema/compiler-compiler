%{
package main
import "fmt"
%}

%union {
    v string    /* Variable */
    s string    /* String */
    num int     /* Integer constant */
    dec float64 /* Decimal constant */
    node Node   /* Node in the AST */
};

%token <num> INTEGER
%token <s> STRING
%token <v> VARIABLE
%token <dec> DECIMAL

%token PRINT IF LET THEN CR

%left LT LE GT GE EQ NE 
%left '+' '-'
%left '*' '/'

%type <node> line statement expression term factor number v s
%type <node> operator expr_list

%%

program:
    block                               {}
    ;

block:
    block line                          {}
    | line                              {}
    ;

line:
    statement CR                { ex($1); }
    ;

statement:
    PRINT expr_list                     { $$ = opr(PRINT, 1, $2); }
    ;

expr_list:
    expr_list ','  expression           { $$ = opr('l', 2, $1, $3); }
    | expression                        { $$ = $1; }
    ;

expression:
    expression '+' term                 { $$ = opr('+', 2, $1, $3); }
    | expression '-' term               { $$ = opr('-', 2, $1, $3); }
    | term                              { $$ = $1; }
    | s                                 { $$ = $1; }
    ;

term:
    term '*' factor                     { $$ = opr('*', 2, $1, $3); }
    | term '/' factor                   { $$ = opr('/', 2, $1, $3); }
    | factor                            { $$ = $1; }
    ;

factor:
    v                                   { $$ = $1; }
    | number                            { $$ = $1; }
    | '(' expression ')'                { $$ = opr('(', 1, $2); }
    ;

number:
    INTEGER                             { $$ = Op{INTEGER, fmt.Sprintf("%d", $1)}; }
    | DECIMAL                           { $$ = Op{DECIMAL, fmt.Sprintf("%f", $1)}; }
    ;

v:
    VARIABLE                            { $$ = VarOp{VARIABLE, $1}; }
    ;

s:
    STRING                              { $$ = StringOp{STRING, $1};}
    ;

%%