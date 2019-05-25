%{
#include <stdio.h>
#include "y.tab.h"
%}

%option yylineno

%%

"import" 																return IMPORT;
"from"																	return FROM;
"as"																	return AS;
"if"																	return IF;
"elif"																	return ELIF;
"else"																	return ELSE;
"while"																	return WHILE;
"for"																	return FOR;
"in"																	return IN;
"range"																	return RANGE;
"True"																	return TRUE;
"False"																	return FALSE;
"and"																	return AND;
"or"																	return OR;
"def"																	return DEF;
"not in"																return NOTIN;
"not"																	return NOT;
"return"																return RET;
"is"																	return IS;
"with"																	return WITH;
"as"																	return AS;
"try"																	return TRY;
"except"																return EXCEPT;
"finally"																return FINALLY;
"raise"																	return RAISE;
"class"																	return CLASS;
"super"																	return SUPER;
"global"																return GLOBAL;
"nonlocal"																return NONLOCAL;
"pass"																	return PASS;
"lambda"																return
[#][-),(.*+=/:_a-zA-Z0-9!?">'<|@#$%^~&}{ \\\[\]\t]*[\n]					;
['][-),(.*+=/:_a-zA-Z0-9!?"><|@#$%^~&}{ \\\[\]\t]*['] 					return SENTENCE;
["][-),(.*+=/:_a-zA-Z0-9!?>'<|@#$%^~&}{ \\\[\]\t]*["] 					return SENTENCE;
['][']['][-),(.*+=/:_a-zA-Z0-9!?">'<|@#$%^~&}{ \\\[\]\n\t]*[']['][']	return MULTISENTENCE;
["]["]["][-),(.*+=/:_a-zA-Z0-9!?">'<|@#$%^~&}{ \\\[\]\n\t]*["]["]["]	return MULTISENTENCE;
[_a-zA-Z][_a-zA-Z0-9]*  												return VAR;
[0-9]+																	return NUM;
[0-9]*[.][0-9]+															return NUM;
[0-9]+[.][0-9]*															return NUM;
[0-9]*[.][0-9]+[e][+-][0-9]+											return NUM;
[0-9]+[.][0-9]*[e][+-][0-9]+											return NUM;
[.][_a-zA-Z0-9]+														return METHOD;
"["																		return '[';
"]"																		return ']';
"{"																		return '{';
"}"																		return '}';
":"																		return ':';
"="																		return '=';
","																		return ',';
"(" 																	return '(';
")"																		return ')';
"+"																		return '+';
"-"																		return '-';
"*"																		return '*';
"/"																		return '/';
"%"																		return '%';
"&"																		return '&';
"|"																		return '|';
"^"																		return '^';
"~"																		return '~';
"<<"																	return LSHIFT;
">>"																	return RSHIFT;
"**"																	return POW;
"//"																	return DIV;
"+="																	return ADDEQ;
"-="																	return SUBEQ;
"/="																	return DIVEQ;
"*="																	return MULEQ;
"//="																	return DDIVEQ;
"%="																	return MODEQ;
"**="																	return POWEQ;
"=="																	return EQUAL;
"!="																	return NOTEQUAL;
">"																		return '>';
"<"																		return '<';
">="																	return MOREEQUAL;
"<="																	return LESSEQUAL;
[ \t\n]																	;
[@]																		return '@';
.																		yyerror("Error");

%%


int yywrap(void)
{
	printf("ok\n");
	exit(1);
}