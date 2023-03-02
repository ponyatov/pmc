# var
MODULE = $(notdir $(CURDIR))
module = $(shell echo $(MODULE) | tr A-Z a-z)
OS     = $(shell uname -o|tr / _)
NOW    = $(shell date +%d%m%y)
REL    = $(shell git rev-parse --short=4 HEAD)
BRANCH = $(shell git rev-parse --abbrev-ref HEAD)

# tool
CURL = curl -L -o
CF   = clang-format

# src
C  += src/$(MODULE).cpp
H  += inc/$(MODULE).hpp
CP += tmp/$(MODULE).parser.cpp tmp/$(MODULE).lexer.cpp
HP += tmp/$(MODULE).parser.hpp
F  += lib/$(MODULE).ini

# cfg
CFLAGS += -O0 -g3 -Iinc -Itmp -std=c++11
L      += -lreadline -lpmem

# all
.PHONY: all
all: bin/$(MODULE) $(F)
	$^

# format
.PHONY: format
format: tmp/format_cpp
tmp/format_cpp: $(C) $(H)
	$(CF) -style=file -i $? && touch $@

# rule
bin/$(MODULE): $(C) $(H) $(CP) $(HP)
	$(CXX) $(CFLAGS) -o $@ $(C) $(CP) $(L)
tmp/$(MODULE).parser.cpp: src/$(MODULE).yacc
	bison -o $@ $<
tmp/$(MODULE).lexer.cpp: src/$(MODULE).lex
	flex -o $@ $<

# doc
.PHONY: doxy
doxy: .doxygen
	rm -rf docs ; doxygen $< 1>/dev/null

.PHONY: doc
doc: \
	doc/scargall.pdf

doc/scargall.pdf:
	$(CURL) $@ https://library.oapen.org/bitstream/id/e234e601-6128-4ee4-be45-32e8f2e417dd/1007325.pdf

# install
.PHONY: install update updev
install: $(OS)_install doc gz
	$(MAKE) update
update:  $(OS)_update
updev:   update $(OS)_updev

.PHONY: GNU_Linux_install GNU_Linux_update GNU_Linux_updev
GNU_Linux_install:
GNU_Linux_update:
ifneq (,$(shell which apt))
	sudo apt update
	sudo apt install -u `cat apt.txt`
endif
# Debian 10
ifeq ($(shell lsb_release -cs),buster)
#	sudo apt install -t buster-backports kicad
endif
GNU_Linux_updev:
	sudo apt install -yu `cat apt.dev`

gz:

# merge
MERGE  = Makefile README.md .clang-format .doxygen $(S) .gitignore
MERGE += apt.dev apt.txt
MERGE += .vscode bin doc lib inc src tmp

dev:
	git push -v
	git checkout $@
	git pull -v
	git checkout shadow -- $(MERGE)
	$(MAKE) doxy ; git add -f docs

shadow:
	git push -v
	git checkout $@
	git pull -v

release:
	git tag $(NOW)-$(REL)
	git push -v --tags
	$(MAKE) shadow

ZIP = tmp/$(MODULE)_$(NOW)_$(REL)_$(BRANCH).zip
zip:
	git archive --format zip --output $(ZIP) HEAD
