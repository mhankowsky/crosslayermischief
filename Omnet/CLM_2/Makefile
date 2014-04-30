#
# OMNeT++/OMNEST Makefile for CLM_2
#
# This file was generated with the command:
#  opp_makemake -f --deep -O out -I../inet/src/linklayer/ethernet -I../inet/src/linklayer/ieee80211/radio -I../inet/src/networklayer/common -I../inet/src -I../inet/src/networklayer/icmpv6 -I../inet/src/world/obstacles -I../inet/src/networklayer/xmipv6 -I../inet/src/networklayer/contract -I../inet/src/mobility -I../inet/src/networklayer/manetrouting/base -I../inet/src/networklayer/autorouting/ipv4 -I../inet/src/linklayer/ieee80211/mgmt -I../inet/src/util -I../inet/src/linklayer/common -I../inet/src/transport/contract -I../inet/src/status -I../inet/src/applications/tcpapp -I../inet/src/linklayer/radio/propagation -I../inet/src/linklayer/ieee80211/radio/errormodel -I../inet/src/linklayer/radio -I../inet/src/util/headerserializers/tcp -I../inet/src/networklayer/ipv4 -I../inet/src/util/headerserializers/ipv4 -I../inet/src/base -I../inet/src/util/headerserializers -I../inet/src/world/radio -I../inet/src/linklayer/ieee80211/mac -I../inet/src/networklayer/ipv6 -I../inet/src/transport/sctp -I../inet/src/util/headerserializers/udp -I../inet/src/networklayer/ipv6tunneling -I../inet/src/battery/models -I../inet/src/applications/pingapp -I../inet/src/util/headerserializers/sctp -I../inet/src/linklayer/contract -I../inet/src/transport/tcp_common -I../inet/src/networklayer/arp -I../inet/src/transport/udp -L../inet/out/$$\(CONFIGNAME\)/src -linet -DINET_IMPORT -KINET_PROJ=../inet
#

# Name of target to be created (-o option)
TARGET = CLM_2$(EXE_SUFFIX)

# User interface (uncomment one) (-u option)
USERIF_LIBS = $(ALL_ENV_LIBS) # that is, $(TKENV_LIBS) $(CMDENV_LIBS)
#USERIF_LIBS = $(CMDENV_LIBS)
#USERIF_LIBS = $(TKENV_LIBS)

# C++ include paths (with -I)
INCLUDE_PATH = \
    -I../inet/src/linklayer/ethernet \
    -I../inet/src/linklayer/ieee80211/radio \
    -I../inet/src/networklayer/common \
    -I../inet/src \
    -I../inet/src/networklayer/icmpv6 \
    -I../inet/src/world/obstacles \
    -I../inet/src/networklayer/xmipv6 \
    -I../inet/src/networklayer/contract \
    -I../inet/src/mobility \
    -I../inet/src/networklayer/manetrouting/base \
    -I../inet/src/networklayer/autorouting/ipv4 \
    -I../inet/src/linklayer/ieee80211/mgmt \
    -I../inet/src/util \
    -I../inet/src/linklayer/common \
    -I../inet/src/transport/contract \
    -I../inet/src/status \
    -I../inet/src/applications/tcpapp \
    -I../inet/src/linklayer/radio/propagation \
    -I../inet/src/linklayer/ieee80211/radio/errormodel \
    -I../inet/src/linklayer/radio \
    -I../inet/src/util/headerserializers/tcp \
    -I../inet/src/networklayer/ipv4 \
    -I../inet/src/util/headerserializers/ipv4 \
    -I../inet/src/base \
    -I../inet/src/util/headerserializers \
    -I../inet/src/world/radio \
    -I../inet/src/linklayer/ieee80211/mac \
    -I../inet/src/networklayer/ipv6 \
    -I../inet/src/transport/sctp \
    -I../inet/src/util/headerserializers/udp \
    -I../inet/src/networklayer/ipv6tunneling \
    -I../inet/src/battery/models \
    -I../inet/src/applications/pingapp \
    -I../inet/src/util/headerserializers/sctp \
    -I../inet/src/linklayer/contract \
    -I../inet/src/transport/tcp_common \
    -I../inet/src/networklayer/arp \
    -I../inet/src/transport/udp \
    -I. \
    -Icrosslayermischief \
    -Icrosslayermischief/Matlab_Bridge \
    -Icrosslayermischief/results

# Additional object and library files to link with
EXTRA_OBJS =

# Additional libraries (-L, -l options)
LIBS = -L../inet/out/$(CONFIGNAME)/src  -linet
LIBS += -Wl,-rpath,`abspath ../inet/out/$(CONFIGNAME)/src`

# Output directory
PROJECT_OUTPUT_DIR = out
PROJECTRELATIVE_PATH =
O = $(PROJECT_OUTPUT_DIR)/$(CONFIGNAME)/$(PROJECTRELATIVE_PATH)

