using namespace std;
extern string rhs,lhs,var,offset,val1,val2,val,op,target,addr;
extern vector<STATEMENT> v;
extern vector< BLOCK >Blocks;


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

void printBlock(BLOCK b)
{
		cout<<"B"<<b.block_no<<endl;
		
		cout<<"IN ";
		for(int k=0;k<b.in.size();k++)
		{
			cout<<b.in[k]<<" ";
		}
		
		
		
		cout<<"\nOUT ";
		for(int k=0;k<b.out.size();k++)
		{
			cout<<b.out[k]<<" ";
		}
		cout<<endl<<endl;
		
		for(int j=0;j<b.statements.size();j++)
		{
			STATEMENT s=b.statements[j];
			cout<<s.address<<"\t"<<s.op<<"\t"<<s.val1<<"\t"<<s.val2<<"\t"<<s.target<<"\t"<<s.isleader<<endl;
		}
		cout<<endl<<endl;
}

void printBlocks()
{
	
	for(int i=0;i<Blocks.size();i++)
	{
		printBlock(Blocks[i]);
	}
}

