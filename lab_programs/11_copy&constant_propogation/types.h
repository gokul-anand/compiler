using namespace std;
typedef struct statement
{
	string address;
	string op;
	string val1;
	string val2;
	string target;
	bool isleader;
}STATEMENT;


typedef struct pool
{	
	string head;
	vector<string> list;
}POOL;

typedef struct block
{
	int block_no;
	vector<string> in;
	vector<string> out;
	vector<STATEMENT> statements;
}BLOCK;

