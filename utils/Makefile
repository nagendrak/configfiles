CC=gcc
CXX=g++
RM=rm -f
CPPFLAGS=-g -I../eigen-eigen-5a0156e40feb/
LDFLAGS=-g
LDLIBS=-L/./

SRCS=diffusion_1d_implicit.cpp
OBJS=$(subst .cpp,.o,$(SRCS))

all: diffusion_solve

diffusion_solve: $(OBJS)
	$(CXX) $(LDFLAGS) -o diffusion_solve $(OBJS) $(LDLIBS)

depend: .depend

.depend: $(SRCS)
	$(RM) ./.depend
	$(CXX) $(CPPFLAGS) -MM $^>>./.depend;

clean:
	$(RM) $(OBJS)

distclean: clean
	$(RM) *~ .depend

include .depend
