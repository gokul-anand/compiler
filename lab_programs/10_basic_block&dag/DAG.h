#include<iostream>
#include<vector>

using namespace std;

bool has_edge(vector<NODE*> out,string arg)
{
	for(int i=0;i<out.size();i++)
	{
		if( out[i]->varname==arg && out[i]->isalive ) return true;
	}
	return false;
}


NODE* search(string op,string arg1,string arg2,vector<NODE*> &g)
{
	for(int i=0;i<g.size();i++)
	{
		//cout<<"op1" <<g[i]->op<<" op2 "<<op<<endl;
		if(g[i]->op==op)
		{
			if( has_edge( g[i]->out,arg1 )  && (has_edge( g[i]->out,arg2 ) )  )
			{
				return (g[i]);
			}
		}
	}
	return NULL;
}

void kill(vector<NODE*> g,string target)
{
	for(int i=0;i<g.size();i++)
	{
		if(g[i]->varname==target)
		{
			g[i]->isalive=false;
		}
		vector<NODE*> out=g[i]->out;
		for(int j=0;j<out.size();j++)
		{
			if(out[j]->varname==target)
				out[j]->isalive=false;
		}
	}
	
}

void print_dag(vector<NODE*> g)
{
	cout<<"Dag";
	for(int i=0;i<g.size();i++)
	{
		NODE* n=g[i];
		
		cout<<"address "<<n<<endl;
		cout<<"varname "<<n->varname<<endl;
		cout<<"op "<<n->op<<endl;
		cout<<"Pointing "<<n->pointing<<endl;
		cout<<"out"<<endl;
		for(int i=0;i<n->out.size();i++)
		{
			cout<<(n->out[i])<<"\t";
			cout<<n->out[i]->varname<<endl;
		}
		
		cout<<endl;		
	}
}

NODE* find(string arg,vector<NODE*> &g)
{
	for(int i=0;i<g.size();i++)
	{
		if(g[i]->varname==arg && g[i]->isalive)
			return (g[i]);
	}
	return NULL;
}

void insert_statement( vector<NODE*> &g,string op,string arg1,string arg2,string target)
{
	NODE* exact = search(op,arg1,arg2,g);
	
	if(exact!=NULL)
	{
		NODE *new_node=create_node(target);
		new_node->pointing=exact;
		g.push_back(new_node);
		return;
	}
	
	NODE* addr1=find(arg1,g);
	if(addr1==NULL)
	{
		NODE* n=create_node(arg1);
		addr1=n;
		g.push_back(n);
	}
	
	NODE* addr2=find(arg2,g);
	if(addr2==NULL)
	{
		NODE* n=create_node(arg2);
		addr2=n;
		g.push_back(n);
	}
	
	NODE* new_node=create_node(target);
	new_node->op=op;
	new_node->out.push_back(addr1);
	new_node->out.push_back(addr2);
	
	kill(g,target);
	
	g.push_back(new_node);
}

