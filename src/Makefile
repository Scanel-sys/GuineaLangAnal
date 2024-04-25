
CC = gcc

BUILDDIR = build
SRCDIR = src

LEX = flex
LEX_FILES = lang.lex
BISON = bison
PARSER_FILE = parser.y
SRC = main.c lex.yy.c parser.tab.c
TARGET = GuineaAnal

all: clean build

build:
	$(BISON) -Wcounterexamples -d $(PARSER_FILE)
	$(LEX) $(LEX_FILES)
	$(CC) $(SRC) -lm -o $(TARGET)

clean:
	rm -f parser.tab.c
	rm -f parser.tab.h
	rm -f lex.yy.c
