
%{
#include<stdio.h>
#include<stdlib.h>
#include<iostream>
#include<map>
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
	//exit(0);
	}

    int yywrap(void){return 1;}
}
#define print printf("%s\n",yytext);
#define newline printf("\n");
int blockno;
string type,atype,variable,pointer="";
extern char* yytext;
void insert_var(string variable,string datatype);
void print_table();
void delete_block();
stack <string> size;
map< string , pair< string,int > > mp;
map< string ,string > table;

int line=1;

%}

%token TYPE VAR SEMICOLON OCB CCB COMMA OSB CSB INTEGER MULTI

%%
stmt			: S {blockno=0;}
				;
S				: OCB {blockno++;}VALIDSTATEMENTS CCB{delete_block();blockno--;}
				;

VALIDSTATEMENTS	:   VALIDSTATEMENTS STATEMENT
				|
				;
		
STATEMENT 		: DSTATEMENT
				| S
				;

DSTATEMENT		: TYPE {type=yytext;} VARIABLE  IDENTIFIERS SEMICOLON   

IDENTIFIERS		: COMMA  VARIABLE IDENTIFIERS
				|
				;
VARIABLE		: POINTER VAR {variable=yytext;} ARRAY_CONSTRUCT { insert_var(variable,atype+pointer);pointer=""; }
				;
POINTER			: MULTI {pointer=pointer+"*";} POINTER
				|
				;
ARRAY_CONSTRUCT	: OSB  INTEGER {size.push(yytext);} CSB  ARRAY_CONSTRUCT {atype=size.top()+","+atype;size.pop();}
				| {atype=type;}
				;

%%



void insert_var(string variable,string datatype)
{
	//cout<<variable<<"\t"<<datatype;
	if(mp.find(variable)!=mp.end())
	{
		
		if(mp.find(variable)->second.second<blockno)
		{
			cout<<line<<" :varible '"<<variable<<"' masking previously declared variable\n";
		}
		if(mp.find(variable)->second.second==blockno)
		{
			cout<<line<<" :varible '"<<variable<<"' is redeclared\n";
		}
	}
	else
	{
	
		mp.insert( make_pair( variable, make_pair( datatype,blockno ) )  );
		table.insert( make_pair( variable,datatype ) );
	}
}
void print_table()
{
	map< string , string> :: iterator it;
	cout<<"SYMBOL TABLE"<<endl;
	for(it=table.begin();it!=table.end();it++)
	{
		cout<<it->first<<" "<<it->second<<endl;
	}
	
}

void delete_block()
{
	map< string , pair< string,int > > :: iterator it;
	for(it=mp.begin();it!=mp.end();it++)
	{
		if(it->second.second==blockno)
			mp.erase(it);
	}
	
}

int main()
{

yyparse();
printf("valid file\n");
print_table();
return 0;
}


