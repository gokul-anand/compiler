%{
#include "grammer.hh"

%}
letter [a-zA-Z]
digit [0-9]
%%
"="								{return EQUAL;}
(>|<|==|>=|<=|!=)				{return REL_OP;}
"true"							{return TRUE;}
"false"							{return FALSE;}
"||"							{return OR;}
"&&"							{return AND;}
"!"								{return NOT;}
"*"								{return MULTI;}
"+"								{return PLUS;}
"-"								{return MINUS;}
"/"								{return DIV;}
"%"								{return MOD;}
"("								{return OFB;}
")"								{return CFB;}
"["								{return OSB;}
"]"								{return CSB;}
":"								{return COLON;}								
"if"							{return IF;}
"goto"							{return GOTO;}
{letter}({letter}|{digit}|_)*	{return VAR;}
{digit}+						{return INTEGER;}
{digit}+[.]{digit}+				{return REAL;}
"\t"							{}
"\n"							{}
" "								{}
.								{}

%%

