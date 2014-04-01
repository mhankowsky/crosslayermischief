/* OMNeTPipe class
 *
 *
 * Michael Rosen
 * mrrosen
 * 3-8-2014
 *
 */

#include "OMNeTPk.hpp"
#include "Sockets.hpp"
#include <string>
using std::string;

#ifndef _OMNETPIPE_HPP_
#define _OMNETPIPE_HPP_
 
/* Maximum size of a packet string */
#define MAX_PK_SIZE 4096
 
/* Message primatives */
#define MSG_BEGIN    '\1'
#define MSG_FIELDSEP '\30'
#define MSG_INTSEP   '\31'
#define MSG_END      '\4'
 
class OMNeTPipe {

private:
	TCPSocket* sk;
	
public:
	OMNeTPipe(char* host, int port);
	int sendPk(OMNeTPk pk);
	OMNeTPk* recvPk(void);
};

#endif /* _OMNETPIPE_HPP_ */
