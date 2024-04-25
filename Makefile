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
	mkdir -pv $(BUILDDIR)
	$(MAKE) -C $(SRCDIR) build
	mv $(SRCDIR)/$(TARGET) $(BUILDDIR)/

clean:
	$(MAKE) -C $(SRCDIR) clean
	rm -rf  $(BUILDDIR)
