BASE = calc.exe
BISON = bison  
CXX = g++
FLEX = flex   

all: $(BASE)

%.cc %.hh %.html %.gv: %.yy
	$(BISON) $(BISONFLAGS) --html --graph -o $*.cc $<

%.cc: %.ll
	$(FLEX) $(FLEXFLAGS) -o$@ $<

$(BASE): $(BASE).o diver.o parser.o scanner.o
	$(CXX) -o $@ $^

$(BASE).o: parser.hh 

parser.o: parser.hh 

scanner.o: parser.hh

run: $(BASE)
	@echo "Type arithmetic expressiones or Crtl+D to quit."
	./$< -
	