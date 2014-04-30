//
// Generated file, do not edit! Created by opp_msgc 4.4 from applications/tcpapp/GenericDataPacket.msg.
//

#ifndef _TEPacket_H_
#define _TEPacket_H_

#include <omnetpp.h>



// dll export symbol
#ifndef INET_API 
#  if defined(INET_EXPORT)
#    define INET_API  OPP_DLLEXPORT
#  elif defined(INET_IMPORT)
#    define INET_API  OPP_DLLIMPORT
#  else
#    define INET_API 
#  endif
#endif

// cplusplus {{
#include "INETDefs.h"
// }}



/**
 * Class generated from <tt>applications/tcpapp/GenericDataPacket.msg</tt> by opp_msgc.
 * <pre>
 * packet GenericDataPacket
 * {
 *     int expectedReplyLength; 
 *     double replyDelay;       
 *     bool serverClose;        
 *                              
 * }
 * </pre>
 */
class INET_API TEPacket : public ::cPacket
{
  protected:
    int expectedReplyLength_var;
    double replyDelay_var;
    bool serverClose_var;
    int src;
    int dest;
    float data;

  private:
    void copy(const TEPacket& other);

  protected:
    // protected and unimplemented operator==(), to prevent accidental usage
    bool operator==(const TEPacket&);

  public:
    TEPacket(const char *name=NULL, int kind=0);
    TEPacket(const TEPacket& other);
    virtual ~TEPacket();
    TEPacket& operator=(const TEPacket& other);
    virtual TEPacket *dup() const {return new TEPacket(*this);}
    virtual void parsimPack(cCommBuffer *b);
    virtual void parsimUnpack(cCommBuffer *b);

    // field getter/setter methods
    virtual int getExpectedReplyLength() const;
    virtual void setExpectedReplyLength(int expectedReplyLength);
    virtual double getReplyDelay() const;
    virtual void setReplyDelay(double replyDelay);
    virtual bool getServerClose() const;
    virtual void setServerClose(bool serverClose);
    virtual int getSourceId();
    virtual int getDestId();
    virtual float getData();
    virtual void setSourceId(int);
    virtual void setDestId(int);
    virtual void setData(float);
};

inline void doPacking(cCommBuffer *b, TEPacket& obj) {obj.parsimPack(b);}
inline void doUnpacking(cCommBuffer *b, TEPacket& obj) {obj.parsimUnpack(b);}


#endif // _TEPacket_H_
