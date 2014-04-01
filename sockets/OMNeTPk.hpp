/* OMNeTPk class
 *
 *
 * Michael Rosen
 * mrrosen
 * 3-8-2014
 *
 */
 
#include <vector>
using std::vector;
#include <algorithm>
#include <cstring>
 
#ifndef _OMNETPK_HPP_
#define _OMNETPK_HPP_

/* Define the types */
#define TYPE_INT      0
#define TYPE_FLOAT    1
#define TYPE_DOUBLE   2
#define TYPE_STR      3
 
class OMNeTPk {
 
private:
	int size;
	char* header;
	vector<char*> names;
	vector<void*> vals;
	vector<int> types;

public:
	OMNeTPk(char* h);
	void addVal(char* name, void* val, int type);
	char* getName(int index);
	void* getVal(char* name);
	int getType(char* name);
	char* getHeader(void);
	int getSize(void);
};

#endif /* _OMNETPK_HPP_ */