CFILES = st.c memory.c names.c news.c interp.c tty.c primitive.c filein.c lex.c parser.c unixio.c

CFLAGS=-O0 -g3 -Wall -Werror

TEST_FILES := $(wildcard test/*.mio)
RES_FILES := $(addprefix test/,$(notdir $(TEST_FILES:.mio=.ref)))
OUT_FILES := $(addprefix test/,$(notdir $(TEST_FILES:.mio=.out)))

all: image

mio:
	gcc -o $@ $(CFLAGS) $(addprefix src/, $(CFILES)) -lm

image: mio
	@echo Creating initial image . . .
	./mio stlib/*

format:
	cd src && astyle -A1 *

clean:
	@-rm -f systemImage *.o 2>/dev/null
	@-rm mio 2>/dev/null
	@-rm test/*.out test/differ

test: mio $(OUT_FILES)
	@echo " "
	@echo "Finished Testing (0 = good, 1 = failed)"
	@cat test/differ

%.out: %.mio
	@cat $< | ./mio > $@ 2>&1
	@diff -c $@ $(basename $@).ref >> test/differ 2>&1; echo -n $$?

.PHONY: test clean
