%{
#include "grammer.hh"

%}
letter [a-zA-Z]
digit [0-9]
%%

{letter}({letter}|{digit}|"_")* 	{return VAR;}
{digit}+([.]{digit}+)?			{return NUM;}
[+] 					{return PLUS;}
[-]					{return MINUS;}
[*]					{return MULTI;}
[/]					{return DIV;}
"{"					{return OCB;}
"}"					{return CCB;}
"("					{return OFB;}
")"					{return CFB;}
"\t"					{}
"\n"					{}
" "					{}	
.					{printf("%s",yytext);}

%%

