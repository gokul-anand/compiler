
bool constant_propogate(BLOCK b,BLOCK &	new_block)
{
	bool flag=false;
	BLOCK n=copy_propogate(b,false);
	
	vector<STATEMENT> new_statements;
	
	map <string,int> constants;
	
	for(int i=0;i<n.statements.size();i++)
	{
		STATEMENT s=n.statements[i];
		
		
		if(s.op=="=")
		{
			string val1=s.val1;
			
			if(isnumber(s.val1))
			{
				if(constants.find(s.target)!=constants.end())
				{
					constants.find(s.target)->second=tonum(s.val1);
				}
				else
				{
					constants.insert( make_pair( s.target,tonum(s.val1) ) );
				}
			}
			else
			{
				if(constants.find(s.target)!=constants.end())
				{
					
					constants.erase( constants.find(s.target) );
				}
				if(constants.find(s.val1)!=constants.end())
				{
					flag=true;
					val1=tostring(constants.find(s.val1)->second);
					
				}	
			}
			
			cout<<s.target<<" "<<s.op<<" "<<val1<<endl;
			STATEMENT temp;
			temp.op="=";
			temp.val1=val1;
			temp.val2="";
			temp.target=s.target;
			temp.isleader=s.isleader;
			
			new_statements.push_back(temp);	
		}
		else
		{
			string val1=s.val1;
			string val2=s.val2;
			
			if(constants.find(val1)!=constants.end())
			{	
				val1=tostring(constants.find(val1)->second);
			}
			if(constants.find(val2)!=constants.end())
			{	
				val2=tostring(constants.find(val2)->second);
			}
			
			if(isnumber(val1) && isnumber(val2))
			{
				flag=true;
				int arg1=tonum(val1);
				int arg2=tonum(val2);
				int result=0;
				
				if(s.op=="+")
				{
					result=arg1+arg2;
				}
				else if(s.op=="-")
				{
					result=arg1-arg2;
				}
				else if(s.op=="*")
				{
					result=arg1*arg2;
				}
				else if(s.op=="/")
				{
					result=arg1/arg2;
				}
				else if(s.op=="%")
				{
					result=arg1%arg2;
				}
				
				
				cout<<s.target<<" = "<<tostring(result)<<endl;
				
				STATEMENT temp;
				temp.op="=";
				temp.val1=tostring(result);
				temp.val2="";
				temp.target=s.target;
				temp.isleader=s.isleader;
				
				new_statements.push_back(temp);	
			}	
			else
			{
				cout<<s.target<<" = "<<val1+s.op+val2<<endl;
				
				STATEMENT temp;
				temp.op=s.op;
				temp.val1=val1;
				temp.val2=val2;
				temp.target=s.target;
				temp.isleader=s.isleader;
				
				new_statements.push_back(temp);	
			}
		}
		
	}
	
	new_block.block_no=b.block_no;
	new_block.in=b.in;
	new_block.out=b.out;
	new_block.statements=new_statements;
	
	return flag;
		
}

void constant_propogation(vector<BLOCK> Blocks)
{
	cout<<"CONSTANT PROPOGATION"<<endl;
	for(int i=0;i<Blocks.size();i++)
	{
		bool flag=true;
		BLOCK b=Blocks[i];
		while(flag)
		{
			BLOCK new_block;
			flag=constant_propogate(b,new_block);
			b=new_block;
			cout<<endl;
		}
	}
}
