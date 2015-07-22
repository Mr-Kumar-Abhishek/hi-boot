CFLAGS= -fno-stack-protector -fno-builtin -nostdinc -O -g -Wall -I.

all: kernel.bin

kernel.bin: boot.o main.o
	ld -T link.ld -o kernel.bin boot.o main.o

clean:
	rm -f *.o *.bin
