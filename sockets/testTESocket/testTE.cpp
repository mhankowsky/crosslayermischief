#include <iostream>
using std::cout;
using std::cerr;
using std::endl;
#include "OMNeTPk.hpp"
#include "OMNeTPipe.hpp"

int main(int argc, char **argv) {
  cout << "Starting up..." << endl;
  OMNeTPipe* p = new OMNeTPipe("localhost", 18637);
  OMNeTPk* pk = new OMNeTPk("INPUT");
  OMNeTPk* pk2;
  OMNeTPk* rpk;

  float u1 = 50.723;
  float u2 = 75.85;
  float u3 = 25.23;
  float u4 = 0.02;
  float dt = 20;

  // Add a value to the packet
  pk->addVal("u1", FLOAT(u1), TYPE_FLOAT);
  pk->addVal("u2", FLOAT(u2), TYPE_FLOAT);
  pk->addVal("u3", FLOAT(u3), TYPE_FLOAT);
  pk->addVal("u4", FLOAT(u4), TYPE_FLOAT);
  pk->addVal("dt", FLOAT(dt), TYPE_FLOAT);

  cout << "Hi!" << endl;
  p->sendPk(*pk);

  cout << "sent!" << endl;
  rpk = p->recvPk();

  cout << "H: '" << rpk->getHeader() << "' Size: " << rpk->getSize() << endl;

  cout << "got it!" << endl;
  
  pk2 = new OMNeTPk("ACK3");
  pk2->addVal("ack", (void *)(1), TYPE_INT);
  p->sendPk(*pk2);
  cout << "ack sent!" << endl;

  return 0;
}
