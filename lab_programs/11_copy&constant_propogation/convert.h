using namespace std;
string tostring(int n)
{
	string s;
	if(n==0) return "0";
	
	while(n)
	{
		s=char(48+(n%10))+s;
		n=n/10;
	}
	
	return s;
}

int tonum(string s)
{
	int sum=0;
	for(int i=0;i<s.size();i++)
	{
		sum=sum*10+s[i]-48;
	}
	return sum;
}

bool isnumber(string s)
{
	for(int i=0;i<s.size();i++)
	{
		if(!(s[i]>='0' && s[i]<='9')) return false;
	}
	
	return true;
}

