%{
package main

%}

%union{
val string
num float64
}


%token NUMBER IDENTIFIER

%%
start: expr 
     | assignment;

expr:
      NUMBER  
    | IDENTIFIER 
    | expr '+' expr 
    | expr '-' expr 
    | expr '*' expr 
    | expr '/' expr 
    | '(' expr ')' 
    | '-' expr 
    ;

assignment:
          IDENTIFIER '=' expr;
%%