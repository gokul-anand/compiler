%{
#include "grammer.hh"

%}
letter [a-zA-Z]
digit [0-9]
%%

{letter}({letter}|{digit}|_)*	{return VARIABLE;}

digit+([.]digit+)?		{return NUMBER;}

"="				{return EQUAL;}
"+"				{return PLUS;}
"-"				{return MINUS;}
"/"				{return DIV;}
"%"				{return MOD;}
"("				{return OFB;}
")"				{return CFB;}
"*"				{return MULTI;}
"\t"				{}
"\n"				{}
" "					
.				

%%

