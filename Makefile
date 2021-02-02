# Makefile syntax
# <target_file> : <dependency1> ...
# <TAB> command to produce target file

# If the dependencies or recipe need to take up more than one line, the line
# must be continued using a backslash.

all : lexicon_VINP.lexc \
	gen_VINP.hfstol \
	ana_VINP.hfstol \
	ana_VINP.png \
	lexicon_VINP.png

lexicon_VINP.lexc : InapariVerbs.lexc
	cat InapariVerbs.lexc > lexicon_VINP.lexc

gen_VINP.hfst : lexicon_VINP.lexc
	hfst-lexc <lexicon_VINP.lexc >gen_VINP.hfst

gen_VINP.hfstol : gen_VINP.hfst
	hfst-fst2fst --optimized-lookup-unweighted -i gen_VINP.hfst -o gen_VINP.hfstol

ana_VINP.hfst : gen_VINP.hfst
	hfst-invert -i gen_VINP.hfst -o ana_VINP.hfst

ana_VINP.hfstol : ana_VINP.hfst
	hfst-fst2fst --optimized-lookup-unweighted -i ana_VINP.hfst -o ana_VINP.hfstol

ana_VINP.png : ana_VINP.hfst
	hfst-fst2txt ana_VINP.hfst | python3 att2dot.py | dot -T png -o ana_VINP.png

lexicon_VINP.png : lexicon_VINP.lexc
	python3 lexc2dot.py <lexicon_VINP.lexc | dot -T png -o lexicon_VINP.png  # BUG

.PHONY : clean
clean :
	-rm *.hfst *.hfstol lexicon_VINP.lexc

.PHONY : test
test :
	sh tests.sh  # sh is a command to run the argument filename as a shell script (usually bash)
