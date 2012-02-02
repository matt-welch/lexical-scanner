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

test: debug test1.sh
	./test1.sh

#.PHONY: submit
#submit: tidy 
# 	cd ..
#	cp -r p1 James_Welch_Proj1
#	rm ./James_Welch_Proj1/tests/test3* ./James_Welch_Proj1/tests/test4*
#	zip -r James_Welch_Proj1 James_Welch_Proj1

