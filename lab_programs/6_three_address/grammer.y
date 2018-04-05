
%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
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
int counter=-1;
string e="",t="",f="",temp="",e1="",t1="",var="";
string gen(); 
string three_address(string e1,string e2,string op);
string three_address(string v,string op);
%}

%token VARIABLE NUMBER EQUAL PLUS MINUS OFB CFB MULTI DIV MOD
%%
stmt	: S 
		;
S		: VARIABLE {var=yytext;} EQUAL E  {e=three_address(var,e,"=");}
		;
E		: E {e1=e;}PLUS T {e=three_address(e1,t,"+");}
		| E {e1=e;}MINUS T {e=three_address(e1,t,"-");}
		|T {e=t;}
		;
T		: T {t1=t;} MULTI F {t=three_address(t1,f,"*");}
		| T {t1=t;} DIV F  {t=three_address(t1,f,"/");}
		| T {t1=t;} MOD F {t=three_address(t1,f,"%");}
		| F {t=f;}
		;
F		: OFB GROUP CFB 
		| VARIABLE {f=yytext;}
		| NUMBER {f=yytext;}
		;
GROUP	: E	{f=e;}
		| MULTI VARIABLE {f=three_address(yytext,"*");}
		| MINUS VARIABLE {f=three_address(yytext,"-");}
		| MINUS NUMBER {f=three_address(yytext,"-");}
		;

%%

string three_address(string v,string op)
{
	
	string temp=gen();
	string three_address=temp+"="+op+v;
	cout<<three_address<<endl;
	return temp;
}

string three_address(string e1,string e2,string op)
{
	if(op=="=")
	{
		cout<<e1+op+e2<<endl;
		return e1+op+e2;
	}	
	
	string temp=gen();
	string three_address=temp+"="+e1+op+e2;
	cout<<three_address<<endl;
	return temp;
}

string to_string(int number)
{
	string s;
	if(number==0)
		return "0";
	while(number)
	{
		s=(char)((number%10)+48)+s;
		number=number/10;
	}
	
	return s;
}

string gen()
{
	counter++;
	return "t"+to_string(counter);
	
}


int main()
{

yyparse();
printf("valid file");

return 0;
}