# Object files for local .cc and .msg files
OBJS = \
    $O/crosslayermischief/TCPActuatorApp.o \
    $O/crosslayermischief/TCPSensorApp.o \
    $O/crosslayermischief/TEPacket.o \
    $O/crosslayermischief/TCPControllerApp.o \
    $O/crosslayermischief/Matlab_Bridge/OMNeTPk.o \
    $O/crosslayermischief/Matlab_Bridge/OMNeTBridge.o \
    $O/crosslayermischief/Matlab_Bridge/Sockets.o \
    $O/crosslayermischief/Matlab_Bridge/OMNeTPipe.o

# Message files
MSGFILES =

# Other makefile variables (-K)
INET_PROJ=../inet

#------------------------------------------------------------------------------

# Pull in OMNeT++ configuration (Makefile.inc or configuser.vc)

ifneq ("$(OMNETPP_CONFIGFILE)","")
CONFIGFILE = $(OMNETPP_CONFIGFILE)
else
ifneq ("$(OMNETPP_ROOT)","")
CONFIGFILE = $(OMNETPP_ROOT)/Makefile.inc
else
CONFIGFILE = $(shell opp_configfilepath)
endif
endif

ifeq ("$(wildcard $(CONFIGFILE))","")
$(error Config file '$(CONFIGFILE)' does not exist -- add the OMNeT++ bin directory to the path so that opp_configfilepath can be found, or set the OMNETPP_CONFIGFILE variable to point to Makefile.inc)
endif

include $(CONFIGFILE)

# Simulation kernel and user interface libraries
OMNETPP_LIB_SUBDIR = $(OMNETPP_LIB_DIR)/$(TOOLCHAIN_NAME)
OMNETPP_LIBS = -L"$(OMNETPP_LIB_SUBDIR)" -L"$(OMNETPP_LIB_DIR)" -loppmain$D $(USERIF_LIBS) $(KERNEL_LIBS) $(SYS_LIBS)

COPTS = $(CFLAGS) -DINET_IMPORT $(INCLUDE_PATH) -I$(OMNETPP_INCL_DIR)
MSGCOPTS = $(INCLUDE_PATH)

# we want to recompile everything if COPTS changes,
# so we store COPTS into $COPTS_FILE and have object
# files depend on it (except when "make depend" was called)
COPTS_FILE = $O/.last-copts
ifneq ($(MAKECMDGOALS),depend)
ifneq ("$(COPTS)","$(shell cat $(COPTS_FILE) 2>/dev/null || echo '')")
$(shell $(MKPATH) "$O" && echo "$(COPTS)" >$(COPTS_FILE))
endif
endif

#------------------------------------------------------------------------------
# User-supplied makefile fragment(s)
# >>>
# <<<
#------------------------------------------------------------------------------

# Main target
all: $O/$(TARGET)
	$(Q)$(LN) $O/$(TARGET) .

$O/$(TARGET): $(OBJS)  $(wildcard $(EXTRA_OBJS)) Makefile
	@$(MKPATH) $O
	@echo Creating executable: $@
	$(Q)$(CXX) $(LDFLAGS) -o $O/$(TARGET)  $(OBJS) $(EXTRA_OBJS) $(AS_NEEDED_OFF) $(WHOLE_ARCHIVE_ON) $(LIBS) $(WHOLE_ARCHIVE_OFF) $(OMNETPP_LIBS)

.PHONY: all clean cleanall depend msgheaders

.SUFFIXES: .cc

$O/%.o: %.cc $(COPTS_FILE)
	@$(MKPATH) $(dir $@)
	$(qecho) "$<"
	$(Q)$(CXX) -c $(CXXFLAGS) $(COPTS) -o $@ $<

%_m.cc %_m.h: %.msg
	$(qecho) MSGC: $<
	$(Q)$(MSGC) -s _m.cc $(MSGCOPTS) $?

msgheaders: $(MSGFILES:.msg=_m.h)

