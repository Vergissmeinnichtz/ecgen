
CC=gcc
GP2C=gp2c

INCLUDES=-I.

CFLAGS=$(INCLUDES) -g -O3 -Wall
GP_CFLAGS=$(INCLUDES) -g -O3 -Wall -fomit-frame-pointer -fno-strict-aliasing -fPIC
GPFLAGS=-g

LIBS=-lpari -lreadline -ltermcap

GP = gp
GPC = $(addsuffix .c, $(GP))
GPO = $(addsuffix .o, $(GP))
GPH = $(addsuffix .h, $(GP))

all: ecgen

ecgen: ecgen.o $(GPO)
	$(CC) $(CFLAGS) -o $@ $^ $(LIBS)

gp2c: $(GPC) $(GPH)

$(GPO): $(GPC) $(GPH)
	$(CC) $(GP_CFLAGS) -c -o $@ $< $(LIBS)

%.o: %.c $(GPH)
	$(CC) $(CFLAGS) -c -o $@ $< $(LIBS)

%.h %.c: %.gp
	$(GP2C) $*.gp $(GPFLAGS) 2>/dev/null | { sed -u '/\/\*End of prototype\*\//q' >"$*.h"; echo '#include "$*.h"' >"$*.c"; cat >>"$*.c"; }

.PHONY: clean-all clean clean-gp

clean-all: clean clean-gp

clean:
	rm -f ecgen
	rm -f *.o

clean-gp:
	rm -f $(GPH)
	rm -f $(GPC)
	rm -f $(GPO)
