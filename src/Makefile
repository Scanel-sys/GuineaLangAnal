
CC = gcc

BUILDDIR = build
SRCDIR = src

LEX = flex
LEX_FILES = lang.l
BISON = bison
PARSER_FILE = parser.y
SRC = GuineaLang.c parser.tab.c lex.yy.c 
TARGET = GuineaAnal

all: clean build

build:
	$(BISON) -Wcounterexamples -d $(PARSER_FILE)
	@echo "-----------------------------------------"
	$(LEX) $(LEX_FILES)
	@echo "-----------------------------------------"
	$(CC) $(SRC) -lm -o $(TARGET)

clean:
	rm -f parser.tab.c
	rm -f parser.tab.h
	rm -f lex.yy.c
