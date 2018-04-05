%{
#include "grammer.hh"

%}
letter [a-zA-Z]
digit [0-9]
%%

for				{return FOR;}
"("				{return OFB;}
")"				{return CFB;}
"{"				{return OCB;}
"}"				{return CCB;}
;				{return SEMICOLON;}
,				{return COMMA;}
a{digit}+			{return A;}
c{digit}+			{return C;}
i{digit}+			{return I;}	
"\t"				{}
"\n"				{}
" "					
.				

%%

