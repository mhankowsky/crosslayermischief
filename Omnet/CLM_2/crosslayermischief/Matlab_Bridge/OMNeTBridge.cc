/* OMNeTBridge class
 *
 * Michael Rosen
 * mrrosen
 * 4-27-2014
 *
 */

#include "OMNeTBridge.h"

OMNeTBridge controlBridge(BRIDGETYPE_CONTROL);
OMNeTBridge systemBridge(BRIDGETYPE_SYSTEM);

/* Constructor */
OMNeTBridge::OMNeTBridge(int cType) {
  /* Local vars */
  OMNeTPk pk ("UPDATE");
  OMNeTPk* rpk;
  float dt = 0.0001;

  /* Set the type of this bridge */
  t = cType;

  /* Make a new pipe */
  if (cType == BRIDGETYPE_CONTROL) {
	pipe = new OMNeTPipe("localhost", PORT_CONTROL);
  }
  else {
	pipe = new OMNeTPipe("localhost", PORT_SYSTEM);
  }

  /* Initialize the connection and MATLAB model */
  pk.addVal("id", (void*)1, TYPE_INT);
  pk.addVal("dt", FLOAT(dt), TYPE_FLOAT);
  pipe->sendPk(pk);

  /* Receive the status packet with everything inside */
  rpk = pipe->recvPk();

  var[TEVAR_U_1] = rpk->getVal("u_1");
  var[TEVAR_U_2] = rpk->getVal("u_2");
  var[TEVAR_U_3] = rpk->getVal("u_3");
  var[TEVAR_U_4] = rpk->getVal("u_4");
  var[TEVAR_F_1] = rpk->getVal("f_1");
  var[TEVAR_F_2] = rpk->getVal("f_2");
  var[TEVAR_F_3] = rpk->getVal("f_3");
  var[TEVAR_F_4] = rpk->getVal("f_4");
  var[TEVAR_P] = rpk->getVal("P");
  var[TEVAR_V_L] = rpk->getVal("v_L");
  var[TEVAR_Y_A3] = rpk->getVal("y_a3");
  var[TEVAR_Y_B3] = rpk->getVal("y_b3");
  var[TEVAR_Y_C3] = rpk->getVal("y_c3");
  var[TEVAR_C] = rpk->getVal("C");
  
  delete rpk;
}

/* Gats a variable from the current state after updating the state */
float OMNeTBridge::getVal(int v, float simTime) {
  /* Local vars */
  OMNeTPk pk ("UPDATE");
  OMNeTPk* rpk;
  float dt = simTime - time;

  /* Update time */
  time = simTime;

  /* Initialize the connection and MATLAB model */
  pk.addVal("id", (void*)1, TYPE_INT);
  pk.addVal("dt", FLOAT(dt), TYPE_FLOAT);
  pipe->sendPk(pk);

  /* Receive the status packet with everything inside */
  rpk = pipe->recvPk();

  var[TEVAR_U_1] = rpk->getVal("u_1");
  var[TEVAR_U_2] = rpk->getVal("u_2");
  var[TEVAR_U_3] = rpk->getVal("u_3");
  var[TEVAR_U_4] = rpk->getVal("u_4");
  var[TEVAR_F_1] = rpk->getVal("f_1");
  var[TEVAR_F_2] = rpk->getVal("f_2");
  var[TEVAR_F_3] = rpk->getVal("f_3");
  var[TEVAR_F_4] = rpk->getVal("f_4");
  var[TEVAR_P] = rpk->getVal("P");
  var[TEVAR_V_L] = rpk->getVal("v_L");
  var[TEVAR_Y_A3] = rpk->getVal("y_a3");
  var[TEVAR_Y_B3] = rpk->getVal("y_b3");
  var[TEVAR_Y_C3] = rpk->getVal("y_c3");
  var[TEVAR_C] = rpk->getVal("C");

  delete rpk;
  
  return ((float*) var)[v];  
}

/* Sets a varue in the bridge and sends it to MATLAB */
void OMNeTBridge::setVal(int v, float tv, float simTime) {
  /* Local vars */
  OMNeTPk pk ("CHANGE");
  OMNeTPk* rpk;
  float dt = simTime - time;

  /* Update time */
  time = simTime;

  /* Set the varue */
  ((float*) var)[v] = tv;

  /* Initialize the connection and MATLAB model */
  pk.addVal("id", (void*)1, TYPE_INT);
  pk.addVal("dt", FLOAT(dt), TYPE_FLOAT);

  /* Add the needed variables */
  if (t == BRIDGETYPE_CONTROL) {
	pk.addVal("f_1", FLOAT(var[TEVAR_F_1]), TYPE_FLOAT);
	pk.addVal("f_2", FLOAT(var[TEVAR_F_2]), TYPE_FLOAT);
	pk.addVal("f_3", FLOAT(var[TEVAR_F_3]), TYPE_FLOAT);
	pk.addVal("f_4", FLOAT(var[TEVAR_F_4]), TYPE_FLOAT);
	pk.addVal("P", FLOAT(var[TEVAR_P]), TYPE_FLOAT);
	pk.addVal("v_l", FLOAT(var[TEVAR_V_L]), TYPE_FLOAT);
	pk.addVal("y_a3", FLOAT(var[TEVAR_Y_A3]), TYPE_FLOAT);
	pk.addVal("y_b3", FLOAT(var[TEVAR_Y_B3]), TYPE_FLOAT);
	pk.addVal("y_c3", FLOAT(var[TEVAR_Y_C3]), TYPE_FLOAT);
	pk.addVal("C", FLOAT(var[TEVAR_C]), TYPE_FLOAT);
  }
  else {
	pk.addVal("u_1", FLOAT(var[TEVAR_U_1]), TYPE_FLOAT);
	pk.addVal("u_2", FLOAT(var[TEVAR_U_2]), TYPE_FLOAT);
	pk.addVal("u_3", FLOAT(var[TEVAR_U_3]), TYPE_FLOAT);
	pk.addVal("u_4", FLOAT(var[TEVAR_U_4]), TYPE_FLOAT);
  }

  pipe->sendPk(pk);

  /* Receive the status packet with everything inside */
  rpk = pipe->recvPk();

  var[TEVAR_U_1] = rpk->getVal("u_1");
  var[TEVAR_U_2] = rpk->getVal("u_2");
  var[TEVAR_U_3] = rpk->getVal("u_3");
  var[TEVAR_U_4] = rpk->getVal("u_4");
  var[TEVAR_F_1] = rpk->getVal("f_1");
  var[TEVAR_F_2] = rpk->getVal("f_2");
  var[TEVAR_F_3] = rpk->getVal("f_3");
  var[TEVAR_F_4] = rpk->getVal("f_4");
  var[TEVAR_P] = rpk->getVal("P");
  var[TEVAR_V_L] = rpk->getVal("v_L");
  var[TEVAR_Y_A3] = rpk->getVal("y_a3");
  var[TEVAR_Y_B3] = rpk->getVal("y_b3");
  var[TEVAR_Y_C3] = rpk->getVal("y_c3");
  var[TEVAR_C] = rpk->getVal("C");

  delete rpk;
  
  return;
}
