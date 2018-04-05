
%{
#include<stdio.h>
#include<stdlib.h>
#include<iostream>
#include<vector>
#include<stack>
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
#define print printf("%s",yytext);
#define newline printf("\n");
void printincrements();	
extern char* yytext;

vector<string> v;
stack< vector<string> > s;
%}

%token FOR OFB CFB SEMICOLON COMMA STATEMENT OCB CCB A C I

%%
stmt		: S 
		;
S		: FOR  OFB   ASSIGNMENT  SEMICOLON {print newline}  {printf("while(");}CONDITION  SEMICOLON  INCREMENT CFB   OCB {print  newline s.push(v); v.clear();} S CCB { newline printincrements(); print} S	
		|
		;
ASSIGNMENT	: A1
		| 
		;
A1		: A1 COMMA {print} A {print}
		| A {print }
		; 
CONDITION	: C {print printf(")\n");} 
		;

INCREMENT	: I1
		| 
		;
I1		: I1 COMMA I {v.push_back(yytext);}
		| I {v.push_back(yytext);}
		;	

%%

void printincrements()
{
	vector<string> e=s.top();
	s.pop();

	int i;
	for(i=0;i<e.size();i++)
	{
		cout<<e[i]<<";"<<endl;
	}
}

int main()
{

yyparse();
printf("valid file");

return 0;
}


