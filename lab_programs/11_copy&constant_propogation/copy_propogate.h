
BLOCK copy_propogate(BLOCK b,bool flag=true)
{
	
	if(flag)printBlock(b);
	
	vector< POOL* > pools;
	vector<STATEMENT> cp;
	
	for(int i=0;i<b.statements.size();i++)
	{
		STATEMENT s=b.statements[i];
		//print_pool(pools);
		if(isnumber(s.target))
			continue;
		
		if(s.op=="=")
		{
			string rhs=s.val1;
			string lhs=s.target;
			
			if (isnumber(rhs))
			{
				delete_from_pools(pools,lhs);
			}
			else
			{
				POOL* p=search_pool(pools,rhs);
				
				if (p!=NULL)
				{
					delete_from_pools(pools,lhs);
					p->list.push_back(lhs);
					
				}
				
				else
				{
					delete_from_pools(pools,lhs);
					POOL* p=create_pool(rhs);
					
					p->list.push_back(lhs);
					
					pools.push_back(p);
				}
				
			}
			
			if(flag)
				cout<<lhs+"="+rhs<<endl;
			
			STATEMENT temp;
			temp.op="=";
			temp.val1=rhs;
			temp.val2="";
			temp.target=lhs;
			temp.isleader=s.isleader;
			
			
			cp.push_back(temp);
			
		}
		else
		{
			POOL *p;
			
			string val1=s.val1,val2=s.val2,op=s.op;
			string lhs=s.target;
			
			p=search_pool(pools,val1);
			
			if(p!=NULL)
			{
				val1=p->head;
			}
			
			p=search_pool(pools,val2);
			
			if(p!=NULL)
			{
				val2=p->head;
			}
			
			delete_from_pools(pools,lhs);
			
			if(flag)
				cout<<lhs<<"="<<val1+op+val2<<endl;
			
			STATEMENT temp;
			temp.op=op;
			temp.val1=val1;
			temp.val2=val2;
			temp.target=lhs;
			temp.isleader=s.isleader;
			
			cp.push_back(temp);
			
		}
	}
	
	if(flag)	cout<<endl;
	
	
	BLOCK cp_b;
	cp_b.block_no=b.block_no;
	cp_b.in=b.in;
	cp_b.out=b.out;
	cp_b.statements=cp;
	
	return cp_b;
	
}

void copy_propogation(vector<BLOCK> Blocks)
{
	cout<<"COPY PROPOGATION";	
	for(int i=0;i<Blocks.size();i++)
	{
		BLOCK b=Blocks[i];
		copy_propogate(b);
	}
}
