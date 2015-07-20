/* boot.S bootstrap for the kernal */

#define ASM 	1

#define MULTIBOOT_HEADER_MAGIC 	0x1BADB002 /* for multiboot header */
#define MULTIBOOT_HEADER_FLAGS 	0x00000003 /* flags for multiboot header */

#ifdef HAVE_ASM_USCORE 	
# define EXT_C(sym)  		_## sym
#else
# define EXT_C(sym)	   		sym
#endif

	 .text 
	 .globl start /* global entry point into the kernal */

start:
		 
		 jmp multiboot_entry

		 /* aligning header at 32bit boundry */

		 .align

multiboot_header: 
		
		.long  	MULTIBOOT_HEADER_MAGIC
		.long 	MULTIBOOT_HEADER_FLAGS
		.long 	-(MULTIBOOT_HEADER_MAGIC + MULTIBOOT_HEADER_FLAGS)


multiboot_entry:
		 
		 /* initializing stack pointers .. defination of stack follows */

		 movl 	 $(stack + STACK_SIZE), %esp

		 /* now entering the c main function EXT_C managing the underscore */

		 call EXT_C(cmain)

		 /* halt !! returning from c ending up here */

loop: 	hlt
		jmp 	loop

.section 	".bss"
				
				/* defining our stack are . The .comm pseudo op declares a comman
				symbol. If the loader does not find the existing defination it will
				allocate STACK_SIZE bytes of uninitialized memory */

			.comm  	stack, STACK_SIZE