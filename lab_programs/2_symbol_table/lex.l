%{
#include "grammer.hh"
extern int line;
%}
letter [a-zA-Z]
digit [0-9]
%%


"{"								{return OCB;}
"}"								{return CCB;}
"["								{return OSB;}
"]"								{return CSB;}
";"								{return SEMICOLON;}
","								{return COMMA;}
"int"|"float"|"double"|"char"	{return TYPE;}
{digit}+						{return INTEGER;}
"*"								{return MULTI;}
"\t"							{}
"\n"							{line++;}
{letter}({letter}|{digit}|_)* 	{return VAR;}
" "								{}				

%%

