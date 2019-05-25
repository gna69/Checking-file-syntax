%{
#include <stdio.h>
#include "y.tab.h"
extern int yylineno;
int check_first_if = 0;
%}

%token VAR NUM SENTENCE MULTISENTENCE TRUE FALSE
%token POW DIV ADDEQ SUBEQ DIVEQ DDIVEQ MULEQ MODEQ POWEQ EQUAL NOTEQUAL MOREEQUAL LESSEQUAL AND OR LSHIFT RSHIFT
%token IMPORT FROM AS
%token IF ELIF ELSE
%token WHILE FOR IN RANGE NOTIN NOT
%token DEF METHOD RET
%token WITH AS IS
%token CLASS SUPER GLOBAL NONLOCAL
%token TRY EXCEPT FINALLY RAISE PASS

%start begin

%%

begin:		my_begin;

my_begin:	check_vars my_begin
			| check_import my_begin
			| check_math_op my_begin
			| check_condition my_begin
			| check_cycle my_begin
			| check_function my_begin
			| check_filework my_begin
			| check_class my_begin
			| check_try my_begin
			| {yyerror("Error");};

check_condition:	IF {check_first_if = 1;} expr ':';
					| ELIF {if(!check_first_if) yyerror("Error");} expr ':';
					| ELSE {if(!check_first_if) yyerror("Error"); check_first_if = 0;}':';

check_try:	TRY ':';
			| EXCEPT check_except ':';
			| FINALLY ':';
			| RAISE VAR '(' def_arg2 ')';

check_except:	VAR check_as;
				| '(' class_arg ')' check_as;
				| ;

check_as:	AS VAR;
			|;

check_function:	DEF VAR '(' def_arg1 ')' ':';
				|VAR '(' def_arg2 ')';
				|VAR check_method;
				|SENTENCE check_method;
				|MULTISENTENCE check_method;
				|RET ret_arg;

check_filework:	WITH VAR '(' SENTENCE ',' SENTENCE ')' AS VAR ':';

check_class:	CLASS VAR ':';
				| CLASS VAR '(' class_arg ')' ':';
				| SUPER '(' class_arg ')' check_method;
				| GLOBAL class_arg1;
				| NONLOCAL class_arg1;
				| PASS;
class_arg1: VAR
			| VAR ',' class_arg1;
			| {yyerror("Error");};

class_arg:	VAR;
			| VAR ',' class_arg;
			|;

ret_arg:	val;
			|;

check_method:	METHOD;
				| METHOD check_method
				| METHOD '(' def_arg2 ')';
				| METHOD '(' def_arg2 ')' check_method;

def_arg1:	VAR;
			| '*' VAR;
			| POW VAR;
			| VAR ',' def_arg1;
			| '*' VAR ',' def_arg1;
			| POW VAR ',' def_arg1;			
			| VAR '=' expr ',' def_arg1;
			|;

def_arg2:	expr;
			| VAR '=' expr;
			| expr ',' def_arg2;
			| VAR '='  expr ',' def_arg2;
			| ;

check_cycle:	WHILE val ':';
				| FOR for_arg1 IN for_arg2 ':';

for_arg1:	VAR check_indexes;
			| VAR check_indexes ',' for_arg1;

for_arg2:	VAR check_indexes;
			|RANGE '(' range_arg ')';

range_arg:	expr;
			| expr ',' expr;
			| expr ',' expr ','expr;



check_import:   IMPORT VAR
				| FROM VAR IMPORT VAR
				| FROM VAR IMPORT '*'
				| FROM VAR IMPORT VAR AS VAR
				;


check_math_op:	VAR eqop expr;


check_indexes: 	'[' expr ']' check_indexes;
				| '[' expr ':' expr ']' check_indexes;
				| '[' expr ':' expr ':' expr ']' check_indexes;
				|  ;

check_vars:	VAR check_indexes '=' val 
			|VAR check_indexes '=' check_vars;
			|VAR check_indexes',' check_vars
			|'@' class_arg1;
			|'@' METHOD;
			|VAR check_method;
			|MULTISENTENCE;

val:
	expr | expr ',' val | '[' ']' | '[' val ']' | for_init | '{' '}' | '{' dict_val '}' | VAR check_method; | SENTENCE check_method; | MULTISENTENCE check_method; | NOT exval;

for_init:	'[' expr FOR for_arg1 IN for_arg2 ']';
			| '[' for_init FOR for_arg1 IN for_arg2 ']';

dict_val: expr ':' expr | expr ':' '[' val ']' | expr ':' '[' val ']' ',' dict_val | expr ':' expr ',' dict_val;

expr: 	exval;
		|exval sign expr;

exval: NUM; | VAR check_indexes; | SENTENCE;| MULTISENTENCE; | TRUE; | FALSE; | '(' expr ')' | VAR '(' def_arg2 ')';

eqop: ADDEQ; | SUBEQ; | DDIVEQ; | DIVEQ; | MODEQ; | MULEQ; | POWEQ;

sign: '+'; | '-'; | '*'; | '/'; | '%'; | POW; | DIV | '>' | '<' | EQUAL | NOTEQUAL | MOREEQUAL | LESSEQUAL | AND; | OR; | IN; |NOTIN; | '&'; | '|'; | '^'; | '~';| LSHIFT; | RSHIFT; | IS; | NOT;


%%

int main()
{
	yyparse();
	return 0;
}


void yyerror(const char *str)
{
	printf("%s in line %d\n", str, yylineno);
	exit(0);
}
