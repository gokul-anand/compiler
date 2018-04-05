%{
#include "grammer.hh"

%}

/*
	variables used must be declared here 
	eg:
	letter [a-zA-Z]
	digit [0-9]

*/
%%


	
/*	write rules for reguler expressions in this part
	
	eg:
	
	{letter}({letter}|{digit}|"_")* 	{return VAR;}
	{digit}+([.]{digit}+)?			{return NUM;}
	[+] 					{return PLUS;}__________________________[] required to match special characters
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



*/

%%

