/* boot.S bootstrap for the kernel */

#define ASM 	1

#define MULTIBOOT_HEADER_MAGIC 	0x1BADB002 /* for multiboot header */
#define MULTIBOOT_HEADER_FLAGS 	0x00000003 /* flags for multiboot header */

#ifdef HAVE_ASM_USCORE 	
# define EXT_C(sym)  		_## sym
#else
# define EXT_C(sym)	   		sym
#endif

	 .text 
	 .globl start /* global entry point into the kernel */

start:
		 
		 jmp multiboot_entry

		 /* aligning header at 32bit boundry */

		 .align 4

multiboot_header: 
		
		.long  	MULTIBOOT_HEADER_MAGIC
		.long 	MULTIBOOT_HEADER_FLAGS
		.long 	-(MULTIBOOT_HEADER_MAGIC + MULTIBOOT_HEADER_FLAGS)


multiboot_entry:
		 
		 /* initializing stack pointers .. definition of stack follows */

		 movl 	 $(stack + STACK_SIZE), %esp

		 /* now entering the cmain function EXT_C managing the underscore */

		 call EXT_C(cmain)

		 /* halt !! returning from c ending up here */

loop: 	hlt
		jmp 	loop

.section 	".bss"
				
				/* defining our stack area. The .comm pseudo op declares a common
				symbol. If the loader does not find the existing definition it will
				allocate STACK_SIZE bytes of uninitialized memory */

			.comm  	stack, STACK_SIZE