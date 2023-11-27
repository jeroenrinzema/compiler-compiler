%{
package main

import (
        "fmt"
        "strconv"
)
%}

%union{
val string
num float64
}


%token<val> NUMBER IDENTIFIER

%type <num> expr

%left '+' '-'
%left '*' '/'

%%
start: expr {
        if yylex.(*lexer).err == nil{
                fmt.Println($1)
        }} 
     | assignment;

expr:
      NUMBER { 
        var err error
        $$, err = strconv.ParseFloat($1, 64)
        if err != nil{
                yylex.Error(err.Error())
        }
        }
    | IDENTIFIER {
        var ok bool
        $$, ok = yylex.(*lexer).vars[$1]
        if !ok {
                yylex.Error(fmt.Sprintf("undefined variable: %s\n", $1))
        }
        }
    | expr '+' expr { $$ = $1 + $3 }
    | expr '-' expr { $$ = $1 - $3 }
    | expr '*' expr { $$ = $1 * $3 }
    | expr '/' expr { $$ = $1 / $3 }
    | '(' expr ')'  { $$ = $2 }
    | '-' expr %prec '*' { $$ = -$2 }
    ;

assignment:
          IDENTIFIER '=' expr {
                if yylex.(*lexer).err == nil {
                        yylex.(*lexer).vars[$1] = $3 
                }};
%%