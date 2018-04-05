%{
#include "grammer.hh"

%}
letter [a-zA-Z]
digit [0-9]
%%

{letter}({letter}|{digit}|"_")* {return VAR;}
{digit}+([.]{digit}+)?		{return NUM;}
[+] 				{return PLUS;}
[-]					{return MINUS;}
[*]					{return MULTI;}
[/]					{return DIV;}
"{"					{return OCB;}
"}"					{return CCB;}
"\t"				{}
"\n"				{}
" "					{}	
.					{}

%%

