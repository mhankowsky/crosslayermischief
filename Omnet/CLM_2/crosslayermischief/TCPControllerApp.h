//
// Copyright 2004 Andras Varga
//
// This library is free software, you can redistribute it and/or modify
// it under  the terms of the GNU Lesser General Public License
// as published by the Free Software Foundation;
// either version 2 of the License, or any later version.
// The library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
// See the GNU Lesser General Public License for more details.
//

#ifndef __INET_TCPControllerAPP_H
#define __INET_TCPControllerAPP_H

#include "INETDefs.h"
#include "ILifecycle.h"
#include "NodeStatus.h"
#include "TCPSocket.h"
#include "OMNeTBridge.h"
#include "TEPacket.h"

/**
 * Accepts any number of incoming connections, and sends back whatever
 * arrives on them.
 */
class INET_API TCPControllerApp : public cSimpleModule, public ILifecycle
{
  protected:
    simtime_t delay;
    double ControllerFactor;

    TCPSocket socket;
    NodeStatus *nodeStatus;

    long bytesRcvd;
    long bytesSent;

    OMNetBridge bridge (1);

    static simsignal_t rcvdPkSignal;
    static simsignal_t sentPkSignal;

  public:
    virtual bool handleOperationStage(LifecycleOperation *operation, int stage, IDoneCallback *doneCallback);

  protected:
    virtual bool isNodeUp();
    virtual void sendDown(cMessage *msg);
    virtual void startListening();
    virtual void stopListening();

  protected:
    virtual void initialize(int stage);
    virtual int numInitStages() const { return 2; }
    virtual void handleMessage(cMessage *msg);
    virtual void finish();
};

#endif


