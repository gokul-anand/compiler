
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



extern char* yytext;

typedef struct node
{
	string s;
	node* left;
	node* right;
}BST;

BST *e=NULL,*e1=NULL,*t=NULL,*t1=NULL,*id=NULL,*f=NULL;


BST* makeNode(string s,BST *left,BST *right)
{
	BST *n=new BST[1];
	
	n->s=s;
	n->left=left;
	n->right=right;
	
	return n;
}

void postorder(BST *node)
{
	if(node)
	{
		postorder(node->left);
		
		
		postorder(node->right);
		
		cout<<node->s;
	}
}

%}

%token VAR NUM PLUS MULTI MINUS DIV OCB CCB

%%
stmt		:  E {postorder(e);}

E			: E PLUS T {e=makeNode("+",e,t);}
			| T	{e=t;}
			;
T			: T MULTI F {t=makeNode("*",t,f);}
			| F {t=f;}
			;
F			:OCB E CCB {f=e;}
			| VAR	{f=makeNode(yytext,NULL,NULL);}
			| NUM	{f=makeNode(yytext,NULL,NULL);}


%%

int main()
{

yyparse();
printf("valid file");

return 0;
}


