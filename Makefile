# Makefile syntax
# <target_file> : <dependency1> ...
# <TAB> command to produce target file

# If the dependencies or recipe need to take up more than one line, the line
# must be continued using a backslash.

all : lexicon.lexc \
	phon.twolc \
	complete.hfst \
	gen.hfstol \
	ana.hfstol \
	ana.png \
	lexicon.png

lexicon.lexc : InapariVerbs.lexc
	cat InapariVerbs.lexc > lexicon.lexc

phon.twolc : phon.twolc
	hfst-twolc phon.twolc > phon.hfst

gen.hfst : lexicon.lexc
	hfst-lexc < lexicon.lexc > gen.hfst

complete.hfst : gen.hfst phon.hfst
	hfst-compose-intersect -1 gen.hfst -2 phon.hfst > full.hfst

gen.hfstol : full.hfst
	hfst-fst2fst --optimized-lookup-unweighted -i full.hfst -o gen.hfstol

ana.hfst : full.hfst
	hfst-invert -i full.hfst -o ana.hfst

ana.hfstol : ana.hfst
	hfst-fst2fst --optimized-lookup-unweighted -i ana.hfst -o ana.hfstol

ana.png : ana.hfstol
	hfst-fst2txt ana.hfstol | python3 att2dot.py | dot -T png -o ana.png

lexicon.png : lexicon.lexc
	python3 lexc2dot.py < lexicon.lexc | dot -T png -o lexicon.png

.PHONY : clean
clean :
	-rm *.hfst *.hfstol lexicon.lexc *.png

.PHONY : test
test :
	sh tests.sh  # sh is a command to run the argument filename as a shell script (usually bash)
