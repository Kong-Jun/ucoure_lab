#include <defs.h>
#include <mmu.h>
#include <memlayout.h>
#include <clock.h>
#include <trap.h>
#include <x86.h>
#include <stdio.h>
#include <assert.h>
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100
void print_switch_to_user()
{
	cprintf("switch to user");
}

void print_switch_to_kernel()
{
	cprintf("switch to kernel\n");
}

static void print_ticks() {
    cprintf("%d ticks\n",TICK_NUM);
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}

/* *
 * Interrupt descriptor table:
 *
 * Must be built at run time because shifted function addresses can't
 * be represented in relocation records.
 * */
static struct gatedesc idt[256] = {{0}};

static struct pseudodesc idt_pd = {
    sizeof(idt) - 1, (uintptr_t)idt
};

extern volatile size_t ticks;

extern uint32_t __vectors[256];

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
     /* LAB1 YOUR CODE : STEP 2 */
     /* (1) Where are the entry addrs of each Interrupt Service Routine (ISR)?
      *     All ISR's entry addrs are stored in __vectors. where is uintptr_t __vectors[] ?
      *     __vectors[] is in kern/trap/vector.S which is produced by tools/vector.c
      *     (try "make" command in lab1, then you will find vector.S in kern/trap DIR)
      *     You can use  "extern uintptr_t __vectors[];" to define this extern variable which will be used later.
      * (2) Now you should setup the entries of ISR in Interrupt Description Table (IDT).
      *     Can you see idt[256] in this file? Yes, it's IDT! you can use SETGATE macro to setup each item of IDT
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	int intrno = 0;
	/* ucore don't use task gate.*/
	for(; intrno < 256; intrno++) 
		SETGATE(idt[intrno], 0, KERNEL_CS, __vectors[intrno], DPL_KERNEL);

	SETGATE(idt[T_SYSCALL], 1, KERNEL_CS, __vectors[T_SYSCALL], DPL_USER);
	SETGATE(idt[T_SWITCH_TOK], 0, KERNEL_CS, __vectors[T_SWITCH_TOK], DPL_USER);
	SETGATE(idt[T_SWITCH_TOU], 0, KERNEL_CS, __vectors[T_SWITCH_TOU], DPL_KERNEL);

	lidt(&idt_pd);

}

static const char *
trapname(int trapno) {
    static const char * const excnames[] = {
        "Divide error",
        "Debug",
        "Non-Maskable Interrupt",
        "Breakpoint",
        "Overflow",
        "BOUND Range Exceeded",
        "Invalid Opcode",
        "Device Not Available",
        "Double Fault",
        "Coprocessor Segment Overrun",
        "Invalid TSS",
        "Segment Not Present",
        "Stack Fault",
        "General Protection",
        "Page Fault",
        "(unknown trap)",
        "x87 FPU Floating-Point Error",
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
        return excnames[trapno];
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
        return "Hardware Interrupt";
    }
    return "(unknown trap)";
}

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
}

static const char *IA32flags[] = {
    "CF", NULL, "PF", NULL, "AF", NULL, "ZF", "SF",
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
    cprintf("trapframe at %p\n", tf);
    print_regs(&tf->tf_regs);
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
    cprintf("  es   0x----%04x\n", tf->tf_es);
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
    cprintf("  err  0x%08x\n", tf->tf_err);
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);

    if (!trap_in_kernel(tf)) {
        cprintf("  esp  0x%08x\n", tf->tf_esp);
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
    }
}

