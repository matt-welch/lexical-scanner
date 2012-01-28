scanner: scanner.o
	gcc -o a.out scanner.o

scanner.o: scanner.c
#	gcc -c -Wall -pedantic scanner.c
	gcc -c $(CONFIG) scanner.c
	
clean:
	rm -f a.out *.o core core.*

tidy: clean
	rm -f *.*~ *~

DEBUG_FLAGS = -g3 -ggdb -O0 -Wall -pedantic -DDEBUG
CONFIG		= -Wall -pedantic

debug: CONFIG=$(DEBUG_FLAGS)
debug: scanner

test: a.out test1.sh
	./test1.sh
