CFILES = st.c memory.c names.c news.c interp.c tty.c primitive.c filein.c lex.c parser.c unixio.c

CFLAGS=-O0 -g3 -Wall -Werror

all: image

mio:
	gcc -o $@ $(CFLAGS) $(addprefix src/, $(CFILES)) -lm

image: mio
	@echo Creating initial image . . .
	./mio stlib/*

format:
	cd src && astyle -A1 *

clean:
	@-rm -f *.o 2>/dev/null
	@-rm mio 2>/dev/null

test:
	echo '1+1' | ./mio | $(TEE) $@.out
	$(DIFF) $@.ref $@.out
	rm -f $@.out

.PHONY: test clean
