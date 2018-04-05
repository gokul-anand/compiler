%{
#include "grammer.hh"

%}
letter [a-zA-Z]
digit [0-9]
%%

(>|<|==|>=|<=|!=)		{return REL_OP;}
"true"				{return TRUE;}
"false"				{return FALSE;}
"||"				{return OR;}
"&&"				{return AND;}
"!"				{return NOT;}
"("				{return OFB;}
")"				{return CFB;}
"\t"				{}
"\n"				{}
{letter}+			{return EXPRESSION;}
" "					
.				

%%

