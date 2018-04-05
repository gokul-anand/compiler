#include<iostream>
#include<vector>
using namespace std;

typedef struct node
{
	string varname;
	string op;
	bool isalive;
	struct node *pointing;
	vector<struct node * > out;	
}NODE;

NODE* create_node(string varname)
{
	
	NODE *new_node=new NODE();
	
	new_node->varname=varname;
	new_node->op="";
	new_node->isalive=true;
	new_node->pointing=NULL;
	
	return new_node;
}


