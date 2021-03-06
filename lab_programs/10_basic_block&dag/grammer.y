
%{
#include<stdio.h>
#include<stdlib.h>
#include<iostream>
#include<vector>
#include<stack>
#include<map>
#include"NODE.h"
#include"DAG.h"

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

typedef struct statement
{
	string address;
	string op;
	string val1;
	string val2;
	string target;
	bool isleader;
}STATEMENT;

typedef struct block
{
	int block_no;
	vector<string> in;
	vector<string> out;
	vector<STATEMENT> statements;
}BLOCK;

typedef struct equals
{	
	string head;
	vector<string> list;
}EQUALS;

vector<STATEMENT> v;

vector< BLOCK >Blocks;

void gen_quad();
void quad_print();
void mark_leaders();
void createBlock();
void printBlock();
void mapBlocks();
void dag();
%}

%token EXPRESSION REL_OP TRUE FALSE OR AND NOT OFB CFB OSB CSB MULTI PLUS MINUS DIV MOD VAR INTEGER REAL COLON IF GOTO EQUAL
%%
stmt					: S {mark_leaders();quad_print();createBlock();mapBlocks();printBlock();dag();}

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

string tostring(int n)
{
	string s;
	if(n==0) return "0";
	
	while(n)
	{
		s=char(48+(n%10))+s;
		n=n/10;
	}
	
	return s;
}

int tonum(string s)
{
	int sum=0;
	for(int i=0;i<s.size();i++)
	{
		sum=sum*10+s[i]-48;
	}
	return sum;
}



void gen_quad()
{
	STATEMENT s;
	
	s.address=addr;
	s.op=op;
	s.val1=val1;
	s.val2=val2;
	s.target=target;
	s.isleader=false;
	
	v.push_back(s);
}

bool isnumber(string s)
{
	for(int i=0;i<s.size();i++)
	{
		if(!(s[i]>='0' && s[i]<='9')) return false;
	}
	
	return true;
}

void mark(string target)
{
	for(int i=0;i<v.size();i++)
	{
		if(v[i].address==target)
		{
			v[i].isleader=true;
			return;
		}
	}
	
}

void mark_leaders()
{
	v[0].isleader=true;
	for (int i=0;i<v.size();i++)
	{
		if(isnumber(v[i].target)) 
		{ 
			if(i+1<v.size()) 
				v[i+1].isleader=true;
			
			mark(v[i].target);
		}
	}
}

void quad_print()
{
	cout<<"QUADRUPLES"<<endl;
	for (int i=0;i<v.size();i++)
	{
		STATEMENT s=v[i];
		if(s.isleader) cout<<endl;
		cout<<s.address<<"\t"<<s.op<<"\t"<<s.val1<<"\t"<<s.val2<<"\t"<<s.target<<"\t"<<s.isleader<<endl;
		
	}
}

void createBlock()
{
	int k=0;
	for(int i=0;i<v.size();)
	{
		vector<STATEMENT> s;
		
		s.push_back(v[i]);
		i+=1;
		
		while(i<v.size()&&!v[i].isleader)
		{
			s.push_back(v[i]);
			i++;
		}
		
		
		BLOCK b;
		b.block_no=k;
		k+=1;
		b.statements=s;
		Blocks.push_back(b);
		
		if(i==v.size()) break;
		
	
	}
}


int find_block(string target)
{
	for(int i=0;i<Blocks.size();i++)
	{
		if(Blocks[i].statements[0].address==target)
			return Blocks[i].block_no;
	}
}

void map_out_blocks()
{
	
	for(int i=0;i<Blocks.size();i++)
	{
		vector<STATEMENT> s=Blocks[i].statements;
		string target=s[ s.size()-1 ].target;
		
		//vector<string> out;
		cout<<tostring(Blocks[i].block_no+1)<<" "<<Blocks[i].block_no+1<<endl;
		Blocks[i].out.push_back(tostring(Blocks[i].block_no+1));
		
		if(isnumber(target))
		{
			int target_block = find_block(target);
			Blocks[i].out.push_back(tostring(target_block));
		}
		
		
		
		//Blocks[i].out=out;
	}
}

void map_in_blocks()
{
	
	for(int i=0;i<Blocks.size();i++)
	{
		//vector<string> out=Blocks[i].out;
		
		
		
		for(int j=0;j<Blocks[i].out.size();j++)
		{
			int block=tonum(Blocks[i].out[j]);
			Blocks[block].in.push_back(tostring(i));
		}
			
		
	}
}

void mapBlocks()
{
	
	map_out_blocks();
	map_in_blocks();
	
}

void printBlock()
{
	cout<<"BLOCKS"<<endl;
	for(int i=0;i<Blocks.size();i++)
	{
		cout<<"B"<<Blocks[i].block_no<<endl;
		
		cout<<"IN ";
		for(int k=0;k<Blocks[i].in.size();k++)
		{
			cout<<Blocks[i].in[k]<<" ";
		}
		
		
		
		cout<<"\nOUT ";
		for(int k=0;k<Blocks[i].out.size();k++)
		{
			cout<<Blocks[i].out[k]<<" ";
		}
		cout<<endl<<endl;
		
		for(int j=0;j<Blocks[i].statements.size();j++)
		{
			STATEMENT s=Blocks[i].statements[j];
			cout<<s.address<<"\t"<<s.op<<"\t"<<s.val1<<"\t"<<s.val2<<"\t"<<s.target<<"\t"<<s.isleader<<endl;
		}
		cout<<endl<<endl;
		
	
	}
}

void dag()
{
	
	for(int i=0;i<Blocks.size();i++)
	{
		
		BLOCK b=Blocks[i];
		cout<<"BLOCK"<<b.block_no<<endl;
		vector<NODE *> g;
		
		for(int j=0;j<b.statements.size();j++)
		{
			STATEMENT s=b.statements[j];
			cout<<s.address<<"\t"<<s.op<<"\t"<<s.val1<<"\t"<<s.val2<<"\t"<<s.target<<"\t"<<s.isleader<<endl;
			
			insert_statement(g,s.op,s.val1,s.val2,s.target);
		}
		cout<<"DAG"<<endl;
		print_dag(g);
	}
		
}



int main()
{
yyparse();
printf("valid file\n");
return 0;
}


