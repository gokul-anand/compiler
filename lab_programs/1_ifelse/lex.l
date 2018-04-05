%{
#include "grammer.hh"
%}

%%
"if" 	{return IF;}
"else"	{return ELSE;}
"{"	{return OCB;}
"}" 	{return CCB;}
"c"	{return CONDITION;}
" "	{}
"\t"	{}
"\n"	{}

%%

