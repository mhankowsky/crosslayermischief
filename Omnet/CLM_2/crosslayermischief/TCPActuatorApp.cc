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


#include "TCPActuatorApp.h"

#include "ModuleAccess.h"
#include "NodeStatus.h"
#include "TCPSocket.h"
#include "TCPCommand_m.h"
#include "GenericAppMsg_m.h"


Define_Module(TCPActuatorApp);

simsignal_t TCPActuatorApp::rcvdPkSignal = SIMSIGNAL_NULL;
simsignal_t TCPActuatorApp::sentPkSignal = SIMSIGNAL_NULL;

OMNeTBridge bridge (2);

void TCPActuatorApp::initialize(int stage)
{
    if (stage == 0)
    {
        int localPort = par("localPort");
        delay = par("replyDelay");
        maxMsgDelay = 0;

        //statistics
        msgsRcvd = msgsSent = bytesRcvd = bytesSent = 0;
        rcvdPkSignal = registerSignal("rcvdPk");
        sentPkSignal = registerSignal("sentPk");

        WATCH(msgsRcvd);
        WATCH(msgsSent);
        WATCH(bytesRcvd);
        WATCH(bytesSent);


        //TODO should use IPvXAddressResolver in stage 3
        const char *localAddress = par("localAddress");
        TCPSocket socket;
        socket.setOutputGate(gate("tcpOut"));
        socket.setDataTransferMode(TCP_TRANSFER_OBJECT);
        socket.bind(localAddress[0] ? IPvXAddress(localAddress) : IPvXAddress(), localPort);
        socket.listen();
    }
    else if (stage == 1)
    {
        bool isOperational;
        NodeStatus *nodeStatus = dynamic_cast<NodeStatus *>(findContainingNode(this)->getSubmodule("status"));
        isOperational = (!nodeStatus) || nodeStatus->getState() == NodeStatus::UP;
        if (!isOperational)
            throw cRuntimeError("This module doesn't support starting in node DOWN state");
    }
}

void TCPActuatorApp::sendOrSchedule(cMessage *msg, simtime_t delay)
{
    if (delay==0)
        sendBack(msg);
    else
        scheduleAt(simTime()+delay, msg);
}

void TCPActuatorApp::sendBack(cMessage *msg)
{
    GenericAppMsg *appmsg = dynamic_cast<GenericAppMsg*>(msg);

    if (appmsg)
    {
        msgsSent++;
        bytesSent += appmsg->getByteLength();
        emit(sentPkSignal, appmsg);

        EV << "sending \"" << appmsg->getName() << "\" to TCP, " << appmsg->getByteLength() << " bytes\n";
    }
    else
    {
        EV << "sending \"" << msg->getName() << "\" to TCP\n";
    }

    send(msg, "tcpOut");
}

void TCPActuatorApp::handleMessage(cMessage *msg)
{
    if (msg->getKind() == TCP_I_PEER_CLOSED)
       {
           // we close too
           msg->setName("close");
           msg->setKind(TCP_C_CLOSE);
           send(msg, "tcpOut");
       }
       else if (msg->getKind() == TCP_I_DATA || msg->getKind() == TCP_I_URGENT_DATA)
       {
           TEPacket *appmsg = dynamic_cast<TEPacket*>(msg);

           cPacket *pk = PK(msg);
           long packetLength = pk->getByteLength();
           bytesRcvd += packetLength;
           emit(rcvdPkSignal, pk);

           //Pass data to the Matlab Model
           int matlabID = appmsg->getSourceId();
           float matlabData = appmsg->getData();
           bridge.setVal(matlabID, matlabData, SIMTIME_DBL(simTime()));




           delete msg;

           if (ev.isGUI())
           {
               char buf[32];
               sprintf(buf, "rcvd: %ld bytes", bytesRcvd);
               getDisplayString().setTagArg("t", 0, buf);
           }
       }
       else
       {
           // must be data or some kind of indication -- can be dropped
           delete msg;
       }
}

void TCPActuatorApp::finish()
{
    EV << getFullPath() << ": sent " << bytesSent << " bytes in " << msgsSent << " packets\n";
    EV << getFullPath() << ": received " << bytesRcvd << " bytes in " << msgsRcvd << " packets\n";
}
