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


#include "TCPControllerApp.h"

#include "GenericAppMsg_m.h"
#include "IPvXAddressResolver.h"


simsignal_t TCPControllerApp::connectSignal = SIMSIGNAL_NULL;
simsignal_t TCPControllerApp::rcvdPkSignal = SIMSIGNAL_NULL;
simsignal_t TCPControllerApp::sentPkSignal = SIMSIGNAL_NULL;

OMNeTBridge bridge (2);

void TCPControllerApp::initialize(int stage)
{
    cSimpleModule::initialize(stage);
    if (stage != 3)
        return;

    numSessions = numBroken = packetsSent = packetsRcvd = bytesSent = bytesRcvd = 0;

    //statistics
    connectSignal = registerSignal("connect");
    rcvdPkSignal = registerSignal("rcvdPk");
    sentPkSignal = registerSignal("sentPk");

    WATCH(numSessions);
    WATCH(numBroken);
    WATCH(packetsSent);
    WATCH(packetsRcvd);
    WATCH(bytesSent);
    WATCH(bytesRcvd);

    // parameters
    const char *localAddress = par("localAddress");
    int localPort = par("localPort");
    socket.readDataTransferModePar(*this);
    socket.bind(*localAddress ? IPvXAddressResolver().resolve(localAddress) : IPvXAddress(), localPort);

    socket.setCallbackObject(this);
    socket.setOutputGate(gate("tcpOut"));

    setStatusString("waiting");
}

void TCPControllerApp::handleMessage(cMessage *msg)
{
    if (msg->isSelfMessage())
        handleTimer(msg);
    else
        socket.processMessage(msg);
}

void TCPControllerApp::connect()
{
    // we need a new connId if this is not the first connection
    socket.renewSocket();

    // connect
    const char *connectAddress = par("connectAddress");
    int connectPort = par("connectPort");

    EV << "issuing OPEN command\n";
    setStatusString("connecting");

    IPvXAddress destination;
    IPvXAddressResolver().tryResolve(connectAddress, destination);
    if (destination.isUnspecified())
        EV << "cannot resolve destination address: " << connectAddress << endl;
    else {
        socket.connect(destination, connectPort);

        numSessions++;
        emit(connectSignal, 1L);
    }
}

void TCPControllerApp::close()
{
    setStatusString("closing");
    EV << "issuing CLOSE command\n";
    socket.close();
    emit(connectSignal, -1L);
}

void TCPControllerApp::sendPacket(int numBytes, int expectedReplyBytes, bool serverClose)
{
    EV << "sending " << numBytes << " bytes, expecting " << expectedReplyBytes
       << (serverClose ? ", and server should close afterwards\n" : "\n");

    GenericAppMsg *msg = new GenericAppMsg("data");
    msg->setByteLength(numBytes);
    msg->setExpectedReplyLength(expectedReplyBytes);
    msg->setServerClose(serverClose);

    emit(sentPkSignal, msg);
    socket.send(msg);

    packetsSent++;
    bytesSent += numBytes;
}

void TCPControllerApp::setStatusString(const char *s)
{
    if (ev.isGUI())
        getDisplayString().setTagArg("t", 0, s);
}

void TCPControllerApp::socketEstablished(int, void *)
{
    // *redefine* to perform or schedule first sending
    EV << "connected\n";
    setStatusString("connected");
}

void TCPControllerApp::socketDataArrived(int, void *, cPacket *msg, bool)
{
    // *redefine* to perform or schedule next sending
    packetsRcvd++;
    bytesRcvd += msg->getByteLength();
    emit(rcvdPkSignal, msg);

    TEPacket te_msg = dynamic_cast<TEPacket*>(msg);

    delete msg;
}

void TCPControllerApp::socketPeerClosed(int, void *)
{
    // close the connection (if not already closed)
    if (socket.getState() == TCPSocket::PEER_CLOSED)
    {
        EV << "remote TCP closed, closing here as well\n";
        close();
    }
}

void TCPControllerApp::socketClosed(int, void *)
{
    // *redefine* to start another session etc.
    EV << "connection closed\n";
    setStatusString("closed");
}

void TCPControllerApp::socketFailure(int, void *, int code)
{
    // subclasses may override this function, and add code try to reconnect after a delay.
    EV << "connection broken\n";
    setStatusString("broken");

    numBroken++;
}

void TCPControllerApp::finish()
{
    std::string modulePath = getFullPath();

    EV << modulePath << ": opened " << numSessions << " sessions\n";
    EV << modulePath << ": sent " << bytesSent << " bytes in " << packetsSent << " packets\n";
    EV << modulePath << ": received " << bytesRcvd << " bytes in " << packetsRcvd << " packets\n";
}

