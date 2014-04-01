/* OMNeTPipe class
 *
 *
 * Michael Rosen
 * mrrosen
 * 3-8-2014
 *
 */

#include "OMNeTPipe.hpp"
#include <stdio.h>
 
/* Constructor */
OMNeTPipe::OMNeTPipe(char* host, int port) {
	/* Local vars */
	char c;
	string sHost(host);
	sk = new TCPSocket(sHost, port);
	
	/* Read synchronizing byte */
	sk->recv(&c, 1);
 }
 
/* sendPk
 * @brief send a packet to the remote side
 *
 * @param header name of the packet
 * @param pk the packet itself
 * @return 0 on success, -1 on failure
 */
int OMNeTPipe::sendPk(OMNeTPk pk) {
	/* Local vars */
	int i;
	int s;
	int t;
	
	int x;
	float f;
	double* d;
	char* st;
	void* v;
	char pk_str[MAX_PK_SIZE];
	char buf[MAX_PK_SIZE];
	
	/* Form header */
	sprintf(pk_str, "%c%s%c", MSG_BEGIN, pk.getHeader(), MSG_FIELDSEP);
	
	/* Form packet string */
	for (i = 0; i < pk.getSize(); i++) {
		/* Add an element */
		t = pk.getType(pk.getName(i));
		
		switch (t) {
			case TYPE_INT:
				x = reinterpret_cast<int>(pk.getVal(pk.getName(i)));
				sprintf(buf, "%c%s%c%i%c%i",
				MSG_FIELDSEP,
				pk.getName(i),
				MSG_INTSEP,
				x,
				MSG_INTSEP,
				t);
				break;
			case TYPE_FLOAT:
				v = pk.getVal(pk.getName(i));
				f = *(reinterpret_cast<float*>(&v));
				sprintf(buf, "%c%s%c%f%c%i",
				MSG_FIELDSEP,
				pk.getName(i),
				MSG_INTSEP,
				f,
				MSG_INTSEP,
				t);
				break;
			case TYPE_DOUBLE:
				d = reinterpret_cast<double*>(pk.getVal(pk.getName(i)));
				sprintf(buf, "%c%s%c%f%c%i",
				MSG_FIELDSEP,
				pk.getName(i),
				MSG_INTSEP,
				*d,
				MSG_INTSEP,
				t);
				break;
			case TYPE_STR:
				st = reinterpret_cast<char*>(pk.getVal(pk.getName(i)));
				sprintf(buf, "%c%s%c%s%c%i",
				MSG_FIELDSEP,
				pk.getName(i),
				MSG_INTSEP,
				st,
				MSG_INTSEP,
				t);
				break;
		}
			
		strcat(pk_str, buf);
	}
	
	/* Add terminator */
	s = strlen(pk_str);
	pk_str[s] = MSG_END;
	pk_str[s+1] = '\0';
	
	/* Send data */
	sk->send(pk_str, strlen(pk_str));
	
	return 0;
}
  
/* recvPk
 * @brief receive a packet from the remote side
 *
 * @return the next packet
 */
OMNeTPk* OMNeTPipe::recvPk(void) {
	/* Local vars */
	char pk_str[MAX_PK_SIZE];
	char buf[MAX_PK_SIZE];
	char name[MAX_PK_SIZE];
	char val[MAX_PK_SIZE];
	char t[MAX_PK_SIZE];
	char c;
	int s;
	int ss;
	int i;
	int n;
	void* v;
	float f;
	int num_fields;
	
	/* Read out the string from the socket */
	num_fields = 0;
	do {
		sk->recv(&c, 1);
		
		s = strlen(pk_str);
		pk_str[s] = c;
		pk_str[s+1] = '\0';
		
		/* Count the number of items in the packet */
		if (c == MSG_FIELDSEP) {
			num_fields++;
		}
	} while (c != MSG_END);
	
	/* Process the string */
	
	/* Parse out the header */
	buf[0] = '\0';
	s = 0;
	i = 1;
	do {
		buf[s] = pk_str[i];
		buf[s+1] = '\0';
		
		s++;
		i++;
	} while (pk_str[i] != MSG_FIELDSEP);
	i++;
	
	/* Create a new packet */
	OMNeTPk* pk = new OMNeTPk(buf);
	
	/* Parse and add each to the packet */
	for (n = 0; n < num_fields; n++) {
		/* Get the entire variable */
		buf[0] = '\0';
		s = 0;
		do {
			buf[s] = pk_str[i];
			buf[s+1] = '\0';
		
			s++;
			i++;
		} while ((pk_str[i] != MSG_FIELDSEP) || (pk_str[i] != MSG_END));
		i++;
		
		/* Parse the buffer */
		
		/* Fill in the name */
		name[0] = '\0';
		s = 0;
		ss = 0;
		do {
			name[s] = buf[ss];
			name[s+1] = '\0';
			
			s++;
			ss++;
		} while (buf[ss] != MSG_INTSEP);
		ss++;
		
		/* Fill in the val */
		val[0] = '\0';
		s = 0;
		do {
			val[s] = buf[ss];
			val[s+1] = '\0';
			
			s++;
			ss++;
		} while (buf[ss] != MSG_INTSEP);
		ss++;
		
		/* Fill in the type */
		t[0] = '\0';
		s = 0;
		do {
			t[s] = buf[ss];
			t[s+1] = '\0';
			
			s++;
			ss++;
		} while (buf[ss] != '\0');
		
		/* Get the type, and process the value accordingly */
		ss = atoi(t);
		
		switch (ss) {
			case TYPE_INT:
				v = reinterpret_cast<void*>(atoi(val));
				break;
			case TYPE_FLOAT:
				f = static_cast<float>(atoi(val));
				v = reinterpret_cast<void*>(&f);
				break;
			case TYPE_DOUBLE:
				//v = reinterpret_cast<void*>(atof(val));
				break;
			case TYPE_STR:
				v = val;
				break;
		}
		
		pk->addVal(name, v, ss);
		
		s = 0;
	}
			
	return pk;
}