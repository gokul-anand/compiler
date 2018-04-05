 
%{
#include<stdio.h>
#include<stdlib.h>
#include<iostream>
#include<vector>
#include<queue>
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



extern char* yytext;

typedef struct node
{
	string s;
	node* left;
	node* right;
	int label;
}BST;

vector <BST*> v;

BST *e=NULL,*e1=NULL,*e2=NULL,*t=NULL,*t1=NULL,*id=NULL,*f=NULL;

stack<BST*> E1,T1;


BST* makeNode(string s,BST *left,BST *right)
{
	BST *n=new BST();
	
	n->s=s;
	n->left=left;
	n->right=right;
	
	
	
	
	if(left==NULL && right==NULL)
	{
		n->label=1;
	}
	else if( right!=NULL && left==NULL  )
	{
		n->label=right->label;
	}
	else if( left!=NULL && right==NULL  )
	{
		n->label=left->label;
	}
	else
	{
		if (left->label==right->label)
		{
			n->label=left->label+1;
		}
		else
		{
			n->label=max(left->label,right->label);
		}
	}
	
	return n;
}

void generate(BST *node,int base)
{
	
	if(node)
	{
		if(node->left==NULL && node->right==NULL)
		{
			cout<<"LD "<<"R"<<base<<", "+node->s<<endl;
			return;
		}

		if(node->left->label==node->right->label)
		{
			generate(node->right,base+1);
			generate(node->left,base);
			cout<<node->s<<" "<<"R"<<base+node->label-1<<" R"<<base+node->label-2<<" R"<<base+node->label-1<<endl;
			
		}
		else
		{
			if(node->left->label>node->right->label)
			{
				generate(node->left,base);
				generate(node->right,base);
				int k=node->left->label;
				int m=node->right->label;
				
				cout<<node->s<<" "<<"R"<<base+k-1<<" R"<<base+k-1<<" R"<<base+m-1<<endl;
				
			}
			else
			{
				
				generate(node->right,base);
				generate(node->left,base);
				
				int k=node->right->label;
				int m=node->left->label;
				
				cout<<node->s<<" "<<"R"<<base+k-1<<" R"<<base+m-1<<" R"<<base+k-1<<endl;
			}
			
		}
		
	}
}

void insufficient_generate(BST *node,int r,int base)
{
	
	if(node)
	{
		if(node->left==NULL && node->right==NULL)
		{
			cout<<"LD "<<"R"<<base<<", "+node->s<<endl;
			return;
		}
		
		if(node->label >r)
		{
			//if(node->left->label >= r || node->right->label >= r)
			{
		
				BST *big,*little;
				bool isright=false;
				if(node->left->label > node->right->label)
				{
					big=node->left;
					little=node->right;
				}
				else
				{
					little=node->left;
					big=node->right;
					isright=true;	
				}
		
				insufficient_generate(big,r,1);
		
				cout<<"ST t"<<node->label<<" R"<<r<<endl;
			
				if(little->label >= r)
				{
					insufficient_generate(little,r,1);
				}
				else
				{
					insufficient_generate(little,r,r-little->label);
				}
			
				cout<<"LD R"<<r-1<<" t"<<node->label<<endl;
		
				if(isright)
				{
					cout<<node->s<<" R"<<r<<" R"<<r<<" R"<<r-1<<endl; 
				}
				else
				{
					cout<<node->s<<" R"<<r<<" R"<<r-1<<" R"<<r<<endl; 	
				}
			
			}
		}
		else
		{
			generate(node,1);
			/*if(node->left->label==node->right->label)
			{
				insufficient_generate(node->right,r,base+1);
				insufficient_generate(node->left,r,base);
				cout<<node->s<<" "<<"R"<<base+node->label-1<<" R"<<base+node->label-2<<" R"<<base+node->label-1<<endl;
			
			}
			else
			{
				if(node->left->label>node->right->label)
				{
					insufficient_generate(node->left,r,base);
					insufficient_generate(node->right,r,base);
					int k=node->left->label;
					int m=node->right->label;
				
					cout<<node->s<<" "<<"R"<<base+k-1<<" R"<<base+k-1<<" R"<<base+m-1<<endl;
				
				}
				else
				{
				
					insufficient_generate(node->right,r,base);
					insufficient_generate(node->left,r,base);
				
					int k=node->right->label;
					int m=node->left->label;
				
					cout<<node->s<<" "<<"R"<<base+k-1<<" R"<<base+m-1<<" R"<<base+k-1<<endl;
				}
			
			}*/
			
		}
	}
}



%}

%token VAR NUM PLUS MULTI MINUS DIV OCB CCB OFB CFB

%%
stmt			:E {cout<<"SUFFICIENT REGISTERS"<<endl;generate(e,1);newline cout<<"INSUFFICIENT REGISTERS"<<endl;insufficient_generate(e,2,1);}
			;
E			: E {E1.push(e);} PLUS T {e1=E1.top();E1.pop();e=makeNode("+",e1,t);}
			| E {E1.push(e);} MINUS  T{e1=E1.top();E1.pop();e=makeNode("-",e1,t);}
			| T {e=t;}
			;
T			: T {T1.push(t);} MULTI F {t1=T1.top();T1.pop();t=makeNode("*",t1,f);}
			| T {T1.push(t);t1=t;} DIV F{t1=T1.top();T1.pop();t=makeNode("/",t1,f);}
			| F {t=f;}
			;
F			:OFB E CFB {f=e;}
			| VAR	{f=makeNode(yytext,NULL,NULL);}
			| NUM	{f=makeNode(yytext,NULL,NULL);}
			;


%%

int main()
{

yyparse();
printf("valid file");

return 0;
}


