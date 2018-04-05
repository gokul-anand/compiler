using namespace std;
POOL* create_pool(string val)
{
	POOL* p=new POOL();
	p->head=val;
	return p;
}

POOL* search_pool( vector<POOL*> &pools,string val )
{
	for(int i=0;i<pools.size();i++)
	{
		POOL* p=pools[i];
		
		if(p->head==val)
			return p;
		
		if( find( p->list.begin(),p->list.end(),val ) !=p->list.end() )
			return p;
	}
	
	return NULL;
}

void delete_from_pools( vector<POOL*> &pools,string val )
{
	for(int i=0;i<pools.size();i++)
	{
		
		POOL* p=pools[i];
		
		if(val==p->head)
		{
			if(p->list.size()>2)
			{
				p->head=p->list[0];
				p->list.erase( p->list.begin() );
			}
			
			else
			{
				pools.erase( pools.begin()+i );
			}
			return;
		}	
		
		for(int  j=0;j<p->list.size();j++)
		{
			if(p->list[j]==val)
			{
				p->list.erase( p->list.begin()+j ) ;
				return;
			}
		}
			
	}
}

void print_pool(vector<POOL *> pools)
{
	cout<<"____________________________________"<<endl;
	for(int i=0;i<pools.size();i++)
	{
		POOL* p=pools[i];
		
		cout<<"Pool Head "<<p->head<<endl;
		
		for(int j=0;j<p->list.size();j++)
		{
			cout<<p->list[j]<<" ";
		}
		cout<<endl;
	}
	cout<<"____________________________________"<<endl;

}
