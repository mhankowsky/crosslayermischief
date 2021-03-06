//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
// 
// You should have received a copy of the GNU Lesser General Public License
// along with this program.  If not, see http://www.gnu.org/licenses/.
// 

#ifndef UDPFACTORYAPP_H_
#define UDPFACTORYAPP_H_

#include <vector>

#include "INETDefs.h"

#include "ApplicationBase.h"
#include "UDPSocket.h"


/**
 * UDP application. See NED for more info.
 */
class INET_API UDPFactoryApp : public ApplicationBase
{
  protected:
    enum SelfMsgKinds { START = 1, SEND, STOP };

    UDPSocket socket;
    int localPort, destPort;
    std::vector<IPvXAddress> destAddresses;
    simtime_t startTime;
    simtime_t stopTime;
    cMessage *selfMsg;

    // statistics
    int numSent;
    int numReceived;

    static simsignal_t sentPkSignal;
    static simsignal_t rcvdPkSignal;

    // chooses random destination address
    virtual IPvXAddress chooseDestAddr();
    virtual void sendPacket();
    virtual void processPacket(cPacket *msg);
    virtual void setSocketOptions();

  public:
    UDPFactoryApp();
    ~UDPFactoryApp();

  protected:
    virtual int numInitStages() const { return 4; }
    virtual void initialize(int stage);
    virtual void handleMessageWhenUp(cMessage *msg);
    virtual void finish();

    virtual void processStart();
    virtual void processSend();
    virtual void processStop();

    virtual bool handleNodeStart(IDoneCallback *doneCallback);
    virtual bool handleNodeShutdown(IDoneCallback *doneCallback);
    virtual void handleNodeCrash();
};


#endif /* UDPFACTORYAPP_H_ */
