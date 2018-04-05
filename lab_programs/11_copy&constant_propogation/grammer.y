
%{
#include<stdio.h>
#include<stdlib.h>
#include<iostream>
#include<vector>
#include<stack>
#include<map>
#include<string>
#include<algorithm>
#include "convert.h"
#include "types.h"
#include "BLOCKS.h"
#include "NODE.h"
#include "DAG.h"
#include "pools.h"
#include "copy_propogate.h"
#include "constant_propogate.h"

using namespace std;
extern char* yytext;
extern "C" 
{
    int yyparse();
    int yylex(void);
    void yyerror(const char *msg)
    {
		printf("error %s , yytext-%s\n",msg,yytext);
		printf("invalid file\n");
		printf("%s",yytext);	
		exit(0);
	}

    int yywrap(void)
    {
    	return 1;
    }
}
#define print printf("%s\n",yytext);
#define newline printf("\n");

 string rhs,lhs,var,offset,val1,val2,val,op,target,addr;
vector<STATEMENT> v;
vector< BLOCK >Blocks;

%}

%token EXPRESSION REL_OP TRUE FALSE OR AND NOT OFB CFB OSB CSB MULTI PLUS MINUS DIV MOD VAR INTEGER REAL COLON IF GOTO EQUAL
%%
stmt					: S {mark_leaders();createBlock();mapBlocks();copy_propogation(Blocks);constant_propogation(Blocks);}

S					: LINE S 
					| 
					;

LINE					: INTEGER {addr=yytext;} COLON	THREE_ADDRESS {gen_quad();} 
					;
				
THREE_ADDRESS				: ASSIGNMENT_STATEMENT
					| IF_STATEMENT
					| GOTO_STATEMENT
					;

ASSIGNMENT_STATEMENT			:RHS EQUAL LHS 
					;

RHS					: VAR {var=yytext;} ARRAY_VAR{ if(offset=="") target=var; else target=var+"["+offset+"]";}
					;
					
LHS					: VALUE {val1=val;} OPERATOR{op=yytext;} VALUE {val2=val; }
					| VALUE { val1=val;val2="";op="="; }
					;

VALUE					: VAR {val=yytext;}
					| NUMBER {val=yytext;}
					;
					
OPERATOR				: REL_OP
					| NOT
					| AND
					| OR
					| PLUS
					| MINUS
					| MULTI	
					| DIV
					| MOD
					;

IF_STATEMENT				: IF VALUE{val1=val;} REL_OP {op=yytext;}VALUE {val2=val;} GOTO INTEGER {val=yytext;target=val;}
					;
					
GOTO_STATEMENT				: GOTO INTEGER {val=yytext;op="goto";val1="";val2="";target=val;}
					;
					
ARRAY_VAR				:  OSB OFFSET {offset=yytext;}CSB
					| {offset="";}
					;
					
OFFSET					: INTEGER
					| VAR
					;
					
NUMBER					: INTEGER
					| REAL
					;

%%


int main()
{
yyparse();
printf("valid file\n");
return 0;
}


