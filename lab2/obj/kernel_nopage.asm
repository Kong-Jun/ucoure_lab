
bin/kernel_nopage：     文件格式 elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
  100000:	b8 00 b0 11 40       	mov    $0x4011b000,%eax
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
  100020:	a3 00 b0 11 00       	mov    %eax,0x11b000

    # set ebp, esp
    movl $0x0, %ebp
  100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10002a:	bc 00 a0 11 00       	mov    $0x11a000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  10002f:	e8 02 00 00 00       	call   100036 <kern_init>

00100034 <spin>:

# should never get here
spin:
    jmp spin
  100034:	eb fe                	jmp    100034 <spin>

00100036 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100036:	55                   	push   %ebp
  100037:	89 e5                	mov    %esp,%ebp
  100039:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  10003c:	b8 48 df 11 00       	mov    $0x11df48,%eax
  100041:	2d 36 aa 11 00       	sub    $0x11aa36,%eax
  100046:	89 44 24 08          	mov    %eax,0x8(%esp)
  10004a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100051:	00 
  100052:	c7 04 24 36 aa 11 00 	movl   $0x11aa36,(%esp)
  100059:	e8 77 60 00 00       	call   1060d5 <memset>

    cons_init();                // init the console
  10005e:	e8 70 15 00 00       	call   1015d3 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100063:	c7 45 f4 e0 68 10 00 	movl   $0x1068e0,-0xc(%ebp)
    cprintf("%s\n\n", message);
  10006a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10006d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100071:	c7 04 24 fc 68 10 00 	movl   $0x1068fc,(%esp)
  100078:	e8 11 02 00 00       	call   10028e <cprintf>

    print_kerninfo();
  10007d:	e8 a7 08 00 00       	call   100929 <print_kerninfo>

    grade_backtrace();
  100082:	e8 89 00 00 00       	call   100110 <grade_backtrace>

    pmm_init();                 // init physical memory management
  100087:	e8 41 35 00 00       	call   1035cd <pmm_init>

    pic_init();                 // init interrupt controller
  10008c:	e8 a7 16 00 00       	call   101738 <pic_init>
    idt_init();                 // init interrupt descriptor table
  100091:	e8 31 18 00 00       	call   1018c7 <idt_init>

    clock_init();               // init clock interrupt
  100096:	e8 db 0c 00 00       	call   100d76 <clock_init>
    intr_enable();              // enable irq interrupt
  10009b:	e8 d2 17 00 00       	call   101872 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    // lab1_switch_test();

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
  1000bf:	e8 a0 0c 00 00       	call   100d64 <mon_backtrace>
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
  100151:	a1 00 d0 11 00       	mov    0x11d000,%eax
  100156:	89 54 24 08          	mov    %edx,0x8(%esp)
  10015a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10015e:	c7 04 24 01 69 10 00 	movl   $0x106901,(%esp)
  100165:	e8 24 01 00 00       	call   10028e <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  10016a:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10016e:	89 c2                	mov    %eax,%edx
  100170:	a1 00 d0 11 00       	mov    0x11d000,%eax
  100175:	89 54 24 08          	mov    %edx,0x8(%esp)
  100179:	89 44 24 04          	mov    %eax,0x4(%esp)
  10017d:	c7 04 24 0f 69 10 00 	movl   $0x10690f,(%esp)
  100184:	e8 05 01 00 00       	call   10028e <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100189:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  10018d:	89 c2                	mov    %eax,%edx
  10018f:	a1 00 d0 11 00       	mov    0x11d000,%eax
  100194:	89 54 24 08          	mov    %edx,0x8(%esp)
  100198:	89 44 24 04          	mov    %eax,0x4(%esp)
  10019c:	c7 04 24 1d 69 10 00 	movl   $0x10691d,(%esp)
  1001a3:	e8 e6 00 00 00       	call   10028e <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001a8:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001ac:	89 c2                	mov    %eax,%edx
  1001ae:	a1 00 d0 11 00       	mov    0x11d000,%eax
  1001b3:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001bb:	c7 04 24 2b 69 10 00 	movl   $0x10692b,(%esp)
  1001c2:	e8 c7 00 00 00       	call   10028e <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001c7:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001cb:	89 c2                	mov    %eax,%edx
  1001cd:	a1 00 d0 11 00       	mov    0x11d000,%eax
  1001d2:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001da:	c7 04 24 39 69 10 00 	movl   $0x106939,(%esp)
  1001e1:	e8 a8 00 00 00       	call   10028e <cprintf>
    round ++;
  1001e6:	a1 00 d0 11 00       	mov    0x11d000,%eax
  1001eb:	40                   	inc    %eax
  1001ec:	a3 00 d0 11 00       	mov    %eax,0x11d000
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
}
  1001f7:	90                   	nop
  1001f8:	5d                   	pop    %ebp
  1001f9:	c3                   	ret    

001001fa <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001fa:	55                   	push   %ebp
  1001fb:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  1001fd:	90                   	nop
  1001fe:	5d                   	pop    %ebp
  1001ff:	c3                   	ret    

00100200 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  100200:	55                   	push   %ebp
  100201:	89 e5                	mov    %esp,%ebp
  100203:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  100206:	e8 2b ff ff ff       	call   100136 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  10020b:	c7 04 24 48 69 10 00 	movl   $0x106948,(%esp)
  100212:	e8 77 00 00 00       	call   10028e <cprintf>
    lab1_switch_to_user();
  100217:	e8 d8 ff ff ff       	call   1001f4 <lab1_switch_to_user>
    lab1_print_cur_status();
  10021c:	e8 15 ff ff ff       	call   100136 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  100221:	c7 04 24 68 69 10 00 	movl   $0x106968,(%esp)
  100228:	e8 61 00 00 00       	call   10028e <cprintf>
    lab1_switch_to_kernel();
  10022d:	e8 c8 ff ff ff       	call   1001fa <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100232:	e8 ff fe ff ff       	call   100136 <lab1_print_cur_status>
}
  100237:	90                   	nop
  100238:	c9                   	leave  
  100239:	c3                   	ret    

0010023a <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  10023a:	55                   	push   %ebp
  10023b:	89 e5                	mov    %esp,%ebp
  10023d:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100240:	8b 45 08             	mov    0x8(%ebp),%eax
  100243:	89 04 24             	mov    %eax,(%esp)
  100246:	e8 b5 13 00 00       	call   101600 <cons_putc>
    (*cnt) ++;
  10024b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10024e:	8b 00                	mov    (%eax),%eax
  100250:	8d 50 01             	lea    0x1(%eax),%edx
  100253:	8b 45 0c             	mov    0xc(%ebp),%eax
  100256:	89 10                	mov    %edx,(%eax)
}
  100258:	90                   	nop
  100259:	c9                   	leave  
  10025a:	c3                   	ret    

0010025b <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  10025b:	55                   	push   %ebp
  10025c:	89 e5                	mov    %esp,%ebp
  10025e:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100261:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100268:	8b 45 0c             	mov    0xc(%ebp),%eax
  10026b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10026f:	8b 45 08             	mov    0x8(%ebp),%eax
  100272:	89 44 24 08          	mov    %eax,0x8(%esp)
  100276:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100279:	89 44 24 04          	mov    %eax,0x4(%esp)
  10027d:	c7 04 24 3a 02 10 00 	movl   $0x10023a,(%esp)
  100284:	e8 9a 61 00 00       	call   106423 <vprintfmt>
    return cnt;
  100289:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10028c:	c9                   	leave  
  10028d:	c3                   	ret    

0010028e <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  10028e:	55                   	push   %ebp
  10028f:	89 e5                	mov    %esp,%ebp
  100291:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100294:	8d 45 0c             	lea    0xc(%ebp),%eax
  100297:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  10029a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10029d:	89 44 24 04          	mov    %eax,0x4(%esp)
  1002a1:	8b 45 08             	mov    0x8(%ebp),%eax
  1002a4:	89 04 24             	mov    %eax,(%esp)
  1002a7:	e8 af ff ff ff       	call   10025b <vcprintf>
  1002ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1002af:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002b2:	c9                   	leave  
  1002b3:	c3                   	ret    

001002b4 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  1002b4:	55                   	push   %ebp
  1002b5:	89 e5                	mov    %esp,%ebp
  1002b7:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002ba:	8b 45 08             	mov    0x8(%ebp),%eax
  1002bd:	89 04 24             	mov    %eax,(%esp)
  1002c0:	e8 3b 13 00 00       	call   101600 <cons_putc>
}
  1002c5:	90                   	nop
  1002c6:	c9                   	leave  
  1002c7:	c3                   	ret    

001002c8 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  1002c8:	55                   	push   %ebp
  1002c9:	89 e5                	mov    %esp,%ebp
  1002cb:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  1002ce:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  1002d5:	eb 13                	jmp    1002ea <cputs+0x22>
        cputch(c, &cnt);
  1002d7:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  1002db:	8d 55 f0             	lea    -0x10(%ebp),%edx
  1002de:	89 54 24 04          	mov    %edx,0x4(%esp)
  1002e2:	89 04 24             	mov    %eax,(%esp)
  1002e5:	e8 50 ff ff ff       	call   10023a <cputch>
    while ((c = *str ++) != '\0') {
  1002ea:	8b 45 08             	mov    0x8(%ebp),%eax
  1002ed:	8d 50 01             	lea    0x1(%eax),%edx
  1002f0:	89 55 08             	mov    %edx,0x8(%ebp)
  1002f3:	0f b6 00             	movzbl (%eax),%eax
  1002f6:	88 45 f7             	mov    %al,-0x9(%ebp)
  1002f9:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1002fd:	75 d8                	jne    1002d7 <cputs+0xf>
    }
    cputch('\n', &cnt);
  1002ff:	8d 45 f0             	lea    -0x10(%ebp),%eax
  100302:	89 44 24 04          	mov    %eax,0x4(%esp)
  100306:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  10030d:	e8 28 ff ff ff       	call   10023a <cputch>
    return cnt;
  100312:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  100315:	c9                   	leave  
  100316:	c3                   	ret    

00100317 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  100317:	55                   	push   %ebp
  100318:	89 e5                	mov    %esp,%ebp
  10031a:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  10031d:	90                   	nop
  10031e:	e8 1a 13 00 00       	call   10163d <cons_getc>
  100323:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100326:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10032a:	74 f2                	je     10031e <getchar+0x7>
        /* do nothing */;
    return c;
  10032c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10032f:	c9                   	leave  
  100330:	c3                   	ret    

00100331 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100331:	55                   	push   %ebp
  100332:	89 e5                	mov    %esp,%ebp
  100334:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100337:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10033b:	74 13                	je     100350 <readline+0x1f>
        cprintf("%s", prompt);
  10033d:	8b 45 08             	mov    0x8(%ebp),%eax
  100340:	89 44 24 04          	mov    %eax,0x4(%esp)
  100344:	c7 04 24 87 69 10 00 	movl   $0x106987,(%esp)
  10034b:	e8 3e ff ff ff       	call   10028e <cprintf>
    }
    int i = 0, c;
  100350:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100357:	e8 bb ff ff ff       	call   100317 <getchar>
  10035c:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  10035f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100363:	79 07                	jns    10036c <readline+0x3b>
            return NULL;
  100365:	b8 00 00 00 00       	mov    $0x0,%eax
  10036a:	eb 78                	jmp    1003e4 <readline+0xb3>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  10036c:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100370:	7e 28                	jle    10039a <readline+0x69>
  100372:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100379:	7f 1f                	jg     10039a <readline+0x69>
            cputchar(c);
  10037b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10037e:	89 04 24             	mov    %eax,(%esp)
  100381:	e8 2e ff ff ff       	call   1002b4 <cputchar>
            buf[i ++] = c;
  100386:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100389:	8d 50 01             	lea    0x1(%eax),%edx
  10038c:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10038f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100392:	88 90 20 d0 11 00    	mov    %dl,0x11d020(%eax)
  100398:	eb 45                	jmp    1003df <readline+0xae>
        }
        else if (c == '\b' && i > 0) {
  10039a:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  10039e:	75 16                	jne    1003b6 <readline+0x85>
  1003a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003a4:	7e 10                	jle    1003b6 <readline+0x85>
            cputchar(c);
  1003a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003a9:	89 04 24             	mov    %eax,(%esp)
  1003ac:	e8 03 ff ff ff       	call   1002b4 <cputchar>
            i --;
  1003b1:	ff 4d f4             	decl   -0xc(%ebp)
  1003b4:	eb 29                	jmp    1003df <readline+0xae>
        }
        else if (c == '\n' || c == '\r') {
  1003b6:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1003ba:	74 06                	je     1003c2 <readline+0x91>
  1003bc:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1003c0:	75 95                	jne    100357 <readline+0x26>
            cputchar(c);
  1003c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003c5:	89 04 24             	mov    %eax,(%esp)
  1003c8:	e8 e7 fe ff ff       	call   1002b4 <cputchar>
            buf[i] = '\0';
  1003cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003d0:	05 20 d0 11 00       	add    $0x11d020,%eax
  1003d5:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1003d8:	b8 20 d0 11 00       	mov    $0x11d020,%eax
  1003dd:	eb 05                	jmp    1003e4 <readline+0xb3>
        c = getchar();
  1003df:	e9 73 ff ff ff       	jmp    100357 <readline+0x26>
        }
    }
}
  1003e4:	c9                   	leave  
  1003e5:	c3                   	ret    

001003e6 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  1003e6:	55                   	push   %ebp
  1003e7:	89 e5                	mov    %esp,%ebp
  1003e9:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  1003ec:	a1 20 d4 11 00       	mov    0x11d420,%eax
  1003f1:	85 c0                	test   %eax,%eax
  1003f3:	75 5b                	jne    100450 <__panic+0x6a>
        goto panic_dead;
    }
    is_panic = 1;
  1003f5:	c7 05 20 d4 11 00 01 	movl   $0x1,0x11d420
  1003fc:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  1003ff:	8d 45 14             	lea    0x14(%ebp),%eax
  100402:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100405:	8b 45 0c             	mov    0xc(%ebp),%eax
  100408:	89 44 24 08          	mov    %eax,0x8(%esp)
  10040c:	8b 45 08             	mov    0x8(%ebp),%eax
  10040f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100413:	c7 04 24 8a 69 10 00 	movl   $0x10698a,(%esp)
  10041a:	e8 6f fe ff ff       	call   10028e <cprintf>
    vcprintf(fmt, ap);
  10041f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100422:	89 44 24 04          	mov    %eax,0x4(%esp)
  100426:	8b 45 10             	mov    0x10(%ebp),%eax
  100429:	89 04 24             	mov    %eax,(%esp)
  10042c:	e8 2a fe ff ff       	call   10025b <vcprintf>
    cprintf("\n");
  100431:	c7 04 24 a6 69 10 00 	movl   $0x1069a6,(%esp)
  100438:	e8 51 fe ff ff       	call   10028e <cprintf>
    
    cprintf("stack trackback:\n");
  10043d:	c7 04 24 a8 69 10 00 	movl   $0x1069a8,(%esp)
  100444:	e8 45 fe ff ff       	call   10028e <cprintf>
    print_stackframe();
  100449:	e8 21 06 00 00       	call   100a6f <print_stackframe>
  10044e:	eb 01                	jmp    100451 <__panic+0x6b>
        goto panic_dead;
  100450:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
  100451:	e8 23 14 00 00       	call   101879 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100456:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10045d:	e8 35 08 00 00       	call   100c97 <kmonitor>
  100462:	eb f2                	jmp    100456 <__panic+0x70>

00100464 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100464:	55                   	push   %ebp
  100465:	89 e5                	mov    %esp,%ebp
  100467:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  10046a:	8d 45 14             	lea    0x14(%ebp),%eax
  10046d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100470:	8b 45 0c             	mov    0xc(%ebp),%eax
  100473:	89 44 24 08          	mov    %eax,0x8(%esp)
  100477:	8b 45 08             	mov    0x8(%ebp),%eax
  10047a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10047e:	c7 04 24 ba 69 10 00 	movl   $0x1069ba,(%esp)
  100485:	e8 04 fe ff ff       	call   10028e <cprintf>
    vcprintf(fmt, ap);
  10048a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10048d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100491:	8b 45 10             	mov    0x10(%ebp),%eax
  100494:	89 04 24             	mov    %eax,(%esp)
  100497:	e8 bf fd ff ff       	call   10025b <vcprintf>
    cprintf("\n");
  10049c:	c7 04 24 a6 69 10 00 	movl   $0x1069a6,(%esp)
  1004a3:	e8 e6 fd ff ff       	call   10028e <cprintf>
    va_end(ap);
}
  1004a8:	90                   	nop
  1004a9:	c9                   	leave  
  1004aa:	c3                   	ret    

001004ab <is_kernel_panic>:

bool
is_kernel_panic(void) {
  1004ab:	55                   	push   %ebp
  1004ac:	89 e5                	mov    %esp,%ebp
    return is_panic;
  1004ae:	a1 20 d4 11 00       	mov    0x11d420,%eax
}
  1004b3:	5d                   	pop    %ebp
  1004b4:	c3                   	ret    

001004b5 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1004b5:	55                   	push   %ebp
  1004b6:	89 e5                	mov    %esp,%ebp
  1004b8:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1004bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004be:	8b 00                	mov    (%eax),%eax
  1004c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1004c3:	8b 45 10             	mov    0x10(%ebp),%eax
  1004c6:	8b 00                	mov    (%eax),%eax
  1004c8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004cb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1004d2:	e9 ca 00 00 00       	jmp    1005a1 <stab_binsearch+0xec>
        int true_m = (l + r) / 2, m = true_m;
  1004d7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1004dd:	01 d0                	add    %edx,%eax
  1004df:	89 c2                	mov    %eax,%edx
  1004e1:	c1 ea 1f             	shr    $0x1f,%edx
  1004e4:	01 d0                	add    %edx,%eax
  1004e6:	d1 f8                	sar    %eax
  1004e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1004eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004ee:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1004f1:	eb 03                	jmp    1004f6 <stab_binsearch+0x41>
            m --;
  1004f3:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  1004f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004f9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004fc:	7c 1f                	jl     10051d <stab_binsearch+0x68>
  1004fe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100501:	89 d0                	mov    %edx,%eax
  100503:	01 c0                	add    %eax,%eax
  100505:	01 d0                	add    %edx,%eax
  100507:	c1 e0 02             	shl    $0x2,%eax
  10050a:	89 c2                	mov    %eax,%edx
  10050c:	8b 45 08             	mov    0x8(%ebp),%eax
  10050f:	01 d0                	add    %edx,%eax
  100511:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100515:	0f b6 c0             	movzbl %al,%eax
  100518:	39 45 14             	cmp    %eax,0x14(%ebp)
  10051b:	75 d6                	jne    1004f3 <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
  10051d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100520:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100523:	7d 09                	jge    10052e <stab_binsearch+0x79>
            l = true_m + 1;
  100525:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100528:	40                   	inc    %eax
  100529:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  10052c:	eb 73                	jmp    1005a1 <stab_binsearch+0xec>
        }

        // actual binary search
        any_matches = 1;
  10052e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100535:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100538:	89 d0                	mov    %edx,%eax
  10053a:	01 c0                	add    %eax,%eax
  10053c:	01 d0                	add    %edx,%eax
  10053e:	c1 e0 02             	shl    $0x2,%eax
  100541:	89 c2                	mov    %eax,%edx
  100543:	8b 45 08             	mov    0x8(%ebp),%eax
  100546:	01 d0                	add    %edx,%eax
  100548:	8b 40 08             	mov    0x8(%eax),%eax
  10054b:	39 45 18             	cmp    %eax,0x18(%ebp)
  10054e:	76 11                	jbe    100561 <stab_binsearch+0xac>
            *region_left = m;
  100550:	8b 45 0c             	mov    0xc(%ebp),%eax
  100553:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100556:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100558:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10055b:	40                   	inc    %eax
  10055c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10055f:	eb 40                	jmp    1005a1 <stab_binsearch+0xec>
        } else if (stabs[m].n_value > addr) {
  100561:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100564:	89 d0                	mov    %edx,%eax
  100566:	01 c0                	add    %eax,%eax
  100568:	01 d0                	add    %edx,%eax
  10056a:	c1 e0 02             	shl    $0x2,%eax
  10056d:	89 c2                	mov    %eax,%edx
  10056f:	8b 45 08             	mov    0x8(%ebp),%eax
  100572:	01 d0                	add    %edx,%eax
  100574:	8b 40 08             	mov    0x8(%eax),%eax
  100577:	39 45 18             	cmp    %eax,0x18(%ebp)
  10057a:	73 14                	jae    100590 <stab_binsearch+0xdb>
            *region_right = m - 1;
  10057c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10057f:	8d 50 ff             	lea    -0x1(%eax),%edx
  100582:	8b 45 10             	mov    0x10(%ebp),%eax
  100585:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  100587:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10058a:	48                   	dec    %eax
  10058b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  10058e:	eb 11                	jmp    1005a1 <stab_binsearch+0xec>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  100590:	8b 45 0c             	mov    0xc(%ebp),%eax
  100593:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100596:	89 10                	mov    %edx,(%eax)
            l = m;
  100598:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10059b:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  10059e:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
  1005a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1005a4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1005a7:	0f 8e 2a ff ff ff    	jle    1004d7 <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
  1005ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1005b1:	75 0f                	jne    1005c2 <stab_binsearch+0x10d>
        *region_right = *region_left - 1;
  1005b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005b6:	8b 00                	mov    (%eax),%eax
  1005b8:	8d 50 ff             	lea    -0x1(%eax),%edx
  1005bb:	8b 45 10             	mov    0x10(%ebp),%eax
  1005be:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  1005c0:	eb 3e                	jmp    100600 <stab_binsearch+0x14b>
        l = *region_right;
  1005c2:	8b 45 10             	mov    0x10(%ebp),%eax
  1005c5:	8b 00                	mov    (%eax),%eax
  1005c7:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1005ca:	eb 03                	jmp    1005cf <stab_binsearch+0x11a>
  1005cc:	ff 4d fc             	decl   -0x4(%ebp)
  1005cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005d2:	8b 00                	mov    (%eax),%eax
  1005d4:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  1005d7:	7e 1f                	jle    1005f8 <stab_binsearch+0x143>
  1005d9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005dc:	89 d0                	mov    %edx,%eax
  1005de:	01 c0                	add    %eax,%eax
  1005e0:	01 d0                	add    %edx,%eax
  1005e2:	c1 e0 02             	shl    $0x2,%eax
  1005e5:	89 c2                	mov    %eax,%edx
  1005e7:	8b 45 08             	mov    0x8(%ebp),%eax
  1005ea:	01 d0                	add    %edx,%eax
  1005ec:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1005f0:	0f b6 c0             	movzbl %al,%eax
  1005f3:	39 45 14             	cmp    %eax,0x14(%ebp)
  1005f6:	75 d4                	jne    1005cc <stab_binsearch+0x117>
        *region_left = l;
  1005f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005fb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005fe:	89 10                	mov    %edx,(%eax)
}
  100600:	90                   	nop
  100601:	c9                   	leave  
  100602:	c3                   	ret    

00100603 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100603:	55                   	push   %ebp
  100604:	89 e5                	mov    %esp,%ebp
  100606:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100609:	8b 45 0c             	mov    0xc(%ebp),%eax
  10060c:	c7 00 d8 69 10 00    	movl   $0x1069d8,(%eax)
    info->eip_line = 0;
  100612:	8b 45 0c             	mov    0xc(%ebp),%eax
  100615:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  10061c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10061f:	c7 40 08 d8 69 10 00 	movl   $0x1069d8,0x8(%eax)
    info->eip_fn_namelen = 9;
  100626:	8b 45 0c             	mov    0xc(%ebp),%eax
  100629:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100630:	8b 45 0c             	mov    0xc(%ebp),%eax
  100633:	8b 55 08             	mov    0x8(%ebp),%edx
  100636:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100639:	8b 45 0c             	mov    0xc(%ebp),%eax
  10063c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100643:	c7 45 f4 88 7d 10 00 	movl   $0x107d88,-0xc(%ebp)
    stab_end = __STAB_END__;
  10064a:	c7 45 f0 90 4d 11 00 	movl   $0x114d90,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100651:	c7 45 ec 91 4d 11 00 	movl   $0x114d91,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100658:	c7 45 e8 de 79 11 00 	movl   $0x1179de,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  10065f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100662:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100665:	76 0b                	jbe    100672 <debuginfo_eip+0x6f>
  100667:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10066a:	48                   	dec    %eax
  10066b:	0f b6 00             	movzbl (%eax),%eax
  10066e:	84 c0                	test   %al,%al
  100670:	74 0a                	je     10067c <debuginfo_eip+0x79>
        return -1;
  100672:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100677:	e9 ab 02 00 00       	jmp    100927 <debuginfo_eip+0x324>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  10067c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  100683:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100686:	2b 45 f4             	sub    -0xc(%ebp),%eax
  100689:	c1 f8 02             	sar    $0x2,%eax
  10068c:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  100692:	48                   	dec    %eax
  100693:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  100696:	8b 45 08             	mov    0x8(%ebp),%eax
  100699:	89 44 24 10          	mov    %eax,0x10(%esp)
  10069d:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1006a4:	00 
  1006a5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1006a8:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006ac:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1006af:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006b6:	89 04 24             	mov    %eax,(%esp)
  1006b9:	e8 f7 fd ff ff       	call   1004b5 <stab_binsearch>
    if (lfile == 0)
  1006be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006c1:	85 c0                	test   %eax,%eax
  1006c3:	75 0a                	jne    1006cf <debuginfo_eip+0xcc>
        return -1;
  1006c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006ca:	e9 58 02 00 00       	jmp    100927 <debuginfo_eip+0x324>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1006cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006d2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1006d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006d8:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1006db:	8b 45 08             	mov    0x8(%ebp),%eax
  1006de:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006e2:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  1006e9:	00 
  1006ea:	8d 45 d8             	lea    -0x28(%ebp),%eax
  1006ed:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006f1:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1006f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006fb:	89 04 24             	mov    %eax,(%esp)
  1006fe:	e8 b2 fd ff ff       	call   1004b5 <stab_binsearch>

    if (lfun <= rfun) {
  100703:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100706:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100709:	39 c2                	cmp    %eax,%edx
  10070b:	7f 78                	jg     100785 <debuginfo_eip+0x182>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  10070d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100710:	89 c2                	mov    %eax,%edx
  100712:	89 d0                	mov    %edx,%eax
  100714:	01 c0                	add    %eax,%eax
  100716:	01 d0                	add    %edx,%eax
  100718:	c1 e0 02             	shl    $0x2,%eax
  10071b:	89 c2                	mov    %eax,%edx
  10071d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100720:	01 d0                	add    %edx,%eax
  100722:	8b 10                	mov    (%eax),%edx
  100724:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100727:	2b 45 ec             	sub    -0x14(%ebp),%eax
  10072a:	39 c2                	cmp    %eax,%edx
  10072c:	73 22                	jae    100750 <debuginfo_eip+0x14d>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  10072e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100731:	89 c2                	mov    %eax,%edx
  100733:	89 d0                	mov    %edx,%eax
  100735:	01 c0                	add    %eax,%eax
  100737:	01 d0                	add    %edx,%eax
  100739:	c1 e0 02             	shl    $0x2,%eax
  10073c:	89 c2                	mov    %eax,%edx
  10073e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100741:	01 d0                	add    %edx,%eax
  100743:	8b 10                	mov    (%eax),%edx
  100745:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100748:	01 c2                	add    %eax,%edx
  10074a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10074d:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100750:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100753:	89 c2                	mov    %eax,%edx
  100755:	89 d0                	mov    %edx,%eax
  100757:	01 c0                	add    %eax,%eax
  100759:	01 d0                	add    %edx,%eax
  10075b:	c1 e0 02             	shl    $0x2,%eax
  10075e:	89 c2                	mov    %eax,%edx
  100760:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100763:	01 d0                	add    %edx,%eax
  100765:	8b 50 08             	mov    0x8(%eax),%edx
  100768:	8b 45 0c             	mov    0xc(%ebp),%eax
  10076b:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  10076e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100771:	8b 40 10             	mov    0x10(%eax),%eax
  100774:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  100777:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10077a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  10077d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100780:	89 45 d0             	mov    %eax,-0x30(%ebp)
  100783:	eb 15                	jmp    10079a <debuginfo_eip+0x197>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  100785:	8b 45 0c             	mov    0xc(%ebp),%eax
  100788:	8b 55 08             	mov    0x8(%ebp),%edx
  10078b:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  10078e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100791:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  100794:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100797:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  10079a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10079d:	8b 40 08             	mov    0x8(%eax),%eax
  1007a0:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1007a7:	00 
  1007a8:	89 04 24             	mov    %eax,(%esp)
  1007ab:	e8 a1 57 00 00       	call   105f51 <strfind>
  1007b0:	89 c2                	mov    %eax,%edx
  1007b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007b5:	8b 40 08             	mov    0x8(%eax),%eax
  1007b8:	29 c2                	sub    %eax,%edx
  1007ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007bd:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1007c0:	8b 45 08             	mov    0x8(%ebp),%eax
  1007c3:	89 44 24 10          	mov    %eax,0x10(%esp)
  1007c7:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1007ce:	00 
  1007cf:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1007d2:	89 44 24 08          	mov    %eax,0x8(%esp)
  1007d6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1007d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1007dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007e0:	89 04 24             	mov    %eax,(%esp)
  1007e3:	e8 cd fc ff ff       	call   1004b5 <stab_binsearch>
    if (lline <= rline) {
  1007e8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007eb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007ee:	39 c2                	cmp    %eax,%edx
  1007f0:	7f 23                	jg     100815 <debuginfo_eip+0x212>
        info->eip_line = stabs[rline].n_desc;
  1007f2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007f5:	89 c2                	mov    %eax,%edx
  1007f7:	89 d0                	mov    %edx,%eax
  1007f9:	01 c0                	add    %eax,%eax
  1007fb:	01 d0                	add    %edx,%eax
  1007fd:	c1 e0 02             	shl    $0x2,%eax
  100800:	89 c2                	mov    %eax,%edx
  100802:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100805:	01 d0                	add    %edx,%eax
  100807:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  10080b:	89 c2                	mov    %eax,%edx
  10080d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100810:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100813:	eb 11                	jmp    100826 <debuginfo_eip+0x223>
        return -1;
  100815:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10081a:	e9 08 01 00 00       	jmp    100927 <debuginfo_eip+0x324>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  10081f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100822:	48                   	dec    %eax
  100823:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  100826:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100829:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10082c:	39 c2                	cmp    %eax,%edx
  10082e:	7c 56                	jl     100886 <debuginfo_eip+0x283>
           && stabs[lline].n_type != N_SOL
  100830:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100833:	89 c2                	mov    %eax,%edx
  100835:	89 d0                	mov    %edx,%eax
  100837:	01 c0                	add    %eax,%eax
  100839:	01 d0                	add    %edx,%eax
  10083b:	c1 e0 02             	shl    $0x2,%eax
  10083e:	89 c2                	mov    %eax,%edx
  100840:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100843:	01 d0                	add    %edx,%eax
  100845:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100849:	3c 84                	cmp    $0x84,%al
  10084b:	74 39                	je     100886 <debuginfo_eip+0x283>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  10084d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100850:	89 c2                	mov    %eax,%edx
  100852:	89 d0                	mov    %edx,%eax
  100854:	01 c0                	add    %eax,%eax
  100856:	01 d0                	add    %edx,%eax
  100858:	c1 e0 02             	shl    $0x2,%eax
  10085b:	89 c2                	mov    %eax,%edx
  10085d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100860:	01 d0                	add    %edx,%eax
  100862:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100866:	3c 64                	cmp    $0x64,%al
  100868:	75 b5                	jne    10081f <debuginfo_eip+0x21c>
  10086a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10086d:	89 c2                	mov    %eax,%edx
  10086f:	89 d0                	mov    %edx,%eax
  100871:	01 c0                	add    %eax,%eax
  100873:	01 d0                	add    %edx,%eax
  100875:	c1 e0 02             	shl    $0x2,%eax
  100878:	89 c2                	mov    %eax,%edx
  10087a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10087d:	01 d0                	add    %edx,%eax
  10087f:	8b 40 08             	mov    0x8(%eax),%eax
  100882:	85 c0                	test   %eax,%eax
  100884:	74 99                	je     10081f <debuginfo_eip+0x21c>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  100886:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100889:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10088c:	39 c2                	cmp    %eax,%edx
  10088e:	7c 42                	jl     1008d2 <debuginfo_eip+0x2cf>
  100890:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100893:	89 c2                	mov    %eax,%edx
  100895:	89 d0                	mov    %edx,%eax
  100897:	01 c0                	add    %eax,%eax
  100899:	01 d0                	add    %edx,%eax
  10089b:	c1 e0 02             	shl    $0x2,%eax
  10089e:	89 c2                	mov    %eax,%edx
  1008a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008a3:	01 d0                	add    %edx,%eax
  1008a5:	8b 10                	mov    (%eax),%edx
  1008a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1008aa:	2b 45 ec             	sub    -0x14(%ebp),%eax
  1008ad:	39 c2                	cmp    %eax,%edx
  1008af:	73 21                	jae    1008d2 <debuginfo_eip+0x2cf>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1008b1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008b4:	89 c2                	mov    %eax,%edx
  1008b6:	89 d0                	mov    %edx,%eax
  1008b8:	01 c0                	add    %eax,%eax
  1008ba:	01 d0                	add    %edx,%eax
  1008bc:	c1 e0 02             	shl    $0x2,%eax
  1008bf:	89 c2                	mov    %eax,%edx
  1008c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008c4:	01 d0                	add    %edx,%eax
  1008c6:	8b 10                	mov    (%eax),%edx
  1008c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1008cb:	01 c2                	add    %eax,%edx
  1008cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008d0:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1008d2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1008d5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1008d8:	39 c2                	cmp    %eax,%edx
  1008da:	7d 46                	jge    100922 <debuginfo_eip+0x31f>
        for (lline = lfun + 1;
  1008dc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1008df:	40                   	inc    %eax
  1008e0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1008e3:	eb 16                	jmp    1008fb <debuginfo_eip+0x2f8>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  1008e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008e8:	8b 40 14             	mov    0x14(%eax),%eax
  1008eb:	8d 50 01             	lea    0x1(%eax),%edx
  1008ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008f1:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  1008f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008f7:	40                   	inc    %eax
  1008f8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008fb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1008fe:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
  100901:	39 c2                	cmp    %eax,%edx
  100903:	7d 1d                	jge    100922 <debuginfo_eip+0x31f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100905:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100908:	89 c2                	mov    %eax,%edx
  10090a:	89 d0                	mov    %edx,%eax
  10090c:	01 c0                	add    %eax,%eax
  10090e:	01 d0                	add    %edx,%eax
  100910:	c1 e0 02             	shl    $0x2,%eax
  100913:	89 c2                	mov    %eax,%edx
  100915:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100918:	01 d0                	add    %edx,%eax
  10091a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10091e:	3c a0                	cmp    $0xa0,%al
  100920:	74 c3                	je     1008e5 <debuginfo_eip+0x2e2>
        }
    }
    return 0;
  100922:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100927:	c9                   	leave  
  100928:	c3                   	ret    

00100929 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100929:	55                   	push   %ebp
  10092a:	89 e5                	mov    %esp,%ebp
  10092c:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  10092f:	c7 04 24 e2 69 10 00 	movl   $0x1069e2,(%esp)
  100936:	e8 53 f9 ff ff       	call   10028e <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  10093b:	c7 44 24 04 36 00 10 	movl   $0x100036,0x4(%esp)
  100942:	00 
  100943:	c7 04 24 fb 69 10 00 	movl   $0x1069fb,(%esp)
  10094a:	e8 3f f9 ff ff       	call   10028e <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  10094f:	c7 44 24 04 ca 68 10 	movl   $0x1068ca,0x4(%esp)
  100956:	00 
  100957:	c7 04 24 13 6a 10 00 	movl   $0x106a13,(%esp)
  10095e:	e8 2b f9 ff ff       	call   10028e <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  100963:	c7 44 24 04 36 aa 11 	movl   $0x11aa36,0x4(%esp)
  10096a:	00 
  10096b:	c7 04 24 2b 6a 10 00 	movl   $0x106a2b,(%esp)
  100972:	e8 17 f9 ff ff       	call   10028e <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  100977:	c7 44 24 04 48 df 11 	movl   $0x11df48,0x4(%esp)
  10097e:	00 
  10097f:	c7 04 24 43 6a 10 00 	movl   $0x106a43,(%esp)
  100986:	e8 03 f9 ff ff       	call   10028e <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  10098b:	b8 48 df 11 00       	mov    $0x11df48,%eax
  100990:	2d 36 00 10 00       	sub    $0x100036,%eax
  100995:	05 ff 03 00 00       	add    $0x3ff,%eax
  10099a:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1009a0:	85 c0                	test   %eax,%eax
  1009a2:	0f 48 c2             	cmovs  %edx,%eax
  1009a5:	c1 f8 0a             	sar    $0xa,%eax
  1009a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009ac:	c7 04 24 5c 6a 10 00 	movl   $0x106a5c,(%esp)
  1009b3:	e8 d6 f8 ff ff       	call   10028e <cprintf>
}
  1009b8:	90                   	nop
  1009b9:	c9                   	leave  
  1009ba:	c3                   	ret    

001009bb <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1009bb:	55                   	push   %ebp
  1009bc:	89 e5                	mov    %esp,%ebp
  1009be:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1009c4:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1009c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009cb:	8b 45 08             	mov    0x8(%ebp),%eax
  1009ce:	89 04 24             	mov    %eax,(%esp)
  1009d1:	e8 2d fc ff ff       	call   100603 <debuginfo_eip>
  1009d6:	85 c0                	test   %eax,%eax
  1009d8:	74 15                	je     1009ef <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  1009da:	8b 45 08             	mov    0x8(%ebp),%eax
  1009dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009e1:	c7 04 24 86 6a 10 00 	movl   $0x106a86,(%esp)
  1009e8:	e8 a1 f8 ff ff       	call   10028e <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  1009ed:	eb 6c                	jmp    100a5b <print_debuginfo+0xa0>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009ef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1009f6:	eb 1b                	jmp    100a13 <print_debuginfo+0x58>
            fnname[j] = info.eip_fn_name[j];
  1009f8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1009fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009fe:	01 d0                	add    %edx,%eax
  100a00:	0f b6 10             	movzbl (%eax),%edx
  100a03:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a0c:	01 c8                	add    %ecx,%eax
  100a0e:	88 10                	mov    %dl,(%eax)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a10:	ff 45 f4             	incl   -0xc(%ebp)
  100a13:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a16:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  100a19:	7c dd                	jl     1009f8 <print_debuginfo+0x3d>
        fnname[j] = '\0';
  100a1b:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a24:	01 d0                	add    %edx,%eax
  100a26:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
  100a29:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100a2c:	8b 55 08             	mov    0x8(%ebp),%edx
  100a2f:	89 d1                	mov    %edx,%ecx
  100a31:	29 c1                	sub    %eax,%ecx
  100a33:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100a36:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100a39:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100a3d:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a43:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100a47:	89 54 24 08          	mov    %edx,0x8(%esp)
  100a4b:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a4f:	c7 04 24 a2 6a 10 00 	movl   $0x106aa2,(%esp)
  100a56:	e8 33 f8 ff ff       	call   10028e <cprintf>
}
  100a5b:	90                   	nop
  100a5c:	c9                   	leave  
  100a5d:	c3                   	ret    

00100a5e <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100a5e:	55                   	push   %ebp
  100a5f:	89 e5                	mov    %esp,%ebp
  100a61:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100a64:	8b 45 04             	mov    0x4(%ebp),%eax
  100a67:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100a6a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100a6d:	c9                   	leave  
  100a6e:	c3                   	ret    

00100a6f <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100a6f:	55                   	push   %ebp
  100a70:	89 e5                	mov    %esp,%ebp
  100a72:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100a75:	89 e8                	mov    %ebp,%eax
  100a77:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  100a7a:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();
  100a7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100a80:	e8 d9 ff ff ff       	call   100a5e <read_eip>
  100a85:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
  100a88:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100a8f:	e9 84 00 00 00       	jmp    100b18 <print_stackframe+0xa9>
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
  100a94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a97:	89 44 24 08          	mov    %eax,0x8(%esp)
  100a9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a9e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100aa2:	c7 04 24 b4 6a 10 00 	movl   $0x106ab4,(%esp)
  100aa9:	e8 e0 f7 ff ff       	call   10028e <cprintf>
        uint32_t *args = (uint32_t *)ebp + 2;
  100aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ab1:	83 c0 08             	add    $0x8,%eax
  100ab4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (j = 0; j < 4; j ++) {
  100ab7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100abe:	eb 24                	jmp    100ae4 <print_stackframe+0x75>
            cprintf("0x%08x ", args[j]);
  100ac0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100ac3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100aca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100acd:	01 d0                	add    %edx,%eax
  100acf:	8b 00                	mov    (%eax),%eax
  100ad1:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ad5:	c7 04 24 d0 6a 10 00 	movl   $0x106ad0,(%esp)
  100adc:	e8 ad f7 ff ff       	call   10028e <cprintf>
        for (j = 0; j < 4; j ++) {
  100ae1:	ff 45 e8             	incl   -0x18(%ebp)
  100ae4:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100ae8:	7e d6                	jle    100ac0 <print_stackframe+0x51>
        }
        cprintf("\n");
  100aea:	c7 04 24 d8 6a 10 00 	movl   $0x106ad8,(%esp)
  100af1:	e8 98 f7 ff ff       	call   10028e <cprintf>
        print_debuginfo(eip - 1);
  100af6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100af9:	48                   	dec    %eax
  100afa:	89 04 24             	mov    %eax,(%esp)
  100afd:	e8 b9 fe ff ff       	call   1009bb <print_debuginfo>
        eip = ((uint32_t *)ebp)[1];
  100b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b05:	83 c0 04             	add    $0x4,%eax
  100b08:	8b 00                	mov    (%eax),%eax
  100b0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
  100b0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b10:	8b 00                	mov    (%eax),%eax
  100b12:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
  100b15:	ff 45 ec             	incl   -0x14(%ebp)
  100b18:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100b1c:	74 0a                	je     100b28 <print_stackframe+0xb9>
  100b1e:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100b22:	0f 8e 6c ff ff ff    	jle    100a94 <print_stackframe+0x25>
    }
}
  100b28:	90                   	nop
  100b29:	c9                   	leave  
  100b2a:	c3                   	ret    

00100b2b <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100b2b:	55                   	push   %ebp
  100b2c:	89 e5                	mov    %esp,%ebp
  100b2e:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100b31:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b38:	eb 0c                	jmp    100b46 <parse+0x1b>
            *buf ++ = '\0';
  100b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  100b3d:	8d 50 01             	lea    0x1(%eax),%edx
  100b40:	89 55 08             	mov    %edx,0x8(%ebp)
  100b43:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b46:	8b 45 08             	mov    0x8(%ebp),%eax
  100b49:	0f b6 00             	movzbl (%eax),%eax
  100b4c:	84 c0                	test   %al,%al
  100b4e:	74 1d                	je     100b6d <parse+0x42>
  100b50:	8b 45 08             	mov    0x8(%ebp),%eax
  100b53:	0f b6 00             	movzbl (%eax),%eax
  100b56:	0f be c0             	movsbl %al,%eax
  100b59:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b5d:	c7 04 24 5c 6b 10 00 	movl   $0x106b5c,(%esp)
  100b64:	e8 b6 53 00 00       	call   105f1f <strchr>
  100b69:	85 c0                	test   %eax,%eax
  100b6b:	75 cd                	jne    100b3a <parse+0xf>
        }
        if (*buf == '\0') {
  100b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  100b70:	0f b6 00             	movzbl (%eax),%eax
  100b73:	84 c0                	test   %al,%al
  100b75:	74 65                	je     100bdc <parse+0xb1>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100b77:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100b7b:	75 14                	jne    100b91 <parse+0x66>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100b7d:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100b84:	00 
  100b85:	c7 04 24 61 6b 10 00 	movl   $0x106b61,(%esp)
  100b8c:	e8 fd f6 ff ff       	call   10028e <cprintf>
        }
        argv[argc ++] = buf;
  100b91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b94:	8d 50 01             	lea    0x1(%eax),%edx
  100b97:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100b9a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100ba1:	8b 45 0c             	mov    0xc(%ebp),%eax
  100ba4:	01 c2                	add    %eax,%edx
  100ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  100ba9:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100bab:	eb 03                	jmp    100bb0 <parse+0x85>
            buf ++;
  100bad:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  100bb3:	0f b6 00             	movzbl (%eax),%eax
  100bb6:	84 c0                	test   %al,%al
  100bb8:	74 8c                	je     100b46 <parse+0x1b>
  100bba:	8b 45 08             	mov    0x8(%ebp),%eax
  100bbd:	0f b6 00             	movzbl (%eax),%eax
  100bc0:	0f be c0             	movsbl %al,%eax
  100bc3:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bc7:	c7 04 24 5c 6b 10 00 	movl   $0x106b5c,(%esp)
  100bce:	e8 4c 53 00 00       	call   105f1f <strchr>
  100bd3:	85 c0                	test   %eax,%eax
  100bd5:	74 d6                	je     100bad <parse+0x82>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100bd7:	e9 6a ff ff ff       	jmp    100b46 <parse+0x1b>
            break;
  100bdc:	90                   	nop
        }
    }
    return argc;
  100bdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100be0:	c9                   	leave  
  100be1:	c3                   	ret    

00100be2 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100be2:	55                   	push   %ebp
  100be3:	89 e5                	mov    %esp,%ebp
  100be5:	53                   	push   %ebx
  100be6:	83 ec 64             	sub    $0x64,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100be9:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100bec:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  100bf3:	89 04 24             	mov    %eax,(%esp)
  100bf6:	e8 30 ff ff ff       	call   100b2b <parse>
  100bfb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100bfe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100c02:	75 0a                	jne    100c0e <runcmd+0x2c>
        return 0;
  100c04:	b8 00 00 00 00       	mov    $0x0,%eax
  100c09:	e9 83 00 00 00       	jmp    100c91 <runcmd+0xaf>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c0e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c15:	eb 5a                	jmp    100c71 <runcmd+0x8f>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100c17:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100c1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c1d:	89 d0                	mov    %edx,%eax
  100c1f:	01 c0                	add    %eax,%eax
  100c21:	01 d0                	add    %edx,%eax
  100c23:	c1 e0 02             	shl    $0x2,%eax
  100c26:	05 00 a0 11 00       	add    $0x11a000,%eax
  100c2b:	8b 00                	mov    (%eax),%eax
  100c2d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100c31:	89 04 24             	mov    %eax,(%esp)
  100c34:	e8 49 52 00 00       	call   105e82 <strcmp>
  100c39:	85 c0                	test   %eax,%eax
  100c3b:	75 31                	jne    100c6e <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100c3d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c40:	89 d0                	mov    %edx,%eax
  100c42:	01 c0                	add    %eax,%eax
  100c44:	01 d0                	add    %edx,%eax
  100c46:	c1 e0 02             	shl    $0x2,%eax
  100c49:	05 08 a0 11 00       	add    $0x11a008,%eax
  100c4e:	8b 10                	mov    (%eax),%edx
  100c50:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c53:	83 c0 04             	add    $0x4,%eax
  100c56:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100c59:	8d 59 ff             	lea    -0x1(%ecx),%ebx
  100c5c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100c5f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c63:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c67:	89 1c 24             	mov    %ebx,(%esp)
  100c6a:	ff d2                	call   *%edx
  100c6c:	eb 23                	jmp    100c91 <runcmd+0xaf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100c6e:	ff 45 f4             	incl   -0xc(%ebp)
  100c71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c74:	83 f8 02             	cmp    $0x2,%eax
  100c77:	76 9e                	jbe    100c17 <runcmd+0x35>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100c79:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100c7c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c80:	c7 04 24 7f 6b 10 00 	movl   $0x106b7f,(%esp)
  100c87:	e8 02 f6 ff ff       	call   10028e <cprintf>
    return 0;
  100c8c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c91:	83 c4 64             	add    $0x64,%esp
  100c94:	5b                   	pop    %ebx
  100c95:	5d                   	pop    %ebp
  100c96:	c3                   	ret    

00100c97 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100c97:	55                   	push   %ebp
  100c98:	89 e5                	mov    %esp,%ebp
  100c9a:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100c9d:	c7 04 24 98 6b 10 00 	movl   $0x106b98,(%esp)
  100ca4:	e8 e5 f5 ff ff       	call   10028e <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100ca9:	c7 04 24 c0 6b 10 00 	movl   $0x106bc0,(%esp)
  100cb0:	e8 d9 f5 ff ff       	call   10028e <cprintf>

    if (tf != NULL) {
  100cb5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100cb9:	74 0b                	je     100cc6 <kmonitor+0x2f>
        print_trapframe(tf);
  100cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  100cbe:	89 04 24             	mov    %eax,(%esp)
  100cc1:	e8 b2 0e 00 00       	call   101b78 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100cc6:	c7 04 24 e5 6b 10 00 	movl   $0x106be5,(%esp)
  100ccd:	e8 5f f6 ff ff       	call   100331 <readline>
  100cd2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100cd5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100cd9:	74 eb                	je     100cc6 <kmonitor+0x2f>
            if (runcmd(buf, tf) < 0) {
  100cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  100cde:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ce5:	89 04 24             	mov    %eax,(%esp)
  100ce8:	e8 f5 fe ff ff       	call   100be2 <runcmd>
  100ced:	85 c0                	test   %eax,%eax
  100cef:	78 02                	js     100cf3 <kmonitor+0x5c>
        if ((buf = readline("K> ")) != NULL) {
  100cf1:	eb d3                	jmp    100cc6 <kmonitor+0x2f>
                break;
  100cf3:	90                   	nop
            }
        }
    }
}
  100cf4:	90                   	nop
  100cf5:	c9                   	leave  
  100cf6:	c3                   	ret    

00100cf7 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100cf7:	55                   	push   %ebp
  100cf8:	89 e5                	mov    %esp,%ebp
  100cfa:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100cfd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100d04:	eb 3d                	jmp    100d43 <mon_help+0x4c>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100d06:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d09:	89 d0                	mov    %edx,%eax
  100d0b:	01 c0                	add    %eax,%eax
  100d0d:	01 d0                	add    %edx,%eax
  100d0f:	c1 e0 02             	shl    $0x2,%eax
  100d12:	05 04 a0 11 00       	add    $0x11a004,%eax
  100d17:	8b 08                	mov    (%eax),%ecx
  100d19:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d1c:	89 d0                	mov    %edx,%eax
  100d1e:	01 c0                	add    %eax,%eax
  100d20:	01 d0                	add    %edx,%eax
  100d22:	c1 e0 02             	shl    $0x2,%eax
  100d25:	05 00 a0 11 00       	add    $0x11a000,%eax
  100d2a:	8b 00                	mov    (%eax),%eax
  100d2c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100d30:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d34:	c7 04 24 e9 6b 10 00 	movl   $0x106be9,(%esp)
  100d3b:	e8 4e f5 ff ff       	call   10028e <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100d40:	ff 45 f4             	incl   -0xc(%ebp)
  100d43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d46:	83 f8 02             	cmp    $0x2,%eax
  100d49:	76 bb                	jbe    100d06 <mon_help+0xf>
    }
    return 0;
  100d4b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d50:	c9                   	leave  
  100d51:	c3                   	ret    

00100d52 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100d52:	55                   	push   %ebp
  100d53:	89 e5                	mov    %esp,%ebp
  100d55:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100d58:	e8 cc fb ff ff       	call   100929 <print_kerninfo>
    return 0;
  100d5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d62:	c9                   	leave  
  100d63:	c3                   	ret    

00100d64 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100d64:	55                   	push   %ebp
  100d65:	89 e5                	mov    %esp,%ebp
  100d67:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100d6a:	e8 00 fd ff ff       	call   100a6f <print_stackframe>
    return 0;
  100d6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d74:	c9                   	leave  
  100d75:	c3                   	ret    

00100d76 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d76:	55                   	push   %ebp
  100d77:	89 e5                	mov    %esp,%ebp
  100d79:	83 ec 28             	sub    $0x28,%esp
  100d7c:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100d82:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100d86:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100d8a:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100d8e:	ee                   	out    %al,(%dx)
  100d8f:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d95:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100d99:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100d9d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100da1:	ee                   	out    %al,(%dx)
  100da2:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100da8:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
  100dac:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100db0:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100db4:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100db5:	c7 05 2c df 11 00 00 	movl   $0x0,0x11df2c
  100dbc:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100dbf:	c7 04 24 f2 6b 10 00 	movl   $0x106bf2,(%esp)
  100dc6:	e8 c3 f4 ff ff       	call   10028e <cprintf>
    pic_enable(IRQ_TIMER);
  100dcb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100dd2:	e8 2e 09 00 00       	call   101705 <pic_enable>
}
  100dd7:	90                   	nop
  100dd8:	c9                   	leave  
  100dd9:	c3                   	ret    

00100dda <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100dda:	55                   	push   %ebp
  100ddb:	89 e5                	mov    %esp,%ebp
  100ddd:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100de0:	9c                   	pushf  
  100de1:	58                   	pop    %eax
  100de2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100de5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100de8:	25 00 02 00 00       	and    $0x200,%eax
  100ded:	85 c0                	test   %eax,%eax
  100def:	74 0c                	je     100dfd <__intr_save+0x23>
        intr_disable();
  100df1:	e8 83 0a 00 00       	call   101879 <intr_disable>
        return 1;
  100df6:	b8 01 00 00 00       	mov    $0x1,%eax
  100dfb:	eb 05                	jmp    100e02 <__intr_save+0x28>
    }
    return 0;
  100dfd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100e02:	c9                   	leave  
  100e03:	c3                   	ret    

00100e04 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100e04:	55                   	push   %ebp
  100e05:	89 e5                	mov    %esp,%ebp
  100e07:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100e0a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100e0e:	74 05                	je     100e15 <__intr_restore+0x11>
        intr_enable();
  100e10:	e8 5d 0a 00 00       	call   101872 <intr_enable>
    }
}
  100e15:	90                   	nop
  100e16:	c9                   	leave  
  100e17:	c3                   	ret    

00100e18 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e18:	55                   	push   %ebp
  100e19:	89 e5                	mov    %esp,%ebp
  100e1b:	83 ec 10             	sub    $0x10,%esp
  100e1e:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e24:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e28:	89 c2                	mov    %eax,%edx
  100e2a:	ec                   	in     (%dx),%al
  100e2b:	88 45 f1             	mov    %al,-0xf(%ebp)
  100e2e:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e34:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e38:	89 c2                	mov    %eax,%edx
  100e3a:	ec                   	in     (%dx),%al
  100e3b:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e3e:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e44:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e48:	89 c2                	mov    %eax,%edx
  100e4a:	ec                   	in     (%dx),%al
  100e4b:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e4e:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  100e54:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e58:	89 c2                	mov    %eax,%edx
  100e5a:	ec                   	in     (%dx),%al
  100e5b:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e5e:	90                   	nop
  100e5f:	c9                   	leave  
  100e60:	c3                   	ret    

00100e61 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100e61:	55                   	push   %ebp
  100e62:	89 e5                	mov    %esp,%ebp
  100e64:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100e67:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100e6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e71:	0f b7 00             	movzwl (%eax),%eax
  100e74:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100e78:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e7b:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100e80:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e83:	0f b7 00             	movzwl (%eax),%eax
  100e86:	0f b7 c0             	movzwl %ax,%eax
  100e89:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
  100e8e:	74 12                	je     100ea2 <cga_init+0x41>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100e90:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100e97:	66 c7 05 46 d4 11 00 	movw   $0x3b4,0x11d446
  100e9e:	b4 03 
  100ea0:	eb 13                	jmp    100eb5 <cga_init+0x54>
    } else {
        *cp = was;
  100ea2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ea5:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100ea9:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100eac:	66 c7 05 46 d4 11 00 	movw   $0x3d4,0x11d446
  100eb3:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100eb5:	0f b7 05 46 d4 11 00 	movzwl 0x11d446,%eax
  100ebc:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100ec0:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ec4:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100ec8:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100ecc:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100ecd:	0f b7 05 46 d4 11 00 	movzwl 0x11d446,%eax
  100ed4:	40                   	inc    %eax
  100ed5:	0f b7 c0             	movzwl %ax,%eax
  100ed8:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100edc:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
  100ee0:	89 c2                	mov    %eax,%edx
  100ee2:	ec                   	in     (%dx),%al
  100ee3:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  100ee6:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100eea:	0f b6 c0             	movzbl %al,%eax
  100eed:	c1 e0 08             	shl    $0x8,%eax
  100ef0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100ef3:	0f b7 05 46 d4 11 00 	movzwl 0x11d446,%eax
  100efa:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100efe:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f02:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f06:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f0a:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100f0b:	0f b7 05 46 d4 11 00 	movzwl 0x11d446,%eax
  100f12:	40                   	inc    %eax
  100f13:	0f b7 c0             	movzwl %ax,%eax
  100f16:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f1a:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100f1e:	89 c2                	mov    %eax,%edx
  100f20:	ec                   	in     (%dx),%al
  100f21:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  100f24:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f28:	0f b6 c0             	movzbl %al,%eax
  100f2b:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100f2e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f31:	a3 40 d4 11 00       	mov    %eax,0x11d440
    crt_pos = pos;
  100f36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f39:	0f b7 c0             	movzwl %ax,%eax
  100f3c:	66 a3 44 d4 11 00    	mov    %ax,0x11d444
}
  100f42:	90                   	nop
  100f43:	c9                   	leave  
  100f44:	c3                   	ret    

00100f45 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f45:	55                   	push   %ebp
  100f46:	89 e5                	mov    %esp,%ebp
  100f48:	83 ec 48             	sub    $0x48,%esp
  100f4b:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  100f51:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f55:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  100f59:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  100f5d:	ee                   	out    %al,(%dx)
  100f5e:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  100f64:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
  100f68:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  100f6c:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  100f70:	ee                   	out    %al,(%dx)
  100f71:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  100f77:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
  100f7b:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  100f7f:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  100f83:	ee                   	out    %al,(%dx)
  100f84:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100f8a:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
  100f8e:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f92:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100f96:	ee                   	out    %al,(%dx)
  100f97:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  100f9d:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
  100fa1:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100fa5:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100fa9:	ee                   	out    %al,(%dx)
  100faa:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  100fb0:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
  100fb4:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100fb8:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100fbc:	ee                   	out    %al,(%dx)
  100fbd:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100fc3:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
  100fc7:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100fcb:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100fcf:	ee                   	out    %al,(%dx)
  100fd0:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100fd6:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100fda:	89 c2                	mov    %eax,%edx
  100fdc:	ec                   	in     (%dx),%al
  100fdd:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100fe0:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100fe4:	3c ff                	cmp    $0xff,%al
  100fe6:	0f 95 c0             	setne  %al
  100fe9:	0f b6 c0             	movzbl %al,%eax
  100fec:	a3 48 d4 11 00       	mov    %eax,0x11d448
  100ff1:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100ff7:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100ffb:	89 c2                	mov    %eax,%edx
  100ffd:	ec                   	in     (%dx),%al
  100ffe:	88 45 f1             	mov    %al,-0xf(%ebp)
  101001:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101007:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10100b:	89 c2                	mov    %eax,%edx
  10100d:	ec                   	in     (%dx),%al
  10100e:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  101011:	a1 48 d4 11 00       	mov    0x11d448,%eax
  101016:	85 c0                	test   %eax,%eax
  101018:	74 0c                	je     101026 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  10101a:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  101021:	e8 df 06 00 00       	call   101705 <pic_enable>
    }
}
  101026:	90                   	nop
  101027:	c9                   	leave  
  101028:	c3                   	ret    

00101029 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  101029:	55                   	push   %ebp
  10102a:	89 e5                	mov    %esp,%ebp
  10102c:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  10102f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101036:	eb 08                	jmp    101040 <lpt_putc_sub+0x17>
        delay();
  101038:	e8 db fd ff ff       	call   100e18 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  10103d:	ff 45 fc             	incl   -0x4(%ebp)
  101040:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  101046:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10104a:	89 c2                	mov    %eax,%edx
  10104c:	ec                   	in     (%dx),%al
  10104d:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101050:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101054:	84 c0                	test   %al,%al
  101056:	78 09                	js     101061 <lpt_putc_sub+0x38>
  101058:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10105f:	7e d7                	jle    101038 <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
  101061:	8b 45 08             	mov    0x8(%ebp),%eax
  101064:	0f b6 c0             	movzbl %al,%eax
  101067:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  10106d:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101070:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101074:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101078:	ee                   	out    %al,(%dx)
  101079:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  10107f:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  101083:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101087:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10108b:	ee                   	out    %al,(%dx)
  10108c:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  101092:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
  101096:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10109a:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10109e:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  10109f:	90                   	nop
  1010a0:	c9                   	leave  
  1010a1:	c3                   	ret    

001010a2 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  1010a2:	55                   	push   %ebp
  1010a3:	89 e5                	mov    %esp,%ebp
  1010a5:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1010a8:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1010ac:	74 0d                	je     1010bb <lpt_putc+0x19>
        lpt_putc_sub(c);
  1010ae:	8b 45 08             	mov    0x8(%ebp),%eax
  1010b1:	89 04 24             	mov    %eax,(%esp)
  1010b4:	e8 70 ff ff ff       	call   101029 <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  1010b9:	eb 24                	jmp    1010df <lpt_putc+0x3d>
        lpt_putc_sub('\b');
  1010bb:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010c2:	e8 62 ff ff ff       	call   101029 <lpt_putc_sub>
        lpt_putc_sub(' ');
  1010c7:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1010ce:	e8 56 ff ff ff       	call   101029 <lpt_putc_sub>
        lpt_putc_sub('\b');
  1010d3:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010da:	e8 4a ff ff ff       	call   101029 <lpt_putc_sub>
}
  1010df:	90                   	nop
  1010e0:	c9                   	leave  
  1010e1:	c3                   	ret    

001010e2 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  1010e2:	55                   	push   %ebp
  1010e3:	89 e5                	mov    %esp,%ebp
  1010e5:	53                   	push   %ebx
  1010e6:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  1010e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1010ec:	25 00 ff ff ff       	and    $0xffffff00,%eax
  1010f1:	85 c0                	test   %eax,%eax
  1010f3:	75 07                	jne    1010fc <cga_putc+0x1a>
        c |= 0x0700;
  1010f5:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  1010fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1010ff:	0f b6 c0             	movzbl %al,%eax
  101102:	83 f8 0a             	cmp    $0xa,%eax
  101105:	74 55                	je     10115c <cga_putc+0x7a>
  101107:	83 f8 0d             	cmp    $0xd,%eax
  10110a:	74 63                	je     10116f <cga_putc+0x8d>
  10110c:	83 f8 08             	cmp    $0x8,%eax
  10110f:	0f 85 94 00 00 00    	jne    1011a9 <cga_putc+0xc7>
    case '\b':
        if (crt_pos > 0) {
  101115:	0f b7 05 44 d4 11 00 	movzwl 0x11d444,%eax
  10111c:	85 c0                	test   %eax,%eax
  10111e:	0f 84 af 00 00 00    	je     1011d3 <cga_putc+0xf1>
            crt_pos --;
  101124:	0f b7 05 44 d4 11 00 	movzwl 0x11d444,%eax
  10112b:	48                   	dec    %eax
  10112c:	0f b7 c0             	movzwl %ax,%eax
  10112f:	66 a3 44 d4 11 00    	mov    %ax,0x11d444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  101135:	8b 45 08             	mov    0x8(%ebp),%eax
  101138:	98                   	cwtl   
  101139:	25 00 ff ff ff       	and    $0xffffff00,%eax
  10113e:	98                   	cwtl   
  10113f:	83 c8 20             	or     $0x20,%eax
  101142:	98                   	cwtl   
  101143:	8b 15 40 d4 11 00    	mov    0x11d440,%edx
  101149:	0f b7 0d 44 d4 11 00 	movzwl 0x11d444,%ecx
  101150:	01 c9                	add    %ecx,%ecx
  101152:	01 ca                	add    %ecx,%edx
  101154:	0f b7 c0             	movzwl %ax,%eax
  101157:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  10115a:	eb 77                	jmp    1011d3 <cga_putc+0xf1>
    case '\n':
        crt_pos += CRT_COLS;
  10115c:	0f b7 05 44 d4 11 00 	movzwl 0x11d444,%eax
  101163:	83 c0 50             	add    $0x50,%eax
  101166:	0f b7 c0             	movzwl %ax,%eax
  101169:	66 a3 44 d4 11 00    	mov    %ax,0x11d444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  10116f:	0f b7 1d 44 d4 11 00 	movzwl 0x11d444,%ebx
  101176:	0f b7 0d 44 d4 11 00 	movzwl 0x11d444,%ecx
  10117d:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  101182:	89 c8                	mov    %ecx,%eax
  101184:	f7 e2                	mul    %edx
  101186:	c1 ea 06             	shr    $0x6,%edx
  101189:	89 d0                	mov    %edx,%eax
  10118b:	c1 e0 02             	shl    $0x2,%eax
  10118e:	01 d0                	add    %edx,%eax
  101190:	c1 e0 04             	shl    $0x4,%eax
  101193:	29 c1                	sub    %eax,%ecx
  101195:	89 c8                	mov    %ecx,%eax
  101197:	0f b7 c0             	movzwl %ax,%eax
  10119a:	29 c3                	sub    %eax,%ebx
  10119c:	89 d8                	mov    %ebx,%eax
  10119e:	0f b7 c0             	movzwl %ax,%eax
  1011a1:	66 a3 44 d4 11 00    	mov    %ax,0x11d444
        break;
  1011a7:	eb 2b                	jmp    1011d4 <cga_putc+0xf2>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1011a9:	8b 0d 40 d4 11 00    	mov    0x11d440,%ecx
  1011af:	0f b7 05 44 d4 11 00 	movzwl 0x11d444,%eax
  1011b6:	8d 50 01             	lea    0x1(%eax),%edx
  1011b9:	0f b7 d2             	movzwl %dx,%edx
  1011bc:	66 89 15 44 d4 11 00 	mov    %dx,0x11d444
  1011c3:	01 c0                	add    %eax,%eax
  1011c5:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  1011c8:	8b 45 08             	mov    0x8(%ebp),%eax
  1011cb:	0f b7 c0             	movzwl %ax,%eax
  1011ce:	66 89 02             	mov    %ax,(%edx)
        break;
  1011d1:	eb 01                	jmp    1011d4 <cga_putc+0xf2>
        break;
  1011d3:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  1011d4:	0f b7 05 44 d4 11 00 	movzwl 0x11d444,%eax
  1011db:	3d cf 07 00 00       	cmp    $0x7cf,%eax
  1011e0:	76 5d                	jbe    10123f <cga_putc+0x15d>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  1011e2:	a1 40 d4 11 00       	mov    0x11d440,%eax
  1011e7:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1011ed:	a1 40 d4 11 00       	mov    0x11d440,%eax
  1011f2:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  1011f9:	00 
  1011fa:	89 54 24 04          	mov    %edx,0x4(%esp)
  1011fe:	89 04 24             	mov    %eax,(%esp)
  101201:	e8 0f 4f 00 00       	call   106115 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101206:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  10120d:	eb 14                	jmp    101223 <cga_putc+0x141>
            crt_buf[i] = 0x0700 | ' ';
  10120f:	a1 40 d4 11 00       	mov    0x11d440,%eax
  101214:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101217:	01 d2                	add    %edx,%edx
  101219:	01 d0                	add    %edx,%eax
  10121b:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101220:	ff 45 f4             	incl   -0xc(%ebp)
  101223:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  10122a:	7e e3                	jle    10120f <cga_putc+0x12d>
        }
        crt_pos -= CRT_COLS;
  10122c:	0f b7 05 44 d4 11 00 	movzwl 0x11d444,%eax
  101233:	83 e8 50             	sub    $0x50,%eax
  101236:	0f b7 c0             	movzwl %ax,%eax
  101239:	66 a3 44 d4 11 00    	mov    %ax,0x11d444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  10123f:	0f b7 05 46 d4 11 00 	movzwl 0x11d446,%eax
  101246:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  10124a:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
  10124e:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101252:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101256:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  101257:	0f b7 05 44 d4 11 00 	movzwl 0x11d444,%eax
  10125e:	c1 e8 08             	shr    $0x8,%eax
  101261:	0f b7 c0             	movzwl %ax,%eax
  101264:	0f b6 c0             	movzbl %al,%eax
  101267:	0f b7 15 46 d4 11 00 	movzwl 0x11d446,%edx
  10126e:	42                   	inc    %edx
  10126f:	0f b7 d2             	movzwl %dx,%edx
  101272:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  101276:	88 45 e9             	mov    %al,-0x17(%ebp)
  101279:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10127d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101281:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  101282:	0f b7 05 46 d4 11 00 	movzwl 0x11d446,%eax
  101289:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  10128d:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
  101291:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101295:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101299:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  10129a:	0f b7 05 44 d4 11 00 	movzwl 0x11d444,%eax
  1012a1:	0f b6 c0             	movzbl %al,%eax
  1012a4:	0f b7 15 46 d4 11 00 	movzwl 0x11d446,%edx
  1012ab:	42                   	inc    %edx
  1012ac:	0f b7 d2             	movzwl %dx,%edx
  1012af:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  1012b3:	88 45 f1             	mov    %al,-0xf(%ebp)
  1012b6:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1012ba:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1012be:	ee                   	out    %al,(%dx)
}
  1012bf:	90                   	nop
  1012c0:	83 c4 34             	add    $0x34,%esp
  1012c3:	5b                   	pop    %ebx
  1012c4:	5d                   	pop    %ebp
  1012c5:	c3                   	ret    

001012c6 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  1012c6:	55                   	push   %ebp
  1012c7:	89 e5                	mov    %esp,%ebp
  1012c9:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1012d3:	eb 08                	jmp    1012dd <serial_putc_sub+0x17>
        delay();
  1012d5:	e8 3e fb ff ff       	call   100e18 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012da:	ff 45 fc             	incl   -0x4(%ebp)
  1012dd:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1012e3:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1012e7:	89 c2                	mov    %eax,%edx
  1012e9:	ec                   	in     (%dx),%al
  1012ea:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1012ed:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1012f1:	0f b6 c0             	movzbl %al,%eax
  1012f4:	83 e0 20             	and    $0x20,%eax
  1012f7:	85 c0                	test   %eax,%eax
  1012f9:	75 09                	jne    101304 <serial_putc_sub+0x3e>
  1012fb:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101302:	7e d1                	jle    1012d5 <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
  101304:	8b 45 08             	mov    0x8(%ebp),%eax
  101307:	0f b6 c0             	movzbl %al,%eax
  10130a:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101310:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101313:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101317:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10131b:	ee                   	out    %al,(%dx)
}
  10131c:	90                   	nop
  10131d:	c9                   	leave  
  10131e:	c3                   	ret    

0010131f <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  10131f:	55                   	push   %ebp
  101320:	89 e5                	mov    %esp,%ebp
  101322:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101325:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101329:	74 0d                	je     101338 <serial_putc+0x19>
        serial_putc_sub(c);
  10132b:	8b 45 08             	mov    0x8(%ebp),%eax
  10132e:	89 04 24             	mov    %eax,(%esp)
  101331:	e8 90 ff ff ff       	call   1012c6 <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  101336:	eb 24                	jmp    10135c <serial_putc+0x3d>
        serial_putc_sub('\b');
  101338:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10133f:	e8 82 ff ff ff       	call   1012c6 <serial_putc_sub>
        serial_putc_sub(' ');
  101344:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10134b:	e8 76 ff ff ff       	call   1012c6 <serial_putc_sub>
        serial_putc_sub('\b');
  101350:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101357:	e8 6a ff ff ff       	call   1012c6 <serial_putc_sub>
}
  10135c:	90                   	nop
  10135d:	c9                   	leave  
  10135e:	c3                   	ret    

0010135f <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  10135f:	55                   	push   %ebp
  101360:	89 e5                	mov    %esp,%ebp
  101362:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  101365:	eb 33                	jmp    10139a <cons_intr+0x3b>
        if (c != 0) {
  101367:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10136b:	74 2d                	je     10139a <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  10136d:	a1 64 d6 11 00       	mov    0x11d664,%eax
  101372:	8d 50 01             	lea    0x1(%eax),%edx
  101375:	89 15 64 d6 11 00    	mov    %edx,0x11d664
  10137b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10137e:	88 90 60 d4 11 00    	mov    %dl,0x11d460(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101384:	a1 64 d6 11 00       	mov    0x11d664,%eax
  101389:	3d 00 02 00 00       	cmp    $0x200,%eax
  10138e:	75 0a                	jne    10139a <cons_intr+0x3b>
                cons.wpos = 0;
  101390:	c7 05 64 d6 11 00 00 	movl   $0x0,0x11d664
  101397:	00 00 00 
    while ((c = (*proc)()) != -1) {
  10139a:	8b 45 08             	mov    0x8(%ebp),%eax
  10139d:	ff d0                	call   *%eax
  10139f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1013a2:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  1013a6:	75 bf                	jne    101367 <cons_intr+0x8>
            }
        }
    }
}
  1013a8:	90                   	nop
  1013a9:	c9                   	leave  
  1013aa:	c3                   	ret    

001013ab <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  1013ab:	55                   	push   %ebp
  1013ac:	89 e5                	mov    %esp,%ebp
  1013ae:	83 ec 10             	sub    $0x10,%esp
  1013b1:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013b7:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1013bb:	89 c2                	mov    %eax,%edx
  1013bd:	ec                   	in     (%dx),%al
  1013be:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1013c1:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  1013c5:	0f b6 c0             	movzbl %al,%eax
  1013c8:	83 e0 01             	and    $0x1,%eax
  1013cb:	85 c0                	test   %eax,%eax
  1013cd:	75 07                	jne    1013d6 <serial_proc_data+0x2b>
        return -1;
  1013cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013d4:	eb 2a                	jmp    101400 <serial_proc_data+0x55>
  1013d6:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013dc:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1013e0:	89 c2                	mov    %eax,%edx
  1013e2:	ec                   	in     (%dx),%al
  1013e3:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  1013e6:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1013ea:	0f b6 c0             	movzbl %al,%eax
  1013ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1013f0:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  1013f4:	75 07                	jne    1013fd <serial_proc_data+0x52>
        c = '\b';
  1013f6:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  1013fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101400:	c9                   	leave  
  101401:	c3                   	ret    

00101402 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101402:	55                   	push   %ebp
  101403:	89 e5                	mov    %esp,%ebp
  101405:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  101408:	a1 48 d4 11 00       	mov    0x11d448,%eax
  10140d:	85 c0                	test   %eax,%eax
  10140f:	74 0c                	je     10141d <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  101411:	c7 04 24 ab 13 10 00 	movl   $0x1013ab,(%esp)
  101418:	e8 42 ff ff ff       	call   10135f <cons_intr>
    }
}
  10141d:	90                   	nop
  10141e:	c9                   	leave  
  10141f:	c3                   	ret    

00101420 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  101420:	55                   	push   %ebp
  101421:	89 e5                	mov    %esp,%ebp
  101423:	83 ec 38             	sub    $0x38,%esp
  101426:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10142c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10142f:	89 c2                	mov    %eax,%edx
  101431:	ec                   	in     (%dx),%al
  101432:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  101435:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  101439:	0f b6 c0             	movzbl %al,%eax
  10143c:	83 e0 01             	and    $0x1,%eax
  10143f:	85 c0                	test   %eax,%eax
  101441:	75 0a                	jne    10144d <kbd_proc_data+0x2d>
        return -1;
  101443:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101448:	e9 55 01 00 00       	jmp    1015a2 <kbd_proc_data+0x182>
  10144d:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101453:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101456:	89 c2                	mov    %eax,%edx
  101458:	ec                   	in     (%dx),%al
  101459:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  10145c:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  101460:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  101463:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101467:	75 17                	jne    101480 <kbd_proc_data+0x60>
        // E0 escape character
        shift |= E0ESC;
  101469:	a1 68 d6 11 00       	mov    0x11d668,%eax
  10146e:	83 c8 40             	or     $0x40,%eax
  101471:	a3 68 d6 11 00       	mov    %eax,0x11d668
        return 0;
  101476:	b8 00 00 00 00       	mov    $0x0,%eax
  10147b:	e9 22 01 00 00       	jmp    1015a2 <kbd_proc_data+0x182>
    } else if (data & 0x80) {
  101480:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101484:	84 c0                	test   %al,%al
  101486:	79 45                	jns    1014cd <kbd_proc_data+0xad>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101488:	a1 68 d6 11 00       	mov    0x11d668,%eax
  10148d:	83 e0 40             	and    $0x40,%eax
  101490:	85 c0                	test   %eax,%eax
  101492:	75 08                	jne    10149c <kbd_proc_data+0x7c>
  101494:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101498:	24 7f                	and    $0x7f,%al
  10149a:	eb 04                	jmp    1014a0 <kbd_proc_data+0x80>
  10149c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014a0:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  1014a3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014a7:	0f b6 80 40 a0 11 00 	movzbl 0x11a040(%eax),%eax
  1014ae:	0c 40                	or     $0x40,%al
  1014b0:	0f b6 c0             	movzbl %al,%eax
  1014b3:	f7 d0                	not    %eax
  1014b5:	89 c2                	mov    %eax,%edx
  1014b7:	a1 68 d6 11 00       	mov    0x11d668,%eax
  1014bc:	21 d0                	and    %edx,%eax
  1014be:	a3 68 d6 11 00       	mov    %eax,0x11d668
        return 0;
  1014c3:	b8 00 00 00 00       	mov    $0x0,%eax
  1014c8:	e9 d5 00 00 00       	jmp    1015a2 <kbd_proc_data+0x182>
    } else if (shift & E0ESC) {
  1014cd:	a1 68 d6 11 00       	mov    0x11d668,%eax
  1014d2:	83 e0 40             	and    $0x40,%eax
  1014d5:	85 c0                	test   %eax,%eax
  1014d7:	74 11                	je     1014ea <kbd_proc_data+0xca>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1014d9:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1014dd:	a1 68 d6 11 00       	mov    0x11d668,%eax
  1014e2:	83 e0 bf             	and    $0xffffffbf,%eax
  1014e5:	a3 68 d6 11 00       	mov    %eax,0x11d668
    }

    shift |= shiftcode[data];
  1014ea:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014ee:	0f b6 80 40 a0 11 00 	movzbl 0x11a040(%eax),%eax
  1014f5:	0f b6 d0             	movzbl %al,%edx
  1014f8:	a1 68 d6 11 00       	mov    0x11d668,%eax
  1014fd:	09 d0                	or     %edx,%eax
  1014ff:	a3 68 d6 11 00       	mov    %eax,0x11d668
    shift ^= togglecode[data];
  101504:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101508:	0f b6 80 40 a1 11 00 	movzbl 0x11a140(%eax),%eax
  10150f:	0f b6 d0             	movzbl %al,%edx
  101512:	a1 68 d6 11 00       	mov    0x11d668,%eax
  101517:	31 d0                	xor    %edx,%eax
  101519:	a3 68 d6 11 00       	mov    %eax,0x11d668

    c = charcode[shift & (CTL | SHIFT)][data];
  10151e:	a1 68 d6 11 00       	mov    0x11d668,%eax
  101523:	83 e0 03             	and    $0x3,%eax
  101526:	8b 14 85 40 a5 11 00 	mov    0x11a540(,%eax,4),%edx
  10152d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101531:	01 d0                	add    %edx,%eax
  101533:	0f b6 00             	movzbl (%eax),%eax
  101536:	0f b6 c0             	movzbl %al,%eax
  101539:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  10153c:	a1 68 d6 11 00       	mov    0x11d668,%eax
  101541:	83 e0 08             	and    $0x8,%eax
  101544:	85 c0                	test   %eax,%eax
  101546:	74 22                	je     10156a <kbd_proc_data+0x14a>
        if ('a' <= c && c <= 'z')
  101548:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  10154c:	7e 0c                	jle    10155a <kbd_proc_data+0x13a>
  10154e:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  101552:	7f 06                	jg     10155a <kbd_proc_data+0x13a>
            c += 'A' - 'a';
  101554:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  101558:	eb 10                	jmp    10156a <kbd_proc_data+0x14a>
        else if ('A' <= c && c <= 'Z')
  10155a:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  10155e:	7e 0a                	jle    10156a <kbd_proc_data+0x14a>
  101560:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101564:	7f 04                	jg     10156a <kbd_proc_data+0x14a>
            c += 'a' - 'A';
  101566:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  10156a:	a1 68 d6 11 00       	mov    0x11d668,%eax
  10156f:	f7 d0                	not    %eax
  101571:	83 e0 06             	and    $0x6,%eax
  101574:	85 c0                	test   %eax,%eax
  101576:	75 27                	jne    10159f <kbd_proc_data+0x17f>
  101578:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  10157f:	75 1e                	jne    10159f <kbd_proc_data+0x17f>
        cprintf("Rebooting!\n");
  101581:	c7 04 24 0d 6c 10 00 	movl   $0x106c0d,(%esp)
  101588:	e8 01 ed ff ff       	call   10028e <cprintf>
  10158d:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101593:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101597:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  10159b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  10159e:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  10159f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1015a2:	c9                   	leave  
  1015a3:	c3                   	ret    

001015a4 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  1015a4:	55                   	push   %ebp
  1015a5:	89 e5                	mov    %esp,%ebp
  1015a7:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  1015aa:	c7 04 24 20 14 10 00 	movl   $0x101420,(%esp)
  1015b1:	e8 a9 fd ff ff       	call   10135f <cons_intr>
}
  1015b6:	90                   	nop
  1015b7:	c9                   	leave  
  1015b8:	c3                   	ret    

001015b9 <kbd_init>:

static void
kbd_init(void) {
  1015b9:	55                   	push   %ebp
  1015ba:	89 e5                	mov    %esp,%ebp
  1015bc:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  1015bf:	e8 e0 ff ff ff       	call   1015a4 <kbd_intr>
    pic_enable(IRQ_KBD);
  1015c4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1015cb:	e8 35 01 00 00       	call   101705 <pic_enable>
}
  1015d0:	90                   	nop
  1015d1:	c9                   	leave  
  1015d2:	c3                   	ret    

001015d3 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1015d3:	55                   	push   %ebp
  1015d4:	89 e5                	mov    %esp,%ebp
  1015d6:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  1015d9:	e8 83 f8 ff ff       	call   100e61 <cga_init>
    serial_init();
  1015de:	e8 62 f9 ff ff       	call   100f45 <serial_init>
    kbd_init();
  1015e3:	e8 d1 ff ff ff       	call   1015b9 <kbd_init>
    if (!serial_exists) {
  1015e8:	a1 48 d4 11 00       	mov    0x11d448,%eax
  1015ed:	85 c0                	test   %eax,%eax
  1015ef:	75 0c                	jne    1015fd <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  1015f1:	c7 04 24 19 6c 10 00 	movl   $0x106c19,(%esp)
  1015f8:	e8 91 ec ff ff       	call   10028e <cprintf>
    }
}
  1015fd:	90                   	nop
  1015fe:	c9                   	leave  
  1015ff:	c3                   	ret    

00101600 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  101600:	55                   	push   %ebp
  101601:	89 e5                	mov    %esp,%ebp
  101603:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  101606:	e8 cf f7 ff ff       	call   100dda <__intr_save>
  10160b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  10160e:	8b 45 08             	mov    0x8(%ebp),%eax
  101611:	89 04 24             	mov    %eax,(%esp)
  101614:	e8 89 fa ff ff       	call   1010a2 <lpt_putc>
        cga_putc(c);
  101619:	8b 45 08             	mov    0x8(%ebp),%eax
  10161c:	89 04 24             	mov    %eax,(%esp)
  10161f:	e8 be fa ff ff       	call   1010e2 <cga_putc>
        serial_putc(c);
  101624:	8b 45 08             	mov    0x8(%ebp),%eax
  101627:	89 04 24             	mov    %eax,(%esp)
  10162a:	e8 f0 fc ff ff       	call   10131f <serial_putc>
    }
    local_intr_restore(intr_flag);
  10162f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101632:	89 04 24             	mov    %eax,(%esp)
  101635:	e8 ca f7 ff ff       	call   100e04 <__intr_restore>
}
  10163a:	90                   	nop
  10163b:	c9                   	leave  
  10163c:	c3                   	ret    

0010163d <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  10163d:	55                   	push   %ebp
  10163e:	89 e5                	mov    %esp,%ebp
  101640:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
  101643:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  10164a:	e8 8b f7 ff ff       	call   100dda <__intr_save>
  10164f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  101652:	e8 ab fd ff ff       	call   101402 <serial_intr>
        kbd_intr();
  101657:	e8 48 ff ff ff       	call   1015a4 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  10165c:	8b 15 60 d6 11 00    	mov    0x11d660,%edx
  101662:	a1 64 d6 11 00       	mov    0x11d664,%eax
  101667:	39 c2                	cmp    %eax,%edx
  101669:	74 31                	je     10169c <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
  10166b:	a1 60 d6 11 00       	mov    0x11d660,%eax
  101670:	8d 50 01             	lea    0x1(%eax),%edx
  101673:	89 15 60 d6 11 00    	mov    %edx,0x11d660
  101679:	0f b6 80 60 d4 11 00 	movzbl 0x11d460(%eax),%eax
  101680:	0f b6 c0             	movzbl %al,%eax
  101683:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  101686:	a1 60 d6 11 00       	mov    0x11d660,%eax
  10168b:	3d 00 02 00 00       	cmp    $0x200,%eax
  101690:	75 0a                	jne    10169c <cons_getc+0x5f>
                cons.rpos = 0;
  101692:	c7 05 60 d6 11 00 00 	movl   $0x0,0x11d660
  101699:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  10169c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10169f:	89 04 24             	mov    %eax,(%esp)
  1016a2:	e8 5d f7 ff ff       	call   100e04 <__intr_restore>
    return c;
  1016a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1016aa:	c9                   	leave  
  1016ab:	c3                   	ret    

001016ac <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1016ac:	55                   	push   %ebp
  1016ad:	89 e5                	mov    %esp,%ebp
  1016af:	83 ec 14             	sub    $0x14,%esp
  1016b2:	8b 45 08             	mov    0x8(%ebp),%eax
  1016b5:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1016b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1016bc:	66 a3 50 a5 11 00    	mov    %ax,0x11a550
    if (did_init) {
  1016c2:	a1 6c d6 11 00       	mov    0x11d66c,%eax
  1016c7:	85 c0                	test   %eax,%eax
  1016c9:	74 37                	je     101702 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  1016cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1016ce:	0f b6 c0             	movzbl %al,%eax
  1016d1:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  1016d7:	88 45 f9             	mov    %al,-0x7(%ebp)
  1016da:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1016de:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1016e2:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  1016e3:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016e7:	c1 e8 08             	shr    $0x8,%eax
  1016ea:	0f b7 c0             	movzwl %ax,%eax
  1016ed:	0f b6 c0             	movzbl %al,%eax
  1016f0:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  1016f6:	88 45 fd             	mov    %al,-0x3(%ebp)
  1016f9:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016fd:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101701:	ee                   	out    %al,(%dx)
    }
}
  101702:	90                   	nop
  101703:	c9                   	leave  
  101704:	c3                   	ret    

00101705 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101705:	55                   	push   %ebp
  101706:	89 e5                	mov    %esp,%ebp
  101708:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  10170b:	8b 45 08             	mov    0x8(%ebp),%eax
  10170e:	ba 01 00 00 00       	mov    $0x1,%edx
  101713:	88 c1                	mov    %al,%cl
  101715:	d3 e2                	shl    %cl,%edx
  101717:	89 d0                	mov    %edx,%eax
  101719:	98                   	cwtl   
  10171a:	f7 d0                	not    %eax
  10171c:	0f bf d0             	movswl %ax,%edx
  10171f:	0f b7 05 50 a5 11 00 	movzwl 0x11a550,%eax
  101726:	98                   	cwtl   
  101727:	21 d0                	and    %edx,%eax
  101729:	98                   	cwtl   
  10172a:	0f b7 c0             	movzwl %ax,%eax
  10172d:	89 04 24             	mov    %eax,(%esp)
  101730:	e8 77 ff ff ff       	call   1016ac <pic_setmask>
}
  101735:	90                   	nop
  101736:	c9                   	leave  
  101737:	c3                   	ret    

00101738 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  101738:	55                   	push   %ebp
  101739:	89 e5                	mov    %esp,%ebp
  10173b:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  10173e:	c7 05 6c d6 11 00 01 	movl   $0x1,0x11d66c
  101745:	00 00 00 
  101748:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  10174e:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
  101752:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  101756:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  10175a:	ee                   	out    %al,(%dx)
  10175b:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  101761:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
  101765:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  101769:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  10176d:	ee                   	out    %al,(%dx)
  10176e:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  101774:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
  101778:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  10177c:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  101780:	ee                   	out    %al,(%dx)
  101781:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  101787:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
  10178b:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  10178f:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101793:	ee                   	out    %al,(%dx)
  101794:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  10179a:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
  10179e:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  1017a2:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  1017a6:	ee                   	out    %al,(%dx)
  1017a7:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  1017ad:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
  1017b1:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  1017b5:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  1017b9:	ee                   	out    %al,(%dx)
  1017ba:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  1017c0:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
  1017c4:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  1017c8:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  1017cc:	ee                   	out    %al,(%dx)
  1017cd:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  1017d3:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
  1017d7:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1017db:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1017df:	ee                   	out    %al,(%dx)
  1017e0:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  1017e6:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
  1017ea:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1017ee:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1017f2:	ee                   	out    %al,(%dx)
  1017f3:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  1017f9:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
  1017fd:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101801:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101805:	ee                   	out    %al,(%dx)
  101806:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  10180c:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
  101810:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101814:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101818:	ee                   	out    %al,(%dx)
  101819:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  10181f:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
  101823:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101827:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10182b:	ee                   	out    %al,(%dx)
  10182c:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  101832:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
  101836:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10183a:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10183e:	ee                   	out    %al,(%dx)
  10183f:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  101845:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
  101849:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10184d:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101851:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  101852:	0f b7 05 50 a5 11 00 	movzwl 0x11a550,%eax
  101859:	3d ff ff 00 00       	cmp    $0xffff,%eax
  10185e:	74 0f                	je     10186f <pic_init+0x137>
        pic_setmask(irq_mask);
  101860:	0f b7 05 50 a5 11 00 	movzwl 0x11a550,%eax
  101867:	89 04 24             	mov    %eax,(%esp)
  10186a:	e8 3d fe ff ff       	call   1016ac <pic_setmask>
    }
}
  10186f:	90                   	nop
  101870:	c9                   	leave  
  101871:	c3                   	ret    

00101872 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  101872:	55                   	push   %ebp
  101873:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
  101875:	fb                   	sti    
    sti();
}
  101876:	90                   	nop
  101877:	5d                   	pop    %ebp
  101878:	c3                   	ret    

00101879 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  101879:	55                   	push   %ebp
  10187a:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
  10187c:	fa                   	cli    
    cli();
}
  10187d:	90                   	nop
  10187e:	5d                   	pop    %ebp
  10187f:	c3                   	ret    

00101880 <print_switch_to_user>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100
void print_switch_to_user()
{
  101880:	55                   	push   %ebp
  101881:	89 e5                	mov    %esp,%ebp
  101883:	83 ec 18             	sub    $0x18,%esp
	cprintf("switch to user");
  101886:	c7 04 24 40 6c 10 00 	movl   $0x106c40,(%esp)
  10188d:	e8 fc e9 ff ff       	call   10028e <cprintf>
}
  101892:	90                   	nop
  101893:	c9                   	leave  
  101894:	c3                   	ret    

00101895 <print_switch_to_kernel>:

void print_switch_to_kernel()
{
  101895:	55                   	push   %ebp
  101896:	89 e5                	mov    %esp,%ebp
  101898:	83 ec 18             	sub    $0x18,%esp
	cprintf("switch to kernel\n");
  10189b:	c7 04 24 4f 6c 10 00 	movl   $0x106c4f,(%esp)
  1018a2:	e8 e7 e9 ff ff       	call   10028e <cprintf>
}
  1018a7:	90                   	nop
  1018a8:	c9                   	leave  
  1018a9:	c3                   	ret    

001018aa <print_ticks>:

static void print_ticks() {
  1018aa:	55                   	push   %ebp
  1018ab:	89 e5                	mov    %esp,%ebp
  1018ad:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  1018b0:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  1018b7:	00 
  1018b8:	c7 04 24 61 6c 10 00 	movl   $0x106c61,(%esp)
  1018bf:	e8 ca e9 ff ff       	call   10028e <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  1018c4:	90                   	nop
  1018c5:	c9                   	leave  
  1018c6:	c3                   	ret    

001018c7 <idt_init>:

extern uint32_t __vectors[256];

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1018c7:	55                   	push   %ebp
  1018c8:	89 e5                	mov    %esp,%ebp
  1018ca:	83 ec 10             	sub    $0x10,%esp
      *     Can you see idt[256] in this file? Yes, it's IDT! you can use SETGATE macro to setup each item of IDT
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	int intrno = 0;
  1018cd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	/* ucore don't use task gate.*/
	for(; intrno < 256; intrno++) 
  1018d4:	e9 c4 00 00 00       	jmp    10199d <idt_init+0xd6>
		SETGATE(idt[intrno], 0, KERNEL_CS, __vectors[intrno], DPL_KERNEL);
  1018d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018dc:	8b 04 85 e0 a5 11 00 	mov    0x11a5e0(,%eax,4),%eax
  1018e3:	0f b7 d0             	movzwl %ax,%edx
  1018e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018e9:	66 89 14 c5 80 d6 11 	mov    %dx,0x11d680(,%eax,8)
  1018f0:	00 
  1018f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018f4:	66 c7 04 c5 82 d6 11 	movw   $0x8,0x11d682(,%eax,8)
  1018fb:	00 08 00 
  1018fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101901:	0f b6 14 c5 84 d6 11 	movzbl 0x11d684(,%eax,8),%edx
  101908:	00 
  101909:	80 e2 e0             	and    $0xe0,%dl
  10190c:	88 14 c5 84 d6 11 00 	mov    %dl,0x11d684(,%eax,8)
  101913:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101916:	0f b6 14 c5 84 d6 11 	movzbl 0x11d684(,%eax,8),%edx
  10191d:	00 
  10191e:	80 e2 1f             	and    $0x1f,%dl
  101921:	88 14 c5 84 d6 11 00 	mov    %dl,0x11d684(,%eax,8)
  101928:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10192b:	0f b6 14 c5 85 d6 11 	movzbl 0x11d685(,%eax,8),%edx
  101932:	00 
  101933:	80 e2 f0             	and    $0xf0,%dl
  101936:	80 ca 0e             	or     $0xe,%dl
  101939:	88 14 c5 85 d6 11 00 	mov    %dl,0x11d685(,%eax,8)
  101940:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101943:	0f b6 14 c5 85 d6 11 	movzbl 0x11d685(,%eax,8),%edx
  10194a:	00 
  10194b:	80 e2 ef             	and    $0xef,%dl
  10194e:	88 14 c5 85 d6 11 00 	mov    %dl,0x11d685(,%eax,8)
  101955:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101958:	0f b6 14 c5 85 d6 11 	movzbl 0x11d685(,%eax,8),%edx
  10195f:	00 
  101960:	80 e2 9f             	and    $0x9f,%dl
  101963:	88 14 c5 85 d6 11 00 	mov    %dl,0x11d685(,%eax,8)
  10196a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10196d:	0f b6 14 c5 85 d6 11 	movzbl 0x11d685(,%eax,8),%edx
  101974:	00 
  101975:	80 ca 80             	or     $0x80,%dl
  101978:	88 14 c5 85 d6 11 00 	mov    %dl,0x11d685(,%eax,8)
  10197f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101982:	8b 04 85 e0 a5 11 00 	mov    0x11a5e0(,%eax,4),%eax
  101989:	c1 e8 10             	shr    $0x10,%eax
  10198c:	0f b7 d0             	movzwl %ax,%edx
  10198f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101992:	66 89 14 c5 86 d6 11 	mov    %dx,0x11d686(,%eax,8)
  101999:	00 
	for(; intrno < 256; intrno++) 
  10199a:	ff 45 fc             	incl   -0x4(%ebp)
  10199d:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  1019a4:	0f 8e 2f ff ff ff    	jle    1018d9 <idt_init+0x12>

	SETGATE(idt[T_SYSCALL], 1, KERNEL_CS, __vectors[T_SYSCALL], DPL_USER);
  1019aa:	a1 e0 a7 11 00       	mov    0x11a7e0,%eax
  1019af:	0f b7 c0             	movzwl %ax,%eax
  1019b2:	66 a3 80 da 11 00    	mov    %ax,0x11da80
  1019b8:	66 c7 05 82 da 11 00 	movw   $0x8,0x11da82
  1019bf:	08 00 
  1019c1:	0f b6 05 84 da 11 00 	movzbl 0x11da84,%eax
  1019c8:	24 e0                	and    $0xe0,%al
  1019ca:	a2 84 da 11 00       	mov    %al,0x11da84
  1019cf:	0f b6 05 84 da 11 00 	movzbl 0x11da84,%eax
  1019d6:	24 1f                	and    $0x1f,%al
  1019d8:	a2 84 da 11 00       	mov    %al,0x11da84
  1019dd:	0f b6 05 85 da 11 00 	movzbl 0x11da85,%eax
  1019e4:	0c 0f                	or     $0xf,%al
  1019e6:	a2 85 da 11 00       	mov    %al,0x11da85
  1019eb:	0f b6 05 85 da 11 00 	movzbl 0x11da85,%eax
  1019f2:	24 ef                	and    $0xef,%al
  1019f4:	a2 85 da 11 00       	mov    %al,0x11da85
  1019f9:	0f b6 05 85 da 11 00 	movzbl 0x11da85,%eax
  101a00:	0c 60                	or     $0x60,%al
  101a02:	a2 85 da 11 00       	mov    %al,0x11da85
  101a07:	0f b6 05 85 da 11 00 	movzbl 0x11da85,%eax
  101a0e:	0c 80                	or     $0x80,%al
  101a10:	a2 85 da 11 00       	mov    %al,0x11da85
  101a15:	a1 e0 a7 11 00       	mov    0x11a7e0,%eax
  101a1a:	c1 e8 10             	shr    $0x10,%eax
  101a1d:	0f b7 c0             	movzwl %ax,%eax
  101a20:	66 a3 86 da 11 00    	mov    %ax,0x11da86
	SETGATE(idt[T_SWITCH_TOK], 0, KERNEL_CS, __vectors[T_SWITCH_TOK], DPL_USER);
  101a26:	a1 c4 a7 11 00       	mov    0x11a7c4,%eax
  101a2b:	0f b7 c0             	movzwl %ax,%eax
  101a2e:	66 a3 48 da 11 00    	mov    %ax,0x11da48
  101a34:	66 c7 05 4a da 11 00 	movw   $0x8,0x11da4a
  101a3b:	08 00 
  101a3d:	0f b6 05 4c da 11 00 	movzbl 0x11da4c,%eax
  101a44:	24 e0                	and    $0xe0,%al
  101a46:	a2 4c da 11 00       	mov    %al,0x11da4c
  101a4b:	0f b6 05 4c da 11 00 	movzbl 0x11da4c,%eax
  101a52:	24 1f                	and    $0x1f,%al
  101a54:	a2 4c da 11 00       	mov    %al,0x11da4c
  101a59:	0f b6 05 4d da 11 00 	movzbl 0x11da4d,%eax
  101a60:	24 f0                	and    $0xf0,%al
  101a62:	0c 0e                	or     $0xe,%al
  101a64:	a2 4d da 11 00       	mov    %al,0x11da4d
  101a69:	0f b6 05 4d da 11 00 	movzbl 0x11da4d,%eax
  101a70:	24 ef                	and    $0xef,%al
  101a72:	a2 4d da 11 00       	mov    %al,0x11da4d
  101a77:	0f b6 05 4d da 11 00 	movzbl 0x11da4d,%eax
  101a7e:	0c 60                	or     $0x60,%al
  101a80:	a2 4d da 11 00       	mov    %al,0x11da4d
  101a85:	0f b6 05 4d da 11 00 	movzbl 0x11da4d,%eax
  101a8c:	0c 80                	or     $0x80,%al
  101a8e:	a2 4d da 11 00       	mov    %al,0x11da4d
  101a93:	a1 c4 a7 11 00       	mov    0x11a7c4,%eax
  101a98:	c1 e8 10             	shr    $0x10,%eax
  101a9b:	0f b7 c0             	movzwl %ax,%eax
  101a9e:	66 a3 4e da 11 00    	mov    %ax,0x11da4e
	SETGATE(idt[T_SWITCH_TOU], 0, KERNEL_CS, __vectors[T_SWITCH_TOU], DPL_KERNEL);
  101aa4:	a1 c0 a7 11 00       	mov    0x11a7c0,%eax
  101aa9:	0f b7 c0             	movzwl %ax,%eax
  101aac:	66 a3 40 da 11 00    	mov    %ax,0x11da40
  101ab2:	66 c7 05 42 da 11 00 	movw   $0x8,0x11da42
  101ab9:	08 00 
  101abb:	0f b6 05 44 da 11 00 	movzbl 0x11da44,%eax
  101ac2:	24 e0                	and    $0xe0,%al
  101ac4:	a2 44 da 11 00       	mov    %al,0x11da44
  101ac9:	0f b6 05 44 da 11 00 	movzbl 0x11da44,%eax
  101ad0:	24 1f                	and    $0x1f,%al
  101ad2:	a2 44 da 11 00       	mov    %al,0x11da44
  101ad7:	0f b6 05 45 da 11 00 	movzbl 0x11da45,%eax
  101ade:	24 f0                	and    $0xf0,%al
  101ae0:	0c 0e                	or     $0xe,%al
  101ae2:	a2 45 da 11 00       	mov    %al,0x11da45
  101ae7:	0f b6 05 45 da 11 00 	movzbl 0x11da45,%eax
  101aee:	24 ef                	and    $0xef,%al
  101af0:	a2 45 da 11 00       	mov    %al,0x11da45
  101af5:	0f b6 05 45 da 11 00 	movzbl 0x11da45,%eax
  101afc:	24 9f                	and    $0x9f,%al
  101afe:	a2 45 da 11 00       	mov    %al,0x11da45
  101b03:	0f b6 05 45 da 11 00 	movzbl 0x11da45,%eax
  101b0a:	0c 80                	or     $0x80,%al
  101b0c:	a2 45 da 11 00       	mov    %al,0x11da45
  101b11:	a1 c0 a7 11 00       	mov    0x11a7c0,%eax
  101b16:	c1 e8 10             	shr    $0x10,%eax
  101b19:	0f b7 c0             	movzwl %ax,%eax
  101b1c:	66 a3 46 da 11 00    	mov    %ax,0x11da46
  101b22:	c7 45 f8 60 a5 11 00 	movl   $0x11a560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  101b29:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101b2c:	0f 01 18             	lidtl  (%eax)

	lidt(&idt_pd);

}
  101b2f:	90                   	nop
  101b30:	c9                   	leave  
  101b31:	c3                   	ret    

00101b32 <trapname>:

static const char *
trapname(int trapno) {
  101b32:	55                   	push   %ebp
  101b33:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101b35:	8b 45 08             	mov    0x8(%ebp),%eax
  101b38:	83 f8 13             	cmp    $0x13,%eax
  101b3b:	77 0c                	ja     101b49 <trapname+0x17>
        return excnames[trapno];
  101b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  101b40:	8b 04 85 e0 6f 10 00 	mov    0x106fe0(,%eax,4),%eax
  101b47:	eb 18                	jmp    101b61 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101b49:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101b4d:	7e 0d                	jle    101b5c <trapname+0x2a>
  101b4f:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101b53:	7f 07                	jg     101b5c <trapname+0x2a>
        return "Hardware Interrupt";
  101b55:	b8 6b 6c 10 00       	mov    $0x106c6b,%eax
  101b5a:	eb 05                	jmp    101b61 <trapname+0x2f>
    }
    return "(unknown trap)";
  101b5c:	b8 7e 6c 10 00       	mov    $0x106c7e,%eax
}
  101b61:	5d                   	pop    %ebp
  101b62:	c3                   	ret    

00101b63 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101b63:	55                   	push   %ebp
  101b64:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101b66:	8b 45 08             	mov    0x8(%ebp),%eax
  101b69:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b6d:	83 f8 08             	cmp    $0x8,%eax
  101b70:	0f 94 c0             	sete   %al
  101b73:	0f b6 c0             	movzbl %al,%eax
}
  101b76:	5d                   	pop    %ebp
  101b77:	c3                   	ret    

00101b78 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101b78:	55                   	push   %ebp
  101b79:	89 e5                	mov    %esp,%ebp
  101b7b:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b81:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b85:	c7 04 24 bf 6c 10 00 	movl   $0x106cbf,(%esp)
  101b8c:	e8 fd e6 ff ff       	call   10028e <cprintf>
    print_regs(&tf->tf_regs);
  101b91:	8b 45 08             	mov    0x8(%ebp),%eax
  101b94:	89 04 24             	mov    %eax,(%esp)
  101b97:	e8 8f 01 00 00       	call   101d2b <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101b9c:	8b 45 08             	mov    0x8(%ebp),%eax
  101b9f:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101ba3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ba7:	c7 04 24 d0 6c 10 00 	movl   $0x106cd0,(%esp)
  101bae:	e8 db e6 ff ff       	call   10028e <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  101bb6:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101bba:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bbe:	c7 04 24 e3 6c 10 00 	movl   $0x106ce3,(%esp)
  101bc5:	e8 c4 e6 ff ff       	call   10028e <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101bca:	8b 45 08             	mov    0x8(%ebp),%eax
  101bcd:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101bd1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bd5:	c7 04 24 f6 6c 10 00 	movl   $0x106cf6,(%esp)
  101bdc:	e8 ad e6 ff ff       	call   10028e <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101be1:	8b 45 08             	mov    0x8(%ebp),%eax
  101be4:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101be8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bec:	c7 04 24 09 6d 10 00 	movl   $0x106d09,(%esp)
  101bf3:	e8 96 e6 ff ff       	call   10028e <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  101bfb:	8b 40 30             	mov    0x30(%eax),%eax
  101bfe:	89 04 24             	mov    %eax,(%esp)
  101c01:	e8 2c ff ff ff       	call   101b32 <trapname>
  101c06:	89 c2                	mov    %eax,%edx
  101c08:	8b 45 08             	mov    0x8(%ebp),%eax
  101c0b:	8b 40 30             	mov    0x30(%eax),%eax
  101c0e:	89 54 24 08          	mov    %edx,0x8(%esp)
  101c12:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c16:	c7 04 24 1c 6d 10 00 	movl   $0x106d1c,(%esp)
  101c1d:	e8 6c e6 ff ff       	call   10028e <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101c22:	8b 45 08             	mov    0x8(%ebp),%eax
  101c25:	8b 40 34             	mov    0x34(%eax),%eax
  101c28:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c2c:	c7 04 24 2e 6d 10 00 	movl   $0x106d2e,(%esp)
  101c33:	e8 56 e6 ff ff       	call   10028e <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101c38:	8b 45 08             	mov    0x8(%ebp),%eax
  101c3b:	8b 40 38             	mov    0x38(%eax),%eax
  101c3e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c42:	c7 04 24 3d 6d 10 00 	movl   $0x106d3d,(%esp)
  101c49:	e8 40 e6 ff ff       	call   10028e <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  101c51:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101c55:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c59:	c7 04 24 4c 6d 10 00 	movl   $0x106d4c,(%esp)
  101c60:	e8 29 e6 ff ff       	call   10028e <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101c65:	8b 45 08             	mov    0x8(%ebp),%eax
  101c68:	8b 40 40             	mov    0x40(%eax),%eax
  101c6b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c6f:	c7 04 24 5f 6d 10 00 	movl   $0x106d5f,(%esp)
  101c76:	e8 13 e6 ff ff       	call   10028e <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101c7b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101c82:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101c89:	eb 3d                	jmp    101cc8 <print_trapframe+0x150>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  101c8e:	8b 50 40             	mov    0x40(%eax),%edx
  101c91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101c94:	21 d0                	and    %edx,%eax
  101c96:	85 c0                	test   %eax,%eax
  101c98:	74 28                	je     101cc2 <print_trapframe+0x14a>
  101c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c9d:	8b 04 85 80 a5 11 00 	mov    0x11a580(,%eax,4),%eax
  101ca4:	85 c0                	test   %eax,%eax
  101ca6:	74 1a                	je     101cc2 <print_trapframe+0x14a>
            cprintf("%s,", IA32flags[i]);
  101ca8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101cab:	8b 04 85 80 a5 11 00 	mov    0x11a580(,%eax,4),%eax
  101cb2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cb6:	c7 04 24 6e 6d 10 00 	movl   $0x106d6e,(%esp)
  101cbd:	e8 cc e5 ff ff       	call   10028e <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101cc2:	ff 45 f4             	incl   -0xc(%ebp)
  101cc5:	d1 65 f0             	shll   -0x10(%ebp)
  101cc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101ccb:	83 f8 17             	cmp    $0x17,%eax
  101cce:	76 bb                	jbe    101c8b <print_trapframe+0x113>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  101cd3:	8b 40 40             	mov    0x40(%eax),%eax
  101cd6:	c1 e8 0c             	shr    $0xc,%eax
  101cd9:	83 e0 03             	and    $0x3,%eax
  101cdc:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ce0:	c7 04 24 72 6d 10 00 	movl   $0x106d72,(%esp)
  101ce7:	e8 a2 e5 ff ff       	call   10028e <cprintf>

    if (!trap_in_kernel(tf)) {
  101cec:	8b 45 08             	mov    0x8(%ebp),%eax
  101cef:	89 04 24             	mov    %eax,(%esp)
  101cf2:	e8 6c fe ff ff       	call   101b63 <trap_in_kernel>
  101cf7:	85 c0                	test   %eax,%eax
  101cf9:	75 2d                	jne    101d28 <print_trapframe+0x1b0>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  101cfe:	8b 40 44             	mov    0x44(%eax),%eax
  101d01:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d05:	c7 04 24 7b 6d 10 00 	movl   $0x106d7b,(%esp)
  101d0c:	e8 7d e5 ff ff       	call   10028e <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101d11:	8b 45 08             	mov    0x8(%ebp),%eax
  101d14:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101d18:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d1c:	c7 04 24 8a 6d 10 00 	movl   $0x106d8a,(%esp)
  101d23:	e8 66 e5 ff ff       	call   10028e <cprintf>
    }
}
  101d28:	90                   	nop
  101d29:	c9                   	leave  
  101d2a:	c3                   	ret    

00101d2b <print_regs>:

void
print_regs(struct pushregs *regs) {
  101d2b:	55                   	push   %ebp
  101d2c:	89 e5                	mov    %esp,%ebp
  101d2e:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101d31:	8b 45 08             	mov    0x8(%ebp),%eax
  101d34:	8b 00                	mov    (%eax),%eax
  101d36:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d3a:	c7 04 24 9d 6d 10 00 	movl   $0x106d9d,(%esp)
  101d41:	e8 48 e5 ff ff       	call   10028e <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101d46:	8b 45 08             	mov    0x8(%ebp),%eax
  101d49:	8b 40 04             	mov    0x4(%eax),%eax
  101d4c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d50:	c7 04 24 ac 6d 10 00 	movl   $0x106dac,(%esp)
  101d57:	e8 32 e5 ff ff       	call   10028e <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  101d5f:	8b 40 08             	mov    0x8(%eax),%eax
  101d62:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d66:	c7 04 24 bb 6d 10 00 	movl   $0x106dbb,(%esp)
  101d6d:	e8 1c e5 ff ff       	call   10028e <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101d72:	8b 45 08             	mov    0x8(%ebp),%eax
  101d75:	8b 40 0c             	mov    0xc(%eax),%eax
  101d78:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d7c:	c7 04 24 ca 6d 10 00 	movl   $0x106dca,(%esp)
  101d83:	e8 06 e5 ff ff       	call   10028e <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101d88:	8b 45 08             	mov    0x8(%ebp),%eax
  101d8b:	8b 40 10             	mov    0x10(%eax),%eax
  101d8e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d92:	c7 04 24 d9 6d 10 00 	movl   $0x106dd9,(%esp)
  101d99:	e8 f0 e4 ff ff       	call   10028e <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  101da1:	8b 40 14             	mov    0x14(%eax),%eax
  101da4:	89 44 24 04          	mov    %eax,0x4(%esp)
  101da8:	c7 04 24 e8 6d 10 00 	movl   $0x106de8,(%esp)
  101daf:	e8 da e4 ff ff       	call   10028e <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101db4:	8b 45 08             	mov    0x8(%ebp),%eax
  101db7:	8b 40 18             	mov    0x18(%eax),%eax
  101dba:	89 44 24 04          	mov    %eax,0x4(%esp)
  101dbe:	c7 04 24 f7 6d 10 00 	movl   $0x106df7,(%esp)
  101dc5:	e8 c4 e4 ff ff       	call   10028e <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101dca:	8b 45 08             	mov    0x8(%ebp),%eax
  101dcd:	8b 40 1c             	mov    0x1c(%eax),%eax
  101dd0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101dd4:	c7 04 24 06 6e 10 00 	movl   $0x106e06,(%esp)
  101ddb:	e8 ae e4 ff ff       	call   10028e <cprintf>
}
  101de0:	90                   	nop
  101de1:	c9                   	leave  
  101de2:	c3                   	ret    

00101de3 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101de3:	55                   	push   %ebp
  101de4:	89 e5                	mov    %esp,%ebp
  101de6:	57                   	push   %edi
  101de7:	56                   	push   %esi
  101de8:	53                   	push   %ebx
  101de9:	83 ec 2c             	sub    $0x2c,%esp
    char c;
	static struct trapframe *correct_tf;
	correct_tf = (struct trapframe *) ((uint32_t)(tf) - 8);
  101dec:	8b 45 08             	mov    0x8(%ebp),%eax
  101def:	83 e8 08             	sub    $0x8,%eax
  101df2:	a3 80 de 11 00       	mov    %eax,0x11de80

    switch (tf->tf_trapno) {
  101df7:	8b 45 08             	mov    0x8(%ebp),%eax
  101dfa:	8b 40 30             	mov    0x30(%eax),%eax
  101dfd:	83 f8 24             	cmp    $0x24,%eax
  101e00:	0f 84 96 00 00 00    	je     101e9c <trap_dispatch+0xb9>
  101e06:	83 f8 24             	cmp    $0x24,%eax
  101e09:	77 1c                	ja     101e27 <trap_dispatch+0x44>
  101e0b:	83 f8 20             	cmp    $0x20,%eax
  101e0e:	74 44                	je     101e54 <trap_dispatch+0x71>
  101e10:	83 f8 21             	cmp    $0x21,%eax
  101e13:	0f 84 ac 00 00 00    	je     101ec5 <trap_dispatch+0xe2>
  101e19:	83 f8 0d             	cmp    $0xd,%eax
  101e1c:	0f 84 aa 03 00 00    	je     1021cc <loop+0x16e>
  101e22:	e9 be 03 00 00       	jmp    1021e5 <loop+0x187>
  101e27:	83 f8 78             	cmp    $0x78,%eax
  101e2a:	0f 84 a8 02 00 00    	je     1020d8 <loop+0x7a>
  101e30:	83 f8 78             	cmp    $0x78,%eax
  101e33:	77 11                	ja     101e46 <trap_dispatch+0x63>
  101e35:	83 e8 2e             	sub    $0x2e,%eax
  101e38:	83 f8 01             	cmp    $0x1,%eax
  101e3b:	0f 87 a4 03 00 00    	ja     1021e5 <loop+0x187>
		}
			break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101e41:	e9 f7 03 00 00       	jmp    10223d <loop+0x1df>
    switch (tf->tf_trapno) {
  101e46:	83 f8 79             	cmp    $0x79,%eax
  101e49:	0f 84 0c 03 00 00    	je     10215b <loop+0xfd>
  101e4f:	e9 91 03 00 00       	jmp    1021e5 <loop+0x187>
		ticks = (ticks + 1) % 100;
  101e54:	a1 2c df 11 00       	mov    0x11df2c,%eax
  101e59:	8d 48 01             	lea    0x1(%eax),%ecx
  101e5c:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101e61:	89 c8                	mov    %ecx,%eax
  101e63:	f7 e2                	mul    %edx
  101e65:	c1 ea 05             	shr    $0x5,%edx
  101e68:	89 d0                	mov    %edx,%eax
  101e6a:	c1 e0 02             	shl    $0x2,%eax
  101e6d:	01 d0                	add    %edx,%eax
  101e6f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  101e76:	01 d0                	add    %edx,%eax
  101e78:	c1 e0 02             	shl    $0x2,%eax
  101e7b:	29 c1                	sub    %eax,%ecx
  101e7d:	89 ca                	mov    %ecx,%edx
  101e7f:	89 15 2c df 11 00    	mov    %edx,0x11df2c
		if (ticks == 0)
  101e85:	a1 2c df 11 00       	mov    0x11df2c,%eax
  101e8a:	85 c0                	test   %eax,%eax
  101e8c:	0f 85 a4 03 00 00    	jne    102236 <loop+0x1d8>
			print_ticks();
  101e92:	e8 13 fa ff ff       	call   1018aa <print_ticks>
        break;
  101e97:	e9 9a 03 00 00       	jmp    102236 <loop+0x1d8>
        c = cons_getc();
  101e9c:	e8 9c f7 ff ff       	call   10163d <cons_getc>
  101ea1:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101ea4:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101ea8:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101eac:	89 54 24 08          	mov    %edx,0x8(%esp)
  101eb0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101eb4:	c7 04 24 15 6e 10 00 	movl   $0x106e15,(%esp)
  101ebb:	e8 ce e3 ff ff       	call   10028e <cprintf>
        break;
  101ec0:	e9 78 03 00 00       	jmp    10223d <loop+0x1df>
        c = cons_getc();
  101ec5:	e8 73 f7 ff ff       	call   10163d <cons_getc>
  101eca:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101ecd:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101ed1:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101ed5:	89 54 24 08          	mov    %edx,0x8(%esp)
  101ed9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101edd:	c7 04 24 27 6e 10 00 	movl   $0x106e27,(%esp)
  101ee4:	e8 a5 e3 ff ff       	call   10028e <cprintf>
		switch (c) {
  101ee9:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101eed:	83 f8 30             	cmp    $0x30,%eax
  101ef0:	74 0e                	je     101f00 <trap_dispatch+0x11d>
  101ef2:	83 f8 33             	cmp    $0x33,%eax
  101ef5:	0f 84 29 01 00 00    	je     102024 <trap_dispatch+0x241>
        break;
  101efb:	e9 3d 03 00 00       	jmp    10223d <loop+0x1df>
				if (!trap_in_kernel(tf)) {
  101f00:	8b 45 08             	mov    0x8(%ebp),%eax
  101f03:	89 04 24             	mov    %eax,(%esp)
  101f06:	e8 58 fc ff ff       	call   101b63 <trap_in_kernel>
  101f0b:	85 c0                	test   %eax,%eax
  101f0d:	0f 85 b9 01 00 00    	jne    1020cc <loop+0x6e>
					tf->tf_cs = KERNEL_CS;
  101f13:	8b 45 08             	mov    0x8(%ebp),%eax
  101f16:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
					tf->tf_ds = tf->tf_es = tf->tf_gs = tf->tf_fs = KERNEL_DS;
  101f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  101f1f:	66 c7 40 24 10 00    	movw   $0x10,0x24(%eax)
  101f25:	8b 45 08             	mov    0x8(%ebp),%eax
  101f28:	0f b7 50 24          	movzwl 0x24(%eax),%edx
  101f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  101f2f:	66 89 50 20          	mov    %dx,0x20(%eax)
  101f33:	8b 45 08             	mov    0x8(%ebp),%eax
  101f36:	0f b7 50 20          	movzwl 0x20(%eax),%edx
  101f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  101f3d:	66 89 50 28          	mov    %dx,0x28(%eax)
  101f41:	8b 45 08             	mov    0x8(%ebp),%eax
  101f44:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101f48:	8b 45 08             	mov    0x8(%ebp),%eax
  101f4b:	66 89 50 2c          	mov    %dx,0x2c(%eax)
					tf->tf_eflags &= ~FL_IOPL_MASK;
  101f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  101f52:	8b 40 40             	mov    0x40(%eax),%eax
  101f55:	25 ff cf ff ff       	and    $0xffffcfff,%eax
  101f5a:	89 c2                	mov    %eax,%edx
  101f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  101f5f:	89 50 40             	mov    %edx,0x40(%eax)
					uintptr_t user_stack_ptr = (uintptr_t)tf->tf_esp;
  101f62:	8b 45 08             	mov    0x8(%ebp),%eax
  101f65:	8b 40 44             	mov    0x44(%eax),%eax
  101f68:	89 45 e0             	mov    %eax,-0x20(%ebp)
					tf->tf_esp = *((uint32_t *) user_stack_ptr);
  101f6b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101f6e:	8b 10                	mov    (%eax),%edx
  101f70:	8b 45 08             	mov    0x8(%ebp),%eax
  101f73:	89 50 44             	mov    %edx,0x44(%eax)
					tf->tf_ss = *((uint16_t *) (user_stack_ptr + 4));
  101f76:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101f79:	83 c0 04             	add    $0x4,%eax
  101f7c:	0f b7 10             	movzwl (%eax),%edx
  101f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  101f82:	66 89 50 48          	mov    %dx,0x48(%eax)
					tf->tf_padding0 = *((uint16_t *) (user_stack_ptr + 6));
  101f86:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101f89:	83 c0 06             	add    $0x6,%eax
  101f8c:	0f b7 10             	movzwl (%eax),%edx
  101f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  101f92:	66 89 50 22          	mov    %dx,0x22(%eax)
					user_stack_ptr -= (uintptr_t) (sizeof(struct trapframe) - 8);
  101f96:	83 6d e0 44          	subl   $0x44,-0x20(%ebp)
					*((struct trapframe *) user_stack_ptr) = *tf;
  101f9a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101f9d:	8b 55 08             	mov    0x8(%ebp),%edx
  101fa0:	bb 4c 00 00 00       	mov    $0x4c,%ebx
  101fa5:	89 c1                	mov    %eax,%ecx
  101fa7:	83 e1 01             	and    $0x1,%ecx
  101faa:	85 c9                	test   %ecx,%ecx
  101fac:	74 0c                	je     101fba <trap_dispatch+0x1d7>
  101fae:	0f b6 0a             	movzbl (%edx),%ecx
  101fb1:	88 08                	mov    %cl,(%eax)
  101fb3:	8d 40 01             	lea    0x1(%eax),%eax
  101fb6:	8d 52 01             	lea    0x1(%edx),%edx
  101fb9:	4b                   	dec    %ebx
  101fba:	89 c1                	mov    %eax,%ecx
  101fbc:	83 e1 02             	and    $0x2,%ecx
  101fbf:	85 c9                	test   %ecx,%ecx
  101fc1:	74 0f                	je     101fd2 <trap_dispatch+0x1ef>
  101fc3:	0f b7 0a             	movzwl (%edx),%ecx
  101fc6:	66 89 08             	mov    %cx,(%eax)
  101fc9:	8d 40 02             	lea    0x2(%eax),%eax
  101fcc:	8d 52 02             	lea    0x2(%edx),%edx
  101fcf:	83 eb 02             	sub    $0x2,%ebx
  101fd2:	89 df                	mov    %ebx,%edi
  101fd4:	83 e7 fc             	and    $0xfffffffc,%edi
  101fd7:	b9 00 00 00 00       	mov    $0x0,%ecx
  101fdc:	8b 34 0a             	mov    (%edx,%ecx,1),%esi
  101fdf:	89 34 08             	mov    %esi,(%eax,%ecx,1)
  101fe2:	83 c1 04             	add    $0x4,%ecx
  101fe5:	39 f9                	cmp    %edi,%ecx
  101fe7:	72 f3                	jb     101fdc <trap_dispatch+0x1f9>
  101fe9:	01 c8                	add    %ecx,%eax
  101feb:	01 ca                	add    %ecx,%edx
  101fed:	b9 00 00 00 00       	mov    $0x0,%ecx
  101ff2:	89 de                	mov    %ebx,%esi
  101ff4:	83 e6 02             	and    $0x2,%esi
  101ff7:	85 f6                	test   %esi,%esi
  101ff9:	74 0b                	je     102006 <trap_dispatch+0x223>
  101ffb:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
  101fff:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
  102003:	83 c1 02             	add    $0x2,%ecx
  102006:	83 e3 01             	and    $0x1,%ebx
  102009:	85 db                	test   %ebx,%ebx
  10200b:	74 07                	je     102014 <trap_dispatch+0x231>
  10200d:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
  102011:	88 14 08             	mov    %dl,(%eax,%ecx,1)
						:"a" ((uint32_t) tf),
  102014:	8b 45 08             	mov    0x8(%ebp),%eax
					__asm__ __volatile__ (
  102017:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10201a:	89 d3                	mov    %edx,%ebx
  10201c:	89 58 fc             	mov    %ebx,-0x4(%eax)
				break;
  10201f:	e9 a8 00 00 00       	jmp    1020cc <loop+0x6e>
				if (trap_in_kernel(tf)) {
  102024:	8b 45 08             	mov    0x8(%ebp),%eax
  102027:	89 04 24             	mov    %eax,(%esp)
  10202a:	e8 34 fb ff ff       	call   101b63 <trap_in_kernel>
  10202f:	85 c0                	test   %eax,%eax
  102031:	0f 84 9b 00 00 00    	je     1020d2 <loop+0x74>
						:"a" ((uint32_t)(&tf->tf_esp)),
  102037:	8b 45 08             	mov    0x8(%ebp),%eax
  10203a:	83 c0 44             	add    $0x44,%eax
						 "d" ((uint32_t)(tf)),
  10203d:	8b 55 08             	mov    0x8(%ebp),%edx
					__asm__ __volatile__ (
  102040:	56                   	push   %esi
  102041:	57                   	push   %edi
  102042:	53                   	push   %ebx
  102043:	83 6a fc 08          	subl   $0x8,-0x4(%edx)
  102047:	89 e6                	mov    %esp,%esi
  102049:	89 c1                	mov    %eax,%ecx
  10204b:	29 f1                	sub    %esi,%ecx
  10204d:	41                   	inc    %ecx
  10204e:	89 e7                	mov    %esp,%edi
  102050:	83 ef 08             	sub    $0x8,%edi
  102053:	fc                   	cld    
  102054:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102056:	83 ec 08             	sub    $0x8,%esp
  102059:	83 ed 08             	sub    $0x8,%ebp
  10205c:	89 eb                	mov    %ebp,%ebx

0010205e <loop>:
  10205e:	83 2b 08             	subl   $0x8,(%ebx)
  102061:	8b 1b                	mov    (%ebx),%ebx
  102063:	39 d8                	cmp    %ebx,%eax
  102065:	7f f7                	jg     10205e <loop>
  102067:	89 40 f8             	mov    %eax,-0x8(%eax)
  10206a:	c7 40 fc 23 00 00 00 	movl   $0x23,-0x4(%eax)
  102071:	5b                   	pop    %ebx
  102072:	5f                   	pop    %edi
  102073:	5e                   	pop    %esi
					correct_tf->tf_cs = USER_CS;
  102074:	a1 80 de 11 00       	mov    0x11de80,%eax
  102079:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
					correct_tf->tf_ds = tf->tf_es = tf->tf_gs = tf->tf_fs = USER_DS;
  10207f:	8b 45 08             	mov    0x8(%ebp),%eax
  102082:	66 c7 40 24 23 00    	movw   $0x23,0x24(%eax)
  102088:	8b 45 08             	mov    0x8(%ebp),%eax
  10208b:	0f b7 50 24          	movzwl 0x24(%eax),%edx
  10208f:	8b 45 08             	mov    0x8(%ebp),%eax
  102092:	66 89 50 20          	mov    %dx,0x20(%eax)
  102096:	8b 45 08             	mov    0x8(%ebp),%eax
  102099:	0f b7 50 20          	movzwl 0x20(%eax),%edx
  10209d:	8b 45 08             	mov    0x8(%ebp),%eax
  1020a0:	66 89 50 28          	mov    %dx,0x28(%eax)
  1020a4:	a1 80 de 11 00       	mov    0x11de80,%eax
  1020a9:	8b 55 08             	mov    0x8(%ebp),%edx
  1020ac:	0f b7 52 28          	movzwl 0x28(%edx),%edx
  1020b0:	66 89 50 2c          	mov    %dx,0x2c(%eax)
					correct_tf->tf_eflags |= FL_IOPL_MASK;
  1020b4:	a1 80 de 11 00       	mov    0x11de80,%eax
  1020b9:	8b 50 40             	mov    0x40(%eax),%edx
  1020bc:	a1 80 de 11 00       	mov    0x11de80,%eax
  1020c1:	81 ca 00 30 00 00    	or     $0x3000,%edx
  1020c7:	89 50 40             	mov    %edx,0x40(%eax)
				break;
  1020ca:	eb 06                	jmp    1020d2 <loop+0x74>
				break;
  1020cc:	90                   	nop
  1020cd:	e9 6b 01 00 00       	jmp    10223d <loop+0x1df>
				break;
  1020d2:	90                   	nop
        break;
  1020d3:	e9 65 01 00 00       	jmp    10223d <loop+0x1df>
		if ((tf->tf_cs & 3) == 0) {
  1020d8:	8b 45 08             	mov    0x8(%ebp),%eax
  1020db:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  1020df:	83 e0 03             	and    $0x3,%eax
  1020e2:	85 c0                	test   %eax,%eax
  1020e4:	0f 85 4f 01 00 00    	jne    102239 <loop+0x1db>
			tf->tf_cs = USER_CS;
  1020ea:	8b 45 08             	mov    0x8(%ebp),%eax
  1020ed:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
			tf->tf_ss = tf->tf_ds = tf->tf_es = tf->tf_gs = tf->tf_fs = USER_DS;
  1020f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1020f6:	66 c7 40 24 23 00    	movw   $0x23,0x24(%eax)
  1020fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1020ff:	0f b7 50 24          	movzwl 0x24(%eax),%edx
  102103:	8b 45 08             	mov    0x8(%ebp),%eax
  102106:	66 89 50 20          	mov    %dx,0x20(%eax)
  10210a:	8b 45 08             	mov    0x8(%ebp),%eax
  10210d:	0f b7 50 20          	movzwl 0x20(%eax),%edx
  102111:	8b 45 08             	mov    0x8(%ebp),%eax
  102114:	66 89 50 28          	mov    %dx,0x28(%eax)
  102118:	8b 45 08             	mov    0x8(%ebp),%eax
  10211b:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  10211f:	8b 45 08             	mov    0x8(%ebp),%eax
  102122:	66 89 50 2c          	mov    %dx,0x2c(%eax)
  102126:	8b 45 08             	mov    0x8(%ebp),%eax
  102129:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
  10212d:	8b 45 08             	mov    0x8(%ebp),%eax
  102130:	66 89 50 48          	mov    %dx,0x48(%eax)
			tf->tf_esp += 4;
  102134:	8b 45 08             	mov    0x8(%ebp),%eax
  102137:	8b 40 44             	mov    0x44(%eax),%eax
  10213a:	8d 50 04             	lea    0x4(%eax),%edx
  10213d:	8b 45 08             	mov    0x8(%ebp),%eax
  102140:	89 50 44             	mov    %edx,0x44(%eax)
			tf->tf_eflags |= FL_IOPL_MASK;
  102143:	8b 45 08             	mov    0x8(%ebp),%eax
  102146:	8b 40 40             	mov    0x40(%eax),%eax
  102149:	0d 00 30 00 00       	or     $0x3000,%eax
  10214e:	89 c2                	mov    %eax,%edx
  102150:	8b 45 08             	mov    0x8(%ebp),%eax
  102153:	89 50 40             	mov    %edx,0x40(%eax)
		break;
  102156:	e9 de 00 00 00       	jmp    102239 <loop+0x1db>
		if ((tf->tf_cs & 3) != 0) {
  10215b:	8b 45 08             	mov    0x8(%ebp),%eax
  10215e:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  102162:	83 e0 03             	and    $0x3,%eax
  102165:	85 c0                	test   %eax,%eax
  102167:	0f 84 cf 00 00 00    	je     10223c <loop+0x1de>
			tf->tf_cs = KERNEL_CS;
  10216d:	8b 45 08             	mov    0x8(%ebp),%eax
  102170:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
			tf->tf_ss = tf->tf_ds = tf->tf_es = tf->tf_gs = tf->tf_fs = KERNEL_DS;
  102176:	8b 45 08             	mov    0x8(%ebp),%eax
  102179:	66 c7 40 24 10 00    	movw   $0x10,0x24(%eax)
  10217f:	8b 45 08             	mov    0x8(%ebp),%eax
  102182:	0f b7 50 24          	movzwl 0x24(%eax),%edx
  102186:	8b 45 08             	mov    0x8(%ebp),%eax
  102189:	66 89 50 20          	mov    %dx,0x20(%eax)
  10218d:	8b 45 08             	mov    0x8(%ebp),%eax
  102190:	0f b7 50 20          	movzwl 0x20(%eax),%edx
  102194:	8b 45 08             	mov    0x8(%ebp),%eax
  102197:	66 89 50 28          	mov    %dx,0x28(%eax)
  10219b:	8b 45 08             	mov    0x8(%ebp),%eax
  10219e:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  1021a2:	8b 45 08             	mov    0x8(%ebp),%eax
  1021a5:	66 89 50 2c          	mov    %dx,0x2c(%eax)
  1021a9:	8b 45 08             	mov    0x8(%ebp),%eax
  1021ac:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
  1021b0:	8b 45 08             	mov    0x8(%ebp),%eax
  1021b3:	66 89 50 48          	mov    %dx,0x48(%eax)
			tf->tf_eflags &= ~FL_IOPL_MASK;
  1021b7:	8b 45 08             	mov    0x8(%ebp),%eax
  1021ba:	8b 40 40             	mov    0x40(%eax),%eax
  1021bd:	25 ff cf ff ff       	and    $0xffffcfff,%eax
  1021c2:	89 c2                	mov    %eax,%edx
  1021c4:	8b 45 08             	mov    0x8(%ebp),%eax
  1021c7:	89 50 40             	mov    %edx,0x40(%eax)
			break;
  1021ca:	eb 70                	jmp    10223c <loop+0x1de>
	case T_GPFLT:
		cprintf("GP Fault!!!\n");
  1021cc:	c7 04 24 36 6e 10 00 	movl   $0x106e36,(%esp)
  1021d3:	e8 b6 e0 ff ff       	call   10028e <cprintf>
		print_trapframe(tf);
  1021d8:	8b 45 08             	mov    0x8(%ebp),%eax
  1021db:	89 04 24             	mov    %eax,(%esp)
  1021de:	e8 95 f9 ff ff       	call   101b78 <print_trapframe>
		break;
  1021e3:	eb 58                	jmp    10223d <loop+0x1df>
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  1021e5:	8b 45 08             	mov    0x8(%ebp),%eax
  1021e8:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  1021ec:	83 e0 03             	and    $0x3,%eax
  1021ef:	85 c0                	test   %eax,%eax
  1021f1:	75 27                	jne    10221a <loop+0x1bc>
            print_trapframe(tf);
  1021f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1021f6:	89 04 24             	mov    %eax,(%esp)
  1021f9:	e8 7a f9 ff ff       	call   101b78 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  1021fe:	c7 44 24 08 43 6e 10 	movl   $0x106e43,0x8(%esp)
  102205:	00 
  102206:	c7 44 24 04 36 01 00 	movl   $0x136,0x4(%esp)
  10220d:	00 
  10220e:	c7 04 24 5f 6e 10 00 	movl   $0x106e5f,(%esp)
  102215:	e8 cc e1 ff ff       	call   1003e6 <__panic>
        }
		else 
			panic("unexpected trap \n");
  10221a:	c7 44 24 08 70 6e 10 	movl   $0x106e70,0x8(%esp)
  102221:	00 
  102222:	c7 44 24 04 39 01 00 	movl   $0x139,0x4(%esp)
  102229:	00 
  10222a:	c7 04 24 5f 6e 10 00 	movl   $0x106e5f,(%esp)
  102231:	e8 b0 e1 ff ff       	call   1003e6 <__panic>
        break;
  102236:	90                   	nop
  102237:	eb 04                	jmp    10223d <loop+0x1df>
		break;
  102239:	90                   	nop
  10223a:	eb 01                	jmp    10223d <loop+0x1df>
			break;
  10223c:	90                   	nop
    }
}
  10223d:	90                   	nop
  10223e:	83 c4 2c             	add    $0x2c,%esp
  102241:	5b                   	pop    %ebx
  102242:	5e                   	pop    %esi
  102243:	5f                   	pop    %edi
  102244:	5d                   	pop    %ebp
  102245:	c3                   	ret    

00102246 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  102246:	55                   	push   %ebp
  102247:	89 e5                	mov    %esp,%ebp
  102249:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  10224c:	8b 45 08             	mov    0x8(%ebp),%eax
  10224f:	89 04 24             	mov    %eax,(%esp)
  102252:	e8 8c fb ff ff       	call   101de3 <trap_dispatch>
}
  102257:	90                   	nop
  102258:	c9                   	leave  
  102259:	c3                   	ret    

0010225a <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  10225a:	6a 00                	push   $0x0
  pushl $0
  10225c:	6a 00                	push   $0x0
  jmp __alltraps
  10225e:	e9 69 0a 00 00       	jmp    102ccc <__alltraps>

00102263 <vector1>:
.globl vector1
vector1:
  pushl $0
  102263:	6a 00                	push   $0x0
  pushl $1
  102265:	6a 01                	push   $0x1
  jmp __alltraps
  102267:	e9 60 0a 00 00       	jmp    102ccc <__alltraps>

0010226c <vector2>:
.globl vector2
vector2:
  pushl $0
  10226c:	6a 00                	push   $0x0
  pushl $2
  10226e:	6a 02                	push   $0x2
  jmp __alltraps
  102270:	e9 57 0a 00 00       	jmp    102ccc <__alltraps>

00102275 <vector3>:
.globl vector3
vector3:
  pushl $0
  102275:	6a 00                	push   $0x0
  pushl $3
  102277:	6a 03                	push   $0x3
  jmp __alltraps
  102279:	e9 4e 0a 00 00       	jmp    102ccc <__alltraps>

0010227e <vector4>:
.globl vector4
vector4:
  pushl $0
  10227e:	6a 00                	push   $0x0
  pushl $4
  102280:	6a 04                	push   $0x4
  jmp __alltraps
  102282:	e9 45 0a 00 00       	jmp    102ccc <__alltraps>

00102287 <vector5>:
.globl vector5
vector5:
  pushl $0
  102287:	6a 00                	push   $0x0
  pushl $5
  102289:	6a 05                	push   $0x5
  jmp __alltraps
  10228b:	e9 3c 0a 00 00       	jmp    102ccc <__alltraps>

00102290 <vector6>:
.globl vector6
vector6:
  pushl $0
  102290:	6a 00                	push   $0x0
  pushl $6
  102292:	6a 06                	push   $0x6
  jmp __alltraps
  102294:	e9 33 0a 00 00       	jmp    102ccc <__alltraps>

00102299 <vector7>:
.globl vector7
vector7:
  pushl $0
  102299:	6a 00                	push   $0x0
  pushl $7
  10229b:	6a 07                	push   $0x7
  jmp __alltraps
  10229d:	e9 2a 0a 00 00       	jmp    102ccc <__alltraps>

001022a2 <vector8>:
.globl vector8
vector8:
  pushl $8
  1022a2:	6a 08                	push   $0x8
  jmp __alltraps
  1022a4:	e9 23 0a 00 00       	jmp    102ccc <__alltraps>

001022a9 <vector9>:
.globl vector9
vector9:
  pushl $0
  1022a9:	6a 00                	push   $0x0
  pushl $9
  1022ab:	6a 09                	push   $0x9
  jmp __alltraps
  1022ad:	e9 1a 0a 00 00       	jmp    102ccc <__alltraps>

001022b2 <vector10>:
.globl vector10
vector10:
  pushl $10
  1022b2:	6a 0a                	push   $0xa
  jmp __alltraps
  1022b4:	e9 13 0a 00 00       	jmp    102ccc <__alltraps>

001022b9 <vector11>:
.globl vector11
vector11:
  pushl $11
  1022b9:	6a 0b                	push   $0xb
  jmp __alltraps
  1022bb:	e9 0c 0a 00 00       	jmp    102ccc <__alltraps>

001022c0 <vector12>:
.globl vector12
vector12:
  pushl $12
  1022c0:	6a 0c                	push   $0xc
  jmp __alltraps
  1022c2:	e9 05 0a 00 00       	jmp    102ccc <__alltraps>

001022c7 <vector13>:
.globl vector13
vector13:
  pushl $13
  1022c7:	6a 0d                	push   $0xd
  jmp __alltraps
  1022c9:	e9 fe 09 00 00       	jmp    102ccc <__alltraps>

001022ce <vector14>:
.globl vector14
vector14:
  pushl $14
  1022ce:	6a 0e                	push   $0xe
  jmp __alltraps
  1022d0:	e9 f7 09 00 00       	jmp    102ccc <__alltraps>

001022d5 <vector15>:
.globl vector15
vector15:
  pushl $0
  1022d5:	6a 00                	push   $0x0
  pushl $15
  1022d7:	6a 0f                	push   $0xf
  jmp __alltraps
  1022d9:	e9 ee 09 00 00       	jmp    102ccc <__alltraps>

001022de <vector16>:
.globl vector16
vector16:
  pushl $0
  1022de:	6a 00                	push   $0x0
  pushl $16
  1022e0:	6a 10                	push   $0x10
  jmp __alltraps
  1022e2:	e9 e5 09 00 00       	jmp    102ccc <__alltraps>

001022e7 <vector17>:
.globl vector17
vector17:
  pushl $17
  1022e7:	6a 11                	push   $0x11
  jmp __alltraps
  1022e9:	e9 de 09 00 00       	jmp    102ccc <__alltraps>

001022ee <vector18>:
.globl vector18
vector18:
  pushl $0
  1022ee:	6a 00                	push   $0x0
  pushl $18
  1022f0:	6a 12                	push   $0x12
  jmp __alltraps
  1022f2:	e9 d5 09 00 00       	jmp    102ccc <__alltraps>

001022f7 <vector19>:
.globl vector19
vector19:
  pushl $0
  1022f7:	6a 00                	push   $0x0
  pushl $19
  1022f9:	6a 13                	push   $0x13
  jmp __alltraps
  1022fb:	e9 cc 09 00 00       	jmp    102ccc <__alltraps>

00102300 <vector20>:
.globl vector20
vector20:
  pushl $0
  102300:	6a 00                	push   $0x0
  pushl $20
  102302:	6a 14                	push   $0x14
  jmp __alltraps
  102304:	e9 c3 09 00 00       	jmp    102ccc <__alltraps>

00102309 <vector21>:
.globl vector21
vector21:
  pushl $0
  102309:	6a 00                	push   $0x0
  pushl $21
  10230b:	6a 15                	push   $0x15
  jmp __alltraps
  10230d:	e9 ba 09 00 00       	jmp    102ccc <__alltraps>

00102312 <vector22>:
.globl vector22
vector22:
  pushl $0
  102312:	6a 00                	push   $0x0
  pushl $22
  102314:	6a 16                	push   $0x16
  jmp __alltraps
  102316:	e9 b1 09 00 00       	jmp    102ccc <__alltraps>

0010231b <vector23>:
.globl vector23
vector23:
  pushl $0
  10231b:	6a 00                	push   $0x0
  pushl $23
  10231d:	6a 17                	push   $0x17
  jmp __alltraps
  10231f:	e9 a8 09 00 00       	jmp    102ccc <__alltraps>

00102324 <vector24>:
.globl vector24
vector24:
  pushl $0
  102324:	6a 00                	push   $0x0
  pushl $24
  102326:	6a 18                	push   $0x18
  jmp __alltraps
  102328:	e9 9f 09 00 00       	jmp    102ccc <__alltraps>

0010232d <vector25>:
.globl vector25
vector25:
  pushl $0
  10232d:	6a 00                	push   $0x0
  pushl $25
  10232f:	6a 19                	push   $0x19
  jmp __alltraps
  102331:	e9 96 09 00 00       	jmp    102ccc <__alltraps>

00102336 <vector26>:
.globl vector26
vector26:
  pushl $0
  102336:	6a 00                	push   $0x0
  pushl $26
  102338:	6a 1a                	push   $0x1a
  jmp __alltraps
  10233a:	e9 8d 09 00 00       	jmp    102ccc <__alltraps>

0010233f <vector27>:
.globl vector27
vector27:
  pushl $0
  10233f:	6a 00                	push   $0x0
  pushl $27
  102341:	6a 1b                	push   $0x1b
  jmp __alltraps
  102343:	e9 84 09 00 00       	jmp    102ccc <__alltraps>

00102348 <vector28>:
.globl vector28
vector28:
  pushl $0
  102348:	6a 00                	push   $0x0
  pushl $28
  10234a:	6a 1c                	push   $0x1c
  jmp __alltraps
  10234c:	e9 7b 09 00 00       	jmp    102ccc <__alltraps>

00102351 <vector29>:
.globl vector29
vector29:
  pushl $0
  102351:	6a 00                	push   $0x0
  pushl $29
  102353:	6a 1d                	push   $0x1d
  jmp __alltraps
  102355:	e9 72 09 00 00       	jmp    102ccc <__alltraps>

0010235a <vector30>:
.globl vector30
vector30:
  pushl $0
  10235a:	6a 00                	push   $0x0
  pushl $30
  10235c:	6a 1e                	push   $0x1e
  jmp __alltraps
  10235e:	e9 69 09 00 00       	jmp    102ccc <__alltraps>

00102363 <vector31>:
.globl vector31
vector31:
  pushl $0
  102363:	6a 00                	push   $0x0
  pushl $31
  102365:	6a 1f                	push   $0x1f
  jmp __alltraps
  102367:	e9 60 09 00 00       	jmp    102ccc <__alltraps>

0010236c <vector32>:
.globl vector32
vector32:
  pushl $0
  10236c:	6a 00                	push   $0x0
  pushl $32
  10236e:	6a 20                	push   $0x20
  jmp __alltraps
  102370:	e9 57 09 00 00       	jmp    102ccc <__alltraps>

00102375 <vector33>:
.globl vector33
vector33:
  pushl $0
  102375:	6a 00                	push   $0x0
  pushl $33
  102377:	6a 21                	push   $0x21
  jmp __alltraps
  102379:	e9 4e 09 00 00       	jmp    102ccc <__alltraps>

0010237e <vector34>:
.globl vector34
vector34:
  pushl $0
  10237e:	6a 00                	push   $0x0
  pushl $34
  102380:	6a 22                	push   $0x22
  jmp __alltraps
  102382:	e9 45 09 00 00       	jmp    102ccc <__alltraps>

00102387 <vector35>:
.globl vector35
vector35:
  pushl $0
  102387:	6a 00                	push   $0x0
  pushl $35
  102389:	6a 23                	push   $0x23
  jmp __alltraps
  10238b:	e9 3c 09 00 00       	jmp    102ccc <__alltraps>

00102390 <vector36>:
.globl vector36
vector36:
  pushl $0
  102390:	6a 00                	push   $0x0
  pushl $36
  102392:	6a 24                	push   $0x24
  jmp __alltraps
  102394:	e9 33 09 00 00       	jmp    102ccc <__alltraps>

00102399 <vector37>:
.globl vector37
vector37:
  pushl $0
  102399:	6a 00                	push   $0x0
  pushl $37
  10239b:	6a 25                	push   $0x25
  jmp __alltraps
  10239d:	e9 2a 09 00 00       	jmp    102ccc <__alltraps>

001023a2 <vector38>:
.globl vector38
vector38:
  pushl $0
  1023a2:	6a 00                	push   $0x0
  pushl $38
  1023a4:	6a 26                	push   $0x26
  jmp __alltraps
  1023a6:	e9 21 09 00 00       	jmp    102ccc <__alltraps>

001023ab <vector39>:
.globl vector39
vector39:
  pushl $0
  1023ab:	6a 00                	push   $0x0
  pushl $39
  1023ad:	6a 27                	push   $0x27
  jmp __alltraps
  1023af:	e9 18 09 00 00       	jmp    102ccc <__alltraps>

001023b4 <vector40>:
.globl vector40
vector40:
  pushl $0
  1023b4:	6a 00                	push   $0x0
  pushl $40
  1023b6:	6a 28                	push   $0x28
  jmp __alltraps
  1023b8:	e9 0f 09 00 00       	jmp    102ccc <__alltraps>

001023bd <vector41>:
.globl vector41
vector41:
  pushl $0
  1023bd:	6a 00                	push   $0x0
  pushl $41
  1023bf:	6a 29                	push   $0x29
  jmp __alltraps
  1023c1:	e9 06 09 00 00       	jmp    102ccc <__alltraps>

001023c6 <vector42>:
.globl vector42
vector42:
  pushl $0
  1023c6:	6a 00                	push   $0x0
  pushl $42
  1023c8:	6a 2a                	push   $0x2a
  jmp __alltraps
  1023ca:	e9 fd 08 00 00       	jmp    102ccc <__alltraps>

001023cf <vector43>:
.globl vector43
vector43:
  pushl $0
  1023cf:	6a 00                	push   $0x0
  pushl $43
  1023d1:	6a 2b                	push   $0x2b
  jmp __alltraps
  1023d3:	e9 f4 08 00 00       	jmp    102ccc <__alltraps>

001023d8 <vector44>:
.globl vector44
vector44:
  pushl $0
  1023d8:	6a 00                	push   $0x0
  pushl $44
  1023da:	6a 2c                	push   $0x2c
  jmp __alltraps
  1023dc:	e9 eb 08 00 00       	jmp    102ccc <__alltraps>

001023e1 <vector45>:
.globl vector45
vector45:
  pushl $0
  1023e1:	6a 00                	push   $0x0
  pushl $45
  1023e3:	6a 2d                	push   $0x2d
  jmp __alltraps
  1023e5:	e9 e2 08 00 00       	jmp    102ccc <__alltraps>

001023ea <vector46>:
.globl vector46
vector46:
  pushl $0
  1023ea:	6a 00                	push   $0x0
  pushl $46
  1023ec:	6a 2e                	push   $0x2e
  jmp __alltraps
  1023ee:	e9 d9 08 00 00       	jmp    102ccc <__alltraps>

001023f3 <vector47>:
.globl vector47
vector47:
  pushl $0
  1023f3:	6a 00                	push   $0x0
  pushl $47
  1023f5:	6a 2f                	push   $0x2f
  jmp __alltraps
  1023f7:	e9 d0 08 00 00       	jmp    102ccc <__alltraps>

001023fc <vector48>:
.globl vector48
vector48:
  pushl $0
  1023fc:	6a 00                	push   $0x0
  pushl $48
  1023fe:	6a 30                	push   $0x30
  jmp __alltraps
  102400:	e9 c7 08 00 00       	jmp    102ccc <__alltraps>

00102405 <vector49>:
.globl vector49
vector49:
  pushl $0
  102405:	6a 00                	push   $0x0
  pushl $49
  102407:	6a 31                	push   $0x31
  jmp __alltraps
  102409:	e9 be 08 00 00       	jmp    102ccc <__alltraps>

0010240e <vector50>:
.globl vector50
vector50:
  pushl $0
  10240e:	6a 00                	push   $0x0
  pushl $50
  102410:	6a 32                	push   $0x32
  jmp __alltraps
  102412:	e9 b5 08 00 00       	jmp    102ccc <__alltraps>

00102417 <vector51>:
.globl vector51
vector51:
  pushl $0
  102417:	6a 00                	push   $0x0
  pushl $51
  102419:	6a 33                	push   $0x33
  jmp __alltraps
  10241b:	e9 ac 08 00 00       	jmp    102ccc <__alltraps>

00102420 <vector52>:
.globl vector52
vector52:
  pushl $0
  102420:	6a 00                	push   $0x0
  pushl $52
  102422:	6a 34                	push   $0x34
  jmp __alltraps
  102424:	e9 a3 08 00 00       	jmp    102ccc <__alltraps>

00102429 <vector53>:
.globl vector53
vector53:
  pushl $0
  102429:	6a 00                	push   $0x0
  pushl $53
  10242b:	6a 35                	push   $0x35
  jmp __alltraps
  10242d:	e9 9a 08 00 00       	jmp    102ccc <__alltraps>

00102432 <vector54>:
.globl vector54
vector54:
  pushl $0
  102432:	6a 00                	push   $0x0
  pushl $54
  102434:	6a 36                	push   $0x36
  jmp __alltraps
  102436:	e9 91 08 00 00       	jmp    102ccc <__alltraps>

0010243b <vector55>:
.globl vector55
vector55:
  pushl $0
  10243b:	6a 00                	push   $0x0
  pushl $55
  10243d:	6a 37                	push   $0x37
  jmp __alltraps
  10243f:	e9 88 08 00 00       	jmp    102ccc <__alltraps>

00102444 <vector56>:
.globl vector56
vector56:
  pushl $0
  102444:	6a 00                	push   $0x0
  pushl $56
  102446:	6a 38                	push   $0x38
  jmp __alltraps
  102448:	e9 7f 08 00 00       	jmp    102ccc <__alltraps>

0010244d <vector57>:
.globl vector57
vector57:
  pushl $0
  10244d:	6a 00                	push   $0x0
  pushl $57
  10244f:	6a 39                	push   $0x39
  jmp __alltraps
  102451:	e9 76 08 00 00       	jmp    102ccc <__alltraps>

00102456 <vector58>:
.globl vector58
vector58:
  pushl $0
  102456:	6a 00                	push   $0x0
  pushl $58
  102458:	6a 3a                	push   $0x3a
  jmp __alltraps
  10245a:	e9 6d 08 00 00       	jmp    102ccc <__alltraps>

0010245f <vector59>:
.globl vector59
vector59:
  pushl $0
  10245f:	6a 00                	push   $0x0
  pushl $59
  102461:	6a 3b                	push   $0x3b
  jmp __alltraps
  102463:	e9 64 08 00 00       	jmp    102ccc <__alltraps>

00102468 <vector60>:
.globl vector60
vector60:
  pushl $0
  102468:	6a 00                	push   $0x0
  pushl $60
  10246a:	6a 3c                	push   $0x3c
  jmp __alltraps
  10246c:	e9 5b 08 00 00       	jmp    102ccc <__alltraps>

00102471 <vector61>:
.globl vector61
vector61:
  pushl $0
  102471:	6a 00                	push   $0x0
  pushl $61
  102473:	6a 3d                	push   $0x3d
  jmp __alltraps
  102475:	e9 52 08 00 00       	jmp    102ccc <__alltraps>

0010247a <vector62>:
.globl vector62
vector62:
  pushl $0
  10247a:	6a 00                	push   $0x0
  pushl $62
  10247c:	6a 3e                	push   $0x3e
  jmp __alltraps
  10247e:	e9 49 08 00 00       	jmp    102ccc <__alltraps>

00102483 <vector63>:
.globl vector63
vector63:
  pushl $0
  102483:	6a 00                	push   $0x0
  pushl $63
  102485:	6a 3f                	push   $0x3f
  jmp __alltraps
  102487:	e9 40 08 00 00       	jmp    102ccc <__alltraps>

0010248c <vector64>:
.globl vector64
vector64:
  pushl $0
  10248c:	6a 00                	push   $0x0
  pushl $64
  10248e:	6a 40                	push   $0x40
  jmp __alltraps
  102490:	e9 37 08 00 00       	jmp    102ccc <__alltraps>

00102495 <vector65>:
.globl vector65
vector65:
  pushl $0
  102495:	6a 00                	push   $0x0
  pushl $65
  102497:	6a 41                	push   $0x41
  jmp __alltraps
  102499:	e9 2e 08 00 00       	jmp    102ccc <__alltraps>

0010249e <vector66>:
.globl vector66
vector66:
  pushl $0
  10249e:	6a 00                	push   $0x0
  pushl $66
  1024a0:	6a 42                	push   $0x42
  jmp __alltraps
  1024a2:	e9 25 08 00 00       	jmp    102ccc <__alltraps>

001024a7 <vector67>:
.globl vector67
vector67:
  pushl $0
  1024a7:	6a 00                	push   $0x0
  pushl $67
  1024a9:	6a 43                	push   $0x43
  jmp __alltraps
  1024ab:	e9 1c 08 00 00       	jmp    102ccc <__alltraps>

001024b0 <vector68>:
.globl vector68
vector68:
  pushl $0
  1024b0:	6a 00                	push   $0x0
  pushl $68
  1024b2:	6a 44                	push   $0x44
  jmp __alltraps
  1024b4:	e9 13 08 00 00       	jmp    102ccc <__alltraps>

001024b9 <vector69>:
.globl vector69
vector69:
  pushl $0
  1024b9:	6a 00                	push   $0x0
  pushl $69
  1024bb:	6a 45                	push   $0x45
  jmp __alltraps
  1024bd:	e9 0a 08 00 00       	jmp    102ccc <__alltraps>

001024c2 <vector70>:
.globl vector70
vector70:
  pushl $0
  1024c2:	6a 00                	push   $0x0
  pushl $70
  1024c4:	6a 46                	push   $0x46
  jmp __alltraps
  1024c6:	e9 01 08 00 00       	jmp    102ccc <__alltraps>

001024cb <vector71>:
.globl vector71
vector71:
  pushl $0
  1024cb:	6a 00                	push   $0x0
  pushl $71
  1024cd:	6a 47                	push   $0x47
  jmp __alltraps
  1024cf:	e9 f8 07 00 00       	jmp    102ccc <__alltraps>

001024d4 <vector72>:
.globl vector72
vector72:
  pushl $0
  1024d4:	6a 00                	push   $0x0
  pushl $72
  1024d6:	6a 48                	push   $0x48
  jmp __alltraps
  1024d8:	e9 ef 07 00 00       	jmp    102ccc <__alltraps>

001024dd <vector73>:
.globl vector73
vector73:
  pushl $0
  1024dd:	6a 00                	push   $0x0
  pushl $73
  1024df:	6a 49                	push   $0x49
  jmp __alltraps
  1024e1:	e9 e6 07 00 00       	jmp    102ccc <__alltraps>

001024e6 <vector74>:
.globl vector74
vector74:
  pushl $0
  1024e6:	6a 00                	push   $0x0
  pushl $74
  1024e8:	6a 4a                	push   $0x4a
  jmp __alltraps
  1024ea:	e9 dd 07 00 00       	jmp    102ccc <__alltraps>

001024ef <vector75>:
.globl vector75
vector75:
  pushl $0
  1024ef:	6a 00                	push   $0x0
  pushl $75
  1024f1:	6a 4b                	push   $0x4b
  jmp __alltraps
  1024f3:	e9 d4 07 00 00       	jmp    102ccc <__alltraps>

001024f8 <vector76>:
.globl vector76
vector76:
  pushl $0
  1024f8:	6a 00                	push   $0x0
  pushl $76
  1024fa:	6a 4c                	push   $0x4c
  jmp __alltraps
  1024fc:	e9 cb 07 00 00       	jmp    102ccc <__alltraps>

00102501 <vector77>:
.globl vector77
vector77:
  pushl $0
  102501:	6a 00                	push   $0x0
  pushl $77
  102503:	6a 4d                	push   $0x4d
  jmp __alltraps
  102505:	e9 c2 07 00 00       	jmp    102ccc <__alltraps>

0010250a <vector78>:
.globl vector78
vector78:
  pushl $0
  10250a:	6a 00                	push   $0x0
  pushl $78
  10250c:	6a 4e                	push   $0x4e
  jmp __alltraps
  10250e:	e9 b9 07 00 00       	jmp    102ccc <__alltraps>

00102513 <vector79>:
.globl vector79
vector79:
  pushl $0
  102513:	6a 00                	push   $0x0
  pushl $79
  102515:	6a 4f                	push   $0x4f
  jmp __alltraps
  102517:	e9 b0 07 00 00       	jmp    102ccc <__alltraps>

0010251c <vector80>:
.globl vector80
vector80:
  pushl $0
  10251c:	6a 00                	push   $0x0
  pushl $80
  10251e:	6a 50                	push   $0x50
  jmp __alltraps
  102520:	e9 a7 07 00 00       	jmp    102ccc <__alltraps>

00102525 <vector81>:
.globl vector81
vector81:
  pushl $0
  102525:	6a 00                	push   $0x0
  pushl $81
  102527:	6a 51                	push   $0x51
  jmp __alltraps
  102529:	e9 9e 07 00 00       	jmp    102ccc <__alltraps>

0010252e <vector82>:
.globl vector82
vector82:
  pushl $0
  10252e:	6a 00                	push   $0x0
  pushl $82
  102530:	6a 52                	push   $0x52
  jmp __alltraps
  102532:	e9 95 07 00 00       	jmp    102ccc <__alltraps>

00102537 <vector83>:
.globl vector83
vector83:
  pushl $0
  102537:	6a 00                	push   $0x0
  pushl $83
  102539:	6a 53                	push   $0x53
  jmp __alltraps
  10253b:	e9 8c 07 00 00       	jmp    102ccc <__alltraps>

00102540 <vector84>:
.globl vector84
vector84:
  pushl $0
  102540:	6a 00                	push   $0x0
  pushl $84
  102542:	6a 54                	push   $0x54
  jmp __alltraps
  102544:	e9 83 07 00 00       	jmp    102ccc <__alltraps>

00102549 <vector85>:
.globl vector85
vector85:
  pushl $0
  102549:	6a 00                	push   $0x0
  pushl $85
  10254b:	6a 55                	push   $0x55
  jmp __alltraps
  10254d:	e9 7a 07 00 00       	jmp    102ccc <__alltraps>

00102552 <vector86>:
.globl vector86
vector86:
  pushl $0
  102552:	6a 00                	push   $0x0
  pushl $86
  102554:	6a 56                	push   $0x56
  jmp __alltraps
  102556:	e9 71 07 00 00       	jmp    102ccc <__alltraps>

0010255b <vector87>:
.globl vector87
vector87:
  pushl $0
  10255b:	6a 00                	push   $0x0
  pushl $87
  10255d:	6a 57                	push   $0x57
  jmp __alltraps
  10255f:	e9 68 07 00 00       	jmp    102ccc <__alltraps>

00102564 <vector88>:
.globl vector88
vector88:
  pushl $0
  102564:	6a 00                	push   $0x0
  pushl $88
  102566:	6a 58                	push   $0x58
  jmp __alltraps
  102568:	e9 5f 07 00 00       	jmp    102ccc <__alltraps>

0010256d <vector89>:
.globl vector89
vector89:
  pushl $0
  10256d:	6a 00                	push   $0x0
  pushl $89
  10256f:	6a 59                	push   $0x59
  jmp __alltraps
  102571:	e9 56 07 00 00       	jmp    102ccc <__alltraps>

00102576 <vector90>:
.globl vector90
vector90:
  pushl $0
  102576:	6a 00                	push   $0x0
  pushl $90
  102578:	6a 5a                	push   $0x5a
  jmp __alltraps
  10257a:	e9 4d 07 00 00       	jmp    102ccc <__alltraps>

0010257f <vector91>:
.globl vector91
vector91:
  pushl $0
  10257f:	6a 00                	push   $0x0
  pushl $91
  102581:	6a 5b                	push   $0x5b
  jmp __alltraps
  102583:	e9 44 07 00 00       	jmp    102ccc <__alltraps>

00102588 <vector92>:
.globl vector92
vector92:
  pushl $0
  102588:	6a 00                	push   $0x0
  pushl $92
  10258a:	6a 5c                	push   $0x5c
  jmp __alltraps
  10258c:	e9 3b 07 00 00       	jmp    102ccc <__alltraps>

00102591 <vector93>:
.globl vector93
vector93:
  pushl $0
  102591:	6a 00                	push   $0x0
  pushl $93
  102593:	6a 5d                	push   $0x5d
  jmp __alltraps
  102595:	e9 32 07 00 00       	jmp    102ccc <__alltraps>

0010259a <vector94>:
.globl vector94
vector94:
  pushl $0
  10259a:	6a 00                	push   $0x0
  pushl $94
  10259c:	6a 5e                	push   $0x5e
  jmp __alltraps
  10259e:	e9 29 07 00 00       	jmp    102ccc <__alltraps>

001025a3 <vector95>:
.globl vector95
vector95:
  pushl $0
  1025a3:	6a 00                	push   $0x0
  pushl $95
  1025a5:	6a 5f                	push   $0x5f
  jmp __alltraps
  1025a7:	e9 20 07 00 00       	jmp    102ccc <__alltraps>

001025ac <vector96>:
.globl vector96
vector96:
  pushl $0
  1025ac:	6a 00                	push   $0x0
  pushl $96
  1025ae:	6a 60                	push   $0x60
  jmp __alltraps
  1025b0:	e9 17 07 00 00       	jmp    102ccc <__alltraps>

001025b5 <vector97>:
.globl vector97
vector97:
  pushl $0
  1025b5:	6a 00                	push   $0x0
  pushl $97
  1025b7:	6a 61                	push   $0x61
  jmp __alltraps
  1025b9:	e9 0e 07 00 00       	jmp    102ccc <__alltraps>

001025be <vector98>:
.globl vector98
vector98:
  pushl $0
  1025be:	6a 00                	push   $0x0
  pushl $98
  1025c0:	6a 62                	push   $0x62
  jmp __alltraps
  1025c2:	e9 05 07 00 00       	jmp    102ccc <__alltraps>

001025c7 <vector99>:
.globl vector99
vector99:
  pushl $0
  1025c7:	6a 00                	push   $0x0
  pushl $99
  1025c9:	6a 63                	push   $0x63
  jmp __alltraps
  1025cb:	e9 fc 06 00 00       	jmp    102ccc <__alltraps>

001025d0 <vector100>:
.globl vector100
vector100:
  pushl $0
  1025d0:	6a 00                	push   $0x0
  pushl $100
  1025d2:	6a 64                	push   $0x64
  jmp __alltraps
  1025d4:	e9 f3 06 00 00       	jmp    102ccc <__alltraps>

001025d9 <vector101>:
.globl vector101
vector101:
  pushl $0
  1025d9:	6a 00                	push   $0x0
  pushl $101
  1025db:	6a 65                	push   $0x65
  jmp __alltraps
  1025dd:	e9 ea 06 00 00       	jmp    102ccc <__alltraps>

001025e2 <vector102>:
.globl vector102
vector102:
  pushl $0
  1025e2:	6a 00                	push   $0x0
  pushl $102
  1025e4:	6a 66                	push   $0x66
  jmp __alltraps
  1025e6:	e9 e1 06 00 00       	jmp    102ccc <__alltraps>

001025eb <vector103>:
.globl vector103
vector103:
  pushl $0
  1025eb:	6a 00                	push   $0x0
  pushl $103
  1025ed:	6a 67                	push   $0x67
  jmp __alltraps
  1025ef:	e9 d8 06 00 00       	jmp    102ccc <__alltraps>

001025f4 <vector104>:
.globl vector104
vector104:
  pushl $0
  1025f4:	6a 00                	push   $0x0
  pushl $104
  1025f6:	6a 68                	push   $0x68
  jmp __alltraps
  1025f8:	e9 cf 06 00 00       	jmp    102ccc <__alltraps>

001025fd <vector105>:
.globl vector105
vector105:
  pushl $0
  1025fd:	6a 00                	push   $0x0
  pushl $105
  1025ff:	6a 69                	push   $0x69
  jmp __alltraps
  102601:	e9 c6 06 00 00       	jmp    102ccc <__alltraps>

00102606 <vector106>:
.globl vector106
vector106:
  pushl $0
  102606:	6a 00                	push   $0x0
  pushl $106
  102608:	6a 6a                	push   $0x6a
  jmp __alltraps
  10260a:	e9 bd 06 00 00       	jmp    102ccc <__alltraps>

0010260f <vector107>:
.globl vector107
vector107:
  pushl $0
  10260f:	6a 00                	push   $0x0
  pushl $107
  102611:	6a 6b                	push   $0x6b
  jmp __alltraps
  102613:	e9 b4 06 00 00       	jmp    102ccc <__alltraps>

00102618 <vector108>:
.globl vector108
vector108:
  pushl $0
  102618:	6a 00                	push   $0x0
  pushl $108
  10261a:	6a 6c                	push   $0x6c
  jmp __alltraps
  10261c:	e9 ab 06 00 00       	jmp    102ccc <__alltraps>

00102621 <vector109>:
.globl vector109
vector109:
  pushl $0
  102621:	6a 00                	push   $0x0
  pushl $109
  102623:	6a 6d                	push   $0x6d
  jmp __alltraps
  102625:	e9 a2 06 00 00       	jmp    102ccc <__alltraps>

0010262a <vector110>:
.globl vector110
vector110:
  pushl $0
  10262a:	6a 00                	push   $0x0
  pushl $110
  10262c:	6a 6e                	push   $0x6e
  jmp __alltraps
  10262e:	e9 99 06 00 00       	jmp    102ccc <__alltraps>

00102633 <vector111>:
.globl vector111
vector111:
  pushl $0
  102633:	6a 00                	push   $0x0
  pushl $111
  102635:	6a 6f                	push   $0x6f
  jmp __alltraps
  102637:	e9 90 06 00 00       	jmp    102ccc <__alltraps>

0010263c <vector112>:
.globl vector112
vector112:
  pushl $0
  10263c:	6a 00                	push   $0x0
  pushl $112
  10263e:	6a 70                	push   $0x70
  jmp __alltraps
  102640:	e9 87 06 00 00       	jmp    102ccc <__alltraps>

00102645 <vector113>:
.globl vector113
vector113:
  pushl $0
  102645:	6a 00                	push   $0x0
  pushl $113
  102647:	6a 71                	push   $0x71
  jmp __alltraps
  102649:	e9 7e 06 00 00       	jmp    102ccc <__alltraps>

0010264e <vector114>:
.globl vector114
vector114:
  pushl $0
  10264e:	6a 00                	push   $0x0
  pushl $114
  102650:	6a 72                	push   $0x72
  jmp __alltraps
  102652:	e9 75 06 00 00       	jmp    102ccc <__alltraps>

00102657 <vector115>:
.globl vector115
vector115:
  pushl $0
  102657:	6a 00                	push   $0x0
  pushl $115
  102659:	6a 73                	push   $0x73
  jmp __alltraps
  10265b:	e9 6c 06 00 00       	jmp    102ccc <__alltraps>

00102660 <vector116>:
.globl vector116
vector116:
  pushl $0
  102660:	6a 00                	push   $0x0
  pushl $116
  102662:	6a 74                	push   $0x74
  jmp __alltraps
  102664:	e9 63 06 00 00       	jmp    102ccc <__alltraps>

00102669 <vector117>:
.globl vector117
vector117:
  pushl $0
  102669:	6a 00                	push   $0x0
  pushl $117
  10266b:	6a 75                	push   $0x75
  jmp __alltraps
  10266d:	e9 5a 06 00 00       	jmp    102ccc <__alltraps>

00102672 <vector118>:
.globl vector118
vector118:
  pushl $0
  102672:	6a 00                	push   $0x0
  pushl $118
  102674:	6a 76                	push   $0x76
  jmp __alltraps
  102676:	e9 51 06 00 00       	jmp    102ccc <__alltraps>

0010267b <vector119>:
.globl vector119
vector119:
  pushl $0
  10267b:	6a 00                	push   $0x0
  pushl $119
  10267d:	6a 77                	push   $0x77
  jmp __alltraps
  10267f:	e9 48 06 00 00       	jmp    102ccc <__alltraps>

00102684 <vector120>:
.globl vector120
vector120:
  pushl $0
  102684:	6a 00                	push   $0x0
  pushl $120
  102686:	6a 78                	push   $0x78
  jmp __alltraps
  102688:	e9 3f 06 00 00       	jmp    102ccc <__alltraps>

0010268d <vector121>:
.globl vector121
vector121:
  pushl $0
  10268d:	6a 00                	push   $0x0
  pushl $121
  10268f:	6a 79                	push   $0x79
  jmp __alltraps
  102691:	e9 36 06 00 00       	jmp    102ccc <__alltraps>

00102696 <vector122>:
.globl vector122
vector122:
  pushl $0
  102696:	6a 00                	push   $0x0
  pushl $122
  102698:	6a 7a                	push   $0x7a
  jmp __alltraps
  10269a:	e9 2d 06 00 00       	jmp    102ccc <__alltraps>

0010269f <vector123>:
.globl vector123
vector123:
  pushl $0
  10269f:	6a 00                	push   $0x0
  pushl $123
  1026a1:	6a 7b                	push   $0x7b
  jmp __alltraps
  1026a3:	e9 24 06 00 00       	jmp    102ccc <__alltraps>

001026a8 <vector124>:
.globl vector124
vector124:
  pushl $0
  1026a8:	6a 00                	push   $0x0
  pushl $124
  1026aa:	6a 7c                	push   $0x7c
  jmp __alltraps
  1026ac:	e9 1b 06 00 00       	jmp    102ccc <__alltraps>

001026b1 <vector125>:
.globl vector125
vector125:
  pushl $0
  1026b1:	6a 00                	push   $0x0
  pushl $125
  1026b3:	6a 7d                	push   $0x7d
  jmp __alltraps
  1026b5:	e9 12 06 00 00       	jmp    102ccc <__alltraps>

001026ba <vector126>:
.globl vector126
vector126:
  pushl $0
  1026ba:	6a 00                	push   $0x0
  pushl $126
  1026bc:	6a 7e                	push   $0x7e
  jmp __alltraps
  1026be:	e9 09 06 00 00       	jmp    102ccc <__alltraps>

001026c3 <vector127>:
.globl vector127
vector127:
  pushl $0
  1026c3:	6a 00                	push   $0x0
  pushl $127
  1026c5:	6a 7f                	push   $0x7f
  jmp __alltraps
  1026c7:	e9 00 06 00 00       	jmp    102ccc <__alltraps>

001026cc <vector128>:
.globl vector128
vector128:
  pushl $0
  1026cc:	6a 00                	push   $0x0
  pushl $128
  1026ce:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  1026d3:	e9 f4 05 00 00       	jmp    102ccc <__alltraps>

001026d8 <vector129>:
.globl vector129
vector129:
  pushl $0
  1026d8:	6a 00                	push   $0x0
  pushl $129
  1026da:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  1026df:	e9 e8 05 00 00       	jmp    102ccc <__alltraps>

001026e4 <vector130>:
.globl vector130
vector130:
  pushl $0
  1026e4:	6a 00                	push   $0x0
  pushl $130
  1026e6:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  1026eb:	e9 dc 05 00 00       	jmp    102ccc <__alltraps>

001026f0 <vector131>:
.globl vector131
vector131:
  pushl $0
  1026f0:	6a 00                	push   $0x0
  pushl $131
  1026f2:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  1026f7:	e9 d0 05 00 00       	jmp    102ccc <__alltraps>

001026fc <vector132>:
.globl vector132
vector132:
  pushl $0
  1026fc:	6a 00                	push   $0x0
  pushl $132
  1026fe:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102703:	e9 c4 05 00 00       	jmp    102ccc <__alltraps>

00102708 <vector133>:
.globl vector133
vector133:
  pushl $0
  102708:	6a 00                	push   $0x0
  pushl $133
  10270a:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  10270f:	e9 b8 05 00 00       	jmp    102ccc <__alltraps>

00102714 <vector134>:
.globl vector134
vector134:
  pushl $0
  102714:	6a 00                	push   $0x0
  pushl $134
  102716:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  10271b:	e9 ac 05 00 00       	jmp    102ccc <__alltraps>

00102720 <vector135>:
.globl vector135
vector135:
  pushl $0
  102720:	6a 00                	push   $0x0
  pushl $135
  102722:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  102727:	e9 a0 05 00 00       	jmp    102ccc <__alltraps>

0010272c <vector136>:
.globl vector136
vector136:
  pushl $0
  10272c:	6a 00                	push   $0x0
  pushl $136
  10272e:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102733:	e9 94 05 00 00       	jmp    102ccc <__alltraps>

00102738 <vector137>:
.globl vector137
vector137:
  pushl $0
  102738:	6a 00                	push   $0x0
  pushl $137
  10273a:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  10273f:	e9 88 05 00 00       	jmp    102ccc <__alltraps>

00102744 <vector138>:
.globl vector138
vector138:
  pushl $0
  102744:	6a 00                	push   $0x0
  pushl $138
  102746:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  10274b:	e9 7c 05 00 00       	jmp    102ccc <__alltraps>

00102750 <vector139>:
.globl vector139
vector139:
  pushl $0
  102750:	6a 00                	push   $0x0
  pushl $139
  102752:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102757:	e9 70 05 00 00       	jmp    102ccc <__alltraps>

0010275c <vector140>:
.globl vector140
vector140:
  pushl $0
  10275c:	6a 00                	push   $0x0
  pushl $140
  10275e:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  102763:	e9 64 05 00 00       	jmp    102ccc <__alltraps>

00102768 <vector141>:
.globl vector141
vector141:
  pushl $0
  102768:	6a 00                	push   $0x0
  pushl $141
  10276a:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  10276f:	e9 58 05 00 00       	jmp    102ccc <__alltraps>

00102774 <vector142>:
.globl vector142
vector142:
  pushl $0
  102774:	6a 00                	push   $0x0
  pushl $142
  102776:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  10277b:	e9 4c 05 00 00       	jmp    102ccc <__alltraps>

00102780 <vector143>:
.globl vector143
vector143:
  pushl $0
  102780:	6a 00                	push   $0x0
  pushl $143
  102782:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  102787:	e9 40 05 00 00       	jmp    102ccc <__alltraps>

0010278c <vector144>:
.globl vector144
vector144:
  pushl $0
  10278c:	6a 00                	push   $0x0
  pushl $144
  10278e:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  102793:	e9 34 05 00 00       	jmp    102ccc <__alltraps>

00102798 <vector145>:
.globl vector145
vector145:
  pushl $0
  102798:	6a 00                	push   $0x0
  pushl $145
  10279a:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  10279f:	e9 28 05 00 00       	jmp    102ccc <__alltraps>

001027a4 <vector146>:
.globl vector146
vector146:
  pushl $0
  1027a4:	6a 00                	push   $0x0
  pushl $146
  1027a6:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  1027ab:	e9 1c 05 00 00       	jmp    102ccc <__alltraps>

001027b0 <vector147>:
.globl vector147
vector147:
  pushl $0
  1027b0:	6a 00                	push   $0x0
  pushl $147
  1027b2:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  1027b7:	e9 10 05 00 00       	jmp    102ccc <__alltraps>

001027bc <vector148>:
.globl vector148
vector148:
  pushl $0
  1027bc:	6a 00                	push   $0x0
  pushl $148
  1027be:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  1027c3:	e9 04 05 00 00       	jmp    102ccc <__alltraps>

001027c8 <vector149>:
.globl vector149
vector149:
  pushl $0
  1027c8:	6a 00                	push   $0x0
  pushl $149
  1027ca:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1027cf:	e9 f8 04 00 00       	jmp    102ccc <__alltraps>

001027d4 <vector150>:
.globl vector150
vector150:
  pushl $0
  1027d4:	6a 00                	push   $0x0
  pushl $150
  1027d6:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  1027db:	e9 ec 04 00 00       	jmp    102ccc <__alltraps>

001027e0 <vector151>:
.globl vector151
vector151:
  pushl $0
  1027e0:	6a 00                	push   $0x0
  pushl $151
  1027e2:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  1027e7:	e9 e0 04 00 00       	jmp    102ccc <__alltraps>

001027ec <vector152>:
.globl vector152
vector152:
  pushl $0
  1027ec:	6a 00                	push   $0x0
  pushl $152
  1027ee:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  1027f3:	e9 d4 04 00 00       	jmp    102ccc <__alltraps>

001027f8 <vector153>:
.globl vector153
vector153:
  pushl $0
  1027f8:	6a 00                	push   $0x0
  pushl $153
  1027fa:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  1027ff:	e9 c8 04 00 00       	jmp    102ccc <__alltraps>

00102804 <vector154>:
.globl vector154
vector154:
  pushl $0
  102804:	6a 00                	push   $0x0
  pushl $154
  102806:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  10280b:	e9 bc 04 00 00       	jmp    102ccc <__alltraps>

00102810 <vector155>:
.globl vector155
vector155:
  pushl $0
  102810:	6a 00                	push   $0x0
  pushl $155
  102812:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  102817:	e9 b0 04 00 00       	jmp    102ccc <__alltraps>

0010281c <vector156>:
.globl vector156
vector156:
  pushl $0
  10281c:	6a 00                	push   $0x0
  pushl $156
  10281e:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102823:	e9 a4 04 00 00       	jmp    102ccc <__alltraps>

00102828 <vector157>:
.globl vector157
vector157:
  pushl $0
  102828:	6a 00                	push   $0x0
  pushl $157
  10282a:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  10282f:	e9 98 04 00 00       	jmp    102ccc <__alltraps>

00102834 <vector158>:
.globl vector158
vector158:
  pushl $0
  102834:	6a 00                	push   $0x0
  pushl $158
  102836:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  10283b:	e9 8c 04 00 00       	jmp    102ccc <__alltraps>

00102840 <vector159>:
.globl vector159
vector159:
  pushl $0
  102840:	6a 00                	push   $0x0
  pushl $159
  102842:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  102847:	e9 80 04 00 00       	jmp    102ccc <__alltraps>

0010284c <vector160>:
.globl vector160
vector160:
  pushl $0
  10284c:	6a 00                	push   $0x0
  pushl $160
  10284e:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  102853:	e9 74 04 00 00       	jmp    102ccc <__alltraps>

00102858 <vector161>:
.globl vector161
vector161:
  pushl $0
  102858:	6a 00                	push   $0x0
  pushl $161
  10285a:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  10285f:	e9 68 04 00 00       	jmp    102ccc <__alltraps>

00102864 <vector162>:
.globl vector162
vector162:
  pushl $0
  102864:	6a 00                	push   $0x0
  pushl $162
  102866:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  10286b:	e9 5c 04 00 00       	jmp    102ccc <__alltraps>

00102870 <vector163>:
.globl vector163
vector163:
  pushl $0
  102870:	6a 00                	push   $0x0
  pushl $163
  102872:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  102877:	e9 50 04 00 00       	jmp    102ccc <__alltraps>

0010287c <vector164>:
.globl vector164
vector164:
  pushl $0
  10287c:	6a 00                	push   $0x0
  pushl $164
  10287e:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  102883:	e9 44 04 00 00       	jmp    102ccc <__alltraps>

00102888 <vector165>:
.globl vector165
vector165:
  pushl $0
  102888:	6a 00                	push   $0x0
  pushl $165
  10288a:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  10288f:	e9 38 04 00 00       	jmp    102ccc <__alltraps>

00102894 <vector166>:
.globl vector166
vector166:
  pushl $0
  102894:	6a 00                	push   $0x0
  pushl $166
  102896:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  10289b:	e9 2c 04 00 00       	jmp    102ccc <__alltraps>

001028a0 <vector167>:
.globl vector167
vector167:
  pushl $0
  1028a0:	6a 00                	push   $0x0
  pushl $167
  1028a2:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  1028a7:	e9 20 04 00 00       	jmp    102ccc <__alltraps>

001028ac <vector168>:
.globl vector168
vector168:
  pushl $0
  1028ac:	6a 00                	push   $0x0
  pushl $168
  1028ae:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  1028b3:	e9 14 04 00 00       	jmp    102ccc <__alltraps>

001028b8 <vector169>:
.globl vector169
vector169:
  pushl $0
  1028b8:	6a 00                	push   $0x0
  pushl $169
  1028ba:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  1028bf:	e9 08 04 00 00       	jmp    102ccc <__alltraps>

001028c4 <vector170>:
.globl vector170
vector170:
  pushl $0
  1028c4:	6a 00                	push   $0x0
  pushl $170
  1028c6:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  1028cb:	e9 fc 03 00 00       	jmp    102ccc <__alltraps>

001028d0 <vector171>:
.globl vector171
vector171:
  pushl $0
  1028d0:	6a 00                	push   $0x0
  pushl $171
  1028d2:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  1028d7:	e9 f0 03 00 00       	jmp    102ccc <__alltraps>

001028dc <vector172>:
.globl vector172
vector172:
  pushl $0
  1028dc:	6a 00                	push   $0x0
  pushl $172
  1028de:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  1028e3:	e9 e4 03 00 00       	jmp    102ccc <__alltraps>

001028e8 <vector173>:
.globl vector173
vector173:
  pushl $0
  1028e8:	6a 00                	push   $0x0
  pushl $173
  1028ea:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  1028ef:	e9 d8 03 00 00       	jmp    102ccc <__alltraps>

001028f4 <vector174>:
.globl vector174
vector174:
  pushl $0
  1028f4:	6a 00                	push   $0x0
  pushl $174
  1028f6:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  1028fb:	e9 cc 03 00 00       	jmp    102ccc <__alltraps>

00102900 <vector175>:
.globl vector175
vector175:
  pushl $0
  102900:	6a 00                	push   $0x0
  pushl $175
  102902:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102907:	e9 c0 03 00 00       	jmp    102ccc <__alltraps>

0010290c <vector176>:
.globl vector176
vector176:
  pushl $0
  10290c:	6a 00                	push   $0x0
  pushl $176
  10290e:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102913:	e9 b4 03 00 00       	jmp    102ccc <__alltraps>

00102918 <vector177>:
.globl vector177
vector177:
  pushl $0
  102918:	6a 00                	push   $0x0
  pushl $177
  10291a:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  10291f:	e9 a8 03 00 00       	jmp    102ccc <__alltraps>

00102924 <vector178>:
.globl vector178
vector178:
  pushl $0
  102924:	6a 00                	push   $0x0
  pushl $178
  102926:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  10292b:	e9 9c 03 00 00       	jmp    102ccc <__alltraps>

00102930 <vector179>:
.globl vector179
vector179:
  pushl $0
  102930:	6a 00                	push   $0x0
  pushl $179
  102932:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102937:	e9 90 03 00 00       	jmp    102ccc <__alltraps>

0010293c <vector180>:
.globl vector180
vector180:
  pushl $0
  10293c:	6a 00                	push   $0x0
  pushl $180
  10293e:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  102943:	e9 84 03 00 00       	jmp    102ccc <__alltraps>

00102948 <vector181>:
.globl vector181
vector181:
  pushl $0
  102948:	6a 00                	push   $0x0
  pushl $181
  10294a:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  10294f:	e9 78 03 00 00       	jmp    102ccc <__alltraps>

00102954 <vector182>:
.globl vector182
vector182:
  pushl $0
  102954:	6a 00                	push   $0x0
  pushl $182
  102956:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  10295b:	e9 6c 03 00 00       	jmp    102ccc <__alltraps>

00102960 <vector183>:
.globl vector183
vector183:
  pushl $0
  102960:	6a 00                	push   $0x0
  pushl $183
  102962:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102967:	e9 60 03 00 00       	jmp    102ccc <__alltraps>

0010296c <vector184>:
.globl vector184
vector184:
  pushl $0
  10296c:	6a 00                	push   $0x0
  pushl $184
  10296e:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  102973:	e9 54 03 00 00       	jmp    102ccc <__alltraps>

00102978 <vector185>:
.globl vector185
vector185:
  pushl $0
  102978:	6a 00                	push   $0x0
  pushl $185
  10297a:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  10297f:	e9 48 03 00 00       	jmp    102ccc <__alltraps>

00102984 <vector186>:
.globl vector186
vector186:
  pushl $0
  102984:	6a 00                	push   $0x0
  pushl $186
  102986:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  10298b:	e9 3c 03 00 00       	jmp    102ccc <__alltraps>

00102990 <vector187>:
.globl vector187
vector187:
  pushl $0
  102990:	6a 00                	push   $0x0
  pushl $187
  102992:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  102997:	e9 30 03 00 00       	jmp    102ccc <__alltraps>

0010299c <vector188>:
.globl vector188
vector188:
  pushl $0
  10299c:	6a 00                	push   $0x0
  pushl $188
  10299e:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  1029a3:	e9 24 03 00 00       	jmp    102ccc <__alltraps>

001029a8 <vector189>:
.globl vector189
vector189:
  pushl $0
  1029a8:	6a 00                	push   $0x0
  pushl $189
  1029aa:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  1029af:	e9 18 03 00 00       	jmp    102ccc <__alltraps>

001029b4 <vector190>:
.globl vector190
vector190:
  pushl $0
  1029b4:	6a 00                	push   $0x0
  pushl $190
  1029b6:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  1029bb:	e9 0c 03 00 00       	jmp    102ccc <__alltraps>

001029c0 <vector191>:
.globl vector191
vector191:
  pushl $0
  1029c0:	6a 00                	push   $0x0
  pushl $191
  1029c2:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  1029c7:	e9 00 03 00 00       	jmp    102ccc <__alltraps>

001029cc <vector192>:
.globl vector192
vector192:
  pushl $0
  1029cc:	6a 00                	push   $0x0
  pushl $192
  1029ce:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  1029d3:	e9 f4 02 00 00       	jmp    102ccc <__alltraps>

001029d8 <vector193>:
.globl vector193
vector193:
  pushl $0
  1029d8:	6a 00                	push   $0x0
  pushl $193
  1029da:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  1029df:	e9 e8 02 00 00       	jmp    102ccc <__alltraps>

001029e4 <vector194>:
.globl vector194
vector194:
  pushl $0
  1029e4:	6a 00                	push   $0x0
  pushl $194
  1029e6:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  1029eb:	e9 dc 02 00 00       	jmp    102ccc <__alltraps>

001029f0 <vector195>:
.globl vector195
vector195:
  pushl $0
  1029f0:	6a 00                	push   $0x0
  pushl $195
  1029f2:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  1029f7:	e9 d0 02 00 00       	jmp    102ccc <__alltraps>

001029fc <vector196>:
.globl vector196
vector196:
  pushl $0
  1029fc:	6a 00                	push   $0x0
  pushl $196
  1029fe:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102a03:	e9 c4 02 00 00       	jmp    102ccc <__alltraps>

00102a08 <vector197>:
.globl vector197
vector197:
  pushl $0
  102a08:	6a 00                	push   $0x0
  pushl $197
  102a0a:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102a0f:	e9 b8 02 00 00       	jmp    102ccc <__alltraps>

00102a14 <vector198>:
.globl vector198
vector198:
  pushl $0
  102a14:	6a 00                	push   $0x0
  pushl $198
  102a16:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102a1b:	e9 ac 02 00 00       	jmp    102ccc <__alltraps>

00102a20 <vector199>:
.globl vector199
vector199:
  pushl $0
  102a20:	6a 00                	push   $0x0
  pushl $199
  102a22:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102a27:	e9 a0 02 00 00       	jmp    102ccc <__alltraps>

00102a2c <vector200>:
.globl vector200
vector200:
  pushl $0
  102a2c:	6a 00                	push   $0x0
  pushl $200
  102a2e:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102a33:	e9 94 02 00 00       	jmp    102ccc <__alltraps>

00102a38 <vector201>:
.globl vector201
vector201:
  pushl $0
  102a38:	6a 00                	push   $0x0
  pushl $201
  102a3a:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102a3f:	e9 88 02 00 00       	jmp    102ccc <__alltraps>

00102a44 <vector202>:
.globl vector202
vector202:
  pushl $0
  102a44:	6a 00                	push   $0x0
  pushl $202
  102a46:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102a4b:	e9 7c 02 00 00       	jmp    102ccc <__alltraps>

00102a50 <vector203>:
.globl vector203
vector203:
  pushl $0
  102a50:	6a 00                	push   $0x0
  pushl $203
  102a52:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102a57:	e9 70 02 00 00       	jmp    102ccc <__alltraps>

00102a5c <vector204>:
.globl vector204
vector204:
  pushl $0
  102a5c:	6a 00                	push   $0x0
  pushl $204
  102a5e:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  102a63:	e9 64 02 00 00       	jmp    102ccc <__alltraps>

00102a68 <vector205>:
.globl vector205
vector205:
  pushl $0
  102a68:	6a 00                	push   $0x0
  pushl $205
  102a6a:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102a6f:	e9 58 02 00 00       	jmp    102ccc <__alltraps>

00102a74 <vector206>:
.globl vector206
vector206:
  pushl $0
  102a74:	6a 00                	push   $0x0
  pushl $206
  102a76:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102a7b:	e9 4c 02 00 00       	jmp    102ccc <__alltraps>

00102a80 <vector207>:
.globl vector207
vector207:
  pushl $0
  102a80:	6a 00                	push   $0x0
  pushl $207
  102a82:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102a87:	e9 40 02 00 00       	jmp    102ccc <__alltraps>

00102a8c <vector208>:
.globl vector208
vector208:
  pushl $0
  102a8c:	6a 00                	push   $0x0
  pushl $208
  102a8e:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102a93:	e9 34 02 00 00       	jmp    102ccc <__alltraps>

00102a98 <vector209>:
.globl vector209
vector209:
  pushl $0
  102a98:	6a 00                	push   $0x0
  pushl $209
  102a9a:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102a9f:	e9 28 02 00 00       	jmp    102ccc <__alltraps>

00102aa4 <vector210>:
.globl vector210
vector210:
  pushl $0
  102aa4:	6a 00                	push   $0x0
  pushl $210
  102aa6:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102aab:	e9 1c 02 00 00       	jmp    102ccc <__alltraps>

00102ab0 <vector211>:
.globl vector211
vector211:
  pushl $0
  102ab0:	6a 00                	push   $0x0
  pushl $211
  102ab2:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102ab7:	e9 10 02 00 00       	jmp    102ccc <__alltraps>

00102abc <vector212>:
.globl vector212
vector212:
  pushl $0
  102abc:	6a 00                	push   $0x0
  pushl $212
  102abe:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102ac3:	e9 04 02 00 00       	jmp    102ccc <__alltraps>

00102ac8 <vector213>:
.globl vector213
vector213:
  pushl $0
  102ac8:	6a 00                	push   $0x0
  pushl $213
  102aca:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102acf:	e9 f8 01 00 00       	jmp    102ccc <__alltraps>

00102ad4 <vector214>:
.globl vector214
vector214:
  pushl $0
  102ad4:	6a 00                	push   $0x0
  pushl $214
  102ad6:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102adb:	e9 ec 01 00 00       	jmp    102ccc <__alltraps>

00102ae0 <vector215>:
.globl vector215
vector215:
  pushl $0
  102ae0:	6a 00                	push   $0x0
  pushl $215
  102ae2:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102ae7:	e9 e0 01 00 00       	jmp    102ccc <__alltraps>

00102aec <vector216>:
.globl vector216
vector216:
  pushl $0
  102aec:	6a 00                	push   $0x0
  pushl $216
  102aee:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102af3:	e9 d4 01 00 00       	jmp    102ccc <__alltraps>

00102af8 <vector217>:
.globl vector217
vector217:
  pushl $0
  102af8:	6a 00                	push   $0x0
  pushl $217
  102afa:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102aff:	e9 c8 01 00 00       	jmp    102ccc <__alltraps>

00102b04 <vector218>:
.globl vector218
vector218:
  pushl $0
  102b04:	6a 00                	push   $0x0
  pushl $218
  102b06:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102b0b:	e9 bc 01 00 00       	jmp    102ccc <__alltraps>

00102b10 <vector219>:
.globl vector219
vector219:
  pushl $0
  102b10:	6a 00                	push   $0x0
  pushl $219
  102b12:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102b17:	e9 b0 01 00 00       	jmp    102ccc <__alltraps>

00102b1c <vector220>:
.globl vector220
vector220:
  pushl $0
  102b1c:	6a 00                	push   $0x0
  pushl $220
  102b1e:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102b23:	e9 a4 01 00 00       	jmp    102ccc <__alltraps>

00102b28 <vector221>:
.globl vector221
vector221:
  pushl $0
  102b28:	6a 00                	push   $0x0
  pushl $221
  102b2a:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102b2f:	e9 98 01 00 00       	jmp    102ccc <__alltraps>

00102b34 <vector222>:
.globl vector222
vector222:
  pushl $0
  102b34:	6a 00                	push   $0x0
  pushl $222
  102b36:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102b3b:	e9 8c 01 00 00       	jmp    102ccc <__alltraps>

00102b40 <vector223>:
.globl vector223
vector223:
  pushl $0
  102b40:	6a 00                	push   $0x0
  pushl $223
  102b42:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102b47:	e9 80 01 00 00       	jmp    102ccc <__alltraps>

00102b4c <vector224>:
.globl vector224
vector224:
  pushl $0
  102b4c:	6a 00                	push   $0x0
  pushl $224
  102b4e:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102b53:	e9 74 01 00 00       	jmp    102ccc <__alltraps>

00102b58 <vector225>:
.globl vector225
vector225:
  pushl $0
  102b58:	6a 00                	push   $0x0
  pushl $225
  102b5a:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  102b5f:	e9 68 01 00 00       	jmp    102ccc <__alltraps>

00102b64 <vector226>:
.globl vector226
vector226:
  pushl $0
  102b64:	6a 00                	push   $0x0
  pushl $226
  102b66:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102b6b:	e9 5c 01 00 00       	jmp    102ccc <__alltraps>

00102b70 <vector227>:
.globl vector227
vector227:
  pushl $0
  102b70:	6a 00                	push   $0x0
  pushl $227
  102b72:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102b77:	e9 50 01 00 00       	jmp    102ccc <__alltraps>

00102b7c <vector228>:
.globl vector228
vector228:
  pushl $0
  102b7c:	6a 00                	push   $0x0
  pushl $228
  102b7e:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102b83:	e9 44 01 00 00       	jmp    102ccc <__alltraps>

00102b88 <vector229>:
.globl vector229
vector229:
  pushl $0
  102b88:	6a 00                	push   $0x0
  pushl $229
  102b8a:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102b8f:	e9 38 01 00 00       	jmp    102ccc <__alltraps>

00102b94 <vector230>:
.globl vector230
vector230:
  pushl $0
  102b94:	6a 00                	push   $0x0
  pushl $230
  102b96:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102b9b:	e9 2c 01 00 00       	jmp    102ccc <__alltraps>

00102ba0 <vector231>:
.globl vector231
vector231:
  pushl $0
  102ba0:	6a 00                	push   $0x0
  pushl $231
  102ba2:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102ba7:	e9 20 01 00 00       	jmp    102ccc <__alltraps>

00102bac <vector232>:
.globl vector232
vector232:
  pushl $0
  102bac:	6a 00                	push   $0x0
  pushl $232
  102bae:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102bb3:	e9 14 01 00 00       	jmp    102ccc <__alltraps>

00102bb8 <vector233>:
.globl vector233
vector233:
  pushl $0
  102bb8:	6a 00                	push   $0x0
  pushl $233
  102bba:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102bbf:	e9 08 01 00 00       	jmp    102ccc <__alltraps>

00102bc4 <vector234>:
.globl vector234
vector234:
  pushl $0
  102bc4:	6a 00                	push   $0x0
  pushl $234
  102bc6:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102bcb:	e9 fc 00 00 00       	jmp    102ccc <__alltraps>

00102bd0 <vector235>:
.globl vector235
vector235:
  pushl $0
  102bd0:	6a 00                	push   $0x0
  pushl $235
  102bd2:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102bd7:	e9 f0 00 00 00       	jmp    102ccc <__alltraps>

00102bdc <vector236>:
.globl vector236
vector236:
  pushl $0
  102bdc:	6a 00                	push   $0x0
  pushl $236
  102bde:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102be3:	e9 e4 00 00 00       	jmp    102ccc <__alltraps>

00102be8 <vector237>:
.globl vector237
vector237:
  pushl $0
  102be8:	6a 00                	push   $0x0
  pushl $237
  102bea:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102bef:	e9 d8 00 00 00       	jmp    102ccc <__alltraps>

00102bf4 <vector238>:
.globl vector238
vector238:
  pushl $0
  102bf4:	6a 00                	push   $0x0
  pushl $238
  102bf6:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102bfb:	e9 cc 00 00 00       	jmp    102ccc <__alltraps>

00102c00 <vector239>:
.globl vector239
vector239:
  pushl $0
  102c00:	6a 00                	push   $0x0
  pushl $239
  102c02:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102c07:	e9 c0 00 00 00       	jmp    102ccc <__alltraps>

00102c0c <vector240>:
.globl vector240
vector240:
  pushl $0
  102c0c:	6a 00                	push   $0x0
  pushl $240
  102c0e:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102c13:	e9 b4 00 00 00       	jmp    102ccc <__alltraps>

00102c18 <vector241>:
.globl vector241
vector241:
  pushl $0
  102c18:	6a 00                	push   $0x0
  pushl $241
  102c1a:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102c1f:	e9 a8 00 00 00       	jmp    102ccc <__alltraps>

00102c24 <vector242>:
.globl vector242
vector242:
  pushl $0
  102c24:	6a 00                	push   $0x0
  pushl $242
  102c26:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102c2b:	e9 9c 00 00 00       	jmp    102ccc <__alltraps>

00102c30 <vector243>:
.globl vector243
vector243:
  pushl $0
  102c30:	6a 00                	push   $0x0
  pushl $243
  102c32:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102c37:	e9 90 00 00 00       	jmp    102ccc <__alltraps>

00102c3c <vector244>:
.globl vector244
vector244:
  pushl $0
  102c3c:	6a 00                	push   $0x0
  pushl $244
  102c3e:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102c43:	e9 84 00 00 00       	jmp    102ccc <__alltraps>

00102c48 <vector245>:
.globl vector245
vector245:
  pushl $0
  102c48:	6a 00                	push   $0x0
  pushl $245
  102c4a:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102c4f:	e9 78 00 00 00       	jmp    102ccc <__alltraps>

00102c54 <vector246>:
.globl vector246
vector246:
  pushl $0
  102c54:	6a 00                	push   $0x0
  pushl $246
  102c56:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102c5b:	e9 6c 00 00 00       	jmp    102ccc <__alltraps>

00102c60 <vector247>:
.globl vector247
vector247:
  pushl $0
  102c60:	6a 00                	push   $0x0
  pushl $247
  102c62:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102c67:	e9 60 00 00 00       	jmp    102ccc <__alltraps>

00102c6c <vector248>:
.globl vector248
vector248:
  pushl $0
  102c6c:	6a 00                	push   $0x0
  pushl $248
  102c6e:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102c73:	e9 54 00 00 00       	jmp    102ccc <__alltraps>

00102c78 <vector249>:
.globl vector249
vector249:
  pushl $0
  102c78:	6a 00                	push   $0x0
  pushl $249
  102c7a:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102c7f:	e9 48 00 00 00       	jmp    102ccc <__alltraps>

00102c84 <vector250>:
.globl vector250
vector250:
  pushl $0
  102c84:	6a 00                	push   $0x0
  pushl $250
  102c86:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102c8b:	e9 3c 00 00 00       	jmp    102ccc <__alltraps>

00102c90 <vector251>:
.globl vector251
vector251:
  pushl $0
  102c90:	6a 00                	push   $0x0
  pushl $251
  102c92:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102c97:	e9 30 00 00 00       	jmp    102ccc <__alltraps>

00102c9c <vector252>:
.globl vector252
vector252:
  pushl $0
  102c9c:	6a 00                	push   $0x0
  pushl $252
  102c9e:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102ca3:	e9 24 00 00 00       	jmp    102ccc <__alltraps>

00102ca8 <vector253>:
.globl vector253
vector253:
  pushl $0
  102ca8:	6a 00                	push   $0x0
  pushl $253
  102caa:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102caf:	e9 18 00 00 00       	jmp    102ccc <__alltraps>

00102cb4 <vector254>:
.globl vector254
vector254:
  pushl $0
  102cb4:	6a 00                	push   $0x0
  pushl $254
  102cb6:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102cbb:	e9 0c 00 00 00       	jmp    102ccc <__alltraps>

00102cc0 <vector255>:
.globl vector255
vector255:
  pushl $0
  102cc0:	6a 00                	push   $0x0
  pushl $255
  102cc2:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102cc7:	e9 00 00 00 00       	jmp    102ccc <__alltraps>

00102ccc <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  102ccc:	1e                   	push   %ds
    pushl %es
  102ccd:	06                   	push   %es
    pushl %fs
  102cce:	0f a0                	push   %fs
    pushl %gs
  102cd0:	0f a8                	push   %gs
    pushal
  102cd2:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  102cd3:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  102cd8:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  102cda:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  102cdc:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  102cdd:	e8 64 f5 ff ff       	call   102246 <trap>

    # pop the pushed stack pointer
    popl %esp
  102ce2:	5c                   	pop    %esp

00102ce3 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  102ce3:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  102ce4:	0f a9                	pop    %gs
    popl %fs
  102ce6:	0f a1                	pop    %fs
    popl %es
  102ce8:	07                   	pop    %es
    popl %ds
  102ce9:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  102cea:	83 c4 08             	add    $0x8,%esp
    iret
  102ced:	cf                   	iret   

00102cee <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  102cee:	55                   	push   %ebp
  102cef:	89 e5                	mov    %esp,%ebp
    return page - pages;
  102cf1:	a1 38 df 11 00       	mov    0x11df38,%eax
  102cf6:	8b 55 08             	mov    0x8(%ebp),%edx
  102cf9:	29 c2                	sub    %eax,%edx
  102cfb:	89 d0                	mov    %edx,%eax
  102cfd:	c1 f8 02             	sar    $0x2,%eax
  102d00:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  102d06:	5d                   	pop    %ebp
  102d07:	c3                   	ret    

00102d08 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  102d08:	55                   	push   %ebp
  102d09:	89 e5                	mov    %esp,%ebp
  102d0b:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  102d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  102d11:	89 04 24             	mov    %eax,(%esp)
  102d14:	e8 d5 ff ff ff       	call   102cee <page2ppn>
  102d19:	c1 e0 0c             	shl    $0xc,%eax
}
  102d1c:	c9                   	leave  
  102d1d:	c3                   	ret    

00102d1e <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  102d1e:	55                   	push   %ebp
  102d1f:	89 e5                	mov    %esp,%ebp
  102d21:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  102d24:	8b 45 08             	mov    0x8(%ebp),%eax
  102d27:	c1 e8 0c             	shr    $0xc,%eax
  102d2a:	89 c2                	mov    %eax,%edx
  102d2c:	a1 a0 de 11 00       	mov    0x11dea0,%eax
  102d31:	39 c2                	cmp    %eax,%edx
  102d33:	72 1c                	jb     102d51 <pa2page+0x33>
        panic("pa2page called with invalid pa");
  102d35:	c7 44 24 08 30 70 10 	movl   $0x107030,0x8(%esp)
  102d3c:	00 
  102d3d:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  102d44:	00 
  102d45:	c7 04 24 4f 70 10 00 	movl   $0x10704f,(%esp)
  102d4c:	e8 95 d6 ff ff       	call   1003e6 <__panic>
    }
    return &pages[PPN(pa)];
  102d51:	8b 0d 38 df 11 00    	mov    0x11df38,%ecx
  102d57:	8b 45 08             	mov    0x8(%ebp),%eax
  102d5a:	c1 e8 0c             	shr    $0xc,%eax
  102d5d:	89 c2                	mov    %eax,%edx
  102d5f:	89 d0                	mov    %edx,%eax
  102d61:	c1 e0 02             	shl    $0x2,%eax
  102d64:	01 d0                	add    %edx,%eax
  102d66:	c1 e0 02             	shl    $0x2,%eax
  102d69:	01 c8                	add    %ecx,%eax
}
  102d6b:	c9                   	leave  
  102d6c:	c3                   	ret    

00102d6d <page2kva>:

static inline void *
page2kva(struct Page *page) {
  102d6d:	55                   	push   %ebp
  102d6e:	89 e5                	mov    %esp,%ebp
  102d70:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  102d73:	8b 45 08             	mov    0x8(%ebp),%eax
  102d76:	89 04 24             	mov    %eax,(%esp)
  102d79:	e8 8a ff ff ff       	call   102d08 <page2pa>
  102d7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102d81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d84:	c1 e8 0c             	shr    $0xc,%eax
  102d87:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102d8a:	a1 a0 de 11 00       	mov    0x11dea0,%eax
  102d8f:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  102d92:	72 23                	jb     102db7 <page2kva+0x4a>
  102d94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d97:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102d9b:	c7 44 24 08 60 70 10 	movl   $0x107060,0x8(%esp)
  102da2:	00 
  102da3:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  102daa:	00 
  102dab:	c7 04 24 4f 70 10 00 	movl   $0x10704f,(%esp)
  102db2:	e8 2f d6 ff ff       	call   1003e6 <__panic>
  102db7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102dba:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  102dbf:	c9                   	leave  
  102dc0:	c3                   	ret    

00102dc1 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  102dc1:	55                   	push   %ebp
  102dc2:	89 e5                	mov    %esp,%ebp
  102dc4:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  102dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  102dca:	83 e0 01             	and    $0x1,%eax
  102dcd:	85 c0                	test   %eax,%eax
  102dcf:	75 1c                	jne    102ded <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  102dd1:	c7 44 24 08 84 70 10 	movl   $0x107084,0x8(%esp)
  102dd8:	00 
  102dd9:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  102de0:	00 
  102de1:	c7 04 24 4f 70 10 00 	movl   $0x10704f,(%esp)
  102de8:	e8 f9 d5 ff ff       	call   1003e6 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  102ded:	8b 45 08             	mov    0x8(%ebp),%eax
  102df0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  102df5:	89 04 24             	mov    %eax,(%esp)
  102df8:	e8 21 ff ff ff       	call   102d1e <pa2page>
}
  102dfd:	c9                   	leave  
  102dfe:	c3                   	ret    

00102dff <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
  102dff:	55                   	push   %ebp
  102e00:	89 e5                	mov    %esp,%ebp
  102e02:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
  102e05:	8b 45 08             	mov    0x8(%ebp),%eax
  102e08:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  102e0d:	89 04 24             	mov    %eax,(%esp)
  102e10:	e8 09 ff ff ff       	call   102d1e <pa2page>
}
  102e15:	c9                   	leave  
  102e16:	c3                   	ret    

00102e17 <page_ref>:

static inline int
page_ref(struct Page *page) {
  102e17:	55                   	push   %ebp
  102e18:	89 e5                	mov    %esp,%ebp
    return page->ref;
  102e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  102e1d:	8b 00                	mov    (%eax),%eax
}
  102e1f:	5d                   	pop    %ebp
  102e20:	c3                   	ret    

00102e21 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  102e21:	55                   	push   %ebp
  102e22:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  102e24:	8b 45 08             	mov    0x8(%ebp),%eax
  102e27:	8b 55 0c             	mov    0xc(%ebp),%edx
  102e2a:	89 10                	mov    %edx,(%eax)
}
  102e2c:	90                   	nop
  102e2d:	5d                   	pop    %ebp
  102e2e:	c3                   	ret    

00102e2f <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
  102e2f:	55                   	push   %ebp
  102e30:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  102e32:	8b 45 08             	mov    0x8(%ebp),%eax
  102e35:	8b 00                	mov    (%eax),%eax
  102e37:	8d 50 01             	lea    0x1(%eax),%edx
  102e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  102e3d:	89 10                	mov    %edx,(%eax)
    return page->ref;
  102e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  102e42:	8b 00                	mov    (%eax),%eax
}
  102e44:	5d                   	pop    %ebp
  102e45:	c3                   	ret    

00102e46 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  102e46:	55                   	push   %ebp
  102e47:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  102e49:	8b 45 08             	mov    0x8(%ebp),%eax
  102e4c:	8b 00                	mov    (%eax),%eax
  102e4e:	8d 50 ff             	lea    -0x1(%eax),%edx
  102e51:	8b 45 08             	mov    0x8(%ebp),%eax
  102e54:	89 10                	mov    %edx,(%eax)
    return page->ref;
  102e56:	8b 45 08             	mov    0x8(%ebp),%eax
  102e59:	8b 00                	mov    (%eax),%eax
}
  102e5b:	5d                   	pop    %ebp
  102e5c:	c3                   	ret    

00102e5d <__intr_save>:
__intr_save(void) {
  102e5d:	55                   	push   %ebp
  102e5e:	89 e5                	mov    %esp,%ebp
  102e60:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  102e63:	9c                   	pushf  
  102e64:	58                   	pop    %eax
  102e65:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  102e68:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  102e6b:	25 00 02 00 00       	and    $0x200,%eax
  102e70:	85 c0                	test   %eax,%eax
  102e72:	74 0c                	je     102e80 <__intr_save+0x23>
        intr_disable();
  102e74:	e8 00 ea ff ff       	call   101879 <intr_disable>
        return 1;
  102e79:	b8 01 00 00 00       	mov    $0x1,%eax
  102e7e:	eb 05                	jmp    102e85 <__intr_save+0x28>
    return 0;
  102e80:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102e85:	c9                   	leave  
  102e86:	c3                   	ret    

00102e87 <__intr_restore>:
__intr_restore(bool flag) {
  102e87:	55                   	push   %ebp
  102e88:	89 e5                	mov    %esp,%ebp
  102e8a:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  102e8d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102e91:	74 05                	je     102e98 <__intr_restore+0x11>
        intr_enable();
  102e93:	e8 da e9 ff ff       	call   101872 <intr_enable>
}
  102e98:	90                   	nop
  102e99:	c9                   	leave  
  102e9a:	c3                   	ret    

00102e9b <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102e9b:	55                   	push   %ebp
  102e9c:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  102ea1:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102ea4:	b8 23 00 00 00       	mov    $0x23,%eax
  102ea9:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102eab:	b8 23 00 00 00       	mov    $0x23,%eax
  102eb0:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102eb2:	b8 10 00 00 00       	mov    $0x10,%eax
  102eb7:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102eb9:	b8 10 00 00 00       	mov    $0x10,%eax
  102ebe:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102ec0:	b8 10 00 00 00       	mov    $0x10,%eax
  102ec5:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102ec7:	ea ce 2e 10 00 08 00 	ljmp   $0x8,$0x102ece
}
  102ece:	90                   	nop
  102ecf:	5d                   	pop    %ebp
  102ed0:	c3                   	ret    

00102ed1 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  102ed1:	55                   	push   %ebp
  102ed2:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  102ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  102ed7:	a3 c4 de 11 00       	mov    %eax,0x11dec4
}
  102edc:	90                   	nop
  102edd:	5d                   	pop    %ebp
  102ede:	c3                   	ret    

00102edf <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102edf:	55                   	push   %ebp
  102ee0:	89 e5                	mov    %esp,%ebp
  102ee2:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  102ee5:	b8 00 a0 11 00       	mov    $0x11a000,%eax
  102eea:	89 04 24             	mov    %eax,(%esp)
  102eed:	e8 df ff ff ff       	call   102ed1 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  102ef2:	66 c7 05 c8 de 11 00 	movw   $0x10,0x11dec8
  102ef9:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  102efb:	66 c7 05 28 aa 11 00 	movw   $0x68,0x11aa28
  102f02:	68 00 
  102f04:	b8 c0 de 11 00       	mov    $0x11dec0,%eax
  102f09:	0f b7 c0             	movzwl %ax,%eax
  102f0c:	66 a3 2a aa 11 00    	mov    %ax,0x11aa2a
  102f12:	b8 c0 de 11 00       	mov    $0x11dec0,%eax
  102f17:	c1 e8 10             	shr    $0x10,%eax
  102f1a:	a2 2c aa 11 00       	mov    %al,0x11aa2c
  102f1f:	0f b6 05 2d aa 11 00 	movzbl 0x11aa2d,%eax
  102f26:	24 f0                	and    $0xf0,%al
  102f28:	0c 09                	or     $0x9,%al
  102f2a:	a2 2d aa 11 00       	mov    %al,0x11aa2d
  102f2f:	0f b6 05 2d aa 11 00 	movzbl 0x11aa2d,%eax
  102f36:	24 ef                	and    $0xef,%al
  102f38:	a2 2d aa 11 00       	mov    %al,0x11aa2d
  102f3d:	0f b6 05 2d aa 11 00 	movzbl 0x11aa2d,%eax
  102f44:	24 9f                	and    $0x9f,%al
  102f46:	a2 2d aa 11 00       	mov    %al,0x11aa2d
  102f4b:	0f b6 05 2d aa 11 00 	movzbl 0x11aa2d,%eax
  102f52:	0c 80                	or     $0x80,%al
  102f54:	a2 2d aa 11 00       	mov    %al,0x11aa2d
  102f59:	0f b6 05 2e aa 11 00 	movzbl 0x11aa2e,%eax
  102f60:	24 f0                	and    $0xf0,%al
  102f62:	a2 2e aa 11 00       	mov    %al,0x11aa2e
  102f67:	0f b6 05 2e aa 11 00 	movzbl 0x11aa2e,%eax
  102f6e:	24 ef                	and    $0xef,%al
  102f70:	a2 2e aa 11 00       	mov    %al,0x11aa2e
  102f75:	0f b6 05 2e aa 11 00 	movzbl 0x11aa2e,%eax
  102f7c:	24 df                	and    $0xdf,%al
  102f7e:	a2 2e aa 11 00       	mov    %al,0x11aa2e
  102f83:	0f b6 05 2e aa 11 00 	movzbl 0x11aa2e,%eax
  102f8a:	0c 40                	or     $0x40,%al
  102f8c:	a2 2e aa 11 00       	mov    %al,0x11aa2e
  102f91:	0f b6 05 2e aa 11 00 	movzbl 0x11aa2e,%eax
  102f98:	24 7f                	and    $0x7f,%al
  102f9a:	a2 2e aa 11 00       	mov    %al,0x11aa2e
  102f9f:	b8 c0 de 11 00       	mov    $0x11dec0,%eax
  102fa4:	c1 e8 18             	shr    $0x18,%eax
  102fa7:	a2 2f aa 11 00       	mov    %al,0x11aa2f

    // reload all segment registers
    lgdt(&gdt_pd);
  102fac:	c7 04 24 30 aa 11 00 	movl   $0x11aa30,(%esp)
  102fb3:	e8 e3 fe ff ff       	call   102e9b <lgdt>
  102fb8:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  102fbe:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102fc2:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  102fc5:	90                   	nop
  102fc6:	c9                   	leave  
  102fc7:	c3                   	ret    

00102fc8 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  102fc8:	55                   	push   %ebp
  102fc9:	89 e5                	mov    %esp,%ebp
  102fcb:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
  102fce:	c7 05 30 df 11 00 70 	movl   $0x107b70,0x11df30
  102fd5:	7b 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  102fd8:	a1 30 df 11 00       	mov    0x11df30,%eax
  102fdd:	8b 00                	mov    (%eax),%eax
  102fdf:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fe3:	c7 04 24 b0 70 10 00 	movl   $0x1070b0,(%esp)
  102fea:	e8 9f d2 ff ff       	call   10028e <cprintf>
    pmm_manager->init();
  102fef:	a1 30 df 11 00       	mov    0x11df30,%eax
  102ff4:	8b 40 04             	mov    0x4(%eax),%eax
  102ff7:	ff d0                	call   *%eax
}
  102ff9:	90                   	nop
  102ffa:	c9                   	leave  
  102ffb:	c3                   	ret    

00102ffc <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  102ffc:	55                   	push   %ebp
  102ffd:	89 e5                	mov    %esp,%ebp
  102fff:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  103002:	a1 30 df 11 00       	mov    0x11df30,%eax
  103007:	8b 40 08             	mov    0x8(%eax),%eax
  10300a:	8b 55 0c             	mov    0xc(%ebp),%edx
  10300d:	89 54 24 04          	mov    %edx,0x4(%esp)
  103011:	8b 55 08             	mov    0x8(%ebp),%edx
  103014:	89 14 24             	mov    %edx,(%esp)
  103017:	ff d0                	call   *%eax
}
  103019:	90                   	nop
  10301a:	c9                   	leave  
  10301b:	c3                   	ret    

0010301c <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  10301c:	55                   	push   %ebp
  10301d:	89 e5                	mov    %esp,%ebp
  10301f:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  103022:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  103029:	e8 2f fe ff ff       	call   102e5d <__intr_save>
  10302e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  103031:	a1 30 df 11 00       	mov    0x11df30,%eax
  103036:	8b 40 0c             	mov    0xc(%eax),%eax
  103039:	8b 55 08             	mov    0x8(%ebp),%edx
  10303c:	89 14 24             	mov    %edx,(%esp)
  10303f:	ff d0                	call   *%eax
  103041:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  103044:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103047:	89 04 24             	mov    %eax,(%esp)
  10304a:	e8 38 fe ff ff       	call   102e87 <__intr_restore>
    return page;
  10304f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103052:	c9                   	leave  
  103053:	c3                   	ret    

00103054 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  103054:	55                   	push   %ebp
  103055:	89 e5                	mov    %esp,%ebp
  103057:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  10305a:	e8 fe fd ff ff       	call   102e5d <__intr_save>
  10305f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  103062:	a1 30 df 11 00       	mov    0x11df30,%eax
  103067:	8b 40 10             	mov    0x10(%eax),%eax
  10306a:	8b 55 0c             	mov    0xc(%ebp),%edx
  10306d:	89 54 24 04          	mov    %edx,0x4(%esp)
  103071:	8b 55 08             	mov    0x8(%ebp),%edx
  103074:	89 14 24             	mov    %edx,(%esp)
  103077:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  103079:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10307c:	89 04 24             	mov    %eax,(%esp)
  10307f:	e8 03 fe ff ff       	call   102e87 <__intr_restore>
}
  103084:	90                   	nop
  103085:	c9                   	leave  
  103086:	c3                   	ret    

00103087 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  103087:	55                   	push   %ebp
  103088:	89 e5                	mov    %esp,%ebp
  10308a:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  10308d:	e8 cb fd ff ff       	call   102e5d <__intr_save>
  103092:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  103095:	a1 30 df 11 00       	mov    0x11df30,%eax
  10309a:	8b 40 14             	mov    0x14(%eax),%eax
  10309d:	ff d0                	call   *%eax
  10309f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  1030a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1030a5:	89 04 24             	mov    %eax,(%esp)
  1030a8:	e8 da fd ff ff       	call   102e87 <__intr_restore>
    return ret;
  1030ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1030b0:	c9                   	leave  
  1030b1:	c3                   	ret    

001030b2 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  1030b2:	55                   	push   %ebp
  1030b3:	89 e5                	mov    %esp,%ebp
  1030b5:	57                   	push   %edi
  1030b6:	56                   	push   %esi
  1030b7:	53                   	push   %ebx
  1030b8:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  1030be:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  1030c5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  1030cc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  1030d3:	c7 04 24 c7 70 10 00 	movl   $0x1070c7,(%esp)
  1030da:	e8 af d1 ff ff       	call   10028e <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  1030df:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1030e6:	e9 1a 01 00 00       	jmp    103205 <page_init+0x153>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  1030eb:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1030ee:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1030f1:	89 d0                	mov    %edx,%eax
  1030f3:	c1 e0 02             	shl    $0x2,%eax
  1030f6:	01 d0                	add    %edx,%eax
  1030f8:	c1 e0 02             	shl    $0x2,%eax
  1030fb:	01 c8                	add    %ecx,%eax
  1030fd:	8b 50 08             	mov    0x8(%eax),%edx
  103100:	8b 40 04             	mov    0x4(%eax),%eax
  103103:	89 45 b8             	mov    %eax,-0x48(%ebp)
  103106:	89 55 bc             	mov    %edx,-0x44(%ebp)
  103109:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10310c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10310f:	89 d0                	mov    %edx,%eax
  103111:	c1 e0 02             	shl    $0x2,%eax
  103114:	01 d0                	add    %edx,%eax
  103116:	c1 e0 02             	shl    $0x2,%eax
  103119:	01 c8                	add    %ecx,%eax
  10311b:	8b 48 0c             	mov    0xc(%eax),%ecx
  10311e:	8b 58 10             	mov    0x10(%eax),%ebx
  103121:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103124:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103127:	01 c8                	add    %ecx,%eax
  103129:	11 da                	adc    %ebx,%edx
  10312b:	89 45 b0             	mov    %eax,-0x50(%ebp)
  10312e:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  103131:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103134:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103137:	89 d0                	mov    %edx,%eax
  103139:	c1 e0 02             	shl    $0x2,%eax
  10313c:	01 d0                	add    %edx,%eax
  10313e:	c1 e0 02             	shl    $0x2,%eax
  103141:	01 c8                	add    %ecx,%eax
  103143:	83 c0 14             	add    $0x14,%eax
  103146:	8b 00                	mov    (%eax),%eax
  103148:	89 45 84             	mov    %eax,-0x7c(%ebp)
  10314b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  10314e:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103151:	83 c0 ff             	add    $0xffffffff,%eax
  103154:	83 d2 ff             	adc    $0xffffffff,%edx
  103157:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
  10315d:	89 95 7c ff ff ff    	mov    %edx,-0x84(%ebp)
  103163:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103166:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103169:	89 d0                	mov    %edx,%eax
  10316b:	c1 e0 02             	shl    $0x2,%eax
  10316e:	01 d0                	add    %edx,%eax
  103170:	c1 e0 02             	shl    $0x2,%eax
  103173:	01 c8                	add    %ecx,%eax
  103175:	8b 48 0c             	mov    0xc(%eax),%ecx
  103178:	8b 58 10             	mov    0x10(%eax),%ebx
  10317b:	8b 55 84             	mov    -0x7c(%ebp),%edx
  10317e:	89 54 24 1c          	mov    %edx,0x1c(%esp)
  103182:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  103188:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
  10318e:	89 44 24 14          	mov    %eax,0x14(%esp)
  103192:	89 54 24 18          	mov    %edx,0x18(%esp)
  103196:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103199:	8b 55 bc             	mov    -0x44(%ebp),%edx
  10319c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1031a0:	89 54 24 10          	mov    %edx,0x10(%esp)
  1031a4:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  1031a8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  1031ac:	c7 04 24 d4 70 10 00 	movl   $0x1070d4,(%esp)
  1031b3:	e8 d6 d0 ff ff       	call   10028e <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  1031b8:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1031bb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1031be:	89 d0                	mov    %edx,%eax
  1031c0:	c1 e0 02             	shl    $0x2,%eax
  1031c3:	01 d0                	add    %edx,%eax
  1031c5:	c1 e0 02             	shl    $0x2,%eax
  1031c8:	01 c8                	add    %ecx,%eax
  1031ca:	83 c0 14             	add    $0x14,%eax
  1031cd:	8b 00                	mov    (%eax),%eax
  1031cf:	83 f8 01             	cmp    $0x1,%eax
  1031d2:	75 2e                	jne    103202 <page_init+0x150>
            if (maxpa < end && begin < KMEMSIZE) {
  1031d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1031d7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1031da:	3b 45 b0             	cmp    -0x50(%ebp),%eax
  1031dd:	89 d0                	mov    %edx,%eax
  1031df:	1b 45 b4             	sbb    -0x4c(%ebp),%eax
  1031e2:	73 1e                	jae    103202 <page_init+0x150>
  1031e4:	ba ff ff ff 37       	mov    $0x37ffffff,%edx
  1031e9:	b8 00 00 00 00       	mov    $0x0,%eax
  1031ee:	3b 55 b8             	cmp    -0x48(%ebp),%edx
  1031f1:	1b 45 bc             	sbb    -0x44(%ebp),%eax
  1031f4:	72 0c                	jb     103202 <page_init+0x150>
                maxpa = end;
  1031f6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1031f9:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  1031fc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1031ff:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
  103202:	ff 45 dc             	incl   -0x24(%ebp)
  103205:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103208:	8b 00                	mov    (%eax),%eax
  10320a:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  10320d:	0f 8c d8 fe ff ff    	jl     1030eb <page_init+0x39>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  103213:	ba 00 00 00 38       	mov    $0x38000000,%edx
  103218:	b8 00 00 00 00       	mov    $0x0,%eax
  10321d:	3b 55 e0             	cmp    -0x20(%ebp),%edx
  103220:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  103223:	73 0e                	jae    103233 <page_init+0x181>
        maxpa = KMEMSIZE;
  103225:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  10322c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  103233:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103236:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103239:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  10323d:	c1 ea 0c             	shr    $0xc,%edx
  103240:	89 c1                	mov    %eax,%ecx
  103242:	89 d3                	mov    %edx,%ebx
  103244:	89 c8                	mov    %ecx,%eax
  103246:	a3 a0 de 11 00       	mov    %eax,0x11dea0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  10324b:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  103252:	b8 48 df 11 00       	mov    $0x11df48,%eax
  103257:	8d 50 ff             	lea    -0x1(%eax),%edx
  10325a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  10325d:	01 d0                	add    %edx,%eax
  10325f:	89 45 a8             	mov    %eax,-0x58(%ebp)
  103262:	8b 45 a8             	mov    -0x58(%ebp),%eax
  103265:	ba 00 00 00 00       	mov    $0x0,%edx
  10326a:	f7 75 ac             	divl   -0x54(%ebp)
  10326d:	8b 45 a8             	mov    -0x58(%ebp),%eax
  103270:	29 d0                	sub    %edx,%eax
  103272:	a3 38 df 11 00       	mov    %eax,0x11df38

    for (i = 0; i < npage; i ++) {
  103277:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  10327e:	eb 2e                	jmp    1032ae <page_init+0x1fc>
        SetPageReserved(pages + i);
  103280:	8b 0d 38 df 11 00    	mov    0x11df38,%ecx
  103286:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103289:	89 d0                	mov    %edx,%eax
  10328b:	c1 e0 02             	shl    $0x2,%eax
  10328e:	01 d0                	add    %edx,%eax
  103290:	c1 e0 02             	shl    $0x2,%eax
  103293:	01 c8                	add    %ecx,%eax
  103295:	83 c0 04             	add    $0x4,%eax
  103298:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
  10329f:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1032a2:	8b 45 8c             	mov    -0x74(%ebp),%eax
  1032a5:	8b 55 90             	mov    -0x70(%ebp),%edx
  1032a8:	0f ab 10             	bts    %edx,(%eax)
    for (i = 0; i < npage; i ++) {
  1032ab:	ff 45 dc             	incl   -0x24(%ebp)
  1032ae:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1032b1:	a1 a0 de 11 00       	mov    0x11dea0,%eax
  1032b6:	39 c2                	cmp    %eax,%edx
  1032b8:	72 c6                	jb     103280 <page_init+0x1ce>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  1032ba:	8b 15 a0 de 11 00    	mov    0x11dea0,%edx
  1032c0:	89 d0                	mov    %edx,%eax
  1032c2:	c1 e0 02             	shl    $0x2,%eax
  1032c5:	01 d0                	add    %edx,%eax
  1032c7:	c1 e0 02             	shl    $0x2,%eax
  1032ca:	89 c2                	mov    %eax,%edx
  1032cc:	a1 38 df 11 00       	mov    0x11df38,%eax
  1032d1:	01 d0                	add    %edx,%eax
  1032d3:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  1032d6:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
  1032dd:	77 23                	ja     103302 <page_init+0x250>
  1032df:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  1032e2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1032e6:	c7 44 24 08 04 71 10 	movl   $0x107104,0x8(%esp)
  1032ed:	00 
  1032ee:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
  1032f5:	00 
  1032f6:	c7 04 24 28 71 10 00 	movl   $0x107128,(%esp)
  1032fd:	e8 e4 d0 ff ff       	call   1003e6 <__panic>
  103302:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  103305:	05 00 00 00 40       	add    $0x40000000,%eax
  10330a:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  10330d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103314:	e9 53 01 00 00       	jmp    10346c <page_init+0x3ba>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  103319:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10331c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10331f:	89 d0                	mov    %edx,%eax
  103321:	c1 e0 02             	shl    $0x2,%eax
  103324:	01 d0                	add    %edx,%eax
  103326:	c1 e0 02             	shl    $0x2,%eax
  103329:	01 c8                	add    %ecx,%eax
  10332b:	8b 50 08             	mov    0x8(%eax),%edx
  10332e:	8b 40 04             	mov    0x4(%eax),%eax
  103331:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103334:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  103337:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10333a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10333d:	89 d0                	mov    %edx,%eax
  10333f:	c1 e0 02             	shl    $0x2,%eax
  103342:	01 d0                	add    %edx,%eax
  103344:	c1 e0 02             	shl    $0x2,%eax
  103347:	01 c8                	add    %ecx,%eax
  103349:	8b 48 0c             	mov    0xc(%eax),%ecx
  10334c:	8b 58 10             	mov    0x10(%eax),%ebx
  10334f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103352:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103355:	01 c8                	add    %ecx,%eax
  103357:	11 da                	adc    %ebx,%edx
  103359:	89 45 c8             	mov    %eax,-0x38(%ebp)
  10335c:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  10335f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103362:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103365:	89 d0                	mov    %edx,%eax
  103367:	c1 e0 02             	shl    $0x2,%eax
  10336a:	01 d0                	add    %edx,%eax
  10336c:	c1 e0 02             	shl    $0x2,%eax
  10336f:	01 c8                	add    %ecx,%eax
  103371:	83 c0 14             	add    $0x14,%eax
  103374:	8b 00                	mov    (%eax),%eax
  103376:	83 f8 01             	cmp    $0x1,%eax
  103379:	0f 85 ea 00 00 00    	jne    103469 <page_init+0x3b7>
            if (begin < freemem) {
  10337f:	8b 45 a0             	mov    -0x60(%ebp),%eax
  103382:	ba 00 00 00 00       	mov    $0x0,%edx
  103387:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  10338a:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  10338d:	19 d1                	sbb    %edx,%ecx
  10338f:	73 0d                	jae    10339e <page_init+0x2ec>
                begin = freemem;
  103391:	8b 45 a0             	mov    -0x60(%ebp),%eax
  103394:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103397:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  10339e:	ba 00 00 00 38       	mov    $0x38000000,%edx
  1033a3:	b8 00 00 00 00       	mov    $0x0,%eax
  1033a8:	3b 55 c8             	cmp    -0x38(%ebp),%edx
  1033ab:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  1033ae:	73 0e                	jae    1033be <page_init+0x30c>
                end = KMEMSIZE;
  1033b0:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  1033b7:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  1033be:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1033c1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1033c4:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  1033c7:	89 d0                	mov    %edx,%eax
  1033c9:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  1033cc:	0f 83 97 00 00 00    	jae    103469 <page_init+0x3b7>
                begin = ROUNDUP(begin, PGSIZE);
  1033d2:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
  1033d9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1033dc:	8b 45 9c             	mov    -0x64(%ebp),%eax
  1033df:	01 d0                	add    %edx,%eax
  1033e1:	48                   	dec    %eax
  1033e2:	89 45 98             	mov    %eax,-0x68(%ebp)
  1033e5:	8b 45 98             	mov    -0x68(%ebp),%eax
  1033e8:	ba 00 00 00 00       	mov    $0x0,%edx
  1033ed:	f7 75 9c             	divl   -0x64(%ebp)
  1033f0:	8b 45 98             	mov    -0x68(%ebp),%eax
  1033f3:	29 d0                	sub    %edx,%eax
  1033f5:	ba 00 00 00 00       	mov    $0x0,%edx
  1033fa:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1033fd:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  103400:	8b 45 c8             	mov    -0x38(%ebp),%eax
  103403:	89 45 94             	mov    %eax,-0x6c(%ebp)
  103406:	8b 45 94             	mov    -0x6c(%ebp),%eax
  103409:	ba 00 00 00 00       	mov    $0x0,%edx
  10340e:	89 c3                	mov    %eax,%ebx
  103410:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  103416:	89 de                	mov    %ebx,%esi
  103418:	89 d0                	mov    %edx,%eax
  10341a:	83 e0 00             	and    $0x0,%eax
  10341d:	89 c7                	mov    %eax,%edi
  10341f:	89 75 c8             	mov    %esi,-0x38(%ebp)
  103422:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
  103425:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103428:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10342b:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  10342e:	89 d0                	mov    %edx,%eax
  103430:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  103433:	73 34                	jae    103469 <page_init+0x3b7>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  103435:	8b 45 c8             	mov    -0x38(%ebp),%eax
  103438:	8b 55 cc             	mov    -0x34(%ebp),%edx
  10343b:	2b 45 d0             	sub    -0x30(%ebp),%eax
  10343e:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
  103441:	89 c1                	mov    %eax,%ecx
  103443:	89 d3                	mov    %edx,%ebx
  103445:	89 c8                	mov    %ecx,%eax
  103447:	89 da                	mov    %ebx,%edx
  103449:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  10344d:	c1 ea 0c             	shr    $0xc,%edx
  103450:	89 c3                	mov    %eax,%ebx
  103452:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103455:	89 04 24             	mov    %eax,(%esp)
  103458:	e8 c1 f8 ff ff       	call   102d1e <pa2page>
  10345d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  103461:	89 04 24             	mov    %eax,(%esp)
  103464:	e8 93 fb ff ff       	call   102ffc <init_memmap>
    for (i = 0; i < memmap->nr_map; i ++) {
  103469:	ff 45 dc             	incl   -0x24(%ebp)
  10346c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  10346f:	8b 00                	mov    (%eax),%eax
  103471:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  103474:	0f 8c 9f fe ff ff    	jl     103319 <page_init+0x267>
                }
            }
        }
    }
}
  10347a:	90                   	nop
  10347b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  103481:	5b                   	pop    %ebx
  103482:	5e                   	pop    %esi
  103483:	5f                   	pop    %edi
  103484:	5d                   	pop    %ebp
  103485:	c3                   	ret    

00103486 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  103486:	55                   	push   %ebp
  103487:	89 e5                	mov    %esp,%ebp
  103489:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  10348c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10348f:	33 45 14             	xor    0x14(%ebp),%eax
  103492:	25 ff 0f 00 00       	and    $0xfff,%eax
  103497:	85 c0                	test   %eax,%eax
  103499:	74 24                	je     1034bf <boot_map_segment+0x39>
  10349b:	c7 44 24 0c 36 71 10 	movl   $0x107136,0xc(%esp)
  1034a2:	00 
  1034a3:	c7 44 24 08 4d 71 10 	movl   $0x10714d,0x8(%esp)
  1034aa:	00 
  1034ab:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  1034b2:	00 
  1034b3:	c7 04 24 28 71 10 00 	movl   $0x107128,(%esp)
  1034ba:	e8 27 cf ff ff       	call   1003e6 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  1034bf:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  1034c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034c9:	25 ff 0f 00 00       	and    $0xfff,%eax
  1034ce:	89 c2                	mov    %eax,%edx
  1034d0:	8b 45 10             	mov    0x10(%ebp),%eax
  1034d3:	01 c2                	add    %eax,%edx
  1034d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1034d8:	01 d0                	add    %edx,%eax
  1034da:	48                   	dec    %eax
  1034db:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1034de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1034e1:	ba 00 00 00 00       	mov    $0x0,%edx
  1034e6:	f7 75 f0             	divl   -0x10(%ebp)
  1034e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1034ec:	29 d0                	sub    %edx,%eax
  1034ee:	c1 e8 0c             	shr    $0xc,%eax
  1034f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  1034f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034f7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1034fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1034fd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103502:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  103505:	8b 45 14             	mov    0x14(%ebp),%eax
  103508:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10350b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10350e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103513:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  103516:	eb 68                	jmp    103580 <boot_map_segment+0xfa>
        pte_t *ptep = get_pte(pgdir, la, 1);
  103518:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  10351f:	00 
  103520:	8b 45 0c             	mov    0xc(%ebp),%eax
  103523:	89 44 24 04          	mov    %eax,0x4(%esp)
  103527:	8b 45 08             	mov    0x8(%ebp),%eax
  10352a:	89 04 24             	mov    %eax,(%esp)
  10352d:	e8 81 01 00 00       	call   1036b3 <get_pte>
  103532:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  103535:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  103539:	75 24                	jne    10355f <boot_map_segment+0xd9>
  10353b:	c7 44 24 0c 62 71 10 	movl   $0x107162,0xc(%esp)
  103542:	00 
  103543:	c7 44 24 08 4d 71 10 	movl   $0x10714d,0x8(%esp)
  10354a:	00 
  10354b:	c7 44 24 04 05 01 00 	movl   $0x105,0x4(%esp)
  103552:	00 
  103553:	c7 04 24 28 71 10 00 	movl   $0x107128,(%esp)
  10355a:	e8 87 ce ff ff       	call   1003e6 <__panic>
        *ptep = pa | PTE_P | perm;
  10355f:	8b 45 14             	mov    0x14(%ebp),%eax
  103562:	0b 45 18             	or     0x18(%ebp),%eax
  103565:	83 c8 01             	or     $0x1,%eax
  103568:	89 c2                	mov    %eax,%edx
  10356a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10356d:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  10356f:	ff 4d f4             	decl   -0xc(%ebp)
  103572:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  103579:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  103580:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103584:	75 92                	jne    103518 <boot_map_segment+0x92>
    }
}
  103586:	90                   	nop
  103587:	c9                   	leave  
  103588:	c3                   	ret    

00103589 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  103589:	55                   	push   %ebp
  10358a:	89 e5                	mov    %esp,%ebp
  10358c:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  10358f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103596:	e8 81 fa ff ff       	call   10301c <alloc_pages>
  10359b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  10359e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1035a2:	75 1c                	jne    1035c0 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
  1035a4:	c7 44 24 08 6f 71 10 	movl   $0x10716f,0x8(%esp)
  1035ab:	00 
  1035ac:	c7 44 24 04 11 01 00 	movl   $0x111,0x4(%esp)
  1035b3:	00 
  1035b4:	c7 04 24 28 71 10 00 	movl   $0x107128,(%esp)
  1035bb:	e8 26 ce ff ff       	call   1003e6 <__panic>
    }
    return page2kva(p);
  1035c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1035c3:	89 04 24             	mov    %eax,(%esp)
  1035c6:	e8 a2 f7 ff ff       	call   102d6d <page2kva>
}
  1035cb:	c9                   	leave  
  1035cc:	c3                   	ret    

001035cd <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  1035cd:	55                   	push   %ebp
  1035ce:	89 e5                	mov    %esp,%ebp
  1035d0:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
  1035d3:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  1035d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1035db:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  1035e2:	77 23                	ja     103607 <pmm_init+0x3a>
  1035e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1035e7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1035eb:	c7 44 24 08 04 71 10 	movl   $0x107104,0x8(%esp)
  1035f2:	00 
  1035f3:	c7 44 24 04 1b 01 00 	movl   $0x11b,0x4(%esp)
  1035fa:	00 
  1035fb:	c7 04 24 28 71 10 00 	movl   $0x107128,(%esp)
  103602:	e8 df cd ff ff       	call   1003e6 <__panic>
  103607:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10360a:	05 00 00 00 40       	add    $0x40000000,%eax
  10360f:	a3 34 df 11 00       	mov    %eax,0x11df34
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  103614:	e8 af f9 ff ff       	call   102fc8 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  103619:	e8 94 fa ff ff       	call   1030b2 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  10361e:	e8 fb 05 00 00       	call   103c1e <check_alloc_page>

    check_pgdir();
  103623:	e8 15 06 00 00       	call   103c3d <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  103628:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  10362d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103630:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  103637:	77 23                	ja     10365c <pmm_init+0x8f>
  103639:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10363c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103640:	c7 44 24 08 04 71 10 	movl   $0x107104,0x8(%esp)
  103647:	00 
  103648:	c7 44 24 04 31 01 00 	movl   $0x131,0x4(%esp)
  10364f:	00 
  103650:	c7 04 24 28 71 10 00 	movl   $0x107128,(%esp)
  103657:	e8 8a cd ff ff       	call   1003e6 <__panic>
  10365c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10365f:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
  103665:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  10366a:	05 ac 0f 00 00       	add    $0xfac,%eax
  10366f:	83 ca 03             	or     $0x3,%edx
  103672:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  103674:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  103679:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  103680:	00 
  103681:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  103688:	00 
  103689:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  103690:	38 
  103691:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  103698:	c0 
  103699:	89 04 24             	mov    %eax,(%esp)
  10369c:	e8 e5 fd ff ff       	call   103486 <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  1036a1:	e8 39 f8 ff ff       	call   102edf <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  1036a6:	e8 2e 0c 00 00       	call   1042d9 <check_boot_pgdir>

    print_pgdir();
  1036ab:	e8 a7 10 00 00       	call   104757 <print_pgdir>

}
  1036b0:	90                   	nop
  1036b1:	c9                   	leave  
  1036b2:	c3                   	ret    

001036b3 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  1036b3:	55                   	push   %ebp
  1036b4:	89 e5                	mov    %esp,%ebp
  1036b6:	83 ec 68             	sub    $0x68,%esp
     *   PTE_W           0x002                   // page table/directory entry flags bit : Writeable
     *   PTE_U           0x004                   // page table/directory entry flags bit : User can access
     */
	
// #if 0
	assert(pgdir != NULL);
  1036b9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1036bd:	75 24                	jne    1036e3 <get_pte+0x30>
  1036bf:	c7 44 24 0c 88 71 10 	movl   $0x107188,0xc(%esp)
  1036c6:	00 
  1036c7:	c7 44 24 08 4d 71 10 	movl   $0x10714d,0x8(%esp)
  1036ce:	00 
  1036cf:	c7 44 24 04 65 01 00 	movl   $0x165,0x4(%esp)
  1036d6:	00 
  1036d7:	c7 04 24 28 71 10 00 	movl   $0x107128,(%esp)
  1036de:	e8 03 cd ff ff       	call   1003e6 <__panic>
	struct Page *struct_page_vp;	// virtual address of struct page
	uint32_t pdx = PDX(la), ptx = PTX(la);	// index of PDE, PTE
  1036e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1036e6:	c1 e8 16             	shr    $0x16,%eax
  1036e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1036ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  1036ef:	c1 e8 0c             	shr    $0xc,%eax
  1036f2:	25 ff 03 00 00       	and    $0x3ff,%eax
  1036f7:	89 45 f0             	mov    %eax,-0x10(%ebp)

    pde_t *pdep, *ptep;   // (1) find page directory entry
	pte_t *page_pa;			// physical address of page
	pdep = pgdir + pdx;
  1036fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1036fd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  103704:	8b 45 08             	mov    0x8(%ebp),%eax
  103707:	01 d0                	add    %edx,%eax
  103709:	89 45 ec             	mov    %eax,-0x14(%ebp)
	ptep = (pte_t *)KADDR(PDE_ADDR(*pdep)) + ptx;
  10370c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10370f:	8b 00                	mov    (%eax),%eax
  103711:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103716:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103719:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10371c:	c1 e8 0c             	shr    $0xc,%eax
  10371f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103722:	a1 a0 de 11 00       	mov    0x11dea0,%eax
  103727:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  10372a:	72 23                	jb     10374f <get_pte+0x9c>
  10372c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10372f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103733:	c7 44 24 08 60 70 10 	movl   $0x107060,0x8(%esp)
  10373a:	00 
  10373b:	c7 44 24 04 6c 01 00 	movl   $0x16c,0x4(%esp)
  103742:	00 
  103743:	c7 04 24 28 71 10 00 	movl   $0x107128,(%esp)
  10374a:	e8 97 cc ff ff       	call   1003e6 <__panic>
  10374f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103752:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103757:	89 c2                	mov    %eax,%edx
  103759:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10375c:	c1 e0 02             	shl    $0x2,%eax
  10375f:	01 d0                	add    %edx,%eax
  103761:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103764:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  10376b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10376e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103771:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103774:	8b 55 c8             	mov    -0x38(%ebp),%edx
  103777:	0f a3 10             	bt     %edx,(%eax)
  10377a:	19 c0                	sbb    %eax,%eax
  10377c:	89 45 c0             	mov    %eax,-0x40(%ebp)
    return oldbit != 0;
  10377f:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  103783:	0f 95 c0             	setne  %al
  103786:	0f b6 c0             	movzbl %al,%eax

	// if PDE exists 
	if (test_bit(0, pdep)) {
  103789:	85 c0                	test   %eax,%eax
  10378b:	74 08                	je     103795 <get_pte+0xe2>
		return ptep;
  10378d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103790:	e9 4d 01 00 00       	jmp    1038e2 <get_pte+0x22f>
  103795:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
  10379c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10379f:	89 45 b8             	mov    %eax,-0x48(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1037a2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  1037a5:	8b 55 bc             	mov    -0x44(%ebp),%edx
  1037a8:	0f a3 10             	bt     %edx,(%eax)
  1037ab:	19 c0                	sbb    %eax,%eax
  1037ad:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    return oldbit != 0;
  1037b0:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  1037b4:	0f 95 c0             	setne  %al
  1037b7:	0f b6 c0             	movzbl %al,%eax
	}
	/* if PDE not exsits, allocate one page for PT and create corresponding PDE */
    if ((!test_bit(0, pdep)) && create) {              // (2) check if entry is not present
  1037ba:	85 c0                	test   %eax,%eax
  1037bc:	0f 85 1b 01 00 00    	jne    1038dd <get_pte+0x22a>
  1037c2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1037c6:	0f 84 11 01 00 00    	je     1038dd <get_pte+0x22a>
		struct_page_vp = alloc_page();
  1037cc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1037d3:	e8 44 f8 ff ff       	call   10301c <alloc_pages>
  1037d8:	89 45 dc             	mov    %eax,-0x24(%ebp)
		assert(struct_page_vp != NULL);
  1037db:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  1037df:	75 24                	jne    103805 <get_pte+0x152>
  1037e1:	c7 44 24 0c 96 71 10 	movl   $0x107196,0xc(%esp)
  1037e8:	00 
  1037e9:	c7 44 24 08 4d 71 10 	movl   $0x10714d,0x8(%esp)
  1037f0:	00 
  1037f1:	c7 44 24 04 75 01 00 	movl   $0x175,0x4(%esp)
  1037f8:	00 
  1037f9:	c7 04 24 28 71 10 00 	movl   $0x107128,(%esp)
  103800:	e8 e1 cb ff ff       	call   1003e6 <__panic>
		set_page_ref(struct_page_vp, 1);
  103805:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10380c:	00 
  10380d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103810:	89 04 24             	mov    %eax,(%esp)
  103813:	e8 09 f6 ff ff       	call   102e21 <set_page_ref>
		page_pa = (pte_t *)page2pa(struct_page_vp);
  103818:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10381b:	89 04 24             	mov    %eax,(%esp)
  10381e:	e8 e5 f4 ff ff       	call   102d08 <page2pa>
  103823:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptep = KADDR(page_pa + ptx);
  103826:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103829:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  103830:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103833:	01 d0                	add    %edx,%eax
  103835:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  103838:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10383b:	c1 e8 0c             	shr    $0xc,%eax
  10383e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103841:	a1 a0 de 11 00       	mov    0x11dea0,%eax
  103846:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  103849:	72 23                	jb     10386e <get_pte+0x1bb>
  10384b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10384e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103852:	c7 44 24 08 60 70 10 	movl   $0x107060,0x8(%esp)
  103859:	00 
  10385a:	c7 44 24 04 78 01 00 	movl   $0x178,0x4(%esp)
  103861:	00 
  103862:	c7 04 24 28 71 10 00 	movl   $0x107128,(%esp)
  103869:	e8 78 cb ff ff       	call   1003e6 <__panic>
  10386e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  103871:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103876:	89 45 e0             	mov    %eax,-0x20(%ebp)
		*pdep = (PADDR(ptep)) | PTE_P | PTE_U | PTE_W;
  103879:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10387c:	89 45 cc             	mov    %eax,-0x34(%ebp)
  10387f:	81 7d cc ff ff ff bf 	cmpl   $0xbfffffff,-0x34(%ebp)
  103886:	77 23                	ja     1038ab <get_pte+0x1f8>
  103888:	8b 45 cc             	mov    -0x34(%ebp),%eax
  10388b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10388f:	c7 44 24 08 04 71 10 	movl   $0x107104,0x8(%esp)
  103896:	00 
  103897:	c7 44 24 04 79 01 00 	movl   $0x179,0x4(%esp)
  10389e:	00 
  10389f:	c7 04 24 28 71 10 00 	movl   $0x107128,(%esp)
  1038a6:	e8 3b cb ff ff       	call   1003e6 <__panic>
  1038ab:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1038ae:	05 00 00 00 40       	add    $0x40000000,%eax
  1038b3:	83 c8 07             	or     $0x7,%eax
  1038b6:	89 c2                	mov    %eax,%edx
  1038b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1038bb:	89 10                	mov    %edx,(%eax)
		memset(ptep, 0, PGSIZE);
  1038bd:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  1038c4:	00 
  1038c5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1038cc:	00 
  1038cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1038d0:	89 04 24             	mov    %eax,(%esp)
  1038d3:	e8 fd 27 00 00       	call   1060d5 <memset>
		return ptep;
  1038d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1038db:	eb 05                	jmp    1038e2 <get_pte+0x22f>
							// (5) get linear address of page
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    
	// if PDE not exists and caller don't require get_pte allocate PTE.
    return NULL;          // (8) return page table entry
  1038dd:	b8 00 00 00 00       	mov    $0x0,%eax
// #endif
}
  1038e2:	c9                   	leave  
  1038e3:	c3                   	ret    

001038e4 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  1038e4:	55                   	push   %ebp
  1038e5:	89 e5                	mov    %esp,%ebp
  1038e7:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  1038ea:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1038f1:	00 
  1038f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1038f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1038f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1038fc:	89 04 24             	mov    %eax,(%esp)
  1038ff:	e8 af fd ff ff       	call   1036b3 <get_pte>
  103904:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  103907:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10390b:	74 08                	je     103915 <get_page+0x31>
        *ptep_store = ptep;
  10390d:	8b 45 10             	mov    0x10(%ebp),%eax
  103910:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103913:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  103915:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103919:	74 1b                	je     103936 <get_page+0x52>
  10391b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10391e:	8b 00                	mov    (%eax),%eax
  103920:	83 e0 01             	and    $0x1,%eax
  103923:	85 c0                	test   %eax,%eax
  103925:	74 0f                	je     103936 <get_page+0x52>
        return pte2page(*ptep);
  103927:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10392a:	8b 00                	mov    (%eax),%eax
  10392c:	89 04 24             	mov    %eax,(%esp)
  10392f:	e8 8d f4 ff ff       	call   102dc1 <pte2page>
  103934:	eb 05                	jmp    10393b <get_page+0x57>
    }
    return NULL;
  103936:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10393b:	c9                   	leave  
  10393c:	c3                   	ret    

0010393d <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  10393d:	55                   	push   %ebp
  10393e:	89 e5                	mov    %esp,%ebp
  103940:	83 ec 48             	sub    $0x48,%esp
     *                        edited are the ones currently in use by the processor.
     * DEFINEs:
     *   PTE_P           0x001                   // page table/directory entry flags bit : Present
     */
// #if 0
	assert(pgdir != NULL);
  103943:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103947:	75 24                	jne    10396d <page_remove_pte+0x30>
  103949:	c7 44 24 0c 88 71 10 	movl   $0x107188,0xc(%esp)
  103950:	00 
  103951:	c7 44 24 08 4d 71 10 	movl   $0x10714d,0x8(%esp)
  103958:	00 
  103959:	c7 44 24 04 b5 01 00 	movl   $0x1b5,0x4(%esp)
  103960:	00 
  103961:	c7 04 24 28 71 10 00 	movl   $0x107128,(%esp)
  103968:	e8 79 ca ff ff       	call   1003e6 <__panic>
	assert(ptep != NULL);
  10396d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103971:	75 24                	jne    103997 <page_remove_pte+0x5a>
  103973:	c7 44 24 0c 62 71 10 	movl   $0x107162,0xc(%esp)
  10397a:	00 
  10397b:	c7 44 24 08 4d 71 10 	movl   $0x10714d,0x8(%esp)
  103982:	00 
  103983:	c7 44 24 04 b6 01 00 	movl   $0x1b6,0x4(%esp)
  10398a:	00 
  10398b:	c7 04 24 28 71 10 00 	movl   $0x107128,(%esp)
  103992:	e8 4f ca ff ff       	call   1003e6 <__panic>
	pde_t *pdep = pgdir + PDX(la);
  103997:	8b 45 0c             	mov    0xc(%ebp),%eax
  10399a:	c1 e8 16             	shr    $0x16,%eax
  10399d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1039a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1039a7:	01 d0                	add    %edx,%eax
  1039a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	assert(PDE_ADDR(*pdep) == PADDR(ROUNDDOWN(ptep, PGSIZE)));
  1039ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1039af:	8b 00                	mov    (%eax),%eax
  1039b1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1039b6:	89 c2                	mov    %eax,%edx
  1039b8:	8b 45 10             	mov    0x10(%ebp),%eax
  1039bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1039be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1039c1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1039c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1039c9:	81 7d ec ff ff ff bf 	cmpl   $0xbfffffff,-0x14(%ebp)
  1039d0:	77 23                	ja     1039f5 <page_remove_pte+0xb8>
  1039d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1039d5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1039d9:	c7 44 24 08 04 71 10 	movl   $0x107104,0x8(%esp)
  1039e0:	00 
  1039e1:	c7 44 24 04 b8 01 00 	movl   $0x1b8,0x4(%esp)
  1039e8:	00 
  1039e9:	c7 04 24 28 71 10 00 	movl   $0x107128,(%esp)
  1039f0:	e8 f1 c9 ff ff       	call   1003e6 <__panic>
  1039f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1039f8:	05 00 00 00 40       	add    $0x40000000,%eax
  1039fd:	39 d0                	cmp    %edx,%eax
  1039ff:	74 24                	je     103a25 <page_remove_pte+0xe8>
  103a01:	c7 44 24 0c b0 71 10 	movl   $0x1071b0,0xc(%esp)
  103a08:	00 
  103a09:	c7 44 24 08 4d 71 10 	movl   $0x10714d,0x8(%esp)
  103a10:	00 
  103a11:	c7 44 24 04 b8 01 00 	movl   $0x1b8,0x4(%esp)
  103a18:	00 
  103a19:	c7 04 24 28 71 10 00 	movl   $0x107128,(%esp)
  103a20:	e8 c1 c9 ff ff       	call   1003e6 <__panic>
  103a25:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  103a2c:	8b 45 10             	mov    0x10(%ebp),%eax
  103a2f:	89 45 e0             	mov    %eax,-0x20(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103a32:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103a35:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103a38:	0f a3 10             	bt     %edx,(%eax)
  103a3b:	19 c0                	sbb    %eax,%eax
  103a3d:	89 45 dc             	mov    %eax,-0x24(%ebp)
    return oldbit != 0;
  103a40:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  103a44:	0f 95 c0             	setne  %al
  103a47:	0f b6 c0             	movzbl %al,%eax
    if (test_bit(0, ptep)) {                      //(1) check if this page table entry is present
  103a4a:	85 c0                	test   %eax,%eax
  103a4c:	74 67                	je     103ab5 <page_remove_pte+0x178>
        struct Page *page = pte2page(*ptep); //(2) find corresponding page to pte
  103a4e:	8b 45 10             	mov    0x10(%ebp),%eax
  103a51:	8b 00                	mov    (%eax),%eax
  103a53:	89 04 24             	mov    %eax,(%esp)
  103a56:	e8 66 f3 ff ff       	call   102dc1 <pte2page>
  103a5b:	89 45 e8             	mov    %eax,-0x18(%ebp)
        page_ref_dec(page);                          //(3) decrease page reference
  103a5e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103a61:	89 04 24             	mov    %eax,(%esp)
  103a64:	e8 dd f3 ff ff       	call   102e46 <page_ref_dec>
        if (page_ref(page) == 0)
  103a69:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103a6c:	89 04 24             	mov    %eax,(%esp)
  103a6f:	e8 a3 f3 ff ff       	call   102e17 <page_ref>
  103a74:	85 c0                	test   %eax,%eax
  103a76:	75 13                	jne    103a8b <page_remove_pte+0x14e>
			free_page(page);			//(4) and free this page when page reference reachs 0
  103a78:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103a7f:	00 
  103a80:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103a83:	89 04 24             	mov    %eax,(%esp)
  103a86:	e8 c9 f5 ff ff       	call   103054 <free_pages>
  103a8b:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
  103a92:	8b 45 10             	mov    0x10(%ebp),%eax
  103a95:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  103a98:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  103a9b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  103a9e:	0f b3 10             	btr    %edx,(%eax)
        clear_bit(PTE_P, ptep);                        //(5) clear second page table entry
        tlb_invalidate(pgdir, la);                          //(6) flush tlb
  103aa1:	8b 45 0c             	mov    0xc(%ebp),%eax
  103aa4:	89 44 24 04          	mov    %eax,0x4(%esp)
  103aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  103aab:	89 04 24             	mov    %eax,(%esp)
  103aae:	e8 0f 01 00 00       	call   103bc2 <tlb_invalidate>
    }
	else 
		cprintf("test_bit(PTE_P, ptep) error\n");
// #endif
}
  103ab3:	eb 0c                	jmp    103ac1 <page_remove_pte+0x184>
		cprintf("test_bit(PTE_P, ptep) error\n");
  103ab5:	c7 04 24 e2 71 10 00 	movl   $0x1071e2,(%esp)
  103abc:	e8 cd c7 ff ff       	call   10028e <cprintf>
}
  103ac1:	90                   	nop
  103ac2:	c9                   	leave  
  103ac3:	c3                   	ret    

00103ac4 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  103ac4:	55                   	push   %ebp
  103ac5:	89 e5                	mov    %esp,%ebp
  103ac7:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  103aca:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103ad1:	00 
  103ad2:	8b 45 0c             	mov    0xc(%ebp),%eax
  103ad5:	89 44 24 04          	mov    %eax,0x4(%esp)
  103ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  103adc:	89 04 24             	mov    %eax,(%esp)
  103adf:	e8 cf fb ff ff       	call   1036b3 <get_pte>
  103ae4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
  103ae7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103aeb:	74 19                	je     103b06 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
  103aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103af0:	89 44 24 08          	mov    %eax,0x8(%esp)
  103af4:	8b 45 0c             	mov    0xc(%ebp),%eax
  103af7:	89 44 24 04          	mov    %eax,0x4(%esp)
  103afb:	8b 45 08             	mov    0x8(%ebp),%eax
  103afe:	89 04 24             	mov    %eax,(%esp)
  103b01:	e8 37 fe ff ff       	call   10393d <page_remove_pte>
    }
}
  103b06:	90                   	nop
  103b07:	c9                   	leave  
  103b08:	c3                   	ret    

00103b09 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  103b09:	55                   	push   %ebp
  103b0a:	89 e5                	mov    %esp,%ebp
  103b0c:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  103b0f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  103b16:	00 
  103b17:	8b 45 10             	mov    0x10(%ebp),%eax
  103b1a:	89 44 24 04          	mov    %eax,0x4(%esp)
  103b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  103b21:	89 04 24             	mov    %eax,(%esp)
  103b24:	e8 8a fb ff ff       	call   1036b3 <get_pte>
  103b29:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  103b2c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103b30:	75 0a                	jne    103b3c <page_insert+0x33>
        return -E_NO_MEM;
  103b32:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  103b37:	e9 84 00 00 00       	jmp    103bc0 <page_insert+0xb7>
    }
    page_ref_inc(page);
  103b3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  103b3f:	89 04 24             	mov    %eax,(%esp)
  103b42:	e8 e8 f2 ff ff       	call   102e2f <page_ref_inc>
    if (*ptep & PTE_P) {
  103b47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103b4a:	8b 00                	mov    (%eax),%eax
  103b4c:	83 e0 01             	and    $0x1,%eax
  103b4f:	85 c0                	test   %eax,%eax
  103b51:	74 3e                	je     103b91 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
  103b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103b56:	8b 00                	mov    (%eax),%eax
  103b58:	89 04 24             	mov    %eax,(%esp)
  103b5b:	e8 61 f2 ff ff       	call   102dc1 <pte2page>
  103b60:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  103b63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103b66:	3b 45 0c             	cmp    0xc(%ebp),%eax
  103b69:	75 0d                	jne    103b78 <page_insert+0x6f>
            page_ref_dec(page);
  103b6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  103b6e:	89 04 24             	mov    %eax,(%esp)
  103b71:	e8 d0 f2 ff ff       	call   102e46 <page_ref_dec>
  103b76:	eb 19                	jmp    103b91 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  103b78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103b7b:	89 44 24 08          	mov    %eax,0x8(%esp)
  103b7f:	8b 45 10             	mov    0x10(%ebp),%eax
  103b82:	89 44 24 04          	mov    %eax,0x4(%esp)
  103b86:	8b 45 08             	mov    0x8(%ebp),%eax
  103b89:	89 04 24             	mov    %eax,(%esp)
  103b8c:	e8 ac fd ff ff       	call   10393d <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  103b91:	8b 45 0c             	mov    0xc(%ebp),%eax
  103b94:	89 04 24             	mov    %eax,(%esp)
  103b97:	e8 6c f1 ff ff       	call   102d08 <page2pa>
  103b9c:	0b 45 14             	or     0x14(%ebp),%eax
  103b9f:	83 c8 01             	or     $0x1,%eax
  103ba2:	89 c2                	mov    %eax,%edx
  103ba4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103ba7:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  103ba9:	8b 45 10             	mov    0x10(%ebp),%eax
  103bac:	89 44 24 04          	mov    %eax,0x4(%esp)
  103bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  103bb3:	89 04 24             	mov    %eax,(%esp)
  103bb6:	e8 07 00 00 00       	call   103bc2 <tlb_invalidate>
    return 0;
  103bbb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103bc0:	c9                   	leave  
  103bc1:	c3                   	ret    

00103bc2 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  103bc2:	55                   	push   %ebp
  103bc3:	89 e5                	mov    %esp,%ebp
  103bc5:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  103bc8:	0f 20 d8             	mov    %cr3,%eax
  103bcb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  103bce:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
  103bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  103bd4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103bd7:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  103bde:	77 23                	ja     103c03 <tlb_invalidate+0x41>
  103be0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103be3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103be7:	c7 44 24 08 04 71 10 	movl   $0x107104,0x8(%esp)
  103bee:	00 
  103bef:	c7 44 24 04 f0 01 00 	movl   $0x1f0,0x4(%esp)
  103bf6:	00 
  103bf7:	c7 04 24 28 71 10 00 	movl   $0x107128,(%esp)
  103bfe:	e8 e3 c7 ff ff       	call   1003e6 <__panic>
  103c03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103c06:	05 00 00 00 40       	add    $0x40000000,%eax
  103c0b:	39 d0                	cmp    %edx,%eax
  103c0d:	75 0c                	jne    103c1b <tlb_invalidate+0x59>
        invlpg((void *)la);
  103c0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103c12:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  103c15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103c18:	0f 01 38             	invlpg (%eax)
    }
}
  103c1b:	90                   	nop
  103c1c:	c9                   	leave  
  103c1d:	c3                   	ret    

00103c1e <check_alloc_page>:

static void
check_alloc_page(void) {
  103c1e:	55                   	push   %ebp
  103c1f:	89 e5                	mov    %esp,%ebp
  103c21:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  103c24:	a1 30 df 11 00       	mov    0x11df30,%eax
  103c29:	8b 40 18             	mov    0x18(%eax),%eax
  103c2c:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  103c2e:	c7 04 24 00 72 10 00 	movl   $0x107200,(%esp)
  103c35:	e8 54 c6 ff ff       	call   10028e <cprintf>
}
  103c3a:	90                   	nop
  103c3b:	c9                   	leave  
  103c3c:	c3                   	ret    

00103c3d <check_pgdir>:

static void
check_pgdir(void) {
  103c3d:	55                   	push   %ebp
  103c3e:	89 e5                	mov    %esp,%ebp
  103c40:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  103c43:	a1 a0 de 11 00       	mov    0x11dea0,%eax
  103c48:	3d 00 80 03 00       	cmp    $0x38000,%eax
  103c4d:	76 24                	jbe    103c73 <check_pgdir+0x36>
  103c4f:	c7 44 24 0c 1f 72 10 	movl   $0x10721f,0xc(%esp)
  103c56:	00 
  103c57:	c7 44 24 08 4d 71 10 	movl   $0x10714d,0x8(%esp)
  103c5e:	00 
  103c5f:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
  103c66:	00 
  103c67:	c7 04 24 28 71 10 00 	movl   $0x107128,(%esp)
  103c6e:	e8 73 c7 ff ff       	call   1003e6 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  103c73:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  103c78:	85 c0                	test   %eax,%eax
  103c7a:	74 0e                	je     103c8a <check_pgdir+0x4d>
  103c7c:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  103c81:	25 ff 0f 00 00       	and    $0xfff,%eax
  103c86:	85 c0                	test   %eax,%eax
  103c88:	74 24                	je     103cae <check_pgdir+0x71>
  103c8a:	c7 44 24 0c 3c 72 10 	movl   $0x10723c,0xc(%esp)
  103c91:	00 
  103c92:	c7 44 24 08 4d 71 10 	movl   $0x10714d,0x8(%esp)
  103c99:	00 
  103c9a:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
  103ca1:	00 
  103ca2:	c7 04 24 28 71 10 00 	movl   $0x107128,(%esp)
  103ca9:	e8 38 c7 ff ff       	call   1003e6 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  103cae:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  103cb3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103cba:	00 
  103cbb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103cc2:	00 
  103cc3:	89 04 24             	mov    %eax,(%esp)
  103cc6:	e8 19 fc ff ff       	call   1038e4 <get_page>
  103ccb:	85 c0                	test   %eax,%eax
  103ccd:	74 24                	je     103cf3 <check_pgdir+0xb6>
  103ccf:	c7 44 24 0c 74 72 10 	movl   $0x107274,0xc(%esp)
  103cd6:	00 
  103cd7:	c7 44 24 08 4d 71 10 	movl   $0x10714d,0x8(%esp)
  103cde:	00 
  103cdf:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
  103ce6:	00 
  103ce7:	c7 04 24 28 71 10 00 	movl   $0x107128,(%esp)
  103cee:	e8 f3 c6 ff ff       	call   1003e6 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  103cf3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103cfa:	e8 1d f3 ff ff       	call   10301c <alloc_pages>
  103cff:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  103d02:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  103d07:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  103d0e:	00 
  103d0f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103d16:	00 
  103d17:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103d1a:	89 54 24 04          	mov    %edx,0x4(%esp)
  103d1e:	89 04 24             	mov    %eax,(%esp)
  103d21:	e8 e3 fd ff ff       	call   103b09 <page_insert>
  103d26:	85 c0                	test   %eax,%eax
  103d28:	74 24                	je     103d4e <check_pgdir+0x111>
  103d2a:	c7 44 24 0c 9c 72 10 	movl   $0x10729c,0xc(%esp)
  103d31:	00 
  103d32:	c7 44 24 08 4d 71 10 	movl   $0x10714d,0x8(%esp)
  103d39:	00 
  103d3a:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
  103d41:	00 
  103d42:	c7 04 24 28 71 10 00 	movl   $0x107128,(%esp)
  103d49:	e8 98 c6 ff ff       	call   1003e6 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  103d4e:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  103d53:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103d5a:	00 
  103d5b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103d62:	00 
  103d63:	89 04 24             	mov    %eax,(%esp)
  103d66:	e8 48 f9 ff ff       	call   1036b3 <get_pte>
  103d6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103d6e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103d72:	75 24                	jne    103d98 <check_pgdir+0x15b>
  103d74:	c7 44 24 0c c8 72 10 	movl   $0x1072c8,0xc(%esp)
  103d7b:	00 
  103d7c:	c7 44 24 08 4d 71 10 	movl   $0x10714d,0x8(%esp)
  103d83:	00 
  103d84:	c7 44 24 04 06 02 00 	movl   $0x206,0x4(%esp)
  103d8b:	00 
  103d8c:	c7 04 24 28 71 10 00 	movl   $0x107128,(%esp)
  103d93:	e8 4e c6 ff ff       	call   1003e6 <__panic>
    assert(pte2page(*ptep) == p1);
  103d98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103d9b:	8b 00                	mov    (%eax),%eax
  103d9d:	89 04 24             	mov    %eax,(%esp)
  103da0:	e8 1c f0 ff ff       	call   102dc1 <pte2page>
  103da5:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  103da8:	74 24                	je     103dce <check_pgdir+0x191>
  103daa:	c7 44 24 0c f5 72 10 	movl   $0x1072f5,0xc(%esp)
  103db1:	00 
  103db2:	c7 44 24 08 4d 71 10 	movl   $0x10714d,0x8(%esp)
  103db9:	00 
  103dba:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
  103dc1:	00 
  103dc2:	c7 04 24 28 71 10 00 	movl   $0x107128,(%esp)
  103dc9:	e8 18 c6 ff ff       	call   1003e6 <__panic>
    assert(page_ref(p1) == 1);
  103dce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103dd1:	89 04 24             	mov    %eax,(%esp)
  103dd4:	e8 3e f0 ff ff       	call   102e17 <page_ref>
  103dd9:	83 f8 01             	cmp    $0x1,%eax
  103ddc:	74 24                	je     103e02 <check_pgdir+0x1c5>
  103dde:	c7 44 24 0c 0b 73 10 	movl   $0x10730b,0xc(%esp)
  103de5:	00 
  103de6:	c7 44 24 08 4d 71 10 	movl   $0x10714d,0x8(%esp)
  103ded:	00 
  103dee:	c7 44 24 04 08 02 00 	movl   $0x208,0x4(%esp)
  103df5:	00 
  103df6:	c7 04 24 28 71 10 00 	movl   $0x107128,(%esp)
  103dfd:	e8 e4 c5 ff ff       	call   1003e6 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  103e02:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  103e07:	8b 00                	mov    (%eax),%eax
  103e09:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103e0e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103e11:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103e14:	c1 e8 0c             	shr    $0xc,%eax
  103e17:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103e1a:	a1 a0 de 11 00       	mov    0x11dea0,%eax
  103e1f:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  103e22:	72 23                	jb     103e47 <check_pgdir+0x20a>
  103e24:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103e27:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103e2b:	c7 44 24 08 60 70 10 	movl   $0x107060,0x8(%esp)
  103e32:	00 
  103e33:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
  103e3a:	00 
  103e3b:	c7 04 24 28 71 10 00 	movl   $0x107128,(%esp)
  103e42:	e8 9f c5 ff ff       	call   1003e6 <__panic>
  103e47:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103e4a:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103e4f:	83 c0 04             	add    $0x4,%eax
  103e52:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  103e55:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  103e5a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103e61:	00 
  103e62:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103e69:	00 
  103e6a:	89 04 24             	mov    %eax,(%esp)
  103e6d:	e8 41 f8 ff ff       	call   1036b3 <get_pte>
  103e72:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  103e75:	74 24                	je     103e9b <check_pgdir+0x25e>
  103e77:	c7 44 24 0c 20 73 10 	movl   $0x107320,0xc(%esp)
  103e7e:	00 
  103e7f:	c7 44 24 08 4d 71 10 	movl   $0x10714d,0x8(%esp)
  103e86:	00 
  103e87:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
  103e8e:	00 
  103e8f:	c7 04 24 28 71 10 00 	movl   $0x107128,(%esp)
  103e96:	e8 4b c5 ff ff       	call   1003e6 <__panic>

    p2 = alloc_page();
  103e9b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103ea2:	e8 75 f1 ff ff       	call   10301c <alloc_pages>
  103ea7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  103eaa:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  103eaf:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  103eb6:	00 
  103eb7:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  103ebe:	00 
  103ebf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103ec2:	89 54 24 04          	mov    %edx,0x4(%esp)
  103ec6:	89 04 24             	mov    %eax,(%esp)
  103ec9:	e8 3b fc ff ff       	call   103b09 <page_insert>
  103ece:	85 c0                	test   %eax,%eax
  103ed0:	74 24                	je     103ef6 <check_pgdir+0x2b9>
  103ed2:	c7 44 24 0c 48 73 10 	movl   $0x107348,0xc(%esp)
  103ed9:	00 
  103eda:	c7 44 24 08 4d 71 10 	movl   $0x10714d,0x8(%esp)
  103ee1:	00 
  103ee2:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
  103ee9:	00 
  103eea:	c7 04 24 28 71 10 00 	movl   $0x107128,(%esp)
  103ef1:	e8 f0 c4 ff ff       	call   1003e6 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  103ef6:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  103efb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103f02:	00 
  103f03:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103f0a:	00 
  103f0b:	89 04 24             	mov    %eax,(%esp)
  103f0e:	e8 a0 f7 ff ff       	call   1036b3 <get_pte>
  103f13:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103f16:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103f1a:	75 24                	jne    103f40 <check_pgdir+0x303>
  103f1c:	c7 44 24 0c 80 73 10 	movl   $0x107380,0xc(%esp)
  103f23:	00 
  103f24:	c7 44 24 08 4d 71 10 	movl   $0x10714d,0x8(%esp)
  103f2b:	00 
  103f2c:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
  103f33:	00 
  103f34:	c7 04 24 28 71 10 00 	movl   $0x107128,(%esp)
  103f3b:	e8 a6 c4 ff ff       	call   1003e6 <__panic>
    assert(*ptep & PTE_U);
  103f40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103f43:	8b 00                	mov    (%eax),%eax
  103f45:	83 e0 04             	and    $0x4,%eax
  103f48:	85 c0                	test   %eax,%eax
  103f4a:	75 24                	jne    103f70 <check_pgdir+0x333>
  103f4c:	c7 44 24 0c b0 73 10 	movl   $0x1073b0,0xc(%esp)
  103f53:	00 
  103f54:	c7 44 24 08 4d 71 10 	movl   $0x10714d,0x8(%esp)
  103f5b:	00 
  103f5c:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
  103f63:	00 
  103f64:	c7 04 24 28 71 10 00 	movl   $0x107128,(%esp)
  103f6b:	e8 76 c4 ff ff       	call   1003e6 <__panic>
    assert(*ptep & PTE_W);
  103f70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103f73:	8b 00                	mov    (%eax),%eax
  103f75:	83 e0 02             	and    $0x2,%eax
  103f78:	85 c0                	test   %eax,%eax
  103f7a:	75 24                	jne    103fa0 <check_pgdir+0x363>
  103f7c:	c7 44 24 0c be 73 10 	movl   $0x1073be,0xc(%esp)
  103f83:	00 
  103f84:	c7 44 24 08 4d 71 10 	movl   $0x10714d,0x8(%esp)
  103f8b:	00 
  103f8c:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
  103f93:	00 
  103f94:	c7 04 24 28 71 10 00 	movl   $0x107128,(%esp)
  103f9b:	e8 46 c4 ff ff       	call   1003e6 <__panic>
    assert(boot_pgdir[0] & PTE_U);
  103fa0:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  103fa5:	8b 00                	mov    (%eax),%eax
  103fa7:	83 e0 04             	and    $0x4,%eax
  103faa:	85 c0                	test   %eax,%eax
  103fac:	75 24                	jne    103fd2 <check_pgdir+0x395>
  103fae:	c7 44 24 0c cc 73 10 	movl   $0x1073cc,0xc(%esp)
  103fb5:	00 
  103fb6:	c7 44 24 08 4d 71 10 	movl   $0x10714d,0x8(%esp)
  103fbd:	00 
  103fbe:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
  103fc5:	00 
  103fc6:	c7 04 24 28 71 10 00 	movl   $0x107128,(%esp)
  103fcd:	e8 14 c4 ff ff       	call   1003e6 <__panic>
    assert(page_ref(p2) == 1);
  103fd2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103fd5:	89 04 24             	mov    %eax,(%esp)
  103fd8:	e8 3a ee ff ff       	call   102e17 <page_ref>
  103fdd:	83 f8 01             	cmp    $0x1,%eax
  103fe0:	74 24                	je     104006 <check_pgdir+0x3c9>
  103fe2:	c7 44 24 0c e2 73 10 	movl   $0x1073e2,0xc(%esp)
  103fe9:	00 
  103fea:	c7 44 24 08 4d 71 10 	movl   $0x10714d,0x8(%esp)
  103ff1:	00 
  103ff2:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
  103ff9:	00 
  103ffa:	c7 04 24 28 71 10 00 	movl   $0x107128,(%esp)
  104001:	e8 e0 c3 ff ff       	call   1003e6 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  104006:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  10400b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104012:	00 
  104013:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  10401a:	00 
  10401b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10401e:	89 54 24 04          	mov    %edx,0x4(%esp)
  104022:	89 04 24             	mov    %eax,(%esp)
  104025:	e8 df fa ff ff       	call   103b09 <page_insert>
  10402a:	85 c0                	test   %eax,%eax
  10402c:	74 24                	je     104052 <check_pgdir+0x415>
  10402e:	c7 44 24 0c f4 73 10 	movl   $0x1073f4,0xc(%esp)
  104035:	00 
  104036:	c7 44 24 08 4d 71 10 	movl   $0x10714d,0x8(%esp)
  10403d:	00 
  10403e:	c7 44 24 04 15 02 00 	movl   $0x215,0x4(%esp)
  104045:	00 
  104046:	c7 04 24 28 71 10 00 	movl   $0x107128,(%esp)
  10404d:	e8 94 c3 ff ff       	call   1003e6 <__panic>
    assert(page_ref(p1) == 2);
  104052:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104055:	89 04 24             	mov    %eax,(%esp)
  104058:	e8 ba ed ff ff       	call   102e17 <page_ref>
  10405d:	83 f8 02             	cmp    $0x2,%eax
  104060:	74 24                	je     104086 <check_pgdir+0x449>
  104062:	c7 44 24 0c 20 74 10 	movl   $0x107420,0xc(%esp)
  104069:	00 
  10406a:	c7 44 24 08 4d 71 10 	movl   $0x10714d,0x8(%esp)
  104071:	00 
  104072:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
  104079:	00 
  10407a:	c7 04 24 28 71 10 00 	movl   $0x107128,(%esp)
  104081:	e8 60 c3 ff ff       	call   1003e6 <__panic>
    assert(page_ref(p2) == 0);
  104086:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104089:	89 04 24             	mov    %eax,(%esp)
  10408c:	e8 86 ed ff ff       	call   102e17 <page_ref>
  104091:	85 c0                	test   %eax,%eax
  104093:	74 24                	je     1040b9 <check_pgdir+0x47c>
  104095:	c7 44 24 0c 32 74 10 	movl   $0x107432,0xc(%esp)
  10409c:	00 
  10409d:	c7 44 24 08 4d 71 10 	movl   $0x10714d,0x8(%esp)
  1040a4:	00 
  1040a5:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
  1040ac:	00 
  1040ad:	c7 04 24 28 71 10 00 	movl   $0x107128,(%esp)
  1040b4:	e8 2d c3 ff ff       	call   1003e6 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  1040b9:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  1040be:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1040c5:	00 
  1040c6:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  1040cd:	00 
  1040ce:	89 04 24             	mov    %eax,(%esp)
  1040d1:	e8 dd f5 ff ff       	call   1036b3 <get_pte>
  1040d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1040d9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1040dd:	75 24                	jne    104103 <check_pgdir+0x4c6>
  1040df:	c7 44 24 0c 80 73 10 	movl   $0x107380,0xc(%esp)
  1040e6:	00 
  1040e7:	c7 44 24 08 4d 71 10 	movl   $0x10714d,0x8(%esp)
  1040ee:	00 
  1040ef:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
  1040f6:	00 
  1040f7:	c7 04 24 28 71 10 00 	movl   $0x107128,(%esp)
  1040fe:	e8 e3 c2 ff ff       	call   1003e6 <__panic>
    assert(pte2page(*ptep) == p1);
  104103:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104106:	8b 00                	mov    (%eax),%eax
  104108:	89 04 24             	mov    %eax,(%esp)
  10410b:	e8 b1 ec ff ff       	call   102dc1 <pte2page>
  104110:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104113:	74 24                	je     104139 <check_pgdir+0x4fc>
  104115:	c7 44 24 0c f5 72 10 	movl   $0x1072f5,0xc(%esp)
  10411c:	00 
  10411d:	c7 44 24 08 4d 71 10 	movl   $0x10714d,0x8(%esp)
  104124:	00 
  104125:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
  10412c:	00 
  10412d:	c7 04 24 28 71 10 00 	movl   $0x107128,(%esp)
  104134:	e8 ad c2 ff ff       	call   1003e6 <__panic>
    assert((*ptep & PTE_U) == 0);
  104139:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10413c:	8b 00                	mov    (%eax),%eax
  10413e:	83 e0 04             	and    $0x4,%eax
  104141:	85 c0                	test   %eax,%eax
  104143:	74 24                	je     104169 <check_pgdir+0x52c>
  104145:	c7 44 24 0c 44 74 10 	movl   $0x107444,0xc(%esp)
  10414c:	00 
  10414d:	c7 44 24 08 4d 71 10 	movl   $0x10714d,0x8(%esp)
  104154:	00 
  104155:	c7 44 24 04 1a 02 00 	movl   $0x21a,0x4(%esp)
  10415c:	00 
  10415d:	c7 04 24 28 71 10 00 	movl   $0x107128,(%esp)
  104164:	e8 7d c2 ff ff       	call   1003e6 <__panic>

    page_remove(boot_pgdir, 0x0);
  104169:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  10416e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104175:	00 
  104176:	89 04 24             	mov    %eax,(%esp)
  104179:	e8 46 f9 ff ff       	call   103ac4 <page_remove>
    assert(page_ref(p1) == 1);
  10417e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104181:	89 04 24             	mov    %eax,(%esp)
  104184:	e8 8e ec ff ff       	call   102e17 <page_ref>
  104189:	83 f8 01             	cmp    $0x1,%eax
  10418c:	74 24                	je     1041b2 <check_pgdir+0x575>
  10418e:	c7 44 24 0c 0b 73 10 	movl   $0x10730b,0xc(%esp)
  104195:	00 
  104196:	c7 44 24 08 4d 71 10 	movl   $0x10714d,0x8(%esp)
  10419d:	00 
  10419e:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
  1041a5:	00 
  1041a6:	c7 04 24 28 71 10 00 	movl   $0x107128,(%esp)
  1041ad:	e8 34 c2 ff ff       	call   1003e6 <__panic>
    assert(page_ref(p2) == 0);
  1041b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1041b5:	89 04 24             	mov    %eax,(%esp)
  1041b8:	e8 5a ec ff ff       	call   102e17 <page_ref>
  1041bd:	85 c0                	test   %eax,%eax
  1041bf:	74 24                	je     1041e5 <check_pgdir+0x5a8>
  1041c1:	c7 44 24 0c 32 74 10 	movl   $0x107432,0xc(%esp)
  1041c8:	00 
  1041c9:	c7 44 24 08 4d 71 10 	movl   $0x10714d,0x8(%esp)
  1041d0:	00 
  1041d1:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
  1041d8:	00 
  1041d9:	c7 04 24 28 71 10 00 	movl   $0x107128,(%esp)
  1041e0:	e8 01 c2 ff ff       	call   1003e6 <__panic>

    page_remove(boot_pgdir, PGSIZE);
  1041e5:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  1041ea:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  1041f1:	00 
  1041f2:	89 04 24             	mov    %eax,(%esp)
  1041f5:	e8 ca f8 ff ff       	call   103ac4 <page_remove>
    assert(page_ref(p1) == 0);
  1041fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1041fd:	89 04 24             	mov    %eax,(%esp)
  104200:	e8 12 ec ff ff       	call   102e17 <page_ref>
  104205:	85 c0                	test   %eax,%eax
  104207:	74 24                	je     10422d <check_pgdir+0x5f0>
  104209:	c7 44 24 0c 59 74 10 	movl   $0x107459,0xc(%esp)
  104210:	00 
  104211:	c7 44 24 08 4d 71 10 	movl   $0x10714d,0x8(%esp)
  104218:	00 
  104219:	c7 44 24 04 21 02 00 	movl   $0x221,0x4(%esp)
  104220:	00 
  104221:	c7 04 24 28 71 10 00 	movl   $0x107128,(%esp)
  104228:	e8 b9 c1 ff ff       	call   1003e6 <__panic>
    assert(page_ref(p2) == 0);
  10422d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104230:	89 04 24             	mov    %eax,(%esp)
  104233:	e8 df eb ff ff       	call   102e17 <page_ref>
  104238:	85 c0                	test   %eax,%eax
  10423a:	74 24                	je     104260 <check_pgdir+0x623>
  10423c:	c7 44 24 0c 32 74 10 	movl   $0x107432,0xc(%esp)
  104243:	00 
  104244:	c7 44 24 08 4d 71 10 	movl   $0x10714d,0x8(%esp)
  10424b:	00 
  10424c:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
  104253:	00 
  104254:	c7 04 24 28 71 10 00 	movl   $0x107128,(%esp)
  10425b:	e8 86 c1 ff ff       	call   1003e6 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
  104260:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  104265:	8b 00                	mov    (%eax),%eax
  104267:	89 04 24             	mov    %eax,(%esp)
  10426a:	e8 90 eb ff ff       	call   102dff <pde2page>
  10426f:	89 04 24             	mov    %eax,(%esp)
  104272:	e8 a0 eb ff ff       	call   102e17 <page_ref>
  104277:	83 f8 01             	cmp    $0x1,%eax
  10427a:	74 24                	je     1042a0 <check_pgdir+0x663>
  10427c:	c7 44 24 0c 6c 74 10 	movl   $0x10746c,0xc(%esp)
  104283:	00 
  104284:	c7 44 24 08 4d 71 10 	movl   $0x10714d,0x8(%esp)
  10428b:	00 
  10428c:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
  104293:	00 
  104294:	c7 04 24 28 71 10 00 	movl   $0x107128,(%esp)
  10429b:	e8 46 c1 ff ff       	call   1003e6 <__panic>
    free_page(pde2page(boot_pgdir[0]));
  1042a0:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  1042a5:	8b 00                	mov    (%eax),%eax
  1042a7:	89 04 24             	mov    %eax,(%esp)
  1042aa:	e8 50 eb ff ff       	call   102dff <pde2page>
  1042af:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1042b6:	00 
  1042b7:	89 04 24             	mov    %eax,(%esp)
  1042ba:	e8 95 ed ff ff       	call   103054 <free_pages>
    boot_pgdir[0] = 0;
  1042bf:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  1042c4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  1042ca:	c7 04 24 93 74 10 00 	movl   $0x107493,(%esp)
  1042d1:	e8 b8 bf ff ff       	call   10028e <cprintf>
}
  1042d6:	90                   	nop
  1042d7:	c9                   	leave  
  1042d8:	c3                   	ret    

001042d9 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  1042d9:	55                   	push   %ebp
  1042da:	89 e5                	mov    %esp,%ebp
  1042dc:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  1042df:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1042e6:	e9 ca 00 00 00       	jmp    1043b5 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  1042eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1042ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1042f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1042f4:	c1 e8 0c             	shr    $0xc,%eax
  1042f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1042fa:	a1 a0 de 11 00       	mov    0x11dea0,%eax
  1042ff:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  104302:	72 23                	jb     104327 <check_boot_pgdir+0x4e>
  104304:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104307:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10430b:	c7 44 24 08 60 70 10 	movl   $0x107060,0x8(%esp)
  104312:	00 
  104313:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
  10431a:	00 
  10431b:	c7 04 24 28 71 10 00 	movl   $0x107128,(%esp)
  104322:	e8 bf c0 ff ff       	call   1003e6 <__panic>
  104327:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10432a:	2d 00 00 00 40       	sub    $0x40000000,%eax
  10432f:	89 c2                	mov    %eax,%edx
  104331:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  104336:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10433d:	00 
  10433e:	89 54 24 04          	mov    %edx,0x4(%esp)
  104342:	89 04 24             	mov    %eax,(%esp)
  104345:	e8 69 f3 ff ff       	call   1036b3 <get_pte>
  10434a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10434d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  104351:	75 24                	jne    104377 <check_boot_pgdir+0x9e>
  104353:	c7 44 24 0c b0 74 10 	movl   $0x1074b0,0xc(%esp)
  10435a:	00 
  10435b:	c7 44 24 08 4d 71 10 	movl   $0x10714d,0x8(%esp)
  104362:	00 
  104363:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
  10436a:	00 
  10436b:	c7 04 24 28 71 10 00 	movl   $0x107128,(%esp)
  104372:	e8 6f c0 ff ff       	call   1003e6 <__panic>
        assert(PTE_ADDR(*ptep) == i);
  104377:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10437a:	8b 00                	mov    (%eax),%eax
  10437c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104381:	89 c2                	mov    %eax,%edx
  104383:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104386:	39 c2                	cmp    %eax,%edx
  104388:	74 24                	je     1043ae <check_boot_pgdir+0xd5>
  10438a:	c7 44 24 0c ed 74 10 	movl   $0x1074ed,0xc(%esp)
  104391:	00 
  104392:	c7 44 24 08 4d 71 10 	movl   $0x10714d,0x8(%esp)
  104399:	00 
  10439a:	c7 44 24 04 31 02 00 	movl   $0x231,0x4(%esp)
  1043a1:	00 
  1043a2:	c7 04 24 28 71 10 00 	movl   $0x107128,(%esp)
  1043a9:	e8 38 c0 ff ff       	call   1003e6 <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
  1043ae:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  1043b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1043b8:	a1 a0 de 11 00       	mov    0x11dea0,%eax
  1043bd:	39 c2                	cmp    %eax,%edx
  1043bf:	0f 82 26 ff ff ff    	jb     1042eb <check_boot_pgdir+0x12>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  1043c5:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  1043ca:	05 ac 0f 00 00       	add    $0xfac,%eax
  1043cf:	8b 00                	mov    (%eax),%eax
  1043d1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1043d6:	89 c2                	mov    %eax,%edx
  1043d8:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  1043dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1043e0:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
  1043e7:	77 23                	ja     10440c <check_boot_pgdir+0x133>
  1043e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1043ec:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1043f0:	c7 44 24 08 04 71 10 	movl   $0x107104,0x8(%esp)
  1043f7:	00 
  1043f8:	c7 44 24 04 34 02 00 	movl   $0x234,0x4(%esp)
  1043ff:	00 
  104400:	c7 04 24 28 71 10 00 	movl   $0x107128,(%esp)
  104407:	e8 da bf ff ff       	call   1003e6 <__panic>
  10440c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10440f:	05 00 00 00 40       	add    $0x40000000,%eax
  104414:	39 d0                	cmp    %edx,%eax
  104416:	74 24                	je     10443c <check_boot_pgdir+0x163>
  104418:	c7 44 24 0c 04 75 10 	movl   $0x107504,0xc(%esp)
  10441f:	00 
  104420:	c7 44 24 08 4d 71 10 	movl   $0x10714d,0x8(%esp)
  104427:	00 
  104428:	c7 44 24 04 34 02 00 	movl   $0x234,0x4(%esp)
  10442f:	00 
  104430:	c7 04 24 28 71 10 00 	movl   $0x107128,(%esp)
  104437:	e8 aa bf ff ff       	call   1003e6 <__panic>

    assert(boot_pgdir[0] == 0);
  10443c:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  104441:	8b 00                	mov    (%eax),%eax
  104443:	85 c0                	test   %eax,%eax
  104445:	74 24                	je     10446b <check_boot_pgdir+0x192>
  104447:	c7 44 24 0c 38 75 10 	movl   $0x107538,0xc(%esp)
  10444e:	00 
  10444f:	c7 44 24 08 4d 71 10 	movl   $0x10714d,0x8(%esp)
  104456:	00 
  104457:	c7 44 24 04 36 02 00 	movl   $0x236,0x4(%esp)
  10445e:	00 
  10445f:	c7 04 24 28 71 10 00 	movl   $0x107128,(%esp)
  104466:	e8 7b bf ff ff       	call   1003e6 <__panic>

    struct Page *p;
    p = alloc_page();
  10446b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104472:	e8 a5 eb ff ff       	call   10301c <alloc_pages>
  104477:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  10447a:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  10447f:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  104486:	00 
  104487:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  10448e:	00 
  10448f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104492:	89 54 24 04          	mov    %edx,0x4(%esp)
  104496:	89 04 24             	mov    %eax,(%esp)
  104499:	e8 6b f6 ff ff       	call   103b09 <page_insert>
  10449e:	85 c0                	test   %eax,%eax
  1044a0:	74 24                	je     1044c6 <check_boot_pgdir+0x1ed>
  1044a2:	c7 44 24 0c 4c 75 10 	movl   $0x10754c,0xc(%esp)
  1044a9:	00 
  1044aa:	c7 44 24 08 4d 71 10 	movl   $0x10714d,0x8(%esp)
  1044b1:	00 
  1044b2:	c7 44 24 04 3a 02 00 	movl   $0x23a,0x4(%esp)
  1044b9:	00 
  1044ba:	c7 04 24 28 71 10 00 	movl   $0x107128,(%esp)
  1044c1:	e8 20 bf ff ff       	call   1003e6 <__panic>
    assert(page_ref(p) == 1);
  1044c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1044c9:	89 04 24             	mov    %eax,(%esp)
  1044cc:	e8 46 e9 ff ff       	call   102e17 <page_ref>
  1044d1:	83 f8 01             	cmp    $0x1,%eax
  1044d4:	74 24                	je     1044fa <check_boot_pgdir+0x221>
  1044d6:	c7 44 24 0c 7a 75 10 	movl   $0x10757a,0xc(%esp)
  1044dd:	00 
  1044de:	c7 44 24 08 4d 71 10 	movl   $0x10714d,0x8(%esp)
  1044e5:	00 
  1044e6:	c7 44 24 04 3b 02 00 	movl   $0x23b,0x4(%esp)
  1044ed:	00 
  1044ee:	c7 04 24 28 71 10 00 	movl   $0x107128,(%esp)
  1044f5:	e8 ec be ff ff       	call   1003e6 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  1044fa:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  1044ff:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  104506:	00 
  104507:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  10450e:	00 
  10450f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104512:	89 54 24 04          	mov    %edx,0x4(%esp)
  104516:	89 04 24             	mov    %eax,(%esp)
  104519:	e8 eb f5 ff ff       	call   103b09 <page_insert>
  10451e:	85 c0                	test   %eax,%eax
  104520:	74 24                	je     104546 <check_boot_pgdir+0x26d>
  104522:	c7 44 24 0c 8c 75 10 	movl   $0x10758c,0xc(%esp)
  104529:	00 
  10452a:	c7 44 24 08 4d 71 10 	movl   $0x10714d,0x8(%esp)
  104531:	00 
  104532:	c7 44 24 04 3c 02 00 	movl   $0x23c,0x4(%esp)
  104539:	00 
  10453a:	c7 04 24 28 71 10 00 	movl   $0x107128,(%esp)
  104541:	e8 a0 be ff ff       	call   1003e6 <__panic>
    assert(page_ref(p) == 2);
  104546:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104549:	89 04 24             	mov    %eax,(%esp)
  10454c:	e8 c6 e8 ff ff       	call   102e17 <page_ref>
  104551:	83 f8 02             	cmp    $0x2,%eax
  104554:	74 24                	je     10457a <check_boot_pgdir+0x2a1>
  104556:	c7 44 24 0c c3 75 10 	movl   $0x1075c3,0xc(%esp)
  10455d:	00 
  10455e:	c7 44 24 08 4d 71 10 	movl   $0x10714d,0x8(%esp)
  104565:	00 
  104566:	c7 44 24 04 3d 02 00 	movl   $0x23d,0x4(%esp)
  10456d:	00 
  10456e:	c7 04 24 28 71 10 00 	movl   $0x107128,(%esp)
  104575:	e8 6c be ff ff       	call   1003e6 <__panic>

    const char *str = "ucore: Hello world!!";
  10457a:	c7 45 dc d4 75 10 00 	movl   $0x1075d4,-0x24(%ebp)
    strcpy((void *)0x100, str);
  104581:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104584:	89 44 24 04          	mov    %eax,0x4(%esp)
  104588:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  10458f:	e8 77 18 00 00       	call   105e0b <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  104594:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  10459b:	00 
  10459c:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1045a3:	e8 da 18 00 00       	call   105e82 <strcmp>
  1045a8:	85 c0                	test   %eax,%eax
  1045aa:	74 24                	je     1045d0 <check_boot_pgdir+0x2f7>
  1045ac:	c7 44 24 0c ec 75 10 	movl   $0x1075ec,0xc(%esp)
  1045b3:	00 
  1045b4:	c7 44 24 08 4d 71 10 	movl   $0x10714d,0x8(%esp)
  1045bb:	00 
  1045bc:	c7 44 24 04 41 02 00 	movl   $0x241,0x4(%esp)
  1045c3:	00 
  1045c4:	c7 04 24 28 71 10 00 	movl   $0x107128,(%esp)
  1045cb:	e8 16 be ff ff       	call   1003e6 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  1045d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1045d3:	89 04 24             	mov    %eax,(%esp)
  1045d6:	e8 92 e7 ff ff       	call   102d6d <page2kva>
  1045db:	05 00 01 00 00       	add    $0x100,%eax
  1045e0:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  1045e3:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1045ea:	e8 c6 17 00 00       	call   105db5 <strlen>
  1045ef:	85 c0                	test   %eax,%eax
  1045f1:	74 24                	je     104617 <check_boot_pgdir+0x33e>
  1045f3:	c7 44 24 0c 24 76 10 	movl   $0x107624,0xc(%esp)
  1045fa:	00 
  1045fb:	c7 44 24 08 4d 71 10 	movl   $0x10714d,0x8(%esp)
  104602:	00 
  104603:	c7 44 24 04 44 02 00 	movl   $0x244,0x4(%esp)
  10460a:	00 
  10460b:	c7 04 24 28 71 10 00 	movl   $0x107128,(%esp)
  104612:	e8 cf bd ff ff       	call   1003e6 <__panic>

    free_page(p);
  104617:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10461e:	00 
  10461f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104622:	89 04 24             	mov    %eax,(%esp)
  104625:	e8 2a ea ff ff       	call   103054 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
  10462a:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  10462f:	8b 00                	mov    (%eax),%eax
  104631:	89 04 24             	mov    %eax,(%esp)
  104634:	e8 c6 e7 ff ff       	call   102dff <pde2page>
  104639:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104640:	00 
  104641:	89 04 24             	mov    %eax,(%esp)
  104644:	e8 0b ea ff ff       	call   103054 <free_pages>
    boot_pgdir[0] = 0;
  104649:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  10464e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  104654:	c7 04 24 48 76 10 00 	movl   $0x107648,(%esp)
  10465b:	e8 2e bc ff ff       	call   10028e <cprintf>
}
  104660:	90                   	nop
  104661:	c9                   	leave  
  104662:	c3                   	ret    

00104663 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  104663:	55                   	push   %ebp
  104664:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  104666:	8b 45 08             	mov    0x8(%ebp),%eax
  104669:	83 e0 04             	and    $0x4,%eax
  10466c:	85 c0                	test   %eax,%eax
  10466e:	74 04                	je     104674 <perm2str+0x11>
  104670:	b0 75                	mov    $0x75,%al
  104672:	eb 02                	jmp    104676 <perm2str+0x13>
  104674:	b0 2d                	mov    $0x2d,%al
  104676:	a2 28 df 11 00       	mov    %al,0x11df28
    str[1] = 'r';
  10467b:	c6 05 29 df 11 00 72 	movb   $0x72,0x11df29
    str[2] = (perm & PTE_W) ? 'w' : '-';
  104682:	8b 45 08             	mov    0x8(%ebp),%eax
  104685:	83 e0 02             	and    $0x2,%eax
  104688:	85 c0                	test   %eax,%eax
  10468a:	74 04                	je     104690 <perm2str+0x2d>
  10468c:	b0 77                	mov    $0x77,%al
  10468e:	eb 02                	jmp    104692 <perm2str+0x2f>
  104690:	b0 2d                	mov    $0x2d,%al
  104692:	a2 2a df 11 00       	mov    %al,0x11df2a
    str[3] = '\0';
  104697:	c6 05 2b df 11 00 00 	movb   $0x0,0x11df2b
    return str;
  10469e:	b8 28 df 11 00       	mov    $0x11df28,%eax
}
  1046a3:	5d                   	pop    %ebp
  1046a4:	c3                   	ret    

001046a5 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  1046a5:	55                   	push   %ebp
  1046a6:	89 e5                	mov    %esp,%ebp
  1046a8:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  1046ab:	8b 45 10             	mov    0x10(%ebp),%eax
  1046ae:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1046b1:	72 0d                	jb     1046c0 <get_pgtable_items+0x1b>
        return 0;
  1046b3:	b8 00 00 00 00       	mov    $0x0,%eax
  1046b8:	e9 98 00 00 00       	jmp    104755 <get_pgtable_items+0xb0>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
  1046bd:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
  1046c0:	8b 45 10             	mov    0x10(%ebp),%eax
  1046c3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1046c6:	73 18                	jae    1046e0 <get_pgtable_items+0x3b>
  1046c8:	8b 45 10             	mov    0x10(%ebp),%eax
  1046cb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1046d2:	8b 45 14             	mov    0x14(%ebp),%eax
  1046d5:	01 d0                	add    %edx,%eax
  1046d7:	8b 00                	mov    (%eax),%eax
  1046d9:	83 e0 01             	and    $0x1,%eax
  1046dc:	85 c0                	test   %eax,%eax
  1046de:	74 dd                	je     1046bd <get_pgtable_items+0x18>
    }
    if (start < right) {
  1046e0:	8b 45 10             	mov    0x10(%ebp),%eax
  1046e3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1046e6:	73 68                	jae    104750 <get_pgtable_items+0xab>
        if (left_store != NULL) {
  1046e8:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  1046ec:	74 08                	je     1046f6 <get_pgtable_items+0x51>
            *left_store = start;
  1046ee:	8b 45 18             	mov    0x18(%ebp),%eax
  1046f1:	8b 55 10             	mov    0x10(%ebp),%edx
  1046f4:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  1046f6:	8b 45 10             	mov    0x10(%ebp),%eax
  1046f9:	8d 50 01             	lea    0x1(%eax),%edx
  1046fc:	89 55 10             	mov    %edx,0x10(%ebp)
  1046ff:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  104706:	8b 45 14             	mov    0x14(%ebp),%eax
  104709:	01 d0                	add    %edx,%eax
  10470b:	8b 00                	mov    (%eax),%eax
  10470d:	83 e0 07             	and    $0x7,%eax
  104710:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  104713:	eb 03                	jmp    104718 <get_pgtable_items+0x73>
            start ++;
  104715:	ff 45 10             	incl   0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  104718:	8b 45 10             	mov    0x10(%ebp),%eax
  10471b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10471e:	73 1d                	jae    10473d <get_pgtable_items+0x98>
  104720:	8b 45 10             	mov    0x10(%ebp),%eax
  104723:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10472a:	8b 45 14             	mov    0x14(%ebp),%eax
  10472d:	01 d0                	add    %edx,%eax
  10472f:	8b 00                	mov    (%eax),%eax
  104731:	83 e0 07             	and    $0x7,%eax
  104734:	89 c2                	mov    %eax,%edx
  104736:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104739:	39 c2                	cmp    %eax,%edx
  10473b:	74 d8                	je     104715 <get_pgtable_items+0x70>
        }
        if (right_store != NULL) {
  10473d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  104741:	74 08                	je     10474b <get_pgtable_items+0xa6>
            *right_store = start;
  104743:	8b 45 1c             	mov    0x1c(%ebp),%eax
  104746:	8b 55 10             	mov    0x10(%ebp),%edx
  104749:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  10474b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10474e:	eb 05                	jmp    104755 <get_pgtable_items+0xb0>
    }
    return 0;
  104750:	b8 00 00 00 00       	mov    $0x0,%eax
}
  104755:	c9                   	leave  
  104756:	c3                   	ret    

00104757 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  104757:	55                   	push   %ebp
  104758:	89 e5                	mov    %esp,%ebp
  10475a:	57                   	push   %edi
  10475b:	56                   	push   %esi
  10475c:	53                   	push   %ebx
  10475d:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  104760:	c7 04 24 68 76 10 00 	movl   $0x107668,(%esp)
  104767:	e8 22 bb ff ff       	call   10028e <cprintf>
    size_t left, right = 0, perm;
  10476c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  104773:	e9 fa 00 00 00       	jmp    104872 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  104778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10477b:	89 04 24             	mov    %eax,(%esp)
  10477e:	e8 e0 fe ff ff       	call   104663 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  104783:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  104786:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104789:	29 d1                	sub    %edx,%ecx
  10478b:	89 ca                	mov    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  10478d:	89 d6                	mov    %edx,%esi
  10478f:	c1 e6 16             	shl    $0x16,%esi
  104792:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104795:	89 d3                	mov    %edx,%ebx
  104797:	c1 e3 16             	shl    $0x16,%ebx
  10479a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10479d:	89 d1                	mov    %edx,%ecx
  10479f:	c1 e1 16             	shl    $0x16,%ecx
  1047a2:	8b 7d dc             	mov    -0x24(%ebp),%edi
  1047a5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1047a8:	29 d7                	sub    %edx,%edi
  1047aa:	89 fa                	mov    %edi,%edx
  1047ac:	89 44 24 14          	mov    %eax,0x14(%esp)
  1047b0:	89 74 24 10          	mov    %esi,0x10(%esp)
  1047b4:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1047b8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1047bc:	89 54 24 04          	mov    %edx,0x4(%esp)
  1047c0:	c7 04 24 99 76 10 00 	movl   $0x107699,(%esp)
  1047c7:	e8 c2 ba ff ff       	call   10028e <cprintf>
        size_t l, r = left * NPTEENTRY;
  1047cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1047cf:	c1 e0 0a             	shl    $0xa,%eax
  1047d2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  1047d5:	eb 54                	jmp    10482b <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  1047d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1047da:	89 04 24             	mov    %eax,(%esp)
  1047dd:	e8 81 fe ff ff       	call   104663 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  1047e2:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  1047e5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1047e8:	29 d1                	sub    %edx,%ecx
  1047ea:	89 ca                	mov    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  1047ec:	89 d6                	mov    %edx,%esi
  1047ee:	c1 e6 0c             	shl    $0xc,%esi
  1047f1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1047f4:	89 d3                	mov    %edx,%ebx
  1047f6:	c1 e3 0c             	shl    $0xc,%ebx
  1047f9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1047fc:	89 d1                	mov    %edx,%ecx
  1047fe:	c1 e1 0c             	shl    $0xc,%ecx
  104801:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  104804:	8b 55 d8             	mov    -0x28(%ebp),%edx
  104807:	29 d7                	sub    %edx,%edi
  104809:	89 fa                	mov    %edi,%edx
  10480b:	89 44 24 14          	mov    %eax,0x14(%esp)
  10480f:	89 74 24 10          	mov    %esi,0x10(%esp)
  104813:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  104817:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  10481b:	89 54 24 04          	mov    %edx,0x4(%esp)
  10481f:	c7 04 24 b8 76 10 00 	movl   $0x1076b8,(%esp)
  104826:	e8 63 ba ff ff       	call   10028e <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  10482b:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
  104830:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104833:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104836:	89 d3                	mov    %edx,%ebx
  104838:	c1 e3 0a             	shl    $0xa,%ebx
  10483b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10483e:	89 d1                	mov    %edx,%ecx
  104840:	c1 e1 0a             	shl    $0xa,%ecx
  104843:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  104846:	89 54 24 14          	mov    %edx,0x14(%esp)
  10484a:	8d 55 d8             	lea    -0x28(%ebp),%edx
  10484d:	89 54 24 10          	mov    %edx,0x10(%esp)
  104851:	89 74 24 0c          	mov    %esi,0xc(%esp)
  104855:	89 44 24 08          	mov    %eax,0x8(%esp)
  104859:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  10485d:	89 0c 24             	mov    %ecx,(%esp)
  104860:	e8 40 fe ff ff       	call   1046a5 <get_pgtable_items>
  104865:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104868:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10486c:	0f 85 65 ff ff ff    	jne    1047d7 <print_pgdir+0x80>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  104872:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
  104877:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10487a:	8d 55 dc             	lea    -0x24(%ebp),%edx
  10487d:	89 54 24 14          	mov    %edx,0x14(%esp)
  104881:	8d 55 e0             	lea    -0x20(%ebp),%edx
  104884:	89 54 24 10          	mov    %edx,0x10(%esp)
  104888:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  10488c:	89 44 24 08          	mov    %eax,0x8(%esp)
  104890:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  104897:	00 
  104898:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10489f:	e8 01 fe ff ff       	call   1046a5 <get_pgtable_items>
  1048a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1048a7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1048ab:	0f 85 c7 fe ff ff    	jne    104778 <print_pgdir+0x21>
        }
    }
    cprintf("--------------------- END ---------------------\n");
  1048b1:	c7 04 24 dc 76 10 00 	movl   $0x1076dc,(%esp)
  1048b8:	e8 d1 b9 ff ff       	call   10028e <cprintf>
}
  1048bd:	90                   	nop
  1048be:	83 c4 4c             	add    $0x4c,%esp
  1048c1:	5b                   	pop    %ebx
  1048c2:	5e                   	pop    %esi
  1048c3:	5f                   	pop    %edi
  1048c4:	5d                   	pop    %ebp
  1048c5:	c3                   	ret    

001048c6 <page2ppn>:
page2ppn(struct Page *page) {
  1048c6:	55                   	push   %ebp
  1048c7:	89 e5                	mov    %esp,%ebp
    return page - pages;
  1048c9:	a1 38 df 11 00       	mov    0x11df38,%eax
  1048ce:	8b 55 08             	mov    0x8(%ebp),%edx
  1048d1:	29 c2                	sub    %eax,%edx
  1048d3:	89 d0                	mov    %edx,%eax
  1048d5:	c1 f8 02             	sar    $0x2,%eax
  1048d8:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  1048de:	5d                   	pop    %ebp
  1048df:	c3                   	ret    

001048e0 <page2pa>:
page2pa(struct Page *page) {
  1048e0:	55                   	push   %ebp
  1048e1:	89 e5                	mov    %esp,%ebp
  1048e3:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  1048e6:	8b 45 08             	mov    0x8(%ebp),%eax
  1048e9:	89 04 24             	mov    %eax,(%esp)
  1048ec:	e8 d5 ff ff ff       	call   1048c6 <page2ppn>
  1048f1:	c1 e0 0c             	shl    $0xc,%eax
}
  1048f4:	c9                   	leave  
  1048f5:	c3                   	ret    

001048f6 <page_ref>:
page_ref(struct Page *page) {
  1048f6:	55                   	push   %ebp
  1048f7:	89 e5                	mov    %esp,%ebp
    return page->ref;
  1048f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1048fc:	8b 00                	mov    (%eax),%eax
}
  1048fe:	5d                   	pop    %ebp
  1048ff:	c3                   	ret    

00104900 <set_page_ref>:
set_page_ref(struct Page *page, int val) {
  104900:	55                   	push   %ebp
  104901:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  104903:	8b 45 08             	mov    0x8(%ebp),%eax
  104906:	8b 55 0c             	mov    0xc(%ebp),%edx
  104909:	89 10                	mov    %edx,(%eax)
}
  10490b:	90                   	nop
  10490c:	5d                   	pop    %ebp
  10490d:	c3                   	ret    

0010490e <default_init>:
#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)


static void
default_init(void) {
  10490e:	55                   	push   %ebp
  10490f:	89 e5                	mov    %esp,%ebp
  104911:	83 ec 10             	sub    $0x10,%esp
  104914:	c7 45 fc 3c df 11 00 	movl   $0x11df3c,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  10491b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10491e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  104921:	89 50 04             	mov    %edx,0x4(%eax)
  104924:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104927:	8b 50 04             	mov    0x4(%eax),%edx
  10492a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10492d:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
  10492f:	c7 05 44 df 11 00 00 	movl   $0x0,0x11df44
  104936:	00 00 00 
}
  104939:	90                   	nop
  10493a:	c9                   	leave  
  10493b:	c3                   	ret    

0010493c <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
  10493c:	55                   	push   %ebp
  10493d:	89 e5                	mov    %esp,%ebp
  10493f:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
  104942:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  104946:	75 24                	jne    10496c <default_init_memmap+0x30>
  104948:	c7 44 24 0c 10 77 10 	movl   $0x107710,0xc(%esp)
  10494f:	00 
  104950:	c7 44 24 08 16 77 10 	movl   $0x107716,0x8(%esp)
  104957:	00 
  104958:	c7 44 24 04 6f 00 00 	movl   $0x6f,0x4(%esp)
  10495f:	00 
  104960:	c7 04 24 2b 77 10 00 	movl   $0x10772b,(%esp)
  104967:	e8 7a ba ff ff       	call   1003e6 <__panic>
    struct Page *p = base;
  10496c:	8b 45 08             	mov    0x8(%ebp),%eax
  10496f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  104972:	e9 b3 00 00 00       	jmp    104a2a <default_init_memmap+0xee>
		// 在查找可用内存并分配struct Page数组时就已经将将全部Page设置为Reserved
		// 将Page标记为可用的:清除Reserved,设置Property,并把property设置为0( 不是空闲块的第一个物理页 )
        assert(PageReserved(p));
  104977:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10497a:	83 c0 04             	add    $0x4,%eax
  10497d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  104984:	89 45 ec             	mov    %eax,-0x14(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104987:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10498a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10498d:	0f a3 10             	bt     %edx,(%eax)
  104990:	19 c0                	sbb    %eax,%eax
  104992:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  104995:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  104999:	0f 95 c0             	setne  %al
  10499c:	0f b6 c0             	movzbl %al,%eax
  10499f:	85 c0                	test   %eax,%eax
  1049a1:	75 24                	jne    1049c7 <default_init_memmap+0x8b>
  1049a3:	c7 44 24 0c 41 77 10 	movl   $0x107741,0xc(%esp)
  1049aa:	00 
  1049ab:	c7 44 24 08 16 77 10 	movl   $0x107716,0x8(%esp)
  1049b2:	00 
  1049b3:	c7 44 24 04 74 00 00 	movl   $0x74,0x4(%esp)
  1049ba:	00 
  1049bb:	c7 04 24 2b 77 10 00 	movl   $0x10772b,(%esp)
  1049c2:	e8 1f ba ff ff       	call   1003e6 <__panic>
        p->flags = p->property = 0;
  1049c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1049ca:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  1049d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1049d4:	8b 50 08             	mov    0x8(%eax),%edx
  1049d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1049da:	89 50 04             	mov    %edx,0x4(%eax)
		SetPageProperty(p);
  1049dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1049e0:	83 c0 04             	add    $0x4,%eax
  1049e3:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  1049ea:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1049ed:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1049f0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1049f3:	0f ab 10             	bts    %edx,(%eax)
        set_page_ref(p, 0);
  1049f6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1049fd:	00 
  1049fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104a01:	89 04 24             	mov    %eax,(%esp)
  104a04:	e8 f7 fe ff ff       	call   104900 <set_page_ref>
		list_init(&(p->page_link));
  104a09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104a0c:	83 c0 0c             	add    $0xc,%eax
  104a0f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104a12:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104a15:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104a18:	89 50 04             	mov    %edx,0x4(%eax)
  104a1b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104a1e:	8b 50 04             	mov    0x4(%eax),%edx
  104a21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104a24:	89 10                	mov    %edx,(%eax)
    for (; p != base + n; p ++) {
  104a26:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  104a2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  104a2d:	89 d0                	mov    %edx,%eax
  104a2f:	c1 e0 02             	shl    $0x2,%eax
  104a32:	01 d0                	add    %edx,%eax
  104a34:	c1 e0 02             	shl    $0x2,%eax
  104a37:	89 c2                	mov    %eax,%edx
  104a39:	8b 45 08             	mov    0x8(%ebp),%eax
  104a3c:	01 d0                	add    %edx,%eax
  104a3e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104a41:	0f 85 30 ff ff ff    	jne    104977 <default_init_memmap+0x3b>
    }
	cprintf("Page address is %x\n", (uintptr_t)base);
  104a47:	8b 45 08             	mov    0x8(%ebp),%eax
  104a4a:	89 44 24 04          	mov    %eax,0x4(%esp)
  104a4e:	c7 04 24 51 77 10 00 	movl   $0x107751,(%esp)
  104a55:	e8 34 b8 ff ff       	call   10028e <cprintf>
    base->property = n;
  104a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  104a5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  104a60:	89 50 08             	mov    %edx,0x8(%eax)
    nr_free += n;
  104a63:	8b 15 44 df 11 00    	mov    0x11df44,%edx
  104a69:	8b 45 0c             	mov    0xc(%ebp),%eax
  104a6c:	01 d0                	add    %edx,%eax
  104a6e:	a3 44 df 11 00       	mov    %eax,0x11df44
    list_add(free_list.prev, &(base->page_link));
  104a73:	8b 45 08             	mov    0x8(%ebp),%eax
  104a76:	8d 50 0c             	lea    0xc(%eax),%edx
  104a79:	a1 3c df 11 00       	mov    0x11df3c,%eax
  104a7e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  104a81:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  104a84:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104a87:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104a8a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104a8d:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  104a90:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104a93:	8b 40 04             	mov    0x4(%eax),%eax
  104a96:	8b 55 cc             	mov    -0x34(%ebp),%edx
  104a99:	89 55 c8             	mov    %edx,-0x38(%ebp)
  104a9c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104a9f:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  104aa2:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  104aa5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  104aa8:	8b 55 c8             	mov    -0x38(%ebp),%edx
  104aab:	89 10                	mov    %edx,(%eax)
  104aad:	8b 45 c0             	mov    -0x40(%ebp),%eax
  104ab0:	8b 10                	mov    (%eax),%edx
  104ab2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104ab5:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  104ab8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104abb:	8b 55 c0             	mov    -0x40(%ebp),%edx
  104abe:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  104ac1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104ac4:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  104ac7:	89 10                	mov    %edx,(%eax)
}
  104ac9:	90                   	nop
  104aca:	c9                   	leave  
  104acb:	c3                   	ret    

00104acc <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
  104acc:	55                   	push   %ebp
  104acd:	89 e5                	mov    %esp,%ebp
  104acf:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
  104ad2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  104ad6:	75 24                	jne    104afc <default_alloc_pages+0x30>
  104ad8:	c7 44 24 0c 10 77 10 	movl   $0x107710,0xc(%esp)
  104adf:	00 
  104ae0:	c7 44 24 08 16 77 10 	movl   $0x107716,0x8(%esp)
  104ae7:	00 
  104ae8:	c7 44 24 04 82 00 00 	movl   $0x82,0x4(%esp)
  104aef:	00 
  104af0:	c7 04 24 2b 77 10 00 	movl   $0x10772b,(%esp)
  104af7:	e8 ea b8 ff ff       	call   1003e6 <__panic>
	/* There are not enough physical memory */
    if (n > nr_free) {
  104afc:	a1 44 df 11 00       	mov    0x11df44,%eax
  104b01:	39 45 08             	cmp    %eax,0x8(%ebp)
  104b04:	76 26                	jbe    104b2c <default_alloc_pages+0x60>
		warn("memory shortage");
  104b06:	c7 44 24 08 65 77 10 	movl   $0x107765,0x8(%esp)
  104b0d:	00 
  104b0e:	c7 44 24 04 85 00 00 	movl   $0x85,0x4(%esp)
  104b15:	00 
  104b16:	c7 04 24 2b 77 10 00 	movl   $0x10772b,(%esp)
  104b1d:	e8 42 b9 ff ff       	call   100464 <__warn>
        return NULL;
  104b22:	b8 00 00 00 00       	mov    $0x0,%eax
  104b27:	e9 96 01 00 00       	jmp    104cc2 <default_alloc_pages+0x1f6>
    }
    struct Page *page = NULL;
  104b2c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	struct Page *p    = NULL;
  104b33:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  104b3a:	c7 45 ec 3c df 11 00 	movl   $0x11df3c,-0x14(%ebp)
	/* try to find empty space to allocate */
    while ((le = list_next(le)) != &free_list) {
  104b41:	eb 1c                	jmp    104b5f <default_alloc_pages+0x93>
        p = le2page(le, page_link);
  104b43:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104b46:	83 e8 0c             	sub    $0xc,%eax
  104b49:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p->property >= n) {
  104b4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104b4f:	8b 40 08             	mov    0x8(%eax),%eax
  104b52:	39 45 08             	cmp    %eax,0x8(%ebp)
  104b55:	77 08                	ja     104b5f <default_alloc_pages+0x93>
            page = p;
  104b57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104b5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  104b5d:	eb 18                	jmp    104b77 <default_alloc_pages+0xab>
  104b5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104b62:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return listelm->next;
  104b65:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104b68:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  104b6b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104b6e:	81 7d ec 3c df 11 00 	cmpl   $0x11df3c,-0x14(%ebp)
  104b75:	75 cc                	jne    104b43 <default_alloc_pages+0x77>
        }
    }
	/* external fragmentation */
	if (page == NULL) {
  104b77:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104b7b:	75 26                	jne    104ba3 <default_alloc_pages+0xd7>
		warn("external fragmentation: There are enough memory, but can't find continuous space to allocate");
  104b7d:	c7 44 24 08 78 77 10 	movl   $0x107778,0x8(%esp)
  104b84:	00 
  104b85:	c7 44 24 04 95 00 00 	movl   $0x95,0x4(%esp)
  104b8c:	00 
  104b8d:	c7 04 24 2b 77 10 00 	movl   $0x10772b,(%esp)
  104b94:	e8 cb b8 ff ff       	call   100464 <__warn>
		return NULL;
  104b99:	b8 00 00 00 00       	mov    $0x0,%eax
  104b9e:	e9 1f 01 00 00       	jmp    104cc2 <default_alloc_pages+0x1f6>
	}

	unsigned int property = page->property;
  104ba3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104ba6:	8b 40 08             	mov    0x8(%eax),%eax
  104ba9:	89 45 e8             	mov    %eax,-0x18(%ebp)
	/* modify pages in allocated block(except of first page)*/
	p = page + 1;
  104bac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104baf:	83 c0 14             	add    $0x14,%eax
  104bb2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	for (; p < page + n; ++p) {
  104bb5:	eb 1d                	jmp    104bd4 <default_alloc_pages+0x108>
		ClearPageProperty(p);
  104bb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104bba:	83 c0 04             	add    $0x4,%eax
  104bbd:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  104bc4:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104bc7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104bca:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104bcd:	0f b3 10             	btr    %edx,(%eax)
	for (; p < page + n; ++p) {
  104bd0:	83 45 f0 14          	addl   $0x14,-0x10(%ebp)
  104bd4:	8b 55 08             	mov    0x8(%ebp),%edx
  104bd7:	89 d0                	mov    %edx,%eax
  104bd9:	c1 e0 02             	shl    $0x2,%eax
  104bdc:	01 d0                	add    %edx,%eax
  104bde:	c1 e0 02             	shl    $0x2,%eax
  104be1:	89 c2                	mov    %eax,%edx
  104be3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104be6:	01 d0                	add    %edx,%eax
  104be8:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  104beb:	72 ca                	jb     104bb7 <default_alloc_pages+0xeb>
		// property is zero, so we needn't modiry it.
	}
	/* modify first page of allcoated block */
	ClearPageProperty(page);
  104bed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104bf0:	83 c0 04             	add    $0x4,%eax
  104bf3:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
  104bfa:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  104bfd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104c00:	8b 55 d8             	mov    -0x28(%ebp),%edx
  104c03:	0f b3 10             	btr    %edx,(%eax)
	page->property = n;
  104c06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104c09:	8b 55 08             	mov    0x8(%ebp),%edx
  104c0c:	89 50 08             	mov    %edx,0x8(%eax)
	nr_free -= n;
  104c0f:	a1 44 df 11 00       	mov    0x11df44,%eax
  104c14:	2b 45 08             	sub    0x8(%ebp),%eax
  104c17:	a3 44 df 11 00       	mov    %eax,0x11df44
	/*
	 * If block size is bigger than requested size, split it;
	 * */
	if (property > n) {
  104c1c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104c1f:	3b 45 08             	cmp    0x8(%ebp),%eax
  104c22:	76 70                	jbe    104c94 <default_alloc_pages+0x1c8>
		p = page + n;
  104c24:	8b 55 08             	mov    0x8(%ebp),%edx
  104c27:	89 d0                	mov    %edx,%eax
  104c29:	c1 e0 02             	shl    $0x2,%eax
  104c2c:	01 d0                	add    %edx,%eax
  104c2e:	c1 e0 02             	shl    $0x2,%eax
  104c31:	89 c2                	mov    %eax,%edx
  104c33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104c36:	01 d0                	add    %edx,%eax
  104c38:	89 45 f0             	mov    %eax,-0x10(%ebp)
		p->property = property - n;
  104c3b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104c3e:	2b 45 08             	sub    0x8(%ebp),%eax
  104c41:	89 c2                	mov    %eax,%edx
  104c43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104c46:	89 50 08             	mov    %edx,0x8(%eax)
		list_add_after(&(page->page_link), &(p->page_link));
  104c49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104c4c:	83 c0 0c             	add    $0xc,%eax
  104c4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104c52:	83 c2 0c             	add    $0xc,%edx
  104c55:	89 55 d0             	mov    %edx,-0x30(%ebp)
  104c58:	89 45 cc             	mov    %eax,-0x34(%ebp)
    __list_add(elm, listelm, listelm->next);
  104c5b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104c5e:	8b 40 04             	mov    0x4(%eax),%eax
  104c61:	8b 55 cc             	mov    -0x34(%ebp),%edx
  104c64:	89 55 c8             	mov    %edx,-0x38(%ebp)
  104c67:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104c6a:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  104c6d:	89 45 c0             	mov    %eax,-0x40(%ebp)
    prev->next = next->prev = elm;
  104c70:	8b 45 c0             	mov    -0x40(%ebp),%eax
  104c73:	8b 55 c8             	mov    -0x38(%ebp),%edx
  104c76:	89 10                	mov    %edx,(%eax)
  104c78:	8b 45 c0             	mov    -0x40(%ebp),%eax
  104c7b:	8b 10                	mov    (%eax),%edx
  104c7d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104c80:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  104c83:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104c86:	8b 55 c0             	mov    -0x40(%ebp),%edx
  104c89:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  104c8c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104c8f:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  104c92:	89 10                	mov    %edx,(%eax)
	}
	list_del(&(page->page_link));
  104c94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104c97:	83 c0 0c             	add    $0xc,%eax
  104c9a:	89 45 bc             	mov    %eax,-0x44(%ebp)
    __list_del(listelm->prev, listelm->next);
  104c9d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  104ca0:	8b 40 04             	mov    0x4(%eax),%eax
  104ca3:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104ca6:	8b 12                	mov    (%edx),%edx
  104ca8:	89 55 b8             	mov    %edx,-0x48(%ebp)
  104cab:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  104cae:	8b 45 b8             	mov    -0x48(%ebp),%eax
  104cb1:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  104cb4:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  104cb7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  104cba:	8b 55 b8             	mov    -0x48(%ebp),%edx
  104cbd:	89 10                	mov    %edx,(%eax)
    return page;
  104cbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  104cc2:	c9                   	leave  
  104cc3:	c3                   	ret    

00104cc4 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
  104cc4:	55                   	push   %ebp
  104cc5:	89 e5                	mov    %esp,%ebp
  104cc7:	81 ec c8 00 00 00    	sub    $0xc8,%esp
    assert(n > 0);
  104ccd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  104cd1:	75 24                	jne    104cf7 <default_free_pages+0x33>
  104cd3:	c7 44 24 0c 10 77 10 	movl   $0x107710,0xc(%esp)
  104cda:	00 
  104cdb:	c7 44 24 08 16 77 10 	movl   $0x107716,0x8(%esp)
  104ce2:	00 
  104ce3:	c7 44 24 04 b2 00 00 	movl   $0xb2,0x4(%esp)
  104cea:	00 
  104ceb:	c7 04 24 2b 77 10 00 	movl   $0x10772b,(%esp)
  104cf2:	e8 ef b6 ff ff       	call   1003e6 <__panic>
	 */

	/* find the beginning of the allocated block.
	 * only begging page's #property fild is non-zero.
	 */
    struct Page *begin = base;
  104cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  104cfa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	size_t count = 0;
  104cfd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	for ( ; begin->property == 0; ++count, --begin) {
  104d04:	e9 83 00 00 00       	jmp    104d8c <default_free_pages+0xc8>
		assert(!PageReserved(begin) && !PageProperty(begin));
  104d09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104d0c:	83 c0 04             	add    $0x4,%eax
  104d0f:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  104d16:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104d19:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104d1c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  104d1f:	0f a3 10             	bt     %edx,(%eax)
  104d22:	19 c0                	sbb    %eax,%eax
  104d24:	89 45 d0             	mov    %eax,-0x30(%ebp)
    return oldbit != 0;
  104d27:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  104d2b:	0f 95 c0             	setne  %al
  104d2e:	0f b6 c0             	movzbl %al,%eax
  104d31:	85 c0                	test   %eax,%eax
  104d33:	75 2c                	jne    104d61 <default_free_pages+0x9d>
  104d35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104d38:	83 c0 04             	add    $0x4,%eax
  104d3b:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  104d42:	89 45 c8             	mov    %eax,-0x38(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104d45:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104d48:	8b 55 cc             	mov    -0x34(%ebp),%edx
  104d4b:	0f a3 10             	bt     %edx,(%eax)
  104d4e:	19 c0                	sbb    %eax,%eax
  104d50:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return oldbit != 0;
  104d53:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  104d57:	0f 95 c0             	setne  %al
  104d5a:	0f b6 c0             	movzbl %al,%eax
  104d5d:	85 c0                	test   %eax,%eax
  104d5f:	74 24                	je     104d85 <default_free_pages+0xc1>
  104d61:	c7 44 24 0c d8 77 10 	movl   $0x1077d8,0xc(%esp)
  104d68:	00 
  104d69:	c7 44 24 08 16 77 10 	movl   $0x107716,0x8(%esp)
  104d70:	00 
  104d71:	c7 44 24 04 be 00 00 	movl   $0xbe,0x4(%esp)
  104d78:	00 
  104d79:	c7 04 24 2b 77 10 00 	movl   $0x10772b,(%esp)
  104d80:	e8 61 b6 ff ff       	call   1003e6 <__panic>
	for ( ; begin->property == 0; ++count, --begin) {
  104d85:	ff 45 f0             	incl   -0x10(%ebp)
  104d88:	83 6d f4 14          	subl   $0x14,-0xc(%ebp)
  104d8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104d8f:	8b 40 08             	mov    0x8(%eax),%eax
  104d92:	85 c0                	test   %eax,%eax
  104d94:	0f 84 6f ff ff ff    	je     104d09 <default_free_pages+0x45>
	/* If @base is not the beginning of the allocated block,
	 * split the allocated block into two part. 
	 * One part is @begin to @base, 
	 * other part is @base to the end of the original part.
	 */
	if (begin != base) {
  104d9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104d9d:	3b 45 08             	cmp    0x8(%ebp),%eax
  104da0:	74 1a                	je     104dbc <default_free_pages+0xf8>
		base->property  = begin->property - count;
  104da2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104da5:	8b 40 08             	mov    0x8(%eax),%eax
  104da8:	2b 45 f0             	sub    -0x10(%ebp),%eax
  104dab:	89 c2                	mov    %eax,%edx
  104dad:	8b 45 08             	mov    0x8(%ebp),%eax
  104db0:	89 50 08             	mov    %edx,0x8(%eax)
		begin->property = count;
  104db3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104db6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  104db9:	89 50 08             	mov    %edx,0x8(%eax)
	}
	
	/* If @n is bigger than the number of pages in the @base block,
	 * it is not an error, just free all pages in block.
	 */
	if (n > base->property) {
  104dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  104dbf:	8b 40 08             	mov    0x8(%eax),%eax
  104dc2:	39 45 0c             	cmp    %eax,0xc(%ebp)
  104dc5:	76 0b                	jbe    104dd2 <default_free_pages+0x10e>
		n = base->property;
  104dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  104dca:	8b 40 08             	mov    0x8(%eax),%eax
  104dcd:	89 45 0c             	mov    %eax,0xc(%ebp)
  104dd0:	eb 36                	jmp    104e08 <default_free_pages+0x144>
	}
	/* If @n is smaller than the number of pages in @base block,
	 * split @base block into two block.
	 */
	else if (n < base->property) {
  104dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  104dd5:	8b 40 08             	mov    0x8(%eax),%eax
  104dd8:	39 45 0c             	cmp    %eax,0xc(%ebp)
  104ddb:	73 2b                	jae    104e08 <default_free_pages+0x144>
		(base + n)->property = base->property - n;
  104ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  104de0:	8b 48 08             	mov    0x8(%eax),%ecx
  104de3:	8b 55 0c             	mov    0xc(%ebp),%edx
  104de6:	89 d0                	mov    %edx,%eax
  104de8:	c1 e0 02             	shl    $0x2,%eax
  104deb:	01 d0                	add    %edx,%eax
  104ded:	c1 e0 02             	shl    $0x2,%eax
  104df0:	89 c2                	mov    %eax,%edx
  104df2:	8b 45 08             	mov    0x8(%ebp),%eax
  104df5:	01 c2                	add    %eax,%edx
  104df7:	89 c8                	mov    %ecx,%eax
  104df9:	2b 45 0c             	sub    0xc(%ebp),%eax
  104dfc:	89 42 08             	mov    %eax,0x8(%edx)
		base->property = n;
  104dff:	8b 45 08             	mov    0x8(%ebp),%eax
  104e02:	8b 55 0c             	mov    0xc(%ebp),%edx
  104e05:	89 50 08             	mov    %edx,0x8(%eax)
	}	
	/* modify status information */
	struct Page *p = base;
  104e08:	8b 45 08             	mov    0x8(%ebp),%eax
  104e0b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for (; p != base + n; ++p) {
  104e0e:	e9 b6 00 00 00       	jmp    104ec9 <default_free_pages+0x205>
        assert(!PageReserved(p) && !PageProperty(p));
  104e13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104e16:	83 c0 04             	add    $0x4,%eax
  104e19:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  104e20:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104e23:	8b 45 bc             	mov    -0x44(%ebp),%eax
  104e26:	8b 55 c0             	mov    -0x40(%ebp),%edx
  104e29:	0f a3 10             	bt     %edx,(%eax)
  104e2c:	19 c0                	sbb    %eax,%eax
  104e2e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  104e31:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  104e35:	0f 95 c0             	setne  %al
  104e38:	0f b6 c0             	movzbl %al,%eax
  104e3b:	85 c0                	test   %eax,%eax
  104e3d:	75 2c                	jne    104e6b <default_free_pages+0x1a7>
  104e3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104e42:	83 c0 04             	add    $0x4,%eax
  104e45:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
  104e4c:	89 45 b0             	mov    %eax,-0x50(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104e4f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  104e52:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  104e55:	0f a3 10             	bt     %edx,(%eax)
  104e58:	19 c0                	sbb    %eax,%eax
  104e5a:	89 45 ac             	mov    %eax,-0x54(%ebp)
    return oldbit != 0;
  104e5d:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
  104e61:	0f 95 c0             	setne  %al
  104e64:	0f b6 c0             	movzbl %al,%eax
  104e67:	85 c0                	test   %eax,%eax
  104e69:	74 24                	je     104e8f <default_free_pages+0x1cb>
  104e6b:	c7 44 24 0c 08 78 10 	movl   $0x107808,0xc(%esp)
  104e72:	00 
  104e73:	c7 44 24 08 16 77 10 	movl   $0x107716,0x8(%esp)
  104e7a:	00 
  104e7b:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
  104e82:	00 
  104e83:	c7 04 24 2b 77 10 00 	movl   $0x10772b,(%esp)
  104e8a:	e8 57 b5 ff ff       	call   1003e6 <__panic>
        p->flags = 0;
  104e8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104e92:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
		SetPageProperty(p);
  104e99:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104e9c:	83 c0 04             	add    $0x4,%eax
  104e9f:	c7 45 a8 01 00 00 00 	movl   $0x1,-0x58(%ebp)
  104ea6:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104ea9:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  104eac:	8b 55 a8             	mov    -0x58(%ebp),%edx
  104eaf:	0f ab 10             	bts    %edx,(%eax)
		set_page_ref(p, 0);
  104eb2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104eb9:	00 
  104eba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104ebd:	89 04 24             	mov    %eax,(%esp)
  104ec0:	e8 3b fa ff ff       	call   104900 <set_page_ref>
    for (; p != base + n; ++p) {
  104ec5:	83 45 ec 14          	addl   $0x14,-0x14(%ebp)
  104ec9:	8b 55 0c             	mov    0xc(%ebp),%edx
  104ecc:	89 d0                	mov    %edx,%eax
  104ece:	c1 e0 02             	shl    $0x2,%eax
  104ed1:	01 d0                	add    %edx,%eax
  104ed3:	c1 e0 02             	shl    $0x2,%eax
  104ed6:	89 c2                	mov    %eax,%edx
  104ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  104edb:	01 d0                	add    %edx,%eax
  104edd:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  104ee0:	0f 85 2d ff ff ff    	jne    104e13 <default_free_pages+0x14f>
  104ee6:	c7 45 a0 3c df 11 00 	movl   $0x11df3c,-0x60(%ebp)
    return listelm->next;
  104eed:	8b 45 a0             	mov    -0x60(%ebp),%eax
  104ef0:	8b 40 04             	mov    0x4(%eax),%eax

	 // list_add(pos, &base->page_link);
	 // nr_free += n;
	
	 /* merge adjcent free blocks */
  	 list_entry_t *le = list_next(&free_list), *pos = free_list.prev, *merge_before_ptr = NULL;
  104ef3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104ef6:	a1 3c df 11 00       	mov    0x11df3c,%eax
  104efb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104efe:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	 unsigned int old_base_property = base->property;
  104f05:	8b 45 08             	mov    0x8(%ebp),%eax
  104f08:	8b 40 08             	mov    0x8(%eax),%eax
  104f0b:	89 45 dc             	mov    %eax,-0x24(%ebp)
	 /* merge free blocks */
 	 while (le != &free_list) {
  104f0e:	e9 f8 00 00 00       	jmp    10500b <default_free_pages+0x347>
		 p = le2page(le, page_link);
  104f13:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104f16:	83 e8 0c             	sub    $0xc,%eax
  104f19:	89 45 ec             	mov    %eax,-0x14(%ebp)
		 /* free_list is ascending sorted, only one free block before @base block will be merged */
		 if ((p + p->property == base)) {
  104f1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104f1f:	8b 50 08             	mov    0x8(%eax),%edx
  104f22:	89 d0                	mov    %edx,%eax
  104f24:	c1 e0 02             	shl    $0x2,%eax
  104f27:	01 d0                	add    %edx,%eax
  104f29:	c1 e0 02             	shl    $0x2,%eax
  104f2c:	89 c2                	mov    %eax,%edx
  104f2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104f31:	01 d0                	add    %edx,%eax
  104f33:	39 45 08             	cmp    %eax,0x8(%ebp)
  104f36:	75 5a                	jne    104f92 <default_free_pages+0x2ce>
			 p->property      += base->property;
  104f38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104f3b:	8b 50 08             	mov    0x8(%eax),%edx
  104f3e:	8b 45 08             	mov    0x8(%ebp),%eax
  104f41:	8b 40 08             	mov    0x8(%eax),%eax
  104f44:	01 c2                	add    %eax,%edx
  104f46:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104f49:	89 50 08             	mov    %edx,0x8(%eax)
			 base->property    = 0;
  104f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  104f4f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			 base              = p;
  104f56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104f59:	89 45 08             	mov    %eax,0x8(%ebp)
			 pos               = le->prev;
  104f5c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104f5f:	8b 00                	mov    (%eax),%eax
  104f61:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			 merge_before_ptr  = le;
  104f64:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104f67:	89 45 e0             	mov    %eax,-0x20(%ebp)
  104f6a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104f6d:	89 45 9c             	mov    %eax,-0x64(%ebp)
    __list_del(listelm->prev, listelm->next);
  104f70:	8b 45 9c             	mov    -0x64(%ebp),%eax
  104f73:	8b 40 04             	mov    0x4(%eax),%eax
  104f76:	8b 55 9c             	mov    -0x64(%ebp),%edx
  104f79:	8b 12                	mov    (%edx),%edx
  104f7b:	89 55 98             	mov    %edx,-0x68(%ebp)
  104f7e:	89 45 94             	mov    %eax,-0x6c(%ebp)
    prev->next = next;
  104f81:	8b 45 98             	mov    -0x68(%ebp),%eax
  104f84:	8b 55 94             	mov    -0x6c(%ebp),%edx
  104f87:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  104f8a:	8b 45 94             	mov    -0x6c(%ebp),%eax
  104f8d:	8b 55 98             	mov    -0x68(%ebp),%edx
  104f90:	89 10                	mov    %edx,(%eax)
			 list_del(le);
		 }
		 if ((base + base->property) == p) {
  104f92:	8b 45 08             	mov    0x8(%ebp),%eax
  104f95:	8b 50 08             	mov    0x8(%eax),%edx
  104f98:	89 d0                	mov    %edx,%eax
  104f9a:	c1 e0 02             	shl    $0x2,%eax
  104f9d:	01 d0                	add    %edx,%eax
  104f9f:	c1 e0 02             	shl    $0x2,%eax
  104fa2:	89 c2                	mov    %eax,%edx
  104fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  104fa7:	01 d0                	add    %edx,%eax
  104fa9:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  104fac:	75 4e                	jne    104ffc <default_free_pages+0x338>
			 base->property += p->property;
  104fae:	8b 45 08             	mov    0x8(%ebp),%eax
  104fb1:	8b 50 08             	mov    0x8(%eax),%edx
  104fb4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104fb7:	8b 40 08             	mov    0x8(%eax),%eax
  104fba:	01 c2                	add    %eax,%edx
  104fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  104fbf:	89 50 08             	mov    %edx,0x8(%eax)
			 p->property     = 0;
  104fc2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104fc5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			 pos             = le->prev;
  104fcc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104fcf:	8b 00                	mov    (%eax),%eax
  104fd1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104fd4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104fd7:	89 45 90             	mov    %eax,-0x70(%ebp)
    __list_del(listelm->prev, listelm->next);
  104fda:	8b 45 90             	mov    -0x70(%ebp),%eax
  104fdd:	8b 40 04             	mov    0x4(%eax),%eax
  104fe0:	8b 55 90             	mov    -0x70(%ebp),%edx
  104fe3:	8b 12                	mov    (%edx),%edx
  104fe5:	89 55 8c             	mov    %edx,-0x74(%ebp)
  104fe8:	89 45 88             	mov    %eax,-0x78(%ebp)
    prev->next = next;
  104feb:	8b 45 8c             	mov    -0x74(%ebp),%eax
  104fee:	8b 55 88             	mov    -0x78(%ebp),%edx
  104ff1:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  104ff4:	8b 45 88             	mov    -0x78(%ebp),%eax
  104ff7:	8b 55 8c             	mov    -0x74(%ebp),%edx
  104ffa:	89 10                	mov    %edx,(%eax)
  104ffc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104fff:	89 45 84             	mov    %eax,-0x7c(%ebp)
    return listelm->next;
  105002:	8b 45 84             	mov    -0x7c(%ebp),%eax
  105005:	8b 40 04             	mov    0x4(%eax),%eax
			 list_del(le);
		 }
		 le = list_next(le);
  105008:	89 45 e8             	mov    %eax,-0x18(%ebp)
 	 while (le != &free_list) {
  10500b:	81 7d e8 3c df 11 00 	cmpl   $0x11df3c,-0x18(%ebp)
  105012:	0f 85 fb fe ff ff    	jne    104f13 <default_free_pages+0x24f>
	 }
	 /* if there may be free blocks before @base block, try to merge them */
	 if (merge_before_ptr != NULL) {
  105018:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  10501c:	0f 84 b9 00 00 00    	je     1050db <default_free_pages+0x417>
		 le = merge_before_ptr->prev;
  105022:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105025:	8b 00                	mov    (%eax),%eax
  105027:	89 45 e8             	mov    %eax,-0x18(%ebp)
		 while (le != &free_list) {
  10502a:	e9 9f 00 00 00       	jmp    1050ce <default_free_pages+0x40a>
			 p = le2page(le, page_link);
  10502f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105032:	83 e8 0c             	sub    $0xc,%eax
  105035:	89 45 ec             	mov    %eax,-0x14(%ebp)
			 if (p + p->property == base) {
  105038:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10503b:	8b 50 08             	mov    0x8(%eax),%edx
  10503e:	89 d0                	mov    %edx,%eax
  105040:	c1 e0 02             	shl    $0x2,%eax
  105043:	01 d0                	add    %edx,%eax
  105045:	c1 e0 02             	shl    $0x2,%eax
  105048:	89 c2                	mov    %eax,%edx
  10504a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10504d:	01 d0                	add    %edx,%eax
  10504f:	39 45 08             	cmp    %eax,0x8(%ebp)
  105052:	75 66                	jne    1050ba <default_free_pages+0x3f6>
				 p->property    += base->property;
  105054:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105057:	8b 50 08             	mov    0x8(%eax),%edx
  10505a:	8b 45 08             	mov    0x8(%ebp),%eax
  10505d:	8b 40 08             	mov    0x8(%eax),%eax
  105060:	01 c2                	add    %eax,%edx
  105062:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105065:	89 50 08             	mov    %edx,0x8(%eax)
				 base->property  = 0;
  105068:	8b 45 08             	mov    0x8(%ebp),%eax
  10506b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				 base            = p;
  105072:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105075:	89 45 08             	mov    %eax,0x8(%ebp)
				 pos             = le->prev;
  105078:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10507b:	8b 00                	mov    (%eax),%eax
  10507d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105080:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105083:	89 45 80             	mov    %eax,-0x80(%ebp)
    __list_del(listelm->prev, listelm->next);
  105086:	8b 45 80             	mov    -0x80(%ebp),%eax
  105089:	8b 40 04             	mov    0x4(%eax),%eax
  10508c:	8b 55 80             	mov    -0x80(%ebp),%edx
  10508f:	8b 12                	mov    (%edx),%edx
  105091:	89 95 7c ff ff ff    	mov    %edx,-0x84(%ebp)
  105097:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
    prev->next = next;
  10509d:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  1050a3:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
  1050a9:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  1050ac:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  1050b2:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
  1050b8:	89 10                	mov    %edx,(%eax)
  1050ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1050bd:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
    return listelm->prev;
  1050c3:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  1050c9:	8b 00                	mov    (%eax),%eax
				 list_del(le);
			 }
			 le = list_prev(le);
  1050cb:	89 45 e8             	mov    %eax,-0x18(%ebp)
		 while (le != &free_list) {
  1050ce:	81 7d e8 3c df 11 00 	cmpl   $0x11df3c,-0x18(%ebp)
  1050d5:	0f 85 54 ff ff ff    	jne    10502f <default_free_pages+0x36b>
		 }
	 } 
	 /* @pos indicate position in whith @base's page_link should insert;
	  * only when there are no adjcent free blocks, should we try to find insertion position
	  */
	 if (base->property == old_base_property) {
  1050db:	8b 45 08             	mov    0x8(%ebp),%eax
  1050de:	8b 40 08             	mov    0x8(%eax),%eax
  1050e1:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  1050e4:	0f 85 90 00 00 00    	jne    10517a <default_free_pages+0x4b6>
  1050ea:	c7 85 70 ff ff ff 3c 	movl   $0x11df3c,-0x90(%ebp)
  1050f1:	df 11 00 
    return listelm->next;
  1050f4:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  1050fa:	8b 40 04             	mov    0x4(%eax),%eax
		 le = list_next(&free_list);
  1050fd:	89 45 e8             	mov    %eax,-0x18(%ebp)
		 while (le != &free_list) {
  105100:	eb 6f                	jmp    105171 <default_free_pages+0x4ad>
			 if (le2page(le, page_link) > base) {
  105102:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105105:	83 e8 0c             	sub    $0xc,%eax
  105108:	39 45 08             	cmp    %eax,0x8(%ebp)
  10510b:	73 4f                	jae    10515c <default_free_pages+0x498>
				 assert((base + base->property) < le2page(le, page_link));
  10510d:	8b 45 08             	mov    0x8(%ebp),%eax
  105110:	8b 50 08             	mov    0x8(%eax),%edx
  105113:	89 d0                	mov    %edx,%eax
  105115:	c1 e0 02             	shl    $0x2,%eax
  105118:	01 d0                	add    %edx,%eax
  10511a:	c1 e0 02             	shl    $0x2,%eax
  10511d:	89 c2                	mov    %eax,%edx
  10511f:	8b 45 08             	mov    0x8(%ebp),%eax
  105122:	01 c2                	add    %eax,%edx
  105124:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105127:	83 e8 0c             	sub    $0xc,%eax
  10512a:	39 c2                	cmp    %eax,%edx
  10512c:	72 24                	jb     105152 <default_free_pages+0x48e>
  10512e:	c7 44 24 0c 30 78 10 	movl   $0x107830,0xc(%esp)
  105135:	00 
  105136:	c7 44 24 08 16 77 10 	movl   $0x107716,0x8(%esp)
  10513d:	00 
  10513e:	c7 44 24 04 3e 01 00 	movl   $0x13e,0x4(%esp)
  105145:	00 
  105146:	c7 04 24 2b 77 10 00 	movl   $0x10772b,(%esp)
  10514d:	e8 94 b2 ff ff       	call   1003e6 <__panic>
				 pos = le->prev;
  105152:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105155:	8b 00                	mov    (%eax),%eax
  105157:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				 break;
  10515a:	eb 1e                	jmp    10517a <default_free_pages+0x4b6>
  10515c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10515f:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  105165:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  10516b:	8b 40 04             	mov    0x4(%eax),%eax
			 }
			 le = list_next(le);
  10516e:	89 45 e8             	mov    %eax,-0x18(%ebp)
		 while (le != &free_list) {
  105171:	81 7d e8 3c df 11 00 	cmpl   $0x11df3c,-0x18(%ebp)
  105178:	75 88                	jne    105102 <default_free_pages+0x43e>
		 }
	 }
	 list_add(pos, &base->page_link);
  10517a:	8b 45 08             	mov    0x8(%ebp),%eax
  10517d:	8d 50 0c             	lea    0xc(%eax),%edx
  105180:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105183:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
  105189:	89 95 64 ff ff ff    	mov    %edx,-0x9c(%ebp)
  10518f:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  105195:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  10519b:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  1051a1:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
    __list_add(elm, listelm, listelm->next);
  1051a7:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  1051ad:	8b 40 04             	mov    0x4(%eax),%eax
  1051b0:	8b 95 5c ff ff ff    	mov    -0xa4(%ebp),%edx
  1051b6:	89 95 58 ff ff ff    	mov    %edx,-0xa8(%ebp)
  1051bc:	8b 95 60 ff ff ff    	mov    -0xa0(%ebp),%edx
  1051c2:	89 95 54 ff ff ff    	mov    %edx,-0xac(%ebp)
  1051c8:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
    prev->next = next->prev = elm;
  1051ce:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  1051d4:	8b 95 58 ff ff ff    	mov    -0xa8(%ebp),%edx
  1051da:	89 10                	mov    %edx,(%eax)
  1051dc:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  1051e2:	8b 10                	mov    (%eax),%edx
  1051e4:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  1051ea:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  1051ed:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  1051f3:	8b 95 50 ff ff ff    	mov    -0xb0(%ebp),%edx
  1051f9:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  1051fc:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  105202:	8b 95 54 ff ff ff    	mov    -0xac(%ebp),%edx
  105208:	89 10                	mov    %edx,(%eax)
	 nr_free += n;
  10520a:	8b 15 44 df 11 00    	mov    0x11df44,%edx
  105210:	8b 45 0c             	mov    0xc(%ebp),%eax
  105213:	01 d0                	add    %edx,%eax
  105215:	a3 44 df 11 00       	mov    %eax,0x11df44
}
  10521a:	90                   	nop
  10521b:	c9                   	leave  
  10521c:	c3                   	ret    

0010521d <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  10521d:	55                   	push   %ebp
  10521e:	89 e5                	mov    %esp,%ebp
    return nr_free;
  105220:	a1 44 df 11 00       	mov    0x11df44,%eax
}
  105225:	5d                   	pop    %ebp
  105226:	c3                   	ret    

00105227 <basic_check>:

static void
basic_check(void) {
  105227:	55                   	push   %ebp
  105228:	89 e5                	mov    %esp,%ebp
  10522a:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  10522d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  105234:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105237:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10523a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10523d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  105240:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105247:	e8 d0 dd ff ff       	call   10301c <alloc_pages>
  10524c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10524f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  105253:	75 24                	jne    105279 <basic_check+0x52>
  105255:	c7 44 24 0c 61 78 10 	movl   $0x107861,0xc(%esp)
  10525c:	00 
  10525d:	c7 44 24 08 16 77 10 	movl   $0x107716,0x8(%esp)
  105264:	00 
  105265:	c7 44 24 04 52 01 00 	movl   $0x152,0x4(%esp)
  10526c:	00 
  10526d:	c7 04 24 2b 77 10 00 	movl   $0x10772b,(%esp)
  105274:	e8 6d b1 ff ff       	call   1003e6 <__panic>
    assert((p1 = alloc_page()) != NULL);
  105279:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105280:	e8 97 dd ff ff       	call   10301c <alloc_pages>
  105285:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105288:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10528c:	75 24                	jne    1052b2 <basic_check+0x8b>
  10528e:	c7 44 24 0c 7d 78 10 	movl   $0x10787d,0xc(%esp)
  105295:	00 
  105296:	c7 44 24 08 16 77 10 	movl   $0x107716,0x8(%esp)
  10529d:	00 
  10529e:	c7 44 24 04 53 01 00 	movl   $0x153,0x4(%esp)
  1052a5:	00 
  1052a6:	c7 04 24 2b 77 10 00 	movl   $0x10772b,(%esp)
  1052ad:	e8 34 b1 ff ff       	call   1003e6 <__panic>
    assert((p2 = alloc_page()) != NULL);
  1052b2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1052b9:	e8 5e dd ff ff       	call   10301c <alloc_pages>
  1052be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1052c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1052c5:	75 24                	jne    1052eb <basic_check+0xc4>
  1052c7:	c7 44 24 0c 99 78 10 	movl   $0x107899,0xc(%esp)
  1052ce:	00 
  1052cf:	c7 44 24 08 16 77 10 	movl   $0x107716,0x8(%esp)
  1052d6:	00 
  1052d7:	c7 44 24 04 54 01 00 	movl   $0x154,0x4(%esp)
  1052de:	00 
  1052df:	c7 04 24 2b 77 10 00 	movl   $0x10772b,(%esp)
  1052e6:	e8 fb b0 ff ff       	call   1003e6 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  1052eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1052ee:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  1052f1:	74 10                	je     105303 <basic_check+0xdc>
  1052f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1052f6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1052f9:	74 08                	je     105303 <basic_check+0xdc>
  1052fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1052fe:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  105301:	75 24                	jne    105327 <basic_check+0x100>
  105303:	c7 44 24 0c b8 78 10 	movl   $0x1078b8,0xc(%esp)
  10530a:	00 
  10530b:	c7 44 24 08 16 77 10 	movl   $0x107716,0x8(%esp)
  105312:	00 
  105313:	c7 44 24 04 56 01 00 	movl   $0x156,0x4(%esp)
  10531a:	00 
  10531b:	c7 04 24 2b 77 10 00 	movl   $0x10772b,(%esp)
  105322:	e8 bf b0 ff ff       	call   1003e6 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  105327:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10532a:	89 04 24             	mov    %eax,(%esp)
  10532d:	e8 c4 f5 ff ff       	call   1048f6 <page_ref>
  105332:	85 c0                	test   %eax,%eax
  105334:	75 1e                	jne    105354 <basic_check+0x12d>
  105336:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105339:	89 04 24             	mov    %eax,(%esp)
  10533c:	e8 b5 f5 ff ff       	call   1048f6 <page_ref>
  105341:	85 c0                	test   %eax,%eax
  105343:	75 0f                	jne    105354 <basic_check+0x12d>
  105345:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105348:	89 04 24             	mov    %eax,(%esp)
  10534b:	e8 a6 f5 ff ff       	call   1048f6 <page_ref>
  105350:	85 c0                	test   %eax,%eax
  105352:	74 24                	je     105378 <basic_check+0x151>
  105354:	c7 44 24 0c dc 78 10 	movl   $0x1078dc,0xc(%esp)
  10535b:	00 
  10535c:	c7 44 24 08 16 77 10 	movl   $0x107716,0x8(%esp)
  105363:	00 
  105364:	c7 44 24 04 57 01 00 	movl   $0x157,0x4(%esp)
  10536b:	00 
  10536c:	c7 04 24 2b 77 10 00 	movl   $0x10772b,(%esp)
  105373:	e8 6e b0 ff ff       	call   1003e6 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  105378:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10537b:	89 04 24             	mov    %eax,(%esp)
  10537e:	e8 5d f5 ff ff       	call   1048e0 <page2pa>
  105383:	8b 15 a0 de 11 00    	mov    0x11dea0,%edx
  105389:	c1 e2 0c             	shl    $0xc,%edx
  10538c:	39 d0                	cmp    %edx,%eax
  10538e:	72 24                	jb     1053b4 <basic_check+0x18d>
  105390:	c7 44 24 0c 18 79 10 	movl   $0x107918,0xc(%esp)
  105397:	00 
  105398:	c7 44 24 08 16 77 10 	movl   $0x107716,0x8(%esp)
  10539f:	00 
  1053a0:	c7 44 24 04 59 01 00 	movl   $0x159,0x4(%esp)
  1053a7:	00 
  1053a8:	c7 04 24 2b 77 10 00 	movl   $0x10772b,(%esp)
  1053af:	e8 32 b0 ff ff       	call   1003e6 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  1053b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1053b7:	89 04 24             	mov    %eax,(%esp)
  1053ba:	e8 21 f5 ff ff       	call   1048e0 <page2pa>
  1053bf:	8b 15 a0 de 11 00    	mov    0x11dea0,%edx
  1053c5:	c1 e2 0c             	shl    $0xc,%edx
  1053c8:	39 d0                	cmp    %edx,%eax
  1053ca:	72 24                	jb     1053f0 <basic_check+0x1c9>
  1053cc:	c7 44 24 0c 35 79 10 	movl   $0x107935,0xc(%esp)
  1053d3:	00 
  1053d4:	c7 44 24 08 16 77 10 	movl   $0x107716,0x8(%esp)
  1053db:	00 
  1053dc:	c7 44 24 04 5a 01 00 	movl   $0x15a,0x4(%esp)
  1053e3:	00 
  1053e4:	c7 04 24 2b 77 10 00 	movl   $0x10772b,(%esp)
  1053eb:	e8 f6 af ff ff       	call   1003e6 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  1053f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1053f3:	89 04 24             	mov    %eax,(%esp)
  1053f6:	e8 e5 f4 ff ff       	call   1048e0 <page2pa>
  1053fb:	8b 15 a0 de 11 00    	mov    0x11dea0,%edx
  105401:	c1 e2 0c             	shl    $0xc,%edx
  105404:	39 d0                	cmp    %edx,%eax
  105406:	72 24                	jb     10542c <basic_check+0x205>
  105408:	c7 44 24 0c 52 79 10 	movl   $0x107952,0xc(%esp)
  10540f:	00 
  105410:	c7 44 24 08 16 77 10 	movl   $0x107716,0x8(%esp)
  105417:	00 
  105418:	c7 44 24 04 5b 01 00 	movl   $0x15b,0x4(%esp)
  10541f:	00 
  105420:	c7 04 24 2b 77 10 00 	movl   $0x10772b,(%esp)
  105427:	e8 ba af ff ff       	call   1003e6 <__panic>

    list_entry_t free_list_store = free_list;
  10542c:	a1 3c df 11 00       	mov    0x11df3c,%eax
  105431:	8b 15 40 df 11 00    	mov    0x11df40,%edx
  105437:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10543a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  10543d:	c7 45 dc 3c df 11 00 	movl   $0x11df3c,-0x24(%ebp)
    elm->prev = elm->next = elm;
  105444:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105447:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10544a:	89 50 04             	mov    %edx,0x4(%eax)
  10544d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105450:	8b 50 04             	mov    0x4(%eax),%edx
  105453:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105456:	89 10                	mov    %edx,(%eax)
  105458:	c7 45 e0 3c df 11 00 	movl   $0x11df3c,-0x20(%ebp)
    return list->next == list;
  10545f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105462:	8b 40 04             	mov    0x4(%eax),%eax
  105465:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  105468:	0f 94 c0             	sete   %al
  10546b:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  10546e:	85 c0                	test   %eax,%eax
  105470:	75 24                	jne    105496 <basic_check+0x26f>
  105472:	c7 44 24 0c 6f 79 10 	movl   $0x10796f,0xc(%esp)
  105479:	00 
  10547a:	c7 44 24 08 16 77 10 	movl   $0x107716,0x8(%esp)
  105481:	00 
  105482:	c7 44 24 04 5f 01 00 	movl   $0x15f,0x4(%esp)
  105489:	00 
  10548a:	c7 04 24 2b 77 10 00 	movl   $0x10772b,(%esp)
  105491:	e8 50 af ff ff       	call   1003e6 <__panic>

    unsigned int nr_free_store = nr_free;
  105496:	a1 44 df 11 00       	mov    0x11df44,%eax
  10549b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  10549e:	c7 05 44 df 11 00 00 	movl   $0x0,0x11df44
  1054a5:	00 00 00 

    assert(alloc_page() == NULL);
  1054a8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1054af:	e8 68 db ff ff       	call   10301c <alloc_pages>
  1054b4:	85 c0                	test   %eax,%eax
  1054b6:	74 24                	je     1054dc <basic_check+0x2b5>
  1054b8:	c7 44 24 0c 86 79 10 	movl   $0x107986,0xc(%esp)
  1054bf:	00 
  1054c0:	c7 44 24 08 16 77 10 	movl   $0x107716,0x8(%esp)
  1054c7:	00 
  1054c8:	c7 44 24 04 64 01 00 	movl   $0x164,0x4(%esp)
  1054cf:	00 
  1054d0:	c7 04 24 2b 77 10 00 	movl   $0x10772b,(%esp)
  1054d7:	e8 0a af ff ff       	call   1003e6 <__panic>

    free_page(p0);
  1054dc:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1054e3:	00 
  1054e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1054e7:	89 04 24             	mov    %eax,(%esp)
  1054ea:	e8 65 db ff ff       	call   103054 <free_pages>
    free_page(p1);
  1054ef:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1054f6:	00 
  1054f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1054fa:	89 04 24             	mov    %eax,(%esp)
  1054fd:	e8 52 db ff ff       	call   103054 <free_pages>
    free_page(p2);
  105502:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105509:	00 
  10550a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10550d:	89 04 24             	mov    %eax,(%esp)
  105510:	e8 3f db ff ff       	call   103054 <free_pages>
    assert(nr_free == 3);
  105515:	a1 44 df 11 00       	mov    0x11df44,%eax
  10551a:	83 f8 03             	cmp    $0x3,%eax
  10551d:	74 24                	je     105543 <basic_check+0x31c>
  10551f:	c7 44 24 0c 9b 79 10 	movl   $0x10799b,0xc(%esp)
  105526:	00 
  105527:	c7 44 24 08 16 77 10 	movl   $0x107716,0x8(%esp)
  10552e:	00 
  10552f:	c7 44 24 04 69 01 00 	movl   $0x169,0x4(%esp)
  105536:	00 
  105537:	c7 04 24 2b 77 10 00 	movl   $0x10772b,(%esp)
  10553e:	e8 a3 ae ff ff       	call   1003e6 <__panic>

    assert((p0 = alloc_page()) != NULL);
  105543:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10554a:	e8 cd da ff ff       	call   10301c <alloc_pages>
  10554f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105552:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  105556:	75 24                	jne    10557c <basic_check+0x355>
  105558:	c7 44 24 0c 61 78 10 	movl   $0x107861,0xc(%esp)
  10555f:	00 
  105560:	c7 44 24 08 16 77 10 	movl   $0x107716,0x8(%esp)
  105567:	00 
  105568:	c7 44 24 04 6b 01 00 	movl   $0x16b,0x4(%esp)
  10556f:	00 
  105570:	c7 04 24 2b 77 10 00 	movl   $0x10772b,(%esp)
  105577:	e8 6a ae ff ff       	call   1003e6 <__panic>
    assert((p1 = alloc_page()) != NULL);
  10557c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105583:	e8 94 da ff ff       	call   10301c <alloc_pages>
  105588:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10558b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10558f:	75 24                	jne    1055b5 <basic_check+0x38e>
  105591:	c7 44 24 0c 7d 78 10 	movl   $0x10787d,0xc(%esp)
  105598:	00 
  105599:	c7 44 24 08 16 77 10 	movl   $0x107716,0x8(%esp)
  1055a0:	00 
  1055a1:	c7 44 24 04 6c 01 00 	movl   $0x16c,0x4(%esp)
  1055a8:	00 
  1055a9:	c7 04 24 2b 77 10 00 	movl   $0x10772b,(%esp)
  1055b0:	e8 31 ae ff ff       	call   1003e6 <__panic>
    assert((p2 = alloc_page()) != NULL);
  1055b5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1055bc:	e8 5b da ff ff       	call   10301c <alloc_pages>
  1055c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1055c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1055c8:	75 24                	jne    1055ee <basic_check+0x3c7>
  1055ca:	c7 44 24 0c 99 78 10 	movl   $0x107899,0xc(%esp)
  1055d1:	00 
  1055d2:	c7 44 24 08 16 77 10 	movl   $0x107716,0x8(%esp)
  1055d9:	00 
  1055da:	c7 44 24 04 6d 01 00 	movl   $0x16d,0x4(%esp)
  1055e1:	00 
  1055e2:	c7 04 24 2b 77 10 00 	movl   $0x10772b,(%esp)
  1055e9:	e8 f8 ad ff ff       	call   1003e6 <__panic>

    assert(alloc_page() == NULL);
  1055ee:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1055f5:	e8 22 da ff ff       	call   10301c <alloc_pages>
  1055fa:	85 c0                	test   %eax,%eax
  1055fc:	74 24                	je     105622 <basic_check+0x3fb>
  1055fe:	c7 44 24 0c 86 79 10 	movl   $0x107986,0xc(%esp)
  105605:	00 
  105606:	c7 44 24 08 16 77 10 	movl   $0x107716,0x8(%esp)
  10560d:	00 
  10560e:	c7 44 24 04 6f 01 00 	movl   $0x16f,0x4(%esp)
  105615:	00 
  105616:	c7 04 24 2b 77 10 00 	movl   $0x10772b,(%esp)
  10561d:	e8 c4 ad ff ff       	call   1003e6 <__panic>

    free_page(p0);
  105622:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105629:	00 
  10562a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10562d:	89 04 24             	mov    %eax,(%esp)
  105630:	e8 1f da ff ff       	call   103054 <free_pages>
  105635:	c7 45 d8 3c df 11 00 	movl   $0x11df3c,-0x28(%ebp)
  10563c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10563f:	8b 40 04             	mov    0x4(%eax),%eax
  105642:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  105645:	0f 94 c0             	sete   %al
  105648:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  10564b:	85 c0                	test   %eax,%eax
  10564d:	74 24                	je     105673 <basic_check+0x44c>
  10564f:	c7 44 24 0c a8 79 10 	movl   $0x1079a8,0xc(%esp)
  105656:	00 
  105657:	c7 44 24 08 16 77 10 	movl   $0x107716,0x8(%esp)
  10565e:	00 
  10565f:	c7 44 24 04 72 01 00 	movl   $0x172,0x4(%esp)
  105666:	00 
  105667:	c7 04 24 2b 77 10 00 	movl   $0x10772b,(%esp)
  10566e:	e8 73 ad ff ff       	call   1003e6 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  105673:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10567a:	e8 9d d9 ff ff       	call   10301c <alloc_pages>
  10567f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105682:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105685:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  105688:	74 24                	je     1056ae <basic_check+0x487>
  10568a:	c7 44 24 0c c0 79 10 	movl   $0x1079c0,0xc(%esp)
  105691:	00 
  105692:	c7 44 24 08 16 77 10 	movl   $0x107716,0x8(%esp)
  105699:	00 
  10569a:	c7 44 24 04 75 01 00 	movl   $0x175,0x4(%esp)
  1056a1:	00 
  1056a2:	c7 04 24 2b 77 10 00 	movl   $0x10772b,(%esp)
  1056a9:	e8 38 ad ff ff       	call   1003e6 <__panic>
    assert(alloc_page() == NULL);
  1056ae:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1056b5:	e8 62 d9 ff ff       	call   10301c <alloc_pages>
  1056ba:	85 c0                	test   %eax,%eax
  1056bc:	74 24                	je     1056e2 <basic_check+0x4bb>
  1056be:	c7 44 24 0c 86 79 10 	movl   $0x107986,0xc(%esp)
  1056c5:	00 
  1056c6:	c7 44 24 08 16 77 10 	movl   $0x107716,0x8(%esp)
  1056cd:	00 
  1056ce:	c7 44 24 04 76 01 00 	movl   $0x176,0x4(%esp)
  1056d5:	00 
  1056d6:	c7 04 24 2b 77 10 00 	movl   $0x10772b,(%esp)
  1056dd:	e8 04 ad ff ff       	call   1003e6 <__panic>

    assert(nr_free == 0);
  1056e2:	a1 44 df 11 00       	mov    0x11df44,%eax
  1056e7:	85 c0                	test   %eax,%eax
  1056e9:	74 24                	je     10570f <basic_check+0x4e8>
  1056eb:	c7 44 24 0c d9 79 10 	movl   $0x1079d9,0xc(%esp)
  1056f2:	00 
  1056f3:	c7 44 24 08 16 77 10 	movl   $0x107716,0x8(%esp)
  1056fa:	00 
  1056fb:	c7 44 24 04 78 01 00 	movl   $0x178,0x4(%esp)
  105702:	00 
  105703:	c7 04 24 2b 77 10 00 	movl   $0x10772b,(%esp)
  10570a:	e8 d7 ac ff ff       	call   1003e6 <__panic>
    free_list = free_list_store;
  10570f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  105712:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105715:	a3 3c df 11 00       	mov    %eax,0x11df3c
  10571a:	89 15 40 df 11 00    	mov    %edx,0x11df40
    nr_free = nr_free_store;
  105720:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105723:	a3 44 df 11 00       	mov    %eax,0x11df44

    free_page(p);
  105728:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10572f:	00 
  105730:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105733:	89 04 24             	mov    %eax,(%esp)
  105736:	e8 19 d9 ff ff       	call   103054 <free_pages>
    free_page(p1);
  10573b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105742:	00 
  105743:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105746:	89 04 24             	mov    %eax,(%esp)
  105749:	e8 06 d9 ff ff       	call   103054 <free_pages>
    free_page(p2);
  10574e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105755:	00 
  105756:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105759:	89 04 24             	mov    %eax,(%esp)
  10575c:	e8 f3 d8 ff ff       	call   103054 <free_pages>
}
  105761:	90                   	nop
  105762:	c9                   	leave  
  105763:	c3                   	ret    

00105764 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  105764:	55                   	push   %ebp
  105765:	89 e5                	mov    %esp,%ebp
  105767:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
  10576d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  105774:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  10577b:	c7 45 ec 3c df 11 00 	movl   $0x11df3c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  105782:	eb 6a                	jmp    1057ee <default_check+0x8a>
        struct Page *p = le2page(le, page_link);
  105784:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105787:	83 e8 0c             	sub    $0xc,%eax
  10578a:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
  10578d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105790:	83 c0 04             	add    $0x4,%eax
  105793:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  10579a:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10579d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1057a0:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1057a3:	0f a3 10             	bt     %edx,(%eax)
  1057a6:	19 c0                	sbb    %eax,%eax
  1057a8:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  1057ab:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  1057af:	0f 95 c0             	setne  %al
  1057b2:	0f b6 c0             	movzbl %al,%eax
  1057b5:	85 c0                	test   %eax,%eax
  1057b7:	75 24                	jne    1057dd <default_check+0x79>
  1057b9:	c7 44 24 0c e6 79 10 	movl   $0x1079e6,0xc(%esp)
  1057c0:	00 
  1057c1:	c7 44 24 08 16 77 10 	movl   $0x107716,0x8(%esp)
  1057c8:	00 
  1057c9:	c7 44 24 04 89 01 00 	movl   $0x189,0x4(%esp)
  1057d0:	00 
  1057d1:	c7 04 24 2b 77 10 00 	movl   $0x10772b,(%esp)
  1057d8:	e8 09 ac ff ff       	call   1003e6 <__panic>
        count ++, total += p->property;
  1057dd:	ff 45 f4             	incl   -0xc(%ebp)
  1057e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1057e3:	8b 50 08             	mov    0x8(%eax),%edx
  1057e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1057e9:	01 d0                	add    %edx,%eax
  1057eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1057ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1057f1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
  1057f4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1057f7:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  1057fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1057fd:	81 7d ec 3c df 11 00 	cmpl   $0x11df3c,-0x14(%ebp)
  105804:	0f 85 7a ff ff ff    	jne    105784 <default_check+0x20>
    }
    assert(total == nr_free_pages());
  10580a:	e8 78 d8 ff ff       	call   103087 <nr_free_pages>
  10580f:	89 c2                	mov    %eax,%edx
  105811:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105814:	39 c2                	cmp    %eax,%edx
  105816:	74 24                	je     10583c <default_check+0xd8>
  105818:	c7 44 24 0c f6 79 10 	movl   $0x1079f6,0xc(%esp)
  10581f:	00 
  105820:	c7 44 24 08 16 77 10 	movl   $0x107716,0x8(%esp)
  105827:	00 
  105828:	c7 44 24 04 8c 01 00 	movl   $0x18c,0x4(%esp)
  10582f:	00 
  105830:	c7 04 24 2b 77 10 00 	movl   $0x10772b,(%esp)
  105837:	e8 aa ab ff ff       	call   1003e6 <__panic>

    basic_check();
  10583c:	e8 e6 f9 ff ff       	call   105227 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  105841:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  105848:	e8 cf d7 ff ff       	call   10301c <alloc_pages>
  10584d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
  105850:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105854:	75 24                	jne    10587a <default_check+0x116>
  105856:	c7 44 24 0c 0f 7a 10 	movl   $0x107a0f,0xc(%esp)
  10585d:	00 
  10585e:	c7 44 24 08 16 77 10 	movl   $0x107716,0x8(%esp)
  105865:	00 
  105866:	c7 44 24 04 91 01 00 	movl   $0x191,0x4(%esp)
  10586d:	00 
  10586e:	c7 04 24 2b 77 10 00 	movl   $0x10772b,(%esp)
  105875:	e8 6c ab ff ff       	call   1003e6 <__panic>
    assert(!PageProperty(p0));
  10587a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10587d:	83 c0 04             	add    $0x4,%eax
  105880:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  105887:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10588a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  10588d:	8b 55 c0             	mov    -0x40(%ebp),%edx
  105890:	0f a3 10             	bt     %edx,(%eax)
  105893:	19 c0                	sbb    %eax,%eax
  105895:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  105898:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  10589c:	0f 95 c0             	setne  %al
  10589f:	0f b6 c0             	movzbl %al,%eax
  1058a2:	85 c0                	test   %eax,%eax
  1058a4:	74 24                	je     1058ca <default_check+0x166>
  1058a6:	c7 44 24 0c 1a 7a 10 	movl   $0x107a1a,0xc(%esp)
  1058ad:	00 
  1058ae:	c7 44 24 08 16 77 10 	movl   $0x107716,0x8(%esp)
  1058b5:	00 
  1058b6:	c7 44 24 04 92 01 00 	movl   $0x192,0x4(%esp)
  1058bd:	00 
  1058be:	c7 04 24 2b 77 10 00 	movl   $0x10772b,(%esp)
  1058c5:	e8 1c ab ff ff       	call   1003e6 <__panic>

    list_entry_t free_list_store = free_list;
  1058ca:	a1 3c df 11 00       	mov    0x11df3c,%eax
  1058cf:	8b 15 40 df 11 00    	mov    0x11df40,%edx
  1058d5:	89 45 80             	mov    %eax,-0x80(%ebp)
  1058d8:	89 55 84             	mov    %edx,-0x7c(%ebp)
  1058db:	c7 45 b0 3c df 11 00 	movl   $0x11df3c,-0x50(%ebp)
    elm->prev = elm->next = elm;
  1058e2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1058e5:	8b 55 b0             	mov    -0x50(%ebp),%edx
  1058e8:	89 50 04             	mov    %edx,0x4(%eax)
  1058eb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1058ee:	8b 50 04             	mov    0x4(%eax),%edx
  1058f1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1058f4:	89 10                	mov    %edx,(%eax)
  1058f6:	c7 45 b4 3c df 11 00 	movl   $0x11df3c,-0x4c(%ebp)
    return list->next == list;
  1058fd:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  105900:	8b 40 04             	mov    0x4(%eax),%eax
  105903:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
  105906:	0f 94 c0             	sete   %al
  105909:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  10590c:	85 c0                	test   %eax,%eax
  10590e:	75 24                	jne    105934 <default_check+0x1d0>
  105910:	c7 44 24 0c 6f 79 10 	movl   $0x10796f,0xc(%esp)
  105917:	00 
  105918:	c7 44 24 08 16 77 10 	movl   $0x107716,0x8(%esp)
  10591f:	00 
  105920:	c7 44 24 04 96 01 00 	movl   $0x196,0x4(%esp)
  105927:	00 
  105928:	c7 04 24 2b 77 10 00 	movl   $0x10772b,(%esp)
  10592f:	e8 b2 aa ff ff       	call   1003e6 <__panic>
    assert(alloc_page() == NULL);
  105934:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10593b:	e8 dc d6 ff ff       	call   10301c <alloc_pages>
  105940:	85 c0                	test   %eax,%eax
  105942:	74 24                	je     105968 <default_check+0x204>
  105944:	c7 44 24 0c 86 79 10 	movl   $0x107986,0xc(%esp)
  10594b:	00 
  10594c:	c7 44 24 08 16 77 10 	movl   $0x107716,0x8(%esp)
  105953:	00 
  105954:	c7 44 24 04 97 01 00 	movl   $0x197,0x4(%esp)
  10595b:	00 
  10595c:	c7 04 24 2b 77 10 00 	movl   $0x10772b,(%esp)
  105963:	e8 7e aa ff ff       	call   1003e6 <__panic>

    unsigned int nr_free_store = nr_free;
  105968:	a1 44 df 11 00       	mov    0x11df44,%eax
  10596d:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
  105970:	c7 05 44 df 11 00 00 	movl   $0x0,0x11df44
  105977:	00 00 00 

    free_pages(p0 + 2, 3);
  10597a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10597d:	83 c0 28             	add    $0x28,%eax
  105980:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  105987:	00 
  105988:	89 04 24             	mov    %eax,(%esp)
  10598b:	e8 c4 d6 ff ff       	call   103054 <free_pages>
    assert(alloc_pages(4) == NULL);
  105990:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  105997:	e8 80 d6 ff ff       	call   10301c <alloc_pages>
  10599c:	85 c0                	test   %eax,%eax
  10599e:	74 24                	je     1059c4 <default_check+0x260>
  1059a0:	c7 44 24 0c 2c 7a 10 	movl   $0x107a2c,0xc(%esp)
  1059a7:	00 
  1059a8:	c7 44 24 08 16 77 10 	movl   $0x107716,0x8(%esp)
  1059af:	00 
  1059b0:	c7 44 24 04 9d 01 00 	movl   $0x19d,0x4(%esp)
  1059b7:	00 
  1059b8:	c7 04 24 2b 77 10 00 	movl   $0x10772b,(%esp)
  1059bf:	e8 22 aa ff ff       	call   1003e6 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  1059c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1059c7:	83 c0 28             	add    $0x28,%eax
  1059ca:	83 c0 04             	add    $0x4,%eax
  1059cd:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  1059d4:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1059d7:	8b 45 a8             	mov    -0x58(%ebp),%eax
  1059da:	8b 55 ac             	mov    -0x54(%ebp),%edx
  1059dd:	0f a3 10             	bt     %edx,(%eax)
  1059e0:	19 c0                	sbb    %eax,%eax
  1059e2:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  1059e5:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  1059e9:	0f 95 c0             	setne  %al
  1059ec:	0f b6 c0             	movzbl %al,%eax
  1059ef:	85 c0                	test   %eax,%eax
  1059f1:	74 0e                	je     105a01 <default_check+0x29d>
  1059f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1059f6:	83 c0 28             	add    $0x28,%eax
  1059f9:	8b 40 08             	mov    0x8(%eax),%eax
  1059fc:	83 f8 03             	cmp    $0x3,%eax
  1059ff:	74 24                	je     105a25 <default_check+0x2c1>
  105a01:	c7 44 24 0c 44 7a 10 	movl   $0x107a44,0xc(%esp)
  105a08:	00 
  105a09:	c7 44 24 08 16 77 10 	movl   $0x107716,0x8(%esp)
  105a10:	00 
  105a11:	c7 44 24 04 9e 01 00 	movl   $0x19e,0x4(%esp)
  105a18:	00 
  105a19:	c7 04 24 2b 77 10 00 	movl   $0x10772b,(%esp)
  105a20:	e8 c1 a9 ff ff       	call   1003e6 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  105a25:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  105a2c:	e8 eb d5 ff ff       	call   10301c <alloc_pages>
  105a31:	89 45 dc             	mov    %eax,-0x24(%ebp)
  105a34:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  105a38:	75 24                	jne    105a5e <default_check+0x2fa>
  105a3a:	c7 44 24 0c 70 7a 10 	movl   $0x107a70,0xc(%esp)
  105a41:	00 
  105a42:	c7 44 24 08 16 77 10 	movl   $0x107716,0x8(%esp)
  105a49:	00 
  105a4a:	c7 44 24 04 9f 01 00 	movl   $0x19f,0x4(%esp)
  105a51:	00 
  105a52:	c7 04 24 2b 77 10 00 	movl   $0x10772b,(%esp)
  105a59:	e8 88 a9 ff ff       	call   1003e6 <__panic>
    assert(alloc_page() == NULL);
  105a5e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105a65:	e8 b2 d5 ff ff       	call   10301c <alloc_pages>
  105a6a:	85 c0                	test   %eax,%eax
  105a6c:	74 24                	je     105a92 <default_check+0x32e>
  105a6e:	c7 44 24 0c 86 79 10 	movl   $0x107986,0xc(%esp)
  105a75:	00 
  105a76:	c7 44 24 08 16 77 10 	movl   $0x107716,0x8(%esp)
  105a7d:	00 
  105a7e:	c7 44 24 04 a0 01 00 	movl   $0x1a0,0x4(%esp)
  105a85:	00 
  105a86:	c7 04 24 2b 77 10 00 	movl   $0x10772b,(%esp)
  105a8d:	e8 54 a9 ff ff       	call   1003e6 <__panic>
    assert(p0 + 2 == p1);
  105a92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105a95:	83 c0 28             	add    $0x28,%eax
  105a98:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  105a9b:	74 24                	je     105ac1 <default_check+0x35d>
  105a9d:	c7 44 24 0c 8e 7a 10 	movl   $0x107a8e,0xc(%esp)
  105aa4:	00 
  105aa5:	c7 44 24 08 16 77 10 	movl   $0x107716,0x8(%esp)
  105aac:	00 
  105aad:	c7 44 24 04 a1 01 00 	movl   $0x1a1,0x4(%esp)
  105ab4:	00 
  105ab5:	c7 04 24 2b 77 10 00 	movl   $0x10772b,(%esp)
  105abc:	e8 25 a9 ff ff       	call   1003e6 <__panic>

    p2 = p0 + 1;
  105ac1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105ac4:	83 c0 14             	add    $0x14,%eax
  105ac7:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
  105aca:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105ad1:	00 
  105ad2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105ad5:	89 04 24             	mov    %eax,(%esp)
  105ad8:	e8 77 d5 ff ff       	call   103054 <free_pages>
    free_pages(p1, 3);
  105add:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  105ae4:	00 
  105ae5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105ae8:	89 04 24             	mov    %eax,(%esp)
  105aeb:	e8 64 d5 ff ff       	call   103054 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  105af0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105af3:	83 c0 04             	add    $0x4,%eax
  105af6:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  105afd:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  105b00:	8b 45 9c             	mov    -0x64(%ebp),%eax
  105b03:	8b 55 a0             	mov    -0x60(%ebp),%edx
  105b06:	0f a3 10             	bt     %edx,(%eax)
  105b09:	19 c0                	sbb    %eax,%eax
  105b0b:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  105b0e:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  105b12:	0f 95 c0             	setne  %al
  105b15:	0f b6 c0             	movzbl %al,%eax
  105b18:	85 c0                	test   %eax,%eax
  105b1a:	74 0b                	je     105b27 <default_check+0x3c3>
  105b1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105b1f:	8b 40 08             	mov    0x8(%eax),%eax
  105b22:	83 f8 01             	cmp    $0x1,%eax
  105b25:	74 24                	je     105b4b <default_check+0x3e7>
  105b27:	c7 44 24 0c 9c 7a 10 	movl   $0x107a9c,0xc(%esp)
  105b2e:	00 
  105b2f:	c7 44 24 08 16 77 10 	movl   $0x107716,0x8(%esp)
  105b36:	00 
  105b37:	c7 44 24 04 a6 01 00 	movl   $0x1a6,0x4(%esp)
  105b3e:	00 
  105b3f:	c7 04 24 2b 77 10 00 	movl   $0x10772b,(%esp)
  105b46:	e8 9b a8 ff ff       	call   1003e6 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  105b4b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105b4e:	83 c0 04             	add    $0x4,%eax
  105b51:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  105b58:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  105b5b:	8b 45 90             	mov    -0x70(%ebp),%eax
  105b5e:	8b 55 94             	mov    -0x6c(%ebp),%edx
  105b61:	0f a3 10             	bt     %edx,(%eax)
  105b64:	19 c0                	sbb    %eax,%eax
  105b66:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  105b69:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  105b6d:	0f 95 c0             	setne  %al
  105b70:	0f b6 c0             	movzbl %al,%eax
  105b73:	85 c0                	test   %eax,%eax
  105b75:	74 0b                	je     105b82 <default_check+0x41e>
  105b77:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105b7a:	8b 40 08             	mov    0x8(%eax),%eax
  105b7d:	83 f8 03             	cmp    $0x3,%eax
  105b80:	74 24                	je     105ba6 <default_check+0x442>
  105b82:	c7 44 24 0c c4 7a 10 	movl   $0x107ac4,0xc(%esp)
  105b89:	00 
  105b8a:	c7 44 24 08 16 77 10 	movl   $0x107716,0x8(%esp)
  105b91:	00 
  105b92:	c7 44 24 04 a7 01 00 	movl   $0x1a7,0x4(%esp)
  105b99:	00 
  105b9a:	c7 04 24 2b 77 10 00 	movl   $0x10772b,(%esp)
  105ba1:	e8 40 a8 ff ff       	call   1003e6 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  105ba6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105bad:	e8 6a d4 ff ff       	call   10301c <alloc_pages>
  105bb2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105bb5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105bb8:	83 e8 14             	sub    $0x14,%eax
  105bbb:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  105bbe:	74 24                	je     105be4 <default_check+0x480>
  105bc0:	c7 44 24 0c ea 7a 10 	movl   $0x107aea,0xc(%esp)
  105bc7:	00 
  105bc8:	c7 44 24 08 16 77 10 	movl   $0x107716,0x8(%esp)
  105bcf:	00 
  105bd0:	c7 44 24 04 a9 01 00 	movl   $0x1a9,0x4(%esp)
  105bd7:	00 
  105bd8:	c7 04 24 2b 77 10 00 	movl   $0x10772b,(%esp)
  105bdf:	e8 02 a8 ff ff       	call   1003e6 <__panic>
    free_page(p0);
  105be4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105beb:	00 
  105bec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105bef:	89 04 24             	mov    %eax,(%esp)
  105bf2:	e8 5d d4 ff ff       	call   103054 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  105bf7:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  105bfe:	e8 19 d4 ff ff       	call   10301c <alloc_pages>
  105c03:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105c06:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105c09:	83 c0 14             	add    $0x14,%eax
  105c0c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  105c0f:	74 24                	je     105c35 <default_check+0x4d1>
  105c11:	c7 44 24 0c 08 7b 10 	movl   $0x107b08,0xc(%esp)
  105c18:	00 
  105c19:	c7 44 24 08 16 77 10 	movl   $0x107716,0x8(%esp)
  105c20:	00 
  105c21:	c7 44 24 04 ab 01 00 	movl   $0x1ab,0x4(%esp)
  105c28:	00 
  105c29:	c7 04 24 2b 77 10 00 	movl   $0x10772b,(%esp)
  105c30:	e8 b1 a7 ff ff       	call   1003e6 <__panic>

    free_pages(p0, 2);
  105c35:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  105c3c:	00 
  105c3d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105c40:	89 04 24             	mov    %eax,(%esp)
  105c43:	e8 0c d4 ff ff       	call   103054 <free_pages>
    free_page(p2);
  105c48:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105c4f:	00 
  105c50:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105c53:	89 04 24             	mov    %eax,(%esp)
  105c56:	e8 f9 d3 ff ff       	call   103054 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  105c5b:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  105c62:	e8 b5 d3 ff ff       	call   10301c <alloc_pages>
  105c67:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105c6a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105c6e:	75 24                	jne    105c94 <default_check+0x530>
  105c70:	c7 44 24 0c 28 7b 10 	movl   $0x107b28,0xc(%esp)
  105c77:	00 
  105c78:	c7 44 24 08 16 77 10 	movl   $0x107716,0x8(%esp)
  105c7f:	00 
  105c80:	c7 44 24 04 b0 01 00 	movl   $0x1b0,0x4(%esp)
  105c87:	00 
  105c88:	c7 04 24 2b 77 10 00 	movl   $0x10772b,(%esp)
  105c8f:	e8 52 a7 ff ff       	call   1003e6 <__panic>
    assert(alloc_page() == NULL);
  105c94:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105c9b:	e8 7c d3 ff ff       	call   10301c <alloc_pages>
  105ca0:	85 c0                	test   %eax,%eax
  105ca2:	74 24                	je     105cc8 <default_check+0x564>
  105ca4:	c7 44 24 0c 86 79 10 	movl   $0x107986,0xc(%esp)
  105cab:	00 
  105cac:	c7 44 24 08 16 77 10 	movl   $0x107716,0x8(%esp)
  105cb3:	00 
  105cb4:	c7 44 24 04 b1 01 00 	movl   $0x1b1,0x4(%esp)
  105cbb:	00 
  105cbc:	c7 04 24 2b 77 10 00 	movl   $0x10772b,(%esp)
  105cc3:	e8 1e a7 ff ff       	call   1003e6 <__panic>

    assert(nr_free == 0);
  105cc8:	a1 44 df 11 00       	mov    0x11df44,%eax
  105ccd:	85 c0                	test   %eax,%eax
  105ccf:	74 24                	je     105cf5 <default_check+0x591>
  105cd1:	c7 44 24 0c d9 79 10 	movl   $0x1079d9,0xc(%esp)
  105cd8:	00 
  105cd9:	c7 44 24 08 16 77 10 	movl   $0x107716,0x8(%esp)
  105ce0:	00 
  105ce1:	c7 44 24 04 b3 01 00 	movl   $0x1b3,0x4(%esp)
  105ce8:	00 
  105ce9:	c7 04 24 2b 77 10 00 	movl   $0x10772b,(%esp)
  105cf0:	e8 f1 a6 ff ff       	call   1003e6 <__panic>
    nr_free = nr_free_store;
  105cf5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105cf8:	a3 44 df 11 00       	mov    %eax,0x11df44

    free_list = free_list_store;
  105cfd:	8b 45 80             	mov    -0x80(%ebp),%eax
  105d00:	8b 55 84             	mov    -0x7c(%ebp),%edx
  105d03:	a3 3c df 11 00       	mov    %eax,0x11df3c
  105d08:	89 15 40 df 11 00    	mov    %edx,0x11df40
    free_pages(p0, 5);
  105d0e:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  105d15:	00 
  105d16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105d19:	89 04 24             	mov    %eax,(%esp)
  105d1c:	e8 33 d3 ff ff       	call   103054 <free_pages>

    le = &free_list;
  105d21:	c7 45 ec 3c df 11 00 	movl   $0x11df3c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  105d28:	eb 1c                	jmp    105d46 <default_check+0x5e2>
        struct Page *p = le2page(le, page_link);
  105d2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105d2d:	83 e8 0c             	sub    $0xc,%eax
  105d30:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
  105d33:	ff 4d f4             	decl   -0xc(%ebp)
  105d36:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105d39:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  105d3c:	8b 40 08             	mov    0x8(%eax),%eax
  105d3f:	29 c2                	sub    %eax,%edx
  105d41:	89 d0                	mov    %edx,%eax
  105d43:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105d46:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105d49:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
  105d4c:	8b 45 88             	mov    -0x78(%ebp),%eax
  105d4f:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  105d52:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105d55:	81 7d ec 3c df 11 00 	cmpl   $0x11df3c,-0x14(%ebp)
  105d5c:	75 cc                	jne    105d2a <default_check+0x5c6>
    }
    assert(count == 0);
  105d5e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  105d62:	74 24                	je     105d88 <default_check+0x624>
  105d64:	c7 44 24 0c 46 7b 10 	movl   $0x107b46,0xc(%esp)
  105d6b:	00 
  105d6c:	c7 44 24 08 16 77 10 	movl   $0x107716,0x8(%esp)
  105d73:	00 
  105d74:	c7 44 24 04 be 01 00 	movl   $0x1be,0x4(%esp)
  105d7b:	00 
  105d7c:	c7 04 24 2b 77 10 00 	movl   $0x10772b,(%esp)
  105d83:	e8 5e a6 ff ff       	call   1003e6 <__panic>
    assert(total == 0);
  105d88:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105d8c:	74 24                	je     105db2 <default_check+0x64e>
  105d8e:	c7 44 24 0c 51 7b 10 	movl   $0x107b51,0xc(%esp)
  105d95:	00 
  105d96:	c7 44 24 08 16 77 10 	movl   $0x107716,0x8(%esp)
  105d9d:	00 
  105d9e:	c7 44 24 04 bf 01 00 	movl   $0x1bf,0x4(%esp)
  105da5:	00 
  105da6:	c7 04 24 2b 77 10 00 	movl   $0x10772b,(%esp)
  105dad:	e8 34 a6 ff ff       	call   1003e6 <__panic>
}
  105db2:	90                   	nop
  105db3:	c9                   	leave  
  105db4:	c3                   	ret    

00105db5 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  105db5:	55                   	push   %ebp
  105db6:	89 e5                	mov    %esp,%ebp
  105db8:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105dbb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  105dc2:	eb 03                	jmp    105dc7 <strlen+0x12>
        cnt ++;
  105dc4:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
  105dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  105dca:	8d 50 01             	lea    0x1(%eax),%edx
  105dcd:	89 55 08             	mov    %edx,0x8(%ebp)
  105dd0:	0f b6 00             	movzbl (%eax),%eax
  105dd3:	84 c0                	test   %al,%al
  105dd5:	75 ed                	jne    105dc4 <strlen+0xf>
    }
    return cnt;
  105dd7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105dda:	c9                   	leave  
  105ddb:	c3                   	ret    

00105ddc <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  105ddc:	55                   	push   %ebp
  105ddd:	89 e5                	mov    %esp,%ebp
  105ddf:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105de2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105de9:	eb 03                	jmp    105dee <strnlen+0x12>
        cnt ++;
  105deb:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105dee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105df1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105df4:	73 10                	jae    105e06 <strnlen+0x2a>
  105df6:	8b 45 08             	mov    0x8(%ebp),%eax
  105df9:	8d 50 01             	lea    0x1(%eax),%edx
  105dfc:	89 55 08             	mov    %edx,0x8(%ebp)
  105dff:	0f b6 00             	movzbl (%eax),%eax
  105e02:	84 c0                	test   %al,%al
  105e04:	75 e5                	jne    105deb <strnlen+0xf>
    }
    return cnt;
  105e06:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105e09:	c9                   	leave  
  105e0a:	c3                   	ret    

00105e0b <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  105e0b:	55                   	push   %ebp
  105e0c:	89 e5                	mov    %esp,%ebp
  105e0e:	57                   	push   %edi
  105e0f:	56                   	push   %esi
  105e10:	83 ec 20             	sub    $0x20,%esp
  105e13:	8b 45 08             	mov    0x8(%ebp),%eax
  105e16:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105e19:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  105e1f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105e22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105e25:	89 d1                	mov    %edx,%ecx
  105e27:	89 c2                	mov    %eax,%edx
  105e29:	89 ce                	mov    %ecx,%esi
  105e2b:	89 d7                	mov    %edx,%edi
  105e2d:	ac                   	lods   %ds:(%esi),%al
  105e2e:	aa                   	stos   %al,%es:(%edi)
  105e2f:	84 c0                	test   %al,%al
  105e31:	75 fa                	jne    105e2d <strcpy+0x22>
  105e33:	89 fa                	mov    %edi,%edx
  105e35:	89 f1                	mov    %esi,%ecx
  105e37:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105e3a:	89 55 e8             	mov    %edx,-0x18(%ebp)
  105e3d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  105e40:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
  105e43:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  105e44:	83 c4 20             	add    $0x20,%esp
  105e47:	5e                   	pop    %esi
  105e48:	5f                   	pop    %edi
  105e49:	5d                   	pop    %ebp
  105e4a:	c3                   	ret    

00105e4b <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  105e4b:	55                   	push   %ebp
  105e4c:	89 e5                	mov    %esp,%ebp
  105e4e:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  105e51:	8b 45 08             	mov    0x8(%ebp),%eax
  105e54:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  105e57:	eb 1e                	jmp    105e77 <strncpy+0x2c>
        if ((*p = *src) != '\0') {
  105e59:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e5c:	0f b6 10             	movzbl (%eax),%edx
  105e5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105e62:	88 10                	mov    %dl,(%eax)
  105e64:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105e67:	0f b6 00             	movzbl (%eax),%eax
  105e6a:	84 c0                	test   %al,%al
  105e6c:	74 03                	je     105e71 <strncpy+0x26>
            src ++;
  105e6e:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
  105e71:	ff 45 fc             	incl   -0x4(%ebp)
  105e74:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
  105e77:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105e7b:	75 dc                	jne    105e59 <strncpy+0xe>
    }
    return dst;
  105e7d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105e80:	c9                   	leave  
  105e81:	c3                   	ret    

00105e82 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  105e82:	55                   	push   %ebp
  105e83:	89 e5                	mov    %esp,%ebp
  105e85:	57                   	push   %edi
  105e86:	56                   	push   %esi
  105e87:	83 ec 20             	sub    $0x20,%esp
  105e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  105e8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105e90:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e93:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  105e96:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105e99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105e9c:	89 d1                	mov    %edx,%ecx
  105e9e:	89 c2                	mov    %eax,%edx
  105ea0:	89 ce                	mov    %ecx,%esi
  105ea2:	89 d7                	mov    %edx,%edi
  105ea4:	ac                   	lods   %ds:(%esi),%al
  105ea5:	ae                   	scas   %es:(%edi),%al
  105ea6:	75 08                	jne    105eb0 <strcmp+0x2e>
  105ea8:	84 c0                	test   %al,%al
  105eaa:	75 f8                	jne    105ea4 <strcmp+0x22>
  105eac:	31 c0                	xor    %eax,%eax
  105eae:	eb 04                	jmp    105eb4 <strcmp+0x32>
  105eb0:	19 c0                	sbb    %eax,%eax
  105eb2:	0c 01                	or     $0x1,%al
  105eb4:	89 fa                	mov    %edi,%edx
  105eb6:	89 f1                	mov    %esi,%ecx
  105eb8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105ebb:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105ebe:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  105ec1:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
  105ec4:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  105ec5:	83 c4 20             	add    $0x20,%esp
  105ec8:	5e                   	pop    %esi
  105ec9:	5f                   	pop    %edi
  105eca:	5d                   	pop    %ebp
  105ecb:	c3                   	ret    

00105ecc <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  105ecc:	55                   	push   %ebp
  105ecd:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105ecf:	eb 09                	jmp    105eda <strncmp+0xe>
        n --, s1 ++, s2 ++;
  105ed1:	ff 4d 10             	decl   0x10(%ebp)
  105ed4:	ff 45 08             	incl   0x8(%ebp)
  105ed7:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105eda:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105ede:	74 1a                	je     105efa <strncmp+0x2e>
  105ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  105ee3:	0f b6 00             	movzbl (%eax),%eax
  105ee6:	84 c0                	test   %al,%al
  105ee8:	74 10                	je     105efa <strncmp+0x2e>
  105eea:	8b 45 08             	mov    0x8(%ebp),%eax
  105eed:	0f b6 10             	movzbl (%eax),%edx
  105ef0:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ef3:	0f b6 00             	movzbl (%eax),%eax
  105ef6:	38 c2                	cmp    %al,%dl
  105ef8:	74 d7                	je     105ed1 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  105efa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105efe:	74 18                	je     105f18 <strncmp+0x4c>
  105f00:	8b 45 08             	mov    0x8(%ebp),%eax
  105f03:	0f b6 00             	movzbl (%eax),%eax
  105f06:	0f b6 d0             	movzbl %al,%edx
  105f09:	8b 45 0c             	mov    0xc(%ebp),%eax
  105f0c:	0f b6 00             	movzbl (%eax),%eax
  105f0f:	0f b6 c0             	movzbl %al,%eax
  105f12:	29 c2                	sub    %eax,%edx
  105f14:	89 d0                	mov    %edx,%eax
  105f16:	eb 05                	jmp    105f1d <strncmp+0x51>
  105f18:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105f1d:	5d                   	pop    %ebp
  105f1e:	c3                   	ret    

00105f1f <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  105f1f:	55                   	push   %ebp
  105f20:	89 e5                	mov    %esp,%ebp
  105f22:	83 ec 04             	sub    $0x4,%esp
  105f25:	8b 45 0c             	mov    0xc(%ebp),%eax
  105f28:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105f2b:	eb 13                	jmp    105f40 <strchr+0x21>
        if (*s == c) {
  105f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  105f30:	0f b6 00             	movzbl (%eax),%eax
  105f33:	38 45 fc             	cmp    %al,-0x4(%ebp)
  105f36:	75 05                	jne    105f3d <strchr+0x1e>
            return (char *)s;
  105f38:	8b 45 08             	mov    0x8(%ebp),%eax
  105f3b:	eb 12                	jmp    105f4f <strchr+0x30>
        }
        s ++;
  105f3d:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  105f40:	8b 45 08             	mov    0x8(%ebp),%eax
  105f43:	0f b6 00             	movzbl (%eax),%eax
  105f46:	84 c0                	test   %al,%al
  105f48:	75 e3                	jne    105f2d <strchr+0xe>
    }
    return NULL;
  105f4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105f4f:	c9                   	leave  
  105f50:	c3                   	ret    

00105f51 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  105f51:	55                   	push   %ebp
  105f52:	89 e5                	mov    %esp,%ebp
  105f54:	83 ec 04             	sub    $0x4,%esp
  105f57:	8b 45 0c             	mov    0xc(%ebp),%eax
  105f5a:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105f5d:	eb 0e                	jmp    105f6d <strfind+0x1c>
        if (*s == c) {
  105f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  105f62:	0f b6 00             	movzbl (%eax),%eax
  105f65:	38 45 fc             	cmp    %al,-0x4(%ebp)
  105f68:	74 0f                	je     105f79 <strfind+0x28>
            break;
        }
        s ++;
  105f6a:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  105f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  105f70:	0f b6 00             	movzbl (%eax),%eax
  105f73:	84 c0                	test   %al,%al
  105f75:	75 e8                	jne    105f5f <strfind+0xe>
  105f77:	eb 01                	jmp    105f7a <strfind+0x29>
            break;
  105f79:	90                   	nop
    }
    return (char *)s;
  105f7a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105f7d:	c9                   	leave  
  105f7e:	c3                   	ret    

00105f7f <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  105f7f:	55                   	push   %ebp
  105f80:	89 e5                	mov    %esp,%ebp
  105f82:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  105f85:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  105f8c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105f93:	eb 03                	jmp    105f98 <strtol+0x19>
        s ++;
  105f95:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  105f98:	8b 45 08             	mov    0x8(%ebp),%eax
  105f9b:	0f b6 00             	movzbl (%eax),%eax
  105f9e:	3c 20                	cmp    $0x20,%al
  105fa0:	74 f3                	je     105f95 <strtol+0x16>
  105fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  105fa5:	0f b6 00             	movzbl (%eax),%eax
  105fa8:	3c 09                	cmp    $0x9,%al
  105faa:	74 e9                	je     105f95 <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
  105fac:	8b 45 08             	mov    0x8(%ebp),%eax
  105faf:	0f b6 00             	movzbl (%eax),%eax
  105fb2:	3c 2b                	cmp    $0x2b,%al
  105fb4:	75 05                	jne    105fbb <strtol+0x3c>
        s ++;
  105fb6:	ff 45 08             	incl   0x8(%ebp)
  105fb9:	eb 14                	jmp    105fcf <strtol+0x50>
    }
    else if (*s == '-') {
  105fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  105fbe:	0f b6 00             	movzbl (%eax),%eax
  105fc1:	3c 2d                	cmp    $0x2d,%al
  105fc3:	75 0a                	jne    105fcf <strtol+0x50>
        s ++, neg = 1;
  105fc5:	ff 45 08             	incl   0x8(%ebp)
  105fc8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  105fcf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105fd3:	74 06                	je     105fdb <strtol+0x5c>
  105fd5:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  105fd9:	75 22                	jne    105ffd <strtol+0x7e>
  105fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  105fde:	0f b6 00             	movzbl (%eax),%eax
  105fe1:	3c 30                	cmp    $0x30,%al
  105fe3:	75 18                	jne    105ffd <strtol+0x7e>
  105fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  105fe8:	40                   	inc    %eax
  105fe9:	0f b6 00             	movzbl (%eax),%eax
  105fec:	3c 78                	cmp    $0x78,%al
  105fee:	75 0d                	jne    105ffd <strtol+0x7e>
        s += 2, base = 16;
  105ff0:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  105ff4:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  105ffb:	eb 29                	jmp    106026 <strtol+0xa7>
    }
    else if (base == 0 && s[0] == '0') {
  105ffd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  106001:	75 16                	jne    106019 <strtol+0x9a>
  106003:	8b 45 08             	mov    0x8(%ebp),%eax
  106006:	0f b6 00             	movzbl (%eax),%eax
  106009:	3c 30                	cmp    $0x30,%al
  10600b:	75 0c                	jne    106019 <strtol+0x9a>
        s ++, base = 8;
  10600d:	ff 45 08             	incl   0x8(%ebp)
  106010:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  106017:	eb 0d                	jmp    106026 <strtol+0xa7>
    }
    else if (base == 0) {
  106019:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10601d:	75 07                	jne    106026 <strtol+0xa7>
        base = 10;
  10601f:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  106026:	8b 45 08             	mov    0x8(%ebp),%eax
  106029:	0f b6 00             	movzbl (%eax),%eax
  10602c:	3c 2f                	cmp    $0x2f,%al
  10602e:	7e 1b                	jle    10604b <strtol+0xcc>
  106030:	8b 45 08             	mov    0x8(%ebp),%eax
  106033:	0f b6 00             	movzbl (%eax),%eax
  106036:	3c 39                	cmp    $0x39,%al
  106038:	7f 11                	jg     10604b <strtol+0xcc>
            dig = *s - '0';
  10603a:	8b 45 08             	mov    0x8(%ebp),%eax
  10603d:	0f b6 00             	movzbl (%eax),%eax
  106040:	0f be c0             	movsbl %al,%eax
  106043:	83 e8 30             	sub    $0x30,%eax
  106046:	89 45 f4             	mov    %eax,-0xc(%ebp)
  106049:	eb 48                	jmp    106093 <strtol+0x114>
        }
        else if (*s >= 'a' && *s <= 'z') {
  10604b:	8b 45 08             	mov    0x8(%ebp),%eax
  10604e:	0f b6 00             	movzbl (%eax),%eax
  106051:	3c 60                	cmp    $0x60,%al
  106053:	7e 1b                	jle    106070 <strtol+0xf1>
  106055:	8b 45 08             	mov    0x8(%ebp),%eax
  106058:	0f b6 00             	movzbl (%eax),%eax
  10605b:	3c 7a                	cmp    $0x7a,%al
  10605d:	7f 11                	jg     106070 <strtol+0xf1>
            dig = *s - 'a' + 10;
  10605f:	8b 45 08             	mov    0x8(%ebp),%eax
  106062:	0f b6 00             	movzbl (%eax),%eax
  106065:	0f be c0             	movsbl %al,%eax
  106068:	83 e8 57             	sub    $0x57,%eax
  10606b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10606e:	eb 23                	jmp    106093 <strtol+0x114>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  106070:	8b 45 08             	mov    0x8(%ebp),%eax
  106073:	0f b6 00             	movzbl (%eax),%eax
  106076:	3c 40                	cmp    $0x40,%al
  106078:	7e 3b                	jle    1060b5 <strtol+0x136>
  10607a:	8b 45 08             	mov    0x8(%ebp),%eax
  10607d:	0f b6 00             	movzbl (%eax),%eax
  106080:	3c 5a                	cmp    $0x5a,%al
  106082:	7f 31                	jg     1060b5 <strtol+0x136>
            dig = *s - 'A' + 10;
  106084:	8b 45 08             	mov    0x8(%ebp),%eax
  106087:	0f b6 00             	movzbl (%eax),%eax
  10608a:	0f be c0             	movsbl %al,%eax
  10608d:	83 e8 37             	sub    $0x37,%eax
  106090:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  106093:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106096:	3b 45 10             	cmp    0x10(%ebp),%eax
  106099:	7d 19                	jge    1060b4 <strtol+0x135>
            break;
        }
        s ++, val = (val * base) + dig;
  10609b:	ff 45 08             	incl   0x8(%ebp)
  10609e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1060a1:	0f af 45 10          	imul   0x10(%ebp),%eax
  1060a5:	89 c2                	mov    %eax,%edx
  1060a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1060aa:	01 d0                	add    %edx,%eax
  1060ac:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  1060af:	e9 72 ff ff ff       	jmp    106026 <strtol+0xa7>
            break;
  1060b4:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  1060b5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1060b9:	74 08                	je     1060c3 <strtol+0x144>
        *endptr = (char *) s;
  1060bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1060be:	8b 55 08             	mov    0x8(%ebp),%edx
  1060c1:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  1060c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  1060c7:	74 07                	je     1060d0 <strtol+0x151>
  1060c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1060cc:	f7 d8                	neg    %eax
  1060ce:	eb 03                	jmp    1060d3 <strtol+0x154>
  1060d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  1060d3:	c9                   	leave  
  1060d4:	c3                   	ret    

001060d5 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  1060d5:	55                   	push   %ebp
  1060d6:	89 e5                	mov    %esp,%ebp
  1060d8:	57                   	push   %edi
  1060d9:	83 ec 24             	sub    $0x24,%esp
  1060dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1060df:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  1060e2:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  1060e6:	8b 45 08             	mov    0x8(%ebp),%eax
  1060e9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1060ec:	88 55 f7             	mov    %dl,-0x9(%ebp)
  1060ef:	8b 45 10             	mov    0x10(%ebp),%eax
  1060f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  1060f5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  1060f8:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  1060fc:	8b 55 f8             	mov    -0x8(%ebp),%edx
  1060ff:	89 d7                	mov    %edx,%edi
  106101:	f3 aa                	rep stos %al,%es:(%edi)
  106103:	89 fa                	mov    %edi,%edx
  106105:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  106108:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  10610b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10610e:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  10610f:	83 c4 24             	add    $0x24,%esp
  106112:	5f                   	pop    %edi
  106113:	5d                   	pop    %ebp
  106114:	c3                   	ret    

00106115 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  106115:	55                   	push   %ebp
  106116:	89 e5                	mov    %esp,%ebp
  106118:	57                   	push   %edi
  106119:	56                   	push   %esi
  10611a:	53                   	push   %ebx
  10611b:	83 ec 30             	sub    $0x30,%esp
  10611e:	8b 45 08             	mov    0x8(%ebp),%eax
  106121:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106124:	8b 45 0c             	mov    0xc(%ebp),%eax
  106127:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10612a:	8b 45 10             	mov    0x10(%ebp),%eax
  10612d:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  106130:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106133:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  106136:	73 42                	jae    10617a <memmove+0x65>
  106138:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10613b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10613e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  106141:	89 45 e0             	mov    %eax,-0x20(%ebp)
  106144:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106147:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  10614a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10614d:	c1 e8 02             	shr    $0x2,%eax
  106150:	89 c1                	mov    %eax,%ecx
    asm volatile (
  106152:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106155:	8b 45 e0             	mov    -0x20(%ebp),%eax
  106158:	89 d7                	mov    %edx,%edi
  10615a:	89 c6                	mov    %eax,%esi
  10615c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  10615e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  106161:	83 e1 03             	and    $0x3,%ecx
  106164:	74 02                	je     106168 <memmove+0x53>
  106166:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  106168:	89 f0                	mov    %esi,%eax
  10616a:	89 fa                	mov    %edi,%edx
  10616c:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  10616f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  106172:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
  106175:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
  106178:	eb 36                	jmp    1061b0 <memmove+0x9b>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  10617a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10617d:	8d 50 ff             	lea    -0x1(%eax),%edx
  106180:	8b 45 ec             	mov    -0x14(%ebp),%eax
  106183:	01 c2                	add    %eax,%edx
  106185:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106188:	8d 48 ff             	lea    -0x1(%eax),%ecx
  10618b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10618e:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  106191:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106194:	89 c1                	mov    %eax,%ecx
  106196:	89 d8                	mov    %ebx,%eax
  106198:	89 d6                	mov    %edx,%esi
  10619a:	89 c7                	mov    %eax,%edi
  10619c:	fd                   	std    
  10619d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10619f:	fc                   	cld    
  1061a0:	89 f8                	mov    %edi,%eax
  1061a2:	89 f2                	mov    %esi,%edx
  1061a4:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  1061a7:	89 55 c8             	mov    %edx,-0x38(%ebp)
  1061aa:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  1061ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  1061b0:	83 c4 30             	add    $0x30,%esp
  1061b3:	5b                   	pop    %ebx
  1061b4:	5e                   	pop    %esi
  1061b5:	5f                   	pop    %edi
  1061b6:	5d                   	pop    %ebp
  1061b7:	c3                   	ret    

001061b8 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  1061b8:	55                   	push   %ebp
  1061b9:	89 e5                	mov    %esp,%ebp
  1061bb:	57                   	push   %edi
  1061bc:	56                   	push   %esi
  1061bd:	83 ec 20             	sub    $0x20,%esp
  1061c0:	8b 45 08             	mov    0x8(%ebp),%eax
  1061c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1061c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1061c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1061cc:	8b 45 10             	mov    0x10(%ebp),%eax
  1061cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  1061d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1061d5:	c1 e8 02             	shr    $0x2,%eax
  1061d8:	89 c1                	mov    %eax,%ecx
    asm volatile (
  1061da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1061dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1061e0:	89 d7                	mov    %edx,%edi
  1061e2:	89 c6                	mov    %eax,%esi
  1061e4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1061e6:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  1061e9:	83 e1 03             	and    $0x3,%ecx
  1061ec:	74 02                	je     1061f0 <memcpy+0x38>
  1061ee:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1061f0:	89 f0                	mov    %esi,%eax
  1061f2:	89 fa                	mov    %edi,%edx
  1061f4:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1061f7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  1061fa:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  1061fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
  106200:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  106201:	83 c4 20             	add    $0x20,%esp
  106204:	5e                   	pop    %esi
  106205:	5f                   	pop    %edi
  106206:	5d                   	pop    %ebp
  106207:	c3                   	ret    

00106208 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  106208:	55                   	push   %ebp
  106209:	89 e5                	mov    %esp,%ebp
  10620b:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  10620e:	8b 45 08             	mov    0x8(%ebp),%eax
  106211:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  106214:	8b 45 0c             	mov    0xc(%ebp),%eax
  106217:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  10621a:	eb 2e                	jmp    10624a <memcmp+0x42>
        if (*s1 != *s2) {
  10621c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10621f:	0f b6 10             	movzbl (%eax),%edx
  106222:	8b 45 f8             	mov    -0x8(%ebp),%eax
  106225:	0f b6 00             	movzbl (%eax),%eax
  106228:	38 c2                	cmp    %al,%dl
  10622a:	74 18                	je     106244 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  10622c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10622f:	0f b6 00             	movzbl (%eax),%eax
  106232:	0f b6 d0             	movzbl %al,%edx
  106235:	8b 45 f8             	mov    -0x8(%ebp),%eax
  106238:	0f b6 00             	movzbl (%eax),%eax
  10623b:	0f b6 c0             	movzbl %al,%eax
  10623e:	29 c2                	sub    %eax,%edx
  106240:	89 d0                	mov    %edx,%eax
  106242:	eb 18                	jmp    10625c <memcmp+0x54>
        }
        s1 ++, s2 ++;
  106244:	ff 45 fc             	incl   -0x4(%ebp)
  106247:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
  10624a:	8b 45 10             	mov    0x10(%ebp),%eax
  10624d:	8d 50 ff             	lea    -0x1(%eax),%edx
  106250:	89 55 10             	mov    %edx,0x10(%ebp)
  106253:	85 c0                	test   %eax,%eax
  106255:	75 c5                	jne    10621c <memcmp+0x14>
    }
    return 0;
  106257:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10625c:	c9                   	leave  
  10625d:	c3                   	ret    

0010625e <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  10625e:	55                   	push   %ebp
  10625f:	89 e5                	mov    %esp,%ebp
  106261:	83 ec 58             	sub    $0x58,%esp
  106264:	8b 45 10             	mov    0x10(%ebp),%eax
  106267:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10626a:	8b 45 14             	mov    0x14(%ebp),%eax
  10626d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  106270:	8b 45 d0             	mov    -0x30(%ebp),%eax
  106273:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  106276:	89 45 e8             	mov    %eax,-0x18(%ebp)
  106279:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  10627c:	8b 45 18             	mov    0x18(%ebp),%eax
  10627f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  106282:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106285:	8b 55 ec             	mov    -0x14(%ebp),%edx
  106288:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10628b:	89 55 f0             	mov    %edx,-0x10(%ebp)
  10628e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106291:	89 45 f4             	mov    %eax,-0xc(%ebp)
  106294:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  106298:	74 1c                	je     1062b6 <printnum+0x58>
  10629a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10629d:	ba 00 00 00 00       	mov    $0x0,%edx
  1062a2:	f7 75 e4             	divl   -0x1c(%ebp)
  1062a5:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1062a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1062ab:	ba 00 00 00 00       	mov    $0x0,%edx
  1062b0:	f7 75 e4             	divl   -0x1c(%ebp)
  1062b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1062b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1062b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1062bc:	f7 75 e4             	divl   -0x1c(%ebp)
  1062bf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1062c2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  1062c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1062c8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1062cb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1062ce:	89 55 ec             	mov    %edx,-0x14(%ebp)
  1062d1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1062d4:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  1062d7:	8b 45 18             	mov    0x18(%ebp),%eax
  1062da:	ba 00 00 00 00       	mov    $0x0,%edx
  1062df:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  1062e2:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  1062e5:	19 d1                	sbb    %edx,%ecx
  1062e7:	72 4c                	jb     106335 <printnum+0xd7>
        printnum(putch, putdat, result, base, width - 1, padc);
  1062e9:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1062ec:	8d 50 ff             	lea    -0x1(%eax),%edx
  1062ef:	8b 45 20             	mov    0x20(%ebp),%eax
  1062f2:	89 44 24 18          	mov    %eax,0x18(%esp)
  1062f6:	89 54 24 14          	mov    %edx,0x14(%esp)
  1062fa:	8b 45 18             	mov    0x18(%ebp),%eax
  1062fd:	89 44 24 10          	mov    %eax,0x10(%esp)
  106301:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106304:	8b 55 ec             	mov    -0x14(%ebp),%edx
  106307:	89 44 24 08          	mov    %eax,0x8(%esp)
  10630b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  10630f:	8b 45 0c             	mov    0xc(%ebp),%eax
  106312:	89 44 24 04          	mov    %eax,0x4(%esp)
  106316:	8b 45 08             	mov    0x8(%ebp),%eax
  106319:	89 04 24             	mov    %eax,(%esp)
  10631c:	e8 3d ff ff ff       	call   10625e <printnum>
  106321:	eb 1b                	jmp    10633e <printnum+0xe0>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  106323:	8b 45 0c             	mov    0xc(%ebp),%eax
  106326:	89 44 24 04          	mov    %eax,0x4(%esp)
  10632a:	8b 45 20             	mov    0x20(%ebp),%eax
  10632d:	89 04 24             	mov    %eax,(%esp)
  106330:	8b 45 08             	mov    0x8(%ebp),%eax
  106333:	ff d0                	call   *%eax
        while (-- width > 0)
  106335:	ff 4d 1c             	decl   0x1c(%ebp)
  106338:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  10633c:	7f e5                	jg     106323 <printnum+0xc5>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  10633e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  106341:	05 0c 7c 10 00       	add    $0x107c0c,%eax
  106346:	0f b6 00             	movzbl (%eax),%eax
  106349:	0f be c0             	movsbl %al,%eax
  10634c:	8b 55 0c             	mov    0xc(%ebp),%edx
  10634f:	89 54 24 04          	mov    %edx,0x4(%esp)
  106353:	89 04 24             	mov    %eax,(%esp)
  106356:	8b 45 08             	mov    0x8(%ebp),%eax
  106359:	ff d0                	call   *%eax
}
  10635b:	90                   	nop
  10635c:	c9                   	leave  
  10635d:	c3                   	ret    

0010635e <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  10635e:	55                   	push   %ebp
  10635f:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  106361:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  106365:	7e 14                	jle    10637b <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  106367:	8b 45 08             	mov    0x8(%ebp),%eax
  10636a:	8b 00                	mov    (%eax),%eax
  10636c:	8d 48 08             	lea    0x8(%eax),%ecx
  10636f:	8b 55 08             	mov    0x8(%ebp),%edx
  106372:	89 0a                	mov    %ecx,(%edx)
  106374:	8b 50 04             	mov    0x4(%eax),%edx
  106377:	8b 00                	mov    (%eax),%eax
  106379:	eb 30                	jmp    1063ab <getuint+0x4d>
    }
    else if (lflag) {
  10637b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10637f:	74 16                	je     106397 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  106381:	8b 45 08             	mov    0x8(%ebp),%eax
  106384:	8b 00                	mov    (%eax),%eax
  106386:	8d 48 04             	lea    0x4(%eax),%ecx
  106389:	8b 55 08             	mov    0x8(%ebp),%edx
  10638c:	89 0a                	mov    %ecx,(%edx)
  10638e:	8b 00                	mov    (%eax),%eax
  106390:	ba 00 00 00 00       	mov    $0x0,%edx
  106395:	eb 14                	jmp    1063ab <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  106397:	8b 45 08             	mov    0x8(%ebp),%eax
  10639a:	8b 00                	mov    (%eax),%eax
  10639c:	8d 48 04             	lea    0x4(%eax),%ecx
  10639f:	8b 55 08             	mov    0x8(%ebp),%edx
  1063a2:	89 0a                	mov    %ecx,(%edx)
  1063a4:	8b 00                	mov    (%eax),%eax
  1063a6:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  1063ab:	5d                   	pop    %ebp
  1063ac:	c3                   	ret    

001063ad <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  1063ad:	55                   	push   %ebp
  1063ae:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1063b0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1063b4:	7e 14                	jle    1063ca <getint+0x1d>
        return va_arg(*ap, long long);
  1063b6:	8b 45 08             	mov    0x8(%ebp),%eax
  1063b9:	8b 00                	mov    (%eax),%eax
  1063bb:	8d 48 08             	lea    0x8(%eax),%ecx
  1063be:	8b 55 08             	mov    0x8(%ebp),%edx
  1063c1:	89 0a                	mov    %ecx,(%edx)
  1063c3:	8b 50 04             	mov    0x4(%eax),%edx
  1063c6:	8b 00                	mov    (%eax),%eax
  1063c8:	eb 28                	jmp    1063f2 <getint+0x45>
    }
    else if (lflag) {
  1063ca:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1063ce:	74 12                	je     1063e2 <getint+0x35>
        return va_arg(*ap, long);
  1063d0:	8b 45 08             	mov    0x8(%ebp),%eax
  1063d3:	8b 00                	mov    (%eax),%eax
  1063d5:	8d 48 04             	lea    0x4(%eax),%ecx
  1063d8:	8b 55 08             	mov    0x8(%ebp),%edx
  1063db:	89 0a                	mov    %ecx,(%edx)
  1063dd:	8b 00                	mov    (%eax),%eax
  1063df:	99                   	cltd   
  1063e0:	eb 10                	jmp    1063f2 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  1063e2:	8b 45 08             	mov    0x8(%ebp),%eax
  1063e5:	8b 00                	mov    (%eax),%eax
  1063e7:	8d 48 04             	lea    0x4(%eax),%ecx
  1063ea:	8b 55 08             	mov    0x8(%ebp),%edx
  1063ed:	89 0a                	mov    %ecx,(%edx)
  1063ef:	8b 00                	mov    (%eax),%eax
  1063f1:	99                   	cltd   
    }
}
  1063f2:	5d                   	pop    %ebp
  1063f3:	c3                   	ret    

001063f4 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  1063f4:	55                   	push   %ebp
  1063f5:	89 e5                	mov    %esp,%ebp
  1063f7:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  1063fa:	8d 45 14             	lea    0x14(%ebp),%eax
  1063fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  106400:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106403:	89 44 24 0c          	mov    %eax,0xc(%esp)
  106407:	8b 45 10             	mov    0x10(%ebp),%eax
  10640a:	89 44 24 08          	mov    %eax,0x8(%esp)
  10640e:	8b 45 0c             	mov    0xc(%ebp),%eax
  106411:	89 44 24 04          	mov    %eax,0x4(%esp)
  106415:	8b 45 08             	mov    0x8(%ebp),%eax
  106418:	89 04 24             	mov    %eax,(%esp)
  10641b:	e8 03 00 00 00       	call   106423 <vprintfmt>
    va_end(ap);
}
  106420:	90                   	nop
  106421:	c9                   	leave  
  106422:	c3                   	ret    

00106423 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  106423:	55                   	push   %ebp
  106424:	89 e5                	mov    %esp,%ebp
  106426:	56                   	push   %esi
  106427:	53                   	push   %ebx
  106428:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  10642b:	eb 17                	jmp    106444 <vprintfmt+0x21>
            if (ch == '\0') {
  10642d:	85 db                	test   %ebx,%ebx
  10642f:	0f 84 bf 03 00 00    	je     1067f4 <vprintfmt+0x3d1>
                return;
            }
            putch(ch, putdat);
  106435:	8b 45 0c             	mov    0xc(%ebp),%eax
  106438:	89 44 24 04          	mov    %eax,0x4(%esp)
  10643c:	89 1c 24             	mov    %ebx,(%esp)
  10643f:	8b 45 08             	mov    0x8(%ebp),%eax
  106442:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  106444:	8b 45 10             	mov    0x10(%ebp),%eax
  106447:	8d 50 01             	lea    0x1(%eax),%edx
  10644a:	89 55 10             	mov    %edx,0x10(%ebp)
  10644d:	0f b6 00             	movzbl (%eax),%eax
  106450:	0f b6 d8             	movzbl %al,%ebx
  106453:	83 fb 25             	cmp    $0x25,%ebx
  106456:	75 d5                	jne    10642d <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
  106458:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  10645c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  106463:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106466:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  106469:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  106470:	8b 45 dc             	mov    -0x24(%ebp),%eax
  106473:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  106476:	8b 45 10             	mov    0x10(%ebp),%eax
  106479:	8d 50 01             	lea    0x1(%eax),%edx
  10647c:	89 55 10             	mov    %edx,0x10(%ebp)
  10647f:	0f b6 00             	movzbl (%eax),%eax
  106482:	0f b6 d8             	movzbl %al,%ebx
  106485:	8d 43 dd             	lea    -0x23(%ebx),%eax
  106488:	83 f8 55             	cmp    $0x55,%eax
  10648b:	0f 87 37 03 00 00    	ja     1067c8 <vprintfmt+0x3a5>
  106491:	8b 04 85 30 7c 10 00 	mov    0x107c30(,%eax,4),%eax
  106498:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  10649a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  10649e:	eb d6                	jmp    106476 <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  1064a0:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  1064a4:	eb d0                	jmp    106476 <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  1064a6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  1064ad:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1064b0:	89 d0                	mov    %edx,%eax
  1064b2:	c1 e0 02             	shl    $0x2,%eax
  1064b5:	01 d0                	add    %edx,%eax
  1064b7:	01 c0                	add    %eax,%eax
  1064b9:	01 d8                	add    %ebx,%eax
  1064bb:	83 e8 30             	sub    $0x30,%eax
  1064be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  1064c1:	8b 45 10             	mov    0x10(%ebp),%eax
  1064c4:	0f b6 00             	movzbl (%eax),%eax
  1064c7:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  1064ca:	83 fb 2f             	cmp    $0x2f,%ebx
  1064cd:	7e 38                	jle    106507 <vprintfmt+0xe4>
  1064cf:	83 fb 39             	cmp    $0x39,%ebx
  1064d2:	7f 33                	jg     106507 <vprintfmt+0xe4>
            for (precision = 0; ; ++ fmt) {
  1064d4:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
  1064d7:	eb d4                	jmp    1064ad <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  1064d9:	8b 45 14             	mov    0x14(%ebp),%eax
  1064dc:	8d 50 04             	lea    0x4(%eax),%edx
  1064df:	89 55 14             	mov    %edx,0x14(%ebp)
  1064e2:	8b 00                	mov    (%eax),%eax
  1064e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  1064e7:	eb 1f                	jmp    106508 <vprintfmt+0xe5>

        case '.':
            if (width < 0)
  1064e9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1064ed:	79 87                	jns    106476 <vprintfmt+0x53>
                width = 0;
  1064ef:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  1064f6:	e9 7b ff ff ff       	jmp    106476 <vprintfmt+0x53>

        case '#':
            altflag = 1;
  1064fb:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  106502:	e9 6f ff ff ff       	jmp    106476 <vprintfmt+0x53>
            goto process_precision;
  106507:	90                   	nop

        process_precision:
            if (width < 0)
  106508:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10650c:	0f 89 64 ff ff ff    	jns    106476 <vprintfmt+0x53>
                width = precision, precision = -1;
  106512:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106515:	89 45 e8             	mov    %eax,-0x18(%ebp)
  106518:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  10651f:	e9 52 ff ff ff       	jmp    106476 <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  106524:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
  106527:	e9 4a ff ff ff       	jmp    106476 <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  10652c:	8b 45 14             	mov    0x14(%ebp),%eax
  10652f:	8d 50 04             	lea    0x4(%eax),%edx
  106532:	89 55 14             	mov    %edx,0x14(%ebp)
  106535:	8b 00                	mov    (%eax),%eax
  106537:	8b 55 0c             	mov    0xc(%ebp),%edx
  10653a:	89 54 24 04          	mov    %edx,0x4(%esp)
  10653e:	89 04 24             	mov    %eax,(%esp)
  106541:	8b 45 08             	mov    0x8(%ebp),%eax
  106544:	ff d0                	call   *%eax
            break;
  106546:	e9 a4 02 00 00       	jmp    1067ef <vprintfmt+0x3cc>

        // error message
        case 'e':
            err = va_arg(ap, int);
  10654b:	8b 45 14             	mov    0x14(%ebp),%eax
  10654e:	8d 50 04             	lea    0x4(%eax),%edx
  106551:	89 55 14             	mov    %edx,0x14(%ebp)
  106554:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  106556:	85 db                	test   %ebx,%ebx
  106558:	79 02                	jns    10655c <vprintfmt+0x139>
                err = -err;
  10655a:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  10655c:	83 fb 06             	cmp    $0x6,%ebx
  10655f:	7f 0b                	jg     10656c <vprintfmt+0x149>
  106561:	8b 34 9d f0 7b 10 00 	mov    0x107bf0(,%ebx,4),%esi
  106568:	85 f6                	test   %esi,%esi
  10656a:	75 23                	jne    10658f <vprintfmt+0x16c>
                printfmt(putch, putdat, "error %d", err);
  10656c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  106570:	c7 44 24 08 1d 7c 10 	movl   $0x107c1d,0x8(%esp)
  106577:	00 
  106578:	8b 45 0c             	mov    0xc(%ebp),%eax
  10657b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10657f:	8b 45 08             	mov    0x8(%ebp),%eax
  106582:	89 04 24             	mov    %eax,(%esp)
  106585:	e8 6a fe ff ff       	call   1063f4 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  10658a:	e9 60 02 00 00       	jmp    1067ef <vprintfmt+0x3cc>
                printfmt(putch, putdat, "%s", p);
  10658f:	89 74 24 0c          	mov    %esi,0xc(%esp)
  106593:	c7 44 24 08 26 7c 10 	movl   $0x107c26,0x8(%esp)
  10659a:	00 
  10659b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10659e:	89 44 24 04          	mov    %eax,0x4(%esp)
  1065a2:	8b 45 08             	mov    0x8(%ebp),%eax
  1065a5:	89 04 24             	mov    %eax,(%esp)
  1065a8:	e8 47 fe ff ff       	call   1063f4 <printfmt>
            break;
  1065ad:	e9 3d 02 00 00       	jmp    1067ef <vprintfmt+0x3cc>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  1065b2:	8b 45 14             	mov    0x14(%ebp),%eax
  1065b5:	8d 50 04             	lea    0x4(%eax),%edx
  1065b8:	89 55 14             	mov    %edx,0x14(%ebp)
  1065bb:	8b 30                	mov    (%eax),%esi
  1065bd:	85 f6                	test   %esi,%esi
  1065bf:	75 05                	jne    1065c6 <vprintfmt+0x1a3>
                p = "(null)";
  1065c1:	be 29 7c 10 00       	mov    $0x107c29,%esi
            }
            if (width > 0 && padc != '-') {
  1065c6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1065ca:	7e 76                	jle    106642 <vprintfmt+0x21f>
  1065cc:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  1065d0:	74 70                	je     106642 <vprintfmt+0x21f>
                for (width -= strnlen(p, precision); width > 0; width --) {
  1065d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1065d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1065d9:	89 34 24             	mov    %esi,(%esp)
  1065dc:	e8 fb f7 ff ff       	call   105ddc <strnlen>
  1065e1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1065e4:	29 c2                	sub    %eax,%edx
  1065e6:	89 d0                	mov    %edx,%eax
  1065e8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1065eb:	eb 16                	jmp    106603 <vprintfmt+0x1e0>
                    putch(padc, putdat);
  1065ed:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  1065f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  1065f4:	89 54 24 04          	mov    %edx,0x4(%esp)
  1065f8:	89 04 24             	mov    %eax,(%esp)
  1065fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1065fe:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
  106600:	ff 4d e8             	decl   -0x18(%ebp)
  106603:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  106607:	7f e4                	jg     1065ed <vprintfmt+0x1ca>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  106609:	eb 37                	jmp    106642 <vprintfmt+0x21f>
                if (altflag && (ch < ' ' || ch > '~')) {
  10660b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  10660f:	74 1f                	je     106630 <vprintfmt+0x20d>
  106611:	83 fb 1f             	cmp    $0x1f,%ebx
  106614:	7e 05                	jle    10661b <vprintfmt+0x1f8>
  106616:	83 fb 7e             	cmp    $0x7e,%ebx
  106619:	7e 15                	jle    106630 <vprintfmt+0x20d>
                    putch('?', putdat);
  10661b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10661e:	89 44 24 04          	mov    %eax,0x4(%esp)
  106622:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  106629:	8b 45 08             	mov    0x8(%ebp),%eax
  10662c:	ff d0                	call   *%eax
  10662e:	eb 0f                	jmp    10663f <vprintfmt+0x21c>
                }
                else {
                    putch(ch, putdat);
  106630:	8b 45 0c             	mov    0xc(%ebp),%eax
  106633:	89 44 24 04          	mov    %eax,0x4(%esp)
  106637:	89 1c 24             	mov    %ebx,(%esp)
  10663a:	8b 45 08             	mov    0x8(%ebp),%eax
  10663d:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  10663f:	ff 4d e8             	decl   -0x18(%ebp)
  106642:	89 f0                	mov    %esi,%eax
  106644:	8d 70 01             	lea    0x1(%eax),%esi
  106647:	0f b6 00             	movzbl (%eax),%eax
  10664a:	0f be d8             	movsbl %al,%ebx
  10664d:	85 db                	test   %ebx,%ebx
  10664f:	74 27                	je     106678 <vprintfmt+0x255>
  106651:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  106655:	78 b4                	js     10660b <vprintfmt+0x1e8>
  106657:	ff 4d e4             	decl   -0x1c(%ebp)
  10665a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10665e:	79 ab                	jns    10660b <vprintfmt+0x1e8>
                }
            }
            for (; width > 0; width --) {
  106660:	eb 16                	jmp    106678 <vprintfmt+0x255>
                putch(' ', putdat);
  106662:	8b 45 0c             	mov    0xc(%ebp),%eax
  106665:	89 44 24 04          	mov    %eax,0x4(%esp)
  106669:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  106670:	8b 45 08             	mov    0x8(%ebp),%eax
  106673:	ff d0                	call   *%eax
            for (; width > 0; width --) {
  106675:	ff 4d e8             	decl   -0x18(%ebp)
  106678:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10667c:	7f e4                	jg     106662 <vprintfmt+0x23f>
            }
            break;
  10667e:	e9 6c 01 00 00       	jmp    1067ef <vprintfmt+0x3cc>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  106683:	8b 45 e0             	mov    -0x20(%ebp),%eax
  106686:	89 44 24 04          	mov    %eax,0x4(%esp)
  10668a:	8d 45 14             	lea    0x14(%ebp),%eax
  10668d:	89 04 24             	mov    %eax,(%esp)
  106690:	e8 18 fd ff ff       	call   1063ad <getint>
  106695:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106698:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  10669b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10669e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1066a1:	85 d2                	test   %edx,%edx
  1066a3:	79 26                	jns    1066cb <vprintfmt+0x2a8>
                putch('-', putdat);
  1066a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1066a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1066ac:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  1066b3:	8b 45 08             	mov    0x8(%ebp),%eax
  1066b6:	ff d0                	call   *%eax
                num = -(long long)num;
  1066b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1066bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1066be:	f7 d8                	neg    %eax
  1066c0:	83 d2 00             	adc    $0x0,%edx
  1066c3:	f7 da                	neg    %edx
  1066c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1066c8:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  1066cb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1066d2:	e9 a8 00 00 00       	jmp    10677f <vprintfmt+0x35c>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  1066d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1066da:	89 44 24 04          	mov    %eax,0x4(%esp)
  1066de:	8d 45 14             	lea    0x14(%ebp),%eax
  1066e1:	89 04 24             	mov    %eax,(%esp)
  1066e4:	e8 75 fc ff ff       	call   10635e <getuint>
  1066e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1066ec:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  1066ef:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1066f6:	e9 84 00 00 00       	jmp    10677f <vprintfmt+0x35c>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  1066fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1066fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  106702:	8d 45 14             	lea    0x14(%ebp),%eax
  106705:	89 04 24             	mov    %eax,(%esp)
  106708:	e8 51 fc ff ff       	call   10635e <getuint>
  10670d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106710:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  106713:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  10671a:	eb 63                	jmp    10677f <vprintfmt+0x35c>

        // pointer
        case 'p':
            putch('0', putdat);
  10671c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10671f:	89 44 24 04          	mov    %eax,0x4(%esp)
  106723:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  10672a:	8b 45 08             	mov    0x8(%ebp),%eax
  10672d:	ff d0                	call   *%eax
            putch('x', putdat);
  10672f:	8b 45 0c             	mov    0xc(%ebp),%eax
  106732:	89 44 24 04          	mov    %eax,0x4(%esp)
  106736:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  10673d:	8b 45 08             	mov    0x8(%ebp),%eax
  106740:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  106742:	8b 45 14             	mov    0x14(%ebp),%eax
  106745:	8d 50 04             	lea    0x4(%eax),%edx
  106748:	89 55 14             	mov    %edx,0x14(%ebp)
  10674b:	8b 00                	mov    (%eax),%eax
  10674d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106750:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  106757:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  10675e:	eb 1f                	jmp    10677f <vprintfmt+0x35c>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  106760:	8b 45 e0             	mov    -0x20(%ebp),%eax
  106763:	89 44 24 04          	mov    %eax,0x4(%esp)
  106767:	8d 45 14             	lea    0x14(%ebp),%eax
  10676a:	89 04 24             	mov    %eax,(%esp)
  10676d:	e8 ec fb ff ff       	call   10635e <getuint>
  106772:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106775:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  106778:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  10677f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  106783:	8b 45 ec             	mov    -0x14(%ebp),%eax
  106786:	89 54 24 18          	mov    %edx,0x18(%esp)
  10678a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  10678d:	89 54 24 14          	mov    %edx,0x14(%esp)
  106791:	89 44 24 10          	mov    %eax,0x10(%esp)
  106795:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106798:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10679b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10679f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1067a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1067a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1067aa:	8b 45 08             	mov    0x8(%ebp),%eax
  1067ad:	89 04 24             	mov    %eax,(%esp)
  1067b0:	e8 a9 fa ff ff       	call   10625e <printnum>
            break;
  1067b5:	eb 38                	jmp    1067ef <vprintfmt+0x3cc>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  1067b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1067ba:	89 44 24 04          	mov    %eax,0x4(%esp)
  1067be:	89 1c 24             	mov    %ebx,(%esp)
  1067c1:	8b 45 08             	mov    0x8(%ebp),%eax
  1067c4:	ff d0                	call   *%eax
            break;
  1067c6:	eb 27                	jmp    1067ef <vprintfmt+0x3cc>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  1067c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1067cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1067cf:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  1067d6:	8b 45 08             	mov    0x8(%ebp),%eax
  1067d9:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  1067db:	ff 4d 10             	decl   0x10(%ebp)
  1067de:	eb 03                	jmp    1067e3 <vprintfmt+0x3c0>
  1067e0:	ff 4d 10             	decl   0x10(%ebp)
  1067e3:	8b 45 10             	mov    0x10(%ebp),%eax
  1067e6:	48                   	dec    %eax
  1067e7:	0f b6 00             	movzbl (%eax),%eax
  1067ea:	3c 25                	cmp    $0x25,%al
  1067ec:	75 f2                	jne    1067e0 <vprintfmt+0x3bd>
                /* do nothing */;
            break;
  1067ee:	90                   	nop
    while (1) {
  1067ef:	e9 37 fc ff ff       	jmp    10642b <vprintfmt+0x8>
                return;
  1067f4:	90                   	nop
        }
    }
}
  1067f5:	83 c4 40             	add    $0x40,%esp
  1067f8:	5b                   	pop    %ebx
  1067f9:	5e                   	pop    %esi
  1067fa:	5d                   	pop    %ebp
  1067fb:	c3                   	ret    

001067fc <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  1067fc:	55                   	push   %ebp
  1067fd:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  1067ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  106802:	8b 40 08             	mov    0x8(%eax),%eax
  106805:	8d 50 01             	lea    0x1(%eax),%edx
  106808:	8b 45 0c             	mov    0xc(%ebp),%eax
  10680b:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  10680e:	8b 45 0c             	mov    0xc(%ebp),%eax
  106811:	8b 10                	mov    (%eax),%edx
  106813:	8b 45 0c             	mov    0xc(%ebp),%eax
  106816:	8b 40 04             	mov    0x4(%eax),%eax
  106819:	39 c2                	cmp    %eax,%edx
  10681b:	73 12                	jae    10682f <sprintputch+0x33>
        *b->buf ++ = ch;
  10681d:	8b 45 0c             	mov    0xc(%ebp),%eax
  106820:	8b 00                	mov    (%eax),%eax
  106822:	8d 48 01             	lea    0x1(%eax),%ecx
  106825:	8b 55 0c             	mov    0xc(%ebp),%edx
  106828:	89 0a                	mov    %ecx,(%edx)
  10682a:	8b 55 08             	mov    0x8(%ebp),%edx
  10682d:	88 10                	mov    %dl,(%eax)
    }
}
  10682f:	90                   	nop
  106830:	5d                   	pop    %ebp
  106831:	c3                   	ret    

00106832 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  106832:	55                   	push   %ebp
  106833:	89 e5                	mov    %esp,%ebp
  106835:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  106838:	8d 45 14             	lea    0x14(%ebp),%eax
  10683b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  10683e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106841:	89 44 24 0c          	mov    %eax,0xc(%esp)
  106845:	8b 45 10             	mov    0x10(%ebp),%eax
  106848:	89 44 24 08          	mov    %eax,0x8(%esp)
  10684c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10684f:	89 44 24 04          	mov    %eax,0x4(%esp)
  106853:	8b 45 08             	mov    0x8(%ebp),%eax
  106856:	89 04 24             	mov    %eax,(%esp)
  106859:	e8 08 00 00 00       	call   106866 <vsnprintf>
  10685e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  106861:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  106864:	c9                   	leave  
  106865:	c3                   	ret    

00106866 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  106866:	55                   	push   %ebp
  106867:	89 e5                	mov    %esp,%ebp
  106869:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  10686c:	8b 45 08             	mov    0x8(%ebp),%eax
  10686f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  106872:	8b 45 0c             	mov    0xc(%ebp),%eax
  106875:	8d 50 ff             	lea    -0x1(%eax),%edx
  106878:	8b 45 08             	mov    0x8(%ebp),%eax
  10687b:	01 d0                	add    %edx,%eax
  10687d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106880:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  106887:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10688b:	74 0a                	je     106897 <vsnprintf+0x31>
  10688d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  106890:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106893:	39 c2                	cmp    %eax,%edx
  106895:	76 07                	jbe    10689e <vsnprintf+0x38>
        return -E_INVAL;
  106897:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  10689c:	eb 2a                	jmp    1068c8 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  10689e:	8b 45 14             	mov    0x14(%ebp),%eax
  1068a1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1068a5:	8b 45 10             	mov    0x10(%ebp),%eax
  1068a8:	89 44 24 08          	mov    %eax,0x8(%esp)
  1068ac:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1068af:	89 44 24 04          	mov    %eax,0x4(%esp)
  1068b3:	c7 04 24 fc 67 10 00 	movl   $0x1067fc,(%esp)
  1068ba:	e8 64 fb ff ff       	call   106423 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  1068bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1068c2:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  1068c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1068c8:	c9                   	leave  
  1068c9:	c3                   	ret    
