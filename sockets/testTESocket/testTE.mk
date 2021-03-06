# A template C++ Makefile for your SAT solver.

# Debugging flags
FLAGS=-m32 -Wall -Wold-style-cast -Wformat=2 -ansi -pedantic -ggdb3 -DDEBUG

# Optimizing flags
#FLAGS=-Wall -Wold-style-cast -Wformat=2 -ansi -pedantic -O3

# List all the .o files you need to build here
OBJS=OMNeTPipe.o testTE.o OMNeTPk.o Sockets.o

# This is the name of the executable file that gets built.  Please
# don't change it.
EXENAME=test_TE

# Compile targets
all: $(OBJS)
	g++ $(FLAGS) $(OBJS) -lz -o $(EXENAME)
OMNeTPk.o: OMNeTPk.cpp OMNeTPk.hpp
	g++ $(FLAGS) -c OMNeTPk.cpp
testTE.o: testTE.cpp
	g++ $(FLAGS) -c testTE.cpp
OMNeTPipe.o: OMNeTPipe.cpp OMNeTPipe.hpp
	g++ $(FLAGS) -c OMNeTPipe.cpp
Sockets.o: Sockets.cpp Sockets.hpp
	g++ $(FLAGS) -c Sockets.cpp
# Add more compilation targets here



# The "phony" `clean' compilation target.  Type `make clean' to remove
# your object files and your executable.
.PHONY: clean
clean:
	rm -rf $(OBJS) $(EXENAME)
