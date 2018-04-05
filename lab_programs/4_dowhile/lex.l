%{
#include "grammer.hh"

%}
letter [a-zA-Z]
digit [0-9]
%%

do					{return DO;}
while				{return WHILE;}
"("					{return OFB;}
")"					{return CFB;}
"{"					{return OCB;}
"}"					{return CCB;}
;					{return SEMICOLON;}
c{digit}+			{return C;}
{letter}+			{return STATEMENT;}
"\t"				
"\n"				
" "					
.				

%%

