
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

string part();
extern char* yytext;

string s="";
string ans="";
stack< pair<string,string> > st;
//vector<string> v;
void enddo();
void startdo();

%}

%token DO WHILE OFB CFB SEMICOLON   OCB CCB  C STATEMENT

%%
stmt			: S
			;
S			: DO {startdo();} OCB  VSTATEMENT  CCB  WHILE{ans=ans+yytext;}  OFB {ans=ans+yytext;}  CONDITION CFB {enddo();}  SEMICOLON  S
			| 
			;
VSTATEMENT		: VSTATEMENT S
			|  VSTATEMENT STATEMENT{s=s+yytext;} SEMICOLON {s=s+yytext+"\n";}
			|
			;
			
CONDITION		: C {ans=ans+yytext;}
			;


%%

void startdo()
{	
	st.push(make_pair(s,ans));
	s="";
	ans="";
}

string part()
{
	return s+ans+"{\n"+s+"}\n";
	
}

void enddo()
{
	ans=ans+yytext+"\n";
	string prt=part();
	pair<string,string> p=st.top();
	st.pop();
	s=p.first;
	ans=p.second;
	s=s+prt;
}

int main()
{

yyparse();
printf("valid file\n");
cout<<s;
return 0;
}


