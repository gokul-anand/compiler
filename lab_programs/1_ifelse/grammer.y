%{

#include<stdio.h>
#include<stdlib.h>
#include<iostream>
using namespace std;
extern char* yytext;
extern "C" {
    int yyparse();
    int yylex(void);
    void yyerror(const char *msg){
	printf("error %s",msg);
	printf("invalid file\n");
	printf("%s",yytext);	
	exit(0);
	}

    int yywrap(void){return 1;}
}

extern char* yytext;

%}

%token IF ELSE OCB CCB CONDITION 

%%
stmt	: S {printf("valid file\n"); exit(0);}
	;
S	: I E S
	|
	;
I	:IF {printf("%s ",yytext);} CONDITION {printf("%s \n",yytext);}  OCB  {printf("%s\n",yytext);}  S CCB  {printf("\n%s\n",yytext);}
	;
E	:ELSE {printf("%s\n",yytext);}  OCB {printf("%s\n",yytext);}   S CCB  {printf("%s\n",yytext);}
	|	{printf("%s","\nelse{}\n");}
	;

%%

int main()
{

yyparse();
printf("valid file");

return 0;
}


