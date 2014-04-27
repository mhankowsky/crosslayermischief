#include <iostream>
using std::cout;
using std::cerr;
using std::endl;
#include "OMNeTPk.h"
#include "OMNeTPipe.h"

int main(int argc, char **argv) {
  cout << "Starting up..." << endl;
  OMNeTPipe* pipeC = new OMNeTPipe("localhost", 18100);
  OMNeTPipe* pipeA = new OMNeTPipe("localhost", 18240);
  OMNeTPk* pk;
  OMNeTPk up ("UPDATE");
  int p;
  float f = 1.0;

  cout << "Connected!" << endl;

  up.addVal("id", (void*)1, TYPE_INT);
  up.addVal("dt", FLOAT(f), TYPE_FLOAT);

  pipeC->sendPk(up);

  p = fork();

  /* Sit on the pipe and pass through whatever pk you get */
  while (1)
  {
	if (p == 0)
	  {
		cout << "(C) Getting packet..." << endl;
		pk = pipeC->recvPk();
		cout << "(C) Packet received (" << pk->getHeader() << ")" << endl;
    sleep(1);
		pipeA->sendPk(*pk);
		cout << "(A) Packet sent!" << endl;
	  }
	else
	  {
		cout << "(A) Getting packet..." << endl;
		pk = pipeA->recvPk();
		cout << "(A) Packet received (" << pk->getHeader() << ")" << endl;
    sleep(1);
		pipeC->sendPk(*pk);
		cout << "(C) Packet sent!" << endl;
	  }	
  }

  return 0;
}
