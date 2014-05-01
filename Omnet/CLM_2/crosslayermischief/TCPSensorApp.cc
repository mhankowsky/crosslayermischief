//
// Copyright (C) 2004 Andras Varga
//
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU Lesser General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with this program; if not, see <http://www.gnu.org/licenses/>.
//


#include "TEPacket.h"
#include "TCPSensorApp.h"
#include "NodeOperations.h"
#include "ModuleAccess.h"

#define MSGKIND_CONNECT  0
#define MSGKIND_SEND     1


Define_Module(TCPSensorApp);

TCPSensorApp::TCPSensorApp()
{
    timeoutMsg = NULL;
}

TCPSensorApp::~TCPSensorApp()
{
    cancelAndDelete(timeoutMsg);
}

void TCPSensorApp::initialize(int stage)
{
    TCPGenericCliAppBase::initialize(stage);
    if (stage != 3)
        return;

    numRequestsToSend = 0;
    earlySend = false;  // TBD make it parameter
    WATCH(numRequestsToSend);
    WATCH(earlySend);


    // FIXME
    sensorName = "F this project";
    delay = par("delay");
    startTime = par("startTime");
    stopTime = par("stopTime");
    matlabID = par("matlabID");
    matlabType = par("matlabType");


    bridge = new OMNeTBridge(matlabType);

    if (stopTime >= SIMTIME_ZERO && stopTime < startTime)
        error("Invalid startTime/stopTime parameters");

    timeoutMsg = new cMessage("timer");
    nodeStatus = dynamic_cast<NodeStatus *>(findContainingNode(this)->getSubmodule("status"));

    if (isNodeUp()) {
        timeoutMsg->setKind(MSGKIND_CONNECT);
        scheduleAt(startTime, timeoutMsg);
    }
}

bool TCPSensorApp::isNodeUp()
{
    return !nodeStatus || nodeStatus->getState() == NodeStatus::UP;
}

bool TCPSensorApp::handleOperationStage(LifecycleOperation *operation, int stage, IDoneCallback *doneCallback)
{
    Enter_Method_Silent();

        if (stage == NodeStartOperation::STAGE_APPLICATION_LAYER) {
            simtime_t now = simTime();
            simtime_t start = std::max(startTime, now);
            timeoutMsg->setKind(MSGKIND_CONNECT);
            scheduleAt(start, timeoutMsg);
        }

    return true;
}

void TCPSensorApp::sendRequest()
{
     EV << "sending request, " << numRequestsToSend-1 << " more to go\n";

     sendPacket();
}

void TCPSensorApp::sendPacket()
{
    //TODO Read from MATLAB
    // READ
    //float matlabData = bridge.getVal(1, (float) SIMTIME_DLB(simTime()));

    float matlabData = bridge->getVal(matlabID, (float) SIMTIME_DLB(simTime()));

    char packetName[50];
    sprintf(packetName, "%d=%f", matlabID, matlabData);
    TEPacket *msg = new TEPacket();
    msg->setName(packetName);
    msg->setKind(1);


    // Send packet
    // TODO: Fix the length of the packet
    int numBytes = 7;
    int expectedReplyBytes = 0;

    EV << "sending " << numBytes << " bytes, expecting " << expectedReplyBytes << "\n";

    msg->setByteLength(numBytes);
    msg->setExpectedReplyLength(expectedReplyBytes);

    emit(sentPkSignal, msg);
    socket.send(msg);

    packetsSent++;
    bytesSent += numBytes;
    cMessage *selfMsg = new cMessage();

    scheduleAt(simTime() + delay, selfMsg);
}

void TCPSensorApp::handleTimer(cMessage *msg)
{
    switch (msg->getKind())
    {
        case MSGKIND_CONNECT:
            EV << "starting session\n";
            connect(); // active OPEN

            // significance of earlySend: if true, data will be sent already
            // in the ACK of SYN, otherwise only in a separate packet (but still
            // immediately)
            if (earlySend)
                sendRequest();
            break;

        case MSGKIND_SEND:
           sendRequest();
           numRequestsToSend--;
           // no scheduleAt(): next request will be sent when reply to this one
           // arrives (see socketDataArrived())
           break;

        default:
            throw cRuntimeError("Invalid timer msg: kind=%d", msg->getKind());
    }
}

void TCPSensorApp::socketEstablished(int connId, void *ptr)
{
    TCPGenericCliAppBase::socketEstablished(connId, ptr);

    // determine number of requests in this session
    numRequestsToSend = (long) par("numRequestsPerSession");
    if (numRequestsToSend < 1)
        numRequestsToSend = 1;

    // perform first request if not already done (next one will be sent when reply arrives)
    if (!earlySend)
        sendRequest();

    numRequestsToSend--;
}

void TCPSensorApp::rescheduleOrDeleteTimer(simtime_t d, short int msgKind)
{
    cancelEvent(timeoutMsg);

    timeoutMsg->setKind(msgKind);
    scheduleAt(d, timeoutMsg);

}

void TCPSensorApp::socketDataArrived(int connId, void *ptr, cPacket *msg, bool urgent)
{
    TCPGenericCliAppBase::socketDataArrived(connId, ptr, msg, urgent);

    //if (numRequestsToSend > 0)
    //{
        EV << "reply arrived\n";

        if (timeoutMsg)
        {
            simtime_t d = simTime() + (simtime_t) par("thinkTime");
            rescheduleOrDeleteTimer(d, MSGKIND_SEND);
        }
    //}
    //else if (socket.getState() != TCPSocket::LOCALLY_CLOSED)
    //{
    //    EV << "reply to last request arrived, closing session\n";
    //    close();
    //}
}

void TCPSensorApp::socketClosed(int connId, void *ptr)
{
    TCPGenericCliAppBase::socketClosed(connId, ptr);

    // start another session after a delay
    if (timeoutMsg)
    {
        simtime_t d = simTime() + (simtime_t) par("idleInterval");
        rescheduleOrDeleteTimer(d, MSGKIND_CONNECT);
    }
}

void TCPSensorApp::socketFailure(int connId, void *ptr, int code)
{
    TCPGenericCliAppBase::socketFailure(connId, ptr, code);

    // reconnect after a delay
    if (timeoutMsg)
    {
        simtime_t d = simTime() + (simtime_t) par("reconnectInterval");
        rescheduleOrDeleteTimer(d, MSGKIND_CONNECT);
    }
}

