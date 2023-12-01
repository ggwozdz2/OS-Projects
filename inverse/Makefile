all : clean
	nasm -f elf64 -w+all -w+error -o inverse_permutation.o inverse_permutation.asm
	gcc -c -Wall -Wextra -std=c17 -O2 -o inverse.o inverse.c
	gcc -z noexecstack -o inverse inverse.o inverse_permutation.o

example: clean
	nasm -f elf64 -w+all -w+error -o inverse_permutation.o inverse_permutation.asm
	gcc -c -Wall -Wextra -std=c17 -O2 -o inverse_permutation_example.o inverse_permutation_example.c
	gcc -z noexecstack -o inverse_permutation_example inverse_permutation_example.o inverse_permutation.o

clean :
	rm -rf *.o inverse inverse_permutation_example
