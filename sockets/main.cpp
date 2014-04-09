#include <iostream>
using std::cout;
using std::cerr;
using std::endl;
#include "OMNeTPk.hpp"
#include "OMNeTPipe.hpp"

int main(int argc, char **argv) {
  cout << "Starting up..." << endl;
  OMNeTPipe* p = new OMNeTPipe("localhost", 18637);

  OMNeTPk* pk = new OMNeTPk("HEAD");
  OMNeTPk* rpk;

  float x = 1.2;

  // Add a value to the packet
  pk->addVal("v", (void*) 3, TYPE_INT);
  pk->addVal("GGG", FLOAT(x), TYPE_FLOAT);

  cout << "Hi!" << endl;
  p->sendPk(*pk);

  cout << "sent!" << endl;
  rpk = p->recvPk();

  cout << "H: '" << rpk->getHeader() << "' Size: " << rpk->getSize() << endl;

  cout << "got it!" << endl;

  return 0;
}
