
EQUAL* search(vector<EQUALS> eq,string val)
{	
	for(int i=0;i<eq.size();i++)
	{	
	
	}
}

void copy_propogate(BLOCK b)
{
	vector<EQUALS> eq;
	
	for(int i=0;i<b.statements.size();i++)
	{
		STATEMENT s=b.statements[i];
		if(s.op=="=")
		{
			EQUAL ispresent=search(eq,s.val1);
			
			if(ispresent!=NULL)
			{
				remove_heads(eq,s.target);
				remove_fromlist(eq,s.target);
				
				ispresent->list.push_back(s.target);
			}
			else
			{
				remove_heads(eq,s.target);
				remove_fromlist(eq,s.target);
				
				EQUALS e;
				e.head=s.val1;
				e.list.push_back(s.target);
			}
			 
		}
		else if(s.op=="+"||s.op=="-"||s.op=="*"||s.op=="/"||s.op=="&")
		{
			
		}
	}
	
}

void copy_propogation()
{
	return;
	for(int i=0;i<Blocks.size();i++)
	{
		BLOCK b=Blocks[i];
		
		copy_propogate(b);
	}
}
