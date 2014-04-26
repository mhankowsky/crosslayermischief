#include <iostream>
using std::cout;
using std::cerr;
using std::endl;
#include "OMNeTPk.h"
#include "OMNeTPipe.h"

int main(int argc, char **argv) {
  cout << "Starting up..." << endl;
  OMNeTPipe* pipe = new OMNeTPipe("localhost", atoi(argv[1]));
  OMNeTPk* pk;
  
  cout << "Connected!" << endl;

  /* Sit on the pipe and pass through whatever pk you get */
  while (1)
  {
	cout << "Getting packet..." << endl;
	pk = pipe->recvPk();
	cout << "Packet received (" << pk->getHeader() << ")" << endl;
	pipe->sendPk(*pk);
	cout << "Packet sent!" << endl;
  }

  return 0;
}
