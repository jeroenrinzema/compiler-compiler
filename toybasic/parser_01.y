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
%type <node> relop expr_list

%%

%%