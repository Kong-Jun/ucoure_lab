
bin/kernel：     文件格式 elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
c0100000:	b8 00 a0 11 00       	mov    $0x11a000,%eax
    movl %eax, %cr3
c0100005:	0f 22 d8             	mov    %eax,%cr3

    # enable paging
    movl %cr0, %eax
c0100008:	0f 20 c0             	mov    %cr0,%eax
    orl $(CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP), %eax
c010000b:	0d 2f 00 05 80       	or     $0x8005002f,%eax
    andl $~(CR0_TS | CR0_EM), %eax
c0100010:	83 e0 f3             	and    $0xfffffff3,%eax
    movl %eax, %cr0
c0100013:	0f 22 c0             	mov    %eax,%cr0

    # update eip
    # now, eip = 0x1.....
    leal next, %eax
c0100016:	8d 05 1e 00 10 c0    	lea    0xc010001e,%eax
    # set eip = KERNBASE + 0x1.....
    jmp *%eax
c010001c:	ff e0                	jmp    *%eax

c010001e <next>:
next:

    # unmap va 0 ~ 4M, it's temporary mapping
    xorl %eax, %eax
c010001e:	31 c0                	xor    %eax,%eax
    movl %eax, __boot_pgdir
c0100020:	a3 00 a0 11 c0       	mov    %eax,0xc011a000

    # set ebp, esp
    movl $0x0, %ebp
c0100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010002a:	bc 00 90 11 c0       	mov    $0xc0119000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c010002f:	e8 02 00 00 00       	call   c0100036 <kern_init>

c0100034 <spin>:

# should never get here
spin:
    jmp spin
c0100034:	eb fe                	jmp    c0100034 <spin>

c0100036 <kern_init>:
static void lab1_print_cur_status(void);
static void lab1_switch_test(void);


int
kern_init(void) {
c0100036:	55                   	push   %ebp
c0100037:	89 e5                	mov    %esp,%ebp
c0100039:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c010003c:	b8 48 cf 11 c0       	mov    $0xc011cf48,%eax
c0100041:	2d 00 c0 11 c0       	sub    $0xc011c000,%eax
c0100046:	89 44 24 08          	mov    %eax,0x8(%esp)
c010004a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100051:	00 
c0100052:	c7 04 24 00 c0 11 c0 	movl   $0xc011c000,(%esp)
c0100059:	e8 aa 5b 00 00       	call   c0105c08 <memset>

    cons_init();                // init the console
c010005e:	e8 8e 15 00 00       	call   c01015f1 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100063:	c7 45 f4 00 64 10 c0 	movl   $0xc0106400,-0xc(%ebp)
    cprintf("%s\n\n", message);
c010006a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010006d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100071:	c7 04 24 1c 64 10 c0 	movl   $0xc010641c,(%esp)
c0100078:	e8 1d 02 00 00       	call   c010029a <cprintf>

    print_kerninfo();
c010007d:	e8 b3 08 00 00       	call   c0100935 <print_kerninfo>

    grade_backtrace();
c0100082:	e8 89 00 00 00       	call   c0100110 <grade_backtrace>

    pmm_init();                 // init physical memory management
c0100087:	e8 35 35 00 00       	call   c01035c1 <pmm_init>

    pic_init();                 // init interrupt controller
c010008c:	e8 c5 16 00 00       	call   c0101756 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100091:	e8 4f 18 00 00       	call   c01018e5 <idt_init>

    clock_init();               // init clock interrupt
c0100096:	e8 f9 0c 00 00       	call   c0100d94 <clock_init>
    intr_enable();              // enable irq interrupt
c010009b:	e8 f0 17 00 00       	call   c0101890 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c01000a0:	eb fe                	jmp    c01000a0 <kern_init+0x6a>

c01000a2 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c01000a2:	55                   	push   %ebp
c01000a3:	89 e5                	mov    %esp,%ebp
c01000a5:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000a8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000af:	00 
c01000b0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000b7:	00 
c01000b8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000bf:	e8 be 0c 00 00       	call   c0100d82 <mon_backtrace>
}
c01000c4:	90                   	nop
c01000c5:	c9                   	leave  
c01000c6:	c3                   	ret    

c01000c7 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000c7:	55                   	push   %ebp
c01000c8:	89 e5                	mov    %esp,%ebp
c01000ca:	53                   	push   %ebx
c01000cb:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000ce:	8d 4d 0c             	lea    0xc(%ebp),%ecx
c01000d1:	8b 55 0c             	mov    0xc(%ebp),%edx
c01000d4:	8d 5d 08             	lea    0x8(%ebp),%ebx
c01000d7:	8b 45 08             	mov    0x8(%ebp),%eax
c01000da:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01000de:	89 54 24 08          	mov    %edx,0x8(%esp)
c01000e2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01000e6:	89 04 24             	mov    %eax,(%esp)
c01000e9:	e8 b4 ff ff ff       	call   c01000a2 <grade_backtrace2>
}
c01000ee:	90                   	nop
c01000ef:	83 c4 14             	add    $0x14,%esp
c01000f2:	5b                   	pop    %ebx
c01000f3:	5d                   	pop    %ebp
c01000f4:	c3                   	ret    

c01000f5 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000f5:	55                   	push   %ebp
c01000f6:	89 e5                	mov    %esp,%ebp
c01000f8:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c01000fb:	8b 45 10             	mov    0x10(%ebp),%eax
c01000fe:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100102:	8b 45 08             	mov    0x8(%ebp),%eax
c0100105:	89 04 24             	mov    %eax,(%esp)
c0100108:	e8 ba ff ff ff       	call   c01000c7 <grade_backtrace1>
}
c010010d:	90                   	nop
c010010e:	c9                   	leave  
c010010f:	c3                   	ret    

c0100110 <grade_backtrace>:

void
grade_backtrace(void) {
c0100110:	55                   	push   %ebp
c0100111:	89 e5                	mov    %esp,%ebp
c0100113:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c0100116:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c010011b:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100122:	ff 
c0100123:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100127:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010012e:	e8 c2 ff ff ff       	call   c01000f5 <grade_backtrace0>
}
c0100133:	90                   	nop
c0100134:	c9                   	leave  
c0100135:	c3                   	ret    

c0100136 <lab1_print_cur_status>:

/* print segment register info and privilege info */
static void
lab1_print_cur_status(void) {
c0100136:	55                   	push   %ebp
c0100137:	89 e5                	mov    %esp,%ebp
c0100139:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c010013c:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c010013f:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c0100142:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100145:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c0100148:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010014c:	83 e0 03             	and    $0x3,%eax
c010014f:	89 c2                	mov    %eax,%edx
c0100151:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c0100156:	89 54 24 08          	mov    %edx,0x8(%esp)
c010015a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010015e:	c7 04 24 21 64 10 c0 	movl   $0xc0106421,(%esp)
c0100165:	e8 30 01 00 00       	call   c010029a <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c010016a:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010016e:	89 c2                	mov    %eax,%edx
c0100170:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c0100175:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100179:	89 44 24 04          	mov    %eax,0x4(%esp)
c010017d:	c7 04 24 2f 64 10 c0 	movl   $0xc010642f,(%esp)
c0100184:	e8 11 01 00 00       	call   c010029a <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100189:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c010018d:	89 c2                	mov    %eax,%edx
c010018f:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c0100194:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100198:	89 44 24 04          	mov    %eax,0x4(%esp)
c010019c:	c7 04 24 3d 64 10 c0 	movl   $0xc010643d,(%esp)
c01001a3:	e8 f2 00 00 00       	call   c010029a <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001a8:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001ac:	89 c2                	mov    %eax,%edx
c01001ae:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c01001b3:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001b7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001bb:	c7 04 24 4b 64 10 c0 	movl   $0xc010644b,(%esp)
c01001c2:	e8 d3 00 00 00       	call   c010029a <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001c7:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001cb:	89 c2                	mov    %eax,%edx
c01001cd:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c01001d2:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001d6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001da:	c7 04 24 59 64 10 c0 	movl   $0xc0106459,(%esp)
c01001e1:	e8 b4 00 00 00       	call   c010029a <cprintf>
    round ++;
c01001e6:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c01001eb:	40                   	inc    %eax
c01001ec:	a3 00 c0 11 c0       	mov    %eax,0xc011c000
}
c01001f1:	90                   	nop
c01001f2:	c9                   	leave  
c01001f3:	c3                   	ret    

c01001f4 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001f4:	55                   	push   %ebp
c01001f5:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
	__asm__ __volatile__ (
c01001f7:	b8 23 00 00 00       	mov    $0x23,%eax
c01001fc:	50                   	push   %eax
c01001fd:	54                   	push   %esp
c01001fe:	cd 78                	int    $0x78
		"pushl %%esp\n\t"
		"int %0\n\t"
		:
		:"i" (T_SWITCH_TOU), "a" (USER_DS)
	);
}
c0100200:	90                   	nop
c0100201:	5d                   	pop    %ebp
c0100202:	c3                   	ret    

c0100203 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c0100203:	55                   	push   %ebp
c0100204:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
	__asm__ __volatile__ (
c0100206:	cd 79                	int    $0x79
c0100208:	5c                   	pop    %esp
		"int %0\n\t"
		"popl %%esp\n\t"
		:
		:"i" (T_SWITCH_TOK)
	);
}
c0100209:	90                   	nop
c010020a:	5d                   	pop    %ebp
c010020b:	c3                   	ret    

c010020c <lab1_switch_test>:

static void
lab1_switch_test(void) {
c010020c:	55                   	push   %ebp
c010020d:	89 e5                	mov    %esp,%ebp
c010020f:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c0100212:	e8 1f ff ff ff       	call   c0100136 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100217:	c7 04 24 68 64 10 c0 	movl   $0xc0106468,(%esp)
c010021e:	e8 77 00 00 00       	call   c010029a <cprintf>
    lab1_switch_to_user();
c0100223:	e8 cc ff ff ff       	call   c01001f4 <lab1_switch_to_user>
    lab1_print_cur_status();
c0100228:	e8 09 ff ff ff       	call   c0100136 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c010022d:	c7 04 24 88 64 10 c0 	movl   $0xc0106488,(%esp)
c0100234:	e8 61 00 00 00       	call   c010029a <cprintf>
    lab1_switch_to_kernel();
c0100239:	e8 c5 ff ff ff       	call   c0100203 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c010023e:	e8 f3 fe ff ff       	call   c0100136 <lab1_print_cur_status>
}
c0100243:	90                   	nop
c0100244:	c9                   	leave  
c0100245:	c3                   	ret    

c0100246 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c0100246:	55                   	push   %ebp
c0100247:	89 e5                	mov    %esp,%ebp
c0100249:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c010024c:	8b 45 08             	mov    0x8(%ebp),%eax
c010024f:	89 04 24             	mov    %eax,(%esp)
c0100252:	e8 c7 13 00 00       	call   c010161e <cons_putc>
    (*cnt) ++;
c0100257:	8b 45 0c             	mov    0xc(%ebp),%eax
c010025a:	8b 00                	mov    (%eax),%eax
c010025c:	8d 50 01             	lea    0x1(%eax),%edx
c010025f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100262:	89 10                	mov    %edx,(%eax)
}
c0100264:	90                   	nop
c0100265:	c9                   	leave  
c0100266:	c3                   	ret    

c0100267 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100267:	55                   	push   %ebp
c0100268:	89 e5                	mov    %esp,%ebp
c010026a:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010026d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100274:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100277:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010027b:	8b 45 08             	mov    0x8(%ebp),%eax
c010027e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100282:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100285:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100289:	c7 04 24 46 02 10 c0 	movl   $0xc0100246,(%esp)
c0100290:	e8 c1 5c 00 00       	call   c0105f56 <vprintfmt>
    return cnt;
c0100295:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100298:	c9                   	leave  
c0100299:	c3                   	ret    

c010029a <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c010029a:	55                   	push   %ebp
c010029b:	89 e5                	mov    %esp,%ebp
c010029d:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c01002a0:	8d 45 0c             	lea    0xc(%ebp),%eax
c01002a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c01002a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002a9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01002ad:	8b 45 08             	mov    0x8(%ebp),%eax
c01002b0:	89 04 24             	mov    %eax,(%esp)
c01002b3:	e8 af ff ff ff       	call   c0100267 <vcprintf>
c01002b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c01002bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01002be:	c9                   	leave  
c01002bf:	c3                   	ret    

c01002c0 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c01002c0:	55                   	push   %ebp
c01002c1:	89 e5                	mov    %esp,%ebp
c01002c3:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002c6:	8b 45 08             	mov    0x8(%ebp),%eax
c01002c9:	89 04 24             	mov    %eax,(%esp)
c01002cc:	e8 4d 13 00 00       	call   c010161e <cons_putc>
}
c01002d1:	90                   	nop
c01002d2:	c9                   	leave  
c01002d3:	c3                   	ret    

c01002d4 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c01002d4:	55                   	push   %ebp
c01002d5:	89 e5                	mov    %esp,%ebp
c01002d7:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c01002da:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c01002e1:	eb 13                	jmp    c01002f6 <cputs+0x22>
        cputch(c, &cnt);
c01002e3:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c01002e7:	8d 55 f0             	lea    -0x10(%ebp),%edx
c01002ea:	89 54 24 04          	mov    %edx,0x4(%esp)
c01002ee:	89 04 24             	mov    %eax,(%esp)
c01002f1:	e8 50 ff ff ff       	call   c0100246 <cputch>
    while ((c = *str ++) != '\0') {
c01002f6:	8b 45 08             	mov    0x8(%ebp),%eax
c01002f9:	8d 50 01             	lea    0x1(%eax),%edx
c01002fc:	89 55 08             	mov    %edx,0x8(%ebp)
c01002ff:	0f b6 00             	movzbl (%eax),%eax
c0100302:	88 45 f7             	mov    %al,-0x9(%ebp)
c0100305:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c0100309:	75 d8                	jne    c01002e3 <cputs+0xf>
    }
    cputch('\n', &cnt);
c010030b:	8d 45 f0             	lea    -0x10(%ebp),%eax
c010030e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100312:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c0100319:	e8 28 ff ff ff       	call   c0100246 <cputch>
    return cnt;
c010031e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0100321:	c9                   	leave  
c0100322:	c3                   	ret    

c0100323 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c0100323:	55                   	push   %ebp
c0100324:	89 e5                	mov    %esp,%ebp
c0100326:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c0100329:	90                   	nop
c010032a:	e8 2c 13 00 00       	call   c010165b <cons_getc>
c010032f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100332:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100336:	74 f2                	je     c010032a <getchar+0x7>
        /* do nothing */;
    return c;
c0100338:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010033b:	c9                   	leave  
c010033c:	c3                   	ret    

c010033d <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c010033d:	55                   	push   %ebp
c010033e:	89 e5                	mov    %esp,%ebp
c0100340:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100343:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100347:	74 13                	je     c010035c <readline+0x1f>
        cprintf("%s", prompt);
c0100349:	8b 45 08             	mov    0x8(%ebp),%eax
c010034c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100350:	c7 04 24 a7 64 10 c0 	movl   $0xc01064a7,(%esp)
c0100357:	e8 3e ff ff ff       	call   c010029a <cprintf>
    }
    int i = 0, c;
c010035c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100363:	e8 bb ff ff ff       	call   c0100323 <getchar>
c0100368:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c010036b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010036f:	79 07                	jns    c0100378 <readline+0x3b>
            return NULL;
c0100371:	b8 00 00 00 00       	mov    $0x0,%eax
c0100376:	eb 78                	jmp    c01003f0 <readline+0xb3>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c0100378:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c010037c:	7e 28                	jle    c01003a6 <readline+0x69>
c010037e:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c0100385:	7f 1f                	jg     c01003a6 <readline+0x69>
            cputchar(c);
c0100387:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010038a:	89 04 24             	mov    %eax,(%esp)
c010038d:	e8 2e ff ff ff       	call   c01002c0 <cputchar>
            buf[i ++] = c;
c0100392:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100395:	8d 50 01             	lea    0x1(%eax),%edx
c0100398:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010039b:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010039e:	88 90 20 c0 11 c0    	mov    %dl,-0x3fee3fe0(%eax)
c01003a4:	eb 45                	jmp    c01003eb <readline+0xae>
        }
        else if (c == '\b' && i > 0) {
c01003a6:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01003aa:	75 16                	jne    c01003c2 <readline+0x85>
c01003ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003b0:	7e 10                	jle    c01003c2 <readline+0x85>
            cputchar(c);
c01003b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01003b5:	89 04 24             	mov    %eax,(%esp)
c01003b8:	e8 03 ff ff ff       	call   c01002c0 <cputchar>
            i --;
c01003bd:	ff 4d f4             	decl   -0xc(%ebp)
c01003c0:	eb 29                	jmp    c01003eb <readline+0xae>
        }
        else if (c == '\n' || c == '\r') {
c01003c2:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01003c6:	74 06                	je     c01003ce <readline+0x91>
c01003c8:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01003cc:	75 95                	jne    c0100363 <readline+0x26>
            cputchar(c);
c01003ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01003d1:	89 04 24             	mov    %eax,(%esp)
c01003d4:	e8 e7 fe ff ff       	call   c01002c0 <cputchar>
            buf[i] = '\0';
c01003d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01003dc:	05 20 c0 11 c0       	add    $0xc011c020,%eax
c01003e1:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01003e4:	b8 20 c0 11 c0       	mov    $0xc011c020,%eax
c01003e9:	eb 05                	jmp    c01003f0 <readline+0xb3>
        c = getchar();
c01003eb:	e9 73 ff ff ff       	jmp    c0100363 <readline+0x26>
        }
    }
}
c01003f0:	c9                   	leave  
c01003f1:	c3                   	ret    

c01003f2 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c01003f2:	55                   	push   %ebp
c01003f3:	89 e5                	mov    %esp,%ebp
c01003f5:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c01003f8:	a1 20 c4 11 c0       	mov    0xc011c420,%eax
c01003fd:	85 c0                	test   %eax,%eax
c01003ff:	75 5b                	jne    c010045c <__panic+0x6a>
        goto panic_dead;
    }
    is_panic = 1;
c0100401:	c7 05 20 c4 11 c0 01 	movl   $0x1,0xc011c420
c0100408:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c010040b:	8d 45 14             	lea    0x14(%ebp),%eax
c010040e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100411:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100414:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100418:	8b 45 08             	mov    0x8(%ebp),%eax
c010041b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010041f:	c7 04 24 aa 64 10 c0 	movl   $0xc01064aa,(%esp)
c0100426:	e8 6f fe ff ff       	call   c010029a <cprintf>
    vcprintf(fmt, ap);
c010042b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010042e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100432:	8b 45 10             	mov    0x10(%ebp),%eax
c0100435:	89 04 24             	mov    %eax,(%esp)
c0100438:	e8 2a fe ff ff       	call   c0100267 <vcprintf>
    cprintf("\n");
c010043d:	c7 04 24 c6 64 10 c0 	movl   $0xc01064c6,(%esp)
c0100444:	e8 51 fe ff ff       	call   c010029a <cprintf>
    
    cprintf("stack trackback:\n");
c0100449:	c7 04 24 c8 64 10 c0 	movl   $0xc01064c8,(%esp)
c0100450:	e8 45 fe ff ff       	call   c010029a <cprintf>
    print_stackframe();
c0100455:	e8 21 06 00 00       	call   c0100a7b <print_stackframe>
c010045a:	eb 01                	jmp    c010045d <__panic+0x6b>
        goto panic_dead;
c010045c:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
c010045d:	e8 35 14 00 00       	call   c0101897 <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100462:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100469:	e8 47 08 00 00       	call   c0100cb5 <kmonitor>
c010046e:	eb f2                	jmp    c0100462 <__panic+0x70>

c0100470 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100470:	55                   	push   %ebp
c0100471:	89 e5                	mov    %esp,%ebp
c0100473:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100476:	8d 45 14             	lea    0x14(%ebp),%eax
c0100479:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c010047c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010047f:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100483:	8b 45 08             	mov    0x8(%ebp),%eax
c0100486:	89 44 24 04          	mov    %eax,0x4(%esp)
c010048a:	c7 04 24 da 64 10 c0 	movl   $0xc01064da,(%esp)
c0100491:	e8 04 fe ff ff       	call   c010029a <cprintf>
    vcprintf(fmt, ap);
c0100496:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100499:	89 44 24 04          	mov    %eax,0x4(%esp)
c010049d:	8b 45 10             	mov    0x10(%ebp),%eax
c01004a0:	89 04 24             	mov    %eax,(%esp)
c01004a3:	e8 bf fd ff ff       	call   c0100267 <vcprintf>
    cprintf("\n");
c01004a8:	c7 04 24 c6 64 10 c0 	movl   $0xc01064c6,(%esp)
c01004af:	e8 e6 fd ff ff       	call   c010029a <cprintf>
    va_end(ap);
}
c01004b4:	90                   	nop
c01004b5:	c9                   	leave  
c01004b6:	c3                   	ret    

c01004b7 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c01004b7:	55                   	push   %ebp
c01004b8:	89 e5                	mov    %esp,%ebp
    return is_panic;
c01004ba:	a1 20 c4 11 c0       	mov    0xc011c420,%eax
}
c01004bf:	5d                   	pop    %ebp
c01004c0:	c3                   	ret    

c01004c1 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01004c1:	55                   	push   %ebp
c01004c2:	89 e5                	mov    %esp,%ebp
c01004c4:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01004c7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004ca:	8b 00                	mov    (%eax),%eax
c01004cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01004cf:	8b 45 10             	mov    0x10(%ebp),%eax
c01004d2:	8b 00                	mov    (%eax),%eax
c01004d4:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004d7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c01004de:	e9 ca 00 00 00       	jmp    c01005ad <stab_binsearch+0xec>
        int true_m = (l + r) / 2, m = true_m;
c01004e3:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01004e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01004e9:	01 d0                	add    %edx,%eax
c01004eb:	89 c2                	mov    %eax,%edx
c01004ed:	c1 ea 1f             	shr    $0x1f,%edx
c01004f0:	01 d0                	add    %edx,%eax
c01004f2:	d1 f8                	sar    %eax
c01004f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01004f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01004fa:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c01004fd:	eb 03                	jmp    c0100502 <stab_binsearch+0x41>
            m --;
c01004ff:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
c0100502:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100505:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100508:	7c 1f                	jl     c0100529 <stab_binsearch+0x68>
c010050a:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010050d:	89 d0                	mov    %edx,%eax
c010050f:	01 c0                	add    %eax,%eax
c0100511:	01 d0                	add    %edx,%eax
c0100513:	c1 e0 02             	shl    $0x2,%eax
c0100516:	89 c2                	mov    %eax,%edx
c0100518:	8b 45 08             	mov    0x8(%ebp),%eax
c010051b:	01 d0                	add    %edx,%eax
c010051d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100521:	0f b6 c0             	movzbl %al,%eax
c0100524:	39 45 14             	cmp    %eax,0x14(%ebp)
c0100527:	75 d6                	jne    c01004ff <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
c0100529:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010052c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010052f:	7d 09                	jge    c010053a <stab_binsearch+0x79>
            l = true_m + 1;
c0100531:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100534:	40                   	inc    %eax
c0100535:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100538:	eb 73                	jmp    c01005ad <stab_binsearch+0xec>
        }

        // actual binary search
        any_matches = 1;
c010053a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100541:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100544:	89 d0                	mov    %edx,%eax
c0100546:	01 c0                	add    %eax,%eax
c0100548:	01 d0                	add    %edx,%eax
c010054a:	c1 e0 02             	shl    $0x2,%eax
c010054d:	89 c2                	mov    %eax,%edx
c010054f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100552:	01 d0                	add    %edx,%eax
c0100554:	8b 40 08             	mov    0x8(%eax),%eax
c0100557:	39 45 18             	cmp    %eax,0x18(%ebp)
c010055a:	76 11                	jbe    c010056d <stab_binsearch+0xac>
            *region_left = m;
c010055c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010055f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100562:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c0100564:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100567:	40                   	inc    %eax
c0100568:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010056b:	eb 40                	jmp    c01005ad <stab_binsearch+0xec>
        } else if (stabs[m].n_value > addr) {
c010056d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100570:	89 d0                	mov    %edx,%eax
c0100572:	01 c0                	add    %eax,%eax
c0100574:	01 d0                	add    %edx,%eax
c0100576:	c1 e0 02             	shl    $0x2,%eax
c0100579:	89 c2                	mov    %eax,%edx
c010057b:	8b 45 08             	mov    0x8(%ebp),%eax
c010057e:	01 d0                	add    %edx,%eax
c0100580:	8b 40 08             	mov    0x8(%eax),%eax
c0100583:	39 45 18             	cmp    %eax,0x18(%ebp)
c0100586:	73 14                	jae    c010059c <stab_binsearch+0xdb>
            *region_right = m - 1;
c0100588:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010058b:	8d 50 ff             	lea    -0x1(%eax),%edx
c010058e:	8b 45 10             	mov    0x10(%ebp),%eax
c0100591:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c0100593:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100596:	48                   	dec    %eax
c0100597:	89 45 f8             	mov    %eax,-0x8(%ebp)
c010059a:	eb 11                	jmp    c01005ad <stab_binsearch+0xec>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c010059c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010059f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005a2:	89 10                	mov    %edx,(%eax)
            l = m;
c01005a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01005a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01005aa:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
c01005ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01005b0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01005b3:	0f 8e 2a ff ff ff    	jle    c01004e3 <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
c01005b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01005bd:	75 0f                	jne    c01005ce <stab_binsearch+0x10d>
        *region_right = *region_left - 1;
c01005bf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005c2:	8b 00                	mov    (%eax),%eax
c01005c4:	8d 50 ff             	lea    -0x1(%eax),%edx
c01005c7:	8b 45 10             	mov    0x10(%ebp),%eax
c01005ca:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
c01005cc:	eb 3e                	jmp    c010060c <stab_binsearch+0x14b>
        l = *region_right;
c01005ce:	8b 45 10             	mov    0x10(%ebp),%eax
c01005d1:	8b 00                	mov    (%eax),%eax
c01005d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c01005d6:	eb 03                	jmp    c01005db <stab_binsearch+0x11a>
c01005d8:	ff 4d fc             	decl   -0x4(%ebp)
c01005db:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005de:	8b 00                	mov    (%eax),%eax
c01005e0:	39 45 fc             	cmp    %eax,-0x4(%ebp)
c01005e3:	7e 1f                	jle    c0100604 <stab_binsearch+0x143>
c01005e5:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01005e8:	89 d0                	mov    %edx,%eax
c01005ea:	01 c0                	add    %eax,%eax
c01005ec:	01 d0                	add    %edx,%eax
c01005ee:	c1 e0 02             	shl    $0x2,%eax
c01005f1:	89 c2                	mov    %eax,%edx
c01005f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01005f6:	01 d0                	add    %edx,%eax
c01005f8:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01005fc:	0f b6 c0             	movzbl %al,%eax
c01005ff:	39 45 14             	cmp    %eax,0x14(%ebp)
c0100602:	75 d4                	jne    c01005d8 <stab_binsearch+0x117>
        *region_left = l;
c0100604:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100607:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010060a:	89 10                	mov    %edx,(%eax)
}
c010060c:	90                   	nop
c010060d:	c9                   	leave  
c010060e:	c3                   	ret    

c010060f <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c010060f:	55                   	push   %ebp
c0100610:	89 e5                	mov    %esp,%ebp
c0100612:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100615:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100618:	c7 00 f8 64 10 c0    	movl   $0xc01064f8,(%eax)
    info->eip_line = 0;
c010061e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100621:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c0100628:	8b 45 0c             	mov    0xc(%ebp),%eax
c010062b:	c7 40 08 f8 64 10 c0 	movl   $0xc01064f8,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100632:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100635:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c010063c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010063f:	8b 55 08             	mov    0x8(%ebp),%edx
c0100642:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100645:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100648:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c010064f:	c7 45 f4 18 78 10 c0 	movl   $0xc0107818,-0xc(%ebp)
    stab_end = __STAB_END__;
c0100656:	c7 45 f0 b4 41 11 c0 	movl   $0xc01141b4,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c010065d:	c7 45 ec b5 41 11 c0 	movl   $0xc01141b5,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100664:	c7 45 e8 42 6d 11 c0 	movl   $0xc0116d42,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c010066b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010066e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0100671:	76 0b                	jbe    c010067e <debuginfo_eip+0x6f>
c0100673:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100676:	48                   	dec    %eax
c0100677:	0f b6 00             	movzbl (%eax),%eax
c010067a:	84 c0                	test   %al,%al
c010067c:	74 0a                	je     c0100688 <debuginfo_eip+0x79>
        return -1;
c010067e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100683:	e9 ab 02 00 00       	jmp    c0100933 <debuginfo_eip+0x324>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c0100688:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c010068f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100692:	2b 45 f4             	sub    -0xc(%ebp),%eax
c0100695:	c1 f8 02             	sar    $0x2,%eax
c0100698:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c010069e:	48                   	dec    %eax
c010069f:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01006a2:	8b 45 08             	mov    0x8(%ebp),%eax
c01006a5:	89 44 24 10          	mov    %eax,0x10(%esp)
c01006a9:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01006b0:	00 
c01006b1:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01006b4:	89 44 24 08          	mov    %eax,0x8(%esp)
c01006b8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01006bb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01006bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006c2:	89 04 24             	mov    %eax,(%esp)
c01006c5:	e8 f7 fd ff ff       	call   c01004c1 <stab_binsearch>
    if (lfile == 0)
c01006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006cd:	85 c0                	test   %eax,%eax
c01006cf:	75 0a                	jne    c01006db <debuginfo_eip+0xcc>
        return -1;
c01006d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01006d6:	e9 58 02 00 00       	jmp    c0100933 <debuginfo_eip+0x324>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c01006db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006de:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01006e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006e4:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c01006e7:	8b 45 08             	mov    0x8(%ebp),%eax
c01006ea:	89 44 24 10          	mov    %eax,0x10(%esp)
c01006ee:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c01006f5:	00 
c01006f6:	8d 45 d8             	lea    -0x28(%ebp),%eax
c01006f9:	89 44 24 08          	mov    %eax,0x8(%esp)
c01006fd:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100700:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100704:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100707:	89 04 24             	mov    %eax,(%esp)
c010070a:	e8 b2 fd ff ff       	call   c01004c1 <stab_binsearch>

    if (lfun <= rfun) {
c010070f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100712:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100715:	39 c2                	cmp    %eax,%edx
c0100717:	7f 78                	jg     c0100791 <debuginfo_eip+0x182>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100719:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010071c:	89 c2                	mov    %eax,%edx
c010071e:	89 d0                	mov    %edx,%eax
c0100720:	01 c0                	add    %eax,%eax
c0100722:	01 d0                	add    %edx,%eax
c0100724:	c1 e0 02             	shl    $0x2,%eax
c0100727:	89 c2                	mov    %eax,%edx
c0100729:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010072c:	01 d0                	add    %edx,%eax
c010072e:	8b 10                	mov    (%eax),%edx
c0100730:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100733:	2b 45 ec             	sub    -0x14(%ebp),%eax
c0100736:	39 c2                	cmp    %eax,%edx
c0100738:	73 22                	jae    c010075c <debuginfo_eip+0x14d>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c010073a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010073d:	89 c2                	mov    %eax,%edx
c010073f:	89 d0                	mov    %edx,%eax
c0100741:	01 c0                	add    %eax,%eax
c0100743:	01 d0                	add    %edx,%eax
c0100745:	c1 e0 02             	shl    $0x2,%eax
c0100748:	89 c2                	mov    %eax,%edx
c010074a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010074d:	01 d0                	add    %edx,%eax
c010074f:	8b 10                	mov    (%eax),%edx
c0100751:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100754:	01 c2                	add    %eax,%edx
c0100756:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100759:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c010075c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010075f:	89 c2                	mov    %eax,%edx
c0100761:	89 d0                	mov    %edx,%eax
c0100763:	01 c0                	add    %eax,%eax
c0100765:	01 d0                	add    %edx,%eax
c0100767:	c1 e0 02             	shl    $0x2,%eax
c010076a:	89 c2                	mov    %eax,%edx
c010076c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010076f:	01 d0                	add    %edx,%eax
c0100771:	8b 50 08             	mov    0x8(%eax),%edx
c0100774:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100777:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c010077a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010077d:	8b 40 10             	mov    0x10(%eax),%eax
c0100780:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c0100783:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100786:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c0100789:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010078c:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010078f:	eb 15                	jmp    c01007a6 <debuginfo_eip+0x197>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c0100791:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100794:	8b 55 08             	mov    0x8(%ebp),%edx
c0100797:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c010079a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010079d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01007a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01007a3:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01007a6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007a9:	8b 40 08             	mov    0x8(%eax),%eax
c01007ac:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01007b3:	00 
c01007b4:	89 04 24             	mov    %eax,(%esp)
c01007b7:	e8 c8 52 00 00       	call   c0105a84 <strfind>
c01007bc:	89 c2                	mov    %eax,%edx
c01007be:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007c1:	8b 40 08             	mov    0x8(%eax),%eax
c01007c4:	29 c2                	sub    %eax,%edx
c01007c6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007c9:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c01007cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01007cf:	89 44 24 10          	mov    %eax,0x10(%esp)
c01007d3:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c01007da:	00 
c01007db:	8d 45 d0             	lea    -0x30(%ebp),%eax
c01007de:	89 44 24 08          	mov    %eax,0x8(%esp)
c01007e2:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c01007e5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01007e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007ec:	89 04 24             	mov    %eax,(%esp)
c01007ef:	e8 cd fc ff ff       	call   c01004c1 <stab_binsearch>
    if (lline <= rline) {
c01007f4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007f7:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01007fa:	39 c2                	cmp    %eax,%edx
c01007fc:	7f 23                	jg     c0100821 <debuginfo_eip+0x212>
        info->eip_line = stabs[rline].n_desc;
c01007fe:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100801:	89 c2                	mov    %eax,%edx
c0100803:	89 d0                	mov    %edx,%eax
c0100805:	01 c0                	add    %eax,%eax
c0100807:	01 d0                	add    %edx,%eax
c0100809:	c1 e0 02             	shl    $0x2,%eax
c010080c:	89 c2                	mov    %eax,%edx
c010080e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100811:	01 d0                	add    %edx,%eax
c0100813:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100817:	89 c2                	mov    %eax,%edx
c0100819:	8b 45 0c             	mov    0xc(%ebp),%eax
c010081c:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c010081f:	eb 11                	jmp    c0100832 <debuginfo_eip+0x223>
        return -1;
c0100821:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100826:	e9 08 01 00 00       	jmp    c0100933 <debuginfo_eip+0x324>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c010082b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010082e:	48                   	dec    %eax
c010082f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
c0100832:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100835:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100838:	39 c2                	cmp    %eax,%edx
c010083a:	7c 56                	jl     c0100892 <debuginfo_eip+0x283>
           && stabs[lline].n_type != N_SOL
c010083c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010083f:	89 c2                	mov    %eax,%edx
c0100841:	89 d0                	mov    %edx,%eax
c0100843:	01 c0                	add    %eax,%eax
c0100845:	01 d0                	add    %edx,%eax
c0100847:	c1 e0 02             	shl    $0x2,%eax
c010084a:	89 c2                	mov    %eax,%edx
c010084c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010084f:	01 d0                	add    %edx,%eax
c0100851:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100855:	3c 84                	cmp    $0x84,%al
c0100857:	74 39                	je     c0100892 <debuginfo_eip+0x283>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c0100859:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010085c:	89 c2                	mov    %eax,%edx
c010085e:	89 d0                	mov    %edx,%eax
c0100860:	01 c0                	add    %eax,%eax
c0100862:	01 d0                	add    %edx,%eax
c0100864:	c1 e0 02             	shl    $0x2,%eax
c0100867:	89 c2                	mov    %eax,%edx
c0100869:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010086c:	01 d0                	add    %edx,%eax
c010086e:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100872:	3c 64                	cmp    $0x64,%al
c0100874:	75 b5                	jne    c010082b <debuginfo_eip+0x21c>
c0100876:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100879:	89 c2                	mov    %eax,%edx
c010087b:	89 d0                	mov    %edx,%eax
c010087d:	01 c0                	add    %eax,%eax
c010087f:	01 d0                	add    %edx,%eax
c0100881:	c1 e0 02             	shl    $0x2,%eax
c0100884:	89 c2                	mov    %eax,%edx
c0100886:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100889:	01 d0                	add    %edx,%eax
c010088b:	8b 40 08             	mov    0x8(%eax),%eax
c010088e:	85 c0                	test   %eax,%eax
c0100890:	74 99                	je     c010082b <debuginfo_eip+0x21c>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c0100892:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100895:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100898:	39 c2                	cmp    %eax,%edx
c010089a:	7c 42                	jl     c01008de <debuginfo_eip+0x2cf>
c010089c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010089f:	89 c2                	mov    %eax,%edx
c01008a1:	89 d0                	mov    %edx,%eax
c01008a3:	01 c0                	add    %eax,%eax
c01008a5:	01 d0                	add    %edx,%eax
c01008a7:	c1 e0 02             	shl    $0x2,%eax
c01008aa:	89 c2                	mov    %eax,%edx
c01008ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008af:	01 d0                	add    %edx,%eax
c01008b1:	8b 10                	mov    (%eax),%edx
c01008b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01008b6:	2b 45 ec             	sub    -0x14(%ebp),%eax
c01008b9:	39 c2                	cmp    %eax,%edx
c01008bb:	73 21                	jae    c01008de <debuginfo_eip+0x2cf>
        info->eip_file = stabstr + stabs[lline].n_strx;
c01008bd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008c0:	89 c2                	mov    %eax,%edx
c01008c2:	89 d0                	mov    %edx,%eax
c01008c4:	01 c0                	add    %eax,%eax
c01008c6:	01 d0                	add    %edx,%eax
c01008c8:	c1 e0 02             	shl    $0x2,%eax
c01008cb:	89 c2                	mov    %eax,%edx
c01008cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008d0:	01 d0                	add    %edx,%eax
c01008d2:	8b 10                	mov    (%eax),%edx
c01008d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01008d7:	01 c2                	add    %eax,%edx
c01008d9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008dc:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c01008de:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01008e1:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01008e4:	39 c2                	cmp    %eax,%edx
c01008e6:	7d 46                	jge    c010092e <debuginfo_eip+0x31f>
        for (lline = lfun + 1;
c01008e8:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01008eb:	40                   	inc    %eax
c01008ec:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c01008ef:	eb 16                	jmp    c0100907 <debuginfo_eip+0x2f8>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c01008f1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008f4:	8b 40 14             	mov    0x14(%eax),%eax
c01008f7:	8d 50 01             	lea    0x1(%eax),%edx
c01008fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008fd:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
c0100900:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100903:	40                   	inc    %eax
c0100904:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100907:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010090a:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
c010090d:	39 c2                	cmp    %eax,%edx
c010090f:	7d 1d                	jge    c010092e <debuginfo_eip+0x31f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100911:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100914:	89 c2                	mov    %eax,%edx
c0100916:	89 d0                	mov    %edx,%eax
c0100918:	01 c0                	add    %eax,%eax
c010091a:	01 d0                	add    %edx,%eax
c010091c:	c1 e0 02             	shl    $0x2,%eax
c010091f:	89 c2                	mov    %eax,%edx
c0100921:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100924:	01 d0                	add    %edx,%eax
c0100926:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010092a:	3c a0                	cmp    $0xa0,%al
c010092c:	74 c3                	je     c01008f1 <debuginfo_eip+0x2e2>
        }
    }
    return 0;
c010092e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100933:	c9                   	leave  
c0100934:	c3                   	ret    

c0100935 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100935:	55                   	push   %ebp
c0100936:	89 e5                	mov    %esp,%ebp
c0100938:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c010093b:	c7 04 24 02 65 10 c0 	movl   $0xc0106502,(%esp)
c0100942:	e8 53 f9 ff ff       	call   c010029a <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100947:	c7 44 24 04 36 00 10 	movl   $0xc0100036,0x4(%esp)
c010094e:	c0 
c010094f:	c7 04 24 1b 65 10 c0 	movl   $0xc010651b,(%esp)
c0100956:	e8 3f f9 ff ff       	call   c010029a <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c010095b:	c7 44 24 04 fd 63 10 	movl   $0xc01063fd,0x4(%esp)
c0100962:	c0 
c0100963:	c7 04 24 33 65 10 c0 	movl   $0xc0106533,(%esp)
c010096a:	e8 2b f9 ff ff       	call   c010029a <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c010096f:	c7 44 24 04 00 c0 11 	movl   $0xc011c000,0x4(%esp)
c0100976:	c0 
c0100977:	c7 04 24 4b 65 10 c0 	movl   $0xc010654b,(%esp)
c010097e:	e8 17 f9 ff ff       	call   c010029a <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c0100983:	c7 44 24 04 48 cf 11 	movl   $0xc011cf48,0x4(%esp)
c010098a:	c0 
c010098b:	c7 04 24 63 65 10 c0 	movl   $0xc0106563,(%esp)
c0100992:	e8 03 f9 ff ff       	call   c010029a <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c0100997:	b8 48 cf 11 c0       	mov    $0xc011cf48,%eax
c010099c:	2d 36 00 10 c0       	sub    $0xc0100036,%eax
c01009a1:	05 ff 03 00 00       	add    $0x3ff,%eax
c01009a6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01009ac:	85 c0                	test   %eax,%eax
c01009ae:	0f 48 c2             	cmovs  %edx,%eax
c01009b1:	c1 f8 0a             	sar    $0xa,%eax
c01009b4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009b8:	c7 04 24 7c 65 10 c0 	movl   $0xc010657c,(%esp)
c01009bf:	e8 d6 f8 ff ff       	call   c010029a <cprintf>
}
c01009c4:	90                   	nop
c01009c5:	c9                   	leave  
c01009c6:	c3                   	ret    

c01009c7 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c01009c7:	55                   	push   %ebp
c01009c8:	89 e5                	mov    %esp,%ebp
c01009ca:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c01009d0:	8d 45 dc             	lea    -0x24(%ebp),%eax
c01009d3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009d7:	8b 45 08             	mov    0x8(%ebp),%eax
c01009da:	89 04 24             	mov    %eax,(%esp)
c01009dd:	e8 2d fc ff ff       	call   c010060f <debuginfo_eip>
c01009e2:	85 c0                	test   %eax,%eax
c01009e4:	74 15                	je     c01009fb <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c01009e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01009e9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009ed:	c7 04 24 a6 65 10 c0 	movl   $0xc01065a6,(%esp)
c01009f4:	e8 a1 f8 ff ff       	call   c010029a <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
c01009f9:	eb 6c                	jmp    c0100a67 <print_debuginfo+0xa0>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c01009fb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100a02:	eb 1b                	jmp    c0100a1f <print_debuginfo+0x58>
            fnname[j] = info.eip_fn_name[j];
c0100a04:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100a07:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a0a:	01 d0                	add    %edx,%eax
c0100a0c:	0f b6 10             	movzbl (%eax),%edx
c0100a0f:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a18:	01 c8                	add    %ecx,%eax
c0100a1a:	88 10                	mov    %dl,(%eax)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a1c:	ff 45 f4             	incl   -0xc(%ebp)
c0100a1f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a22:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0100a25:	7c dd                	jl     c0100a04 <print_debuginfo+0x3d>
        fnname[j] = '\0';
c0100a27:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100a2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a30:	01 d0                	add    %edx,%eax
c0100a32:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
c0100a35:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100a38:	8b 55 08             	mov    0x8(%ebp),%edx
c0100a3b:	89 d1                	mov    %edx,%ecx
c0100a3d:	29 c1                	sub    %eax,%ecx
c0100a3f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100a42:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100a45:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100a49:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a4f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100a53:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100a57:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a5b:	c7 04 24 c2 65 10 c0 	movl   $0xc01065c2,(%esp)
c0100a62:	e8 33 f8 ff ff       	call   c010029a <cprintf>
}
c0100a67:	90                   	nop
c0100a68:	c9                   	leave  
c0100a69:	c3                   	ret    

c0100a6a <read_eip>:

static __noinline uint32_t
read_eip(void) {
c0100a6a:	55                   	push   %ebp
c0100a6b:	89 e5                	mov    %esp,%ebp
c0100a6d:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c0100a70:	8b 45 04             	mov    0x4(%ebp),%eax
c0100a73:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c0100a76:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0100a79:	c9                   	leave  
c0100a7a:	c3                   	ret    

c0100a7b <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c0100a7b:	55                   	push   %ebp
c0100a7c:	89 e5                	mov    %esp,%ebp
c0100a7e:	83 ec 38             	sub    $0x38,%esp

	/* In my version, I don't popup the calling stackframe. After exeution of print_stackframe,
	 * PC still point to current stackframe(the stackframe of print_stackframe()) 
	 */
	uint32_t eip, ebp;
	size_t i = 0, j = 0;
c0100a81:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0100a88:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	eip = read_eip();
c0100a8f:	e8 d6 ff ff ff       	call   c0100a6a <read_eip>
c0100a94:	89 45 f4             	mov    %eax,-0xc(%ebp)
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c0100a97:	89 e8                	mov    %ebp,%eax
c0100a99:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return ebp;
c0100a9c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
	ebp = read_ebp();
c0100a9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i++) {
c0100aa2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0100aa9:	e9 88 00 00 00       	jmp    c0100b36 <print_stackframe+0xbb>
		cprintf("ebp:0x%08x eip:0x%08x ", ebp, eip);
c0100aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ab1:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100ab5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100ab8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100abc:	c7 04 24 d4 65 10 c0 	movl   $0xc01065d4,(%esp)
c0100ac3:	e8 d2 f7 ff ff       	call   c010029a <cprintf>
		cprintf("args:");
c0100ac8:	c7 04 24 eb 65 10 c0 	movl   $0xc01065eb,(%esp)
c0100acf:	e8 c6 f7 ff ff       	call   c010029a <cprintf>
		for(j = 0; j < 4; j++) {
c0100ad4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100adb:	eb 25                	jmp    c0100b02 <print_stackframe+0x87>
			cprintf("0x%08x ", (uint32_t*)(ebp) + 2 + j);
c0100add:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100ae0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100ae7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100aea:	01 d0                	add    %edx,%eax
c0100aec:	83 c0 08             	add    $0x8,%eax
c0100aef:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100af3:	c7 04 24 f1 65 10 c0 	movl   $0xc01065f1,(%esp)
c0100afa:	e8 9b f7 ff ff       	call   c010029a <cprintf>
		for(j = 0; j < 4; j++) {
c0100aff:	ff 45 e8             	incl   -0x18(%ebp)
c0100b02:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100b06:	76 d5                	jbe    c0100add <print_stackframe+0x62>
		}
		cprintf("\n");
c0100b08:	c7 04 24 f9 65 10 c0 	movl   $0xc01065f9,(%esp)
c0100b0f:	e8 86 f7 ff ff       	call   c010029a <cprintf>
		print_debuginfo(eip - 1);
c0100b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b17:	48                   	dec    %eax
c0100b18:	89 04 24             	mov    %eax,(%esp)
c0100b1b:	e8 a7 fe ff ff       	call   c01009c7 <print_debuginfo>
		ebp = *((uint32_t *)ebp);		
c0100b20:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100b23:	8b 00                	mov    (%eax),%eax
c0100b25:	89 45 f0             	mov    %eax,-0x10(%ebp)
		eip = *((uint32_t *)ebp + 1);
c0100b28:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100b2b:	83 c0 04             	add    $0x4,%eax
c0100b2e:	8b 00                	mov    (%eax),%eax
c0100b30:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i++) {
c0100b33:	ff 45 ec             	incl   -0x14(%ebp)
c0100b36:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b3a:	74 0a                	je     c0100b46 <print_stackframe+0xcb>
c0100b3c:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100b40:	0f 86 68 ff ff ff    	jbe    c0100aae <print_stackframe+0x33>
        ebp = ((uint32_t *)ebp)[0];
    }
	*/


}
c0100b46:	90                   	nop
c0100b47:	c9                   	leave  
c0100b48:	c3                   	ret    

c0100b49 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100b49:	55                   	push   %ebp
c0100b4a:	89 e5                	mov    %esp,%ebp
c0100b4c:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100b4f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b56:	eb 0c                	jmp    c0100b64 <parse+0x1b>
            *buf ++ = '\0';
c0100b58:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b5b:	8d 50 01             	lea    0x1(%eax),%edx
c0100b5e:	89 55 08             	mov    %edx,0x8(%ebp)
c0100b61:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b64:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b67:	0f b6 00             	movzbl (%eax),%eax
c0100b6a:	84 c0                	test   %al,%al
c0100b6c:	74 1d                	je     c0100b8b <parse+0x42>
c0100b6e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b71:	0f b6 00             	movzbl (%eax),%eax
c0100b74:	0f be c0             	movsbl %al,%eax
c0100b77:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b7b:	c7 04 24 7c 66 10 c0 	movl   $0xc010667c,(%esp)
c0100b82:	e8 cb 4e 00 00       	call   c0105a52 <strchr>
c0100b87:	85 c0                	test   %eax,%eax
c0100b89:	75 cd                	jne    c0100b58 <parse+0xf>
        }
        if (*buf == '\0') {
c0100b8b:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b8e:	0f b6 00             	movzbl (%eax),%eax
c0100b91:	84 c0                	test   %al,%al
c0100b93:	74 65                	je     c0100bfa <parse+0xb1>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100b95:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100b99:	75 14                	jne    c0100baf <parse+0x66>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100b9b:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100ba2:	00 
c0100ba3:	c7 04 24 81 66 10 c0 	movl   $0xc0106681,(%esp)
c0100baa:	e8 eb f6 ff ff       	call   c010029a <cprintf>
        }
        argv[argc ++] = buf;
c0100baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bb2:	8d 50 01             	lea    0x1(%eax),%edx
c0100bb5:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100bb8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100bbf:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100bc2:	01 c2                	add    %eax,%edx
c0100bc4:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bc7:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100bc9:	eb 03                	jmp    c0100bce <parse+0x85>
            buf ++;
c0100bcb:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100bce:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bd1:	0f b6 00             	movzbl (%eax),%eax
c0100bd4:	84 c0                	test   %al,%al
c0100bd6:	74 8c                	je     c0100b64 <parse+0x1b>
c0100bd8:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bdb:	0f b6 00             	movzbl (%eax),%eax
c0100bde:	0f be c0             	movsbl %al,%eax
c0100be1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100be5:	c7 04 24 7c 66 10 c0 	movl   $0xc010667c,(%esp)
c0100bec:	e8 61 4e 00 00       	call   c0105a52 <strchr>
c0100bf1:	85 c0                	test   %eax,%eax
c0100bf3:	74 d6                	je     c0100bcb <parse+0x82>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100bf5:	e9 6a ff ff ff       	jmp    c0100b64 <parse+0x1b>
            break;
c0100bfa:	90                   	nop
        }
    }
    return argc;
c0100bfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100bfe:	c9                   	leave  
c0100bff:	c3                   	ret    

c0100c00 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100c00:	55                   	push   %ebp
c0100c01:	89 e5                	mov    %esp,%ebp
c0100c03:	53                   	push   %ebx
c0100c04:	83 ec 64             	sub    $0x64,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100c07:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100c0a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c0e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c11:	89 04 24             	mov    %eax,(%esp)
c0100c14:	e8 30 ff ff ff       	call   c0100b49 <parse>
c0100c19:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100c1c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100c20:	75 0a                	jne    c0100c2c <runcmd+0x2c>
        return 0;
c0100c22:	b8 00 00 00 00       	mov    $0x0,%eax
c0100c27:	e9 83 00 00 00       	jmp    c0100caf <runcmd+0xaf>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c2c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c33:	eb 5a                	jmp    c0100c8f <runcmd+0x8f>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100c35:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100c38:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c3b:	89 d0                	mov    %edx,%eax
c0100c3d:	01 c0                	add    %eax,%eax
c0100c3f:	01 d0                	add    %edx,%eax
c0100c41:	c1 e0 02             	shl    $0x2,%eax
c0100c44:	05 00 90 11 c0       	add    $0xc0119000,%eax
c0100c49:	8b 00                	mov    (%eax),%eax
c0100c4b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100c4f:	89 04 24             	mov    %eax,(%esp)
c0100c52:	e8 5e 4d 00 00       	call   c01059b5 <strcmp>
c0100c57:	85 c0                	test   %eax,%eax
c0100c59:	75 31                	jne    c0100c8c <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100c5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c5e:	89 d0                	mov    %edx,%eax
c0100c60:	01 c0                	add    %eax,%eax
c0100c62:	01 d0                	add    %edx,%eax
c0100c64:	c1 e0 02             	shl    $0x2,%eax
c0100c67:	05 08 90 11 c0       	add    $0xc0119008,%eax
c0100c6c:	8b 10                	mov    (%eax),%edx
c0100c6e:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100c71:	83 c0 04             	add    $0x4,%eax
c0100c74:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0100c77:	8d 59 ff             	lea    -0x1(%ecx),%ebx
c0100c7a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c0100c7d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100c81:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c85:	89 1c 24             	mov    %ebx,(%esp)
c0100c88:	ff d2                	call   *%edx
c0100c8a:	eb 23                	jmp    c0100caf <runcmd+0xaf>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c8c:	ff 45 f4             	incl   -0xc(%ebp)
c0100c8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c92:	83 f8 02             	cmp    $0x2,%eax
c0100c95:	76 9e                	jbe    c0100c35 <runcmd+0x35>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100c97:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100c9a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c9e:	c7 04 24 9f 66 10 c0 	movl   $0xc010669f,(%esp)
c0100ca5:	e8 f0 f5 ff ff       	call   c010029a <cprintf>
    return 0;
c0100caa:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100caf:	83 c4 64             	add    $0x64,%esp
c0100cb2:	5b                   	pop    %ebx
c0100cb3:	5d                   	pop    %ebp
c0100cb4:	c3                   	ret    

c0100cb5 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100cb5:	55                   	push   %ebp
c0100cb6:	89 e5                	mov    %esp,%ebp
c0100cb8:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100cbb:	c7 04 24 b8 66 10 c0 	movl   $0xc01066b8,(%esp)
c0100cc2:	e8 d3 f5 ff ff       	call   c010029a <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100cc7:	c7 04 24 e0 66 10 c0 	movl   $0xc01066e0,(%esp)
c0100cce:	e8 c7 f5 ff ff       	call   c010029a <cprintf>

    if (tf != NULL) {
c0100cd3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100cd7:	74 0b                	je     c0100ce4 <kmonitor+0x2f>
        print_trapframe(tf);
c0100cd9:	8b 45 08             	mov    0x8(%ebp),%eax
c0100cdc:	89 04 24             	mov    %eax,(%esp)
c0100cdf:	e8 b2 0e 00 00       	call   c0101b96 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100ce4:	c7 04 24 05 67 10 c0 	movl   $0xc0106705,(%esp)
c0100ceb:	e8 4d f6 ff ff       	call   c010033d <readline>
c0100cf0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100cf3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100cf7:	74 eb                	je     c0100ce4 <kmonitor+0x2f>
            if (runcmd(buf, tf) < 0) {
c0100cf9:	8b 45 08             	mov    0x8(%ebp),%eax
c0100cfc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d00:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d03:	89 04 24             	mov    %eax,(%esp)
c0100d06:	e8 f5 fe ff ff       	call   c0100c00 <runcmd>
c0100d0b:	85 c0                	test   %eax,%eax
c0100d0d:	78 02                	js     c0100d11 <kmonitor+0x5c>
        if ((buf = readline("K> ")) != NULL) {
c0100d0f:	eb d3                	jmp    c0100ce4 <kmonitor+0x2f>
                break;
c0100d11:	90                   	nop
            }
        }
    }
}
c0100d12:	90                   	nop
c0100d13:	c9                   	leave  
c0100d14:	c3                   	ret    

c0100d15 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100d15:	55                   	push   %ebp
c0100d16:	89 e5                	mov    %esp,%ebp
c0100d18:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100d1b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100d22:	eb 3d                	jmp    c0100d61 <mon_help+0x4c>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100d24:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d27:	89 d0                	mov    %edx,%eax
c0100d29:	01 c0                	add    %eax,%eax
c0100d2b:	01 d0                	add    %edx,%eax
c0100d2d:	c1 e0 02             	shl    $0x2,%eax
c0100d30:	05 04 90 11 c0       	add    $0xc0119004,%eax
c0100d35:	8b 08                	mov    (%eax),%ecx
c0100d37:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d3a:	89 d0                	mov    %edx,%eax
c0100d3c:	01 c0                	add    %eax,%eax
c0100d3e:	01 d0                	add    %edx,%eax
c0100d40:	c1 e0 02             	shl    $0x2,%eax
c0100d43:	05 00 90 11 c0       	add    $0xc0119000,%eax
c0100d48:	8b 00                	mov    (%eax),%eax
c0100d4a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100d4e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d52:	c7 04 24 09 67 10 c0 	movl   $0xc0106709,(%esp)
c0100d59:	e8 3c f5 ff ff       	call   c010029a <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100d5e:	ff 45 f4             	incl   -0xc(%ebp)
c0100d61:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d64:	83 f8 02             	cmp    $0x2,%eax
c0100d67:	76 bb                	jbe    c0100d24 <mon_help+0xf>
    }
    return 0;
c0100d69:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d6e:	c9                   	leave  
c0100d6f:	c3                   	ret    

c0100d70 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100d70:	55                   	push   %ebp
c0100d71:	89 e5                	mov    %esp,%ebp
c0100d73:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100d76:	e8 ba fb ff ff       	call   c0100935 <print_kerninfo>
    return 0;
c0100d7b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d80:	c9                   	leave  
c0100d81:	c3                   	ret    

c0100d82 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100d82:	55                   	push   %ebp
c0100d83:	89 e5                	mov    %esp,%ebp
c0100d85:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100d88:	e8 ee fc ff ff       	call   c0100a7b <print_stackframe>
    return 0;
c0100d8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d92:	c9                   	leave  
c0100d93:	c3                   	ret    

c0100d94 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100d94:	55                   	push   %ebp
c0100d95:	89 e5                	mov    %esp,%ebp
c0100d97:	83 ec 28             	sub    $0x28,%esp
c0100d9a:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
c0100da0:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100da4:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100da8:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100dac:	ee                   	out    %al,(%dx)
c0100dad:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100db3:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100db7:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100dbb:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100dbf:	ee                   	out    %al,(%dx)
c0100dc0:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
c0100dc6:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
c0100dca:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100dce:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100dd2:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100dd3:	c7 05 2c cf 11 c0 00 	movl   $0x0,0xc011cf2c
c0100dda:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100ddd:	c7 04 24 12 67 10 c0 	movl   $0xc0106712,(%esp)
c0100de4:	e8 b1 f4 ff ff       	call   c010029a <cprintf>
    pic_enable(IRQ_TIMER);
c0100de9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100df0:	e8 2e 09 00 00       	call   c0101723 <pic_enable>
}
c0100df5:	90                   	nop
c0100df6:	c9                   	leave  
c0100df7:	c3                   	ret    

c0100df8 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100df8:	55                   	push   %ebp
c0100df9:	89 e5                	mov    %esp,%ebp
c0100dfb:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100dfe:	9c                   	pushf  
c0100dff:	58                   	pop    %eax
c0100e00:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100e03:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100e06:	25 00 02 00 00       	and    $0x200,%eax
c0100e0b:	85 c0                	test   %eax,%eax
c0100e0d:	74 0c                	je     c0100e1b <__intr_save+0x23>
        intr_disable();
c0100e0f:	e8 83 0a 00 00       	call   c0101897 <intr_disable>
        return 1;
c0100e14:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e19:	eb 05                	jmp    c0100e20 <__intr_save+0x28>
    }
    return 0;
c0100e1b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e20:	c9                   	leave  
c0100e21:	c3                   	ret    

c0100e22 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e22:	55                   	push   %ebp
c0100e23:	89 e5                	mov    %esp,%ebp
c0100e25:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e28:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e2c:	74 05                	je     c0100e33 <__intr_restore+0x11>
        intr_enable();
c0100e2e:	e8 5d 0a 00 00       	call   c0101890 <intr_enable>
    }
}
c0100e33:	90                   	nop
c0100e34:	c9                   	leave  
c0100e35:	c3                   	ret    

c0100e36 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e36:	55                   	push   %ebp
c0100e37:	89 e5                	mov    %esp,%ebp
c0100e39:	83 ec 10             	sub    $0x10,%esp
c0100e3c:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e42:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e46:	89 c2                	mov    %eax,%edx
c0100e48:	ec                   	in     (%dx),%al
c0100e49:	88 45 f1             	mov    %al,-0xf(%ebp)
c0100e4c:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e52:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e56:	89 c2                	mov    %eax,%edx
c0100e58:	ec                   	in     (%dx),%al
c0100e59:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e5c:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e62:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e66:	89 c2                	mov    %eax,%edx
c0100e68:	ec                   	in     (%dx),%al
c0100e69:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100e6c:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
c0100e72:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e76:	89 c2                	mov    %eax,%edx
c0100e78:	ec                   	in     (%dx),%al
c0100e79:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e7c:	90                   	nop
c0100e7d:	c9                   	leave  
c0100e7e:	c3                   	ret    

c0100e7f <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e7f:	55                   	push   %ebp
c0100e80:	89 e5                	mov    %esp,%ebp
c0100e82:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e85:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100e8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e8f:	0f b7 00             	movzwl (%eax),%eax
c0100e92:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100e96:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e99:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100e9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ea1:	0f b7 00             	movzwl (%eax),%eax
c0100ea4:	0f b7 c0             	movzwl %ax,%eax
c0100ea7:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
c0100eac:	74 12                	je     c0100ec0 <cga_init+0x41>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100eae:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100eb5:	66 c7 05 46 c4 11 c0 	movw   $0x3b4,0xc011c446
c0100ebc:	b4 03 
c0100ebe:	eb 13                	jmp    c0100ed3 <cga_init+0x54>
    } else {
        *cp = was;
c0100ec0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ec3:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100ec7:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100eca:	66 c7 05 46 c4 11 c0 	movw   $0x3d4,0xc011c446
c0100ed1:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100ed3:	0f b7 05 46 c4 11 c0 	movzwl 0xc011c446,%eax
c0100eda:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c0100ede:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ee2:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100ee6:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100eea:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100eeb:	0f b7 05 46 c4 11 c0 	movzwl 0xc011c446,%eax
c0100ef2:	40                   	inc    %eax
c0100ef3:	0f b7 c0             	movzwl %ax,%eax
c0100ef6:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100efa:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100efe:	89 c2                	mov    %eax,%edx
c0100f00:	ec                   	in     (%dx),%al
c0100f01:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
c0100f04:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f08:	0f b6 c0             	movzbl %al,%eax
c0100f0b:	c1 e0 08             	shl    $0x8,%eax
c0100f0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100f11:	0f b7 05 46 c4 11 c0 	movzwl 0xc011c446,%eax
c0100f18:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0100f1c:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f20:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f24:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f28:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100f29:	0f b7 05 46 c4 11 c0 	movzwl 0xc011c446,%eax
c0100f30:	40                   	inc    %eax
c0100f31:	0f b7 c0             	movzwl %ax,%eax
c0100f34:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f38:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100f3c:	89 c2                	mov    %eax,%edx
c0100f3e:	ec                   	in     (%dx),%al
c0100f3f:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
c0100f42:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f46:	0f b6 c0             	movzbl %al,%eax
c0100f49:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f4f:	a3 40 c4 11 c0       	mov    %eax,0xc011c440
    crt_pos = pos;
c0100f54:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f57:	0f b7 c0             	movzwl %ax,%eax
c0100f5a:	66 a3 44 c4 11 c0    	mov    %ax,0xc011c444
}
c0100f60:	90                   	nop
c0100f61:	c9                   	leave  
c0100f62:	c3                   	ret    

c0100f63 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f63:	55                   	push   %ebp
c0100f64:	89 e5                	mov    %esp,%ebp
c0100f66:	83 ec 48             	sub    $0x48,%esp
c0100f69:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
c0100f6f:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f73:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0100f77:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0100f7b:	ee                   	out    %al,(%dx)
c0100f7c:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
c0100f82:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
c0100f86:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0100f8a:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0100f8e:	ee                   	out    %al,(%dx)
c0100f8f:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
c0100f95:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
c0100f99:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0100f9d:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0100fa1:	ee                   	out    %al,(%dx)
c0100fa2:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100fa8:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
c0100fac:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100fb0:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100fb4:	ee                   	out    %al,(%dx)
c0100fb5:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
c0100fbb:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
c0100fbf:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100fc3:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100fc7:	ee                   	out    %al,(%dx)
c0100fc8:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
c0100fce:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
c0100fd2:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100fd6:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100fda:	ee                   	out    %al,(%dx)
c0100fdb:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100fe1:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
c0100fe5:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100fe9:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100fed:	ee                   	out    %al,(%dx)
c0100fee:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ff4:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100ff8:	89 c2                	mov    %eax,%edx
c0100ffa:	ec                   	in     (%dx),%al
c0100ffb:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100ffe:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0101002:	3c ff                	cmp    $0xff,%al
c0101004:	0f 95 c0             	setne  %al
c0101007:	0f b6 c0             	movzbl %al,%eax
c010100a:	a3 48 c4 11 c0       	mov    %eax,0xc011c448
c010100f:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101015:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101019:	89 c2                	mov    %eax,%edx
c010101b:	ec                   	in     (%dx),%al
c010101c:	88 45 f1             	mov    %al,-0xf(%ebp)
c010101f:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101025:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101029:	89 c2                	mov    %eax,%edx
c010102b:	ec                   	in     (%dx),%al
c010102c:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c010102f:	a1 48 c4 11 c0       	mov    0xc011c448,%eax
c0101034:	85 c0                	test   %eax,%eax
c0101036:	74 0c                	je     c0101044 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c0101038:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c010103f:	e8 df 06 00 00       	call   c0101723 <pic_enable>
    }
}
c0101044:	90                   	nop
c0101045:	c9                   	leave  
c0101046:	c3                   	ret    

c0101047 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c0101047:	55                   	push   %ebp
c0101048:	89 e5                	mov    %esp,%ebp
c010104a:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c010104d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101054:	eb 08                	jmp    c010105e <lpt_putc_sub+0x17>
        delay();
c0101056:	e8 db fd ff ff       	call   c0100e36 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c010105b:	ff 45 fc             	incl   -0x4(%ebp)
c010105e:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c0101064:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101068:	89 c2                	mov    %eax,%edx
c010106a:	ec                   	in     (%dx),%al
c010106b:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c010106e:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101072:	84 c0                	test   %al,%al
c0101074:	78 09                	js     c010107f <lpt_putc_sub+0x38>
c0101076:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c010107d:	7e d7                	jle    c0101056 <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
c010107f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101082:	0f b6 c0             	movzbl %al,%eax
c0101085:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
c010108b:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010108e:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101092:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101096:	ee                   	out    %al,(%dx)
c0101097:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c010109d:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c01010a1:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01010a5:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01010a9:	ee                   	out    %al,(%dx)
c01010aa:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
c01010b0:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
c01010b4:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c01010b8:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01010bc:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01010bd:	90                   	nop
c01010be:	c9                   	leave  
c01010bf:	c3                   	ret    

c01010c0 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01010c0:	55                   	push   %ebp
c01010c1:	89 e5                	mov    %esp,%ebp
c01010c3:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01010c6:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01010ca:	74 0d                	je     c01010d9 <lpt_putc+0x19>
        lpt_putc_sub(c);
c01010cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01010cf:	89 04 24             	mov    %eax,(%esp)
c01010d2:	e8 70 ff ff ff       	call   c0101047 <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
c01010d7:	eb 24                	jmp    c01010fd <lpt_putc+0x3d>
        lpt_putc_sub('\b');
c01010d9:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010e0:	e8 62 ff ff ff       	call   c0101047 <lpt_putc_sub>
        lpt_putc_sub(' ');
c01010e5:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01010ec:	e8 56 ff ff ff       	call   c0101047 <lpt_putc_sub>
        lpt_putc_sub('\b');
c01010f1:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010f8:	e8 4a ff ff ff       	call   c0101047 <lpt_putc_sub>
}
c01010fd:	90                   	nop
c01010fe:	c9                   	leave  
c01010ff:	c3                   	ret    

c0101100 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c0101100:	55                   	push   %ebp
c0101101:	89 e5                	mov    %esp,%ebp
c0101103:	53                   	push   %ebx
c0101104:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c0101107:	8b 45 08             	mov    0x8(%ebp),%eax
c010110a:	25 00 ff ff ff       	and    $0xffffff00,%eax
c010110f:	85 c0                	test   %eax,%eax
c0101111:	75 07                	jne    c010111a <cga_putc+0x1a>
        c |= 0x0700;
c0101113:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c010111a:	8b 45 08             	mov    0x8(%ebp),%eax
c010111d:	0f b6 c0             	movzbl %al,%eax
c0101120:	83 f8 0a             	cmp    $0xa,%eax
c0101123:	74 55                	je     c010117a <cga_putc+0x7a>
c0101125:	83 f8 0d             	cmp    $0xd,%eax
c0101128:	74 63                	je     c010118d <cga_putc+0x8d>
c010112a:	83 f8 08             	cmp    $0x8,%eax
c010112d:	0f 85 94 00 00 00    	jne    c01011c7 <cga_putc+0xc7>
    case '\b':
        if (crt_pos > 0) {
c0101133:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c010113a:	85 c0                	test   %eax,%eax
c010113c:	0f 84 af 00 00 00    	je     c01011f1 <cga_putc+0xf1>
            crt_pos --;
c0101142:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c0101149:	48                   	dec    %eax
c010114a:	0f b7 c0             	movzwl %ax,%eax
c010114d:	66 a3 44 c4 11 c0    	mov    %ax,0xc011c444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c0101153:	8b 45 08             	mov    0x8(%ebp),%eax
c0101156:	98                   	cwtl   
c0101157:	25 00 ff ff ff       	and    $0xffffff00,%eax
c010115c:	98                   	cwtl   
c010115d:	83 c8 20             	or     $0x20,%eax
c0101160:	98                   	cwtl   
c0101161:	8b 15 40 c4 11 c0    	mov    0xc011c440,%edx
c0101167:	0f b7 0d 44 c4 11 c0 	movzwl 0xc011c444,%ecx
c010116e:	01 c9                	add    %ecx,%ecx
c0101170:	01 ca                	add    %ecx,%edx
c0101172:	0f b7 c0             	movzwl %ax,%eax
c0101175:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c0101178:	eb 77                	jmp    c01011f1 <cga_putc+0xf1>
    case '\n':
        crt_pos += CRT_COLS;
c010117a:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c0101181:	83 c0 50             	add    $0x50,%eax
c0101184:	0f b7 c0             	movzwl %ax,%eax
c0101187:	66 a3 44 c4 11 c0    	mov    %ax,0xc011c444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c010118d:	0f b7 1d 44 c4 11 c0 	movzwl 0xc011c444,%ebx
c0101194:	0f b7 0d 44 c4 11 c0 	movzwl 0xc011c444,%ecx
c010119b:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
c01011a0:	89 c8                	mov    %ecx,%eax
c01011a2:	f7 e2                	mul    %edx
c01011a4:	c1 ea 06             	shr    $0x6,%edx
c01011a7:	89 d0                	mov    %edx,%eax
c01011a9:	c1 e0 02             	shl    $0x2,%eax
c01011ac:	01 d0                	add    %edx,%eax
c01011ae:	c1 e0 04             	shl    $0x4,%eax
c01011b1:	29 c1                	sub    %eax,%ecx
c01011b3:	89 c8                	mov    %ecx,%eax
c01011b5:	0f b7 c0             	movzwl %ax,%eax
c01011b8:	29 c3                	sub    %eax,%ebx
c01011ba:	89 d8                	mov    %ebx,%eax
c01011bc:	0f b7 c0             	movzwl %ax,%eax
c01011bf:	66 a3 44 c4 11 c0    	mov    %ax,0xc011c444
        break;
c01011c5:	eb 2b                	jmp    c01011f2 <cga_putc+0xf2>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01011c7:	8b 0d 40 c4 11 c0    	mov    0xc011c440,%ecx
c01011cd:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c01011d4:	8d 50 01             	lea    0x1(%eax),%edx
c01011d7:	0f b7 d2             	movzwl %dx,%edx
c01011da:	66 89 15 44 c4 11 c0 	mov    %dx,0xc011c444
c01011e1:	01 c0                	add    %eax,%eax
c01011e3:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c01011e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01011e9:	0f b7 c0             	movzwl %ax,%eax
c01011ec:	66 89 02             	mov    %ax,(%edx)
        break;
c01011ef:	eb 01                	jmp    c01011f2 <cga_putc+0xf2>
        break;
c01011f1:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01011f2:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c01011f9:	3d cf 07 00 00       	cmp    $0x7cf,%eax
c01011fe:	76 5d                	jbe    c010125d <cga_putc+0x15d>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c0101200:	a1 40 c4 11 c0       	mov    0xc011c440,%eax
c0101205:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c010120b:	a1 40 c4 11 c0       	mov    0xc011c440,%eax
c0101210:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c0101217:	00 
c0101218:	89 54 24 04          	mov    %edx,0x4(%esp)
c010121c:	89 04 24             	mov    %eax,(%esp)
c010121f:	e8 24 4a 00 00       	call   c0105c48 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101224:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c010122b:	eb 14                	jmp    c0101241 <cga_putc+0x141>
            crt_buf[i] = 0x0700 | ' ';
c010122d:	a1 40 c4 11 c0       	mov    0xc011c440,%eax
c0101232:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101235:	01 d2                	add    %edx,%edx
c0101237:	01 d0                	add    %edx,%eax
c0101239:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c010123e:	ff 45 f4             	incl   -0xc(%ebp)
c0101241:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c0101248:	7e e3                	jle    c010122d <cga_putc+0x12d>
        }
        crt_pos -= CRT_COLS;
c010124a:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c0101251:	83 e8 50             	sub    $0x50,%eax
c0101254:	0f b7 c0             	movzwl %ax,%eax
c0101257:	66 a3 44 c4 11 c0    	mov    %ax,0xc011c444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c010125d:	0f b7 05 46 c4 11 c0 	movzwl 0xc011c446,%eax
c0101264:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c0101268:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
c010126c:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101270:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101274:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c0101275:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c010127c:	c1 e8 08             	shr    $0x8,%eax
c010127f:	0f b7 c0             	movzwl %ax,%eax
c0101282:	0f b6 c0             	movzbl %al,%eax
c0101285:	0f b7 15 46 c4 11 c0 	movzwl 0xc011c446,%edx
c010128c:	42                   	inc    %edx
c010128d:	0f b7 d2             	movzwl %dx,%edx
c0101290:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101294:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101297:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010129b:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010129f:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c01012a0:	0f b7 05 46 c4 11 c0 	movzwl 0xc011c446,%eax
c01012a7:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c01012ab:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
c01012af:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01012b3:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01012b7:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c01012b8:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c01012bf:	0f b6 c0             	movzbl %al,%eax
c01012c2:	0f b7 15 46 c4 11 c0 	movzwl 0xc011c446,%edx
c01012c9:	42                   	inc    %edx
c01012ca:	0f b7 d2             	movzwl %dx,%edx
c01012cd:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
c01012d1:	88 45 f1             	mov    %al,-0xf(%ebp)
c01012d4:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01012d8:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01012dc:	ee                   	out    %al,(%dx)
}
c01012dd:	90                   	nop
c01012de:	83 c4 34             	add    $0x34,%esp
c01012e1:	5b                   	pop    %ebx
c01012e2:	5d                   	pop    %ebp
c01012e3:	c3                   	ret    

c01012e4 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01012e4:	55                   	push   %ebp
c01012e5:	89 e5                	mov    %esp,%ebp
c01012e7:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012ea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01012f1:	eb 08                	jmp    c01012fb <serial_putc_sub+0x17>
        delay();
c01012f3:	e8 3e fb ff ff       	call   c0100e36 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012f8:	ff 45 fc             	incl   -0x4(%ebp)
c01012fb:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101301:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101305:	89 c2                	mov    %eax,%edx
c0101307:	ec                   	in     (%dx),%al
c0101308:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c010130b:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010130f:	0f b6 c0             	movzbl %al,%eax
c0101312:	83 e0 20             	and    $0x20,%eax
c0101315:	85 c0                	test   %eax,%eax
c0101317:	75 09                	jne    c0101322 <serial_putc_sub+0x3e>
c0101319:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101320:	7e d1                	jle    c01012f3 <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
c0101322:	8b 45 08             	mov    0x8(%ebp),%eax
c0101325:	0f b6 c0             	movzbl %al,%eax
c0101328:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c010132e:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101331:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101335:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101339:	ee                   	out    %al,(%dx)
}
c010133a:	90                   	nop
c010133b:	c9                   	leave  
c010133c:	c3                   	ret    

c010133d <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c010133d:	55                   	push   %ebp
c010133e:	89 e5                	mov    %esp,%ebp
c0101340:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101343:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101347:	74 0d                	je     c0101356 <serial_putc+0x19>
        serial_putc_sub(c);
c0101349:	8b 45 08             	mov    0x8(%ebp),%eax
c010134c:	89 04 24             	mov    %eax,(%esp)
c010134f:	e8 90 ff ff ff       	call   c01012e4 <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
c0101354:	eb 24                	jmp    c010137a <serial_putc+0x3d>
        serial_putc_sub('\b');
c0101356:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010135d:	e8 82 ff ff ff       	call   c01012e4 <serial_putc_sub>
        serial_putc_sub(' ');
c0101362:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101369:	e8 76 ff ff ff       	call   c01012e4 <serial_putc_sub>
        serial_putc_sub('\b');
c010136e:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101375:	e8 6a ff ff ff       	call   c01012e4 <serial_putc_sub>
}
c010137a:	90                   	nop
c010137b:	c9                   	leave  
c010137c:	c3                   	ret    

c010137d <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c010137d:	55                   	push   %ebp
c010137e:	89 e5                	mov    %esp,%ebp
c0101380:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c0101383:	eb 33                	jmp    c01013b8 <cons_intr+0x3b>
        if (c != 0) {
c0101385:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101389:	74 2d                	je     c01013b8 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c010138b:	a1 64 c6 11 c0       	mov    0xc011c664,%eax
c0101390:	8d 50 01             	lea    0x1(%eax),%edx
c0101393:	89 15 64 c6 11 c0    	mov    %edx,0xc011c664
c0101399:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010139c:	88 90 60 c4 11 c0    	mov    %dl,-0x3fee3ba0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c01013a2:	a1 64 c6 11 c0       	mov    0xc011c664,%eax
c01013a7:	3d 00 02 00 00       	cmp    $0x200,%eax
c01013ac:	75 0a                	jne    c01013b8 <cons_intr+0x3b>
                cons.wpos = 0;
c01013ae:	c7 05 64 c6 11 c0 00 	movl   $0x0,0xc011c664
c01013b5:	00 00 00 
    while ((c = (*proc)()) != -1) {
c01013b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01013bb:	ff d0                	call   *%eax
c01013bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01013c0:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c01013c4:	75 bf                	jne    c0101385 <cons_intr+0x8>
            }
        }
    }
}
c01013c6:	90                   	nop
c01013c7:	c9                   	leave  
c01013c8:	c3                   	ret    

c01013c9 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01013c9:	55                   	push   %ebp
c01013ca:	89 e5                	mov    %esp,%ebp
c01013cc:	83 ec 10             	sub    $0x10,%esp
c01013cf:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013d5:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013d9:	89 c2                	mov    %eax,%edx
c01013db:	ec                   	in     (%dx),%al
c01013dc:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013df:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01013e3:	0f b6 c0             	movzbl %al,%eax
c01013e6:	83 e0 01             	and    $0x1,%eax
c01013e9:	85 c0                	test   %eax,%eax
c01013eb:	75 07                	jne    c01013f4 <serial_proc_data+0x2b>
        return -1;
c01013ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01013f2:	eb 2a                	jmp    c010141e <serial_proc_data+0x55>
c01013f4:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013fa:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01013fe:	89 c2                	mov    %eax,%edx
c0101400:	ec                   	in     (%dx),%al
c0101401:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c0101404:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c0101408:	0f b6 c0             	movzbl %al,%eax
c010140b:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c010140e:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c0101412:	75 07                	jne    c010141b <serial_proc_data+0x52>
        c = '\b';
c0101414:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c010141b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010141e:	c9                   	leave  
c010141f:	c3                   	ret    

c0101420 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c0101420:	55                   	push   %ebp
c0101421:	89 e5                	mov    %esp,%ebp
c0101423:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c0101426:	a1 48 c4 11 c0       	mov    0xc011c448,%eax
c010142b:	85 c0                	test   %eax,%eax
c010142d:	74 0c                	je     c010143b <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c010142f:	c7 04 24 c9 13 10 c0 	movl   $0xc01013c9,(%esp)
c0101436:	e8 42 ff ff ff       	call   c010137d <cons_intr>
    }
}
c010143b:	90                   	nop
c010143c:	c9                   	leave  
c010143d:	c3                   	ret    

c010143e <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c010143e:	55                   	push   %ebp
c010143f:	89 e5                	mov    %esp,%ebp
c0101441:	83 ec 38             	sub    $0x38,%esp
c0101444:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010144a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010144d:	89 c2                	mov    %eax,%edx
c010144f:	ec                   	in     (%dx),%al
c0101450:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c0101453:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c0101457:	0f b6 c0             	movzbl %al,%eax
c010145a:	83 e0 01             	and    $0x1,%eax
c010145d:	85 c0                	test   %eax,%eax
c010145f:	75 0a                	jne    c010146b <kbd_proc_data+0x2d>
        return -1;
c0101461:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101466:	e9 55 01 00 00       	jmp    c01015c0 <kbd_proc_data+0x182>
c010146b:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101471:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101474:	89 c2                	mov    %eax,%edx
c0101476:	ec                   	in     (%dx),%al
c0101477:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c010147a:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c010147e:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c0101481:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c0101485:	75 17                	jne    c010149e <kbd_proc_data+0x60>
        // E0 escape character
        shift |= E0ESC;
c0101487:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c010148c:	83 c8 40             	or     $0x40,%eax
c010148f:	a3 68 c6 11 c0       	mov    %eax,0xc011c668
        return 0;
c0101494:	b8 00 00 00 00       	mov    $0x0,%eax
c0101499:	e9 22 01 00 00       	jmp    c01015c0 <kbd_proc_data+0x182>
    } else if (data & 0x80) {
c010149e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014a2:	84 c0                	test   %al,%al
c01014a4:	79 45                	jns    c01014eb <kbd_proc_data+0xad>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c01014a6:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c01014ab:	83 e0 40             	and    $0x40,%eax
c01014ae:	85 c0                	test   %eax,%eax
c01014b0:	75 08                	jne    c01014ba <kbd_proc_data+0x7c>
c01014b2:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014b6:	24 7f                	and    $0x7f,%al
c01014b8:	eb 04                	jmp    c01014be <kbd_proc_data+0x80>
c01014ba:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014be:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c01014c1:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014c5:	0f b6 80 40 90 11 c0 	movzbl -0x3fee6fc0(%eax),%eax
c01014cc:	0c 40                	or     $0x40,%al
c01014ce:	0f b6 c0             	movzbl %al,%eax
c01014d1:	f7 d0                	not    %eax
c01014d3:	89 c2                	mov    %eax,%edx
c01014d5:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c01014da:	21 d0                	and    %edx,%eax
c01014dc:	a3 68 c6 11 c0       	mov    %eax,0xc011c668
        return 0;
c01014e1:	b8 00 00 00 00       	mov    $0x0,%eax
c01014e6:	e9 d5 00 00 00       	jmp    c01015c0 <kbd_proc_data+0x182>
    } else if (shift & E0ESC) {
c01014eb:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c01014f0:	83 e0 40             	and    $0x40,%eax
c01014f3:	85 c0                	test   %eax,%eax
c01014f5:	74 11                	je     c0101508 <kbd_proc_data+0xca>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01014f7:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01014fb:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c0101500:	83 e0 bf             	and    $0xffffffbf,%eax
c0101503:	a3 68 c6 11 c0       	mov    %eax,0xc011c668
    }

    shift |= shiftcode[data];
c0101508:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010150c:	0f b6 80 40 90 11 c0 	movzbl -0x3fee6fc0(%eax),%eax
c0101513:	0f b6 d0             	movzbl %al,%edx
c0101516:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c010151b:	09 d0                	or     %edx,%eax
c010151d:	a3 68 c6 11 c0       	mov    %eax,0xc011c668
    shift ^= togglecode[data];
c0101522:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101526:	0f b6 80 40 91 11 c0 	movzbl -0x3fee6ec0(%eax),%eax
c010152d:	0f b6 d0             	movzbl %al,%edx
c0101530:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c0101535:	31 d0                	xor    %edx,%eax
c0101537:	a3 68 c6 11 c0       	mov    %eax,0xc011c668

    c = charcode[shift & (CTL | SHIFT)][data];
c010153c:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c0101541:	83 e0 03             	and    $0x3,%eax
c0101544:	8b 14 85 40 95 11 c0 	mov    -0x3fee6ac0(,%eax,4),%edx
c010154b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010154f:	01 d0                	add    %edx,%eax
c0101551:	0f b6 00             	movzbl (%eax),%eax
c0101554:	0f b6 c0             	movzbl %al,%eax
c0101557:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c010155a:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c010155f:	83 e0 08             	and    $0x8,%eax
c0101562:	85 c0                	test   %eax,%eax
c0101564:	74 22                	je     c0101588 <kbd_proc_data+0x14a>
        if ('a' <= c && c <= 'z')
c0101566:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c010156a:	7e 0c                	jle    c0101578 <kbd_proc_data+0x13a>
c010156c:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101570:	7f 06                	jg     c0101578 <kbd_proc_data+0x13a>
            c += 'A' - 'a';
c0101572:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101576:	eb 10                	jmp    c0101588 <kbd_proc_data+0x14a>
        else if ('A' <= c && c <= 'Z')
c0101578:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c010157c:	7e 0a                	jle    c0101588 <kbd_proc_data+0x14a>
c010157e:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c0101582:	7f 04                	jg     c0101588 <kbd_proc_data+0x14a>
            c += 'a' - 'A';
c0101584:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c0101588:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c010158d:	f7 d0                	not    %eax
c010158f:	83 e0 06             	and    $0x6,%eax
c0101592:	85 c0                	test   %eax,%eax
c0101594:	75 27                	jne    c01015bd <kbd_proc_data+0x17f>
c0101596:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c010159d:	75 1e                	jne    c01015bd <kbd_proc_data+0x17f>
        cprintf("Rebooting!\n");
c010159f:	c7 04 24 2d 67 10 c0 	movl   $0xc010672d,(%esp)
c01015a6:	e8 ef ec ff ff       	call   c010029a <cprintf>
c01015ab:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c01015b1:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01015b5:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c01015b9:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01015bc:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c01015bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01015c0:	c9                   	leave  
c01015c1:	c3                   	ret    

c01015c2 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c01015c2:	55                   	push   %ebp
c01015c3:	89 e5                	mov    %esp,%ebp
c01015c5:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c01015c8:	c7 04 24 3e 14 10 c0 	movl   $0xc010143e,(%esp)
c01015cf:	e8 a9 fd ff ff       	call   c010137d <cons_intr>
}
c01015d4:	90                   	nop
c01015d5:	c9                   	leave  
c01015d6:	c3                   	ret    

c01015d7 <kbd_init>:

static void
kbd_init(void) {
c01015d7:	55                   	push   %ebp
c01015d8:	89 e5                	mov    %esp,%ebp
c01015da:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c01015dd:	e8 e0 ff ff ff       	call   c01015c2 <kbd_intr>
    pic_enable(IRQ_KBD);
c01015e2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01015e9:	e8 35 01 00 00       	call   c0101723 <pic_enable>
}
c01015ee:	90                   	nop
c01015ef:	c9                   	leave  
c01015f0:	c3                   	ret    

c01015f1 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01015f1:	55                   	push   %ebp
c01015f2:	89 e5                	mov    %esp,%ebp
c01015f4:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01015f7:	e8 83 f8 ff ff       	call   c0100e7f <cga_init>
    serial_init();
c01015fc:	e8 62 f9 ff ff       	call   c0100f63 <serial_init>
    kbd_init();
c0101601:	e8 d1 ff ff ff       	call   c01015d7 <kbd_init>
    if (!serial_exists) {
c0101606:	a1 48 c4 11 c0       	mov    0xc011c448,%eax
c010160b:	85 c0                	test   %eax,%eax
c010160d:	75 0c                	jne    c010161b <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c010160f:	c7 04 24 39 67 10 c0 	movl   $0xc0106739,(%esp)
c0101616:	e8 7f ec ff ff       	call   c010029a <cprintf>
    }
}
c010161b:	90                   	nop
c010161c:	c9                   	leave  
c010161d:	c3                   	ret    

c010161e <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c010161e:	55                   	push   %ebp
c010161f:	89 e5                	mov    %esp,%ebp
c0101621:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0101624:	e8 cf f7 ff ff       	call   c0100df8 <__intr_save>
c0101629:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c010162c:	8b 45 08             	mov    0x8(%ebp),%eax
c010162f:	89 04 24             	mov    %eax,(%esp)
c0101632:	e8 89 fa ff ff       	call   c01010c0 <lpt_putc>
        cga_putc(c);
c0101637:	8b 45 08             	mov    0x8(%ebp),%eax
c010163a:	89 04 24             	mov    %eax,(%esp)
c010163d:	e8 be fa ff ff       	call   c0101100 <cga_putc>
        serial_putc(c);
c0101642:	8b 45 08             	mov    0x8(%ebp),%eax
c0101645:	89 04 24             	mov    %eax,(%esp)
c0101648:	e8 f0 fc ff ff       	call   c010133d <serial_putc>
    }
    local_intr_restore(intr_flag);
c010164d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101650:	89 04 24             	mov    %eax,(%esp)
c0101653:	e8 ca f7 ff ff       	call   c0100e22 <__intr_restore>
}
c0101658:	90                   	nop
c0101659:	c9                   	leave  
c010165a:	c3                   	ret    

c010165b <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c010165b:	55                   	push   %ebp
c010165c:	89 e5                	mov    %esp,%ebp
c010165e:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c0101661:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101668:	e8 8b f7 ff ff       	call   c0100df8 <__intr_save>
c010166d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101670:	e8 ab fd ff ff       	call   c0101420 <serial_intr>
        kbd_intr();
c0101675:	e8 48 ff ff ff       	call   c01015c2 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c010167a:	8b 15 60 c6 11 c0    	mov    0xc011c660,%edx
c0101680:	a1 64 c6 11 c0       	mov    0xc011c664,%eax
c0101685:	39 c2                	cmp    %eax,%edx
c0101687:	74 31                	je     c01016ba <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c0101689:	a1 60 c6 11 c0       	mov    0xc011c660,%eax
c010168e:	8d 50 01             	lea    0x1(%eax),%edx
c0101691:	89 15 60 c6 11 c0    	mov    %edx,0xc011c660
c0101697:	0f b6 80 60 c4 11 c0 	movzbl -0x3fee3ba0(%eax),%eax
c010169e:	0f b6 c0             	movzbl %al,%eax
c01016a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c01016a4:	a1 60 c6 11 c0       	mov    0xc011c660,%eax
c01016a9:	3d 00 02 00 00       	cmp    $0x200,%eax
c01016ae:	75 0a                	jne    c01016ba <cons_getc+0x5f>
                cons.rpos = 0;
c01016b0:	c7 05 60 c6 11 c0 00 	movl   $0x0,0xc011c660
c01016b7:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c01016ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01016bd:	89 04 24             	mov    %eax,(%esp)
c01016c0:	e8 5d f7 ff ff       	call   c0100e22 <__intr_restore>
    return c;
c01016c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01016c8:	c9                   	leave  
c01016c9:	c3                   	ret    

c01016ca <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c01016ca:	55                   	push   %ebp
c01016cb:	89 e5                	mov    %esp,%ebp
c01016cd:	83 ec 14             	sub    $0x14,%esp
c01016d0:	8b 45 08             	mov    0x8(%ebp),%eax
c01016d3:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c01016d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01016da:	66 a3 50 95 11 c0    	mov    %ax,0xc0119550
    if (did_init) {
c01016e0:	a1 6c c6 11 c0       	mov    0xc011c66c,%eax
c01016e5:	85 c0                	test   %eax,%eax
c01016e7:	74 37                	je     c0101720 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c01016e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01016ec:	0f b6 c0             	movzbl %al,%eax
c01016ef:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
c01016f5:	88 45 f9             	mov    %al,-0x7(%ebp)
c01016f8:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01016fc:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101700:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c0101701:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101705:	c1 e8 08             	shr    $0x8,%eax
c0101708:	0f b7 c0             	movzwl %ax,%eax
c010170b:	0f b6 c0             	movzbl %al,%eax
c010170e:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
c0101714:	88 45 fd             	mov    %al,-0x3(%ebp)
c0101717:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c010171b:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c010171f:	ee                   	out    %al,(%dx)
    }
}
c0101720:	90                   	nop
c0101721:	c9                   	leave  
c0101722:	c3                   	ret    

c0101723 <pic_enable>:

void
pic_enable(unsigned int irq) {
c0101723:	55                   	push   %ebp
c0101724:	89 e5                	mov    %esp,%ebp
c0101726:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c0101729:	8b 45 08             	mov    0x8(%ebp),%eax
c010172c:	ba 01 00 00 00       	mov    $0x1,%edx
c0101731:	88 c1                	mov    %al,%cl
c0101733:	d3 e2                	shl    %cl,%edx
c0101735:	89 d0                	mov    %edx,%eax
c0101737:	98                   	cwtl   
c0101738:	f7 d0                	not    %eax
c010173a:	0f bf d0             	movswl %ax,%edx
c010173d:	0f b7 05 50 95 11 c0 	movzwl 0xc0119550,%eax
c0101744:	98                   	cwtl   
c0101745:	21 d0                	and    %edx,%eax
c0101747:	98                   	cwtl   
c0101748:	0f b7 c0             	movzwl %ax,%eax
c010174b:	89 04 24             	mov    %eax,(%esp)
c010174e:	e8 77 ff ff ff       	call   c01016ca <pic_setmask>
}
c0101753:	90                   	nop
c0101754:	c9                   	leave  
c0101755:	c3                   	ret    

c0101756 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101756:	55                   	push   %ebp
c0101757:	89 e5                	mov    %esp,%ebp
c0101759:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c010175c:	c7 05 6c c6 11 c0 01 	movl   $0x1,0xc011c66c
c0101763:	00 00 00 
c0101766:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
c010176c:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
c0101770:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c0101774:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c0101778:	ee                   	out    %al,(%dx)
c0101779:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
c010177f:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
c0101783:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c0101787:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c010178b:	ee                   	out    %al,(%dx)
c010178c:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c0101792:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
c0101796:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c010179a:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c010179e:	ee                   	out    %al,(%dx)
c010179f:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
c01017a5:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
c01017a9:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c01017ad:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c01017b1:	ee                   	out    %al,(%dx)
c01017b2:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
c01017b8:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
c01017bc:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c01017c0:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c01017c4:	ee                   	out    %al,(%dx)
c01017c5:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
c01017cb:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
c01017cf:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01017d3:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c01017d7:	ee                   	out    %al,(%dx)
c01017d8:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
c01017de:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
c01017e2:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01017e6:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01017ea:	ee                   	out    %al,(%dx)
c01017eb:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
c01017f1:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
c01017f5:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01017f9:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01017fd:	ee                   	out    %al,(%dx)
c01017fe:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
c0101804:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
c0101808:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010180c:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101810:	ee                   	out    %al,(%dx)
c0101811:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
c0101817:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
c010181b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010181f:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101823:	ee                   	out    %al,(%dx)
c0101824:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
c010182a:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
c010182e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101832:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101836:	ee                   	out    %al,(%dx)
c0101837:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c010183d:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
c0101841:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101845:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101849:	ee                   	out    %al,(%dx)
c010184a:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
c0101850:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
c0101854:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101858:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c010185c:	ee                   	out    %al,(%dx)
c010185d:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
c0101863:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
c0101867:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c010186b:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c010186f:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c0101870:	0f b7 05 50 95 11 c0 	movzwl 0xc0119550,%eax
c0101877:	3d ff ff 00 00       	cmp    $0xffff,%eax
c010187c:	74 0f                	je     c010188d <pic_init+0x137>
        pic_setmask(irq_mask);
c010187e:	0f b7 05 50 95 11 c0 	movzwl 0xc0119550,%eax
c0101885:	89 04 24             	mov    %eax,(%esp)
c0101888:	e8 3d fe ff ff       	call   c01016ca <pic_setmask>
    }
}
c010188d:	90                   	nop
c010188e:	c9                   	leave  
c010188f:	c3                   	ret    

c0101890 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c0101890:	55                   	push   %ebp
c0101891:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
c0101893:	fb                   	sti    
    sti();
}
c0101894:	90                   	nop
c0101895:	5d                   	pop    %ebp
c0101896:	c3                   	ret    

c0101897 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c0101897:	55                   	push   %ebp
c0101898:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
c010189a:	fa                   	cli    
    cli();
}
c010189b:	90                   	nop
c010189c:	5d                   	pop    %ebp
c010189d:	c3                   	ret    

c010189e <print_switch_to_user>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100
void print_switch_to_user()
{
c010189e:	55                   	push   %ebp
c010189f:	89 e5                	mov    %esp,%ebp
c01018a1:	83 ec 18             	sub    $0x18,%esp
	cprintf("switch to user");
c01018a4:	c7 04 24 60 67 10 c0 	movl   $0xc0106760,(%esp)
c01018ab:	e8 ea e9 ff ff       	call   c010029a <cprintf>
}
c01018b0:	90                   	nop
c01018b1:	c9                   	leave  
c01018b2:	c3                   	ret    

c01018b3 <print_switch_to_kernel>:

void print_switch_to_kernel()
{
c01018b3:	55                   	push   %ebp
c01018b4:	89 e5                	mov    %esp,%ebp
c01018b6:	83 ec 18             	sub    $0x18,%esp
	cprintf("switch to kernel\n");
c01018b9:	c7 04 24 6f 67 10 c0 	movl   $0xc010676f,(%esp)
c01018c0:	e8 d5 e9 ff ff       	call   c010029a <cprintf>
}
c01018c5:	90                   	nop
c01018c6:	c9                   	leave  
c01018c7:	c3                   	ret    

c01018c8 <print_ticks>:

static void print_ticks() {
c01018c8:	55                   	push   %ebp
c01018c9:	89 e5                	mov    %esp,%ebp
c01018cb:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c01018ce:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c01018d5:	00 
c01018d6:	c7 04 24 81 67 10 c0 	movl   $0xc0106781,(%esp)
c01018dd:	e8 b8 e9 ff ff       	call   c010029a <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
c01018e2:	90                   	nop
c01018e3:	c9                   	leave  
c01018e4:	c3                   	ret    

c01018e5 <idt_init>:

extern uint32_t __vectors[256];

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c01018e5:	55                   	push   %ebp
c01018e6:	89 e5                	mov    %esp,%ebp
c01018e8:	83 ec 10             	sub    $0x10,%esp
      *     Can you see idt[256] in this file? Yes, it's IDT! you can use SETGATE macro to setup each item of IDT
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	int intrno = 0;
c01018eb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	/* ucore don't use task gate.*/
	for(; intrno < 256; intrno++) 
c01018f2:	e9 c4 00 00 00       	jmp    c01019bb <idt_init+0xd6>
		SETGATE(idt[intrno], 0, KERNEL_CS, __vectors[intrno], DPL_KERNEL);
c01018f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018fa:	8b 04 85 e0 95 11 c0 	mov    -0x3fee6a20(,%eax,4),%eax
c0101901:	0f b7 d0             	movzwl %ax,%edx
c0101904:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101907:	66 89 14 c5 80 c6 11 	mov    %dx,-0x3fee3980(,%eax,8)
c010190e:	c0 
c010190f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101912:	66 c7 04 c5 82 c6 11 	movw   $0x8,-0x3fee397e(,%eax,8)
c0101919:	c0 08 00 
c010191c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010191f:	0f b6 14 c5 84 c6 11 	movzbl -0x3fee397c(,%eax,8),%edx
c0101926:	c0 
c0101927:	80 e2 e0             	and    $0xe0,%dl
c010192a:	88 14 c5 84 c6 11 c0 	mov    %dl,-0x3fee397c(,%eax,8)
c0101931:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101934:	0f b6 14 c5 84 c6 11 	movzbl -0x3fee397c(,%eax,8),%edx
c010193b:	c0 
c010193c:	80 e2 1f             	and    $0x1f,%dl
c010193f:	88 14 c5 84 c6 11 c0 	mov    %dl,-0x3fee397c(,%eax,8)
c0101946:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101949:	0f b6 14 c5 85 c6 11 	movzbl -0x3fee397b(,%eax,8),%edx
c0101950:	c0 
c0101951:	80 e2 f0             	and    $0xf0,%dl
c0101954:	80 ca 0e             	or     $0xe,%dl
c0101957:	88 14 c5 85 c6 11 c0 	mov    %dl,-0x3fee397b(,%eax,8)
c010195e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101961:	0f b6 14 c5 85 c6 11 	movzbl -0x3fee397b(,%eax,8),%edx
c0101968:	c0 
c0101969:	80 e2 ef             	and    $0xef,%dl
c010196c:	88 14 c5 85 c6 11 c0 	mov    %dl,-0x3fee397b(,%eax,8)
c0101973:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101976:	0f b6 14 c5 85 c6 11 	movzbl -0x3fee397b(,%eax,8),%edx
c010197d:	c0 
c010197e:	80 e2 9f             	and    $0x9f,%dl
c0101981:	88 14 c5 85 c6 11 c0 	mov    %dl,-0x3fee397b(,%eax,8)
c0101988:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010198b:	0f b6 14 c5 85 c6 11 	movzbl -0x3fee397b(,%eax,8),%edx
c0101992:	c0 
c0101993:	80 ca 80             	or     $0x80,%dl
c0101996:	88 14 c5 85 c6 11 c0 	mov    %dl,-0x3fee397b(,%eax,8)
c010199d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019a0:	8b 04 85 e0 95 11 c0 	mov    -0x3fee6a20(,%eax,4),%eax
c01019a7:	c1 e8 10             	shr    $0x10,%eax
c01019aa:	0f b7 d0             	movzwl %ax,%edx
c01019ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019b0:	66 89 14 c5 86 c6 11 	mov    %dx,-0x3fee397a(,%eax,8)
c01019b7:	c0 
	for(; intrno < 256; intrno++) 
c01019b8:	ff 45 fc             	incl   -0x4(%ebp)
c01019bb:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c01019c2:	0f 8e 2f ff ff ff    	jle    c01018f7 <idt_init+0x12>

	SETGATE(idt[T_SYSCALL], 1, KERNEL_CS, __vectors[T_SYSCALL], DPL_USER);
c01019c8:	a1 e0 97 11 c0       	mov    0xc01197e0,%eax
c01019cd:	0f b7 c0             	movzwl %ax,%eax
c01019d0:	66 a3 80 ca 11 c0    	mov    %ax,0xc011ca80
c01019d6:	66 c7 05 82 ca 11 c0 	movw   $0x8,0xc011ca82
c01019dd:	08 00 
c01019df:	0f b6 05 84 ca 11 c0 	movzbl 0xc011ca84,%eax
c01019e6:	24 e0                	and    $0xe0,%al
c01019e8:	a2 84 ca 11 c0       	mov    %al,0xc011ca84
c01019ed:	0f b6 05 84 ca 11 c0 	movzbl 0xc011ca84,%eax
c01019f4:	24 1f                	and    $0x1f,%al
c01019f6:	a2 84 ca 11 c0       	mov    %al,0xc011ca84
c01019fb:	0f b6 05 85 ca 11 c0 	movzbl 0xc011ca85,%eax
c0101a02:	0c 0f                	or     $0xf,%al
c0101a04:	a2 85 ca 11 c0       	mov    %al,0xc011ca85
c0101a09:	0f b6 05 85 ca 11 c0 	movzbl 0xc011ca85,%eax
c0101a10:	24 ef                	and    $0xef,%al
c0101a12:	a2 85 ca 11 c0       	mov    %al,0xc011ca85
c0101a17:	0f b6 05 85 ca 11 c0 	movzbl 0xc011ca85,%eax
c0101a1e:	0c 60                	or     $0x60,%al
c0101a20:	a2 85 ca 11 c0       	mov    %al,0xc011ca85
c0101a25:	0f b6 05 85 ca 11 c0 	movzbl 0xc011ca85,%eax
c0101a2c:	0c 80                	or     $0x80,%al
c0101a2e:	a2 85 ca 11 c0       	mov    %al,0xc011ca85
c0101a33:	a1 e0 97 11 c0       	mov    0xc01197e0,%eax
c0101a38:	c1 e8 10             	shr    $0x10,%eax
c0101a3b:	0f b7 c0             	movzwl %ax,%eax
c0101a3e:	66 a3 86 ca 11 c0    	mov    %ax,0xc011ca86
	SETGATE(idt[T_SWITCH_TOK], 0, KERNEL_CS, __vectors[T_SWITCH_TOK], DPL_USER);
c0101a44:	a1 c4 97 11 c0       	mov    0xc01197c4,%eax
c0101a49:	0f b7 c0             	movzwl %ax,%eax
c0101a4c:	66 a3 48 ca 11 c0    	mov    %ax,0xc011ca48
c0101a52:	66 c7 05 4a ca 11 c0 	movw   $0x8,0xc011ca4a
c0101a59:	08 00 
c0101a5b:	0f b6 05 4c ca 11 c0 	movzbl 0xc011ca4c,%eax
c0101a62:	24 e0                	and    $0xe0,%al
c0101a64:	a2 4c ca 11 c0       	mov    %al,0xc011ca4c
c0101a69:	0f b6 05 4c ca 11 c0 	movzbl 0xc011ca4c,%eax
c0101a70:	24 1f                	and    $0x1f,%al
c0101a72:	a2 4c ca 11 c0       	mov    %al,0xc011ca4c
c0101a77:	0f b6 05 4d ca 11 c0 	movzbl 0xc011ca4d,%eax
c0101a7e:	24 f0                	and    $0xf0,%al
c0101a80:	0c 0e                	or     $0xe,%al
c0101a82:	a2 4d ca 11 c0       	mov    %al,0xc011ca4d
c0101a87:	0f b6 05 4d ca 11 c0 	movzbl 0xc011ca4d,%eax
c0101a8e:	24 ef                	and    $0xef,%al
c0101a90:	a2 4d ca 11 c0       	mov    %al,0xc011ca4d
c0101a95:	0f b6 05 4d ca 11 c0 	movzbl 0xc011ca4d,%eax
c0101a9c:	0c 60                	or     $0x60,%al
c0101a9e:	a2 4d ca 11 c0       	mov    %al,0xc011ca4d
c0101aa3:	0f b6 05 4d ca 11 c0 	movzbl 0xc011ca4d,%eax
c0101aaa:	0c 80                	or     $0x80,%al
c0101aac:	a2 4d ca 11 c0       	mov    %al,0xc011ca4d
c0101ab1:	a1 c4 97 11 c0       	mov    0xc01197c4,%eax
c0101ab6:	c1 e8 10             	shr    $0x10,%eax
c0101ab9:	0f b7 c0             	movzwl %ax,%eax
c0101abc:	66 a3 4e ca 11 c0    	mov    %ax,0xc011ca4e
	SETGATE(idt[T_SWITCH_TOU], 0, KERNEL_CS, __vectors[T_SWITCH_TOU], DPL_KERNEL);
c0101ac2:	a1 c0 97 11 c0       	mov    0xc01197c0,%eax
c0101ac7:	0f b7 c0             	movzwl %ax,%eax
c0101aca:	66 a3 40 ca 11 c0    	mov    %ax,0xc011ca40
c0101ad0:	66 c7 05 42 ca 11 c0 	movw   $0x8,0xc011ca42
c0101ad7:	08 00 
c0101ad9:	0f b6 05 44 ca 11 c0 	movzbl 0xc011ca44,%eax
c0101ae0:	24 e0                	and    $0xe0,%al
c0101ae2:	a2 44 ca 11 c0       	mov    %al,0xc011ca44
c0101ae7:	0f b6 05 44 ca 11 c0 	movzbl 0xc011ca44,%eax
c0101aee:	24 1f                	and    $0x1f,%al
c0101af0:	a2 44 ca 11 c0       	mov    %al,0xc011ca44
c0101af5:	0f b6 05 45 ca 11 c0 	movzbl 0xc011ca45,%eax
c0101afc:	24 f0                	and    $0xf0,%al
c0101afe:	0c 0e                	or     $0xe,%al
c0101b00:	a2 45 ca 11 c0       	mov    %al,0xc011ca45
c0101b05:	0f b6 05 45 ca 11 c0 	movzbl 0xc011ca45,%eax
c0101b0c:	24 ef                	and    $0xef,%al
c0101b0e:	a2 45 ca 11 c0       	mov    %al,0xc011ca45
c0101b13:	0f b6 05 45 ca 11 c0 	movzbl 0xc011ca45,%eax
c0101b1a:	24 9f                	and    $0x9f,%al
c0101b1c:	a2 45 ca 11 c0       	mov    %al,0xc011ca45
c0101b21:	0f b6 05 45 ca 11 c0 	movzbl 0xc011ca45,%eax
c0101b28:	0c 80                	or     $0x80,%al
c0101b2a:	a2 45 ca 11 c0       	mov    %al,0xc011ca45
c0101b2f:	a1 c0 97 11 c0       	mov    0xc01197c0,%eax
c0101b34:	c1 e8 10             	shr    $0x10,%eax
c0101b37:	0f b7 c0             	movzwl %ax,%eax
c0101b3a:	66 a3 46 ca 11 c0    	mov    %ax,0xc011ca46
c0101b40:	c7 45 f8 60 95 11 c0 	movl   $0xc0119560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0101b47:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101b4a:	0f 01 18             	lidtl  (%eax)

	lidt(&idt_pd);

}
c0101b4d:	90                   	nop
c0101b4e:	c9                   	leave  
c0101b4f:	c3                   	ret    

c0101b50 <trapname>:

static const char *
trapname(int trapno) {
c0101b50:	55                   	push   %ebp
c0101b51:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0101b53:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b56:	83 f8 13             	cmp    $0x13,%eax
c0101b59:	77 0c                	ja     c0101b67 <trapname+0x17>
        return excnames[trapno];
c0101b5b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b5e:	8b 04 85 e0 6a 10 c0 	mov    -0x3fef9520(,%eax,4),%eax
c0101b65:	eb 18                	jmp    c0101b7f <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101b67:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101b6b:	7e 0d                	jle    c0101b7a <trapname+0x2a>
c0101b6d:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101b71:	7f 07                	jg     c0101b7a <trapname+0x2a>
        return "Hardware Interrupt";
c0101b73:	b8 8b 67 10 c0       	mov    $0xc010678b,%eax
c0101b78:	eb 05                	jmp    c0101b7f <trapname+0x2f>
    }
    return "(unknown trap)";
c0101b7a:	b8 9e 67 10 c0       	mov    $0xc010679e,%eax
}
c0101b7f:	5d                   	pop    %ebp
c0101b80:	c3                   	ret    

c0101b81 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0101b81:	55                   	push   %ebp
c0101b82:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101b84:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b87:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101b8b:	83 f8 08             	cmp    $0x8,%eax
c0101b8e:	0f 94 c0             	sete   %al
c0101b91:	0f b6 c0             	movzbl %al,%eax
}
c0101b94:	5d                   	pop    %ebp
c0101b95:	c3                   	ret    

c0101b96 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101b96:	55                   	push   %ebp
c0101b97:	89 e5                	mov    %esp,%ebp
c0101b99:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c0101b9c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b9f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ba3:	c7 04 24 df 67 10 c0 	movl   $0xc01067df,(%esp)
c0101baa:	e8 eb e6 ff ff       	call   c010029a <cprintf>
    print_regs(&tf->tf_regs);
c0101baf:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bb2:	89 04 24             	mov    %eax,(%esp)
c0101bb5:	e8 8f 01 00 00       	call   c0101d49 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101bba:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bbd:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101bc1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bc5:	c7 04 24 f0 67 10 c0 	movl   $0xc01067f0,(%esp)
c0101bcc:	e8 c9 e6 ff ff       	call   c010029a <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101bd1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bd4:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101bd8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bdc:	c7 04 24 03 68 10 c0 	movl   $0xc0106803,(%esp)
c0101be3:	e8 b2 e6 ff ff       	call   c010029a <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101be8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101beb:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101bef:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bf3:	c7 04 24 16 68 10 c0 	movl   $0xc0106816,(%esp)
c0101bfa:	e8 9b e6 ff ff       	call   c010029a <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101bff:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c02:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101c06:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c0a:	c7 04 24 29 68 10 c0 	movl   $0xc0106829,(%esp)
c0101c11:	e8 84 e6 ff ff       	call   c010029a <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101c16:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c19:	8b 40 30             	mov    0x30(%eax),%eax
c0101c1c:	89 04 24             	mov    %eax,(%esp)
c0101c1f:	e8 2c ff ff ff       	call   c0101b50 <trapname>
c0101c24:	89 c2                	mov    %eax,%edx
c0101c26:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c29:	8b 40 30             	mov    0x30(%eax),%eax
c0101c2c:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101c30:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c34:	c7 04 24 3c 68 10 c0 	movl   $0xc010683c,(%esp)
c0101c3b:	e8 5a e6 ff ff       	call   c010029a <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101c40:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c43:	8b 40 34             	mov    0x34(%eax),%eax
c0101c46:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c4a:	c7 04 24 4e 68 10 c0 	movl   $0xc010684e,(%esp)
c0101c51:	e8 44 e6 ff ff       	call   c010029a <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101c56:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c59:	8b 40 38             	mov    0x38(%eax),%eax
c0101c5c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c60:	c7 04 24 5d 68 10 c0 	movl   $0xc010685d,(%esp)
c0101c67:	e8 2e e6 ff ff       	call   c010029a <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101c6c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c6f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101c73:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c77:	c7 04 24 6c 68 10 c0 	movl   $0xc010686c,(%esp)
c0101c7e:	e8 17 e6 ff ff       	call   c010029a <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101c83:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c86:	8b 40 40             	mov    0x40(%eax),%eax
c0101c89:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c8d:	c7 04 24 7f 68 10 c0 	movl   $0xc010687f,(%esp)
c0101c94:	e8 01 e6 ff ff       	call   c010029a <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101c99:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101ca0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101ca7:	eb 3d                	jmp    c0101ce6 <print_trapframe+0x150>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101ca9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cac:	8b 50 40             	mov    0x40(%eax),%edx
c0101caf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101cb2:	21 d0                	and    %edx,%eax
c0101cb4:	85 c0                	test   %eax,%eax
c0101cb6:	74 28                	je     c0101ce0 <print_trapframe+0x14a>
c0101cb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101cbb:	8b 04 85 80 95 11 c0 	mov    -0x3fee6a80(,%eax,4),%eax
c0101cc2:	85 c0                	test   %eax,%eax
c0101cc4:	74 1a                	je     c0101ce0 <print_trapframe+0x14a>
            cprintf("%s,", IA32flags[i]);
c0101cc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101cc9:	8b 04 85 80 95 11 c0 	mov    -0x3fee6a80(,%eax,4),%eax
c0101cd0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cd4:	c7 04 24 8e 68 10 c0 	movl   $0xc010688e,(%esp)
c0101cdb:	e8 ba e5 ff ff       	call   c010029a <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101ce0:	ff 45 f4             	incl   -0xc(%ebp)
c0101ce3:	d1 65 f0             	shll   -0x10(%ebp)
c0101ce6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101ce9:	83 f8 17             	cmp    $0x17,%eax
c0101cec:	76 bb                	jbe    c0101ca9 <print_trapframe+0x113>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101cee:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cf1:	8b 40 40             	mov    0x40(%eax),%eax
c0101cf4:	c1 e8 0c             	shr    $0xc,%eax
c0101cf7:	83 e0 03             	and    $0x3,%eax
c0101cfa:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cfe:	c7 04 24 92 68 10 c0 	movl   $0xc0106892,(%esp)
c0101d05:	e8 90 e5 ff ff       	call   c010029a <cprintf>

    if (!trap_in_kernel(tf)) {
c0101d0a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d0d:	89 04 24             	mov    %eax,(%esp)
c0101d10:	e8 6c fe ff ff       	call   c0101b81 <trap_in_kernel>
c0101d15:	85 c0                	test   %eax,%eax
c0101d17:	75 2d                	jne    c0101d46 <print_trapframe+0x1b0>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101d19:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d1c:	8b 40 44             	mov    0x44(%eax),%eax
c0101d1f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d23:	c7 04 24 9b 68 10 c0 	movl   $0xc010689b,(%esp)
c0101d2a:	e8 6b e5 ff ff       	call   c010029a <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101d2f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d32:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101d36:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d3a:	c7 04 24 aa 68 10 c0 	movl   $0xc01068aa,(%esp)
c0101d41:	e8 54 e5 ff ff       	call   c010029a <cprintf>
    }
}
c0101d46:	90                   	nop
c0101d47:	c9                   	leave  
c0101d48:	c3                   	ret    

c0101d49 <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101d49:	55                   	push   %ebp
c0101d4a:	89 e5                	mov    %esp,%ebp
c0101d4c:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101d4f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d52:	8b 00                	mov    (%eax),%eax
c0101d54:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d58:	c7 04 24 bd 68 10 c0 	movl   $0xc01068bd,(%esp)
c0101d5f:	e8 36 e5 ff ff       	call   c010029a <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101d64:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d67:	8b 40 04             	mov    0x4(%eax),%eax
c0101d6a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d6e:	c7 04 24 cc 68 10 c0 	movl   $0xc01068cc,(%esp)
c0101d75:	e8 20 e5 ff ff       	call   c010029a <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101d7a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d7d:	8b 40 08             	mov    0x8(%eax),%eax
c0101d80:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d84:	c7 04 24 db 68 10 c0 	movl   $0xc01068db,(%esp)
c0101d8b:	e8 0a e5 ff ff       	call   c010029a <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101d90:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d93:	8b 40 0c             	mov    0xc(%eax),%eax
c0101d96:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d9a:	c7 04 24 ea 68 10 c0 	movl   $0xc01068ea,(%esp)
c0101da1:	e8 f4 e4 ff ff       	call   c010029a <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101da6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101da9:	8b 40 10             	mov    0x10(%eax),%eax
c0101dac:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101db0:	c7 04 24 f9 68 10 c0 	movl   $0xc01068f9,(%esp)
c0101db7:	e8 de e4 ff ff       	call   c010029a <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101dbc:	8b 45 08             	mov    0x8(%ebp),%eax
c0101dbf:	8b 40 14             	mov    0x14(%eax),%eax
c0101dc2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101dc6:	c7 04 24 08 69 10 c0 	movl   $0xc0106908,(%esp)
c0101dcd:	e8 c8 e4 ff ff       	call   c010029a <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101dd2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101dd5:	8b 40 18             	mov    0x18(%eax),%eax
c0101dd8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ddc:	c7 04 24 17 69 10 c0 	movl   $0xc0106917,(%esp)
c0101de3:	e8 b2 e4 ff ff       	call   c010029a <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101de8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101deb:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101dee:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101df2:	c7 04 24 26 69 10 c0 	movl   $0xc0106926,(%esp)
c0101df9:	e8 9c e4 ff ff       	call   c010029a <cprintf>
}
c0101dfe:	90                   	nop
c0101dff:	c9                   	leave  
c0101e00:	c3                   	ret    

c0101e01 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101e01:	55                   	push   %ebp
c0101e02:	89 e5                	mov    %esp,%ebp
c0101e04:	57                   	push   %edi
c0101e05:	56                   	push   %esi
c0101e06:	53                   	push   %ebx
c0101e07:	83 ec 2c             	sub    $0x2c,%esp
    char c;
	static struct trapframe *correct_tf;
	correct_tf = (struct trapframe *) ((uint32_t)(tf) - 8);
c0101e0a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e0d:	83 e8 08             	sub    $0x8,%eax
c0101e10:	a3 80 ce 11 c0       	mov    %eax,0xc011ce80

    switch (tf->tf_trapno) {
c0101e15:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e18:	8b 40 30             	mov    0x30(%eax),%eax
c0101e1b:	83 f8 24             	cmp    $0x24,%eax
c0101e1e:	0f 84 96 00 00 00    	je     c0101eba <trap_dispatch+0xb9>
c0101e24:	83 f8 24             	cmp    $0x24,%eax
c0101e27:	77 1c                	ja     c0101e45 <trap_dispatch+0x44>
c0101e29:	83 f8 20             	cmp    $0x20,%eax
c0101e2c:	74 44                	je     c0101e72 <trap_dispatch+0x71>
c0101e2e:	83 f8 21             	cmp    $0x21,%eax
c0101e31:	0f 84 ac 00 00 00    	je     c0101ee3 <trap_dispatch+0xe2>
c0101e37:	83 f8 0d             	cmp    $0xd,%eax
c0101e3a:	0f 84 aa 03 00 00    	je     c01021ea <loop+0x16e>
c0101e40:	e9 be 03 00 00       	jmp    c0102203 <loop+0x187>
c0101e45:	83 f8 78             	cmp    $0x78,%eax
c0101e48:	0f 84 a8 02 00 00    	je     c01020f6 <loop+0x7a>
c0101e4e:	83 f8 78             	cmp    $0x78,%eax
c0101e51:	77 11                	ja     c0101e64 <trap_dispatch+0x63>
c0101e53:	83 e8 2e             	sub    $0x2e,%eax
c0101e56:	83 f8 01             	cmp    $0x1,%eax
c0101e59:	0f 87 a4 03 00 00    	ja     c0102203 <loop+0x187>
		}
			break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0101e5f:	e9 db 03 00 00       	jmp    c010223f <loop+0x1c3>
    switch (tf->tf_trapno) {
c0101e64:	83 f8 79             	cmp    $0x79,%eax
c0101e67:	0f 84 0c 03 00 00    	je     c0102179 <loop+0xfd>
c0101e6d:	e9 91 03 00 00       	jmp    c0102203 <loop+0x187>
		ticks = (ticks + 1) % 100;
c0101e72:	a1 2c cf 11 c0       	mov    0xc011cf2c,%eax
c0101e77:	8d 48 01             	lea    0x1(%eax),%ecx
c0101e7a:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0101e7f:	89 c8                	mov    %ecx,%eax
c0101e81:	f7 e2                	mul    %edx
c0101e83:	c1 ea 05             	shr    $0x5,%edx
c0101e86:	89 d0                	mov    %edx,%eax
c0101e88:	c1 e0 02             	shl    $0x2,%eax
c0101e8b:	01 d0                	add    %edx,%eax
c0101e8d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0101e94:	01 d0                	add    %edx,%eax
c0101e96:	c1 e0 02             	shl    $0x2,%eax
c0101e99:	29 c1                	sub    %eax,%ecx
c0101e9b:	89 ca                	mov    %ecx,%edx
c0101e9d:	89 15 2c cf 11 c0    	mov    %edx,0xc011cf2c
		if (ticks == 0)
c0101ea3:	a1 2c cf 11 c0       	mov    0xc011cf2c,%eax
c0101ea8:	85 c0                	test   %eax,%eax
c0101eaa:	0f 85 88 03 00 00    	jne    c0102238 <loop+0x1bc>
			print_ticks();
c0101eb0:	e8 13 fa ff ff       	call   c01018c8 <print_ticks>
        break;
c0101eb5:	e9 7e 03 00 00       	jmp    c0102238 <loop+0x1bc>
        c = cons_getc();
c0101eba:	e8 9c f7 ff ff       	call   c010165b <cons_getc>
c0101ebf:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101ec2:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
c0101ec6:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
c0101eca:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101ece:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ed2:	c7 04 24 35 69 10 c0 	movl   $0xc0106935,(%esp)
c0101ed9:	e8 bc e3 ff ff       	call   c010029a <cprintf>
        break;
c0101ede:	e9 5c 03 00 00       	jmp    c010223f <loop+0x1c3>
        c = cons_getc();
c0101ee3:	e8 73 f7 ff ff       	call   c010165b <cons_getc>
c0101ee8:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101eeb:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
c0101eef:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
c0101ef3:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101ef7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101efb:	c7 04 24 47 69 10 c0 	movl   $0xc0106947,(%esp)
c0101f02:	e8 93 e3 ff ff       	call   c010029a <cprintf>
		switch (c) {
c0101f07:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
c0101f0b:	83 f8 30             	cmp    $0x30,%eax
c0101f0e:	74 0e                	je     c0101f1e <trap_dispatch+0x11d>
c0101f10:	83 f8 33             	cmp    $0x33,%eax
c0101f13:	0f 84 29 01 00 00    	je     c0102042 <trap_dispatch+0x241>
        break;
c0101f19:	e9 21 03 00 00       	jmp    c010223f <loop+0x1c3>
				if (!trap_in_kernel(tf)) {
c0101f1e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f21:	89 04 24             	mov    %eax,(%esp)
c0101f24:	e8 58 fc ff ff       	call   c0101b81 <trap_in_kernel>
c0101f29:	85 c0                	test   %eax,%eax
c0101f2b:	0f 85 b9 01 00 00    	jne    c01020ea <loop+0x6e>
					tf->tf_cs = KERNEL_CS;
c0101f31:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f34:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
					tf->tf_ds = tf->tf_es = tf->tf_gs = tf->tf_fs = KERNEL_DS;
c0101f3a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f3d:	66 c7 40 24 10 00    	movw   $0x10,0x24(%eax)
c0101f43:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f46:	0f b7 50 24          	movzwl 0x24(%eax),%edx
c0101f4a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f4d:	66 89 50 20          	mov    %dx,0x20(%eax)
c0101f51:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f54:	0f b7 50 20          	movzwl 0x20(%eax),%edx
c0101f58:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f5b:	66 89 50 28          	mov    %dx,0x28(%eax)
c0101f5f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f62:	0f b7 50 28          	movzwl 0x28(%eax),%edx
c0101f66:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f69:	66 89 50 2c          	mov    %dx,0x2c(%eax)
					tf->tf_eflags &= ~FL_IOPL_MASK;
c0101f6d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f70:	8b 40 40             	mov    0x40(%eax),%eax
c0101f73:	25 ff cf ff ff       	and    $0xffffcfff,%eax
c0101f78:	89 c2                	mov    %eax,%edx
c0101f7a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f7d:	89 50 40             	mov    %edx,0x40(%eax)
					uintptr_t user_stack_ptr = (uintptr_t)tf->tf_esp;
c0101f80:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f83:	8b 40 44             	mov    0x44(%eax),%eax
c0101f86:	89 45 e0             	mov    %eax,-0x20(%ebp)
					tf->tf_esp = *((uint32_t *) user_stack_ptr);
c0101f89:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0101f8c:	8b 10                	mov    (%eax),%edx
c0101f8e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f91:	89 50 44             	mov    %edx,0x44(%eax)
					tf->tf_ss = *((uint16_t *) (user_stack_ptr + 4));
c0101f94:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0101f97:	83 c0 04             	add    $0x4,%eax
c0101f9a:	0f b7 10             	movzwl (%eax),%edx
c0101f9d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101fa0:	66 89 50 48          	mov    %dx,0x48(%eax)
					tf->tf_padding0 = *((uint16_t *) (user_stack_ptr + 6));
c0101fa4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0101fa7:	83 c0 06             	add    $0x6,%eax
c0101faa:	0f b7 10             	movzwl (%eax),%edx
c0101fad:	8b 45 08             	mov    0x8(%ebp),%eax
c0101fb0:	66 89 50 22          	mov    %dx,0x22(%eax)
					user_stack_ptr -= (uintptr_t) (sizeof(struct trapframe) - 8);
c0101fb4:	83 6d e0 44          	subl   $0x44,-0x20(%ebp)
					*((struct trapframe *) user_stack_ptr) = *tf;
c0101fb8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0101fbb:	8b 55 08             	mov    0x8(%ebp),%edx
c0101fbe:	bb 4c 00 00 00       	mov    $0x4c,%ebx
c0101fc3:	89 c1                	mov    %eax,%ecx
c0101fc5:	83 e1 01             	and    $0x1,%ecx
c0101fc8:	85 c9                	test   %ecx,%ecx
c0101fca:	74 0c                	je     c0101fd8 <trap_dispatch+0x1d7>
c0101fcc:	0f b6 0a             	movzbl (%edx),%ecx
c0101fcf:	88 08                	mov    %cl,(%eax)
c0101fd1:	8d 40 01             	lea    0x1(%eax),%eax
c0101fd4:	8d 52 01             	lea    0x1(%edx),%edx
c0101fd7:	4b                   	dec    %ebx
c0101fd8:	89 c1                	mov    %eax,%ecx
c0101fda:	83 e1 02             	and    $0x2,%ecx
c0101fdd:	85 c9                	test   %ecx,%ecx
c0101fdf:	74 0f                	je     c0101ff0 <trap_dispatch+0x1ef>
c0101fe1:	0f b7 0a             	movzwl (%edx),%ecx
c0101fe4:	66 89 08             	mov    %cx,(%eax)
c0101fe7:	8d 40 02             	lea    0x2(%eax),%eax
c0101fea:	8d 52 02             	lea    0x2(%edx),%edx
c0101fed:	83 eb 02             	sub    $0x2,%ebx
c0101ff0:	89 df                	mov    %ebx,%edi
c0101ff2:	83 e7 fc             	and    $0xfffffffc,%edi
c0101ff5:	b9 00 00 00 00       	mov    $0x0,%ecx
c0101ffa:	8b 34 0a             	mov    (%edx,%ecx,1),%esi
c0101ffd:	89 34 08             	mov    %esi,(%eax,%ecx,1)
c0102000:	83 c1 04             	add    $0x4,%ecx
c0102003:	39 f9                	cmp    %edi,%ecx
c0102005:	72 f3                	jb     c0101ffa <trap_dispatch+0x1f9>
c0102007:	01 c8                	add    %ecx,%eax
c0102009:	01 ca                	add    %ecx,%edx
c010200b:	b9 00 00 00 00       	mov    $0x0,%ecx
c0102010:	89 de                	mov    %ebx,%esi
c0102012:	83 e6 02             	and    $0x2,%esi
c0102015:	85 f6                	test   %esi,%esi
c0102017:	74 0b                	je     c0102024 <trap_dispatch+0x223>
c0102019:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
c010201d:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
c0102021:	83 c1 02             	add    $0x2,%ecx
c0102024:	83 e3 01             	and    $0x1,%ebx
c0102027:	85 db                	test   %ebx,%ebx
c0102029:	74 07                	je     c0102032 <trap_dispatch+0x231>
c010202b:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
c010202f:	88 14 08             	mov    %dl,(%eax,%ecx,1)
						:"a" ((uint32_t) tf),
c0102032:	8b 45 08             	mov    0x8(%ebp),%eax
					__asm__ __volatile__ (
c0102035:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102038:	89 d3                	mov    %edx,%ebx
c010203a:	89 58 fc             	mov    %ebx,-0x4(%eax)
				break;
c010203d:	e9 a8 00 00 00       	jmp    c01020ea <loop+0x6e>
				if (trap_in_kernel(tf)) {
c0102042:	8b 45 08             	mov    0x8(%ebp),%eax
c0102045:	89 04 24             	mov    %eax,(%esp)
c0102048:	e8 34 fb ff ff       	call   c0101b81 <trap_in_kernel>
c010204d:	85 c0                	test   %eax,%eax
c010204f:	0f 84 9b 00 00 00    	je     c01020f0 <loop+0x74>
						:"a" ((uint32_t)(&tf->tf_esp)),
c0102055:	8b 45 08             	mov    0x8(%ebp),%eax
c0102058:	83 c0 44             	add    $0x44,%eax
						 "d" ((uint32_t)(tf)),
c010205b:	8b 55 08             	mov    0x8(%ebp),%edx
					__asm__ __volatile__ (
c010205e:	56                   	push   %esi
c010205f:	57                   	push   %edi
c0102060:	53                   	push   %ebx
c0102061:	83 6a fc 08          	subl   $0x8,-0x4(%edx)
c0102065:	89 e6                	mov    %esp,%esi
c0102067:	89 c1                	mov    %eax,%ecx
c0102069:	29 f1                	sub    %esi,%ecx
c010206b:	41                   	inc    %ecx
c010206c:	89 e7                	mov    %esp,%edi
c010206e:	83 ef 08             	sub    $0x8,%edi
c0102071:	fc                   	cld    
c0102072:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0102074:	83 ec 08             	sub    $0x8,%esp
c0102077:	83 ed 08             	sub    $0x8,%ebp
c010207a:	89 eb                	mov    %ebp,%ebx

c010207c <loop>:
c010207c:	83 2b 08             	subl   $0x8,(%ebx)
c010207f:	8b 1b                	mov    (%ebx),%ebx
c0102081:	39 d8                	cmp    %ebx,%eax
c0102083:	7f f7                	jg     c010207c <loop>
c0102085:	89 40 f8             	mov    %eax,-0x8(%eax)
c0102088:	c7 40 fc 23 00 00 00 	movl   $0x23,-0x4(%eax)
c010208f:	5b                   	pop    %ebx
c0102090:	5f                   	pop    %edi
c0102091:	5e                   	pop    %esi
					correct_tf->tf_cs = USER_CS;
c0102092:	a1 80 ce 11 c0       	mov    0xc011ce80,%eax
c0102097:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
					correct_tf->tf_ds = tf->tf_es = tf->tf_gs = tf->tf_fs = USER_DS;
c010209d:	8b 45 08             	mov    0x8(%ebp),%eax
c01020a0:	66 c7 40 24 23 00    	movw   $0x23,0x24(%eax)
c01020a6:	8b 45 08             	mov    0x8(%ebp),%eax
c01020a9:	0f b7 50 24          	movzwl 0x24(%eax),%edx
c01020ad:	8b 45 08             	mov    0x8(%ebp),%eax
c01020b0:	66 89 50 20          	mov    %dx,0x20(%eax)
c01020b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01020b7:	0f b7 50 20          	movzwl 0x20(%eax),%edx
c01020bb:	8b 45 08             	mov    0x8(%ebp),%eax
c01020be:	66 89 50 28          	mov    %dx,0x28(%eax)
c01020c2:	a1 80 ce 11 c0       	mov    0xc011ce80,%eax
c01020c7:	8b 55 08             	mov    0x8(%ebp),%edx
c01020ca:	0f b7 52 28          	movzwl 0x28(%edx),%edx
c01020ce:	66 89 50 2c          	mov    %dx,0x2c(%eax)
					correct_tf->tf_eflags |= FL_IOPL_MASK;
c01020d2:	a1 80 ce 11 c0       	mov    0xc011ce80,%eax
c01020d7:	8b 50 40             	mov    0x40(%eax),%edx
c01020da:	a1 80 ce 11 c0       	mov    0xc011ce80,%eax
c01020df:	81 ca 00 30 00 00    	or     $0x3000,%edx
c01020e5:	89 50 40             	mov    %edx,0x40(%eax)
				break;
c01020e8:	eb 06                	jmp    c01020f0 <loop+0x74>
				break;
c01020ea:	90                   	nop
c01020eb:	e9 4f 01 00 00       	jmp    c010223f <loop+0x1c3>
				break;
c01020f0:	90                   	nop
        break;
c01020f1:	e9 49 01 00 00       	jmp    c010223f <loop+0x1c3>
		if ((tf->tf_cs & 3) == 0) {
c01020f6:	8b 45 08             	mov    0x8(%ebp),%eax
c01020f9:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01020fd:	83 e0 03             	and    $0x3,%eax
c0102100:	85 c0                	test   %eax,%eax
c0102102:	0f 85 33 01 00 00    	jne    c010223b <loop+0x1bf>
			tf->tf_cs = USER_CS;
c0102108:	8b 45 08             	mov    0x8(%ebp),%eax
c010210b:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
			tf->tf_ss = tf->tf_ds = tf->tf_es = tf->tf_gs = tf->tf_fs = USER_DS;
c0102111:	8b 45 08             	mov    0x8(%ebp),%eax
c0102114:	66 c7 40 24 23 00    	movw   $0x23,0x24(%eax)
c010211a:	8b 45 08             	mov    0x8(%ebp),%eax
c010211d:	0f b7 50 24          	movzwl 0x24(%eax),%edx
c0102121:	8b 45 08             	mov    0x8(%ebp),%eax
c0102124:	66 89 50 20          	mov    %dx,0x20(%eax)
c0102128:	8b 45 08             	mov    0x8(%ebp),%eax
c010212b:	0f b7 50 20          	movzwl 0x20(%eax),%edx
c010212f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102132:	66 89 50 28          	mov    %dx,0x28(%eax)
c0102136:	8b 45 08             	mov    0x8(%ebp),%eax
c0102139:	0f b7 50 28          	movzwl 0x28(%eax),%edx
c010213d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102140:	66 89 50 2c          	mov    %dx,0x2c(%eax)
c0102144:	8b 45 08             	mov    0x8(%ebp),%eax
c0102147:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
c010214b:	8b 45 08             	mov    0x8(%ebp),%eax
c010214e:	66 89 50 48          	mov    %dx,0x48(%eax)
			tf->tf_esp += 4;
c0102152:	8b 45 08             	mov    0x8(%ebp),%eax
c0102155:	8b 40 44             	mov    0x44(%eax),%eax
c0102158:	8d 50 04             	lea    0x4(%eax),%edx
c010215b:	8b 45 08             	mov    0x8(%ebp),%eax
c010215e:	89 50 44             	mov    %edx,0x44(%eax)
			tf->tf_eflags |= FL_IOPL_MASK;
c0102161:	8b 45 08             	mov    0x8(%ebp),%eax
c0102164:	8b 40 40             	mov    0x40(%eax),%eax
c0102167:	0d 00 30 00 00       	or     $0x3000,%eax
c010216c:	89 c2                	mov    %eax,%edx
c010216e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102171:	89 50 40             	mov    %edx,0x40(%eax)
		break;
c0102174:	e9 c2 00 00 00       	jmp    c010223b <loop+0x1bf>
		if ((tf->tf_cs & 3) != 0) {
c0102179:	8b 45 08             	mov    0x8(%ebp),%eax
c010217c:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0102180:	83 e0 03             	and    $0x3,%eax
c0102183:	85 c0                	test   %eax,%eax
c0102185:	0f 84 b3 00 00 00    	je     c010223e <loop+0x1c2>
			tf->tf_cs = KERNEL_CS;
c010218b:	8b 45 08             	mov    0x8(%ebp),%eax
c010218e:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
			tf->tf_ss = tf->tf_ds = tf->tf_es = tf->tf_gs = tf->tf_fs = KERNEL_DS;
c0102194:	8b 45 08             	mov    0x8(%ebp),%eax
c0102197:	66 c7 40 24 10 00    	movw   $0x10,0x24(%eax)
c010219d:	8b 45 08             	mov    0x8(%ebp),%eax
c01021a0:	0f b7 50 24          	movzwl 0x24(%eax),%edx
c01021a4:	8b 45 08             	mov    0x8(%ebp),%eax
c01021a7:	66 89 50 20          	mov    %dx,0x20(%eax)
c01021ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01021ae:	0f b7 50 20          	movzwl 0x20(%eax),%edx
c01021b2:	8b 45 08             	mov    0x8(%ebp),%eax
c01021b5:	66 89 50 28          	mov    %dx,0x28(%eax)
c01021b9:	8b 45 08             	mov    0x8(%ebp),%eax
c01021bc:	0f b7 50 28          	movzwl 0x28(%eax),%edx
c01021c0:	8b 45 08             	mov    0x8(%ebp),%eax
c01021c3:	66 89 50 2c          	mov    %dx,0x2c(%eax)
c01021c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01021ca:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
c01021ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01021d1:	66 89 50 48          	mov    %dx,0x48(%eax)
			tf->tf_eflags &= ~FL_IOPL_MASK;
c01021d5:	8b 45 08             	mov    0x8(%ebp),%eax
c01021d8:	8b 40 40             	mov    0x40(%eax),%eax
c01021db:	25 ff cf ff ff       	and    $0xffffcfff,%eax
c01021e0:	89 c2                	mov    %eax,%edx
c01021e2:	8b 45 08             	mov    0x8(%ebp),%eax
c01021e5:	89 50 40             	mov    %edx,0x40(%eax)
			break;
c01021e8:	eb 54                	jmp    c010223e <loop+0x1c2>
	case T_GPFLT:
		cprintf("GP Fault!!!\n");
c01021ea:	c7 04 24 56 69 10 c0 	movl   $0xc0106956,(%esp)
c01021f1:	e8 a4 e0 ff ff       	call   c010029a <cprintf>
		print_trapframe(tf);
c01021f6:	8b 45 08             	mov    0x8(%ebp),%eax
c01021f9:	89 04 24             	mov    %eax,(%esp)
c01021fc:	e8 95 f9 ff ff       	call   c0101b96 <print_trapframe>
		break;
c0102201:	eb 3c                	jmp    c010223f <loop+0x1c3>
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0102203:	8b 45 08             	mov    0x8(%ebp),%eax
c0102206:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c010220a:	83 e0 03             	and    $0x3,%eax
c010220d:	85 c0                	test   %eax,%eax
c010220f:	75 2e                	jne    c010223f <loop+0x1c3>
            print_trapframe(tf);
c0102211:	8b 45 08             	mov    0x8(%ebp),%eax
c0102214:	89 04 24             	mov    %eax,(%esp)
c0102217:	e8 7a f9 ff ff       	call   c0101b96 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c010221c:	c7 44 24 08 63 69 10 	movl   $0xc0106963,0x8(%esp)
c0102223:	c0 
c0102224:	c7 44 24 04 36 01 00 	movl   $0x136,0x4(%esp)
c010222b:	00 
c010222c:	c7 04 24 7f 69 10 c0 	movl   $0xc010697f,(%esp)
c0102233:	e8 ba e1 ff ff       	call   c01003f2 <__panic>
        break;
c0102238:	90                   	nop
c0102239:	eb 04                	jmp    c010223f <loop+0x1c3>
		break;
c010223b:	90                   	nop
c010223c:	eb 01                	jmp    c010223f <loop+0x1c3>
			break;
c010223e:	90                   	nop
        }
    }
}
c010223f:	90                   	nop
c0102240:	83 c4 2c             	add    $0x2c,%esp
c0102243:	5b                   	pop    %ebx
c0102244:	5e                   	pop    %esi
c0102245:	5f                   	pop    %edi
c0102246:	5d                   	pop    %ebp
c0102247:	c3                   	ret    

c0102248 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0102248:	55                   	push   %ebp
c0102249:	89 e5                	mov    %esp,%ebp
c010224b:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c010224e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102251:	89 04 24             	mov    %eax,(%esp)
c0102254:	e8 a8 fb ff ff       	call   c0101e01 <trap_dispatch>
}
c0102259:	90                   	nop
c010225a:	c9                   	leave  
c010225b:	c3                   	ret    

c010225c <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c010225c:	6a 00                	push   $0x0
  pushl $0
c010225e:	6a 00                	push   $0x0
  jmp __alltraps
c0102260:	e9 69 0a 00 00       	jmp    c0102cce <__alltraps>

c0102265 <vector1>:
.globl vector1
vector1:
  pushl $0
c0102265:	6a 00                	push   $0x0
  pushl $1
c0102267:	6a 01                	push   $0x1
  jmp __alltraps
c0102269:	e9 60 0a 00 00       	jmp    c0102cce <__alltraps>

c010226e <vector2>:
.globl vector2
vector2:
  pushl $0
c010226e:	6a 00                	push   $0x0
  pushl $2
c0102270:	6a 02                	push   $0x2
  jmp __alltraps
c0102272:	e9 57 0a 00 00       	jmp    c0102cce <__alltraps>

c0102277 <vector3>:
.globl vector3
vector3:
  pushl $0
c0102277:	6a 00                	push   $0x0
  pushl $3
c0102279:	6a 03                	push   $0x3
  jmp __alltraps
c010227b:	e9 4e 0a 00 00       	jmp    c0102cce <__alltraps>

c0102280 <vector4>:
.globl vector4
vector4:
  pushl $0
c0102280:	6a 00                	push   $0x0
  pushl $4
c0102282:	6a 04                	push   $0x4
  jmp __alltraps
c0102284:	e9 45 0a 00 00       	jmp    c0102cce <__alltraps>

c0102289 <vector5>:
.globl vector5
vector5:
  pushl $0
c0102289:	6a 00                	push   $0x0
  pushl $5
c010228b:	6a 05                	push   $0x5
  jmp __alltraps
c010228d:	e9 3c 0a 00 00       	jmp    c0102cce <__alltraps>

c0102292 <vector6>:
.globl vector6
vector6:
  pushl $0
c0102292:	6a 00                	push   $0x0
  pushl $6
c0102294:	6a 06                	push   $0x6
  jmp __alltraps
c0102296:	e9 33 0a 00 00       	jmp    c0102cce <__alltraps>

c010229b <vector7>:
.globl vector7
vector7:
  pushl $0
c010229b:	6a 00                	push   $0x0
  pushl $7
c010229d:	6a 07                	push   $0x7
  jmp __alltraps
c010229f:	e9 2a 0a 00 00       	jmp    c0102cce <__alltraps>

c01022a4 <vector8>:
.globl vector8
vector8:
  pushl $8
c01022a4:	6a 08                	push   $0x8
  jmp __alltraps
c01022a6:	e9 23 0a 00 00       	jmp    c0102cce <__alltraps>

c01022ab <vector9>:
.globl vector9
vector9:
  pushl $0
c01022ab:	6a 00                	push   $0x0
  pushl $9
c01022ad:	6a 09                	push   $0x9
  jmp __alltraps
c01022af:	e9 1a 0a 00 00       	jmp    c0102cce <__alltraps>

c01022b4 <vector10>:
.globl vector10
vector10:
  pushl $10
c01022b4:	6a 0a                	push   $0xa
  jmp __alltraps
c01022b6:	e9 13 0a 00 00       	jmp    c0102cce <__alltraps>

c01022bb <vector11>:
.globl vector11
vector11:
  pushl $11
c01022bb:	6a 0b                	push   $0xb
  jmp __alltraps
c01022bd:	e9 0c 0a 00 00       	jmp    c0102cce <__alltraps>

c01022c2 <vector12>:
.globl vector12
vector12:
  pushl $12
c01022c2:	6a 0c                	push   $0xc
  jmp __alltraps
c01022c4:	e9 05 0a 00 00       	jmp    c0102cce <__alltraps>

c01022c9 <vector13>:
.globl vector13
vector13:
  pushl $13
c01022c9:	6a 0d                	push   $0xd
  jmp __alltraps
c01022cb:	e9 fe 09 00 00       	jmp    c0102cce <__alltraps>

c01022d0 <vector14>:
.globl vector14
vector14:
  pushl $14
c01022d0:	6a 0e                	push   $0xe
  jmp __alltraps
c01022d2:	e9 f7 09 00 00       	jmp    c0102cce <__alltraps>

c01022d7 <vector15>:
.globl vector15
vector15:
  pushl $0
c01022d7:	6a 00                	push   $0x0
  pushl $15
c01022d9:	6a 0f                	push   $0xf
  jmp __alltraps
c01022db:	e9 ee 09 00 00       	jmp    c0102cce <__alltraps>

c01022e0 <vector16>:
.globl vector16
vector16:
  pushl $0
c01022e0:	6a 00                	push   $0x0
  pushl $16
c01022e2:	6a 10                	push   $0x10
  jmp __alltraps
c01022e4:	e9 e5 09 00 00       	jmp    c0102cce <__alltraps>

c01022e9 <vector17>:
.globl vector17
vector17:
  pushl $17
c01022e9:	6a 11                	push   $0x11
  jmp __alltraps
c01022eb:	e9 de 09 00 00       	jmp    c0102cce <__alltraps>

c01022f0 <vector18>:
.globl vector18
vector18:
  pushl $0
c01022f0:	6a 00                	push   $0x0
  pushl $18
c01022f2:	6a 12                	push   $0x12
  jmp __alltraps
c01022f4:	e9 d5 09 00 00       	jmp    c0102cce <__alltraps>

c01022f9 <vector19>:
.globl vector19
vector19:
  pushl $0
c01022f9:	6a 00                	push   $0x0
  pushl $19
c01022fb:	6a 13                	push   $0x13
  jmp __alltraps
c01022fd:	e9 cc 09 00 00       	jmp    c0102cce <__alltraps>

c0102302 <vector20>:
.globl vector20
vector20:
  pushl $0
c0102302:	6a 00                	push   $0x0
  pushl $20
c0102304:	6a 14                	push   $0x14
  jmp __alltraps
c0102306:	e9 c3 09 00 00       	jmp    c0102cce <__alltraps>

c010230b <vector21>:
.globl vector21
vector21:
  pushl $0
c010230b:	6a 00                	push   $0x0
  pushl $21
c010230d:	6a 15                	push   $0x15
  jmp __alltraps
c010230f:	e9 ba 09 00 00       	jmp    c0102cce <__alltraps>

c0102314 <vector22>:
.globl vector22
vector22:
  pushl $0
c0102314:	6a 00                	push   $0x0
  pushl $22
c0102316:	6a 16                	push   $0x16
  jmp __alltraps
c0102318:	e9 b1 09 00 00       	jmp    c0102cce <__alltraps>

c010231d <vector23>:
.globl vector23
vector23:
  pushl $0
c010231d:	6a 00                	push   $0x0
  pushl $23
c010231f:	6a 17                	push   $0x17
  jmp __alltraps
c0102321:	e9 a8 09 00 00       	jmp    c0102cce <__alltraps>

c0102326 <vector24>:
.globl vector24
vector24:
  pushl $0
c0102326:	6a 00                	push   $0x0
  pushl $24
c0102328:	6a 18                	push   $0x18
  jmp __alltraps
c010232a:	e9 9f 09 00 00       	jmp    c0102cce <__alltraps>

c010232f <vector25>:
.globl vector25
vector25:
  pushl $0
c010232f:	6a 00                	push   $0x0
  pushl $25
c0102331:	6a 19                	push   $0x19
  jmp __alltraps
c0102333:	e9 96 09 00 00       	jmp    c0102cce <__alltraps>

c0102338 <vector26>:
.globl vector26
vector26:
  pushl $0
c0102338:	6a 00                	push   $0x0
  pushl $26
c010233a:	6a 1a                	push   $0x1a
  jmp __alltraps
c010233c:	e9 8d 09 00 00       	jmp    c0102cce <__alltraps>

c0102341 <vector27>:
.globl vector27
vector27:
  pushl $0
c0102341:	6a 00                	push   $0x0
  pushl $27
c0102343:	6a 1b                	push   $0x1b
  jmp __alltraps
c0102345:	e9 84 09 00 00       	jmp    c0102cce <__alltraps>

c010234a <vector28>:
.globl vector28
vector28:
  pushl $0
c010234a:	6a 00                	push   $0x0
  pushl $28
c010234c:	6a 1c                	push   $0x1c
  jmp __alltraps
c010234e:	e9 7b 09 00 00       	jmp    c0102cce <__alltraps>

c0102353 <vector29>:
.globl vector29
vector29:
  pushl $0
c0102353:	6a 00                	push   $0x0
  pushl $29
c0102355:	6a 1d                	push   $0x1d
  jmp __alltraps
c0102357:	e9 72 09 00 00       	jmp    c0102cce <__alltraps>

c010235c <vector30>:
.globl vector30
vector30:
  pushl $0
c010235c:	6a 00                	push   $0x0
  pushl $30
c010235e:	6a 1e                	push   $0x1e
  jmp __alltraps
c0102360:	e9 69 09 00 00       	jmp    c0102cce <__alltraps>

c0102365 <vector31>:
.globl vector31
vector31:
  pushl $0
c0102365:	6a 00                	push   $0x0
  pushl $31
c0102367:	6a 1f                	push   $0x1f
  jmp __alltraps
c0102369:	e9 60 09 00 00       	jmp    c0102cce <__alltraps>

c010236e <vector32>:
.globl vector32
vector32:
  pushl $0
c010236e:	6a 00                	push   $0x0
  pushl $32
c0102370:	6a 20                	push   $0x20
  jmp __alltraps
c0102372:	e9 57 09 00 00       	jmp    c0102cce <__alltraps>

c0102377 <vector33>:
.globl vector33
vector33:
  pushl $0
c0102377:	6a 00                	push   $0x0
  pushl $33
c0102379:	6a 21                	push   $0x21
  jmp __alltraps
c010237b:	e9 4e 09 00 00       	jmp    c0102cce <__alltraps>

c0102380 <vector34>:
.globl vector34
vector34:
  pushl $0
c0102380:	6a 00                	push   $0x0
  pushl $34
c0102382:	6a 22                	push   $0x22
  jmp __alltraps
c0102384:	e9 45 09 00 00       	jmp    c0102cce <__alltraps>

c0102389 <vector35>:
.globl vector35
vector35:
  pushl $0
c0102389:	6a 00                	push   $0x0
  pushl $35
c010238b:	6a 23                	push   $0x23
  jmp __alltraps
c010238d:	e9 3c 09 00 00       	jmp    c0102cce <__alltraps>

c0102392 <vector36>:
.globl vector36
vector36:
  pushl $0
c0102392:	6a 00                	push   $0x0
  pushl $36
c0102394:	6a 24                	push   $0x24
  jmp __alltraps
c0102396:	e9 33 09 00 00       	jmp    c0102cce <__alltraps>

c010239b <vector37>:
.globl vector37
vector37:
  pushl $0
c010239b:	6a 00                	push   $0x0
  pushl $37
c010239d:	6a 25                	push   $0x25
  jmp __alltraps
c010239f:	e9 2a 09 00 00       	jmp    c0102cce <__alltraps>

c01023a4 <vector38>:
.globl vector38
vector38:
  pushl $0
c01023a4:	6a 00                	push   $0x0
  pushl $38
c01023a6:	6a 26                	push   $0x26
  jmp __alltraps
c01023a8:	e9 21 09 00 00       	jmp    c0102cce <__alltraps>

c01023ad <vector39>:
.globl vector39
vector39:
  pushl $0
c01023ad:	6a 00                	push   $0x0
  pushl $39
c01023af:	6a 27                	push   $0x27
  jmp __alltraps
c01023b1:	e9 18 09 00 00       	jmp    c0102cce <__alltraps>

c01023b6 <vector40>:
.globl vector40
vector40:
  pushl $0
c01023b6:	6a 00                	push   $0x0
  pushl $40
c01023b8:	6a 28                	push   $0x28
  jmp __alltraps
c01023ba:	e9 0f 09 00 00       	jmp    c0102cce <__alltraps>

c01023bf <vector41>:
.globl vector41
vector41:
  pushl $0
c01023bf:	6a 00                	push   $0x0
  pushl $41
c01023c1:	6a 29                	push   $0x29
  jmp __alltraps
c01023c3:	e9 06 09 00 00       	jmp    c0102cce <__alltraps>

c01023c8 <vector42>:
.globl vector42
vector42:
  pushl $0
c01023c8:	6a 00                	push   $0x0
  pushl $42
c01023ca:	6a 2a                	push   $0x2a
  jmp __alltraps
c01023cc:	e9 fd 08 00 00       	jmp    c0102cce <__alltraps>

c01023d1 <vector43>:
.globl vector43
vector43:
  pushl $0
c01023d1:	6a 00                	push   $0x0
  pushl $43
c01023d3:	6a 2b                	push   $0x2b
  jmp __alltraps
c01023d5:	e9 f4 08 00 00       	jmp    c0102cce <__alltraps>

c01023da <vector44>:
.globl vector44
vector44:
  pushl $0
c01023da:	6a 00                	push   $0x0
  pushl $44
c01023dc:	6a 2c                	push   $0x2c
  jmp __alltraps
c01023de:	e9 eb 08 00 00       	jmp    c0102cce <__alltraps>

c01023e3 <vector45>:
.globl vector45
vector45:
  pushl $0
c01023e3:	6a 00                	push   $0x0
  pushl $45
c01023e5:	6a 2d                	push   $0x2d
  jmp __alltraps
c01023e7:	e9 e2 08 00 00       	jmp    c0102cce <__alltraps>

c01023ec <vector46>:
.globl vector46
vector46:
  pushl $0
c01023ec:	6a 00                	push   $0x0
  pushl $46
c01023ee:	6a 2e                	push   $0x2e
  jmp __alltraps
c01023f0:	e9 d9 08 00 00       	jmp    c0102cce <__alltraps>

c01023f5 <vector47>:
.globl vector47
vector47:
  pushl $0
c01023f5:	6a 00                	push   $0x0
  pushl $47
c01023f7:	6a 2f                	push   $0x2f
  jmp __alltraps
c01023f9:	e9 d0 08 00 00       	jmp    c0102cce <__alltraps>

c01023fe <vector48>:
.globl vector48
vector48:
  pushl $0
c01023fe:	6a 00                	push   $0x0
  pushl $48
c0102400:	6a 30                	push   $0x30
  jmp __alltraps
c0102402:	e9 c7 08 00 00       	jmp    c0102cce <__alltraps>

c0102407 <vector49>:
.globl vector49
vector49:
  pushl $0
c0102407:	6a 00                	push   $0x0
  pushl $49
c0102409:	6a 31                	push   $0x31
  jmp __alltraps
c010240b:	e9 be 08 00 00       	jmp    c0102cce <__alltraps>

c0102410 <vector50>:
.globl vector50
vector50:
  pushl $0
c0102410:	6a 00                	push   $0x0
  pushl $50
c0102412:	6a 32                	push   $0x32
  jmp __alltraps
c0102414:	e9 b5 08 00 00       	jmp    c0102cce <__alltraps>

c0102419 <vector51>:
.globl vector51
vector51:
  pushl $0
c0102419:	6a 00                	push   $0x0
  pushl $51
c010241b:	6a 33                	push   $0x33
  jmp __alltraps
c010241d:	e9 ac 08 00 00       	jmp    c0102cce <__alltraps>

c0102422 <vector52>:
.globl vector52
vector52:
  pushl $0
c0102422:	6a 00                	push   $0x0
  pushl $52
c0102424:	6a 34                	push   $0x34
  jmp __alltraps
c0102426:	e9 a3 08 00 00       	jmp    c0102cce <__alltraps>

c010242b <vector53>:
.globl vector53
vector53:
  pushl $0
c010242b:	6a 00                	push   $0x0
  pushl $53
c010242d:	6a 35                	push   $0x35
  jmp __alltraps
c010242f:	e9 9a 08 00 00       	jmp    c0102cce <__alltraps>

c0102434 <vector54>:
.globl vector54
vector54:
  pushl $0
c0102434:	6a 00                	push   $0x0
  pushl $54
c0102436:	6a 36                	push   $0x36
  jmp __alltraps
c0102438:	e9 91 08 00 00       	jmp    c0102cce <__alltraps>

c010243d <vector55>:
.globl vector55
vector55:
  pushl $0
c010243d:	6a 00                	push   $0x0
  pushl $55
c010243f:	6a 37                	push   $0x37
  jmp __alltraps
c0102441:	e9 88 08 00 00       	jmp    c0102cce <__alltraps>

c0102446 <vector56>:
.globl vector56
vector56:
  pushl $0
c0102446:	6a 00                	push   $0x0
  pushl $56
c0102448:	6a 38                	push   $0x38
  jmp __alltraps
c010244a:	e9 7f 08 00 00       	jmp    c0102cce <__alltraps>

c010244f <vector57>:
.globl vector57
vector57:
  pushl $0
c010244f:	6a 00                	push   $0x0
  pushl $57
c0102451:	6a 39                	push   $0x39
  jmp __alltraps
c0102453:	e9 76 08 00 00       	jmp    c0102cce <__alltraps>

c0102458 <vector58>:
.globl vector58
vector58:
  pushl $0
c0102458:	6a 00                	push   $0x0
  pushl $58
c010245a:	6a 3a                	push   $0x3a
  jmp __alltraps
c010245c:	e9 6d 08 00 00       	jmp    c0102cce <__alltraps>

c0102461 <vector59>:
.globl vector59
vector59:
  pushl $0
c0102461:	6a 00                	push   $0x0
  pushl $59
c0102463:	6a 3b                	push   $0x3b
  jmp __alltraps
c0102465:	e9 64 08 00 00       	jmp    c0102cce <__alltraps>

c010246a <vector60>:
.globl vector60
vector60:
  pushl $0
c010246a:	6a 00                	push   $0x0
  pushl $60
c010246c:	6a 3c                	push   $0x3c
  jmp __alltraps
c010246e:	e9 5b 08 00 00       	jmp    c0102cce <__alltraps>

c0102473 <vector61>:
.globl vector61
vector61:
  pushl $0
c0102473:	6a 00                	push   $0x0
  pushl $61
c0102475:	6a 3d                	push   $0x3d
  jmp __alltraps
c0102477:	e9 52 08 00 00       	jmp    c0102cce <__alltraps>

c010247c <vector62>:
.globl vector62
vector62:
  pushl $0
c010247c:	6a 00                	push   $0x0
  pushl $62
c010247e:	6a 3e                	push   $0x3e
  jmp __alltraps
c0102480:	e9 49 08 00 00       	jmp    c0102cce <__alltraps>

c0102485 <vector63>:
.globl vector63
vector63:
  pushl $0
c0102485:	6a 00                	push   $0x0
  pushl $63
c0102487:	6a 3f                	push   $0x3f
  jmp __alltraps
c0102489:	e9 40 08 00 00       	jmp    c0102cce <__alltraps>

c010248e <vector64>:
.globl vector64
vector64:
  pushl $0
c010248e:	6a 00                	push   $0x0
  pushl $64
c0102490:	6a 40                	push   $0x40
  jmp __alltraps
c0102492:	e9 37 08 00 00       	jmp    c0102cce <__alltraps>

c0102497 <vector65>:
.globl vector65
vector65:
  pushl $0
c0102497:	6a 00                	push   $0x0
  pushl $65
c0102499:	6a 41                	push   $0x41
  jmp __alltraps
c010249b:	e9 2e 08 00 00       	jmp    c0102cce <__alltraps>

c01024a0 <vector66>:
.globl vector66
vector66:
  pushl $0
c01024a0:	6a 00                	push   $0x0
  pushl $66
c01024a2:	6a 42                	push   $0x42
  jmp __alltraps
c01024a4:	e9 25 08 00 00       	jmp    c0102cce <__alltraps>

c01024a9 <vector67>:
.globl vector67
vector67:
  pushl $0
c01024a9:	6a 00                	push   $0x0
  pushl $67
c01024ab:	6a 43                	push   $0x43
  jmp __alltraps
c01024ad:	e9 1c 08 00 00       	jmp    c0102cce <__alltraps>

c01024b2 <vector68>:
.globl vector68
vector68:
  pushl $0
c01024b2:	6a 00                	push   $0x0
  pushl $68
c01024b4:	6a 44                	push   $0x44
  jmp __alltraps
c01024b6:	e9 13 08 00 00       	jmp    c0102cce <__alltraps>

c01024bb <vector69>:
.globl vector69
vector69:
  pushl $0
c01024bb:	6a 00                	push   $0x0
  pushl $69
c01024bd:	6a 45                	push   $0x45
  jmp __alltraps
c01024bf:	e9 0a 08 00 00       	jmp    c0102cce <__alltraps>

c01024c4 <vector70>:
.globl vector70
vector70:
  pushl $0
c01024c4:	6a 00                	push   $0x0
  pushl $70
c01024c6:	6a 46                	push   $0x46
  jmp __alltraps
c01024c8:	e9 01 08 00 00       	jmp    c0102cce <__alltraps>

c01024cd <vector71>:
.globl vector71
vector71:
  pushl $0
c01024cd:	6a 00                	push   $0x0
  pushl $71
c01024cf:	6a 47                	push   $0x47
  jmp __alltraps
c01024d1:	e9 f8 07 00 00       	jmp    c0102cce <__alltraps>

c01024d6 <vector72>:
.globl vector72
vector72:
  pushl $0
c01024d6:	6a 00                	push   $0x0
  pushl $72
c01024d8:	6a 48                	push   $0x48
  jmp __alltraps
c01024da:	e9 ef 07 00 00       	jmp    c0102cce <__alltraps>

c01024df <vector73>:
.globl vector73
vector73:
  pushl $0
c01024df:	6a 00                	push   $0x0
  pushl $73
c01024e1:	6a 49                	push   $0x49
  jmp __alltraps
c01024e3:	e9 e6 07 00 00       	jmp    c0102cce <__alltraps>

c01024e8 <vector74>:
.globl vector74
vector74:
  pushl $0
c01024e8:	6a 00                	push   $0x0
  pushl $74
c01024ea:	6a 4a                	push   $0x4a
  jmp __alltraps
c01024ec:	e9 dd 07 00 00       	jmp    c0102cce <__alltraps>

c01024f1 <vector75>:
.globl vector75
vector75:
  pushl $0
c01024f1:	6a 00                	push   $0x0
  pushl $75
c01024f3:	6a 4b                	push   $0x4b
  jmp __alltraps
c01024f5:	e9 d4 07 00 00       	jmp    c0102cce <__alltraps>

c01024fa <vector76>:
.globl vector76
vector76:
  pushl $0
c01024fa:	6a 00                	push   $0x0
  pushl $76
c01024fc:	6a 4c                	push   $0x4c
  jmp __alltraps
c01024fe:	e9 cb 07 00 00       	jmp    c0102cce <__alltraps>

c0102503 <vector77>:
.globl vector77
vector77:
  pushl $0
c0102503:	6a 00                	push   $0x0
  pushl $77
c0102505:	6a 4d                	push   $0x4d
  jmp __alltraps
c0102507:	e9 c2 07 00 00       	jmp    c0102cce <__alltraps>

c010250c <vector78>:
.globl vector78
vector78:
  pushl $0
c010250c:	6a 00                	push   $0x0
  pushl $78
c010250e:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102510:	e9 b9 07 00 00       	jmp    c0102cce <__alltraps>

c0102515 <vector79>:
.globl vector79
vector79:
  pushl $0
c0102515:	6a 00                	push   $0x0
  pushl $79
c0102517:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102519:	e9 b0 07 00 00       	jmp    c0102cce <__alltraps>

c010251e <vector80>:
.globl vector80
vector80:
  pushl $0
c010251e:	6a 00                	push   $0x0
  pushl $80
c0102520:	6a 50                	push   $0x50
  jmp __alltraps
c0102522:	e9 a7 07 00 00       	jmp    c0102cce <__alltraps>

c0102527 <vector81>:
.globl vector81
vector81:
  pushl $0
c0102527:	6a 00                	push   $0x0
  pushl $81
c0102529:	6a 51                	push   $0x51
  jmp __alltraps
c010252b:	e9 9e 07 00 00       	jmp    c0102cce <__alltraps>

c0102530 <vector82>:
.globl vector82
vector82:
  pushl $0
c0102530:	6a 00                	push   $0x0
  pushl $82
c0102532:	6a 52                	push   $0x52
  jmp __alltraps
c0102534:	e9 95 07 00 00       	jmp    c0102cce <__alltraps>

c0102539 <vector83>:
.globl vector83
vector83:
  pushl $0
c0102539:	6a 00                	push   $0x0
  pushl $83
c010253b:	6a 53                	push   $0x53
  jmp __alltraps
c010253d:	e9 8c 07 00 00       	jmp    c0102cce <__alltraps>

c0102542 <vector84>:
.globl vector84
vector84:
  pushl $0
c0102542:	6a 00                	push   $0x0
  pushl $84
c0102544:	6a 54                	push   $0x54
  jmp __alltraps
c0102546:	e9 83 07 00 00       	jmp    c0102cce <__alltraps>

c010254b <vector85>:
.globl vector85
vector85:
  pushl $0
c010254b:	6a 00                	push   $0x0
  pushl $85
c010254d:	6a 55                	push   $0x55
  jmp __alltraps
c010254f:	e9 7a 07 00 00       	jmp    c0102cce <__alltraps>

c0102554 <vector86>:
.globl vector86
vector86:
  pushl $0
c0102554:	6a 00                	push   $0x0
  pushl $86
c0102556:	6a 56                	push   $0x56
  jmp __alltraps
c0102558:	e9 71 07 00 00       	jmp    c0102cce <__alltraps>

c010255d <vector87>:
.globl vector87
vector87:
  pushl $0
c010255d:	6a 00                	push   $0x0
  pushl $87
c010255f:	6a 57                	push   $0x57
  jmp __alltraps
c0102561:	e9 68 07 00 00       	jmp    c0102cce <__alltraps>

c0102566 <vector88>:
.globl vector88
vector88:
  pushl $0
c0102566:	6a 00                	push   $0x0
  pushl $88
c0102568:	6a 58                	push   $0x58
  jmp __alltraps
c010256a:	e9 5f 07 00 00       	jmp    c0102cce <__alltraps>

c010256f <vector89>:
.globl vector89
vector89:
  pushl $0
c010256f:	6a 00                	push   $0x0
  pushl $89
c0102571:	6a 59                	push   $0x59
  jmp __alltraps
c0102573:	e9 56 07 00 00       	jmp    c0102cce <__alltraps>

c0102578 <vector90>:
.globl vector90
vector90:
  pushl $0
c0102578:	6a 00                	push   $0x0
  pushl $90
c010257a:	6a 5a                	push   $0x5a
  jmp __alltraps
c010257c:	e9 4d 07 00 00       	jmp    c0102cce <__alltraps>

c0102581 <vector91>:
.globl vector91
vector91:
  pushl $0
c0102581:	6a 00                	push   $0x0
  pushl $91
c0102583:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102585:	e9 44 07 00 00       	jmp    c0102cce <__alltraps>

c010258a <vector92>:
.globl vector92
vector92:
  pushl $0
c010258a:	6a 00                	push   $0x0
  pushl $92
c010258c:	6a 5c                	push   $0x5c
  jmp __alltraps
c010258e:	e9 3b 07 00 00       	jmp    c0102cce <__alltraps>

c0102593 <vector93>:
.globl vector93
vector93:
  pushl $0
c0102593:	6a 00                	push   $0x0
  pushl $93
c0102595:	6a 5d                	push   $0x5d
  jmp __alltraps
c0102597:	e9 32 07 00 00       	jmp    c0102cce <__alltraps>

c010259c <vector94>:
.globl vector94
vector94:
  pushl $0
c010259c:	6a 00                	push   $0x0
  pushl $94
c010259e:	6a 5e                	push   $0x5e
  jmp __alltraps
c01025a0:	e9 29 07 00 00       	jmp    c0102cce <__alltraps>

c01025a5 <vector95>:
.globl vector95
vector95:
  pushl $0
c01025a5:	6a 00                	push   $0x0
  pushl $95
c01025a7:	6a 5f                	push   $0x5f
  jmp __alltraps
c01025a9:	e9 20 07 00 00       	jmp    c0102cce <__alltraps>

c01025ae <vector96>:
.globl vector96
vector96:
  pushl $0
c01025ae:	6a 00                	push   $0x0
  pushl $96
c01025b0:	6a 60                	push   $0x60
  jmp __alltraps
c01025b2:	e9 17 07 00 00       	jmp    c0102cce <__alltraps>

c01025b7 <vector97>:
.globl vector97
vector97:
  pushl $0
c01025b7:	6a 00                	push   $0x0
  pushl $97
c01025b9:	6a 61                	push   $0x61
  jmp __alltraps
c01025bb:	e9 0e 07 00 00       	jmp    c0102cce <__alltraps>

c01025c0 <vector98>:
.globl vector98
vector98:
  pushl $0
c01025c0:	6a 00                	push   $0x0
  pushl $98
c01025c2:	6a 62                	push   $0x62
  jmp __alltraps
c01025c4:	e9 05 07 00 00       	jmp    c0102cce <__alltraps>

c01025c9 <vector99>:
.globl vector99
vector99:
  pushl $0
c01025c9:	6a 00                	push   $0x0
  pushl $99
c01025cb:	6a 63                	push   $0x63
  jmp __alltraps
c01025cd:	e9 fc 06 00 00       	jmp    c0102cce <__alltraps>

c01025d2 <vector100>:
.globl vector100
vector100:
  pushl $0
c01025d2:	6a 00                	push   $0x0
  pushl $100
c01025d4:	6a 64                	push   $0x64
  jmp __alltraps
c01025d6:	e9 f3 06 00 00       	jmp    c0102cce <__alltraps>

c01025db <vector101>:
.globl vector101
vector101:
  pushl $0
c01025db:	6a 00                	push   $0x0
  pushl $101
c01025dd:	6a 65                	push   $0x65
  jmp __alltraps
c01025df:	e9 ea 06 00 00       	jmp    c0102cce <__alltraps>

c01025e4 <vector102>:
.globl vector102
vector102:
  pushl $0
c01025e4:	6a 00                	push   $0x0
  pushl $102
c01025e6:	6a 66                	push   $0x66
  jmp __alltraps
c01025e8:	e9 e1 06 00 00       	jmp    c0102cce <__alltraps>

c01025ed <vector103>:
.globl vector103
vector103:
  pushl $0
c01025ed:	6a 00                	push   $0x0
  pushl $103
c01025ef:	6a 67                	push   $0x67
  jmp __alltraps
c01025f1:	e9 d8 06 00 00       	jmp    c0102cce <__alltraps>

c01025f6 <vector104>:
.globl vector104
vector104:
  pushl $0
c01025f6:	6a 00                	push   $0x0
  pushl $104
c01025f8:	6a 68                	push   $0x68
  jmp __alltraps
c01025fa:	e9 cf 06 00 00       	jmp    c0102cce <__alltraps>

c01025ff <vector105>:
.globl vector105
vector105:
  pushl $0
c01025ff:	6a 00                	push   $0x0
  pushl $105
c0102601:	6a 69                	push   $0x69
  jmp __alltraps
c0102603:	e9 c6 06 00 00       	jmp    c0102cce <__alltraps>

c0102608 <vector106>:
.globl vector106
vector106:
  pushl $0
c0102608:	6a 00                	push   $0x0
  pushl $106
c010260a:	6a 6a                	push   $0x6a
  jmp __alltraps
c010260c:	e9 bd 06 00 00       	jmp    c0102cce <__alltraps>

c0102611 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102611:	6a 00                	push   $0x0
  pushl $107
c0102613:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102615:	e9 b4 06 00 00       	jmp    c0102cce <__alltraps>

c010261a <vector108>:
.globl vector108
vector108:
  pushl $0
c010261a:	6a 00                	push   $0x0
  pushl $108
c010261c:	6a 6c                	push   $0x6c
  jmp __alltraps
c010261e:	e9 ab 06 00 00       	jmp    c0102cce <__alltraps>

c0102623 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102623:	6a 00                	push   $0x0
  pushl $109
c0102625:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102627:	e9 a2 06 00 00       	jmp    c0102cce <__alltraps>

c010262c <vector110>:
.globl vector110
vector110:
  pushl $0
c010262c:	6a 00                	push   $0x0
  pushl $110
c010262e:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102630:	e9 99 06 00 00       	jmp    c0102cce <__alltraps>

c0102635 <vector111>:
.globl vector111
vector111:
  pushl $0
c0102635:	6a 00                	push   $0x0
  pushl $111
c0102637:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102639:	e9 90 06 00 00       	jmp    c0102cce <__alltraps>

c010263e <vector112>:
.globl vector112
vector112:
  pushl $0
c010263e:	6a 00                	push   $0x0
  pushl $112
c0102640:	6a 70                	push   $0x70
  jmp __alltraps
c0102642:	e9 87 06 00 00       	jmp    c0102cce <__alltraps>

c0102647 <vector113>:
.globl vector113
vector113:
  pushl $0
c0102647:	6a 00                	push   $0x0
  pushl $113
c0102649:	6a 71                	push   $0x71
  jmp __alltraps
c010264b:	e9 7e 06 00 00       	jmp    c0102cce <__alltraps>

c0102650 <vector114>:
.globl vector114
vector114:
  pushl $0
c0102650:	6a 00                	push   $0x0
  pushl $114
c0102652:	6a 72                	push   $0x72
  jmp __alltraps
c0102654:	e9 75 06 00 00       	jmp    c0102cce <__alltraps>

c0102659 <vector115>:
.globl vector115
vector115:
  pushl $0
c0102659:	6a 00                	push   $0x0
  pushl $115
c010265b:	6a 73                	push   $0x73
  jmp __alltraps
c010265d:	e9 6c 06 00 00       	jmp    c0102cce <__alltraps>

c0102662 <vector116>:
.globl vector116
vector116:
  pushl $0
c0102662:	6a 00                	push   $0x0
  pushl $116
c0102664:	6a 74                	push   $0x74
  jmp __alltraps
c0102666:	e9 63 06 00 00       	jmp    c0102cce <__alltraps>

c010266b <vector117>:
.globl vector117
vector117:
  pushl $0
c010266b:	6a 00                	push   $0x0
  pushl $117
c010266d:	6a 75                	push   $0x75
  jmp __alltraps
c010266f:	e9 5a 06 00 00       	jmp    c0102cce <__alltraps>

c0102674 <vector118>:
.globl vector118
vector118:
  pushl $0
c0102674:	6a 00                	push   $0x0
  pushl $118
c0102676:	6a 76                	push   $0x76
  jmp __alltraps
c0102678:	e9 51 06 00 00       	jmp    c0102cce <__alltraps>

c010267d <vector119>:
.globl vector119
vector119:
  pushl $0
c010267d:	6a 00                	push   $0x0
  pushl $119
c010267f:	6a 77                	push   $0x77
  jmp __alltraps
c0102681:	e9 48 06 00 00       	jmp    c0102cce <__alltraps>

c0102686 <vector120>:
.globl vector120
vector120:
  pushl $0
c0102686:	6a 00                	push   $0x0
  pushl $120
c0102688:	6a 78                	push   $0x78
  jmp __alltraps
c010268a:	e9 3f 06 00 00       	jmp    c0102cce <__alltraps>

c010268f <vector121>:
.globl vector121
vector121:
  pushl $0
c010268f:	6a 00                	push   $0x0
  pushl $121
c0102691:	6a 79                	push   $0x79
  jmp __alltraps
c0102693:	e9 36 06 00 00       	jmp    c0102cce <__alltraps>

c0102698 <vector122>:
.globl vector122
vector122:
  pushl $0
c0102698:	6a 00                	push   $0x0
  pushl $122
c010269a:	6a 7a                	push   $0x7a
  jmp __alltraps
c010269c:	e9 2d 06 00 00       	jmp    c0102cce <__alltraps>

c01026a1 <vector123>:
.globl vector123
vector123:
  pushl $0
c01026a1:	6a 00                	push   $0x0
  pushl $123
c01026a3:	6a 7b                	push   $0x7b
  jmp __alltraps
c01026a5:	e9 24 06 00 00       	jmp    c0102cce <__alltraps>

c01026aa <vector124>:
.globl vector124
vector124:
  pushl $0
c01026aa:	6a 00                	push   $0x0
  pushl $124
c01026ac:	6a 7c                	push   $0x7c
  jmp __alltraps
c01026ae:	e9 1b 06 00 00       	jmp    c0102cce <__alltraps>

c01026b3 <vector125>:
.globl vector125
vector125:
  pushl $0
c01026b3:	6a 00                	push   $0x0
  pushl $125
c01026b5:	6a 7d                	push   $0x7d
  jmp __alltraps
c01026b7:	e9 12 06 00 00       	jmp    c0102cce <__alltraps>

c01026bc <vector126>:
.globl vector126
vector126:
  pushl $0
c01026bc:	6a 00                	push   $0x0
  pushl $126
c01026be:	6a 7e                	push   $0x7e
  jmp __alltraps
c01026c0:	e9 09 06 00 00       	jmp    c0102cce <__alltraps>

c01026c5 <vector127>:
.globl vector127
vector127:
  pushl $0
c01026c5:	6a 00                	push   $0x0
  pushl $127
c01026c7:	6a 7f                	push   $0x7f
  jmp __alltraps
c01026c9:	e9 00 06 00 00       	jmp    c0102cce <__alltraps>

c01026ce <vector128>:
.globl vector128
vector128:
  pushl $0
c01026ce:	6a 00                	push   $0x0
  pushl $128
c01026d0:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c01026d5:	e9 f4 05 00 00       	jmp    c0102cce <__alltraps>

c01026da <vector129>:
.globl vector129
vector129:
  pushl $0
c01026da:	6a 00                	push   $0x0
  pushl $129
c01026dc:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c01026e1:	e9 e8 05 00 00       	jmp    c0102cce <__alltraps>

c01026e6 <vector130>:
.globl vector130
vector130:
  pushl $0
c01026e6:	6a 00                	push   $0x0
  pushl $130
c01026e8:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c01026ed:	e9 dc 05 00 00       	jmp    c0102cce <__alltraps>

c01026f2 <vector131>:
.globl vector131
vector131:
  pushl $0
c01026f2:	6a 00                	push   $0x0
  pushl $131
c01026f4:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c01026f9:	e9 d0 05 00 00       	jmp    c0102cce <__alltraps>

c01026fe <vector132>:
.globl vector132
vector132:
  pushl $0
c01026fe:	6a 00                	push   $0x0
  pushl $132
c0102700:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102705:	e9 c4 05 00 00       	jmp    c0102cce <__alltraps>

c010270a <vector133>:
.globl vector133
vector133:
  pushl $0
c010270a:	6a 00                	push   $0x0
  pushl $133
c010270c:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102711:	e9 b8 05 00 00       	jmp    c0102cce <__alltraps>

c0102716 <vector134>:
.globl vector134
vector134:
  pushl $0
c0102716:	6a 00                	push   $0x0
  pushl $134
c0102718:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c010271d:	e9 ac 05 00 00       	jmp    c0102cce <__alltraps>

c0102722 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102722:	6a 00                	push   $0x0
  pushl $135
c0102724:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102729:	e9 a0 05 00 00       	jmp    c0102cce <__alltraps>

c010272e <vector136>:
.globl vector136
vector136:
  pushl $0
c010272e:	6a 00                	push   $0x0
  pushl $136
c0102730:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102735:	e9 94 05 00 00       	jmp    c0102cce <__alltraps>

c010273a <vector137>:
.globl vector137
vector137:
  pushl $0
c010273a:	6a 00                	push   $0x0
  pushl $137
c010273c:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102741:	e9 88 05 00 00       	jmp    c0102cce <__alltraps>

c0102746 <vector138>:
.globl vector138
vector138:
  pushl $0
c0102746:	6a 00                	push   $0x0
  pushl $138
c0102748:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c010274d:	e9 7c 05 00 00       	jmp    c0102cce <__alltraps>

c0102752 <vector139>:
.globl vector139
vector139:
  pushl $0
c0102752:	6a 00                	push   $0x0
  pushl $139
c0102754:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102759:	e9 70 05 00 00       	jmp    c0102cce <__alltraps>

c010275e <vector140>:
.globl vector140
vector140:
  pushl $0
c010275e:	6a 00                	push   $0x0
  pushl $140
c0102760:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102765:	e9 64 05 00 00       	jmp    c0102cce <__alltraps>

c010276a <vector141>:
.globl vector141
vector141:
  pushl $0
c010276a:	6a 00                	push   $0x0
  pushl $141
c010276c:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102771:	e9 58 05 00 00       	jmp    c0102cce <__alltraps>

c0102776 <vector142>:
.globl vector142
vector142:
  pushl $0
c0102776:	6a 00                	push   $0x0
  pushl $142
c0102778:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c010277d:	e9 4c 05 00 00       	jmp    c0102cce <__alltraps>

c0102782 <vector143>:
.globl vector143
vector143:
  pushl $0
c0102782:	6a 00                	push   $0x0
  pushl $143
c0102784:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102789:	e9 40 05 00 00       	jmp    c0102cce <__alltraps>

c010278e <vector144>:
.globl vector144
vector144:
  pushl $0
c010278e:	6a 00                	push   $0x0
  pushl $144
c0102790:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102795:	e9 34 05 00 00       	jmp    c0102cce <__alltraps>

c010279a <vector145>:
.globl vector145
vector145:
  pushl $0
c010279a:	6a 00                	push   $0x0
  pushl $145
c010279c:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c01027a1:	e9 28 05 00 00       	jmp    c0102cce <__alltraps>

c01027a6 <vector146>:
.globl vector146
vector146:
  pushl $0
c01027a6:	6a 00                	push   $0x0
  pushl $146
c01027a8:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c01027ad:	e9 1c 05 00 00       	jmp    c0102cce <__alltraps>

c01027b2 <vector147>:
.globl vector147
vector147:
  pushl $0
c01027b2:	6a 00                	push   $0x0
  pushl $147
c01027b4:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c01027b9:	e9 10 05 00 00       	jmp    c0102cce <__alltraps>

c01027be <vector148>:
.globl vector148
vector148:
  pushl $0
c01027be:	6a 00                	push   $0x0
  pushl $148
c01027c0:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c01027c5:	e9 04 05 00 00       	jmp    c0102cce <__alltraps>

c01027ca <vector149>:
.globl vector149
vector149:
  pushl $0
c01027ca:	6a 00                	push   $0x0
  pushl $149
c01027cc:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c01027d1:	e9 f8 04 00 00       	jmp    c0102cce <__alltraps>

c01027d6 <vector150>:
.globl vector150
vector150:
  pushl $0
c01027d6:	6a 00                	push   $0x0
  pushl $150
c01027d8:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c01027dd:	e9 ec 04 00 00       	jmp    c0102cce <__alltraps>

c01027e2 <vector151>:
.globl vector151
vector151:
  pushl $0
c01027e2:	6a 00                	push   $0x0
  pushl $151
c01027e4:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c01027e9:	e9 e0 04 00 00       	jmp    c0102cce <__alltraps>

c01027ee <vector152>:
.globl vector152
vector152:
  pushl $0
c01027ee:	6a 00                	push   $0x0
  pushl $152
c01027f0:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c01027f5:	e9 d4 04 00 00       	jmp    c0102cce <__alltraps>

c01027fa <vector153>:
.globl vector153
vector153:
  pushl $0
c01027fa:	6a 00                	push   $0x0
  pushl $153
c01027fc:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102801:	e9 c8 04 00 00       	jmp    c0102cce <__alltraps>

c0102806 <vector154>:
.globl vector154
vector154:
  pushl $0
c0102806:	6a 00                	push   $0x0
  pushl $154
c0102808:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c010280d:	e9 bc 04 00 00       	jmp    c0102cce <__alltraps>

c0102812 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102812:	6a 00                	push   $0x0
  pushl $155
c0102814:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102819:	e9 b0 04 00 00       	jmp    c0102cce <__alltraps>

c010281e <vector156>:
.globl vector156
vector156:
  pushl $0
c010281e:	6a 00                	push   $0x0
  pushl $156
c0102820:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102825:	e9 a4 04 00 00       	jmp    c0102cce <__alltraps>

c010282a <vector157>:
.globl vector157
vector157:
  pushl $0
c010282a:	6a 00                	push   $0x0
  pushl $157
c010282c:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102831:	e9 98 04 00 00       	jmp    c0102cce <__alltraps>

c0102836 <vector158>:
.globl vector158
vector158:
  pushl $0
c0102836:	6a 00                	push   $0x0
  pushl $158
c0102838:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c010283d:	e9 8c 04 00 00       	jmp    c0102cce <__alltraps>

c0102842 <vector159>:
.globl vector159
vector159:
  pushl $0
c0102842:	6a 00                	push   $0x0
  pushl $159
c0102844:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102849:	e9 80 04 00 00       	jmp    c0102cce <__alltraps>

c010284e <vector160>:
.globl vector160
vector160:
  pushl $0
c010284e:	6a 00                	push   $0x0
  pushl $160
c0102850:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0102855:	e9 74 04 00 00       	jmp    c0102cce <__alltraps>

c010285a <vector161>:
.globl vector161
vector161:
  pushl $0
c010285a:	6a 00                	push   $0x0
  pushl $161
c010285c:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c0102861:	e9 68 04 00 00       	jmp    c0102cce <__alltraps>

c0102866 <vector162>:
.globl vector162
vector162:
  pushl $0
c0102866:	6a 00                	push   $0x0
  pushl $162
c0102868:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c010286d:	e9 5c 04 00 00       	jmp    c0102cce <__alltraps>

c0102872 <vector163>:
.globl vector163
vector163:
  pushl $0
c0102872:	6a 00                	push   $0x0
  pushl $163
c0102874:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0102879:	e9 50 04 00 00       	jmp    c0102cce <__alltraps>

c010287e <vector164>:
.globl vector164
vector164:
  pushl $0
c010287e:	6a 00                	push   $0x0
  pushl $164
c0102880:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0102885:	e9 44 04 00 00       	jmp    c0102cce <__alltraps>

c010288a <vector165>:
.globl vector165
vector165:
  pushl $0
c010288a:	6a 00                	push   $0x0
  pushl $165
c010288c:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c0102891:	e9 38 04 00 00       	jmp    c0102cce <__alltraps>

c0102896 <vector166>:
.globl vector166
vector166:
  pushl $0
c0102896:	6a 00                	push   $0x0
  pushl $166
c0102898:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c010289d:	e9 2c 04 00 00       	jmp    c0102cce <__alltraps>

c01028a2 <vector167>:
.globl vector167
vector167:
  pushl $0
c01028a2:	6a 00                	push   $0x0
  pushl $167
c01028a4:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c01028a9:	e9 20 04 00 00       	jmp    c0102cce <__alltraps>

c01028ae <vector168>:
.globl vector168
vector168:
  pushl $0
c01028ae:	6a 00                	push   $0x0
  pushl $168
c01028b0:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c01028b5:	e9 14 04 00 00       	jmp    c0102cce <__alltraps>

c01028ba <vector169>:
.globl vector169
vector169:
  pushl $0
c01028ba:	6a 00                	push   $0x0
  pushl $169
c01028bc:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c01028c1:	e9 08 04 00 00       	jmp    c0102cce <__alltraps>

c01028c6 <vector170>:
.globl vector170
vector170:
  pushl $0
c01028c6:	6a 00                	push   $0x0
  pushl $170
c01028c8:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c01028cd:	e9 fc 03 00 00       	jmp    c0102cce <__alltraps>

c01028d2 <vector171>:
.globl vector171
vector171:
  pushl $0
c01028d2:	6a 00                	push   $0x0
  pushl $171
c01028d4:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c01028d9:	e9 f0 03 00 00       	jmp    c0102cce <__alltraps>

c01028de <vector172>:
.globl vector172
vector172:
  pushl $0
c01028de:	6a 00                	push   $0x0
  pushl $172
c01028e0:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c01028e5:	e9 e4 03 00 00       	jmp    c0102cce <__alltraps>

c01028ea <vector173>:
.globl vector173
vector173:
  pushl $0
c01028ea:	6a 00                	push   $0x0
  pushl $173
c01028ec:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c01028f1:	e9 d8 03 00 00       	jmp    c0102cce <__alltraps>

c01028f6 <vector174>:
.globl vector174
vector174:
  pushl $0
c01028f6:	6a 00                	push   $0x0
  pushl $174
c01028f8:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c01028fd:	e9 cc 03 00 00       	jmp    c0102cce <__alltraps>

c0102902 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102902:	6a 00                	push   $0x0
  pushl $175
c0102904:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c0102909:	e9 c0 03 00 00       	jmp    c0102cce <__alltraps>

c010290e <vector176>:
.globl vector176
vector176:
  pushl $0
c010290e:	6a 00                	push   $0x0
  pushl $176
c0102910:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102915:	e9 b4 03 00 00       	jmp    c0102cce <__alltraps>

c010291a <vector177>:
.globl vector177
vector177:
  pushl $0
c010291a:	6a 00                	push   $0x0
  pushl $177
c010291c:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102921:	e9 a8 03 00 00       	jmp    c0102cce <__alltraps>

c0102926 <vector178>:
.globl vector178
vector178:
  pushl $0
c0102926:	6a 00                	push   $0x0
  pushl $178
c0102928:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c010292d:	e9 9c 03 00 00       	jmp    c0102cce <__alltraps>

c0102932 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102932:	6a 00                	push   $0x0
  pushl $179
c0102934:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0102939:	e9 90 03 00 00       	jmp    c0102cce <__alltraps>

c010293e <vector180>:
.globl vector180
vector180:
  pushl $0
c010293e:	6a 00                	push   $0x0
  pushl $180
c0102940:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0102945:	e9 84 03 00 00       	jmp    c0102cce <__alltraps>

c010294a <vector181>:
.globl vector181
vector181:
  pushl $0
c010294a:	6a 00                	push   $0x0
  pushl $181
c010294c:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0102951:	e9 78 03 00 00       	jmp    c0102cce <__alltraps>

c0102956 <vector182>:
.globl vector182
vector182:
  pushl $0
c0102956:	6a 00                	push   $0x0
  pushl $182
c0102958:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c010295d:	e9 6c 03 00 00       	jmp    c0102cce <__alltraps>

c0102962 <vector183>:
.globl vector183
vector183:
  pushl $0
c0102962:	6a 00                	push   $0x0
  pushl $183
c0102964:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0102969:	e9 60 03 00 00       	jmp    c0102cce <__alltraps>

c010296e <vector184>:
.globl vector184
vector184:
  pushl $0
c010296e:	6a 00                	push   $0x0
  pushl $184
c0102970:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c0102975:	e9 54 03 00 00       	jmp    c0102cce <__alltraps>

c010297a <vector185>:
.globl vector185
vector185:
  pushl $0
c010297a:	6a 00                	push   $0x0
  pushl $185
c010297c:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c0102981:	e9 48 03 00 00       	jmp    c0102cce <__alltraps>

c0102986 <vector186>:
.globl vector186
vector186:
  pushl $0
c0102986:	6a 00                	push   $0x0
  pushl $186
c0102988:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c010298d:	e9 3c 03 00 00       	jmp    c0102cce <__alltraps>

c0102992 <vector187>:
.globl vector187
vector187:
  pushl $0
c0102992:	6a 00                	push   $0x0
  pushl $187
c0102994:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c0102999:	e9 30 03 00 00       	jmp    c0102cce <__alltraps>

c010299e <vector188>:
.globl vector188
vector188:
  pushl $0
c010299e:	6a 00                	push   $0x0
  pushl $188
c01029a0:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c01029a5:	e9 24 03 00 00       	jmp    c0102cce <__alltraps>

c01029aa <vector189>:
.globl vector189
vector189:
  pushl $0
c01029aa:	6a 00                	push   $0x0
  pushl $189
c01029ac:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c01029b1:	e9 18 03 00 00       	jmp    c0102cce <__alltraps>

c01029b6 <vector190>:
.globl vector190
vector190:
  pushl $0
c01029b6:	6a 00                	push   $0x0
  pushl $190
c01029b8:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c01029bd:	e9 0c 03 00 00       	jmp    c0102cce <__alltraps>

c01029c2 <vector191>:
.globl vector191
vector191:
  pushl $0
c01029c2:	6a 00                	push   $0x0
  pushl $191
c01029c4:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c01029c9:	e9 00 03 00 00       	jmp    c0102cce <__alltraps>

c01029ce <vector192>:
.globl vector192
vector192:
  pushl $0
c01029ce:	6a 00                	push   $0x0
  pushl $192
c01029d0:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c01029d5:	e9 f4 02 00 00       	jmp    c0102cce <__alltraps>

c01029da <vector193>:
.globl vector193
vector193:
  pushl $0
c01029da:	6a 00                	push   $0x0
  pushl $193
c01029dc:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c01029e1:	e9 e8 02 00 00       	jmp    c0102cce <__alltraps>

c01029e6 <vector194>:
.globl vector194
vector194:
  pushl $0
c01029e6:	6a 00                	push   $0x0
  pushl $194
c01029e8:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c01029ed:	e9 dc 02 00 00       	jmp    c0102cce <__alltraps>

c01029f2 <vector195>:
.globl vector195
vector195:
  pushl $0
c01029f2:	6a 00                	push   $0x0
  pushl $195
c01029f4:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c01029f9:	e9 d0 02 00 00       	jmp    c0102cce <__alltraps>

c01029fe <vector196>:
.globl vector196
vector196:
  pushl $0
c01029fe:	6a 00                	push   $0x0
  pushl $196
c0102a00:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0102a05:	e9 c4 02 00 00       	jmp    c0102cce <__alltraps>

c0102a0a <vector197>:
.globl vector197
vector197:
  pushl $0
c0102a0a:	6a 00                	push   $0x0
  pushl $197
c0102a0c:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102a11:	e9 b8 02 00 00       	jmp    c0102cce <__alltraps>

c0102a16 <vector198>:
.globl vector198
vector198:
  pushl $0
c0102a16:	6a 00                	push   $0x0
  pushl $198
c0102a18:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0102a1d:	e9 ac 02 00 00       	jmp    c0102cce <__alltraps>

c0102a22 <vector199>:
.globl vector199
vector199:
  pushl $0
c0102a22:	6a 00                	push   $0x0
  pushl $199
c0102a24:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c0102a29:	e9 a0 02 00 00       	jmp    c0102cce <__alltraps>

c0102a2e <vector200>:
.globl vector200
vector200:
  pushl $0
c0102a2e:	6a 00                	push   $0x0
  pushl $200
c0102a30:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0102a35:	e9 94 02 00 00       	jmp    c0102cce <__alltraps>

c0102a3a <vector201>:
.globl vector201
vector201:
  pushl $0
c0102a3a:	6a 00                	push   $0x0
  pushl $201
c0102a3c:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0102a41:	e9 88 02 00 00       	jmp    c0102cce <__alltraps>

c0102a46 <vector202>:
.globl vector202
vector202:
  pushl $0
c0102a46:	6a 00                	push   $0x0
  pushl $202
c0102a48:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c0102a4d:	e9 7c 02 00 00       	jmp    c0102cce <__alltraps>

c0102a52 <vector203>:
.globl vector203
vector203:
  pushl $0
c0102a52:	6a 00                	push   $0x0
  pushl $203
c0102a54:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0102a59:	e9 70 02 00 00       	jmp    c0102cce <__alltraps>

c0102a5e <vector204>:
.globl vector204
vector204:
  pushl $0
c0102a5e:	6a 00                	push   $0x0
  pushl $204
c0102a60:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c0102a65:	e9 64 02 00 00       	jmp    c0102cce <__alltraps>

c0102a6a <vector205>:
.globl vector205
vector205:
  pushl $0
c0102a6a:	6a 00                	push   $0x0
  pushl $205
c0102a6c:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c0102a71:	e9 58 02 00 00       	jmp    c0102cce <__alltraps>

c0102a76 <vector206>:
.globl vector206
vector206:
  pushl $0
c0102a76:	6a 00                	push   $0x0
  pushl $206
c0102a78:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c0102a7d:	e9 4c 02 00 00       	jmp    c0102cce <__alltraps>

c0102a82 <vector207>:
.globl vector207
vector207:
  pushl $0
c0102a82:	6a 00                	push   $0x0
  pushl $207
c0102a84:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c0102a89:	e9 40 02 00 00       	jmp    c0102cce <__alltraps>

c0102a8e <vector208>:
.globl vector208
vector208:
  pushl $0
c0102a8e:	6a 00                	push   $0x0
  pushl $208
c0102a90:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c0102a95:	e9 34 02 00 00       	jmp    c0102cce <__alltraps>

c0102a9a <vector209>:
.globl vector209
vector209:
  pushl $0
c0102a9a:	6a 00                	push   $0x0
  pushl $209
c0102a9c:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0102aa1:	e9 28 02 00 00       	jmp    c0102cce <__alltraps>

c0102aa6 <vector210>:
.globl vector210
vector210:
  pushl $0
c0102aa6:	6a 00                	push   $0x0
  pushl $210
c0102aa8:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c0102aad:	e9 1c 02 00 00       	jmp    c0102cce <__alltraps>

c0102ab2 <vector211>:
.globl vector211
vector211:
  pushl $0
c0102ab2:	6a 00                	push   $0x0
  pushl $211
c0102ab4:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c0102ab9:	e9 10 02 00 00       	jmp    c0102cce <__alltraps>

c0102abe <vector212>:
.globl vector212
vector212:
  pushl $0
c0102abe:	6a 00                	push   $0x0
  pushl $212
c0102ac0:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c0102ac5:	e9 04 02 00 00       	jmp    c0102cce <__alltraps>

c0102aca <vector213>:
.globl vector213
vector213:
  pushl $0
c0102aca:	6a 00                	push   $0x0
  pushl $213
c0102acc:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c0102ad1:	e9 f8 01 00 00       	jmp    c0102cce <__alltraps>

c0102ad6 <vector214>:
.globl vector214
vector214:
  pushl $0
c0102ad6:	6a 00                	push   $0x0
  pushl $214
c0102ad8:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c0102add:	e9 ec 01 00 00       	jmp    c0102cce <__alltraps>

c0102ae2 <vector215>:
.globl vector215
vector215:
  pushl $0
c0102ae2:	6a 00                	push   $0x0
  pushl $215
c0102ae4:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c0102ae9:	e9 e0 01 00 00       	jmp    c0102cce <__alltraps>

c0102aee <vector216>:
.globl vector216
vector216:
  pushl $0
c0102aee:	6a 00                	push   $0x0
  pushl $216
c0102af0:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c0102af5:	e9 d4 01 00 00       	jmp    c0102cce <__alltraps>

c0102afa <vector217>:
.globl vector217
vector217:
  pushl $0
c0102afa:	6a 00                	push   $0x0
  pushl $217
c0102afc:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0102b01:	e9 c8 01 00 00       	jmp    c0102cce <__alltraps>

c0102b06 <vector218>:
.globl vector218
vector218:
  pushl $0
c0102b06:	6a 00                	push   $0x0
  pushl $218
c0102b08:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c0102b0d:	e9 bc 01 00 00       	jmp    c0102cce <__alltraps>

c0102b12 <vector219>:
.globl vector219
vector219:
  pushl $0
c0102b12:	6a 00                	push   $0x0
  pushl $219
c0102b14:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c0102b19:	e9 b0 01 00 00       	jmp    c0102cce <__alltraps>

c0102b1e <vector220>:
.globl vector220
vector220:
  pushl $0
c0102b1e:	6a 00                	push   $0x0
  pushl $220
c0102b20:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c0102b25:	e9 a4 01 00 00       	jmp    c0102cce <__alltraps>

c0102b2a <vector221>:
.globl vector221
vector221:
  pushl $0
c0102b2a:	6a 00                	push   $0x0
  pushl $221
c0102b2c:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0102b31:	e9 98 01 00 00       	jmp    c0102cce <__alltraps>

c0102b36 <vector222>:
.globl vector222
vector222:
  pushl $0
c0102b36:	6a 00                	push   $0x0
  pushl $222
c0102b38:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c0102b3d:	e9 8c 01 00 00       	jmp    c0102cce <__alltraps>

c0102b42 <vector223>:
.globl vector223
vector223:
  pushl $0
c0102b42:	6a 00                	push   $0x0
  pushl $223
c0102b44:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c0102b49:	e9 80 01 00 00       	jmp    c0102cce <__alltraps>

c0102b4e <vector224>:
.globl vector224
vector224:
  pushl $0
c0102b4e:	6a 00                	push   $0x0
  pushl $224
c0102b50:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c0102b55:	e9 74 01 00 00       	jmp    c0102cce <__alltraps>

c0102b5a <vector225>:
.globl vector225
vector225:
  pushl $0
c0102b5a:	6a 00                	push   $0x0
  pushl $225
c0102b5c:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c0102b61:	e9 68 01 00 00       	jmp    c0102cce <__alltraps>

c0102b66 <vector226>:
.globl vector226
vector226:
  pushl $0
c0102b66:	6a 00                	push   $0x0
  pushl $226
c0102b68:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c0102b6d:	e9 5c 01 00 00       	jmp    c0102cce <__alltraps>

c0102b72 <vector227>:
.globl vector227
vector227:
  pushl $0
c0102b72:	6a 00                	push   $0x0
  pushl $227
c0102b74:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c0102b79:	e9 50 01 00 00       	jmp    c0102cce <__alltraps>

c0102b7e <vector228>:
.globl vector228
vector228:
  pushl $0
c0102b7e:	6a 00                	push   $0x0
  pushl $228
c0102b80:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c0102b85:	e9 44 01 00 00       	jmp    c0102cce <__alltraps>

c0102b8a <vector229>:
.globl vector229
vector229:
  pushl $0
c0102b8a:	6a 00                	push   $0x0
  pushl $229
c0102b8c:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c0102b91:	e9 38 01 00 00       	jmp    c0102cce <__alltraps>

c0102b96 <vector230>:
.globl vector230
vector230:
  pushl $0
c0102b96:	6a 00                	push   $0x0
  pushl $230
c0102b98:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c0102b9d:	e9 2c 01 00 00       	jmp    c0102cce <__alltraps>

c0102ba2 <vector231>:
.globl vector231
vector231:
  pushl $0
c0102ba2:	6a 00                	push   $0x0
  pushl $231
c0102ba4:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c0102ba9:	e9 20 01 00 00       	jmp    c0102cce <__alltraps>

c0102bae <vector232>:
.globl vector232
vector232:
  pushl $0
c0102bae:	6a 00                	push   $0x0
  pushl $232
c0102bb0:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c0102bb5:	e9 14 01 00 00       	jmp    c0102cce <__alltraps>

c0102bba <vector233>:
.globl vector233
vector233:
  pushl $0
c0102bba:	6a 00                	push   $0x0
  pushl $233
c0102bbc:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c0102bc1:	e9 08 01 00 00       	jmp    c0102cce <__alltraps>

c0102bc6 <vector234>:
.globl vector234
vector234:
  pushl $0
c0102bc6:	6a 00                	push   $0x0
  pushl $234
c0102bc8:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c0102bcd:	e9 fc 00 00 00       	jmp    c0102cce <__alltraps>

c0102bd2 <vector235>:
.globl vector235
vector235:
  pushl $0
c0102bd2:	6a 00                	push   $0x0
  pushl $235
c0102bd4:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c0102bd9:	e9 f0 00 00 00       	jmp    c0102cce <__alltraps>

c0102bde <vector236>:
.globl vector236
vector236:
  pushl $0
c0102bde:	6a 00                	push   $0x0
  pushl $236
c0102be0:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c0102be5:	e9 e4 00 00 00       	jmp    c0102cce <__alltraps>

c0102bea <vector237>:
.globl vector237
vector237:
  pushl $0
c0102bea:	6a 00                	push   $0x0
  pushl $237
c0102bec:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c0102bf1:	e9 d8 00 00 00       	jmp    c0102cce <__alltraps>

c0102bf6 <vector238>:
.globl vector238
vector238:
  pushl $0
c0102bf6:	6a 00                	push   $0x0
  pushl $238
c0102bf8:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c0102bfd:	e9 cc 00 00 00       	jmp    c0102cce <__alltraps>

c0102c02 <vector239>:
.globl vector239
vector239:
  pushl $0
c0102c02:	6a 00                	push   $0x0
  pushl $239
c0102c04:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c0102c09:	e9 c0 00 00 00       	jmp    c0102cce <__alltraps>

c0102c0e <vector240>:
.globl vector240
vector240:
  pushl $0
c0102c0e:	6a 00                	push   $0x0
  pushl $240
c0102c10:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c0102c15:	e9 b4 00 00 00       	jmp    c0102cce <__alltraps>

c0102c1a <vector241>:
.globl vector241
vector241:
  pushl $0
c0102c1a:	6a 00                	push   $0x0
  pushl $241
c0102c1c:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0102c21:	e9 a8 00 00 00       	jmp    c0102cce <__alltraps>

c0102c26 <vector242>:
.globl vector242
vector242:
  pushl $0
c0102c26:	6a 00                	push   $0x0
  pushl $242
c0102c28:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c0102c2d:	e9 9c 00 00 00       	jmp    c0102cce <__alltraps>

c0102c32 <vector243>:
.globl vector243
vector243:
  pushl $0
c0102c32:	6a 00                	push   $0x0
  pushl $243
c0102c34:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c0102c39:	e9 90 00 00 00       	jmp    c0102cce <__alltraps>

c0102c3e <vector244>:
.globl vector244
vector244:
  pushl $0
c0102c3e:	6a 00                	push   $0x0
  pushl $244
c0102c40:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c0102c45:	e9 84 00 00 00       	jmp    c0102cce <__alltraps>

c0102c4a <vector245>:
.globl vector245
vector245:
  pushl $0
c0102c4a:	6a 00                	push   $0x0
  pushl $245
c0102c4c:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c0102c51:	e9 78 00 00 00       	jmp    c0102cce <__alltraps>

c0102c56 <vector246>:
.globl vector246
vector246:
  pushl $0
c0102c56:	6a 00                	push   $0x0
  pushl $246
c0102c58:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c0102c5d:	e9 6c 00 00 00       	jmp    c0102cce <__alltraps>

c0102c62 <vector247>:
.globl vector247
vector247:
  pushl $0
c0102c62:	6a 00                	push   $0x0
  pushl $247
c0102c64:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c0102c69:	e9 60 00 00 00       	jmp    c0102cce <__alltraps>

c0102c6e <vector248>:
.globl vector248
vector248:
  pushl $0
c0102c6e:	6a 00                	push   $0x0
  pushl $248
c0102c70:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c0102c75:	e9 54 00 00 00       	jmp    c0102cce <__alltraps>

c0102c7a <vector249>:
.globl vector249
vector249:
  pushl $0
c0102c7a:	6a 00                	push   $0x0
  pushl $249
c0102c7c:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c0102c81:	e9 48 00 00 00       	jmp    c0102cce <__alltraps>

c0102c86 <vector250>:
.globl vector250
vector250:
  pushl $0
c0102c86:	6a 00                	push   $0x0
  pushl $250
c0102c88:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c0102c8d:	e9 3c 00 00 00       	jmp    c0102cce <__alltraps>

c0102c92 <vector251>:
.globl vector251
vector251:
  pushl $0
c0102c92:	6a 00                	push   $0x0
  pushl $251
c0102c94:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c0102c99:	e9 30 00 00 00       	jmp    c0102cce <__alltraps>

c0102c9e <vector252>:
.globl vector252
vector252:
  pushl $0
c0102c9e:	6a 00                	push   $0x0
  pushl $252
c0102ca0:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c0102ca5:	e9 24 00 00 00       	jmp    c0102cce <__alltraps>

c0102caa <vector253>:
.globl vector253
vector253:
  pushl $0
c0102caa:	6a 00                	push   $0x0
  pushl $253
c0102cac:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c0102cb1:	e9 18 00 00 00       	jmp    c0102cce <__alltraps>

c0102cb6 <vector254>:
.globl vector254
vector254:
  pushl $0
c0102cb6:	6a 00                	push   $0x0
  pushl $254
c0102cb8:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c0102cbd:	e9 0c 00 00 00       	jmp    c0102cce <__alltraps>

c0102cc2 <vector255>:
.globl vector255
vector255:
  pushl $0
c0102cc2:	6a 00                	push   $0x0
  pushl $255
c0102cc4:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c0102cc9:	e9 00 00 00 00       	jmp    c0102cce <__alltraps>

c0102cce <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0102cce:	1e                   	push   %ds
    pushl %es
c0102ccf:	06                   	push   %es
    pushl %fs
c0102cd0:	0f a0                	push   %fs
    pushl %gs
c0102cd2:	0f a8                	push   %gs
    pushal
c0102cd4:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0102cd5:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0102cda:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0102cdc:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0102cde:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0102cdf:	e8 64 f5 ff ff       	call   c0102248 <trap>

    # pop the pushed stack pointer
    popl %esp
c0102ce4:	5c                   	pop    %esp

c0102ce5 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0102ce5:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0102ce6:	0f a9                	pop    %gs
    popl %fs
c0102ce8:	0f a1                	pop    %fs
    popl %es
c0102cea:	07                   	pop    %es
    popl %ds
c0102ceb:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0102cec:	83 c4 08             	add    $0x8,%esp
    iret
c0102cef:	cf                   	iret   

c0102cf0 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0102cf0:	55                   	push   %ebp
c0102cf1:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0102cf3:	a1 38 cf 11 c0       	mov    0xc011cf38,%eax
c0102cf8:	8b 55 08             	mov    0x8(%ebp),%edx
c0102cfb:	29 c2                	sub    %eax,%edx
c0102cfd:	89 d0                	mov    %edx,%eax
c0102cff:	c1 f8 02             	sar    $0x2,%eax
c0102d02:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0102d08:	5d                   	pop    %ebp
c0102d09:	c3                   	ret    

c0102d0a <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0102d0a:	55                   	push   %ebp
c0102d0b:	89 e5                	mov    %esp,%ebp
c0102d0d:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0102d10:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d13:	89 04 24             	mov    %eax,(%esp)
c0102d16:	e8 d5 ff ff ff       	call   c0102cf0 <page2ppn>
c0102d1b:	c1 e0 0c             	shl    $0xc,%eax
}
c0102d1e:	c9                   	leave  
c0102d1f:	c3                   	ret    

c0102d20 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0102d20:	55                   	push   %ebp
c0102d21:	89 e5                	mov    %esp,%ebp
c0102d23:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0102d26:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d29:	c1 e8 0c             	shr    $0xc,%eax
c0102d2c:	89 c2                	mov    %eax,%edx
c0102d2e:	a1 a0 ce 11 c0       	mov    0xc011cea0,%eax
c0102d33:	39 c2                	cmp    %eax,%edx
c0102d35:	72 1c                	jb     c0102d53 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0102d37:	c7 44 24 08 30 6b 10 	movl   $0xc0106b30,0x8(%esp)
c0102d3e:	c0 
c0102d3f:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0102d46:	00 
c0102d47:	c7 04 24 4f 6b 10 c0 	movl   $0xc0106b4f,(%esp)
c0102d4e:	e8 9f d6 ff ff       	call   c01003f2 <__panic>
    }
    return &pages[PPN(pa)];
c0102d53:	8b 0d 38 cf 11 c0    	mov    0xc011cf38,%ecx
c0102d59:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d5c:	c1 e8 0c             	shr    $0xc,%eax
c0102d5f:	89 c2                	mov    %eax,%edx
c0102d61:	89 d0                	mov    %edx,%eax
c0102d63:	c1 e0 02             	shl    $0x2,%eax
c0102d66:	01 d0                	add    %edx,%eax
c0102d68:	c1 e0 02             	shl    $0x2,%eax
c0102d6b:	01 c8                	add    %ecx,%eax
}
c0102d6d:	c9                   	leave  
c0102d6e:	c3                   	ret    

c0102d6f <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0102d6f:	55                   	push   %ebp
c0102d70:	89 e5                	mov    %esp,%ebp
c0102d72:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0102d75:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d78:	89 04 24             	mov    %eax,(%esp)
c0102d7b:	e8 8a ff ff ff       	call   c0102d0a <page2pa>
c0102d80:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102d83:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d86:	c1 e8 0c             	shr    $0xc,%eax
c0102d89:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102d8c:	a1 a0 ce 11 c0       	mov    0xc011cea0,%eax
c0102d91:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0102d94:	72 23                	jb     c0102db9 <page2kva+0x4a>
c0102d96:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d99:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0102d9d:	c7 44 24 08 60 6b 10 	movl   $0xc0106b60,0x8(%esp)
c0102da4:	c0 
c0102da5:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0102dac:	00 
c0102dad:	c7 04 24 4f 6b 10 c0 	movl   $0xc0106b4f,(%esp)
c0102db4:	e8 39 d6 ff ff       	call   c01003f2 <__panic>
c0102db9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102dbc:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0102dc1:	c9                   	leave  
c0102dc2:	c3                   	ret    

c0102dc3 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0102dc3:	55                   	push   %ebp
c0102dc4:	89 e5                	mov    %esp,%ebp
c0102dc6:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0102dc9:	8b 45 08             	mov    0x8(%ebp),%eax
c0102dcc:	83 e0 01             	and    $0x1,%eax
c0102dcf:	85 c0                	test   %eax,%eax
c0102dd1:	75 1c                	jne    c0102def <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0102dd3:	c7 44 24 08 84 6b 10 	movl   $0xc0106b84,0x8(%esp)
c0102dda:	c0 
c0102ddb:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0102de2:	00 
c0102de3:	c7 04 24 4f 6b 10 c0 	movl   $0xc0106b4f,(%esp)
c0102dea:	e8 03 d6 ff ff       	call   c01003f2 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0102def:	8b 45 08             	mov    0x8(%ebp),%eax
c0102df2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0102df7:	89 04 24             	mov    %eax,(%esp)
c0102dfa:	e8 21 ff ff ff       	call   c0102d20 <pa2page>
}
c0102dff:	c9                   	leave  
c0102e00:	c3                   	ret    

c0102e01 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c0102e01:	55                   	push   %ebp
c0102e02:	89 e5                	mov    %esp,%ebp
c0102e04:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c0102e07:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e0a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0102e0f:	89 04 24             	mov    %eax,(%esp)
c0102e12:	e8 09 ff ff ff       	call   c0102d20 <pa2page>
}
c0102e17:	c9                   	leave  
c0102e18:	c3                   	ret    

c0102e19 <page_ref>:

static inline int
page_ref(struct Page *page) {
c0102e19:	55                   	push   %ebp
c0102e1a:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0102e1c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e1f:	8b 00                	mov    (%eax),%eax
}
c0102e21:	5d                   	pop    %ebp
c0102e22:	c3                   	ret    

c0102e23 <page_ref_inc>:
set_page_ref(struct Page *page, int val) {
    page->ref = val;
}

static inline int
page_ref_inc(struct Page *page) {
c0102e23:	55                   	push   %ebp
c0102e24:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0102e26:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e29:	8b 00                	mov    (%eax),%eax
c0102e2b:	8d 50 01             	lea    0x1(%eax),%edx
c0102e2e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e31:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0102e33:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e36:	8b 00                	mov    (%eax),%eax
}
c0102e38:	5d                   	pop    %ebp
c0102e39:	c3                   	ret    

c0102e3a <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0102e3a:	55                   	push   %ebp
c0102e3b:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0102e3d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e40:	8b 00                	mov    (%eax),%eax
c0102e42:	8d 50 ff             	lea    -0x1(%eax),%edx
c0102e45:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e48:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0102e4a:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e4d:	8b 00                	mov    (%eax),%eax
}
c0102e4f:	5d                   	pop    %ebp
c0102e50:	c3                   	ret    

c0102e51 <__intr_save>:
__intr_save(void) {
c0102e51:	55                   	push   %ebp
c0102e52:	89 e5                	mov    %esp,%ebp
c0102e54:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0102e57:	9c                   	pushf  
c0102e58:	58                   	pop    %eax
c0102e59:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0102e5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0102e5f:	25 00 02 00 00       	and    $0x200,%eax
c0102e64:	85 c0                	test   %eax,%eax
c0102e66:	74 0c                	je     c0102e74 <__intr_save+0x23>
        intr_disable();
c0102e68:	e8 2a ea ff ff       	call   c0101897 <intr_disable>
        return 1;
c0102e6d:	b8 01 00 00 00       	mov    $0x1,%eax
c0102e72:	eb 05                	jmp    c0102e79 <__intr_save+0x28>
    return 0;
c0102e74:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0102e79:	c9                   	leave  
c0102e7a:	c3                   	ret    

c0102e7b <__intr_restore>:
__intr_restore(bool flag) {
c0102e7b:	55                   	push   %ebp
c0102e7c:	89 e5                	mov    %esp,%ebp
c0102e7e:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0102e81:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102e85:	74 05                	je     c0102e8c <__intr_restore+0x11>
        intr_enable();
c0102e87:	e8 04 ea ff ff       	call   c0101890 <intr_enable>
}
c0102e8c:	90                   	nop
c0102e8d:	c9                   	leave  
c0102e8e:	c3                   	ret    

c0102e8f <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0102e8f:	55                   	push   %ebp
c0102e90:	89 e5                	mov    %esp,%ebp
	asm volatile ("lgdt (%0)" :: "r" (pd));
c0102e92:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e95:	0f 01 10             	lgdtl  (%eax)
	asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0102e98:	b8 23 00 00 00       	mov    $0x23,%eax
c0102e9d:	8e e8                	mov    %eax,%gs
	asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0102e9f:	b8 23 00 00 00       	mov    $0x23,%eax
c0102ea4:	8e e0                	mov    %eax,%fs
	asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0102ea6:	b8 10 00 00 00       	mov    $0x10,%eax
c0102eab:	8e c0                	mov    %eax,%es
	asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0102ead:	b8 10 00 00 00       	mov    $0x10,%eax
c0102eb2:	8e d8                	mov    %eax,%ds
	asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0102eb4:	b8 10 00 00 00       	mov    $0x10,%eax
c0102eb9:	8e d0                	mov    %eax,%ss
	// reload cs
	asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0102ebb:	ea c2 2e 10 c0 08 00 	ljmp   $0x8,$0xc0102ec2
}
c0102ec2:	90                   	nop
c0102ec3:	5d                   	pop    %ebp
c0102ec4:	c3                   	ret    

c0102ec5 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0102ec5:	55                   	push   %ebp
c0102ec6:	89 e5                	mov    %esp,%ebp
	ts.ts_esp0 = esp0;
c0102ec8:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ecb:	a3 c4 ce 11 c0       	mov    %eax,0xc011cec4
}
c0102ed0:	90                   	nop
c0102ed1:	5d                   	pop    %ebp
c0102ed2:	c3                   	ret    

c0102ed3 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0102ed3:	55                   	push   %ebp
c0102ed4:	89 e5                	mov    %esp,%ebp
c0102ed6:	83 ec 14             	sub    $0x14,%esp
	// set boot kernel stack and default SS0
	load_esp0((uintptr_t)bootstacktop);
c0102ed9:	b8 00 90 11 c0       	mov    $0xc0119000,%eax
c0102ede:	89 04 24             	mov    %eax,(%esp)
c0102ee1:	e8 df ff ff ff       	call   c0102ec5 <load_esp0>
	ts.ts_ss0 = KERNEL_DS;
c0102ee6:	66 c7 05 c8 ce 11 c0 	movw   $0x10,0xc011cec8
c0102eed:	10 00 

	// initialize the TSS filed of the gdt
	gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0102eef:	66 c7 05 28 9a 11 c0 	movw   $0x68,0xc0119a28
c0102ef6:	68 00 
c0102ef8:	b8 c0 ce 11 c0       	mov    $0xc011cec0,%eax
c0102efd:	0f b7 c0             	movzwl %ax,%eax
c0102f00:	66 a3 2a 9a 11 c0    	mov    %ax,0xc0119a2a
c0102f06:	b8 c0 ce 11 c0       	mov    $0xc011cec0,%eax
c0102f0b:	c1 e8 10             	shr    $0x10,%eax
c0102f0e:	a2 2c 9a 11 c0       	mov    %al,0xc0119a2c
c0102f13:	0f b6 05 2d 9a 11 c0 	movzbl 0xc0119a2d,%eax
c0102f1a:	24 f0                	and    $0xf0,%al
c0102f1c:	0c 09                	or     $0x9,%al
c0102f1e:	a2 2d 9a 11 c0       	mov    %al,0xc0119a2d
c0102f23:	0f b6 05 2d 9a 11 c0 	movzbl 0xc0119a2d,%eax
c0102f2a:	24 ef                	and    $0xef,%al
c0102f2c:	a2 2d 9a 11 c0       	mov    %al,0xc0119a2d
c0102f31:	0f b6 05 2d 9a 11 c0 	movzbl 0xc0119a2d,%eax
c0102f38:	24 9f                	and    $0x9f,%al
c0102f3a:	a2 2d 9a 11 c0       	mov    %al,0xc0119a2d
c0102f3f:	0f b6 05 2d 9a 11 c0 	movzbl 0xc0119a2d,%eax
c0102f46:	0c 80                	or     $0x80,%al
c0102f48:	a2 2d 9a 11 c0       	mov    %al,0xc0119a2d
c0102f4d:	0f b6 05 2e 9a 11 c0 	movzbl 0xc0119a2e,%eax
c0102f54:	24 f0                	and    $0xf0,%al
c0102f56:	a2 2e 9a 11 c0       	mov    %al,0xc0119a2e
c0102f5b:	0f b6 05 2e 9a 11 c0 	movzbl 0xc0119a2e,%eax
c0102f62:	24 ef                	and    $0xef,%al
c0102f64:	a2 2e 9a 11 c0       	mov    %al,0xc0119a2e
c0102f69:	0f b6 05 2e 9a 11 c0 	movzbl 0xc0119a2e,%eax
c0102f70:	24 df                	and    $0xdf,%al
c0102f72:	a2 2e 9a 11 c0       	mov    %al,0xc0119a2e
c0102f77:	0f b6 05 2e 9a 11 c0 	movzbl 0xc0119a2e,%eax
c0102f7e:	0c 40                	or     $0x40,%al
c0102f80:	a2 2e 9a 11 c0       	mov    %al,0xc0119a2e
c0102f85:	0f b6 05 2e 9a 11 c0 	movzbl 0xc0119a2e,%eax
c0102f8c:	24 7f                	and    $0x7f,%al
c0102f8e:	a2 2e 9a 11 c0       	mov    %al,0xc0119a2e
c0102f93:	b8 c0 ce 11 c0       	mov    $0xc011cec0,%eax
c0102f98:	c1 e8 18             	shr    $0x18,%eax
c0102f9b:	a2 2f 9a 11 c0       	mov    %al,0xc0119a2f

	// reload all segment registers
	lgdt(&gdt_pd);
c0102fa0:	c7 04 24 30 9a 11 c0 	movl   $0xc0119a30,(%esp)
c0102fa7:	e8 e3 fe ff ff       	call   c0102e8f <lgdt>
c0102fac:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0102fb2:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0102fb6:	0f 00 d8             	ltr    %ax

	// load the TSS
	ltr(GD_TSS);
}
c0102fb9:	90                   	nop
c0102fba:	c9                   	leave  
c0102fbb:	c3                   	ret    

c0102fbc <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0102fbc:	55                   	push   %ebp
c0102fbd:	89 e5                	mov    %esp,%ebp
c0102fbf:	83 ec 18             	sub    $0x18,%esp
	pmm_manager = &default_pmm_manager;
c0102fc2:	c7 05 30 cf 11 c0 00 	movl   $0xc0107600,0xc011cf30
c0102fc9:	76 10 c0 
	cprintf("memory management: %s\n", pmm_manager->name);
c0102fcc:	a1 30 cf 11 c0       	mov    0xc011cf30,%eax
c0102fd1:	8b 00                	mov    (%eax),%eax
c0102fd3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102fd7:	c7 04 24 b0 6b 10 c0 	movl   $0xc0106bb0,(%esp)
c0102fde:	e8 b7 d2 ff ff       	call   c010029a <cprintf>
	pmm_manager->init();
c0102fe3:	a1 30 cf 11 c0       	mov    0xc011cf30,%eax
c0102fe8:	8b 40 04             	mov    0x4(%eax),%eax
c0102feb:	ff d0                	call   *%eax
}
c0102fed:	90                   	nop
c0102fee:	c9                   	leave  
c0102fef:	c3                   	ret    

c0102ff0 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0102ff0:	55                   	push   %ebp
c0102ff1:	89 e5                	mov    %esp,%ebp
c0102ff3:	83 ec 18             	sub    $0x18,%esp
	pmm_manager->init_memmap(base, n);
c0102ff6:	a1 30 cf 11 c0       	mov    0xc011cf30,%eax
c0102ffb:	8b 40 08             	mov    0x8(%eax),%eax
c0102ffe:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103001:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103005:	8b 55 08             	mov    0x8(%ebp),%edx
c0103008:	89 14 24             	mov    %edx,(%esp)
c010300b:	ff d0                	call   *%eax
}
c010300d:	90                   	nop
c010300e:	c9                   	leave  
c010300f:	c3                   	ret    

c0103010 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0103010:	55                   	push   %ebp
c0103011:	89 e5                	mov    %esp,%ebp
c0103013:	83 ec 28             	sub    $0x28,%esp
	struct Page *page=NULL;
c0103016:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	bool intr_flag;
	local_intr_save(intr_flag);
c010301d:	e8 2f fe ff ff       	call   c0102e51 <__intr_save>
c0103022:	89 45 f0             	mov    %eax,-0x10(%ebp)
	{
		page = pmm_manager->alloc_pages(n);
c0103025:	a1 30 cf 11 c0       	mov    0xc011cf30,%eax
c010302a:	8b 40 0c             	mov    0xc(%eax),%eax
c010302d:	8b 55 08             	mov    0x8(%ebp),%edx
c0103030:	89 14 24             	mov    %edx,(%esp)
c0103033:	ff d0                	call   *%eax
c0103035:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}
	local_intr_restore(intr_flag);
c0103038:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010303b:	89 04 24             	mov    %eax,(%esp)
c010303e:	e8 38 fe ff ff       	call   c0102e7b <__intr_restore>
	return page;
c0103043:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103046:	c9                   	leave  
c0103047:	c3                   	ret    

c0103048 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0103048:	55                   	push   %ebp
c0103049:	89 e5                	mov    %esp,%ebp
c010304b:	83 ec 28             	sub    $0x28,%esp
	bool intr_flag;
	local_intr_save(intr_flag);
c010304e:	e8 fe fd ff ff       	call   c0102e51 <__intr_save>
c0103053:	89 45 f4             	mov    %eax,-0xc(%ebp)
	{
		pmm_manager->free_pages(base, n);
c0103056:	a1 30 cf 11 c0       	mov    0xc011cf30,%eax
c010305b:	8b 40 10             	mov    0x10(%eax),%eax
c010305e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103061:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103065:	8b 55 08             	mov    0x8(%ebp),%edx
c0103068:	89 14 24             	mov    %edx,(%esp)
c010306b:	ff d0                	call   *%eax
	}
	local_intr_restore(intr_flag);
c010306d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103070:	89 04 24             	mov    %eax,(%esp)
c0103073:	e8 03 fe ff ff       	call   c0102e7b <__intr_restore>
}
c0103078:	90                   	nop
c0103079:	c9                   	leave  
c010307a:	c3                   	ret    

c010307b <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c010307b:	55                   	push   %ebp
c010307c:	89 e5                	mov    %esp,%ebp
c010307e:	83 ec 28             	sub    $0x28,%esp
	size_t ret;
	bool intr_flag;
	local_intr_save(intr_flag);
c0103081:	e8 cb fd ff ff       	call   c0102e51 <__intr_save>
c0103086:	89 45 f4             	mov    %eax,-0xc(%ebp)
	{
		ret = pmm_manager->nr_free_pages();
c0103089:	a1 30 cf 11 c0       	mov    0xc011cf30,%eax
c010308e:	8b 40 14             	mov    0x14(%eax),%eax
c0103091:	ff d0                	call   *%eax
c0103093:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}
	local_intr_restore(intr_flag);
c0103096:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103099:	89 04 24             	mov    %eax,(%esp)
c010309c:	e8 da fd ff ff       	call   c0102e7b <__intr_restore>
	return ret;
c01030a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01030a4:	c9                   	leave  
c01030a5:	c3                   	ret    

c01030a6 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c01030a6:	55                   	push   %ebp
c01030a7:	89 e5                	mov    %esp,%ebp
c01030a9:	57                   	push   %edi
c01030aa:	56                   	push   %esi
c01030ab:	53                   	push   %ebx
c01030ac:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c01030b2:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
	uint64_t maxpa = 0;
c01030b9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c01030c0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

	cprintf("e820map:\n");
c01030c7:	c7 04 24 c7 6b 10 c0 	movl   $0xc0106bc7,(%esp)
c01030ce:	e8 c7 d1 ff ff       	call   c010029a <cprintf>
	int i;
	for (i = 0; i < memmap->nr_map; i ++) {
c01030d3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01030da:	e9 1a 01 00 00       	jmp    c01031f9 <page_init+0x153>
		uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c01030df:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01030e2:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01030e5:	89 d0                	mov    %edx,%eax
c01030e7:	c1 e0 02             	shl    $0x2,%eax
c01030ea:	01 d0                	add    %edx,%eax
c01030ec:	c1 e0 02             	shl    $0x2,%eax
c01030ef:	01 c8                	add    %ecx,%eax
c01030f1:	8b 50 08             	mov    0x8(%eax),%edx
c01030f4:	8b 40 04             	mov    0x4(%eax),%eax
c01030f7:	89 45 b8             	mov    %eax,-0x48(%ebp)
c01030fa:	89 55 bc             	mov    %edx,-0x44(%ebp)
c01030fd:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103100:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103103:	89 d0                	mov    %edx,%eax
c0103105:	c1 e0 02             	shl    $0x2,%eax
c0103108:	01 d0                	add    %edx,%eax
c010310a:	c1 e0 02             	shl    $0x2,%eax
c010310d:	01 c8                	add    %ecx,%eax
c010310f:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103112:	8b 58 10             	mov    0x10(%eax),%ebx
c0103115:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103118:	8b 55 bc             	mov    -0x44(%ebp),%edx
c010311b:	01 c8                	add    %ecx,%eax
c010311d:	11 da                	adc    %ebx,%edx
c010311f:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0103122:	89 55 b4             	mov    %edx,-0x4c(%ebp)
		cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0103125:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103128:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010312b:	89 d0                	mov    %edx,%eax
c010312d:	c1 e0 02             	shl    $0x2,%eax
c0103130:	01 d0                	add    %edx,%eax
c0103132:	c1 e0 02             	shl    $0x2,%eax
c0103135:	01 c8                	add    %ecx,%eax
c0103137:	83 c0 14             	add    $0x14,%eax
c010313a:	8b 00                	mov    (%eax),%eax
c010313c:	89 45 84             	mov    %eax,-0x7c(%ebp)
c010313f:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103142:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103145:	83 c0 ff             	add    $0xffffffff,%eax
c0103148:	83 d2 ff             	adc    $0xffffffff,%edx
c010314b:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
c0103151:	89 95 7c ff ff ff    	mov    %edx,-0x84(%ebp)
c0103157:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010315a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010315d:	89 d0                	mov    %edx,%eax
c010315f:	c1 e0 02             	shl    $0x2,%eax
c0103162:	01 d0                	add    %edx,%eax
c0103164:	c1 e0 02             	shl    $0x2,%eax
c0103167:	01 c8                	add    %ecx,%eax
c0103169:	8b 48 0c             	mov    0xc(%eax),%ecx
c010316c:	8b 58 10             	mov    0x10(%eax),%ebx
c010316f:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0103172:	89 54 24 1c          	mov    %edx,0x1c(%esp)
c0103176:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
c010317c:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
c0103182:	89 44 24 14          	mov    %eax,0x14(%esp)
c0103186:	89 54 24 18          	mov    %edx,0x18(%esp)
c010318a:	8b 45 b8             	mov    -0x48(%ebp),%eax
c010318d:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103190:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103194:	89 54 24 10          	mov    %edx,0x10(%esp)
c0103198:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c010319c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c01031a0:	c7 04 24 d4 6b 10 c0 	movl   $0xc0106bd4,(%esp)
c01031a7:	e8 ee d0 ff ff       	call   c010029a <cprintf>
				memmap->map[i].size, begin, end - 1, memmap->map[i].type);
		if (memmap->map[i].type == E820_ARM) {
c01031ac:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01031af:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01031b2:	89 d0                	mov    %edx,%eax
c01031b4:	c1 e0 02             	shl    $0x2,%eax
c01031b7:	01 d0                	add    %edx,%eax
c01031b9:	c1 e0 02             	shl    $0x2,%eax
c01031bc:	01 c8                	add    %ecx,%eax
c01031be:	83 c0 14             	add    $0x14,%eax
c01031c1:	8b 00                	mov    (%eax),%eax
c01031c3:	83 f8 01             	cmp    $0x1,%eax
c01031c6:	75 2e                	jne    c01031f6 <page_init+0x150>
			if (maxpa < end && begin < KMEMSIZE) {
c01031c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01031cb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01031ce:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c01031d1:	89 d0                	mov    %edx,%eax
c01031d3:	1b 45 b4             	sbb    -0x4c(%ebp),%eax
c01031d6:	73 1e                	jae    c01031f6 <page_init+0x150>
c01031d8:	ba ff ff ff 37       	mov    $0x37ffffff,%edx
c01031dd:	b8 00 00 00 00       	mov    $0x0,%eax
c01031e2:	3b 55 b8             	cmp    -0x48(%ebp),%edx
c01031e5:	1b 45 bc             	sbb    -0x44(%ebp),%eax
c01031e8:	72 0c                	jb     c01031f6 <page_init+0x150>
				maxpa = end;
c01031ea:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01031ed:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01031f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01031f3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	for (i = 0; i < memmap->nr_map; i ++) {
c01031f6:	ff 45 dc             	incl   -0x24(%ebp)
c01031f9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01031fc:	8b 00                	mov    (%eax),%eax
c01031fe:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0103201:	0f 8c d8 fe ff ff    	jl     c01030df <page_init+0x39>
			}
		}
	}
	// 确保maxpa不大于ucore支持的最大物理内存地址
	if (maxpa > KMEMSIZE) {
c0103207:	ba 00 00 00 38       	mov    $0x38000000,%edx
c010320c:	b8 00 00 00 00       	mov    $0x0,%eax
c0103211:	3b 55 e0             	cmp    -0x20(%ebp),%edx
c0103214:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
c0103217:	73 0e                	jae    c0103227 <page_init+0x181>
		maxpa = KMEMSIZE;
c0103219:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0103220:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	}

	extern char end[];

	npage = maxpa / PGSIZE;
c0103227:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010322a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010322d:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0103231:	c1 ea 0c             	shr    $0xc,%edx
c0103234:	89 c1                	mov    %eax,%ecx
c0103236:	89 d3                	mov    %edx,%ebx
c0103238:	89 c8                	mov    %ecx,%eax
c010323a:	a3 a0 ce 11 c0       	mov    %eax,0xc011cea0
	// 将struct Page数组放置到.bss段之上
	pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c010323f:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0103246:	b8 48 cf 11 c0       	mov    $0xc011cf48,%eax
c010324b:	8d 50 ff             	lea    -0x1(%eax),%edx
c010324e:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103251:	01 d0                	add    %edx,%eax
c0103253:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0103256:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103259:	ba 00 00 00 00       	mov    $0x0,%edx
c010325e:	f7 75 ac             	divl   -0x54(%ebp)
c0103261:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103264:	29 d0                	sub    %edx,%eax
c0103266:	a3 38 cf 11 c0       	mov    %eax,0xc011cf38

	for (i = 0; i < npage; i ++) {
c010326b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103272:	eb 2e                	jmp    c01032a2 <page_init+0x1fc>
		SetPageReserved(pages + i);
c0103274:	8b 0d 38 cf 11 c0    	mov    0xc011cf38,%ecx
c010327a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010327d:	89 d0                	mov    %edx,%eax
c010327f:	c1 e0 02             	shl    $0x2,%eax
c0103282:	01 d0                	add    %edx,%eax
c0103284:	c1 e0 02             	shl    $0x2,%eax
c0103287:	01 c8                	add    %ecx,%eax
c0103289:	83 c0 04             	add    $0x4,%eax
c010328c:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c0103293:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103296:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0103299:	8b 55 90             	mov    -0x70(%ebp),%edx
c010329c:	0f ab 10             	bts    %edx,(%eax)
	for (i = 0; i < npage; i ++) {
c010329f:	ff 45 dc             	incl   -0x24(%ebp)
c01032a2:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01032a5:	a1 a0 ce 11 c0       	mov    0xc011cea0,%eax
c01032aa:	39 c2                	cmp    %eax,%edx
c01032ac:	72 c6                	jb     c0103274 <page_init+0x1ce>
	}

	// struct Page数组之上是可用的物理内存
	uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c01032ae:	8b 15 a0 ce 11 c0    	mov    0xc011cea0,%edx
c01032b4:	89 d0                	mov    %edx,%eax
c01032b6:	c1 e0 02             	shl    $0x2,%eax
c01032b9:	01 d0                	add    %edx,%eax
c01032bb:	c1 e0 02             	shl    $0x2,%eax
c01032be:	89 c2                	mov    %eax,%edx
c01032c0:	a1 38 cf 11 c0       	mov    0xc011cf38,%eax
c01032c5:	01 d0                	add    %edx,%eax
c01032c7:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c01032ca:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c01032d1:	77 23                	ja     c01032f6 <page_init+0x250>
c01032d3:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c01032d6:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01032da:	c7 44 24 08 04 6c 10 	movl   $0xc0106c04,0x8(%esp)
c01032e1:	c0 
c01032e2:	c7 44 24 04 df 00 00 	movl   $0xdf,0x4(%esp)
c01032e9:	00 
c01032ea:	c7 04 24 28 6c 10 c0 	movl   $0xc0106c28,(%esp)
c01032f1:	e8 fc d0 ff ff       	call   c01003f2 <__panic>
c01032f6:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c01032f9:	05 00 00 00 40       	add    $0x40000000,%eax
c01032fe:	89 45 a0             	mov    %eax,-0x60(%ebp)

	for (i = 0; i < memmap->nr_map; i ++) {
c0103301:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103308:	e9 53 01 00 00       	jmp    c0103460 <page_init+0x3ba>
		uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c010330d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103310:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103313:	89 d0                	mov    %edx,%eax
c0103315:	c1 e0 02             	shl    $0x2,%eax
c0103318:	01 d0                	add    %edx,%eax
c010331a:	c1 e0 02             	shl    $0x2,%eax
c010331d:	01 c8                	add    %ecx,%eax
c010331f:	8b 50 08             	mov    0x8(%eax),%edx
c0103322:	8b 40 04             	mov    0x4(%eax),%eax
c0103325:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103328:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010332b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010332e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103331:	89 d0                	mov    %edx,%eax
c0103333:	c1 e0 02             	shl    $0x2,%eax
c0103336:	01 d0                	add    %edx,%eax
c0103338:	c1 e0 02             	shl    $0x2,%eax
c010333b:	01 c8                	add    %ecx,%eax
c010333d:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103340:	8b 58 10             	mov    0x10(%eax),%ebx
c0103343:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103346:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103349:	01 c8                	add    %ecx,%eax
c010334b:	11 da                	adc    %ebx,%edx
c010334d:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0103350:	89 55 cc             	mov    %edx,-0x34(%ebp)
		if (memmap->map[i].type == E820_ARM) {
c0103353:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103356:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103359:	89 d0                	mov    %edx,%eax
c010335b:	c1 e0 02             	shl    $0x2,%eax
c010335e:	01 d0                	add    %edx,%eax
c0103360:	c1 e0 02             	shl    $0x2,%eax
c0103363:	01 c8                	add    %ecx,%eax
c0103365:	83 c0 14             	add    $0x14,%eax
c0103368:	8b 00                	mov    (%eax),%eax
c010336a:	83 f8 01             	cmp    $0x1,%eax
c010336d:	0f 85 ea 00 00 00    	jne    c010345d <page_init+0x3b7>
			if (begin < freemem) {
c0103373:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0103376:	ba 00 00 00 00       	mov    $0x0,%edx
c010337b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c010337e:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c0103381:	19 d1                	sbb    %edx,%ecx
c0103383:	73 0d                	jae    c0103392 <page_init+0x2ec>
				begin = freemem;
c0103385:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0103388:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010338b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
			}
			if (end > KMEMSIZE) {
c0103392:	ba 00 00 00 38       	mov    $0x38000000,%edx
c0103397:	b8 00 00 00 00       	mov    $0x0,%eax
c010339c:	3b 55 c8             	cmp    -0x38(%ebp),%edx
c010339f:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c01033a2:	73 0e                	jae    c01033b2 <page_init+0x30c>
				end = KMEMSIZE;
c01033a4:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c01033ab:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
			}
			if (begin < end) {
c01033b2:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01033b5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01033b8:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01033bb:	89 d0                	mov    %edx,%eax
c01033bd:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c01033c0:	0f 83 97 00 00 00    	jae    c010345d <page_init+0x3b7>
				// 为了避免超出可用的物理内存范围,begin只能向上舍入、end只能向下舍入
				begin = ROUNDUP(begin, PGSIZE);
c01033c6:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c01033cd:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01033d0:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01033d3:	01 d0                	add    %edx,%eax
c01033d5:	48                   	dec    %eax
c01033d6:	89 45 98             	mov    %eax,-0x68(%ebp)
c01033d9:	8b 45 98             	mov    -0x68(%ebp),%eax
c01033dc:	ba 00 00 00 00       	mov    $0x0,%edx
c01033e1:	f7 75 9c             	divl   -0x64(%ebp)
c01033e4:	8b 45 98             	mov    -0x68(%ebp),%eax
c01033e7:	29 d0                	sub    %edx,%eax
c01033e9:	ba 00 00 00 00       	mov    $0x0,%edx
c01033ee:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01033f1:	89 55 d4             	mov    %edx,-0x2c(%ebp)
				end = ROUNDDOWN(end, PGSIZE);
c01033f4:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01033f7:	89 45 94             	mov    %eax,-0x6c(%ebp)
c01033fa:	8b 45 94             	mov    -0x6c(%ebp),%eax
c01033fd:	ba 00 00 00 00       	mov    $0x0,%edx
c0103402:	89 c3                	mov    %eax,%ebx
c0103404:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
c010340a:	89 de                	mov    %ebx,%esi
c010340c:	89 d0                	mov    %edx,%eax
c010340e:	83 e0 00             	and    $0x0,%eax
c0103411:	89 c7                	mov    %eax,%edi
c0103413:	89 75 c8             	mov    %esi,-0x38(%ebp)
c0103416:	89 7d cc             	mov    %edi,-0x34(%ebp)
				if (begin < end) {
c0103419:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010341c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010341f:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0103422:	89 d0                	mov    %edx,%eax
c0103424:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c0103427:	73 34                	jae    c010345d <page_init+0x3b7>
					init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0103429:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010342c:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010342f:	2b 45 d0             	sub    -0x30(%ebp),%eax
c0103432:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
c0103435:	89 c1                	mov    %eax,%ecx
c0103437:	89 d3                	mov    %edx,%ebx
c0103439:	89 c8                	mov    %ecx,%eax
c010343b:	89 da                	mov    %ebx,%edx
c010343d:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0103441:	c1 ea 0c             	shr    $0xc,%edx
c0103444:	89 c3                	mov    %eax,%ebx
c0103446:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103449:	89 04 24             	mov    %eax,(%esp)
c010344c:	e8 cf f8 ff ff       	call   c0102d20 <pa2page>
c0103451:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0103455:	89 04 24             	mov    %eax,(%esp)
c0103458:	e8 93 fb ff ff       	call   c0102ff0 <init_memmap>
	for (i = 0; i < memmap->nr_map; i ++) {
c010345d:	ff 45 dc             	incl   -0x24(%ebp)
c0103460:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103463:	8b 00                	mov    (%eax),%eax
c0103465:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0103468:	0f 8c 9f fe ff ff    	jl     c010330d <page_init+0x267>
				}
			}
		}
	}
}
c010346e:	90                   	nop
c010346f:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c0103475:	5b                   	pop    %ebx
c0103476:	5e                   	pop    %esi
c0103477:	5f                   	pop    %edi
c0103478:	5d                   	pop    %ebp
c0103479:	c3                   	ret    

c010347a <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c010347a:	55                   	push   %ebp
c010347b:	89 e5                	mov    %esp,%ebp
c010347d:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0103480:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103483:	33 45 14             	xor    0x14(%ebp),%eax
c0103486:	25 ff 0f 00 00       	and    $0xfff,%eax
c010348b:	85 c0                	test   %eax,%eax
c010348d:	74 24                	je     c01034b3 <boot_map_segment+0x39>
c010348f:	c7 44 24 0c 36 6c 10 	movl   $0xc0106c36,0xc(%esp)
c0103496:	c0 
c0103497:	c7 44 24 08 4d 6c 10 	movl   $0xc0106c4d,0x8(%esp)
c010349e:	c0 
c010349f:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
c01034a6:	00 
c01034a7:	c7 04 24 28 6c 10 c0 	movl   $0xc0106c28,(%esp)
c01034ae:	e8 3f cf ff ff       	call   c01003f2 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c01034b3:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c01034ba:	8b 45 0c             	mov    0xc(%ebp),%eax
c01034bd:	25 ff 0f 00 00       	and    $0xfff,%eax
c01034c2:	89 c2                	mov    %eax,%edx
c01034c4:	8b 45 10             	mov    0x10(%ebp),%eax
c01034c7:	01 c2                	add    %eax,%edx
c01034c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01034cc:	01 d0                	add    %edx,%eax
c01034ce:	48                   	dec    %eax
c01034cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01034d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01034d5:	ba 00 00 00 00       	mov    $0x0,%edx
c01034da:	f7 75 f0             	divl   -0x10(%ebp)
c01034dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01034e0:	29 d0                	sub    %edx,%eax
c01034e2:	c1 e8 0c             	shr    $0xc,%eax
c01034e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c01034e8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01034eb:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01034ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01034f1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01034f6:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c01034f9:	8b 45 14             	mov    0x14(%ebp),%eax
c01034fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01034ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103502:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103507:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c010350a:	eb 68                	jmp    c0103574 <boot_map_segment+0xfa>
        pte_t *ptep = get_pte(pgdir, la, 1);
c010350c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0103513:	00 
c0103514:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103517:	89 44 24 04          	mov    %eax,0x4(%esp)
c010351b:	8b 45 08             	mov    0x8(%ebp),%eax
c010351e:	89 04 24             	mov    %eax,(%esp)
c0103521:	e8 81 01 00 00       	call   c01036a7 <get_pte>
c0103526:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0103529:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c010352d:	75 24                	jne    c0103553 <boot_map_segment+0xd9>
c010352f:	c7 44 24 0c 62 6c 10 	movl   $0xc0106c62,0xc(%esp)
c0103536:	c0 
c0103537:	c7 44 24 08 4d 6c 10 	movl   $0xc0106c4d,0x8(%esp)
c010353e:	c0 
c010353f:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c0103546:	00 
c0103547:	c7 04 24 28 6c 10 c0 	movl   $0xc0106c28,(%esp)
c010354e:	e8 9f ce ff ff       	call   c01003f2 <__panic>
        *ptep = pa | PTE_P | perm;
c0103553:	8b 45 14             	mov    0x14(%ebp),%eax
c0103556:	0b 45 18             	or     0x18(%ebp),%eax
c0103559:	83 c8 01             	or     $0x1,%eax
c010355c:	89 c2                	mov    %eax,%edx
c010355e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103561:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0103563:	ff 4d f4             	decl   -0xc(%ebp)
c0103566:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c010356d:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0103574:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103578:	75 92                	jne    c010350c <boot_map_segment+0x92>
    }
}
c010357a:	90                   	nop
c010357b:	c9                   	leave  
c010357c:	c3                   	ret    

c010357d <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c010357d:	55                   	push   %ebp
c010357e:	89 e5                	mov    %esp,%ebp
c0103580:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c0103583:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010358a:	e8 81 fa ff ff       	call   c0103010 <alloc_pages>
c010358f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0103592:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103596:	75 1c                	jne    c01035b4 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c0103598:	c7 44 24 08 6f 6c 10 	movl   $0xc0106c6f,0x8(%esp)
c010359f:	c0 
c01035a0:	c7 44 24 04 10 01 00 	movl   $0x110,0x4(%esp)
c01035a7:	00 
c01035a8:	c7 04 24 28 6c 10 c0 	movl   $0xc0106c28,(%esp)
c01035af:	e8 3e ce ff ff       	call   c01003f2 <__panic>
    }
    return page2kva(p);
c01035b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035b7:	89 04 24             	mov    %eax,(%esp)
c01035ba:	e8 b0 f7 ff ff       	call   c0102d6f <page2kva>
}
c01035bf:	c9                   	leave  
c01035c0:	c3                   	ret    

c01035c1 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c01035c1:	55                   	push   %ebp
c01035c2:	89 e5                	mov    %esp,%ebp
c01035c4:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
c01035c7:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c01035cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01035cf:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01035d6:	77 23                	ja     c01035fb <pmm_init+0x3a>
c01035d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035db:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01035df:	c7 44 24 08 04 6c 10 	movl   $0xc0106c04,0x8(%esp)
c01035e6:	c0 
c01035e7:	c7 44 24 04 1a 01 00 	movl   $0x11a,0x4(%esp)
c01035ee:	00 
c01035ef:	c7 04 24 28 6c 10 c0 	movl   $0xc0106c28,(%esp)
c01035f6:	e8 f7 cd ff ff       	call   c01003f2 <__panic>
c01035fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035fe:	05 00 00 00 40       	add    $0x40000000,%eax
c0103603:	a3 34 cf 11 c0       	mov    %eax,0xc011cf34
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0103608:	e8 af f9 ff ff       	call   c0102fbc <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c010360d:	e8 94 fa ff ff       	call   c01030a6 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c0103612:	e8 4f 02 00 00       	call   c0103866 <check_alloc_page>

    check_pgdir();
c0103617:	e8 69 02 00 00       	call   c0103885 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c010361c:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103621:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103624:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c010362b:	77 23                	ja     c0103650 <pmm_init+0x8f>
c010362d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103630:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103634:	c7 44 24 08 04 6c 10 	movl   $0xc0106c04,0x8(%esp)
c010363b:	c0 
c010363c:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
c0103643:	00 
c0103644:	c7 04 24 28 6c 10 c0 	movl   $0xc0106c28,(%esp)
c010364b:	e8 a2 cd ff ff       	call   c01003f2 <__panic>
c0103650:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103653:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
c0103659:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c010365e:	05 ac 0f 00 00       	add    $0xfac,%eax
c0103663:	83 ca 03             	or     $0x3,%edx
c0103666:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c0103668:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c010366d:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c0103674:	00 
c0103675:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010367c:	00 
c010367d:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c0103684:	38 
c0103685:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c010368c:	c0 
c010368d:	89 04 24             	mov    %eax,(%esp)
c0103690:	e8 e5 fd ff ff       	call   c010347a <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c0103695:	e8 39 f8 ff ff       	call   c0102ed3 <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c010369a:	e8 82 08 00 00       	call   c0103f21 <check_boot_pgdir>

    print_pgdir();
c010369f:	e8 fb 0c 00 00       	call   c010439f <print_pgdir>

}
c01036a4:	90                   	nop
c01036a5:	c9                   	leave  
c01036a6:	c3                   	ret    

c01036a7 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c01036a7:	55                   	push   %ebp
c01036a8:	89 e5                	mov    %esp,%ebp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
}
c01036aa:	90                   	nop
c01036ab:	5d                   	pop    %ebp
c01036ac:	c3                   	ret    

c01036ad <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c01036ad:	55                   	push   %ebp
c01036ae:	89 e5                	mov    %esp,%ebp
c01036b0:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01036b3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01036ba:	00 
c01036bb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01036be:	89 44 24 04          	mov    %eax,0x4(%esp)
c01036c2:	8b 45 08             	mov    0x8(%ebp),%eax
c01036c5:	89 04 24             	mov    %eax,(%esp)
c01036c8:	e8 da ff ff ff       	call   c01036a7 <get_pte>
c01036cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c01036d0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01036d4:	74 08                	je     c01036de <get_page+0x31>
        *ptep_store = ptep;
c01036d6:	8b 45 10             	mov    0x10(%ebp),%eax
c01036d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01036dc:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c01036de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01036e2:	74 1b                	je     c01036ff <get_page+0x52>
c01036e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036e7:	8b 00                	mov    (%eax),%eax
c01036e9:	83 e0 01             	and    $0x1,%eax
c01036ec:	85 c0                	test   %eax,%eax
c01036ee:	74 0f                	je     c01036ff <get_page+0x52>
        return pte2page(*ptep);
c01036f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036f3:	8b 00                	mov    (%eax),%eax
c01036f5:	89 04 24             	mov    %eax,(%esp)
c01036f8:	e8 c6 f6 ff ff       	call   c0102dc3 <pte2page>
c01036fd:	eb 05                	jmp    c0103704 <get_page+0x57>
    }
    return NULL;
c01036ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103704:	c9                   	leave  
c0103705:	c3                   	ret    

c0103706 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c0103706:	55                   	push   %ebp
c0103707:	89 e5                	mov    %esp,%ebp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
}
c0103709:	90                   	nop
c010370a:	5d                   	pop    %ebp
c010370b:	c3                   	ret    

c010370c <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c010370c:	55                   	push   %ebp
c010370d:	89 e5                	mov    %esp,%ebp
c010370f:	83 ec 1c             	sub    $0x1c,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0103712:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103719:	00 
c010371a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010371d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103721:	8b 45 08             	mov    0x8(%ebp),%eax
c0103724:	89 04 24             	mov    %eax,(%esp)
c0103727:	e8 7b ff ff ff       	call   c01036a7 <get_pte>
c010372c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (ptep != NULL) {
c010372f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0103733:	74 19                	je     c010374e <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c0103735:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103738:	89 44 24 08          	mov    %eax,0x8(%esp)
c010373c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010373f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103743:	8b 45 08             	mov    0x8(%ebp),%eax
c0103746:	89 04 24             	mov    %eax,(%esp)
c0103749:	e8 b8 ff ff ff       	call   c0103706 <page_remove_pte>
    }
}
c010374e:	90                   	nop
c010374f:	c9                   	leave  
c0103750:	c3                   	ret    

c0103751 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c0103751:	55                   	push   %ebp
c0103752:	89 e5                	mov    %esp,%ebp
c0103754:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0103757:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c010375e:	00 
c010375f:	8b 45 10             	mov    0x10(%ebp),%eax
c0103762:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103766:	8b 45 08             	mov    0x8(%ebp),%eax
c0103769:	89 04 24             	mov    %eax,(%esp)
c010376c:	e8 36 ff ff ff       	call   c01036a7 <get_pte>
c0103771:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c0103774:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103778:	75 0a                	jne    c0103784 <page_insert+0x33>
        return -E_NO_MEM;
c010377a:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c010377f:	e9 84 00 00 00       	jmp    c0103808 <page_insert+0xb7>
    }
    page_ref_inc(page);
c0103784:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103787:	89 04 24             	mov    %eax,(%esp)
c010378a:	e8 94 f6 ff ff       	call   c0102e23 <page_ref_inc>
    if (*ptep & PTE_P) {
c010378f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103792:	8b 00                	mov    (%eax),%eax
c0103794:	83 e0 01             	and    $0x1,%eax
c0103797:	85 c0                	test   %eax,%eax
c0103799:	74 3e                	je     c01037d9 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c010379b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010379e:	8b 00                	mov    (%eax),%eax
c01037a0:	89 04 24             	mov    %eax,(%esp)
c01037a3:	e8 1b f6 ff ff       	call   c0102dc3 <pte2page>
c01037a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c01037ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01037ae:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01037b1:	75 0d                	jne    c01037c0 <page_insert+0x6f>
            page_ref_dec(page);
c01037b3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01037b6:	89 04 24             	mov    %eax,(%esp)
c01037b9:	e8 7c f6 ff ff       	call   c0102e3a <page_ref_dec>
c01037be:	eb 19                	jmp    c01037d9 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c01037c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01037c3:	89 44 24 08          	mov    %eax,0x8(%esp)
c01037c7:	8b 45 10             	mov    0x10(%ebp),%eax
c01037ca:	89 44 24 04          	mov    %eax,0x4(%esp)
c01037ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01037d1:	89 04 24             	mov    %eax,(%esp)
c01037d4:	e8 2d ff ff ff       	call   c0103706 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c01037d9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01037dc:	89 04 24             	mov    %eax,(%esp)
c01037df:	e8 26 f5 ff ff       	call   c0102d0a <page2pa>
c01037e4:	0b 45 14             	or     0x14(%ebp),%eax
c01037e7:	83 c8 01             	or     $0x1,%eax
c01037ea:	89 c2                	mov    %eax,%edx
c01037ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01037ef:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c01037f1:	8b 45 10             	mov    0x10(%ebp),%eax
c01037f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01037f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01037fb:	89 04 24             	mov    %eax,(%esp)
c01037fe:	e8 07 00 00 00       	call   c010380a <tlb_invalidate>
    return 0;
c0103803:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103808:	c9                   	leave  
c0103809:	c3                   	ret    

c010380a <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c010380a:	55                   	push   %ebp
c010380b:	89 e5                	mov    %esp,%ebp
c010380d:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c0103810:	0f 20 d8             	mov    %cr3,%eax
c0103813:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c0103816:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
c0103819:	8b 45 08             	mov    0x8(%ebp),%eax
c010381c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010381f:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0103826:	77 23                	ja     c010384b <tlb_invalidate+0x41>
c0103828:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010382b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010382f:	c7 44 24 08 04 6c 10 	movl   $0xc0106c04,0x8(%esp)
c0103836:	c0 
c0103837:	c7 44 24 04 c7 01 00 	movl   $0x1c7,0x4(%esp)
c010383e:	00 
c010383f:	c7 04 24 28 6c 10 c0 	movl   $0xc0106c28,(%esp)
c0103846:	e8 a7 cb ff ff       	call   c01003f2 <__panic>
c010384b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010384e:	05 00 00 00 40       	add    $0x40000000,%eax
c0103853:	39 d0                	cmp    %edx,%eax
c0103855:	75 0c                	jne    c0103863 <tlb_invalidate+0x59>
        invlpg((void *)la);
c0103857:	8b 45 0c             	mov    0xc(%ebp),%eax
c010385a:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c010385d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103860:	0f 01 38             	invlpg (%eax)
    }
}
c0103863:	90                   	nop
c0103864:	c9                   	leave  
c0103865:	c3                   	ret    

c0103866 <check_alloc_page>:

static void
check_alloc_page(void) {
c0103866:	55                   	push   %ebp
c0103867:	89 e5                	mov    %esp,%ebp
c0103869:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c010386c:	a1 30 cf 11 c0       	mov    0xc011cf30,%eax
c0103871:	8b 40 18             	mov    0x18(%eax),%eax
c0103874:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c0103876:	c7 04 24 88 6c 10 c0 	movl   $0xc0106c88,(%esp)
c010387d:	e8 18 ca ff ff       	call   c010029a <cprintf>
}
c0103882:	90                   	nop
c0103883:	c9                   	leave  
c0103884:	c3                   	ret    

c0103885 <check_pgdir>:

static void
check_pgdir(void) {
c0103885:	55                   	push   %ebp
c0103886:	89 e5                	mov    %esp,%ebp
c0103888:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c010388b:	a1 a0 ce 11 c0       	mov    0xc011cea0,%eax
c0103890:	3d 00 80 03 00       	cmp    $0x38000,%eax
c0103895:	76 24                	jbe    c01038bb <check_pgdir+0x36>
c0103897:	c7 44 24 0c a7 6c 10 	movl   $0xc0106ca7,0xc(%esp)
c010389e:	c0 
c010389f:	c7 44 24 08 4d 6c 10 	movl   $0xc0106c4d,0x8(%esp)
c01038a6:	c0 
c01038a7:	c7 44 24 04 d4 01 00 	movl   $0x1d4,0x4(%esp)
c01038ae:	00 
c01038af:	c7 04 24 28 6c 10 c0 	movl   $0xc0106c28,(%esp)
c01038b6:	e8 37 cb ff ff       	call   c01003f2 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c01038bb:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c01038c0:	85 c0                	test   %eax,%eax
c01038c2:	74 0e                	je     c01038d2 <check_pgdir+0x4d>
c01038c4:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c01038c9:	25 ff 0f 00 00       	and    $0xfff,%eax
c01038ce:	85 c0                	test   %eax,%eax
c01038d0:	74 24                	je     c01038f6 <check_pgdir+0x71>
c01038d2:	c7 44 24 0c c4 6c 10 	movl   $0xc0106cc4,0xc(%esp)
c01038d9:	c0 
c01038da:	c7 44 24 08 4d 6c 10 	movl   $0xc0106c4d,0x8(%esp)
c01038e1:	c0 
c01038e2:	c7 44 24 04 d5 01 00 	movl   $0x1d5,0x4(%esp)
c01038e9:	00 
c01038ea:	c7 04 24 28 6c 10 c0 	movl   $0xc0106c28,(%esp)
c01038f1:	e8 fc ca ff ff       	call   c01003f2 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c01038f6:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c01038fb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103902:	00 
c0103903:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010390a:	00 
c010390b:	89 04 24             	mov    %eax,(%esp)
c010390e:	e8 9a fd ff ff       	call   c01036ad <get_page>
c0103913:	85 c0                	test   %eax,%eax
c0103915:	74 24                	je     c010393b <check_pgdir+0xb6>
c0103917:	c7 44 24 0c fc 6c 10 	movl   $0xc0106cfc,0xc(%esp)
c010391e:	c0 
c010391f:	c7 44 24 08 4d 6c 10 	movl   $0xc0106c4d,0x8(%esp)
c0103926:	c0 
c0103927:	c7 44 24 04 d6 01 00 	movl   $0x1d6,0x4(%esp)
c010392e:	00 
c010392f:	c7 04 24 28 6c 10 c0 	movl   $0xc0106c28,(%esp)
c0103936:	e8 b7 ca ff ff       	call   c01003f2 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c010393b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103942:	e8 c9 f6 ff ff       	call   c0103010 <alloc_pages>
c0103947:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c010394a:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c010394f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0103956:	00 
c0103957:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010395e:	00 
c010395f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103962:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103966:	89 04 24             	mov    %eax,(%esp)
c0103969:	e8 e3 fd ff ff       	call   c0103751 <page_insert>
c010396e:	85 c0                	test   %eax,%eax
c0103970:	74 24                	je     c0103996 <check_pgdir+0x111>
c0103972:	c7 44 24 0c 24 6d 10 	movl   $0xc0106d24,0xc(%esp)
c0103979:	c0 
c010397a:	c7 44 24 08 4d 6c 10 	movl   $0xc0106c4d,0x8(%esp)
c0103981:	c0 
c0103982:	c7 44 24 04 da 01 00 	movl   $0x1da,0x4(%esp)
c0103989:	00 
c010398a:	c7 04 24 28 6c 10 c0 	movl   $0xc0106c28,(%esp)
c0103991:	e8 5c ca ff ff       	call   c01003f2 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0103996:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c010399b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01039a2:	00 
c01039a3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01039aa:	00 
c01039ab:	89 04 24             	mov    %eax,(%esp)
c01039ae:	e8 f4 fc ff ff       	call   c01036a7 <get_pte>
c01039b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01039b6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01039ba:	75 24                	jne    c01039e0 <check_pgdir+0x15b>
c01039bc:	c7 44 24 0c 50 6d 10 	movl   $0xc0106d50,0xc(%esp)
c01039c3:	c0 
c01039c4:	c7 44 24 08 4d 6c 10 	movl   $0xc0106c4d,0x8(%esp)
c01039cb:	c0 
c01039cc:	c7 44 24 04 dd 01 00 	movl   $0x1dd,0x4(%esp)
c01039d3:	00 
c01039d4:	c7 04 24 28 6c 10 c0 	movl   $0xc0106c28,(%esp)
c01039db:	e8 12 ca ff ff       	call   c01003f2 <__panic>
    assert(pte2page(*ptep) == p1);
c01039e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01039e3:	8b 00                	mov    (%eax),%eax
c01039e5:	89 04 24             	mov    %eax,(%esp)
c01039e8:	e8 d6 f3 ff ff       	call   c0102dc3 <pte2page>
c01039ed:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c01039f0:	74 24                	je     c0103a16 <check_pgdir+0x191>
c01039f2:	c7 44 24 0c 7d 6d 10 	movl   $0xc0106d7d,0xc(%esp)
c01039f9:	c0 
c01039fa:	c7 44 24 08 4d 6c 10 	movl   $0xc0106c4d,0x8(%esp)
c0103a01:	c0 
c0103a02:	c7 44 24 04 de 01 00 	movl   $0x1de,0x4(%esp)
c0103a09:	00 
c0103a0a:	c7 04 24 28 6c 10 c0 	movl   $0xc0106c28,(%esp)
c0103a11:	e8 dc c9 ff ff       	call   c01003f2 <__panic>
    assert(page_ref(p1) == 1);
c0103a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a19:	89 04 24             	mov    %eax,(%esp)
c0103a1c:	e8 f8 f3 ff ff       	call   c0102e19 <page_ref>
c0103a21:	83 f8 01             	cmp    $0x1,%eax
c0103a24:	74 24                	je     c0103a4a <check_pgdir+0x1c5>
c0103a26:	c7 44 24 0c 93 6d 10 	movl   $0xc0106d93,0xc(%esp)
c0103a2d:	c0 
c0103a2e:	c7 44 24 08 4d 6c 10 	movl   $0xc0106c4d,0x8(%esp)
c0103a35:	c0 
c0103a36:	c7 44 24 04 df 01 00 	movl   $0x1df,0x4(%esp)
c0103a3d:	00 
c0103a3e:	c7 04 24 28 6c 10 c0 	movl   $0xc0106c28,(%esp)
c0103a45:	e8 a8 c9 ff ff       	call   c01003f2 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0103a4a:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103a4f:	8b 00                	mov    (%eax),%eax
c0103a51:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103a56:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103a59:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103a5c:	c1 e8 0c             	shr    $0xc,%eax
c0103a5f:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103a62:	a1 a0 ce 11 c0       	mov    0xc011cea0,%eax
c0103a67:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0103a6a:	72 23                	jb     c0103a8f <check_pgdir+0x20a>
c0103a6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103a6f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103a73:	c7 44 24 08 60 6b 10 	movl   $0xc0106b60,0x8(%esp)
c0103a7a:	c0 
c0103a7b:	c7 44 24 04 e1 01 00 	movl   $0x1e1,0x4(%esp)
c0103a82:	00 
c0103a83:	c7 04 24 28 6c 10 c0 	movl   $0xc0106c28,(%esp)
c0103a8a:	e8 63 c9 ff ff       	call   c01003f2 <__panic>
c0103a8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103a92:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103a97:	83 c0 04             	add    $0x4,%eax
c0103a9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0103a9d:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103aa2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103aa9:	00 
c0103aaa:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0103ab1:	00 
c0103ab2:	89 04 24             	mov    %eax,(%esp)
c0103ab5:	e8 ed fb ff ff       	call   c01036a7 <get_pte>
c0103aba:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0103abd:	74 24                	je     c0103ae3 <check_pgdir+0x25e>
c0103abf:	c7 44 24 0c a8 6d 10 	movl   $0xc0106da8,0xc(%esp)
c0103ac6:	c0 
c0103ac7:	c7 44 24 08 4d 6c 10 	movl   $0xc0106c4d,0x8(%esp)
c0103ace:	c0 
c0103acf:	c7 44 24 04 e2 01 00 	movl   $0x1e2,0x4(%esp)
c0103ad6:	00 
c0103ad7:	c7 04 24 28 6c 10 c0 	movl   $0xc0106c28,(%esp)
c0103ade:	e8 0f c9 ff ff       	call   c01003f2 <__panic>

    p2 = alloc_page();
c0103ae3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103aea:	e8 21 f5 ff ff       	call   c0103010 <alloc_pages>
c0103aef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0103af2:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103af7:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0103afe:	00 
c0103aff:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0103b06:	00 
c0103b07:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103b0a:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103b0e:	89 04 24             	mov    %eax,(%esp)
c0103b11:	e8 3b fc ff ff       	call   c0103751 <page_insert>
c0103b16:	85 c0                	test   %eax,%eax
c0103b18:	74 24                	je     c0103b3e <check_pgdir+0x2b9>
c0103b1a:	c7 44 24 0c d0 6d 10 	movl   $0xc0106dd0,0xc(%esp)
c0103b21:	c0 
c0103b22:	c7 44 24 08 4d 6c 10 	movl   $0xc0106c4d,0x8(%esp)
c0103b29:	c0 
c0103b2a:	c7 44 24 04 e5 01 00 	movl   $0x1e5,0x4(%esp)
c0103b31:	00 
c0103b32:	c7 04 24 28 6c 10 c0 	movl   $0xc0106c28,(%esp)
c0103b39:	e8 b4 c8 ff ff       	call   c01003f2 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0103b3e:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103b43:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103b4a:	00 
c0103b4b:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0103b52:	00 
c0103b53:	89 04 24             	mov    %eax,(%esp)
c0103b56:	e8 4c fb ff ff       	call   c01036a7 <get_pte>
c0103b5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103b5e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103b62:	75 24                	jne    c0103b88 <check_pgdir+0x303>
c0103b64:	c7 44 24 0c 08 6e 10 	movl   $0xc0106e08,0xc(%esp)
c0103b6b:	c0 
c0103b6c:	c7 44 24 08 4d 6c 10 	movl   $0xc0106c4d,0x8(%esp)
c0103b73:	c0 
c0103b74:	c7 44 24 04 e6 01 00 	movl   $0x1e6,0x4(%esp)
c0103b7b:	00 
c0103b7c:	c7 04 24 28 6c 10 c0 	movl   $0xc0106c28,(%esp)
c0103b83:	e8 6a c8 ff ff       	call   c01003f2 <__panic>
    assert(*ptep & PTE_U);
c0103b88:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103b8b:	8b 00                	mov    (%eax),%eax
c0103b8d:	83 e0 04             	and    $0x4,%eax
c0103b90:	85 c0                	test   %eax,%eax
c0103b92:	75 24                	jne    c0103bb8 <check_pgdir+0x333>
c0103b94:	c7 44 24 0c 38 6e 10 	movl   $0xc0106e38,0xc(%esp)
c0103b9b:	c0 
c0103b9c:	c7 44 24 08 4d 6c 10 	movl   $0xc0106c4d,0x8(%esp)
c0103ba3:	c0 
c0103ba4:	c7 44 24 04 e7 01 00 	movl   $0x1e7,0x4(%esp)
c0103bab:	00 
c0103bac:	c7 04 24 28 6c 10 c0 	movl   $0xc0106c28,(%esp)
c0103bb3:	e8 3a c8 ff ff       	call   c01003f2 <__panic>
    assert(*ptep & PTE_W);
c0103bb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103bbb:	8b 00                	mov    (%eax),%eax
c0103bbd:	83 e0 02             	and    $0x2,%eax
c0103bc0:	85 c0                	test   %eax,%eax
c0103bc2:	75 24                	jne    c0103be8 <check_pgdir+0x363>
c0103bc4:	c7 44 24 0c 46 6e 10 	movl   $0xc0106e46,0xc(%esp)
c0103bcb:	c0 
c0103bcc:	c7 44 24 08 4d 6c 10 	movl   $0xc0106c4d,0x8(%esp)
c0103bd3:	c0 
c0103bd4:	c7 44 24 04 e8 01 00 	movl   $0x1e8,0x4(%esp)
c0103bdb:	00 
c0103bdc:	c7 04 24 28 6c 10 c0 	movl   $0xc0106c28,(%esp)
c0103be3:	e8 0a c8 ff ff       	call   c01003f2 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0103be8:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103bed:	8b 00                	mov    (%eax),%eax
c0103bef:	83 e0 04             	and    $0x4,%eax
c0103bf2:	85 c0                	test   %eax,%eax
c0103bf4:	75 24                	jne    c0103c1a <check_pgdir+0x395>
c0103bf6:	c7 44 24 0c 54 6e 10 	movl   $0xc0106e54,0xc(%esp)
c0103bfd:	c0 
c0103bfe:	c7 44 24 08 4d 6c 10 	movl   $0xc0106c4d,0x8(%esp)
c0103c05:	c0 
c0103c06:	c7 44 24 04 e9 01 00 	movl   $0x1e9,0x4(%esp)
c0103c0d:	00 
c0103c0e:	c7 04 24 28 6c 10 c0 	movl   $0xc0106c28,(%esp)
c0103c15:	e8 d8 c7 ff ff       	call   c01003f2 <__panic>
    assert(page_ref(p2) == 1);
c0103c1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103c1d:	89 04 24             	mov    %eax,(%esp)
c0103c20:	e8 f4 f1 ff ff       	call   c0102e19 <page_ref>
c0103c25:	83 f8 01             	cmp    $0x1,%eax
c0103c28:	74 24                	je     c0103c4e <check_pgdir+0x3c9>
c0103c2a:	c7 44 24 0c 6a 6e 10 	movl   $0xc0106e6a,0xc(%esp)
c0103c31:	c0 
c0103c32:	c7 44 24 08 4d 6c 10 	movl   $0xc0106c4d,0x8(%esp)
c0103c39:	c0 
c0103c3a:	c7 44 24 04 ea 01 00 	movl   $0x1ea,0x4(%esp)
c0103c41:	00 
c0103c42:	c7 04 24 28 6c 10 c0 	movl   $0xc0106c28,(%esp)
c0103c49:	e8 a4 c7 ff ff       	call   c01003f2 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0103c4e:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103c53:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0103c5a:	00 
c0103c5b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0103c62:	00 
c0103c63:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103c66:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103c6a:	89 04 24             	mov    %eax,(%esp)
c0103c6d:	e8 df fa ff ff       	call   c0103751 <page_insert>
c0103c72:	85 c0                	test   %eax,%eax
c0103c74:	74 24                	je     c0103c9a <check_pgdir+0x415>
c0103c76:	c7 44 24 0c 7c 6e 10 	movl   $0xc0106e7c,0xc(%esp)
c0103c7d:	c0 
c0103c7e:	c7 44 24 08 4d 6c 10 	movl   $0xc0106c4d,0x8(%esp)
c0103c85:	c0 
c0103c86:	c7 44 24 04 ec 01 00 	movl   $0x1ec,0x4(%esp)
c0103c8d:	00 
c0103c8e:	c7 04 24 28 6c 10 c0 	movl   $0xc0106c28,(%esp)
c0103c95:	e8 58 c7 ff ff       	call   c01003f2 <__panic>
    assert(page_ref(p1) == 2);
c0103c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c9d:	89 04 24             	mov    %eax,(%esp)
c0103ca0:	e8 74 f1 ff ff       	call   c0102e19 <page_ref>
c0103ca5:	83 f8 02             	cmp    $0x2,%eax
c0103ca8:	74 24                	je     c0103cce <check_pgdir+0x449>
c0103caa:	c7 44 24 0c a8 6e 10 	movl   $0xc0106ea8,0xc(%esp)
c0103cb1:	c0 
c0103cb2:	c7 44 24 08 4d 6c 10 	movl   $0xc0106c4d,0x8(%esp)
c0103cb9:	c0 
c0103cba:	c7 44 24 04 ed 01 00 	movl   $0x1ed,0x4(%esp)
c0103cc1:	00 
c0103cc2:	c7 04 24 28 6c 10 c0 	movl   $0xc0106c28,(%esp)
c0103cc9:	e8 24 c7 ff ff       	call   c01003f2 <__panic>
    assert(page_ref(p2) == 0);
c0103cce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103cd1:	89 04 24             	mov    %eax,(%esp)
c0103cd4:	e8 40 f1 ff ff       	call   c0102e19 <page_ref>
c0103cd9:	85 c0                	test   %eax,%eax
c0103cdb:	74 24                	je     c0103d01 <check_pgdir+0x47c>
c0103cdd:	c7 44 24 0c ba 6e 10 	movl   $0xc0106eba,0xc(%esp)
c0103ce4:	c0 
c0103ce5:	c7 44 24 08 4d 6c 10 	movl   $0xc0106c4d,0x8(%esp)
c0103cec:	c0 
c0103ced:	c7 44 24 04 ee 01 00 	movl   $0x1ee,0x4(%esp)
c0103cf4:	00 
c0103cf5:	c7 04 24 28 6c 10 c0 	movl   $0xc0106c28,(%esp)
c0103cfc:	e8 f1 c6 ff ff       	call   c01003f2 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0103d01:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103d06:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103d0d:	00 
c0103d0e:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0103d15:	00 
c0103d16:	89 04 24             	mov    %eax,(%esp)
c0103d19:	e8 89 f9 ff ff       	call   c01036a7 <get_pte>
c0103d1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103d21:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103d25:	75 24                	jne    c0103d4b <check_pgdir+0x4c6>
c0103d27:	c7 44 24 0c 08 6e 10 	movl   $0xc0106e08,0xc(%esp)
c0103d2e:	c0 
c0103d2f:	c7 44 24 08 4d 6c 10 	movl   $0xc0106c4d,0x8(%esp)
c0103d36:	c0 
c0103d37:	c7 44 24 04 ef 01 00 	movl   $0x1ef,0x4(%esp)
c0103d3e:	00 
c0103d3f:	c7 04 24 28 6c 10 c0 	movl   $0xc0106c28,(%esp)
c0103d46:	e8 a7 c6 ff ff       	call   c01003f2 <__panic>
    assert(pte2page(*ptep) == p1);
c0103d4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103d4e:	8b 00                	mov    (%eax),%eax
c0103d50:	89 04 24             	mov    %eax,(%esp)
c0103d53:	e8 6b f0 ff ff       	call   c0102dc3 <pte2page>
c0103d58:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0103d5b:	74 24                	je     c0103d81 <check_pgdir+0x4fc>
c0103d5d:	c7 44 24 0c 7d 6d 10 	movl   $0xc0106d7d,0xc(%esp)
c0103d64:	c0 
c0103d65:	c7 44 24 08 4d 6c 10 	movl   $0xc0106c4d,0x8(%esp)
c0103d6c:	c0 
c0103d6d:	c7 44 24 04 f0 01 00 	movl   $0x1f0,0x4(%esp)
c0103d74:	00 
c0103d75:	c7 04 24 28 6c 10 c0 	movl   $0xc0106c28,(%esp)
c0103d7c:	e8 71 c6 ff ff       	call   c01003f2 <__panic>
    assert((*ptep & PTE_U) == 0);
c0103d81:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103d84:	8b 00                	mov    (%eax),%eax
c0103d86:	83 e0 04             	and    $0x4,%eax
c0103d89:	85 c0                	test   %eax,%eax
c0103d8b:	74 24                	je     c0103db1 <check_pgdir+0x52c>
c0103d8d:	c7 44 24 0c cc 6e 10 	movl   $0xc0106ecc,0xc(%esp)
c0103d94:	c0 
c0103d95:	c7 44 24 08 4d 6c 10 	movl   $0xc0106c4d,0x8(%esp)
c0103d9c:	c0 
c0103d9d:	c7 44 24 04 f1 01 00 	movl   $0x1f1,0x4(%esp)
c0103da4:	00 
c0103da5:	c7 04 24 28 6c 10 c0 	movl   $0xc0106c28,(%esp)
c0103dac:	e8 41 c6 ff ff       	call   c01003f2 <__panic>

    page_remove(boot_pgdir, 0x0);
c0103db1:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103db6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103dbd:	00 
c0103dbe:	89 04 24             	mov    %eax,(%esp)
c0103dc1:	e8 46 f9 ff ff       	call   c010370c <page_remove>
    assert(page_ref(p1) == 1);
c0103dc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103dc9:	89 04 24             	mov    %eax,(%esp)
c0103dcc:	e8 48 f0 ff ff       	call   c0102e19 <page_ref>
c0103dd1:	83 f8 01             	cmp    $0x1,%eax
c0103dd4:	74 24                	je     c0103dfa <check_pgdir+0x575>
c0103dd6:	c7 44 24 0c 93 6d 10 	movl   $0xc0106d93,0xc(%esp)
c0103ddd:	c0 
c0103dde:	c7 44 24 08 4d 6c 10 	movl   $0xc0106c4d,0x8(%esp)
c0103de5:	c0 
c0103de6:	c7 44 24 04 f4 01 00 	movl   $0x1f4,0x4(%esp)
c0103ded:	00 
c0103dee:	c7 04 24 28 6c 10 c0 	movl   $0xc0106c28,(%esp)
c0103df5:	e8 f8 c5 ff ff       	call   c01003f2 <__panic>
    assert(page_ref(p2) == 0);
c0103dfa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103dfd:	89 04 24             	mov    %eax,(%esp)
c0103e00:	e8 14 f0 ff ff       	call   c0102e19 <page_ref>
c0103e05:	85 c0                	test   %eax,%eax
c0103e07:	74 24                	je     c0103e2d <check_pgdir+0x5a8>
c0103e09:	c7 44 24 0c ba 6e 10 	movl   $0xc0106eba,0xc(%esp)
c0103e10:	c0 
c0103e11:	c7 44 24 08 4d 6c 10 	movl   $0xc0106c4d,0x8(%esp)
c0103e18:	c0 
c0103e19:	c7 44 24 04 f5 01 00 	movl   $0x1f5,0x4(%esp)
c0103e20:	00 
c0103e21:	c7 04 24 28 6c 10 c0 	movl   $0xc0106c28,(%esp)
c0103e28:	e8 c5 c5 ff ff       	call   c01003f2 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0103e2d:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103e32:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0103e39:	00 
c0103e3a:	89 04 24             	mov    %eax,(%esp)
c0103e3d:	e8 ca f8 ff ff       	call   c010370c <page_remove>
    assert(page_ref(p1) == 0);
c0103e42:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103e45:	89 04 24             	mov    %eax,(%esp)
c0103e48:	e8 cc ef ff ff       	call   c0102e19 <page_ref>
c0103e4d:	85 c0                	test   %eax,%eax
c0103e4f:	74 24                	je     c0103e75 <check_pgdir+0x5f0>
c0103e51:	c7 44 24 0c e1 6e 10 	movl   $0xc0106ee1,0xc(%esp)
c0103e58:	c0 
c0103e59:	c7 44 24 08 4d 6c 10 	movl   $0xc0106c4d,0x8(%esp)
c0103e60:	c0 
c0103e61:	c7 44 24 04 f8 01 00 	movl   $0x1f8,0x4(%esp)
c0103e68:	00 
c0103e69:	c7 04 24 28 6c 10 c0 	movl   $0xc0106c28,(%esp)
c0103e70:	e8 7d c5 ff ff       	call   c01003f2 <__panic>
    assert(page_ref(p2) == 0);
c0103e75:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103e78:	89 04 24             	mov    %eax,(%esp)
c0103e7b:	e8 99 ef ff ff       	call   c0102e19 <page_ref>
c0103e80:	85 c0                	test   %eax,%eax
c0103e82:	74 24                	je     c0103ea8 <check_pgdir+0x623>
c0103e84:	c7 44 24 0c ba 6e 10 	movl   $0xc0106eba,0xc(%esp)
c0103e8b:	c0 
c0103e8c:	c7 44 24 08 4d 6c 10 	movl   $0xc0106c4d,0x8(%esp)
c0103e93:	c0 
c0103e94:	c7 44 24 04 f9 01 00 	movl   $0x1f9,0x4(%esp)
c0103e9b:	00 
c0103e9c:	c7 04 24 28 6c 10 c0 	movl   $0xc0106c28,(%esp)
c0103ea3:	e8 4a c5 ff ff       	call   c01003f2 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0103ea8:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103ead:	8b 00                	mov    (%eax),%eax
c0103eaf:	89 04 24             	mov    %eax,(%esp)
c0103eb2:	e8 4a ef ff ff       	call   c0102e01 <pde2page>
c0103eb7:	89 04 24             	mov    %eax,(%esp)
c0103eba:	e8 5a ef ff ff       	call   c0102e19 <page_ref>
c0103ebf:	83 f8 01             	cmp    $0x1,%eax
c0103ec2:	74 24                	je     c0103ee8 <check_pgdir+0x663>
c0103ec4:	c7 44 24 0c f4 6e 10 	movl   $0xc0106ef4,0xc(%esp)
c0103ecb:	c0 
c0103ecc:	c7 44 24 08 4d 6c 10 	movl   $0xc0106c4d,0x8(%esp)
c0103ed3:	c0 
c0103ed4:	c7 44 24 04 fb 01 00 	movl   $0x1fb,0x4(%esp)
c0103edb:	00 
c0103edc:	c7 04 24 28 6c 10 c0 	movl   $0xc0106c28,(%esp)
c0103ee3:	e8 0a c5 ff ff       	call   c01003f2 <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0103ee8:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103eed:	8b 00                	mov    (%eax),%eax
c0103eef:	89 04 24             	mov    %eax,(%esp)
c0103ef2:	e8 0a ef ff ff       	call   c0102e01 <pde2page>
c0103ef7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103efe:	00 
c0103eff:	89 04 24             	mov    %eax,(%esp)
c0103f02:	e8 41 f1 ff ff       	call   c0103048 <free_pages>
    boot_pgdir[0] = 0;
c0103f07:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103f0c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0103f12:	c7 04 24 1b 6f 10 c0 	movl   $0xc0106f1b,(%esp)
c0103f19:	e8 7c c3 ff ff       	call   c010029a <cprintf>
}
c0103f1e:	90                   	nop
c0103f1f:	c9                   	leave  
c0103f20:	c3                   	ret    

c0103f21 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0103f21:	55                   	push   %ebp
c0103f22:	89 e5                	mov    %esp,%ebp
c0103f24:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0103f27:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103f2e:	e9 ca 00 00 00       	jmp    c0103ffd <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0103f33:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103f36:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103f39:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103f3c:	c1 e8 0c             	shr    $0xc,%eax
c0103f3f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103f42:	a1 a0 ce 11 c0       	mov    0xc011cea0,%eax
c0103f47:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0103f4a:	72 23                	jb     c0103f6f <check_boot_pgdir+0x4e>
c0103f4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103f4f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103f53:	c7 44 24 08 60 6b 10 	movl   $0xc0106b60,0x8(%esp)
c0103f5a:	c0 
c0103f5b:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
c0103f62:	00 
c0103f63:	c7 04 24 28 6c 10 c0 	movl   $0xc0106c28,(%esp)
c0103f6a:	e8 83 c4 ff ff       	call   c01003f2 <__panic>
c0103f6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103f72:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103f77:	89 c2                	mov    %eax,%edx
c0103f79:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103f7e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103f85:	00 
c0103f86:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103f8a:	89 04 24             	mov    %eax,(%esp)
c0103f8d:	e8 15 f7 ff ff       	call   c01036a7 <get_pte>
c0103f92:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103f95:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0103f99:	75 24                	jne    c0103fbf <check_boot_pgdir+0x9e>
c0103f9b:	c7 44 24 0c 38 6f 10 	movl   $0xc0106f38,0xc(%esp)
c0103fa2:	c0 
c0103fa3:	c7 44 24 08 4d 6c 10 	movl   $0xc0106c4d,0x8(%esp)
c0103faa:	c0 
c0103fab:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
c0103fb2:	00 
c0103fb3:	c7 04 24 28 6c 10 c0 	movl   $0xc0106c28,(%esp)
c0103fba:	e8 33 c4 ff ff       	call   c01003f2 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0103fbf:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103fc2:	8b 00                	mov    (%eax),%eax
c0103fc4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103fc9:	89 c2                	mov    %eax,%edx
c0103fcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103fce:	39 c2                	cmp    %eax,%edx
c0103fd0:	74 24                	je     c0103ff6 <check_boot_pgdir+0xd5>
c0103fd2:	c7 44 24 0c 75 6f 10 	movl   $0xc0106f75,0xc(%esp)
c0103fd9:	c0 
c0103fda:	c7 44 24 08 4d 6c 10 	movl   $0xc0106c4d,0x8(%esp)
c0103fe1:	c0 
c0103fe2:	c7 44 24 04 08 02 00 	movl   $0x208,0x4(%esp)
c0103fe9:	00 
c0103fea:	c7 04 24 28 6c 10 c0 	movl   $0xc0106c28,(%esp)
c0103ff1:	e8 fc c3 ff ff       	call   c01003f2 <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
c0103ff6:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0103ffd:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104000:	a1 a0 ce 11 c0       	mov    0xc011cea0,%eax
c0104005:	39 c2                	cmp    %eax,%edx
c0104007:	0f 82 26 ff ff ff    	jb     c0103f33 <check_boot_pgdir+0x12>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c010400d:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104012:	05 ac 0f 00 00       	add    $0xfac,%eax
c0104017:	8b 00                	mov    (%eax),%eax
c0104019:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010401e:	89 c2                	mov    %eax,%edx
c0104020:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104025:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104028:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c010402f:	77 23                	ja     c0104054 <check_boot_pgdir+0x133>
c0104031:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104034:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104038:	c7 44 24 08 04 6c 10 	movl   $0xc0106c04,0x8(%esp)
c010403f:	c0 
c0104040:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
c0104047:	00 
c0104048:	c7 04 24 28 6c 10 c0 	movl   $0xc0106c28,(%esp)
c010404f:	e8 9e c3 ff ff       	call   c01003f2 <__panic>
c0104054:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104057:	05 00 00 00 40       	add    $0x40000000,%eax
c010405c:	39 d0                	cmp    %edx,%eax
c010405e:	74 24                	je     c0104084 <check_boot_pgdir+0x163>
c0104060:	c7 44 24 0c 8c 6f 10 	movl   $0xc0106f8c,0xc(%esp)
c0104067:	c0 
c0104068:	c7 44 24 08 4d 6c 10 	movl   $0xc0106c4d,0x8(%esp)
c010406f:	c0 
c0104070:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
c0104077:	00 
c0104078:	c7 04 24 28 6c 10 c0 	movl   $0xc0106c28,(%esp)
c010407f:	e8 6e c3 ff ff       	call   c01003f2 <__panic>

    assert(boot_pgdir[0] == 0);
c0104084:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104089:	8b 00                	mov    (%eax),%eax
c010408b:	85 c0                	test   %eax,%eax
c010408d:	74 24                	je     c01040b3 <check_boot_pgdir+0x192>
c010408f:	c7 44 24 0c c0 6f 10 	movl   $0xc0106fc0,0xc(%esp)
c0104096:	c0 
c0104097:	c7 44 24 08 4d 6c 10 	movl   $0xc0106c4d,0x8(%esp)
c010409e:	c0 
c010409f:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
c01040a6:	00 
c01040a7:	c7 04 24 28 6c 10 c0 	movl   $0xc0106c28,(%esp)
c01040ae:	e8 3f c3 ff ff       	call   c01003f2 <__panic>

    struct Page *p;
    p = alloc_page();
c01040b3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01040ba:	e8 51 ef ff ff       	call   c0103010 <alloc_pages>
c01040bf:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c01040c2:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c01040c7:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c01040ce:	00 
c01040cf:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c01040d6:	00 
c01040d7:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01040da:	89 54 24 04          	mov    %edx,0x4(%esp)
c01040de:	89 04 24             	mov    %eax,(%esp)
c01040e1:	e8 6b f6 ff ff       	call   c0103751 <page_insert>
c01040e6:	85 c0                	test   %eax,%eax
c01040e8:	74 24                	je     c010410e <check_boot_pgdir+0x1ed>
c01040ea:	c7 44 24 0c d4 6f 10 	movl   $0xc0106fd4,0xc(%esp)
c01040f1:	c0 
c01040f2:	c7 44 24 08 4d 6c 10 	movl   $0xc0106c4d,0x8(%esp)
c01040f9:	c0 
c01040fa:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
c0104101:	00 
c0104102:	c7 04 24 28 6c 10 c0 	movl   $0xc0106c28,(%esp)
c0104109:	e8 e4 c2 ff ff       	call   c01003f2 <__panic>
    assert(page_ref(p) == 1);
c010410e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104111:	89 04 24             	mov    %eax,(%esp)
c0104114:	e8 00 ed ff ff       	call   c0102e19 <page_ref>
c0104119:	83 f8 01             	cmp    $0x1,%eax
c010411c:	74 24                	je     c0104142 <check_boot_pgdir+0x221>
c010411e:	c7 44 24 0c 02 70 10 	movl   $0xc0107002,0xc(%esp)
c0104125:	c0 
c0104126:	c7 44 24 08 4d 6c 10 	movl   $0xc0106c4d,0x8(%esp)
c010412d:	c0 
c010412e:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
c0104135:	00 
c0104136:	c7 04 24 28 6c 10 c0 	movl   $0xc0106c28,(%esp)
c010413d:	e8 b0 c2 ff ff       	call   c01003f2 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0104142:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104147:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c010414e:	00 
c010414f:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0104156:	00 
c0104157:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010415a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010415e:	89 04 24             	mov    %eax,(%esp)
c0104161:	e8 eb f5 ff ff       	call   c0103751 <page_insert>
c0104166:	85 c0                	test   %eax,%eax
c0104168:	74 24                	je     c010418e <check_boot_pgdir+0x26d>
c010416a:	c7 44 24 0c 14 70 10 	movl   $0xc0107014,0xc(%esp)
c0104171:	c0 
c0104172:	c7 44 24 08 4d 6c 10 	movl   $0xc0106c4d,0x8(%esp)
c0104179:	c0 
c010417a:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
c0104181:	00 
c0104182:	c7 04 24 28 6c 10 c0 	movl   $0xc0106c28,(%esp)
c0104189:	e8 64 c2 ff ff       	call   c01003f2 <__panic>
    assert(page_ref(p) == 2);
c010418e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104191:	89 04 24             	mov    %eax,(%esp)
c0104194:	e8 80 ec ff ff       	call   c0102e19 <page_ref>
c0104199:	83 f8 02             	cmp    $0x2,%eax
c010419c:	74 24                	je     c01041c2 <check_boot_pgdir+0x2a1>
c010419e:	c7 44 24 0c 4b 70 10 	movl   $0xc010704b,0xc(%esp)
c01041a5:	c0 
c01041a6:	c7 44 24 08 4d 6c 10 	movl   $0xc0106c4d,0x8(%esp)
c01041ad:	c0 
c01041ae:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
c01041b5:	00 
c01041b6:	c7 04 24 28 6c 10 c0 	movl   $0xc0106c28,(%esp)
c01041bd:	e8 30 c2 ff ff       	call   c01003f2 <__panic>

    const char *str = "ucore: Hello world!!";
c01041c2:	c7 45 dc 5c 70 10 c0 	movl   $0xc010705c,-0x24(%ebp)
    strcpy((void *)0x100, str);
c01041c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01041cc:	89 44 24 04          	mov    %eax,0x4(%esp)
c01041d0:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01041d7:	e8 62 17 00 00       	call   c010593e <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c01041dc:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c01041e3:	00 
c01041e4:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01041eb:	e8 c5 17 00 00       	call   c01059b5 <strcmp>
c01041f0:	85 c0                	test   %eax,%eax
c01041f2:	74 24                	je     c0104218 <check_boot_pgdir+0x2f7>
c01041f4:	c7 44 24 0c 74 70 10 	movl   $0xc0107074,0xc(%esp)
c01041fb:	c0 
c01041fc:	c7 44 24 08 4d 6c 10 	movl   $0xc0106c4d,0x8(%esp)
c0104203:	c0 
c0104204:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
c010420b:	00 
c010420c:	c7 04 24 28 6c 10 c0 	movl   $0xc0106c28,(%esp)
c0104213:	e8 da c1 ff ff       	call   c01003f2 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0104218:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010421b:	89 04 24             	mov    %eax,(%esp)
c010421e:	e8 4c eb ff ff       	call   c0102d6f <page2kva>
c0104223:	05 00 01 00 00       	add    $0x100,%eax
c0104228:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c010422b:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0104232:	e8 b1 16 00 00       	call   c01058e8 <strlen>
c0104237:	85 c0                	test   %eax,%eax
c0104239:	74 24                	je     c010425f <check_boot_pgdir+0x33e>
c010423b:	c7 44 24 0c ac 70 10 	movl   $0xc01070ac,0xc(%esp)
c0104242:	c0 
c0104243:	c7 44 24 08 4d 6c 10 	movl   $0xc0106c4d,0x8(%esp)
c010424a:	c0 
c010424b:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
c0104252:	00 
c0104253:	c7 04 24 28 6c 10 c0 	movl   $0xc0106c28,(%esp)
c010425a:	e8 93 c1 ff ff       	call   c01003f2 <__panic>

    free_page(p);
c010425f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104266:	00 
c0104267:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010426a:	89 04 24             	mov    %eax,(%esp)
c010426d:	e8 d6 ed ff ff       	call   c0103048 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
c0104272:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104277:	8b 00                	mov    (%eax),%eax
c0104279:	89 04 24             	mov    %eax,(%esp)
c010427c:	e8 80 eb ff ff       	call   c0102e01 <pde2page>
c0104281:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104288:	00 
c0104289:	89 04 24             	mov    %eax,(%esp)
c010428c:	e8 b7 ed ff ff       	call   c0103048 <free_pages>
    boot_pgdir[0] = 0;
c0104291:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104296:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c010429c:	c7 04 24 d0 70 10 c0 	movl   $0xc01070d0,(%esp)
c01042a3:	e8 f2 bf ff ff       	call   c010029a <cprintf>
}
c01042a8:	90                   	nop
c01042a9:	c9                   	leave  
c01042aa:	c3                   	ret    

c01042ab <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c01042ab:	55                   	push   %ebp
c01042ac:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c01042ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01042b1:	83 e0 04             	and    $0x4,%eax
c01042b4:	85 c0                	test   %eax,%eax
c01042b6:	74 04                	je     c01042bc <perm2str+0x11>
c01042b8:	b0 75                	mov    $0x75,%al
c01042ba:	eb 02                	jmp    c01042be <perm2str+0x13>
c01042bc:	b0 2d                	mov    $0x2d,%al
c01042be:	a2 28 cf 11 c0       	mov    %al,0xc011cf28
    str[1] = 'r';
c01042c3:	c6 05 29 cf 11 c0 72 	movb   $0x72,0xc011cf29
    str[2] = (perm & PTE_W) ? 'w' : '-';
c01042ca:	8b 45 08             	mov    0x8(%ebp),%eax
c01042cd:	83 e0 02             	and    $0x2,%eax
c01042d0:	85 c0                	test   %eax,%eax
c01042d2:	74 04                	je     c01042d8 <perm2str+0x2d>
c01042d4:	b0 77                	mov    $0x77,%al
c01042d6:	eb 02                	jmp    c01042da <perm2str+0x2f>
c01042d8:	b0 2d                	mov    $0x2d,%al
c01042da:	a2 2a cf 11 c0       	mov    %al,0xc011cf2a
    str[3] = '\0';
c01042df:	c6 05 2b cf 11 c0 00 	movb   $0x0,0xc011cf2b
    return str;
c01042e6:	b8 28 cf 11 c0       	mov    $0xc011cf28,%eax
}
c01042eb:	5d                   	pop    %ebp
c01042ec:	c3                   	ret    

c01042ed <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c01042ed:	55                   	push   %ebp
c01042ee:	89 e5                	mov    %esp,%ebp
c01042f0:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c01042f3:	8b 45 10             	mov    0x10(%ebp),%eax
c01042f6:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01042f9:	72 0d                	jb     c0104308 <get_pgtable_items+0x1b>
        return 0;
c01042fb:	b8 00 00 00 00       	mov    $0x0,%eax
c0104300:	e9 98 00 00 00       	jmp    c010439d <get_pgtable_items+0xb0>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
c0104305:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
c0104308:	8b 45 10             	mov    0x10(%ebp),%eax
c010430b:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010430e:	73 18                	jae    c0104328 <get_pgtable_items+0x3b>
c0104310:	8b 45 10             	mov    0x10(%ebp),%eax
c0104313:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010431a:	8b 45 14             	mov    0x14(%ebp),%eax
c010431d:	01 d0                	add    %edx,%eax
c010431f:	8b 00                	mov    (%eax),%eax
c0104321:	83 e0 01             	and    $0x1,%eax
c0104324:	85 c0                	test   %eax,%eax
c0104326:	74 dd                	je     c0104305 <get_pgtable_items+0x18>
    }
    if (start < right) {
c0104328:	8b 45 10             	mov    0x10(%ebp),%eax
c010432b:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010432e:	73 68                	jae    c0104398 <get_pgtable_items+0xab>
        if (left_store != NULL) {
c0104330:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0104334:	74 08                	je     c010433e <get_pgtable_items+0x51>
            *left_store = start;
c0104336:	8b 45 18             	mov    0x18(%ebp),%eax
c0104339:	8b 55 10             	mov    0x10(%ebp),%edx
c010433c:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c010433e:	8b 45 10             	mov    0x10(%ebp),%eax
c0104341:	8d 50 01             	lea    0x1(%eax),%edx
c0104344:	89 55 10             	mov    %edx,0x10(%ebp)
c0104347:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010434e:	8b 45 14             	mov    0x14(%ebp),%eax
c0104351:	01 d0                	add    %edx,%eax
c0104353:	8b 00                	mov    (%eax),%eax
c0104355:	83 e0 07             	and    $0x7,%eax
c0104358:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c010435b:	eb 03                	jmp    c0104360 <get_pgtable_items+0x73>
            start ++;
c010435d:	ff 45 10             	incl   0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0104360:	8b 45 10             	mov    0x10(%ebp),%eax
c0104363:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104366:	73 1d                	jae    c0104385 <get_pgtable_items+0x98>
c0104368:	8b 45 10             	mov    0x10(%ebp),%eax
c010436b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104372:	8b 45 14             	mov    0x14(%ebp),%eax
c0104375:	01 d0                	add    %edx,%eax
c0104377:	8b 00                	mov    (%eax),%eax
c0104379:	83 e0 07             	and    $0x7,%eax
c010437c:	89 c2                	mov    %eax,%edx
c010437e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104381:	39 c2                	cmp    %eax,%edx
c0104383:	74 d8                	je     c010435d <get_pgtable_items+0x70>
        }
        if (right_store != NULL) {
c0104385:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0104389:	74 08                	je     c0104393 <get_pgtable_items+0xa6>
            *right_store = start;
c010438b:	8b 45 1c             	mov    0x1c(%ebp),%eax
c010438e:	8b 55 10             	mov    0x10(%ebp),%edx
c0104391:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0104393:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104396:	eb 05                	jmp    c010439d <get_pgtable_items+0xb0>
    }
    return 0;
c0104398:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010439d:	c9                   	leave  
c010439e:	c3                   	ret    

c010439f <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c010439f:	55                   	push   %ebp
c01043a0:	89 e5                	mov    %esp,%ebp
c01043a2:	57                   	push   %edi
c01043a3:	56                   	push   %esi
c01043a4:	53                   	push   %ebx
c01043a5:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c01043a8:	c7 04 24 f0 70 10 c0 	movl   $0xc01070f0,(%esp)
c01043af:	e8 e6 be ff ff       	call   c010029a <cprintf>
    size_t left, right = 0, perm;
c01043b4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01043bb:	e9 fa 00 00 00       	jmp    c01044ba <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c01043c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01043c3:	89 04 24             	mov    %eax,(%esp)
c01043c6:	e8 e0 fe ff ff       	call   c01042ab <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c01043cb:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01043ce:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01043d1:	29 d1                	sub    %edx,%ecx
c01043d3:	89 ca                	mov    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c01043d5:	89 d6                	mov    %edx,%esi
c01043d7:	c1 e6 16             	shl    $0x16,%esi
c01043da:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01043dd:	89 d3                	mov    %edx,%ebx
c01043df:	c1 e3 16             	shl    $0x16,%ebx
c01043e2:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01043e5:	89 d1                	mov    %edx,%ecx
c01043e7:	c1 e1 16             	shl    $0x16,%ecx
c01043ea:	8b 7d dc             	mov    -0x24(%ebp),%edi
c01043ed:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01043f0:	29 d7                	sub    %edx,%edi
c01043f2:	89 fa                	mov    %edi,%edx
c01043f4:	89 44 24 14          	mov    %eax,0x14(%esp)
c01043f8:	89 74 24 10          	mov    %esi,0x10(%esp)
c01043fc:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0104400:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0104404:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104408:	c7 04 24 21 71 10 c0 	movl   $0xc0107121,(%esp)
c010440f:	e8 86 be ff ff       	call   c010029a <cprintf>
        size_t l, r = left * NPTEENTRY;
c0104414:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104417:	c1 e0 0a             	shl    $0xa,%eax
c010441a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c010441d:	eb 54                	jmp    c0104473 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c010441f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104422:	89 04 24             	mov    %eax,(%esp)
c0104425:	e8 81 fe ff ff       	call   c01042ab <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c010442a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c010442d:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104430:	29 d1                	sub    %edx,%ecx
c0104432:	89 ca                	mov    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0104434:	89 d6                	mov    %edx,%esi
c0104436:	c1 e6 0c             	shl    $0xc,%esi
c0104439:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010443c:	89 d3                	mov    %edx,%ebx
c010443e:	c1 e3 0c             	shl    $0xc,%ebx
c0104441:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104444:	89 d1                	mov    %edx,%ecx
c0104446:	c1 e1 0c             	shl    $0xc,%ecx
c0104449:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c010444c:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010444f:	29 d7                	sub    %edx,%edi
c0104451:	89 fa                	mov    %edi,%edx
c0104453:	89 44 24 14          	mov    %eax,0x14(%esp)
c0104457:	89 74 24 10          	mov    %esi,0x10(%esp)
c010445b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010445f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0104463:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104467:	c7 04 24 40 71 10 c0 	movl   $0xc0107140,(%esp)
c010446e:	e8 27 be ff ff       	call   c010029a <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0104473:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
c0104478:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010447b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010447e:	89 d3                	mov    %edx,%ebx
c0104480:	c1 e3 0a             	shl    $0xa,%ebx
c0104483:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104486:	89 d1                	mov    %edx,%ecx
c0104488:	c1 e1 0a             	shl    $0xa,%ecx
c010448b:	8d 55 d4             	lea    -0x2c(%ebp),%edx
c010448e:	89 54 24 14          	mov    %edx,0x14(%esp)
c0104492:	8d 55 d8             	lea    -0x28(%ebp),%edx
c0104495:	89 54 24 10          	mov    %edx,0x10(%esp)
c0104499:	89 74 24 0c          	mov    %esi,0xc(%esp)
c010449d:	89 44 24 08          	mov    %eax,0x8(%esp)
c01044a1:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01044a5:	89 0c 24             	mov    %ecx,(%esp)
c01044a8:	e8 40 fe ff ff       	call   c01042ed <get_pgtable_items>
c01044ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01044b0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01044b4:	0f 85 65 ff ff ff    	jne    c010441f <print_pgdir+0x80>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01044ba:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
c01044bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01044c2:	8d 55 dc             	lea    -0x24(%ebp),%edx
c01044c5:	89 54 24 14          	mov    %edx,0x14(%esp)
c01044c9:	8d 55 e0             	lea    -0x20(%ebp),%edx
c01044cc:	89 54 24 10          	mov    %edx,0x10(%esp)
c01044d0:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01044d4:	89 44 24 08          	mov    %eax,0x8(%esp)
c01044d8:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c01044df:	00 
c01044e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01044e7:	e8 01 fe ff ff       	call   c01042ed <get_pgtable_items>
c01044ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01044ef:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01044f3:	0f 85 c7 fe ff ff    	jne    c01043c0 <print_pgdir+0x21>
        }
    }
    cprintf("--------------------- END ---------------------\n");
c01044f9:	c7 04 24 64 71 10 c0 	movl   $0xc0107164,(%esp)
c0104500:	e8 95 bd ff ff       	call   c010029a <cprintf>
}
c0104505:	90                   	nop
c0104506:	83 c4 4c             	add    $0x4c,%esp
c0104509:	5b                   	pop    %ebx
c010450a:	5e                   	pop    %esi
c010450b:	5f                   	pop    %edi
c010450c:	5d                   	pop    %ebp
c010450d:	c3                   	ret    

c010450e <page2ppn>:
page2ppn(struct Page *page) {
c010450e:	55                   	push   %ebp
c010450f:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0104511:	a1 38 cf 11 c0       	mov    0xc011cf38,%eax
c0104516:	8b 55 08             	mov    0x8(%ebp),%edx
c0104519:	29 c2                	sub    %eax,%edx
c010451b:	89 d0                	mov    %edx,%eax
c010451d:	c1 f8 02             	sar    $0x2,%eax
c0104520:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0104526:	5d                   	pop    %ebp
c0104527:	c3                   	ret    

c0104528 <page2pa>:
page2pa(struct Page *page) {
c0104528:	55                   	push   %ebp
c0104529:	89 e5                	mov    %esp,%ebp
c010452b:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c010452e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104531:	89 04 24             	mov    %eax,(%esp)
c0104534:	e8 d5 ff ff ff       	call   c010450e <page2ppn>
c0104539:	c1 e0 0c             	shl    $0xc,%eax
}
c010453c:	c9                   	leave  
c010453d:	c3                   	ret    

c010453e <page_ref>:
page_ref(struct Page *page) {
c010453e:	55                   	push   %ebp
c010453f:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0104541:	8b 45 08             	mov    0x8(%ebp),%eax
c0104544:	8b 00                	mov    (%eax),%eax
}
c0104546:	5d                   	pop    %ebp
c0104547:	c3                   	ret    

c0104548 <set_page_ref>:
set_page_ref(struct Page *page, int val) {
c0104548:	55                   	push   %ebp
c0104549:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c010454b:	8b 45 08             	mov    0x8(%ebp),%eax
c010454e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104551:	89 10                	mov    %edx,(%eax)
}
c0104553:	90                   	nop
c0104554:	5d                   	pop    %ebp
c0104555:	c3                   	ret    

c0104556 <default_init>:

/* tail of free_list */
static list_entry_t *tail = &free_list;

static void
default_init(void) {
c0104556:	55                   	push   %ebp
c0104557:	89 e5                	mov    %esp,%ebp
c0104559:	83 ec 10             	sub    $0x10,%esp
c010455c:	c7 45 fc 3c cf 11 c0 	movl   $0xc011cf3c,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0104563:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104566:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0104569:	89 50 04             	mov    %edx,0x4(%eax)
c010456c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010456f:	8b 50 04             	mov    0x4(%eax),%edx
c0104572:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104575:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c0104577:	c7 05 44 cf 11 c0 00 	movl   $0x0,0xc011cf44
c010457e:	00 00 00 
}
c0104581:	90                   	nop
c0104582:	c9                   	leave  
c0104583:	c3                   	ret    

c0104584 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c0104584:	55                   	push   %ebp
c0104585:	89 e5                	mov    %esp,%ebp
c0104587:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c010458a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010458e:	75 24                	jne    c01045b4 <default_init_memmap+0x30>
c0104590:	c7 44 24 0c 98 71 10 	movl   $0xc0107198,0xc(%esp)
c0104597:	c0 
c0104598:	c7 44 24 08 9e 71 10 	movl   $0xc010719e,0x8(%esp)
c010459f:	c0 
c01045a0:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
c01045a7:	00 
c01045a8:	c7 04 24 b3 71 10 c0 	movl   $0xc01071b3,(%esp)
c01045af:	e8 3e be ff ff       	call   c01003f2 <__panic>
    struct Page *p = base;
c01045b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01045b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c01045ba:	e9 b3 00 00 00       	jmp    c0104672 <default_init_memmap+0xee>
		// 在查找可用内存并分配struct Page数组时就已经将将全部Page设置为Reserved
		// 将Page标记为可用的:清除Reserved,设置Property,并把property设置为0( 不是空闲块的第一个物理页 )
        assert(PageReserved(p));
c01045bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045c2:	83 c0 04             	add    $0x4,%eax
c01045c5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c01045cc:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01045cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01045d2:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01045d5:	0f a3 10             	bt     %edx,(%eax)
c01045d8:	19 c0                	sbb    %eax,%eax
c01045da:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c01045dd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01045e1:	0f 95 c0             	setne  %al
c01045e4:	0f b6 c0             	movzbl %al,%eax
c01045e7:	85 c0                	test   %eax,%eax
c01045e9:	75 24                	jne    c010460f <default_init_memmap+0x8b>
c01045eb:	c7 44 24 0c c9 71 10 	movl   $0xc01071c9,0xc(%esp)
c01045f2:	c0 
c01045f3:	c7 44 24 08 9e 71 10 	movl   $0xc010719e,0x8(%esp)
c01045fa:	c0 
c01045fb:	c7 44 24 04 76 00 00 	movl   $0x76,0x4(%esp)
c0104602:	00 
c0104603:	c7 04 24 b3 71 10 c0 	movl   $0xc01071b3,(%esp)
c010460a:	e8 e3 bd ff ff       	call   c01003f2 <__panic>
        p->flags = p->property = 0;
c010460f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104612:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c0104619:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010461c:	8b 50 08             	mov    0x8(%eax),%edx
c010461f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104622:	89 50 04             	mov    %edx,0x4(%eax)
		SetPageProperty(p);
c0104625:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104628:	83 c0 04             	add    $0x4,%eax
c010462b:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c0104632:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104635:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104638:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010463b:	0f ab 10             	bts    %edx,(%eax)
        set_page_ref(p, 0);
c010463e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104645:	00 
c0104646:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104649:	89 04 24             	mov    %eax,(%esp)
c010464c:	e8 f7 fe ff ff       	call   c0104548 <set_page_ref>
		list_init(&(p->page_link));
c0104651:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104654:	83 c0 0c             	add    $0xc,%eax
c0104657:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010465a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010465d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104660:	89 50 04             	mov    %edx,0x4(%eax)
c0104663:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104666:	8b 50 04             	mov    0x4(%eax),%edx
c0104669:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010466c:	89 10                	mov    %edx,(%eax)
    for (; p != base + n; p ++) {
c010466e:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0104672:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104675:	89 d0                	mov    %edx,%eax
c0104677:	c1 e0 02             	shl    $0x2,%eax
c010467a:	01 d0                	add    %edx,%eax
c010467c:	c1 e0 02             	shl    $0x2,%eax
c010467f:	89 c2                	mov    %eax,%edx
c0104681:	8b 45 08             	mov    0x8(%ebp),%eax
c0104684:	01 d0                	add    %edx,%eax
c0104686:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104689:	0f 85 30 ff ff ff    	jne    c01045bf <default_init_memmap+0x3b>
    }
	cprintf("Page address is %x\n", (uintptr_t)base);
c010468f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104692:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104696:	c7 04 24 d9 71 10 c0 	movl   $0xc01071d9,(%esp)
c010469d:	e8 f8 bb ff ff       	call   c010029a <cprintf>
    base->property = n;
c01046a2:	8b 45 08             	mov    0x8(%ebp),%eax
c01046a5:	8b 55 0c             	mov    0xc(%ebp),%edx
c01046a8:	89 50 08             	mov    %edx,0x8(%eax)
    nr_free += n;
c01046ab:	8b 15 44 cf 11 c0    	mov    0xc011cf44,%edx
c01046b1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01046b4:	01 d0                	add    %edx,%eax
c01046b6:	a3 44 cf 11 c0       	mov    %eax,0xc011cf44
	assert(tail == &free_list);
c01046bb:	a1 38 9a 11 c0       	mov    0xc0119a38,%eax
c01046c0:	3d 3c cf 11 c0       	cmp    $0xc011cf3c,%eax
c01046c5:	74 24                	je     c01046eb <default_init_memmap+0x167>
c01046c7:	c7 44 24 0c ed 71 10 	movl   $0xc01071ed,0xc(%esp)
c01046ce:	c0 
c01046cf:	c7 44 24 08 9e 71 10 	movl   $0xc010719e,0x8(%esp)
c01046d6:	c0 
c01046d7:	c7 44 24 04 7f 00 00 	movl   $0x7f,0x4(%esp)
c01046de:	00 
c01046df:	c7 04 24 b3 71 10 c0 	movl   $0xc01071b3,(%esp)
c01046e6:	e8 07 bd ff ff       	call   c01003f2 <__panic>
	assert(tail != &(base->page_link));
c01046eb:	8b 45 08             	mov    0x8(%ebp),%eax
c01046ee:	8d 50 0c             	lea    0xc(%eax),%edx
c01046f1:	a1 38 9a 11 c0       	mov    0xc0119a38,%eax
c01046f6:	39 c2                	cmp    %eax,%edx
c01046f8:	75 24                	jne    c010471e <default_init_memmap+0x19a>
c01046fa:	c7 44 24 0c 00 72 10 	movl   $0xc0107200,0xc(%esp)
c0104701:	c0 
c0104702:	c7 44 24 08 9e 71 10 	movl   $0xc010719e,0x8(%esp)
c0104709:	c0 
c010470a:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
c0104711:	00 
c0104712:	c7 04 24 b3 71 10 c0 	movl   $0xc01071b3,(%esp)
c0104719:	e8 d4 bc ff ff       	call   c01003f2 <__panic>
    list_add(tail, &(base->page_link));
c010471e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104721:	8d 50 0c             	lea    0xc(%eax),%edx
c0104724:	a1 38 9a 11 c0       	mov    0xc0119a38,%eax
c0104729:	89 45 d8             	mov    %eax,-0x28(%ebp)
c010472c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010472f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104732:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104735:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104738:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c010473b:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010473e:	8b 40 04             	mov    0x4(%eax),%eax
c0104741:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104744:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0104747:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010474a:	89 55 c4             	mov    %edx,-0x3c(%ebp)
c010474d:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0104750:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104753:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0104756:	89 10                	mov    %edx,(%eax)
c0104758:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010475b:	8b 10                	mov    (%eax),%edx
c010475d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104760:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104763:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104766:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0104769:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010476c:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010476f:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0104772:	89 10                	mov    %edx,(%eax)
	tail = tail->next;
c0104774:	a1 38 9a 11 c0       	mov    0xc0119a38,%eax
c0104779:	8b 40 04             	mov    0x4(%eax),%eax
c010477c:	a3 38 9a 11 c0       	mov    %eax,0xc0119a38
}
c0104781:	90                   	nop
c0104782:	c9                   	leave  
c0104783:	c3                   	ret    

c0104784 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c0104784:	55                   	push   %ebp
c0104785:	89 e5                	mov    %esp,%ebp
c0104787:	83 ec 78             	sub    $0x78,%esp
    assert(n > 0);
c010478a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010478e:	75 24                	jne    c01047b4 <default_alloc_pages+0x30>
c0104790:	c7 44 24 0c 98 71 10 	movl   $0xc0107198,0xc(%esp)
c0104797:	c0 
c0104798:	c7 44 24 08 9e 71 10 	movl   $0xc010719e,0x8(%esp)
c010479f:	c0 
c01047a0:	c7 44 24 04 87 00 00 	movl   $0x87,0x4(%esp)
c01047a7:	00 
c01047a8:	c7 04 24 b3 71 10 c0 	movl   $0xc01071b3,(%esp)
c01047af:	e8 3e bc ff ff       	call   c01003f2 <__panic>
	/* There are not enough physical memory */
    if (n > nr_free) {
c01047b4:	a1 44 cf 11 c0       	mov    0xc011cf44,%eax
c01047b9:	39 45 08             	cmp    %eax,0x8(%ebp)
c01047bc:	76 26                	jbe    c01047e4 <default_alloc_pages+0x60>
		warn("memory shortage");
c01047be:	c7 44 24 08 1b 72 10 	movl   $0xc010721b,0x8(%esp)
c01047c5:	c0 
c01047c6:	c7 44 24 04 8a 00 00 	movl   $0x8a,0x4(%esp)
c01047cd:	00 
c01047ce:	c7 04 24 b3 71 10 c0 	movl   $0xc01071b3,(%esp)
c01047d5:	e8 96 bc ff ff       	call   c0100470 <__warn>
        return NULL;
c01047da:	b8 00 00 00 00       	mov    $0x0,%eax
c01047df:	e9 d6 01 00 00       	jmp    c01049ba <default_alloc_pages+0x236>
    }
    struct Page *page = NULL;
c01047e4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c01047eb:	c7 45 f0 3c cf 11 c0 	movl   $0xc011cf3c,-0x10(%ebp)
	/* try to find empty space to allocate */
    while ((le = list_next(le)) != &free_list) {
c01047f2:	eb 1c                	jmp    c0104810 <default_alloc_pages+0x8c>
        struct Page *p = le2page(le, page_link);
c01047f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01047f7:	83 e8 0c             	sub    $0xc,%eax
c01047fa:	89 45 e8             	mov    %eax,-0x18(%ebp)
        if (p->property >= n) {
c01047fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104800:	8b 40 08             	mov    0x8(%eax),%eax
c0104803:	39 45 08             	cmp    %eax,0x8(%ebp)
c0104806:	77 08                	ja     c0104810 <default_alloc_pages+0x8c>
            page = p;
c0104808:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010480b:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c010480e:	eb 18                	jmp    c0104828 <default_alloc_pages+0xa4>
c0104810:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104813:	89 45 dc             	mov    %eax,-0x24(%ebp)
    return listelm->next;
c0104816:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104819:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c010481c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010481f:	81 7d f0 3c cf 11 c0 	cmpl   $0xc011cf3c,-0x10(%ebp)
c0104826:	75 cc                	jne    c01047f4 <default_alloc_pages+0x70>
        }
    }
	/* external fragmentation */
	if (page == NULL) {
c0104828:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010482c:	75 26                	jne    c0104854 <default_alloc_pages+0xd0>
		warn("external fragmentation: There are enough memory, but can't find continuous space to allocate");
c010482e:	c7 44 24 08 2c 72 10 	movl   $0xc010722c,0x8(%esp)
c0104835:	c0 
c0104836:	c7 44 24 04 99 00 00 	movl   $0x99,0x4(%esp)
c010483d:	00 
c010483e:	c7 04 24 b3 71 10 c0 	movl   $0xc01071b3,(%esp)
c0104845:	e8 26 bc ff ff       	call   c0100470 <__warn>
		return NULL;
c010484a:	b8 00 00 00 00       	mov    $0x0,%eax
c010484f:	e9 66 01 00 00       	jmp    c01049ba <default_alloc_pages+0x236>
	}
	/* There are enough space to allocate.
	 * If block size is bigger than requested size, split it;
	 * If block size is equal to requested size, just delte it from free_list.
	 * */
    if (page != NULL) {
c0104854:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104858:	0f 84 59 01 00 00    	je     c01049b7 <default_alloc_pages+0x233>
        /* list_del(&(page->page_link)); */
		list_entry_t *temp = (page->page_link).prev;
c010485e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104861:	8b 40 0c             	mov    0xc(%eax),%eax
c0104864:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		list_del_init(&(page->page_link));
c0104867:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010486a:	83 c0 0c             	add    $0xc,%eax
c010486d:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0104870:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104873:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    __list_del(listelm->prev, listelm->next);
c0104876:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104879:	8b 40 04             	mov    0x4(%eax),%eax
c010487c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010487f:	8b 12                	mov    (%edx),%edx
c0104881:	89 55 d0             	mov    %edx,-0x30(%ebp)
c0104884:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0104887:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010488a:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010488d:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0104890:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104893:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104896:	89 10                	mov    %edx,(%eax)
c0104898:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010489b:	89 45 c8             	mov    %eax,-0x38(%ebp)
    elm->prev = elm->next = elm;
c010489e:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01048a1:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01048a4:	89 50 04             	mov    %edx,0x4(%eax)
c01048a7:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01048aa:	8b 50 04             	mov    0x4(%eax),%edx
c01048ad:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01048b0:	89 10                	mov    %edx,(%eax)
        if (page->property > n) {
c01048b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048b5:	8b 40 08             	mov    0x8(%eax),%eax
c01048b8:	39 45 08             	cmp    %eax,0x8(%ebp)
c01048bb:	73 70                	jae    c010492d <default_alloc_pages+0x1a9>
            struct Page *p = page + n;
c01048bd:	8b 55 08             	mov    0x8(%ebp),%edx
c01048c0:	89 d0                	mov    %edx,%eax
c01048c2:	c1 e0 02             	shl    $0x2,%eax
c01048c5:	01 d0                	add    %edx,%eax
c01048c7:	c1 e0 02             	shl    $0x2,%eax
c01048ca:	89 c2                	mov    %eax,%edx
c01048cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048cf:	01 d0                	add    %edx,%eax
c01048d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
            p->property = page->property - n;
c01048d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048d7:	8b 40 08             	mov    0x8(%eax),%eax
c01048da:	2b 45 08             	sub    0x8(%ebp),%eax
c01048dd:	89 c2                	mov    %eax,%edx
c01048df:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01048e2:	89 50 08             	mov    %edx,0x8(%eax)
			// Property is set when initialize Page
            list_add_after(temp, &(p->page_link));
c01048e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01048e8:	8d 50 0c             	lea    0xc(%eax),%edx
c01048eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01048ee:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c01048f1:	89 55 c0             	mov    %edx,-0x40(%ebp)
    __list_add(elm, listelm, listelm->next);
c01048f4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01048f7:	8b 40 04             	mov    0x4(%eax),%eax
c01048fa:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01048fd:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0104900:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0104903:	89 55 b8             	mov    %edx,-0x48(%ebp)
c0104906:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    prev->next = next->prev = elm;
c0104909:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010490c:	8b 55 bc             	mov    -0x44(%ebp),%edx
c010490f:	89 10                	mov    %edx,(%eax)
c0104911:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104914:	8b 10                	mov    (%eax),%edx
c0104916:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104919:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010491c:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010491f:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0104922:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104925:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104928:	8b 55 b8             	mov    -0x48(%ebp),%edx
c010492b:	89 10                	mov    %edx,(%eax)
		}
		/* modify pages in allocated block(except of first page)*/
		struct Page *p = page + 1;
c010492d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104930:	83 c0 14             	add    $0x14,%eax
c0104933:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for (; p < page + n; ++p) {
c0104936:	eb 2a                	jmp    c0104962 <default_alloc_pages+0x1de>
			ClearPageProperty(p);
c0104938:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010493b:	83 c0 04             	add    $0x4,%eax
c010493e:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
c0104945:	89 45 ac             	mov    %eax,-0x54(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104948:	8b 45 ac             	mov    -0x54(%ebp),%eax
c010494b:	8b 55 b0             	mov    -0x50(%ebp),%edx
c010494e:	0f b3 10             	btr    %edx,(%eax)
			++(p->ref);
c0104951:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104954:	8b 00                	mov    (%eax),%eax
c0104956:	8d 50 01             	lea    0x1(%eax),%edx
c0104959:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010495c:	89 10                	mov    %edx,(%eax)
		for (; p < page + n; ++p) {
c010495e:	83 45 ec 14          	addl   $0x14,-0x14(%ebp)
c0104962:	8b 55 08             	mov    0x8(%ebp),%edx
c0104965:	89 d0                	mov    %edx,%eax
c0104967:	c1 e0 02             	shl    $0x2,%eax
c010496a:	01 d0                	add    %edx,%eax
c010496c:	c1 e0 02             	shl    $0x2,%eax
c010496f:	89 c2                	mov    %eax,%edx
c0104971:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104974:	01 d0                	add    %edx,%eax
c0104976:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0104979:	72 bd                	jb     c0104938 <default_alloc_pages+0x1b4>
			// property is zero, so we needn't modiry it.
		}
		/* modify first page of allcoated block */
        ClearPageProperty(page);
c010497b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010497e:	83 c0 04             	add    $0x4,%eax
c0104981:	c7 45 a8 01 00 00 00 	movl   $0x1,-0x58(%ebp)
c0104988:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c010498b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c010498e:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0104991:	0f b3 10             	btr    %edx,(%eax)
		page->property = n;
c0104994:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104997:	8b 55 08             	mov    0x8(%ebp),%edx
c010499a:	89 50 08             	mov    %edx,0x8(%eax)
		++(page->ref);
c010499d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049a0:	8b 00                	mov    (%eax),%eax
c01049a2:	8d 50 01             	lea    0x1(%eax),%edx
c01049a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049a8:	89 10                	mov    %edx,(%eax)
        nr_free -= n;
c01049aa:	a1 44 cf 11 c0       	mov    0xc011cf44,%eax
c01049af:	2b 45 08             	sub    0x8(%ebp),%eax
c01049b2:	a3 44 cf 11 c0       	mov    %eax,0xc011cf44
    }
    return page;
c01049b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01049ba:	c9                   	leave  
c01049bb:	c3                   	ret    

c01049bc <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c01049bc:	55                   	push   %ebp
c01049bd:	89 e5                	mov    %esp,%ebp
c01049bf:	81 ec a8 00 00 00    	sub    $0xa8,%esp
    assert(n > 0);
c01049c5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01049c9:	75 24                	jne    c01049ef <default_free_pages+0x33>
c01049cb:	c7 44 24 0c 98 71 10 	movl   $0xc0107198,0xc(%esp)
c01049d2:	c0 
c01049d3:	c7 44 24 08 9e 71 10 	movl   $0xc010719e,0x8(%esp)
c01049da:	c0 
c01049db:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c01049e2:	00 
c01049e3:	c7 04 24 b3 71 10 c0 	movl   $0xc01071b3,(%esp)
c01049ea:	e8 03 ba ff ff       	call   c01003f2 <__panic>
	assert(n == base->property);
c01049ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01049f2:	8b 40 08             	mov    0x8(%eax),%eax
c01049f5:	39 45 0c             	cmp    %eax,0xc(%ebp)
c01049f8:	74 24                	je     c0104a1e <default_free_pages+0x62>
c01049fa:	c7 44 24 0c 89 72 10 	movl   $0xc0107289,0xc(%esp)
c0104a01:	c0 
c0104a02:	c7 44 24 08 9e 71 10 	movl   $0xc010719e,0x8(%esp)
c0104a09:	c0 
c0104a0a:	c7 44 24 04 bd 00 00 	movl   $0xbd,0x4(%esp)
c0104a11:	00 
c0104a12:	c7 04 24 b3 71 10 c0 	movl   $0xc01071b3,(%esp)
c0104a19:	e8 d4 b9 ff ff       	call   c01003f2 <__panic>
    struct Page *p = base;
c0104a1e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104a21:	89 45 f4             	mov    %eax,-0xc(%ebp)
	/* revert status information */
    for (; p != base + n; p ++) {
c0104a24:	e9 b6 00 00 00       	jmp    c0104adf <default_free_pages+0x123>
		/* p->property and p->page_link needn't change */
        assert(!PageReserved(p) && !PageProperty(p));
c0104a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a2c:	83 c0 04             	add    $0x4,%eax
c0104a2f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0104a36:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104a39:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104a3c:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104a3f:	0f a3 10             	bt     %edx,(%eax)
c0104a42:	19 c0                	sbb    %eax,%eax
c0104a44:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c0104a47:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104a4b:	0f 95 c0             	setne  %al
c0104a4e:	0f b6 c0             	movzbl %al,%eax
c0104a51:	85 c0                	test   %eax,%eax
c0104a53:	75 2c                	jne    c0104a81 <default_free_pages+0xc5>
c0104a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a58:	83 c0 04             	add    $0x4,%eax
c0104a5b:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c0104a62:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104a65:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104a68:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104a6b:	0f a3 10             	bt     %edx,(%eax)
c0104a6e:	19 c0                	sbb    %eax,%eax
c0104a70:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
c0104a73:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0104a77:	0f 95 c0             	setne  %al
c0104a7a:	0f b6 c0             	movzbl %al,%eax
c0104a7d:	85 c0                	test   %eax,%eax
c0104a7f:	74 24                	je     c0104aa5 <default_free_pages+0xe9>
c0104a81:	c7 44 24 0c a0 72 10 	movl   $0xc01072a0,0xc(%esp)
c0104a88:	c0 
c0104a89:	c7 44 24 08 9e 71 10 	movl   $0xc010719e,0x8(%esp)
c0104a90:	c0 
c0104a91:	c7 44 24 04 c2 00 00 	movl   $0xc2,0x4(%esp)
c0104a98:	00 
c0104a99:	c7 04 24 b3 71 10 c0 	movl   $0xc01071b3,(%esp)
c0104aa0:	e8 4d b9 ff ff       	call   c01003f2 <__panic>
        p->flags = 0;
c0104aa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104aa8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
		SetPageProperty(p);
c0104aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ab2:	83 c0 04             	add    $0x4,%eax
c0104ab5:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0104abc:	89 45 d0             	mov    %eax,-0x30(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104abf:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104ac2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104ac5:	0f ab 10             	bts    %edx,(%eax)
        set_page_ref(p, 0);
c0104ac8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104acf:	00 
c0104ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ad3:	89 04 24             	mov    %eax,(%esp)
c0104ad6:	e8 6d fa ff ff       	call   c0104548 <set_page_ref>
    for (; p != base + n; p ++) {
c0104adb:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0104adf:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104ae2:	89 d0                	mov    %edx,%eax
c0104ae4:	c1 e0 02             	shl    $0x2,%eax
c0104ae7:	01 d0                	add    %edx,%eax
c0104ae9:	c1 e0 02             	shl    $0x2,%eax
c0104aec:	89 c2                	mov    %eax,%edx
c0104aee:	8b 45 08             	mov    0x8(%ebp),%eax
c0104af1:	01 d0                	add    %edx,%eax
c0104af3:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104af6:	0f 85 2d ff ff ff    	jne    c0104a29 <default_free_pages+0x6d>
    /*         list_del(&(p->page_link)); */
    /*     } */
    /* } */

	/* if the adjacent block(next to block being freed) is free, merge the free block and the block being freed into one new free block*/
	p = base + base->property;
c0104afc:	8b 45 08             	mov    0x8(%ebp),%eax
c0104aff:	8b 50 08             	mov    0x8(%eax),%edx
c0104b02:	89 d0                	mov    %edx,%eax
c0104b04:	c1 e0 02             	shl    $0x2,%eax
c0104b07:	01 d0                	add    %edx,%eax
c0104b09:	c1 e0 02             	shl    $0x2,%eax
c0104b0c:	89 c2                	mov    %eax,%edx
c0104b0e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b11:	01 d0                	add    %edx,%eax
c0104b13:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (!PageReserved(p) && PageProperty(p)) {
c0104b16:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b19:	83 c0 04             	add    $0x4,%eax
c0104b1c:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
c0104b23:	89 45 c8             	mov    %eax,-0x38(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104b26:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104b29:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104b2c:	0f a3 10             	bt     %edx,(%eax)
c0104b2f:	19 c0                	sbb    %eax,%eax
c0104b31:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return oldbit != 0;
c0104b34:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
c0104b38:	0f 95 c0             	setne  %al
c0104b3b:	0f b6 c0             	movzbl %al,%eax
c0104b3e:	85 c0                	test   %eax,%eax
c0104b40:	0f 85 e3 00 00 00    	jne    c0104c29 <default_free_pages+0x26d>
c0104b46:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b49:	83 c0 04             	add    $0x4,%eax
c0104b4c:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0104b53:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104b56:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104b59:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0104b5c:	0f a3 10             	bt     %edx,(%eax)
c0104b5f:	19 c0                	sbb    %eax,%eax
c0104b61:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0104b64:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0104b68:	0f 95 c0             	setne  %al
c0104b6b:	0f b6 c0             	movzbl %al,%eax
c0104b6e:	85 c0                	test   %eax,%eax
c0104b70:	0f 84 b3 00 00 00    	je     c0104c29 <default_free_pages+0x26d>
		base->property += p->property;
c0104b76:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b79:	8b 50 08             	mov    0x8(%eax),%edx
c0104b7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b7f:	8b 40 08             	mov    0x8(%eax),%eax
c0104b82:	01 c2                	add    %eax,%edx
c0104b84:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b87:	89 50 08             	mov    %edx,0x8(%eax)
		p->property = 0;
c0104b8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b8d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	
		/* add new free block(pointed by #base) into free_list and delete merged block(pointed by #p) */
		assert((p->page_link).prev < &(base->page_link));
c0104b94:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b97:	8b 40 0c             	mov    0xc(%eax),%eax
c0104b9a:	8b 55 08             	mov    0x8(%ebp),%edx
c0104b9d:	83 c2 0c             	add    $0xc,%edx
c0104ba0:	39 d0                	cmp    %edx,%eax
c0104ba2:	72 24                	jb     c0104bc8 <default_free_pages+0x20c>
c0104ba4:	c7 44 24 0c c8 72 10 	movl   $0xc01072c8,0xc(%esp)
c0104bab:	c0 
c0104bac:	c7 44 24 08 9e 71 10 	movl   $0xc010719e,0x8(%esp)
c0104bb3:	c0 
c0104bb4:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
c0104bbb:	00 
c0104bbc:	c7 04 24 b3 71 10 c0 	movl   $0xc01071b3,(%esp)
c0104bc3:	e8 2a b8 ff ff       	call   c01003f2 <__panic>
		__list_add(&(base->page_link), (p->page_link).prev, (p->page_link).next);
c0104bc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104bcb:	8b 40 10             	mov    0x10(%eax),%eax
c0104bce:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104bd1:	8b 52 0c             	mov    0xc(%edx),%edx
c0104bd4:	8b 4d 08             	mov    0x8(%ebp),%ecx
c0104bd7:	83 c1 0c             	add    $0xc,%ecx
c0104bda:	89 4d b0             	mov    %ecx,-0x50(%ebp)
c0104bdd:	89 55 ac             	mov    %edx,-0x54(%ebp)
c0104be0:	89 45 a8             	mov    %eax,-0x58(%ebp)
    prev->next = next->prev = elm;
c0104be3:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104be6:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0104be9:	89 10                	mov    %edx,(%eax)
c0104beb:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104bee:	8b 10                	mov    (%eax),%edx
c0104bf0:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0104bf3:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104bf6:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104bf9:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0104bfc:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104bff:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104c02:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0104c05:	89 10                	mov    %edx,(%eax)
		list_init(&(p->page_link));	
c0104c07:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c0a:	83 c0 0c             	add    $0xc,%eax
c0104c0d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    elm->prev = elm->next = elm;
c0104c10:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104c13:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0104c16:	89 50 04             	mov    %edx,0x4(%eax)
c0104c19:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104c1c:	8b 50 04             	mov    0x4(%eax),%edx
c0104c1f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104c22:	89 10                	mov    %edx,(%eax)
c0104c24:	e9 14 01 00 00       	jmp    c0104d3d <default_free_pages+0x381>
	}
	/* if the adjacent block is not free, find appropriate position and inset the block into free_list */
	else if (!PageReserved(p) && !PageProperty(p)) {
c0104c29:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c2c:	83 c0 04             	add    $0x4,%eax
c0104c2f:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
c0104c36:	89 45 a0             	mov    %eax,-0x60(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104c39:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104c3c:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0104c3f:	0f a3 10             	bt     %edx,(%eax)
c0104c42:	19 c0                	sbb    %eax,%eax
c0104c44:	89 45 9c             	mov    %eax,-0x64(%ebp)
    return oldbit != 0;
c0104c47:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
c0104c4b:	0f 95 c0             	setne  %al
c0104c4e:	0f b6 c0             	movzbl %al,%eax
c0104c51:	85 c0                	test   %eax,%eax
c0104c53:	0f 85 e4 00 00 00    	jne    c0104d3d <default_free_pages+0x381>
c0104c59:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c5c:	83 c0 04             	add    $0x4,%eax
c0104c5f:	c7 45 98 01 00 00 00 	movl   $0x1,-0x68(%ebp)
c0104c66:	89 45 94             	mov    %eax,-0x6c(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104c69:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0104c6c:	8b 55 98             	mov    -0x68(%ebp),%edx
c0104c6f:	0f a3 10             	bt     %edx,(%eax)
c0104c72:	19 c0                	sbb    %eax,%eax
c0104c74:	89 45 90             	mov    %eax,-0x70(%ebp)
    return oldbit != 0;
c0104c77:	83 7d 90 00          	cmpl   $0x0,-0x70(%ebp)
c0104c7b:	0f 95 c0             	setne  %al
c0104c7e:	0f b6 c0             	movzbl %al,%eax
c0104c81:	85 c0                	test   %eax,%eax
c0104c83:	0f 85 b4 00 00 00    	jne    c0104d3d <default_free_pages+0x381>
c0104c89:	c7 45 8c 3c cf 11 c0 	movl   $0xc011cf3c,-0x74(%ebp)
    return listelm->next;
c0104c90:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0104c93:	8b 40 04             	mov    0x4(%eax),%eax
		list_entry_t *pl = list_next(&free_list);
c0104c96:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (; pl != &free_list; pl = list_next(pl)) {
c0104c99:	eb 2a                	jmp    c0104cc5 <default_free_pages+0x309>
			if (pl > &(base->page_link)) {
c0104c9b:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c9e:	83 c0 0c             	add    $0xc,%eax
c0104ca1:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0104ca4:	76 10                	jbe    c0104cb6 <default_free_pages+0x2fa>
c0104ca6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ca9:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->prev;
c0104cac:	8b 45 88             	mov    -0x78(%ebp),%eax
c0104caf:	8b 00                	mov    (%eax),%eax
				pl = list_prev(pl);
c0104cb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
				break;
c0104cb4:	eb 18                	jmp    c0104cce <default_free_pages+0x312>
c0104cb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104cb9:	89 45 84             	mov    %eax,-0x7c(%ebp)
    return listelm->next;
c0104cbc:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0104cbf:	8b 40 04             	mov    0x4(%eax),%eax
		for (; pl != &free_list; pl = list_next(pl)) {
c0104cc2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104cc5:	81 7d f0 3c cf 11 c0 	cmpl   $0xc011cf3c,-0x10(%ebp)
c0104ccc:	75 cd                	jne    c0104c9b <default_free_pages+0x2df>
			}
		}
		list_add_after(pl, &(base->page_link));
c0104cce:	8b 45 08             	mov    0x8(%ebp),%eax
c0104cd1:	8d 50 0c             	lea    0xc(%eax),%edx
c0104cd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104cd7:	89 45 80             	mov    %eax,-0x80(%ebp)
c0104cda:	89 95 7c ff ff ff    	mov    %edx,-0x84(%ebp)
    __list_add(elm, listelm, listelm->next);
c0104ce0:	8b 45 80             	mov    -0x80(%ebp),%eax
c0104ce3:	8b 40 04             	mov    0x4(%eax),%eax
c0104ce6:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
c0104cec:	89 95 78 ff ff ff    	mov    %edx,-0x88(%ebp)
c0104cf2:	8b 55 80             	mov    -0x80(%ebp),%edx
c0104cf5:	89 95 74 ff ff ff    	mov    %edx,-0x8c(%ebp)
c0104cfb:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
    prev->next = next->prev = elm;
c0104d01:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
c0104d07:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
c0104d0d:	89 10                	mov    %edx,(%eax)
c0104d0f:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
c0104d15:	8b 10                	mov    (%eax),%edx
c0104d17:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
c0104d1d:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104d20:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
c0104d26:	8b 95 70 ff ff ff    	mov    -0x90(%ebp),%edx
c0104d2c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104d2f:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
c0104d35:	8b 95 74 ff ff ff    	mov    -0x8c(%ebp),%edx
c0104d3b:	89 10                	mov    %edx,(%eax)
	}
    nr_free += n;
c0104d3d:	8b 15 44 cf 11 c0    	mov    0xc011cf44,%edx
c0104d43:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104d46:	01 d0                	add    %edx,%eax
c0104d48:	a3 44 cf 11 c0       	mov    %eax,0xc011cf44
}
c0104d4d:	90                   	nop
c0104d4e:	c9                   	leave  
c0104d4f:	c3                   	ret    

c0104d50 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0104d50:	55                   	push   %ebp
c0104d51:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0104d53:	a1 44 cf 11 c0       	mov    0xc011cf44,%eax
}
c0104d58:	5d                   	pop    %ebp
c0104d59:	c3                   	ret    

c0104d5a <basic_check>:

static void
basic_check(void) {
c0104d5a:	55                   	push   %ebp
c0104d5b:	89 e5                	mov    %esp,%ebp
c0104d5d:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0104d60:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104d67:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104d6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d70:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0104d73:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104d7a:	e8 91 e2 ff ff       	call   c0103010 <alloc_pages>
c0104d7f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104d82:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104d86:	75 24                	jne    c0104dac <basic_check+0x52>
c0104d88:	c7 44 24 0c f1 72 10 	movl   $0xc01072f1,0xc(%esp)
c0104d8f:	c0 
c0104d90:	c7 44 24 08 9e 71 10 	movl   $0xc010719e,0x8(%esp)
c0104d97:	c0 
c0104d98:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c0104d9f:	00 
c0104da0:	c7 04 24 b3 71 10 c0 	movl   $0xc01071b3,(%esp)
c0104da7:	e8 46 b6 ff ff       	call   c01003f2 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0104dac:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104db3:	e8 58 e2 ff ff       	call   c0103010 <alloc_pages>
c0104db8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104dbb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104dbf:	75 24                	jne    c0104de5 <basic_check+0x8b>
c0104dc1:	c7 44 24 0c 0d 73 10 	movl   $0xc010730d,0xc(%esp)
c0104dc8:	c0 
c0104dc9:	c7 44 24 08 9e 71 10 	movl   $0xc010719e,0x8(%esp)
c0104dd0:	c0 
c0104dd1:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
c0104dd8:	00 
c0104dd9:	c7 04 24 b3 71 10 c0 	movl   $0xc01071b3,(%esp)
c0104de0:	e8 0d b6 ff ff       	call   c01003f2 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0104de5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104dec:	e8 1f e2 ff ff       	call   c0103010 <alloc_pages>
c0104df1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104df4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104df8:	75 24                	jne    c0104e1e <basic_check+0xc4>
c0104dfa:	c7 44 24 0c 29 73 10 	movl   $0xc0107329,0xc(%esp)
c0104e01:	c0 
c0104e02:	c7 44 24 08 9e 71 10 	movl   $0xc010719e,0x8(%esp)
c0104e09:	c0 
c0104e0a:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
c0104e11:	00 
c0104e12:	c7 04 24 b3 71 10 c0 	movl   $0xc01071b3,(%esp)
c0104e19:	e8 d4 b5 ff ff       	call   c01003f2 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0104e1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104e21:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104e24:	74 10                	je     c0104e36 <basic_check+0xdc>
c0104e26:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104e29:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104e2c:	74 08                	je     c0104e36 <basic_check+0xdc>
c0104e2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e31:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104e34:	75 24                	jne    c0104e5a <basic_check+0x100>
c0104e36:	c7 44 24 0c 48 73 10 	movl   $0xc0107348,0xc(%esp)
c0104e3d:	c0 
c0104e3e:	c7 44 24 08 9e 71 10 	movl   $0xc010719e,0x8(%esp)
c0104e45:	c0 
c0104e46:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
c0104e4d:	00 
c0104e4e:	c7 04 24 b3 71 10 c0 	movl   $0xc01071b3,(%esp)
c0104e55:	e8 98 b5 ff ff       	call   c01003f2 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0104e5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104e5d:	89 04 24             	mov    %eax,(%esp)
c0104e60:	e8 d9 f6 ff ff       	call   c010453e <page_ref>
c0104e65:	85 c0                	test   %eax,%eax
c0104e67:	75 1e                	jne    c0104e87 <basic_check+0x12d>
c0104e69:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e6c:	89 04 24             	mov    %eax,(%esp)
c0104e6f:	e8 ca f6 ff ff       	call   c010453e <page_ref>
c0104e74:	85 c0                	test   %eax,%eax
c0104e76:	75 0f                	jne    c0104e87 <basic_check+0x12d>
c0104e78:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e7b:	89 04 24             	mov    %eax,(%esp)
c0104e7e:	e8 bb f6 ff ff       	call   c010453e <page_ref>
c0104e83:	85 c0                	test   %eax,%eax
c0104e85:	74 24                	je     c0104eab <basic_check+0x151>
c0104e87:	c7 44 24 0c 6c 73 10 	movl   $0xc010736c,0xc(%esp)
c0104e8e:	c0 
c0104e8f:	c7 44 24 08 9e 71 10 	movl   $0xc010719e,0x8(%esp)
c0104e96:	c0 
c0104e97:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c0104e9e:	00 
c0104e9f:	c7 04 24 b3 71 10 c0 	movl   $0xc01071b3,(%esp)
c0104ea6:	e8 47 b5 ff ff       	call   c01003f2 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0104eab:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104eae:	89 04 24             	mov    %eax,(%esp)
c0104eb1:	e8 72 f6 ff ff       	call   c0104528 <page2pa>
c0104eb6:	8b 15 a0 ce 11 c0    	mov    0xc011cea0,%edx
c0104ebc:	c1 e2 0c             	shl    $0xc,%edx
c0104ebf:	39 d0                	cmp    %edx,%eax
c0104ec1:	72 24                	jb     c0104ee7 <basic_check+0x18d>
c0104ec3:	c7 44 24 0c a8 73 10 	movl   $0xc01073a8,0xc(%esp)
c0104eca:	c0 
c0104ecb:	c7 44 24 08 9e 71 10 	movl   $0xc010719e,0x8(%esp)
c0104ed2:	c0 
c0104ed3:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
c0104eda:	00 
c0104edb:	c7 04 24 b3 71 10 c0 	movl   $0xc01071b3,(%esp)
c0104ee2:	e8 0b b5 ff ff       	call   c01003f2 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0104ee7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104eea:	89 04 24             	mov    %eax,(%esp)
c0104eed:	e8 36 f6 ff ff       	call   c0104528 <page2pa>
c0104ef2:	8b 15 a0 ce 11 c0    	mov    0xc011cea0,%edx
c0104ef8:	c1 e2 0c             	shl    $0xc,%edx
c0104efb:	39 d0                	cmp    %edx,%eax
c0104efd:	72 24                	jb     c0104f23 <basic_check+0x1c9>
c0104eff:	c7 44 24 0c c5 73 10 	movl   $0xc01073c5,0xc(%esp)
c0104f06:	c0 
c0104f07:	c7 44 24 08 9e 71 10 	movl   $0xc010719e,0x8(%esp)
c0104f0e:	c0 
c0104f0f:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
c0104f16:	00 
c0104f17:	c7 04 24 b3 71 10 c0 	movl   $0xc01071b3,(%esp)
c0104f1e:	e8 cf b4 ff ff       	call   c01003f2 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0104f23:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f26:	89 04 24             	mov    %eax,(%esp)
c0104f29:	e8 fa f5 ff ff       	call   c0104528 <page2pa>
c0104f2e:	8b 15 a0 ce 11 c0    	mov    0xc011cea0,%edx
c0104f34:	c1 e2 0c             	shl    $0xc,%edx
c0104f37:	39 d0                	cmp    %edx,%eax
c0104f39:	72 24                	jb     c0104f5f <basic_check+0x205>
c0104f3b:	c7 44 24 0c e2 73 10 	movl   $0xc01073e2,0xc(%esp)
c0104f42:	c0 
c0104f43:	c7 44 24 08 9e 71 10 	movl   $0xc010719e,0x8(%esp)
c0104f4a:	c0 
c0104f4b:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c0104f52:	00 
c0104f53:	c7 04 24 b3 71 10 c0 	movl   $0xc01071b3,(%esp)
c0104f5a:	e8 93 b4 ff ff       	call   c01003f2 <__panic>

    list_entry_t free_list_store = free_list;
c0104f5f:	a1 3c cf 11 c0       	mov    0xc011cf3c,%eax
c0104f64:	8b 15 40 cf 11 c0    	mov    0xc011cf40,%edx
c0104f6a:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104f6d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0104f70:	c7 45 dc 3c cf 11 c0 	movl   $0xc011cf3c,-0x24(%ebp)
    elm->prev = elm->next = elm;
c0104f77:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104f7a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104f7d:	89 50 04             	mov    %edx,0x4(%eax)
c0104f80:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104f83:	8b 50 04             	mov    0x4(%eax),%edx
c0104f86:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104f89:	89 10                	mov    %edx,(%eax)
c0104f8b:	c7 45 e0 3c cf 11 c0 	movl   $0xc011cf3c,-0x20(%ebp)
    return list->next == list;
c0104f92:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104f95:	8b 40 04             	mov    0x4(%eax),%eax
c0104f98:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0104f9b:	0f 94 c0             	sete   %al
c0104f9e:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0104fa1:	85 c0                	test   %eax,%eax
c0104fa3:	75 24                	jne    c0104fc9 <basic_check+0x26f>
c0104fa5:	c7 44 24 0c ff 73 10 	movl   $0xc01073ff,0xc(%esp)
c0104fac:	c0 
c0104fad:	c7 44 24 08 9e 71 10 	movl   $0xc010719e,0x8(%esp)
c0104fb4:	c0 
c0104fb5:	c7 44 24 04 08 01 00 	movl   $0x108,0x4(%esp)
c0104fbc:	00 
c0104fbd:	c7 04 24 b3 71 10 c0 	movl   $0xc01071b3,(%esp)
c0104fc4:	e8 29 b4 ff ff       	call   c01003f2 <__panic>

    unsigned int nr_free_store = nr_free;
c0104fc9:	a1 44 cf 11 c0       	mov    0xc011cf44,%eax
c0104fce:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0104fd1:	c7 05 44 cf 11 c0 00 	movl   $0x0,0xc011cf44
c0104fd8:	00 00 00 

    assert(alloc_page() == NULL);
c0104fdb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104fe2:	e8 29 e0 ff ff       	call   c0103010 <alloc_pages>
c0104fe7:	85 c0                	test   %eax,%eax
c0104fe9:	74 24                	je     c010500f <basic_check+0x2b5>
c0104feb:	c7 44 24 0c 16 74 10 	movl   $0xc0107416,0xc(%esp)
c0104ff2:	c0 
c0104ff3:	c7 44 24 08 9e 71 10 	movl   $0xc010719e,0x8(%esp)
c0104ffa:	c0 
c0104ffb:	c7 44 24 04 0d 01 00 	movl   $0x10d,0x4(%esp)
c0105002:	00 
c0105003:	c7 04 24 b3 71 10 c0 	movl   $0xc01071b3,(%esp)
c010500a:	e8 e3 b3 ff ff       	call   c01003f2 <__panic>

    free_page(p0);
c010500f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105016:	00 
c0105017:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010501a:	89 04 24             	mov    %eax,(%esp)
c010501d:	e8 26 e0 ff ff       	call   c0103048 <free_pages>
    free_page(p1);
c0105022:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105029:	00 
c010502a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010502d:	89 04 24             	mov    %eax,(%esp)
c0105030:	e8 13 e0 ff ff       	call   c0103048 <free_pages>
    free_page(p2);
c0105035:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010503c:	00 
c010503d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105040:	89 04 24             	mov    %eax,(%esp)
c0105043:	e8 00 e0 ff ff       	call   c0103048 <free_pages>
    assert(nr_free == 3);
c0105048:	a1 44 cf 11 c0       	mov    0xc011cf44,%eax
c010504d:	83 f8 03             	cmp    $0x3,%eax
c0105050:	74 24                	je     c0105076 <basic_check+0x31c>
c0105052:	c7 44 24 0c 2b 74 10 	movl   $0xc010742b,0xc(%esp)
c0105059:	c0 
c010505a:	c7 44 24 08 9e 71 10 	movl   $0xc010719e,0x8(%esp)
c0105061:	c0 
c0105062:	c7 44 24 04 12 01 00 	movl   $0x112,0x4(%esp)
c0105069:	00 
c010506a:	c7 04 24 b3 71 10 c0 	movl   $0xc01071b3,(%esp)
c0105071:	e8 7c b3 ff ff       	call   c01003f2 <__panic>

    assert((p0 = alloc_page()) != NULL);
c0105076:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010507d:	e8 8e df ff ff       	call   c0103010 <alloc_pages>
c0105082:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105085:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0105089:	75 24                	jne    c01050af <basic_check+0x355>
c010508b:	c7 44 24 0c f1 72 10 	movl   $0xc01072f1,0xc(%esp)
c0105092:	c0 
c0105093:	c7 44 24 08 9e 71 10 	movl   $0xc010719e,0x8(%esp)
c010509a:	c0 
c010509b:	c7 44 24 04 14 01 00 	movl   $0x114,0x4(%esp)
c01050a2:	00 
c01050a3:	c7 04 24 b3 71 10 c0 	movl   $0xc01071b3,(%esp)
c01050aa:	e8 43 b3 ff ff       	call   c01003f2 <__panic>
    assert((p1 = alloc_page()) != NULL);
c01050af:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01050b6:	e8 55 df ff ff       	call   c0103010 <alloc_pages>
c01050bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01050be:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01050c2:	75 24                	jne    c01050e8 <basic_check+0x38e>
c01050c4:	c7 44 24 0c 0d 73 10 	movl   $0xc010730d,0xc(%esp)
c01050cb:	c0 
c01050cc:	c7 44 24 08 9e 71 10 	movl   $0xc010719e,0x8(%esp)
c01050d3:	c0 
c01050d4:	c7 44 24 04 15 01 00 	movl   $0x115,0x4(%esp)
c01050db:	00 
c01050dc:	c7 04 24 b3 71 10 c0 	movl   $0xc01071b3,(%esp)
c01050e3:	e8 0a b3 ff ff       	call   c01003f2 <__panic>
    assert((p2 = alloc_page()) != NULL);
c01050e8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01050ef:	e8 1c df ff ff       	call   c0103010 <alloc_pages>
c01050f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01050f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01050fb:	75 24                	jne    c0105121 <basic_check+0x3c7>
c01050fd:	c7 44 24 0c 29 73 10 	movl   $0xc0107329,0xc(%esp)
c0105104:	c0 
c0105105:	c7 44 24 08 9e 71 10 	movl   $0xc010719e,0x8(%esp)
c010510c:	c0 
c010510d:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c0105114:	00 
c0105115:	c7 04 24 b3 71 10 c0 	movl   $0xc01071b3,(%esp)
c010511c:	e8 d1 b2 ff ff       	call   c01003f2 <__panic>

    assert(alloc_page() == NULL);
c0105121:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105128:	e8 e3 de ff ff       	call   c0103010 <alloc_pages>
c010512d:	85 c0                	test   %eax,%eax
c010512f:	74 24                	je     c0105155 <basic_check+0x3fb>
c0105131:	c7 44 24 0c 16 74 10 	movl   $0xc0107416,0xc(%esp)
c0105138:	c0 
c0105139:	c7 44 24 08 9e 71 10 	movl   $0xc010719e,0x8(%esp)
c0105140:	c0 
c0105141:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
c0105148:	00 
c0105149:	c7 04 24 b3 71 10 c0 	movl   $0xc01071b3,(%esp)
c0105150:	e8 9d b2 ff ff       	call   c01003f2 <__panic>

    free_page(p0);
c0105155:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010515c:	00 
c010515d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105160:	89 04 24             	mov    %eax,(%esp)
c0105163:	e8 e0 de ff ff       	call   c0103048 <free_pages>
c0105168:	c7 45 d8 3c cf 11 c0 	movl   $0xc011cf3c,-0x28(%ebp)
c010516f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105172:	8b 40 04             	mov    0x4(%eax),%eax
c0105175:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0105178:	0f 94 c0             	sete   %al
c010517b:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c010517e:	85 c0                	test   %eax,%eax
c0105180:	74 24                	je     c01051a6 <basic_check+0x44c>
c0105182:	c7 44 24 0c 38 74 10 	movl   $0xc0107438,0xc(%esp)
c0105189:	c0 
c010518a:	c7 44 24 08 9e 71 10 	movl   $0xc010719e,0x8(%esp)
c0105191:	c0 
c0105192:	c7 44 24 04 1b 01 00 	movl   $0x11b,0x4(%esp)
c0105199:	00 
c010519a:	c7 04 24 b3 71 10 c0 	movl   $0xc01071b3,(%esp)
c01051a1:	e8 4c b2 ff ff       	call   c01003f2 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c01051a6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01051ad:	e8 5e de ff ff       	call   c0103010 <alloc_pages>
c01051b2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01051b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01051b8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01051bb:	74 24                	je     c01051e1 <basic_check+0x487>
c01051bd:	c7 44 24 0c 50 74 10 	movl   $0xc0107450,0xc(%esp)
c01051c4:	c0 
c01051c5:	c7 44 24 08 9e 71 10 	movl   $0xc010719e,0x8(%esp)
c01051cc:	c0 
c01051cd:	c7 44 24 04 1e 01 00 	movl   $0x11e,0x4(%esp)
c01051d4:	00 
c01051d5:	c7 04 24 b3 71 10 c0 	movl   $0xc01071b3,(%esp)
c01051dc:	e8 11 b2 ff ff       	call   c01003f2 <__panic>
    assert(alloc_page() == NULL);
c01051e1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01051e8:	e8 23 de ff ff       	call   c0103010 <alloc_pages>
c01051ed:	85 c0                	test   %eax,%eax
c01051ef:	74 24                	je     c0105215 <basic_check+0x4bb>
c01051f1:	c7 44 24 0c 16 74 10 	movl   $0xc0107416,0xc(%esp)
c01051f8:	c0 
c01051f9:	c7 44 24 08 9e 71 10 	movl   $0xc010719e,0x8(%esp)
c0105200:	c0 
c0105201:	c7 44 24 04 1f 01 00 	movl   $0x11f,0x4(%esp)
c0105208:	00 
c0105209:	c7 04 24 b3 71 10 c0 	movl   $0xc01071b3,(%esp)
c0105210:	e8 dd b1 ff ff       	call   c01003f2 <__panic>

    assert(nr_free == 0);
c0105215:	a1 44 cf 11 c0       	mov    0xc011cf44,%eax
c010521a:	85 c0                	test   %eax,%eax
c010521c:	74 24                	je     c0105242 <basic_check+0x4e8>
c010521e:	c7 44 24 0c 69 74 10 	movl   $0xc0107469,0xc(%esp)
c0105225:	c0 
c0105226:	c7 44 24 08 9e 71 10 	movl   $0xc010719e,0x8(%esp)
c010522d:	c0 
c010522e:	c7 44 24 04 21 01 00 	movl   $0x121,0x4(%esp)
c0105235:	00 
c0105236:	c7 04 24 b3 71 10 c0 	movl   $0xc01071b3,(%esp)
c010523d:	e8 b0 b1 ff ff       	call   c01003f2 <__panic>
    free_list = free_list_store;
c0105242:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105245:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105248:	a3 3c cf 11 c0       	mov    %eax,0xc011cf3c
c010524d:	89 15 40 cf 11 c0    	mov    %edx,0xc011cf40
    nr_free = nr_free_store;
c0105253:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105256:	a3 44 cf 11 c0       	mov    %eax,0xc011cf44

    free_page(p);
c010525b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105262:	00 
c0105263:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105266:	89 04 24             	mov    %eax,(%esp)
c0105269:	e8 da dd ff ff       	call   c0103048 <free_pages>
    free_page(p1);
c010526e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105275:	00 
c0105276:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105279:	89 04 24             	mov    %eax,(%esp)
c010527c:	e8 c7 dd ff ff       	call   c0103048 <free_pages>
    free_page(p2);
c0105281:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105288:	00 
c0105289:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010528c:	89 04 24             	mov    %eax,(%esp)
c010528f:	e8 b4 dd ff ff       	call   c0103048 <free_pages>
}
c0105294:	90                   	nop
c0105295:	c9                   	leave  
c0105296:	c3                   	ret    

c0105297 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0105297:	55                   	push   %ebp
c0105298:	89 e5                	mov    %esp,%ebp
c010529a:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
c01052a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01052a7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c01052ae:	c7 45 ec 3c cf 11 c0 	movl   $0xc011cf3c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01052b5:	eb 6a                	jmp    c0105321 <default_check+0x8a>
        struct Page *p = le2page(le, page_link);
c01052b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01052ba:	83 e8 0c             	sub    $0xc,%eax
c01052bd:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c01052c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01052c3:	83 c0 04             	add    $0x4,%eax
c01052c6:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c01052cd:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01052d0:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01052d3:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01052d6:	0f a3 10             	bt     %edx,(%eax)
c01052d9:	19 c0                	sbb    %eax,%eax
c01052db:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c01052de:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c01052e2:	0f 95 c0             	setne  %al
c01052e5:	0f b6 c0             	movzbl %al,%eax
c01052e8:	85 c0                	test   %eax,%eax
c01052ea:	75 24                	jne    c0105310 <default_check+0x79>
c01052ec:	c7 44 24 0c 76 74 10 	movl   $0xc0107476,0xc(%esp)
c01052f3:	c0 
c01052f4:	c7 44 24 08 9e 71 10 	movl   $0xc010719e,0x8(%esp)
c01052fb:	c0 
c01052fc:	c7 44 24 04 32 01 00 	movl   $0x132,0x4(%esp)
c0105303:	00 
c0105304:	c7 04 24 b3 71 10 c0 	movl   $0xc01071b3,(%esp)
c010530b:	e8 e2 b0 ff ff       	call   c01003f2 <__panic>
        count ++, total += p->property;
c0105310:	ff 45 f4             	incl   -0xc(%ebp)
c0105313:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105316:	8b 50 08             	mov    0x8(%eax),%edx
c0105319:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010531c:	01 d0                	add    %edx,%eax
c010531e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105321:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105324:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
c0105327:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010532a:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c010532d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105330:	81 7d ec 3c cf 11 c0 	cmpl   $0xc011cf3c,-0x14(%ebp)
c0105337:	0f 85 7a ff ff ff    	jne    c01052b7 <default_check+0x20>
    }
    assert(total == nr_free_pages());
c010533d:	e8 39 dd ff ff       	call   c010307b <nr_free_pages>
c0105342:	89 c2                	mov    %eax,%edx
c0105344:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105347:	39 c2                	cmp    %eax,%edx
c0105349:	74 24                	je     c010536f <default_check+0xd8>
c010534b:	c7 44 24 0c 86 74 10 	movl   $0xc0107486,0xc(%esp)
c0105352:	c0 
c0105353:	c7 44 24 08 9e 71 10 	movl   $0xc010719e,0x8(%esp)
c010535a:	c0 
c010535b:	c7 44 24 04 35 01 00 	movl   $0x135,0x4(%esp)
c0105362:	00 
c0105363:	c7 04 24 b3 71 10 c0 	movl   $0xc01071b3,(%esp)
c010536a:	e8 83 b0 ff ff       	call   c01003f2 <__panic>

    basic_check();
c010536f:	e8 e6 f9 ff ff       	call   c0104d5a <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0105374:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c010537b:	e8 90 dc ff ff       	call   c0103010 <alloc_pages>
c0105380:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c0105383:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105387:	75 24                	jne    c01053ad <default_check+0x116>
c0105389:	c7 44 24 0c 9f 74 10 	movl   $0xc010749f,0xc(%esp)
c0105390:	c0 
c0105391:	c7 44 24 08 9e 71 10 	movl   $0xc010719e,0x8(%esp)
c0105398:	c0 
c0105399:	c7 44 24 04 3a 01 00 	movl   $0x13a,0x4(%esp)
c01053a0:	00 
c01053a1:	c7 04 24 b3 71 10 c0 	movl   $0xc01071b3,(%esp)
c01053a8:	e8 45 b0 ff ff       	call   c01003f2 <__panic>
    assert(!PageProperty(p0));
c01053ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01053b0:	83 c0 04             	add    $0x4,%eax
c01053b3:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c01053ba:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01053bd:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01053c0:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01053c3:	0f a3 10             	bt     %edx,(%eax)
c01053c6:	19 c0                	sbb    %eax,%eax
c01053c8:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c01053cb:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c01053cf:	0f 95 c0             	setne  %al
c01053d2:	0f b6 c0             	movzbl %al,%eax
c01053d5:	85 c0                	test   %eax,%eax
c01053d7:	74 24                	je     c01053fd <default_check+0x166>
c01053d9:	c7 44 24 0c aa 74 10 	movl   $0xc01074aa,0xc(%esp)
c01053e0:	c0 
c01053e1:	c7 44 24 08 9e 71 10 	movl   $0xc010719e,0x8(%esp)
c01053e8:	c0 
c01053e9:	c7 44 24 04 3b 01 00 	movl   $0x13b,0x4(%esp)
c01053f0:	00 
c01053f1:	c7 04 24 b3 71 10 c0 	movl   $0xc01071b3,(%esp)
c01053f8:	e8 f5 af ff ff       	call   c01003f2 <__panic>

    list_entry_t free_list_store = free_list;
c01053fd:	a1 3c cf 11 c0       	mov    0xc011cf3c,%eax
c0105402:	8b 15 40 cf 11 c0    	mov    0xc011cf40,%edx
c0105408:	89 45 80             	mov    %eax,-0x80(%ebp)
c010540b:	89 55 84             	mov    %edx,-0x7c(%ebp)
c010540e:	c7 45 b0 3c cf 11 c0 	movl   $0xc011cf3c,-0x50(%ebp)
    elm->prev = elm->next = elm;
c0105415:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0105418:	8b 55 b0             	mov    -0x50(%ebp),%edx
c010541b:	89 50 04             	mov    %edx,0x4(%eax)
c010541e:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0105421:	8b 50 04             	mov    0x4(%eax),%edx
c0105424:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0105427:	89 10                	mov    %edx,(%eax)
c0105429:	c7 45 b4 3c cf 11 c0 	movl   $0xc011cf3c,-0x4c(%ebp)
    return list->next == list;
c0105430:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0105433:	8b 40 04             	mov    0x4(%eax),%eax
c0105436:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
c0105439:	0f 94 c0             	sete   %al
c010543c:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c010543f:	85 c0                	test   %eax,%eax
c0105441:	75 24                	jne    c0105467 <default_check+0x1d0>
c0105443:	c7 44 24 0c ff 73 10 	movl   $0xc01073ff,0xc(%esp)
c010544a:	c0 
c010544b:	c7 44 24 08 9e 71 10 	movl   $0xc010719e,0x8(%esp)
c0105452:	c0 
c0105453:	c7 44 24 04 3f 01 00 	movl   $0x13f,0x4(%esp)
c010545a:	00 
c010545b:	c7 04 24 b3 71 10 c0 	movl   $0xc01071b3,(%esp)
c0105462:	e8 8b af ff ff       	call   c01003f2 <__panic>
    assert(alloc_page() == NULL);
c0105467:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010546e:	e8 9d db ff ff       	call   c0103010 <alloc_pages>
c0105473:	85 c0                	test   %eax,%eax
c0105475:	74 24                	je     c010549b <default_check+0x204>
c0105477:	c7 44 24 0c 16 74 10 	movl   $0xc0107416,0xc(%esp)
c010547e:	c0 
c010547f:	c7 44 24 08 9e 71 10 	movl   $0xc010719e,0x8(%esp)
c0105486:	c0 
c0105487:	c7 44 24 04 40 01 00 	movl   $0x140,0x4(%esp)
c010548e:	00 
c010548f:	c7 04 24 b3 71 10 c0 	movl   $0xc01071b3,(%esp)
c0105496:	e8 57 af ff ff       	call   c01003f2 <__panic>

    unsigned int nr_free_store = nr_free;
c010549b:	a1 44 cf 11 c0       	mov    0xc011cf44,%eax
c01054a0:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c01054a3:	c7 05 44 cf 11 c0 00 	movl   $0x0,0xc011cf44
c01054aa:	00 00 00 

    free_pages(p0 + 2, 3);
c01054ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01054b0:	83 c0 28             	add    $0x28,%eax
c01054b3:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01054ba:	00 
c01054bb:	89 04 24             	mov    %eax,(%esp)
c01054be:	e8 85 db ff ff       	call   c0103048 <free_pages>
    assert(alloc_pages(4) == NULL);
c01054c3:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c01054ca:	e8 41 db ff ff       	call   c0103010 <alloc_pages>
c01054cf:	85 c0                	test   %eax,%eax
c01054d1:	74 24                	je     c01054f7 <default_check+0x260>
c01054d3:	c7 44 24 0c bc 74 10 	movl   $0xc01074bc,0xc(%esp)
c01054da:	c0 
c01054db:	c7 44 24 08 9e 71 10 	movl   $0xc010719e,0x8(%esp)
c01054e2:	c0 
c01054e3:	c7 44 24 04 46 01 00 	movl   $0x146,0x4(%esp)
c01054ea:	00 
c01054eb:	c7 04 24 b3 71 10 c0 	movl   $0xc01071b3,(%esp)
c01054f2:	e8 fb ae ff ff       	call   c01003f2 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c01054f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01054fa:	83 c0 28             	add    $0x28,%eax
c01054fd:	83 c0 04             	add    $0x4,%eax
c0105500:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0105507:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010550a:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010550d:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0105510:	0f a3 10             	bt     %edx,(%eax)
c0105513:	19 c0                	sbb    %eax,%eax
c0105515:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0105518:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c010551c:	0f 95 c0             	setne  %al
c010551f:	0f b6 c0             	movzbl %al,%eax
c0105522:	85 c0                	test   %eax,%eax
c0105524:	74 0e                	je     c0105534 <default_check+0x29d>
c0105526:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105529:	83 c0 28             	add    $0x28,%eax
c010552c:	8b 40 08             	mov    0x8(%eax),%eax
c010552f:	83 f8 03             	cmp    $0x3,%eax
c0105532:	74 24                	je     c0105558 <default_check+0x2c1>
c0105534:	c7 44 24 0c d4 74 10 	movl   $0xc01074d4,0xc(%esp)
c010553b:	c0 
c010553c:	c7 44 24 08 9e 71 10 	movl   $0xc010719e,0x8(%esp)
c0105543:	c0 
c0105544:	c7 44 24 04 47 01 00 	movl   $0x147,0x4(%esp)
c010554b:	00 
c010554c:	c7 04 24 b3 71 10 c0 	movl   $0xc01071b3,(%esp)
c0105553:	e8 9a ae ff ff       	call   c01003f2 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0105558:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c010555f:	e8 ac da ff ff       	call   c0103010 <alloc_pages>
c0105564:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0105567:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c010556b:	75 24                	jne    c0105591 <default_check+0x2fa>
c010556d:	c7 44 24 0c 00 75 10 	movl   $0xc0107500,0xc(%esp)
c0105574:	c0 
c0105575:	c7 44 24 08 9e 71 10 	movl   $0xc010719e,0x8(%esp)
c010557c:	c0 
c010557d:	c7 44 24 04 48 01 00 	movl   $0x148,0x4(%esp)
c0105584:	00 
c0105585:	c7 04 24 b3 71 10 c0 	movl   $0xc01071b3,(%esp)
c010558c:	e8 61 ae ff ff       	call   c01003f2 <__panic>
    assert(alloc_page() == NULL);
c0105591:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105598:	e8 73 da ff ff       	call   c0103010 <alloc_pages>
c010559d:	85 c0                	test   %eax,%eax
c010559f:	74 24                	je     c01055c5 <default_check+0x32e>
c01055a1:	c7 44 24 0c 16 74 10 	movl   $0xc0107416,0xc(%esp)
c01055a8:	c0 
c01055a9:	c7 44 24 08 9e 71 10 	movl   $0xc010719e,0x8(%esp)
c01055b0:	c0 
c01055b1:	c7 44 24 04 49 01 00 	movl   $0x149,0x4(%esp)
c01055b8:	00 
c01055b9:	c7 04 24 b3 71 10 c0 	movl   $0xc01071b3,(%esp)
c01055c0:	e8 2d ae ff ff       	call   c01003f2 <__panic>
    assert(p0 + 2 == p1);
c01055c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01055c8:	83 c0 28             	add    $0x28,%eax
c01055cb:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01055ce:	74 24                	je     c01055f4 <default_check+0x35d>
c01055d0:	c7 44 24 0c 1e 75 10 	movl   $0xc010751e,0xc(%esp)
c01055d7:	c0 
c01055d8:	c7 44 24 08 9e 71 10 	movl   $0xc010719e,0x8(%esp)
c01055df:	c0 
c01055e0:	c7 44 24 04 4a 01 00 	movl   $0x14a,0x4(%esp)
c01055e7:	00 
c01055e8:	c7 04 24 b3 71 10 c0 	movl   $0xc01071b3,(%esp)
c01055ef:	e8 fe ad ff ff       	call   c01003f2 <__panic>

    p2 = p0 + 1;
c01055f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01055f7:	83 c0 14             	add    $0x14,%eax
c01055fa:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c01055fd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105604:	00 
c0105605:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105608:	89 04 24             	mov    %eax,(%esp)
c010560b:	e8 38 da ff ff       	call   c0103048 <free_pages>
    free_pages(p1, 3);
c0105610:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0105617:	00 
c0105618:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010561b:	89 04 24             	mov    %eax,(%esp)
c010561e:	e8 25 da ff ff       	call   c0103048 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c0105623:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105626:	83 c0 04             	add    $0x4,%eax
c0105629:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c0105630:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105633:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0105636:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0105639:	0f a3 10             	bt     %edx,(%eax)
c010563c:	19 c0                	sbb    %eax,%eax
c010563e:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c0105641:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0105645:	0f 95 c0             	setne  %al
c0105648:	0f b6 c0             	movzbl %al,%eax
c010564b:	85 c0                	test   %eax,%eax
c010564d:	74 0b                	je     c010565a <default_check+0x3c3>
c010564f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105652:	8b 40 08             	mov    0x8(%eax),%eax
c0105655:	83 f8 01             	cmp    $0x1,%eax
c0105658:	74 24                	je     c010567e <default_check+0x3e7>
c010565a:	c7 44 24 0c 2c 75 10 	movl   $0xc010752c,0xc(%esp)
c0105661:	c0 
c0105662:	c7 44 24 08 9e 71 10 	movl   $0xc010719e,0x8(%esp)
c0105669:	c0 
c010566a:	c7 44 24 04 4f 01 00 	movl   $0x14f,0x4(%esp)
c0105671:	00 
c0105672:	c7 04 24 b3 71 10 c0 	movl   $0xc01071b3,(%esp)
c0105679:	e8 74 ad ff ff       	call   c01003f2 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c010567e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105681:	83 c0 04             	add    $0x4,%eax
c0105684:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c010568b:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010568e:	8b 45 90             	mov    -0x70(%ebp),%eax
c0105691:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0105694:	0f a3 10             	bt     %edx,(%eax)
c0105697:	19 c0                	sbb    %eax,%eax
c0105699:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c010569c:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c01056a0:	0f 95 c0             	setne  %al
c01056a3:	0f b6 c0             	movzbl %al,%eax
c01056a6:	85 c0                	test   %eax,%eax
c01056a8:	74 0b                	je     c01056b5 <default_check+0x41e>
c01056aa:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01056ad:	8b 40 08             	mov    0x8(%eax),%eax
c01056b0:	83 f8 03             	cmp    $0x3,%eax
c01056b3:	74 24                	je     c01056d9 <default_check+0x442>
c01056b5:	c7 44 24 0c 54 75 10 	movl   $0xc0107554,0xc(%esp)
c01056bc:	c0 
c01056bd:	c7 44 24 08 9e 71 10 	movl   $0xc010719e,0x8(%esp)
c01056c4:	c0 
c01056c5:	c7 44 24 04 50 01 00 	movl   $0x150,0x4(%esp)
c01056cc:	00 
c01056cd:	c7 04 24 b3 71 10 c0 	movl   $0xc01071b3,(%esp)
c01056d4:	e8 19 ad ff ff       	call   c01003f2 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c01056d9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01056e0:	e8 2b d9 ff ff       	call   c0103010 <alloc_pages>
c01056e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01056e8:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01056eb:	83 e8 14             	sub    $0x14,%eax
c01056ee:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01056f1:	74 24                	je     c0105717 <default_check+0x480>
c01056f3:	c7 44 24 0c 7a 75 10 	movl   $0xc010757a,0xc(%esp)
c01056fa:	c0 
c01056fb:	c7 44 24 08 9e 71 10 	movl   $0xc010719e,0x8(%esp)
c0105702:	c0 
c0105703:	c7 44 24 04 52 01 00 	movl   $0x152,0x4(%esp)
c010570a:	00 
c010570b:	c7 04 24 b3 71 10 c0 	movl   $0xc01071b3,(%esp)
c0105712:	e8 db ac ff ff       	call   c01003f2 <__panic>
    free_page(p0);
c0105717:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010571e:	00 
c010571f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105722:	89 04 24             	mov    %eax,(%esp)
c0105725:	e8 1e d9 ff ff       	call   c0103048 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c010572a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c0105731:	e8 da d8 ff ff       	call   c0103010 <alloc_pages>
c0105736:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105739:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010573c:	83 c0 14             	add    $0x14,%eax
c010573f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0105742:	74 24                	je     c0105768 <default_check+0x4d1>
c0105744:	c7 44 24 0c 98 75 10 	movl   $0xc0107598,0xc(%esp)
c010574b:	c0 
c010574c:	c7 44 24 08 9e 71 10 	movl   $0xc010719e,0x8(%esp)
c0105753:	c0 
c0105754:	c7 44 24 04 54 01 00 	movl   $0x154,0x4(%esp)
c010575b:	00 
c010575c:	c7 04 24 b3 71 10 c0 	movl   $0xc01071b3,(%esp)
c0105763:	e8 8a ac ff ff       	call   c01003f2 <__panic>

    free_pages(p0, 2);
c0105768:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c010576f:	00 
c0105770:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105773:	89 04 24             	mov    %eax,(%esp)
c0105776:	e8 cd d8 ff ff       	call   c0103048 <free_pages>
    free_page(p2);
c010577b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105782:	00 
c0105783:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105786:	89 04 24             	mov    %eax,(%esp)
c0105789:	e8 ba d8 ff ff       	call   c0103048 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c010578e:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0105795:	e8 76 d8 ff ff       	call   c0103010 <alloc_pages>
c010579a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010579d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01057a1:	75 24                	jne    c01057c7 <default_check+0x530>
c01057a3:	c7 44 24 0c b8 75 10 	movl   $0xc01075b8,0xc(%esp)
c01057aa:	c0 
c01057ab:	c7 44 24 08 9e 71 10 	movl   $0xc010719e,0x8(%esp)
c01057b2:	c0 
c01057b3:	c7 44 24 04 59 01 00 	movl   $0x159,0x4(%esp)
c01057ba:	00 
c01057bb:	c7 04 24 b3 71 10 c0 	movl   $0xc01071b3,(%esp)
c01057c2:	e8 2b ac ff ff       	call   c01003f2 <__panic>
    assert(alloc_page() == NULL);
c01057c7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01057ce:	e8 3d d8 ff ff       	call   c0103010 <alloc_pages>
c01057d3:	85 c0                	test   %eax,%eax
c01057d5:	74 24                	je     c01057fb <default_check+0x564>
c01057d7:	c7 44 24 0c 16 74 10 	movl   $0xc0107416,0xc(%esp)
c01057de:	c0 
c01057df:	c7 44 24 08 9e 71 10 	movl   $0xc010719e,0x8(%esp)
c01057e6:	c0 
c01057e7:	c7 44 24 04 5a 01 00 	movl   $0x15a,0x4(%esp)
c01057ee:	00 
c01057ef:	c7 04 24 b3 71 10 c0 	movl   $0xc01071b3,(%esp)
c01057f6:	e8 f7 ab ff ff       	call   c01003f2 <__panic>

    assert(nr_free == 0);
c01057fb:	a1 44 cf 11 c0       	mov    0xc011cf44,%eax
c0105800:	85 c0                	test   %eax,%eax
c0105802:	74 24                	je     c0105828 <default_check+0x591>
c0105804:	c7 44 24 0c 69 74 10 	movl   $0xc0107469,0xc(%esp)
c010580b:	c0 
c010580c:	c7 44 24 08 9e 71 10 	movl   $0xc010719e,0x8(%esp)
c0105813:	c0 
c0105814:	c7 44 24 04 5c 01 00 	movl   $0x15c,0x4(%esp)
c010581b:	00 
c010581c:	c7 04 24 b3 71 10 c0 	movl   $0xc01071b3,(%esp)
c0105823:	e8 ca ab ff ff       	call   c01003f2 <__panic>
    nr_free = nr_free_store;
c0105828:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010582b:	a3 44 cf 11 c0       	mov    %eax,0xc011cf44

    free_list = free_list_store;
c0105830:	8b 45 80             	mov    -0x80(%ebp),%eax
c0105833:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0105836:	a3 3c cf 11 c0       	mov    %eax,0xc011cf3c
c010583b:	89 15 40 cf 11 c0    	mov    %edx,0xc011cf40
    free_pages(p0, 5);
c0105841:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0105848:	00 
c0105849:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010584c:	89 04 24             	mov    %eax,(%esp)
c010584f:	e8 f4 d7 ff ff       	call   c0103048 <free_pages>

    le = &free_list;
c0105854:	c7 45 ec 3c cf 11 c0 	movl   $0xc011cf3c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c010585b:	eb 1c                	jmp    c0105879 <default_check+0x5e2>
        struct Page *p = le2page(le, page_link);
c010585d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105860:	83 e8 0c             	sub    $0xc,%eax
c0105863:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c0105866:	ff 4d f4             	decl   -0xc(%ebp)
c0105869:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010586c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010586f:	8b 40 08             	mov    0x8(%eax),%eax
c0105872:	29 c2                	sub    %eax,%edx
c0105874:	89 d0                	mov    %edx,%eax
c0105876:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105879:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010587c:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
c010587f:	8b 45 88             	mov    -0x78(%ebp),%eax
c0105882:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0105885:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105888:	81 7d ec 3c cf 11 c0 	cmpl   $0xc011cf3c,-0x14(%ebp)
c010588f:	75 cc                	jne    c010585d <default_check+0x5c6>
    }
    assert(count == 0);
c0105891:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105895:	74 24                	je     c01058bb <default_check+0x624>
c0105897:	c7 44 24 0c d6 75 10 	movl   $0xc01075d6,0xc(%esp)
c010589e:	c0 
c010589f:	c7 44 24 08 9e 71 10 	movl   $0xc010719e,0x8(%esp)
c01058a6:	c0 
c01058a7:	c7 44 24 04 67 01 00 	movl   $0x167,0x4(%esp)
c01058ae:	00 
c01058af:	c7 04 24 b3 71 10 c0 	movl   $0xc01071b3,(%esp)
c01058b6:	e8 37 ab ff ff       	call   c01003f2 <__panic>
    assert(total == 0);
c01058bb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01058bf:	74 24                	je     c01058e5 <default_check+0x64e>
c01058c1:	c7 44 24 0c e1 75 10 	movl   $0xc01075e1,0xc(%esp)
c01058c8:	c0 
c01058c9:	c7 44 24 08 9e 71 10 	movl   $0xc010719e,0x8(%esp)
c01058d0:	c0 
c01058d1:	c7 44 24 04 68 01 00 	movl   $0x168,0x4(%esp)
c01058d8:	00 
c01058d9:	c7 04 24 b3 71 10 c0 	movl   $0xc01071b3,(%esp)
c01058e0:	e8 0d ab ff ff       	call   c01003f2 <__panic>
}
c01058e5:	90                   	nop
c01058e6:	c9                   	leave  
c01058e7:	c3                   	ret    

c01058e8 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c01058e8:	55                   	push   %ebp
c01058e9:	89 e5                	mov    %esp,%ebp
c01058eb:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c01058ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c01058f5:	eb 03                	jmp    c01058fa <strlen+0x12>
        cnt ++;
c01058f7:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
c01058fa:	8b 45 08             	mov    0x8(%ebp),%eax
c01058fd:	8d 50 01             	lea    0x1(%eax),%edx
c0105900:	89 55 08             	mov    %edx,0x8(%ebp)
c0105903:	0f b6 00             	movzbl (%eax),%eax
c0105906:	84 c0                	test   %al,%al
c0105908:	75 ed                	jne    c01058f7 <strlen+0xf>
    }
    return cnt;
c010590a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010590d:	c9                   	leave  
c010590e:	c3                   	ret    

c010590f <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c010590f:	55                   	push   %ebp
c0105910:	89 e5                	mov    %esp,%ebp
c0105912:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105915:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c010591c:	eb 03                	jmp    c0105921 <strnlen+0x12>
        cnt ++;
c010591e:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105921:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105924:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105927:	73 10                	jae    c0105939 <strnlen+0x2a>
c0105929:	8b 45 08             	mov    0x8(%ebp),%eax
c010592c:	8d 50 01             	lea    0x1(%eax),%edx
c010592f:	89 55 08             	mov    %edx,0x8(%ebp)
c0105932:	0f b6 00             	movzbl (%eax),%eax
c0105935:	84 c0                	test   %al,%al
c0105937:	75 e5                	jne    c010591e <strnlen+0xf>
    }
    return cnt;
c0105939:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010593c:	c9                   	leave  
c010593d:	c3                   	ret    

c010593e <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c010593e:	55                   	push   %ebp
c010593f:	89 e5                	mov    %esp,%ebp
c0105941:	57                   	push   %edi
c0105942:	56                   	push   %esi
c0105943:	83 ec 20             	sub    $0x20,%esp
c0105946:	8b 45 08             	mov    0x8(%ebp),%eax
c0105949:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010594c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010594f:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0105952:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105955:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105958:	89 d1                	mov    %edx,%ecx
c010595a:	89 c2                	mov    %eax,%edx
c010595c:	89 ce                	mov    %ecx,%esi
c010595e:	89 d7                	mov    %edx,%edi
c0105960:	ac                   	lods   %ds:(%esi),%al
c0105961:	aa                   	stos   %al,%es:(%edi)
c0105962:	84 c0                	test   %al,%al
c0105964:	75 fa                	jne    c0105960 <strcpy+0x22>
c0105966:	89 fa                	mov    %edi,%edx
c0105968:	89 f1                	mov    %esi,%ecx
c010596a:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c010596d:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0105970:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0105973:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
c0105976:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0105977:	83 c4 20             	add    $0x20,%esp
c010597a:	5e                   	pop    %esi
c010597b:	5f                   	pop    %edi
c010597c:	5d                   	pop    %ebp
c010597d:	c3                   	ret    

c010597e <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c010597e:	55                   	push   %ebp
c010597f:	89 e5                	mov    %esp,%ebp
c0105981:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0105984:	8b 45 08             	mov    0x8(%ebp),%eax
c0105987:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c010598a:	eb 1e                	jmp    c01059aa <strncpy+0x2c>
        if ((*p = *src) != '\0') {
c010598c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010598f:	0f b6 10             	movzbl (%eax),%edx
c0105992:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105995:	88 10                	mov    %dl,(%eax)
c0105997:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010599a:	0f b6 00             	movzbl (%eax),%eax
c010599d:	84 c0                	test   %al,%al
c010599f:	74 03                	je     c01059a4 <strncpy+0x26>
            src ++;
c01059a1:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
c01059a4:	ff 45 fc             	incl   -0x4(%ebp)
c01059a7:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
c01059aa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01059ae:	75 dc                	jne    c010598c <strncpy+0xe>
    }
    return dst;
c01059b0:	8b 45 08             	mov    0x8(%ebp),%eax
}
c01059b3:	c9                   	leave  
c01059b4:	c3                   	ret    

c01059b5 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c01059b5:	55                   	push   %ebp
c01059b6:	89 e5                	mov    %esp,%ebp
c01059b8:	57                   	push   %edi
c01059b9:	56                   	push   %esi
c01059ba:	83 ec 20             	sub    $0x20,%esp
c01059bd:	8b 45 08             	mov    0x8(%ebp),%eax
c01059c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01059c3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
c01059c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01059cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01059cf:	89 d1                	mov    %edx,%ecx
c01059d1:	89 c2                	mov    %eax,%edx
c01059d3:	89 ce                	mov    %ecx,%esi
c01059d5:	89 d7                	mov    %edx,%edi
c01059d7:	ac                   	lods   %ds:(%esi),%al
c01059d8:	ae                   	scas   %es:(%edi),%al
c01059d9:	75 08                	jne    c01059e3 <strcmp+0x2e>
c01059db:	84 c0                	test   %al,%al
c01059dd:	75 f8                	jne    c01059d7 <strcmp+0x22>
c01059df:	31 c0                	xor    %eax,%eax
c01059e1:	eb 04                	jmp    c01059e7 <strcmp+0x32>
c01059e3:	19 c0                	sbb    %eax,%eax
c01059e5:	0c 01                	or     $0x1,%al
c01059e7:	89 fa                	mov    %edi,%edx
c01059e9:	89 f1                	mov    %esi,%ecx
c01059eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01059ee:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c01059f1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
c01059f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
c01059f7:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c01059f8:	83 c4 20             	add    $0x20,%esp
c01059fb:	5e                   	pop    %esi
c01059fc:	5f                   	pop    %edi
c01059fd:	5d                   	pop    %ebp
c01059fe:	c3                   	ret    

c01059ff <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c01059ff:	55                   	push   %ebp
c0105a00:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105a02:	eb 09                	jmp    c0105a0d <strncmp+0xe>
        n --, s1 ++, s2 ++;
c0105a04:	ff 4d 10             	decl   0x10(%ebp)
c0105a07:	ff 45 08             	incl   0x8(%ebp)
c0105a0a:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105a0d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105a11:	74 1a                	je     c0105a2d <strncmp+0x2e>
c0105a13:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a16:	0f b6 00             	movzbl (%eax),%eax
c0105a19:	84 c0                	test   %al,%al
c0105a1b:	74 10                	je     c0105a2d <strncmp+0x2e>
c0105a1d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a20:	0f b6 10             	movzbl (%eax),%edx
c0105a23:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a26:	0f b6 00             	movzbl (%eax),%eax
c0105a29:	38 c2                	cmp    %al,%dl
c0105a2b:	74 d7                	je     c0105a04 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105a2d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105a31:	74 18                	je     c0105a4b <strncmp+0x4c>
c0105a33:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a36:	0f b6 00             	movzbl (%eax),%eax
c0105a39:	0f b6 d0             	movzbl %al,%edx
c0105a3c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a3f:	0f b6 00             	movzbl (%eax),%eax
c0105a42:	0f b6 c0             	movzbl %al,%eax
c0105a45:	29 c2                	sub    %eax,%edx
c0105a47:	89 d0                	mov    %edx,%eax
c0105a49:	eb 05                	jmp    c0105a50 <strncmp+0x51>
c0105a4b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105a50:	5d                   	pop    %ebp
c0105a51:	c3                   	ret    

c0105a52 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0105a52:	55                   	push   %ebp
c0105a53:	89 e5                	mov    %esp,%ebp
c0105a55:	83 ec 04             	sub    $0x4,%esp
c0105a58:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a5b:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105a5e:	eb 13                	jmp    c0105a73 <strchr+0x21>
        if (*s == c) {
c0105a60:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a63:	0f b6 00             	movzbl (%eax),%eax
c0105a66:	38 45 fc             	cmp    %al,-0x4(%ebp)
c0105a69:	75 05                	jne    c0105a70 <strchr+0x1e>
            return (char *)s;
c0105a6b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a6e:	eb 12                	jmp    c0105a82 <strchr+0x30>
        }
        s ++;
c0105a70:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
c0105a73:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a76:	0f b6 00             	movzbl (%eax),%eax
c0105a79:	84 c0                	test   %al,%al
c0105a7b:	75 e3                	jne    c0105a60 <strchr+0xe>
    }
    return NULL;
c0105a7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105a82:	c9                   	leave  
c0105a83:	c3                   	ret    

c0105a84 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0105a84:	55                   	push   %ebp
c0105a85:	89 e5                	mov    %esp,%ebp
c0105a87:	83 ec 04             	sub    $0x4,%esp
c0105a8a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a8d:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105a90:	eb 0e                	jmp    c0105aa0 <strfind+0x1c>
        if (*s == c) {
c0105a92:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a95:	0f b6 00             	movzbl (%eax),%eax
c0105a98:	38 45 fc             	cmp    %al,-0x4(%ebp)
c0105a9b:	74 0f                	je     c0105aac <strfind+0x28>
            break;
        }
        s ++;
c0105a9d:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
c0105aa0:	8b 45 08             	mov    0x8(%ebp),%eax
c0105aa3:	0f b6 00             	movzbl (%eax),%eax
c0105aa6:	84 c0                	test   %al,%al
c0105aa8:	75 e8                	jne    c0105a92 <strfind+0xe>
c0105aaa:	eb 01                	jmp    c0105aad <strfind+0x29>
            break;
c0105aac:	90                   	nop
    }
    return (char *)s;
c0105aad:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105ab0:	c9                   	leave  
c0105ab1:	c3                   	ret    

c0105ab2 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0105ab2:	55                   	push   %ebp
c0105ab3:	89 e5                	mov    %esp,%ebp
c0105ab5:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0105ab8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0105abf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105ac6:	eb 03                	jmp    c0105acb <strtol+0x19>
        s ++;
c0105ac8:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
c0105acb:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ace:	0f b6 00             	movzbl (%eax),%eax
c0105ad1:	3c 20                	cmp    $0x20,%al
c0105ad3:	74 f3                	je     c0105ac8 <strtol+0x16>
c0105ad5:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ad8:	0f b6 00             	movzbl (%eax),%eax
c0105adb:	3c 09                	cmp    $0x9,%al
c0105add:	74 e9                	je     c0105ac8 <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
c0105adf:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ae2:	0f b6 00             	movzbl (%eax),%eax
c0105ae5:	3c 2b                	cmp    $0x2b,%al
c0105ae7:	75 05                	jne    c0105aee <strtol+0x3c>
        s ++;
c0105ae9:	ff 45 08             	incl   0x8(%ebp)
c0105aec:	eb 14                	jmp    c0105b02 <strtol+0x50>
    }
    else if (*s == '-') {
c0105aee:	8b 45 08             	mov    0x8(%ebp),%eax
c0105af1:	0f b6 00             	movzbl (%eax),%eax
c0105af4:	3c 2d                	cmp    $0x2d,%al
c0105af6:	75 0a                	jne    c0105b02 <strtol+0x50>
        s ++, neg = 1;
c0105af8:	ff 45 08             	incl   0x8(%ebp)
c0105afb:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0105b02:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105b06:	74 06                	je     c0105b0e <strtol+0x5c>
c0105b08:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0105b0c:	75 22                	jne    c0105b30 <strtol+0x7e>
c0105b0e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b11:	0f b6 00             	movzbl (%eax),%eax
c0105b14:	3c 30                	cmp    $0x30,%al
c0105b16:	75 18                	jne    c0105b30 <strtol+0x7e>
c0105b18:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b1b:	40                   	inc    %eax
c0105b1c:	0f b6 00             	movzbl (%eax),%eax
c0105b1f:	3c 78                	cmp    $0x78,%al
c0105b21:	75 0d                	jne    c0105b30 <strtol+0x7e>
        s += 2, base = 16;
c0105b23:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105b27:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0105b2e:	eb 29                	jmp    c0105b59 <strtol+0xa7>
    }
    else if (base == 0 && s[0] == '0') {
c0105b30:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105b34:	75 16                	jne    c0105b4c <strtol+0x9a>
c0105b36:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b39:	0f b6 00             	movzbl (%eax),%eax
c0105b3c:	3c 30                	cmp    $0x30,%al
c0105b3e:	75 0c                	jne    c0105b4c <strtol+0x9a>
        s ++, base = 8;
c0105b40:	ff 45 08             	incl   0x8(%ebp)
c0105b43:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0105b4a:	eb 0d                	jmp    c0105b59 <strtol+0xa7>
    }
    else if (base == 0) {
c0105b4c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105b50:	75 07                	jne    c0105b59 <strtol+0xa7>
        base = 10;
c0105b52:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0105b59:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b5c:	0f b6 00             	movzbl (%eax),%eax
c0105b5f:	3c 2f                	cmp    $0x2f,%al
c0105b61:	7e 1b                	jle    c0105b7e <strtol+0xcc>
c0105b63:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b66:	0f b6 00             	movzbl (%eax),%eax
c0105b69:	3c 39                	cmp    $0x39,%al
c0105b6b:	7f 11                	jg     c0105b7e <strtol+0xcc>
            dig = *s - '0';
c0105b6d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b70:	0f b6 00             	movzbl (%eax),%eax
c0105b73:	0f be c0             	movsbl %al,%eax
c0105b76:	83 e8 30             	sub    $0x30,%eax
c0105b79:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105b7c:	eb 48                	jmp    c0105bc6 <strtol+0x114>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0105b7e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b81:	0f b6 00             	movzbl (%eax),%eax
c0105b84:	3c 60                	cmp    $0x60,%al
c0105b86:	7e 1b                	jle    c0105ba3 <strtol+0xf1>
c0105b88:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b8b:	0f b6 00             	movzbl (%eax),%eax
c0105b8e:	3c 7a                	cmp    $0x7a,%al
c0105b90:	7f 11                	jg     c0105ba3 <strtol+0xf1>
            dig = *s - 'a' + 10;
c0105b92:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b95:	0f b6 00             	movzbl (%eax),%eax
c0105b98:	0f be c0             	movsbl %al,%eax
c0105b9b:	83 e8 57             	sub    $0x57,%eax
c0105b9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105ba1:	eb 23                	jmp    c0105bc6 <strtol+0x114>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0105ba3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ba6:	0f b6 00             	movzbl (%eax),%eax
c0105ba9:	3c 40                	cmp    $0x40,%al
c0105bab:	7e 3b                	jle    c0105be8 <strtol+0x136>
c0105bad:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bb0:	0f b6 00             	movzbl (%eax),%eax
c0105bb3:	3c 5a                	cmp    $0x5a,%al
c0105bb5:	7f 31                	jg     c0105be8 <strtol+0x136>
            dig = *s - 'A' + 10;
c0105bb7:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bba:	0f b6 00             	movzbl (%eax),%eax
c0105bbd:	0f be c0             	movsbl %al,%eax
c0105bc0:	83 e8 37             	sub    $0x37,%eax
c0105bc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0105bc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105bc9:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105bcc:	7d 19                	jge    c0105be7 <strtol+0x135>
            break;
        }
        s ++, val = (val * base) + dig;
c0105bce:	ff 45 08             	incl   0x8(%ebp)
c0105bd1:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105bd4:	0f af 45 10          	imul   0x10(%ebp),%eax
c0105bd8:	89 c2                	mov    %eax,%edx
c0105bda:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105bdd:	01 d0                	add    %edx,%eax
c0105bdf:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
c0105be2:	e9 72 ff ff ff       	jmp    c0105b59 <strtol+0xa7>
            break;
c0105be7:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
c0105be8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105bec:	74 08                	je     c0105bf6 <strtol+0x144>
        *endptr = (char *) s;
c0105bee:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bf1:	8b 55 08             	mov    0x8(%ebp),%edx
c0105bf4:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0105bf6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0105bfa:	74 07                	je     c0105c03 <strtol+0x151>
c0105bfc:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105bff:	f7 d8                	neg    %eax
c0105c01:	eb 03                	jmp    c0105c06 <strtol+0x154>
c0105c03:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0105c06:	c9                   	leave  
c0105c07:	c3                   	ret    

c0105c08 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0105c08:	55                   	push   %ebp
c0105c09:	89 e5                	mov    %esp,%ebp
c0105c0b:	57                   	push   %edi
c0105c0c:	83 ec 24             	sub    $0x24,%esp
c0105c0f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c12:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0105c15:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
c0105c19:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c1c:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0105c1f:	88 55 f7             	mov    %dl,-0x9(%ebp)
c0105c22:	8b 45 10             	mov    0x10(%ebp),%eax
c0105c25:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0105c28:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0105c2b:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0105c2f:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0105c32:	89 d7                	mov    %edx,%edi
c0105c34:	f3 aa                	rep stos %al,%es:(%edi)
c0105c36:	89 fa                	mov    %edi,%edx
c0105c38:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105c3b:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0105c3e:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105c41:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0105c42:	83 c4 24             	add    $0x24,%esp
c0105c45:	5f                   	pop    %edi
c0105c46:	5d                   	pop    %ebp
c0105c47:	c3                   	ret    

c0105c48 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0105c48:	55                   	push   %ebp
c0105c49:	89 e5                	mov    %esp,%ebp
c0105c4b:	57                   	push   %edi
c0105c4c:	56                   	push   %esi
c0105c4d:	53                   	push   %ebx
c0105c4e:	83 ec 30             	sub    $0x30,%esp
c0105c51:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c54:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105c57:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c5a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105c5d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105c60:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0105c63:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105c66:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105c69:	73 42                	jae    c0105cad <memmove+0x65>
c0105c6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105c6e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105c71:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105c74:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105c77:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105c7a:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105c7d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105c80:	c1 e8 02             	shr    $0x2,%eax
c0105c83:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0105c85:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105c88:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105c8b:	89 d7                	mov    %edx,%edi
c0105c8d:	89 c6                	mov    %eax,%esi
c0105c8f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105c91:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105c94:	83 e1 03             	and    $0x3,%ecx
c0105c97:	74 02                	je     c0105c9b <memmove+0x53>
c0105c99:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105c9b:	89 f0                	mov    %esi,%eax
c0105c9d:	89 fa                	mov    %edi,%edx
c0105c9f:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0105ca2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105ca5:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
c0105ca8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
c0105cab:	eb 36                	jmp    c0105ce3 <memmove+0x9b>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0105cad:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105cb0:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105cb3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105cb6:	01 c2                	add    %eax,%edx
c0105cb8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105cbb:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0105cbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105cc1:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
c0105cc4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105cc7:	89 c1                	mov    %eax,%ecx
c0105cc9:	89 d8                	mov    %ebx,%eax
c0105ccb:	89 d6                	mov    %edx,%esi
c0105ccd:	89 c7                	mov    %eax,%edi
c0105ccf:	fd                   	std    
c0105cd0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105cd2:	fc                   	cld    
c0105cd3:	89 f8                	mov    %edi,%eax
c0105cd5:	89 f2                	mov    %esi,%edx
c0105cd7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0105cda:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0105cdd:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
c0105ce0:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0105ce3:	83 c4 30             	add    $0x30,%esp
c0105ce6:	5b                   	pop    %ebx
c0105ce7:	5e                   	pop    %esi
c0105ce8:	5f                   	pop    %edi
c0105ce9:	5d                   	pop    %ebp
c0105cea:	c3                   	ret    

c0105ceb <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0105ceb:	55                   	push   %ebp
c0105cec:	89 e5                	mov    %esp,%ebp
c0105cee:	57                   	push   %edi
c0105cef:	56                   	push   %esi
c0105cf0:	83 ec 20             	sub    $0x20,%esp
c0105cf3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cf6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105cf9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105cfc:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105cff:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d02:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105d05:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105d08:	c1 e8 02             	shr    $0x2,%eax
c0105d0b:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0105d0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105d10:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d13:	89 d7                	mov    %edx,%edi
c0105d15:	89 c6                	mov    %eax,%esi
c0105d17:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105d19:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0105d1c:	83 e1 03             	and    $0x3,%ecx
c0105d1f:	74 02                	je     c0105d23 <memcpy+0x38>
c0105d21:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105d23:	89 f0                	mov    %esi,%eax
c0105d25:	89 fa                	mov    %edi,%edx
c0105d27:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105d2a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0105d2d:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
c0105d30:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
c0105d33:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0105d34:	83 c4 20             	add    $0x20,%esp
c0105d37:	5e                   	pop    %esi
c0105d38:	5f                   	pop    %edi
c0105d39:	5d                   	pop    %ebp
c0105d3a:	c3                   	ret    

c0105d3b <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0105d3b:	55                   	push   %ebp
c0105d3c:	89 e5                	mov    %esp,%ebp
c0105d3e:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0105d41:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d44:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0105d47:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d4a:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0105d4d:	eb 2e                	jmp    c0105d7d <memcmp+0x42>
        if (*s1 != *s2) {
c0105d4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105d52:	0f b6 10             	movzbl (%eax),%edx
c0105d55:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105d58:	0f b6 00             	movzbl (%eax),%eax
c0105d5b:	38 c2                	cmp    %al,%dl
c0105d5d:	74 18                	je     c0105d77 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105d5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105d62:	0f b6 00             	movzbl (%eax),%eax
c0105d65:	0f b6 d0             	movzbl %al,%edx
c0105d68:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105d6b:	0f b6 00             	movzbl (%eax),%eax
c0105d6e:	0f b6 c0             	movzbl %al,%eax
c0105d71:	29 c2                	sub    %eax,%edx
c0105d73:	89 d0                	mov    %edx,%eax
c0105d75:	eb 18                	jmp    c0105d8f <memcmp+0x54>
        }
        s1 ++, s2 ++;
c0105d77:	ff 45 fc             	incl   -0x4(%ebp)
c0105d7a:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
c0105d7d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d80:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105d83:	89 55 10             	mov    %edx,0x10(%ebp)
c0105d86:	85 c0                	test   %eax,%eax
c0105d88:	75 c5                	jne    c0105d4f <memcmp+0x14>
    }
    return 0;
c0105d8a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105d8f:	c9                   	leave  
c0105d90:	c3                   	ret    

c0105d91 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c0105d91:	55                   	push   %ebp
c0105d92:	89 e5                	mov    %esp,%ebp
c0105d94:	83 ec 58             	sub    $0x58,%esp
c0105d97:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d9a:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105d9d:	8b 45 14             	mov    0x14(%ebp),%eax
c0105da0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0105da3:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105da6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105da9:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105dac:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c0105daf:	8b 45 18             	mov    0x18(%ebp),%eax
c0105db2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105db5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105db8:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105dbb:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105dbe:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0105dc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105dc4:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105dc7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105dcb:	74 1c                	je     c0105de9 <printnum+0x58>
c0105dcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105dd0:	ba 00 00 00 00       	mov    $0x0,%edx
c0105dd5:	f7 75 e4             	divl   -0x1c(%ebp)
c0105dd8:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0105ddb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105dde:	ba 00 00 00 00       	mov    $0x0,%edx
c0105de3:	f7 75 e4             	divl   -0x1c(%ebp)
c0105de6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105de9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105dec:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105def:	f7 75 e4             	divl   -0x1c(%ebp)
c0105df2:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105df5:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0105df8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105dfb:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105dfe:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105e01:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0105e04:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105e07:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c0105e0a:	8b 45 18             	mov    0x18(%ebp),%eax
c0105e0d:	ba 00 00 00 00       	mov    $0x0,%edx
c0105e12:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0105e15:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c0105e18:	19 d1                	sbb    %edx,%ecx
c0105e1a:	72 4c                	jb     c0105e68 <printnum+0xd7>
        printnum(putch, putdat, result, base, width - 1, padc);
c0105e1c:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105e1f:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105e22:	8b 45 20             	mov    0x20(%ebp),%eax
c0105e25:	89 44 24 18          	mov    %eax,0x18(%esp)
c0105e29:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105e2d:	8b 45 18             	mov    0x18(%ebp),%eax
c0105e30:	89 44 24 10          	mov    %eax,0x10(%esp)
c0105e34:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105e37:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105e3a:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105e3e:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105e42:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e45:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105e49:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e4c:	89 04 24             	mov    %eax,(%esp)
c0105e4f:	e8 3d ff ff ff       	call   c0105d91 <printnum>
c0105e54:	eb 1b                	jmp    c0105e71 <printnum+0xe0>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c0105e56:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e59:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105e5d:	8b 45 20             	mov    0x20(%ebp),%eax
c0105e60:	89 04 24             	mov    %eax,(%esp)
c0105e63:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e66:	ff d0                	call   *%eax
        while (-- width > 0)
c0105e68:	ff 4d 1c             	decl   0x1c(%ebp)
c0105e6b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0105e6f:	7f e5                	jg     c0105e56 <printnum+0xc5>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c0105e71:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105e74:	05 9c 76 10 c0       	add    $0xc010769c,%eax
c0105e79:	0f b6 00             	movzbl (%eax),%eax
c0105e7c:	0f be c0             	movsbl %al,%eax
c0105e7f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105e82:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105e86:	89 04 24             	mov    %eax,(%esp)
c0105e89:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e8c:	ff d0                	call   *%eax
}
c0105e8e:	90                   	nop
c0105e8f:	c9                   	leave  
c0105e90:	c3                   	ret    

c0105e91 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c0105e91:	55                   	push   %ebp
c0105e92:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105e94:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105e98:	7e 14                	jle    c0105eae <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c0105e9a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e9d:	8b 00                	mov    (%eax),%eax
c0105e9f:	8d 48 08             	lea    0x8(%eax),%ecx
c0105ea2:	8b 55 08             	mov    0x8(%ebp),%edx
c0105ea5:	89 0a                	mov    %ecx,(%edx)
c0105ea7:	8b 50 04             	mov    0x4(%eax),%edx
c0105eaa:	8b 00                	mov    (%eax),%eax
c0105eac:	eb 30                	jmp    c0105ede <getuint+0x4d>
    }
    else if (lflag) {
c0105eae:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105eb2:	74 16                	je     c0105eca <getuint+0x39>
        return va_arg(*ap, unsigned long);
c0105eb4:	8b 45 08             	mov    0x8(%ebp),%eax
c0105eb7:	8b 00                	mov    (%eax),%eax
c0105eb9:	8d 48 04             	lea    0x4(%eax),%ecx
c0105ebc:	8b 55 08             	mov    0x8(%ebp),%edx
c0105ebf:	89 0a                	mov    %ecx,(%edx)
c0105ec1:	8b 00                	mov    (%eax),%eax
c0105ec3:	ba 00 00 00 00       	mov    $0x0,%edx
c0105ec8:	eb 14                	jmp    c0105ede <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c0105eca:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ecd:	8b 00                	mov    (%eax),%eax
c0105ecf:	8d 48 04             	lea    0x4(%eax),%ecx
c0105ed2:	8b 55 08             	mov    0x8(%ebp),%edx
c0105ed5:	89 0a                	mov    %ecx,(%edx)
c0105ed7:	8b 00                	mov    (%eax),%eax
c0105ed9:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c0105ede:	5d                   	pop    %ebp
c0105edf:	c3                   	ret    

c0105ee0 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c0105ee0:	55                   	push   %ebp
c0105ee1:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105ee3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105ee7:	7e 14                	jle    c0105efd <getint+0x1d>
        return va_arg(*ap, long long);
c0105ee9:	8b 45 08             	mov    0x8(%ebp),%eax
c0105eec:	8b 00                	mov    (%eax),%eax
c0105eee:	8d 48 08             	lea    0x8(%eax),%ecx
c0105ef1:	8b 55 08             	mov    0x8(%ebp),%edx
c0105ef4:	89 0a                	mov    %ecx,(%edx)
c0105ef6:	8b 50 04             	mov    0x4(%eax),%edx
c0105ef9:	8b 00                	mov    (%eax),%eax
c0105efb:	eb 28                	jmp    c0105f25 <getint+0x45>
    }
    else if (lflag) {
c0105efd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105f01:	74 12                	je     c0105f15 <getint+0x35>
        return va_arg(*ap, long);
c0105f03:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f06:	8b 00                	mov    (%eax),%eax
c0105f08:	8d 48 04             	lea    0x4(%eax),%ecx
c0105f0b:	8b 55 08             	mov    0x8(%ebp),%edx
c0105f0e:	89 0a                	mov    %ecx,(%edx)
c0105f10:	8b 00                	mov    (%eax),%eax
c0105f12:	99                   	cltd   
c0105f13:	eb 10                	jmp    c0105f25 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c0105f15:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f18:	8b 00                	mov    (%eax),%eax
c0105f1a:	8d 48 04             	lea    0x4(%eax),%ecx
c0105f1d:	8b 55 08             	mov    0x8(%ebp),%edx
c0105f20:	89 0a                	mov    %ecx,(%edx)
c0105f22:	8b 00                	mov    (%eax),%eax
c0105f24:	99                   	cltd   
    }
}
c0105f25:	5d                   	pop    %ebp
c0105f26:	c3                   	ret    

c0105f27 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c0105f27:	55                   	push   %ebp
c0105f28:	89 e5                	mov    %esp,%ebp
c0105f2a:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c0105f2d:	8d 45 14             	lea    0x14(%ebp),%eax
c0105f30:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c0105f33:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105f36:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105f3a:	8b 45 10             	mov    0x10(%ebp),%eax
c0105f3d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105f41:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f44:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105f48:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f4b:	89 04 24             	mov    %eax,(%esp)
c0105f4e:	e8 03 00 00 00       	call   c0105f56 <vprintfmt>
    va_end(ap);
}
c0105f53:	90                   	nop
c0105f54:	c9                   	leave  
c0105f55:	c3                   	ret    

c0105f56 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c0105f56:	55                   	push   %ebp
c0105f57:	89 e5                	mov    %esp,%ebp
c0105f59:	56                   	push   %esi
c0105f5a:	53                   	push   %ebx
c0105f5b:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105f5e:	eb 17                	jmp    c0105f77 <vprintfmt+0x21>
            if (ch == '\0') {
c0105f60:	85 db                	test   %ebx,%ebx
c0105f62:	0f 84 bf 03 00 00    	je     c0106327 <vprintfmt+0x3d1>
                return;
            }
            putch(ch, putdat);
c0105f68:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f6b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105f6f:	89 1c 24             	mov    %ebx,(%esp)
c0105f72:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f75:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105f77:	8b 45 10             	mov    0x10(%ebp),%eax
c0105f7a:	8d 50 01             	lea    0x1(%eax),%edx
c0105f7d:	89 55 10             	mov    %edx,0x10(%ebp)
c0105f80:	0f b6 00             	movzbl (%eax),%eax
c0105f83:	0f b6 d8             	movzbl %al,%ebx
c0105f86:	83 fb 25             	cmp    $0x25,%ebx
c0105f89:	75 d5                	jne    c0105f60 <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
c0105f8b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c0105f8f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c0105f96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105f99:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0105f9c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0105fa3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105fa6:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c0105fa9:	8b 45 10             	mov    0x10(%ebp),%eax
c0105fac:	8d 50 01             	lea    0x1(%eax),%edx
c0105faf:	89 55 10             	mov    %edx,0x10(%ebp)
c0105fb2:	0f b6 00             	movzbl (%eax),%eax
c0105fb5:	0f b6 d8             	movzbl %al,%ebx
c0105fb8:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0105fbb:	83 f8 55             	cmp    $0x55,%eax
c0105fbe:	0f 87 37 03 00 00    	ja     c01062fb <vprintfmt+0x3a5>
c0105fc4:	8b 04 85 c0 76 10 c0 	mov    -0x3fef8940(,%eax,4),%eax
c0105fcb:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0105fcd:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0105fd1:	eb d6                	jmp    c0105fa9 <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c0105fd3:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c0105fd7:	eb d0                	jmp    c0105fa9 <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0105fd9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0105fe0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105fe3:	89 d0                	mov    %edx,%eax
c0105fe5:	c1 e0 02             	shl    $0x2,%eax
c0105fe8:	01 d0                	add    %edx,%eax
c0105fea:	01 c0                	add    %eax,%eax
c0105fec:	01 d8                	add    %ebx,%eax
c0105fee:	83 e8 30             	sub    $0x30,%eax
c0105ff1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c0105ff4:	8b 45 10             	mov    0x10(%ebp),%eax
c0105ff7:	0f b6 00             	movzbl (%eax),%eax
c0105ffa:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c0105ffd:	83 fb 2f             	cmp    $0x2f,%ebx
c0106000:	7e 38                	jle    c010603a <vprintfmt+0xe4>
c0106002:	83 fb 39             	cmp    $0x39,%ebx
c0106005:	7f 33                	jg     c010603a <vprintfmt+0xe4>
            for (precision = 0; ; ++ fmt) {
c0106007:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
c010600a:	eb d4                	jmp    c0105fe0 <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c010600c:	8b 45 14             	mov    0x14(%ebp),%eax
c010600f:	8d 50 04             	lea    0x4(%eax),%edx
c0106012:	89 55 14             	mov    %edx,0x14(%ebp)
c0106015:	8b 00                	mov    (%eax),%eax
c0106017:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c010601a:	eb 1f                	jmp    c010603b <vprintfmt+0xe5>

        case '.':
            if (width < 0)
c010601c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0106020:	79 87                	jns    c0105fa9 <vprintfmt+0x53>
                width = 0;
c0106022:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c0106029:	e9 7b ff ff ff       	jmp    c0105fa9 <vprintfmt+0x53>

        case '#':
            altflag = 1;
c010602e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c0106035:	e9 6f ff ff ff       	jmp    c0105fa9 <vprintfmt+0x53>
            goto process_precision;
c010603a:	90                   	nop

        process_precision:
            if (width < 0)
c010603b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010603f:	0f 89 64 ff ff ff    	jns    c0105fa9 <vprintfmt+0x53>
                width = precision, precision = -1;
c0106045:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106048:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010604b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c0106052:	e9 52 ff ff ff       	jmp    c0105fa9 <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c0106057:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
c010605a:	e9 4a ff ff ff       	jmp    c0105fa9 <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c010605f:	8b 45 14             	mov    0x14(%ebp),%eax
c0106062:	8d 50 04             	lea    0x4(%eax),%edx
c0106065:	89 55 14             	mov    %edx,0x14(%ebp)
c0106068:	8b 00                	mov    (%eax),%eax
c010606a:	8b 55 0c             	mov    0xc(%ebp),%edx
c010606d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106071:	89 04 24             	mov    %eax,(%esp)
c0106074:	8b 45 08             	mov    0x8(%ebp),%eax
c0106077:	ff d0                	call   *%eax
            break;
c0106079:	e9 a4 02 00 00       	jmp    c0106322 <vprintfmt+0x3cc>

        // error message
        case 'e':
            err = va_arg(ap, int);
c010607e:	8b 45 14             	mov    0x14(%ebp),%eax
c0106081:	8d 50 04             	lea    0x4(%eax),%edx
c0106084:	89 55 14             	mov    %edx,0x14(%ebp)
c0106087:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c0106089:	85 db                	test   %ebx,%ebx
c010608b:	79 02                	jns    c010608f <vprintfmt+0x139>
                err = -err;
c010608d:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c010608f:	83 fb 06             	cmp    $0x6,%ebx
c0106092:	7f 0b                	jg     c010609f <vprintfmt+0x149>
c0106094:	8b 34 9d 80 76 10 c0 	mov    -0x3fef8980(,%ebx,4),%esi
c010609b:	85 f6                	test   %esi,%esi
c010609d:	75 23                	jne    c01060c2 <vprintfmt+0x16c>
                printfmt(putch, putdat, "error %d", err);
c010609f:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01060a3:	c7 44 24 08 ad 76 10 	movl   $0xc01076ad,0x8(%esp)
c01060aa:	c0 
c01060ab:	8b 45 0c             	mov    0xc(%ebp),%eax
c01060ae:	89 44 24 04          	mov    %eax,0x4(%esp)
c01060b2:	8b 45 08             	mov    0x8(%ebp),%eax
c01060b5:	89 04 24             	mov    %eax,(%esp)
c01060b8:	e8 6a fe ff ff       	call   c0105f27 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c01060bd:	e9 60 02 00 00       	jmp    c0106322 <vprintfmt+0x3cc>
                printfmt(putch, putdat, "%s", p);
c01060c2:	89 74 24 0c          	mov    %esi,0xc(%esp)
c01060c6:	c7 44 24 08 b6 76 10 	movl   $0xc01076b6,0x8(%esp)
c01060cd:	c0 
c01060ce:	8b 45 0c             	mov    0xc(%ebp),%eax
c01060d1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01060d5:	8b 45 08             	mov    0x8(%ebp),%eax
c01060d8:	89 04 24             	mov    %eax,(%esp)
c01060db:	e8 47 fe ff ff       	call   c0105f27 <printfmt>
            break;
c01060e0:	e9 3d 02 00 00       	jmp    c0106322 <vprintfmt+0x3cc>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c01060e5:	8b 45 14             	mov    0x14(%ebp),%eax
c01060e8:	8d 50 04             	lea    0x4(%eax),%edx
c01060eb:	89 55 14             	mov    %edx,0x14(%ebp)
c01060ee:	8b 30                	mov    (%eax),%esi
c01060f0:	85 f6                	test   %esi,%esi
c01060f2:	75 05                	jne    c01060f9 <vprintfmt+0x1a3>
                p = "(null)";
c01060f4:	be b9 76 10 c0       	mov    $0xc01076b9,%esi
            }
            if (width > 0 && padc != '-') {
c01060f9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01060fd:	7e 76                	jle    c0106175 <vprintfmt+0x21f>
c01060ff:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c0106103:	74 70                	je     c0106175 <vprintfmt+0x21f>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0106105:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106108:	89 44 24 04          	mov    %eax,0x4(%esp)
c010610c:	89 34 24             	mov    %esi,(%esp)
c010610f:	e8 fb f7 ff ff       	call   c010590f <strnlen>
c0106114:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0106117:	29 c2                	sub    %eax,%edx
c0106119:	89 d0                	mov    %edx,%eax
c010611b:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010611e:	eb 16                	jmp    c0106136 <vprintfmt+0x1e0>
                    putch(padc, putdat);
c0106120:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c0106124:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106127:	89 54 24 04          	mov    %edx,0x4(%esp)
c010612b:	89 04 24             	mov    %eax,(%esp)
c010612e:	8b 45 08             	mov    0x8(%ebp),%eax
c0106131:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
c0106133:	ff 4d e8             	decl   -0x18(%ebp)
c0106136:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010613a:	7f e4                	jg     c0106120 <vprintfmt+0x1ca>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c010613c:	eb 37                	jmp    c0106175 <vprintfmt+0x21f>
                if (altflag && (ch < ' ' || ch > '~')) {
c010613e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0106142:	74 1f                	je     c0106163 <vprintfmt+0x20d>
c0106144:	83 fb 1f             	cmp    $0x1f,%ebx
c0106147:	7e 05                	jle    c010614e <vprintfmt+0x1f8>
c0106149:	83 fb 7e             	cmp    $0x7e,%ebx
c010614c:	7e 15                	jle    c0106163 <vprintfmt+0x20d>
                    putch('?', putdat);
c010614e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106151:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106155:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c010615c:	8b 45 08             	mov    0x8(%ebp),%eax
c010615f:	ff d0                	call   *%eax
c0106161:	eb 0f                	jmp    c0106172 <vprintfmt+0x21c>
                }
                else {
                    putch(ch, putdat);
c0106163:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106166:	89 44 24 04          	mov    %eax,0x4(%esp)
c010616a:	89 1c 24             	mov    %ebx,(%esp)
c010616d:	8b 45 08             	mov    0x8(%ebp),%eax
c0106170:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0106172:	ff 4d e8             	decl   -0x18(%ebp)
c0106175:	89 f0                	mov    %esi,%eax
c0106177:	8d 70 01             	lea    0x1(%eax),%esi
c010617a:	0f b6 00             	movzbl (%eax),%eax
c010617d:	0f be d8             	movsbl %al,%ebx
c0106180:	85 db                	test   %ebx,%ebx
c0106182:	74 27                	je     c01061ab <vprintfmt+0x255>
c0106184:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0106188:	78 b4                	js     c010613e <vprintfmt+0x1e8>
c010618a:	ff 4d e4             	decl   -0x1c(%ebp)
c010618d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0106191:	79 ab                	jns    c010613e <vprintfmt+0x1e8>
                }
            }
            for (; width > 0; width --) {
c0106193:	eb 16                	jmp    c01061ab <vprintfmt+0x255>
                putch(' ', putdat);
c0106195:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106198:	89 44 24 04          	mov    %eax,0x4(%esp)
c010619c:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01061a3:	8b 45 08             	mov    0x8(%ebp),%eax
c01061a6:	ff d0                	call   *%eax
            for (; width > 0; width --) {
c01061a8:	ff 4d e8             	decl   -0x18(%ebp)
c01061ab:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01061af:	7f e4                	jg     c0106195 <vprintfmt+0x23f>
            }
            break;
c01061b1:	e9 6c 01 00 00       	jmp    c0106322 <vprintfmt+0x3cc>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c01061b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01061b9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01061bd:	8d 45 14             	lea    0x14(%ebp),%eax
c01061c0:	89 04 24             	mov    %eax,(%esp)
c01061c3:	e8 18 fd ff ff       	call   c0105ee0 <getint>
c01061c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01061cb:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c01061ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01061d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01061d4:	85 d2                	test   %edx,%edx
c01061d6:	79 26                	jns    c01061fe <vprintfmt+0x2a8>
                putch('-', putdat);
c01061d8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01061db:	89 44 24 04          	mov    %eax,0x4(%esp)
c01061df:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c01061e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01061e9:	ff d0                	call   *%eax
                num = -(long long)num;
c01061eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01061ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01061f1:	f7 d8                	neg    %eax
c01061f3:	83 d2 00             	adc    $0x0,%edx
c01061f6:	f7 da                	neg    %edx
c01061f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01061fb:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c01061fe:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0106205:	e9 a8 00 00 00       	jmp    c01062b2 <vprintfmt+0x35c>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c010620a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010620d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106211:	8d 45 14             	lea    0x14(%ebp),%eax
c0106214:	89 04 24             	mov    %eax,(%esp)
c0106217:	e8 75 fc ff ff       	call   c0105e91 <getuint>
c010621c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010621f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0106222:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0106229:	e9 84 00 00 00       	jmp    c01062b2 <vprintfmt+0x35c>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c010622e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106231:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106235:	8d 45 14             	lea    0x14(%ebp),%eax
c0106238:	89 04 24             	mov    %eax,(%esp)
c010623b:	e8 51 fc ff ff       	call   c0105e91 <getuint>
c0106240:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106243:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0106246:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c010624d:	eb 63                	jmp    c01062b2 <vprintfmt+0x35c>

        // pointer
        case 'p':
            putch('0', putdat);
c010624f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106252:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106256:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c010625d:	8b 45 08             	mov    0x8(%ebp),%eax
c0106260:	ff d0                	call   *%eax
            putch('x', putdat);
c0106262:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106265:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106269:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c0106270:	8b 45 08             	mov    0x8(%ebp),%eax
c0106273:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0106275:	8b 45 14             	mov    0x14(%ebp),%eax
c0106278:	8d 50 04             	lea    0x4(%eax),%edx
c010627b:	89 55 14             	mov    %edx,0x14(%ebp)
c010627e:	8b 00                	mov    (%eax),%eax
c0106280:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106283:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c010628a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0106291:	eb 1f                	jmp    c01062b2 <vprintfmt+0x35c>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0106293:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106296:	89 44 24 04          	mov    %eax,0x4(%esp)
c010629a:	8d 45 14             	lea    0x14(%ebp),%eax
c010629d:	89 04 24             	mov    %eax,(%esp)
c01062a0:	e8 ec fb ff ff       	call   c0105e91 <getuint>
c01062a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01062a8:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c01062ab:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c01062b2:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c01062b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01062b9:	89 54 24 18          	mov    %edx,0x18(%esp)
c01062bd:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01062c0:	89 54 24 14          	mov    %edx,0x14(%esp)
c01062c4:	89 44 24 10          	mov    %eax,0x10(%esp)
c01062c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01062cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01062ce:	89 44 24 08          	mov    %eax,0x8(%esp)
c01062d2:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01062d6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01062d9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01062dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01062e0:	89 04 24             	mov    %eax,(%esp)
c01062e3:	e8 a9 fa ff ff       	call   c0105d91 <printnum>
            break;
c01062e8:	eb 38                	jmp    c0106322 <vprintfmt+0x3cc>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c01062ea:	8b 45 0c             	mov    0xc(%ebp),%eax
c01062ed:	89 44 24 04          	mov    %eax,0x4(%esp)
c01062f1:	89 1c 24             	mov    %ebx,(%esp)
c01062f4:	8b 45 08             	mov    0x8(%ebp),%eax
c01062f7:	ff d0                	call   *%eax
            break;
c01062f9:	eb 27                	jmp    c0106322 <vprintfmt+0x3cc>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c01062fb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01062fe:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106302:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c0106309:	8b 45 08             	mov    0x8(%ebp),%eax
c010630c:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c010630e:	ff 4d 10             	decl   0x10(%ebp)
c0106311:	eb 03                	jmp    c0106316 <vprintfmt+0x3c0>
c0106313:	ff 4d 10             	decl   0x10(%ebp)
c0106316:	8b 45 10             	mov    0x10(%ebp),%eax
c0106319:	48                   	dec    %eax
c010631a:	0f b6 00             	movzbl (%eax),%eax
c010631d:	3c 25                	cmp    $0x25,%al
c010631f:	75 f2                	jne    c0106313 <vprintfmt+0x3bd>
                /* do nothing */;
            break;
c0106321:	90                   	nop
    while (1) {
c0106322:	e9 37 fc ff ff       	jmp    c0105f5e <vprintfmt+0x8>
                return;
c0106327:	90                   	nop
        }
    }
}
c0106328:	83 c4 40             	add    $0x40,%esp
c010632b:	5b                   	pop    %ebx
c010632c:	5e                   	pop    %esi
c010632d:	5d                   	pop    %ebp
c010632e:	c3                   	ret    

c010632f <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c010632f:	55                   	push   %ebp
c0106330:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0106332:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106335:	8b 40 08             	mov    0x8(%eax),%eax
c0106338:	8d 50 01             	lea    0x1(%eax),%edx
c010633b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010633e:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0106341:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106344:	8b 10                	mov    (%eax),%edx
c0106346:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106349:	8b 40 04             	mov    0x4(%eax),%eax
c010634c:	39 c2                	cmp    %eax,%edx
c010634e:	73 12                	jae    c0106362 <sprintputch+0x33>
        *b->buf ++ = ch;
c0106350:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106353:	8b 00                	mov    (%eax),%eax
c0106355:	8d 48 01             	lea    0x1(%eax),%ecx
c0106358:	8b 55 0c             	mov    0xc(%ebp),%edx
c010635b:	89 0a                	mov    %ecx,(%edx)
c010635d:	8b 55 08             	mov    0x8(%ebp),%edx
c0106360:	88 10                	mov    %dl,(%eax)
    }
}
c0106362:	90                   	nop
c0106363:	5d                   	pop    %ebp
c0106364:	c3                   	ret    

c0106365 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0106365:	55                   	push   %ebp
c0106366:	89 e5                	mov    %esp,%ebp
c0106368:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c010636b:	8d 45 14             	lea    0x14(%ebp),%eax
c010636e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0106371:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106374:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106378:	8b 45 10             	mov    0x10(%ebp),%eax
c010637b:	89 44 24 08          	mov    %eax,0x8(%esp)
c010637f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106382:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106386:	8b 45 08             	mov    0x8(%ebp),%eax
c0106389:	89 04 24             	mov    %eax,(%esp)
c010638c:	e8 08 00 00 00       	call   c0106399 <vsnprintf>
c0106391:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0106394:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106397:	c9                   	leave  
c0106398:	c3                   	ret    

c0106399 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0106399:	55                   	push   %ebp
c010639a:	89 e5                	mov    %esp,%ebp
c010639c:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c010639f:	8b 45 08             	mov    0x8(%ebp),%eax
c01063a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01063a5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01063a8:	8d 50 ff             	lea    -0x1(%eax),%edx
c01063ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01063ae:	01 d0                	add    %edx,%eax
c01063b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01063b3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c01063ba:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01063be:	74 0a                	je     c01063ca <vsnprintf+0x31>
c01063c0:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01063c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01063c6:	39 c2                	cmp    %eax,%edx
c01063c8:	76 07                	jbe    c01063d1 <vsnprintf+0x38>
        return -E_INVAL;
c01063ca:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c01063cf:	eb 2a                	jmp    c01063fb <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c01063d1:	8b 45 14             	mov    0x14(%ebp),%eax
c01063d4:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01063d8:	8b 45 10             	mov    0x10(%ebp),%eax
c01063db:	89 44 24 08          	mov    %eax,0x8(%esp)
c01063df:	8d 45 ec             	lea    -0x14(%ebp),%eax
c01063e2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01063e6:	c7 04 24 2f 63 10 c0 	movl   $0xc010632f,(%esp)
c01063ed:	e8 64 fb ff ff       	call   c0105f56 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c01063f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01063f5:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c01063f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01063fb:	c9                   	leave  
c01063fc:	c3                   	ret    
