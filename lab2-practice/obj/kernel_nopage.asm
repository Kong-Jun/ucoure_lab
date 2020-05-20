
bin/kernel_nopage：     文件格式 elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
  100000:	b8 00 a0 11 40       	mov    $0x4011a000,%eax
    movl %eax, %cr3
  100005:	0f 22 d8             	mov    %eax,%cr3

    # enable paging
    movl %cr0, %eax
  100008:	0f 20 c0             	mov    %cr0,%eax
    orl $(CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP), %eax
  10000b:	0d 2f 00 05 80       	or     $0x8005002f,%eax
    andl $~(CR0_TS | CR0_EM), %eax
  100010:	83 e0 f3             	and    $0xfffffff3,%eax
    movl %eax, %cr0
  100013:	0f 22 c0             	mov    %eax,%cr0

    # update eip
    # now, eip = 0x1.....
    leal next, %eax
  100016:	8d 05 1e 00 10 00    	lea    0x10001e,%eax
    # set eip = KERNBASE + 0x1.....
    jmp *%eax
  10001c:	ff e0                	jmp    *%eax

0010001e <next>:
next:

    # unmap va 0 ~ 4M, it's temporary mapping
    xorl %eax, %eax
  10001e:	31 c0                	xor    %eax,%eax
    movl %eax, __boot_pgdir
  100020:	a3 00 a0 11 00       	mov    %eax,0x11a000

    # set ebp, esp
    movl $0x0, %ebp
  100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10002a:	bc 00 90 11 00       	mov    $0x119000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  10002f:	e8 02 00 00 00       	call   100036 <kern_init>

00100034 <spin>:

# should never get here
spin:
    jmp spin
  100034:	eb fe                	jmp    100034 <spin>

00100036 <kern_init>:
static void lab1_print_cur_status(void);
static void lab1_switch_test(void);


int
kern_init(void) {
  100036:	55                   	push   %ebp
  100037:	89 e5                	mov    %esp,%ebp
  100039:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  10003c:	b8 48 cf 11 00       	mov    $0x11cf48,%eax
  100041:	2d 3c 9a 11 00       	sub    $0x119a3c,%eax
  100046:	89 44 24 08          	mov    %eax,0x8(%esp)
  10004a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100051:	00 
  100052:	c7 04 24 3c 9a 11 00 	movl   $0x119a3c,(%esp)
  100059:	e8 aa 5b 00 00       	call   105c08 <memset>

    cons_init();                // init the console
  10005e:	e8 8e 15 00 00       	call   1015f1 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100063:	c7 45 f4 00 64 10 00 	movl   $0x106400,-0xc(%ebp)
    cprintf("%s\n\n", message);
  10006a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10006d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100071:	c7 04 24 1c 64 10 00 	movl   $0x10641c,(%esp)
  100078:	e8 1d 02 00 00       	call   10029a <cprintf>

    print_kerninfo();
  10007d:	e8 b3 08 00 00       	call   100935 <print_kerninfo>

    grade_backtrace();
  100082:	e8 89 00 00 00       	call   100110 <grade_backtrace>

    pmm_init();                 // init physical memory management
  100087:	e8 35 35 00 00       	call   1035c1 <pmm_init>

    pic_init();                 // init interrupt controller
  10008c:	e8 c5 16 00 00       	call   101756 <pic_init>
    idt_init();                 // init interrupt descriptor table
  100091:	e8 4f 18 00 00       	call   1018e5 <idt_init>

    clock_init();               // init clock interrupt
  100096:	e8 f9 0c 00 00       	call   100d94 <clock_init>
    intr_enable();              // enable irq interrupt
  10009b:	e8 f0 17 00 00       	call   101890 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  1000a0:	eb fe                	jmp    1000a0 <kern_init+0x6a>

001000a2 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  1000a2:	55                   	push   %ebp
  1000a3:	89 e5                	mov    %esp,%ebp
  1000a5:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  1000a8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1000af:	00 
  1000b0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1000b7:	00 
  1000b8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000bf:	e8 be 0c 00 00       	call   100d82 <mon_backtrace>
}
  1000c4:	90                   	nop
  1000c5:	c9                   	leave  
  1000c6:	c3                   	ret    

001000c7 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000c7:	55                   	push   %ebp
  1000c8:	89 e5                	mov    %esp,%ebp
  1000ca:	53                   	push   %ebx
  1000cb:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000ce:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  1000d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  1000d4:	8d 5d 08             	lea    0x8(%ebp),%ebx
  1000d7:	8b 45 08             	mov    0x8(%ebp),%eax
  1000da:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1000de:	89 54 24 08          	mov    %edx,0x8(%esp)
  1000e2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1000e6:	89 04 24             	mov    %eax,(%esp)
  1000e9:	e8 b4 ff ff ff       	call   1000a2 <grade_backtrace2>
}
  1000ee:	90                   	nop
  1000ef:	83 c4 14             	add    $0x14,%esp
  1000f2:	5b                   	pop    %ebx
  1000f3:	5d                   	pop    %ebp
  1000f4:	c3                   	ret    

001000f5 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000f5:	55                   	push   %ebp
  1000f6:	89 e5                	mov    %esp,%ebp
  1000f8:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000fb:	8b 45 10             	mov    0x10(%ebp),%eax
  1000fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  100102:	8b 45 08             	mov    0x8(%ebp),%eax
  100105:	89 04 24             	mov    %eax,(%esp)
  100108:	e8 ba ff ff ff       	call   1000c7 <grade_backtrace1>
}
  10010d:	90                   	nop
  10010e:	c9                   	leave  
  10010f:	c3                   	ret    

00100110 <grade_backtrace>:

void
grade_backtrace(void) {
  100110:	55                   	push   %ebp
  100111:	89 e5                	mov    %esp,%ebp
  100113:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  100116:	b8 36 00 10 00       	mov    $0x100036,%eax
  10011b:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  100122:	ff 
  100123:	89 44 24 04          	mov    %eax,0x4(%esp)
  100127:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10012e:	e8 c2 ff ff ff       	call   1000f5 <grade_backtrace0>
}
  100133:	90                   	nop
  100134:	c9                   	leave  
  100135:	c3                   	ret    

00100136 <lab1_print_cur_status>:

/* print segment register info and privilege info */
static void
lab1_print_cur_status(void) {
  100136:	55                   	push   %ebp
  100137:	89 e5                	mov    %esp,%ebp
  100139:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  10013c:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  10013f:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100142:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100145:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100148:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10014c:	83 e0 03             	and    $0x3,%eax
  10014f:	89 c2                	mov    %eax,%edx
  100151:	a1 00 c0 11 00       	mov    0x11c000,%eax
  100156:	89 54 24 08          	mov    %edx,0x8(%esp)
  10015a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10015e:	c7 04 24 21 64 10 00 	movl   $0x106421,(%esp)
  100165:	e8 30 01 00 00       	call   10029a <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  10016a:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10016e:	89 c2                	mov    %eax,%edx
  100170:	a1 00 c0 11 00       	mov    0x11c000,%eax
  100175:	89 54 24 08          	mov    %edx,0x8(%esp)
  100179:	89 44 24 04          	mov    %eax,0x4(%esp)
  10017d:	c7 04 24 2f 64 10 00 	movl   $0x10642f,(%esp)
  100184:	e8 11 01 00 00       	call   10029a <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100189:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  10018d:	89 c2                	mov    %eax,%edx
  10018f:	a1 00 c0 11 00       	mov    0x11c000,%eax
  100194:	89 54 24 08          	mov    %edx,0x8(%esp)
  100198:	89 44 24 04          	mov    %eax,0x4(%esp)
  10019c:	c7 04 24 3d 64 10 00 	movl   $0x10643d,(%esp)
  1001a3:	e8 f2 00 00 00       	call   10029a <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001a8:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001ac:	89 c2                	mov    %eax,%edx
  1001ae:	a1 00 c0 11 00       	mov    0x11c000,%eax
  1001b3:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001bb:	c7 04 24 4b 64 10 00 	movl   $0x10644b,(%esp)
  1001c2:	e8 d3 00 00 00       	call   10029a <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001c7:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001cb:	89 c2                	mov    %eax,%edx
  1001cd:	a1 00 c0 11 00       	mov    0x11c000,%eax
  1001d2:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001da:	c7 04 24 59 64 10 00 	movl   $0x106459,(%esp)
  1001e1:	e8 b4 00 00 00       	call   10029a <cprintf>
    round ++;
  1001e6:	a1 00 c0 11 00       	mov    0x11c000,%eax
  1001eb:	40                   	inc    %eax
  1001ec:	a3 00 c0 11 00       	mov    %eax,0x11c000
}
  1001f1:	90                   	nop
  1001f2:	c9                   	leave  
  1001f3:	c3                   	ret    

001001f4 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001f4:	55                   	push   %ebp
  1001f5:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
	__asm__ __volatile__ (
  1001f7:	b8 23 00 00 00       	mov    $0x23,%eax
  1001fc:	50                   	push   %eax
  1001fd:	54                   	push   %esp
  1001fe:	cd 78                	int    $0x78
		"pushl %%esp\n\t"
		"int %0\n\t"
		:
		:"i" (T_SWITCH_TOU), "a" (USER_DS)
	);
}
  100200:	90                   	nop
  100201:	5d                   	pop    %ebp
  100202:	c3                   	ret    

00100203 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  100203:	55                   	push   %ebp
  100204:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
	__asm__ __volatile__ (
  100206:	cd 79                	int    $0x79
  100208:	5c                   	pop    %esp
		"int %0\n\t"
		"popl %%esp\n\t"
		:
		:"i" (T_SWITCH_TOK)
	);
}
  100209:	90                   	nop
  10020a:	5d                   	pop    %ebp
  10020b:	c3                   	ret    

0010020c <lab1_switch_test>:

static void
lab1_switch_test(void) {
  10020c:	55                   	push   %ebp
  10020d:	89 e5                	mov    %esp,%ebp
  10020f:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  100212:	e8 1f ff ff ff       	call   100136 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  100217:	c7 04 24 68 64 10 00 	movl   $0x106468,(%esp)
  10021e:	e8 77 00 00 00       	call   10029a <cprintf>
    lab1_switch_to_user();
  100223:	e8 cc ff ff ff       	call   1001f4 <lab1_switch_to_user>
    lab1_print_cur_status();
  100228:	e8 09 ff ff ff       	call   100136 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  10022d:	c7 04 24 88 64 10 00 	movl   $0x106488,(%esp)
  100234:	e8 61 00 00 00       	call   10029a <cprintf>
    lab1_switch_to_kernel();
  100239:	e8 c5 ff ff ff       	call   100203 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  10023e:	e8 f3 fe ff ff       	call   100136 <lab1_print_cur_status>
}
  100243:	90                   	nop
  100244:	c9                   	leave  
  100245:	c3                   	ret    

00100246 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  100246:	55                   	push   %ebp
  100247:	89 e5                	mov    %esp,%ebp
  100249:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  10024c:	8b 45 08             	mov    0x8(%ebp),%eax
  10024f:	89 04 24             	mov    %eax,(%esp)
  100252:	e8 c7 13 00 00       	call   10161e <cons_putc>
    (*cnt) ++;
  100257:	8b 45 0c             	mov    0xc(%ebp),%eax
  10025a:	8b 00                	mov    (%eax),%eax
  10025c:	8d 50 01             	lea    0x1(%eax),%edx
  10025f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100262:	89 10                	mov    %edx,(%eax)
}
  100264:	90                   	nop
  100265:	c9                   	leave  
  100266:	c3                   	ret    

00100267 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100267:	55                   	push   %ebp
  100268:	89 e5                	mov    %esp,%ebp
  10026a:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10026d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100274:	8b 45 0c             	mov    0xc(%ebp),%eax
  100277:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10027b:	8b 45 08             	mov    0x8(%ebp),%eax
  10027e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100282:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100285:	89 44 24 04          	mov    %eax,0x4(%esp)
  100289:	c7 04 24 46 02 10 00 	movl   $0x100246,(%esp)
  100290:	e8 c1 5c 00 00       	call   105f56 <vprintfmt>
    return cnt;
  100295:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100298:	c9                   	leave  
  100299:	c3                   	ret    

0010029a <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  10029a:	55                   	push   %ebp
  10029b:	89 e5                	mov    %esp,%ebp
  10029d:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  1002a0:	8d 45 0c             	lea    0xc(%ebp),%eax
  1002a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  1002a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1002ad:	8b 45 08             	mov    0x8(%ebp),%eax
  1002b0:	89 04 24             	mov    %eax,(%esp)
  1002b3:	e8 af ff ff ff       	call   100267 <vcprintf>
  1002b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1002bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002be:	c9                   	leave  
  1002bf:	c3                   	ret    

001002c0 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  1002c0:	55                   	push   %ebp
  1002c1:	89 e5                	mov    %esp,%ebp
  1002c3:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002c6:	8b 45 08             	mov    0x8(%ebp),%eax
  1002c9:	89 04 24             	mov    %eax,(%esp)
  1002cc:	e8 4d 13 00 00       	call   10161e <cons_putc>
}
  1002d1:	90                   	nop
  1002d2:	c9                   	leave  
  1002d3:	c3                   	ret    

001002d4 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  1002d4:	55                   	push   %ebp
  1002d5:	89 e5                	mov    %esp,%ebp
  1002d7:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  1002da:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  1002e1:	eb 13                	jmp    1002f6 <cputs+0x22>
        cputch(c, &cnt);
  1002e3:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  1002e7:	8d 55 f0             	lea    -0x10(%ebp),%edx
  1002ea:	89 54 24 04          	mov    %edx,0x4(%esp)
  1002ee:	89 04 24             	mov    %eax,(%esp)
  1002f1:	e8 50 ff ff ff       	call   100246 <cputch>
    while ((c = *str ++) != '\0') {
  1002f6:	8b 45 08             	mov    0x8(%ebp),%eax
  1002f9:	8d 50 01             	lea    0x1(%eax),%edx
  1002fc:	89 55 08             	mov    %edx,0x8(%ebp)
  1002ff:	0f b6 00             	movzbl (%eax),%eax
  100302:	88 45 f7             	mov    %al,-0x9(%ebp)
  100305:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  100309:	75 d8                	jne    1002e3 <cputs+0xf>
    }
    cputch('\n', &cnt);
  10030b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  10030e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100312:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  100319:	e8 28 ff ff ff       	call   100246 <cputch>
    return cnt;
  10031e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  100321:	c9                   	leave  
  100322:	c3                   	ret    

00100323 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  100323:	55                   	push   %ebp
  100324:	89 e5                	mov    %esp,%ebp
  100326:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  100329:	90                   	nop
  10032a:	e8 2c 13 00 00       	call   10165b <cons_getc>
  10032f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100332:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100336:	74 f2                	je     10032a <getchar+0x7>
        /* do nothing */;
    return c;
  100338:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10033b:	c9                   	leave  
  10033c:	c3                   	ret    

0010033d <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  10033d:	55                   	push   %ebp
  10033e:	89 e5                	mov    %esp,%ebp
  100340:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100343:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100347:	74 13                	je     10035c <readline+0x1f>
        cprintf("%s", prompt);
  100349:	8b 45 08             	mov    0x8(%ebp),%eax
  10034c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100350:	c7 04 24 a7 64 10 00 	movl   $0x1064a7,(%esp)
  100357:	e8 3e ff ff ff       	call   10029a <cprintf>
    }
    int i = 0, c;
  10035c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100363:	e8 bb ff ff ff       	call   100323 <getchar>
  100368:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  10036b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10036f:	79 07                	jns    100378 <readline+0x3b>
            return NULL;
  100371:	b8 00 00 00 00       	mov    $0x0,%eax
  100376:	eb 78                	jmp    1003f0 <readline+0xb3>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100378:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  10037c:	7e 28                	jle    1003a6 <readline+0x69>
  10037e:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100385:	7f 1f                	jg     1003a6 <readline+0x69>
            cputchar(c);
  100387:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10038a:	89 04 24             	mov    %eax,(%esp)
  10038d:	e8 2e ff ff ff       	call   1002c0 <cputchar>
            buf[i ++] = c;
  100392:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100395:	8d 50 01             	lea    0x1(%eax),%edx
  100398:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10039b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10039e:	88 90 20 c0 11 00    	mov    %dl,0x11c020(%eax)
  1003a4:	eb 45                	jmp    1003eb <readline+0xae>
        }
        else if (c == '\b' && i > 0) {
  1003a6:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1003aa:	75 16                	jne    1003c2 <readline+0x85>
  1003ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003b0:	7e 10                	jle    1003c2 <readline+0x85>
            cputchar(c);
  1003b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003b5:	89 04 24             	mov    %eax,(%esp)
  1003b8:	e8 03 ff ff ff       	call   1002c0 <cputchar>
            i --;
  1003bd:	ff 4d f4             	decl   -0xc(%ebp)
  1003c0:	eb 29                	jmp    1003eb <readline+0xae>
        }
        else if (c == '\n' || c == '\r') {
  1003c2:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1003c6:	74 06                	je     1003ce <readline+0x91>
  1003c8:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1003cc:	75 95                	jne    100363 <readline+0x26>
            cputchar(c);
  1003ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003d1:	89 04 24             	mov    %eax,(%esp)
  1003d4:	e8 e7 fe ff ff       	call   1002c0 <cputchar>
            buf[i] = '\0';
  1003d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003dc:	05 20 c0 11 00       	add    $0x11c020,%eax
  1003e1:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1003e4:	b8 20 c0 11 00       	mov    $0x11c020,%eax
  1003e9:	eb 05                	jmp    1003f0 <readline+0xb3>
        c = getchar();
  1003eb:	e9 73 ff ff ff       	jmp    100363 <readline+0x26>
        }
    }
}
  1003f0:	c9                   	leave  
  1003f1:	c3                   	ret    

001003f2 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  1003f2:	55                   	push   %ebp
  1003f3:	89 e5                	mov    %esp,%ebp
  1003f5:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  1003f8:	a1 20 c4 11 00       	mov    0x11c420,%eax
  1003fd:	85 c0                	test   %eax,%eax
  1003ff:	75 5b                	jne    10045c <__panic+0x6a>
        goto panic_dead;
    }
    is_panic = 1;
  100401:	c7 05 20 c4 11 00 01 	movl   $0x1,0x11c420
  100408:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  10040b:	8d 45 14             	lea    0x14(%ebp),%eax
  10040e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100411:	8b 45 0c             	mov    0xc(%ebp),%eax
  100414:	89 44 24 08          	mov    %eax,0x8(%esp)
  100418:	8b 45 08             	mov    0x8(%ebp),%eax
  10041b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10041f:	c7 04 24 aa 64 10 00 	movl   $0x1064aa,(%esp)
  100426:	e8 6f fe ff ff       	call   10029a <cprintf>
    vcprintf(fmt, ap);
  10042b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10042e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100432:	8b 45 10             	mov    0x10(%ebp),%eax
  100435:	89 04 24             	mov    %eax,(%esp)
  100438:	e8 2a fe ff ff       	call   100267 <vcprintf>
    cprintf("\n");
  10043d:	c7 04 24 c6 64 10 00 	movl   $0x1064c6,(%esp)
  100444:	e8 51 fe ff ff       	call   10029a <cprintf>
    
    cprintf("stack trackback:\n");
  100449:	c7 04 24 c8 64 10 00 	movl   $0x1064c8,(%esp)
  100450:	e8 45 fe ff ff       	call   10029a <cprintf>
    print_stackframe();
  100455:	e8 21 06 00 00       	call   100a7b <print_stackframe>
  10045a:	eb 01                	jmp    10045d <__panic+0x6b>
        goto panic_dead;
  10045c:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
  10045d:	e8 35 14 00 00       	call   101897 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100462:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100469:	e8 47 08 00 00       	call   100cb5 <kmonitor>
  10046e:	eb f2                	jmp    100462 <__panic+0x70>

00100470 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100470:	55                   	push   %ebp
  100471:	89 e5                	mov    %esp,%ebp
  100473:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100476:	8d 45 14             	lea    0x14(%ebp),%eax
  100479:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  10047c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10047f:	89 44 24 08          	mov    %eax,0x8(%esp)
  100483:	8b 45 08             	mov    0x8(%ebp),%eax
  100486:	89 44 24 04          	mov    %eax,0x4(%esp)
  10048a:	c7 04 24 da 64 10 00 	movl   $0x1064da,(%esp)
  100491:	e8 04 fe ff ff       	call   10029a <cprintf>
    vcprintf(fmt, ap);
  100496:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100499:	89 44 24 04          	mov    %eax,0x4(%esp)
  10049d:	8b 45 10             	mov    0x10(%ebp),%eax
  1004a0:	89 04 24             	mov    %eax,(%esp)
  1004a3:	e8 bf fd ff ff       	call   100267 <vcprintf>
    cprintf("\n");
  1004a8:	c7 04 24 c6 64 10 00 	movl   $0x1064c6,(%esp)
  1004af:	e8 e6 fd ff ff       	call   10029a <cprintf>
    va_end(ap);
}
  1004b4:	90                   	nop
  1004b5:	c9                   	leave  
  1004b6:	c3                   	ret    

001004b7 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  1004b7:	55                   	push   %ebp
  1004b8:	89 e5                	mov    %esp,%ebp
    return is_panic;
  1004ba:	a1 20 c4 11 00       	mov    0x11c420,%eax
}
  1004bf:	5d                   	pop    %ebp
  1004c0:	c3                   	ret    

001004c1 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1004c1:	55                   	push   %ebp
  1004c2:	89 e5                	mov    %esp,%ebp
  1004c4:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1004c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004ca:	8b 00                	mov    (%eax),%eax
  1004cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1004cf:	8b 45 10             	mov    0x10(%ebp),%eax
  1004d2:	8b 00                	mov    (%eax),%eax
  1004d4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004d7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1004de:	e9 ca 00 00 00       	jmp    1005ad <stab_binsearch+0xec>
        int true_m = (l + r) / 2, m = true_m;
  1004e3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1004e9:	01 d0                	add    %edx,%eax
  1004eb:	89 c2                	mov    %eax,%edx
  1004ed:	c1 ea 1f             	shr    $0x1f,%edx
  1004f0:	01 d0                	add    %edx,%eax
  1004f2:	d1 f8                	sar    %eax
  1004f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1004f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004fa:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1004fd:	eb 03                	jmp    100502 <stab_binsearch+0x41>
            m --;
  1004ff:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  100502:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100505:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100508:	7c 1f                	jl     100529 <stab_binsearch+0x68>
  10050a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10050d:	89 d0                	mov    %edx,%eax
  10050f:	01 c0                	add    %eax,%eax
  100511:	01 d0                	add    %edx,%eax
  100513:	c1 e0 02             	shl    $0x2,%eax
  100516:	89 c2                	mov    %eax,%edx
  100518:	8b 45 08             	mov    0x8(%ebp),%eax
  10051b:	01 d0                	add    %edx,%eax
  10051d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100521:	0f b6 c0             	movzbl %al,%eax
  100524:	39 45 14             	cmp    %eax,0x14(%ebp)
  100527:	75 d6                	jne    1004ff <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
  100529:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10052c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10052f:	7d 09                	jge    10053a <stab_binsearch+0x79>
            l = true_m + 1;
  100531:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100534:	40                   	inc    %eax
  100535:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100538:	eb 73                	jmp    1005ad <stab_binsearch+0xec>
        }

        // actual binary search
        any_matches = 1;
  10053a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100541:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100544:	89 d0                	mov    %edx,%eax
  100546:	01 c0                	add    %eax,%eax
  100548:	01 d0                	add    %edx,%eax
  10054a:	c1 e0 02             	shl    $0x2,%eax
  10054d:	89 c2                	mov    %eax,%edx
  10054f:	8b 45 08             	mov    0x8(%ebp),%eax
  100552:	01 d0                	add    %edx,%eax
  100554:	8b 40 08             	mov    0x8(%eax),%eax
  100557:	39 45 18             	cmp    %eax,0x18(%ebp)
  10055a:	76 11                	jbe    10056d <stab_binsearch+0xac>
            *region_left = m;
  10055c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10055f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100562:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100564:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100567:	40                   	inc    %eax
  100568:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10056b:	eb 40                	jmp    1005ad <stab_binsearch+0xec>
        } else if (stabs[m].n_value > addr) {
  10056d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100570:	89 d0                	mov    %edx,%eax
  100572:	01 c0                	add    %eax,%eax
  100574:	01 d0                	add    %edx,%eax
  100576:	c1 e0 02             	shl    $0x2,%eax
  100579:	89 c2                	mov    %eax,%edx
  10057b:	8b 45 08             	mov    0x8(%ebp),%eax
  10057e:	01 d0                	add    %edx,%eax
  100580:	8b 40 08             	mov    0x8(%eax),%eax
  100583:	39 45 18             	cmp    %eax,0x18(%ebp)
  100586:	73 14                	jae    10059c <stab_binsearch+0xdb>
            *region_right = m - 1;
  100588:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10058b:	8d 50 ff             	lea    -0x1(%eax),%edx
  10058e:	8b 45 10             	mov    0x10(%ebp),%eax
  100591:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  100593:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100596:	48                   	dec    %eax
  100597:	89 45 f8             	mov    %eax,-0x8(%ebp)
  10059a:	eb 11                	jmp    1005ad <stab_binsearch+0xec>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  10059c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10059f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005a2:	89 10                	mov    %edx,(%eax)
            l = m;
  1005a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1005aa:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
  1005ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1005b0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1005b3:	0f 8e 2a ff ff ff    	jle    1004e3 <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
  1005b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1005bd:	75 0f                	jne    1005ce <stab_binsearch+0x10d>
        *region_right = *region_left - 1;
  1005bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005c2:	8b 00                	mov    (%eax),%eax
  1005c4:	8d 50 ff             	lea    -0x1(%eax),%edx
  1005c7:	8b 45 10             	mov    0x10(%ebp),%eax
  1005ca:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  1005cc:	eb 3e                	jmp    10060c <stab_binsearch+0x14b>
        l = *region_right;
  1005ce:	8b 45 10             	mov    0x10(%ebp),%eax
  1005d1:	8b 00                	mov    (%eax),%eax
  1005d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1005d6:	eb 03                	jmp    1005db <stab_binsearch+0x11a>
  1005d8:	ff 4d fc             	decl   -0x4(%ebp)
  1005db:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005de:	8b 00                	mov    (%eax),%eax
  1005e0:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  1005e3:	7e 1f                	jle    100604 <stab_binsearch+0x143>
  1005e5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005e8:	89 d0                	mov    %edx,%eax
  1005ea:	01 c0                	add    %eax,%eax
  1005ec:	01 d0                	add    %edx,%eax
  1005ee:	c1 e0 02             	shl    $0x2,%eax
  1005f1:	89 c2                	mov    %eax,%edx
  1005f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1005f6:	01 d0                	add    %edx,%eax
  1005f8:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1005fc:	0f b6 c0             	movzbl %al,%eax
  1005ff:	39 45 14             	cmp    %eax,0x14(%ebp)
  100602:	75 d4                	jne    1005d8 <stab_binsearch+0x117>
        *region_left = l;
  100604:	8b 45 0c             	mov    0xc(%ebp),%eax
  100607:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10060a:	89 10                	mov    %edx,(%eax)
}
  10060c:	90                   	nop
  10060d:	c9                   	leave  
  10060e:	c3                   	ret    

0010060f <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  10060f:	55                   	push   %ebp
  100610:	89 e5                	mov    %esp,%ebp
  100612:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100615:	8b 45 0c             	mov    0xc(%ebp),%eax
  100618:	c7 00 f8 64 10 00    	movl   $0x1064f8,(%eax)
    info->eip_line = 0;
  10061e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100621:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100628:	8b 45 0c             	mov    0xc(%ebp),%eax
  10062b:	c7 40 08 f8 64 10 00 	movl   $0x1064f8,0x8(%eax)
    info->eip_fn_namelen = 9;
  100632:	8b 45 0c             	mov    0xc(%ebp),%eax
  100635:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  10063c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10063f:	8b 55 08             	mov    0x8(%ebp),%edx
  100642:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100645:	8b 45 0c             	mov    0xc(%ebp),%eax
  100648:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  10064f:	c7 45 f4 18 78 10 00 	movl   $0x107818,-0xc(%ebp)
    stab_end = __STAB_END__;
  100656:	c7 45 f0 b4 41 11 00 	movl   $0x1141b4,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  10065d:	c7 45 ec b5 41 11 00 	movl   $0x1141b5,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100664:	c7 45 e8 42 6d 11 00 	movl   $0x116d42,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  10066b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10066e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100671:	76 0b                	jbe    10067e <debuginfo_eip+0x6f>
  100673:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100676:	48                   	dec    %eax
  100677:	0f b6 00             	movzbl (%eax),%eax
  10067a:	84 c0                	test   %al,%al
  10067c:	74 0a                	je     100688 <debuginfo_eip+0x79>
        return -1;
  10067e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100683:	e9 ab 02 00 00       	jmp    100933 <debuginfo_eip+0x324>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  100688:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  10068f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100692:	2b 45 f4             	sub    -0xc(%ebp),%eax
  100695:	c1 f8 02             	sar    $0x2,%eax
  100698:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  10069e:	48                   	dec    %eax
  10069f:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1006a2:	8b 45 08             	mov    0x8(%ebp),%eax
  1006a5:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006a9:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1006b0:	00 
  1006b1:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1006b4:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006b8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1006bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006c2:	89 04 24             	mov    %eax,(%esp)
  1006c5:	e8 f7 fd ff ff       	call   1004c1 <stab_binsearch>
    if (lfile == 0)
  1006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006cd:	85 c0                	test   %eax,%eax
  1006cf:	75 0a                	jne    1006db <debuginfo_eip+0xcc>
        return -1;
  1006d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006d6:	e9 58 02 00 00       	jmp    100933 <debuginfo_eip+0x324>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1006db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006de:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1006e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006e4:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1006e7:	8b 45 08             	mov    0x8(%ebp),%eax
  1006ea:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006ee:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  1006f5:	00 
  1006f6:	8d 45 d8             	lea    -0x28(%ebp),%eax
  1006f9:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006fd:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100700:	89 44 24 04          	mov    %eax,0x4(%esp)
  100704:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100707:	89 04 24             	mov    %eax,(%esp)
  10070a:	e8 b2 fd ff ff       	call   1004c1 <stab_binsearch>

    if (lfun <= rfun) {
  10070f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100712:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100715:	39 c2                	cmp    %eax,%edx
  100717:	7f 78                	jg     100791 <debuginfo_eip+0x182>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  100719:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10071c:	89 c2                	mov    %eax,%edx
  10071e:	89 d0                	mov    %edx,%eax
  100720:	01 c0                	add    %eax,%eax
  100722:	01 d0                	add    %edx,%eax
  100724:	c1 e0 02             	shl    $0x2,%eax
  100727:	89 c2                	mov    %eax,%edx
  100729:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10072c:	01 d0                	add    %edx,%eax
  10072e:	8b 10                	mov    (%eax),%edx
  100730:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100733:	2b 45 ec             	sub    -0x14(%ebp),%eax
  100736:	39 c2                	cmp    %eax,%edx
  100738:	73 22                	jae    10075c <debuginfo_eip+0x14d>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  10073a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10073d:	89 c2                	mov    %eax,%edx
  10073f:	89 d0                	mov    %edx,%eax
  100741:	01 c0                	add    %eax,%eax
  100743:	01 d0                	add    %edx,%eax
  100745:	c1 e0 02             	shl    $0x2,%eax
  100748:	89 c2                	mov    %eax,%edx
  10074a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10074d:	01 d0                	add    %edx,%eax
  10074f:	8b 10                	mov    (%eax),%edx
  100751:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100754:	01 c2                	add    %eax,%edx
  100756:	8b 45 0c             	mov    0xc(%ebp),%eax
  100759:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  10075c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10075f:	89 c2                	mov    %eax,%edx
  100761:	89 d0                	mov    %edx,%eax
  100763:	01 c0                	add    %eax,%eax
  100765:	01 d0                	add    %edx,%eax
  100767:	c1 e0 02             	shl    $0x2,%eax
  10076a:	89 c2                	mov    %eax,%edx
  10076c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10076f:	01 d0                	add    %edx,%eax
  100771:	8b 50 08             	mov    0x8(%eax),%edx
  100774:	8b 45 0c             	mov    0xc(%ebp),%eax
  100777:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  10077a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10077d:	8b 40 10             	mov    0x10(%eax),%eax
  100780:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  100783:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100786:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  100789:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10078c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10078f:	eb 15                	jmp    1007a6 <debuginfo_eip+0x197>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  100791:	8b 45 0c             	mov    0xc(%ebp),%eax
  100794:	8b 55 08             	mov    0x8(%ebp),%edx
  100797:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  10079a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10079d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1007a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1007a3:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1007a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007a9:	8b 40 08             	mov    0x8(%eax),%eax
  1007ac:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1007b3:	00 
  1007b4:	89 04 24             	mov    %eax,(%esp)
  1007b7:	e8 c8 52 00 00       	call   105a84 <strfind>
  1007bc:	89 c2                	mov    %eax,%edx
  1007be:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007c1:	8b 40 08             	mov    0x8(%eax),%eax
  1007c4:	29 c2                	sub    %eax,%edx
  1007c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007c9:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1007cc:	8b 45 08             	mov    0x8(%ebp),%eax
  1007cf:	89 44 24 10          	mov    %eax,0x10(%esp)
  1007d3:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1007da:	00 
  1007db:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1007de:	89 44 24 08          	mov    %eax,0x8(%esp)
  1007e2:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1007e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1007e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007ec:	89 04 24             	mov    %eax,(%esp)
  1007ef:	e8 cd fc ff ff       	call   1004c1 <stab_binsearch>
    if (lline <= rline) {
  1007f4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007f7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007fa:	39 c2                	cmp    %eax,%edx
  1007fc:	7f 23                	jg     100821 <debuginfo_eip+0x212>
        info->eip_line = stabs[rline].n_desc;
  1007fe:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100801:	89 c2                	mov    %eax,%edx
  100803:	89 d0                	mov    %edx,%eax
  100805:	01 c0                	add    %eax,%eax
  100807:	01 d0                	add    %edx,%eax
  100809:	c1 e0 02             	shl    $0x2,%eax
  10080c:	89 c2                	mov    %eax,%edx
  10080e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100811:	01 d0                	add    %edx,%eax
  100813:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100817:	89 c2                	mov    %eax,%edx
  100819:	8b 45 0c             	mov    0xc(%ebp),%eax
  10081c:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  10081f:	eb 11                	jmp    100832 <debuginfo_eip+0x223>
        return -1;
  100821:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100826:	e9 08 01 00 00       	jmp    100933 <debuginfo_eip+0x324>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  10082b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10082e:	48                   	dec    %eax
  10082f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  100832:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100835:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100838:	39 c2                	cmp    %eax,%edx
  10083a:	7c 56                	jl     100892 <debuginfo_eip+0x283>
           && stabs[lline].n_type != N_SOL
  10083c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10083f:	89 c2                	mov    %eax,%edx
  100841:	89 d0                	mov    %edx,%eax
  100843:	01 c0                	add    %eax,%eax
  100845:	01 d0                	add    %edx,%eax
  100847:	c1 e0 02             	shl    $0x2,%eax
  10084a:	89 c2                	mov    %eax,%edx
  10084c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10084f:	01 d0                	add    %edx,%eax
  100851:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100855:	3c 84                	cmp    $0x84,%al
  100857:	74 39                	je     100892 <debuginfo_eip+0x283>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100859:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10085c:	89 c2                	mov    %eax,%edx
  10085e:	89 d0                	mov    %edx,%eax
  100860:	01 c0                	add    %eax,%eax
  100862:	01 d0                	add    %edx,%eax
  100864:	c1 e0 02             	shl    $0x2,%eax
  100867:	89 c2                	mov    %eax,%edx
  100869:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10086c:	01 d0                	add    %edx,%eax
  10086e:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100872:	3c 64                	cmp    $0x64,%al
  100874:	75 b5                	jne    10082b <debuginfo_eip+0x21c>
  100876:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100879:	89 c2                	mov    %eax,%edx
  10087b:	89 d0                	mov    %edx,%eax
  10087d:	01 c0                	add    %eax,%eax
  10087f:	01 d0                	add    %edx,%eax
  100881:	c1 e0 02             	shl    $0x2,%eax
  100884:	89 c2                	mov    %eax,%edx
  100886:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100889:	01 d0                	add    %edx,%eax
  10088b:	8b 40 08             	mov    0x8(%eax),%eax
  10088e:	85 c0                	test   %eax,%eax
  100890:	74 99                	je     10082b <debuginfo_eip+0x21c>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  100892:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100895:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100898:	39 c2                	cmp    %eax,%edx
  10089a:	7c 42                	jl     1008de <debuginfo_eip+0x2cf>
  10089c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10089f:	89 c2                	mov    %eax,%edx
  1008a1:	89 d0                	mov    %edx,%eax
  1008a3:	01 c0                	add    %eax,%eax
  1008a5:	01 d0                	add    %edx,%eax
  1008a7:	c1 e0 02             	shl    $0x2,%eax
  1008aa:	89 c2                	mov    %eax,%edx
  1008ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008af:	01 d0                	add    %edx,%eax
  1008b1:	8b 10                	mov    (%eax),%edx
  1008b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1008b6:	2b 45 ec             	sub    -0x14(%ebp),%eax
  1008b9:	39 c2                	cmp    %eax,%edx
  1008bb:	73 21                	jae    1008de <debuginfo_eip+0x2cf>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1008bd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008c0:	89 c2                	mov    %eax,%edx
  1008c2:	89 d0                	mov    %edx,%eax
  1008c4:	01 c0                	add    %eax,%eax
  1008c6:	01 d0                	add    %edx,%eax
  1008c8:	c1 e0 02             	shl    $0x2,%eax
  1008cb:	89 c2                	mov    %eax,%edx
  1008cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008d0:	01 d0                	add    %edx,%eax
  1008d2:	8b 10                	mov    (%eax),%edx
  1008d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1008d7:	01 c2                	add    %eax,%edx
  1008d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008dc:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1008de:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1008e1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1008e4:	39 c2                	cmp    %eax,%edx
  1008e6:	7d 46                	jge    10092e <debuginfo_eip+0x31f>
        for (lline = lfun + 1;
  1008e8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1008eb:	40                   	inc    %eax
  1008ec:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1008ef:	eb 16                	jmp    100907 <debuginfo_eip+0x2f8>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  1008f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008f4:	8b 40 14             	mov    0x14(%eax),%eax
  1008f7:	8d 50 01             	lea    0x1(%eax),%edx
  1008fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008fd:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  100900:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100903:	40                   	inc    %eax
  100904:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100907:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10090a:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
  10090d:	39 c2                	cmp    %eax,%edx
  10090f:	7d 1d                	jge    10092e <debuginfo_eip+0x31f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100911:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100914:	89 c2                	mov    %eax,%edx
  100916:	89 d0                	mov    %edx,%eax
  100918:	01 c0                	add    %eax,%eax
  10091a:	01 d0                	add    %edx,%eax
  10091c:	c1 e0 02             	shl    $0x2,%eax
  10091f:	89 c2                	mov    %eax,%edx
  100921:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100924:	01 d0                	add    %edx,%eax
  100926:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10092a:	3c a0                	cmp    $0xa0,%al
  10092c:	74 c3                	je     1008f1 <debuginfo_eip+0x2e2>
        }
    }
    return 0;
  10092e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100933:	c9                   	leave  
  100934:	c3                   	ret    

00100935 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100935:	55                   	push   %ebp
  100936:	89 e5                	mov    %esp,%ebp
  100938:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  10093b:	c7 04 24 02 65 10 00 	movl   $0x106502,(%esp)
  100942:	e8 53 f9 ff ff       	call   10029a <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100947:	c7 44 24 04 36 00 10 	movl   $0x100036,0x4(%esp)
  10094e:	00 
  10094f:	c7 04 24 1b 65 10 00 	movl   $0x10651b,(%esp)
  100956:	e8 3f f9 ff ff       	call   10029a <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  10095b:	c7 44 24 04 fd 63 10 	movl   $0x1063fd,0x4(%esp)
  100962:	00 
  100963:	c7 04 24 33 65 10 00 	movl   $0x106533,(%esp)
  10096a:	e8 2b f9 ff ff       	call   10029a <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  10096f:	c7 44 24 04 3c 9a 11 	movl   $0x119a3c,0x4(%esp)
  100976:	00 
  100977:	c7 04 24 4b 65 10 00 	movl   $0x10654b,(%esp)
  10097e:	e8 17 f9 ff ff       	call   10029a <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  100983:	c7 44 24 04 48 cf 11 	movl   $0x11cf48,0x4(%esp)
  10098a:	00 
  10098b:	c7 04 24 63 65 10 00 	movl   $0x106563,(%esp)
  100992:	e8 03 f9 ff ff       	call   10029a <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  100997:	b8 48 cf 11 00       	mov    $0x11cf48,%eax
  10099c:	2d 36 00 10 00       	sub    $0x100036,%eax
  1009a1:	05 ff 03 00 00       	add    $0x3ff,%eax
  1009a6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1009ac:	85 c0                	test   %eax,%eax
  1009ae:	0f 48 c2             	cmovs  %edx,%eax
  1009b1:	c1 f8 0a             	sar    $0xa,%eax
  1009b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009b8:	c7 04 24 7c 65 10 00 	movl   $0x10657c,(%esp)
  1009bf:	e8 d6 f8 ff ff       	call   10029a <cprintf>
}
  1009c4:	90                   	nop
  1009c5:	c9                   	leave  
  1009c6:	c3                   	ret    

001009c7 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1009c7:	55                   	push   %ebp
  1009c8:	89 e5                	mov    %esp,%ebp
  1009ca:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1009d0:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1009d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009d7:	8b 45 08             	mov    0x8(%ebp),%eax
  1009da:	89 04 24             	mov    %eax,(%esp)
  1009dd:	e8 2d fc ff ff       	call   10060f <debuginfo_eip>
  1009e2:	85 c0                	test   %eax,%eax
  1009e4:	74 15                	je     1009fb <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  1009e6:	8b 45 08             	mov    0x8(%ebp),%eax
  1009e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009ed:	c7 04 24 a6 65 10 00 	movl   $0x1065a6,(%esp)
  1009f4:	e8 a1 f8 ff ff       	call   10029a <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  1009f9:	eb 6c                	jmp    100a67 <print_debuginfo+0xa0>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009fb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100a02:	eb 1b                	jmp    100a1f <print_debuginfo+0x58>
            fnname[j] = info.eip_fn_name[j];
  100a04:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100a07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a0a:	01 d0                	add    %edx,%eax
  100a0c:	0f b6 10             	movzbl (%eax),%edx
  100a0f:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a18:	01 c8                	add    %ecx,%eax
  100a1a:	88 10                	mov    %dl,(%eax)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a1c:	ff 45 f4             	incl   -0xc(%ebp)
  100a1f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a22:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  100a25:	7c dd                	jl     100a04 <print_debuginfo+0x3d>
        fnname[j] = '\0';
  100a27:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100a2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a30:	01 d0                	add    %edx,%eax
  100a32:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
  100a35:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100a38:	8b 55 08             	mov    0x8(%ebp),%edx
  100a3b:	89 d1                	mov    %edx,%ecx
  100a3d:	29 c1                	sub    %eax,%ecx
  100a3f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100a42:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100a45:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100a49:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a4f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100a53:	89 54 24 08          	mov    %edx,0x8(%esp)
  100a57:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a5b:	c7 04 24 c2 65 10 00 	movl   $0x1065c2,(%esp)
  100a62:	e8 33 f8 ff ff       	call   10029a <cprintf>
}
  100a67:	90                   	nop
  100a68:	c9                   	leave  
  100a69:	c3                   	ret    

00100a6a <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100a6a:	55                   	push   %ebp
  100a6b:	89 e5                	mov    %esp,%ebp
  100a6d:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100a70:	8b 45 04             	mov    0x4(%ebp),%eax
  100a73:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100a76:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100a79:	c9                   	leave  
  100a7a:	c3                   	ret    

00100a7b <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100a7b:	55                   	push   %ebp
  100a7c:	89 e5                	mov    %esp,%ebp
  100a7e:	83 ec 38             	sub    $0x38,%esp

	/* In my version, I don't popup the calling stackframe. After exeution of print_stackframe,
	 * PC still point to current stackframe(the stackframe of print_stackframe()) 
	 */
	uint32_t eip, ebp;
	size_t i = 0, j = 0;
  100a81:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100a88:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	eip = read_eip();
  100a8f:	e8 d6 ff ff ff       	call   100a6a <read_eip>
  100a94:	89 45 f4             	mov    %eax,-0xc(%ebp)
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100a97:	89 e8                	mov    %ebp,%eax
  100a99:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return ebp;
  100a9c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
	ebp = read_ebp();
  100a9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i++) {
  100aa2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100aa9:	e9 88 00 00 00       	jmp    100b36 <print_stackframe+0xbb>
		cprintf("ebp:0x%08x eip:0x%08x ", ebp, eip);
  100aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ab1:	89 44 24 08          	mov    %eax,0x8(%esp)
  100ab5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100ab8:	89 44 24 04          	mov    %eax,0x4(%esp)
  100abc:	c7 04 24 d4 65 10 00 	movl   $0x1065d4,(%esp)
  100ac3:	e8 d2 f7 ff ff       	call   10029a <cprintf>
		cprintf("args:");
  100ac8:	c7 04 24 eb 65 10 00 	movl   $0x1065eb,(%esp)
  100acf:	e8 c6 f7 ff ff       	call   10029a <cprintf>
		for(j = 0; j < 4; j++) {
  100ad4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100adb:	eb 25                	jmp    100b02 <print_stackframe+0x87>
			cprintf("0x%08x ", (uint32_t*)(ebp) + 2 + j);
  100add:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100ae0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100ae7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100aea:	01 d0                	add    %edx,%eax
  100aec:	83 c0 08             	add    $0x8,%eax
  100aef:	89 44 24 04          	mov    %eax,0x4(%esp)
  100af3:	c7 04 24 f1 65 10 00 	movl   $0x1065f1,(%esp)
  100afa:	e8 9b f7 ff ff       	call   10029a <cprintf>
		for(j = 0; j < 4; j++) {
  100aff:	ff 45 e8             	incl   -0x18(%ebp)
  100b02:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100b06:	76 d5                	jbe    100add <print_stackframe+0x62>
		}
		cprintf("\n");
  100b08:	c7 04 24 f9 65 10 00 	movl   $0x1065f9,(%esp)
  100b0f:	e8 86 f7 ff ff       	call   10029a <cprintf>
		print_debuginfo(eip - 1);
  100b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b17:	48                   	dec    %eax
  100b18:	89 04 24             	mov    %eax,(%esp)
  100b1b:	e8 a7 fe ff ff       	call   1009c7 <print_debuginfo>
		ebp = *((uint32_t *)ebp);		
  100b20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100b23:	8b 00                	mov    (%eax),%eax
  100b25:	89 45 f0             	mov    %eax,-0x10(%ebp)
		eip = *((uint32_t *)ebp + 1);
  100b28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100b2b:	83 c0 04             	add    $0x4,%eax
  100b2e:	8b 00                	mov    (%eax),%eax
  100b30:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i++) {
  100b33:	ff 45 ec             	incl   -0x14(%ebp)
  100b36:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b3a:	74 0a                	je     100b46 <print_stackframe+0xcb>
  100b3c:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100b40:	0f 86 68 ff ff ff    	jbe    100aae <print_stackframe+0x33>
        ebp = ((uint32_t *)ebp)[0];
    }
	*/


}
  100b46:	90                   	nop
  100b47:	c9                   	leave  
  100b48:	c3                   	ret    

00100b49 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100b49:	55                   	push   %ebp
  100b4a:	89 e5                	mov    %esp,%ebp
  100b4c:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100b4f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b56:	eb 0c                	jmp    100b64 <parse+0x1b>
            *buf ++ = '\0';
  100b58:	8b 45 08             	mov    0x8(%ebp),%eax
  100b5b:	8d 50 01             	lea    0x1(%eax),%edx
  100b5e:	89 55 08             	mov    %edx,0x8(%ebp)
  100b61:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b64:	8b 45 08             	mov    0x8(%ebp),%eax
  100b67:	0f b6 00             	movzbl (%eax),%eax
  100b6a:	84 c0                	test   %al,%al
  100b6c:	74 1d                	je     100b8b <parse+0x42>
  100b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  100b71:	0f b6 00             	movzbl (%eax),%eax
  100b74:	0f be c0             	movsbl %al,%eax
  100b77:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b7b:	c7 04 24 7c 66 10 00 	movl   $0x10667c,(%esp)
  100b82:	e8 cb 4e 00 00       	call   105a52 <strchr>
  100b87:	85 c0                	test   %eax,%eax
  100b89:	75 cd                	jne    100b58 <parse+0xf>
        }
        if (*buf == '\0') {
  100b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  100b8e:	0f b6 00             	movzbl (%eax),%eax
  100b91:	84 c0                	test   %al,%al
  100b93:	74 65                	je     100bfa <parse+0xb1>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100b95:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100b99:	75 14                	jne    100baf <parse+0x66>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100b9b:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100ba2:	00 
  100ba3:	c7 04 24 81 66 10 00 	movl   $0x106681,(%esp)
  100baa:	e8 eb f6 ff ff       	call   10029a <cprintf>
        }
        argv[argc ++] = buf;
  100baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bb2:	8d 50 01             	lea    0x1(%eax),%edx
  100bb5:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100bb8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100bbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  100bc2:	01 c2                	add    %eax,%edx
  100bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  100bc7:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100bc9:	eb 03                	jmp    100bce <parse+0x85>
            buf ++;
  100bcb:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100bce:	8b 45 08             	mov    0x8(%ebp),%eax
  100bd1:	0f b6 00             	movzbl (%eax),%eax
  100bd4:	84 c0                	test   %al,%al
  100bd6:	74 8c                	je     100b64 <parse+0x1b>
  100bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  100bdb:	0f b6 00             	movzbl (%eax),%eax
  100bde:	0f be c0             	movsbl %al,%eax
  100be1:	89 44 24 04          	mov    %eax,0x4(%esp)
  100be5:	c7 04 24 7c 66 10 00 	movl   $0x10667c,(%esp)
  100bec:	e8 61 4e 00 00       	call   105a52 <strchr>
  100bf1:	85 c0                	test   %eax,%eax
  100bf3:	74 d6                	je     100bcb <parse+0x82>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100bf5:	e9 6a ff ff ff       	jmp    100b64 <parse+0x1b>
            break;
  100bfa:	90                   	nop
        }
    }
    return argc;
  100bfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100bfe:	c9                   	leave  
  100bff:	c3                   	ret    

00100c00 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100c00:	55                   	push   %ebp
  100c01:	89 e5                	mov    %esp,%ebp
  100c03:	53                   	push   %ebx
  100c04:	83 ec 64             	sub    $0x64,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100c07:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c0a:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  100c11:	89 04 24             	mov    %eax,(%esp)
  100c14:	e8 30 ff ff ff       	call   100b49 <parse>
  100c19:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100c1c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100c20:	75 0a                	jne    100c2c <runcmd+0x2c>
        return 0;
  100c22:	b8 00 00 00 00       	mov    $0x0,%eax
  100c27:	e9 83 00 00 00       	jmp    100caf <runcmd+0xaf>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c2c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c33:	eb 5a                	jmp    100c8f <runcmd+0x8f>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100c35:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100c38:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c3b:	89 d0                	mov    %edx,%eax
  100c3d:	01 c0                	add    %eax,%eax
  100c3f:	01 d0                	add    %edx,%eax
  100c41:	c1 e0 02             	shl    $0x2,%eax
  100c44:	05 00 90 11 00       	add    $0x119000,%eax
  100c49:	8b 00                	mov    (%eax),%eax
  100c4b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100c4f:	89 04 24             	mov    %eax,(%esp)
  100c52:	e8 5e 4d 00 00       	call   1059b5 <strcmp>
  100c57:	85 c0                	test   %eax,%eax
  100c59:	75 31                	jne    100c8c <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100c5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c5e:	89 d0                	mov    %edx,%eax
  100c60:	01 c0                	add    %eax,%eax
  100c62:	01 d0                	add    %edx,%eax
  100c64:	c1 e0 02             	shl    $0x2,%eax
  100c67:	05 08 90 11 00       	add    $0x119008,%eax
  100c6c:	8b 10                	mov    (%eax),%edx
  100c6e:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c71:	83 c0 04             	add    $0x4,%eax
  100c74:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100c77:	8d 59 ff             	lea    -0x1(%ecx),%ebx
  100c7a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100c7d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c81:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c85:	89 1c 24             	mov    %ebx,(%esp)
  100c88:	ff d2                	call   *%edx
  100c8a:	eb 23                	jmp    100caf <runcmd+0xaf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100c8c:	ff 45 f4             	incl   -0xc(%ebp)
  100c8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c92:	83 f8 02             	cmp    $0x2,%eax
  100c95:	76 9e                	jbe    100c35 <runcmd+0x35>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100c97:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100c9a:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c9e:	c7 04 24 9f 66 10 00 	movl   $0x10669f,(%esp)
  100ca5:	e8 f0 f5 ff ff       	call   10029a <cprintf>
    return 0;
  100caa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100caf:	83 c4 64             	add    $0x64,%esp
  100cb2:	5b                   	pop    %ebx
  100cb3:	5d                   	pop    %ebp
  100cb4:	c3                   	ret    

00100cb5 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100cb5:	55                   	push   %ebp
  100cb6:	89 e5                	mov    %esp,%ebp
  100cb8:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100cbb:	c7 04 24 b8 66 10 00 	movl   $0x1066b8,(%esp)
  100cc2:	e8 d3 f5 ff ff       	call   10029a <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100cc7:	c7 04 24 e0 66 10 00 	movl   $0x1066e0,(%esp)
  100cce:	e8 c7 f5 ff ff       	call   10029a <cprintf>

    if (tf != NULL) {
  100cd3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100cd7:	74 0b                	je     100ce4 <kmonitor+0x2f>
        print_trapframe(tf);
  100cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  100cdc:	89 04 24             	mov    %eax,(%esp)
  100cdf:	e8 b2 0e 00 00       	call   101b96 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100ce4:	c7 04 24 05 67 10 00 	movl   $0x106705,(%esp)
  100ceb:	e8 4d f6 ff ff       	call   10033d <readline>
  100cf0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100cf3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100cf7:	74 eb                	je     100ce4 <kmonitor+0x2f>
            if (runcmd(buf, tf) < 0) {
  100cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  100cfc:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d03:	89 04 24             	mov    %eax,(%esp)
  100d06:	e8 f5 fe ff ff       	call   100c00 <runcmd>
  100d0b:	85 c0                	test   %eax,%eax
  100d0d:	78 02                	js     100d11 <kmonitor+0x5c>
        if ((buf = readline("K> ")) != NULL) {
  100d0f:	eb d3                	jmp    100ce4 <kmonitor+0x2f>
                break;
  100d11:	90                   	nop
            }
        }
    }
}
  100d12:	90                   	nop
  100d13:	c9                   	leave  
  100d14:	c3                   	ret    

00100d15 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100d15:	55                   	push   %ebp
  100d16:	89 e5                	mov    %esp,%ebp
  100d18:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100d1b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100d22:	eb 3d                	jmp    100d61 <mon_help+0x4c>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100d24:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d27:	89 d0                	mov    %edx,%eax
  100d29:	01 c0                	add    %eax,%eax
  100d2b:	01 d0                	add    %edx,%eax
  100d2d:	c1 e0 02             	shl    $0x2,%eax
  100d30:	05 04 90 11 00       	add    $0x119004,%eax
  100d35:	8b 08                	mov    (%eax),%ecx
  100d37:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d3a:	89 d0                	mov    %edx,%eax
  100d3c:	01 c0                	add    %eax,%eax
  100d3e:	01 d0                	add    %edx,%eax
  100d40:	c1 e0 02             	shl    $0x2,%eax
  100d43:	05 00 90 11 00       	add    $0x119000,%eax
  100d48:	8b 00                	mov    (%eax),%eax
  100d4a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100d4e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d52:	c7 04 24 09 67 10 00 	movl   $0x106709,(%esp)
  100d59:	e8 3c f5 ff ff       	call   10029a <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100d5e:	ff 45 f4             	incl   -0xc(%ebp)
  100d61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d64:	83 f8 02             	cmp    $0x2,%eax
  100d67:	76 bb                	jbe    100d24 <mon_help+0xf>
    }
    return 0;
  100d69:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d6e:	c9                   	leave  
  100d6f:	c3                   	ret    

00100d70 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100d70:	55                   	push   %ebp
  100d71:	89 e5                	mov    %esp,%ebp
  100d73:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100d76:	e8 ba fb ff ff       	call   100935 <print_kerninfo>
    return 0;
  100d7b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d80:	c9                   	leave  
  100d81:	c3                   	ret    

00100d82 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100d82:	55                   	push   %ebp
  100d83:	89 e5                	mov    %esp,%ebp
  100d85:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100d88:	e8 ee fc ff ff       	call   100a7b <print_stackframe>
    return 0;
  100d8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d92:	c9                   	leave  
  100d93:	c3                   	ret    

00100d94 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d94:	55                   	push   %ebp
  100d95:	89 e5                	mov    %esp,%ebp
  100d97:	83 ec 28             	sub    $0x28,%esp
  100d9a:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100da0:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100da4:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100da8:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100dac:	ee                   	out    %al,(%dx)
  100dad:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100db3:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100db7:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100dbb:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100dbf:	ee                   	out    %al,(%dx)
  100dc0:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100dc6:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
  100dca:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100dce:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100dd2:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100dd3:	c7 05 2c cf 11 00 00 	movl   $0x0,0x11cf2c
  100dda:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100ddd:	c7 04 24 12 67 10 00 	movl   $0x106712,(%esp)
  100de4:	e8 b1 f4 ff ff       	call   10029a <cprintf>
    pic_enable(IRQ_TIMER);
  100de9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100df0:	e8 2e 09 00 00       	call   101723 <pic_enable>
}
  100df5:	90                   	nop
  100df6:	c9                   	leave  
  100df7:	c3                   	ret    

00100df8 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100df8:	55                   	push   %ebp
  100df9:	89 e5                	mov    %esp,%ebp
  100dfb:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100dfe:	9c                   	pushf  
  100dff:	58                   	pop    %eax
  100e00:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100e03:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100e06:	25 00 02 00 00       	and    $0x200,%eax
  100e0b:	85 c0                	test   %eax,%eax
  100e0d:	74 0c                	je     100e1b <__intr_save+0x23>
        intr_disable();
  100e0f:	e8 83 0a 00 00       	call   101897 <intr_disable>
        return 1;
  100e14:	b8 01 00 00 00       	mov    $0x1,%eax
  100e19:	eb 05                	jmp    100e20 <__intr_save+0x28>
    }
    return 0;
  100e1b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100e20:	c9                   	leave  
  100e21:	c3                   	ret    

00100e22 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100e22:	55                   	push   %ebp
  100e23:	89 e5                	mov    %esp,%ebp
  100e25:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100e28:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100e2c:	74 05                	je     100e33 <__intr_restore+0x11>
        intr_enable();
  100e2e:	e8 5d 0a 00 00       	call   101890 <intr_enable>
    }
}
  100e33:	90                   	nop
  100e34:	c9                   	leave  
  100e35:	c3                   	ret    

00100e36 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e36:	55                   	push   %ebp
  100e37:	89 e5                	mov    %esp,%ebp
  100e39:	83 ec 10             	sub    $0x10,%esp
  100e3c:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e42:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e46:	89 c2                	mov    %eax,%edx
  100e48:	ec                   	in     (%dx),%al
  100e49:	88 45 f1             	mov    %al,-0xf(%ebp)
  100e4c:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e52:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e56:	89 c2                	mov    %eax,%edx
  100e58:	ec                   	in     (%dx),%al
  100e59:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e5c:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e62:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e66:	89 c2                	mov    %eax,%edx
  100e68:	ec                   	in     (%dx),%al
  100e69:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e6c:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  100e72:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e76:	89 c2                	mov    %eax,%edx
  100e78:	ec                   	in     (%dx),%al
  100e79:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e7c:	90                   	nop
  100e7d:	c9                   	leave  
  100e7e:	c3                   	ret    

00100e7f <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100e7f:	55                   	push   %ebp
  100e80:	89 e5                	mov    %esp,%ebp
  100e82:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100e85:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100e8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e8f:	0f b7 00             	movzwl (%eax),%eax
  100e92:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100e96:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e99:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100e9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ea1:	0f b7 00             	movzwl (%eax),%eax
  100ea4:	0f b7 c0             	movzwl %ax,%eax
  100ea7:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
  100eac:	74 12                	je     100ec0 <cga_init+0x41>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100eae:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100eb5:	66 c7 05 46 c4 11 00 	movw   $0x3b4,0x11c446
  100ebc:	b4 03 
  100ebe:	eb 13                	jmp    100ed3 <cga_init+0x54>
    } else {
        *cp = was;
  100ec0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ec3:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100ec7:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100eca:	66 c7 05 46 c4 11 00 	movw   $0x3d4,0x11c446
  100ed1:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100ed3:	0f b7 05 46 c4 11 00 	movzwl 0x11c446,%eax
  100eda:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100ede:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ee2:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100ee6:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100eea:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100eeb:	0f b7 05 46 c4 11 00 	movzwl 0x11c446,%eax
  100ef2:	40                   	inc    %eax
  100ef3:	0f b7 c0             	movzwl %ax,%eax
  100ef6:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100efa:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
  100efe:	89 c2                	mov    %eax,%edx
  100f00:	ec                   	in     (%dx),%al
  100f01:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  100f04:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f08:	0f b6 c0             	movzbl %al,%eax
  100f0b:	c1 e0 08             	shl    $0x8,%eax
  100f0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100f11:	0f b7 05 46 c4 11 00 	movzwl 0x11c446,%eax
  100f18:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100f1c:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f20:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f24:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f28:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100f29:	0f b7 05 46 c4 11 00 	movzwl 0x11c446,%eax
  100f30:	40                   	inc    %eax
  100f31:	0f b7 c0             	movzwl %ax,%eax
  100f34:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f38:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100f3c:	89 c2                	mov    %eax,%edx
  100f3e:	ec                   	in     (%dx),%al
  100f3f:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  100f42:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f46:	0f b6 c0             	movzbl %al,%eax
  100f49:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100f4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f4f:	a3 40 c4 11 00       	mov    %eax,0x11c440
    crt_pos = pos;
  100f54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f57:	0f b7 c0             	movzwl %ax,%eax
  100f5a:	66 a3 44 c4 11 00    	mov    %ax,0x11c444
}
  100f60:	90                   	nop
  100f61:	c9                   	leave  
  100f62:	c3                   	ret    

00100f63 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f63:	55                   	push   %ebp
  100f64:	89 e5                	mov    %esp,%ebp
  100f66:	83 ec 48             	sub    $0x48,%esp
  100f69:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  100f6f:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f73:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  100f77:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  100f7b:	ee                   	out    %al,(%dx)
  100f7c:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  100f82:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
  100f86:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  100f8a:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  100f8e:	ee                   	out    %al,(%dx)
  100f8f:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  100f95:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
  100f99:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  100f9d:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  100fa1:	ee                   	out    %al,(%dx)
  100fa2:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100fa8:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
  100fac:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100fb0:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100fb4:	ee                   	out    %al,(%dx)
  100fb5:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  100fbb:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
  100fbf:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100fc3:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100fc7:	ee                   	out    %al,(%dx)
  100fc8:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  100fce:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
  100fd2:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100fd6:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100fda:	ee                   	out    %al,(%dx)
  100fdb:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100fe1:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
  100fe5:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100fe9:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100fed:	ee                   	out    %al,(%dx)
  100fee:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100ff4:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100ff8:	89 c2                	mov    %eax,%edx
  100ffa:	ec                   	in     (%dx),%al
  100ffb:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100ffe:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  101002:	3c ff                	cmp    $0xff,%al
  101004:	0f 95 c0             	setne  %al
  101007:	0f b6 c0             	movzbl %al,%eax
  10100a:	a3 48 c4 11 00       	mov    %eax,0x11c448
  10100f:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101015:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  101019:	89 c2                	mov    %eax,%edx
  10101b:	ec                   	in     (%dx),%al
  10101c:	88 45 f1             	mov    %al,-0xf(%ebp)
  10101f:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101025:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101029:	89 c2                	mov    %eax,%edx
  10102b:	ec                   	in     (%dx),%al
  10102c:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  10102f:	a1 48 c4 11 00       	mov    0x11c448,%eax
  101034:	85 c0                	test   %eax,%eax
  101036:	74 0c                	je     101044 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  101038:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  10103f:	e8 df 06 00 00       	call   101723 <pic_enable>
    }
}
  101044:	90                   	nop
  101045:	c9                   	leave  
  101046:	c3                   	ret    

00101047 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  101047:	55                   	push   %ebp
  101048:	89 e5                	mov    %esp,%ebp
  10104a:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  10104d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101054:	eb 08                	jmp    10105e <lpt_putc_sub+0x17>
        delay();
  101056:	e8 db fd ff ff       	call   100e36 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  10105b:	ff 45 fc             	incl   -0x4(%ebp)
  10105e:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  101064:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101068:	89 c2                	mov    %eax,%edx
  10106a:	ec                   	in     (%dx),%al
  10106b:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10106e:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101072:	84 c0                	test   %al,%al
  101074:	78 09                	js     10107f <lpt_putc_sub+0x38>
  101076:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10107d:	7e d7                	jle    101056 <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
  10107f:	8b 45 08             	mov    0x8(%ebp),%eax
  101082:	0f b6 c0             	movzbl %al,%eax
  101085:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  10108b:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10108e:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101092:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101096:	ee                   	out    %al,(%dx)
  101097:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  10109d:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  1010a1:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1010a5:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1010a9:	ee                   	out    %al,(%dx)
  1010aa:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  1010b0:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
  1010b4:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1010b8:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1010bc:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  1010bd:	90                   	nop
  1010be:	c9                   	leave  
  1010bf:	c3                   	ret    

001010c0 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  1010c0:	55                   	push   %ebp
  1010c1:	89 e5                	mov    %esp,%ebp
  1010c3:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1010c6:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1010ca:	74 0d                	je     1010d9 <lpt_putc+0x19>
        lpt_putc_sub(c);
  1010cc:	8b 45 08             	mov    0x8(%ebp),%eax
  1010cf:	89 04 24             	mov    %eax,(%esp)
  1010d2:	e8 70 ff ff ff       	call   101047 <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  1010d7:	eb 24                	jmp    1010fd <lpt_putc+0x3d>
        lpt_putc_sub('\b');
  1010d9:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010e0:	e8 62 ff ff ff       	call   101047 <lpt_putc_sub>
        lpt_putc_sub(' ');
  1010e5:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1010ec:	e8 56 ff ff ff       	call   101047 <lpt_putc_sub>
        lpt_putc_sub('\b');
  1010f1:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010f8:	e8 4a ff ff ff       	call   101047 <lpt_putc_sub>
}
  1010fd:	90                   	nop
  1010fe:	c9                   	leave  
  1010ff:	c3                   	ret    

00101100 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101100:	55                   	push   %ebp
  101101:	89 e5                	mov    %esp,%ebp
  101103:	53                   	push   %ebx
  101104:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  101107:	8b 45 08             	mov    0x8(%ebp),%eax
  10110a:	25 00 ff ff ff       	and    $0xffffff00,%eax
  10110f:	85 c0                	test   %eax,%eax
  101111:	75 07                	jne    10111a <cga_putc+0x1a>
        c |= 0x0700;
  101113:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  10111a:	8b 45 08             	mov    0x8(%ebp),%eax
  10111d:	0f b6 c0             	movzbl %al,%eax
  101120:	83 f8 0a             	cmp    $0xa,%eax
  101123:	74 55                	je     10117a <cga_putc+0x7a>
  101125:	83 f8 0d             	cmp    $0xd,%eax
  101128:	74 63                	je     10118d <cga_putc+0x8d>
  10112a:	83 f8 08             	cmp    $0x8,%eax
  10112d:	0f 85 94 00 00 00    	jne    1011c7 <cga_putc+0xc7>
    case '\b':
        if (crt_pos > 0) {
  101133:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  10113a:	85 c0                	test   %eax,%eax
  10113c:	0f 84 af 00 00 00    	je     1011f1 <cga_putc+0xf1>
            crt_pos --;
  101142:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  101149:	48                   	dec    %eax
  10114a:	0f b7 c0             	movzwl %ax,%eax
  10114d:	66 a3 44 c4 11 00    	mov    %ax,0x11c444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  101153:	8b 45 08             	mov    0x8(%ebp),%eax
  101156:	98                   	cwtl   
  101157:	25 00 ff ff ff       	and    $0xffffff00,%eax
  10115c:	98                   	cwtl   
  10115d:	83 c8 20             	or     $0x20,%eax
  101160:	98                   	cwtl   
  101161:	8b 15 40 c4 11 00    	mov    0x11c440,%edx
  101167:	0f b7 0d 44 c4 11 00 	movzwl 0x11c444,%ecx
  10116e:	01 c9                	add    %ecx,%ecx
  101170:	01 ca                	add    %ecx,%edx
  101172:	0f b7 c0             	movzwl %ax,%eax
  101175:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  101178:	eb 77                	jmp    1011f1 <cga_putc+0xf1>
    case '\n':
        crt_pos += CRT_COLS;
  10117a:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  101181:	83 c0 50             	add    $0x50,%eax
  101184:	0f b7 c0             	movzwl %ax,%eax
  101187:	66 a3 44 c4 11 00    	mov    %ax,0x11c444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  10118d:	0f b7 1d 44 c4 11 00 	movzwl 0x11c444,%ebx
  101194:	0f b7 0d 44 c4 11 00 	movzwl 0x11c444,%ecx
  10119b:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  1011a0:	89 c8                	mov    %ecx,%eax
  1011a2:	f7 e2                	mul    %edx
  1011a4:	c1 ea 06             	shr    $0x6,%edx
  1011a7:	89 d0                	mov    %edx,%eax
  1011a9:	c1 e0 02             	shl    $0x2,%eax
  1011ac:	01 d0                	add    %edx,%eax
  1011ae:	c1 e0 04             	shl    $0x4,%eax
  1011b1:	29 c1                	sub    %eax,%ecx
  1011b3:	89 c8                	mov    %ecx,%eax
  1011b5:	0f b7 c0             	movzwl %ax,%eax
  1011b8:	29 c3                	sub    %eax,%ebx
  1011ba:	89 d8                	mov    %ebx,%eax
  1011bc:	0f b7 c0             	movzwl %ax,%eax
  1011bf:	66 a3 44 c4 11 00    	mov    %ax,0x11c444
        break;
  1011c5:	eb 2b                	jmp    1011f2 <cga_putc+0xf2>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1011c7:	8b 0d 40 c4 11 00    	mov    0x11c440,%ecx
  1011cd:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  1011d4:	8d 50 01             	lea    0x1(%eax),%edx
  1011d7:	0f b7 d2             	movzwl %dx,%edx
  1011da:	66 89 15 44 c4 11 00 	mov    %dx,0x11c444
  1011e1:	01 c0                	add    %eax,%eax
  1011e3:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  1011e6:	8b 45 08             	mov    0x8(%ebp),%eax
  1011e9:	0f b7 c0             	movzwl %ax,%eax
  1011ec:	66 89 02             	mov    %ax,(%edx)
        break;
  1011ef:	eb 01                	jmp    1011f2 <cga_putc+0xf2>
        break;
  1011f1:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  1011f2:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  1011f9:	3d cf 07 00 00       	cmp    $0x7cf,%eax
  1011fe:	76 5d                	jbe    10125d <cga_putc+0x15d>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101200:	a1 40 c4 11 00       	mov    0x11c440,%eax
  101205:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  10120b:	a1 40 c4 11 00       	mov    0x11c440,%eax
  101210:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  101217:	00 
  101218:	89 54 24 04          	mov    %edx,0x4(%esp)
  10121c:	89 04 24             	mov    %eax,(%esp)
  10121f:	e8 24 4a 00 00       	call   105c48 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101224:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  10122b:	eb 14                	jmp    101241 <cga_putc+0x141>
            crt_buf[i] = 0x0700 | ' ';
  10122d:	a1 40 c4 11 00       	mov    0x11c440,%eax
  101232:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101235:	01 d2                	add    %edx,%edx
  101237:	01 d0                	add    %edx,%eax
  101239:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10123e:	ff 45 f4             	incl   -0xc(%ebp)
  101241:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  101248:	7e e3                	jle    10122d <cga_putc+0x12d>
        }
        crt_pos -= CRT_COLS;
  10124a:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  101251:	83 e8 50             	sub    $0x50,%eax
  101254:	0f b7 c0             	movzwl %ax,%eax
  101257:	66 a3 44 c4 11 00    	mov    %ax,0x11c444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  10125d:	0f b7 05 46 c4 11 00 	movzwl 0x11c446,%eax
  101264:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  101268:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
  10126c:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101270:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101274:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  101275:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  10127c:	c1 e8 08             	shr    $0x8,%eax
  10127f:	0f b7 c0             	movzwl %ax,%eax
  101282:	0f b6 c0             	movzbl %al,%eax
  101285:	0f b7 15 46 c4 11 00 	movzwl 0x11c446,%edx
  10128c:	42                   	inc    %edx
  10128d:	0f b7 d2             	movzwl %dx,%edx
  101290:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  101294:	88 45 e9             	mov    %al,-0x17(%ebp)
  101297:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10129b:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10129f:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  1012a0:	0f b7 05 46 c4 11 00 	movzwl 0x11c446,%eax
  1012a7:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  1012ab:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
  1012af:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1012b3:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1012b7:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  1012b8:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  1012bf:	0f b6 c0             	movzbl %al,%eax
  1012c2:	0f b7 15 46 c4 11 00 	movzwl 0x11c446,%edx
  1012c9:	42                   	inc    %edx
  1012ca:	0f b7 d2             	movzwl %dx,%edx
  1012cd:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  1012d1:	88 45 f1             	mov    %al,-0xf(%ebp)
  1012d4:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1012d8:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1012dc:	ee                   	out    %al,(%dx)
}
  1012dd:	90                   	nop
  1012de:	83 c4 34             	add    $0x34,%esp
  1012e1:	5b                   	pop    %ebx
  1012e2:	5d                   	pop    %ebp
  1012e3:	c3                   	ret    

001012e4 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  1012e4:	55                   	push   %ebp
  1012e5:	89 e5                	mov    %esp,%ebp
  1012e7:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012ea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1012f1:	eb 08                	jmp    1012fb <serial_putc_sub+0x17>
        delay();
  1012f3:	e8 3e fb ff ff       	call   100e36 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012f8:	ff 45 fc             	incl   -0x4(%ebp)
  1012fb:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101301:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101305:	89 c2                	mov    %eax,%edx
  101307:	ec                   	in     (%dx),%al
  101308:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10130b:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10130f:	0f b6 c0             	movzbl %al,%eax
  101312:	83 e0 20             	and    $0x20,%eax
  101315:	85 c0                	test   %eax,%eax
  101317:	75 09                	jne    101322 <serial_putc_sub+0x3e>
  101319:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101320:	7e d1                	jle    1012f3 <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
  101322:	8b 45 08             	mov    0x8(%ebp),%eax
  101325:	0f b6 c0             	movzbl %al,%eax
  101328:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  10132e:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101331:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101335:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101339:	ee                   	out    %al,(%dx)
}
  10133a:	90                   	nop
  10133b:	c9                   	leave  
  10133c:	c3                   	ret    

0010133d <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  10133d:	55                   	push   %ebp
  10133e:	89 e5                	mov    %esp,%ebp
  101340:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101343:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101347:	74 0d                	je     101356 <serial_putc+0x19>
        serial_putc_sub(c);
  101349:	8b 45 08             	mov    0x8(%ebp),%eax
  10134c:	89 04 24             	mov    %eax,(%esp)
  10134f:	e8 90 ff ff ff       	call   1012e4 <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  101354:	eb 24                	jmp    10137a <serial_putc+0x3d>
        serial_putc_sub('\b');
  101356:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10135d:	e8 82 ff ff ff       	call   1012e4 <serial_putc_sub>
        serial_putc_sub(' ');
  101362:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101369:	e8 76 ff ff ff       	call   1012e4 <serial_putc_sub>
        serial_putc_sub('\b');
  10136e:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101375:	e8 6a ff ff ff       	call   1012e4 <serial_putc_sub>
}
  10137a:	90                   	nop
  10137b:	c9                   	leave  
  10137c:	c3                   	ret    

0010137d <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  10137d:	55                   	push   %ebp
  10137e:	89 e5                	mov    %esp,%ebp
  101380:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  101383:	eb 33                	jmp    1013b8 <cons_intr+0x3b>
        if (c != 0) {
  101385:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  101389:	74 2d                	je     1013b8 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  10138b:	a1 64 c6 11 00       	mov    0x11c664,%eax
  101390:	8d 50 01             	lea    0x1(%eax),%edx
  101393:	89 15 64 c6 11 00    	mov    %edx,0x11c664
  101399:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10139c:	88 90 60 c4 11 00    	mov    %dl,0x11c460(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  1013a2:	a1 64 c6 11 00       	mov    0x11c664,%eax
  1013a7:	3d 00 02 00 00       	cmp    $0x200,%eax
  1013ac:	75 0a                	jne    1013b8 <cons_intr+0x3b>
                cons.wpos = 0;
  1013ae:	c7 05 64 c6 11 00 00 	movl   $0x0,0x11c664
  1013b5:	00 00 00 
    while ((c = (*proc)()) != -1) {
  1013b8:	8b 45 08             	mov    0x8(%ebp),%eax
  1013bb:	ff d0                	call   *%eax
  1013bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1013c0:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  1013c4:	75 bf                	jne    101385 <cons_intr+0x8>
            }
        }
    }
}
  1013c6:	90                   	nop
  1013c7:	c9                   	leave  
  1013c8:	c3                   	ret    

001013c9 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  1013c9:	55                   	push   %ebp
  1013ca:	89 e5                	mov    %esp,%ebp
  1013cc:	83 ec 10             	sub    $0x10,%esp
  1013cf:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013d5:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1013d9:	89 c2                	mov    %eax,%edx
  1013db:	ec                   	in     (%dx),%al
  1013dc:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1013df:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  1013e3:	0f b6 c0             	movzbl %al,%eax
  1013e6:	83 e0 01             	and    $0x1,%eax
  1013e9:	85 c0                	test   %eax,%eax
  1013eb:	75 07                	jne    1013f4 <serial_proc_data+0x2b>
        return -1;
  1013ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013f2:	eb 2a                	jmp    10141e <serial_proc_data+0x55>
  1013f4:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013fa:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1013fe:	89 c2                	mov    %eax,%edx
  101400:	ec                   	in     (%dx),%al
  101401:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  101404:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  101408:	0f b6 c0             	movzbl %al,%eax
  10140b:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  10140e:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  101412:	75 07                	jne    10141b <serial_proc_data+0x52>
        c = '\b';
  101414:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  10141b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10141e:	c9                   	leave  
  10141f:	c3                   	ret    

00101420 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101420:	55                   	push   %ebp
  101421:	89 e5                	mov    %esp,%ebp
  101423:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  101426:	a1 48 c4 11 00       	mov    0x11c448,%eax
  10142b:	85 c0                	test   %eax,%eax
  10142d:	74 0c                	je     10143b <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  10142f:	c7 04 24 c9 13 10 00 	movl   $0x1013c9,(%esp)
  101436:	e8 42 ff ff ff       	call   10137d <cons_intr>
    }
}
  10143b:	90                   	nop
  10143c:	c9                   	leave  
  10143d:	c3                   	ret    

0010143e <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  10143e:	55                   	push   %ebp
  10143f:	89 e5                	mov    %esp,%ebp
  101441:	83 ec 38             	sub    $0x38,%esp
  101444:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10144a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10144d:	89 c2                	mov    %eax,%edx
  10144f:	ec                   	in     (%dx),%al
  101450:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  101453:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  101457:	0f b6 c0             	movzbl %al,%eax
  10145a:	83 e0 01             	and    $0x1,%eax
  10145d:	85 c0                	test   %eax,%eax
  10145f:	75 0a                	jne    10146b <kbd_proc_data+0x2d>
        return -1;
  101461:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101466:	e9 55 01 00 00       	jmp    1015c0 <kbd_proc_data+0x182>
  10146b:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101471:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101474:	89 c2                	mov    %eax,%edx
  101476:	ec                   	in     (%dx),%al
  101477:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  10147a:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  10147e:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  101481:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101485:	75 17                	jne    10149e <kbd_proc_data+0x60>
        // E0 escape character
        shift |= E0ESC;
  101487:	a1 68 c6 11 00       	mov    0x11c668,%eax
  10148c:	83 c8 40             	or     $0x40,%eax
  10148f:	a3 68 c6 11 00       	mov    %eax,0x11c668
        return 0;
  101494:	b8 00 00 00 00       	mov    $0x0,%eax
  101499:	e9 22 01 00 00       	jmp    1015c0 <kbd_proc_data+0x182>
    } else if (data & 0x80) {
  10149e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014a2:	84 c0                	test   %al,%al
  1014a4:	79 45                	jns    1014eb <kbd_proc_data+0xad>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  1014a6:	a1 68 c6 11 00       	mov    0x11c668,%eax
  1014ab:	83 e0 40             	and    $0x40,%eax
  1014ae:	85 c0                	test   %eax,%eax
  1014b0:	75 08                	jne    1014ba <kbd_proc_data+0x7c>
  1014b2:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014b6:	24 7f                	and    $0x7f,%al
  1014b8:	eb 04                	jmp    1014be <kbd_proc_data+0x80>
  1014ba:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014be:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  1014c1:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014c5:	0f b6 80 40 90 11 00 	movzbl 0x119040(%eax),%eax
  1014cc:	0c 40                	or     $0x40,%al
  1014ce:	0f b6 c0             	movzbl %al,%eax
  1014d1:	f7 d0                	not    %eax
  1014d3:	89 c2                	mov    %eax,%edx
  1014d5:	a1 68 c6 11 00       	mov    0x11c668,%eax
  1014da:	21 d0                	and    %edx,%eax
  1014dc:	a3 68 c6 11 00       	mov    %eax,0x11c668
        return 0;
  1014e1:	b8 00 00 00 00       	mov    $0x0,%eax
  1014e6:	e9 d5 00 00 00       	jmp    1015c0 <kbd_proc_data+0x182>
    } else if (shift & E0ESC) {
  1014eb:	a1 68 c6 11 00       	mov    0x11c668,%eax
  1014f0:	83 e0 40             	and    $0x40,%eax
  1014f3:	85 c0                	test   %eax,%eax
  1014f5:	74 11                	je     101508 <kbd_proc_data+0xca>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1014f7:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1014fb:	a1 68 c6 11 00       	mov    0x11c668,%eax
  101500:	83 e0 bf             	and    $0xffffffbf,%eax
  101503:	a3 68 c6 11 00       	mov    %eax,0x11c668
    }

    shift |= shiftcode[data];
  101508:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10150c:	0f b6 80 40 90 11 00 	movzbl 0x119040(%eax),%eax
  101513:	0f b6 d0             	movzbl %al,%edx
  101516:	a1 68 c6 11 00       	mov    0x11c668,%eax
  10151b:	09 d0                	or     %edx,%eax
  10151d:	a3 68 c6 11 00       	mov    %eax,0x11c668
    shift ^= togglecode[data];
  101522:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101526:	0f b6 80 40 91 11 00 	movzbl 0x119140(%eax),%eax
  10152d:	0f b6 d0             	movzbl %al,%edx
  101530:	a1 68 c6 11 00       	mov    0x11c668,%eax
  101535:	31 d0                	xor    %edx,%eax
  101537:	a3 68 c6 11 00       	mov    %eax,0x11c668

    c = charcode[shift & (CTL | SHIFT)][data];
  10153c:	a1 68 c6 11 00       	mov    0x11c668,%eax
  101541:	83 e0 03             	and    $0x3,%eax
  101544:	8b 14 85 40 95 11 00 	mov    0x119540(,%eax,4),%edx
  10154b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10154f:	01 d0                	add    %edx,%eax
  101551:	0f b6 00             	movzbl (%eax),%eax
  101554:	0f b6 c0             	movzbl %al,%eax
  101557:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  10155a:	a1 68 c6 11 00       	mov    0x11c668,%eax
  10155f:	83 e0 08             	and    $0x8,%eax
  101562:	85 c0                	test   %eax,%eax
  101564:	74 22                	je     101588 <kbd_proc_data+0x14a>
        if ('a' <= c && c <= 'z')
  101566:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  10156a:	7e 0c                	jle    101578 <kbd_proc_data+0x13a>
  10156c:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  101570:	7f 06                	jg     101578 <kbd_proc_data+0x13a>
            c += 'A' - 'a';
  101572:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  101576:	eb 10                	jmp    101588 <kbd_proc_data+0x14a>
        else if ('A' <= c && c <= 'Z')
  101578:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  10157c:	7e 0a                	jle    101588 <kbd_proc_data+0x14a>
  10157e:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101582:	7f 04                	jg     101588 <kbd_proc_data+0x14a>
            c += 'a' - 'A';
  101584:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  101588:	a1 68 c6 11 00       	mov    0x11c668,%eax
  10158d:	f7 d0                	not    %eax
  10158f:	83 e0 06             	and    $0x6,%eax
  101592:	85 c0                	test   %eax,%eax
  101594:	75 27                	jne    1015bd <kbd_proc_data+0x17f>
  101596:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  10159d:	75 1e                	jne    1015bd <kbd_proc_data+0x17f>
        cprintf("Rebooting!\n");
  10159f:	c7 04 24 2d 67 10 00 	movl   $0x10672d,(%esp)
  1015a6:	e8 ef ec ff ff       	call   10029a <cprintf>
  1015ab:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  1015b1:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1015b5:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  1015b9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1015bc:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  1015bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1015c0:	c9                   	leave  
  1015c1:	c3                   	ret    

001015c2 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  1015c2:	55                   	push   %ebp
  1015c3:	89 e5                	mov    %esp,%ebp
  1015c5:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  1015c8:	c7 04 24 3e 14 10 00 	movl   $0x10143e,(%esp)
  1015cf:	e8 a9 fd ff ff       	call   10137d <cons_intr>
}
  1015d4:	90                   	nop
  1015d5:	c9                   	leave  
  1015d6:	c3                   	ret    

001015d7 <kbd_init>:

static void
kbd_init(void) {
  1015d7:	55                   	push   %ebp
  1015d8:	89 e5                	mov    %esp,%ebp
  1015da:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  1015dd:	e8 e0 ff ff ff       	call   1015c2 <kbd_intr>
    pic_enable(IRQ_KBD);
  1015e2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1015e9:	e8 35 01 00 00       	call   101723 <pic_enable>
}
  1015ee:	90                   	nop
  1015ef:	c9                   	leave  
  1015f0:	c3                   	ret    

001015f1 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1015f1:	55                   	push   %ebp
  1015f2:	89 e5                	mov    %esp,%ebp
  1015f4:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  1015f7:	e8 83 f8 ff ff       	call   100e7f <cga_init>
    serial_init();
  1015fc:	e8 62 f9 ff ff       	call   100f63 <serial_init>
    kbd_init();
  101601:	e8 d1 ff ff ff       	call   1015d7 <kbd_init>
    if (!serial_exists) {
  101606:	a1 48 c4 11 00       	mov    0x11c448,%eax
  10160b:	85 c0                	test   %eax,%eax
  10160d:	75 0c                	jne    10161b <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  10160f:	c7 04 24 39 67 10 00 	movl   $0x106739,(%esp)
  101616:	e8 7f ec ff ff       	call   10029a <cprintf>
    }
}
  10161b:	90                   	nop
  10161c:	c9                   	leave  
  10161d:	c3                   	ret    

0010161e <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  10161e:	55                   	push   %ebp
  10161f:	89 e5                	mov    %esp,%ebp
  101621:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  101624:	e8 cf f7 ff ff       	call   100df8 <__intr_save>
  101629:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  10162c:	8b 45 08             	mov    0x8(%ebp),%eax
  10162f:	89 04 24             	mov    %eax,(%esp)
  101632:	e8 89 fa ff ff       	call   1010c0 <lpt_putc>
        cga_putc(c);
  101637:	8b 45 08             	mov    0x8(%ebp),%eax
  10163a:	89 04 24             	mov    %eax,(%esp)
  10163d:	e8 be fa ff ff       	call   101100 <cga_putc>
        serial_putc(c);
  101642:	8b 45 08             	mov    0x8(%ebp),%eax
  101645:	89 04 24             	mov    %eax,(%esp)
  101648:	e8 f0 fc ff ff       	call   10133d <serial_putc>
    }
    local_intr_restore(intr_flag);
  10164d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101650:	89 04 24             	mov    %eax,(%esp)
  101653:	e8 ca f7 ff ff       	call   100e22 <__intr_restore>
}
  101658:	90                   	nop
  101659:	c9                   	leave  
  10165a:	c3                   	ret    

0010165b <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  10165b:	55                   	push   %ebp
  10165c:	89 e5                	mov    %esp,%ebp
  10165e:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
  101661:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  101668:	e8 8b f7 ff ff       	call   100df8 <__intr_save>
  10166d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  101670:	e8 ab fd ff ff       	call   101420 <serial_intr>
        kbd_intr();
  101675:	e8 48 ff ff ff       	call   1015c2 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  10167a:	8b 15 60 c6 11 00    	mov    0x11c660,%edx
  101680:	a1 64 c6 11 00       	mov    0x11c664,%eax
  101685:	39 c2                	cmp    %eax,%edx
  101687:	74 31                	je     1016ba <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
  101689:	a1 60 c6 11 00       	mov    0x11c660,%eax
  10168e:	8d 50 01             	lea    0x1(%eax),%edx
  101691:	89 15 60 c6 11 00    	mov    %edx,0x11c660
  101697:	0f b6 80 60 c4 11 00 	movzbl 0x11c460(%eax),%eax
  10169e:	0f b6 c0             	movzbl %al,%eax
  1016a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  1016a4:	a1 60 c6 11 00       	mov    0x11c660,%eax
  1016a9:	3d 00 02 00 00       	cmp    $0x200,%eax
  1016ae:	75 0a                	jne    1016ba <cons_getc+0x5f>
                cons.rpos = 0;
  1016b0:	c7 05 60 c6 11 00 00 	movl   $0x0,0x11c660
  1016b7:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  1016ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1016bd:	89 04 24             	mov    %eax,(%esp)
  1016c0:	e8 5d f7 ff ff       	call   100e22 <__intr_restore>
    return c;
  1016c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1016c8:	c9                   	leave  
  1016c9:	c3                   	ret    

001016ca <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1016ca:	55                   	push   %ebp
  1016cb:	89 e5                	mov    %esp,%ebp
  1016cd:	83 ec 14             	sub    $0x14,%esp
  1016d0:	8b 45 08             	mov    0x8(%ebp),%eax
  1016d3:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1016d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1016da:	66 a3 50 95 11 00    	mov    %ax,0x119550
    if (did_init) {
  1016e0:	a1 6c c6 11 00       	mov    0x11c66c,%eax
  1016e5:	85 c0                	test   %eax,%eax
  1016e7:	74 37                	je     101720 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  1016e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1016ec:	0f b6 c0             	movzbl %al,%eax
  1016ef:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  1016f5:	88 45 f9             	mov    %al,-0x7(%ebp)
  1016f8:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1016fc:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101700:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  101701:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101705:	c1 e8 08             	shr    $0x8,%eax
  101708:	0f b7 c0             	movzwl %ax,%eax
  10170b:	0f b6 c0             	movzbl %al,%eax
  10170e:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  101714:	88 45 fd             	mov    %al,-0x3(%ebp)
  101717:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10171b:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10171f:	ee                   	out    %al,(%dx)
    }
}
  101720:	90                   	nop
  101721:	c9                   	leave  
  101722:	c3                   	ret    

00101723 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101723:	55                   	push   %ebp
  101724:	89 e5                	mov    %esp,%ebp
  101726:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  101729:	8b 45 08             	mov    0x8(%ebp),%eax
  10172c:	ba 01 00 00 00       	mov    $0x1,%edx
  101731:	88 c1                	mov    %al,%cl
  101733:	d3 e2                	shl    %cl,%edx
  101735:	89 d0                	mov    %edx,%eax
  101737:	98                   	cwtl   
  101738:	f7 d0                	not    %eax
  10173a:	0f bf d0             	movswl %ax,%edx
  10173d:	0f b7 05 50 95 11 00 	movzwl 0x119550,%eax
  101744:	98                   	cwtl   
  101745:	21 d0                	and    %edx,%eax
  101747:	98                   	cwtl   
  101748:	0f b7 c0             	movzwl %ax,%eax
  10174b:	89 04 24             	mov    %eax,(%esp)
  10174e:	e8 77 ff ff ff       	call   1016ca <pic_setmask>
}
  101753:	90                   	nop
  101754:	c9                   	leave  
  101755:	c3                   	ret    

00101756 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  101756:	55                   	push   %ebp
  101757:	89 e5                	mov    %esp,%ebp
  101759:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  10175c:	c7 05 6c c6 11 00 01 	movl   $0x1,0x11c66c
  101763:	00 00 00 
  101766:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  10176c:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
  101770:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  101774:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  101778:	ee                   	out    %al,(%dx)
  101779:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  10177f:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
  101783:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  101787:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  10178b:	ee                   	out    %al,(%dx)
  10178c:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  101792:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
  101796:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  10179a:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  10179e:	ee                   	out    %al,(%dx)
  10179f:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  1017a5:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
  1017a9:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  1017ad:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  1017b1:	ee                   	out    %al,(%dx)
  1017b2:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  1017b8:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
  1017bc:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  1017c0:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  1017c4:	ee                   	out    %al,(%dx)
  1017c5:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  1017cb:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
  1017cf:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  1017d3:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  1017d7:	ee                   	out    %al,(%dx)
  1017d8:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  1017de:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
  1017e2:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  1017e6:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  1017ea:	ee                   	out    %al,(%dx)
  1017eb:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  1017f1:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
  1017f5:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1017f9:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1017fd:	ee                   	out    %al,(%dx)
  1017fe:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  101804:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
  101808:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10180c:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101810:	ee                   	out    %al,(%dx)
  101811:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  101817:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
  10181b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10181f:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101823:	ee                   	out    %al,(%dx)
  101824:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  10182a:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
  10182e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101832:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101836:	ee                   	out    %al,(%dx)
  101837:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  10183d:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
  101841:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101845:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101849:	ee                   	out    %al,(%dx)
  10184a:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  101850:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
  101854:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101858:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10185c:	ee                   	out    %al,(%dx)
  10185d:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  101863:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
  101867:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10186b:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10186f:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  101870:	0f b7 05 50 95 11 00 	movzwl 0x119550,%eax
  101877:	3d ff ff 00 00       	cmp    $0xffff,%eax
  10187c:	74 0f                	je     10188d <pic_init+0x137>
        pic_setmask(irq_mask);
  10187e:	0f b7 05 50 95 11 00 	movzwl 0x119550,%eax
  101885:	89 04 24             	mov    %eax,(%esp)
  101888:	e8 3d fe ff ff       	call   1016ca <pic_setmask>
    }
}
  10188d:	90                   	nop
  10188e:	c9                   	leave  
  10188f:	c3                   	ret    

00101890 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  101890:	55                   	push   %ebp
  101891:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
  101893:	fb                   	sti    
    sti();
}
  101894:	90                   	nop
  101895:	5d                   	pop    %ebp
  101896:	c3                   	ret    

00101897 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  101897:	55                   	push   %ebp
  101898:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
  10189a:	fa                   	cli    
    cli();
}
  10189b:	90                   	nop
  10189c:	5d                   	pop    %ebp
  10189d:	c3                   	ret    

0010189e <print_switch_to_user>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100
void print_switch_to_user()
{
  10189e:	55                   	push   %ebp
  10189f:	89 e5                	mov    %esp,%ebp
  1018a1:	83 ec 18             	sub    $0x18,%esp
	cprintf("switch to user");
  1018a4:	c7 04 24 60 67 10 00 	movl   $0x106760,(%esp)
  1018ab:	e8 ea e9 ff ff       	call   10029a <cprintf>
}
  1018b0:	90                   	nop
  1018b1:	c9                   	leave  
  1018b2:	c3                   	ret    

001018b3 <print_switch_to_kernel>:

void print_switch_to_kernel()
{
  1018b3:	55                   	push   %ebp
  1018b4:	89 e5                	mov    %esp,%ebp
  1018b6:	83 ec 18             	sub    $0x18,%esp
	cprintf("switch to kernel\n");
  1018b9:	c7 04 24 6f 67 10 00 	movl   $0x10676f,(%esp)
  1018c0:	e8 d5 e9 ff ff       	call   10029a <cprintf>
}
  1018c5:	90                   	nop
  1018c6:	c9                   	leave  
  1018c7:	c3                   	ret    

001018c8 <print_ticks>:

static void print_ticks() {
  1018c8:	55                   	push   %ebp
  1018c9:	89 e5                	mov    %esp,%ebp
  1018cb:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  1018ce:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  1018d5:	00 
  1018d6:	c7 04 24 81 67 10 00 	movl   $0x106781,(%esp)
  1018dd:	e8 b8 e9 ff ff       	call   10029a <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  1018e2:	90                   	nop
  1018e3:	c9                   	leave  
  1018e4:	c3                   	ret    

001018e5 <idt_init>:

extern uint32_t __vectors[256];

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1018e5:	55                   	push   %ebp
  1018e6:	89 e5                	mov    %esp,%ebp
  1018e8:	83 ec 10             	sub    $0x10,%esp
      *     Can you see idt[256] in this file? Yes, it's IDT! you can use SETGATE macro to setup each item of IDT
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	int intrno = 0;
  1018eb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	/* ucore don't use task gate.*/
	for(; intrno < 256; intrno++) 
  1018f2:	e9 c4 00 00 00       	jmp    1019bb <idt_init+0xd6>
		SETGATE(idt[intrno], 0, KERNEL_CS, __vectors[intrno], DPL_KERNEL);
  1018f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018fa:	8b 04 85 e0 95 11 00 	mov    0x1195e0(,%eax,4),%eax
  101901:	0f b7 d0             	movzwl %ax,%edx
  101904:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101907:	66 89 14 c5 80 c6 11 	mov    %dx,0x11c680(,%eax,8)
  10190e:	00 
  10190f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101912:	66 c7 04 c5 82 c6 11 	movw   $0x8,0x11c682(,%eax,8)
  101919:	00 08 00 
  10191c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10191f:	0f b6 14 c5 84 c6 11 	movzbl 0x11c684(,%eax,8),%edx
  101926:	00 
  101927:	80 e2 e0             	and    $0xe0,%dl
  10192a:	88 14 c5 84 c6 11 00 	mov    %dl,0x11c684(,%eax,8)
  101931:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101934:	0f b6 14 c5 84 c6 11 	movzbl 0x11c684(,%eax,8),%edx
  10193b:	00 
  10193c:	80 e2 1f             	and    $0x1f,%dl
  10193f:	88 14 c5 84 c6 11 00 	mov    %dl,0x11c684(,%eax,8)
  101946:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101949:	0f b6 14 c5 85 c6 11 	movzbl 0x11c685(,%eax,8),%edx
  101950:	00 
  101951:	80 e2 f0             	and    $0xf0,%dl
  101954:	80 ca 0e             	or     $0xe,%dl
  101957:	88 14 c5 85 c6 11 00 	mov    %dl,0x11c685(,%eax,8)
  10195e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101961:	0f b6 14 c5 85 c6 11 	movzbl 0x11c685(,%eax,8),%edx
  101968:	00 
  101969:	80 e2 ef             	and    $0xef,%dl
  10196c:	88 14 c5 85 c6 11 00 	mov    %dl,0x11c685(,%eax,8)
  101973:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101976:	0f b6 14 c5 85 c6 11 	movzbl 0x11c685(,%eax,8),%edx
  10197d:	00 
  10197e:	80 e2 9f             	and    $0x9f,%dl
  101981:	88 14 c5 85 c6 11 00 	mov    %dl,0x11c685(,%eax,8)
  101988:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10198b:	0f b6 14 c5 85 c6 11 	movzbl 0x11c685(,%eax,8),%edx
  101992:	00 
  101993:	80 ca 80             	or     $0x80,%dl
  101996:	88 14 c5 85 c6 11 00 	mov    %dl,0x11c685(,%eax,8)
  10199d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019a0:	8b 04 85 e0 95 11 00 	mov    0x1195e0(,%eax,4),%eax
  1019a7:	c1 e8 10             	shr    $0x10,%eax
  1019aa:	0f b7 d0             	movzwl %ax,%edx
  1019ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019b0:	66 89 14 c5 86 c6 11 	mov    %dx,0x11c686(,%eax,8)
  1019b7:	00 
	for(; intrno < 256; intrno++) 
  1019b8:	ff 45 fc             	incl   -0x4(%ebp)
  1019bb:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  1019c2:	0f 8e 2f ff ff ff    	jle    1018f7 <idt_init+0x12>

	SETGATE(idt[T_SYSCALL], 1, KERNEL_CS, __vectors[T_SYSCALL], DPL_USER);
  1019c8:	a1 e0 97 11 00       	mov    0x1197e0,%eax
  1019cd:	0f b7 c0             	movzwl %ax,%eax
  1019d0:	66 a3 80 ca 11 00    	mov    %ax,0x11ca80
  1019d6:	66 c7 05 82 ca 11 00 	movw   $0x8,0x11ca82
  1019dd:	08 00 
  1019df:	0f b6 05 84 ca 11 00 	movzbl 0x11ca84,%eax
  1019e6:	24 e0                	and    $0xe0,%al
  1019e8:	a2 84 ca 11 00       	mov    %al,0x11ca84
  1019ed:	0f b6 05 84 ca 11 00 	movzbl 0x11ca84,%eax
  1019f4:	24 1f                	and    $0x1f,%al
  1019f6:	a2 84 ca 11 00       	mov    %al,0x11ca84
  1019fb:	0f b6 05 85 ca 11 00 	movzbl 0x11ca85,%eax
  101a02:	0c 0f                	or     $0xf,%al
  101a04:	a2 85 ca 11 00       	mov    %al,0x11ca85
  101a09:	0f b6 05 85 ca 11 00 	movzbl 0x11ca85,%eax
  101a10:	24 ef                	and    $0xef,%al
  101a12:	a2 85 ca 11 00       	mov    %al,0x11ca85
  101a17:	0f b6 05 85 ca 11 00 	movzbl 0x11ca85,%eax
  101a1e:	0c 60                	or     $0x60,%al
  101a20:	a2 85 ca 11 00       	mov    %al,0x11ca85
  101a25:	0f b6 05 85 ca 11 00 	movzbl 0x11ca85,%eax
  101a2c:	0c 80                	or     $0x80,%al
  101a2e:	a2 85 ca 11 00       	mov    %al,0x11ca85
  101a33:	a1 e0 97 11 00       	mov    0x1197e0,%eax
  101a38:	c1 e8 10             	shr    $0x10,%eax
  101a3b:	0f b7 c0             	movzwl %ax,%eax
  101a3e:	66 a3 86 ca 11 00    	mov    %ax,0x11ca86
	SETGATE(idt[T_SWITCH_TOK], 0, KERNEL_CS, __vectors[T_SWITCH_TOK], DPL_USER);
  101a44:	a1 c4 97 11 00       	mov    0x1197c4,%eax
  101a49:	0f b7 c0             	movzwl %ax,%eax
  101a4c:	66 a3 48 ca 11 00    	mov    %ax,0x11ca48
  101a52:	66 c7 05 4a ca 11 00 	movw   $0x8,0x11ca4a
  101a59:	08 00 
  101a5b:	0f b6 05 4c ca 11 00 	movzbl 0x11ca4c,%eax
  101a62:	24 e0                	and    $0xe0,%al
  101a64:	a2 4c ca 11 00       	mov    %al,0x11ca4c
  101a69:	0f b6 05 4c ca 11 00 	movzbl 0x11ca4c,%eax
  101a70:	24 1f                	and    $0x1f,%al
  101a72:	a2 4c ca 11 00       	mov    %al,0x11ca4c
  101a77:	0f b6 05 4d ca 11 00 	movzbl 0x11ca4d,%eax
  101a7e:	24 f0                	and    $0xf0,%al
  101a80:	0c 0e                	or     $0xe,%al
  101a82:	a2 4d ca 11 00       	mov    %al,0x11ca4d
  101a87:	0f b6 05 4d ca 11 00 	movzbl 0x11ca4d,%eax
  101a8e:	24 ef                	and    $0xef,%al
  101a90:	a2 4d ca 11 00       	mov    %al,0x11ca4d
  101a95:	0f b6 05 4d ca 11 00 	movzbl 0x11ca4d,%eax
  101a9c:	0c 60                	or     $0x60,%al
  101a9e:	a2 4d ca 11 00       	mov    %al,0x11ca4d
  101aa3:	0f b6 05 4d ca 11 00 	movzbl 0x11ca4d,%eax
  101aaa:	0c 80                	or     $0x80,%al
  101aac:	a2 4d ca 11 00       	mov    %al,0x11ca4d
  101ab1:	a1 c4 97 11 00       	mov    0x1197c4,%eax
  101ab6:	c1 e8 10             	shr    $0x10,%eax
  101ab9:	0f b7 c0             	movzwl %ax,%eax
  101abc:	66 a3 4e ca 11 00    	mov    %ax,0x11ca4e
	SETGATE(idt[T_SWITCH_TOU], 0, KERNEL_CS, __vectors[T_SWITCH_TOU], DPL_KERNEL);
  101ac2:	a1 c0 97 11 00       	mov    0x1197c0,%eax
  101ac7:	0f b7 c0             	movzwl %ax,%eax
  101aca:	66 a3 40 ca 11 00    	mov    %ax,0x11ca40
  101ad0:	66 c7 05 42 ca 11 00 	movw   $0x8,0x11ca42
  101ad7:	08 00 
  101ad9:	0f b6 05 44 ca 11 00 	movzbl 0x11ca44,%eax
  101ae0:	24 e0                	and    $0xe0,%al
  101ae2:	a2 44 ca 11 00       	mov    %al,0x11ca44
  101ae7:	0f b6 05 44 ca 11 00 	movzbl 0x11ca44,%eax
  101aee:	24 1f                	and    $0x1f,%al
  101af0:	a2 44 ca 11 00       	mov    %al,0x11ca44
  101af5:	0f b6 05 45 ca 11 00 	movzbl 0x11ca45,%eax
  101afc:	24 f0                	and    $0xf0,%al
  101afe:	0c 0e                	or     $0xe,%al
  101b00:	a2 45 ca 11 00       	mov    %al,0x11ca45
  101b05:	0f b6 05 45 ca 11 00 	movzbl 0x11ca45,%eax
  101b0c:	24 ef                	and    $0xef,%al
  101b0e:	a2 45 ca 11 00       	mov    %al,0x11ca45
  101b13:	0f b6 05 45 ca 11 00 	movzbl 0x11ca45,%eax
  101b1a:	24 9f                	and    $0x9f,%al
  101b1c:	a2 45 ca 11 00       	mov    %al,0x11ca45
  101b21:	0f b6 05 45 ca 11 00 	movzbl 0x11ca45,%eax
  101b28:	0c 80                	or     $0x80,%al
  101b2a:	a2 45 ca 11 00       	mov    %al,0x11ca45
  101b2f:	a1 c0 97 11 00       	mov    0x1197c0,%eax
  101b34:	c1 e8 10             	shr    $0x10,%eax
  101b37:	0f b7 c0             	movzwl %ax,%eax
  101b3a:	66 a3 46 ca 11 00    	mov    %ax,0x11ca46
  101b40:	c7 45 f8 60 95 11 00 	movl   $0x119560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  101b47:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101b4a:	0f 01 18             	lidtl  (%eax)

	lidt(&idt_pd);

}
  101b4d:	90                   	nop
  101b4e:	c9                   	leave  
  101b4f:	c3                   	ret    

00101b50 <trapname>:

static const char *
trapname(int trapno) {
  101b50:	55                   	push   %ebp
  101b51:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101b53:	8b 45 08             	mov    0x8(%ebp),%eax
  101b56:	83 f8 13             	cmp    $0x13,%eax
  101b59:	77 0c                	ja     101b67 <trapname+0x17>
        return excnames[trapno];
  101b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  101b5e:	8b 04 85 e0 6a 10 00 	mov    0x106ae0(,%eax,4),%eax
  101b65:	eb 18                	jmp    101b7f <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101b67:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101b6b:	7e 0d                	jle    101b7a <trapname+0x2a>
  101b6d:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101b71:	7f 07                	jg     101b7a <trapname+0x2a>
        return "Hardware Interrupt";
  101b73:	b8 8b 67 10 00       	mov    $0x10678b,%eax
  101b78:	eb 05                	jmp    101b7f <trapname+0x2f>
    }
    return "(unknown trap)";
  101b7a:	b8 9e 67 10 00       	mov    $0x10679e,%eax
}
  101b7f:	5d                   	pop    %ebp
  101b80:	c3                   	ret    

00101b81 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101b81:	55                   	push   %ebp
  101b82:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101b84:	8b 45 08             	mov    0x8(%ebp),%eax
  101b87:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b8b:	83 f8 08             	cmp    $0x8,%eax
  101b8e:	0f 94 c0             	sete   %al
  101b91:	0f b6 c0             	movzbl %al,%eax
}
  101b94:	5d                   	pop    %ebp
  101b95:	c3                   	ret    

00101b96 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101b96:	55                   	push   %ebp
  101b97:	89 e5                	mov    %esp,%ebp
  101b99:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101b9c:	8b 45 08             	mov    0x8(%ebp),%eax
  101b9f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ba3:	c7 04 24 df 67 10 00 	movl   $0x1067df,(%esp)
  101baa:	e8 eb e6 ff ff       	call   10029a <cprintf>
    print_regs(&tf->tf_regs);
  101baf:	8b 45 08             	mov    0x8(%ebp),%eax
  101bb2:	89 04 24             	mov    %eax,(%esp)
  101bb5:	e8 8f 01 00 00       	call   101d49 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101bba:	8b 45 08             	mov    0x8(%ebp),%eax
  101bbd:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101bc1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bc5:	c7 04 24 f0 67 10 00 	movl   $0x1067f0,(%esp)
  101bcc:	e8 c9 e6 ff ff       	call   10029a <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  101bd4:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101bd8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bdc:	c7 04 24 03 68 10 00 	movl   $0x106803,(%esp)
  101be3:	e8 b2 e6 ff ff       	call   10029a <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101be8:	8b 45 08             	mov    0x8(%ebp),%eax
  101beb:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101bef:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bf3:	c7 04 24 16 68 10 00 	movl   $0x106816,(%esp)
  101bfa:	e8 9b e6 ff ff       	call   10029a <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101bff:	8b 45 08             	mov    0x8(%ebp),%eax
  101c02:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101c06:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c0a:	c7 04 24 29 68 10 00 	movl   $0x106829,(%esp)
  101c11:	e8 84 e6 ff ff       	call   10029a <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101c16:	8b 45 08             	mov    0x8(%ebp),%eax
  101c19:	8b 40 30             	mov    0x30(%eax),%eax
  101c1c:	89 04 24             	mov    %eax,(%esp)
  101c1f:	e8 2c ff ff ff       	call   101b50 <trapname>
  101c24:	89 c2                	mov    %eax,%edx
  101c26:	8b 45 08             	mov    0x8(%ebp),%eax
  101c29:	8b 40 30             	mov    0x30(%eax),%eax
  101c2c:	89 54 24 08          	mov    %edx,0x8(%esp)
  101c30:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c34:	c7 04 24 3c 68 10 00 	movl   $0x10683c,(%esp)
  101c3b:	e8 5a e6 ff ff       	call   10029a <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101c40:	8b 45 08             	mov    0x8(%ebp),%eax
  101c43:	8b 40 34             	mov    0x34(%eax),%eax
  101c46:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c4a:	c7 04 24 4e 68 10 00 	movl   $0x10684e,(%esp)
  101c51:	e8 44 e6 ff ff       	call   10029a <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101c56:	8b 45 08             	mov    0x8(%ebp),%eax
  101c59:	8b 40 38             	mov    0x38(%eax),%eax
  101c5c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c60:	c7 04 24 5d 68 10 00 	movl   $0x10685d,(%esp)
  101c67:	e8 2e e6 ff ff       	call   10029a <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  101c6f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101c73:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c77:	c7 04 24 6c 68 10 00 	movl   $0x10686c,(%esp)
  101c7e:	e8 17 e6 ff ff       	call   10029a <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101c83:	8b 45 08             	mov    0x8(%ebp),%eax
  101c86:	8b 40 40             	mov    0x40(%eax),%eax
  101c89:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c8d:	c7 04 24 7f 68 10 00 	movl   $0x10687f,(%esp)
  101c94:	e8 01 e6 ff ff       	call   10029a <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101c99:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101ca0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101ca7:	eb 3d                	jmp    101ce6 <print_trapframe+0x150>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  101cac:	8b 50 40             	mov    0x40(%eax),%edx
  101caf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101cb2:	21 d0                	and    %edx,%eax
  101cb4:	85 c0                	test   %eax,%eax
  101cb6:	74 28                	je     101ce0 <print_trapframe+0x14a>
  101cb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101cbb:	8b 04 85 80 95 11 00 	mov    0x119580(,%eax,4),%eax
  101cc2:	85 c0                	test   %eax,%eax
  101cc4:	74 1a                	je     101ce0 <print_trapframe+0x14a>
            cprintf("%s,", IA32flags[i]);
  101cc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101cc9:	8b 04 85 80 95 11 00 	mov    0x119580(,%eax,4),%eax
  101cd0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cd4:	c7 04 24 8e 68 10 00 	movl   $0x10688e,(%esp)
  101cdb:	e8 ba e5 ff ff       	call   10029a <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101ce0:	ff 45 f4             	incl   -0xc(%ebp)
  101ce3:	d1 65 f0             	shll   -0x10(%ebp)
  101ce6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101ce9:	83 f8 17             	cmp    $0x17,%eax
  101cec:	76 bb                	jbe    101ca9 <print_trapframe+0x113>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101cee:	8b 45 08             	mov    0x8(%ebp),%eax
  101cf1:	8b 40 40             	mov    0x40(%eax),%eax
  101cf4:	c1 e8 0c             	shr    $0xc,%eax
  101cf7:	83 e0 03             	and    $0x3,%eax
  101cfa:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cfe:	c7 04 24 92 68 10 00 	movl   $0x106892,(%esp)
  101d05:	e8 90 e5 ff ff       	call   10029a <cprintf>

    if (!trap_in_kernel(tf)) {
  101d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  101d0d:	89 04 24             	mov    %eax,(%esp)
  101d10:	e8 6c fe ff ff       	call   101b81 <trap_in_kernel>
  101d15:	85 c0                	test   %eax,%eax
  101d17:	75 2d                	jne    101d46 <print_trapframe+0x1b0>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101d19:	8b 45 08             	mov    0x8(%ebp),%eax
  101d1c:	8b 40 44             	mov    0x44(%eax),%eax
  101d1f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d23:	c7 04 24 9b 68 10 00 	movl   $0x10689b,(%esp)
  101d2a:	e8 6b e5 ff ff       	call   10029a <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  101d32:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101d36:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d3a:	c7 04 24 aa 68 10 00 	movl   $0x1068aa,(%esp)
  101d41:	e8 54 e5 ff ff       	call   10029a <cprintf>
    }
}
  101d46:	90                   	nop
  101d47:	c9                   	leave  
  101d48:	c3                   	ret    

00101d49 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101d49:	55                   	push   %ebp
  101d4a:	89 e5                	mov    %esp,%ebp
  101d4c:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  101d52:	8b 00                	mov    (%eax),%eax
  101d54:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d58:	c7 04 24 bd 68 10 00 	movl   $0x1068bd,(%esp)
  101d5f:	e8 36 e5 ff ff       	call   10029a <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101d64:	8b 45 08             	mov    0x8(%ebp),%eax
  101d67:	8b 40 04             	mov    0x4(%eax),%eax
  101d6a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d6e:	c7 04 24 cc 68 10 00 	movl   $0x1068cc,(%esp)
  101d75:	e8 20 e5 ff ff       	call   10029a <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101d7a:	8b 45 08             	mov    0x8(%ebp),%eax
  101d7d:	8b 40 08             	mov    0x8(%eax),%eax
  101d80:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d84:	c7 04 24 db 68 10 00 	movl   $0x1068db,(%esp)
  101d8b:	e8 0a e5 ff ff       	call   10029a <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101d90:	8b 45 08             	mov    0x8(%ebp),%eax
  101d93:	8b 40 0c             	mov    0xc(%eax),%eax
  101d96:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d9a:	c7 04 24 ea 68 10 00 	movl   $0x1068ea,(%esp)
  101da1:	e8 f4 e4 ff ff       	call   10029a <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101da6:	8b 45 08             	mov    0x8(%ebp),%eax
  101da9:	8b 40 10             	mov    0x10(%eax),%eax
  101dac:	89 44 24 04          	mov    %eax,0x4(%esp)
  101db0:	c7 04 24 f9 68 10 00 	movl   $0x1068f9,(%esp)
  101db7:	e8 de e4 ff ff       	call   10029a <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  101dbf:	8b 40 14             	mov    0x14(%eax),%eax
  101dc2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101dc6:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  101dcd:	e8 c8 e4 ff ff       	call   10029a <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  101dd5:	8b 40 18             	mov    0x18(%eax),%eax
  101dd8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ddc:	c7 04 24 17 69 10 00 	movl   $0x106917,(%esp)
  101de3:	e8 b2 e4 ff ff       	call   10029a <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101de8:	8b 45 08             	mov    0x8(%ebp),%eax
  101deb:	8b 40 1c             	mov    0x1c(%eax),%eax
  101dee:	89 44 24 04          	mov    %eax,0x4(%esp)
  101df2:	c7 04 24 26 69 10 00 	movl   $0x106926,(%esp)
  101df9:	e8 9c e4 ff ff       	call   10029a <cprintf>
}
  101dfe:	90                   	nop
  101dff:	c9                   	leave  
  101e00:	c3                   	ret    

00101e01 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101e01:	55                   	push   %ebp
  101e02:	89 e5                	mov    %esp,%ebp
  101e04:	57                   	push   %edi
  101e05:	56                   	push   %esi
  101e06:	53                   	push   %ebx
  101e07:	83 ec 2c             	sub    $0x2c,%esp
    char c;
	static struct trapframe *correct_tf;
	correct_tf = (struct trapframe *) ((uint32_t)(tf) - 8);
  101e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  101e0d:	83 e8 08             	sub    $0x8,%eax
  101e10:	a3 80 ce 11 00       	mov    %eax,0x11ce80

    switch (tf->tf_trapno) {
  101e15:	8b 45 08             	mov    0x8(%ebp),%eax
  101e18:	8b 40 30             	mov    0x30(%eax),%eax
  101e1b:	83 f8 24             	cmp    $0x24,%eax
  101e1e:	0f 84 96 00 00 00    	je     101eba <trap_dispatch+0xb9>
  101e24:	83 f8 24             	cmp    $0x24,%eax
  101e27:	77 1c                	ja     101e45 <trap_dispatch+0x44>
  101e29:	83 f8 20             	cmp    $0x20,%eax
  101e2c:	74 44                	je     101e72 <trap_dispatch+0x71>
  101e2e:	83 f8 21             	cmp    $0x21,%eax
  101e31:	0f 84 ac 00 00 00    	je     101ee3 <trap_dispatch+0xe2>
  101e37:	83 f8 0d             	cmp    $0xd,%eax
  101e3a:	0f 84 aa 03 00 00    	je     1021ea <loop+0x16e>
  101e40:	e9 be 03 00 00       	jmp    102203 <loop+0x187>
  101e45:	83 f8 78             	cmp    $0x78,%eax
  101e48:	0f 84 a8 02 00 00    	je     1020f6 <loop+0x7a>
  101e4e:	83 f8 78             	cmp    $0x78,%eax
  101e51:	77 11                	ja     101e64 <trap_dispatch+0x63>
  101e53:	83 e8 2e             	sub    $0x2e,%eax
  101e56:	83 f8 01             	cmp    $0x1,%eax
  101e59:	0f 87 a4 03 00 00    	ja     102203 <loop+0x187>
		}
			break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101e5f:	e9 db 03 00 00       	jmp    10223f <loop+0x1c3>
    switch (tf->tf_trapno) {
  101e64:	83 f8 79             	cmp    $0x79,%eax
  101e67:	0f 84 0c 03 00 00    	je     102179 <loop+0xfd>
  101e6d:	e9 91 03 00 00       	jmp    102203 <loop+0x187>
		ticks = (ticks + 1) % 100;
  101e72:	a1 2c cf 11 00       	mov    0x11cf2c,%eax
  101e77:	8d 48 01             	lea    0x1(%eax),%ecx
  101e7a:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101e7f:	89 c8                	mov    %ecx,%eax
  101e81:	f7 e2                	mul    %edx
  101e83:	c1 ea 05             	shr    $0x5,%edx
  101e86:	89 d0                	mov    %edx,%eax
  101e88:	c1 e0 02             	shl    $0x2,%eax
  101e8b:	01 d0                	add    %edx,%eax
  101e8d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  101e94:	01 d0                	add    %edx,%eax
  101e96:	c1 e0 02             	shl    $0x2,%eax
  101e99:	29 c1                	sub    %eax,%ecx
  101e9b:	89 ca                	mov    %ecx,%edx
  101e9d:	89 15 2c cf 11 00    	mov    %edx,0x11cf2c
		if (ticks == 0)
  101ea3:	a1 2c cf 11 00       	mov    0x11cf2c,%eax
  101ea8:	85 c0                	test   %eax,%eax
  101eaa:	0f 85 88 03 00 00    	jne    102238 <loop+0x1bc>
			print_ticks();
  101eb0:	e8 13 fa ff ff       	call   1018c8 <print_ticks>
        break;
  101eb5:	e9 7e 03 00 00       	jmp    102238 <loop+0x1bc>
        c = cons_getc();
  101eba:	e8 9c f7 ff ff       	call   10165b <cons_getc>
  101ebf:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101ec2:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101ec6:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101eca:	89 54 24 08          	mov    %edx,0x8(%esp)
  101ece:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ed2:	c7 04 24 35 69 10 00 	movl   $0x106935,(%esp)
  101ed9:	e8 bc e3 ff ff       	call   10029a <cprintf>
        break;
  101ede:	e9 5c 03 00 00       	jmp    10223f <loop+0x1c3>
        c = cons_getc();
  101ee3:	e8 73 f7 ff ff       	call   10165b <cons_getc>
  101ee8:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101eeb:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101eef:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101ef3:	89 54 24 08          	mov    %edx,0x8(%esp)
  101ef7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101efb:	c7 04 24 47 69 10 00 	movl   $0x106947,(%esp)
  101f02:	e8 93 e3 ff ff       	call   10029a <cprintf>
		switch (c) {
  101f07:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101f0b:	83 f8 30             	cmp    $0x30,%eax
  101f0e:	74 0e                	je     101f1e <trap_dispatch+0x11d>
  101f10:	83 f8 33             	cmp    $0x33,%eax
  101f13:	0f 84 29 01 00 00    	je     102042 <trap_dispatch+0x241>
        break;
  101f19:	e9 21 03 00 00       	jmp    10223f <loop+0x1c3>
				if (!trap_in_kernel(tf)) {
  101f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  101f21:	89 04 24             	mov    %eax,(%esp)
  101f24:	e8 58 fc ff ff       	call   101b81 <trap_in_kernel>
  101f29:	85 c0                	test   %eax,%eax
  101f2b:	0f 85 b9 01 00 00    	jne    1020ea <loop+0x6e>
					tf->tf_cs = KERNEL_CS;
  101f31:	8b 45 08             	mov    0x8(%ebp),%eax
  101f34:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
					tf->tf_ds = tf->tf_es = tf->tf_gs = tf->tf_fs = KERNEL_DS;
  101f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  101f3d:	66 c7 40 24 10 00    	movw   $0x10,0x24(%eax)
  101f43:	8b 45 08             	mov    0x8(%ebp),%eax
  101f46:	0f b7 50 24          	movzwl 0x24(%eax),%edx
  101f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  101f4d:	66 89 50 20          	mov    %dx,0x20(%eax)
  101f51:	8b 45 08             	mov    0x8(%ebp),%eax
  101f54:	0f b7 50 20          	movzwl 0x20(%eax),%edx
  101f58:	8b 45 08             	mov    0x8(%ebp),%eax
  101f5b:	66 89 50 28          	mov    %dx,0x28(%eax)
  101f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  101f62:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101f66:	8b 45 08             	mov    0x8(%ebp),%eax
  101f69:	66 89 50 2c          	mov    %dx,0x2c(%eax)
					tf->tf_eflags &= ~FL_IOPL_MASK;
  101f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  101f70:	8b 40 40             	mov    0x40(%eax),%eax
  101f73:	25 ff cf ff ff       	and    $0xffffcfff,%eax
  101f78:	89 c2                	mov    %eax,%edx
  101f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  101f7d:	89 50 40             	mov    %edx,0x40(%eax)
					uintptr_t user_stack_ptr = (uintptr_t)tf->tf_esp;
  101f80:	8b 45 08             	mov    0x8(%ebp),%eax
  101f83:	8b 40 44             	mov    0x44(%eax),%eax
  101f86:	89 45 e0             	mov    %eax,-0x20(%ebp)
					tf->tf_esp = *((uint32_t *) user_stack_ptr);
  101f89:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101f8c:	8b 10                	mov    (%eax),%edx
  101f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  101f91:	89 50 44             	mov    %edx,0x44(%eax)
					tf->tf_ss = *((uint16_t *) (user_stack_ptr + 4));
  101f94:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101f97:	83 c0 04             	add    $0x4,%eax
  101f9a:	0f b7 10             	movzwl (%eax),%edx
  101f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  101fa0:	66 89 50 48          	mov    %dx,0x48(%eax)
					tf->tf_padding0 = *((uint16_t *) (user_stack_ptr + 6));
  101fa4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101fa7:	83 c0 06             	add    $0x6,%eax
  101faa:	0f b7 10             	movzwl (%eax),%edx
  101fad:	8b 45 08             	mov    0x8(%ebp),%eax
  101fb0:	66 89 50 22          	mov    %dx,0x22(%eax)
					user_stack_ptr -= (uintptr_t) (sizeof(struct trapframe) - 8);
  101fb4:	83 6d e0 44          	subl   $0x44,-0x20(%ebp)
					*((struct trapframe *) user_stack_ptr) = *tf;
  101fb8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101fbb:	8b 55 08             	mov    0x8(%ebp),%edx
  101fbe:	bb 4c 00 00 00       	mov    $0x4c,%ebx
  101fc3:	89 c1                	mov    %eax,%ecx
  101fc5:	83 e1 01             	and    $0x1,%ecx
  101fc8:	85 c9                	test   %ecx,%ecx
  101fca:	74 0c                	je     101fd8 <trap_dispatch+0x1d7>
  101fcc:	0f b6 0a             	movzbl (%edx),%ecx
  101fcf:	88 08                	mov    %cl,(%eax)
  101fd1:	8d 40 01             	lea    0x1(%eax),%eax
  101fd4:	8d 52 01             	lea    0x1(%edx),%edx
  101fd7:	4b                   	dec    %ebx
  101fd8:	89 c1                	mov    %eax,%ecx
  101fda:	83 e1 02             	and    $0x2,%ecx
  101fdd:	85 c9                	test   %ecx,%ecx
  101fdf:	74 0f                	je     101ff0 <trap_dispatch+0x1ef>
  101fe1:	0f b7 0a             	movzwl (%edx),%ecx
  101fe4:	66 89 08             	mov    %cx,(%eax)
  101fe7:	8d 40 02             	lea    0x2(%eax),%eax
  101fea:	8d 52 02             	lea    0x2(%edx),%edx
  101fed:	83 eb 02             	sub    $0x2,%ebx
  101ff0:	89 df                	mov    %ebx,%edi
  101ff2:	83 e7 fc             	and    $0xfffffffc,%edi
  101ff5:	b9 00 00 00 00       	mov    $0x0,%ecx
  101ffa:	8b 34 0a             	mov    (%edx,%ecx,1),%esi
  101ffd:	89 34 08             	mov    %esi,(%eax,%ecx,1)
  102000:	83 c1 04             	add    $0x4,%ecx
  102003:	39 f9                	cmp    %edi,%ecx
  102005:	72 f3                	jb     101ffa <trap_dispatch+0x1f9>
  102007:	01 c8                	add    %ecx,%eax
  102009:	01 ca                	add    %ecx,%edx
  10200b:	b9 00 00 00 00       	mov    $0x0,%ecx
  102010:	89 de                	mov    %ebx,%esi
  102012:	83 e6 02             	and    $0x2,%esi
  102015:	85 f6                	test   %esi,%esi
  102017:	74 0b                	je     102024 <trap_dispatch+0x223>
  102019:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
  10201d:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
  102021:	83 c1 02             	add    $0x2,%ecx
  102024:	83 e3 01             	and    $0x1,%ebx
  102027:	85 db                	test   %ebx,%ebx
  102029:	74 07                	je     102032 <trap_dispatch+0x231>
  10202b:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
  10202f:	88 14 08             	mov    %dl,(%eax,%ecx,1)
						:"a" ((uint32_t) tf),
  102032:	8b 45 08             	mov    0x8(%ebp),%eax
					__asm__ __volatile__ (
  102035:	8b 55 e0             	mov    -0x20(%ebp),%edx
  102038:	89 d3                	mov    %edx,%ebx
  10203a:	89 58 fc             	mov    %ebx,-0x4(%eax)
				break;
  10203d:	e9 a8 00 00 00       	jmp    1020ea <loop+0x6e>
				if (trap_in_kernel(tf)) {
  102042:	8b 45 08             	mov    0x8(%ebp),%eax
  102045:	89 04 24             	mov    %eax,(%esp)
  102048:	e8 34 fb ff ff       	call   101b81 <trap_in_kernel>
  10204d:	85 c0                	test   %eax,%eax
  10204f:	0f 84 9b 00 00 00    	je     1020f0 <loop+0x74>
						:"a" ((uint32_t)(&tf->tf_esp)),
  102055:	8b 45 08             	mov    0x8(%ebp),%eax
  102058:	83 c0 44             	add    $0x44,%eax
						 "d" ((uint32_t)(tf)),
  10205b:	8b 55 08             	mov    0x8(%ebp),%edx
					__asm__ __volatile__ (
  10205e:	56                   	push   %esi
  10205f:	57                   	push   %edi
  102060:	53                   	push   %ebx
  102061:	83 6a fc 08          	subl   $0x8,-0x4(%edx)
  102065:	89 e6                	mov    %esp,%esi
  102067:	89 c1                	mov    %eax,%ecx
  102069:	29 f1                	sub    %esi,%ecx
  10206b:	41                   	inc    %ecx
  10206c:	89 e7                	mov    %esp,%edi
  10206e:	83 ef 08             	sub    $0x8,%edi
  102071:	fc                   	cld    
  102072:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102074:	83 ec 08             	sub    $0x8,%esp
  102077:	83 ed 08             	sub    $0x8,%ebp
  10207a:	89 eb                	mov    %ebp,%ebx

0010207c <loop>:
  10207c:	83 2b 08             	subl   $0x8,(%ebx)
  10207f:	8b 1b                	mov    (%ebx),%ebx
  102081:	39 d8                	cmp    %ebx,%eax
  102083:	7f f7                	jg     10207c <loop>
  102085:	89 40 f8             	mov    %eax,-0x8(%eax)
  102088:	c7 40 fc 23 00 00 00 	movl   $0x23,-0x4(%eax)
  10208f:	5b                   	pop    %ebx
  102090:	5f                   	pop    %edi
  102091:	5e                   	pop    %esi
					correct_tf->tf_cs = USER_CS;
  102092:	a1 80 ce 11 00       	mov    0x11ce80,%eax
  102097:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
					correct_tf->tf_ds = tf->tf_es = tf->tf_gs = tf->tf_fs = USER_DS;
  10209d:	8b 45 08             	mov    0x8(%ebp),%eax
  1020a0:	66 c7 40 24 23 00    	movw   $0x23,0x24(%eax)
  1020a6:	8b 45 08             	mov    0x8(%ebp),%eax
  1020a9:	0f b7 50 24          	movzwl 0x24(%eax),%edx
  1020ad:	8b 45 08             	mov    0x8(%ebp),%eax
  1020b0:	66 89 50 20          	mov    %dx,0x20(%eax)
  1020b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1020b7:	0f b7 50 20          	movzwl 0x20(%eax),%edx
  1020bb:	8b 45 08             	mov    0x8(%ebp),%eax
  1020be:	66 89 50 28          	mov    %dx,0x28(%eax)
  1020c2:	a1 80 ce 11 00       	mov    0x11ce80,%eax
  1020c7:	8b 55 08             	mov    0x8(%ebp),%edx
  1020ca:	0f b7 52 28          	movzwl 0x28(%edx),%edx
  1020ce:	66 89 50 2c          	mov    %dx,0x2c(%eax)
					correct_tf->tf_eflags |= FL_IOPL_MASK;
  1020d2:	a1 80 ce 11 00       	mov    0x11ce80,%eax
  1020d7:	8b 50 40             	mov    0x40(%eax),%edx
  1020da:	a1 80 ce 11 00       	mov    0x11ce80,%eax
  1020df:	81 ca 00 30 00 00    	or     $0x3000,%edx
  1020e5:	89 50 40             	mov    %edx,0x40(%eax)
				break;
  1020e8:	eb 06                	jmp    1020f0 <loop+0x74>
				break;
  1020ea:	90                   	nop
  1020eb:	e9 4f 01 00 00       	jmp    10223f <loop+0x1c3>
				break;
  1020f0:	90                   	nop
        break;
  1020f1:	e9 49 01 00 00       	jmp    10223f <loop+0x1c3>
		if ((tf->tf_cs & 3) == 0) {
  1020f6:	8b 45 08             	mov    0x8(%ebp),%eax
  1020f9:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  1020fd:	83 e0 03             	and    $0x3,%eax
  102100:	85 c0                	test   %eax,%eax
  102102:	0f 85 33 01 00 00    	jne    10223b <loop+0x1bf>
			tf->tf_cs = USER_CS;
  102108:	8b 45 08             	mov    0x8(%ebp),%eax
  10210b:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
			tf->tf_ss = tf->tf_ds = tf->tf_es = tf->tf_gs = tf->tf_fs = USER_DS;
  102111:	8b 45 08             	mov    0x8(%ebp),%eax
  102114:	66 c7 40 24 23 00    	movw   $0x23,0x24(%eax)
  10211a:	8b 45 08             	mov    0x8(%ebp),%eax
  10211d:	0f b7 50 24          	movzwl 0x24(%eax),%edx
  102121:	8b 45 08             	mov    0x8(%ebp),%eax
  102124:	66 89 50 20          	mov    %dx,0x20(%eax)
  102128:	8b 45 08             	mov    0x8(%ebp),%eax
  10212b:	0f b7 50 20          	movzwl 0x20(%eax),%edx
  10212f:	8b 45 08             	mov    0x8(%ebp),%eax
  102132:	66 89 50 28          	mov    %dx,0x28(%eax)
  102136:	8b 45 08             	mov    0x8(%ebp),%eax
  102139:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  10213d:	8b 45 08             	mov    0x8(%ebp),%eax
  102140:	66 89 50 2c          	mov    %dx,0x2c(%eax)
  102144:	8b 45 08             	mov    0x8(%ebp),%eax
  102147:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
  10214b:	8b 45 08             	mov    0x8(%ebp),%eax
  10214e:	66 89 50 48          	mov    %dx,0x48(%eax)
			tf->tf_esp += 4;
  102152:	8b 45 08             	mov    0x8(%ebp),%eax
  102155:	8b 40 44             	mov    0x44(%eax),%eax
  102158:	8d 50 04             	lea    0x4(%eax),%edx
  10215b:	8b 45 08             	mov    0x8(%ebp),%eax
  10215e:	89 50 44             	mov    %edx,0x44(%eax)
			tf->tf_eflags |= FL_IOPL_MASK;
  102161:	8b 45 08             	mov    0x8(%ebp),%eax
  102164:	8b 40 40             	mov    0x40(%eax),%eax
  102167:	0d 00 30 00 00       	or     $0x3000,%eax
  10216c:	89 c2                	mov    %eax,%edx
  10216e:	8b 45 08             	mov    0x8(%ebp),%eax
  102171:	89 50 40             	mov    %edx,0x40(%eax)
		break;
  102174:	e9 c2 00 00 00       	jmp    10223b <loop+0x1bf>
		if ((tf->tf_cs & 3) != 0) {
  102179:	8b 45 08             	mov    0x8(%ebp),%eax
  10217c:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  102180:	83 e0 03             	and    $0x3,%eax
  102183:	85 c0                	test   %eax,%eax
  102185:	0f 84 b3 00 00 00    	je     10223e <loop+0x1c2>
			tf->tf_cs = KERNEL_CS;
  10218b:	8b 45 08             	mov    0x8(%ebp),%eax
  10218e:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
			tf->tf_ss = tf->tf_ds = tf->tf_es = tf->tf_gs = tf->tf_fs = KERNEL_DS;
  102194:	8b 45 08             	mov    0x8(%ebp),%eax
  102197:	66 c7 40 24 10 00    	movw   $0x10,0x24(%eax)
  10219d:	8b 45 08             	mov    0x8(%ebp),%eax
  1021a0:	0f b7 50 24          	movzwl 0x24(%eax),%edx
  1021a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1021a7:	66 89 50 20          	mov    %dx,0x20(%eax)
  1021ab:	8b 45 08             	mov    0x8(%ebp),%eax
  1021ae:	0f b7 50 20          	movzwl 0x20(%eax),%edx
  1021b2:	8b 45 08             	mov    0x8(%ebp),%eax
  1021b5:	66 89 50 28          	mov    %dx,0x28(%eax)
  1021b9:	8b 45 08             	mov    0x8(%ebp),%eax
  1021bc:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  1021c0:	8b 45 08             	mov    0x8(%ebp),%eax
  1021c3:	66 89 50 2c          	mov    %dx,0x2c(%eax)
  1021c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1021ca:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
  1021ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1021d1:	66 89 50 48          	mov    %dx,0x48(%eax)
			tf->tf_eflags &= ~FL_IOPL_MASK;
  1021d5:	8b 45 08             	mov    0x8(%ebp),%eax
  1021d8:	8b 40 40             	mov    0x40(%eax),%eax
  1021db:	25 ff cf ff ff       	and    $0xffffcfff,%eax
  1021e0:	89 c2                	mov    %eax,%edx
  1021e2:	8b 45 08             	mov    0x8(%ebp),%eax
  1021e5:	89 50 40             	mov    %edx,0x40(%eax)
			break;
  1021e8:	eb 54                	jmp    10223e <loop+0x1c2>
	case T_GPFLT:
		cprintf("GP Fault!!!\n");
  1021ea:	c7 04 24 56 69 10 00 	movl   $0x106956,(%esp)
  1021f1:	e8 a4 e0 ff ff       	call   10029a <cprintf>
		print_trapframe(tf);
  1021f6:	8b 45 08             	mov    0x8(%ebp),%eax
  1021f9:	89 04 24             	mov    %eax,(%esp)
  1021fc:	e8 95 f9 ff ff       	call   101b96 <print_trapframe>
		break;
  102201:	eb 3c                	jmp    10223f <loop+0x1c3>
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  102203:	8b 45 08             	mov    0x8(%ebp),%eax
  102206:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  10220a:	83 e0 03             	and    $0x3,%eax
  10220d:	85 c0                	test   %eax,%eax
  10220f:	75 2e                	jne    10223f <loop+0x1c3>
            print_trapframe(tf);
  102211:	8b 45 08             	mov    0x8(%ebp),%eax
  102214:	89 04 24             	mov    %eax,(%esp)
  102217:	e8 7a f9 ff ff       	call   101b96 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  10221c:	c7 44 24 08 63 69 10 	movl   $0x106963,0x8(%esp)
  102223:	00 
  102224:	c7 44 24 04 36 01 00 	movl   $0x136,0x4(%esp)
  10222b:	00 
  10222c:	c7 04 24 7f 69 10 00 	movl   $0x10697f,(%esp)
  102233:	e8 ba e1 ff ff       	call   1003f2 <__panic>
        break;
  102238:	90                   	nop
  102239:	eb 04                	jmp    10223f <loop+0x1c3>
		break;
  10223b:	90                   	nop
  10223c:	eb 01                	jmp    10223f <loop+0x1c3>
			break;
  10223e:	90                   	nop
        }
    }
}
  10223f:	90                   	nop
  102240:	83 c4 2c             	add    $0x2c,%esp
  102243:	5b                   	pop    %ebx
  102244:	5e                   	pop    %esi
  102245:	5f                   	pop    %edi
  102246:	5d                   	pop    %ebp
  102247:	c3                   	ret    

00102248 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  102248:	55                   	push   %ebp
  102249:	89 e5                	mov    %esp,%ebp
  10224b:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  10224e:	8b 45 08             	mov    0x8(%ebp),%eax
  102251:	89 04 24             	mov    %eax,(%esp)
  102254:	e8 a8 fb ff ff       	call   101e01 <trap_dispatch>
}
  102259:	90                   	nop
  10225a:	c9                   	leave  
  10225b:	c3                   	ret    

0010225c <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  10225c:	6a 00                	push   $0x0
  pushl $0
  10225e:	6a 00                	push   $0x0
  jmp __alltraps
  102260:	e9 69 0a 00 00       	jmp    102cce <__alltraps>

00102265 <vector1>:
.globl vector1
vector1:
  pushl $0
  102265:	6a 00                	push   $0x0
  pushl $1
  102267:	6a 01                	push   $0x1
  jmp __alltraps
  102269:	e9 60 0a 00 00       	jmp    102cce <__alltraps>

0010226e <vector2>:
.globl vector2
vector2:
  pushl $0
  10226e:	6a 00                	push   $0x0
  pushl $2
  102270:	6a 02                	push   $0x2
  jmp __alltraps
  102272:	e9 57 0a 00 00       	jmp    102cce <__alltraps>

00102277 <vector3>:
.globl vector3
vector3:
  pushl $0
  102277:	6a 00                	push   $0x0
  pushl $3
  102279:	6a 03                	push   $0x3
  jmp __alltraps
  10227b:	e9 4e 0a 00 00       	jmp    102cce <__alltraps>

00102280 <vector4>:
.globl vector4
vector4:
  pushl $0
  102280:	6a 00                	push   $0x0
  pushl $4
  102282:	6a 04                	push   $0x4
  jmp __alltraps
  102284:	e9 45 0a 00 00       	jmp    102cce <__alltraps>

00102289 <vector5>:
.globl vector5
vector5:
  pushl $0
  102289:	6a 00                	push   $0x0
  pushl $5
  10228b:	6a 05                	push   $0x5
  jmp __alltraps
  10228d:	e9 3c 0a 00 00       	jmp    102cce <__alltraps>

00102292 <vector6>:
.globl vector6
vector6:
  pushl $0
  102292:	6a 00                	push   $0x0
  pushl $6
  102294:	6a 06                	push   $0x6
  jmp __alltraps
  102296:	e9 33 0a 00 00       	jmp    102cce <__alltraps>

0010229b <vector7>:
.globl vector7
vector7:
  pushl $0
  10229b:	6a 00                	push   $0x0
  pushl $7
  10229d:	6a 07                	push   $0x7
  jmp __alltraps
  10229f:	e9 2a 0a 00 00       	jmp    102cce <__alltraps>

001022a4 <vector8>:
.globl vector8
vector8:
  pushl $8
  1022a4:	6a 08                	push   $0x8
  jmp __alltraps
  1022a6:	e9 23 0a 00 00       	jmp    102cce <__alltraps>

001022ab <vector9>:
.globl vector9
vector9:
  pushl $0
  1022ab:	6a 00                	push   $0x0
  pushl $9
  1022ad:	6a 09                	push   $0x9
  jmp __alltraps
  1022af:	e9 1a 0a 00 00       	jmp    102cce <__alltraps>

001022b4 <vector10>:
.globl vector10
vector10:
  pushl $10
  1022b4:	6a 0a                	push   $0xa
  jmp __alltraps
  1022b6:	e9 13 0a 00 00       	jmp    102cce <__alltraps>

001022bb <vector11>:
.globl vector11
vector11:
  pushl $11
  1022bb:	6a 0b                	push   $0xb
  jmp __alltraps
  1022bd:	e9 0c 0a 00 00       	jmp    102cce <__alltraps>

001022c2 <vector12>:
.globl vector12
vector12:
  pushl $12
  1022c2:	6a 0c                	push   $0xc
  jmp __alltraps
  1022c4:	e9 05 0a 00 00       	jmp    102cce <__alltraps>

001022c9 <vector13>:
.globl vector13
vector13:
  pushl $13
  1022c9:	6a 0d                	push   $0xd
  jmp __alltraps
  1022cb:	e9 fe 09 00 00       	jmp    102cce <__alltraps>

001022d0 <vector14>:
.globl vector14
vector14:
  pushl $14
  1022d0:	6a 0e                	push   $0xe
  jmp __alltraps
  1022d2:	e9 f7 09 00 00       	jmp    102cce <__alltraps>

001022d7 <vector15>:
.globl vector15
vector15:
  pushl $0
  1022d7:	6a 00                	push   $0x0
  pushl $15
  1022d9:	6a 0f                	push   $0xf
  jmp __alltraps
  1022db:	e9 ee 09 00 00       	jmp    102cce <__alltraps>

001022e0 <vector16>:
.globl vector16
vector16:
  pushl $0
  1022e0:	6a 00                	push   $0x0
  pushl $16
  1022e2:	6a 10                	push   $0x10
  jmp __alltraps
  1022e4:	e9 e5 09 00 00       	jmp    102cce <__alltraps>

001022e9 <vector17>:
.globl vector17
vector17:
  pushl $17
  1022e9:	6a 11                	push   $0x11
  jmp __alltraps
  1022eb:	e9 de 09 00 00       	jmp    102cce <__alltraps>

001022f0 <vector18>:
.globl vector18
vector18:
  pushl $0
  1022f0:	6a 00                	push   $0x0
  pushl $18
  1022f2:	6a 12                	push   $0x12
  jmp __alltraps
  1022f4:	e9 d5 09 00 00       	jmp    102cce <__alltraps>

001022f9 <vector19>:
.globl vector19
vector19:
  pushl $0
  1022f9:	6a 00                	push   $0x0
  pushl $19
  1022fb:	6a 13                	push   $0x13
  jmp __alltraps
  1022fd:	e9 cc 09 00 00       	jmp    102cce <__alltraps>

00102302 <vector20>:
.globl vector20
vector20:
  pushl $0
  102302:	6a 00                	push   $0x0
  pushl $20
  102304:	6a 14                	push   $0x14
  jmp __alltraps
  102306:	e9 c3 09 00 00       	jmp    102cce <__alltraps>

0010230b <vector21>:
.globl vector21
vector21:
  pushl $0
  10230b:	6a 00                	push   $0x0
  pushl $21
  10230d:	6a 15                	push   $0x15
  jmp __alltraps
  10230f:	e9 ba 09 00 00       	jmp    102cce <__alltraps>

00102314 <vector22>:
.globl vector22
vector22:
  pushl $0
  102314:	6a 00                	push   $0x0
  pushl $22
  102316:	6a 16                	push   $0x16
  jmp __alltraps
  102318:	e9 b1 09 00 00       	jmp    102cce <__alltraps>

0010231d <vector23>:
.globl vector23
vector23:
  pushl $0
  10231d:	6a 00                	push   $0x0
  pushl $23
  10231f:	6a 17                	push   $0x17
  jmp __alltraps
  102321:	e9 a8 09 00 00       	jmp    102cce <__alltraps>

00102326 <vector24>:
.globl vector24
vector24:
  pushl $0
  102326:	6a 00                	push   $0x0
  pushl $24
  102328:	6a 18                	push   $0x18
  jmp __alltraps
  10232a:	e9 9f 09 00 00       	jmp    102cce <__alltraps>

0010232f <vector25>:
.globl vector25
vector25:
  pushl $0
  10232f:	6a 00                	push   $0x0
  pushl $25
  102331:	6a 19                	push   $0x19
  jmp __alltraps
  102333:	e9 96 09 00 00       	jmp    102cce <__alltraps>

00102338 <vector26>:
.globl vector26
vector26:
  pushl $0
  102338:	6a 00                	push   $0x0
  pushl $26
  10233a:	6a 1a                	push   $0x1a
  jmp __alltraps
  10233c:	e9 8d 09 00 00       	jmp    102cce <__alltraps>

00102341 <vector27>:
.globl vector27
vector27:
  pushl $0
  102341:	6a 00                	push   $0x0
  pushl $27
  102343:	6a 1b                	push   $0x1b
  jmp __alltraps
  102345:	e9 84 09 00 00       	jmp    102cce <__alltraps>

0010234a <vector28>:
.globl vector28
vector28:
  pushl $0
  10234a:	6a 00                	push   $0x0
  pushl $28
  10234c:	6a 1c                	push   $0x1c
  jmp __alltraps
  10234e:	e9 7b 09 00 00       	jmp    102cce <__alltraps>

00102353 <vector29>:
.globl vector29
vector29:
  pushl $0
  102353:	6a 00                	push   $0x0
  pushl $29
  102355:	6a 1d                	push   $0x1d
  jmp __alltraps
  102357:	e9 72 09 00 00       	jmp    102cce <__alltraps>

0010235c <vector30>:
.globl vector30
vector30:
  pushl $0
  10235c:	6a 00                	push   $0x0
  pushl $30
  10235e:	6a 1e                	push   $0x1e
  jmp __alltraps
  102360:	e9 69 09 00 00       	jmp    102cce <__alltraps>

00102365 <vector31>:
.globl vector31
vector31:
  pushl $0
  102365:	6a 00                	push   $0x0
  pushl $31
  102367:	6a 1f                	push   $0x1f
  jmp __alltraps
  102369:	e9 60 09 00 00       	jmp    102cce <__alltraps>

0010236e <vector32>:
.globl vector32
vector32:
  pushl $0
  10236e:	6a 00                	push   $0x0
  pushl $32
  102370:	6a 20                	push   $0x20
  jmp __alltraps
  102372:	e9 57 09 00 00       	jmp    102cce <__alltraps>

00102377 <vector33>:
.globl vector33
vector33:
  pushl $0
  102377:	6a 00                	push   $0x0
  pushl $33
  102379:	6a 21                	push   $0x21
  jmp __alltraps
  10237b:	e9 4e 09 00 00       	jmp    102cce <__alltraps>

00102380 <vector34>:
.globl vector34
vector34:
  pushl $0
  102380:	6a 00                	push   $0x0
  pushl $34
  102382:	6a 22                	push   $0x22
  jmp __alltraps
  102384:	e9 45 09 00 00       	jmp    102cce <__alltraps>

00102389 <vector35>:
.globl vector35
vector35:
  pushl $0
  102389:	6a 00                	push   $0x0
  pushl $35
  10238b:	6a 23                	push   $0x23
  jmp __alltraps
  10238d:	e9 3c 09 00 00       	jmp    102cce <__alltraps>

00102392 <vector36>:
.globl vector36
vector36:
  pushl $0
  102392:	6a 00                	push   $0x0
  pushl $36
  102394:	6a 24                	push   $0x24
  jmp __alltraps
  102396:	e9 33 09 00 00       	jmp    102cce <__alltraps>

0010239b <vector37>:
.globl vector37
vector37:
  pushl $0
  10239b:	6a 00                	push   $0x0
  pushl $37
  10239d:	6a 25                	push   $0x25
  jmp __alltraps
  10239f:	e9 2a 09 00 00       	jmp    102cce <__alltraps>

001023a4 <vector38>:
.globl vector38
vector38:
  pushl $0
  1023a4:	6a 00                	push   $0x0
  pushl $38
  1023a6:	6a 26                	push   $0x26
  jmp __alltraps
  1023a8:	e9 21 09 00 00       	jmp    102cce <__alltraps>

001023ad <vector39>:
.globl vector39
vector39:
  pushl $0
  1023ad:	6a 00                	push   $0x0
  pushl $39
  1023af:	6a 27                	push   $0x27
  jmp __alltraps
  1023b1:	e9 18 09 00 00       	jmp    102cce <__alltraps>

001023b6 <vector40>:
.globl vector40
vector40:
  pushl $0
  1023b6:	6a 00                	push   $0x0
  pushl $40
  1023b8:	6a 28                	push   $0x28
  jmp __alltraps
  1023ba:	e9 0f 09 00 00       	jmp    102cce <__alltraps>

001023bf <vector41>:
.globl vector41
vector41:
  pushl $0
  1023bf:	6a 00                	push   $0x0
  pushl $41
  1023c1:	6a 29                	push   $0x29
  jmp __alltraps
  1023c3:	e9 06 09 00 00       	jmp    102cce <__alltraps>

001023c8 <vector42>:
.globl vector42
vector42:
  pushl $0
  1023c8:	6a 00                	push   $0x0
  pushl $42
  1023ca:	6a 2a                	push   $0x2a
  jmp __alltraps
  1023cc:	e9 fd 08 00 00       	jmp    102cce <__alltraps>

001023d1 <vector43>:
.globl vector43
vector43:
  pushl $0
  1023d1:	6a 00                	push   $0x0
  pushl $43
  1023d3:	6a 2b                	push   $0x2b
  jmp __alltraps
  1023d5:	e9 f4 08 00 00       	jmp    102cce <__alltraps>

001023da <vector44>:
.globl vector44
vector44:
  pushl $0
  1023da:	6a 00                	push   $0x0
  pushl $44
  1023dc:	6a 2c                	push   $0x2c
  jmp __alltraps
  1023de:	e9 eb 08 00 00       	jmp    102cce <__alltraps>

001023e3 <vector45>:
.globl vector45
vector45:
  pushl $0
  1023e3:	6a 00                	push   $0x0
  pushl $45
  1023e5:	6a 2d                	push   $0x2d
  jmp __alltraps
  1023e7:	e9 e2 08 00 00       	jmp    102cce <__alltraps>

001023ec <vector46>:
.globl vector46
vector46:
  pushl $0
  1023ec:	6a 00                	push   $0x0
  pushl $46
  1023ee:	6a 2e                	push   $0x2e
  jmp __alltraps
  1023f0:	e9 d9 08 00 00       	jmp    102cce <__alltraps>

001023f5 <vector47>:
.globl vector47
vector47:
  pushl $0
  1023f5:	6a 00                	push   $0x0
  pushl $47
  1023f7:	6a 2f                	push   $0x2f
  jmp __alltraps
  1023f9:	e9 d0 08 00 00       	jmp    102cce <__alltraps>

001023fe <vector48>:
.globl vector48
vector48:
  pushl $0
  1023fe:	6a 00                	push   $0x0
  pushl $48
  102400:	6a 30                	push   $0x30
  jmp __alltraps
  102402:	e9 c7 08 00 00       	jmp    102cce <__alltraps>

00102407 <vector49>:
.globl vector49
vector49:
  pushl $0
  102407:	6a 00                	push   $0x0
  pushl $49
  102409:	6a 31                	push   $0x31
  jmp __alltraps
  10240b:	e9 be 08 00 00       	jmp    102cce <__alltraps>

00102410 <vector50>:
.globl vector50
vector50:
  pushl $0
  102410:	6a 00                	push   $0x0
  pushl $50
  102412:	6a 32                	push   $0x32
  jmp __alltraps
  102414:	e9 b5 08 00 00       	jmp    102cce <__alltraps>

00102419 <vector51>:
.globl vector51
vector51:
  pushl $0
  102419:	6a 00                	push   $0x0
  pushl $51
  10241b:	6a 33                	push   $0x33
  jmp __alltraps
  10241d:	e9 ac 08 00 00       	jmp    102cce <__alltraps>

00102422 <vector52>:
.globl vector52
vector52:
  pushl $0
  102422:	6a 00                	push   $0x0
  pushl $52
  102424:	6a 34                	push   $0x34
  jmp __alltraps
  102426:	e9 a3 08 00 00       	jmp    102cce <__alltraps>

0010242b <vector53>:
.globl vector53
vector53:
  pushl $0
  10242b:	6a 00                	push   $0x0
  pushl $53
  10242d:	6a 35                	push   $0x35
  jmp __alltraps
  10242f:	e9 9a 08 00 00       	jmp    102cce <__alltraps>

00102434 <vector54>:
.globl vector54
vector54:
  pushl $0
  102434:	6a 00                	push   $0x0
  pushl $54
  102436:	6a 36                	push   $0x36
  jmp __alltraps
  102438:	e9 91 08 00 00       	jmp    102cce <__alltraps>

0010243d <vector55>:
.globl vector55
vector55:
  pushl $0
  10243d:	6a 00                	push   $0x0
  pushl $55
  10243f:	6a 37                	push   $0x37
  jmp __alltraps
  102441:	e9 88 08 00 00       	jmp    102cce <__alltraps>

00102446 <vector56>:
.globl vector56
vector56:
  pushl $0
  102446:	6a 00                	push   $0x0
  pushl $56
  102448:	6a 38                	push   $0x38
  jmp __alltraps
  10244a:	e9 7f 08 00 00       	jmp    102cce <__alltraps>

0010244f <vector57>:
.globl vector57
vector57:
  pushl $0
  10244f:	6a 00                	push   $0x0
  pushl $57
  102451:	6a 39                	push   $0x39
  jmp __alltraps
  102453:	e9 76 08 00 00       	jmp    102cce <__alltraps>

00102458 <vector58>:
.globl vector58
vector58:
  pushl $0
  102458:	6a 00                	push   $0x0
  pushl $58
  10245a:	6a 3a                	push   $0x3a
  jmp __alltraps
  10245c:	e9 6d 08 00 00       	jmp    102cce <__alltraps>

00102461 <vector59>:
.globl vector59
vector59:
  pushl $0
  102461:	6a 00                	push   $0x0
  pushl $59
  102463:	6a 3b                	push   $0x3b
  jmp __alltraps
  102465:	e9 64 08 00 00       	jmp    102cce <__alltraps>

0010246a <vector60>:
.globl vector60
vector60:
  pushl $0
  10246a:	6a 00                	push   $0x0
  pushl $60
  10246c:	6a 3c                	push   $0x3c
  jmp __alltraps
  10246e:	e9 5b 08 00 00       	jmp    102cce <__alltraps>

00102473 <vector61>:
.globl vector61
vector61:
  pushl $0
  102473:	6a 00                	push   $0x0
  pushl $61
  102475:	6a 3d                	push   $0x3d
  jmp __alltraps
  102477:	e9 52 08 00 00       	jmp    102cce <__alltraps>

0010247c <vector62>:
.globl vector62
vector62:
  pushl $0
  10247c:	6a 00                	push   $0x0
  pushl $62
  10247e:	6a 3e                	push   $0x3e
  jmp __alltraps
  102480:	e9 49 08 00 00       	jmp    102cce <__alltraps>

00102485 <vector63>:
.globl vector63
vector63:
  pushl $0
  102485:	6a 00                	push   $0x0
  pushl $63
  102487:	6a 3f                	push   $0x3f
  jmp __alltraps
  102489:	e9 40 08 00 00       	jmp    102cce <__alltraps>

0010248e <vector64>:
.globl vector64
vector64:
  pushl $0
  10248e:	6a 00                	push   $0x0
  pushl $64
  102490:	6a 40                	push   $0x40
  jmp __alltraps
  102492:	e9 37 08 00 00       	jmp    102cce <__alltraps>

00102497 <vector65>:
.globl vector65
vector65:
  pushl $0
  102497:	6a 00                	push   $0x0
  pushl $65
  102499:	6a 41                	push   $0x41
  jmp __alltraps
  10249b:	e9 2e 08 00 00       	jmp    102cce <__alltraps>

001024a0 <vector66>:
.globl vector66
vector66:
  pushl $0
  1024a0:	6a 00                	push   $0x0
  pushl $66
  1024a2:	6a 42                	push   $0x42
  jmp __alltraps
  1024a4:	e9 25 08 00 00       	jmp    102cce <__alltraps>

001024a9 <vector67>:
.globl vector67
vector67:
  pushl $0
  1024a9:	6a 00                	push   $0x0
  pushl $67
  1024ab:	6a 43                	push   $0x43
  jmp __alltraps
  1024ad:	e9 1c 08 00 00       	jmp    102cce <__alltraps>

001024b2 <vector68>:
.globl vector68
vector68:
  pushl $0
  1024b2:	6a 00                	push   $0x0
  pushl $68
  1024b4:	6a 44                	push   $0x44
  jmp __alltraps
  1024b6:	e9 13 08 00 00       	jmp    102cce <__alltraps>

001024bb <vector69>:
.globl vector69
vector69:
  pushl $0
  1024bb:	6a 00                	push   $0x0
  pushl $69
  1024bd:	6a 45                	push   $0x45
  jmp __alltraps
  1024bf:	e9 0a 08 00 00       	jmp    102cce <__alltraps>

001024c4 <vector70>:
.globl vector70
vector70:
  pushl $0
  1024c4:	6a 00                	push   $0x0
  pushl $70
  1024c6:	6a 46                	push   $0x46
  jmp __alltraps
  1024c8:	e9 01 08 00 00       	jmp    102cce <__alltraps>

001024cd <vector71>:
.globl vector71
vector71:
  pushl $0
  1024cd:	6a 00                	push   $0x0
  pushl $71
  1024cf:	6a 47                	push   $0x47
  jmp __alltraps
  1024d1:	e9 f8 07 00 00       	jmp    102cce <__alltraps>

001024d6 <vector72>:
.globl vector72
vector72:
  pushl $0
  1024d6:	6a 00                	push   $0x0
  pushl $72
  1024d8:	6a 48                	push   $0x48
  jmp __alltraps
  1024da:	e9 ef 07 00 00       	jmp    102cce <__alltraps>

001024df <vector73>:
.globl vector73
vector73:
  pushl $0
  1024df:	6a 00                	push   $0x0
  pushl $73
  1024e1:	6a 49                	push   $0x49
  jmp __alltraps
  1024e3:	e9 e6 07 00 00       	jmp    102cce <__alltraps>

001024e8 <vector74>:
.globl vector74
vector74:
  pushl $0
  1024e8:	6a 00                	push   $0x0
  pushl $74
  1024ea:	6a 4a                	push   $0x4a
  jmp __alltraps
  1024ec:	e9 dd 07 00 00       	jmp    102cce <__alltraps>

001024f1 <vector75>:
.globl vector75
vector75:
  pushl $0
  1024f1:	6a 00                	push   $0x0
  pushl $75
  1024f3:	6a 4b                	push   $0x4b
  jmp __alltraps
  1024f5:	e9 d4 07 00 00       	jmp    102cce <__alltraps>

001024fa <vector76>:
.globl vector76
vector76:
  pushl $0
  1024fa:	6a 00                	push   $0x0
  pushl $76
  1024fc:	6a 4c                	push   $0x4c
  jmp __alltraps
  1024fe:	e9 cb 07 00 00       	jmp    102cce <__alltraps>

00102503 <vector77>:
.globl vector77
vector77:
  pushl $0
  102503:	6a 00                	push   $0x0
  pushl $77
  102505:	6a 4d                	push   $0x4d
  jmp __alltraps
  102507:	e9 c2 07 00 00       	jmp    102cce <__alltraps>

0010250c <vector78>:
.globl vector78
vector78:
  pushl $0
  10250c:	6a 00                	push   $0x0
  pushl $78
  10250e:	6a 4e                	push   $0x4e
  jmp __alltraps
  102510:	e9 b9 07 00 00       	jmp    102cce <__alltraps>

00102515 <vector79>:
.globl vector79
vector79:
  pushl $0
  102515:	6a 00                	push   $0x0
  pushl $79
  102517:	6a 4f                	push   $0x4f
  jmp __alltraps
  102519:	e9 b0 07 00 00       	jmp    102cce <__alltraps>

0010251e <vector80>:
.globl vector80
vector80:
  pushl $0
  10251e:	6a 00                	push   $0x0
  pushl $80
  102520:	6a 50                	push   $0x50
  jmp __alltraps
  102522:	e9 a7 07 00 00       	jmp    102cce <__alltraps>

00102527 <vector81>:
.globl vector81
vector81:
  pushl $0
  102527:	6a 00                	push   $0x0
  pushl $81
  102529:	6a 51                	push   $0x51
  jmp __alltraps
  10252b:	e9 9e 07 00 00       	jmp    102cce <__alltraps>

00102530 <vector82>:
.globl vector82
vector82:
  pushl $0
  102530:	6a 00                	push   $0x0
  pushl $82
  102532:	6a 52                	push   $0x52
  jmp __alltraps
  102534:	e9 95 07 00 00       	jmp    102cce <__alltraps>

00102539 <vector83>:
.globl vector83
vector83:
  pushl $0
  102539:	6a 00                	push   $0x0
  pushl $83
  10253b:	6a 53                	push   $0x53
  jmp __alltraps
  10253d:	e9 8c 07 00 00       	jmp    102cce <__alltraps>

00102542 <vector84>:
.globl vector84
vector84:
  pushl $0
  102542:	6a 00                	push   $0x0
  pushl $84
  102544:	6a 54                	push   $0x54
  jmp __alltraps
  102546:	e9 83 07 00 00       	jmp    102cce <__alltraps>

0010254b <vector85>:
.globl vector85
vector85:
  pushl $0
  10254b:	6a 00                	push   $0x0
  pushl $85
  10254d:	6a 55                	push   $0x55
  jmp __alltraps
  10254f:	e9 7a 07 00 00       	jmp    102cce <__alltraps>

00102554 <vector86>:
.globl vector86
vector86:
  pushl $0
  102554:	6a 00                	push   $0x0
  pushl $86
  102556:	6a 56                	push   $0x56
  jmp __alltraps
  102558:	e9 71 07 00 00       	jmp    102cce <__alltraps>

0010255d <vector87>:
.globl vector87
vector87:
  pushl $0
  10255d:	6a 00                	push   $0x0
  pushl $87
  10255f:	6a 57                	push   $0x57
  jmp __alltraps
  102561:	e9 68 07 00 00       	jmp    102cce <__alltraps>

00102566 <vector88>:
.globl vector88
vector88:
  pushl $0
  102566:	6a 00                	push   $0x0
  pushl $88
  102568:	6a 58                	push   $0x58
  jmp __alltraps
  10256a:	e9 5f 07 00 00       	jmp    102cce <__alltraps>

0010256f <vector89>:
.globl vector89
vector89:
  pushl $0
  10256f:	6a 00                	push   $0x0
  pushl $89
  102571:	6a 59                	push   $0x59
  jmp __alltraps
  102573:	e9 56 07 00 00       	jmp    102cce <__alltraps>

00102578 <vector90>:
.globl vector90
vector90:
  pushl $0
  102578:	6a 00                	push   $0x0
  pushl $90
  10257a:	6a 5a                	push   $0x5a
  jmp __alltraps
  10257c:	e9 4d 07 00 00       	jmp    102cce <__alltraps>

00102581 <vector91>:
.globl vector91
vector91:
  pushl $0
  102581:	6a 00                	push   $0x0
  pushl $91
  102583:	6a 5b                	push   $0x5b
  jmp __alltraps
  102585:	e9 44 07 00 00       	jmp    102cce <__alltraps>

0010258a <vector92>:
.globl vector92
vector92:
  pushl $0
  10258a:	6a 00                	push   $0x0
  pushl $92
  10258c:	6a 5c                	push   $0x5c
  jmp __alltraps
  10258e:	e9 3b 07 00 00       	jmp    102cce <__alltraps>

00102593 <vector93>:
.globl vector93
vector93:
  pushl $0
  102593:	6a 00                	push   $0x0
  pushl $93
  102595:	6a 5d                	push   $0x5d
  jmp __alltraps
  102597:	e9 32 07 00 00       	jmp    102cce <__alltraps>

0010259c <vector94>:
.globl vector94
vector94:
  pushl $0
  10259c:	6a 00                	push   $0x0
  pushl $94
  10259e:	6a 5e                	push   $0x5e
  jmp __alltraps
  1025a0:	e9 29 07 00 00       	jmp    102cce <__alltraps>

001025a5 <vector95>:
.globl vector95
vector95:
  pushl $0
  1025a5:	6a 00                	push   $0x0
  pushl $95
  1025a7:	6a 5f                	push   $0x5f
  jmp __alltraps
  1025a9:	e9 20 07 00 00       	jmp    102cce <__alltraps>

001025ae <vector96>:
.globl vector96
vector96:
  pushl $0
  1025ae:	6a 00                	push   $0x0
  pushl $96
  1025b0:	6a 60                	push   $0x60
  jmp __alltraps
  1025b2:	e9 17 07 00 00       	jmp    102cce <__alltraps>

001025b7 <vector97>:
.globl vector97
vector97:
  pushl $0
  1025b7:	6a 00                	push   $0x0
  pushl $97
  1025b9:	6a 61                	push   $0x61
  jmp __alltraps
  1025bb:	e9 0e 07 00 00       	jmp    102cce <__alltraps>

001025c0 <vector98>:
.globl vector98
vector98:
  pushl $0
  1025c0:	6a 00                	push   $0x0
  pushl $98
  1025c2:	6a 62                	push   $0x62
  jmp __alltraps
  1025c4:	e9 05 07 00 00       	jmp    102cce <__alltraps>

001025c9 <vector99>:
.globl vector99
vector99:
  pushl $0
  1025c9:	6a 00                	push   $0x0
  pushl $99
  1025cb:	6a 63                	push   $0x63
  jmp __alltraps
  1025cd:	e9 fc 06 00 00       	jmp    102cce <__alltraps>

001025d2 <vector100>:
.globl vector100
vector100:
  pushl $0
  1025d2:	6a 00                	push   $0x0
  pushl $100
  1025d4:	6a 64                	push   $0x64
  jmp __alltraps
  1025d6:	e9 f3 06 00 00       	jmp    102cce <__alltraps>

001025db <vector101>:
.globl vector101
vector101:
  pushl $0
  1025db:	6a 00                	push   $0x0
  pushl $101
  1025dd:	6a 65                	push   $0x65
  jmp __alltraps
  1025df:	e9 ea 06 00 00       	jmp    102cce <__alltraps>

001025e4 <vector102>:
.globl vector102
vector102:
  pushl $0
  1025e4:	6a 00                	push   $0x0
  pushl $102
  1025e6:	6a 66                	push   $0x66
  jmp __alltraps
  1025e8:	e9 e1 06 00 00       	jmp    102cce <__alltraps>

001025ed <vector103>:
.globl vector103
vector103:
  pushl $0
  1025ed:	6a 00                	push   $0x0
  pushl $103
  1025ef:	6a 67                	push   $0x67
  jmp __alltraps
  1025f1:	e9 d8 06 00 00       	jmp    102cce <__alltraps>

001025f6 <vector104>:
.globl vector104
vector104:
  pushl $0
  1025f6:	6a 00                	push   $0x0
  pushl $104
  1025f8:	6a 68                	push   $0x68
  jmp __alltraps
  1025fa:	e9 cf 06 00 00       	jmp    102cce <__alltraps>

001025ff <vector105>:
.globl vector105
vector105:
  pushl $0
  1025ff:	6a 00                	push   $0x0
  pushl $105
  102601:	6a 69                	push   $0x69
  jmp __alltraps
  102603:	e9 c6 06 00 00       	jmp    102cce <__alltraps>

00102608 <vector106>:
.globl vector106
vector106:
  pushl $0
  102608:	6a 00                	push   $0x0
  pushl $106
  10260a:	6a 6a                	push   $0x6a
  jmp __alltraps
  10260c:	e9 bd 06 00 00       	jmp    102cce <__alltraps>

00102611 <vector107>:
.globl vector107
vector107:
  pushl $0
  102611:	6a 00                	push   $0x0
  pushl $107
  102613:	6a 6b                	push   $0x6b
  jmp __alltraps
  102615:	e9 b4 06 00 00       	jmp    102cce <__alltraps>

0010261a <vector108>:
.globl vector108
vector108:
  pushl $0
  10261a:	6a 00                	push   $0x0
  pushl $108
  10261c:	6a 6c                	push   $0x6c
  jmp __alltraps
  10261e:	e9 ab 06 00 00       	jmp    102cce <__alltraps>

00102623 <vector109>:
.globl vector109
vector109:
  pushl $0
  102623:	6a 00                	push   $0x0
  pushl $109
  102625:	6a 6d                	push   $0x6d
  jmp __alltraps
  102627:	e9 a2 06 00 00       	jmp    102cce <__alltraps>

0010262c <vector110>:
.globl vector110
vector110:
  pushl $0
  10262c:	6a 00                	push   $0x0
  pushl $110
  10262e:	6a 6e                	push   $0x6e
  jmp __alltraps
  102630:	e9 99 06 00 00       	jmp    102cce <__alltraps>

00102635 <vector111>:
.globl vector111
vector111:
  pushl $0
  102635:	6a 00                	push   $0x0
  pushl $111
  102637:	6a 6f                	push   $0x6f
  jmp __alltraps
  102639:	e9 90 06 00 00       	jmp    102cce <__alltraps>

0010263e <vector112>:
.globl vector112
vector112:
  pushl $0
  10263e:	6a 00                	push   $0x0
  pushl $112
  102640:	6a 70                	push   $0x70
  jmp __alltraps
  102642:	e9 87 06 00 00       	jmp    102cce <__alltraps>

00102647 <vector113>:
.globl vector113
vector113:
  pushl $0
  102647:	6a 00                	push   $0x0
  pushl $113
  102649:	6a 71                	push   $0x71
  jmp __alltraps
  10264b:	e9 7e 06 00 00       	jmp    102cce <__alltraps>

00102650 <vector114>:
.globl vector114
vector114:
  pushl $0
  102650:	6a 00                	push   $0x0
  pushl $114
  102652:	6a 72                	push   $0x72
  jmp __alltraps
  102654:	e9 75 06 00 00       	jmp    102cce <__alltraps>

00102659 <vector115>:
.globl vector115
vector115:
  pushl $0
  102659:	6a 00                	push   $0x0
  pushl $115
  10265b:	6a 73                	push   $0x73
  jmp __alltraps
  10265d:	e9 6c 06 00 00       	jmp    102cce <__alltraps>

00102662 <vector116>:
.globl vector116
vector116:
  pushl $0
  102662:	6a 00                	push   $0x0
  pushl $116
  102664:	6a 74                	push   $0x74
  jmp __alltraps
  102666:	e9 63 06 00 00       	jmp    102cce <__alltraps>

0010266b <vector117>:
.globl vector117
vector117:
  pushl $0
  10266b:	6a 00                	push   $0x0
  pushl $117
  10266d:	6a 75                	push   $0x75
  jmp __alltraps
  10266f:	e9 5a 06 00 00       	jmp    102cce <__alltraps>

00102674 <vector118>:
.globl vector118
vector118:
  pushl $0
  102674:	6a 00                	push   $0x0
  pushl $118
  102676:	6a 76                	push   $0x76
  jmp __alltraps
  102678:	e9 51 06 00 00       	jmp    102cce <__alltraps>

0010267d <vector119>:
.globl vector119
vector119:
  pushl $0
  10267d:	6a 00                	push   $0x0
  pushl $119
  10267f:	6a 77                	push   $0x77
  jmp __alltraps
  102681:	e9 48 06 00 00       	jmp    102cce <__alltraps>

00102686 <vector120>:
.globl vector120
vector120:
  pushl $0
  102686:	6a 00                	push   $0x0
  pushl $120
  102688:	6a 78                	push   $0x78
  jmp __alltraps
  10268a:	e9 3f 06 00 00       	jmp    102cce <__alltraps>

0010268f <vector121>:
.globl vector121
vector121:
  pushl $0
  10268f:	6a 00                	push   $0x0
  pushl $121
  102691:	6a 79                	push   $0x79
  jmp __alltraps
  102693:	e9 36 06 00 00       	jmp    102cce <__alltraps>

00102698 <vector122>:
.globl vector122
vector122:
  pushl $0
  102698:	6a 00                	push   $0x0
  pushl $122
  10269a:	6a 7a                	push   $0x7a
  jmp __alltraps
  10269c:	e9 2d 06 00 00       	jmp    102cce <__alltraps>

001026a1 <vector123>:
.globl vector123
vector123:
  pushl $0
  1026a1:	6a 00                	push   $0x0
  pushl $123
  1026a3:	6a 7b                	push   $0x7b
  jmp __alltraps
  1026a5:	e9 24 06 00 00       	jmp    102cce <__alltraps>

001026aa <vector124>:
.globl vector124
vector124:
  pushl $0
  1026aa:	6a 00                	push   $0x0
  pushl $124
  1026ac:	6a 7c                	push   $0x7c
  jmp __alltraps
  1026ae:	e9 1b 06 00 00       	jmp    102cce <__alltraps>

001026b3 <vector125>:
.globl vector125
vector125:
  pushl $0
  1026b3:	6a 00                	push   $0x0
  pushl $125
  1026b5:	6a 7d                	push   $0x7d
  jmp __alltraps
  1026b7:	e9 12 06 00 00       	jmp    102cce <__alltraps>

001026bc <vector126>:
.globl vector126
vector126:
  pushl $0
  1026bc:	6a 00                	push   $0x0
  pushl $126
  1026be:	6a 7e                	push   $0x7e
  jmp __alltraps
  1026c0:	e9 09 06 00 00       	jmp    102cce <__alltraps>

001026c5 <vector127>:
.globl vector127
vector127:
  pushl $0
  1026c5:	6a 00                	push   $0x0
  pushl $127
  1026c7:	6a 7f                	push   $0x7f
  jmp __alltraps
  1026c9:	e9 00 06 00 00       	jmp    102cce <__alltraps>

001026ce <vector128>:
.globl vector128
vector128:
  pushl $0
  1026ce:	6a 00                	push   $0x0
  pushl $128
  1026d0:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  1026d5:	e9 f4 05 00 00       	jmp    102cce <__alltraps>

001026da <vector129>:
.globl vector129
vector129:
  pushl $0
  1026da:	6a 00                	push   $0x0
  pushl $129
  1026dc:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  1026e1:	e9 e8 05 00 00       	jmp    102cce <__alltraps>

001026e6 <vector130>:
.globl vector130
vector130:
  pushl $0
  1026e6:	6a 00                	push   $0x0
  pushl $130
  1026e8:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  1026ed:	e9 dc 05 00 00       	jmp    102cce <__alltraps>

001026f2 <vector131>:
.globl vector131
vector131:
  pushl $0
  1026f2:	6a 00                	push   $0x0
  pushl $131
  1026f4:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  1026f9:	e9 d0 05 00 00       	jmp    102cce <__alltraps>

001026fe <vector132>:
.globl vector132
vector132:
  pushl $0
  1026fe:	6a 00                	push   $0x0
  pushl $132
  102700:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102705:	e9 c4 05 00 00       	jmp    102cce <__alltraps>

0010270a <vector133>:
.globl vector133
vector133:
  pushl $0
  10270a:	6a 00                	push   $0x0
  pushl $133
  10270c:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102711:	e9 b8 05 00 00       	jmp    102cce <__alltraps>

00102716 <vector134>:
.globl vector134
vector134:
  pushl $0
  102716:	6a 00                	push   $0x0
  pushl $134
  102718:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  10271d:	e9 ac 05 00 00       	jmp    102cce <__alltraps>

00102722 <vector135>:
.globl vector135
vector135:
  pushl $0
  102722:	6a 00                	push   $0x0
  pushl $135
  102724:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  102729:	e9 a0 05 00 00       	jmp    102cce <__alltraps>

0010272e <vector136>:
.globl vector136
vector136:
  pushl $0
  10272e:	6a 00                	push   $0x0
  pushl $136
  102730:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102735:	e9 94 05 00 00       	jmp    102cce <__alltraps>

0010273a <vector137>:
.globl vector137
vector137:
  pushl $0
  10273a:	6a 00                	push   $0x0
  pushl $137
  10273c:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  102741:	e9 88 05 00 00       	jmp    102cce <__alltraps>

00102746 <vector138>:
.globl vector138
vector138:
  pushl $0
  102746:	6a 00                	push   $0x0
  pushl $138
  102748:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  10274d:	e9 7c 05 00 00       	jmp    102cce <__alltraps>

00102752 <vector139>:
.globl vector139
vector139:
  pushl $0
  102752:	6a 00                	push   $0x0
  pushl $139
  102754:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102759:	e9 70 05 00 00       	jmp    102cce <__alltraps>

0010275e <vector140>:
.globl vector140
vector140:
  pushl $0
  10275e:	6a 00                	push   $0x0
  pushl $140
  102760:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  102765:	e9 64 05 00 00       	jmp    102cce <__alltraps>

0010276a <vector141>:
.globl vector141
vector141:
  pushl $0
  10276a:	6a 00                	push   $0x0
  pushl $141
  10276c:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  102771:	e9 58 05 00 00       	jmp    102cce <__alltraps>

00102776 <vector142>:
.globl vector142
vector142:
  pushl $0
  102776:	6a 00                	push   $0x0
  pushl $142
  102778:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  10277d:	e9 4c 05 00 00       	jmp    102cce <__alltraps>

00102782 <vector143>:
.globl vector143
vector143:
  pushl $0
  102782:	6a 00                	push   $0x0
  pushl $143
  102784:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  102789:	e9 40 05 00 00       	jmp    102cce <__alltraps>

0010278e <vector144>:
.globl vector144
vector144:
  pushl $0
  10278e:	6a 00                	push   $0x0
  pushl $144
  102790:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  102795:	e9 34 05 00 00       	jmp    102cce <__alltraps>

0010279a <vector145>:
.globl vector145
vector145:
  pushl $0
  10279a:	6a 00                	push   $0x0
  pushl $145
  10279c:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  1027a1:	e9 28 05 00 00       	jmp    102cce <__alltraps>

001027a6 <vector146>:
.globl vector146
vector146:
  pushl $0
  1027a6:	6a 00                	push   $0x0
  pushl $146
  1027a8:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  1027ad:	e9 1c 05 00 00       	jmp    102cce <__alltraps>

001027b2 <vector147>:
.globl vector147
vector147:
  pushl $0
  1027b2:	6a 00                	push   $0x0
  pushl $147
  1027b4:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  1027b9:	e9 10 05 00 00       	jmp    102cce <__alltraps>

001027be <vector148>:
.globl vector148
vector148:
  pushl $0
  1027be:	6a 00                	push   $0x0
  pushl $148
  1027c0:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  1027c5:	e9 04 05 00 00       	jmp    102cce <__alltraps>

001027ca <vector149>:
.globl vector149
vector149:
  pushl $0
  1027ca:	6a 00                	push   $0x0
  pushl $149
  1027cc:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1027d1:	e9 f8 04 00 00       	jmp    102cce <__alltraps>

001027d6 <vector150>:
.globl vector150
vector150:
  pushl $0
  1027d6:	6a 00                	push   $0x0
  pushl $150
  1027d8:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  1027dd:	e9 ec 04 00 00       	jmp    102cce <__alltraps>

001027e2 <vector151>:
.globl vector151
vector151:
  pushl $0
  1027e2:	6a 00                	push   $0x0
  pushl $151
  1027e4:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  1027e9:	e9 e0 04 00 00       	jmp    102cce <__alltraps>

001027ee <vector152>:
.globl vector152
vector152:
  pushl $0
  1027ee:	6a 00                	push   $0x0
  pushl $152
  1027f0:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  1027f5:	e9 d4 04 00 00       	jmp    102cce <__alltraps>

001027fa <vector153>:
.globl vector153
vector153:
  pushl $0
  1027fa:	6a 00                	push   $0x0
  pushl $153
  1027fc:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102801:	e9 c8 04 00 00       	jmp    102cce <__alltraps>

00102806 <vector154>:
.globl vector154
vector154:
  pushl $0
  102806:	6a 00                	push   $0x0
  pushl $154
  102808:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  10280d:	e9 bc 04 00 00       	jmp    102cce <__alltraps>

00102812 <vector155>:
.globl vector155
vector155:
  pushl $0
  102812:	6a 00                	push   $0x0
  pushl $155
  102814:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  102819:	e9 b0 04 00 00       	jmp    102cce <__alltraps>

0010281e <vector156>:
.globl vector156
vector156:
  pushl $0
  10281e:	6a 00                	push   $0x0
  pushl $156
  102820:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102825:	e9 a4 04 00 00       	jmp    102cce <__alltraps>

0010282a <vector157>:
.globl vector157
vector157:
  pushl $0
  10282a:	6a 00                	push   $0x0
  pushl $157
  10282c:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102831:	e9 98 04 00 00       	jmp    102cce <__alltraps>

00102836 <vector158>:
.globl vector158
vector158:
  pushl $0
  102836:	6a 00                	push   $0x0
  pushl $158
  102838:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  10283d:	e9 8c 04 00 00       	jmp    102cce <__alltraps>

00102842 <vector159>:
.globl vector159
vector159:
  pushl $0
  102842:	6a 00                	push   $0x0
  pushl $159
  102844:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  102849:	e9 80 04 00 00       	jmp    102cce <__alltraps>

0010284e <vector160>:
.globl vector160
vector160:
  pushl $0
  10284e:	6a 00                	push   $0x0
  pushl $160
  102850:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  102855:	e9 74 04 00 00       	jmp    102cce <__alltraps>

0010285a <vector161>:
.globl vector161
vector161:
  pushl $0
  10285a:	6a 00                	push   $0x0
  pushl $161
  10285c:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  102861:	e9 68 04 00 00       	jmp    102cce <__alltraps>

00102866 <vector162>:
.globl vector162
vector162:
  pushl $0
  102866:	6a 00                	push   $0x0
  pushl $162
  102868:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  10286d:	e9 5c 04 00 00       	jmp    102cce <__alltraps>

00102872 <vector163>:
.globl vector163
vector163:
  pushl $0
  102872:	6a 00                	push   $0x0
  pushl $163
  102874:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  102879:	e9 50 04 00 00       	jmp    102cce <__alltraps>

0010287e <vector164>:
.globl vector164
vector164:
  pushl $0
  10287e:	6a 00                	push   $0x0
  pushl $164
  102880:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  102885:	e9 44 04 00 00       	jmp    102cce <__alltraps>

0010288a <vector165>:
.globl vector165
vector165:
  pushl $0
  10288a:	6a 00                	push   $0x0
  pushl $165
  10288c:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  102891:	e9 38 04 00 00       	jmp    102cce <__alltraps>

00102896 <vector166>:
.globl vector166
vector166:
  pushl $0
  102896:	6a 00                	push   $0x0
  pushl $166
  102898:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  10289d:	e9 2c 04 00 00       	jmp    102cce <__alltraps>

001028a2 <vector167>:
.globl vector167
vector167:
  pushl $0
  1028a2:	6a 00                	push   $0x0
  pushl $167
  1028a4:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  1028a9:	e9 20 04 00 00       	jmp    102cce <__alltraps>

001028ae <vector168>:
.globl vector168
vector168:
  pushl $0
  1028ae:	6a 00                	push   $0x0
  pushl $168
  1028b0:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  1028b5:	e9 14 04 00 00       	jmp    102cce <__alltraps>

001028ba <vector169>:
.globl vector169
vector169:
  pushl $0
  1028ba:	6a 00                	push   $0x0
  pushl $169
  1028bc:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  1028c1:	e9 08 04 00 00       	jmp    102cce <__alltraps>

001028c6 <vector170>:
.globl vector170
vector170:
  pushl $0
  1028c6:	6a 00                	push   $0x0
  pushl $170
  1028c8:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  1028cd:	e9 fc 03 00 00       	jmp    102cce <__alltraps>

001028d2 <vector171>:
.globl vector171
vector171:
  pushl $0
  1028d2:	6a 00                	push   $0x0
  pushl $171
  1028d4:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  1028d9:	e9 f0 03 00 00       	jmp    102cce <__alltraps>

001028de <vector172>:
.globl vector172
vector172:
  pushl $0
  1028de:	6a 00                	push   $0x0
  pushl $172
  1028e0:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  1028e5:	e9 e4 03 00 00       	jmp    102cce <__alltraps>

001028ea <vector173>:
.globl vector173
vector173:
  pushl $0
  1028ea:	6a 00                	push   $0x0
  pushl $173
  1028ec:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  1028f1:	e9 d8 03 00 00       	jmp    102cce <__alltraps>

001028f6 <vector174>:
.globl vector174
vector174:
  pushl $0
  1028f6:	6a 00                	push   $0x0
  pushl $174
  1028f8:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  1028fd:	e9 cc 03 00 00       	jmp    102cce <__alltraps>

00102902 <vector175>:
.globl vector175
vector175:
  pushl $0
  102902:	6a 00                	push   $0x0
  pushl $175
  102904:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102909:	e9 c0 03 00 00       	jmp    102cce <__alltraps>

0010290e <vector176>:
.globl vector176
vector176:
  pushl $0
  10290e:	6a 00                	push   $0x0
  pushl $176
  102910:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102915:	e9 b4 03 00 00       	jmp    102cce <__alltraps>

0010291a <vector177>:
.globl vector177
vector177:
  pushl $0
  10291a:	6a 00                	push   $0x0
  pushl $177
  10291c:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102921:	e9 a8 03 00 00       	jmp    102cce <__alltraps>

00102926 <vector178>:
.globl vector178
vector178:
  pushl $0
  102926:	6a 00                	push   $0x0
  pushl $178
  102928:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  10292d:	e9 9c 03 00 00       	jmp    102cce <__alltraps>

00102932 <vector179>:
.globl vector179
vector179:
  pushl $0
  102932:	6a 00                	push   $0x0
  pushl $179
  102934:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102939:	e9 90 03 00 00       	jmp    102cce <__alltraps>

0010293e <vector180>:
.globl vector180
vector180:
  pushl $0
  10293e:	6a 00                	push   $0x0
  pushl $180
  102940:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  102945:	e9 84 03 00 00       	jmp    102cce <__alltraps>

0010294a <vector181>:
.globl vector181
vector181:
  pushl $0
  10294a:	6a 00                	push   $0x0
  pushl $181
  10294c:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  102951:	e9 78 03 00 00       	jmp    102cce <__alltraps>

00102956 <vector182>:
.globl vector182
vector182:
  pushl $0
  102956:	6a 00                	push   $0x0
  pushl $182
  102958:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  10295d:	e9 6c 03 00 00       	jmp    102cce <__alltraps>

00102962 <vector183>:
.globl vector183
vector183:
  pushl $0
  102962:	6a 00                	push   $0x0
  pushl $183
  102964:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102969:	e9 60 03 00 00       	jmp    102cce <__alltraps>

0010296e <vector184>:
.globl vector184
vector184:
  pushl $0
  10296e:	6a 00                	push   $0x0
  pushl $184
  102970:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  102975:	e9 54 03 00 00       	jmp    102cce <__alltraps>

0010297a <vector185>:
.globl vector185
vector185:
  pushl $0
  10297a:	6a 00                	push   $0x0
  pushl $185
  10297c:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102981:	e9 48 03 00 00       	jmp    102cce <__alltraps>

00102986 <vector186>:
.globl vector186
vector186:
  pushl $0
  102986:	6a 00                	push   $0x0
  pushl $186
  102988:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  10298d:	e9 3c 03 00 00       	jmp    102cce <__alltraps>

00102992 <vector187>:
.globl vector187
vector187:
  pushl $0
  102992:	6a 00                	push   $0x0
  pushl $187
  102994:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  102999:	e9 30 03 00 00       	jmp    102cce <__alltraps>

0010299e <vector188>:
.globl vector188
vector188:
  pushl $0
  10299e:	6a 00                	push   $0x0
  pushl $188
  1029a0:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  1029a5:	e9 24 03 00 00       	jmp    102cce <__alltraps>

001029aa <vector189>:
.globl vector189
vector189:
  pushl $0
  1029aa:	6a 00                	push   $0x0
  pushl $189
  1029ac:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  1029b1:	e9 18 03 00 00       	jmp    102cce <__alltraps>

001029b6 <vector190>:
.globl vector190
vector190:
  pushl $0
  1029b6:	6a 00                	push   $0x0
  pushl $190
  1029b8:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  1029bd:	e9 0c 03 00 00       	jmp    102cce <__alltraps>

001029c2 <vector191>:
.globl vector191
vector191:
  pushl $0
  1029c2:	6a 00                	push   $0x0
  pushl $191
  1029c4:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  1029c9:	e9 00 03 00 00       	jmp    102cce <__alltraps>

001029ce <vector192>:
.globl vector192
vector192:
  pushl $0
  1029ce:	6a 00                	push   $0x0
  pushl $192
  1029d0:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  1029d5:	e9 f4 02 00 00       	jmp    102cce <__alltraps>

001029da <vector193>:
.globl vector193
vector193:
  pushl $0
  1029da:	6a 00                	push   $0x0
  pushl $193
  1029dc:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  1029e1:	e9 e8 02 00 00       	jmp    102cce <__alltraps>

001029e6 <vector194>:
.globl vector194
vector194:
  pushl $0
  1029e6:	6a 00                	push   $0x0
  pushl $194
  1029e8:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  1029ed:	e9 dc 02 00 00       	jmp    102cce <__alltraps>

001029f2 <vector195>:
.globl vector195
vector195:
  pushl $0
  1029f2:	6a 00                	push   $0x0
  pushl $195
  1029f4:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  1029f9:	e9 d0 02 00 00       	jmp    102cce <__alltraps>

001029fe <vector196>:
.globl vector196
vector196:
  pushl $0
  1029fe:	6a 00                	push   $0x0
  pushl $196
  102a00:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102a05:	e9 c4 02 00 00       	jmp    102cce <__alltraps>

00102a0a <vector197>:
.globl vector197
vector197:
  pushl $0
  102a0a:	6a 00                	push   $0x0
  pushl $197
  102a0c:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102a11:	e9 b8 02 00 00       	jmp    102cce <__alltraps>

00102a16 <vector198>:
.globl vector198
vector198:
  pushl $0
  102a16:	6a 00                	push   $0x0
  pushl $198
  102a18:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102a1d:	e9 ac 02 00 00       	jmp    102cce <__alltraps>

00102a22 <vector199>:
.globl vector199
vector199:
  pushl $0
  102a22:	6a 00                	push   $0x0
  pushl $199
  102a24:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102a29:	e9 a0 02 00 00       	jmp    102cce <__alltraps>

00102a2e <vector200>:
.globl vector200
vector200:
  pushl $0
  102a2e:	6a 00                	push   $0x0
  pushl $200
  102a30:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102a35:	e9 94 02 00 00       	jmp    102cce <__alltraps>

00102a3a <vector201>:
.globl vector201
vector201:
  pushl $0
  102a3a:	6a 00                	push   $0x0
  pushl $201
  102a3c:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102a41:	e9 88 02 00 00       	jmp    102cce <__alltraps>

00102a46 <vector202>:
.globl vector202
vector202:
  pushl $0
  102a46:	6a 00                	push   $0x0
  pushl $202
  102a48:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102a4d:	e9 7c 02 00 00       	jmp    102cce <__alltraps>

00102a52 <vector203>:
.globl vector203
vector203:
  pushl $0
  102a52:	6a 00                	push   $0x0
  pushl $203
  102a54:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102a59:	e9 70 02 00 00       	jmp    102cce <__alltraps>

00102a5e <vector204>:
.globl vector204
vector204:
  pushl $0
  102a5e:	6a 00                	push   $0x0
  pushl $204
  102a60:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  102a65:	e9 64 02 00 00       	jmp    102cce <__alltraps>

00102a6a <vector205>:
.globl vector205
vector205:
  pushl $0
  102a6a:	6a 00                	push   $0x0
  pushl $205
  102a6c:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102a71:	e9 58 02 00 00       	jmp    102cce <__alltraps>

00102a76 <vector206>:
.globl vector206
vector206:
  pushl $0
  102a76:	6a 00                	push   $0x0
  pushl $206
  102a78:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102a7d:	e9 4c 02 00 00       	jmp    102cce <__alltraps>

00102a82 <vector207>:
.globl vector207
vector207:
  pushl $0
  102a82:	6a 00                	push   $0x0
  pushl $207
  102a84:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102a89:	e9 40 02 00 00       	jmp    102cce <__alltraps>

00102a8e <vector208>:
.globl vector208
vector208:
  pushl $0
  102a8e:	6a 00                	push   $0x0
  pushl $208
  102a90:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102a95:	e9 34 02 00 00       	jmp    102cce <__alltraps>

00102a9a <vector209>:
.globl vector209
vector209:
  pushl $0
  102a9a:	6a 00                	push   $0x0
  pushl $209
  102a9c:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102aa1:	e9 28 02 00 00       	jmp    102cce <__alltraps>

00102aa6 <vector210>:
.globl vector210
vector210:
  pushl $0
  102aa6:	6a 00                	push   $0x0
  pushl $210
  102aa8:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102aad:	e9 1c 02 00 00       	jmp    102cce <__alltraps>

00102ab2 <vector211>:
.globl vector211
vector211:
  pushl $0
  102ab2:	6a 00                	push   $0x0
  pushl $211
  102ab4:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102ab9:	e9 10 02 00 00       	jmp    102cce <__alltraps>

00102abe <vector212>:
.globl vector212
vector212:
  pushl $0
  102abe:	6a 00                	push   $0x0
  pushl $212
  102ac0:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102ac5:	e9 04 02 00 00       	jmp    102cce <__alltraps>

00102aca <vector213>:
.globl vector213
vector213:
  pushl $0
  102aca:	6a 00                	push   $0x0
  pushl $213
  102acc:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102ad1:	e9 f8 01 00 00       	jmp    102cce <__alltraps>

00102ad6 <vector214>:
.globl vector214
vector214:
  pushl $0
  102ad6:	6a 00                	push   $0x0
  pushl $214
  102ad8:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102add:	e9 ec 01 00 00       	jmp    102cce <__alltraps>

00102ae2 <vector215>:
.globl vector215
vector215:
  pushl $0
  102ae2:	6a 00                	push   $0x0
  pushl $215
  102ae4:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102ae9:	e9 e0 01 00 00       	jmp    102cce <__alltraps>

00102aee <vector216>:
.globl vector216
vector216:
  pushl $0
  102aee:	6a 00                	push   $0x0
  pushl $216
  102af0:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102af5:	e9 d4 01 00 00       	jmp    102cce <__alltraps>

00102afa <vector217>:
.globl vector217
vector217:
  pushl $0
  102afa:	6a 00                	push   $0x0
  pushl $217
  102afc:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102b01:	e9 c8 01 00 00       	jmp    102cce <__alltraps>

00102b06 <vector218>:
.globl vector218
vector218:
  pushl $0
  102b06:	6a 00                	push   $0x0
  pushl $218
  102b08:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102b0d:	e9 bc 01 00 00       	jmp    102cce <__alltraps>

00102b12 <vector219>:
.globl vector219
vector219:
  pushl $0
  102b12:	6a 00                	push   $0x0
  pushl $219
  102b14:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102b19:	e9 b0 01 00 00       	jmp    102cce <__alltraps>

00102b1e <vector220>:
.globl vector220
vector220:
  pushl $0
  102b1e:	6a 00                	push   $0x0
  pushl $220
  102b20:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102b25:	e9 a4 01 00 00       	jmp    102cce <__alltraps>

00102b2a <vector221>:
.globl vector221
vector221:
  pushl $0
  102b2a:	6a 00                	push   $0x0
  pushl $221
  102b2c:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102b31:	e9 98 01 00 00       	jmp    102cce <__alltraps>

00102b36 <vector222>:
.globl vector222
vector222:
  pushl $0
  102b36:	6a 00                	push   $0x0
  pushl $222
  102b38:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102b3d:	e9 8c 01 00 00       	jmp    102cce <__alltraps>

00102b42 <vector223>:
.globl vector223
vector223:
  pushl $0
  102b42:	6a 00                	push   $0x0
  pushl $223
  102b44:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102b49:	e9 80 01 00 00       	jmp    102cce <__alltraps>

00102b4e <vector224>:
.globl vector224
vector224:
  pushl $0
  102b4e:	6a 00                	push   $0x0
  pushl $224
  102b50:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102b55:	e9 74 01 00 00       	jmp    102cce <__alltraps>

00102b5a <vector225>:
.globl vector225
vector225:
  pushl $0
  102b5a:	6a 00                	push   $0x0
  pushl $225
  102b5c:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  102b61:	e9 68 01 00 00       	jmp    102cce <__alltraps>

00102b66 <vector226>:
.globl vector226
vector226:
  pushl $0
  102b66:	6a 00                	push   $0x0
  pushl $226
  102b68:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102b6d:	e9 5c 01 00 00       	jmp    102cce <__alltraps>

00102b72 <vector227>:
.globl vector227
vector227:
  pushl $0
  102b72:	6a 00                	push   $0x0
  pushl $227
  102b74:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102b79:	e9 50 01 00 00       	jmp    102cce <__alltraps>

00102b7e <vector228>:
.globl vector228
vector228:
  pushl $0
  102b7e:	6a 00                	push   $0x0
  pushl $228
  102b80:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102b85:	e9 44 01 00 00       	jmp    102cce <__alltraps>

00102b8a <vector229>:
.globl vector229
vector229:
  pushl $0
  102b8a:	6a 00                	push   $0x0
  pushl $229
  102b8c:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102b91:	e9 38 01 00 00       	jmp    102cce <__alltraps>

00102b96 <vector230>:
.globl vector230
vector230:
  pushl $0
  102b96:	6a 00                	push   $0x0
  pushl $230
  102b98:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102b9d:	e9 2c 01 00 00       	jmp    102cce <__alltraps>

00102ba2 <vector231>:
.globl vector231
vector231:
  pushl $0
  102ba2:	6a 00                	push   $0x0
  pushl $231
  102ba4:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102ba9:	e9 20 01 00 00       	jmp    102cce <__alltraps>

00102bae <vector232>:
.globl vector232
vector232:
  pushl $0
  102bae:	6a 00                	push   $0x0
  pushl $232
  102bb0:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102bb5:	e9 14 01 00 00       	jmp    102cce <__alltraps>

00102bba <vector233>:
.globl vector233
vector233:
  pushl $0
  102bba:	6a 00                	push   $0x0
  pushl $233
  102bbc:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102bc1:	e9 08 01 00 00       	jmp    102cce <__alltraps>

00102bc6 <vector234>:
.globl vector234
vector234:
  pushl $0
  102bc6:	6a 00                	push   $0x0
  pushl $234
  102bc8:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102bcd:	e9 fc 00 00 00       	jmp    102cce <__alltraps>

00102bd2 <vector235>:
.globl vector235
vector235:
  pushl $0
  102bd2:	6a 00                	push   $0x0
  pushl $235
  102bd4:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102bd9:	e9 f0 00 00 00       	jmp    102cce <__alltraps>

00102bde <vector236>:
.globl vector236
vector236:
  pushl $0
  102bde:	6a 00                	push   $0x0
  pushl $236
  102be0:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102be5:	e9 e4 00 00 00       	jmp    102cce <__alltraps>

00102bea <vector237>:
.globl vector237
vector237:
  pushl $0
  102bea:	6a 00                	push   $0x0
  pushl $237
  102bec:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102bf1:	e9 d8 00 00 00       	jmp    102cce <__alltraps>

00102bf6 <vector238>:
.globl vector238
vector238:
  pushl $0
  102bf6:	6a 00                	push   $0x0
  pushl $238
  102bf8:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102bfd:	e9 cc 00 00 00       	jmp    102cce <__alltraps>

00102c02 <vector239>:
.globl vector239
vector239:
  pushl $0
  102c02:	6a 00                	push   $0x0
  pushl $239
  102c04:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102c09:	e9 c0 00 00 00       	jmp    102cce <__alltraps>

00102c0e <vector240>:
.globl vector240
vector240:
  pushl $0
  102c0e:	6a 00                	push   $0x0
  pushl $240
  102c10:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102c15:	e9 b4 00 00 00       	jmp    102cce <__alltraps>

00102c1a <vector241>:
.globl vector241
vector241:
  pushl $0
  102c1a:	6a 00                	push   $0x0
  pushl $241
  102c1c:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102c21:	e9 a8 00 00 00       	jmp    102cce <__alltraps>

00102c26 <vector242>:
.globl vector242
vector242:
  pushl $0
  102c26:	6a 00                	push   $0x0
  pushl $242
  102c28:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102c2d:	e9 9c 00 00 00       	jmp    102cce <__alltraps>

00102c32 <vector243>:
.globl vector243
vector243:
  pushl $0
  102c32:	6a 00                	push   $0x0
  pushl $243
  102c34:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102c39:	e9 90 00 00 00       	jmp    102cce <__alltraps>

00102c3e <vector244>:
.globl vector244
vector244:
  pushl $0
  102c3e:	6a 00                	push   $0x0
  pushl $244
  102c40:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102c45:	e9 84 00 00 00       	jmp    102cce <__alltraps>

00102c4a <vector245>:
.globl vector245
vector245:
  pushl $0
  102c4a:	6a 00                	push   $0x0
  pushl $245
  102c4c:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102c51:	e9 78 00 00 00       	jmp    102cce <__alltraps>

00102c56 <vector246>:
.globl vector246
vector246:
  pushl $0
  102c56:	6a 00                	push   $0x0
  pushl $246
  102c58:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102c5d:	e9 6c 00 00 00       	jmp    102cce <__alltraps>

00102c62 <vector247>:
.globl vector247
vector247:
  pushl $0
  102c62:	6a 00                	push   $0x0
  pushl $247
  102c64:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102c69:	e9 60 00 00 00       	jmp    102cce <__alltraps>

00102c6e <vector248>:
.globl vector248
vector248:
  pushl $0
  102c6e:	6a 00                	push   $0x0
  pushl $248
  102c70:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102c75:	e9 54 00 00 00       	jmp    102cce <__alltraps>

00102c7a <vector249>:
.globl vector249
vector249:
  pushl $0
  102c7a:	6a 00                	push   $0x0
  pushl $249
  102c7c:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102c81:	e9 48 00 00 00       	jmp    102cce <__alltraps>

00102c86 <vector250>:
.globl vector250
vector250:
  pushl $0
  102c86:	6a 00                	push   $0x0
  pushl $250
  102c88:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102c8d:	e9 3c 00 00 00       	jmp    102cce <__alltraps>

00102c92 <vector251>:
.globl vector251
vector251:
  pushl $0
  102c92:	6a 00                	push   $0x0
  pushl $251
  102c94:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102c99:	e9 30 00 00 00       	jmp    102cce <__alltraps>

00102c9e <vector252>:
.globl vector252
vector252:
  pushl $0
  102c9e:	6a 00                	push   $0x0
  pushl $252
  102ca0:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102ca5:	e9 24 00 00 00       	jmp    102cce <__alltraps>

00102caa <vector253>:
.globl vector253
vector253:
  pushl $0
  102caa:	6a 00                	push   $0x0
  pushl $253
  102cac:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102cb1:	e9 18 00 00 00       	jmp    102cce <__alltraps>

00102cb6 <vector254>:
.globl vector254
vector254:
  pushl $0
  102cb6:	6a 00                	push   $0x0
  pushl $254
  102cb8:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102cbd:	e9 0c 00 00 00       	jmp    102cce <__alltraps>

00102cc2 <vector255>:
.globl vector255
vector255:
  pushl $0
  102cc2:	6a 00                	push   $0x0
  pushl $255
  102cc4:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102cc9:	e9 00 00 00 00       	jmp    102cce <__alltraps>

00102cce <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  102cce:	1e                   	push   %ds
    pushl %es
  102ccf:	06                   	push   %es
    pushl %fs
  102cd0:	0f a0                	push   %fs
    pushl %gs
  102cd2:	0f a8                	push   %gs
    pushal
  102cd4:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  102cd5:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  102cda:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  102cdc:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  102cde:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  102cdf:	e8 64 f5 ff ff       	call   102248 <trap>

    # pop the pushed stack pointer
    popl %esp
  102ce4:	5c                   	pop    %esp

00102ce5 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  102ce5:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  102ce6:	0f a9                	pop    %gs
    popl %fs
  102ce8:	0f a1                	pop    %fs
    popl %es
  102cea:	07                   	pop    %es
    popl %ds
  102ceb:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  102cec:	83 c4 08             	add    $0x8,%esp
    iret
  102cef:	cf                   	iret   

00102cf0 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  102cf0:	55                   	push   %ebp
  102cf1:	89 e5                	mov    %esp,%ebp
    return page - pages;
  102cf3:	a1 38 cf 11 00       	mov    0x11cf38,%eax
  102cf8:	8b 55 08             	mov    0x8(%ebp),%edx
  102cfb:	29 c2                	sub    %eax,%edx
  102cfd:	89 d0                	mov    %edx,%eax
  102cff:	c1 f8 02             	sar    $0x2,%eax
  102d02:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  102d08:	5d                   	pop    %ebp
  102d09:	c3                   	ret    

00102d0a <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  102d0a:	55                   	push   %ebp
  102d0b:	89 e5                	mov    %esp,%ebp
  102d0d:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  102d10:	8b 45 08             	mov    0x8(%ebp),%eax
  102d13:	89 04 24             	mov    %eax,(%esp)
  102d16:	e8 d5 ff ff ff       	call   102cf0 <page2ppn>
  102d1b:	c1 e0 0c             	shl    $0xc,%eax
}
  102d1e:	c9                   	leave  
  102d1f:	c3                   	ret    

00102d20 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  102d20:	55                   	push   %ebp
  102d21:	89 e5                	mov    %esp,%ebp
  102d23:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  102d26:	8b 45 08             	mov    0x8(%ebp),%eax
  102d29:	c1 e8 0c             	shr    $0xc,%eax
  102d2c:	89 c2                	mov    %eax,%edx
  102d2e:	a1 a0 ce 11 00       	mov    0x11cea0,%eax
  102d33:	39 c2                	cmp    %eax,%edx
  102d35:	72 1c                	jb     102d53 <pa2page+0x33>
        panic("pa2page called with invalid pa");
  102d37:	c7 44 24 08 30 6b 10 	movl   $0x106b30,0x8(%esp)
  102d3e:	00 
  102d3f:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  102d46:	00 
  102d47:	c7 04 24 4f 6b 10 00 	movl   $0x106b4f,(%esp)
  102d4e:	e8 9f d6 ff ff       	call   1003f2 <__panic>
    }
    return &pages[PPN(pa)];
  102d53:	8b 0d 38 cf 11 00    	mov    0x11cf38,%ecx
  102d59:	8b 45 08             	mov    0x8(%ebp),%eax
  102d5c:	c1 e8 0c             	shr    $0xc,%eax
  102d5f:	89 c2                	mov    %eax,%edx
  102d61:	89 d0                	mov    %edx,%eax
  102d63:	c1 e0 02             	shl    $0x2,%eax
  102d66:	01 d0                	add    %edx,%eax
  102d68:	c1 e0 02             	shl    $0x2,%eax
  102d6b:	01 c8                	add    %ecx,%eax
}
  102d6d:	c9                   	leave  
  102d6e:	c3                   	ret    

00102d6f <page2kva>:

static inline void *
page2kva(struct Page *page) {
  102d6f:	55                   	push   %ebp
  102d70:	89 e5                	mov    %esp,%ebp
  102d72:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  102d75:	8b 45 08             	mov    0x8(%ebp),%eax
  102d78:	89 04 24             	mov    %eax,(%esp)
  102d7b:	e8 8a ff ff ff       	call   102d0a <page2pa>
  102d80:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102d83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d86:	c1 e8 0c             	shr    $0xc,%eax
  102d89:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102d8c:	a1 a0 ce 11 00       	mov    0x11cea0,%eax
  102d91:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  102d94:	72 23                	jb     102db9 <page2kva+0x4a>
  102d96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d99:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102d9d:	c7 44 24 08 60 6b 10 	movl   $0x106b60,0x8(%esp)
  102da4:	00 
  102da5:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  102dac:	00 
  102dad:	c7 04 24 4f 6b 10 00 	movl   $0x106b4f,(%esp)
  102db4:	e8 39 d6 ff ff       	call   1003f2 <__panic>
  102db9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102dbc:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  102dc1:	c9                   	leave  
  102dc2:	c3                   	ret    

00102dc3 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  102dc3:	55                   	push   %ebp
  102dc4:	89 e5                	mov    %esp,%ebp
  102dc6:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  102dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  102dcc:	83 e0 01             	and    $0x1,%eax
  102dcf:	85 c0                	test   %eax,%eax
  102dd1:	75 1c                	jne    102def <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  102dd3:	c7 44 24 08 84 6b 10 	movl   $0x106b84,0x8(%esp)
  102dda:	00 
  102ddb:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  102de2:	00 
  102de3:	c7 04 24 4f 6b 10 00 	movl   $0x106b4f,(%esp)
  102dea:	e8 03 d6 ff ff       	call   1003f2 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  102def:	8b 45 08             	mov    0x8(%ebp),%eax
  102df2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  102df7:	89 04 24             	mov    %eax,(%esp)
  102dfa:	e8 21 ff ff ff       	call   102d20 <pa2page>
}
  102dff:	c9                   	leave  
  102e00:	c3                   	ret    

00102e01 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
  102e01:	55                   	push   %ebp
  102e02:	89 e5                	mov    %esp,%ebp
  102e04:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
  102e07:	8b 45 08             	mov    0x8(%ebp),%eax
  102e0a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  102e0f:	89 04 24             	mov    %eax,(%esp)
  102e12:	e8 09 ff ff ff       	call   102d20 <pa2page>
}
  102e17:	c9                   	leave  
  102e18:	c3                   	ret    

00102e19 <page_ref>:

static inline int
page_ref(struct Page *page) {
  102e19:	55                   	push   %ebp
  102e1a:	89 e5                	mov    %esp,%ebp
    return page->ref;
  102e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  102e1f:	8b 00                	mov    (%eax),%eax
}
  102e21:	5d                   	pop    %ebp
  102e22:	c3                   	ret    

00102e23 <page_ref_inc>:
set_page_ref(struct Page *page, int val) {
    page->ref = val;
}

static inline int
page_ref_inc(struct Page *page) {
  102e23:	55                   	push   %ebp
  102e24:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  102e26:	8b 45 08             	mov    0x8(%ebp),%eax
  102e29:	8b 00                	mov    (%eax),%eax
  102e2b:	8d 50 01             	lea    0x1(%eax),%edx
  102e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  102e31:	89 10                	mov    %edx,(%eax)
    return page->ref;
  102e33:	8b 45 08             	mov    0x8(%ebp),%eax
  102e36:	8b 00                	mov    (%eax),%eax
}
  102e38:	5d                   	pop    %ebp
  102e39:	c3                   	ret    

00102e3a <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  102e3a:	55                   	push   %ebp
  102e3b:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  102e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  102e40:	8b 00                	mov    (%eax),%eax
  102e42:	8d 50 ff             	lea    -0x1(%eax),%edx
  102e45:	8b 45 08             	mov    0x8(%ebp),%eax
  102e48:	89 10                	mov    %edx,(%eax)
    return page->ref;
  102e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  102e4d:	8b 00                	mov    (%eax),%eax
}
  102e4f:	5d                   	pop    %ebp
  102e50:	c3                   	ret    

00102e51 <__intr_save>:
__intr_save(void) {
  102e51:	55                   	push   %ebp
  102e52:	89 e5                	mov    %esp,%ebp
  102e54:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  102e57:	9c                   	pushf  
  102e58:	58                   	pop    %eax
  102e59:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  102e5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  102e5f:	25 00 02 00 00       	and    $0x200,%eax
  102e64:	85 c0                	test   %eax,%eax
  102e66:	74 0c                	je     102e74 <__intr_save+0x23>
        intr_disable();
  102e68:	e8 2a ea ff ff       	call   101897 <intr_disable>
        return 1;
  102e6d:	b8 01 00 00 00       	mov    $0x1,%eax
  102e72:	eb 05                	jmp    102e79 <__intr_save+0x28>
    return 0;
  102e74:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102e79:	c9                   	leave  
  102e7a:	c3                   	ret    

00102e7b <__intr_restore>:
__intr_restore(bool flag) {
  102e7b:	55                   	push   %ebp
  102e7c:	89 e5                	mov    %esp,%ebp
  102e7e:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  102e81:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102e85:	74 05                	je     102e8c <__intr_restore+0x11>
        intr_enable();
  102e87:	e8 04 ea ff ff       	call   101890 <intr_enable>
}
  102e8c:	90                   	nop
  102e8d:	c9                   	leave  
  102e8e:	c3                   	ret    

00102e8f <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102e8f:	55                   	push   %ebp
  102e90:	89 e5                	mov    %esp,%ebp
	asm volatile ("lgdt (%0)" :: "r" (pd));
  102e92:	8b 45 08             	mov    0x8(%ebp),%eax
  102e95:	0f 01 10             	lgdtl  (%eax)
	asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102e98:	b8 23 00 00 00       	mov    $0x23,%eax
  102e9d:	8e e8                	mov    %eax,%gs
	asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102e9f:	b8 23 00 00 00       	mov    $0x23,%eax
  102ea4:	8e e0                	mov    %eax,%fs
	asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102ea6:	b8 10 00 00 00       	mov    $0x10,%eax
  102eab:	8e c0                	mov    %eax,%es
	asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102ead:	b8 10 00 00 00       	mov    $0x10,%eax
  102eb2:	8e d8                	mov    %eax,%ds
	asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102eb4:	b8 10 00 00 00       	mov    $0x10,%eax
  102eb9:	8e d0                	mov    %eax,%ss
	// reload cs
	asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102ebb:	ea c2 2e 10 00 08 00 	ljmp   $0x8,$0x102ec2
}
  102ec2:	90                   	nop
  102ec3:	5d                   	pop    %ebp
  102ec4:	c3                   	ret    

00102ec5 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  102ec5:	55                   	push   %ebp
  102ec6:	89 e5                	mov    %esp,%ebp
	ts.ts_esp0 = esp0;
  102ec8:	8b 45 08             	mov    0x8(%ebp),%eax
  102ecb:	a3 c4 ce 11 00       	mov    %eax,0x11cec4
}
  102ed0:	90                   	nop
  102ed1:	5d                   	pop    %ebp
  102ed2:	c3                   	ret    

00102ed3 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102ed3:	55                   	push   %ebp
  102ed4:	89 e5                	mov    %esp,%ebp
  102ed6:	83 ec 14             	sub    $0x14,%esp
	// set boot kernel stack and default SS0
	load_esp0((uintptr_t)bootstacktop);
  102ed9:	b8 00 90 11 00       	mov    $0x119000,%eax
  102ede:	89 04 24             	mov    %eax,(%esp)
  102ee1:	e8 df ff ff ff       	call   102ec5 <load_esp0>
	ts.ts_ss0 = KERNEL_DS;
  102ee6:	66 c7 05 c8 ce 11 00 	movw   $0x10,0x11cec8
  102eed:	10 00 

	// initialize the TSS filed of the gdt
	gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  102eef:	66 c7 05 28 9a 11 00 	movw   $0x68,0x119a28
  102ef6:	68 00 
  102ef8:	b8 c0 ce 11 00       	mov    $0x11cec0,%eax
  102efd:	0f b7 c0             	movzwl %ax,%eax
  102f00:	66 a3 2a 9a 11 00    	mov    %ax,0x119a2a
  102f06:	b8 c0 ce 11 00       	mov    $0x11cec0,%eax
  102f0b:	c1 e8 10             	shr    $0x10,%eax
  102f0e:	a2 2c 9a 11 00       	mov    %al,0x119a2c
  102f13:	0f b6 05 2d 9a 11 00 	movzbl 0x119a2d,%eax
  102f1a:	24 f0                	and    $0xf0,%al
  102f1c:	0c 09                	or     $0x9,%al
  102f1e:	a2 2d 9a 11 00       	mov    %al,0x119a2d
  102f23:	0f b6 05 2d 9a 11 00 	movzbl 0x119a2d,%eax
  102f2a:	24 ef                	and    $0xef,%al
  102f2c:	a2 2d 9a 11 00       	mov    %al,0x119a2d
  102f31:	0f b6 05 2d 9a 11 00 	movzbl 0x119a2d,%eax
  102f38:	24 9f                	and    $0x9f,%al
  102f3a:	a2 2d 9a 11 00       	mov    %al,0x119a2d
  102f3f:	0f b6 05 2d 9a 11 00 	movzbl 0x119a2d,%eax
  102f46:	0c 80                	or     $0x80,%al
  102f48:	a2 2d 9a 11 00       	mov    %al,0x119a2d
  102f4d:	0f b6 05 2e 9a 11 00 	movzbl 0x119a2e,%eax
  102f54:	24 f0                	and    $0xf0,%al
  102f56:	a2 2e 9a 11 00       	mov    %al,0x119a2e
  102f5b:	0f b6 05 2e 9a 11 00 	movzbl 0x119a2e,%eax
  102f62:	24 ef                	and    $0xef,%al
  102f64:	a2 2e 9a 11 00       	mov    %al,0x119a2e
  102f69:	0f b6 05 2e 9a 11 00 	movzbl 0x119a2e,%eax
  102f70:	24 df                	and    $0xdf,%al
  102f72:	a2 2e 9a 11 00       	mov    %al,0x119a2e
  102f77:	0f b6 05 2e 9a 11 00 	movzbl 0x119a2e,%eax
  102f7e:	0c 40                	or     $0x40,%al
  102f80:	a2 2e 9a 11 00       	mov    %al,0x119a2e
  102f85:	0f b6 05 2e 9a 11 00 	movzbl 0x119a2e,%eax
  102f8c:	24 7f                	and    $0x7f,%al
  102f8e:	a2 2e 9a 11 00       	mov    %al,0x119a2e
  102f93:	b8 c0 ce 11 00       	mov    $0x11cec0,%eax
  102f98:	c1 e8 18             	shr    $0x18,%eax
  102f9b:	a2 2f 9a 11 00       	mov    %al,0x119a2f

	// reload all segment registers
	lgdt(&gdt_pd);
  102fa0:	c7 04 24 30 9a 11 00 	movl   $0x119a30,(%esp)
  102fa7:	e8 e3 fe ff ff       	call   102e8f <lgdt>
  102fac:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  102fb2:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102fb6:	0f 00 d8             	ltr    %ax

	// load the TSS
	ltr(GD_TSS);
}
  102fb9:	90                   	nop
  102fba:	c9                   	leave  
  102fbb:	c3                   	ret    

00102fbc <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  102fbc:	55                   	push   %ebp
  102fbd:	89 e5                	mov    %esp,%ebp
  102fbf:	83 ec 18             	sub    $0x18,%esp
	pmm_manager = &default_pmm_manager;
  102fc2:	c7 05 30 cf 11 00 00 	movl   $0x107600,0x11cf30
  102fc9:	76 10 00 
	cprintf("memory management: %s\n", pmm_manager->name);
  102fcc:	a1 30 cf 11 00       	mov    0x11cf30,%eax
  102fd1:	8b 00                	mov    (%eax),%eax
  102fd3:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fd7:	c7 04 24 b0 6b 10 00 	movl   $0x106bb0,(%esp)
  102fde:	e8 b7 d2 ff ff       	call   10029a <cprintf>
	pmm_manager->init();
  102fe3:	a1 30 cf 11 00       	mov    0x11cf30,%eax
  102fe8:	8b 40 04             	mov    0x4(%eax),%eax
  102feb:	ff d0                	call   *%eax
}
  102fed:	90                   	nop
  102fee:	c9                   	leave  
  102fef:	c3                   	ret    

00102ff0 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  102ff0:	55                   	push   %ebp
  102ff1:	89 e5                	mov    %esp,%ebp
  102ff3:	83 ec 18             	sub    $0x18,%esp
	pmm_manager->init_memmap(base, n);
  102ff6:	a1 30 cf 11 00       	mov    0x11cf30,%eax
  102ffb:	8b 40 08             	mov    0x8(%eax),%eax
  102ffe:	8b 55 0c             	mov    0xc(%ebp),%edx
  103001:	89 54 24 04          	mov    %edx,0x4(%esp)
  103005:	8b 55 08             	mov    0x8(%ebp),%edx
  103008:	89 14 24             	mov    %edx,(%esp)
  10300b:	ff d0                	call   *%eax
}
  10300d:	90                   	nop
  10300e:	c9                   	leave  
  10300f:	c3                   	ret    

00103010 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  103010:	55                   	push   %ebp
  103011:	89 e5                	mov    %esp,%ebp
  103013:	83 ec 28             	sub    $0x28,%esp
	struct Page *page=NULL;
  103016:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	bool intr_flag;
	local_intr_save(intr_flag);
  10301d:	e8 2f fe ff ff       	call   102e51 <__intr_save>
  103022:	89 45 f0             	mov    %eax,-0x10(%ebp)
	{
		page = pmm_manager->alloc_pages(n);
  103025:	a1 30 cf 11 00       	mov    0x11cf30,%eax
  10302a:	8b 40 0c             	mov    0xc(%eax),%eax
  10302d:	8b 55 08             	mov    0x8(%ebp),%edx
  103030:	89 14 24             	mov    %edx,(%esp)
  103033:	ff d0                	call   *%eax
  103035:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}
	local_intr_restore(intr_flag);
  103038:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10303b:	89 04 24             	mov    %eax,(%esp)
  10303e:	e8 38 fe ff ff       	call   102e7b <__intr_restore>
	return page;
  103043:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103046:	c9                   	leave  
  103047:	c3                   	ret    

00103048 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  103048:	55                   	push   %ebp
  103049:	89 e5                	mov    %esp,%ebp
  10304b:	83 ec 28             	sub    $0x28,%esp
	bool intr_flag;
	local_intr_save(intr_flag);
  10304e:	e8 fe fd ff ff       	call   102e51 <__intr_save>
  103053:	89 45 f4             	mov    %eax,-0xc(%ebp)
	{
		pmm_manager->free_pages(base, n);
  103056:	a1 30 cf 11 00       	mov    0x11cf30,%eax
  10305b:	8b 40 10             	mov    0x10(%eax),%eax
  10305e:	8b 55 0c             	mov    0xc(%ebp),%edx
  103061:	89 54 24 04          	mov    %edx,0x4(%esp)
  103065:	8b 55 08             	mov    0x8(%ebp),%edx
  103068:	89 14 24             	mov    %edx,(%esp)
  10306b:	ff d0                	call   *%eax
	}
	local_intr_restore(intr_flag);
  10306d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103070:	89 04 24             	mov    %eax,(%esp)
  103073:	e8 03 fe ff ff       	call   102e7b <__intr_restore>
}
  103078:	90                   	nop
  103079:	c9                   	leave  
  10307a:	c3                   	ret    

0010307b <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  10307b:	55                   	push   %ebp
  10307c:	89 e5                	mov    %esp,%ebp
  10307e:	83 ec 28             	sub    $0x28,%esp
	size_t ret;
	bool intr_flag;
	local_intr_save(intr_flag);
  103081:	e8 cb fd ff ff       	call   102e51 <__intr_save>
  103086:	89 45 f4             	mov    %eax,-0xc(%ebp)
	{
		ret = pmm_manager->nr_free_pages();
  103089:	a1 30 cf 11 00       	mov    0x11cf30,%eax
  10308e:	8b 40 14             	mov    0x14(%eax),%eax
  103091:	ff d0                	call   *%eax
  103093:	89 45 f0             	mov    %eax,-0x10(%ebp)
	}
	local_intr_restore(intr_flag);
  103096:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103099:	89 04 24             	mov    %eax,(%esp)
  10309c:	e8 da fd ff ff       	call   102e7b <__intr_restore>
	return ret;
  1030a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1030a4:	c9                   	leave  
  1030a5:	c3                   	ret    

001030a6 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  1030a6:	55                   	push   %ebp
  1030a7:	89 e5                	mov    %esp,%ebp
  1030a9:	57                   	push   %edi
  1030aa:	56                   	push   %esi
  1030ab:	53                   	push   %ebx
  1030ac:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  1030b2:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
	uint64_t maxpa = 0;
  1030b9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  1030c0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

	cprintf("e820map:\n");
  1030c7:	c7 04 24 c7 6b 10 00 	movl   $0x106bc7,(%esp)
  1030ce:	e8 c7 d1 ff ff       	call   10029a <cprintf>
	int i;
	for (i = 0; i < memmap->nr_map; i ++) {
  1030d3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1030da:	e9 1a 01 00 00       	jmp    1031f9 <page_init+0x153>
		uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  1030df:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1030e2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1030e5:	89 d0                	mov    %edx,%eax
  1030e7:	c1 e0 02             	shl    $0x2,%eax
  1030ea:	01 d0                	add    %edx,%eax
  1030ec:	c1 e0 02             	shl    $0x2,%eax
  1030ef:	01 c8                	add    %ecx,%eax
  1030f1:	8b 50 08             	mov    0x8(%eax),%edx
  1030f4:	8b 40 04             	mov    0x4(%eax),%eax
  1030f7:	89 45 b8             	mov    %eax,-0x48(%ebp)
  1030fa:	89 55 bc             	mov    %edx,-0x44(%ebp)
  1030fd:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103100:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103103:	89 d0                	mov    %edx,%eax
  103105:	c1 e0 02             	shl    $0x2,%eax
  103108:	01 d0                	add    %edx,%eax
  10310a:	c1 e0 02             	shl    $0x2,%eax
  10310d:	01 c8                	add    %ecx,%eax
  10310f:	8b 48 0c             	mov    0xc(%eax),%ecx
  103112:	8b 58 10             	mov    0x10(%eax),%ebx
  103115:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103118:	8b 55 bc             	mov    -0x44(%ebp),%edx
  10311b:	01 c8                	add    %ecx,%eax
  10311d:	11 da                	adc    %ebx,%edx
  10311f:	89 45 b0             	mov    %eax,-0x50(%ebp)
  103122:	89 55 b4             	mov    %edx,-0x4c(%ebp)
		cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  103125:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103128:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10312b:	89 d0                	mov    %edx,%eax
  10312d:	c1 e0 02             	shl    $0x2,%eax
  103130:	01 d0                	add    %edx,%eax
  103132:	c1 e0 02             	shl    $0x2,%eax
  103135:	01 c8                	add    %ecx,%eax
  103137:	83 c0 14             	add    $0x14,%eax
  10313a:	8b 00                	mov    (%eax),%eax
  10313c:	89 45 84             	mov    %eax,-0x7c(%ebp)
  10313f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103142:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103145:	83 c0 ff             	add    $0xffffffff,%eax
  103148:	83 d2 ff             	adc    $0xffffffff,%edx
  10314b:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
  103151:	89 95 7c ff ff ff    	mov    %edx,-0x84(%ebp)
  103157:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10315a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10315d:	89 d0                	mov    %edx,%eax
  10315f:	c1 e0 02             	shl    $0x2,%eax
  103162:	01 d0                	add    %edx,%eax
  103164:	c1 e0 02             	shl    $0x2,%eax
  103167:	01 c8                	add    %ecx,%eax
  103169:	8b 48 0c             	mov    0xc(%eax),%ecx
  10316c:	8b 58 10             	mov    0x10(%eax),%ebx
  10316f:	8b 55 84             	mov    -0x7c(%ebp),%edx
  103172:	89 54 24 1c          	mov    %edx,0x1c(%esp)
  103176:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  10317c:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
  103182:	89 44 24 14          	mov    %eax,0x14(%esp)
  103186:	89 54 24 18          	mov    %edx,0x18(%esp)
  10318a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  10318d:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103190:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103194:	89 54 24 10          	mov    %edx,0x10(%esp)
  103198:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  10319c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  1031a0:	c7 04 24 d4 6b 10 00 	movl   $0x106bd4,(%esp)
  1031a7:	e8 ee d0 ff ff       	call   10029a <cprintf>
				memmap->map[i].size, begin, end - 1, memmap->map[i].type);
		if (memmap->map[i].type == E820_ARM) {
  1031ac:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1031af:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1031b2:	89 d0                	mov    %edx,%eax
  1031b4:	c1 e0 02             	shl    $0x2,%eax
  1031b7:	01 d0                	add    %edx,%eax
  1031b9:	c1 e0 02             	shl    $0x2,%eax
  1031bc:	01 c8                	add    %ecx,%eax
  1031be:	83 c0 14             	add    $0x14,%eax
  1031c1:	8b 00                	mov    (%eax),%eax
  1031c3:	83 f8 01             	cmp    $0x1,%eax
  1031c6:	75 2e                	jne    1031f6 <page_init+0x150>
			if (maxpa < end && begin < KMEMSIZE) {
  1031c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1031cb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1031ce:	3b 45 b0             	cmp    -0x50(%ebp),%eax
  1031d1:	89 d0                	mov    %edx,%eax
  1031d3:	1b 45 b4             	sbb    -0x4c(%ebp),%eax
  1031d6:	73 1e                	jae    1031f6 <page_init+0x150>
  1031d8:	ba ff ff ff 37       	mov    $0x37ffffff,%edx
  1031dd:	b8 00 00 00 00       	mov    $0x0,%eax
  1031e2:	3b 55 b8             	cmp    -0x48(%ebp),%edx
  1031e5:	1b 45 bc             	sbb    -0x44(%ebp),%eax
  1031e8:	72 0c                	jb     1031f6 <page_init+0x150>
				maxpa = end;
  1031ea:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1031ed:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  1031f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1031f3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	for (i = 0; i < memmap->nr_map; i ++) {
  1031f6:	ff 45 dc             	incl   -0x24(%ebp)
  1031f9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1031fc:	8b 00                	mov    (%eax),%eax
  1031fe:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  103201:	0f 8c d8 fe ff ff    	jl     1030df <page_init+0x39>
			}
		}
	}
	// 确保maxpa不大于ucore支持的最大物理内存地址
	if (maxpa > KMEMSIZE) {
  103207:	ba 00 00 00 38       	mov    $0x38000000,%edx
  10320c:	b8 00 00 00 00       	mov    $0x0,%eax
  103211:	3b 55 e0             	cmp    -0x20(%ebp),%edx
  103214:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  103217:	73 0e                	jae    103227 <page_init+0x181>
		maxpa = KMEMSIZE;
  103219:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  103220:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	}

	extern char end[];

	npage = maxpa / PGSIZE;
  103227:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10322a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10322d:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  103231:	c1 ea 0c             	shr    $0xc,%edx
  103234:	89 c1                	mov    %eax,%ecx
  103236:	89 d3                	mov    %edx,%ebx
  103238:	89 c8                	mov    %ecx,%eax
  10323a:	a3 a0 ce 11 00       	mov    %eax,0x11cea0
	// 将struct Page数组放置到.bss段之上
	pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  10323f:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  103246:	b8 48 cf 11 00       	mov    $0x11cf48,%eax
  10324b:	8d 50 ff             	lea    -0x1(%eax),%edx
  10324e:	8b 45 ac             	mov    -0x54(%ebp),%eax
  103251:	01 d0                	add    %edx,%eax
  103253:	89 45 a8             	mov    %eax,-0x58(%ebp)
  103256:	8b 45 a8             	mov    -0x58(%ebp),%eax
  103259:	ba 00 00 00 00       	mov    $0x0,%edx
  10325e:	f7 75 ac             	divl   -0x54(%ebp)
  103261:	8b 45 a8             	mov    -0x58(%ebp),%eax
  103264:	29 d0                	sub    %edx,%eax
  103266:	a3 38 cf 11 00       	mov    %eax,0x11cf38

	for (i = 0; i < npage; i ++) {
  10326b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103272:	eb 2e                	jmp    1032a2 <page_init+0x1fc>
		SetPageReserved(pages + i);
  103274:	8b 0d 38 cf 11 00    	mov    0x11cf38,%ecx
  10327a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10327d:	89 d0                	mov    %edx,%eax
  10327f:	c1 e0 02             	shl    $0x2,%eax
  103282:	01 d0                	add    %edx,%eax
  103284:	c1 e0 02             	shl    $0x2,%eax
  103287:	01 c8                	add    %ecx,%eax
  103289:	83 c0 04             	add    $0x4,%eax
  10328c:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
  103293:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  103296:	8b 45 8c             	mov    -0x74(%ebp),%eax
  103299:	8b 55 90             	mov    -0x70(%ebp),%edx
  10329c:	0f ab 10             	bts    %edx,(%eax)
	for (i = 0; i < npage; i ++) {
  10329f:	ff 45 dc             	incl   -0x24(%ebp)
  1032a2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1032a5:	a1 a0 ce 11 00       	mov    0x11cea0,%eax
  1032aa:	39 c2                	cmp    %eax,%edx
  1032ac:	72 c6                	jb     103274 <page_init+0x1ce>
	}

	// struct Page数组之上是可用的物理内存
	uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  1032ae:	8b 15 a0 ce 11 00    	mov    0x11cea0,%edx
  1032b4:	89 d0                	mov    %edx,%eax
  1032b6:	c1 e0 02             	shl    $0x2,%eax
  1032b9:	01 d0                	add    %edx,%eax
  1032bb:	c1 e0 02             	shl    $0x2,%eax
  1032be:	89 c2                	mov    %eax,%edx
  1032c0:	a1 38 cf 11 00       	mov    0x11cf38,%eax
  1032c5:	01 d0                	add    %edx,%eax
  1032c7:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  1032ca:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
  1032d1:	77 23                	ja     1032f6 <page_init+0x250>
  1032d3:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  1032d6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1032da:	c7 44 24 08 04 6c 10 	movl   $0x106c04,0x8(%esp)
  1032e1:	00 
  1032e2:	c7 44 24 04 df 00 00 	movl   $0xdf,0x4(%esp)
  1032e9:	00 
  1032ea:	c7 04 24 28 6c 10 00 	movl   $0x106c28,(%esp)
  1032f1:	e8 fc d0 ff ff       	call   1003f2 <__panic>
  1032f6:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  1032f9:	05 00 00 00 40       	add    $0x40000000,%eax
  1032fe:	89 45 a0             	mov    %eax,-0x60(%ebp)

	for (i = 0; i < memmap->nr_map; i ++) {
  103301:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103308:	e9 53 01 00 00       	jmp    103460 <page_init+0x3ba>
		uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  10330d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103310:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103313:	89 d0                	mov    %edx,%eax
  103315:	c1 e0 02             	shl    $0x2,%eax
  103318:	01 d0                	add    %edx,%eax
  10331a:	c1 e0 02             	shl    $0x2,%eax
  10331d:	01 c8                	add    %ecx,%eax
  10331f:	8b 50 08             	mov    0x8(%eax),%edx
  103322:	8b 40 04             	mov    0x4(%eax),%eax
  103325:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103328:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  10332b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10332e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103331:	89 d0                	mov    %edx,%eax
  103333:	c1 e0 02             	shl    $0x2,%eax
  103336:	01 d0                	add    %edx,%eax
  103338:	c1 e0 02             	shl    $0x2,%eax
  10333b:	01 c8                	add    %ecx,%eax
  10333d:	8b 48 0c             	mov    0xc(%eax),%ecx
  103340:	8b 58 10             	mov    0x10(%eax),%ebx
  103343:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103346:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103349:	01 c8                	add    %ecx,%eax
  10334b:	11 da                	adc    %ebx,%edx
  10334d:	89 45 c8             	mov    %eax,-0x38(%ebp)
  103350:	89 55 cc             	mov    %edx,-0x34(%ebp)
		if (memmap->map[i].type == E820_ARM) {
  103353:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103356:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103359:	89 d0                	mov    %edx,%eax
  10335b:	c1 e0 02             	shl    $0x2,%eax
  10335e:	01 d0                	add    %edx,%eax
  103360:	c1 e0 02             	shl    $0x2,%eax
  103363:	01 c8                	add    %ecx,%eax
  103365:	83 c0 14             	add    $0x14,%eax
  103368:	8b 00                	mov    (%eax),%eax
  10336a:	83 f8 01             	cmp    $0x1,%eax
  10336d:	0f 85 ea 00 00 00    	jne    10345d <page_init+0x3b7>
			if (begin < freemem) {
  103373:	8b 45 a0             	mov    -0x60(%ebp),%eax
  103376:	ba 00 00 00 00       	mov    $0x0,%edx
  10337b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  10337e:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  103381:	19 d1                	sbb    %edx,%ecx
  103383:	73 0d                	jae    103392 <page_init+0x2ec>
				begin = freemem;
  103385:	8b 45 a0             	mov    -0x60(%ebp),%eax
  103388:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10338b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
			}
			if (end > KMEMSIZE) {
  103392:	ba 00 00 00 38       	mov    $0x38000000,%edx
  103397:	b8 00 00 00 00       	mov    $0x0,%eax
  10339c:	3b 55 c8             	cmp    -0x38(%ebp),%edx
  10339f:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  1033a2:	73 0e                	jae    1033b2 <page_init+0x30c>
				end = KMEMSIZE;
  1033a4:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  1033ab:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
			}
			if (begin < end) {
  1033b2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1033b5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1033b8:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  1033bb:	89 d0                	mov    %edx,%eax
  1033bd:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  1033c0:	0f 83 97 00 00 00    	jae    10345d <page_init+0x3b7>
				// 为了避免超出可用的物理内存范围,begin只能向上舍入、end只能向下舍入
				begin = ROUNDUP(begin, PGSIZE);
  1033c6:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
  1033cd:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1033d0:	8b 45 9c             	mov    -0x64(%ebp),%eax
  1033d3:	01 d0                	add    %edx,%eax
  1033d5:	48                   	dec    %eax
  1033d6:	89 45 98             	mov    %eax,-0x68(%ebp)
  1033d9:	8b 45 98             	mov    -0x68(%ebp),%eax
  1033dc:	ba 00 00 00 00       	mov    $0x0,%edx
  1033e1:	f7 75 9c             	divl   -0x64(%ebp)
  1033e4:	8b 45 98             	mov    -0x68(%ebp),%eax
  1033e7:	29 d0                	sub    %edx,%eax
  1033e9:	ba 00 00 00 00       	mov    $0x0,%edx
  1033ee:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1033f1:	89 55 d4             	mov    %edx,-0x2c(%ebp)
				end = ROUNDDOWN(end, PGSIZE);
  1033f4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1033f7:	89 45 94             	mov    %eax,-0x6c(%ebp)
  1033fa:	8b 45 94             	mov    -0x6c(%ebp),%eax
  1033fd:	ba 00 00 00 00       	mov    $0x0,%edx
  103402:	89 c3                	mov    %eax,%ebx
  103404:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  10340a:	89 de                	mov    %ebx,%esi
  10340c:	89 d0                	mov    %edx,%eax
  10340e:	83 e0 00             	and    $0x0,%eax
  103411:	89 c7                	mov    %eax,%edi
  103413:	89 75 c8             	mov    %esi,-0x38(%ebp)
  103416:	89 7d cc             	mov    %edi,-0x34(%ebp)
				if (begin < end) {
  103419:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10341c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10341f:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  103422:	89 d0                	mov    %edx,%eax
  103424:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  103427:	73 34                	jae    10345d <page_init+0x3b7>
					init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  103429:	8b 45 c8             	mov    -0x38(%ebp),%eax
  10342c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  10342f:	2b 45 d0             	sub    -0x30(%ebp),%eax
  103432:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
  103435:	89 c1                	mov    %eax,%ecx
  103437:	89 d3                	mov    %edx,%ebx
  103439:	89 c8                	mov    %ecx,%eax
  10343b:	89 da                	mov    %ebx,%edx
  10343d:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  103441:	c1 ea 0c             	shr    $0xc,%edx
  103444:	89 c3                	mov    %eax,%ebx
  103446:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103449:	89 04 24             	mov    %eax,(%esp)
  10344c:	e8 cf f8 ff ff       	call   102d20 <pa2page>
  103451:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  103455:	89 04 24             	mov    %eax,(%esp)
  103458:	e8 93 fb ff ff       	call   102ff0 <init_memmap>
	for (i = 0; i < memmap->nr_map; i ++) {
  10345d:	ff 45 dc             	incl   -0x24(%ebp)
  103460:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103463:	8b 00                	mov    (%eax),%eax
  103465:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  103468:	0f 8c 9f fe ff ff    	jl     10330d <page_init+0x267>
				}
			}
		}
	}
}
  10346e:	90                   	nop
  10346f:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  103475:	5b                   	pop    %ebx
  103476:	5e                   	pop    %esi
  103477:	5f                   	pop    %edi
  103478:	5d                   	pop    %ebp
  103479:	c3                   	ret    

0010347a <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  10347a:	55                   	push   %ebp
  10347b:	89 e5                	mov    %esp,%ebp
  10347d:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  103480:	8b 45 0c             	mov    0xc(%ebp),%eax
  103483:	33 45 14             	xor    0x14(%ebp),%eax
  103486:	25 ff 0f 00 00       	and    $0xfff,%eax
  10348b:	85 c0                	test   %eax,%eax
  10348d:	74 24                	je     1034b3 <boot_map_segment+0x39>
  10348f:	c7 44 24 0c 36 6c 10 	movl   $0x106c36,0xc(%esp)
  103496:	00 
  103497:	c7 44 24 08 4d 6c 10 	movl   $0x106c4d,0x8(%esp)
  10349e:	00 
  10349f:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
  1034a6:	00 
  1034a7:	c7 04 24 28 6c 10 00 	movl   $0x106c28,(%esp)
  1034ae:	e8 3f cf ff ff       	call   1003f2 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  1034b3:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  1034ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034bd:	25 ff 0f 00 00       	and    $0xfff,%eax
  1034c2:	89 c2                	mov    %eax,%edx
  1034c4:	8b 45 10             	mov    0x10(%ebp),%eax
  1034c7:	01 c2                	add    %eax,%edx
  1034c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1034cc:	01 d0                	add    %edx,%eax
  1034ce:	48                   	dec    %eax
  1034cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1034d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1034d5:	ba 00 00 00 00       	mov    $0x0,%edx
  1034da:	f7 75 f0             	divl   -0x10(%ebp)
  1034dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1034e0:	29 d0                	sub    %edx,%eax
  1034e2:	c1 e8 0c             	shr    $0xc,%eax
  1034e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  1034e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034eb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1034ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1034f1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1034f6:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  1034f9:	8b 45 14             	mov    0x14(%ebp),%eax
  1034fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1034ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103502:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103507:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  10350a:	eb 68                	jmp    103574 <boot_map_segment+0xfa>
        pte_t *ptep = get_pte(pgdir, la, 1);
  10350c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  103513:	00 
  103514:	8b 45 0c             	mov    0xc(%ebp),%eax
  103517:	89 44 24 04          	mov    %eax,0x4(%esp)
  10351b:	8b 45 08             	mov    0x8(%ebp),%eax
  10351e:	89 04 24             	mov    %eax,(%esp)
  103521:	e8 81 01 00 00       	call   1036a7 <get_pte>
  103526:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  103529:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  10352d:	75 24                	jne    103553 <boot_map_segment+0xd9>
  10352f:	c7 44 24 0c 62 6c 10 	movl   $0x106c62,0xc(%esp)
  103536:	00 
  103537:	c7 44 24 08 4d 6c 10 	movl   $0x106c4d,0x8(%esp)
  10353e:	00 
  10353f:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
  103546:	00 
  103547:	c7 04 24 28 6c 10 00 	movl   $0x106c28,(%esp)
  10354e:	e8 9f ce ff ff       	call   1003f2 <__panic>
        *ptep = pa | PTE_P | perm;
  103553:	8b 45 14             	mov    0x14(%ebp),%eax
  103556:	0b 45 18             	or     0x18(%ebp),%eax
  103559:	83 c8 01             	or     $0x1,%eax
  10355c:	89 c2                	mov    %eax,%edx
  10355e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103561:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  103563:	ff 4d f4             	decl   -0xc(%ebp)
  103566:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  10356d:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  103574:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103578:	75 92                	jne    10350c <boot_map_segment+0x92>
    }
}
  10357a:	90                   	nop
  10357b:	c9                   	leave  
  10357c:	c3                   	ret    

0010357d <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  10357d:	55                   	push   %ebp
  10357e:	89 e5                	mov    %esp,%ebp
  103580:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  103583:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10358a:	e8 81 fa ff ff       	call   103010 <alloc_pages>
  10358f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  103592:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103596:	75 1c                	jne    1035b4 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
  103598:	c7 44 24 08 6f 6c 10 	movl   $0x106c6f,0x8(%esp)
  10359f:	00 
  1035a0:	c7 44 24 04 10 01 00 	movl   $0x110,0x4(%esp)
  1035a7:	00 
  1035a8:	c7 04 24 28 6c 10 00 	movl   $0x106c28,(%esp)
  1035af:	e8 3e ce ff ff       	call   1003f2 <__panic>
    }
    return page2kva(p);
  1035b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1035b7:	89 04 24             	mov    %eax,(%esp)
  1035ba:	e8 b0 f7 ff ff       	call   102d6f <page2kva>
}
  1035bf:	c9                   	leave  
  1035c0:	c3                   	ret    

001035c1 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  1035c1:	55                   	push   %ebp
  1035c2:	89 e5                	mov    %esp,%ebp
  1035c4:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
  1035c7:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  1035cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1035cf:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  1035d6:	77 23                	ja     1035fb <pmm_init+0x3a>
  1035d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1035db:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1035df:	c7 44 24 08 04 6c 10 	movl   $0x106c04,0x8(%esp)
  1035e6:	00 
  1035e7:	c7 44 24 04 1a 01 00 	movl   $0x11a,0x4(%esp)
  1035ee:	00 
  1035ef:	c7 04 24 28 6c 10 00 	movl   $0x106c28,(%esp)
  1035f6:	e8 f7 cd ff ff       	call   1003f2 <__panic>
  1035fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1035fe:	05 00 00 00 40       	add    $0x40000000,%eax
  103603:	a3 34 cf 11 00       	mov    %eax,0x11cf34
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  103608:	e8 af f9 ff ff       	call   102fbc <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  10360d:	e8 94 fa ff ff       	call   1030a6 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  103612:	e8 4f 02 00 00       	call   103866 <check_alloc_page>

    check_pgdir();
  103617:	e8 69 02 00 00       	call   103885 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  10361c:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103621:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103624:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  10362b:	77 23                	ja     103650 <pmm_init+0x8f>
  10362d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103630:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103634:	c7 44 24 08 04 6c 10 	movl   $0x106c04,0x8(%esp)
  10363b:	00 
  10363c:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
  103643:	00 
  103644:	c7 04 24 28 6c 10 00 	movl   $0x106c28,(%esp)
  10364b:	e8 a2 cd ff ff       	call   1003f2 <__panic>
  103650:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103653:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
  103659:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  10365e:	05 ac 0f 00 00       	add    $0xfac,%eax
  103663:	83 ca 03             	or     $0x3,%edx
  103666:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  103668:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  10366d:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  103674:	00 
  103675:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  10367c:	00 
  10367d:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  103684:	38 
  103685:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  10368c:	c0 
  10368d:	89 04 24             	mov    %eax,(%esp)
  103690:	e8 e5 fd ff ff       	call   10347a <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  103695:	e8 39 f8 ff ff       	call   102ed3 <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  10369a:	e8 82 08 00 00       	call   103f21 <check_boot_pgdir>

    print_pgdir();
  10369f:	e8 fb 0c 00 00       	call   10439f <print_pgdir>

}
  1036a4:	90                   	nop
  1036a5:	c9                   	leave  
  1036a6:	c3                   	ret    

001036a7 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  1036a7:	55                   	push   %ebp
  1036a8:	89 e5                	mov    %esp,%ebp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
}
  1036aa:	90                   	nop
  1036ab:	5d                   	pop    %ebp
  1036ac:	c3                   	ret    

001036ad <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  1036ad:	55                   	push   %ebp
  1036ae:	89 e5                	mov    %esp,%ebp
  1036b0:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  1036b3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1036ba:	00 
  1036bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1036be:	89 44 24 04          	mov    %eax,0x4(%esp)
  1036c2:	8b 45 08             	mov    0x8(%ebp),%eax
  1036c5:	89 04 24             	mov    %eax,(%esp)
  1036c8:	e8 da ff ff ff       	call   1036a7 <get_pte>
  1036cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  1036d0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1036d4:	74 08                	je     1036de <get_page+0x31>
        *ptep_store = ptep;
  1036d6:	8b 45 10             	mov    0x10(%ebp),%eax
  1036d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1036dc:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  1036de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1036e2:	74 1b                	je     1036ff <get_page+0x52>
  1036e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1036e7:	8b 00                	mov    (%eax),%eax
  1036e9:	83 e0 01             	and    $0x1,%eax
  1036ec:	85 c0                	test   %eax,%eax
  1036ee:	74 0f                	je     1036ff <get_page+0x52>
        return pte2page(*ptep);
  1036f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1036f3:	8b 00                	mov    (%eax),%eax
  1036f5:	89 04 24             	mov    %eax,(%esp)
  1036f8:	e8 c6 f6 ff ff       	call   102dc3 <pte2page>
  1036fd:	eb 05                	jmp    103704 <get_page+0x57>
    }
    return NULL;
  1036ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103704:	c9                   	leave  
  103705:	c3                   	ret    

00103706 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  103706:	55                   	push   %ebp
  103707:	89 e5                	mov    %esp,%ebp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
}
  103709:	90                   	nop
  10370a:	5d                   	pop    %ebp
  10370b:	c3                   	ret    

0010370c <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  10370c:	55                   	push   %ebp
  10370d:	89 e5                	mov    %esp,%ebp
  10370f:	83 ec 1c             	sub    $0x1c,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  103712:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103719:	00 
  10371a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10371d:	89 44 24 04          	mov    %eax,0x4(%esp)
  103721:	8b 45 08             	mov    0x8(%ebp),%eax
  103724:	89 04 24             	mov    %eax,(%esp)
  103727:	e8 7b ff ff ff       	call   1036a7 <get_pte>
  10372c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (ptep != NULL) {
  10372f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  103733:	74 19                	je     10374e <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
  103735:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103738:	89 44 24 08          	mov    %eax,0x8(%esp)
  10373c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10373f:	89 44 24 04          	mov    %eax,0x4(%esp)
  103743:	8b 45 08             	mov    0x8(%ebp),%eax
  103746:	89 04 24             	mov    %eax,(%esp)
  103749:	e8 b8 ff ff ff       	call   103706 <page_remove_pte>
    }
}
  10374e:	90                   	nop
  10374f:	c9                   	leave  
  103750:	c3                   	ret    

00103751 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  103751:	55                   	push   %ebp
  103752:	89 e5                	mov    %esp,%ebp
  103754:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  103757:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  10375e:	00 
  10375f:	8b 45 10             	mov    0x10(%ebp),%eax
  103762:	89 44 24 04          	mov    %eax,0x4(%esp)
  103766:	8b 45 08             	mov    0x8(%ebp),%eax
  103769:	89 04 24             	mov    %eax,(%esp)
  10376c:	e8 36 ff ff ff       	call   1036a7 <get_pte>
  103771:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  103774:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103778:	75 0a                	jne    103784 <page_insert+0x33>
        return -E_NO_MEM;
  10377a:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  10377f:	e9 84 00 00 00       	jmp    103808 <page_insert+0xb7>
    }
    page_ref_inc(page);
  103784:	8b 45 0c             	mov    0xc(%ebp),%eax
  103787:	89 04 24             	mov    %eax,(%esp)
  10378a:	e8 94 f6 ff ff       	call   102e23 <page_ref_inc>
    if (*ptep & PTE_P) {
  10378f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103792:	8b 00                	mov    (%eax),%eax
  103794:	83 e0 01             	and    $0x1,%eax
  103797:	85 c0                	test   %eax,%eax
  103799:	74 3e                	je     1037d9 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
  10379b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10379e:	8b 00                	mov    (%eax),%eax
  1037a0:	89 04 24             	mov    %eax,(%esp)
  1037a3:	e8 1b f6 ff ff       	call   102dc3 <pte2page>
  1037a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  1037ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1037ae:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1037b1:	75 0d                	jne    1037c0 <page_insert+0x6f>
            page_ref_dec(page);
  1037b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1037b6:	89 04 24             	mov    %eax,(%esp)
  1037b9:	e8 7c f6 ff ff       	call   102e3a <page_ref_dec>
  1037be:	eb 19                	jmp    1037d9 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  1037c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1037c3:	89 44 24 08          	mov    %eax,0x8(%esp)
  1037c7:	8b 45 10             	mov    0x10(%ebp),%eax
  1037ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  1037ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1037d1:	89 04 24             	mov    %eax,(%esp)
  1037d4:	e8 2d ff ff ff       	call   103706 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  1037d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1037dc:	89 04 24             	mov    %eax,(%esp)
  1037df:	e8 26 f5 ff ff       	call   102d0a <page2pa>
  1037e4:	0b 45 14             	or     0x14(%ebp),%eax
  1037e7:	83 c8 01             	or     $0x1,%eax
  1037ea:	89 c2                	mov    %eax,%edx
  1037ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1037ef:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  1037f1:	8b 45 10             	mov    0x10(%ebp),%eax
  1037f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1037f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1037fb:	89 04 24             	mov    %eax,(%esp)
  1037fe:	e8 07 00 00 00       	call   10380a <tlb_invalidate>
    return 0;
  103803:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103808:	c9                   	leave  
  103809:	c3                   	ret    

0010380a <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  10380a:	55                   	push   %ebp
  10380b:	89 e5                	mov    %esp,%ebp
  10380d:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  103810:	0f 20 d8             	mov    %cr3,%eax
  103813:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  103816:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
  103819:	8b 45 08             	mov    0x8(%ebp),%eax
  10381c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10381f:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  103826:	77 23                	ja     10384b <tlb_invalidate+0x41>
  103828:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10382b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10382f:	c7 44 24 08 04 6c 10 	movl   $0x106c04,0x8(%esp)
  103836:	00 
  103837:	c7 44 24 04 c7 01 00 	movl   $0x1c7,0x4(%esp)
  10383e:	00 
  10383f:	c7 04 24 28 6c 10 00 	movl   $0x106c28,(%esp)
  103846:	e8 a7 cb ff ff       	call   1003f2 <__panic>
  10384b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10384e:	05 00 00 00 40       	add    $0x40000000,%eax
  103853:	39 d0                	cmp    %edx,%eax
  103855:	75 0c                	jne    103863 <tlb_invalidate+0x59>
        invlpg((void *)la);
  103857:	8b 45 0c             	mov    0xc(%ebp),%eax
  10385a:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  10385d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103860:	0f 01 38             	invlpg (%eax)
    }
}
  103863:	90                   	nop
  103864:	c9                   	leave  
  103865:	c3                   	ret    

00103866 <check_alloc_page>:

static void
check_alloc_page(void) {
  103866:	55                   	push   %ebp
  103867:	89 e5                	mov    %esp,%ebp
  103869:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  10386c:	a1 30 cf 11 00       	mov    0x11cf30,%eax
  103871:	8b 40 18             	mov    0x18(%eax),%eax
  103874:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  103876:	c7 04 24 88 6c 10 00 	movl   $0x106c88,(%esp)
  10387d:	e8 18 ca ff ff       	call   10029a <cprintf>
}
  103882:	90                   	nop
  103883:	c9                   	leave  
  103884:	c3                   	ret    

00103885 <check_pgdir>:

static void
check_pgdir(void) {
  103885:	55                   	push   %ebp
  103886:	89 e5                	mov    %esp,%ebp
  103888:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  10388b:	a1 a0 ce 11 00       	mov    0x11cea0,%eax
  103890:	3d 00 80 03 00       	cmp    $0x38000,%eax
  103895:	76 24                	jbe    1038bb <check_pgdir+0x36>
  103897:	c7 44 24 0c a7 6c 10 	movl   $0x106ca7,0xc(%esp)
  10389e:	00 
  10389f:	c7 44 24 08 4d 6c 10 	movl   $0x106c4d,0x8(%esp)
  1038a6:	00 
  1038a7:	c7 44 24 04 d4 01 00 	movl   $0x1d4,0x4(%esp)
  1038ae:	00 
  1038af:	c7 04 24 28 6c 10 00 	movl   $0x106c28,(%esp)
  1038b6:	e8 37 cb ff ff       	call   1003f2 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  1038bb:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  1038c0:	85 c0                	test   %eax,%eax
  1038c2:	74 0e                	je     1038d2 <check_pgdir+0x4d>
  1038c4:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  1038c9:	25 ff 0f 00 00       	and    $0xfff,%eax
  1038ce:	85 c0                	test   %eax,%eax
  1038d0:	74 24                	je     1038f6 <check_pgdir+0x71>
  1038d2:	c7 44 24 0c c4 6c 10 	movl   $0x106cc4,0xc(%esp)
  1038d9:	00 
  1038da:	c7 44 24 08 4d 6c 10 	movl   $0x106c4d,0x8(%esp)
  1038e1:	00 
  1038e2:	c7 44 24 04 d5 01 00 	movl   $0x1d5,0x4(%esp)
  1038e9:	00 
  1038ea:	c7 04 24 28 6c 10 00 	movl   $0x106c28,(%esp)
  1038f1:	e8 fc ca ff ff       	call   1003f2 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  1038f6:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  1038fb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103902:	00 
  103903:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10390a:	00 
  10390b:	89 04 24             	mov    %eax,(%esp)
  10390e:	e8 9a fd ff ff       	call   1036ad <get_page>
  103913:	85 c0                	test   %eax,%eax
  103915:	74 24                	je     10393b <check_pgdir+0xb6>
  103917:	c7 44 24 0c fc 6c 10 	movl   $0x106cfc,0xc(%esp)
  10391e:	00 
  10391f:	c7 44 24 08 4d 6c 10 	movl   $0x106c4d,0x8(%esp)
  103926:	00 
  103927:	c7 44 24 04 d6 01 00 	movl   $0x1d6,0x4(%esp)
  10392e:	00 
  10392f:	c7 04 24 28 6c 10 00 	movl   $0x106c28,(%esp)
  103936:	e8 b7 ca ff ff       	call   1003f2 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  10393b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103942:	e8 c9 f6 ff ff       	call   103010 <alloc_pages>
  103947:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  10394a:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  10394f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  103956:	00 
  103957:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10395e:	00 
  10395f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103962:	89 54 24 04          	mov    %edx,0x4(%esp)
  103966:	89 04 24             	mov    %eax,(%esp)
  103969:	e8 e3 fd ff ff       	call   103751 <page_insert>
  10396e:	85 c0                	test   %eax,%eax
  103970:	74 24                	je     103996 <check_pgdir+0x111>
  103972:	c7 44 24 0c 24 6d 10 	movl   $0x106d24,0xc(%esp)
  103979:	00 
  10397a:	c7 44 24 08 4d 6c 10 	movl   $0x106c4d,0x8(%esp)
  103981:	00 
  103982:	c7 44 24 04 da 01 00 	movl   $0x1da,0x4(%esp)
  103989:	00 
  10398a:	c7 04 24 28 6c 10 00 	movl   $0x106c28,(%esp)
  103991:	e8 5c ca ff ff       	call   1003f2 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  103996:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  10399b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1039a2:	00 
  1039a3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1039aa:	00 
  1039ab:	89 04 24             	mov    %eax,(%esp)
  1039ae:	e8 f4 fc ff ff       	call   1036a7 <get_pte>
  1039b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1039b6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1039ba:	75 24                	jne    1039e0 <check_pgdir+0x15b>
  1039bc:	c7 44 24 0c 50 6d 10 	movl   $0x106d50,0xc(%esp)
  1039c3:	00 
  1039c4:	c7 44 24 08 4d 6c 10 	movl   $0x106c4d,0x8(%esp)
  1039cb:	00 
  1039cc:	c7 44 24 04 dd 01 00 	movl   $0x1dd,0x4(%esp)
  1039d3:	00 
  1039d4:	c7 04 24 28 6c 10 00 	movl   $0x106c28,(%esp)
  1039db:	e8 12 ca ff ff       	call   1003f2 <__panic>
    assert(pte2page(*ptep) == p1);
  1039e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1039e3:	8b 00                	mov    (%eax),%eax
  1039e5:	89 04 24             	mov    %eax,(%esp)
  1039e8:	e8 d6 f3 ff ff       	call   102dc3 <pte2page>
  1039ed:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  1039f0:	74 24                	je     103a16 <check_pgdir+0x191>
  1039f2:	c7 44 24 0c 7d 6d 10 	movl   $0x106d7d,0xc(%esp)
  1039f9:	00 
  1039fa:	c7 44 24 08 4d 6c 10 	movl   $0x106c4d,0x8(%esp)
  103a01:	00 
  103a02:	c7 44 24 04 de 01 00 	movl   $0x1de,0x4(%esp)
  103a09:	00 
  103a0a:	c7 04 24 28 6c 10 00 	movl   $0x106c28,(%esp)
  103a11:	e8 dc c9 ff ff       	call   1003f2 <__panic>
    assert(page_ref(p1) == 1);
  103a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103a19:	89 04 24             	mov    %eax,(%esp)
  103a1c:	e8 f8 f3 ff ff       	call   102e19 <page_ref>
  103a21:	83 f8 01             	cmp    $0x1,%eax
  103a24:	74 24                	je     103a4a <check_pgdir+0x1c5>
  103a26:	c7 44 24 0c 93 6d 10 	movl   $0x106d93,0xc(%esp)
  103a2d:	00 
  103a2e:	c7 44 24 08 4d 6c 10 	movl   $0x106c4d,0x8(%esp)
  103a35:	00 
  103a36:	c7 44 24 04 df 01 00 	movl   $0x1df,0x4(%esp)
  103a3d:	00 
  103a3e:	c7 04 24 28 6c 10 00 	movl   $0x106c28,(%esp)
  103a45:	e8 a8 c9 ff ff       	call   1003f2 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  103a4a:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103a4f:	8b 00                	mov    (%eax),%eax
  103a51:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103a56:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103a59:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103a5c:	c1 e8 0c             	shr    $0xc,%eax
  103a5f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103a62:	a1 a0 ce 11 00       	mov    0x11cea0,%eax
  103a67:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  103a6a:	72 23                	jb     103a8f <check_pgdir+0x20a>
  103a6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103a6f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103a73:	c7 44 24 08 60 6b 10 	movl   $0x106b60,0x8(%esp)
  103a7a:	00 
  103a7b:	c7 44 24 04 e1 01 00 	movl   $0x1e1,0x4(%esp)
  103a82:	00 
  103a83:	c7 04 24 28 6c 10 00 	movl   $0x106c28,(%esp)
  103a8a:	e8 63 c9 ff ff       	call   1003f2 <__panic>
  103a8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103a92:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103a97:	83 c0 04             	add    $0x4,%eax
  103a9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  103a9d:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103aa2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103aa9:	00 
  103aaa:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103ab1:	00 
  103ab2:	89 04 24             	mov    %eax,(%esp)
  103ab5:	e8 ed fb ff ff       	call   1036a7 <get_pte>
  103aba:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  103abd:	74 24                	je     103ae3 <check_pgdir+0x25e>
  103abf:	c7 44 24 0c a8 6d 10 	movl   $0x106da8,0xc(%esp)
  103ac6:	00 
  103ac7:	c7 44 24 08 4d 6c 10 	movl   $0x106c4d,0x8(%esp)
  103ace:	00 
  103acf:	c7 44 24 04 e2 01 00 	movl   $0x1e2,0x4(%esp)
  103ad6:	00 
  103ad7:	c7 04 24 28 6c 10 00 	movl   $0x106c28,(%esp)
  103ade:	e8 0f c9 ff ff       	call   1003f2 <__panic>

    p2 = alloc_page();
  103ae3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103aea:	e8 21 f5 ff ff       	call   103010 <alloc_pages>
  103aef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  103af2:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103af7:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  103afe:	00 
  103aff:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  103b06:	00 
  103b07:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103b0a:	89 54 24 04          	mov    %edx,0x4(%esp)
  103b0e:	89 04 24             	mov    %eax,(%esp)
  103b11:	e8 3b fc ff ff       	call   103751 <page_insert>
  103b16:	85 c0                	test   %eax,%eax
  103b18:	74 24                	je     103b3e <check_pgdir+0x2b9>
  103b1a:	c7 44 24 0c d0 6d 10 	movl   $0x106dd0,0xc(%esp)
  103b21:	00 
  103b22:	c7 44 24 08 4d 6c 10 	movl   $0x106c4d,0x8(%esp)
  103b29:	00 
  103b2a:	c7 44 24 04 e5 01 00 	movl   $0x1e5,0x4(%esp)
  103b31:	00 
  103b32:	c7 04 24 28 6c 10 00 	movl   $0x106c28,(%esp)
  103b39:	e8 b4 c8 ff ff       	call   1003f2 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  103b3e:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103b43:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103b4a:	00 
  103b4b:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103b52:	00 
  103b53:	89 04 24             	mov    %eax,(%esp)
  103b56:	e8 4c fb ff ff       	call   1036a7 <get_pte>
  103b5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103b5e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103b62:	75 24                	jne    103b88 <check_pgdir+0x303>
  103b64:	c7 44 24 0c 08 6e 10 	movl   $0x106e08,0xc(%esp)
  103b6b:	00 
  103b6c:	c7 44 24 08 4d 6c 10 	movl   $0x106c4d,0x8(%esp)
  103b73:	00 
  103b74:	c7 44 24 04 e6 01 00 	movl   $0x1e6,0x4(%esp)
  103b7b:	00 
  103b7c:	c7 04 24 28 6c 10 00 	movl   $0x106c28,(%esp)
  103b83:	e8 6a c8 ff ff       	call   1003f2 <__panic>
    assert(*ptep & PTE_U);
  103b88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103b8b:	8b 00                	mov    (%eax),%eax
  103b8d:	83 e0 04             	and    $0x4,%eax
  103b90:	85 c0                	test   %eax,%eax
  103b92:	75 24                	jne    103bb8 <check_pgdir+0x333>
  103b94:	c7 44 24 0c 38 6e 10 	movl   $0x106e38,0xc(%esp)
  103b9b:	00 
  103b9c:	c7 44 24 08 4d 6c 10 	movl   $0x106c4d,0x8(%esp)
  103ba3:	00 
  103ba4:	c7 44 24 04 e7 01 00 	movl   $0x1e7,0x4(%esp)
  103bab:	00 
  103bac:	c7 04 24 28 6c 10 00 	movl   $0x106c28,(%esp)
  103bb3:	e8 3a c8 ff ff       	call   1003f2 <__panic>
    assert(*ptep & PTE_W);
  103bb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103bbb:	8b 00                	mov    (%eax),%eax
  103bbd:	83 e0 02             	and    $0x2,%eax
  103bc0:	85 c0                	test   %eax,%eax
  103bc2:	75 24                	jne    103be8 <check_pgdir+0x363>
  103bc4:	c7 44 24 0c 46 6e 10 	movl   $0x106e46,0xc(%esp)
  103bcb:	00 
  103bcc:	c7 44 24 08 4d 6c 10 	movl   $0x106c4d,0x8(%esp)
  103bd3:	00 
  103bd4:	c7 44 24 04 e8 01 00 	movl   $0x1e8,0x4(%esp)
  103bdb:	00 
  103bdc:	c7 04 24 28 6c 10 00 	movl   $0x106c28,(%esp)
  103be3:	e8 0a c8 ff ff       	call   1003f2 <__panic>
    assert(boot_pgdir[0] & PTE_U);
  103be8:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103bed:	8b 00                	mov    (%eax),%eax
  103bef:	83 e0 04             	and    $0x4,%eax
  103bf2:	85 c0                	test   %eax,%eax
  103bf4:	75 24                	jne    103c1a <check_pgdir+0x395>
  103bf6:	c7 44 24 0c 54 6e 10 	movl   $0x106e54,0xc(%esp)
  103bfd:	00 
  103bfe:	c7 44 24 08 4d 6c 10 	movl   $0x106c4d,0x8(%esp)
  103c05:	00 
  103c06:	c7 44 24 04 e9 01 00 	movl   $0x1e9,0x4(%esp)
  103c0d:	00 
  103c0e:	c7 04 24 28 6c 10 00 	movl   $0x106c28,(%esp)
  103c15:	e8 d8 c7 ff ff       	call   1003f2 <__panic>
    assert(page_ref(p2) == 1);
  103c1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103c1d:	89 04 24             	mov    %eax,(%esp)
  103c20:	e8 f4 f1 ff ff       	call   102e19 <page_ref>
  103c25:	83 f8 01             	cmp    $0x1,%eax
  103c28:	74 24                	je     103c4e <check_pgdir+0x3c9>
  103c2a:	c7 44 24 0c 6a 6e 10 	movl   $0x106e6a,0xc(%esp)
  103c31:	00 
  103c32:	c7 44 24 08 4d 6c 10 	movl   $0x106c4d,0x8(%esp)
  103c39:	00 
  103c3a:	c7 44 24 04 ea 01 00 	movl   $0x1ea,0x4(%esp)
  103c41:	00 
  103c42:	c7 04 24 28 6c 10 00 	movl   $0x106c28,(%esp)
  103c49:	e8 a4 c7 ff ff       	call   1003f2 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  103c4e:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103c53:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  103c5a:	00 
  103c5b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  103c62:	00 
  103c63:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103c66:	89 54 24 04          	mov    %edx,0x4(%esp)
  103c6a:	89 04 24             	mov    %eax,(%esp)
  103c6d:	e8 df fa ff ff       	call   103751 <page_insert>
  103c72:	85 c0                	test   %eax,%eax
  103c74:	74 24                	je     103c9a <check_pgdir+0x415>
  103c76:	c7 44 24 0c 7c 6e 10 	movl   $0x106e7c,0xc(%esp)
  103c7d:	00 
  103c7e:	c7 44 24 08 4d 6c 10 	movl   $0x106c4d,0x8(%esp)
  103c85:	00 
  103c86:	c7 44 24 04 ec 01 00 	movl   $0x1ec,0x4(%esp)
  103c8d:	00 
  103c8e:	c7 04 24 28 6c 10 00 	movl   $0x106c28,(%esp)
  103c95:	e8 58 c7 ff ff       	call   1003f2 <__panic>
    assert(page_ref(p1) == 2);
  103c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103c9d:	89 04 24             	mov    %eax,(%esp)
  103ca0:	e8 74 f1 ff ff       	call   102e19 <page_ref>
  103ca5:	83 f8 02             	cmp    $0x2,%eax
  103ca8:	74 24                	je     103cce <check_pgdir+0x449>
  103caa:	c7 44 24 0c a8 6e 10 	movl   $0x106ea8,0xc(%esp)
  103cb1:	00 
  103cb2:	c7 44 24 08 4d 6c 10 	movl   $0x106c4d,0x8(%esp)
  103cb9:	00 
  103cba:	c7 44 24 04 ed 01 00 	movl   $0x1ed,0x4(%esp)
  103cc1:	00 
  103cc2:	c7 04 24 28 6c 10 00 	movl   $0x106c28,(%esp)
  103cc9:	e8 24 c7 ff ff       	call   1003f2 <__panic>
    assert(page_ref(p2) == 0);
  103cce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103cd1:	89 04 24             	mov    %eax,(%esp)
  103cd4:	e8 40 f1 ff ff       	call   102e19 <page_ref>
  103cd9:	85 c0                	test   %eax,%eax
  103cdb:	74 24                	je     103d01 <check_pgdir+0x47c>
  103cdd:	c7 44 24 0c ba 6e 10 	movl   $0x106eba,0xc(%esp)
  103ce4:	00 
  103ce5:	c7 44 24 08 4d 6c 10 	movl   $0x106c4d,0x8(%esp)
  103cec:	00 
  103ced:	c7 44 24 04 ee 01 00 	movl   $0x1ee,0x4(%esp)
  103cf4:	00 
  103cf5:	c7 04 24 28 6c 10 00 	movl   $0x106c28,(%esp)
  103cfc:	e8 f1 c6 ff ff       	call   1003f2 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  103d01:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103d06:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103d0d:	00 
  103d0e:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103d15:	00 
  103d16:	89 04 24             	mov    %eax,(%esp)
  103d19:	e8 89 f9 ff ff       	call   1036a7 <get_pte>
  103d1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103d21:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103d25:	75 24                	jne    103d4b <check_pgdir+0x4c6>
  103d27:	c7 44 24 0c 08 6e 10 	movl   $0x106e08,0xc(%esp)
  103d2e:	00 
  103d2f:	c7 44 24 08 4d 6c 10 	movl   $0x106c4d,0x8(%esp)
  103d36:	00 
  103d37:	c7 44 24 04 ef 01 00 	movl   $0x1ef,0x4(%esp)
  103d3e:	00 
  103d3f:	c7 04 24 28 6c 10 00 	movl   $0x106c28,(%esp)
  103d46:	e8 a7 c6 ff ff       	call   1003f2 <__panic>
    assert(pte2page(*ptep) == p1);
  103d4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103d4e:	8b 00                	mov    (%eax),%eax
  103d50:	89 04 24             	mov    %eax,(%esp)
  103d53:	e8 6b f0 ff ff       	call   102dc3 <pte2page>
  103d58:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  103d5b:	74 24                	je     103d81 <check_pgdir+0x4fc>
  103d5d:	c7 44 24 0c 7d 6d 10 	movl   $0x106d7d,0xc(%esp)
  103d64:	00 
  103d65:	c7 44 24 08 4d 6c 10 	movl   $0x106c4d,0x8(%esp)
  103d6c:	00 
  103d6d:	c7 44 24 04 f0 01 00 	movl   $0x1f0,0x4(%esp)
  103d74:	00 
  103d75:	c7 04 24 28 6c 10 00 	movl   $0x106c28,(%esp)
  103d7c:	e8 71 c6 ff ff       	call   1003f2 <__panic>
    assert((*ptep & PTE_U) == 0);
  103d81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103d84:	8b 00                	mov    (%eax),%eax
  103d86:	83 e0 04             	and    $0x4,%eax
  103d89:	85 c0                	test   %eax,%eax
  103d8b:	74 24                	je     103db1 <check_pgdir+0x52c>
  103d8d:	c7 44 24 0c cc 6e 10 	movl   $0x106ecc,0xc(%esp)
  103d94:	00 
  103d95:	c7 44 24 08 4d 6c 10 	movl   $0x106c4d,0x8(%esp)
  103d9c:	00 
  103d9d:	c7 44 24 04 f1 01 00 	movl   $0x1f1,0x4(%esp)
  103da4:	00 
  103da5:	c7 04 24 28 6c 10 00 	movl   $0x106c28,(%esp)
  103dac:	e8 41 c6 ff ff       	call   1003f2 <__panic>

    page_remove(boot_pgdir, 0x0);
  103db1:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103db6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103dbd:	00 
  103dbe:	89 04 24             	mov    %eax,(%esp)
  103dc1:	e8 46 f9 ff ff       	call   10370c <page_remove>
    assert(page_ref(p1) == 1);
  103dc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103dc9:	89 04 24             	mov    %eax,(%esp)
  103dcc:	e8 48 f0 ff ff       	call   102e19 <page_ref>
  103dd1:	83 f8 01             	cmp    $0x1,%eax
  103dd4:	74 24                	je     103dfa <check_pgdir+0x575>
  103dd6:	c7 44 24 0c 93 6d 10 	movl   $0x106d93,0xc(%esp)
  103ddd:	00 
  103dde:	c7 44 24 08 4d 6c 10 	movl   $0x106c4d,0x8(%esp)
  103de5:	00 
  103de6:	c7 44 24 04 f4 01 00 	movl   $0x1f4,0x4(%esp)
  103ded:	00 
  103dee:	c7 04 24 28 6c 10 00 	movl   $0x106c28,(%esp)
  103df5:	e8 f8 c5 ff ff       	call   1003f2 <__panic>
    assert(page_ref(p2) == 0);
  103dfa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103dfd:	89 04 24             	mov    %eax,(%esp)
  103e00:	e8 14 f0 ff ff       	call   102e19 <page_ref>
  103e05:	85 c0                	test   %eax,%eax
  103e07:	74 24                	je     103e2d <check_pgdir+0x5a8>
  103e09:	c7 44 24 0c ba 6e 10 	movl   $0x106eba,0xc(%esp)
  103e10:	00 
  103e11:	c7 44 24 08 4d 6c 10 	movl   $0x106c4d,0x8(%esp)
  103e18:	00 
  103e19:	c7 44 24 04 f5 01 00 	movl   $0x1f5,0x4(%esp)
  103e20:	00 
  103e21:	c7 04 24 28 6c 10 00 	movl   $0x106c28,(%esp)
  103e28:	e8 c5 c5 ff ff       	call   1003f2 <__panic>

    page_remove(boot_pgdir, PGSIZE);
  103e2d:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103e32:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103e39:	00 
  103e3a:	89 04 24             	mov    %eax,(%esp)
  103e3d:	e8 ca f8 ff ff       	call   10370c <page_remove>
    assert(page_ref(p1) == 0);
  103e42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103e45:	89 04 24             	mov    %eax,(%esp)
  103e48:	e8 cc ef ff ff       	call   102e19 <page_ref>
  103e4d:	85 c0                	test   %eax,%eax
  103e4f:	74 24                	je     103e75 <check_pgdir+0x5f0>
  103e51:	c7 44 24 0c e1 6e 10 	movl   $0x106ee1,0xc(%esp)
  103e58:	00 
  103e59:	c7 44 24 08 4d 6c 10 	movl   $0x106c4d,0x8(%esp)
  103e60:	00 
  103e61:	c7 44 24 04 f8 01 00 	movl   $0x1f8,0x4(%esp)
  103e68:	00 
  103e69:	c7 04 24 28 6c 10 00 	movl   $0x106c28,(%esp)
  103e70:	e8 7d c5 ff ff       	call   1003f2 <__panic>
    assert(page_ref(p2) == 0);
  103e75:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103e78:	89 04 24             	mov    %eax,(%esp)
  103e7b:	e8 99 ef ff ff       	call   102e19 <page_ref>
  103e80:	85 c0                	test   %eax,%eax
  103e82:	74 24                	je     103ea8 <check_pgdir+0x623>
  103e84:	c7 44 24 0c ba 6e 10 	movl   $0x106eba,0xc(%esp)
  103e8b:	00 
  103e8c:	c7 44 24 08 4d 6c 10 	movl   $0x106c4d,0x8(%esp)
  103e93:	00 
  103e94:	c7 44 24 04 f9 01 00 	movl   $0x1f9,0x4(%esp)
  103e9b:	00 
  103e9c:	c7 04 24 28 6c 10 00 	movl   $0x106c28,(%esp)
  103ea3:	e8 4a c5 ff ff       	call   1003f2 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
  103ea8:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103ead:	8b 00                	mov    (%eax),%eax
  103eaf:	89 04 24             	mov    %eax,(%esp)
  103eb2:	e8 4a ef ff ff       	call   102e01 <pde2page>
  103eb7:	89 04 24             	mov    %eax,(%esp)
  103eba:	e8 5a ef ff ff       	call   102e19 <page_ref>
  103ebf:	83 f8 01             	cmp    $0x1,%eax
  103ec2:	74 24                	je     103ee8 <check_pgdir+0x663>
  103ec4:	c7 44 24 0c f4 6e 10 	movl   $0x106ef4,0xc(%esp)
  103ecb:	00 
  103ecc:	c7 44 24 08 4d 6c 10 	movl   $0x106c4d,0x8(%esp)
  103ed3:	00 
  103ed4:	c7 44 24 04 fb 01 00 	movl   $0x1fb,0x4(%esp)
  103edb:	00 
  103edc:	c7 04 24 28 6c 10 00 	movl   $0x106c28,(%esp)
  103ee3:	e8 0a c5 ff ff       	call   1003f2 <__panic>
    free_page(pde2page(boot_pgdir[0]));
  103ee8:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103eed:	8b 00                	mov    (%eax),%eax
  103eef:	89 04 24             	mov    %eax,(%esp)
  103ef2:	e8 0a ef ff ff       	call   102e01 <pde2page>
  103ef7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103efe:	00 
  103eff:	89 04 24             	mov    %eax,(%esp)
  103f02:	e8 41 f1 ff ff       	call   103048 <free_pages>
    boot_pgdir[0] = 0;
  103f07:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103f0c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  103f12:	c7 04 24 1b 6f 10 00 	movl   $0x106f1b,(%esp)
  103f19:	e8 7c c3 ff ff       	call   10029a <cprintf>
}
  103f1e:	90                   	nop
  103f1f:	c9                   	leave  
  103f20:	c3                   	ret    

00103f21 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  103f21:	55                   	push   %ebp
  103f22:	89 e5                	mov    %esp,%ebp
  103f24:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  103f27:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103f2e:	e9 ca 00 00 00       	jmp    103ffd <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  103f33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103f36:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103f39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103f3c:	c1 e8 0c             	shr    $0xc,%eax
  103f3f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103f42:	a1 a0 ce 11 00       	mov    0x11cea0,%eax
  103f47:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  103f4a:	72 23                	jb     103f6f <check_boot_pgdir+0x4e>
  103f4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103f4f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103f53:	c7 44 24 08 60 6b 10 	movl   $0x106b60,0x8(%esp)
  103f5a:	00 
  103f5b:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
  103f62:	00 
  103f63:	c7 04 24 28 6c 10 00 	movl   $0x106c28,(%esp)
  103f6a:	e8 83 c4 ff ff       	call   1003f2 <__panic>
  103f6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103f72:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103f77:	89 c2                	mov    %eax,%edx
  103f79:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103f7e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103f85:	00 
  103f86:	89 54 24 04          	mov    %edx,0x4(%esp)
  103f8a:	89 04 24             	mov    %eax,(%esp)
  103f8d:	e8 15 f7 ff ff       	call   1036a7 <get_pte>
  103f92:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103f95:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103f99:	75 24                	jne    103fbf <check_boot_pgdir+0x9e>
  103f9b:	c7 44 24 0c 38 6f 10 	movl   $0x106f38,0xc(%esp)
  103fa2:	00 
  103fa3:	c7 44 24 08 4d 6c 10 	movl   $0x106c4d,0x8(%esp)
  103faa:	00 
  103fab:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
  103fb2:	00 
  103fb3:	c7 04 24 28 6c 10 00 	movl   $0x106c28,(%esp)
  103fba:	e8 33 c4 ff ff       	call   1003f2 <__panic>
        assert(PTE_ADDR(*ptep) == i);
  103fbf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103fc2:	8b 00                	mov    (%eax),%eax
  103fc4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103fc9:	89 c2                	mov    %eax,%edx
  103fcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103fce:	39 c2                	cmp    %eax,%edx
  103fd0:	74 24                	je     103ff6 <check_boot_pgdir+0xd5>
  103fd2:	c7 44 24 0c 75 6f 10 	movl   $0x106f75,0xc(%esp)
  103fd9:	00 
  103fda:	c7 44 24 08 4d 6c 10 	movl   $0x106c4d,0x8(%esp)
  103fe1:	00 
  103fe2:	c7 44 24 04 08 02 00 	movl   $0x208,0x4(%esp)
  103fe9:	00 
  103fea:	c7 04 24 28 6c 10 00 	movl   $0x106c28,(%esp)
  103ff1:	e8 fc c3 ff ff       	call   1003f2 <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
  103ff6:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  103ffd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104000:	a1 a0 ce 11 00       	mov    0x11cea0,%eax
  104005:	39 c2                	cmp    %eax,%edx
  104007:	0f 82 26 ff ff ff    	jb     103f33 <check_boot_pgdir+0x12>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  10400d:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104012:	05 ac 0f 00 00       	add    $0xfac,%eax
  104017:	8b 00                	mov    (%eax),%eax
  104019:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10401e:	89 c2                	mov    %eax,%edx
  104020:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104025:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104028:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
  10402f:	77 23                	ja     104054 <check_boot_pgdir+0x133>
  104031:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104034:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104038:	c7 44 24 08 04 6c 10 	movl   $0x106c04,0x8(%esp)
  10403f:	00 
  104040:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
  104047:	00 
  104048:	c7 04 24 28 6c 10 00 	movl   $0x106c28,(%esp)
  10404f:	e8 9e c3 ff ff       	call   1003f2 <__panic>
  104054:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104057:	05 00 00 00 40       	add    $0x40000000,%eax
  10405c:	39 d0                	cmp    %edx,%eax
  10405e:	74 24                	je     104084 <check_boot_pgdir+0x163>
  104060:	c7 44 24 0c 8c 6f 10 	movl   $0x106f8c,0xc(%esp)
  104067:	00 
  104068:	c7 44 24 08 4d 6c 10 	movl   $0x106c4d,0x8(%esp)
  10406f:	00 
  104070:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
  104077:	00 
  104078:	c7 04 24 28 6c 10 00 	movl   $0x106c28,(%esp)
  10407f:	e8 6e c3 ff ff       	call   1003f2 <__panic>

    assert(boot_pgdir[0] == 0);
  104084:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104089:	8b 00                	mov    (%eax),%eax
  10408b:	85 c0                	test   %eax,%eax
  10408d:	74 24                	je     1040b3 <check_boot_pgdir+0x192>
  10408f:	c7 44 24 0c c0 6f 10 	movl   $0x106fc0,0xc(%esp)
  104096:	00 
  104097:	c7 44 24 08 4d 6c 10 	movl   $0x106c4d,0x8(%esp)
  10409e:	00 
  10409f:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
  1040a6:	00 
  1040a7:	c7 04 24 28 6c 10 00 	movl   $0x106c28,(%esp)
  1040ae:	e8 3f c3 ff ff       	call   1003f2 <__panic>

    struct Page *p;
    p = alloc_page();
  1040b3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1040ba:	e8 51 ef ff ff       	call   103010 <alloc_pages>
  1040bf:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  1040c2:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  1040c7:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  1040ce:	00 
  1040cf:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  1040d6:	00 
  1040d7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1040da:	89 54 24 04          	mov    %edx,0x4(%esp)
  1040de:	89 04 24             	mov    %eax,(%esp)
  1040e1:	e8 6b f6 ff ff       	call   103751 <page_insert>
  1040e6:	85 c0                	test   %eax,%eax
  1040e8:	74 24                	je     10410e <check_boot_pgdir+0x1ed>
  1040ea:	c7 44 24 0c d4 6f 10 	movl   $0x106fd4,0xc(%esp)
  1040f1:	00 
  1040f2:	c7 44 24 08 4d 6c 10 	movl   $0x106c4d,0x8(%esp)
  1040f9:	00 
  1040fa:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
  104101:	00 
  104102:	c7 04 24 28 6c 10 00 	movl   $0x106c28,(%esp)
  104109:	e8 e4 c2 ff ff       	call   1003f2 <__panic>
    assert(page_ref(p) == 1);
  10410e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104111:	89 04 24             	mov    %eax,(%esp)
  104114:	e8 00 ed ff ff       	call   102e19 <page_ref>
  104119:	83 f8 01             	cmp    $0x1,%eax
  10411c:	74 24                	je     104142 <check_boot_pgdir+0x221>
  10411e:	c7 44 24 0c 02 70 10 	movl   $0x107002,0xc(%esp)
  104125:	00 
  104126:	c7 44 24 08 4d 6c 10 	movl   $0x106c4d,0x8(%esp)
  10412d:	00 
  10412e:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
  104135:	00 
  104136:	c7 04 24 28 6c 10 00 	movl   $0x106c28,(%esp)
  10413d:	e8 b0 c2 ff ff       	call   1003f2 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  104142:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104147:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  10414e:	00 
  10414f:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  104156:	00 
  104157:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10415a:	89 54 24 04          	mov    %edx,0x4(%esp)
  10415e:	89 04 24             	mov    %eax,(%esp)
  104161:	e8 eb f5 ff ff       	call   103751 <page_insert>
  104166:	85 c0                	test   %eax,%eax
  104168:	74 24                	je     10418e <check_boot_pgdir+0x26d>
  10416a:	c7 44 24 0c 14 70 10 	movl   $0x107014,0xc(%esp)
  104171:	00 
  104172:	c7 44 24 08 4d 6c 10 	movl   $0x106c4d,0x8(%esp)
  104179:	00 
  10417a:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
  104181:	00 
  104182:	c7 04 24 28 6c 10 00 	movl   $0x106c28,(%esp)
  104189:	e8 64 c2 ff ff       	call   1003f2 <__panic>
    assert(page_ref(p) == 2);
  10418e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104191:	89 04 24             	mov    %eax,(%esp)
  104194:	e8 80 ec ff ff       	call   102e19 <page_ref>
  104199:	83 f8 02             	cmp    $0x2,%eax
  10419c:	74 24                	je     1041c2 <check_boot_pgdir+0x2a1>
  10419e:	c7 44 24 0c 4b 70 10 	movl   $0x10704b,0xc(%esp)
  1041a5:	00 
  1041a6:	c7 44 24 08 4d 6c 10 	movl   $0x106c4d,0x8(%esp)
  1041ad:	00 
  1041ae:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
  1041b5:	00 
  1041b6:	c7 04 24 28 6c 10 00 	movl   $0x106c28,(%esp)
  1041bd:	e8 30 c2 ff ff       	call   1003f2 <__panic>

    const char *str = "ucore: Hello world!!";
  1041c2:	c7 45 dc 5c 70 10 00 	movl   $0x10705c,-0x24(%ebp)
    strcpy((void *)0x100, str);
  1041c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1041cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  1041d0:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1041d7:	e8 62 17 00 00       	call   10593e <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  1041dc:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  1041e3:	00 
  1041e4:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1041eb:	e8 c5 17 00 00       	call   1059b5 <strcmp>
  1041f0:	85 c0                	test   %eax,%eax
  1041f2:	74 24                	je     104218 <check_boot_pgdir+0x2f7>
  1041f4:	c7 44 24 0c 74 70 10 	movl   $0x107074,0xc(%esp)
  1041fb:	00 
  1041fc:	c7 44 24 08 4d 6c 10 	movl   $0x106c4d,0x8(%esp)
  104203:	00 
  104204:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
  10420b:	00 
  10420c:	c7 04 24 28 6c 10 00 	movl   $0x106c28,(%esp)
  104213:	e8 da c1 ff ff       	call   1003f2 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  104218:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10421b:	89 04 24             	mov    %eax,(%esp)
  10421e:	e8 4c eb ff ff       	call   102d6f <page2kva>
  104223:	05 00 01 00 00       	add    $0x100,%eax
  104228:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  10422b:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  104232:	e8 b1 16 00 00       	call   1058e8 <strlen>
  104237:	85 c0                	test   %eax,%eax
  104239:	74 24                	je     10425f <check_boot_pgdir+0x33e>
  10423b:	c7 44 24 0c ac 70 10 	movl   $0x1070ac,0xc(%esp)
  104242:	00 
  104243:	c7 44 24 08 4d 6c 10 	movl   $0x106c4d,0x8(%esp)
  10424a:	00 
  10424b:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
  104252:	00 
  104253:	c7 04 24 28 6c 10 00 	movl   $0x106c28,(%esp)
  10425a:	e8 93 c1 ff ff       	call   1003f2 <__panic>

    free_page(p);
  10425f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104266:	00 
  104267:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10426a:	89 04 24             	mov    %eax,(%esp)
  10426d:	e8 d6 ed ff ff       	call   103048 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
  104272:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104277:	8b 00                	mov    (%eax),%eax
  104279:	89 04 24             	mov    %eax,(%esp)
  10427c:	e8 80 eb ff ff       	call   102e01 <pde2page>
  104281:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104288:	00 
  104289:	89 04 24             	mov    %eax,(%esp)
  10428c:	e8 b7 ed ff ff       	call   103048 <free_pages>
    boot_pgdir[0] = 0;
  104291:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104296:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  10429c:	c7 04 24 d0 70 10 00 	movl   $0x1070d0,(%esp)
  1042a3:	e8 f2 bf ff ff       	call   10029a <cprintf>
}
  1042a8:	90                   	nop
  1042a9:	c9                   	leave  
  1042aa:	c3                   	ret    

001042ab <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  1042ab:	55                   	push   %ebp
  1042ac:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  1042ae:	8b 45 08             	mov    0x8(%ebp),%eax
  1042b1:	83 e0 04             	and    $0x4,%eax
  1042b4:	85 c0                	test   %eax,%eax
  1042b6:	74 04                	je     1042bc <perm2str+0x11>
  1042b8:	b0 75                	mov    $0x75,%al
  1042ba:	eb 02                	jmp    1042be <perm2str+0x13>
  1042bc:	b0 2d                	mov    $0x2d,%al
  1042be:	a2 28 cf 11 00       	mov    %al,0x11cf28
    str[1] = 'r';
  1042c3:	c6 05 29 cf 11 00 72 	movb   $0x72,0x11cf29
    str[2] = (perm & PTE_W) ? 'w' : '-';
  1042ca:	8b 45 08             	mov    0x8(%ebp),%eax
  1042cd:	83 e0 02             	and    $0x2,%eax
  1042d0:	85 c0                	test   %eax,%eax
  1042d2:	74 04                	je     1042d8 <perm2str+0x2d>
  1042d4:	b0 77                	mov    $0x77,%al
  1042d6:	eb 02                	jmp    1042da <perm2str+0x2f>
  1042d8:	b0 2d                	mov    $0x2d,%al
  1042da:	a2 2a cf 11 00       	mov    %al,0x11cf2a
    str[3] = '\0';
  1042df:	c6 05 2b cf 11 00 00 	movb   $0x0,0x11cf2b
    return str;
  1042e6:	b8 28 cf 11 00       	mov    $0x11cf28,%eax
}
  1042eb:	5d                   	pop    %ebp
  1042ec:	c3                   	ret    

001042ed <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  1042ed:	55                   	push   %ebp
  1042ee:	89 e5                	mov    %esp,%ebp
  1042f0:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  1042f3:	8b 45 10             	mov    0x10(%ebp),%eax
  1042f6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1042f9:	72 0d                	jb     104308 <get_pgtable_items+0x1b>
        return 0;
  1042fb:	b8 00 00 00 00       	mov    $0x0,%eax
  104300:	e9 98 00 00 00       	jmp    10439d <get_pgtable_items+0xb0>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
  104305:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
  104308:	8b 45 10             	mov    0x10(%ebp),%eax
  10430b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10430e:	73 18                	jae    104328 <get_pgtable_items+0x3b>
  104310:	8b 45 10             	mov    0x10(%ebp),%eax
  104313:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10431a:	8b 45 14             	mov    0x14(%ebp),%eax
  10431d:	01 d0                	add    %edx,%eax
  10431f:	8b 00                	mov    (%eax),%eax
  104321:	83 e0 01             	and    $0x1,%eax
  104324:	85 c0                	test   %eax,%eax
  104326:	74 dd                	je     104305 <get_pgtable_items+0x18>
    }
    if (start < right) {
  104328:	8b 45 10             	mov    0x10(%ebp),%eax
  10432b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10432e:	73 68                	jae    104398 <get_pgtable_items+0xab>
        if (left_store != NULL) {
  104330:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  104334:	74 08                	je     10433e <get_pgtable_items+0x51>
            *left_store = start;
  104336:	8b 45 18             	mov    0x18(%ebp),%eax
  104339:	8b 55 10             	mov    0x10(%ebp),%edx
  10433c:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  10433e:	8b 45 10             	mov    0x10(%ebp),%eax
  104341:	8d 50 01             	lea    0x1(%eax),%edx
  104344:	89 55 10             	mov    %edx,0x10(%ebp)
  104347:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10434e:	8b 45 14             	mov    0x14(%ebp),%eax
  104351:	01 d0                	add    %edx,%eax
  104353:	8b 00                	mov    (%eax),%eax
  104355:	83 e0 07             	and    $0x7,%eax
  104358:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  10435b:	eb 03                	jmp    104360 <get_pgtable_items+0x73>
            start ++;
  10435d:	ff 45 10             	incl   0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  104360:	8b 45 10             	mov    0x10(%ebp),%eax
  104363:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104366:	73 1d                	jae    104385 <get_pgtable_items+0x98>
  104368:	8b 45 10             	mov    0x10(%ebp),%eax
  10436b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  104372:	8b 45 14             	mov    0x14(%ebp),%eax
  104375:	01 d0                	add    %edx,%eax
  104377:	8b 00                	mov    (%eax),%eax
  104379:	83 e0 07             	and    $0x7,%eax
  10437c:	89 c2                	mov    %eax,%edx
  10437e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104381:	39 c2                	cmp    %eax,%edx
  104383:	74 d8                	je     10435d <get_pgtable_items+0x70>
        }
        if (right_store != NULL) {
  104385:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  104389:	74 08                	je     104393 <get_pgtable_items+0xa6>
            *right_store = start;
  10438b:	8b 45 1c             	mov    0x1c(%ebp),%eax
  10438e:	8b 55 10             	mov    0x10(%ebp),%edx
  104391:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  104393:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104396:	eb 05                	jmp    10439d <get_pgtable_items+0xb0>
    }
    return 0;
  104398:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10439d:	c9                   	leave  
  10439e:	c3                   	ret    

0010439f <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  10439f:	55                   	push   %ebp
  1043a0:	89 e5                	mov    %esp,%ebp
  1043a2:	57                   	push   %edi
  1043a3:	56                   	push   %esi
  1043a4:	53                   	push   %ebx
  1043a5:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  1043a8:	c7 04 24 f0 70 10 00 	movl   $0x1070f0,(%esp)
  1043af:	e8 e6 be ff ff       	call   10029a <cprintf>
    size_t left, right = 0, perm;
  1043b4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  1043bb:	e9 fa 00 00 00       	jmp    1044ba <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  1043c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1043c3:	89 04 24             	mov    %eax,(%esp)
  1043c6:	e8 e0 fe ff ff       	call   1042ab <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  1043cb:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1043ce:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1043d1:	29 d1                	sub    %edx,%ecx
  1043d3:	89 ca                	mov    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  1043d5:	89 d6                	mov    %edx,%esi
  1043d7:	c1 e6 16             	shl    $0x16,%esi
  1043da:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1043dd:	89 d3                	mov    %edx,%ebx
  1043df:	c1 e3 16             	shl    $0x16,%ebx
  1043e2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1043e5:	89 d1                	mov    %edx,%ecx
  1043e7:	c1 e1 16             	shl    $0x16,%ecx
  1043ea:	8b 7d dc             	mov    -0x24(%ebp),%edi
  1043ed:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1043f0:	29 d7                	sub    %edx,%edi
  1043f2:	89 fa                	mov    %edi,%edx
  1043f4:	89 44 24 14          	mov    %eax,0x14(%esp)
  1043f8:	89 74 24 10          	mov    %esi,0x10(%esp)
  1043fc:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  104400:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  104404:	89 54 24 04          	mov    %edx,0x4(%esp)
  104408:	c7 04 24 21 71 10 00 	movl   $0x107121,(%esp)
  10440f:	e8 86 be ff ff       	call   10029a <cprintf>
        size_t l, r = left * NPTEENTRY;
  104414:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104417:	c1 e0 0a             	shl    $0xa,%eax
  10441a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  10441d:	eb 54                	jmp    104473 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  10441f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104422:	89 04 24             	mov    %eax,(%esp)
  104425:	e8 81 fe ff ff       	call   1042ab <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  10442a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  10442d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  104430:	29 d1                	sub    %edx,%ecx
  104432:	89 ca                	mov    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  104434:	89 d6                	mov    %edx,%esi
  104436:	c1 e6 0c             	shl    $0xc,%esi
  104439:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10443c:	89 d3                	mov    %edx,%ebx
  10443e:	c1 e3 0c             	shl    $0xc,%ebx
  104441:	8b 55 d8             	mov    -0x28(%ebp),%edx
  104444:	89 d1                	mov    %edx,%ecx
  104446:	c1 e1 0c             	shl    $0xc,%ecx
  104449:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  10444c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10444f:	29 d7                	sub    %edx,%edi
  104451:	89 fa                	mov    %edi,%edx
  104453:	89 44 24 14          	mov    %eax,0x14(%esp)
  104457:	89 74 24 10          	mov    %esi,0x10(%esp)
  10445b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  10445f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  104463:	89 54 24 04          	mov    %edx,0x4(%esp)
  104467:	c7 04 24 40 71 10 00 	movl   $0x107140,(%esp)
  10446e:	e8 27 be ff ff       	call   10029a <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  104473:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
  104478:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10447b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10447e:	89 d3                	mov    %edx,%ebx
  104480:	c1 e3 0a             	shl    $0xa,%ebx
  104483:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104486:	89 d1                	mov    %edx,%ecx
  104488:	c1 e1 0a             	shl    $0xa,%ecx
  10448b:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  10448e:	89 54 24 14          	mov    %edx,0x14(%esp)
  104492:	8d 55 d8             	lea    -0x28(%ebp),%edx
  104495:	89 54 24 10          	mov    %edx,0x10(%esp)
  104499:	89 74 24 0c          	mov    %esi,0xc(%esp)
  10449d:	89 44 24 08          	mov    %eax,0x8(%esp)
  1044a1:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1044a5:	89 0c 24             	mov    %ecx,(%esp)
  1044a8:	e8 40 fe ff ff       	call   1042ed <get_pgtable_items>
  1044ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1044b0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1044b4:	0f 85 65 ff ff ff    	jne    10441f <print_pgdir+0x80>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  1044ba:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
  1044bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1044c2:	8d 55 dc             	lea    -0x24(%ebp),%edx
  1044c5:	89 54 24 14          	mov    %edx,0x14(%esp)
  1044c9:	8d 55 e0             	lea    -0x20(%ebp),%edx
  1044cc:	89 54 24 10          	mov    %edx,0x10(%esp)
  1044d0:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1044d4:	89 44 24 08          	mov    %eax,0x8(%esp)
  1044d8:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  1044df:	00 
  1044e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1044e7:	e8 01 fe ff ff       	call   1042ed <get_pgtable_items>
  1044ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1044ef:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1044f3:	0f 85 c7 fe ff ff    	jne    1043c0 <print_pgdir+0x21>
        }
    }
    cprintf("--------------------- END ---------------------\n");
  1044f9:	c7 04 24 64 71 10 00 	movl   $0x107164,(%esp)
  104500:	e8 95 bd ff ff       	call   10029a <cprintf>
}
  104505:	90                   	nop
  104506:	83 c4 4c             	add    $0x4c,%esp
  104509:	5b                   	pop    %ebx
  10450a:	5e                   	pop    %esi
  10450b:	5f                   	pop    %edi
  10450c:	5d                   	pop    %ebp
  10450d:	c3                   	ret    

0010450e <page2ppn>:
page2ppn(struct Page *page) {
  10450e:	55                   	push   %ebp
  10450f:	89 e5                	mov    %esp,%ebp
    return page - pages;
  104511:	a1 38 cf 11 00       	mov    0x11cf38,%eax
  104516:	8b 55 08             	mov    0x8(%ebp),%edx
  104519:	29 c2                	sub    %eax,%edx
  10451b:	89 d0                	mov    %edx,%eax
  10451d:	c1 f8 02             	sar    $0x2,%eax
  104520:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  104526:	5d                   	pop    %ebp
  104527:	c3                   	ret    

00104528 <page2pa>:
page2pa(struct Page *page) {
  104528:	55                   	push   %ebp
  104529:	89 e5                	mov    %esp,%ebp
  10452b:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  10452e:	8b 45 08             	mov    0x8(%ebp),%eax
  104531:	89 04 24             	mov    %eax,(%esp)
  104534:	e8 d5 ff ff ff       	call   10450e <page2ppn>
  104539:	c1 e0 0c             	shl    $0xc,%eax
}
  10453c:	c9                   	leave  
  10453d:	c3                   	ret    

0010453e <page_ref>:
page_ref(struct Page *page) {
  10453e:	55                   	push   %ebp
  10453f:	89 e5                	mov    %esp,%ebp
    return page->ref;
  104541:	8b 45 08             	mov    0x8(%ebp),%eax
  104544:	8b 00                	mov    (%eax),%eax
}
  104546:	5d                   	pop    %ebp
  104547:	c3                   	ret    

00104548 <set_page_ref>:
set_page_ref(struct Page *page, int val) {
  104548:	55                   	push   %ebp
  104549:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  10454b:	8b 45 08             	mov    0x8(%ebp),%eax
  10454e:	8b 55 0c             	mov    0xc(%ebp),%edx
  104551:	89 10                	mov    %edx,(%eax)
}
  104553:	90                   	nop
  104554:	5d                   	pop    %ebp
  104555:	c3                   	ret    

00104556 <default_init>:

/* tail of free_list */
static list_entry_t *tail = &free_list;

static void
default_init(void) {
  104556:	55                   	push   %ebp
  104557:	89 e5                	mov    %esp,%ebp
  104559:	83 ec 10             	sub    $0x10,%esp
  10455c:	c7 45 fc 3c cf 11 00 	movl   $0x11cf3c,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  104563:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104566:	8b 55 fc             	mov    -0x4(%ebp),%edx
  104569:	89 50 04             	mov    %edx,0x4(%eax)
  10456c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10456f:	8b 50 04             	mov    0x4(%eax),%edx
  104572:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104575:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
  104577:	c7 05 44 cf 11 00 00 	movl   $0x0,0x11cf44
  10457e:	00 00 00 
}
  104581:	90                   	nop
  104582:	c9                   	leave  
  104583:	c3                   	ret    

00104584 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
  104584:	55                   	push   %ebp
  104585:	89 e5                	mov    %esp,%ebp
  104587:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
  10458a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10458e:	75 24                	jne    1045b4 <default_init_memmap+0x30>
  104590:	c7 44 24 0c 98 71 10 	movl   $0x107198,0xc(%esp)
  104597:	00 
  104598:	c7 44 24 08 9e 71 10 	movl   $0x10719e,0x8(%esp)
  10459f:	00 
  1045a0:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
  1045a7:	00 
  1045a8:	c7 04 24 b3 71 10 00 	movl   $0x1071b3,(%esp)
  1045af:	e8 3e be ff ff       	call   1003f2 <__panic>
    struct Page *p = base;
  1045b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1045b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  1045ba:	e9 b3 00 00 00       	jmp    104672 <default_init_memmap+0xee>
		// 在查找可用内存并分配struct Page数组时就已经将将全部Page设置为Reserved
		// 将Page标记为可用的:清除Reserved,设置Property,并把property设置为0( 不是空闲块的第一个物理页 )
        assert(PageReserved(p));
  1045bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045c2:	83 c0 04             	add    $0x4,%eax
  1045c5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  1045cc:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1045cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1045d2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1045d5:	0f a3 10             	bt     %edx,(%eax)
  1045d8:	19 c0                	sbb    %eax,%eax
  1045da:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  1045dd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1045e1:	0f 95 c0             	setne  %al
  1045e4:	0f b6 c0             	movzbl %al,%eax
  1045e7:	85 c0                	test   %eax,%eax
  1045e9:	75 24                	jne    10460f <default_init_memmap+0x8b>
  1045eb:	c7 44 24 0c c9 71 10 	movl   $0x1071c9,0xc(%esp)
  1045f2:	00 
  1045f3:	c7 44 24 08 9e 71 10 	movl   $0x10719e,0x8(%esp)
  1045fa:	00 
  1045fb:	c7 44 24 04 76 00 00 	movl   $0x76,0x4(%esp)
  104602:	00 
  104603:	c7 04 24 b3 71 10 00 	movl   $0x1071b3,(%esp)
  10460a:	e8 e3 bd ff ff       	call   1003f2 <__panic>
        p->flags = p->property = 0;
  10460f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104612:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  104619:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10461c:	8b 50 08             	mov    0x8(%eax),%edx
  10461f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104622:	89 50 04             	mov    %edx,0x4(%eax)
		SetPageProperty(p);
  104625:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104628:	83 c0 04             	add    $0x4,%eax
  10462b:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  104632:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104635:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104638:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10463b:	0f ab 10             	bts    %edx,(%eax)
        set_page_ref(p, 0);
  10463e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104645:	00 
  104646:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104649:	89 04 24             	mov    %eax,(%esp)
  10464c:	e8 f7 fe ff ff       	call   104548 <set_page_ref>
		list_init(&(p->page_link));
  104651:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104654:	83 c0 0c             	add    $0xc,%eax
  104657:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10465a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10465d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104660:	89 50 04             	mov    %edx,0x4(%eax)
  104663:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104666:	8b 50 04             	mov    0x4(%eax),%edx
  104669:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10466c:	89 10                	mov    %edx,(%eax)
    for (; p != base + n; p ++) {
  10466e:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  104672:	8b 55 0c             	mov    0xc(%ebp),%edx
  104675:	89 d0                	mov    %edx,%eax
  104677:	c1 e0 02             	shl    $0x2,%eax
  10467a:	01 d0                	add    %edx,%eax
  10467c:	c1 e0 02             	shl    $0x2,%eax
  10467f:	89 c2                	mov    %eax,%edx
  104681:	8b 45 08             	mov    0x8(%ebp),%eax
  104684:	01 d0                	add    %edx,%eax
  104686:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104689:	0f 85 30 ff ff ff    	jne    1045bf <default_init_memmap+0x3b>
    }
	cprintf("Page address is %x\n", (uintptr_t)base);
  10468f:	8b 45 08             	mov    0x8(%ebp),%eax
  104692:	89 44 24 04          	mov    %eax,0x4(%esp)
  104696:	c7 04 24 d9 71 10 00 	movl   $0x1071d9,(%esp)
  10469d:	e8 f8 bb ff ff       	call   10029a <cprintf>
    base->property = n;
  1046a2:	8b 45 08             	mov    0x8(%ebp),%eax
  1046a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  1046a8:	89 50 08             	mov    %edx,0x8(%eax)
    nr_free += n;
  1046ab:	8b 15 44 cf 11 00    	mov    0x11cf44,%edx
  1046b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1046b4:	01 d0                	add    %edx,%eax
  1046b6:	a3 44 cf 11 00       	mov    %eax,0x11cf44
	assert(tail == &free_list);
  1046bb:	a1 38 9a 11 00       	mov    0x119a38,%eax
  1046c0:	3d 3c cf 11 00       	cmp    $0x11cf3c,%eax
  1046c5:	74 24                	je     1046eb <default_init_memmap+0x167>
  1046c7:	c7 44 24 0c ed 71 10 	movl   $0x1071ed,0xc(%esp)
  1046ce:	00 
  1046cf:	c7 44 24 08 9e 71 10 	movl   $0x10719e,0x8(%esp)
  1046d6:	00 
  1046d7:	c7 44 24 04 7f 00 00 	movl   $0x7f,0x4(%esp)
  1046de:	00 
  1046df:	c7 04 24 b3 71 10 00 	movl   $0x1071b3,(%esp)
  1046e6:	e8 07 bd ff ff       	call   1003f2 <__panic>
	assert(tail != &(base->page_link));
  1046eb:	8b 45 08             	mov    0x8(%ebp),%eax
  1046ee:	8d 50 0c             	lea    0xc(%eax),%edx
  1046f1:	a1 38 9a 11 00       	mov    0x119a38,%eax
  1046f6:	39 c2                	cmp    %eax,%edx
  1046f8:	75 24                	jne    10471e <default_init_memmap+0x19a>
  1046fa:	c7 44 24 0c 00 72 10 	movl   $0x107200,0xc(%esp)
  104701:	00 
  104702:	c7 44 24 08 9e 71 10 	movl   $0x10719e,0x8(%esp)
  104709:	00 
  10470a:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
  104711:	00 
  104712:	c7 04 24 b3 71 10 00 	movl   $0x1071b3,(%esp)
  104719:	e8 d4 bc ff ff       	call   1003f2 <__panic>
    list_add(tail, &(base->page_link));
  10471e:	8b 45 08             	mov    0x8(%ebp),%eax
  104721:	8d 50 0c             	lea    0xc(%eax),%edx
  104724:	a1 38 9a 11 00       	mov    0x119a38,%eax
  104729:	89 45 d8             	mov    %eax,-0x28(%ebp)
  10472c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  10472f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104732:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104735:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104738:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  10473b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10473e:	8b 40 04             	mov    0x4(%eax),%eax
  104741:	8b 55 cc             	mov    -0x34(%ebp),%edx
  104744:	89 55 c8             	mov    %edx,-0x38(%ebp)
  104747:	8b 55 d0             	mov    -0x30(%ebp),%edx
  10474a:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  10474d:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  104750:	8b 45 c0             	mov    -0x40(%ebp),%eax
  104753:	8b 55 c8             	mov    -0x38(%ebp),%edx
  104756:	89 10                	mov    %edx,(%eax)
  104758:	8b 45 c0             	mov    -0x40(%ebp),%eax
  10475b:	8b 10                	mov    (%eax),%edx
  10475d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104760:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  104763:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104766:	8b 55 c0             	mov    -0x40(%ebp),%edx
  104769:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  10476c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  10476f:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  104772:	89 10                	mov    %edx,(%eax)
	tail = tail->next;
  104774:	a1 38 9a 11 00       	mov    0x119a38,%eax
  104779:	8b 40 04             	mov    0x4(%eax),%eax
  10477c:	a3 38 9a 11 00       	mov    %eax,0x119a38
}
  104781:	90                   	nop
  104782:	c9                   	leave  
  104783:	c3                   	ret    

00104784 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
  104784:	55                   	push   %ebp
  104785:	89 e5                	mov    %esp,%ebp
  104787:	83 ec 78             	sub    $0x78,%esp
    assert(n > 0);
  10478a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10478e:	75 24                	jne    1047b4 <default_alloc_pages+0x30>
  104790:	c7 44 24 0c 98 71 10 	movl   $0x107198,0xc(%esp)
  104797:	00 
  104798:	c7 44 24 08 9e 71 10 	movl   $0x10719e,0x8(%esp)
  10479f:	00 
  1047a0:	c7 44 24 04 87 00 00 	movl   $0x87,0x4(%esp)
  1047a7:	00 
  1047a8:	c7 04 24 b3 71 10 00 	movl   $0x1071b3,(%esp)
  1047af:	e8 3e bc ff ff       	call   1003f2 <__panic>
	/* There are not enough physical memory */
    if (n > nr_free) {
  1047b4:	a1 44 cf 11 00       	mov    0x11cf44,%eax
  1047b9:	39 45 08             	cmp    %eax,0x8(%ebp)
  1047bc:	76 26                	jbe    1047e4 <default_alloc_pages+0x60>
		warn("memory shortage");
  1047be:	c7 44 24 08 1b 72 10 	movl   $0x10721b,0x8(%esp)
  1047c5:	00 
  1047c6:	c7 44 24 04 8a 00 00 	movl   $0x8a,0x4(%esp)
  1047cd:	00 
  1047ce:	c7 04 24 b3 71 10 00 	movl   $0x1071b3,(%esp)
  1047d5:	e8 96 bc ff ff       	call   100470 <__warn>
        return NULL;
  1047da:	b8 00 00 00 00       	mov    $0x0,%eax
  1047df:	e9 d6 01 00 00       	jmp    1049ba <default_alloc_pages+0x236>
    }
    struct Page *page = NULL;
  1047e4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
  1047eb:	c7 45 f0 3c cf 11 00 	movl   $0x11cf3c,-0x10(%ebp)
	/* try to find empty space to allocate */
    while ((le = list_next(le)) != &free_list) {
  1047f2:	eb 1c                	jmp    104810 <default_alloc_pages+0x8c>
        struct Page *p = le2page(le, page_link);
  1047f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1047f7:	83 e8 0c             	sub    $0xc,%eax
  1047fa:	89 45 e8             	mov    %eax,-0x18(%ebp)
        if (p->property >= n) {
  1047fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104800:	8b 40 08             	mov    0x8(%eax),%eax
  104803:	39 45 08             	cmp    %eax,0x8(%ebp)
  104806:	77 08                	ja     104810 <default_alloc_pages+0x8c>
            page = p;
  104808:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10480b:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  10480e:	eb 18                	jmp    104828 <default_alloc_pages+0xa4>
  104810:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104813:	89 45 dc             	mov    %eax,-0x24(%ebp)
    return listelm->next;
  104816:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104819:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  10481c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10481f:	81 7d f0 3c cf 11 00 	cmpl   $0x11cf3c,-0x10(%ebp)
  104826:	75 cc                	jne    1047f4 <default_alloc_pages+0x70>
        }
    }
	/* external fragmentation */
	if (page == NULL) {
  104828:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10482c:	75 26                	jne    104854 <default_alloc_pages+0xd0>
		warn("external fragmentation: There are enough memory, but can't find continuous space to allocate");
  10482e:	c7 44 24 08 2c 72 10 	movl   $0x10722c,0x8(%esp)
  104835:	00 
  104836:	c7 44 24 04 99 00 00 	movl   $0x99,0x4(%esp)
  10483d:	00 
  10483e:	c7 04 24 b3 71 10 00 	movl   $0x1071b3,(%esp)
  104845:	e8 26 bc ff ff       	call   100470 <__warn>
		return NULL;
  10484a:	b8 00 00 00 00       	mov    $0x0,%eax
  10484f:	e9 66 01 00 00       	jmp    1049ba <default_alloc_pages+0x236>
	}
	/* There are enough space to allocate.
	 * If block size is bigger than requested size, split it;
	 * If block size is equal to requested size, just delte it from free_list.
	 * */
    if (page != NULL) {
  104854:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104858:	0f 84 59 01 00 00    	je     1049b7 <default_alloc_pages+0x233>
        /* list_del(&(page->page_link)); */
		list_entry_t *temp = (page->page_link).prev;
  10485e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104861:	8b 40 0c             	mov    0xc(%eax),%eax
  104864:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		list_del_init(&(page->page_link));
  104867:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10486a:	83 c0 0c             	add    $0xc,%eax
  10486d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  104870:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104873:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    __list_del(listelm->prev, listelm->next);
  104876:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104879:	8b 40 04             	mov    0x4(%eax),%eax
  10487c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10487f:	8b 12                	mov    (%edx),%edx
  104881:	89 55 d0             	mov    %edx,-0x30(%ebp)
  104884:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  104887:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10488a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  10488d:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  104890:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104893:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104896:	89 10                	mov    %edx,(%eax)
  104898:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10489b:	89 45 c8             	mov    %eax,-0x38(%ebp)
    elm->prev = elm->next = elm;
  10489e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1048a1:	8b 55 c8             	mov    -0x38(%ebp),%edx
  1048a4:	89 50 04             	mov    %edx,0x4(%eax)
  1048a7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1048aa:	8b 50 04             	mov    0x4(%eax),%edx
  1048ad:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1048b0:	89 10                	mov    %edx,(%eax)
        if (page->property > n) {
  1048b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048b5:	8b 40 08             	mov    0x8(%eax),%eax
  1048b8:	39 45 08             	cmp    %eax,0x8(%ebp)
  1048bb:	73 70                	jae    10492d <default_alloc_pages+0x1a9>
            struct Page *p = page + n;
  1048bd:	8b 55 08             	mov    0x8(%ebp),%edx
  1048c0:	89 d0                	mov    %edx,%eax
  1048c2:	c1 e0 02             	shl    $0x2,%eax
  1048c5:	01 d0                	add    %edx,%eax
  1048c7:	c1 e0 02             	shl    $0x2,%eax
  1048ca:	89 c2                	mov    %eax,%edx
  1048cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048cf:	01 d0                	add    %edx,%eax
  1048d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
            p->property = page->property - n;
  1048d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048d7:	8b 40 08             	mov    0x8(%eax),%eax
  1048da:	2b 45 08             	sub    0x8(%ebp),%eax
  1048dd:	89 c2                	mov    %eax,%edx
  1048df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1048e2:	89 50 08             	mov    %edx,0x8(%eax)
			// Property is set when initialize Page
            list_add_after(temp, &(p->page_link));
  1048e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1048e8:	8d 50 0c             	lea    0xc(%eax),%edx
  1048eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1048ee:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  1048f1:	89 55 c0             	mov    %edx,-0x40(%ebp)
    __list_add(elm, listelm, listelm->next);
  1048f4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1048f7:	8b 40 04             	mov    0x4(%eax),%eax
  1048fa:	8b 55 c0             	mov    -0x40(%ebp),%edx
  1048fd:	89 55 bc             	mov    %edx,-0x44(%ebp)
  104900:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  104903:	89 55 b8             	mov    %edx,-0x48(%ebp)
  104906:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    prev->next = next->prev = elm;
  104909:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  10490c:	8b 55 bc             	mov    -0x44(%ebp),%edx
  10490f:	89 10                	mov    %edx,(%eax)
  104911:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  104914:	8b 10                	mov    (%eax),%edx
  104916:	8b 45 b8             	mov    -0x48(%ebp),%eax
  104919:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  10491c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  10491f:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  104922:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  104925:	8b 45 bc             	mov    -0x44(%ebp),%eax
  104928:	8b 55 b8             	mov    -0x48(%ebp),%edx
  10492b:	89 10                	mov    %edx,(%eax)
		}
		/* modify pages in allocated block(except of first page)*/
		struct Page *p = page + 1;
  10492d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104930:	83 c0 14             	add    $0x14,%eax
  104933:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for (; p < page + n; ++p) {
  104936:	eb 2a                	jmp    104962 <default_alloc_pages+0x1de>
			ClearPageProperty(p);
  104938:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10493b:	83 c0 04             	add    $0x4,%eax
  10493e:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
  104945:	89 45 ac             	mov    %eax,-0x54(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104948:	8b 45 ac             	mov    -0x54(%ebp),%eax
  10494b:	8b 55 b0             	mov    -0x50(%ebp),%edx
  10494e:	0f b3 10             	btr    %edx,(%eax)
			++(p->ref);
  104951:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104954:	8b 00                	mov    (%eax),%eax
  104956:	8d 50 01             	lea    0x1(%eax),%edx
  104959:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10495c:	89 10                	mov    %edx,(%eax)
		for (; p < page + n; ++p) {
  10495e:	83 45 ec 14          	addl   $0x14,-0x14(%ebp)
  104962:	8b 55 08             	mov    0x8(%ebp),%edx
  104965:	89 d0                	mov    %edx,%eax
  104967:	c1 e0 02             	shl    $0x2,%eax
  10496a:	01 d0                	add    %edx,%eax
  10496c:	c1 e0 02             	shl    $0x2,%eax
  10496f:	89 c2                	mov    %eax,%edx
  104971:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104974:	01 d0                	add    %edx,%eax
  104976:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  104979:	72 bd                	jb     104938 <default_alloc_pages+0x1b4>
			// property is zero, so we needn't modiry it.
		}
		/* modify first page of allcoated block */
        ClearPageProperty(page);
  10497b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10497e:	83 c0 04             	add    $0x4,%eax
  104981:	c7 45 a8 01 00 00 00 	movl   $0x1,-0x58(%ebp)
  104988:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  10498b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  10498e:	8b 55 a8             	mov    -0x58(%ebp),%edx
  104991:	0f b3 10             	btr    %edx,(%eax)
		page->property = n;
  104994:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104997:	8b 55 08             	mov    0x8(%ebp),%edx
  10499a:	89 50 08             	mov    %edx,0x8(%eax)
		++(page->ref);
  10499d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1049a0:	8b 00                	mov    (%eax),%eax
  1049a2:	8d 50 01             	lea    0x1(%eax),%edx
  1049a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1049a8:	89 10                	mov    %edx,(%eax)
        nr_free -= n;
  1049aa:	a1 44 cf 11 00       	mov    0x11cf44,%eax
  1049af:	2b 45 08             	sub    0x8(%ebp),%eax
  1049b2:	a3 44 cf 11 00       	mov    %eax,0x11cf44
    }
    return page;
  1049b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1049ba:	c9                   	leave  
  1049bb:	c3                   	ret    

001049bc <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
  1049bc:	55                   	push   %ebp
  1049bd:	89 e5                	mov    %esp,%ebp
  1049bf:	81 ec a8 00 00 00    	sub    $0xa8,%esp
    assert(n > 0);
  1049c5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1049c9:	75 24                	jne    1049ef <default_free_pages+0x33>
  1049cb:	c7 44 24 0c 98 71 10 	movl   $0x107198,0xc(%esp)
  1049d2:	00 
  1049d3:	c7 44 24 08 9e 71 10 	movl   $0x10719e,0x8(%esp)
  1049da:	00 
  1049db:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
  1049e2:	00 
  1049e3:	c7 04 24 b3 71 10 00 	movl   $0x1071b3,(%esp)
  1049ea:	e8 03 ba ff ff       	call   1003f2 <__panic>
	assert(n == base->property);
  1049ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1049f2:	8b 40 08             	mov    0x8(%eax),%eax
  1049f5:	39 45 0c             	cmp    %eax,0xc(%ebp)
  1049f8:	74 24                	je     104a1e <default_free_pages+0x62>
  1049fa:	c7 44 24 0c 89 72 10 	movl   $0x107289,0xc(%esp)
  104a01:	00 
  104a02:	c7 44 24 08 9e 71 10 	movl   $0x10719e,0x8(%esp)
  104a09:	00 
  104a0a:	c7 44 24 04 bd 00 00 	movl   $0xbd,0x4(%esp)
  104a11:	00 
  104a12:	c7 04 24 b3 71 10 00 	movl   $0x1071b3,(%esp)
  104a19:	e8 d4 b9 ff ff       	call   1003f2 <__panic>
    struct Page *p = base;
  104a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  104a21:	89 45 f4             	mov    %eax,-0xc(%ebp)
	/* revert status information */
    for (; p != base + n; p ++) {
  104a24:	e9 b6 00 00 00       	jmp    104adf <default_free_pages+0x123>
		/* p->property and p->page_link needn't change */
        assert(!PageReserved(p) && !PageProperty(p));
  104a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104a2c:	83 c0 04             	add    $0x4,%eax
  104a2f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  104a36:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104a39:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104a3c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  104a3f:	0f a3 10             	bt     %edx,(%eax)
  104a42:	19 c0                	sbb    %eax,%eax
  104a44:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
  104a47:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  104a4b:	0f 95 c0             	setne  %al
  104a4e:	0f b6 c0             	movzbl %al,%eax
  104a51:	85 c0                	test   %eax,%eax
  104a53:	75 2c                	jne    104a81 <default_free_pages+0xc5>
  104a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104a58:	83 c0 04             	add    $0x4,%eax
  104a5b:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  104a62:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104a65:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104a68:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104a6b:	0f a3 10             	bt     %edx,(%eax)
  104a6e:	19 c0                	sbb    %eax,%eax
  104a70:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
  104a73:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  104a77:	0f 95 c0             	setne  %al
  104a7a:	0f b6 c0             	movzbl %al,%eax
  104a7d:	85 c0                	test   %eax,%eax
  104a7f:	74 24                	je     104aa5 <default_free_pages+0xe9>
  104a81:	c7 44 24 0c a0 72 10 	movl   $0x1072a0,0xc(%esp)
  104a88:	00 
  104a89:	c7 44 24 08 9e 71 10 	movl   $0x10719e,0x8(%esp)
  104a90:	00 
  104a91:	c7 44 24 04 c2 00 00 	movl   $0xc2,0x4(%esp)
  104a98:	00 
  104a99:	c7 04 24 b3 71 10 00 	movl   $0x1071b3,(%esp)
  104aa0:	e8 4d b9 ff ff       	call   1003f2 <__panic>
        p->flags = 0;
  104aa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104aa8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
		SetPageProperty(p);
  104aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104ab2:	83 c0 04             	add    $0x4,%eax
  104ab5:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  104abc:	89 45 d0             	mov    %eax,-0x30(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104abf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104ac2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104ac5:	0f ab 10             	bts    %edx,(%eax)
        set_page_ref(p, 0);
  104ac8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104acf:	00 
  104ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104ad3:	89 04 24             	mov    %eax,(%esp)
  104ad6:	e8 6d fa ff ff       	call   104548 <set_page_ref>
    for (; p != base + n; p ++) {
  104adb:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  104adf:	8b 55 0c             	mov    0xc(%ebp),%edx
  104ae2:	89 d0                	mov    %edx,%eax
  104ae4:	c1 e0 02             	shl    $0x2,%eax
  104ae7:	01 d0                	add    %edx,%eax
  104ae9:	c1 e0 02             	shl    $0x2,%eax
  104aec:	89 c2                	mov    %eax,%edx
  104aee:	8b 45 08             	mov    0x8(%ebp),%eax
  104af1:	01 d0                	add    %edx,%eax
  104af3:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104af6:	0f 85 2d ff ff ff    	jne    104a29 <default_free_pages+0x6d>
    /*         list_del(&(p->page_link)); */
    /*     } */
    /* } */

	/* if the adjacent block(next to block being freed) is free, merge the free block and the block being freed into one new free block*/
	p = base + base->property;
  104afc:	8b 45 08             	mov    0x8(%ebp),%eax
  104aff:	8b 50 08             	mov    0x8(%eax),%edx
  104b02:	89 d0                	mov    %edx,%eax
  104b04:	c1 e0 02             	shl    $0x2,%eax
  104b07:	01 d0                	add    %edx,%eax
  104b09:	c1 e0 02             	shl    $0x2,%eax
  104b0c:	89 c2                	mov    %eax,%edx
  104b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  104b11:	01 d0                	add    %edx,%eax
  104b13:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (!PageReserved(p) && PageProperty(p)) {
  104b16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104b19:	83 c0 04             	add    $0x4,%eax
  104b1c:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  104b23:	89 45 c8             	mov    %eax,-0x38(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104b26:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104b29:	8b 55 cc             	mov    -0x34(%ebp),%edx
  104b2c:	0f a3 10             	bt     %edx,(%eax)
  104b2f:	19 c0                	sbb    %eax,%eax
  104b31:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return oldbit != 0;
  104b34:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  104b38:	0f 95 c0             	setne  %al
  104b3b:	0f b6 c0             	movzbl %al,%eax
  104b3e:	85 c0                	test   %eax,%eax
  104b40:	0f 85 e3 00 00 00    	jne    104c29 <default_free_pages+0x26d>
  104b46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104b49:	83 c0 04             	add    $0x4,%eax
  104b4c:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  104b53:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104b56:	8b 45 bc             	mov    -0x44(%ebp),%eax
  104b59:	8b 55 c0             	mov    -0x40(%ebp),%edx
  104b5c:	0f a3 10             	bt     %edx,(%eax)
  104b5f:	19 c0                	sbb    %eax,%eax
  104b61:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  104b64:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  104b68:	0f 95 c0             	setne  %al
  104b6b:	0f b6 c0             	movzbl %al,%eax
  104b6e:	85 c0                	test   %eax,%eax
  104b70:	0f 84 b3 00 00 00    	je     104c29 <default_free_pages+0x26d>
		base->property += p->property;
  104b76:	8b 45 08             	mov    0x8(%ebp),%eax
  104b79:	8b 50 08             	mov    0x8(%eax),%edx
  104b7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104b7f:	8b 40 08             	mov    0x8(%eax),%eax
  104b82:	01 c2                	add    %eax,%edx
  104b84:	8b 45 08             	mov    0x8(%ebp),%eax
  104b87:	89 50 08             	mov    %edx,0x8(%eax)
		p->property = 0;
  104b8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104b8d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	
		/* add new free block(pointed by #base) into free_list and delete merged block(pointed by #p) */
		assert((p->page_link).prev < &(base->page_link));
  104b94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104b97:	8b 40 0c             	mov    0xc(%eax),%eax
  104b9a:	8b 55 08             	mov    0x8(%ebp),%edx
  104b9d:	83 c2 0c             	add    $0xc,%edx
  104ba0:	39 d0                	cmp    %edx,%eax
  104ba2:	72 24                	jb     104bc8 <default_free_pages+0x20c>
  104ba4:	c7 44 24 0c c8 72 10 	movl   $0x1072c8,0xc(%esp)
  104bab:	00 
  104bac:	c7 44 24 08 9e 71 10 	movl   $0x10719e,0x8(%esp)
  104bb3:	00 
  104bb4:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
  104bbb:	00 
  104bbc:	c7 04 24 b3 71 10 00 	movl   $0x1071b3,(%esp)
  104bc3:	e8 2a b8 ff ff       	call   1003f2 <__panic>
		__list_add(&(base->page_link), (p->page_link).prev, (p->page_link).next);
  104bc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104bcb:	8b 40 10             	mov    0x10(%eax),%eax
  104bce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104bd1:	8b 52 0c             	mov    0xc(%edx),%edx
  104bd4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  104bd7:	83 c1 0c             	add    $0xc,%ecx
  104bda:	89 4d b0             	mov    %ecx,-0x50(%ebp)
  104bdd:	89 55 ac             	mov    %edx,-0x54(%ebp)
  104be0:	89 45 a8             	mov    %eax,-0x58(%ebp)
    prev->next = next->prev = elm;
  104be3:	8b 45 a8             	mov    -0x58(%ebp),%eax
  104be6:	8b 55 b0             	mov    -0x50(%ebp),%edx
  104be9:	89 10                	mov    %edx,(%eax)
  104beb:	8b 45 a8             	mov    -0x58(%ebp),%eax
  104bee:	8b 10                	mov    (%eax),%edx
  104bf0:	8b 45 ac             	mov    -0x54(%ebp),%eax
  104bf3:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  104bf6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  104bf9:	8b 55 a8             	mov    -0x58(%ebp),%edx
  104bfc:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  104bff:	8b 45 b0             	mov    -0x50(%ebp),%eax
  104c02:	8b 55 ac             	mov    -0x54(%ebp),%edx
  104c05:	89 10                	mov    %edx,(%eax)
		list_init(&(p->page_link));	
  104c07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104c0a:	83 c0 0c             	add    $0xc,%eax
  104c0d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    elm->prev = elm->next = elm;
  104c10:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  104c13:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  104c16:	89 50 04             	mov    %edx,0x4(%eax)
  104c19:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  104c1c:	8b 50 04             	mov    0x4(%eax),%edx
  104c1f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  104c22:	89 10                	mov    %edx,(%eax)
  104c24:	e9 14 01 00 00       	jmp    104d3d <default_free_pages+0x381>
	}
	/* if the adjacent block is not free, find appropriate position and inset the block into free_list */
	else if (!PageReserved(p) && !PageProperty(p)) {
  104c29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104c2c:	83 c0 04             	add    $0x4,%eax
  104c2f:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
  104c36:	89 45 a0             	mov    %eax,-0x60(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104c39:	8b 45 a0             	mov    -0x60(%ebp),%eax
  104c3c:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  104c3f:	0f a3 10             	bt     %edx,(%eax)
  104c42:	19 c0                	sbb    %eax,%eax
  104c44:	89 45 9c             	mov    %eax,-0x64(%ebp)
    return oldbit != 0;
  104c47:	83 7d 9c 00          	cmpl   $0x0,-0x64(%ebp)
  104c4b:	0f 95 c0             	setne  %al
  104c4e:	0f b6 c0             	movzbl %al,%eax
  104c51:	85 c0                	test   %eax,%eax
  104c53:	0f 85 e4 00 00 00    	jne    104d3d <default_free_pages+0x381>
  104c59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104c5c:	83 c0 04             	add    $0x4,%eax
  104c5f:	c7 45 98 01 00 00 00 	movl   $0x1,-0x68(%ebp)
  104c66:	89 45 94             	mov    %eax,-0x6c(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104c69:	8b 45 94             	mov    -0x6c(%ebp),%eax
  104c6c:	8b 55 98             	mov    -0x68(%ebp),%edx
  104c6f:	0f a3 10             	bt     %edx,(%eax)
  104c72:	19 c0                	sbb    %eax,%eax
  104c74:	89 45 90             	mov    %eax,-0x70(%ebp)
    return oldbit != 0;
  104c77:	83 7d 90 00          	cmpl   $0x0,-0x70(%ebp)
  104c7b:	0f 95 c0             	setne  %al
  104c7e:	0f b6 c0             	movzbl %al,%eax
  104c81:	85 c0                	test   %eax,%eax
  104c83:	0f 85 b4 00 00 00    	jne    104d3d <default_free_pages+0x381>
  104c89:	c7 45 8c 3c cf 11 00 	movl   $0x11cf3c,-0x74(%ebp)
    return listelm->next;
  104c90:	8b 45 8c             	mov    -0x74(%ebp),%eax
  104c93:	8b 40 04             	mov    0x4(%eax),%eax
		list_entry_t *pl = list_next(&free_list);
  104c96:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (; pl != &free_list; pl = list_next(pl)) {
  104c99:	eb 2a                	jmp    104cc5 <default_free_pages+0x309>
			if (pl > &(base->page_link)) {
  104c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  104c9e:	83 c0 0c             	add    $0xc,%eax
  104ca1:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  104ca4:	76 10                	jbe    104cb6 <default_free_pages+0x2fa>
  104ca6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104ca9:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->prev;
  104cac:	8b 45 88             	mov    -0x78(%ebp),%eax
  104caf:	8b 00                	mov    (%eax),%eax
				pl = list_prev(pl);
  104cb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
				break;
  104cb4:	eb 18                	jmp    104cce <default_free_pages+0x312>
  104cb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104cb9:	89 45 84             	mov    %eax,-0x7c(%ebp)
    return listelm->next;
  104cbc:	8b 45 84             	mov    -0x7c(%ebp),%eax
  104cbf:	8b 40 04             	mov    0x4(%eax),%eax
		for (; pl != &free_list; pl = list_next(pl)) {
  104cc2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104cc5:	81 7d f0 3c cf 11 00 	cmpl   $0x11cf3c,-0x10(%ebp)
  104ccc:	75 cd                	jne    104c9b <default_free_pages+0x2df>
			}
		}
		list_add_after(pl, &(base->page_link));
  104cce:	8b 45 08             	mov    0x8(%ebp),%eax
  104cd1:	8d 50 0c             	lea    0xc(%eax),%edx
  104cd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104cd7:	89 45 80             	mov    %eax,-0x80(%ebp)
  104cda:	89 95 7c ff ff ff    	mov    %edx,-0x84(%ebp)
    __list_add(elm, listelm, listelm->next);
  104ce0:	8b 45 80             	mov    -0x80(%ebp),%eax
  104ce3:	8b 40 04             	mov    0x4(%eax),%eax
  104ce6:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
  104cec:	89 95 78 ff ff ff    	mov    %edx,-0x88(%ebp)
  104cf2:	8b 55 80             	mov    -0x80(%ebp),%edx
  104cf5:	89 95 74 ff ff ff    	mov    %edx,-0x8c(%ebp)
  104cfb:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
    prev->next = next->prev = elm;
  104d01:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  104d07:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
  104d0d:	89 10                	mov    %edx,(%eax)
  104d0f:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  104d15:	8b 10                	mov    (%eax),%edx
  104d17:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  104d1d:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  104d20:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  104d26:	8b 95 70 ff ff ff    	mov    -0x90(%ebp),%edx
  104d2c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  104d2f:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  104d35:	8b 95 74 ff ff ff    	mov    -0x8c(%ebp),%edx
  104d3b:	89 10                	mov    %edx,(%eax)
	}
    nr_free += n;
  104d3d:	8b 15 44 cf 11 00    	mov    0x11cf44,%edx
  104d43:	8b 45 0c             	mov    0xc(%ebp),%eax
  104d46:	01 d0                	add    %edx,%eax
  104d48:	a3 44 cf 11 00       	mov    %eax,0x11cf44
}
  104d4d:	90                   	nop
  104d4e:	c9                   	leave  
  104d4f:	c3                   	ret    

00104d50 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  104d50:	55                   	push   %ebp
  104d51:	89 e5                	mov    %esp,%ebp
    return nr_free;
  104d53:	a1 44 cf 11 00       	mov    0x11cf44,%eax
}
  104d58:	5d                   	pop    %ebp
  104d59:	c3                   	ret    

00104d5a <basic_check>:

static void
basic_check(void) {
  104d5a:	55                   	push   %ebp
  104d5b:	89 e5                	mov    %esp,%ebp
  104d5d:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  104d60:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104d67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104d6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104d6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104d70:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  104d73:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104d7a:	e8 91 e2 ff ff       	call   103010 <alloc_pages>
  104d7f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104d82:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  104d86:	75 24                	jne    104dac <basic_check+0x52>
  104d88:	c7 44 24 0c f1 72 10 	movl   $0x1072f1,0xc(%esp)
  104d8f:	00 
  104d90:	c7 44 24 08 9e 71 10 	movl   $0x10719e,0x8(%esp)
  104d97:	00 
  104d98:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
  104d9f:	00 
  104da0:	c7 04 24 b3 71 10 00 	movl   $0x1071b3,(%esp)
  104da7:	e8 46 b6 ff ff       	call   1003f2 <__panic>
    assert((p1 = alloc_page()) != NULL);
  104dac:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104db3:	e8 58 e2 ff ff       	call   103010 <alloc_pages>
  104db8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104dbb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104dbf:	75 24                	jne    104de5 <basic_check+0x8b>
  104dc1:	c7 44 24 0c 0d 73 10 	movl   $0x10730d,0xc(%esp)
  104dc8:	00 
  104dc9:	c7 44 24 08 9e 71 10 	movl   $0x10719e,0x8(%esp)
  104dd0:	00 
  104dd1:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
  104dd8:	00 
  104dd9:	c7 04 24 b3 71 10 00 	movl   $0x1071b3,(%esp)
  104de0:	e8 0d b6 ff ff       	call   1003f2 <__panic>
    assert((p2 = alloc_page()) != NULL);
  104de5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104dec:	e8 1f e2 ff ff       	call   103010 <alloc_pages>
  104df1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104df4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104df8:	75 24                	jne    104e1e <basic_check+0xc4>
  104dfa:	c7 44 24 0c 29 73 10 	movl   $0x107329,0xc(%esp)
  104e01:	00 
  104e02:	c7 44 24 08 9e 71 10 	movl   $0x10719e,0x8(%esp)
  104e09:	00 
  104e0a:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
  104e11:	00 
  104e12:	c7 04 24 b3 71 10 00 	movl   $0x1071b3,(%esp)
  104e19:	e8 d4 b5 ff ff       	call   1003f2 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  104e1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104e21:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  104e24:	74 10                	je     104e36 <basic_check+0xdc>
  104e26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104e29:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104e2c:	74 08                	je     104e36 <basic_check+0xdc>
  104e2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104e31:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104e34:	75 24                	jne    104e5a <basic_check+0x100>
  104e36:	c7 44 24 0c 48 73 10 	movl   $0x107348,0xc(%esp)
  104e3d:	00 
  104e3e:	c7 44 24 08 9e 71 10 	movl   $0x10719e,0x8(%esp)
  104e45:	00 
  104e46:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  104e4d:	00 
  104e4e:	c7 04 24 b3 71 10 00 	movl   $0x1071b3,(%esp)
  104e55:	e8 98 b5 ff ff       	call   1003f2 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  104e5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104e5d:	89 04 24             	mov    %eax,(%esp)
  104e60:	e8 d9 f6 ff ff       	call   10453e <page_ref>
  104e65:	85 c0                	test   %eax,%eax
  104e67:	75 1e                	jne    104e87 <basic_check+0x12d>
  104e69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104e6c:	89 04 24             	mov    %eax,(%esp)
  104e6f:	e8 ca f6 ff ff       	call   10453e <page_ref>
  104e74:	85 c0                	test   %eax,%eax
  104e76:	75 0f                	jne    104e87 <basic_check+0x12d>
  104e78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104e7b:	89 04 24             	mov    %eax,(%esp)
  104e7e:	e8 bb f6 ff ff       	call   10453e <page_ref>
  104e83:	85 c0                	test   %eax,%eax
  104e85:	74 24                	je     104eab <basic_check+0x151>
  104e87:	c7 44 24 0c 6c 73 10 	movl   $0x10736c,0xc(%esp)
  104e8e:	00 
  104e8f:	c7 44 24 08 9e 71 10 	movl   $0x10719e,0x8(%esp)
  104e96:	00 
  104e97:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
  104e9e:	00 
  104e9f:	c7 04 24 b3 71 10 00 	movl   $0x1071b3,(%esp)
  104ea6:	e8 47 b5 ff ff       	call   1003f2 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  104eab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104eae:	89 04 24             	mov    %eax,(%esp)
  104eb1:	e8 72 f6 ff ff       	call   104528 <page2pa>
  104eb6:	8b 15 a0 ce 11 00    	mov    0x11cea0,%edx
  104ebc:	c1 e2 0c             	shl    $0xc,%edx
  104ebf:	39 d0                	cmp    %edx,%eax
  104ec1:	72 24                	jb     104ee7 <basic_check+0x18d>
  104ec3:	c7 44 24 0c a8 73 10 	movl   $0x1073a8,0xc(%esp)
  104eca:	00 
  104ecb:	c7 44 24 08 9e 71 10 	movl   $0x10719e,0x8(%esp)
  104ed2:	00 
  104ed3:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
  104eda:	00 
  104edb:	c7 04 24 b3 71 10 00 	movl   $0x1071b3,(%esp)
  104ee2:	e8 0b b5 ff ff       	call   1003f2 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  104ee7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104eea:	89 04 24             	mov    %eax,(%esp)
  104eed:	e8 36 f6 ff ff       	call   104528 <page2pa>
  104ef2:	8b 15 a0 ce 11 00    	mov    0x11cea0,%edx
  104ef8:	c1 e2 0c             	shl    $0xc,%edx
  104efb:	39 d0                	cmp    %edx,%eax
  104efd:	72 24                	jb     104f23 <basic_check+0x1c9>
  104eff:	c7 44 24 0c c5 73 10 	movl   $0x1073c5,0xc(%esp)
  104f06:	00 
  104f07:	c7 44 24 08 9e 71 10 	movl   $0x10719e,0x8(%esp)
  104f0e:	00 
  104f0f:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
  104f16:	00 
  104f17:	c7 04 24 b3 71 10 00 	movl   $0x1071b3,(%esp)
  104f1e:	e8 cf b4 ff ff       	call   1003f2 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  104f23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104f26:	89 04 24             	mov    %eax,(%esp)
  104f29:	e8 fa f5 ff ff       	call   104528 <page2pa>
  104f2e:	8b 15 a0 ce 11 00    	mov    0x11cea0,%edx
  104f34:	c1 e2 0c             	shl    $0xc,%edx
  104f37:	39 d0                	cmp    %edx,%eax
  104f39:	72 24                	jb     104f5f <basic_check+0x205>
  104f3b:	c7 44 24 0c e2 73 10 	movl   $0x1073e2,0xc(%esp)
  104f42:	00 
  104f43:	c7 44 24 08 9e 71 10 	movl   $0x10719e,0x8(%esp)
  104f4a:	00 
  104f4b:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
  104f52:	00 
  104f53:	c7 04 24 b3 71 10 00 	movl   $0x1071b3,(%esp)
  104f5a:	e8 93 b4 ff ff       	call   1003f2 <__panic>

    list_entry_t free_list_store = free_list;
  104f5f:	a1 3c cf 11 00       	mov    0x11cf3c,%eax
  104f64:	8b 15 40 cf 11 00    	mov    0x11cf40,%edx
  104f6a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104f6d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  104f70:	c7 45 dc 3c cf 11 00 	movl   $0x11cf3c,-0x24(%ebp)
    elm->prev = elm->next = elm;
  104f77:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104f7a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104f7d:	89 50 04             	mov    %edx,0x4(%eax)
  104f80:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104f83:	8b 50 04             	mov    0x4(%eax),%edx
  104f86:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104f89:	89 10                	mov    %edx,(%eax)
  104f8b:	c7 45 e0 3c cf 11 00 	movl   $0x11cf3c,-0x20(%ebp)
    return list->next == list;
  104f92:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104f95:	8b 40 04             	mov    0x4(%eax),%eax
  104f98:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  104f9b:	0f 94 c0             	sete   %al
  104f9e:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  104fa1:	85 c0                	test   %eax,%eax
  104fa3:	75 24                	jne    104fc9 <basic_check+0x26f>
  104fa5:	c7 44 24 0c ff 73 10 	movl   $0x1073ff,0xc(%esp)
  104fac:	00 
  104fad:	c7 44 24 08 9e 71 10 	movl   $0x10719e,0x8(%esp)
  104fb4:	00 
  104fb5:	c7 44 24 04 08 01 00 	movl   $0x108,0x4(%esp)
  104fbc:	00 
  104fbd:	c7 04 24 b3 71 10 00 	movl   $0x1071b3,(%esp)
  104fc4:	e8 29 b4 ff ff       	call   1003f2 <__panic>

    unsigned int nr_free_store = nr_free;
  104fc9:	a1 44 cf 11 00       	mov    0x11cf44,%eax
  104fce:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  104fd1:	c7 05 44 cf 11 00 00 	movl   $0x0,0x11cf44
  104fd8:	00 00 00 

    assert(alloc_page() == NULL);
  104fdb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104fe2:	e8 29 e0 ff ff       	call   103010 <alloc_pages>
  104fe7:	85 c0                	test   %eax,%eax
  104fe9:	74 24                	je     10500f <basic_check+0x2b5>
  104feb:	c7 44 24 0c 16 74 10 	movl   $0x107416,0xc(%esp)
  104ff2:	00 
  104ff3:	c7 44 24 08 9e 71 10 	movl   $0x10719e,0x8(%esp)
  104ffa:	00 
  104ffb:	c7 44 24 04 0d 01 00 	movl   $0x10d,0x4(%esp)
  105002:	00 
  105003:	c7 04 24 b3 71 10 00 	movl   $0x1071b3,(%esp)
  10500a:	e8 e3 b3 ff ff       	call   1003f2 <__panic>

    free_page(p0);
  10500f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105016:	00 
  105017:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10501a:	89 04 24             	mov    %eax,(%esp)
  10501d:	e8 26 e0 ff ff       	call   103048 <free_pages>
    free_page(p1);
  105022:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105029:	00 
  10502a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10502d:	89 04 24             	mov    %eax,(%esp)
  105030:	e8 13 e0 ff ff       	call   103048 <free_pages>
    free_page(p2);
  105035:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10503c:	00 
  10503d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105040:	89 04 24             	mov    %eax,(%esp)
  105043:	e8 00 e0 ff ff       	call   103048 <free_pages>
    assert(nr_free == 3);
  105048:	a1 44 cf 11 00       	mov    0x11cf44,%eax
  10504d:	83 f8 03             	cmp    $0x3,%eax
  105050:	74 24                	je     105076 <basic_check+0x31c>
  105052:	c7 44 24 0c 2b 74 10 	movl   $0x10742b,0xc(%esp)
  105059:	00 
  10505a:	c7 44 24 08 9e 71 10 	movl   $0x10719e,0x8(%esp)
  105061:	00 
  105062:	c7 44 24 04 12 01 00 	movl   $0x112,0x4(%esp)
  105069:	00 
  10506a:	c7 04 24 b3 71 10 00 	movl   $0x1071b3,(%esp)
  105071:	e8 7c b3 ff ff       	call   1003f2 <__panic>

    assert((p0 = alloc_page()) != NULL);
  105076:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10507d:	e8 8e df ff ff       	call   103010 <alloc_pages>
  105082:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105085:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  105089:	75 24                	jne    1050af <basic_check+0x355>
  10508b:	c7 44 24 0c f1 72 10 	movl   $0x1072f1,0xc(%esp)
  105092:	00 
  105093:	c7 44 24 08 9e 71 10 	movl   $0x10719e,0x8(%esp)
  10509a:	00 
  10509b:	c7 44 24 04 14 01 00 	movl   $0x114,0x4(%esp)
  1050a2:	00 
  1050a3:	c7 04 24 b3 71 10 00 	movl   $0x1071b3,(%esp)
  1050aa:	e8 43 b3 ff ff       	call   1003f2 <__panic>
    assert((p1 = alloc_page()) != NULL);
  1050af:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1050b6:	e8 55 df ff ff       	call   103010 <alloc_pages>
  1050bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1050be:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1050c2:	75 24                	jne    1050e8 <basic_check+0x38e>
  1050c4:	c7 44 24 0c 0d 73 10 	movl   $0x10730d,0xc(%esp)
  1050cb:	00 
  1050cc:	c7 44 24 08 9e 71 10 	movl   $0x10719e,0x8(%esp)
  1050d3:	00 
  1050d4:	c7 44 24 04 15 01 00 	movl   $0x115,0x4(%esp)
  1050db:	00 
  1050dc:	c7 04 24 b3 71 10 00 	movl   $0x1071b3,(%esp)
  1050e3:	e8 0a b3 ff ff       	call   1003f2 <__panic>
    assert((p2 = alloc_page()) != NULL);
  1050e8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1050ef:	e8 1c df ff ff       	call   103010 <alloc_pages>
  1050f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1050f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1050fb:	75 24                	jne    105121 <basic_check+0x3c7>
  1050fd:	c7 44 24 0c 29 73 10 	movl   $0x107329,0xc(%esp)
  105104:	00 
  105105:	c7 44 24 08 9e 71 10 	movl   $0x10719e,0x8(%esp)
  10510c:	00 
  10510d:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  105114:	00 
  105115:	c7 04 24 b3 71 10 00 	movl   $0x1071b3,(%esp)
  10511c:	e8 d1 b2 ff ff       	call   1003f2 <__panic>

    assert(alloc_page() == NULL);
  105121:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105128:	e8 e3 de ff ff       	call   103010 <alloc_pages>
  10512d:	85 c0                	test   %eax,%eax
  10512f:	74 24                	je     105155 <basic_check+0x3fb>
  105131:	c7 44 24 0c 16 74 10 	movl   $0x107416,0xc(%esp)
  105138:	00 
  105139:	c7 44 24 08 9e 71 10 	movl   $0x10719e,0x8(%esp)
  105140:	00 
  105141:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
  105148:	00 
  105149:	c7 04 24 b3 71 10 00 	movl   $0x1071b3,(%esp)
  105150:	e8 9d b2 ff ff       	call   1003f2 <__panic>

    free_page(p0);
  105155:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10515c:	00 
  10515d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105160:	89 04 24             	mov    %eax,(%esp)
  105163:	e8 e0 de ff ff       	call   103048 <free_pages>
  105168:	c7 45 d8 3c cf 11 00 	movl   $0x11cf3c,-0x28(%ebp)
  10516f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105172:	8b 40 04             	mov    0x4(%eax),%eax
  105175:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  105178:	0f 94 c0             	sete   %al
  10517b:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  10517e:	85 c0                	test   %eax,%eax
  105180:	74 24                	je     1051a6 <basic_check+0x44c>
  105182:	c7 44 24 0c 38 74 10 	movl   $0x107438,0xc(%esp)
  105189:	00 
  10518a:	c7 44 24 08 9e 71 10 	movl   $0x10719e,0x8(%esp)
  105191:	00 
  105192:	c7 44 24 04 1b 01 00 	movl   $0x11b,0x4(%esp)
  105199:	00 
  10519a:	c7 04 24 b3 71 10 00 	movl   $0x1071b3,(%esp)
  1051a1:	e8 4c b2 ff ff       	call   1003f2 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  1051a6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1051ad:	e8 5e de ff ff       	call   103010 <alloc_pages>
  1051b2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1051b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1051b8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1051bb:	74 24                	je     1051e1 <basic_check+0x487>
  1051bd:	c7 44 24 0c 50 74 10 	movl   $0x107450,0xc(%esp)
  1051c4:	00 
  1051c5:	c7 44 24 08 9e 71 10 	movl   $0x10719e,0x8(%esp)
  1051cc:	00 
  1051cd:	c7 44 24 04 1e 01 00 	movl   $0x11e,0x4(%esp)
  1051d4:	00 
  1051d5:	c7 04 24 b3 71 10 00 	movl   $0x1071b3,(%esp)
  1051dc:	e8 11 b2 ff ff       	call   1003f2 <__panic>
    assert(alloc_page() == NULL);
  1051e1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1051e8:	e8 23 de ff ff       	call   103010 <alloc_pages>
  1051ed:	85 c0                	test   %eax,%eax
  1051ef:	74 24                	je     105215 <basic_check+0x4bb>
  1051f1:	c7 44 24 0c 16 74 10 	movl   $0x107416,0xc(%esp)
  1051f8:	00 
  1051f9:	c7 44 24 08 9e 71 10 	movl   $0x10719e,0x8(%esp)
  105200:	00 
  105201:	c7 44 24 04 1f 01 00 	movl   $0x11f,0x4(%esp)
  105208:	00 
  105209:	c7 04 24 b3 71 10 00 	movl   $0x1071b3,(%esp)
  105210:	e8 dd b1 ff ff       	call   1003f2 <__panic>

    assert(nr_free == 0);
  105215:	a1 44 cf 11 00       	mov    0x11cf44,%eax
  10521a:	85 c0                	test   %eax,%eax
  10521c:	74 24                	je     105242 <basic_check+0x4e8>
  10521e:	c7 44 24 0c 69 74 10 	movl   $0x107469,0xc(%esp)
  105225:	00 
  105226:	c7 44 24 08 9e 71 10 	movl   $0x10719e,0x8(%esp)
  10522d:	00 
  10522e:	c7 44 24 04 21 01 00 	movl   $0x121,0x4(%esp)
  105235:	00 
  105236:	c7 04 24 b3 71 10 00 	movl   $0x1071b3,(%esp)
  10523d:	e8 b0 b1 ff ff       	call   1003f2 <__panic>
    free_list = free_list_store;
  105242:	8b 45 d0             	mov    -0x30(%ebp),%eax
  105245:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105248:	a3 3c cf 11 00       	mov    %eax,0x11cf3c
  10524d:	89 15 40 cf 11 00    	mov    %edx,0x11cf40
    nr_free = nr_free_store;
  105253:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105256:	a3 44 cf 11 00       	mov    %eax,0x11cf44

    free_page(p);
  10525b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105262:	00 
  105263:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105266:	89 04 24             	mov    %eax,(%esp)
  105269:	e8 da dd ff ff       	call   103048 <free_pages>
    free_page(p1);
  10526e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105275:	00 
  105276:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105279:	89 04 24             	mov    %eax,(%esp)
  10527c:	e8 c7 dd ff ff       	call   103048 <free_pages>
    free_page(p2);
  105281:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105288:	00 
  105289:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10528c:	89 04 24             	mov    %eax,(%esp)
  10528f:	e8 b4 dd ff ff       	call   103048 <free_pages>
}
  105294:	90                   	nop
  105295:	c9                   	leave  
  105296:	c3                   	ret    

00105297 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  105297:	55                   	push   %ebp
  105298:	89 e5                	mov    %esp,%ebp
  10529a:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
  1052a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1052a7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  1052ae:	c7 45 ec 3c cf 11 00 	movl   $0x11cf3c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  1052b5:	eb 6a                	jmp    105321 <default_check+0x8a>
        struct Page *p = le2page(le, page_link);
  1052b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1052ba:	83 e8 0c             	sub    $0xc,%eax
  1052bd:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
  1052c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1052c3:	83 c0 04             	add    $0x4,%eax
  1052c6:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  1052cd:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1052d0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1052d3:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1052d6:	0f a3 10             	bt     %edx,(%eax)
  1052d9:	19 c0                	sbb    %eax,%eax
  1052db:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  1052de:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  1052e2:	0f 95 c0             	setne  %al
  1052e5:	0f b6 c0             	movzbl %al,%eax
  1052e8:	85 c0                	test   %eax,%eax
  1052ea:	75 24                	jne    105310 <default_check+0x79>
  1052ec:	c7 44 24 0c 76 74 10 	movl   $0x107476,0xc(%esp)
  1052f3:	00 
  1052f4:	c7 44 24 08 9e 71 10 	movl   $0x10719e,0x8(%esp)
  1052fb:	00 
  1052fc:	c7 44 24 04 32 01 00 	movl   $0x132,0x4(%esp)
  105303:	00 
  105304:	c7 04 24 b3 71 10 00 	movl   $0x1071b3,(%esp)
  10530b:	e8 e2 b0 ff ff       	call   1003f2 <__panic>
        count ++, total += p->property;
  105310:	ff 45 f4             	incl   -0xc(%ebp)
  105313:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105316:	8b 50 08             	mov    0x8(%eax),%edx
  105319:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10531c:	01 d0                	add    %edx,%eax
  10531e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105321:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105324:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
  105327:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  10532a:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  10532d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105330:	81 7d ec 3c cf 11 00 	cmpl   $0x11cf3c,-0x14(%ebp)
  105337:	0f 85 7a ff ff ff    	jne    1052b7 <default_check+0x20>
    }
    assert(total == nr_free_pages());
  10533d:	e8 39 dd ff ff       	call   10307b <nr_free_pages>
  105342:	89 c2                	mov    %eax,%edx
  105344:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105347:	39 c2                	cmp    %eax,%edx
  105349:	74 24                	je     10536f <default_check+0xd8>
  10534b:	c7 44 24 0c 86 74 10 	movl   $0x107486,0xc(%esp)
  105352:	00 
  105353:	c7 44 24 08 9e 71 10 	movl   $0x10719e,0x8(%esp)
  10535a:	00 
  10535b:	c7 44 24 04 35 01 00 	movl   $0x135,0x4(%esp)
  105362:	00 
  105363:	c7 04 24 b3 71 10 00 	movl   $0x1071b3,(%esp)
  10536a:	e8 83 b0 ff ff       	call   1003f2 <__panic>

    basic_check();
  10536f:	e8 e6 f9 ff ff       	call   104d5a <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  105374:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  10537b:	e8 90 dc ff ff       	call   103010 <alloc_pages>
  105380:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
  105383:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105387:	75 24                	jne    1053ad <default_check+0x116>
  105389:	c7 44 24 0c 9f 74 10 	movl   $0x10749f,0xc(%esp)
  105390:	00 
  105391:	c7 44 24 08 9e 71 10 	movl   $0x10719e,0x8(%esp)
  105398:	00 
  105399:	c7 44 24 04 3a 01 00 	movl   $0x13a,0x4(%esp)
  1053a0:	00 
  1053a1:	c7 04 24 b3 71 10 00 	movl   $0x1071b3,(%esp)
  1053a8:	e8 45 b0 ff ff       	call   1003f2 <__panic>
    assert(!PageProperty(p0));
  1053ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1053b0:	83 c0 04             	add    $0x4,%eax
  1053b3:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  1053ba:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1053bd:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1053c0:	8b 55 c0             	mov    -0x40(%ebp),%edx
  1053c3:	0f a3 10             	bt     %edx,(%eax)
  1053c6:	19 c0                	sbb    %eax,%eax
  1053c8:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  1053cb:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  1053cf:	0f 95 c0             	setne  %al
  1053d2:	0f b6 c0             	movzbl %al,%eax
  1053d5:	85 c0                	test   %eax,%eax
  1053d7:	74 24                	je     1053fd <default_check+0x166>
  1053d9:	c7 44 24 0c aa 74 10 	movl   $0x1074aa,0xc(%esp)
  1053e0:	00 
  1053e1:	c7 44 24 08 9e 71 10 	movl   $0x10719e,0x8(%esp)
  1053e8:	00 
  1053e9:	c7 44 24 04 3b 01 00 	movl   $0x13b,0x4(%esp)
  1053f0:	00 
  1053f1:	c7 04 24 b3 71 10 00 	movl   $0x1071b3,(%esp)
  1053f8:	e8 f5 af ff ff       	call   1003f2 <__panic>

    list_entry_t free_list_store = free_list;
  1053fd:	a1 3c cf 11 00       	mov    0x11cf3c,%eax
  105402:	8b 15 40 cf 11 00    	mov    0x11cf40,%edx
  105408:	89 45 80             	mov    %eax,-0x80(%ebp)
  10540b:	89 55 84             	mov    %edx,-0x7c(%ebp)
  10540e:	c7 45 b0 3c cf 11 00 	movl   $0x11cf3c,-0x50(%ebp)
    elm->prev = elm->next = elm;
  105415:	8b 45 b0             	mov    -0x50(%ebp),%eax
  105418:	8b 55 b0             	mov    -0x50(%ebp),%edx
  10541b:	89 50 04             	mov    %edx,0x4(%eax)
  10541e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  105421:	8b 50 04             	mov    0x4(%eax),%edx
  105424:	8b 45 b0             	mov    -0x50(%ebp),%eax
  105427:	89 10                	mov    %edx,(%eax)
  105429:	c7 45 b4 3c cf 11 00 	movl   $0x11cf3c,-0x4c(%ebp)
    return list->next == list;
  105430:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  105433:	8b 40 04             	mov    0x4(%eax),%eax
  105436:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
  105439:	0f 94 c0             	sete   %al
  10543c:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  10543f:	85 c0                	test   %eax,%eax
  105441:	75 24                	jne    105467 <default_check+0x1d0>
  105443:	c7 44 24 0c ff 73 10 	movl   $0x1073ff,0xc(%esp)
  10544a:	00 
  10544b:	c7 44 24 08 9e 71 10 	movl   $0x10719e,0x8(%esp)
  105452:	00 
  105453:	c7 44 24 04 3f 01 00 	movl   $0x13f,0x4(%esp)
  10545a:	00 
  10545b:	c7 04 24 b3 71 10 00 	movl   $0x1071b3,(%esp)
  105462:	e8 8b af ff ff       	call   1003f2 <__panic>
    assert(alloc_page() == NULL);
  105467:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10546e:	e8 9d db ff ff       	call   103010 <alloc_pages>
  105473:	85 c0                	test   %eax,%eax
  105475:	74 24                	je     10549b <default_check+0x204>
  105477:	c7 44 24 0c 16 74 10 	movl   $0x107416,0xc(%esp)
  10547e:	00 
  10547f:	c7 44 24 08 9e 71 10 	movl   $0x10719e,0x8(%esp)
  105486:	00 
  105487:	c7 44 24 04 40 01 00 	movl   $0x140,0x4(%esp)
  10548e:	00 
  10548f:	c7 04 24 b3 71 10 00 	movl   $0x1071b3,(%esp)
  105496:	e8 57 af ff ff       	call   1003f2 <__panic>

    unsigned int nr_free_store = nr_free;
  10549b:	a1 44 cf 11 00       	mov    0x11cf44,%eax
  1054a0:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
  1054a3:	c7 05 44 cf 11 00 00 	movl   $0x0,0x11cf44
  1054aa:	00 00 00 

    free_pages(p0 + 2, 3);
  1054ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1054b0:	83 c0 28             	add    $0x28,%eax
  1054b3:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  1054ba:	00 
  1054bb:	89 04 24             	mov    %eax,(%esp)
  1054be:	e8 85 db ff ff       	call   103048 <free_pages>
    assert(alloc_pages(4) == NULL);
  1054c3:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  1054ca:	e8 41 db ff ff       	call   103010 <alloc_pages>
  1054cf:	85 c0                	test   %eax,%eax
  1054d1:	74 24                	je     1054f7 <default_check+0x260>
  1054d3:	c7 44 24 0c bc 74 10 	movl   $0x1074bc,0xc(%esp)
  1054da:	00 
  1054db:	c7 44 24 08 9e 71 10 	movl   $0x10719e,0x8(%esp)
  1054e2:	00 
  1054e3:	c7 44 24 04 46 01 00 	movl   $0x146,0x4(%esp)
  1054ea:	00 
  1054eb:	c7 04 24 b3 71 10 00 	movl   $0x1071b3,(%esp)
  1054f2:	e8 fb ae ff ff       	call   1003f2 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  1054f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1054fa:	83 c0 28             	add    $0x28,%eax
  1054fd:	83 c0 04             	add    $0x4,%eax
  105500:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  105507:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10550a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  10550d:	8b 55 ac             	mov    -0x54(%ebp),%edx
  105510:	0f a3 10             	bt     %edx,(%eax)
  105513:	19 c0                	sbb    %eax,%eax
  105515:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  105518:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  10551c:	0f 95 c0             	setne  %al
  10551f:	0f b6 c0             	movzbl %al,%eax
  105522:	85 c0                	test   %eax,%eax
  105524:	74 0e                	je     105534 <default_check+0x29d>
  105526:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105529:	83 c0 28             	add    $0x28,%eax
  10552c:	8b 40 08             	mov    0x8(%eax),%eax
  10552f:	83 f8 03             	cmp    $0x3,%eax
  105532:	74 24                	je     105558 <default_check+0x2c1>
  105534:	c7 44 24 0c d4 74 10 	movl   $0x1074d4,0xc(%esp)
  10553b:	00 
  10553c:	c7 44 24 08 9e 71 10 	movl   $0x10719e,0x8(%esp)
  105543:	00 
  105544:	c7 44 24 04 47 01 00 	movl   $0x147,0x4(%esp)
  10554b:	00 
  10554c:	c7 04 24 b3 71 10 00 	movl   $0x1071b3,(%esp)
  105553:	e8 9a ae ff ff       	call   1003f2 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  105558:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  10555f:	e8 ac da ff ff       	call   103010 <alloc_pages>
  105564:	89 45 dc             	mov    %eax,-0x24(%ebp)
  105567:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  10556b:	75 24                	jne    105591 <default_check+0x2fa>
  10556d:	c7 44 24 0c 00 75 10 	movl   $0x107500,0xc(%esp)
  105574:	00 
  105575:	c7 44 24 08 9e 71 10 	movl   $0x10719e,0x8(%esp)
  10557c:	00 
  10557d:	c7 44 24 04 48 01 00 	movl   $0x148,0x4(%esp)
  105584:	00 
  105585:	c7 04 24 b3 71 10 00 	movl   $0x1071b3,(%esp)
  10558c:	e8 61 ae ff ff       	call   1003f2 <__panic>
    assert(alloc_page() == NULL);
  105591:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105598:	e8 73 da ff ff       	call   103010 <alloc_pages>
  10559d:	85 c0                	test   %eax,%eax
  10559f:	74 24                	je     1055c5 <default_check+0x32e>
  1055a1:	c7 44 24 0c 16 74 10 	movl   $0x107416,0xc(%esp)
  1055a8:	00 
  1055a9:	c7 44 24 08 9e 71 10 	movl   $0x10719e,0x8(%esp)
  1055b0:	00 
  1055b1:	c7 44 24 04 49 01 00 	movl   $0x149,0x4(%esp)
  1055b8:	00 
  1055b9:	c7 04 24 b3 71 10 00 	movl   $0x1071b3,(%esp)
  1055c0:	e8 2d ae ff ff       	call   1003f2 <__panic>
    assert(p0 + 2 == p1);
  1055c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1055c8:	83 c0 28             	add    $0x28,%eax
  1055cb:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  1055ce:	74 24                	je     1055f4 <default_check+0x35d>
  1055d0:	c7 44 24 0c 1e 75 10 	movl   $0x10751e,0xc(%esp)
  1055d7:	00 
  1055d8:	c7 44 24 08 9e 71 10 	movl   $0x10719e,0x8(%esp)
  1055df:	00 
  1055e0:	c7 44 24 04 4a 01 00 	movl   $0x14a,0x4(%esp)
  1055e7:	00 
  1055e8:	c7 04 24 b3 71 10 00 	movl   $0x1071b3,(%esp)
  1055ef:	e8 fe ad ff ff       	call   1003f2 <__panic>

    p2 = p0 + 1;
  1055f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1055f7:	83 c0 14             	add    $0x14,%eax
  1055fa:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
  1055fd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105604:	00 
  105605:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105608:	89 04 24             	mov    %eax,(%esp)
  10560b:	e8 38 da ff ff       	call   103048 <free_pages>
    free_pages(p1, 3);
  105610:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  105617:	00 
  105618:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10561b:	89 04 24             	mov    %eax,(%esp)
  10561e:	e8 25 da ff ff       	call   103048 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  105623:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105626:	83 c0 04             	add    $0x4,%eax
  105629:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  105630:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  105633:	8b 45 9c             	mov    -0x64(%ebp),%eax
  105636:	8b 55 a0             	mov    -0x60(%ebp),%edx
  105639:	0f a3 10             	bt     %edx,(%eax)
  10563c:	19 c0                	sbb    %eax,%eax
  10563e:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  105641:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  105645:	0f 95 c0             	setne  %al
  105648:	0f b6 c0             	movzbl %al,%eax
  10564b:	85 c0                	test   %eax,%eax
  10564d:	74 0b                	je     10565a <default_check+0x3c3>
  10564f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105652:	8b 40 08             	mov    0x8(%eax),%eax
  105655:	83 f8 01             	cmp    $0x1,%eax
  105658:	74 24                	je     10567e <default_check+0x3e7>
  10565a:	c7 44 24 0c 2c 75 10 	movl   $0x10752c,0xc(%esp)
  105661:	00 
  105662:	c7 44 24 08 9e 71 10 	movl   $0x10719e,0x8(%esp)
  105669:	00 
  10566a:	c7 44 24 04 4f 01 00 	movl   $0x14f,0x4(%esp)
  105671:	00 
  105672:	c7 04 24 b3 71 10 00 	movl   $0x1071b3,(%esp)
  105679:	e8 74 ad ff ff       	call   1003f2 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  10567e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105681:	83 c0 04             	add    $0x4,%eax
  105684:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  10568b:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10568e:	8b 45 90             	mov    -0x70(%ebp),%eax
  105691:	8b 55 94             	mov    -0x6c(%ebp),%edx
  105694:	0f a3 10             	bt     %edx,(%eax)
  105697:	19 c0                	sbb    %eax,%eax
  105699:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  10569c:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  1056a0:	0f 95 c0             	setne  %al
  1056a3:	0f b6 c0             	movzbl %al,%eax
  1056a6:	85 c0                	test   %eax,%eax
  1056a8:	74 0b                	je     1056b5 <default_check+0x41e>
  1056aa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1056ad:	8b 40 08             	mov    0x8(%eax),%eax
  1056b0:	83 f8 03             	cmp    $0x3,%eax
  1056b3:	74 24                	je     1056d9 <default_check+0x442>
  1056b5:	c7 44 24 0c 54 75 10 	movl   $0x107554,0xc(%esp)
  1056bc:	00 
  1056bd:	c7 44 24 08 9e 71 10 	movl   $0x10719e,0x8(%esp)
  1056c4:	00 
  1056c5:	c7 44 24 04 50 01 00 	movl   $0x150,0x4(%esp)
  1056cc:	00 
  1056cd:	c7 04 24 b3 71 10 00 	movl   $0x1071b3,(%esp)
  1056d4:	e8 19 ad ff ff       	call   1003f2 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  1056d9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1056e0:	e8 2b d9 ff ff       	call   103010 <alloc_pages>
  1056e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1056e8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1056eb:	83 e8 14             	sub    $0x14,%eax
  1056ee:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  1056f1:	74 24                	je     105717 <default_check+0x480>
  1056f3:	c7 44 24 0c 7a 75 10 	movl   $0x10757a,0xc(%esp)
  1056fa:	00 
  1056fb:	c7 44 24 08 9e 71 10 	movl   $0x10719e,0x8(%esp)
  105702:	00 
  105703:	c7 44 24 04 52 01 00 	movl   $0x152,0x4(%esp)
  10570a:	00 
  10570b:	c7 04 24 b3 71 10 00 	movl   $0x1071b3,(%esp)
  105712:	e8 db ac ff ff       	call   1003f2 <__panic>
    free_page(p0);
  105717:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10571e:	00 
  10571f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105722:	89 04 24             	mov    %eax,(%esp)
  105725:	e8 1e d9 ff ff       	call   103048 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  10572a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  105731:	e8 da d8 ff ff       	call   103010 <alloc_pages>
  105736:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105739:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10573c:	83 c0 14             	add    $0x14,%eax
  10573f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  105742:	74 24                	je     105768 <default_check+0x4d1>
  105744:	c7 44 24 0c 98 75 10 	movl   $0x107598,0xc(%esp)
  10574b:	00 
  10574c:	c7 44 24 08 9e 71 10 	movl   $0x10719e,0x8(%esp)
  105753:	00 
  105754:	c7 44 24 04 54 01 00 	movl   $0x154,0x4(%esp)
  10575b:	00 
  10575c:	c7 04 24 b3 71 10 00 	movl   $0x1071b3,(%esp)
  105763:	e8 8a ac ff ff       	call   1003f2 <__panic>

    free_pages(p0, 2);
  105768:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  10576f:	00 
  105770:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105773:	89 04 24             	mov    %eax,(%esp)
  105776:	e8 cd d8 ff ff       	call   103048 <free_pages>
    free_page(p2);
  10577b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105782:	00 
  105783:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105786:	89 04 24             	mov    %eax,(%esp)
  105789:	e8 ba d8 ff ff       	call   103048 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  10578e:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  105795:	e8 76 d8 ff ff       	call   103010 <alloc_pages>
  10579a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10579d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1057a1:	75 24                	jne    1057c7 <default_check+0x530>
  1057a3:	c7 44 24 0c b8 75 10 	movl   $0x1075b8,0xc(%esp)
  1057aa:	00 
  1057ab:	c7 44 24 08 9e 71 10 	movl   $0x10719e,0x8(%esp)
  1057b2:	00 
  1057b3:	c7 44 24 04 59 01 00 	movl   $0x159,0x4(%esp)
  1057ba:	00 
  1057bb:	c7 04 24 b3 71 10 00 	movl   $0x1071b3,(%esp)
  1057c2:	e8 2b ac ff ff       	call   1003f2 <__panic>
    assert(alloc_page() == NULL);
  1057c7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1057ce:	e8 3d d8 ff ff       	call   103010 <alloc_pages>
  1057d3:	85 c0                	test   %eax,%eax
  1057d5:	74 24                	je     1057fb <default_check+0x564>
  1057d7:	c7 44 24 0c 16 74 10 	movl   $0x107416,0xc(%esp)
  1057de:	00 
  1057df:	c7 44 24 08 9e 71 10 	movl   $0x10719e,0x8(%esp)
  1057e6:	00 
  1057e7:	c7 44 24 04 5a 01 00 	movl   $0x15a,0x4(%esp)
  1057ee:	00 
  1057ef:	c7 04 24 b3 71 10 00 	movl   $0x1071b3,(%esp)
  1057f6:	e8 f7 ab ff ff       	call   1003f2 <__panic>

    assert(nr_free == 0);
  1057fb:	a1 44 cf 11 00       	mov    0x11cf44,%eax
  105800:	85 c0                	test   %eax,%eax
  105802:	74 24                	je     105828 <default_check+0x591>
  105804:	c7 44 24 0c 69 74 10 	movl   $0x107469,0xc(%esp)
  10580b:	00 
  10580c:	c7 44 24 08 9e 71 10 	movl   $0x10719e,0x8(%esp)
  105813:	00 
  105814:	c7 44 24 04 5c 01 00 	movl   $0x15c,0x4(%esp)
  10581b:	00 
  10581c:	c7 04 24 b3 71 10 00 	movl   $0x1071b3,(%esp)
  105823:	e8 ca ab ff ff       	call   1003f2 <__panic>
    nr_free = nr_free_store;
  105828:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10582b:	a3 44 cf 11 00       	mov    %eax,0x11cf44

    free_list = free_list_store;
  105830:	8b 45 80             	mov    -0x80(%ebp),%eax
  105833:	8b 55 84             	mov    -0x7c(%ebp),%edx
  105836:	a3 3c cf 11 00       	mov    %eax,0x11cf3c
  10583b:	89 15 40 cf 11 00    	mov    %edx,0x11cf40
    free_pages(p0, 5);
  105841:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  105848:	00 
  105849:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10584c:	89 04 24             	mov    %eax,(%esp)
  10584f:	e8 f4 d7 ff ff       	call   103048 <free_pages>

    le = &free_list;
  105854:	c7 45 ec 3c cf 11 00 	movl   $0x11cf3c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  10585b:	eb 1c                	jmp    105879 <default_check+0x5e2>
        struct Page *p = le2page(le, page_link);
  10585d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105860:	83 e8 0c             	sub    $0xc,%eax
  105863:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
  105866:	ff 4d f4             	decl   -0xc(%ebp)
  105869:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10586c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10586f:	8b 40 08             	mov    0x8(%eax),%eax
  105872:	29 c2                	sub    %eax,%edx
  105874:	89 d0                	mov    %edx,%eax
  105876:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105879:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10587c:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
  10587f:	8b 45 88             	mov    -0x78(%ebp),%eax
  105882:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  105885:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105888:	81 7d ec 3c cf 11 00 	cmpl   $0x11cf3c,-0x14(%ebp)
  10588f:	75 cc                	jne    10585d <default_check+0x5c6>
    }
    assert(count == 0);
  105891:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  105895:	74 24                	je     1058bb <default_check+0x624>
  105897:	c7 44 24 0c d6 75 10 	movl   $0x1075d6,0xc(%esp)
  10589e:	00 
  10589f:	c7 44 24 08 9e 71 10 	movl   $0x10719e,0x8(%esp)
  1058a6:	00 
  1058a7:	c7 44 24 04 67 01 00 	movl   $0x167,0x4(%esp)
  1058ae:	00 
  1058af:	c7 04 24 b3 71 10 00 	movl   $0x1071b3,(%esp)
  1058b6:	e8 37 ab ff ff       	call   1003f2 <__panic>
    assert(total == 0);
  1058bb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1058bf:	74 24                	je     1058e5 <default_check+0x64e>
  1058c1:	c7 44 24 0c e1 75 10 	movl   $0x1075e1,0xc(%esp)
  1058c8:	00 
  1058c9:	c7 44 24 08 9e 71 10 	movl   $0x10719e,0x8(%esp)
  1058d0:	00 
  1058d1:	c7 44 24 04 68 01 00 	movl   $0x168,0x4(%esp)
  1058d8:	00 
  1058d9:	c7 04 24 b3 71 10 00 	movl   $0x1071b3,(%esp)
  1058e0:	e8 0d ab ff ff       	call   1003f2 <__panic>
}
  1058e5:	90                   	nop
  1058e6:	c9                   	leave  
  1058e7:	c3                   	ret    

001058e8 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  1058e8:	55                   	push   %ebp
  1058e9:	89 e5                	mov    %esp,%ebp
  1058eb:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  1058ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  1058f5:	eb 03                	jmp    1058fa <strlen+0x12>
        cnt ++;
  1058f7:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
  1058fa:	8b 45 08             	mov    0x8(%ebp),%eax
  1058fd:	8d 50 01             	lea    0x1(%eax),%edx
  105900:	89 55 08             	mov    %edx,0x8(%ebp)
  105903:	0f b6 00             	movzbl (%eax),%eax
  105906:	84 c0                	test   %al,%al
  105908:	75 ed                	jne    1058f7 <strlen+0xf>
    }
    return cnt;
  10590a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10590d:	c9                   	leave  
  10590e:	c3                   	ret    

0010590f <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  10590f:	55                   	push   %ebp
  105910:	89 e5                	mov    %esp,%ebp
  105912:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105915:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  10591c:	eb 03                	jmp    105921 <strnlen+0x12>
        cnt ++;
  10591e:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105921:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105924:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105927:	73 10                	jae    105939 <strnlen+0x2a>
  105929:	8b 45 08             	mov    0x8(%ebp),%eax
  10592c:	8d 50 01             	lea    0x1(%eax),%edx
  10592f:	89 55 08             	mov    %edx,0x8(%ebp)
  105932:	0f b6 00             	movzbl (%eax),%eax
  105935:	84 c0                	test   %al,%al
  105937:	75 e5                	jne    10591e <strnlen+0xf>
    }
    return cnt;
  105939:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10593c:	c9                   	leave  
  10593d:	c3                   	ret    

0010593e <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  10593e:	55                   	push   %ebp
  10593f:	89 e5                	mov    %esp,%ebp
  105941:	57                   	push   %edi
  105942:	56                   	push   %esi
  105943:	83 ec 20             	sub    $0x20,%esp
  105946:	8b 45 08             	mov    0x8(%ebp),%eax
  105949:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10594c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10594f:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  105952:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105955:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105958:	89 d1                	mov    %edx,%ecx
  10595a:	89 c2                	mov    %eax,%edx
  10595c:	89 ce                	mov    %ecx,%esi
  10595e:	89 d7                	mov    %edx,%edi
  105960:	ac                   	lods   %ds:(%esi),%al
  105961:	aa                   	stos   %al,%es:(%edi)
  105962:	84 c0                	test   %al,%al
  105964:	75 fa                	jne    105960 <strcpy+0x22>
  105966:	89 fa                	mov    %edi,%edx
  105968:	89 f1                	mov    %esi,%ecx
  10596a:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  10596d:	89 55 e8             	mov    %edx,-0x18(%ebp)
  105970:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  105973:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
  105976:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  105977:	83 c4 20             	add    $0x20,%esp
  10597a:	5e                   	pop    %esi
  10597b:	5f                   	pop    %edi
  10597c:	5d                   	pop    %ebp
  10597d:	c3                   	ret    

0010597e <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  10597e:	55                   	push   %ebp
  10597f:	89 e5                	mov    %esp,%ebp
  105981:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  105984:	8b 45 08             	mov    0x8(%ebp),%eax
  105987:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  10598a:	eb 1e                	jmp    1059aa <strncpy+0x2c>
        if ((*p = *src) != '\0') {
  10598c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10598f:	0f b6 10             	movzbl (%eax),%edx
  105992:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105995:	88 10                	mov    %dl,(%eax)
  105997:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10599a:	0f b6 00             	movzbl (%eax),%eax
  10599d:	84 c0                	test   %al,%al
  10599f:	74 03                	je     1059a4 <strncpy+0x26>
            src ++;
  1059a1:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
  1059a4:	ff 45 fc             	incl   -0x4(%ebp)
  1059a7:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
  1059aa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1059ae:	75 dc                	jne    10598c <strncpy+0xe>
    }
    return dst;
  1059b0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1059b3:	c9                   	leave  
  1059b4:	c3                   	ret    

001059b5 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  1059b5:	55                   	push   %ebp
  1059b6:	89 e5                	mov    %esp,%ebp
  1059b8:	57                   	push   %edi
  1059b9:	56                   	push   %esi
  1059ba:	83 ec 20             	sub    $0x20,%esp
  1059bd:	8b 45 08             	mov    0x8(%ebp),%eax
  1059c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1059c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  1059c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1059cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1059cf:	89 d1                	mov    %edx,%ecx
  1059d1:	89 c2                	mov    %eax,%edx
  1059d3:	89 ce                	mov    %ecx,%esi
  1059d5:	89 d7                	mov    %edx,%edi
  1059d7:	ac                   	lods   %ds:(%esi),%al
  1059d8:	ae                   	scas   %es:(%edi),%al
  1059d9:	75 08                	jne    1059e3 <strcmp+0x2e>
  1059db:	84 c0                	test   %al,%al
  1059dd:	75 f8                	jne    1059d7 <strcmp+0x22>
  1059df:	31 c0                	xor    %eax,%eax
  1059e1:	eb 04                	jmp    1059e7 <strcmp+0x32>
  1059e3:	19 c0                	sbb    %eax,%eax
  1059e5:	0c 01                	or     $0x1,%al
  1059e7:	89 fa                	mov    %edi,%edx
  1059e9:	89 f1                	mov    %esi,%ecx
  1059eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1059ee:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1059f1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  1059f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
  1059f7:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  1059f8:	83 c4 20             	add    $0x20,%esp
  1059fb:	5e                   	pop    %esi
  1059fc:	5f                   	pop    %edi
  1059fd:	5d                   	pop    %ebp
  1059fe:	c3                   	ret    

001059ff <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  1059ff:	55                   	push   %ebp
  105a00:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105a02:	eb 09                	jmp    105a0d <strncmp+0xe>
        n --, s1 ++, s2 ++;
  105a04:	ff 4d 10             	decl   0x10(%ebp)
  105a07:	ff 45 08             	incl   0x8(%ebp)
  105a0a:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105a0d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105a11:	74 1a                	je     105a2d <strncmp+0x2e>
  105a13:	8b 45 08             	mov    0x8(%ebp),%eax
  105a16:	0f b6 00             	movzbl (%eax),%eax
  105a19:	84 c0                	test   %al,%al
  105a1b:	74 10                	je     105a2d <strncmp+0x2e>
  105a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  105a20:	0f b6 10             	movzbl (%eax),%edx
  105a23:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a26:	0f b6 00             	movzbl (%eax),%eax
  105a29:	38 c2                	cmp    %al,%dl
  105a2b:	74 d7                	je     105a04 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  105a2d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105a31:	74 18                	je     105a4b <strncmp+0x4c>
  105a33:	8b 45 08             	mov    0x8(%ebp),%eax
  105a36:	0f b6 00             	movzbl (%eax),%eax
  105a39:	0f b6 d0             	movzbl %al,%edx
  105a3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a3f:	0f b6 00             	movzbl (%eax),%eax
  105a42:	0f b6 c0             	movzbl %al,%eax
  105a45:	29 c2                	sub    %eax,%edx
  105a47:	89 d0                	mov    %edx,%eax
  105a49:	eb 05                	jmp    105a50 <strncmp+0x51>
  105a4b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105a50:	5d                   	pop    %ebp
  105a51:	c3                   	ret    

00105a52 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  105a52:	55                   	push   %ebp
  105a53:	89 e5                	mov    %esp,%ebp
  105a55:	83 ec 04             	sub    $0x4,%esp
  105a58:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a5b:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105a5e:	eb 13                	jmp    105a73 <strchr+0x21>
        if (*s == c) {
  105a60:	8b 45 08             	mov    0x8(%ebp),%eax
  105a63:	0f b6 00             	movzbl (%eax),%eax
  105a66:	38 45 fc             	cmp    %al,-0x4(%ebp)
  105a69:	75 05                	jne    105a70 <strchr+0x1e>
            return (char *)s;
  105a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  105a6e:	eb 12                	jmp    105a82 <strchr+0x30>
        }
        s ++;
  105a70:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  105a73:	8b 45 08             	mov    0x8(%ebp),%eax
  105a76:	0f b6 00             	movzbl (%eax),%eax
  105a79:	84 c0                	test   %al,%al
  105a7b:	75 e3                	jne    105a60 <strchr+0xe>
    }
    return NULL;
  105a7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105a82:	c9                   	leave  
  105a83:	c3                   	ret    

00105a84 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  105a84:	55                   	push   %ebp
  105a85:	89 e5                	mov    %esp,%ebp
  105a87:	83 ec 04             	sub    $0x4,%esp
  105a8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a8d:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105a90:	eb 0e                	jmp    105aa0 <strfind+0x1c>
        if (*s == c) {
  105a92:	8b 45 08             	mov    0x8(%ebp),%eax
  105a95:	0f b6 00             	movzbl (%eax),%eax
  105a98:	38 45 fc             	cmp    %al,-0x4(%ebp)
  105a9b:	74 0f                	je     105aac <strfind+0x28>
            break;
        }
        s ++;
  105a9d:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  105aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  105aa3:	0f b6 00             	movzbl (%eax),%eax
  105aa6:	84 c0                	test   %al,%al
  105aa8:	75 e8                	jne    105a92 <strfind+0xe>
  105aaa:	eb 01                	jmp    105aad <strfind+0x29>
            break;
  105aac:	90                   	nop
    }
    return (char *)s;
  105aad:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105ab0:	c9                   	leave  
  105ab1:	c3                   	ret    

00105ab2 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  105ab2:	55                   	push   %ebp
  105ab3:	89 e5                	mov    %esp,%ebp
  105ab5:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  105ab8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  105abf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105ac6:	eb 03                	jmp    105acb <strtol+0x19>
        s ++;
  105ac8:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  105acb:	8b 45 08             	mov    0x8(%ebp),%eax
  105ace:	0f b6 00             	movzbl (%eax),%eax
  105ad1:	3c 20                	cmp    $0x20,%al
  105ad3:	74 f3                	je     105ac8 <strtol+0x16>
  105ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  105ad8:	0f b6 00             	movzbl (%eax),%eax
  105adb:	3c 09                	cmp    $0x9,%al
  105add:	74 e9                	je     105ac8 <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
  105adf:	8b 45 08             	mov    0x8(%ebp),%eax
  105ae2:	0f b6 00             	movzbl (%eax),%eax
  105ae5:	3c 2b                	cmp    $0x2b,%al
  105ae7:	75 05                	jne    105aee <strtol+0x3c>
        s ++;
  105ae9:	ff 45 08             	incl   0x8(%ebp)
  105aec:	eb 14                	jmp    105b02 <strtol+0x50>
    }
    else if (*s == '-') {
  105aee:	8b 45 08             	mov    0x8(%ebp),%eax
  105af1:	0f b6 00             	movzbl (%eax),%eax
  105af4:	3c 2d                	cmp    $0x2d,%al
  105af6:	75 0a                	jne    105b02 <strtol+0x50>
        s ++, neg = 1;
  105af8:	ff 45 08             	incl   0x8(%ebp)
  105afb:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  105b02:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105b06:	74 06                	je     105b0e <strtol+0x5c>
  105b08:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  105b0c:	75 22                	jne    105b30 <strtol+0x7e>
  105b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  105b11:	0f b6 00             	movzbl (%eax),%eax
  105b14:	3c 30                	cmp    $0x30,%al
  105b16:	75 18                	jne    105b30 <strtol+0x7e>
  105b18:	8b 45 08             	mov    0x8(%ebp),%eax
  105b1b:	40                   	inc    %eax
  105b1c:	0f b6 00             	movzbl (%eax),%eax
  105b1f:	3c 78                	cmp    $0x78,%al
  105b21:	75 0d                	jne    105b30 <strtol+0x7e>
        s += 2, base = 16;
  105b23:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  105b27:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  105b2e:	eb 29                	jmp    105b59 <strtol+0xa7>
    }
    else if (base == 0 && s[0] == '0') {
  105b30:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105b34:	75 16                	jne    105b4c <strtol+0x9a>
  105b36:	8b 45 08             	mov    0x8(%ebp),%eax
  105b39:	0f b6 00             	movzbl (%eax),%eax
  105b3c:	3c 30                	cmp    $0x30,%al
  105b3e:	75 0c                	jne    105b4c <strtol+0x9a>
        s ++, base = 8;
  105b40:	ff 45 08             	incl   0x8(%ebp)
  105b43:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  105b4a:	eb 0d                	jmp    105b59 <strtol+0xa7>
    }
    else if (base == 0) {
  105b4c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105b50:	75 07                	jne    105b59 <strtol+0xa7>
        base = 10;
  105b52:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  105b59:	8b 45 08             	mov    0x8(%ebp),%eax
  105b5c:	0f b6 00             	movzbl (%eax),%eax
  105b5f:	3c 2f                	cmp    $0x2f,%al
  105b61:	7e 1b                	jle    105b7e <strtol+0xcc>
  105b63:	8b 45 08             	mov    0x8(%ebp),%eax
  105b66:	0f b6 00             	movzbl (%eax),%eax
  105b69:	3c 39                	cmp    $0x39,%al
  105b6b:	7f 11                	jg     105b7e <strtol+0xcc>
            dig = *s - '0';
  105b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  105b70:	0f b6 00             	movzbl (%eax),%eax
  105b73:	0f be c0             	movsbl %al,%eax
  105b76:	83 e8 30             	sub    $0x30,%eax
  105b79:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105b7c:	eb 48                	jmp    105bc6 <strtol+0x114>
        }
        else if (*s >= 'a' && *s <= 'z') {
  105b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  105b81:	0f b6 00             	movzbl (%eax),%eax
  105b84:	3c 60                	cmp    $0x60,%al
  105b86:	7e 1b                	jle    105ba3 <strtol+0xf1>
  105b88:	8b 45 08             	mov    0x8(%ebp),%eax
  105b8b:	0f b6 00             	movzbl (%eax),%eax
  105b8e:	3c 7a                	cmp    $0x7a,%al
  105b90:	7f 11                	jg     105ba3 <strtol+0xf1>
            dig = *s - 'a' + 10;
  105b92:	8b 45 08             	mov    0x8(%ebp),%eax
  105b95:	0f b6 00             	movzbl (%eax),%eax
  105b98:	0f be c0             	movsbl %al,%eax
  105b9b:	83 e8 57             	sub    $0x57,%eax
  105b9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105ba1:	eb 23                	jmp    105bc6 <strtol+0x114>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  105ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  105ba6:	0f b6 00             	movzbl (%eax),%eax
  105ba9:	3c 40                	cmp    $0x40,%al
  105bab:	7e 3b                	jle    105be8 <strtol+0x136>
  105bad:	8b 45 08             	mov    0x8(%ebp),%eax
  105bb0:	0f b6 00             	movzbl (%eax),%eax
  105bb3:	3c 5a                	cmp    $0x5a,%al
  105bb5:	7f 31                	jg     105be8 <strtol+0x136>
            dig = *s - 'A' + 10;
  105bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  105bba:	0f b6 00             	movzbl (%eax),%eax
  105bbd:	0f be c0             	movsbl %al,%eax
  105bc0:	83 e8 37             	sub    $0x37,%eax
  105bc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  105bc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105bc9:	3b 45 10             	cmp    0x10(%ebp),%eax
  105bcc:	7d 19                	jge    105be7 <strtol+0x135>
            break;
        }
        s ++, val = (val * base) + dig;
  105bce:	ff 45 08             	incl   0x8(%ebp)
  105bd1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105bd4:	0f af 45 10          	imul   0x10(%ebp),%eax
  105bd8:	89 c2                	mov    %eax,%edx
  105bda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105bdd:	01 d0                	add    %edx,%eax
  105bdf:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  105be2:	e9 72 ff ff ff       	jmp    105b59 <strtol+0xa7>
            break;
  105be7:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  105be8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105bec:	74 08                	je     105bf6 <strtol+0x144>
        *endptr = (char *) s;
  105bee:	8b 45 0c             	mov    0xc(%ebp),%eax
  105bf1:	8b 55 08             	mov    0x8(%ebp),%edx
  105bf4:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  105bf6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  105bfa:	74 07                	je     105c03 <strtol+0x151>
  105bfc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105bff:	f7 d8                	neg    %eax
  105c01:	eb 03                	jmp    105c06 <strtol+0x154>
  105c03:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  105c06:	c9                   	leave  
  105c07:	c3                   	ret    

00105c08 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  105c08:	55                   	push   %ebp
  105c09:	89 e5                	mov    %esp,%ebp
  105c0b:	57                   	push   %edi
  105c0c:	83 ec 24             	sub    $0x24,%esp
  105c0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c12:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  105c15:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  105c19:	8b 45 08             	mov    0x8(%ebp),%eax
  105c1c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  105c1f:	88 55 f7             	mov    %dl,-0x9(%ebp)
  105c22:	8b 45 10             	mov    0x10(%ebp),%eax
  105c25:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  105c28:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  105c2b:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  105c2f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  105c32:	89 d7                	mov    %edx,%edi
  105c34:	f3 aa                	rep stos %al,%es:(%edi)
  105c36:	89 fa                	mov    %edi,%edx
  105c38:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105c3b:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  105c3e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105c41:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  105c42:	83 c4 24             	add    $0x24,%esp
  105c45:	5f                   	pop    %edi
  105c46:	5d                   	pop    %ebp
  105c47:	c3                   	ret    

00105c48 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  105c48:	55                   	push   %ebp
  105c49:	89 e5                	mov    %esp,%ebp
  105c4b:	57                   	push   %edi
  105c4c:	56                   	push   %esi
  105c4d:	53                   	push   %ebx
  105c4e:	83 ec 30             	sub    $0x30,%esp
  105c51:	8b 45 08             	mov    0x8(%ebp),%eax
  105c54:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105c57:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c5a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105c5d:	8b 45 10             	mov    0x10(%ebp),%eax
  105c60:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  105c63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105c66:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  105c69:	73 42                	jae    105cad <memmove+0x65>
  105c6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105c6e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105c71:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105c74:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105c77:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105c7a:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105c7d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105c80:	c1 e8 02             	shr    $0x2,%eax
  105c83:	89 c1                	mov    %eax,%ecx
    asm volatile (
  105c85:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105c88:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105c8b:	89 d7                	mov    %edx,%edi
  105c8d:	89 c6                	mov    %eax,%esi
  105c8f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105c91:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105c94:	83 e1 03             	and    $0x3,%ecx
  105c97:	74 02                	je     105c9b <memmove+0x53>
  105c99:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105c9b:	89 f0                	mov    %esi,%eax
  105c9d:	89 fa                	mov    %edi,%edx
  105c9f:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  105ca2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  105ca5:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
  105ca8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
  105cab:	eb 36                	jmp    105ce3 <memmove+0x9b>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  105cad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105cb0:	8d 50 ff             	lea    -0x1(%eax),%edx
  105cb3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105cb6:	01 c2                	add    %eax,%edx
  105cb8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105cbb:	8d 48 ff             	lea    -0x1(%eax),%ecx
  105cbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105cc1:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  105cc4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105cc7:	89 c1                	mov    %eax,%ecx
  105cc9:	89 d8                	mov    %ebx,%eax
  105ccb:	89 d6                	mov    %edx,%esi
  105ccd:	89 c7                	mov    %eax,%edi
  105ccf:	fd                   	std    
  105cd0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105cd2:	fc                   	cld    
  105cd3:	89 f8                	mov    %edi,%eax
  105cd5:	89 f2                	mov    %esi,%edx
  105cd7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  105cda:	89 55 c8             	mov    %edx,-0x38(%ebp)
  105cdd:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  105ce0:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  105ce3:	83 c4 30             	add    $0x30,%esp
  105ce6:	5b                   	pop    %ebx
  105ce7:	5e                   	pop    %esi
  105ce8:	5f                   	pop    %edi
  105ce9:	5d                   	pop    %ebp
  105cea:	c3                   	ret    

00105ceb <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  105ceb:	55                   	push   %ebp
  105cec:	89 e5                	mov    %esp,%ebp
  105cee:	57                   	push   %edi
  105cef:	56                   	push   %esi
  105cf0:	83 ec 20             	sub    $0x20,%esp
  105cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  105cf6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105cf9:	8b 45 0c             	mov    0xc(%ebp),%eax
  105cfc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105cff:	8b 45 10             	mov    0x10(%ebp),%eax
  105d02:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105d05:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105d08:	c1 e8 02             	shr    $0x2,%eax
  105d0b:	89 c1                	mov    %eax,%ecx
    asm volatile (
  105d0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105d10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105d13:	89 d7                	mov    %edx,%edi
  105d15:	89 c6                	mov    %eax,%esi
  105d17:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105d19:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  105d1c:	83 e1 03             	and    $0x3,%ecx
  105d1f:	74 02                	je     105d23 <memcpy+0x38>
  105d21:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105d23:	89 f0                	mov    %esi,%eax
  105d25:	89 fa                	mov    %edi,%edx
  105d27:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105d2a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  105d2d:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  105d30:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
  105d33:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  105d34:	83 c4 20             	add    $0x20,%esp
  105d37:	5e                   	pop    %esi
  105d38:	5f                   	pop    %edi
  105d39:	5d                   	pop    %ebp
  105d3a:	c3                   	ret    

00105d3b <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  105d3b:	55                   	push   %ebp
  105d3c:	89 e5                	mov    %esp,%ebp
  105d3e:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  105d41:	8b 45 08             	mov    0x8(%ebp),%eax
  105d44:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  105d47:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d4a:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  105d4d:	eb 2e                	jmp    105d7d <memcmp+0x42>
        if (*s1 != *s2) {
  105d4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105d52:	0f b6 10             	movzbl (%eax),%edx
  105d55:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105d58:	0f b6 00             	movzbl (%eax),%eax
  105d5b:	38 c2                	cmp    %al,%dl
  105d5d:	74 18                	je     105d77 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  105d5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105d62:	0f b6 00             	movzbl (%eax),%eax
  105d65:	0f b6 d0             	movzbl %al,%edx
  105d68:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105d6b:	0f b6 00             	movzbl (%eax),%eax
  105d6e:	0f b6 c0             	movzbl %al,%eax
  105d71:	29 c2                	sub    %eax,%edx
  105d73:	89 d0                	mov    %edx,%eax
  105d75:	eb 18                	jmp    105d8f <memcmp+0x54>
        }
        s1 ++, s2 ++;
  105d77:	ff 45 fc             	incl   -0x4(%ebp)
  105d7a:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
  105d7d:	8b 45 10             	mov    0x10(%ebp),%eax
  105d80:	8d 50 ff             	lea    -0x1(%eax),%edx
  105d83:	89 55 10             	mov    %edx,0x10(%ebp)
  105d86:	85 c0                	test   %eax,%eax
  105d88:	75 c5                	jne    105d4f <memcmp+0x14>
    }
    return 0;
  105d8a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105d8f:	c9                   	leave  
  105d90:	c3                   	ret    

00105d91 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  105d91:	55                   	push   %ebp
  105d92:	89 e5                	mov    %esp,%ebp
  105d94:	83 ec 58             	sub    $0x58,%esp
  105d97:	8b 45 10             	mov    0x10(%ebp),%eax
  105d9a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  105d9d:	8b 45 14             	mov    0x14(%ebp),%eax
  105da0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  105da3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  105da6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105da9:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105dac:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  105daf:	8b 45 18             	mov    0x18(%ebp),%eax
  105db2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105db5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105db8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105dbb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105dbe:	89 55 f0             	mov    %edx,-0x10(%ebp)
  105dc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105dc4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105dc7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105dcb:	74 1c                	je     105de9 <printnum+0x58>
  105dcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105dd0:	ba 00 00 00 00       	mov    $0x0,%edx
  105dd5:	f7 75 e4             	divl   -0x1c(%ebp)
  105dd8:	89 55 f4             	mov    %edx,-0xc(%ebp)
  105ddb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105dde:	ba 00 00 00 00       	mov    $0x0,%edx
  105de3:	f7 75 e4             	divl   -0x1c(%ebp)
  105de6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105de9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105dec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105def:	f7 75 e4             	divl   -0x1c(%ebp)
  105df2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105df5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  105df8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105dfb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105dfe:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105e01:	89 55 ec             	mov    %edx,-0x14(%ebp)
  105e04:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105e07:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  105e0a:	8b 45 18             	mov    0x18(%ebp),%eax
  105e0d:	ba 00 00 00 00       	mov    $0x0,%edx
  105e12:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  105e15:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  105e18:	19 d1                	sbb    %edx,%ecx
  105e1a:	72 4c                	jb     105e68 <printnum+0xd7>
        printnum(putch, putdat, result, base, width - 1, padc);
  105e1c:	8b 45 1c             	mov    0x1c(%ebp),%eax
  105e1f:	8d 50 ff             	lea    -0x1(%eax),%edx
  105e22:	8b 45 20             	mov    0x20(%ebp),%eax
  105e25:	89 44 24 18          	mov    %eax,0x18(%esp)
  105e29:	89 54 24 14          	mov    %edx,0x14(%esp)
  105e2d:	8b 45 18             	mov    0x18(%ebp),%eax
  105e30:	89 44 24 10          	mov    %eax,0x10(%esp)
  105e34:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105e37:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105e3a:	89 44 24 08          	mov    %eax,0x8(%esp)
  105e3e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105e42:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e45:	89 44 24 04          	mov    %eax,0x4(%esp)
  105e49:	8b 45 08             	mov    0x8(%ebp),%eax
  105e4c:	89 04 24             	mov    %eax,(%esp)
  105e4f:	e8 3d ff ff ff       	call   105d91 <printnum>
  105e54:	eb 1b                	jmp    105e71 <printnum+0xe0>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  105e56:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e59:	89 44 24 04          	mov    %eax,0x4(%esp)
  105e5d:	8b 45 20             	mov    0x20(%ebp),%eax
  105e60:	89 04 24             	mov    %eax,(%esp)
  105e63:	8b 45 08             	mov    0x8(%ebp),%eax
  105e66:	ff d0                	call   *%eax
        while (-- width > 0)
  105e68:	ff 4d 1c             	decl   0x1c(%ebp)
  105e6b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  105e6f:	7f e5                	jg     105e56 <printnum+0xc5>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  105e71:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105e74:	05 9c 76 10 00       	add    $0x10769c,%eax
  105e79:	0f b6 00             	movzbl (%eax),%eax
  105e7c:	0f be c0             	movsbl %al,%eax
  105e7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  105e82:	89 54 24 04          	mov    %edx,0x4(%esp)
  105e86:	89 04 24             	mov    %eax,(%esp)
  105e89:	8b 45 08             	mov    0x8(%ebp),%eax
  105e8c:	ff d0                	call   *%eax
}
  105e8e:	90                   	nop
  105e8f:	c9                   	leave  
  105e90:	c3                   	ret    

00105e91 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  105e91:	55                   	push   %ebp
  105e92:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105e94:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105e98:	7e 14                	jle    105eae <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  105e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  105e9d:	8b 00                	mov    (%eax),%eax
  105e9f:	8d 48 08             	lea    0x8(%eax),%ecx
  105ea2:	8b 55 08             	mov    0x8(%ebp),%edx
  105ea5:	89 0a                	mov    %ecx,(%edx)
  105ea7:	8b 50 04             	mov    0x4(%eax),%edx
  105eaa:	8b 00                	mov    (%eax),%eax
  105eac:	eb 30                	jmp    105ede <getuint+0x4d>
    }
    else if (lflag) {
  105eae:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105eb2:	74 16                	je     105eca <getuint+0x39>
        return va_arg(*ap, unsigned long);
  105eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  105eb7:	8b 00                	mov    (%eax),%eax
  105eb9:	8d 48 04             	lea    0x4(%eax),%ecx
  105ebc:	8b 55 08             	mov    0x8(%ebp),%edx
  105ebf:	89 0a                	mov    %ecx,(%edx)
  105ec1:	8b 00                	mov    (%eax),%eax
  105ec3:	ba 00 00 00 00       	mov    $0x0,%edx
  105ec8:	eb 14                	jmp    105ede <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  105eca:	8b 45 08             	mov    0x8(%ebp),%eax
  105ecd:	8b 00                	mov    (%eax),%eax
  105ecf:	8d 48 04             	lea    0x4(%eax),%ecx
  105ed2:	8b 55 08             	mov    0x8(%ebp),%edx
  105ed5:	89 0a                	mov    %ecx,(%edx)
  105ed7:	8b 00                	mov    (%eax),%eax
  105ed9:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  105ede:	5d                   	pop    %ebp
  105edf:	c3                   	ret    

00105ee0 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  105ee0:	55                   	push   %ebp
  105ee1:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105ee3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105ee7:	7e 14                	jle    105efd <getint+0x1d>
        return va_arg(*ap, long long);
  105ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  105eec:	8b 00                	mov    (%eax),%eax
  105eee:	8d 48 08             	lea    0x8(%eax),%ecx
  105ef1:	8b 55 08             	mov    0x8(%ebp),%edx
  105ef4:	89 0a                	mov    %ecx,(%edx)
  105ef6:	8b 50 04             	mov    0x4(%eax),%edx
  105ef9:	8b 00                	mov    (%eax),%eax
  105efb:	eb 28                	jmp    105f25 <getint+0x45>
    }
    else if (lflag) {
  105efd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105f01:	74 12                	je     105f15 <getint+0x35>
        return va_arg(*ap, long);
  105f03:	8b 45 08             	mov    0x8(%ebp),%eax
  105f06:	8b 00                	mov    (%eax),%eax
  105f08:	8d 48 04             	lea    0x4(%eax),%ecx
  105f0b:	8b 55 08             	mov    0x8(%ebp),%edx
  105f0e:	89 0a                	mov    %ecx,(%edx)
  105f10:	8b 00                	mov    (%eax),%eax
  105f12:	99                   	cltd   
  105f13:	eb 10                	jmp    105f25 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  105f15:	8b 45 08             	mov    0x8(%ebp),%eax
  105f18:	8b 00                	mov    (%eax),%eax
  105f1a:	8d 48 04             	lea    0x4(%eax),%ecx
  105f1d:	8b 55 08             	mov    0x8(%ebp),%edx
  105f20:	89 0a                	mov    %ecx,(%edx)
  105f22:	8b 00                	mov    (%eax),%eax
  105f24:	99                   	cltd   
    }
}
  105f25:	5d                   	pop    %ebp
  105f26:	c3                   	ret    

00105f27 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  105f27:	55                   	push   %ebp
  105f28:	89 e5                	mov    %esp,%ebp
  105f2a:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  105f2d:	8d 45 14             	lea    0x14(%ebp),%eax
  105f30:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  105f33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105f36:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105f3a:	8b 45 10             	mov    0x10(%ebp),%eax
  105f3d:	89 44 24 08          	mov    %eax,0x8(%esp)
  105f41:	8b 45 0c             	mov    0xc(%ebp),%eax
  105f44:	89 44 24 04          	mov    %eax,0x4(%esp)
  105f48:	8b 45 08             	mov    0x8(%ebp),%eax
  105f4b:	89 04 24             	mov    %eax,(%esp)
  105f4e:	e8 03 00 00 00       	call   105f56 <vprintfmt>
    va_end(ap);
}
  105f53:	90                   	nop
  105f54:	c9                   	leave  
  105f55:	c3                   	ret    

00105f56 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  105f56:	55                   	push   %ebp
  105f57:	89 e5                	mov    %esp,%ebp
  105f59:	56                   	push   %esi
  105f5a:	53                   	push   %ebx
  105f5b:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105f5e:	eb 17                	jmp    105f77 <vprintfmt+0x21>
            if (ch == '\0') {
  105f60:	85 db                	test   %ebx,%ebx
  105f62:	0f 84 bf 03 00 00    	je     106327 <vprintfmt+0x3d1>
                return;
            }
            putch(ch, putdat);
  105f68:	8b 45 0c             	mov    0xc(%ebp),%eax
  105f6b:	89 44 24 04          	mov    %eax,0x4(%esp)
  105f6f:	89 1c 24             	mov    %ebx,(%esp)
  105f72:	8b 45 08             	mov    0x8(%ebp),%eax
  105f75:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105f77:	8b 45 10             	mov    0x10(%ebp),%eax
  105f7a:	8d 50 01             	lea    0x1(%eax),%edx
  105f7d:	89 55 10             	mov    %edx,0x10(%ebp)
  105f80:	0f b6 00             	movzbl (%eax),%eax
  105f83:	0f b6 d8             	movzbl %al,%ebx
  105f86:	83 fb 25             	cmp    $0x25,%ebx
  105f89:	75 d5                	jne    105f60 <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
  105f8b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  105f8f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  105f96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105f99:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  105f9c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  105fa3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105fa6:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  105fa9:	8b 45 10             	mov    0x10(%ebp),%eax
  105fac:	8d 50 01             	lea    0x1(%eax),%edx
  105faf:	89 55 10             	mov    %edx,0x10(%ebp)
  105fb2:	0f b6 00             	movzbl (%eax),%eax
  105fb5:	0f b6 d8             	movzbl %al,%ebx
  105fb8:	8d 43 dd             	lea    -0x23(%ebx),%eax
  105fbb:	83 f8 55             	cmp    $0x55,%eax
  105fbe:	0f 87 37 03 00 00    	ja     1062fb <vprintfmt+0x3a5>
  105fc4:	8b 04 85 c0 76 10 00 	mov    0x1076c0(,%eax,4),%eax
  105fcb:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  105fcd:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  105fd1:	eb d6                	jmp    105fa9 <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  105fd3:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  105fd7:	eb d0                	jmp    105fa9 <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  105fd9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  105fe0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105fe3:	89 d0                	mov    %edx,%eax
  105fe5:	c1 e0 02             	shl    $0x2,%eax
  105fe8:	01 d0                	add    %edx,%eax
  105fea:	01 c0                	add    %eax,%eax
  105fec:	01 d8                	add    %ebx,%eax
  105fee:	83 e8 30             	sub    $0x30,%eax
  105ff1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  105ff4:	8b 45 10             	mov    0x10(%ebp),%eax
  105ff7:	0f b6 00             	movzbl (%eax),%eax
  105ffa:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  105ffd:	83 fb 2f             	cmp    $0x2f,%ebx
  106000:	7e 38                	jle    10603a <vprintfmt+0xe4>
  106002:	83 fb 39             	cmp    $0x39,%ebx
  106005:	7f 33                	jg     10603a <vprintfmt+0xe4>
            for (precision = 0; ; ++ fmt) {
  106007:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
  10600a:	eb d4                	jmp    105fe0 <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  10600c:	8b 45 14             	mov    0x14(%ebp),%eax
  10600f:	8d 50 04             	lea    0x4(%eax),%edx
  106012:	89 55 14             	mov    %edx,0x14(%ebp)
  106015:	8b 00                	mov    (%eax),%eax
  106017:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  10601a:	eb 1f                	jmp    10603b <vprintfmt+0xe5>

        case '.':
            if (width < 0)
  10601c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  106020:	79 87                	jns    105fa9 <vprintfmt+0x53>
                width = 0;
  106022:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  106029:	e9 7b ff ff ff       	jmp    105fa9 <vprintfmt+0x53>

        case '#':
            altflag = 1;
  10602e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  106035:	e9 6f ff ff ff       	jmp    105fa9 <vprintfmt+0x53>
            goto process_precision;
  10603a:	90                   	nop

        process_precision:
            if (width < 0)
  10603b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10603f:	0f 89 64 ff ff ff    	jns    105fa9 <vprintfmt+0x53>
                width = precision, precision = -1;
  106045:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106048:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10604b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  106052:	e9 52 ff ff ff       	jmp    105fa9 <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  106057:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
  10605a:	e9 4a ff ff ff       	jmp    105fa9 <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  10605f:	8b 45 14             	mov    0x14(%ebp),%eax
  106062:	8d 50 04             	lea    0x4(%eax),%edx
  106065:	89 55 14             	mov    %edx,0x14(%ebp)
  106068:	8b 00                	mov    (%eax),%eax
  10606a:	8b 55 0c             	mov    0xc(%ebp),%edx
  10606d:	89 54 24 04          	mov    %edx,0x4(%esp)
  106071:	89 04 24             	mov    %eax,(%esp)
  106074:	8b 45 08             	mov    0x8(%ebp),%eax
  106077:	ff d0                	call   *%eax
            break;
  106079:	e9 a4 02 00 00       	jmp    106322 <vprintfmt+0x3cc>

        // error message
        case 'e':
            err = va_arg(ap, int);
  10607e:	8b 45 14             	mov    0x14(%ebp),%eax
  106081:	8d 50 04             	lea    0x4(%eax),%edx
  106084:	89 55 14             	mov    %edx,0x14(%ebp)
  106087:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  106089:	85 db                	test   %ebx,%ebx
  10608b:	79 02                	jns    10608f <vprintfmt+0x139>
                err = -err;
  10608d:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  10608f:	83 fb 06             	cmp    $0x6,%ebx
  106092:	7f 0b                	jg     10609f <vprintfmt+0x149>
  106094:	8b 34 9d 80 76 10 00 	mov    0x107680(,%ebx,4),%esi
  10609b:	85 f6                	test   %esi,%esi
  10609d:	75 23                	jne    1060c2 <vprintfmt+0x16c>
                printfmt(putch, putdat, "error %d", err);
  10609f:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1060a3:	c7 44 24 08 ad 76 10 	movl   $0x1076ad,0x8(%esp)
  1060aa:	00 
  1060ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  1060ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  1060b2:	8b 45 08             	mov    0x8(%ebp),%eax
  1060b5:	89 04 24             	mov    %eax,(%esp)
  1060b8:	e8 6a fe ff ff       	call   105f27 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  1060bd:	e9 60 02 00 00       	jmp    106322 <vprintfmt+0x3cc>
                printfmt(putch, putdat, "%s", p);
  1060c2:	89 74 24 0c          	mov    %esi,0xc(%esp)
  1060c6:	c7 44 24 08 b6 76 10 	movl   $0x1076b6,0x8(%esp)
  1060cd:	00 
  1060ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  1060d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1060d5:	8b 45 08             	mov    0x8(%ebp),%eax
  1060d8:	89 04 24             	mov    %eax,(%esp)
  1060db:	e8 47 fe ff ff       	call   105f27 <printfmt>
            break;
  1060e0:	e9 3d 02 00 00       	jmp    106322 <vprintfmt+0x3cc>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  1060e5:	8b 45 14             	mov    0x14(%ebp),%eax
  1060e8:	8d 50 04             	lea    0x4(%eax),%edx
  1060eb:	89 55 14             	mov    %edx,0x14(%ebp)
  1060ee:	8b 30                	mov    (%eax),%esi
  1060f0:	85 f6                	test   %esi,%esi
  1060f2:	75 05                	jne    1060f9 <vprintfmt+0x1a3>
                p = "(null)";
  1060f4:	be b9 76 10 00       	mov    $0x1076b9,%esi
            }
            if (width > 0 && padc != '-') {
  1060f9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1060fd:	7e 76                	jle    106175 <vprintfmt+0x21f>
  1060ff:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  106103:	74 70                	je     106175 <vprintfmt+0x21f>
                for (width -= strnlen(p, precision); width > 0; width --) {
  106105:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106108:	89 44 24 04          	mov    %eax,0x4(%esp)
  10610c:	89 34 24             	mov    %esi,(%esp)
  10610f:	e8 fb f7 ff ff       	call   10590f <strnlen>
  106114:	8b 55 e8             	mov    -0x18(%ebp),%edx
  106117:	29 c2                	sub    %eax,%edx
  106119:	89 d0                	mov    %edx,%eax
  10611b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10611e:	eb 16                	jmp    106136 <vprintfmt+0x1e0>
                    putch(padc, putdat);
  106120:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  106124:	8b 55 0c             	mov    0xc(%ebp),%edx
  106127:	89 54 24 04          	mov    %edx,0x4(%esp)
  10612b:	89 04 24             	mov    %eax,(%esp)
  10612e:	8b 45 08             	mov    0x8(%ebp),%eax
  106131:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
  106133:	ff 4d e8             	decl   -0x18(%ebp)
  106136:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10613a:	7f e4                	jg     106120 <vprintfmt+0x1ca>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  10613c:	eb 37                	jmp    106175 <vprintfmt+0x21f>
                if (altflag && (ch < ' ' || ch > '~')) {
  10613e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  106142:	74 1f                	je     106163 <vprintfmt+0x20d>
  106144:	83 fb 1f             	cmp    $0x1f,%ebx
  106147:	7e 05                	jle    10614e <vprintfmt+0x1f8>
  106149:	83 fb 7e             	cmp    $0x7e,%ebx
  10614c:	7e 15                	jle    106163 <vprintfmt+0x20d>
                    putch('?', putdat);
  10614e:	8b 45 0c             	mov    0xc(%ebp),%eax
  106151:	89 44 24 04          	mov    %eax,0x4(%esp)
  106155:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  10615c:	8b 45 08             	mov    0x8(%ebp),%eax
  10615f:	ff d0                	call   *%eax
  106161:	eb 0f                	jmp    106172 <vprintfmt+0x21c>
                }
                else {
                    putch(ch, putdat);
  106163:	8b 45 0c             	mov    0xc(%ebp),%eax
  106166:	89 44 24 04          	mov    %eax,0x4(%esp)
  10616a:	89 1c 24             	mov    %ebx,(%esp)
  10616d:	8b 45 08             	mov    0x8(%ebp),%eax
  106170:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  106172:	ff 4d e8             	decl   -0x18(%ebp)
  106175:	89 f0                	mov    %esi,%eax
  106177:	8d 70 01             	lea    0x1(%eax),%esi
  10617a:	0f b6 00             	movzbl (%eax),%eax
  10617d:	0f be d8             	movsbl %al,%ebx
  106180:	85 db                	test   %ebx,%ebx
  106182:	74 27                	je     1061ab <vprintfmt+0x255>
  106184:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  106188:	78 b4                	js     10613e <vprintfmt+0x1e8>
  10618a:	ff 4d e4             	decl   -0x1c(%ebp)
  10618d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  106191:	79 ab                	jns    10613e <vprintfmt+0x1e8>
                }
            }
            for (; width > 0; width --) {
  106193:	eb 16                	jmp    1061ab <vprintfmt+0x255>
                putch(' ', putdat);
  106195:	8b 45 0c             	mov    0xc(%ebp),%eax
  106198:	89 44 24 04          	mov    %eax,0x4(%esp)
  10619c:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1061a3:	8b 45 08             	mov    0x8(%ebp),%eax
  1061a6:	ff d0                	call   *%eax
            for (; width > 0; width --) {
  1061a8:	ff 4d e8             	decl   -0x18(%ebp)
  1061ab:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1061af:	7f e4                	jg     106195 <vprintfmt+0x23f>
            }
            break;
  1061b1:	e9 6c 01 00 00       	jmp    106322 <vprintfmt+0x3cc>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  1061b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1061b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1061bd:	8d 45 14             	lea    0x14(%ebp),%eax
  1061c0:	89 04 24             	mov    %eax,(%esp)
  1061c3:	e8 18 fd ff ff       	call   105ee0 <getint>
  1061c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1061cb:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  1061ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1061d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1061d4:	85 d2                	test   %edx,%edx
  1061d6:	79 26                	jns    1061fe <vprintfmt+0x2a8>
                putch('-', putdat);
  1061d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1061db:	89 44 24 04          	mov    %eax,0x4(%esp)
  1061df:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  1061e6:	8b 45 08             	mov    0x8(%ebp),%eax
  1061e9:	ff d0                	call   *%eax
                num = -(long long)num;
  1061eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1061ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1061f1:	f7 d8                	neg    %eax
  1061f3:	83 d2 00             	adc    $0x0,%edx
  1061f6:	f7 da                	neg    %edx
  1061f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1061fb:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  1061fe:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  106205:	e9 a8 00 00 00       	jmp    1062b2 <vprintfmt+0x35c>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  10620a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10620d:	89 44 24 04          	mov    %eax,0x4(%esp)
  106211:	8d 45 14             	lea    0x14(%ebp),%eax
  106214:	89 04 24             	mov    %eax,(%esp)
  106217:	e8 75 fc ff ff       	call   105e91 <getuint>
  10621c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10621f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  106222:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  106229:	e9 84 00 00 00       	jmp    1062b2 <vprintfmt+0x35c>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  10622e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  106231:	89 44 24 04          	mov    %eax,0x4(%esp)
  106235:	8d 45 14             	lea    0x14(%ebp),%eax
  106238:	89 04 24             	mov    %eax,(%esp)
  10623b:	e8 51 fc ff ff       	call   105e91 <getuint>
  106240:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106243:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  106246:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  10624d:	eb 63                	jmp    1062b2 <vprintfmt+0x35c>

        // pointer
        case 'p':
            putch('0', putdat);
  10624f:	8b 45 0c             	mov    0xc(%ebp),%eax
  106252:	89 44 24 04          	mov    %eax,0x4(%esp)
  106256:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  10625d:	8b 45 08             	mov    0x8(%ebp),%eax
  106260:	ff d0                	call   *%eax
            putch('x', putdat);
  106262:	8b 45 0c             	mov    0xc(%ebp),%eax
  106265:	89 44 24 04          	mov    %eax,0x4(%esp)
  106269:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  106270:	8b 45 08             	mov    0x8(%ebp),%eax
  106273:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  106275:	8b 45 14             	mov    0x14(%ebp),%eax
  106278:	8d 50 04             	lea    0x4(%eax),%edx
  10627b:	89 55 14             	mov    %edx,0x14(%ebp)
  10627e:	8b 00                	mov    (%eax),%eax
  106280:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106283:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  10628a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  106291:	eb 1f                	jmp    1062b2 <vprintfmt+0x35c>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  106293:	8b 45 e0             	mov    -0x20(%ebp),%eax
  106296:	89 44 24 04          	mov    %eax,0x4(%esp)
  10629a:	8d 45 14             	lea    0x14(%ebp),%eax
  10629d:	89 04 24             	mov    %eax,(%esp)
  1062a0:	e8 ec fb ff ff       	call   105e91 <getuint>
  1062a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1062a8:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  1062ab:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  1062b2:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  1062b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1062b9:	89 54 24 18          	mov    %edx,0x18(%esp)
  1062bd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1062c0:	89 54 24 14          	mov    %edx,0x14(%esp)
  1062c4:	89 44 24 10          	mov    %eax,0x10(%esp)
  1062c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1062cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1062ce:	89 44 24 08          	mov    %eax,0x8(%esp)
  1062d2:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1062d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1062d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1062dd:	8b 45 08             	mov    0x8(%ebp),%eax
  1062e0:	89 04 24             	mov    %eax,(%esp)
  1062e3:	e8 a9 fa ff ff       	call   105d91 <printnum>
            break;
  1062e8:	eb 38                	jmp    106322 <vprintfmt+0x3cc>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  1062ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  1062ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  1062f1:	89 1c 24             	mov    %ebx,(%esp)
  1062f4:	8b 45 08             	mov    0x8(%ebp),%eax
  1062f7:	ff d0                	call   *%eax
            break;
  1062f9:	eb 27                	jmp    106322 <vprintfmt+0x3cc>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  1062fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1062fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  106302:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  106309:	8b 45 08             	mov    0x8(%ebp),%eax
  10630c:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  10630e:	ff 4d 10             	decl   0x10(%ebp)
  106311:	eb 03                	jmp    106316 <vprintfmt+0x3c0>
  106313:	ff 4d 10             	decl   0x10(%ebp)
  106316:	8b 45 10             	mov    0x10(%ebp),%eax
  106319:	48                   	dec    %eax
  10631a:	0f b6 00             	movzbl (%eax),%eax
  10631d:	3c 25                	cmp    $0x25,%al
  10631f:	75 f2                	jne    106313 <vprintfmt+0x3bd>
                /* do nothing */;
            break;
  106321:	90                   	nop
    while (1) {
  106322:	e9 37 fc ff ff       	jmp    105f5e <vprintfmt+0x8>
                return;
  106327:	90                   	nop
        }
    }
}
  106328:	83 c4 40             	add    $0x40,%esp
  10632b:	5b                   	pop    %ebx
  10632c:	5e                   	pop    %esi
  10632d:	5d                   	pop    %ebp
  10632e:	c3                   	ret    

0010632f <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  10632f:	55                   	push   %ebp
  106330:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  106332:	8b 45 0c             	mov    0xc(%ebp),%eax
  106335:	8b 40 08             	mov    0x8(%eax),%eax
  106338:	8d 50 01             	lea    0x1(%eax),%edx
  10633b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10633e:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  106341:	8b 45 0c             	mov    0xc(%ebp),%eax
  106344:	8b 10                	mov    (%eax),%edx
  106346:	8b 45 0c             	mov    0xc(%ebp),%eax
  106349:	8b 40 04             	mov    0x4(%eax),%eax
  10634c:	39 c2                	cmp    %eax,%edx
  10634e:	73 12                	jae    106362 <sprintputch+0x33>
        *b->buf ++ = ch;
  106350:	8b 45 0c             	mov    0xc(%ebp),%eax
  106353:	8b 00                	mov    (%eax),%eax
  106355:	8d 48 01             	lea    0x1(%eax),%ecx
  106358:	8b 55 0c             	mov    0xc(%ebp),%edx
  10635b:	89 0a                	mov    %ecx,(%edx)
  10635d:	8b 55 08             	mov    0x8(%ebp),%edx
  106360:	88 10                	mov    %dl,(%eax)
    }
}
  106362:	90                   	nop
  106363:	5d                   	pop    %ebp
  106364:	c3                   	ret    

00106365 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  106365:	55                   	push   %ebp
  106366:	89 e5                	mov    %esp,%ebp
  106368:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  10636b:	8d 45 14             	lea    0x14(%ebp),%eax
  10636e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  106371:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106374:	89 44 24 0c          	mov    %eax,0xc(%esp)
  106378:	8b 45 10             	mov    0x10(%ebp),%eax
  10637b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10637f:	8b 45 0c             	mov    0xc(%ebp),%eax
  106382:	89 44 24 04          	mov    %eax,0x4(%esp)
  106386:	8b 45 08             	mov    0x8(%ebp),%eax
  106389:	89 04 24             	mov    %eax,(%esp)
  10638c:	e8 08 00 00 00       	call   106399 <vsnprintf>
  106391:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  106394:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  106397:	c9                   	leave  
  106398:	c3                   	ret    

00106399 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  106399:	55                   	push   %ebp
  10639a:	89 e5                	mov    %esp,%ebp
  10639c:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  10639f:	8b 45 08             	mov    0x8(%ebp),%eax
  1063a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1063a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1063a8:	8d 50 ff             	lea    -0x1(%eax),%edx
  1063ab:	8b 45 08             	mov    0x8(%ebp),%eax
  1063ae:	01 d0                	add    %edx,%eax
  1063b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1063b3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  1063ba:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1063be:	74 0a                	je     1063ca <vsnprintf+0x31>
  1063c0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1063c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1063c6:	39 c2                	cmp    %eax,%edx
  1063c8:	76 07                	jbe    1063d1 <vsnprintf+0x38>
        return -E_INVAL;
  1063ca:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  1063cf:	eb 2a                	jmp    1063fb <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  1063d1:	8b 45 14             	mov    0x14(%ebp),%eax
  1063d4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1063d8:	8b 45 10             	mov    0x10(%ebp),%eax
  1063db:	89 44 24 08          	mov    %eax,0x8(%esp)
  1063df:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1063e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1063e6:	c7 04 24 2f 63 10 00 	movl   $0x10632f,(%esp)
  1063ed:	e8 64 fb ff ff       	call   105f56 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  1063f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1063f5:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  1063f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1063fb:	c9                   	leave  
  1063fc:	c3                   	ret    
