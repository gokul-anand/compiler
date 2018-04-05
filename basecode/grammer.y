 
%{
#include<stdio.h>
#include<stdlib.h>
#include<iostream>

/*
	include necessary headers here
*/

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

/*
	declare variables and functions going to be used in the production rules
*/

%}

%token VAR NUM PLUS MULTI MINUS DIV OCB CCB OFB CFB //declare the varaible in the grammer

%%

//change the following grammer accordingly and write the semantics associated with the grammaer within {} braces
stmt			:E {}
			;
E			: E {} PLUS T {}
			| E {} MINUS  T{}
			| T {}
			;
T			: T {} MULTI F {}
			| F {}
			;
F			:OFB E CFB 
			| VAR	{}
			| NUM	{}
			;


%%

int main()
{

yyparse();
printf("valid file");

return 0;
}