clean:
	$(qecho) Cleaning...
	$(Q)-rm -rf $O
	$(Q)-rm -f CLM_2 CLM_2.exe libCLM_2.so libCLM_2.a libCLM_2.dll libCLM_2.dylib
	$(Q)-rm -f ./*_m.cc ./*_m.h
	$(Q)-rm -f crosslayermischief/*_m.cc crosslayermischief/*_m.h
	$(Q)-rm -f crosslayermischief/Matlab_Bridge/*_m.cc crosslayermischief/Matlab_Bridge/*_m.h
	$(Q)-rm -f crosslayermischief/results/*_m.cc crosslayermischief/results/*_m.h

cleanall: clean
	$(Q)-rm -rf $(PROJECT_OUTPUT_DIR)

depend:
	$(qecho) Creating dependencies...
	$(Q)$(MAKEDEPEND) $(INCLUDE_PATH) -f Makefile -P\$$O/ -- $(MSG_CC_FILES)  ./*.cc crosslayermischief/*.cc crosslayermischief/Matlab_Bridge/*.cc crosslayermischief/results/*.cc

# DO NOT DELETE THIS LINE -- make depend depends on it.
$O/crosslayermischief/TCPActuatorApp.o: crosslayermischief/TCPActuatorApp.cc \
	crosslayermischief/Matlab_Bridge/OMNeTBridge.h \
	crosslayermischief/Matlab_Bridge/OMNeTPipe.h \
	crosslayermischief/Matlab_Bridge/OMNeTPk.h \
	crosslayermischief/Matlab_Bridge/Sockets.h \
	crosslayermischief/TCPActuatorApp.h \
	crosslayermischief/TEPacket.h \
	$(INET_PROJ)/src/applications/tcpapp/GenericAppMsg_m.h \
	$(INET_PROJ)/src/base/ILifecycle.h \
	$(INET_PROJ)/src/base/INETDefs.h \
	$(INET_PROJ)/src/base/LifecycleOperation.h \
	$(INET_PROJ)/src/base/ModuleAccess.h \
	$(INET_PROJ)/src/networklayer/contract/IPv4Address.h \
	$(INET_PROJ)/src/networklayer/contract/IPv6Address.h \
	$(INET_PROJ)/src/networklayer/contract/IPvXAddress.h \
	$(INET_PROJ)/src/status/NodeStatus.h \
	$(INET_PROJ)/src/transport/contract/TCPCommand_m.h \
	$(INET_PROJ)/src/transport/contract/TCPSocket.h
$O/crosslayermischief/TCPControllerApp.o: crosslayermischief/TCPControllerApp.cc \
	crosslayermischief/TCPControllerApp.h \
	crosslayermischief/TEPacket.h \
	$(INET_PROJ)/src/applications/tcpapp/GenericAppMsg_m.h \
	$(INET_PROJ)/src/base/INETDefs.h \
	$(INET_PROJ)/src/networklayer/contract/IPv4Address.h \
	$(INET_PROJ)/src/networklayer/contract/IPv6Address.h \
	$(INET_PROJ)/src/networklayer/contract/IPvXAddress.h \
	$(INET_PROJ)/src/networklayer/contract/IPvXAddressResolver.h \
	$(INET_PROJ)/src/transport/contract/TCPCommand_m.h \
	$(INET_PROJ)/src/transport/contract/TCPSocket.h
$O/crosslayermischief/TCPSensorApp.o: crosslayermischief/TCPSensorApp.cc \
	crosslayermischief/Matlab_Bridge/OMNeTBridge.h \
	crosslayermischief/Matlab_Bridge/OMNeTPipe.h \
	crosslayermischief/Matlab_Bridge/OMNeTPk.h \
	crosslayermischief/Matlab_Bridge/Sockets.h \
	crosslayermischief/TCPSensorApp.h \
	crosslayermischief/TEPacket.h \
	$(INET_PROJ)/src/applications/tcpapp/TCPGenericCliAppBase.h \
	$(INET_PROJ)/src/base/ILifecycle.h \
	$(INET_PROJ)/src/base/INETDefs.h \
	$(INET_PROJ)/src/base/LifecycleOperation.h \
	$(INET_PROJ)/src/base/ModuleAccess.h \
	$(INET_PROJ)/src/base/NodeOperations.h \
	$(INET_PROJ)/src/networklayer/contract/IPv4Address.h \
	$(INET_PROJ)/src/networklayer/contract/IPv6Address.h \
	$(INET_PROJ)/src/networklayer/contract/IPvXAddress.h \
	$(INET_PROJ)/src/status/NodeStatus.h \
	$(INET_PROJ)/src/transport/contract/TCPCommand_m.h \
	$(INET_PROJ)/src/transport/contract/TCPSocket.h
$O/crosslayermischief/TEPacket.o: crosslayermischief/TEPacket.cc \
	crosslayermischief/TEPacket.h \
	$(INET_PROJ)/src/base/INETDefs.h
$O/crosslayermischief/Matlab_Bridge/OMNeTBridge.o: crosslayermischief/Matlab_Bridge/OMNeTBridge.cc \
	crosslayermischief/Matlab_Bridge/OMNeTBridge.h \
	crosslayermischief/Matlab_Bridge/OMNeTPipe.h \
	crosslayermischief/Matlab_Bridge/OMNeTPk.h \
	crosslayermischief/Matlab_Bridge/Sockets.h
$O/crosslayermischief/Matlab_Bridge/OMNeTPipe.o: crosslayermischief/Matlab_Bridge/OMNeTPipe.cc \
	crosslayermischief/Matlab_Bridge/OMNeTPipe.h \
	crosslayermischief/Matlab_Bridge/OMNeTPk.h \
	crosslayermischief/Matlab_Bridge/Sockets.h
$O/crosslayermischief/Matlab_Bridge/OMNeTPk.o: crosslayermischief/Matlab_Bridge/OMNeTPk.cc \
	crosslayermischief/Matlab_Bridge/OMNeTPk.h
$O/crosslayermischief/Matlab_Bridge/Sockets.o: crosslayermischief/Matlab_Bridge/Sockets.cc \
	crosslayermischief/Matlab_Bridge/Sockets.h

