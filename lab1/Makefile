arquivo1.s: arquivo1.c
	clang-15 --target=riscv32 -march=rv32g -mabi=ilp32d -mno-relax arquivo1.c -S -o arquivo1.s

arquivo2.s: arquivo2.c
	clang-15 --target=riscv32 -march=rv32g -mabi=ilp32d -mno-relax arquivo2.c -S -o arquivo2.s

arquivo1.o: arquivo1.s
	clang-15 --target=riscv32 -march=rv32g -mabi=ilp32d -mno-relax arquivo1.s -c -o arquivo1.o

arquivo2.o: arquivo2.s
	clang-15 --target=riscv32 -march=rv32g -mabi=ilp32d -mno-relax arquivo2.s -c -o arquivo2.o

prog.x: arquivo1.o arquivo2.o
	ld.lld arquivo1.o arquivo2.o -o prog.x

lab1b.s: lab1b.c
	clang-15 --target=riscv32 -march=rv32g -mabi=ilp32d -mno-relax lab1b.c -S -o lab1b.s

lab1b.o: lab1b.s
	clang-15 --target=riscv32 -march=rv32g -mabi=ilp32d -mno-relax lab1b.s -c -o lab1b.o

lab1b.x: lab1b.o
	ld.lld lab1b.o -o lab1b.x