void
print_regs(struct pushregs *regs) {
    cprintf("  edi  0x%08x\n", regs->reg_edi);
    cprintf("  esi  0x%08x\n", regs->reg_esi);
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
    cprintf("  edx  0x%08x\n", regs->reg_edx);
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
    cprintf("  eax  0x%08x\n", regs->reg_eax);
}

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
    char c;
	static struct trapframe *correct_tf;
	correct_tf = (struct trapframe *) ((uint32_t)(tf) - 8);

    switch (tf->tf_trapno) {
    case IRQ_OFFSET + IRQ_TIMER:
        /* LAB1 YOUR CODE : STEP 3 */
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
		
		/* ticks is a global variable defined in kern/driver/clock.h;
		 * ticks equals to zero at beginning;
		 */
		ticks = (ticks + 1) % 100;
		if (ticks == 0)
			print_ticks();
        break;
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
        cprintf("serial [%03d] %c\n", c, c);
        break;
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
        cprintf("kbd [%03d] %c\n", c, c);
		switch (c) {
			case '0' :
				if (!trap_in_kernel(tf)) {
					tf->tf_cs = KERNEL_CS;
					tf->tf_ds = tf->tf_es = tf->tf_gs = tf->tf_fs = KERNEL_DS;
					tf->tf_eflags &= ~FL_IOPL_MASK;
					uintptr_t user_stack_ptr = (uintptr_t)tf->tf_esp;
					tf->tf_esp = *((uint32_t *) user_stack_ptr);
					tf->tf_ss = *((uint16_t *) (user_stack_ptr + 4));
					tf->tf_padding0 = *((uint16_t *) (user_stack_ptr + 6));
					user_stack_ptr -= (uintptr_t) (sizeof(struct trapframe) - 8);
					*((struct trapframe *) user_stack_ptr) = *tf;
					__asm__ __volatile__ (
						"movl %%ebx, -4(%%eax) \n\t"
						:
						:"a" ((uint32_t) tf),
						 "b" ((uint32_t) user_stack_ptr)
					);
					// __asm__ __volatile__ (
					// /* copy trapframe to user stack */
					// 	"movl %%ebx, %%esi \n\t"
					// 	"movl 4(%%ebx), %%edi \n\t"
					// 	"subl $4, %%edi \n\t"
					// 	"std \n\t"
					// 	"rep movsb \n\t"
					// /* make %esp point to user stack */
					// 	"movl %%edi, -4(%%eax) \n\t"
					// /* correct %ss */
					// 	"movw 8(%%ebx), %%ss \n\t"
					// 	:
					// 	:"a" ((uint32_t)tf),
					//      "b" ((uint32_t)&tf->tf_eflags), "c" ((uint32_t)(sizeof(struct trapframe) - 8))
					// 	:"%edi", "%esi"
					// );
				}
				break;
			case '3' :
				if (trap_in_kernel(tf)) {
					__asm__ __volatile__ (
						"pushl %%esi \n\t"
						"pushl %%edi \n\t"
						"pushl %%ebx \n\t"
					/* set %esp(upon trapframe) to correct position */
						"subl $8, -4(%%edx) \n\t"
					/* move space opon trapframe and trapframe to low address */
						"movl %%esp, %%esi \n\t"
					/* %eax - the highest bound of trapframe */
						"movl %%eax, %%ecx \n\t"
						"subl %%esi, %%ecx \n\t"
						"incl %%ecx \n\t"
						"movl %%esp, %%edi \n\t"
						"subl $8, %%edi \n\t"
						"cld \n\t"
						"rep movsb \n\t"
					/* correct %esp and %ebp */

						"subl $8, %%esp \n\t"
						"subl $8, %%ebp \n\t"
						"movl %%ebp, %%ebx \n\t"
					"loop: \n\t"
						"subl $8, (%%ebx) \n\t"
						"movl (%%ebx), %%ebx \n\t"
						"cmpl %%ebx, %%eax \n\t"
						"jg loop \n\t"

						"movl %%eax, -8(%%eax) \n\t"
						"movl %2, -4(%%eax) \n\t"

						"popl %%ebx \n\t"
						"popl %%edi \n\t"
						"popl %%esi \n\t"
						:
						:"a" ((uint32_t)(&tf->tf_esp)),
						 "d" ((uint32_t)(tf)),
					     "i" ((uint16_t)USER_DS)
						:"%ecx", "memory" 
					);
					correct_tf->tf_cs = USER_CS;
					correct_tf->tf_ds = tf->tf_es = tf->tf_gs = tf->tf_fs = USER_DS;
					correct_tf->tf_eflags |= FL_IOPL_MASK;
						 
				}
				break;
		}
        break;
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
		if ((tf->tf_cs & 3) == 0) {
			tf->tf_cs = USER_CS;
			tf->tf_ss = tf->tf_ds = tf->tf_es = tf->tf_gs = tf->tf_fs = USER_DS;
			tf->tf_esp += 4;
			tf->tf_eflags |= FL_IOPL_MASK;
		}
		break;

    case T_SWITCH_TOK:
		if ((tf->tf_cs & 3) != 0) {
			tf->tf_cs = KERNEL_CS;
			tf->tf_ss = tf->tf_ds = tf->tf_es = tf->tf_gs = tf->tf_fs = KERNEL_DS;
			tf->tf_eflags &= ~FL_IOPL_MASK;
			// __asm__ __volatile__ (
			// 	"movw %%ax, %%ss\n\t"
			// 	:
			// 	:"a" (tf->tf_ss)
			// );	
		}
			break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
	case T_GPFLT:
		cprintf("GP Fault!!!\n");
		print_trapframe(tf);
		break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}

/* *
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
}

