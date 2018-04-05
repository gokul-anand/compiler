
%{
#include<stdio.h>
#include<stdlib.h>
#include<iostream>
#include<vector>
#include<stack>
#include<map>

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

stack<vector<int> > b1_truelist,b1_falselist,b2_truelist,b2_falselist,b_truelist,b_falselist;
string b1_tl,b1_fl,b2_tl,b2_fl,b_tl,b_fl,e1,e2,relop;
map<int, pair<string,int> > mp;
int address=100;
stack<int> m_instr;
void expression();
void generate(string s);
void b_to_b1();
void b_to_b2();
void endor();
void endand();
void backpatch(vector<int> list,int address);
void enclosed();
void move( stack< vector<int> > to, stack< vector<int> > from);
void printstack(stack< vector<int> > s);
void complement_b();
%}

%token EXPRESSION REL_OP TRUE FALSE OR AND NOT OFB CFB
%%
stmt		: S 
		;
S		: B
		;
B		: B { b_to_b1();} OR M B { b_to_b2(); endor();}
		| B { b_to_b1();} AND M B { b_to_b2(); endand();}
		| NOT B {complement_b();}
		| OFB B  CFB 
		| EXPRESSION {e1=yytext;} REL_OP {relop=yytext;} EXPRESSION {e2=yytext; expression();}
		| TRUE
		| FALSE
		;
M		: {m_instr.push(address);}
		;
%%


void backpatch(vector<int> list,int address)
{
		
	for(int i=0;i<list.size();i++)
	{
		mp.find(list[i])->second.second=address;
	}
}

void endor()
{
	backpatch(b1_falselist.top(),m_instr.top());
	b1_falselist.pop();
	m_instr.pop();
	
	vector<int> l1,l2;
	
	l1=b1_truelist.top();
	b1_truelist.pop();
	l2=b2_truelist.top();
	b2_truelist.pop();
	
	for(int i=0;i<l2.size();i++)
	{
		l1.push_back(l2[i]);
	}
	
	b_truelist.push(l1);
	b_falselist.push(b2_falselist.top());
	b2_falselist.pop();
}

void endand()
{
	
	vector<int> v=b1_truelist.top();
	
	
	backpatch(b1_truelist.top(),m_instr.top());
	b1_truelist.pop();
	m_instr.pop();
	
	vector<int> l1,l2;
	
	l1=b1_falselist.top();
	b1_falselist.pop();
	l2=b2_falselist.top();
	b2_falselist.pop();
	
	for(int i=0;i<l2.size();i++)
	{
		l1.push_back(l2[i]);
	}
	
	b_falselist.push(l1);
	b_truelist.push(b2_truelist.top());
	b2_truelist.pop();
}

void b_to_b1()
{
	
		
	
	b1_truelist.push(b_truelist.top());
	b_truelist.pop();
	b1_falselist.push(b_falselist.top());
	b_falselist.pop();
	
	
}

void complement_b()
{	
	
	vector<int> t,f;
	t=b_truelist.top();
	b_truelist.pop();
	f=b_falselist.top();
	b_falselist.pop();
	

	
	b_truelist.push(f);
	b_falselist.push(t);
	
	
	
	
}

void b_to_b2()
{
	b2_truelist.push(b_truelist.top());
	b_truelist.pop();
	b2_falselist.push(b_falselist.top());
	b_falselist.pop();
}

void generate(string s)
{
	mp.insert( make_pair( address,  make_pair(s,-1) ) );
	address+=1;
}

void expression()
{
	vector<int> v1,v2;
	
	v1.push_back(address);
	v2.push_back(address+1);
	
	b_truelist.push(v1);
	b_falselist.push(v2);
	generate("if "+e1+relop+e2+" goto");
	generate("goto");
}

int main()
{

yyparse();
printf("valid file\n");

map<int, pair<string,int> > ::iterator it;

for(it=mp.begin();it!=mp.end();it++)
{
	cout<<it->first<<": "<<it->second.first<<" "<<it->second.second<<endl;
}

return 0;
}


