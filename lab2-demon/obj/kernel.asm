
bin/kernel：     文件格式 elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
	# __boot_pgidr代表一个变量，但是计算时却使用的是地址。为什么？？？
    movl $REALLOC(__boot_pgdir), %eax
  100000:	b8 00 b0 11 00       	mov    $0x11b000,%eax
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
    # unmap va 0 ~ 4M, it's temporary mapping
	#xorl %eax, %eax
	#movl %eax, __boot_pgdir

    # set ebp, esp
    movl $0x0, %ebp
  10001e:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  100023:	bc 00 a0 11 00       	mov    $0x11a000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  100028:	e8 02 00 00 00       	call   10002f <kern_init>

0010002d <spin>:

# should never get here
spin:
    jmp spin
  10002d:	eb fe                	jmp    10002d <spin>

0010002f <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  10002f:	55                   	push   %ebp
  100030:	89 e5                	mov    %esp,%ebp
  100032:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100035:	b8 48 df 11 00       	mov    $0x11df48,%eax
  10003a:	2d 00 d0 11 00       	sub    $0x11d000,%eax
  10003f:	89 44 24 08          	mov    %eax,0x8(%esp)
  100043:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10004a:	00 
  10004b:	c7 04 24 00 d0 11 00 	movl   $0x11d000,(%esp)
  100052:	e8 b2 5f 00 00       	call   106009 <memset>

    cons_init();                // init the console
  100057:	e8 70 15 00 00       	call   1015cc <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  10005c:	c7 45 f4 00 68 10 00 	movl   $0x106800,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100063:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100066:	89 44 24 04          	mov    %eax,0x4(%esp)
  10006a:	c7 04 24 1c 68 10 00 	movl   $0x10681c,(%esp)
  100071:	e8 11 02 00 00       	call   100287 <cprintf>

    print_kerninfo();
  100076:	e8 a7 08 00 00       	call   100922 <print_kerninfo>

    grade_backtrace();
  10007b:	e8 89 00 00 00       	call   100109 <grade_backtrace>

    pmm_init();                 // init physical memory management
  100080:	e8 50 35 00 00       	call   1035d5 <pmm_init>

    pic_init();                 // init interrupt controller
  100085:	e8 a7 16 00 00       	call   101731 <pic_init>
    idt_init();                 // init interrupt descriptor table
  10008a:	e8 31 18 00 00       	call   1018c0 <idt_init>

    clock_init();               // init clock interrupt
  10008f:	e8 db 0c 00 00       	call   100d6f <clock_init>
    intr_enable();              // enable irq interrupt
  100094:	e8 d2 17 00 00       	call   10186b <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    // lab1_switch_test();

    /* do nothing */
	while (1);
  100099:	eb fe                	jmp    100099 <kern_init+0x6a>

0010009b <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  10009b:	55                   	push   %ebp
  10009c:	89 e5                	mov    %esp,%ebp
  10009e:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  1000a1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1000a8:	00 
  1000a9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1000b0:	00 
  1000b1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000b8:	e8 a0 0c 00 00       	call   100d5d <mon_backtrace>
}
  1000bd:	90                   	nop
  1000be:	c9                   	leave  
  1000bf:	c3                   	ret    

001000c0 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000c0:	55                   	push   %ebp
  1000c1:	89 e5                	mov    %esp,%ebp
  1000c3:	53                   	push   %ebx
  1000c4:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000c7:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  1000ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  1000cd:	8d 5d 08             	lea    0x8(%ebp),%ebx
  1000d0:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1000d7:	89 54 24 08          	mov    %edx,0x8(%esp)
  1000db:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1000df:	89 04 24             	mov    %eax,(%esp)
  1000e2:	e8 b4 ff ff ff       	call   10009b <grade_backtrace2>
}
  1000e7:	90                   	nop
  1000e8:	83 c4 14             	add    $0x14,%esp
  1000eb:	5b                   	pop    %ebx
  1000ec:	5d                   	pop    %ebp
  1000ed:	c3                   	ret    

001000ee <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000ee:	55                   	push   %ebp
  1000ef:	89 e5                	mov    %esp,%ebp
  1000f1:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000f4:	8b 45 10             	mov    0x10(%ebp),%eax
  1000f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1000fe:	89 04 24             	mov    %eax,(%esp)
  100101:	e8 ba ff ff ff       	call   1000c0 <grade_backtrace1>
}
  100106:	90                   	nop
  100107:	c9                   	leave  
  100108:	c3                   	ret    

00100109 <grade_backtrace>:

void
grade_backtrace(void) {
  100109:	55                   	push   %ebp
  10010a:	89 e5                	mov    %esp,%ebp
  10010c:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  10010f:	b8 2f 00 10 00       	mov    $0x10002f,%eax
  100114:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  10011b:	ff 
  10011c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100120:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100127:	e8 c2 ff ff ff       	call   1000ee <grade_backtrace0>
}
  10012c:	90                   	nop
  10012d:	c9                   	leave  
  10012e:	c3                   	ret    

0010012f <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  10012f:	55                   	push   %ebp
  100130:	89 e5                	mov    %esp,%ebp
  100132:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100135:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100138:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  10013b:	8c 45 f2             	mov    %es,-0xe(%ebp)
  10013e:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100141:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100145:	83 e0 03             	and    $0x3,%eax
  100148:	89 c2                	mov    %eax,%edx
  10014a:	a1 00 d0 11 00       	mov    0x11d000,%eax
  10014f:	89 54 24 08          	mov    %edx,0x8(%esp)
  100153:	89 44 24 04          	mov    %eax,0x4(%esp)
  100157:	c7 04 24 21 68 10 00 	movl   $0x106821,(%esp)
  10015e:	e8 24 01 00 00       	call   100287 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100163:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100167:	89 c2                	mov    %eax,%edx
  100169:	a1 00 d0 11 00       	mov    0x11d000,%eax
  10016e:	89 54 24 08          	mov    %edx,0x8(%esp)
  100172:	89 44 24 04          	mov    %eax,0x4(%esp)
  100176:	c7 04 24 2f 68 10 00 	movl   $0x10682f,(%esp)
  10017d:	e8 05 01 00 00       	call   100287 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100182:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100186:	89 c2                	mov    %eax,%edx
  100188:	a1 00 d0 11 00       	mov    0x11d000,%eax
  10018d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100191:	89 44 24 04          	mov    %eax,0x4(%esp)
  100195:	c7 04 24 3d 68 10 00 	movl   $0x10683d,(%esp)
  10019c:	e8 e6 00 00 00       	call   100287 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001a1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001a5:	89 c2                	mov    %eax,%edx
  1001a7:	a1 00 d0 11 00       	mov    0x11d000,%eax
  1001ac:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001b4:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  1001bb:	e8 c7 00 00 00       	call   100287 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001c0:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001c4:	89 c2                	mov    %eax,%edx
  1001c6:	a1 00 d0 11 00       	mov    0x11d000,%eax
  1001cb:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001d3:	c7 04 24 59 68 10 00 	movl   $0x106859,(%esp)
  1001da:	e8 a8 00 00 00       	call   100287 <cprintf>
    round ++;
  1001df:	a1 00 d0 11 00       	mov    0x11d000,%eax
  1001e4:	40                   	inc    %eax
  1001e5:	a3 00 d0 11 00       	mov    %eax,0x11d000
}
  1001ea:	90                   	nop
  1001eb:	c9                   	leave  
  1001ec:	c3                   	ret    

001001ed <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001ed:	55                   	push   %ebp
  1001ee:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001f0:	90                   	nop
  1001f1:	5d                   	pop    %ebp
  1001f2:	c3                   	ret    

001001f3 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001f3:	55                   	push   %ebp
  1001f4:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  1001f6:	90                   	nop
  1001f7:	5d                   	pop    %ebp
  1001f8:	c3                   	ret    

001001f9 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001f9:	55                   	push   %ebp
  1001fa:	89 e5                	mov    %esp,%ebp
  1001fc:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  1001ff:	e8 2b ff ff ff       	call   10012f <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  100204:	c7 04 24 68 68 10 00 	movl   $0x106868,(%esp)
  10020b:	e8 77 00 00 00       	call   100287 <cprintf>
    lab1_switch_to_user();
  100210:	e8 d8 ff ff ff       	call   1001ed <lab1_switch_to_user>
    lab1_print_cur_status();
  100215:	e8 15 ff ff ff       	call   10012f <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  10021a:	c7 04 24 88 68 10 00 	movl   $0x106888,(%esp)
  100221:	e8 61 00 00 00       	call   100287 <cprintf>
    lab1_switch_to_kernel();
  100226:	e8 c8 ff ff ff       	call   1001f3 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  10022b:	e8 ff fe ff ff       	call   10012f <lab1_print_cur_status>
}
  100230:	90                   	nop
  100231:	c9                   	leave  
  100232:	c3                   	ret    

00100233 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  100233:	55                   	push   %ebp
  100234:	89 e5                	mov    %esp,%ebp
  100236:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100239:	8b 45 08             	mov    0x8(%ebp),%eax
  10023c:	89 04 24             	mov    %eax,(%esp)
  10023f:	e8 b5 13 00 00       	call   1015f9 <cons_putc>
    (*cnt) ++;
  100244:	8b 45 0c             	mov    0xc(%ebp),%eax
  100247:	8b 00                	mov    (%eax),%eax
  100249:	8d 50 01             	lea    0x1(%eax),%edx
  10024c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10024f:	89 10                	mov    %edx,(%eax)
}
  100251:	90                   	nop
  100252:	c9                   	leave  
  100253:	c3                   	ret    

00100254 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100254:	55                   	push   %ebp
  100255:	89 e5                	mov    %esp,%ebp
  100257:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10025a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100261:	8b 45 0c             	mov    0xc(%ebp),%eax
  100264:	89 44 24 0c          	mov    %eax,0xc(%esp)
  100268:	8b 45 08             	mov    0x8(%ebp),%eax
  10026b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10026f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100272:	89 44 24 04          	mov    %eax,0x4(%esp)
  100276:	c7 04 24 33 02 10 00 	movl   $0x100233,(%esp)
  10027d:	e8 d5 60 00 00       	call   106357 <vprintfmt>
    return cnt;
  100282:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100285:	c9                   	leave  
  100286:	c3                   	ret    

00100287 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100287:	55                   	push   %ebp
  100288:	89 e5                	mov    %esp,%ebp
  10028a:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  10028d:	8d 45 0c             	lea    0xc(%ebp),%eax
  100290:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100293:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100296:	89 44 24 04          	mov    %eax,0x4(%esp)
  10029a:	8b 45 08             	mov    0x8(%ebp),%eax
  10029d:	89 04 24             	mov    %eax,(%esp)
  1002a0:	e8 af ff ff ff       	call   100254 <vcprintf>
  1002a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1002a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002ab:	c9                   	leave  
  1002ac:	c3                   	ret    

001002ad <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  1002ad:	55                   	push   %ebp
  1002ae:	89 e5                	mov    %esp,%ebp
  1002b0:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002b3:	8b 45 08             	mov    0x8(%ebp),%eax
  1002b6:	89 04 24             	mov    %eax,(%esp)
  1002b9:	e8 3b 13 00 00       	call   1015f9 <cons_putc>
}
  1002be:	90                   	nop
  1002bf:	c9                   	leave  
  1002c0:	c3                   	ret    

001002c1 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  1002c1:	55                   	push   %ebp
  1002c2:	89 e5                	mov    %esp,%ebp
  1002c4:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  1002c7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  1002ce:	eb 13                	jmp    1002e3 <cputs+0x22>
        cputch(c, &cnt);
  1002d0:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  1002d4:	8d 55 f0             	lea    -0x10(%ebp),%edx
  1002d7:	89 54 24 04          	mov    %edx,0x4(%esp)
  1002db:	89 04 24             	mov    %eax,(%esp)
  1002de:	e8 50 ff ff ff       	call   100233 <cputch>
    while ((c = *str ++) != '\0') {
  1002e3:	8b 45 08             	mov    0x8(%ebp),%eax
  1002e6:	8d 50 01             	lea    0x1(%eax),%edx
  1002e9:	89 55 08             	mov    %edx,0x8(%ebp)
  1002ec:	0f b6 00             	movzbl (%eax),%eax
  1002ef:	88 45 f7             	mov    %al,-0x9(%ebp)
  1002f2:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1002f6:	75 d8                	jne    1002d0 <cputs+0xf>
    }
    cputch('\n', &cnt);
  1002f8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1002fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1002ff:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  100306:	e8 28 ff ff ff       	call   100233 <cputch>
    return cnt;
  10030b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  10030e:	c9                   	leave  
  10030f:	c3                   	ret    

00100310 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  100310:	55                   	push   %ebp
  100311:	89 e5                	mov    %esp,%ebp
  100313:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  100316:	90                   	nop
  100317:	e8 1a 13 00 00       	call   101636 <cons_getc>
  10031c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10031f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100323:	74 f2                	je     100317 <getchar+0x7>
        /* do nothing */;
    return c;
  100325:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100328:	c9                   	leave  
  100329:	c3                   	ret    

0010032a <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  10032a:	55                   	push   %ebp
  10032b:	89 e5                	mov    %esp,%ebp
  10032d:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100330:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100334:	74 13                	je     100349 <readline+0x1f>
        cprintf("%s", prompt);
  100336:	8b 45 08             	mov    0x8(%ebp),%eax
  100339:	89 44 24 04          	mov    %eax,0x4(%esp)
  10033d:	c7 04 24 a7 68 10 00 	movl   $0x1068a7,(%esp)
  100344:	e8 3e ff ff ff       	call   100287 <cprintf>
    }
    int i = 0, c;
  100349:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100350:	e8 bb ff ff ff       	call   100310 <getchar>
  100355:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100358:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10035c:	79 07                	jns    100365 <readline+0x3b>
            return NULL;
  10035e:	b8 00 00 00 00       	mov    $0x0,%eax
  100363:	eb 78                	jmp    1003dd <readline+0xb3>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100365:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100369:	7e 28                	jle    100393 <readline+0x69>
  10036b:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100372:	7f 1f                	jg     100393 <readline+0x69>
            cputchar(c);
  100374:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100377:	89 04 24             	mov    %eax,(%esp)
  10037a:	e8 2e ff ff ff       	call   1002ad <cputchar>
            buf[i ++] = c;
  10037f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100382:	8d 50 01             	lea    0x1(%eax),%edx
  100385:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100388:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10038b:	88 90 20 d0 11 00    	mov    %dl,0x11d020(%eax)
  100391:	eb 45                	jmp    1003d8 <readline+0xae>
        }
        else if (c == '\b' && i > 0) {
  100393:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  100397:	75 16                	jne    1003af <readline+0x85>
  100399:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10039d:	7e 10                	jle    1003af <readline+0x85>
            cputchar(c);
  10039f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003a2:	89 04 24             	mov    %eax,(%esp)
  1003a5:	e8 03 ff ff ff       	call   1002ad <cputchar>
            i --;
  1003aa:	ff 4d f4             	decl   -0xc(%ebp)
  1003ad:	eb 29                	jmp    1003d8 <readline+0xae>
        }
        else if (c == '\n' || c == '\r') {
  1003af:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1003b3:	74 06                	je     1003bb <readline+0x91>
  1003b5:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1003b9:	75 95                	jne    100350 <readline+0x26>
            cputchar(c);
  1003bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003be:	89 04 24             	mov    %eax,(%esp)
  1003c1:	e8 e7 fe ff ff       	call   1002ad <cputchar>
            buf[i] = '\0';
  1003c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003c9:	05 20 d0 11 00       	add    $0x11d020,%eax
  1003ce:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1003d1:	b8 20 d0 11 00       	mov    $0x11d020,%eax
  1003d6:	eb 05                	jmp    1003dd <readline+0xb3>
        c = getchar();
  1003d8:	e9 73 ff ff ff       	jmp    100350 <readline+0x26>
        }
    }
}
  1003dd:	c9                   	leave  
  1003de:	c3                   	ret    

001003df <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  1003df:	55                   	push   %ebp
  1003e0:	89 e5                	mov    %esp,%ebp
  1003e2:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  1003e5:	a1 20 d4 11 00       	mov    0x11d420,%eax
  1003ea:	85 c0                	test   %eax,%eax
  1003ec:	75 5b                	jne    100449 <__panic+0x6a>
        goto panic_dead;
    }
    is_panic = 1;
  1003ee:	c7 05 20 d4 11 00 01 	movl   $0x1,0x11d420
  1003f5:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  1003f8:	8d 45 14             	lea    0x14(%ebp),%eax
  1003fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  1003fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  100401:	89 44 24 08          	mov    %eax,0x8(%esp)
  100405:	8b 45 08             	mov    0x8(%ebp),%eax
  100408:	89 44 24 04          	mov    %eax,0x4(%esp)
  10040c:	c7 04 24 aa 68 10 00 	movl   $0x1068aa,(%esp)
  100413:	e8 6f fe ff ff       	call   100287 <cprintf>
    vcprintf(fmt, ap);
  100418:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10041b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10041f:	8b 45 10             	mov    0x10(%ebp),%eax
  100422:	89 04 24             	mov    %eax,(%esp)
  100425:	e8 2a fe ff ff       	call   100254 <vcprintf>
    cprintf("\n");
  10042a:	c7 04 24 c6 68 10 00 	movl   $0x1068c6,(%esp)
  100431:	e8 51 fe ff ff       	call   100287 <cprintf>
    
    cprintf("stack trackback:\n");
  100436:	c7 04 24 c8 68 10 00 	movl   $0x1068c8,(%esp)
  10043d:	e8 45 fe ff ff       	call   100287 <cprintf>
    print_stackframe();
  100442:	e8 21 06 00 00       	call   100a68 <print_stackframe>
  100447:	eb 01                	jmp    10044a <__panic+0x6b>
        goto panic_dead;
  100449:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
  10044a:	e8 23 14 00 00       	call   101872 <intr_disable>
    while (1) {
        kmonitor(NULL);
  10044f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100456:	e8 35 08 00 00       	call   100c90 <kmonitor>
  10045b:	eb f2                	jmp    10044f <__panic+0x70>

0010045d <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  10045d:	55                   	push   %ebp
  10045e:	89 e5                	mov    %esp,%ebp
  100460:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100463:	8d 45 14             	lea    0x14(%ebp),%eax
  100466:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100469:	8b 45 0c             	mov    0xc(%ebp),%eax
  10046c:	89 44 24 08          	mov    %eax,0x8(%esp)
  100470:	8b 45 08             	mov    0x8(%ebp),%eax
  100473:	89 44 24 04          	mov    %eax,0x4(%esp)
  100477:	c7 04 24 da 68 10 00 	movl   $0x1068da,(%esp)
  10047e:	e8 04 fe ff ff       	call   100287 <cprintf>
    vcprintf(fmt, ap);
  100483:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100486:	89 44 24 04          	mov    %eax,0x4(%esp)
  10048a:	8b 45 10             	mov    0x10(%ebp),%eax
  10048d:	89 04 24             	mov    %eax,(%esp)
  100490:	e8 bf fd ff ff       	call   100254 <vcprintf>
    cprintf("\n");
  100495:	c7 04 24 c6 68 10 00 	movl   $0x1068c6,(%esp)
  10049c:	e8 e6 fd ff ff       	call   100287 <cprintf>
    va_end(ap);
}
  1004a1:	90                   	nop
  1004a2:	c9                   	leave  
  1004a3:	c3                   	ret    

001004a4 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  1004a4:	55                   	push   %ebp
  1004a5:	89 e5                	mov    %esp,%ebp
    return is_panic;
  1004a7:	a1 20 d4 11 00       	mov    0x11d420,%eax
}
  1004ac:	5d                   	pop    %ebp
  1004ad:	c3                   	ret    

001004ae <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1004ae:	55                   	push   %ebp
  1004af:	89 e5                	mov    %esp,%ebp
  1004b1:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1004b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004b7:	8b 00                	mov    (%eax),%eax
  1004b9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1004bc:	8b 45 10             	mov    0x10(%ebp),%eax
  1004bf:	8b 00                	mov    (%eax),%eax
  1004c1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004c4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1004cb:	e9 ca 00 00 00       	jmp    10059a <stab_binsearch+0xec>
        int true_m = (l + r) / 2, m = true_m;
  1004d0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1004d6:	01 d0                	add    %edx,%eax
  1004d8:	89 c2                	mov    %eax,%edx
  1004da:	c1 ea 1f             	shr    $0x1f,%edx
  1004dd:	01 d0                	add    %edx,%eax
  1004df:	d1 f8                	sar    %eax
  1004e1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1004e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004e7:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1004ea:	eb 03                	jmp    1004ef <stab_binsearch+0x41>
            m --;
  1004ec:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  1004ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004f2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004f5:	7c 1f                	jl     100516 <stab_binsearch+0x68>
  1004f7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004fa:	89 d0                	mov    %edx,%eax
  1004fc:	01 c0                	add    %eax,%eax
  1004fe:	01 d0                	add    %edx,%eax
  100500:	c1 e0 02             	shl    $0x2,%eax
  100503:	89 c2                	mov    %eax,%edx
  100505:	8b 45 08             	mov    0x8(%ebp),%eax
  100508:	01 d0                	add    %edx,%eax
  10050a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10050e:	0f b6 c0             	movzbl %al,%eax
  100511:	39 45 14             	cmp    %eax,0x14(%ebp)
  100514:	75 d6                	jne    1004ec <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
  100516:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100519:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10051c:	7d 09                	jge    100527 <stab_binsearch+0x79>
            l = true_m + 1;
  10051e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100521:	40                   	inc    %eax
  100522:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100525:	eb 73                	jmp    10059a <stab_binsearch+0xec>
        }

        // actual binary search
        any_matches = 1;
  100527:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  10052e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100531:	89 d0                	mov    %edx,%eax
  100533:	01 c0                	add    %eax,%eax
  100535:	01 d0                	add    %edx,%eax
  100537:	c1 e0 02             	shl    $0x2,%eax
  10053a:	89 c2                	mov    %eax,%edx
  10053c:	8b 45 08             	mov    0x8(%ebp),%eax
  10053f:	01 d0                	add    %edx,%eax
  100541:	8b 40 08             	mov    0x8(%eax),%eax
  100544:	39 45 18             	cmp    %eax,0x18(%ebp)
  100547:	76 11                	jbe    10055a <stab_binsearch+0xac>
            *region_left = m;
  100549:	8b 45 0c             	mov    0xc(%ebp),%eax
  10054c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10054f:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100551:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100554:	40                   	inc    %eax
  100555:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100558:	eb 40                	jmp    10059a <stab_binsearch+0xec>
        } else if (stabs[m].n_value > addr) {
  10055a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10055d:	89 d0                	mov    %edx,%eax
  10055f:	01 c0                	add    %eax,%eax
  100561:	01 d0                	add    %edx,%eax
  100563:	c1 e0 02             	shl    $0x2,%eax
  100566:	89 c2                	mov    %eax,%edx
  100568:	8b 45 08             	mov    0x8(%ebp),%eax
  10056b:	01 d0                	add    %edx,%eax
  10056d:	8b 40 08             	mov    0x8(%eax),%eax
  100570:	39 45 18             	cmp    %eax,0x18(%ebp)
  100573:	73 14                	jae    100589 <stab_binsearch+0xdb>
            *region_right = m - 1;
  100575:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100578:	8d 50 ff             	lea    -0x1(%eax),%edx
  10057b:	8b 45 10             	mov    0x10(%ebp),%eax
  10057e:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  100580:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100583:	48                   	dec    %eax
  100584:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100587:	eb 11                	jmp    10059a <stab_binsearch+0xec>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  100589:	8b 45 0c             	mov    0xc(%ebp),%eax
  10058c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10058f:	89 10                	mov    %edx,(%eax)
            l = m;
  100591:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100594:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  100597:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
  10059a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10059d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1005a0:	0f 8e 2a ff ff ff    	jle    1004d0 <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
  1005a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1005aa:	75 0f                	jne    1005bb <stab_binsearch+0x10d>
        *region_right = *region_left - 1;
  1005ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005af:	8b 00                	mov    (%eax),%eax
  1005b1:	8d 50 ff             	lea    -0x1(%eax),%edx
  1005b4:	8b 45 10             	mov    0x10(%ebp),%eax
  1005b7:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  1005b9:	eb 3e                	jmp    1005f9 <stab_binsearch+0x14b>
        l = *region_right;
  1005bb:	8b 45 10             	mov    0x10(%ebp),%eax
  1005be:	8b 00                	mov    (%eax),%eax
  1005c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1005c3:	eb 03                	jmp    1005c8 <stab_binsearch+0x11a>
  1005c5:	ff 4d fc             	decl   -0x4(%ebp)
  1005c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005cb:	8b 00                	mov    (%eax),%eax
  1005cd:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  1005d0:	7e 1f                	jle    1005f1 <stab_binsearch+0x143>
  1005d2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005d5:	89 d0                	mov    %edx,%eax
  1005d7:	01 c0                	add    %eax,%eax
  1005d9:	01 d0                	add    %edx,%eax
  1005db:	c1 e0 02             	shl    $0x2,%eax
  1005de:	89 c2                	mov    %eax,%edx
  1005e0:	8b 45 08             	mov    0x8(%ebp),%eax
  1005e3:	01 d0                	add    %edx,%eax
  1005e5:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1005e9:	0f b6 c0             	movzbl %al,%eax
  1005ec:	39 45 14             	cmp    %eax,0x14(%ebp)
  1005ef:	75 d4                	jne    1005c5 <stab_binsearch+0x117>
        *region_left = l;
  1005f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005f4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005f7:	89 10                	mov    %edx,(%eax)
}
  1005f9:	90                   	nop
  1005fa:	c9                   	leave  
  1005fb:	c3                   	ret    

001005fc <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  1005fc:	55                   	push   %ebp
  1005fd:	89 e5                	mov    %esp,%ebp
  1005ff:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100602:	8b 45 0c             	mov    0xc(%ebp),%eax
  100605:	c7 00 f8 68 10 00    	movl   $0x1068f8,(%eax)
    info->eip_line = 0;
  10060b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10060e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100615:	8b 45 0c             	mov    0xc(%ebp),%eax
  100618:	c7 40 08 f8 68 10 00 	movl   $0x1068f8,0x8(%eax)
    info->eip_fn_namelen = 9;
  10061f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100622:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100629:	8b 45 0c             	mov    0xc(%ebp),%eax
  10062c:	8b 55 08             	mov    0x8(%ebp),%edx
  10062f:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100632:	8b 45 0c             	mov    0xc(%ebp),%eax
  100635:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  10063c:	c7 45 f4 dc 7c 10 00 	movl   $0x107cdc,-0xc(%ebp)
    stab_end = __STAB_END__;
  100643:	c7 45 f0 90 4c 11 00 	movl   $0x114c90,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  10064a:	c7 45 ec 91 4c 11 00 	movl   $0x114c91,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100651:	c7 45 e8 de 78 11 00 	movl   $0x1178de,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100658:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10065b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10065e:	76 0b                	jbe    10066b <debuginfo_eip+0x6f>
  100660:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100663:	48                   	dec    %eax
  100664:	0f b6 00             	movzbl (%eax),%eax
  100667:	84 c0                	test   %al,%al
  100669:	74 0a                	je     100675 <debuginfo_eip+0x79>
        return -1;
  10066b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100670:	e9 ab 02 00 00       	jmp    100920 <debuginfo_eip+0x324>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  100675:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  10067c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10067f:	2b 45 f4             	sub    -0xc(%ebp),%eax
  100682:	c1 f8 02             	sar    $0x2,%eax
  100685:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  10068b:	48                   	dec    %eax
  10068c:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  10068f:	8b 45 08             	mov    0x8(%ebp),%eax
  100692:	89 44 24 10          	mov    %eax,0x10(%esp)
  100696:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  10069d:	00 
  10069e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1006a1:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006a5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1006a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006af:	89 04 24             	mov    %eax,(%esp)
  1006b2:	e8 f7 fd ff ff       	call   1004ae <stab_binsearch>
    if (lfile == 0)
  1006b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006ba:	85 c0                	test   %eax,%eax
  1006bc:	75 0a                	jne    1006c8 <debuginfo_eip+0xcc>
        return -1;
  1006be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006c3:	e9 58 02 00 00       	jmp    100920 <debuginfo_eip+0x324>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1006c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006cb:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1006ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006d1:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1006d4:	8b 45 08             	mov    0x8(%ebp),%eax
  1006d7:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006db:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  1006e2:	00 
  1006e3:	8d 45 d8             	lea    -0x28(%ebp),%eax
  1006e6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006ea:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1006ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006f4:	89 04 24             	mov    %eax,(%esp)
  1006f7:	e8 b2 fd ff ff       	call   1004ae <stab_binsearch>

    if (lfun <= rfun) {
  1006fc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1006ff:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100702:	39 c2                	cmp    %eax,%edx
  100704:	7f 78                	jg     10077e <debuginfo_eip+0x182>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  100706:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100709:	89 c2                	mov    %eax,%edx
  10070b:	89 d0                	mov    %edx,%eax
  10070d:	01 c0                	add    %eax,%eax
  10070f:	01 d0                	add    %edx,%eax
  100711:	c1 e0 02             	shl    $0x2,%eax
  100714:	89 c2                	mov    %eax,%edx
  100716:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100719:	01 d0                	add    %edx,%eax
  10071b:	8b 10                	mov    (%eax),%edx
  10071d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100720:	2b 45 ec             	sub    -0x14(%ebp),%eax
  100723:	39 c2                	cmp    %eax,%edx
  100725:	73 22                	jae    100749 <debuginfo_eip+0x14d>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100727:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10072a:	89 c2                	mov    %eax,%edx
  10072c:	89 d0                	mov    %edx,%eax
  10072e:	01 c0                	add    %eax,%eax
  100730:	01 d0                	add    %edx,%eax
  100732:	c1 e0 02             	shl    $0x2,%eax
  100735:	89 c2                	mov    %eax,%edx
  100737:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10073a:	01 d0                	add    %edx,%eax
  10073c:	8b 10                	mov    (%eax),%edx
  10073e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100741:	01 c2                	add    %eax,%edx
  100743:	8b 45 0c             	mov    0xc(%ebp),%eax
  100746:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100749:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10074c:	89 c2                	mov    %eax,%edx
  10074e:	89 d0                	mov    %edx,%eax
  100750:	01 c0                	add    %eax,%eax
  100752:	01 d0                	add    %edx,%eax
  100754:	c1 e0 02             	shl    $0x2,%eax
  100757:	89 c2                	mov    %eax,%edx
  100759:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10075c:	01 d0                	add    %edx,%eax
  10075e:	8b 50 08             	mov    0x8(%eax),%edx
  100761:	8b 45 0c             	mov    0xc(%ebp),%eax
  100764:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  100767:	8b 45 0c             	mov    0xc(%ebp),%eax
  10076a:	8b 40 10             	mov    0x10(%eax),%eax
  10076d:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  100770:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100773:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  100776:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100779:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10077c:	eb 15                	jmp    100793 <debuginfo_eip+0x197>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  10077e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100781:	8b 55 08             	mov    0x8(%ebp),%edx
  100784:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  100787:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10078a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  10078d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100790:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  100793:	8b 45 0c             	mov    0xc(%ebp),%eax
  100796:	8b 40 08             	mov    0x8(%eax),%eax
  100799:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1007a0:	00 
  1007a1:	89 04 24             	mov    %eax,(%esp)
  1007a4:	e8 dc 56 00 00       	call   105e85 <strfind>
  1007a9:	89 c2                	mov    %eax,%edx
  1007ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007ae:	8b 40 08             	mov    0x8(%eax),%eax
  1007b1:	29 c2                	sub    %eax,%edx
  1007b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007b6:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1007b9:	8b 45 08             	mov    0x8(%ebp),%eax
  1007bc:	89 44 24 10          	mov    %eax,0x10(%esp)
  1007c0:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1007c7:	00 
  1007c8:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1007cb:	89 44 24 08          	mov    %eax,0x8(%esp)
  1007cf:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1007d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1007d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007d9:	89 04 24             	mov    %eax,(%esp)
  1007dc:	e8 cd fc ff ff       	call   1004ae <stab_binsearch>
    if (lline <= rline) {
  1007e1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007e4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007e7:	39 c2                	cmp    %eax,%edx
  1007e9:	7f 23                	jg     10080e <debuginfo_eip+0x212>
        info->eip_line = stabs[rline].n_desc;
  1007eb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007ee:	89 c2                	mov    %eax,%edx
  1007f0:	89 d0                	mov    %edx,%eax
  1007f2:	01 c0                	add    %eax,%eax
  1007f4:	01 d0                	add    %edx,%eax
  1007f6:	c1 e0 02             	shl    $0x2,%eax
  1007f9:	89 c2                	mov    %eax,%edx
  1007fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007fe:	01 d0                	add    %edx,%eax
  100800:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100804:	89 c2                	mov    %eax,%edx
  100806:	8b 45 0c             	mov    0xc(%ebp),%eax
  100809:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  10080c:	eb 11                	jmp    10081f <debuginfo_eip+0x223>
        return -1;
  10080e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100813:	e9 08 01 00 00       	jmp    100920 <debuginfo_eip+0x324>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100818:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10081b:	48                   	dec    %eax
  10081c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  10081f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100822:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100825:	39 c2                	cmp    %eax,%edx
  100827:	7c 56                	jl     10087f <debuginfo_eip+0x283>
           && stabs[lline].n_type != N_SOL
  100829:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10082c:	89 c2                	mov    %eax,%edx
  10082e:	89 d0                	mov    %edx,%eax
  100830:	01 c0                	add    %eax,%eax
  100832:	01 d0                	add    %edx,%eax
  100834:	c1 e0 02             	shl    $0x2,%eax
  100837:	89 c2                	mov    %eax,%edx
  100839:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10083c:	01 d0                	add    %edx,%eax
  10083e:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100842:	3c 84                	cmp    $0x84,%al
  100844:	74 39                	je     10087f <debuginfo_eip+0x283>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100846:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100849:	89 c2                	mov    %eax,%edx
  10084b:	89 d0                	mov    %edx,%eax
  10084d:	01 c0                	add    %eax,%eax
  10084f:	01 d0                	add    %edx,%eax
  100851:	c1 e0 02             	shl    $0x2,%eax
  100854:	89 c2                	mov    %eax,%edx
  100856:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100859:	01 d0                	add    %edx,%eax
  10085b:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10085f:	3c 64                	cmp    $0x64,%al
  100861:	75 b5                	jne    100818 <debuginfo_eip+0x21c>
  100863:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100866:	89 c2                	mov    %eax,%edx
  100868:	89 d0                	mov    %edx,%eax
  10086a:	01 c0                	add    %eax,%eax
  10086c:	01 d0                	add    %edx,%eax
  10086e:	c1 e0 02             	shl    $0x2,%eax
  100871:	89 c2                	mov    %eax,%edx
  100873:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100876:	01 d0                	add    %edx,%eax
  100878:	8b 40 08             	mov    0x8(%eax),%eax
  10087b:	85 c0                	test   %eax,%eax
  10087d:	74 99                	je     100818 <debuginfo_eip+0x21c>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  10087f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100882:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100885:	39 c2                	cmp    %eax,%edx
  100887:	7c 42                	jl     1008cb <debuginfo_eip+0x2cf>
  100889:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10088c:	89 c2                	mov    %eax,%edx
  10088e:	89 d0                	mov    %edx,%eax
  100890:	01 c0                	add    %eax,%eax
  100892:	01 d0                	add    %edx,%eax
  100894:	c1 e0 02             	shl    $0x2,%eax
  100897:	89 c2                	mov    %eax,%edx
  100899:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10089c:	01 d0                	add    %edx,%eax
  10089e:	8b 10                	mov    (%eax),%edx
  1008a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1008a3:	2b 45 ec             	sub    -0x14(%ebp),%eax
  1008a6:	39 c2                	cmp    %eax,%edx
  1008a8:	73 21                	jae    1008cb <debuginfo_eip+0x2cf>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1008aa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008ad:	89 c2                	mov    %eax,%edx
  1008af:	89 d0                	mov    %edx,%eax
  1008b1:	01 c0                	add    %eax,%eax
  1008b3:	01 d0                	add    %edx,%eax
  1008b5:	c1 e0 02             	shl    $0x2,%eax
  1008b8:	89 c2                	mov    %eax,%edx
  1008ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008bd:	01 d0                	add    %edx,%eax
  1008bf:	8b 10                	mov    (%eax),%edx
  1008c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1008c4:	01 c2                	add    %eax,%edx
  1008c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008c9:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1008cb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1008ce:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1008d1:	39 c2                	cmp    %eax,%edx
  1008d3:	7d 46                	jge    10091b <debuginfo_eip+0x31f>
        for (lline = lfun + 1;
  1008d5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1008d8:	40                   	inc    %eax
  1008d9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1008dc:	eb 16                	jmp    1008f4 <debuginfo_eip+0x2f8>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  1008de:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008e1:	8b 40 14             	mov    0x14(%eax),%eax
  1008e4:	8d 50 01             	lea    0x1(%eax),%edx
  1008e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008ea:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  1008ed:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008f0:	40                   	inc    %eax
  1008f1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008f4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1008f7:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
  1008fa:	39 c2                	cmp    %eax,%edx
  1008fc:	7d 1d                	jge    10091b <debuginfo_eip+0x31f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008fe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100901:	89 c2                	mov    %eax,%edx
  100903:	89 d0                	mov    %edx,%eax
  100905:	01 c0                	add    %eax,%eax
  100907:	01 d0                	add    %edx,%eax
  100909:	c1 e0 02             	shl    $0x2,%eax
  10090c:	89 c2                	mov    %eax,%edx
  10090e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100911:	01 d0                	add    %edx,%eax
  100913:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100917:	3c a0                	cmp    $0xa0,%al
  100919:	74 c3                	je     1008de <debuginfo_eip+0x2e2>
        }
    }
    return 0;
  10091b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100920:	c9                   	leave  
  100921:	c3                   	ret    

00100922 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100922:	55                   	push   %ebp
  100923:	89 e5                	mov    %esp,%ebp
  100925:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100928:	c7 04 24 02 69 10 00 	movl   $0x106902,(%esp)
  10092f:	e8 53 f9 ff ff       	call   100287 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100934:	c7 44 24 04 2f 00 10 	movl   $0x10002f,0x4(%esp)
  10093b:	00 
  10093c:	c7 04 24 1b 69 10 00 	movl   $0x10691b,(%esp)
  100943:	e8 3f f9 ff ff       	call   100287 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  100948:	c7 44 24 04 fe 67 10 	movl   $0x1067fe,0x4(%esp)
  10094f:	00 
  100950:	c7 04 24 33 69 10 00 	movl   $0x106933,(%esp)
  100957:	e8 2b f9 ff ff       	call   100287 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  10095c:	c7 44 24 04 00 d0 11 	movl   $0x11d000,0x4(%esp)
  100963:	00 
  100964:	c7 04 24 4b 69 10 00 	movl   $0x10694b,(%esp)
  10096b:	e8 17 f9 ff ff       	call   100287 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  100970:	c7 44 24 04 48 df 11 	movl   $0x11df48,0x4(%esp)
  100977:	00 
  100978:	c7 04 24 63 69 10 00 	movl   $0x106963,(%esp)
  10097f:	e8 03 f9 ff ff       	call   100287 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  100984:	b8 48 df 11 00       	mov    $0x11df48,%eax
  100989:	2d 2f 00 10 00       	sub    $0x10002f,%eax
  10098e:	05 ff 03 00 00       	add    $0x3ff,%eax
  100993:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  100999:	85 c0                	test   %eax,%eax
  10099b:	0f 48 c2             	cmovs  %edx,%eax
  10099e:	c1 f8 0a             	sar    $0xa,%eax
  1009a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009a5:	c7 04 24 7c 69 10 00 	movl   $0x10697c,(%esp)
  1009ac:	e8 d6 f8 ff ff       	call   100287 <cprintf>
}
  1009b1:	90                   	nop
  1009b2:	c9                   	leave  
  1009b3:	c3                   	ret    

001009b4 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1009b4:	55                   	push   %ebp
  1009b5:	89 e5                	mov    %esp,%ebp
  1009b7:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1009bd:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1009c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009c4:	8b 45 08             	mov    0x8(%ebp),%eax
  1009c7:	89 04 24             	mov    %eax,(%esp)
  1009ca:	e8 2d fc ff ff       	call   1005fc <debuginfo_eip>
  1009cf:	85 c0                	test   %eax,%eax
  1009d1:	74 15                	je     1009e8 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  1009d3:	8b 45 08             	mov    0x8(%ebp),%eax
  1009d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009da:	c7 04 24 a6 69 10 00 	movl   $0x1069a6,(%esp)
  1009e1:	e8 a1 f8 ff ff       	call   100287 <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  1009e6:	eb 6c                	jmp    100a54 <print_debuginfo+0xa0>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009e8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1009ef:	eb 1b                	jmp    100a0c <print_debuginfo+0x58>
            fnname[j] = info.eip_fn_name[j];
  1009f1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1009f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009f7:	01 d0                	add    %edx,%eax
  1009f9:	0f b6 10             	movzbl (%eax),%edx
  1009fc:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a05:	01 c8                	add    %ecx,%eax
  100a07:	88 10                	mov    %dl,(%eax)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a09:	ff 45 f4             	incl   -0xc(%ebp)
  100a0c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a0f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  100a12:	7c dd                	jl     1009f1 <print_debuginfo+0x3d>
        fnname[j] = '\0';
  100a14:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100a1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a1d:	01 d0                	add    %edx,%eax
  100a1f:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
  100a22:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100a25:	8b 55 08             	mov    0x8(%ebp),%edx
  100a28:	89 d1                	mov    %edx,%ecx
  100a2a:	29 c1                	sub    %eax,%ecx
  100a2c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100a2f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100a32:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100a36:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a3c:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100a40:	89 54 24 08          	mov    %edx,0x8(%esp)
  100a44:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a48:	c7 04 24 c2 69 10 00 	movl   $0x1069c2,(%esp)
  100a4f:	e8 33 f8 ff ff       	call   100287 <cprintf>
}
  100a54:	90                   	nop
  100a55:	c9                   	leave  
  100a56:	c3                   	ret    

00100a57 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100a57:	55                   	push   %ebp
  100a58:	89 e5                	mov    %esp,%ebp
  100a5a:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100a5d:	8b 45 04             	mov    0x4(%ebp),%eax
  100a60:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100a63:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100a66:	c9                   	leave  
  100a67:	c3                   	ret    

00100a68 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100a68:	55                   	push   %ebp
  100a69:	89 e5                	mov    %esp,%ebp
  100a6b:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100a6e:	89 e8                	mov    %ebp,%eax
  100a70:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  100a73:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();
  100a76:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100a79:	e8 d9 ff ff ff       	call   100a57 <read_eip>
  100a7e:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
  100a81:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100a88:	e9 84 00 00 00       	jmp    100b11 <print_stackframe+0xa9>
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
  100a8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a90:	89 44 24 08          	mov    %eax,0x8(%esp)
  100a94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a97:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a9b:	c7 04 24 d4 69 10 00 	movl   $0x1069d4,(%esp)
  100aa2:	e8 e0 f7 ff ff       	call   100287 <cprintf>
        uint32_t *args = (uint32_t *)ebp + 2;
  100aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100aaa:	83 c0 08             	add    $0x8,%eax
  100aad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (j = 0; j < 4; j ++) {
  100ab0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100ab7:	eb 24                	jmp    100add <print_stackframe+0x75>
            cprintf("0x%08x ", args[j]);
  100ab9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100abc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100ac3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100ac6:	01 d0                	add    %edx,%eax
  100ac8:	8b 00                	mov    (%eax),%eax
  100aca:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ace:	c7 04 24 f0 69 10 00 	movl   $0x1069f0,(%esp)
  100ad5:	e8 ad f7 ff ff       	call   100287 <cprintf>
        for (j = 0; j < 4; j ++) {
  100ada:	ff 45 e8             	incl   -0x18(%ebp)
  100add:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100ae1:	7e d6                	jle    100ab9 <print_stackframe+0x51>
        }
        cprintf("\n");
  100ae3:	c7 04 24 f8 69 10 00 	movl   $0x1069f8,(%esp)
  100aea:	e8 98 f7 ff ff       	call   100287 <cprintf>
        print_debuginfo(eip - 1);
  100aef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100af2:	48                   	dec    %eax
  100af3:	89 04 24             	mov    %eax,(%esp)
  100af6:	e8 b9 fe ff ff       	call   1009b4 <print_debuginfo>
        eip = ((uint32_t *)ebp)[1];
  100afb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100afe:	83 c0 04             	add    $0x4,%eax
  100b01:	8b 00                	mov    (%eax),%eax
  100b03:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
  100b06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b09:	8b 00                	mov    (%eax),%eax
  100b0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
  100b0e:	ff 45 ec             	incl   -0x14(%ebp)
  100b11:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100b15:	74 0a                	je     100b21 <print_stackframe+0xb9>
  100b17:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100b1b:	0f 8e 6c ff ff ff    	jle    100a8d <print_stackframe+0x25>
    }
}
  100b21:	90                   	nop
  100b22:	c9                   	leave  
  100b23:	c3                   	ret    

00100b24 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100b24:	55                   	push   %ebp
  100b25:	89 e5                	mov    %esp,%ebp
  100b27:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100b2a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b31:	eb 0c                	jmp    100b3f <parse+0x1b>
            *buf ++ = '\0';
  100b33:	8b 45 08             	mov    0x8(%ebp),%eax
  100b36:	8d 50 01             	lea    0x1(%eax),%edx
  100b39:	89 55 08             	mov    %edx,0x8(%ebp)
  100b3c:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  100b42:	0f b6 00             	movzbl (%eax),%eax
  100b45:	84 c0                	test   %al,%al
  100b47:	74 1d                	je     100b66 <parse+0x42>
  100b49:	8b 45 08             	mov    0x8(%ebp),%eax
  100b4c:	0f b6 00             	movzbl (%eax),%eax
  100b4f:	0f be c0             	movsbl %al,%eax
  100b52:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b56:	c7 04 24 7c 6a 10 00 	movl   $0x106a7c,(%esp)
  100b5d:	e8 f1 52 00 00       	call   105e53 <strchr>
  100b62:	85 c0                	test   %eax,%eax
  100b64:	75 cd                	jne    100b33 <parse+0xf>
        }
        if (*buf == '\0') {
  100b66:	8b 45 08             	mov    0x8(%ebp),%eax
  100b69:	0f b6 00             	movzbl (%eax),%eax
  100b6c:	84 c0                	test   %al,%al
  100b6e:	74 65                	je     100bd5 <parse+0xb1>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100b70:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100b74:	75 14                	jne    100b8a <parse+0x66>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100b76:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100b7d:	00 
  100b7e:	c7 04 24 81 6a 10 00 	movl   $0x106a81,(%esp)
  100b85:	e8 fd f6 ff ff       	call   100287 <cprintf>
        }
        argv[argc ++] = buf;
  100b8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b8d:	8d 50 01             	lea    0x1(%eax),%edx
  100b90:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100b93:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100b9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  100b9d:	01 c2                	add    %eax,%edx
  100b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  100ba2:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100ba4:	eb 03                	jmp    100ba9 <parse+0x85>
            buf ++;
  100ba6:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  100bac:	0f b6 00             	movzbl (%eax),%eax
  100baf:	84 c0                	test   %al,%al
  100bb1:	74 8c                	je     100b3f <parse+0x1b>
  100bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  100bb6:	0f b6 00             	movzbl (%eax),%eax
  100bb9:	0f be c0             	movsbl %al,%eax
  100bbc:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bc0:	c7 04 24 7c 6a 10 00 	movl   $0x106a7c,(%esp)
  100bc7:	e8 87 52 00 00       	call   105e53 <strchr>
  100bcc:	85 c0                	test   %eax,%eax
  100bce:	74 d6                	je     100ba6 <parse+0x82>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100bd0:	e9 6a ff ff ff       	jmp    100b3f <parse+0x1b>
            break;
  100bd5:	90                   	nop
        }
    }
    return argc;
  100bd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100bd9:	c9                   	leave  
  100bda:	c3                   	ret    

00100bdb <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100bdb:	55                   	push   %ebp
  100bdc:	89 e5                	mov    %esp,%ebp
  100bde:	53                   	push   %ebx
  100bdf:	83 ec 64             	sub    $0x64,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100be2:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100be5:	89 44 24 04          	mov    %eax,0x4(%esp)
  100be9:	8b 45 08             	mov    0x8(%ebp),%eax
  100bec:	89 04 24             	mov    %eax,(%esp)
  100bef:	e8 30 ff ff ff       	call   100b24 <parse>
  100bf4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100bf7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100bfb:	75 0a                	jne    100c07 <runcmd+0x2c>
        return 0;
  100bfd:	b8 00 00 00 00       	mov    $0x0,%eax
  100c02:	e9 83 00 00 00       	jmp    100c8a <runcmd+0xaf>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c07:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c0e:	eb 5a                	jmp    100c6a <runcmd+0x8f>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100c10:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100c13:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c16:	89 d0                	mov    %edx,%eax
  100c18:	01 c0                	add    %eax,%eax
  100c1a:	01 d0                	add    %edx,%eax
  100c1c:	c1 e0 02             	shl    $0x2,%eax
  100c1f:	05 00 a0 11 00       	add    $0x11a000,%eax
  100c24:	8b 00                	mov    (%eax),%eax
  100c26:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100c2a:	89 04 24             	mov    %eax,(%esp)
  100c2d:	e8 84 51 00 00       	call   105db6 <strcmp>
  100c32:	85 c0                	test   %eax,%eax
  100c34:	75 31                	jne    100c67 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100c36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c39:	89 d0                	mov    %edx,%eax
  100c3b:	01 c0                	add    %eax,%eax
  100c3d:	01 d0                	add    %edx,%eax
  100c3f:	c1 e0 02             	shl    $0x2,%eax
  100c42:	05 08 a0 11 00       	add    $0x11a008,%eax
  100c47:	8b 10                	mov    (%eax),%edx
  100c49:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c4c:	83 c0 04             	add    $0x4,%eax
  100c4f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100c52:	8d 59 ff             	lea    -0x1(%ecx),%ebx
  100c55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100c58:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c5c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c60:	89 1c 24             	mov    %ebx,(%esp)
  100c63:	ff d2                	call   *%edx
  100c65:	eb 23                	jmp    100c8a <runcmd+0xaf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100c67:	ff 45 f4             	incl   -0xc(%ebp)
  100c6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c6d:	83 f8 02             	cmp    $0x2,%eax
  100c70:	76 9e                	jbe    100c10 <runcmd+0x35>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100c72:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100c75:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c79:	c7 04 24 9f 6a 10 00 	movl   $0x106a9f,(%esp)
  100c80:	e8 02 f6 ff ff       	call   100287 <cprintf>
    return 0;
  100c85:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c8a:	83 c4 64             	add    $0x64,%esp
  100c8d:	5b                   	pop    %ebx
  100c8e:	5d                   	pop    %ebp
  100c8f:	c3                   	ret    

00100c90 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100c90:	55                   	push   %ebp
  100c91:	89 e5                	mov    %esp,%ebp
  100c93:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100c96:	c7 04 24 b8 6a 10 00 	movl   $0x106ab8,(%esp)
  100c9d:	e8 e5 f5 ff ff       	call   100287 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100ca2:	c7 04 24 e0 6a 10 00 	movl   $0x106ae0,(%esp)
  100ca9:	e8 d9 f5 ff ff       	call   100287 <cprintf>

    if (tf != NULL) {
  100cae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100cb2:	74 0b                	je     100cbf <kmonitor+0x2f>
        print_trapframe(tf);
  100cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  100cb7:	89 04 24             	mov    %eax,(%esp)
  100cba:	e8 b2 0e 00 00       	call   101b71 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100cbf:	c7 04 24 05 6b 10 00 	movl   $0x106b05,(%esp)
  100cc6:	e8 5f f6 ff ff       	call   10032a <readline>
  100ccb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100cce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100cd2:	74 eb                	je     100cbf <kmonitor+0x2f>
            if (runcmd(buf, tf) < 0) {
  100cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  100cd7:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cde:	89 04 24             	mov    %eax,(%esp)
  100ce1:	e8 f5 fe ff ff       	call   100bdb <runcmd>
  100ce6:	85 c0                	test   %eax,%eax
  100ce8:	78 02                	js     100cec <kmonitor+0x5c>
        if ((buf = readline("K> ")) != NULL) {
  100cea:	eb d3                	jmp    100cbf <kmonitor+0x2f>
                break;
  100cec:	90                   	nop
            }
        }
    }
}
  100ced:	90                   	nop
  100cee:	c9                   	leave  
  100cef:	c3                   	ret    

00100cf0 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100cf0:	55                   	push   %ebp
  100cf1:	89 e5                	mov    %esp,%ebp
  100cf3:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100cf6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100cfd:	eb 3d                	jmp    100d3c <mon_help+0x4c>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100cff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d02:	89 d0                	mov    %edx,%eax
  100d04:	01 c0                	add    %eax,%eax
  100d06:	01 d0                	add    %edx,%eax
  100d08:	c1 e0 02             	shl    $0x2,%eax
  100d0b:	05 04 a0 11 00       	add    $0x11a004,%eax
  100d10:	8b 08                	mov    (%eax),%ecx
  100d12:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d15:	89 d0                	mov    %edx,%eax
  100d17:	01 c0                	add    %eax,%eax
  100d19:	01 d0                	add    %edx,%eax
  100d1b:	c1 e0 02             	shl    $0x2,%eax
  100d1e:	05 00 a0 11 00       	add    $0x11a000,%eax
  100d23:	8b 00                	mov    (%eax),%eax
  100d25:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100d29:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d2d:	c7 04 24 09 6b 10 00 	movl   $0x106b09,(%esp)
  100d34:	e8 4e f5 ff ff       	call   100287 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100d39:	ff 45 f4             	incl   -0xc(%ebp)
  100d3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d3f:	83 f8 02             	cmp    $0x2,%eax
  100d42:	76 bb                	jbe    100cff <mon_help+0xf>
    }
    return 0;
  100d44:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d49:	c9                   	leave  
  100d4a:	c3                   	ret    

00100d4b <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100d4b:	55                   	push   %ebp
  100d4c:	89 e5                	mov    %esp,%ebp
  100d4e:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100d51:	e8 cc fb ff ff       	call   100922 <print_kerninfo>
    return 0;
  100d56:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d5b:	c9                   	leave  
  100d5c:	c3                   	ret    

00100d5d <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100d5d:	55                   	push   %ebp
  100d5e:	89 e5                	mov    %esp,%ebp
  100d60:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100d63:	e8 00 fd ff ff       	call   100a68 <print_stackframe>
    return 0;
  100d68:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d6d:	c9                   	leave  
  100d6e:	c3                   	ret    

00100d6f <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d6f:	55                   	push   %ebp
  100d70:	89 e5                	mov    %esp,%ebp
  100d72:	83 ec 28             	sub    $0x28,%esp
  100d75:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100d7b:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100d7f:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100d83:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100d87:	ee                   	out    %al,(%dx)
  100d88:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d8e:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100d92:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100d96:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100d9a:	ee                   	out    %al,(%dx)
  100d9b:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100da1:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
  100da5:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100da9:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100dad:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100dae:	c7 05 2c df 11 00 00 	movl   $0x0,0x11df2c
  100db5:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100db8:	c7 04 24 12 6b 10 00 	movl   $0x106b12,(%esp)
  100dbf:	e8 c3 f4 ff ff       	call   100287 <cprintf>
    pic_enable(IRQ_TIMER);
  100dc4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100dcb:	e8 2e 09 00 00       	call   1016fe <pic_enable>
}
  100dd0:	90                   	nop
  100dd1:	c9                   	leave  
  100dd2:	c3                   	ret    

00100dd3 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100dd3:	55                   	push   %ebp
  100dd4:	89 e5                	mov    %esp,%ebp
  100dd6:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100dd9:	9c                   	pushf  
  100dda:	58                   	pop    %eax
  100ddb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100dde:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100de1:	25 00 02 00 00       	and    $0x200,%eax
  100de6:	85 c0                	test   %eax,%eax
  100de8:	74 0c                	je     100df6 <__intr_save+0x23>
        intr_disable();
  100dea:	e8 83 0a 00 00       	call   101872 <intr_disable>
        return 1;
  100def:	b8 01 00 00 00       	mov    $0x1,%eax
  100df4:	eb 05                	jmp    100dfb <__intr_save+0x28>
    }
    return 0;
  100df6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100dfb:	c9                   	leave  
  100dfc:	c3                   	ret    

00100dfd <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100dfd:	55                   	push   %ebp
  100dfe:	89 e5                	mov    %esp,%ebp
  100e00:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100e03:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100e07:	74 05                	je     100e0e <__intr_restore+0x11>
        intr_enable();
  100e09:	e8 5d 0a 00 00       	call   10186b <intr_enable>
    }
}
  100e0e:	90                   	nop
  100e0f:	c9                   	leave  
  100e10:	c3                   	ret    

00100e11 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e11:	55                   	push   %ebp
  100e12:	89 e5                	mov    %esp,%ebp
  100e14:	83 ec 10             	sub    $0x10,%esp
  100e17:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e1d:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e21:	89 c2                	mov    %eax,%edx
  100e23:	ec                   	in     (%dx),%al
  100e24:	88 45 f1             	mov    %al,-0xf(%ebp)
  100e27:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e2d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e31:	89 c2                	mov    %eax,%edx
  100e33:	ec                   	in     (%dx),%al
  100e34:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e37:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e3d:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e41:	89 c2                	mov    %eax,%edx
  100e43:	ec                   	in     (%dx),%al
  100e44:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e47:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  100e4d:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e51:	89 c2                	mov    %eax,%edx
  100e53:	ec                   	in     (%dx),%al
  100e54:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e57:	90                   	nop
  100e58:	c9                   	leave  
  100e59:	c3                   	ret    

00100e5a <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100e5a:	55                   	push   %ebp
  100e5b:	89 e5                	mov    %esp,%ebp
  100e5d:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100e60:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;
  100e67:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e6a:	0f b7 00             	movzwl (%eax),%eax
  100e6d:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100e71:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e74:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100e79:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e7c:	0f b7 00             	movzwl (%eax),%eax
  100e7f:	0f b7 c0             	movzwl %ax,%eax
  100e82:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
  100e87:	74 12                	je     100e9b <cga_init+0x41>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100e89:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100e90:	66 c7 05 46 d4 11 00 	movw   $0x3b4,0x11d446
  100e97:	b4 03 
  100e99:	eb 13                	jmp    100eae <cga_init+0x54>
    } else {
        *cp = was;
  100e9b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e9e:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100ea2:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100ea5:	66 c7 05 46 d4 11 00 	movw   $0x3d4,0x11d446
  100eac:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100eae:	0f b7 05 46 d4 11 00 	movzwl 0x11d446,%eax
  100eb5:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100eb9:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ebd:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100ec1:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100ec5:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100ec6:	0f b7 05 46 d4 11 00 	movzwl 0x11d446,%eax
  100ecd:	40                   	inc    %eax
  100ece:	0f b7 c0             	movzwl %ax,%eax
  100ed1:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100ed5:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
  100ed9:	89 c2                	mov    %eax,%edx
  100edb:	ec                   	in     (%dx),%al
  100edc:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  100edf:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100ee3:	0f b6 c0             	movzbl %al,%eax
  100ee6:	c1 e0 08             	shl    $0x8,%eax
  100ee9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100eec:	0f b7 05 46 d4 11 00 	movzwl 0x11d446,%eax
  100ef3:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100ef7:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100efb:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100eff:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f03:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100f04:	0f b7 05 46 d4 11 00 	movzwl 0x11d446,%eax
  100f0b:	40                   	inc    %eax
  100f0c:	0f b7 c0             	movzwl %ax,%eax
  100f0f:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f13:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100f17:	89 c2                	mov    %eax,%edx
  100f19:	ec                   	in     (%dx),%al
  100f1a:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  100f1d:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f21:	0f b6 c0             	movzbl %al,%eax
  100f24:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100f27:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f2a:	a3 40 d4 11 00       	mov    %eax,0x11d440
    crt_pos = pos;
  100f2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f32:	0f b7 c0             	movzwl %ax,%eax
  100f35:	66 a3 44 d4 11 00    	mov    %ax,0x11d444
}
  100f3b:	90                   	nop
  100f3c:	c9                   	leave  
  100f3d:	c3                   	ret    

00100f3e <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f3e:	55                   	push   %ebp
  100f3f:	89 e5                	mov    %esp,%ebp
  100f41:	83 ec 48             	sub    $0x48,%esp
  100f44:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  100f4a:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f4e:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  100f52:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  100f56:	ee                   	out    %al,(%dx)
  100f57:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  100f5d:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
  100f61:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  100f65:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  100f69:	ee                   	out    %al,(%dx)
  100f6a:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  100f70:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
  100f74:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  100f78:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  100f7c:	ee                   	out    %al,(%dx)
  100f7d:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100f83:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
  100f87:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f8b:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100f8f:	ee                   	out    %al,(%dx)
  100f90:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  100f96:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
  100f9a:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100f9e:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100fa2:	ee                   	out    %al,(%dx)
  100fa3:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  100fa9:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
  100fad:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100fb1:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100fb5:	ee                   	out    %al,(%dx)
  100fb6:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100fbc:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
  100fc0:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100fc4:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100fc8:	ee                   	out    %al,(%dx)
  100fc9:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100fcf:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100fd3:	89 c2                	mov    %eax,%edx
  100fd5:	ec                   	in     (%dx),%al
  100fd6:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100fd9:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100fdd:	3c ff                	cmp    $0xff,%al
  100fdf:	0f 95 c0             	setne  %al
  100fe2:	0f b6 c0             	movzbl %al,%eax
  100fe5:	a3 48 d4 11 00       	mov    %eax,0x11d448
  100fea:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100ff0:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100ff4:	89 c2                	mov    %eax,%edx
  100ff6:	ec                   	in     (%dx),%al
  100ff7:	88 45 f1             	mov    %al,-0xf(%ebp)
  100ffa:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101000:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101004:	89 c2                	mov    %eax,%edx
  101006:	ec                   	in     (%dx),%al
  101007:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  10100a:	a1 48 d4 11 00       	mov    0x11d448,%eax
  10100f:	85 c0                	test   %eax,%eax
  101011:	74 0c                	je     10101f <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  101013:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  10101a:	e8 df 06 00 00       	call   1016fe <pic_enable>
    }
}
  10101f:	90                   	nop
  101020:	c9                   	leave  
  101021:	c3                   	ret    

00101022 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  101022:	55                   	push   %ebp
  101023:	89 e5                	mov    %esp,%ebp
  101025:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101028:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10102f:	eb 08                	jmp    101039 <lpt_putc_sub+0x17>
        delay();
  101031:	e8 db fd ff ff       	call   100e11 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101036:	ff 45 fc             	incl   -0x4(%ebp)
  101039:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  10103f:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101043:	89 c2                	mov    %eax,%edx
  101045:	ec                   	in     (%dx),%al
  101046:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101049:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10104d:	84 c0                	test   %al,%al
  10104f:	78 09                	js     10105a <lpt_putc_sub+0x38>
  101051:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101058:	7e d7                	jle    101031 <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
  10105a:	8b 45 08             	mov    0x8(%ebp),%eax
  10105d:	0f b6 c0             	movzbl %al,%eax
  101060:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  101066:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101069:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10106d:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101071:	ee                   	out    %al,(%dx)
  101072:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  101078:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  10107c:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101080:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101084:	ee                   	out    %al,(%dx)
  101085:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  10108b:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
  10108f:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101093:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101097:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101098:	90                   	nop
  101099:	c9                   	leave  
  10109a:	c3                   	ret    

0010109b <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  10109b:	55                   	push   %ebp
  10109c:	89 e5                	mov    %esp,%ebp
  10109e:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1010a1:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1010a5:	74 0d                	je     1010b4 <lpt_putc+0x19>
        lpt_putc_sub(c);
  1010a7:	8b 45 08             	mov    0x8(%ebp),%eax
  1010aa:	89 04 24             	mov    %eax,(%esp)
  1010ad:	e8 70 ff ff ff       	call   101022 <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  1010b2:	eb 24                	jmp    1010d8 <lpt_putc+0x3d>
        lpt_putc_sub('\b');
  1010b4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010bb:	e8 62 ff ff ff       	call   101022 <lpt_putc_sub>
        lpt_putc_sub(' ');
  1010c0:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1010c7:	e8 56 ff ff ff       	call   101022 <lpt_putc_sub>
        lpt_putc_sub('\b');
  1010cc:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010d3:	e8 4a ff ff ff       	call   101022 <lpt_putc_sub>
}
  1010d8:	90                   	nop
  1010d9:	c9                   	leave  
  1010da:	c3                   	ret    

001010db <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  1010db:	55                   	push   %ebp
  1010dc:	89 e5                	mov    %esp,%ebp
  1010de:	53                   	push   %ebx
  1010df:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  1010e2:	8b 45 08             	mov    0x8(%ebp),%eax
  1010e5:	25 00 ff ff ff       	and    $0xffffff00,%eax
  1010ea:	85 c0                	test   %eax,%eax
  1010ec:	75 07                	jne    1010f5 <cga_putc+0x1a>
        c |= 0x0700;
  1010ee:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  1010f5:	8b 45 08             	mov    0x8(%ebp),%eax
  1010f8:	0f b6 c0             	movzbl %al,%eax
  1010fb:	83 f8 0a             	cmp    $0xa,%eax
  1010fe:	74 55                	je     101155 <cga_putc+0x7a>
  101100:	83 f8 0d             	cmp    $0xd,%eax
  101103:	74 63                	je     101168 <cga_putc+0x8d>
  101105:	83 f8 08             	cmp    $0x8,%eax
  101108:	0f 85 94 00 00 00    	jne    1011a2 <cga_putc+0xc7>
    case '\b':
        if (crt_pos > 0) {
  10110e:	0f b7 05 44 d4 11 00 	movzwl 0x11d444,%eax
  101115:	85 c0                	test   %eax,%eax
  101117:	0f 84 af 00 00 00    	je     1011cc <cga_putc+0xf1>
            crt_pos --;
  10111d:	0f b7 05 44 d4 11 00 	movzwl 0x11d444,%eax
  101124:	48                   	dec    %eax
  101125:	0f b7 c0             	movzwl %ax,%eax
  101128:	66 a3 44 d4 11 00    	mov    %ax,0x11d444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  10112e:	8b 45 08             	mov    0x8(%ebp),%eax
  101131:	98                   	cwtl   
  101132:	25 00 ff ff ff       	and    $0xffffff00,%eax
  101137:	98                   	cwtl   
  101138:	83 c8 20             	or     $0x20,%eax
  10113b:	98                   	cwtl   
  10113c:	8b 15 40 d4 11 00    	mov    0x11d440,%edx
  101142:	0f b7 0d 44 d4 11 00 	movzwl 0x11d444,%ecx
  101149:	01 c9                	add    %ecx,%ecx
  10114b:	01 ca                	add    %ecx,%edx
  10114d:	0f b7 c0             	movzwl %ax,%eax
  101150:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  101153:	eb 77                	jmp    1011cc <cga_putc+0xf1>
    case '\n':
        crt_pos += CRT_COLS;
  101155:	0f b7 05 44 d4 11 00 	movzwl 0x11d444,%eax
  10115c:	83 c0 50             	add    $0x50,%eax
  10115f:	0f b7 c0             	movzwl %ax,%eax
  101162:	66 a3 44 d4 11 00    	mov    %ax,0x11d444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101168:	0f b7 1d 44 d4 11 00 	movzwl 0x11d444,%ebx
  10116f:	0f b7 0d 44 d4 11 00 	movzwl 0x11d444,%ecx
  101176:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  10117b:	89 c8                	mov    %ecx,%eax
  10117d:	f7 e2                	mul    %edx
  10117f:	c1 ea 06             	shr    $0x6,%edx
  101182:	89 d0                	mov    %edx,%eax
  101184:	c1 e0 02             	shl    $0x2,%eax
  101187:	01 d0                	add    %edx,%eax
  101189:	c1 e0 04             	shl    $0x4,%eax
  10118c:	29 c1                	sub    %eax,%ecx
  10118e:	89 c8                	mov    %ecx,%eax
  101190:	0f b7 c0             	movzwl %ax,%eax
  101193:	29 c3                	sub    %eax,%ebx
  101195:	89 d8                	mov    %ebx,%eax
  101197:	0f b7 c0             	movzwl %ax,%eax
  10119a:	66 a3 44 d4 11 00    	mov    %ax,0x11d444
        break;
  1011a0:	eb 2b                	jmp    1011cd <cga_putc+0xf2>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1011a2:	8b 0d 40 d4 11 00    	mov    0x11d440,%ecx
  1011a8:	0f b7 05 44 d4 11 00 	movzwl 0x11d444,%eax
  1011af:	8d 50 01             	lea    0x1(%eax),%edx
  1011b2:	0f b7 d2             	movzwl %dx,%edx
  1011b5:	66 89 15 44 d4 11 00 	mov    %dx,0x11d444
  1011bc:	01 c0                	add    %eax,%eax
  1011be:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  1011c1:	8b 45 08             	mov    0x8(%ebp),%eax
  1011c4:	0f b7 c0             	movzwl %ax,%eax
  1011c7:	66 89 02             	mov    %ax,(%edx)
        break;
  1011ca:	eb 01                	jmp    1011cd <cga_putc+0xf2>
        break;
  1011cc:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  1011cd:	0f b7 05 44 d4 11 00 	movzwl 0x11d444,%eax
  1011d4:	3d cf 07 00 00       	cmp    $0x7cf,%eax
  1011d9:	76 5d                	jbe    101238 <cga_putc+0x15d>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  1011db:	a1 40 d4 11 00       	mov    0x11d440,%eax
  1011e0:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1011e6:	a1 40 d4 11 00       	mov    0x11d440,%eax
  1011eb:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  1011f2:	00 
  1011f3:	89 54 24 04          	mov    %edx,0x4(%esp)
  1011f7:	89 04 24             	mov    %eax,(%esp)
  1011fa:	e8 4a 4e 00 00       	call   106049 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011ff:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  101206:	eb 14                	jmp    10121c <cga_putc+0x141>
            crt_buf[i] = 0x0700 | ' ';
  101208:	a1 40 d4 11 00       	mov    0x11d440,%eax
  10120d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101210:	01 d2                	add    %edx,%edx
  101212:	01 d0                	add    %edx,%eax
  101214:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101219:	ff 45 f4             	incl   -0xc(%ebp)
  10121c:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  101223:	7e e3                	jle    101208 <cga_putc+0x12d>
        }
        crt_pos -= CRT_COLS;
  101225:	0f b7 05 44 d4 11 00 	movzwl 0x11d444,%eax
  10122c:	83 e8 50             	sub    $0x50,%eax
  10122f:	0f b7 c0             	movzwl %ax,%eax
  101232:	66 a3 44 d4 11 00    	mov    %ax,0x11d444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  101238:	0f b7 05 46 d4 11 00 	movzwl 0x11d446,%eax
  10123f:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  101243:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
  101247:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10124b:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10124f:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  101250:	0f b7 05 44 d4 11 00 	movzwl 0x11d444,%eax
  101257:	c1 e8 08             	shr    $0x8,%eax
  10125a:	0f b7 c0             	movzwl %ax,%eax
  10125d:	0f b6 c0             	movzbl %al,%eax
  101260:	0f b7 15 46 d4 11 00 	movzwl 0x11d446,%edx
  101267:	42                   	inc    %edx
  101268:	0f b7 d2             	movzwl %dx,%edx
  10126b:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  10126f:	88 45 e9             	mov    %al,-0x17(%ebp)
  101272:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101276:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10127a:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  10127b:	0f b7 05 46 d4 11 00 	movzwl 0x11d446,%eax
  101282:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  101286:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
  10128a:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10128e:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101292:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  101293:	0f b7 05 44 d4 11 00 	movzwl 0x11d444,%eax
  10129a:	0f b6 c0             	movzbl %al,%eax
  10129d:	0f b7 15 46 d4 11 00 	movzwl 0x11d446,%edx
  1012a4:	42                   	inc    %edx
  1012a5:	0f b7 d2             	movzwl %dx,%edx
  1012a8:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  1012ac:	88 45 f1             	mov    %al,-0xf(%ebp)
  1012af:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1012b3:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1012b7:	ee                   	out    %al,(%dx)
}
  1012b8:	90                   	nop
  1012b9:	83 c4 34             	add    $0x34,%esp
  1012bc:	5b                   	pop    %ebx
  1012bd:	5d                   	pop    %ebp
  1012be:	c3                   	ret    

001012bf <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  1012bf:	55                   	push   %ebp
  1012c0:	89 e5                	mov    %esp,%ebp
  1012c2:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1012cc:	eb 08                	jmp    1012d6 <serial_putc_sub+0x17>
        delay();
  1012ce:	e8 3e fb ff ff       	call   100e11 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012d3:	ff 45 fc             	incl   -0x4(%ebp)
  1012d6:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1012dc:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1012e0:	89 c2                	mov    %eax,%edx
  1012e2:	ec                   	in     (%dx),%al
  1012e3:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1012e6:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1012ea:	0f b6 c0             	movzbl %al,%eax
  1012ed:	83 e0 20             	and    $0x20,%eax
  1012f0:	85 c0                	test   %eax,%eax
  1012f2:	75 09                	jne    1012fd <serial_putc_sub+0x3e>
  1012f4:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1012fb:	7e d1                	jle    1012ce <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
  1012fd:	8b 45 08             	mov    0x8(%ebp),%eax
  101300:	0f b6 c0             	movzbl %al,%eax
  101303:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101309:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10130c:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101310:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101314:	ee                   	out    %al,(%dx)
}
  101315:	90                   	nop
  101316:	c9                   	leave  
  101317:	c3                   	ret    

00101318 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  101318:	55                   	push   %ebp
  101319:	89 e5                	mov    %esp,%ebp
  10131b:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  10131e:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101322:	74 0d                	je     101331 <serial_putc+0x19>
        serial_putc_sub(c);
  101324:	8b 45 08             	mov    0x8(%ebp),%eax
  101327:	89 04 24             	mov    %eax,(%esp)
  10132a:	e8 90 ff ff ff       	call   1012bf <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  10132f:	eb 24                	jmp    101355 <serial_putc+0x3d>
        serial_putc_sub('\b');
  101331:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101338:	e8 82 ff ff ff       	call   1012bf <serial_putc_sub>
        serial_putc_sub(' ');
  10133d:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101344:	e8 76 ff ff ff       	call   1012bf <serial_putc_sub>
        serial_putc_sub('\b');
  101349:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101350:	e8 6a ff ff ff       	call   1012bf <serial_putc_sub>
}
  101355:	90                   	nop
  101356:	c9                   	leave  
  101357:	c3                   	ret    

00101358 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  101358:	55                   	push   %ebp
  101359:	89 e5                	mov    %esp,%ebp
  10135b:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  10135e:	eb 33                	jmp    101393 <cons_intr+0x3b>
        if (c != 0) {
  101360:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  101364:	74 2d                	je     101393 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  101366:	a1 64 d6 11 00       	mov    0x11d664,%eax
  10136b:	8d 50 01             	lea    0x1(%eax),%edx
  10136e:	89 15 64 d6 11 00    	mov    %edx,0x11d664
  101374:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101377:	88 90 60 d4 11 00    	mov    %dl,0x11d460(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  10137d:	a1 64 d6 11 00       	mov    0x11d664,%eax
  101382:	3d 00 02 00 00       	cmp    $0x200,%eax
  101387:	75 0a                	jne    101393 <cons_intr+0x3b>
                cons.wpos = 0;
  101389:	c7 05 64 d6 11 00 00 	movl   $0x0,0x11d664
  101390:	00 00 00 
    while ((c = (*proc)()) != -1) {
  101393:	8b 45 08             	mov    0x8(%ebp),%eax
  101396:	ff d0                	call   *%eax
  101398:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10139b:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  10139f:	75 bf                	jne    101360 <cons_intr+0x8>
            }
        }
    }
}
  1013a1:	90                   	nop
  1013a2:	c9                   	leave  
  1013a3:	c3                   	ret    

001013a4 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  1013a4:	55                   	push   %ebp
  1013a5:	89 e5                	mov    %esp,%ebp
  1013a7:	83 ec 10             	sub    $0x10,%esp
  1013aa:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013b0:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1013b4:	89 c2                	mov    %eax,%edx
  1013b6:	ec                   	in     (%dx),%al
  1013b7:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1013ba:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  1013be:	0f b6 c0             	movzbl %al,%eax
  1013c1:	83 e0 01             	and    $0x1,%eax
  1013c4:	85 c0                	test   %eax,%eax
  1013c6:	75 07                	jne    1013cf <serial_proc_data+0x2b>
        return -1;
  1013c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013cd:	eb 2a                	jmp    1013f9 <serial_proc_data+0x55>
  1013cf:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013d5:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1013d9:	89 c2                	mov    %eax,%edx
  1013db:	ec                   	in     (%dx),%al
  1013dc:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  1013df:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1013e3:	0f b6 c0             	movzbl %al,%eax
  1013e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1013e9:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  1013ed:	75 07                	jne    1013f6 <serial_proc_data+0x52>
        c = '\b';
  1013ef:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  1013f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1013f9:	c9                   	leave  
  1013fa:	c3                   	ret    

001013fb <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  1013fb:	55                   	push   %ebp
  1013fc:	89 e5                	mov    %esp,%ebp
  1013fe:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  101401:	a1 48 d4 11 00       	mov    0x11d448,%eax
  101406:	85 c0                	test   %eax,%eax
  101408:	74 0c                	je     101416 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  10140a:	c7 04 24 a4 13 10 00 	movl   $0x1013a4,(%esp)
  101411:	e8 42 ff ff ff       	call   101358 <cons_intr>
    }
}
  101416:	90                   	nop
  101417:	c9                   	leave  
  101418:	c3                   	ret    

00101419 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  101419:	55                   	push   %ebp
  10141a:	89 e5                	mov    %esp,%ebp
  10141c:	83 ec 38             	sub    $0x38,%esp
  10141f:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101425:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101428:	89 c2                	mov    %eax,%edx
  10142a:	ec                   	in     (%dx),%al
  10142b:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  10142e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  101432:	0f b6 c0             	movzbl %al,%eax
  101435:	83 e0 01             	and    $0x1,%eax
  101438:	85 c0                	test   %eax,%eax
  10143a:	75 0a                	jne    101446 <kbd_proc_data+0x2d>
        return -1;
  10143c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101441:	e9 55 01 00 00       	jmp    10159b <kbd_proc_data+0x182>
  101446:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10144c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10144f:	89 c2                	mov    %eax,%edx
  101451:	ec                   	in     (%dx),%al
  101452:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  101455:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  101459:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  10145c:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101460:	75 17                	jne    101479 <kbd_proc_data+0x60>
        // E0 escape character
        shift |= E0ESC;
  101462:	a1 68 d6 11 00       	mov    0x11d668,%eax
  101467:	83 c8 40             	or     $0x40,%eax
  10146a:	a3 68 d6 11 00       	mov    %eax,0x11d668
        return 0;
  10146f:	b8 00 00 00 00       	mov    $0x0,%eax
  101474:	e9 22 01 00 00       	jmp    10159b <kbd_proc_data+0x182>
    } else if (data & 0x80) {
  101479:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10147d:	84 c0                	test   %al,%al
  10147f:	79 45                	jns    1014c6 <kbd_proc_data+0xad>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101481:	a1 68 d6 11 00       	mov    0x11d668,%eax
  101486:	83 e0 40             	and    $0x40,%eax
  101489:	85 c0                	test   %eax,%eax
  10148b:	75 08                	jne    101495 <kbd_proc_data+0x7c>
  10148d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101491:	24 7f                	and    $0x7f,%al
  101493:	eb 04                	jmp    101499 <kbd_proc_data+0x80>
  101495:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101499:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  10149c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014a0:	0f b6 80 40 a0 11 00 	movzbl 0x11a040(%eax),%eax
  1014a7:	0c 40                	or     $0x40,%al
  1014a9:	0f b6 c0             	movzbl %al,%eax
  1014ac:	f7 d0                	not    %eax
  1014ae:	89 c2                	mov    %eax,%edx
  1014b0:	a1 68 d6 11 00       	mov    0x11d668,%eax
  1014b5:	21 d0                	and    %edx,%eax
  1014b7:	a3 68 d6 11 00       	mov    %eax,0x11d668
        return 0;
  1014bc:	b8 00 00 00 00       	mov    $0x0,%eax
  1014c1:	e9 d5 00 00 00       	jmp    10159b <kbd_proc_data+0x182>
    } else if (shift & E0ESC) {
  1014c6:	a1 68 d6 11 00       	mov    0x11d668,%eax
  1014cb:	83 e0 40             	and    $0x40,%eax
  1014ce:	85 c0                	test   %eax,%eax
  1014d0:	74 11                	je     1014e3 <kbd_proc_data+0xca>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1014d2:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1014d6:	a1 68 d6 11 00       	mov    0x11d668,%eax
  1014db:	83 e0 bf             	and    $0xffffffbf,%eax
  1014de:	a3 68 d6 11 00       	mov    %eax,0x11d668
    }

    shift |= shiftcode[data];
  1014e3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014e7:	0f b6 80 40 a0 11 00 	movzbl 0x11a040(%eax),%eax
  1014ee:	0f b6 d0             	movzbl %al,%edx
  1014f1:	a1 68 d6 11 00       	mov    0x11d668,%eax
  1014f6:	09 d0                	or     %edx,%eax
  1014f8:	a3 68 d6 11 00       	mov    %eax,0x11d668
    shift ^= togglecode[data];
  1014fd:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101501:	0f b6 80 40 a1 11 00 	movzbl 0x11a140(%eax),%eax
  101508:	0f b6 d0             	movzbl %al,%edx
  10150b:	a1 68 d6 11 00       	mov    0x11d668,%eax
  101510:	31 d0                	xor    %edx,%eax
  101512:	a3 68 d6 11 00       	mov    %eax,0x11d668

    c = charcode[shift & (CTL | SHIFT)][data];
  101517:	a1 68 d6 11 00       	mov    0x11d668,%eax
  10151c:	83 e0 03             	and    $0x3,%eax
  10151f:	8b 14 85 40 a5 11 00 	mov    0x11a540(,%eax,4),%edx
  101526:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10152a:	01 d0                	add    %edx,%eax
  10152c:	0f b6 00             	movzbl (%eax),%eax
  10152f:	0f b6 c0             	movzbl %al,%eax
  101532:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  101535:	a1 68 d6 11 00       	mov    0x11d668,%eax
  10153a:	83 e0 08             	and    $0x8,%eax
  10153d:	85 c0                	test   %eax,%eax
  10153f:	74 22                	je     101563 <kbd_proc_data+0x14a>
        if ('a' <= c && c <= 'z')
  101541:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  101545:	7e 0c                	jle    101553 <kbd_proc_data+0x13a>
  101547:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  10154b:	7f 06                	jg     101553 <kbd_proc_data+0x13a>
            c += 'A' - 'a';
  10154d:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  101551:	eb 10                	jmp    101563 <kbd_proc_data+0x14a>
        else if ('A' <= c && c <= 'Z')
  101553:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  101557:	7e 0a                	jle    101563 <kbd_proc_data+0x14a>
  101559:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  10155d:	7f 04                	jg     101563 <kbd_proc_data+0x14a>
            c += 'a' - 'A';
  10155f:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  101563:	a1 68 d6 11 00       	mov    0x11d668,%eax
  101568:	f7 d0                	not    %eax
  10156a:	83 e0 06             	and    $0x6,%eax
  10156d:	85 c0                	test   %eax,%eax
  10156f:	75 27                	jne    101598 <kbd_proc_data+0x17f>
  101571:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101578:	75 1e                	jne    101598 <kbd_proc_data+0x17f>
        cprintf("Rebooting!\n");
  10157a:	c7 04 24 2d 6b 10 00 	movl   $0x106b2d,(%esp)
  101581:	e8 01 ed ff ff       	call   100287 <cprintf>
  101586:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  10158c:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101590:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  101594:	8b 55 e8             	mov    -0x18(%ebp),%edx
  101597:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101598:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10159b:	c9                   	leave  
  10159c:	c3                   	ret    

0010159d <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  10159d:	55                   	push   %ebp
  10159e:	89 e5                	mov    %esp,%ebp
  1015a0:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  1015a3:	c7 04 24 19 14 10 00 	movl   $0x101419,(%esp)
  1015aa:	e8 a9 fd ff ff       	call   101358 <cons_intr>
}
  1015af:	90                   	nop
  1015b0:	c9                   	leave  
  1015b1:	c3                   	ret    

001015b2 <kbd_init>:

static void
kbd_init(void) {
  1015b2:	55                   	push   %ebp
  1015b3:	89 e5                	mov    %esp,%ebp
  1015b5:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  1015b8:	e8 e0 ff ff ff       	call   10159d <kbd_intr>
    pic_enable(IRQ_KBD);
  1015bd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1015c4:	e8 35 01 00 00       	call   1016fe <pic_enable>
}
  1015c9:	90                   	nop
  1015ca:	c9                   	leave  
  1015cb:	c3                   	ret    

001015cc <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1015cc:	55                   	push   %ebp
  1015cd:	89 e5                	mov    %esp,%ebp
  1015cf:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  1015d2:	e8 83 f8 ff ff       	call   100e5a <cga_init>
    serial_init();
  1015d7:	e8 62 f9 ff ff       	call   100f3e <serial_init>
    kbd_init();
  1015dc:	e8 d1 ff ff ff       	call   1015b2 <kbd_init>
    if (!serial_exists) {
  1015e1:	a1 48 d4 11 00       	mov    0x11d448,%eax
  1015e6:	85 c0                	test   %eax,%eax
  1015e8:	75 0c                	jne    1015f6 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  1015ea:	c7 04 24 39 6b 10 00 	movl   $0x106b39,(%esp)
  1015f1:	e8 91 ec ff ff       	call   100287 <cprintf>
    }
}
  1015f6:	90                   	nop
  1015f7:	c9                   	leave  
  1015f8:	c3                   	ret    

001015f9 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1015f9:	55                   	push   %ebp
  1015fa:	89 e5                	mov    %esp,%ebp
  1015fc:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  1015ff:	e8 cf f7 ff ff       	call   100dd3 <__intr_save>
  101604:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  101607:	8b 45 08             	mov    0x8(%ebp),%eax
  10160a:	89 04 24             	mov    %eax,(%esp)
  10160d:	e8 89 fa ff ff       	call   10109b <lpt_putc>
        cga_putc(c);
  101612:	8b 45 08             	mov    0x8(%ebp),%eax
  101615:	89 04 24             	mov    %eax,(%esp)
  101618:	e8 be fa ff ff       	call   1010db <cga_putc>
        serial_putc(c);
  10161d:	8b 45 08             	mov    0x8(%ebp),%eax
  101620:	89 04 24             	mov    %eax,(%esp)
  101623:	e8 f0 fc ff ff       	call   101318 <serial_putc>
    }
    local_intr_restore(intr_flag);
  101628:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10162b:	89 04 24             	mov    %eax,(%esp)
  10162e:	e8 ca f7 ff ff       	call   100dfd <__intr_restore>
}
  101633:	90                   	nop
  101634:	c9                   	leave  
  101635:	c3                   	ret    

00101636 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  101636:	55                   	push   %ebp
  101637:	89 e5                	mov    %esp,%ebp
  101639:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
  10163c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  101643:	e8 8b f7 ff ff       	call   100dd3 <__intr_save>
  101648:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  10164b:	e8 ab fd ff ff       	call   1013fb <serial_intr>
        kbd_intr();
  101650:	e8 48 ff ff ff       	call   10159d <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  101655:	8b 15 60 d6 11 00    	mov    0x11d660,%edx
  10165b:	a1 64 d6 11 00       	mov    0x11d664,%eax
  101660:	39 c2                	cmp    %eax,%edx
  101662:	74 31                	je     101695 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
  101664:	a1 60 d6 11 00       	mov    0x11d660,%eax
  101669:	8d 50 01             	lea    0x1(%eax),%edx
  10166c:	89 15 60 d6 11 00    	mov    %edx,0x11d660
  101672:	0f b6 80 60 d4 11 00 	movzbl 0x11d460(%eax),%eax
  101679:	0f b6 c0             	movzbl %al,%eax
  10167c:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  10167f:	a1 60 d6 11 00       	mov    0x11d660,%eax
  101684:	3d 00 02 00 00       	cmp    $0x200,%eax
  101689:	75 0a                	jne    101695 <cons_getc+0x5f>
                cons.rpos = 0;
  10168b:	c7 05 60 d6 11 00 00 	movl   $0x0,0x11d660
  101692:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  101695:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101698:	89 04 24             	mov    %eax,(%esp)
  10169b:	e8 5d f7 ff ff       	call   100dfd <__intr_restore>
    return c;
  1016a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1016a3:	c9                   	leave  
  1016a4:	c3                   	ret    

001016a5 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1016a5:	55                   	push   %ebp
  1016a6:	89 e5                	mov    %esp,%ebp
  1016a8:	83 ec 14             	sub    $0x14,%esp
  1016ab:	8b 45 08             	mov    0x8(%ebp),%eax
  1016ae:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1016b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1016b5:	66 a3 50 a5 11 00    	mov    %ax,0x11a550
    if (did_init) {
  1016bb:	a1 6c d6 11 00       	mov    0x11d66c,%eax
  1016c0:	85 c0                	test   %eax,%eax
  1016c2:	74 37                	je     1016fb <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  1016c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1016c7:	0f b6 c0             	movzbl %al,%eax
  1016ca:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  1016d0:	88 45 f9             	mov    %al,-0x7(%ebp)
  1016d3:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1016d7:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1016db:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  1016dc:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016e0:	c1 e8 08             	shr    $0x8,%eax
  1016e3:	0f b7 c0             	movzwl %ax,%eax
  1016e6:	0f b6 c0             	movzbl %al,%eax
  1016e9:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  1016ef:	88 45 fd             	mov    %al,-0x3(%ebp)
  1016f2:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016f6:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016fa:	ee                   	out    %al,(%dx)
    }
}
  1016fb:	90                   	nop
  1016fc:	c9                   	leave  
  1016fd:	c3                   	ret    

001016fe <pic_enable>:

void
pic_enable(unsigned int irq) {
  1016fe:	55                   	push   %ebp
  1016ff:	89 e5                	mov    %esp,%ebp
  101701:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  101704:	8b 45 08             	mov    0x8(%ebp),%eax
  101707:	ba 01 00 00 00       	mov    $0x1,%edx
  10170c:	88 c1                	mov    %al,%cl
  10170e:	d3 e2                	shl    %cl,%edx
  101710:	89 d0                	mov    %edx,%eax
  101712:	98                   	cwtl   
  101713:	f7 d0                	not    %eax
  101715:	0f bf d0             	movswl %ax,%edx
  101718:	0f b7 05 50 a5 11 00 	movzwl 0x11a550,%eax
  10171f:	98                   	cwtl   
  101720:	21 d0                	and    %edx,%eax
  101722:	98                   	cwtl   
  101723:	0f b7 c0             	movzwl %ax,%eax
  101726:	89 04 24             	mov    %eax,(%esp)
  101729:	e8 77 ff ff ff       	call   1016a5 <pic_setmask>
}
  10172e:	90                   	nop
  10172f:	c9                   	leave  
  101730:	c3                   	ret    

00101731 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  101731:	55                   	push   %ebp
  101732:	89 e5                	mov    %esp,%ebp
  101734:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  101737:	c7 05 6c d6 11 00 01 	movl   $0x1,0x11d66c
  10173e:	00 00 00 
  101741:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  101747:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
  10174b:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  10174f:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  101753:	ee                   	out    %al,(%dx)
  101754:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  10175a:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
  10175e:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  101762:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101766:	ee                   	out    %al,(%dx)
  101767:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  10176d:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
  101771:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  101775:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  101779:	ee                   	out    %al,(%dx)
  10177a:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  101780:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
  101784:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101788:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  10178c:	ee                   	out    %al,(%dx)
  10178d:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  101793:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
  101797:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  10179b:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  10179f:	ee                   	out    %al,(%dx)
  1017a0:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  1017a6:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
  1017aa:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  1017ae:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  1017b2:	ee                   	out    %al,(%dx)
  1017b3:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  1017b9:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
  1017bd:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  1017c1:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  1017c5:	ee                   	out    %al,(%dx)
  1017c6:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  1017cc:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
  1017d0:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1017d4:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1017d8:	ee                   	out    %al,(%dx)
  1017d9:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  1017df:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
  1017e3:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1017e7:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1017eb:	ee                   	out    %al,(%dx)
  1017ec:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  1017f2:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
  1017f6:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1017fa:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1017fe:	ee                   	out    %al,(%dx)
  1017ff:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  101805:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
  101809:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10180d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101811:	ee                   	out    %al,(%dx)
  101812:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  101818:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
  10181c:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101820:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101824:	ee                   	out    %al,(%dx)
  101825:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  10182b:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
  10182f:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101833:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101837:	ee                   	out    %al,(%dx)
  101838:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  10183e:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
  101842:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101846:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10184a:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  10184b:	0f b7 05 50 a5 11 00 	movzwl 0x11a550,%eax
  101852:	3d ff ff 00 00       	cmp    $0xffff,%eax
  101857:	74 0f                	je     101868 <pic_init+0x137>
        pic_setmask(irq_mask);
  101859:	0f b7 05 50 a5 11 00 	movzwl 0x11a550,%eax
  101860:	89 04 24             	mov    %eax,(%esp)
  101863:	e8 3d fe ff ff       	call   1016a5 <pic_setmask>
    }
}
  101868:	90                   	nop
  101869:	c9                   	leave  
  10186a:	c3                   	ret    

0010186b <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  10186b:	55                   	push   %ebp
  10186c:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
  10186e:	fb                   	sti    
    sti();
}
  10186f:	90                   	nop
  101870:	5d                   	pop    %ebp
  101871:	c3                   	ret    

00101872 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  101872:	55                   	push   %ebp
  101873:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
  101875:	fa                   	cli    
    cli();
}
  101876:	90                   	nop
  101877:	5d                   	pop    %ebp
  101878:	c3                   	ret    

00101879 <print_switch_to_user>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100
void print_switch_to_user()
{
  101879:	55                   	push   %ebp
  10187a:	89 e5                	mov    %esp,%ebp
  10187c:	83 ec 18             	sub    $0x18,%esp
	cprintf("switch to user");
  10187f:	c7 04 24 60 6b 10 00 	movl   $0x106b60,(%esp)
  101886:	e8 fc e9 ff ff       	call   100287 <cprintf>
}
  10188b:	90                   	nop
  10188c:	c9                   	leave  
  10188d:	c3                   	ret    

0010188e <print_switch_to_kernel>:

void print_switch_to_kernel()
{
  10188e:	55                   	push   %ebp
  10188f:	89 e5                	mov    %esp,%ebp
  101891:	83 ec 18             	sub    $0x18,%esp
	cprintf("switch to kernel\n");
  101894:	c7 04 24 6f 6b 10 00 	movl   $0x106b6f,(%esp)
  10189b:	e8 e7 e9 ff ff       	call   100287 <cprintf>
}
  1018a0:	90                   	nop
  1018a1:	c9                   	leave  
  1018a2:	c3                   	ret    

001018a3 <print_ticks>:

static void print_ticks() {
  1018a3:	55                   	push   %ebp
  1018a4:	89 e5                	mov    %esp,%ebp
  1018a6:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  1018a9:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  1018b0:	00 
  1018b1:	c7 04 24 81 6b 10 00 	movl   $0x106b81,(%esp)
  1018b8:	e8 ca e9 ff ff       	call   100287 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  1018bd:	90                   	nop
  1018be:	c9                   	leave  
  1018bf:	c3                   	ret    

001018c0 <idt_init>:

extern uint32_t __vectors[256];

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1018c0:	55                   	push   %ebp
  1018c1:	89 e5                	mov    %esp,%ebp
  1018c3:	83 ec 10             	sub    $0x10,%esp
      *     Can you see idt[256] in this file? Yes, it's IDT! you can use SETGATE macro to setup each item of IDT
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	int intrno = 0;
  1018c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	/* ucore don't use task gate.*/
	for(; intrno < 256; intrno++) 
  1018cd:	e9 c4 00 00 00       	jmp    101996 <idt_init+0xd6>
		SETGATE(idt[intrno], 0, KERNEL_CS, __vectors[intrno], DPL_KERNEL);
  1018d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018d5:	8b 04 85 e0 a5 11 00 	mov    0x11a5e0(,%eax,4),%eax
  1018dc:	0f b7 d0             	movzwl %ax,%edx
  1018df:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018e2:	66 89 14 c5 80 d6 11 	mov    %dx,0x11d680(,%eax,8)
  1018e9:	00 
  1018ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018ed:	66 c7 04 c5 82 d6 11 	movw   $0x8,0x11d682(,%eax,8)
  1018f4:	00 08 00 
  1018f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018fa:	0f b6 14 c5 84 d6 11 	movzbl 0x11d684(,%eax,8),%edx
  101901:	00 
  101902:	80 e2 e0             	and    $0xe0,%dl
  101905:	88 14 c5 84 d6 11 00 	mov    %dl,0x11d684(,%eax,8)
  10190c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10190f:	0f b6 14 c5 84 d6 11 	movzbl 0x11d684(,%eax,8),%edx
  101916:	00 
  101917:	80 e2 1f             	and    $0x1f,%dl
  10191a:	88 14 c5 84 d6 11 00 	mov    %dl,0x11d684(,%eax,8)
  101921:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101924:	0f b6 14 c5 85 d6 11 	movzbl 0x11d685(,%eax,8),%edx
  10192b:	00 
  10192c:	80 e2 f0             	and    $0xf0,%dl
  10192f:	80 ca 0e             	or     $0xe,%dl
  101932:	88 14 c5 85 d6 11 00 	mov    %dl,0x11d685(,%eax,8)
  101939:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10193c:	0f b6 14 c5 85 d6 11 	movzbl 0x11d685(,%eax,8),%edx
  101943:	00 
  101944:	80 e2 ef             	and    $0xef,%dl
  101947:	88 14 c5 85 d6 11 00 	mov    %dl,0x11d685(,%eax,8)
  10194e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101951:	0f b6 14 c5 85 d6 11 	movzbl 0x11d685(,%eax,8),%edx
  101958:	00 
  101959:	80 e2 9f             	and    $0x9f,%dl
  10195c:	88 14 c5 85 d6 11 00 	mov    %dl,0x11d685(,%eax,8)
  101963:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101966:	0f b6 14 c5 85 d6 11 	movzbl 0x11d685(,%eax,8),%edx
  10196d:	00 
  10196e:	80 ca 80             	or     $0x80,%dl
  101971:	88 14 c5 85 d6 11 00 	mov    %dl,0x11d685(,%eax,8)
  101978:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10197b:	8b 04 85 e0 a5 11 00 	mov    0x11a5e0(,%eax,4),%eax
  101982:	c1 e8 10             	shr    $0x10,%eax
  101985:	0f b7 d0             	movzwl %ax,%edx
  101988:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10198b:	66 89 14 c5 86 d6 11 	mov    %dx,0x11d686(,%eax,8)
  101992:	00 
	for(; intrno < 256; intrno++) 
  101993:	ff 45 fc             	incl   -0x4(%ebp)
  101996:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  10199d:	0f 8e 2f ff ff ff    	jle    1018d2 <idt_init+0x12>

	SETGATE(idt[T_SYSCALL], 1, KERNEL_CS, __vectors[T_SYSCALL], DPL_USER);
  1019a3:	a1 e0 a7 11 00       	mov    0x11a7e0,%eax
  1019a8:	0f b7 c0             	movzwl %ax,%eax
  1019ab:	66 a3 80 da 11 00    	mov    %ax,0x11da80
  1019b1:	66 c7 05 82 da 11 00 	movw   $0x8,0x11da82
  1019b8:	08 00 
  1019ba:	0f b6 05 84 da 11 00 	movzbl 0x11da84,%eax
  1019c1:	24 e0                	and    $0xe0,%al
  1019c3:	a2 84 da 11 00       	mov    %al,0x11da84
  1019c8:	0f b6 05 84 da 11 00 	movzbl 0x11da84,%eax
  1019cf:	24 1f                	and    $0x1f,%al
  1019d1:	a2 84 da 11 00       	mov    %al,0x11da84
  1019d6:	0f b6 05 85 da 11 00 	movzbl 0x11da85,%eax
  1019dd:	0c 0f                	or     $0xf,%al
  1019df:	a2 85 da 11 00       	mov    %al,0x11da85
  1019e4:	0f b6 05 85 da 11 00 	movzbl 0x11da85,%eax
  1019eb:	24 ef                	and    $0xef,%al
  1019ed:	a2 85 da 11 00       	mov    %al,0x11da85
  1019f2:	0f b6 05 85 da 11 00 	movzbl 0x11da85,%eax
  1019f9:	0c 60                	or     $0x60,%al
  1019fb:	a2 85 da 11 00       	mov    %al,0x11da85
  101a00:	0f b6 05 85 da 11 00 	movzbl 0x11da85,%eax
  101a07:	0c 80                	or     $0x80,%al
  101a09:	a2 85 da 11 00       	mov    %al,0x11da85
  101a0e:	a1 e0 a7 11 00       	mov    0x11a7e0,%eax
  101a13:	c1 e8 10             	shr    $0x10,%eax
  101a16:	0f b7 c0             	movzwl %ax,%eax
  101a19:	66 a3 86 da 11 00    	mov    %ax,0x11da86
	SETGATE(idt[T_SWITCH_TOK], 0, KERNEL_CS, __vectors[T_SWITCH_TOK], DPL_USER);
  101a1f:	a1 c4 a7 11 00       	mov    0x11a7c4,%eax
  101a24:	0f b7 c0             	movzwl %ax,%eax
  101a27:	66 a3 48 da 11 00    	mov    %ax,0x11da48
  101a2d:	66 c7 05 4a da 11 00 	movw   $0x8,0x11da4a
  101a34:	08 00 
  101a36:	0f b6 05 4c da 11 00 	movzbl 0x11da4c,%eax
  101a3d:	24 e0                	and    $0xe0,%al
  101a3f:	a2 4c da 11 00       	mov    %al,0x11da4c
  101a44:	0f b6 05 4c da 11 00 	movzbl 0x11da4c,%eax
  101a4b:	24 1f                	and    $0x1f,%al
  101a4d:	a2 4c da 11 00       	mov    %al,0x11da4c
  101a52:	0f b6 05 4d da 11 00 	movzbl 0x11da4d,%eax
  101a59:	24 f0                	and    $0xf0,%al
  101a5b:	0c 0e                	or     $0xe,%al
  101a5d:	a2 4d da 11 00       	mov    %al,0x11da4d
  101a62:	0f b6 05 4d da 11 00 	movzbl 0x11da4d,%eax
  101a69:	24 ef                	and    $0xef,%al
  101a6b:	a2 4d da 11 00       	mov    %al,0x11da4d
  101a70:	0f b6 05 4d da 11 00 	movzbl 0x11da4d,%eax
  101a77:	0c 60                	or     $0x60,%al
  101a79:	a2 4d da 11 00       	mov    %al,0x11da4d
  101a7e:	0f b6 05 4d da 11 00 	movzbl 0x11da4d,%eax
  101a85:	0c 80                	or     $0x80,%al
  101a87:	a2 4d da 11 00       	mov    %al,0x11da4d
  101a8c:	a1 c4 a7 11 00       	mov    0x11a7c4,%eax
  101a91:	c1 e8 10             	shr    $0x10,%eax
  101a94:	0f b7 c0             	movzwl %ax,%eax
  101a97:	66 a3 4e da 11 00    	mov    %ax,0x11da4e
	SETGATE(idt[T_SWITCH_TOU], 0, KERNEL_CS, __vectors[T_SWITCH_TOU], DPL_KERNEL);
  101a9d:	a1 c0 a7 11 00       	mov    0x11a7c0,%eax
  101aa2:	0f b7 c0             	movzwl %ax,%eax
  101aa5:	66 a3 40 da 11 00    	mov    %ax,0x11da40
  101aab:	66 c7 05 42 da 11 00 	movw   $0x8,0x11da42
  101ab2:	08 00 
  101ab4:	0f b6 05 44 da 11 00 	movzbl 0x11da44,%eax
  101abb:	24 e0                	and    $0xe0,%al
  101abd:	a2 44 da 11 00       	mov    %al,0x11da44
  101ac2:	0f b6 05 44 da 11 00 	movzbl 0x11da44,%eax
  101ac9:	24 1f                	and    $0x1f,%al
  101acb:	a2 44 da 11 00       	mov    %al,0x11da44
  101ad0:	0f b6 05 45 da 11 00 	movzbl 0x11da45,%eax
  101ad7:	24 f0                	and    $0xf0,%al
  101ad9:	0c 0e                	or     $0xe,%al
  101adb:	a2 45 da 11 00       	mov    %al,0x11da45
  101ae0:	0f b6 05 45 da 11 00 	movzbl 0x11da45,%eax
  101ae7:	24 ef                	and    $0xef,%al
  101ae9:	a2 45 da 11 00       	mov    %al,0x11da45
  101aee:	0f b6 05 45 da 11 00 	movzbl 0x11da45,%eax
  101af5:	24 9f                	and    $0x9f,%al
  101af7:	a2 45 da 11 00       	mov    %al,0x11da45
  101afc:	0f b6 05 45 da 11 00 	movzbl 0x11da45,%eax
  101b03:	0c 80                	or     $0x80,%al
  101b05:	a2 45 da 11 00       	mov    %al,0x11da45
  101b0a:	a1 c0 a7 11 00       	mov    0x11a7c0,%eax
  101b0f:	c1 e8 10             	shr    $0x10,%eax
  101b12:	0f b7 c0             	movzwl %ax,%eax
  101b15:	66 a3 46 da 11 00    	mov    %ax,0x11da46
  101b1b:	c7 45 f8 60 a5 11 00 	movl   $0x11a560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  101b22:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101b25:	0f 01 18             	lidtl  (%eax)

	lidt(&idt_pd);

}
  101b28:	90                   	nop
  101b29:	c9                   	leave  
  101b2a:	c3                   	ret    

00101b2b <trapname>:

static const char *
trapname(int trapno) {
  101b2b:	55                   	push   %ebp
  101b2c:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b31:	83 f8 13             	cmp    $0x13,%eax
  101b34:	77 0c                	ja     101b42 <trapname+0x17>
        return excnames[trapno];
  101b36:	8b 45 08             	mov    0x8(%ebp),%eax
  101b39:	8b 04 85 00 6f 10 00 	mov    0x106f00(,%eax,4),%eax
  101b40:	eb 18                	jmp    101b5a <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101b42:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101b46:	7e 0d                	jle    101b55 <trapname+0x2a>
  101b48:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101b4c:	7f 07                	jg     101b55 <trapname+0x2a>
        return "Hardware Interrupt";
  101b4e:	b8 8b 6b 10 00       	mov    $0x106b8b,%eax
  101b53:	eb 05                	jmp    101b5a <trapname+0x2f>
    }
    return "(unknown trap)";
  101b55:	b8 9e 6b 10 00       	mov    $0x106b9e,%eax
}
  101b5a:	5d                   	pop    %ebp
  101b5b:	c3                   	ret    

00101b5c <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101b5c:	55                   	push   %ebp
  101b5d:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  101b62:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b66:	83 f8 08             	cmp    $0x8,%eax
  101b69:	0f 94 c0             	sete   %al
  101b6c:	0f b6 c0             	movzbl %al,%eax
}
  101b6f:	5d                   	pop    %ebp
  101b70:	c3                   	ret    

00101b71 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101b71:	55                   	push   %ebp
  101b72:	89 e5                	mov    %esp,%ebp
  101b74:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101b77:	8b 45 08             	mov    0x8(%ebp),%eax
  101b7a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b7e:	c7 04 24 df 6b 10 00 	movl   $0x106bdf,(%esp)
  101b85:	e8 fd e6 ff ff       	call   100287 <cprintf>
    print_regs(&tf->tf_regs);
  101b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  101b8d:	89 04 24             	mov    %eax,(%esp)
  101b90:	e8 8f 01 00 00       	call   101d24 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101b95:	8b 45 08             	mov    0x8(%ebp),%eax
  101b98:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101b9c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ba0:	c7 04 24 f0 6b 10 00 	movl   $0x106bf0,(%esp)
  101ba7:	e8 db e6 ff ff       	call   100287 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101bac:	8b 45 08             	mov    0x8(%ebp),%eax
  101baf:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101bb3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bb7:	c7 04 24 03 6c 10 00 	movl   $0x106c03,(%esp)
  101bbe:	e8 c4 e6 ff ff       	call   100287 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  101bc6:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101bca:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bce:	c7 04 24 16 6c 10 00 	movl   $0x106c16,(%esp)
  101bd5:	e8 ad e6 ff ff       	call   100287 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101bda:	8b 45 08             	mov    0x8(%ebp),%eax
  101bdd:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101be1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101be5:	c7 04 24 29 6c 10 00 	movl   $0x106c29,(%esp)
  101bec:	e8 96 e6 ff ff       	call   100287 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  101bf4:	8b 40 30             	mov    0x30(%eax),%eax
  101bf7:	89 04 24             	mov    %eax,(%esp)
  101bfa:	e8 2c ff ff ff       	call   101b2b <trapname>
  101bff:	89 c2                	mov    %eax,%edx
  101c01:	8b 45 08             	mov    0x8(%ebp),%eax
  101c04:	8b 40 30             	mov    0x30(%eax),%eax
  101c07:	89 54 24 08          	mov    %edx,0x8(%esp)
  101c0b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c0f:	c7 04 24 3c 6c 10 00 	movl   $0x106c3c,(%esp)
  101c16:	e8 6c e6 ff ff       	call   100287 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  101c1e:	8b 40 34             	mov    0x34(%eax),%eax
  101c21:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c25:	c7 04 24 4e 6c 10 00 	movl   $0x106c4e,(%esp)
  101c2c:	e8 56 e6 ff ff       	call   100287 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101c31:	8b 45 08             	mov    0x8(%ebp),%eax
  101c34:	8b 40 38             	mov    0x38(%eax),%eax
  101c37:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c3b:	c7 04 24 5d 6c 10 00 	movl   $0x106c5d,(%esp)
  101c42:	e8 40 e6 ff ff       	call   100287 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101c47:	8b 45 08             	mov    0x8(%ebp),%eax
  101c4a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101c4e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c52:	c7 04 24 6c 6c 10 00 	movl   $0x106c6c,(%esp)
  101c59:	e8 29 e6 ff ff       	call   100287 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  101c61:	8b 40 40             	mov    0x40(%eax),%eax
  101c64:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c68:	c7 04 24 7f 6c 10 00 	movl   $0x106c7f,(%esp)
  101c6f:	e8 13 e6 ff ff       	call   100287 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101c74:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101c7b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101c82:	eb 3d                	jmp    101cc1 <print_trapframe+0x150>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101c84:	8b 45 08             	mov    0x8(%ebp),%eax
  101c87:	8b 50 40             	mov    0x40(%eax),%edx
  101c8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101c8d:	21 d0                	and    %edx,%eax
  101c8f:	85 c0                	test   %eax,%eax
  101c91:	74 28                	je     101cbb <print_trapframe+0x14a>
  101c93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c96:	8b 04 85 80 a5 11 00 	mov    0x11a580(,%eax,4),%eax
  101c9d:	85 c0                	test   %eax,%eax
  101c9f:	74 1a                	je     101cbb <print_trapframe+0x14a>
            cprintf("%s,", IA32flags[i]);
  101ca1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101ca4:	8b 04 85 80 a5 11 00 	mov    0x11a580(,%eax,4),%eax
  101cab:	89 44 24 04          	mov    %eax,0x4(%esp)
  101caf:	c7 04 24 8e 6c 10 00 	movl   $0x106c8e,(%esp)
  101cb6:	e8 cc e5 ff ff       	call   100287 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101cbb:	ff 45 f4             	incl   -0xc(%ebp)
  101cbe:	d1 65 f0             	shll   -0x10(%ebp)
  101cc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101cc4:	83 f8 17             	cmp    $0x17,%eax
  101cc7:	76 bb                	jbe    101c84 <print_trapframe+0x113>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  101ccc:	8b 40 40             	mov    0x40(%eax),%eax
  101ccf:	c1 e8 0c             	shr    $0xc,%eax
  101cd2:	83 e0 03             	and    $0x3,%eax
  101cd5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cd9:	c7 04 24 92 6c 10 00 	movl   $0x106c92,(%esp)
  101ce0:	e8 a2 e5 ff ff       	call   100287 <cprintf>

    if (!trap_in_kernel(tf)) {
  101ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  101ce8:	89 04 24             	mov    %eax,(%esp)
  101ceb:	e8 6c fe ff ff       	call   101b5c <trap_in_kernel>
  101cf0:	85 c0                	test   %eax,%eax
  101cf2:	75 2d                	jne    101d21 <print_trapframe+0x1b0>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  101cf7:	8b 40 44             	mov    0x44(%eax),%eax
  101cfa:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cfe:	c7 04 24 9b 6c 10 00 	movl   $0x106c9b,(%esp)
  101d05:	e8 7d e5 ff ff       	call   100287 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  101d0d:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101d11:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d15:	c7 04 24 aa 6c 10 00 	movl   $0x106caa,(%esp)
  101d1c:	e8 66 e5 ff ff       	call   100287 <cprintf>
    }
}
  101d21:	90                   	nop
  101d22:	c9                   	leave  
  101d23:	c3                   	ret    

00101d24 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101d24:	55                   	push   %ebp
  101d25:	89 e5                	mov    %esp,%ebp
  101d27:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  101d2d:	8b 00                	mov    (%eax),%eax
  101d2f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d33:	c7 04 24 bd 6c 10 00 	movl   $0x106cbd,(%esp)
  101d3a:	e8 48 e5 ff ff       	call   100287 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  101d42:	8b 40 04             	mov    0x4(%eax),%eax
  101d45:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d49:	c7 04 24 cc 6c 10 00 	movl   $0x106ccc,(%esp)
  101d50:	e8 32 e5 ff ff       	call   100287 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101d55:	8b 45 08             	mov    0x8(%ebp),%eax
  101d58:	8b 40 08             	mov    0x8(%eax),%eax
  101d5b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d5f:	c7 04 24 db 6c 10 00 	movl   $0x106cdb,(%esp)
  101d66:	e8 1c e5 ff ff       	call   100287 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  101d6e:	8b 40 0c             	mov    0xc(%eax),%eax
  101d71:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d75:	c7 04 24 ea 6c 10 00 	movl   $0x106cea,(%esp)
  101d7c:	e8 06 e5 ff ff       	call   100287 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101d81:	8b 45 08             	mov    0x8(%ebp),%eax
  101d84:	8b 40 10             	mov    0x10(%eax),%eax
  101d87:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d8b:	c7 04 24 f9 6c 10 00 	movl   $0x106cf9,(%esp)
  101d92:	e8 f0 e4 ff ff       	call   100287 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101d97:	8b 45 08             	mov    0x8(%ebp),%eax
  101d9a:	8b 40 14             	mov    0x14(%eax),%eax
  101d9d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101da1:	c7 04 24 08 6d 10 00 	movl   $0x106d08,(%esp)
  101da8:	e8 da e4 ff ff       	call   100287 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101dad:	8b 45 08             	mov    0x8(%ebp),%eax
  101db0:	8b 40 18             	mov    0x18(%eax),%eax
  101db3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101db7:	c7 04 24 17 6d 10 00 	movl   $0x106d17,(%esp)
  101dbe:	e8 c4 e4 ff ff       	call   100287 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  101dc6:	8b 40 1c             	mov    0x1c(%eax),%eax
  101dc9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101dcd:	c7 04 24 26 6d 10 00 	movl   $0x106d26,(%esp)
  101dd4:	e8 ae e4 ff ff       	call   100287 <cprintf>
}
  101dd9:	90                   	nop
  101dda:	c9                   	leave  
  101ddb:	c3                   	ret    

00101ddc <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101ddc:	55                   	push   %ebp
  101ddd:	89 e5                	mov    %esp,%ebp
  101ddf:	57                   	push   %edi
  101de0:	56                   	push   %esi
  101de1:	53                   	push   %ebx
  101de2:	83 ec 2c             	sub    $0x2c,%esp
    char c;
	static struct trapframe *correct_tf;
	correct_tf = (struct trapframe *) ((uint32_t)(tf) - 8);
  101de5:	8b 45 08             	mov    0x8(%ebp),%eax
  101de8:	83 e8 08             	sub    $0x8,%eax
  101deb:	a3 80 de 11 00       	mov    %eax,0x11de80

    switch (tf->tf_trapno) {
  101df0:	8b 45 08             	mov    0x8(%ebp),%eax
  101df3:	8b 40 30             	mov    0x30(%eax),%eax
  101df6:	83 f8 24             	cmp    $0x24,%eax
  101df9:	0f 84 96 00 00 00    	je     101e95 <trap_dispatch+0xb9>
  101dff:	83 f8 24             	cmp    $0x24,%eax
  101e02:	77 1c                	ja     101e20 <trap_dispatch+0x44>
  101e04:	83 f8 20             	cmp    $0x20,%eax
  101e07:	74 44                	je     101e4d <trap_dispatch+0x71>
  101e09:	83 f8 21             	cmp    $0x21,%eax
  101e0c:	0f 84 ac 00 00 00    	je     101ebe <trap_dispatch+0xe2>
  101e12:	83 f8 0d             	cmp    $0xd,%eax
  101e15:	0f 84 aa 03 00 00    	je     1021c5 <loop+0x16e>
  101e1b:	e9 be 03 00 00       	jmp    1021de <loop+0x187>
  101e20:	83 f8 78             	cmp    $0x78,%eax
  101e23:	0f 84 a8 02 00 00    	je     1020d1 <loop+0x7a>
  101e29:	83 f8 78             	cmp    $0x78,%eax
  101e2c:	77 11                	ja     101e3f <trap_dispatch+0x63>
  101e2e:	83 e8 2e             	sub    $0x2e,%eax
  101e31:	83 f8 01             	cmp    $0x1,%eax
  101e34:	0f 87 a4 03 00 00    	ja     1021de <loop+0x187>
		}
			break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101e3a:	e9 f7 03 00 00       	jmp    102236 <loop+0x1df>
    switch (tf->tf_trapno) {
  101e3f:	83 f8 79             	cmp    $0x79,%eax
  101e42:	0f 84 0c 03 00 00    	je     102154 <loop+0xfd>
  101e48:	e9 91 03 00 00       	jmp    1021de <loop+0x187>
		ticks = (ticks + 1) % 100;
  101e4d:	a1 2c df 11 00       	mov    0x11df2c,%eax
  101e52:	8d 48 01             	lea    0x1(%eax),%ecx
  101e55:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101e5a:	89 c8                	mov    %ecx,%eax
  101e5c:	f7 e2                	mul    %edx
  101e5e:	c1 ea 05             	shr    $0x5,%edx
  101e61:	89 d0                	mov    %edx,%eax
  101e63:	c1 e0 02             	shl    $0x2,%eax
  101e66:	01 d0                	add    %edx,%eax
  101e68:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  101e6f:	01 d0                	add    %edx,%eax
  101e71:	c1 e0 02             	shl    $0x2,%eax
  101e74:	29 c1                	sub    %eax,%ecx
  101e76:	89 ca                	mov    %ecx,%edx
  101e78:	89 15 2c df 11 00    	mov    %edx,0x11df2c
		if (ticks == 0)
  101e7e:	a1 2c df 11 00       	mov    0x11df2c,%eax
  101e83:	85 c0                	test   %eax,%eax
  101e85:	0f 85 a4 03 00 00    	jne    10222f <loop+0x1d8>
			print_ticks();
  101e8b:	e8 13 fa ff ff       	call   1018a3 <print_ticks>
        break;
  101e90:	e9 9a 03 00 00       	jmp    10222f <loop+0x1d8>
        c = cons_getc();
  101e95:	e8 9c f7 ff ff       	call   101636 <cons_getc>
  101e9a:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101e9d:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101ea1:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101ea5:	89 54 24 08          	mov    %edx,0x8(%esp)
  101ea9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ead:	c7 04 24 35 6d 10 00 	movl   $0x106d35,(%esp)
  101eb4:	e8 ce e3 ff ff       	call   100287 <cprintf>
        break;
  101eb9:	e9 78 03 00 00       	jmp    102236 <loop+0x1df>
        c = cons_getc();
  101ebe:	e8 73 f7 ff ff       	call   101636 <cons_getc>
  101ec3:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101ec6:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101eca:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101ece:	89 54 24 08          	mov    %edx,0x8(%esp)
  101ed2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ed6:	c7 04 24 47 6d 10 00 	movl   $0x106d47,(%esp)
  101edd:	e8 a5 e3 ff ff       	call   100287 <cprintf>
		switch (c) {
  101ee2:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101ee6:	83 f8 30             	cmp    $0x30,%eax
  101ee9:	74 0e                	je     101ef9 <trap_dispatch+0x11d>
  101eeb:	83 f8 33             	cmp    $0x33,%eax
  101eee:	0f 84 29 01 00 00    	je     10201d <trap_dispatch+0x241>
        break;
  101ef4:	e9 3d 03 00 00       	jmp    102236 <loop+0x1df>
				if (!trap_in_kernel(tf)) {
  101ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  101efc:	89 04 24             	mov    %eax,(%esp)
  101eff:	e8 58 fc ff ff       	call   101b5c <trap_in_kernel>
  101f04:	85 c0                	test   %eax,%eax
  101f06:	0f 85 b9 01 00 00    	jne    1020c5 <loop+0x6e>
					tf->tf_cs = KERNEL_CS;
  101f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  101f0f:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
					tf->tf_ds = tf->tf_es = tf->tf_gs = tf->tf_fs = KERNEL_DS;
  101f15:	8b 45 08             	mov    0x8(%ebp),%eax
  101f18:	66 c7 40 24 10 00    	movw   $0x10,0x24(%eax)
  101f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  101f21:	0f b7 50 24          	movzwl 0x24(%eax),%edx
  101f25:	8b 45 08             	mov    0x8(%ebp),%eax
  101f28:	66 89 50 20          	mov    %dx,0x20(%eax)
  101f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  101f2f:	0f b7 50 20          	movzwl 0x20(%eax),%edx
  101f33:	8b 45 08             	mov    0x8(%ebp),%eax
  101f36:	66 89 50 28          	mov    %dx,0x28(%eax)
  101f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  101f3d:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101f41:	8b 45 08             	mov    0x8(%ebp),%eax
  101f44:	66 89 50 2c          	mov    %dx,0x2c(%eax)
					tf->tf_eflags &= ~FL_IOPL_MASK;
  101f48:	8b 45 08             	mov    0x8(%ebp),%eax
  101f4b:	8b 40 40             	mov    0x40(%eax),%eax
  101f4e:	25 ff cf ff ff       	and    $0xffffcfff,%eax
  101f53:	89 c2                	mov    %eax,%edx
  101f55:	8b 45 08             	mov    0x8(%ebp),%eax
  101f58:	89 50 40             	mov    %edx,0x40(%eax)
					uintptr_t user_stack_ptr = (uintptr_t)tf->tf_esp;
  101f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  101f5e:	8b 40 44             	mov    0x44(%eax),%eax
  101f61:	89 45 e0             	mov    %eax,-0x20(%ebp)
					tf->tf_esp = *((uint32_t *) user_stack_ptr);
  101f64:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101f67:	8b 10                	mov    (%eax),%edx
  101f69:	8b 45 08             	mov    0x8(%ebp),%eax
  101f6c:	89 50 44             	mov    %edx,0x44(%eax)
					tf->tf_ss = *((uint16_t *) (user_stack_ptr + 4));
  101f6f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101f72:	83 c0 04             	add    $0x4,%eax
  101f75:	0f b7 10             	movzwl (%eax),%edx
  101f78:	8b 45 08             	mov    0x8(%ebp),%eax
  101f7b:	66 89 50 48          	mov    %dx,0x48(%eax)
					tf->tf_padding0 = *((uint16_t *) (user_stack_ptr + 6));
  101f7f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101f82:	83 c0 06             	add    $0x6,%eax
  101f85:	0f b7 10             	movzwl (%eax),%edx
  101f88:	8b 45 08             	mov    0x8(%ebp),%eax
  101f8b:	66 89 50 22          	mov    %dx,0x22(%eax)
					user_stack_ptr -= (uintptr_t) (sizeof(struct trapframe) - 8);
  101f8f:	83 6d e0 44          	subl   $0x44,-0x20(%ebp)
					*((struct trapframe *) user_stack_ptr) = *tf;
  101f93:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101f96:	8b 55 08             	mov    0x8(%ebp),%edx
  101f99:	bb 4c 00 00 00       	mov    $0x4c,%ebx
  101f9e:	89 c1                	mov    %eax,%ecx
  101fa0:	83 e1 01             	and    $0x1,%ecx
  101fa3:	85 c9                	test   %ecx,%ecx
  101fa5:	74 0c                	je     101fb3 <trap_dispatch+0x1d7>
  101fa7:	0f b6 0a             	movzbl (%edx),%ecx
  101faa:	88 08                	mov    %cl,(%eax)
  101fac:	8d 40 01             	lea    0x1(%eax),%eax
  101faf:	8d 52 01             	lea    0x1(%edx),%edx
  101fb2:	4b                   	dec    %ebx
  101fb3:	89 c1                	mov    %eax,%ecx
  101fb5:	83 e1 02             	and    $0x2,%ecx
  101fb8:	85 c9                	test   %ecx,%ecx
  101fba:	74 0f                	je     101fcb <trap_dispatch+0x1ef>
  101fbc:	0f b7 0a             	movzwl (%edx),%ecx
  101fbf:	66 89 08             	mov    %cx,(%eax)
  101fc2:	8d 40 02             	lea    0x2(%eax),%eax
  101fc5:	8d 52 02             	lea    0x2(%edx),%edx
  101fc8:	83 eb 02             	sub    $0x2,%ebx
  101fcb:	89 df                	mov    %ebx,%edi
  101fcd:	83 e7 fc             	and    $0xfffffffc,%edi
  101fd0:	b9 00 00 00 00       	mov    $0x0,%ecx
  101fd5:	8b 34 0a             	mov    (%edx,%ecx,1),%esi
  101fd8:	89 34 08             	mov    %esi,(%eax,%ecx,1)
  101fdb:	83 c1 04             	add    $0x4,%ecx
  101fde:	39 f9                	cmp    %edi,%ecx
  101fe0:	72 f3                	jb     101fd5 <trap_dispatch+0x1f9>
  101fe2:	01 c8                	add    %ecx,%eax
  101fe4:	01 ca                	add    %ecx,%edx
  101fe6:	b9 00 00 00 00       	mov    $0x0,%ecx
  101feb:	89 de                	mov    %ebx,%esi
  101fed:	83 e6 02             	and    $0x2,%esi
  101ff0:	85 f6                	test   %esi,%esi
  101ff2:	74 0b                	je     101fff <trap_dispatch+0x223>
  101ff4:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
  101ff8:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
  101ffc:	83 c1 02             	add    $0x2,%ecx
  101fff:	83 e3 01             	and    $0x1,%ebx
  102002:	85 db                	test   %ebx,%ebx
  102004:	74 07                	je     10200d <trap_dispatch+0x231>
  102006:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
  10200a:	88 14 08             	mov    %dl,(%eax,%ecx,1)
						:"a" ((uint32_t) tf),
  10200d:	8b 45 08             	mov    0x8(%ebp),%eax
					__asm__ __volatile__ (
  102010:	8b 55 e0             	mov    -0x20(%ebp),%edx
  102013:	89 d3                	mov    %edx,%ebx
  102015:	89 58 fc             	mov    %ebx,-0x4(%eax)
				break;
  102018:	e9 a8 00 00 00       	jmp    1020c5 <loop+0x6e>
				if (trap_in_kernel(tf)) {
  10201d:	8b 45 08             	mov    0x8(%ebp),%eax
  102020:	89 04 24             	mov    %eax,(%esp)
  102023:	e8 34 fb ff ff       	call   101b5c <trap_in_kernel>
  102028:	85 c0                	test   %eax,%eax
  10202a:	0f 84 9b 00 00 00    	je     1020cb <loop+0x74>
						:"a" ((uint32_t)(&tf->tf_esp)),
  102030:	8b 45 08             	mov    0x8(%ebp),%eax
  102033:	83 c0 44             	add    $0x44,%eax
						 "d" ((uint32_t)(tf)),
  102036:	8b 55 08             	mov    0x8(%ebp),%edx
					__asm__ __volatile__ (
  102039:	56                   	push   %esi
  10203a:	57                   	push   %edi
  10203b:	53                   	push   %ebx
  10203c:	83 6a fc 08          	subl   $0x8,-0x4(%edx)
  102040:	89 e6                	mov    %esp,%esi
  102042:	89 c1                	mov    %eax,%ecx
  102044:	29 f1                	sub    %esi,%ecx
  102046:	41                   	inc    %ecx
  102047:	89 e7                	mov    %esp,%edi
  102049:	83 ef 08             	sub    $0x8,%edi
  10204c:	fc                   	cld    
  10204d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10204f:	83 ec 08             	sub    $0x8,%esp
  102052:	83 ed 08             	sub    $0x8,%ebp
  102055:	89 eb                	mov    %ebp,%ebx

00102057 <loop>:
  102057:	83 2b 08             	subl   $0x8,(%ebx)
  10205a:	8b 1b                	mov    (%ebx),%ebx
  10205c:	39 d8                	cmp    %ebx,%eax
  10205e:	7f f7                	jg     102057 <loop>
  102060:	89 40 f8             	mov    %eax,-0x8(%eax)
  102063:	c7 40 fc 23 00 00 00 	movl   $0x23,-0x4(%eax)
  10206a:	5b                   	pop    %ebx
  10206b:	5f                   	pop    %edi
  10206c:	5e                   	pop    %esi
					correct_tf->tf_cs = USER_CS;
  10206d:	a1 80 de 11 00       	mov    0x11de80,%eax
  102072:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
					correct_tf->tf_ds = tf->tf_es = tf->tf_gs = tf->tf_fs = USER_DS;
  102078:	8b 45 08             	mov    0x8(%ebp),%eax
  10207b:	66 c7 40 24 23 00    	movw   $0x23,0x24(%eax)
  102081:	8b 45 08             	mov    0x8(%ebp),%eax
  102084:	0f b7 50 24          	movzwl 0x24(%eax),%edx
  102088:	8b 45 08             	mov    0x8(%ebp),%eax
  10208b:	66 89 50 20          	mov    %dx,0x20(%eax)
  10208f:	8b 45 08             	mov    0x8(%ebp),%eax
  102092:	0f b7 50 20          	movzwl 0x20(%eax),%edx
  102096:	8b 45 08             	mov    0x8(%ebp),%eax
  102099:	66 89 50 28          	mov    %dx,0x28(%eax)
  10209d:	a1 80 de 11 00       	mov    0x11de80,%eax
  1020a2:	8b 55 08             	mov    0x8(%ebp),%edx
  1020a5:	0f b7 52 28          	movzwl 0x28(%edx),%edx
  1020a9:	66 89 50 2c          	mov    %dx,0x2c(%eax)
					correct_tf->tf_eflags |= FL_IOPL_MASK;
  1020ad:	a1 80 de 11 00       	mov    0x11de80,%eax
  1020b2:	8b 50 40             	mov    0x40(%eax),%edx
  1020b5:	a1 80 de 11 00       	mov    0x11de80,%eax
  1020ba:	81 ca 00 30 00 00    	or     $0x3000,%edx
  1020c0:	89 50 40             	mov    %edx,0x40(%eax)
				break;
  1020c3:	eb 06                	jmp    1020cb <loop+0x74>
				break;
  1020c5:	90                   	nop
  1020c6:	e9 6b 01 00 00       	jmp    102236 <loop+0x1df>
				break;
  1020cb:	90                   	nop
        break;
  1020cc:	e9 65 01 00 00       	jmp    102236 <loop+0x1df>
		if ((tf->tf_cs & 3) == 0) {
  1020d1:	8b 45 08             	mov    0x8(%ebp),%eax
  1020d4:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  1020d8:	83 e0 03             	and    $0x3,%eax
  1020db:	85 c0                	test   %eax,%eax
  1020dd:	0f 85 4f 01 00 00    	jne    102232 <loop+0x1db>
			tf->tf_cs = USER_CS;
  1020e3:	8b 45 08             	mov    0x8(%ebp),%eax
  1020e6:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
			tf->tf_ss = tf->tf_ds = tf->tf_es = tf->tf_gs = tf->tf_fs = USER_DS;
  1020ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1020ef:	66 c7 40 24 23 00    	movw   $0x23,0x24(%eax)
  1020f5:	8b 45 08             	mov    0x8(%ebp),%eax
  1020f8:	0f b7 50 24          	movzwl 0x24(%eax),%edx
  1020fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1020ff:	66 89 50 20          	mov    %dx,0x20(%eax)
  102103:	8b 45 08             	mov    0x8(%ebp),%eax
  102106:	0f b7 50 20          	movzwl 0x20(%eax),%edx
  10210a:	8b 45 08             	mov    0x8(%ebp),%eax
  10210d:	66 89 50 28          	mov    %dx,0x28(%eax)
  102111:	8b 45 08             	mov    0x8(%ebp),%eax
  102114:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  102118:	8b 45 08             	mov    0x8(%ebp),%eax
  10211b:	66 89 50 2c          	mov    %dx,0x2c(%eax)
  10211f:	8b 45 08             	mov    0x8(%ebp),%eax
  102122:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
  102126:	8b 45 08             	mov    0x8(%ebp),%eax
  102129:	66 89 50 48          	mov    %dx,0x48(%eax)
			tf->tf_esp += 4;
  10212d:	8b 45 08             	mov    0x8(%ebp),%eax
  102130:	8b 40 44             	mov    0x44(%eax),%eax
  102133:	8d 50 04             	lea    0x4(%eax),%edx
  102136:	8b 45 08             	mov    0x8(%ebp),%eax
  102139:	89 50 44             	mov    %edx,0x44(%eax)
			tf->tf_eflags |= FL_IOPL_MASK;
  10213c:	8b 45 08             	mov    0x8(%ebp),%eax
  10213f:	8b 40 40             	mov    0x40(%eax),%eax
  102142:	0d 00 30 00 00       	or     $0x3000,%eax
  102147:	89 c2                	mov    %eax,%edx
  102149:	8b 45 08             	mov    0x8(%ebp),%eax
  10214c:	89 50 40             	mov    %edx,0x40(%eax)
		break;
  10214f:	e9 de 00 00 00       	jmp    102232 <loop+0x1db>
		if ((tf->tf_cs & 3) != 0) {
  102154:	8b 45 08             	mov    0x8(%ebp),%eax
  102157:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  10215b:	83 e0 03             	and    $0x3,%eax
  10215e:	85 c0                	test   %eax,%eax
  102160:	0f 84 cf 00 00 00    	je     102235 <loop+0x1de>
			tf->tf_cs = KERNEL_CS;
  102166:	8b 45 08             	mov    0x8(%ebp),%eax
  102169:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
			tf->tf_ss = tf->tf_ds = tf->tf_es = tf->tf_gs = tf->tf_fs = KERNEL_DS;
  10216f:	8b 45 08             	mov    0x8(%ebp),%eax
  102172:	66 c7 40 24 10 00    	movw   $0x10,0x24(%eax)
  102178:	8b 45 08             	mov    0x8(%ebp),%eax
  10217b:	0f b7 50 24          	movzwl 0x24(%eax),%edx
  10217f:	8b 45 08             	mov    0x8(%ebp),%eax
  102182:	66 89 50 20          	mov    %dx,0x20(%eax)
  102186:	8b 45 08             	mov    0x8(%ebp),%eax
  102189:	0f b7 50 20          	movzwl 0x20(%eax),%edx
  10218d:	8b 45 08             	mov    0x8(%ebp),%eax
  102190:	66 89 50 28          	mov    %dx,0x28(%eax)
  102194:	8b 45 08             	mov    0x8(%ebp),%eax
  102197:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  10219b:	8b 45 08             	mov    0x8(%ebp),%eax
  10219e:	66 89 50 2c          	mov    %dx,0x2c(%eax)
  1021a2:	8b 45 08             	mov    0x8(%ebp),%eax
  1021a5:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
  1021a9:	8b 45 08             	mov    0x8(%ebp),%eax
  1021ac:	66 89 50 48          	mov    %dx,0x48(%eax)
			tf->tf_eflags &= ~FL_IOPL_MASK;
  1021b0:	8b 45 08             	mov    0x8(%ebp),%eax
  1021b3:	8b 40 40             	mov    0x40(%eax),%eax
  1021b6:	25 ff cf ff ff       	and    $0xffffcfff,%eax
  1021bb:	89 c2                	mov    %eax,%edx
  1021bd:	8b 45 08             	mov    0x8(%ebp),%eax
  1021c0:	89 50 40             	mov    %edx,0x40(%eax)
			break;
  1021c3:	eb 70                	jmp    102235 <loop+0x1de>
	case T_GPFLT:
		cprintf("GP Fault!!!\n");
  1021c5:	c7 04 24 56 6d 10 00 	movl   $0x106d56,(%esp)
  1021cc:	e8 b6 e0 ff ff       	call   100287 <cprintf>
		print_trapframe(tf);
  1021d1:	8b 45 08             	mov    0x8(%ebp),%eax
  1021d4:	89 04 24             	mov    %eax,(%esp)
  1021d7:	e8 95 f9 ff ff       	call   101b71 <print_trapframe>
		break;
  1021dc:	eb 58                	jmp    102236 <loop+0x1df>
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  1021de:	8b 45 08             	mov    0x8(%ebp),%eax
  1021e1:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  1021e5:	83 e0 03             	and    $0x3,%eax
  1021e8:	85 c0                	test   %eax,%eax
  1021ea:	75 27                	jne    102213 <loop+0x1bc>
            print_trapframe(tf);
  1021ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1021ef:	89 04 24             	mov    %eax,(%esp)
  1021f2:	e8 7a f9 ff ff       	call   101b71 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  1021f7:	c7 44 24 08 63 6d 10 	movl   $0x106d63,0x8(%esp)
  1021fe:	00 
  1021ff:	c7 44 24 04 36 01 00 	movl   $0x136,0x4(%esp)
  102206:	00 
  102207:	c7 04 24 7f 6d 10 00 	movl   $0x106d7f,(%esp)
  10220e:	e8 cc e1 ff ff       	call   1003df <__panic>
        }
		else 
			panic("unexpected trap \n");
  102213:	c7 44 24 08 90 6d 10 	movl   $0x106d90,0x8(%esp)
  10221a:	00 
  10221b:	c7 44 24 04 39 01 00 	movl   $0x139,0x4(%esp)
  102222:	00 
  102223:	c7 04 24 7f 6d 10 00 	movl   $0x106d7f,(%esp)
  10222a:	e8 b0 e1 ff ff       	call   1003df <__panic>
        break;
  10222f:	90                   	nop
  102230:	eb 04                	jmp    102236 <loop+0x1df>
		break;
  102232:	90                   	nop
  102233:	eb 01                	jmp    102236 <loop+0x1df>
			break;
  102235:	90                   	nop
    }
}
  102236:	90                   	nop
  102237:	83 c4 2c             	add    $0x2c,%esp
  10223a:	5b                   	pop    %ebx
  10223b:	5e                   	pop    %esi
  10223c:	5f                   	pop    %edi
  10223d:	5d                   	pop    %ebp
  10223e:	c3                   	ret    

0010223f <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  10223f:	55                   	push   %ebp
  102240:	89 e5                	mov    %esp,%ebp
  102242:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  102245:	8b 45 08             	mov    0x8(%ebp),%eax
  102248:	89 04 24             	mov    %eax,(%esp)
  10224b:	e8 8c fb ff ff       	call   101ddc <trap_dispatch>
}
  102250:	90                   	nop
  102251:	c9                   	leave  
  102252:	c3                   	ret    

00102253 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  102253:	6a 00                	push   $0x0
  pushl $0
  102255:	6a 00                	push   $0x0
  jmp __alltraps
  102257:	e9 69 0a 00 00       	jmp    102cc5 <__alltraps>

0010225c <vector1>:
.globl vector1
vector1:
  pushl $0
  10225c:	6a 00                	push   $0x0
  pushl $1
  10225e:	6a 01                	push   $0x1
  jmp __alltraps
  102260:	e9 60 0a 00 00       	jmp    102cc5 <__alltraps>

00102265 <vector2>:
.globl vector2
vector2:
  pushl $0
  102265:	6a 00                	push   $0x0
  pushl $2
  102267:	6a 02                	push   $0x2
  jmp __alltraps
  102269:	e9 57 0a 00 00       	jmp    102cc5 <__alltraps>

0010226e <vector3>:
.globl vector3
vector3:
  pushl $0
  10226e:	6a 00                	push   $0x0
  pushl $3
  102270:	6a 03                	push   $0x3
  jmp __alltraps
  102272:	e9 4e 0a 00 00       	jmp    102cc5 <__alltraps>

00102277 <vector4>:
.globl vector4
vector4:
  pushl $0
  102277:	6a 00                	push   $0x0
  pushl $4
  102279:	6a 04                	push   $0x4
  jmp __alltraps
  10227b:	e9 45 0a 00 00       	jmp    102cc5 <__alltraps>

00102280 <vector5>:
.globl vector5
vector5:
  pushl $0
  102280:	6a 00                	push   $0x0
  pushl $5
  102282:	6a 05                	push   $0x5
  jmp __alltraps
  102284:	e9 3c 0a 00 00       	jmp    102cc5 <__alltraps>

00102289 <vector6>:
.globl vector6
vector6:
  pushl $0
  102289:	6a 00                	push   $0x0
  pushl $6
  10228b:	6a 06                	push   $0x6
  jmp __alltraps
  10228d:	e9 33 0a 00 00       	jmp    102cc5 <__alltraps>

00102292 <vector7>:
.globl vector7
vector7:
  pushl $0
  102292:	6a 00                	push   $0x0
  pushl $7
  102294:	6a 07                	push   $0x7
  jmp __alltraps
  102296:	e9 2a 0a 00 00       	jmp    102cc5 <__alltraps>

0010229b <vector8>:
.globl vector8
vector8:
  pushl $8
  10229b:	6a 08                	push   $0x8
  jmp __alltraps
  10229d:	e9 23 0a 00 00       	jmp    102cc5 <__alltraps>

001022a2 <vector9>:
.globl vector9
vector9:
  pushl $0
  1022a2:	6a 00                	push   $0x0
  pushl $9
  1022a4:	6a 09                	push   $0x9
  jmp __alltraps
  1022a6:	e9 1a 0a 00 00       	jmp    102cc5 <__alltraps>

001022ab <vector10>:
.globl vector10
vector10:
  pushl $10
  1022ab:	6a 0a                	push   $0xa
  jmp __alltraps
  1022ad:	e9 13 0a 00 00       	jmp    102cc5 <__alltraps>

001022b2 <vector11>:
.globl vector11
vector11:
  pushl $11
  1022b2:	6a 0b                	push   $0xb
  jmp __alltraps
  1022b4:	e9 0c 0a 00 00       	jmp    102cc5 <__alltraps>

001022b9 <vector12>:
.globl vector12
vector12:
  pushl $12
  1022b9:	6a 0c                	push   $0xc
  jmp __alltraps
  1022bb:	e9 05 0a 00 00       	jmp    102cc5 <__alltraps>

001022c0 <vector13>:
.globl vector13
vector13:
  pushl $13
  1022c0:	6a 0d                	push   $0xd
  jmp __alltraps
  1022c2:	e9 fe 09 00 00       	jmp    102cc5 <__alltraps>

001022c7 <vector14>:
.globl vector14
vector14:
  pushl $14
  1022c7:	6a 0e                	push   $0xe
  jmp __alltraps
  1022c9:	e9 f7 09 00 00       	jmp    102cc5 <__alltraps>

001022ce <vector15>:
.globl vector15
vector15:
  pushl $0
  1022ce:	6a 00                	push   $0x0
  pushl $15
  1022d0:	6a 0f                	push   $0xf
  jmp __alltraps
  1022d2:	e9 ee 09 00 00       	jmp    102cc5 <__alltraps>

001022d7 <vector16>:
.globl vector16
vector16:
  pushl $0
  1022d7:	6a 00                	push   $0x0
  pushl $16
  1022d9:	6a 10                	push   $0x10
  jmp __alltraps
  1022db:	e9 e5 09 00 00       	jmp    102cc5 <__alltraps>

001022e0 <vector17>:
.globl vector17
vector17:
  pushl $17
  1022e0:	6a 11                	push   $0x11
  jmp __alltraps
  1022e2:	e9 de 09 00 00       	jmp    102cc5 <__alltraps>

001022e7 <vector18>:
.globl vector18
vector18:
  pushl $0
  1022e7:	6a 00                	push   $0x0
  pushl $18
  1022e9:	6a 12                	push   $0x12
  jmp __alltraps
  1022eb:	e9 d5 09 00 00       	jmp    102cc5 <__alltraps>

001022f0 <vector19>:
.globl vector19
vector19:
  pushl $0
  1022f0:	6a 00                	push   $0x0
  pushl $19
  1022f2:	6a 13                	push   $0x13
  jmp __alltraps
  1022f4:	e9 cc 09 00 00       	jmp    102cc5 <__alltraps>

001022f9 <vector20>:
.globl vector20
vector20:
  pushl $0
  1022f9:	6a 00                	push   $0x0
  pushl $20
  1022fb:	6a 14                	push   $0x14
  jmp __alltraps
  1022fd:	e9 c3 09 00 00       	jmp    102cc5 <__alltraps>

00102302 <vector21>:
.globl vector21
vector21:
  pushl $0
  102302:	6a 00                	push   $0x0
  pushl $21
  102304:	6a 15                	push   $0x15
  jmp __alltraps
  102306:	e9 ba 09 00 00       	jmp    102cc5 <__alltraps>

0010230b <vector22>:
.globl vector22
vector22:
  pushl $0
  10230b:	6a 00                	push   $0x0
  pushl $22
  10230d:	6a 16                	push   $0x16
  jmp __alltraps
  10230f:	e9 b1 09 00 00       	jmp    102cc5 <__alltraps>

00102314 <vector23>:
.globl vector23
vector23:
  pushl $0
  102314:	6a 00                	push   $0x0
  pushl $23
  102316:	6a 17                	push   $0x17
  jmp __alltraps
  102318:	e9 a8 09 00 00       	jmp    102cc5 <__alltraps>

0010231d <vector24>:
.globl vector24
vector24:
  pushl $0
  10231d:	6a 00                	push   $0x0
  pushl $24
  10231f:	6a 18                	push   $0x18
  jmp __alltraps
  102321:	e9 9f 09 00 00       	jmp    102cc5 <__alltraps>

00102326 <vector25>:
.globl vector25
vector25:
  pushl $0
  102326:	6a 00                	push   $0x0
  pushl $25
  102328:	6a 19                	push   $0x19
  jmp __alltraps
  10232a:	e9 96 09 00 00       	jmp    102cc5 <__alltraps>

0010232f <vector26>:
.globl vector26
vector26:
  pushl $0
  10232f:	6a 00                	push   $0x0
  pushl $26
  102331:	6a 1a                	push   $0x1a
  jmp __alltraps
  102333:	e9 8d 09 00 00       	jmp    102cc5 <__alltraps>

00102338 <vector27>:
.globl vector27
vector27:
  pushl $0
  102338:	6a 00                	push   $0x0
  pushl $27
  10233a:	6a 1b                	push   $0x1b
  jmp __alltraps
  10233c:	e9 84 09 00 00       	jmp    102cc5 <__alltraps>

00102341 <vector28>:
.globl vector28
vector28:
  pushl $0
  102341:	6a 00                	push   $0x0
  pushl $28
  102343:	6a 1c                	push   $0x1c
  jmp __alltraps
  102345:	e9 7b 09 00 00       	jmp    102cc5 <__alltraps>

0010234a <vector29>:
.globl vector29
vector29:
  pushl $0
  10234a:	6a 00                	push   $0x0
  pushl $29
  10234c:	6a 1d                	push   $0x1d
  jmp __alltraps
  10234e:	e9 72 09 00 00       	jmp    102cc5 <__alltraps>

00102353 <vector30>:
.globl vector30
vector30:
  pushl $0
  102353:	6a 00                	push   $0x0
  pushl $30
  102355:	6a 1e                	push   $0x1e
  jmp __alltraps
  102357:	e9 69 09 00 00       	jmp    102cc5 <__alltraps>

0010235c <vector31>:
.globl vector31
vector31:
  pushl $0
  10235c:	6a 00                	push   $0x0
  pushl $31
  10235e:	6a 1f                	push   $0x1f
  jmp __alltraps
  102360:	e9 60 09 00 00       	jmp    102cc5 <__alltraps>

00102365 <vector32>:
.globl vector32
vector32:
  pushl $0
  102365:	6a 00                	push   $0x0
  pushl $32
  102367:	6a 20                	push   $0x20
  jmp __alltraps
  102369:	e9 57 09 00 00       	jmp    102cc5 <__alltraps>

0010236e <vector33>:
.globl vector33
vector33:
  pushl $0
  10236e:	6a 00                	push   $0x0
  pushl $33
  102370:	6a 21                	push   $0x21
  jmp __alltraps
  102372:	e9 4e 09 00 00       	jmp    102cc5 <__alltraps>

00102377 <vector34>:
.globl vector34
vector34:
  pushl $0
  102377:	6a 00                	push   $0x0
  pushl $34
  102379:	6a 22                	push   $0x22
  jmp __alltraps
  10237b:	e9 45 09 00 00       	jmp    102cc5 <__alltraps>

00102380 <vector35>:
.globl vector35
vector35:
  pushl $0
  102380:	6a 00                	push   $0x0
  pushl $35
  102382:	6a 23                	push   $0x23
  jmp __alltraps
  102384:	e9 3c 09 00 00       	jmp    102cc5 <__alltraps>

00102389 <vector36>:
.globl vector36
vector36:
  pushl $0
  102389:	6a 00                	push   $0x0
  pushl $36
  10238b:	6a 24                	push   $0x24
  jmp __alltraps
  10238d:	e9 33 09 00 00       	jmp    102cc5 <__alltraps>

00102392 <vector37>:
.globl vector37
vector37:
  pushl $0
  102392:	6a 00                	push   $0x0
  pushl $37
  102394:	6a 25                	push   $0x25
  jmp __alltraps
  102396:	e9 2a 09 00 00       	jmp    102cc5 <__alltraps>

0010239b <vector38>:
.globl vector38
vector38:
  pushl $0
  10239b:	6a 00                	push   $0x0
  pushl $38
  10239d:	6a 26                	push   $0x26
  jmp __alltraps
  10239f:	e9 21 09 00 00       	jmp    102cc5 <__alltraps>

001023a4 <vector39>:
.globl vector39
vector39:
  pushl $0
  1023a4:	6a 00                	push   $0x0
  pushl $39
  1023a6:	6a 27                	push   $0x27
  jmp __alltraps
  1023a8:	e9 18 09 00 00       	jmp    102cc5 <__alltraps>

001023ad <vector40>:
.globl vector40
vector40:
  pushl $0
  1023ad:	6a 00                	push   $0x0
  pushl $40
  1023af:	6a 28                	push   $0x28
  jmp __alltraps
  1023b1:	e9 0f 09 00 00       	jmp    102cc5 <__alltraps>

001023b6 <vector41>:
.globl vector41
vector41:
  pushl $0
  1023b6:	6a 00                	push   $0x0
  pushl $41
  1023b8:	6a 29                	push   $0x29
  jmp __alltraps
  1023ba:	e9 06 09 00 00       	jmp    102cc5 <__alltraps>

001023bf <vector42>:
.globl vector42
vector42:
  pushl $0
  1023bf:	6a 00                	push   $0x0
  pushl $42
  1023c1:	6a 2a                	push   $0x2a
  jmp __alltraps
  1023c3:	e9 fd 08 00 00       	jmp    102cc5 <__alltraps>

001023c8 <vector43>:
.globl vector43
vector43:
  pushl $0
  1023c8:	6a 00                	push   $0x0
  pushl $43
  1023ca:	6a 2b                	push   $0x2b
  jmp __alltraps
  1023cc:	e9 f4 08 00 00       	jmp    102cc5 <__alltraps>

001023d1 <vector44>:
.globl vector44
vector44:
  pushl $0
  1023d1:	6a 00                	push   $0x0
  pushl $44
  1023d3:	6a 2c                	push   $0x2c
  jmp __alltraps
  1023d5:	e9 eb 08 00 00       	jmp    102cc5 <__alltraps>

001023da <vector45>:
.globl vector45
vector45:
  pushl $0
  1023da:	6a 00                	push   $0x0
  pushl $45
  1023dc:	6a 2d                	push   $0x2d
  jmp __alltraps
  1023de:	e9 e2 08 00 00       	jmp    102cc5 <__alltraps>

001023e3 <vector46>:
.globl vector46
vector46:
  pushl $0
  1023e3:	6a 00                	push   $0x0
  pushl $46
  1023e5:	6a 2e                	push   $0x2e
  jmp __alltraps
  1023e7:	e9 d9 08 00 00       	jmp    102cc5 <__alltraps>

001023ec <vector47>:
.globl vector47
vector47:
  pushl $0
  1023ec:	6a 00                	push   $0x0
  pushl $47
  1023ee:	6a 2f                	push   $0x2f
  jmp __alltraps
  1023f0:	e9 d0 08 00 00       	jmp    102cc5 <__alltraps>

001023f5 <vector48>:
.globl vector48
vector48:
  pushl $0
  1023f5:	6a 00                	push   $0x0
  pushl $48
  1023f7:	6a 30                	push   $0x30
  jmp __alltraps
  1023f9:	e9 c7 08 00 00       	jmp    102cc5 <__alltraps>

001023fe <vector49>:
.globl vector49
vector49:
  pushl $0
  1023fe:	6a 00                	push   $0x0
  pushl $49
  102400:	6a 31                	push   $0x31
  jmp __alltraps
  102402:	e9 be 08 00 00       	jmp    102cc5 <__alltraps>

00102407 <vector50>:
.globl vector50
vector50:
  pushl $0
  102407:	6a 00                	push   $0x0
  pushl $50
  102409:	6a 32                	push   $0x32
  jmp __alltraps
  10240b:	e9 b5 08 00 00       	jmp    102cc5 <__alltraps>

00102410 <vector51>:
.globl vector51
vector51:
  pushl $0
  102410:	6a 00                	push   $0x0
  pushl $51
  102412:	6a 33                	push   $0x33
  jmp __alltraps
  102414:	e9 ac 08 00 00       	jmp    102cc5 <__alltraps>

00102419 <vector52>:
.globl vector52
vector52:
  pushl $0
  102419:	6a 00                	push   $0x0
  pushl $52
  10241b:	6a 34                	push   $0x34
  jmp __alltraps
  10241d:	e9 a3 08 00 00       	jmp    102cc5 <__alltraps>

00102422 <vector53>:
.globl vector53
vector53:
  pushl $0
  102422:	6a 00                	push   $0x0
  pushl $53
  102424:	6a 35                	push   $0x35
  jmp __alltraps
  102426:	e9 9a 08 00 00       	jmp    102cc5 <__alltraps>

0010242b <vector54>:
.globl vector54
vector54:
  pushl $0
  10242b:	6a 00                	push   $0x0
  pushl $54
  10242d:	6a 36                	push   $0x36
  jmp __alltraps
  10242f:	e9 91 08 00 00       	jmp    102cc5 <__alltraps>

00102434 <vector55>:
.globl vector55
vector55:
  pushl $0
  102434:	6a 00                	push   $0x0
  pushl $55
  102436:	6a 37                	push   $0x37
  jmp __alltraps
  102438:	e9 88 08 00 00       	jmp    102cc5 <__alltraps>

0010243d <vector56>:
.globl vector56
vector56:
  pushl $0
  10243d:	6a 00                	push   $0x0
  pushl $56
  10243f:	6a 38                	push   $0x38
  jmp __alltraps
  102441:	e9 7f 08 00 00       	jmp    102cc5 <__alltraps>

00102446 <vector57>:
.globl vector57
vector57:
  pushl $0
  102446:	6a 00                	push   $0x0
  pushl $57
  102448:	6a 39                	push   $0x39
  jmp __alltraps
  10244a:	e9 76 08 00 00       	jmp    102cc5 <__alltraps>

0010244f <vector58>:
.globl vector58
vector58:
  pushl $0
  10244f:	6a 00                	push   $0x0
  pushl $58
  102451:	6a 3a                	push   $0x3a
  jmp __alltraps
  102453:	e9 6d 08 00 00       	jmp    102cc5 <__alltraps>

00102458 <vector59>:
.globl vector59
vector59:
  pushl $0
  102458:	6a 00                	push   $0x0
  pushl $59
  10245a:	6a 3b                	push   $0x3b
  jmp __alltraps
  10245c:	e9 64 08 00 00       	jmp    102cc5 <__alltraps>

00102461 <vector60>:
.globl vector60
vector60:
  pushl $0
  102461:	6a 00                	push   $0x0
  pushl $60
  102463:	6a 3c                	push   $0x3c
  jmp __alltraps
  102465:	e9 5b 08 00 00       	jmp    102cc5 <__alltraps>

0010246a <vector61>:
.globl vector61
vector61:
  pushl $0
  10246a:	6a 00                	push   $0x0
  pushl $61
  10246c:	6a 3d                	push   $0x3d
  jmp __alltraps
  10246e:	e9 52 08 00 00       	jmp    102cc5 <__alltraps>

00102473 <vector62>:
.globl vector62
vector62:
  pushl $0
  102473:	6a 00                	push   $0x0
  pushl $62
  102475:	6a 3e                	push   $0x3e
  jmp __alltraps
  102477:	e9 49 08 00 00       	jmp    102cc5 <__alltraps>

0010247c <vector63>:
.globl vector63
vector63:
  pushl $0
  10247c:	6a 00                	push   $0x0
  pushl $63
  10247e:	6a 3f                	push   $0x3f
  jmp __alltraps
  102480:	e9 40 08 00 00       	jmp    102cc5 <__alltraps>

00102485 <vector64>:
.globl vector64
vector64:
  pushl $0
  102485:	6a 00                	push   $0x0
  pushl $64
  102487:	6a 40                	push   $0x40
  jmp __alltraps
  102489:	e9 37 08 00 00       	jmp    102cc5 <__alltraps>

0010248e <vector65>:
.globl vector65
vector65:
  pushl $0
  10248e:	6a 00                	push   $0x0
  pushl $65
  102490:	6a 41                	push   $0x41
  jmp __alltraps
  102492:	e9 2e 08 00 00       	jmp    102cc5 <__alltraps>

00102497 <vector66>:
.globl vector66
vector66:
  pushl $0
  102497:	6a 00                	push   $0x0
  pushl $66
  102499:	6a 42                	push   $0x42
  jmp __alltraps
  10249b:	e9 25 08 00 00       	jmp    102cc5 <__alltraps>

001024a0 <vector67>:
.globl vector67
vector67:
  pushl $0
  1024a0:	6a 00                	push   $0x0
  pushl $67
  1024a2:	6a 43                	push   $0x43
  jmp __alltraps
  1024a4:	e9 1c 08 00 00       	jmp    102cc5 <__alltraps>

001024a9 <vector68>:
.globl vector68
vector68:
  pushl $0
  1024a9:	6a 00                	push   $0x0
  pushl $68
  1024ab:	6a 44                	push   $0x44
  jmp __alltraps
  1024ad:	e9 13 08 00 00       	jmp    102cc5 <__alltraps>

001024b2 <vector69>:
.globl vector69
vector69:
  pushl $0
  1024b2:	6a 00                	push   $0x0
  pushl $69
  1024b4:	6a 45                	push   $0x45
  jmp __alltraps
  1024b6:	e9 0a 08 00 00       	jmp    102cc5 <__alltraps>

001024bb <vector70>:
.globl vector70
vector70:
  pushl $0
  1024bb:	6a 00                	push   $0x0
  pushl $70
  1024bd:	6a 46                	push   $0x46
  jmp __alltraps
  1024bf:	e9 01 08 00 00       	jmp    102cc5 <__alltraps>

001024c4 <vector71>:
.globl vector71
vector71:
  pushl $0
  1024c4:	6a 00                	push   $0x0
  pushl $71
  1024c6:	6a 47                	push   $0x47
  jmp __alltraps
  1024c8:	e9 f8 07 00 00       	jmp    102cc5 <__alltraps>

001024cd <vector72>:
.globl vector72
vector72:
  pushl $0
  1024cd:	6a 00                	push   $0x0
  pushl $72
  1024cf:	6a 48                	push   $0x48
  jmp __alltraps
  1024d1:	e9 ef 07 00 00       	jmp    102cc5 <__alltraps>

001024d6 <vector73>:
.globl vector73
vector73:
  pushl $0
  1024d6:	6a 00                	push   $0x0
  pushl $73
  1024d8:	6a 49                	push   $0x49
  jmp __alltraps
  1024da:	e9 e6 07 00 00       	jmp    102cc5 <__alltraps>

001024df <vector74>:
.globl vector74
vector74:
  pushl $0
  1024df:	6a 00                	push   $0x0
  pushl $74
  1024e1:	6a 4a                	push   $0x4a
  jmp __alltraps
  1024e3:	e9 dd 07 00 00       	jmp    102cc5 <__alltraps>

001024e8 <vector75>:
.globl vector75
vector75:
  pushl $0
  1024e8:	6a 00                	push   $0x0
  pushl $75
  1024ea:	6a 4b                	push   $0x4b
  jmp __alltraps
  1024ec:	e9 d4 07 00 00       	jmp    102cc5 <__alltraps>

001024f1 <vector76>:
.globl vector76
vector76:
  pushl $0
  1024f1:	6a 00                	push   $0x0
  pushl $76
  1024f3:	6a 4c                	push   $0x4c
  jmp __alltraps
  1024f5:	e9 cb 07 00 00       	jmp    102cc5 <__alltraps>

001024fa <vector77>:
.globl vector77
vector77:
  pushl $0
  1024fa:	6a 00                	push   $0x0
  pushl $77
  1024fc:	6a 4d                	push   $0x4d
  jmp __alltraps
  1024fe:	e9 c2 07 00 00       	jmp    102cc5 <__alltraps>

00102503 <vector78>:
.globl vector78
vector78:
  pushl $0
  102503:	6a 00                	push   $0x0
  pushl $78
  102505:	6a 4e                	push   $0x4e
  jmp __alltraps
  102507:	e9 b9 07 00 00       	jmp    102cc5 <__alltraps>

0010250c <vector79>:
.globl vector79
vector79:
  pushl $0
  10250c:	6a 00                	push   $0x0
  pushl $79
  10250e:	6a 4f                	push   $0x4f
  jmp __alltraps
  102510:	e9 b0 07 00 00       	jmp    102cc5 <__alltraps>

00102515 <vector80>:
.globl vector80
vector80:
  pushl $0
  102515:	6a 00                	push   $0x0
  pushl $80
  102517:	6a 50                	push   $0x50
  jmp __alltraps
  102519:	e9 a7 07 00 00       	jmp    102cc5 <__alltraps>

0010251e <vector81>:
.globl vector81
vector81:
  pushl $0
  10251e:	6a 00                	push   $0x0
  pushl $81
  102520:	6a 51                	push   $0x51
  jmp __alltraps
  102522:	e9 9e 07 00 00       	jmp    102cc5 <__alltraps>

00102527 <vector82>:
.globl vector82
vector82:
  pushl $0
  102527:	6a 00                	push   $0x0
  pushl $82
  102529:	6a 52                	push   $0x52
  jmp __alltraps
  10252b:	e9 95 07 00 00       	jmp    102cc5 <__alltraps>

00102530 <vector83>:
.globl vector83
vector83:
  pushl $0
  102530:	6a 00                	push   $0x0
  pushl $83
  102532:	6a 53                	push   $0x53
  jmp __alltraps
  102534:	e9 8c 07 00 00       	jmp    102cc5 <__alltraps>

00102539 <vector84>:
.globl vector84
vector84:
  pushl $0
  102539:	6a 00                	push   $0x0
  pushl $84
  10253b:	6a 54                	push   $0x54
  jmp __alltraps
  10253d:	e9 83 07 00 00       	jmp    102cc5 <__alltraps>

00102542 <vector85>:
.globl vector85
vector85:
  pushl $0
  102542:	6a 00                	push   $0x0
  pushl $85
  102544:	6a 55                	push   $0x55
  jmp __alltraps
  102546:	e9 7a 07 00 00       	jmp    102cc5 <__alltraps>

0010254b <vector86>:
.globl vector86
vector86:
  pushl $0
  10254b:	6a 00                	push   $0x0
  pushl $86
  10254d:	6a 56                	push   $0x56
  jmp __alltraps
  10254f:	e9 71 07 00 00       	jmp    102cc5 <__alltraps>

00102554 <vector87>:
.globl vector87
vector87:
  pushl $0
  102554:	6a 00                	push   $0x0
  pushl $87
  102556:	6a 57                	push   $0x57
  jmp __alltraps
  102558:	e9 68 07 00 00       	jmp    102cc5 <__alltraps>

0010255d <vector88>:
.globl vector88
vector88:
  pushl $0
  10255d:	6a 00                	push   $0x0
  pushl $88
  10255f:	6a 58                	push   $0x58
  jmp __alltraps
  102561:	e9 5f 07 00 00       	jmp    102cc5 <__alltraps>

00102566 <vector89>:
.globl vector89
vector89:
  pushl $0
  102566:	6a 00                	push   $0x0
  pushl $89
  102568:	6a 59                	push   $0x59
  jmp __alltraps
  10256a:	e9 56 07 00 00       	jmp    102cc5 <__alltraps>

0010256f <vector90>:
.globl vector90
vector90:
  pushl $0
  10256f:	6a 00                	push   $0x0
  pushl $90
  102571:	6a 5a                	push   $0x5a
  jmp __alltraps
  102573:	e9 4d 07 00 00       	jmp    102cc5 <__alltraps>

00102578 <vector91>:
.globl vector91
vector91:
  pushl $0
  102578:	6a 00                	push   $0x0
  pushl $91
  10257a:	6a 5b                	push   $0x5b
  jmp __alltraps
  10257c:	e9 44 07 00 00       	jmp    102cc5 <__alltraps>

00102581 <vector92>:
.globl vector92
vector92:
  pushl $0
  102581:	6a 00                	push   $0x0
  pushl $92
  102583:	6a 5c                	push   $0x5c
  jmp __alltraps
  102585:	e9 3b 07 00 00       	jmp    102cc5 <__alltraps>

0010258a <vector93>:
.globl vector93
vector93:
  pushl $0
  10258a:	6a 00                	push   $0x0
  pushl $93
  10258c:	6a 5d                	push   $0x5d
  jmp __alltraps
  10258e:	e9 32 07 00 00       	jmp    102cc5 <__alltraps>

00102593 <vector94>:
.globl vector94
vector94:
  pushl $0
  102593:	6a 00                	push   $0x0
  pushl $94
  102595:	6a 5e                	push   $0x5e
  jmp __alltraps
  102597:	e9 29 07 00 00       	jmp    102cc5 <__alltraps>

0010259c <vector95>:
.globl vector95
vector95:
  pushl $0
  10259c:	6a 00                	push   $0x0
  pushl $95
  10259e:	6a 5f                	push   $0x5f
  jmp __alltraps
  1025a0:	e9 20 07 00 00       	jmp    102cc5 <__alltraps>

001025a5 <vector96>:
.globl vector96
vector96:
  pushl $0
  1025a5:	6a 00                	push   $0x0
  pushl $96
  1025a7:	6a 60                	push   $0x60
  jmp __alltraps
  1025a9:	e9 17 07 00 00       	jmp    102cc5 <__alltraps>

001025ae <vector97>:
.globl vector97
vector97:
  pushl $0
  1025ae:	6a 00                	push   $0x0
  pushl $97
  1025b0:	6a 61                	push   $0x61
  jmp __alltraps
  1025b2:	e9 0e 07 00 00       	jmp    102cc5 <__alltraps>

001025b7 <vector98>:
.globl vector98
vector98:
  pushl $0
  1025b7:	6a 00                	push   $0x0
  pushl $98
  1025b9:	6a 62                	push   $0x62
  jmp __alltraps
  1025bb:	e9 05 07 00 00       	jmp    102cc5 <__alltraps>

001025c0 <vector99>:
.globl vector99
vector99:
  pushl $0
  1025c0:	6a 00                	push   $0x0
  pushl $99
  1025c2:	6a 63                	push   $0x63
  jmp __alltraps
  1025c4:	e9 fc 06 00 00       	jmp    102cc5 <__alltraps>

001025c9 <vector100>:
.globl vector100
vector100:
  pushl $0
  1025c9:	6a 00                	push   $0x0
  pushl $100
  1025cb:	6a 64                	push   $0x64
  jmp __alltraps
  1025cd:	e9 f3 06 00 00       	jmp    102cc5 <__alltraps>

001025d2 <vector101>:
.globl vector101
vector101:
  pushl $0
  1025d2:	6a 00                	push   $0x0
  pushl $101
  1025d4:	6a 65                	push   $0x65
  jmp __alltraps
  1025d6:	e9 ea 06 00 00       	jmp    102cc5 <__alltraps>

001025db <vector102>:
.globl vector102
vector102:
  pushl $0
  1025db:	6a 00                	push   $0x0
  pushl $102
  1025dd:	6a 66                	push   $0x66
  jmp __alltraps
  1025df:	e9 e1 06 00 00       	jmp    102cc5 <__alltraps>

001025e4 <vector103>:
.globl vector103
vector103:
  pushl $0
  1025e4:	6a 00                	push   $0x0
  pushl $103
  1025e6:	6a 67                	push   $0x67
  jmp __alltraps
  1025e8:	e9 d8 06 00 00       	jmp    102cc5 <__alltraps>

001025ed <vector104>:
.globl vector104
vector104:
  pushl $0
  1025ed:	6a 00                	push   $0x0
  pushl $104
  1025ef:	6a 68                	push   $0x68
  jmp __alltraps
  1025f1:	e9 cf 06 00 00       	jmp    102cc5 <__alltraps>

001025f6 <vector105>:
.globl vector105
vector105:
  pushl $0
  1025f6:	6a 00                	push   $0x0
  pushl $105
  1025f8:	6a 69                	push   $0x69
  jmp __alltraps
  1025fa:	e9 c6 06 00 00       	jmp    102cc5 <__alltraps>

001025ff <vector106>:
.globl vector106
vector106:
  pushl $0
  1025ff:	6a 00                	push   $0x0
  pushl $106
  102601:	6a 6a                	push   $0x6a
  jmp __alltraps
  102603:	e9 bd 06 00 00       	jmp    102cc5 <__alltraps>

00102608 <vector107>:
.globl vector107
vector107:
  pushl $0
  102608:	6a 00                	push   $0x0
  pushl $107
  10260a:	6a 6b                	push   $0x6b
  jmp __alltraps
  10260c:	e9 b4 06 00 00       	jmp    102cc5 <__alltraps>

00102611 <vector108>:
.globl vector108
vector108:
  pushl $0
  102611:	6a 00                	push   $0x0
  pushl $108
  102613:	6a 6c                	push   $0x6c
  jmp __alltraps
  102615:	e9 ab 06 00 00       	jmp    102cc5 <__alltraps>

0010261a <vector109>:
.globl vector109
vector109:
  pushl $0
  10261a:	6a 00                	push   $0x0
  pushl $109
  10261c:	6a 6d                	push   $0x6d
  jmp __alltraps
  10261e:	e9 a2 06 00 00       	jmp    102cc5 <__alltraps>

00102623 <vector110>:
.globl vector110
vector110:
  pushl $0
  102623:	6a 00                	push   $0x0
  pushl $110
  102625:	6a 6e                	push   $0x6e
  jmp __alltraps
  102627:	e9 99 06 00 00       	jmp    102cc5 <__alltraps>

0010262c <vector111>:
.globl vector111
vector111:
  pushl $0
  10262c:	6a 00                	push   $0x0
  pushl $111
  10262e:	6a 6f                	push   $0x6f
  jmp __alltraps
  102630:	e9 90 06 00 00       	jmp    102cc5 <__alltraps>

00102635 <vector112>:
.globl vector112
vector112:
  pushl $0
  102635:	6a 00                	push   $0x0
  pushl $112
  102637:	6a 70                	push   $0x70
  jmp __alltraps
  102639:	e9 87 06 00 00       	jmp    102cc5 <__alltraps>

0010263e <vector113>:
.globl vector113
vector113:
  pushl $0
  10263e:	6a 00                	push   $0x0
  pushl $113
  102640:	6a 71                	push   $0x71
  jmp __alltraps
  102642:	e9 7e 06 00 00       	jmp    102cc5 <__alltraps>

00102647 <vector114>:
.globl vector114
vector114:
  pushl $0
  102647:	6a 00                	push   $0x0
  pushl $114
  102649:	6a 72                	push   $0x72
  jmp __alltraps
  10264b:	e9 75 06 00 00       	jmp    102cc5 <__alltraps>

00102650 <vector115>:
.globl vector115
vector115:
  pushl $0
  102650:	6a 00                	push   $0x0
  pushl $115
  102652:	6a 73                	push   $0x73
  jmp __alltraps
  102654:	e9 6c 06 00 00       	jmp    102cc5 <__alltraps>

00102659 <vector116>:
.globl vector116
vector116:
  pushl $0
  102659:	6a 00                	push   $0x0
  pushl $116
  10265b:	6a 74                	push   $0x74
  jmp __alltraps
  10265d:	e9 63 06 00 00       	jmp    102cc5 <__alltraps>

00102662 <vector117>:
.globl vector117
vector117:
  pushl $0
  102662:	6a 00                	push   $0x0
  pushl $117
  102664:	6a 75                	push   $0x75
  jmp __alltraps
  102666:	e9 5a 06 00 00       	jmp    102cc5 <__alltraps>

0010266b <vector118>:
.globl vector118
vector118:
  pushl $0
  10266b:	6a 00                	push   $0x0
  pushl $118
  10266d:	6a 76                	push   $0x76
  jmp __alltraps
  10266f:	e9 51 06 00 00       	jmp    102cc5 <__alltraps>

00102674 <vector119>:
.globl vector119
vector119:
  pushl $0
  102674:	6a 00                	push   $0x0
  pushl $119
  102676:	6a 77                	push   $0x77
  jmp __alltraps
  102678:	e9 48 06 00 00       	jmp    102cc5 <__alltraps>

0010267d <vector120>:
.globl vector120
vector120:
  pushl $0
  10267d:	6a 00                	push   $0x0
  pushl $120
  10267f:	6a 78                	push   $0x78
  jmp __alltraps
  102681:	e9 3f 06 00 00       	jmp    102cc5 <__alltraps>

00102686 <vector121>:
.globl vector121
vector121:
  pushl $0
  102686:	6a 00                	push   $0x0
  pushl $121
  102688:	6a 79                	push   $0x79
  jmp __alltraps
  10268a:	e9 36 06 00 00       	jmp    102cc5 <__alltraps>

0010268f <vector122>:
.globl vector122
vector122:
  pushl $0
  10268f:	6a 00                	push   $0x0
  pushl $122
  102691:	6a 7a                	push   $0x7a
  jmp __alltraps
  102693:	e9 2d 06 00 00       	jmp    102cc5 <__alltraps>

00102698 <vector123>:
.globl vector123
vector123:
  pushl $0
  102698:	6a 00                	push   $0x0
  pushl $123
  10269a:	6a 7b                	push   $0x7b
  jmp __alltraps
  10269c:	e9 24 06 00 00       	jmp    102cc5 <__alltraps>

001026a1 <vector124>:
.globl vector124
vector124:
  pushl $0
  1026a1:	6a 00                	push   $0x0
  pushl $124
  1026a3:	6a 7c                	push   $0x7c
  jmp __alltraps
  1026a5:	e9 1b 06 00 00       	jmp    102cc5 <__alltraps>

001026aa <vector125>:
.globl vector125
vector125:
  pushl $0
  1026aa:	6a 00                	push   $0x0
  pushl $125
  1026ac:	6a 7d                	push   $0x7d
  jmp __alltraps
  1026ae:	e9 12 06 00 00       	jmp    102cc5 <__alltraps>

001026b3 <vector126>:
.globl vector126
vector126:
  pushl $0
  1026b3:	6a 00                	push   $0x0
  pushl $126
  1026b5:	6a 7e                	push   $0x7e
  jmp __alltraps
  1026b7:	e9 09 06 00 00       	jmp    102cc5 <__alltraps>

001026bc <vector127>:
.globl vector127
vector127:
  pushl $0
  1026bc:	6a 00                	push   $0x0
  pushl $127
  1026be:	6a 7f                	push   $0x7f
  jmp __alltraps
  1026c0:	e9 00 06 00 00       	jmp    102cc5 <__alltraps>

001026c5 <vector128>:
.globl vector128
vector128:
  pushl $0
  1026c5:	6a 00                	push   $0x0
  pushl $128
  1026c7:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  1026cc:	e9 f4 05 00 00       	jmp    102cc5 <__alltraps>

001026d1 <vector129>:
.globl vector129
vector129:
  pushl $0
  1026d1:	6a 00                	push   $0x0
  pushl $129
  1026d3:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  1026d8:	e9 e8 05 00 00       	jmp    102cc5 <__alltraps>

001026dd <vector130>:
.globl vector130
vector130:
  pushl $0
  1026dd:	6a 00                	push   $0x0
  pushl $130
  1026df:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  1026e4:	e9 dc 05 00 00       	jmp    102cc5 <__alltraps>

001026e9 <vector131>:
.globl vector131
vector131:
  pushl $0
  1026e9:	6a 00                	push   $0x0
  pushl $131
  1026eb:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  1026f0:	e9 d0 05 00 00       	jmp    102cc5 <__alltraps>

001026f5 <vector132>:
.globl vector132
vector132:
  pushl $0
  1026f5:	6a 00                	push   $0x0
  pushl $132
  1026f7:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  1026fc:	e9 c4 05 00 00       	jmp    102cc5 <__alltraps>

00102701 <vector133>:
.globl vector133
vector133:
  pushl $0
  102701:	6a 00                	push   $0x0
  pushl $133
  102703:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102708:	e9 b8 05 00 00       	jmp    102cc5 <__alltraps>

0010270d <vector134>:
.globl vector134
vector134:
  pushl $0
  10270d:	6a 00                	push   $0x0
  pushl $134
  10270f:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  102714:	e9 ac 05 00 00       	jmp    102cc5 <__alltraps>

00102719 <vector135>:
.globl vector135
vector135:
  pushl $0
  102719:	6a 00                	push   $0x0
  pushl $135
  10271b:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  102720:	e9 a0 05 00 00       	jmp    102cc5 <__alltraps>

00102725 <vector136>:
.globl vector136
vector136:
  pushl $0
  102725:	6a 00                	push   $0x0
  pushl $136
  102727:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  10272c:	e9 94 05 00 00       	jmp    102cc5 <__alltraps>

00102731 <vector137>:
.globl vector137
vector137:
  pushl $0
  102731:	6a 00                	push   $0x0
  pushl $137
  102733:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  102738:	e9 88 05 00 00       	jmp    102cc5 <__alltraps>

0010273d <vector138>:
.globl vector138
vector138:
  pushl $0
  10273d:	6a 00                	push   $0x0
  pushl $138
  10273f:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  102744:	e9 7c 05 00 00       	jmp    102cc5 <__alltraps>

00102749 <vector139>:
.globl vector139
vector139:
  pushl $0
  102749:	6a 00                	push   $0x0
  pushl $139
  10274b:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102750:	e9 70 05 00 00       	jmp    102cc5 <__alltraps>

00102755 <vector140>:
.globl vector140
vector140:
  pushl $0
  102755:	6a 00                	push   $0x0
  pushl $140
  102757:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  10275c:	e9 64 05 00 00       	jmp    102cc5 <__alltraps>

00102761 <vector141>:
.globl vector141
vector141:
  pushl $0
  102761:	6a 00                	push   $0x0
  pushl $141
  102763:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  102768:	e9 58 05 00 00       	jmp    102cc5 <__alltraps>

0010276d <vector142>:
.globl vector142
vector142:
  pushl $0
  10276d:	6a 00                	push   $0x0
  pushl $142
  10276f:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  102774:	e9 4c 05 00 00       	jmp    102cc5 <__alltraps>

00102779 <vector143>:
.globl vector143
vector143:
  pushl $0
  102779:	6a 00                	push   $0x0
  pushl $143
  10277b:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  102780:	e9 40 05 00 00       	jmp    102cc5 <__alltraps>

00102785 <vector144>:
.globl vector144
vector144:
  pushl $0
  102785:	6a 00                	push   $0x0
  pushl $144
  102787:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  10278c:	e9 34 05 00 00       	jmp    102cc5 <__alltraps>

00102791 <vector145>:
.globl vector145
vector145:
  pushl $0
  102791:	6a 00                	push   $0x0
  pushl $145
  102793:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102798:	e9 28 05 00 00       	jmp    102cc5 <__alltraps>

0010279d <vector146>:
.globl vector146
vector146:
  pushl $0
  10279d:	6a 00                	push   $0x0
  pushl $146
  10279f:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  1027a4:	e9 1c 05 00 00       	jmp    102cc5 <__alltraps>

001027a9 <vector147>:
.globl vector147
vector147:
  pushl $0
  1027a9:	6a 00                	push   $0x0
  pushl $147
  1027ab:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  1027b0:	e9 10 05 00 00       	jmp    102cc5 <__alltraps>

001027b5 <vector148>:
.globl vector148
vector148:
  pushl $0
  1027b5:	6a 00                	push   $0x0
  pushl $148
  1027b7:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  1027bc:	e9 04 05 00 00       	jmp    102cc5 <__alltraps>

001027c1 <vector149>:
.globl vector149
vector149:
  pushl $0
  1027c1:	6a 00                	push   $0x0
  pushl $149
  1027c3:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1027c8:	e9 f8 04 00 00       	jmp    102cc5 <__alltraps>

001027cd <vector150>:
.globl vector150
vector150:
  pushl $0
  1027cd:	6a 00                	push   $0x0
  pushl $150
  1027cf:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  1027d4:	e9 ec 04 00 00       	jmp    102cc5 <__alltraps>

001027d9 <vector151>:
.globl vector151
vector151:
  pushl $0
  1027d9:	6a 00                	push   $0x0
  pushl $151
  1027db:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  1027e0:	e9 e0 04 00 00       	jmp    102cc5 <__alltraps>

001027e5 <vector152>:
.globl vector152
vector152:
  pushl $0
  1027e5:	6a 00                	push   $0x0
  pushl $152
  1027e7:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  1027ec:	e9 d4 04 00 00       	jmp    102cc5 <__alltraps>

001027f1 <vector153>:
.globl vector153
vector153:
  pushl $0
  1027f1:	6a 00                	push   $0x0
  pushl $153
  1027f3:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  1027f8:	e9 c8 04 00 00       	jmp    102cc5 <__alltraps>

001027fd <vector154>:
.globl vector154
vector154:
  pushl $0
  1027fd:	6a 00                	push   $0x0
  pushl $154
  1027ff:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  102804:	e9 bc 04 00 00       	jmp    102cc5 <__alltraps>

00102809 <vector155>:
.globl vector155
vector155:
  pushl $0
  102809:	6a 00                	push   $0x0
  pushl $155
  10280b:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  102810:	e9 b0 04 00 00       	jmp    102cc5 <__alltraps>

00102815 <vector156>:
.globl vector156
vector156:
  pushl $0
  102815:	6a 00                	push   $0x0
  pushl $156
  102817:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  10281c:	e9 a4 04 00 00       	jmp    102cc5 <__alltraps>

00102821 <vector157>:
.globl vector157
vector157:
  pushl $0
  102821:	6a 00                	push   $0x0
  pushl $157
  102823:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102828:	e9 98 04 00 00       	jmp    102cc5 <__alltraps>

0010282d <vector158>:
.globl vector158
vector158:
  pushl $0
  10282d:	6a 00                	push   $0x0
  pushl $158
  10282f:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  102834:	e9 8c 04 00 00       	jmp    102cc5 <__alltraps>

00102839 <vector159>:
.globl vector159
vector159:
  pushl $0
  102839:	6a 00                	push   $0x0
  pushl $159
  10283b:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  102840:	e9 80 04 00 00       	jmp    102cc5 <__alltraps>

00102845 <vector160>:
.globl vector160
vector160:
  pushl $0
  102845:	6a 00                	push   $0x0
  pushl $160
  102847:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  10284c:	e9 74 04 00 00       	jmp    102cc5 <__alltraps>

00102851 <vector161>:
.globl vector161
vector161:
  pushl $0
  102851:	6a 00                	push   $0x0
  pushl $161
  102853:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  102858:	e9 68 04 00 00       	jmp    102cc5 <__alltraps>

0010285d <vector162>:
.globl vector162
vector162:
  pushl $0
  10285d:	6a 00                	push   $0x0
  pushl $162
  10285f:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  102864:	e9 5c 04 00 00       	jmp    102cc5 <__alltraps>

00102869 <vector163>:
.globl vector163
vector163:
  pushl $0
  102869:	6a 00                	push   $0x0
  pushl $163
  10286b:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  102870:	e9 50 04 00 00       	jmp    102cc5 <__alltraps>

00102875 <vector164>:
.globl vector164
vector164:
  pushl $0
  102875:	6a 00                	push   $0x0
  pushl $164
  102877:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  10287c:	e9 44 04 00 00       	jmp    102cc5 <__alltraps>

00102881 <vector165>:
.globl vector165
vector165:
  pushl $0
  102881:	6a 00                	push   $0x0
  pushl $165
  102883:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  102888:	e9 38 04 00 00       	jmp    102cc5 <__alltraps>

0010288d <vector166>:
.globl vector166
vector166:
  pushl $0
  10288d:	6a 00                	push   $0x0
  pushl $166
  10288f:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  102894:	e9 2c 04 00 00       	jmp    102cc5 <__alltraps>

00102899 <vector167>:
.globl vector167
vector167:
  pushl $0
  102899:	6a 00                	push   $0x0
  pushl $167
  10289b:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  1028a0:	e9 20 04 00 00       	jmp    102cc5 <__alltraps>

001028a5 <vector168>:
.globl vector168
vector168:
  pushl $0
  1028a5:	6a 00                	push   $0x0
  pushl $168
  1028a7:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  1028ac:	e9 14 04 00 00       	jmp    102cc5 <__alltraps>

001028b1 <vector169>:
.globl vector169
vector169:
  pushl $0
  1028b1:	6a 00                	push   $0x0
  pushl $169
  1028b3:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  1028b8:	e9 08 04 00 00       	jmp    102cc5 <__alltraps>

001028bd <vector170>:
.globl vector170
vector170:
  pushl $0
  1028bd:	6a 00                	push   $0x0
  pushl $170
  1028bf:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  1028c4:	e9 fc 03 00 00       	jmp    102cc5 <__alltraps>

001028c9 <vector171>:
.globl vector171
vector171:
  pushl $0
  1028c9:	6a 00                	push   $0x0
  pushl $171
  1028cb:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  1028d0:	e9 f0 03 00 00       	jmp    102cc5 <__alltraps>

001028d5 <vector172>:
.globl vector172
vector172:
  pushl $0
  1028d5:	6a 00                	push   $0x0
  pushl $172
  1028d7:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  1028dc:	e9 e4 03 00 00       	jmp    102cc5 <__alltraps>

001028e1 <vector173>:
.globl vector173
vector173:
  pushl $0
  1028e1:	6a 00                	push   $0x0
  pushl $173
  1028e3:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  1028e8:	e9 d8 03 00 00       	jmp    102cc5 <__alltraps>

001028ed <vector174>:
.globl vector174
vector174:
  pushl $0
  1028ed:	6a 00                	push   $0x0
  pushl $174
  1028ef:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  1028f4:	e9 cc 03 00 00       	jmp    102cc5 <__alltraps>

001028f9 <vector175>:
.globl vector175
vector175:
  pushl $0
  1028f9:	6a 00                	push   $0x0
  pushl $175
  1028fb:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102900:	e9 c0 03 00 00       	jmp    102cc5 <__alltraps>

00102905 <vector176>:
.globl vector176
vector176:
  pushl $0
  102905:	6a 00                	push   $0x0
  pushl $176
  102907:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  10290c:	e9 b4 03 00 00       	jmp    102cc5 <__alltraps>

00102911 <vector177>:
.globl vector177
vector177:
  pushl $0
  102911:	6a 00                	push   $0x0
  pushl $177
  102913:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102918:	e9 a8 03 00 00       	jmp    102cc5 <__alltraps>

0010291d <vector178>:
.globl vector178
vector178:
  pushl $0
  10291d:	6a 00                	push   $0x0
  pushl $178
  10291f:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102924:	e9 9c 03 00 00       	jmp    102cc5 <__alltraps>

00102929 <vector179>:
.globl vector179
vector179:
  pushl $0
  102929:	6a 00                	push   $0x0
  pushl $179
  10292b:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102930:	e9 90 03 00 00       	jmp    102cc5 <__alltraps>

00102935 <vector180>:
.globl vector180
vector180:
  pushl $0
  102935:	6a 00                	push   $0x0
  pushl $180
  102937:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  10293c:	e9 84 03 00 00       	jmp    102cc5 <__alltraps>

00102941 <vector181>:
.globl vector181
vector181:
  pushl $0
  102941:	6a 00                	push   $0x0
  pushl $181
  102943:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  102948:	e9 78 03 00 00       	jmp    102cc5 <__alltraps>

0010294d <vector182>:
.globl vector182
vector182:
  pushl $0
  10294d:	6a 00                	push   $0x0
  pushl $182
  10294f:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  102954:	e9 6c 03 00 00       	jmp    102cc5 <__alltraps>

00102959 <vector183>:
.globl vector183
vector183:
  pushl $0
  102959:	6a 00                	push   $0x0
  pushl $183
  10295b:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102960:	e9 60 03 00 00       	jmp    102cc5 <__alltraps>

00102965 <vector184>:
.globl vector184
vector184:
  pushl $0
  102965:	6a 00                	push   $0x0
  pushl $184
  102967:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  10296c:	e9 54 03 00 00       	jmp    102cc5 <__alltraps>

00102971 <vector185>:
.globl vector185
vector185:
  pushl $0
  102971:	6a 00                	push   $0x0
  pushl $185
  102973:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102978:	e9 48 03 00 00       	jmp    102cc5 <__alltraps>

0010297d <vector186>:
.globl vector186
vector186:
  pushl $0
  10297d:	6a 00                	push   $0x0
  pushl $186
  10297f:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  102984:	e9 3c 03 00 00       	jmp    102cc5 <__alltraps>

00102989 <vector187>:
.globl vector187
vector187:
  pushl $0
  102989:	6a 00                	push   $0x0
  pushl $187
  10298b:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  102990:	e9 30 03 00 00       	jmp    102cc5 <__alltraps>

00102995 <vector188>:
.globl vector188
vector188:
  pushl $0
  102995:	6a 00                	push   $0x0
  pushl $188
  102997:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  10299c:	e9 24 03 00 00       	jmp    102cc5 <__alltraps>

001029a1 <vector189>:
.globl vector189
vector189:
  pushl $0
  1029a1:	6a 00                	push   $0x0
  pushl $189
  1029a3:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  1029a8:	e9 18 03 00 00       	jmp    102cc5 <__alltraps>

001029ad <vector190>:
.globl vector190
vector190:
  pushl $0
  1029ad:	6a 00                	push   $0x0
  pushl $190
  1029af:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  1029b4:	e9 0c 03 00 00       	jmp    102cc5 <__alltraps>

001029b9 <vector191>:
.globl vector191
vector191:
  pushl $0
  1029b9:	6a 00                	push   $0x0
  pushl $191
  1029bb:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  1029c0:	e9 00 03 00 00       	jmp    102cc5 <__alltraps>

001029c5 <vector192>:
.globl vector192
vector192:
  pushl $0
  1029c5:	6a 00                	push   $0x0
  pushl $192
  1029c7:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  1029cc:	e9 f4 02 00 00       	jmp    102cc5 <__alltraps>

001029d1 <vector193>:
.globl vector193
vector193:
  pushl $0
  1029d1:	6a 00                	push   $0x0
  pushl $193
  1029d3:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  1029d8:	e9 e8 02 00 00       	jmp    102cc5 <__alltraps>

001029dd <vector194>:
.globl vector194
vector194:
  pushl $0
  1029dd:	6a 00                	push   $0x0
  pushl $194
  1029df:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  1029e4:	e9 dc 02 00 00       	jmp    102cc5 <__alltraps>

001029e9 <vector195>:
.globl vector195
vector195:
  pushl $0
  1029e9:	6a 00                	push   $0x0
  pushl $195
  1029eb:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  1029f0:	e9 d0 02 00 00       	jmp    102cc5 <__alltraps>

001029f5 <vector196>:
.globl vector196
vector196:
  pushl $0
  1029f5:	6a 00                	push   $0x0
  pushl $196
  1029f7:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  1029fc:	e9 c4 02 00 00       	jmp    102cc5 <__alltraps>

00102a01 <vector197>:
.globl vector197
vector197:
  pushl $0
  102a01:	6a 00                	push   $0x0
  pushl $197
  102a03:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102a08:	e9 b8 02 00 00       	jmp    102cc5 <__alltraps>

00102a0d <vector198>:
.globl vector198
vector198:
  pushl $0
  102a0d:	6a 00                	push   $0x0
  pushl $198
  102a0f:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102a14:	e9 ac 02 00 00       	jmp    102cc5 <__alltraps>

00102a19 <vector199>:
.globl vector199
vector199:
  pushl $0
  102a19:	6a 00                	push   $0x0
  pushl $199
  102a1b:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102a20:	e9 a0 02 00 00       	jmp    102cc5 <__alltraps>

00102a25 <vector200>:
.globl vector200
vector200:
  pushl $0
  102a25:	6a 00                	push   $0x0
  pushl $200
  102a27:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102a2c:	e9 94 02 00 00       	jmp    102cc5 <__alltraps>

00102a31 <vector201>:
.globl vector201
vector201:
  pushl $0
  102a31:	6a 00                	push   $0x0
  pushl $201
  102a33:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102a38:	e9 88 02 00 00       	jmp    102cc5 <__alltraps>

00102a3d <vector202>:
.globl vector202
vector202:
  pushl $0
  102a3d:	6a 00                	push   $0x0
  pushl $202
  102a3f:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102a44:	e9 7c 02 00 00       	jmp    102cc5 <__alltraps>

00102a49 <vector203>:
.globl vector203
vector203:
  pushl $0
  102a49:	6a 00                	push   $0x0
  pushl $203
  102a4b:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102a50:	e9 70 02 00 00       	jmp    102cc5 <__alltraps>

00102a55 <vector204>:
.globl vector204
vector204:
  pushl $0
  102a55:	6a 00                	push   $0x0
  pushl $204
  102a57:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  102a5c:	e9 64 02 00 00       	jmp    102cc5 <__alltraps>

00102a61 <vector205>:
.globl vector205
vector205:
  pushl $0
  102a61:	6a 00                	push   $0x0
  pushl $205
  102a63:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102a68:	e9 58 02 00 00       	jmp    102cc5 <__alltraps>

00102a6d <vector206>:
.globl vector206
vector206:
  pushl $0
  102a6d:	6a 00                	push   $0x0
  pushl $206
  102a6f:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102a74:	e9 4c 02 00 00       	jmp    102cc5 <__alltraps>

00102a79 <vector207>:
.globl vector207
vector207:
  pushl $0
  102a79:	6a 00                	push   $0x0
  pushl $207
  102a7b:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102a80:	e9 40 02 00 00       	jmp    102cc5 <__alltraps>

00102a85 <vector208>:
.globl vector208
vector208:
  pushl $0
  102a85:	6a 00                	push   $0x0
  pushl $208
  102a87:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102a8c:	e9 34 02 00 00       	jmp    102cc5 <__alltraps>

00102a91 <vector209>:
.globl vector209
vector209:
  pushl $0
  102a91:	6a 00                	push   $0x0
  pushl $209
  102a93:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102a98:	e9 28 02 00 00       	jmp    102cc5 <__alltraps>

00102a9d <vector210>:
.globl vector210
vector210:
  pushl $0
  102a9d:	6a 00                	push   $0x0
  pushl $210
  102a9f:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102aa4:	e9 1c 02 00 00       	jmp    102cc5 <__alltraps>

00102aa9 <vector211>:
.globl vector211
vector211:
  pushl $0
  102aa9:	6a 00                	push   $0x0
  pushl $211
  102aab:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102ab0:	e9 10 02 00 00       	jmp    102cc5 <__alltraps>

00102ab5 <vector212>:
.globl vector212
vector212:
  pushl $0
  102ab5:	6a 00                	push   $0x0
  pushl $212
  102ab7:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102abc:	e9 04 02 00 00       	jmp    102cc5 <__alltraps>

00102ac1 <vector213>:
.globl vector213
vector213:
  pushl $0
  102ac1:	6a 00                	push   $0x0
  pushl $213
  102ac3:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102ac8:	e9 f8 01 00 00       	jmp    102cc5 <__alltraps>

00102acd <vector214>:
.globl vector214
vector214:
  pushl $0
  102acd:	6a 00                	push   $0x0
  pushl $214
  102acf:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102ad4:	e9 ec 01 00 00       	jmp    102cc5 <__alltraps>

00102ad9 <vector215>:
.globl vector215
vector215:
  pushl $0
  102ad9:	6a 00                	push   $0x0
  pushl $215
  102adb:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102ae0:	e9 e0 01 00 00       	jmp    102cc5 <__alltraps>

00102ae5 <vector216>:
.globl vector216
vector216:
  pushl $0
  102ae5:	6a 00                	push   $0x0
  pushl $216
  102ae7:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102aec:	e9 d4 01 00 00       	jmp    102cc5 <__alltraps>

00102af1 <vector217>:
.globl vector217
vector217:
  pushl $0
  102af1:	6a 00                	push   $0x0
  pushl $217
  102af3:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102af8:	e9 c8 01 00 00       	jmp    102cc5 <__alltraps>

00102afd <vector218>:
.globl vector218
vector218:
  pushl $0
  102afd:	6a 00                	push   $0x0
  pushl $218
  102aff:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102b04:	e9 bc 01 00 00       	jmp    102cc5 <__alltraps>

00102b09 <vector219>:
.globl vector219
vector219:
  pushl $0
  102b09:	6a 00                	push   $0x0
  pushl $219
  102b0b:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102b10:	e9 b0 01 00 00       	jmp    102cc5 <__alltraps>

00102b15 <vector220>:
.globl vector220
vector220:
  pushl $0
  102b15:	6a 00                	push   $0x0
  pushl $220
  102b17:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102b1c:	e9 a4 01 00 00       	jmp    102cc5 <__alltraps>

00102b21 <vector221>:
.globl vector221
vector221:
  pushl $0
  102b21:	6a 00                	push   $0x0
  pushl $221
  102b23:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102b28:	e9 98 01 00 00       	jmp    102cc5 <__alltraps>

00102b2d <vector222>:
.globl vector222
vector222:
  pushl $0
  102b2d:	6a 00                	push   $0x0
  pushl $222
  102b2f:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102b34:	e9 8c 01 00 00       	jmp    102cc5 <__alltraps>

00102b39 <vector223>:
.globl vector223
vector223:
  pushl $0
  102b39:	6a 00                	push   $0x0
  pushl $223
  102b3b:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102b40:	e9 80 01 00 00       	jmp    102cc5 <__alltraps>

00102b45 <vector224>:
.globl vector224
vector224:
  pushl $0
  102b45:	6a 00                	push   $0x0
  pushl $224
  102b47:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102b4c:	e9 74 01 00 00       	jmp    102cc5 <__alltraps>

00102b51 <vector225>:
.globl vector225
vector225:
  pushl $0
  102b51:	6a 00                	push   $0x0
  pushl $225
  102b53:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  102b58:	e9 68 01 00 00       	jmp    102cc5 <__alltraps>

00102b5d <vector226>:
.globl vector226
vector226:
  pushl $0
  102b5d:	6a 00                	push   $0x0
  pushl $226
  102b5f:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102b64:	e9 5c 01 00 00       	jmp    102cc5 <__alltraps>

00102b69 <vector227>:
.globl vector227
vector227:
  pushl $0
  102b69:	6a 00                	push   $0x0
  pushl $227
  102b6b:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102b70:	e9 50 01 00 00       	jmp    102cc5 <__alltraps>

00102b75 <vector228>:
.globl vector228
vector228:
  pushl $0
  102b75:	6a 00                	push   $0x0
  pushl $228
  102b77:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102b7c:	e9 44 01 00 00       	jmp    102cc5 <__alltraps>

00102b81 <vector229>:
.globl vector229
vector229:
  pushl $0
  102b81:	6a 00                	push   $0x0
  pushl $229
  102b83:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102b88:	e9 38 01 00 00       	jmp    102cc5 <__alltraps>

00102b8d <vector230>:
.globl vector230
vector230:
  pushl $0
  102b8d:	6a 00                	push   $0x0
  pushl $230
  102b8f:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102b94:	e9 2c 01 00 00       	jmp    102cc5 <__alltraps>

00102b99 <vector231>:
.globl vector231
vector231:
  pushl $0
  102b99:	6a 00                	push   $0x0
  pushl $231
  102b9b:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102ba0:	e9 20 01 00 00       	jmp    102cc5 <__alltraps>

00102ba5 <vector232>:
.globl vector232
vector232:
  pushl $0
  102ba5:	6a 00                	push   $0x0
  pushl $232
  102ba7:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102bac:	e9 14 01 00 00       	jmp    102cc5 <__alltraps>

00102bb1 <vector233>:
.globl vector233
vector233:
  pushl $0
  102bb1:	6a 00                	push   $0x0
  pushl $233
  102bb3:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102bb8:	e9 08 01 00 00       	jmp    102cc5 <__alltraps>

00102bbd <vector234>:
.globl vector234
vector234:
  pushl $0
  102bbd:	6a 00                	push   $0x0
  pushl $234
  102bbf:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102bc4:	e9 fc 00 00 00       	jmp    102cc5 <__alltraps>

00102bc9 <vector235>:
.globl vector235
vector235:
  pushl $0
  102bc9:	6a 00                	push   $0x0
  pushl $235
  102bcb:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102bd0:	e9 f0 00 00 00       	jmp    102cc5 <__alltraps>

00102bd5 <vector236>:
.globl vector236
vector236:
  pushl $0
  102bd5:	6a 00                	push   $0x0
  pushl $236
  102bd7:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102bdc:	e9 e4 00 00 00       	jmp    102cc5 <__alltraps>

00102be1 <vector237>:
.globl vector237
vector237:
  pushl $0
  102be1:	6a 00                	push   $0x0
  pushl $237
  102be3:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102be8:	e9 d8 00 00 00       	jmp    102cc5 <__alltraps>

00102bed <vector238>:
.globl vector238
vector238:
  pushl $0
  102bed:	6a 00                	push   $0x0
  pushl $238
  102bef:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102bf4:	e9 cc 00 00 00       	jmp    102cc5 <__alltraps>

00102bf9 <vector239>:
.globl vector239
vector239:
  pushl $0
  102bf9:	6a 00                	push   $0x0
  pushl $239
  102bfb:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102c00:	e9 c0 00 00 00       	jmp    102cc5 <__alltraps>

00102c05 <vector240>:
.globl vector240
vector240:
  pushl $0
  102c05:	6a 00                	push   $0x0
  pushl $240
  102c07:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102c0c:	e9 b4 00 00 00       	jmp    102cc5 <__alltraps>

00102c11 <vector241>:
.globl vector241
vector241:
  pushl $0
  102c11:	6a 00                	push   $0x0
  pushl $241
  102c13:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102c18:	e9 a8 00 00 00       	jmp    102cc5 <__alltraps>

00102c1d <vector242>:
.globl vector242
vector242:
  pushl $0
  102c1d:	6a 00                	push   $0x0
  pushl $242
  102c1f:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102c24:	e9 9c 00 00 00       	jmp    102cc5 <__alltraps>

00102c29 <vector243>:
.globl vector243
vector243:
  pushl $0
  102c29:	6a 00                	push   $0x0
  pushl $243
  102c2b:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102c30:	e9 90 00 00 00       	jmp    102cc5 <__alltraps>

00102c35 <vector244>:
.globl vector244
vector244:
  pushl $0
  102c35:	6a 00                	push   $0x0
  pushl $244
  102c37:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102c3c:	e9 84 00 00 00       	jmp    102cc5 <__alltraps>

00102c41 <vector245>:
.globl vector245
vector245:
  pushl $0
  102c41:	6a 00                	push   $0x0
  pushl $245
  102c43:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102c48:	e9 78 00 00 00       	jmp    102cc5 <__alltraps>

00102c4d <vector246>:
.globl vector246
vector246:
  pushl $0
  102c4d:	6a 00                	push   $0x0
  pushl $246
  102c4f:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102c54:	e9 6c 00 00 00       	jmp    102cc5 <__alltraps>

00102c59 <vector247>:
.globl vector247
vector247:
  pushl $0
  102c59:	6a 00                	push   $0x0
  pushl $247
  102c5b:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102c60:	e9 60 00 00 00       	jmp    102cc5 <__alltraps>

00102c65 <vector248>:
.globl vector248
vector248:
  pushl $0
  102c65:	6a 00                	push   $0x0
  pushl $248
  102c67:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102c6c:	e9 54 00 00 00       	jmp    102cc5 <__alltraps>

00102c71 <vector249>:
.globl vector249
vector249:
  pushl $0
  102c71:	6a 00                	push   $0x0
  pushl $249
  102c73:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102c78:	e9 48 00 00 00       	jmp    102cc5 <__alltraps>

00102c7d <vector250>:
.globl vector250
vector250:
  pushl $0
  102c7d:	6a 00                	push   $0x0
  pushl $250
  102c7f:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102c84:	e9 3c 00 00 00       	jmp    102cc5 <__alltraps>

00102c89 <vector251>:
.globl vector251
vector251:
  pushl $0
  102c89:	6a 00                	push   $0x0
  pushl $251
  102c8b:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102c90:	e9 30 00 00 00       	jmp    102cc5 <__alltraps>

00102c95 <vector252>:
.globl vector252
vector252:
  pushl $0
  102c95:	6a 00                	push   $0x0
  pushl $252
  102c97:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102c9c:	e9 24 00 00 00       	jmp    102cc5 <__alltraps>

00102ca1 <vector253>:
.globl vector253
vector253:
  pushl $0
  102ca1:	6a 00                	push   $0x0
  pushl $253
  102ca3:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102ca8:	e9 18 00 00 00       	jmp    102cc5 <__alltraps>

00102cad <vector254>:
.globl vector254
vector254:
  pushl $0
  102cad:	6a 00                	push   $0x0
  pushl $254
  102caf:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102cb4:	e9 0c 00 00 00       	jmp    102cc5 <__alltraps>

00102cb9 <vector255>:
.globl vector255
vector255:
  pushl $0
  102cb9:	6a 00                	push   $0x0
  pushl $255
  102cbb:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102cc0:	e9 00 00 00 00       	jmp    102cc5 <__alltraps>

00102cc5 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  102cc5:	1e                   	push   %ds
    pushl %es
  102cc6:	06                   	push   %es
    pushl %fs
  102cc7:	0f a0                	push   %fs
    pushl %gs
  102cc9:	0f a8                	push   %gs
    pushal
  102ccb:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  102ccc:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  102cd1:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  102cd3:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  102cd5:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  102cd6:	e8 64 f5 ff ff       	call   10223f <trap>

    # pop the pushed stack pointer
    popl %esp
  102cdb:	5c                   	pop    %esp

00102cdc <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  102cdc:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  102cdd:	0f a9                	pop    %gs
    popl %fs
  102cdf:	0f a1                	pop    %fs
    popl %es
  102ce1:	07                   	pop    %es
    popl %ds
  102ce2:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  102ce3:	83 c4 08             	add    $0x8,%esp
    iret
  102ce6:	cf                   	iret   

00102ce7 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  102ce7:	55                   	push   %ebp
  102ce8:	89 e5                	mov    %esp,%ebp
    return page - pages;
  102cea:	a1 38 df 11 00       	mov    0x11df38,%eax
  102cef:	8b 55 08             	mov    0x8(%ebp),%edx
  102cf2:	29 c2                	sub    %eax,%edx
  102cf4:	89 d0                	mov    %edx,%eax
  102cf6:	c1 f8 02             	sar    $0x2,%eax
  102cf9:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  102cff:	5d                   	pop    %ebp
  102d00:	c3                   	ret    

00102d01 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  102d01:	55                   	push   %ebp
  102d02:	89 e5                	mov    %esp,%ebp
  102d04:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  102d07:	8b 45 08             	mov    0x8(%ebp),%eax
  102d0a:	89 04 24             	mov    %eax,(%esp)
  102d0d:	e8 d5 ff ff ff       	call   102ce7 <page2ppn>
  102d12:	c1 e0 0c             	shl    $0xc,%eax
}
  102d15:	c9                   	leave  
  102d16:	c3                   	ret    

00102d17 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  102d17:	55                   	push   %ebp
  102d18:	89 e5                	mov    %esp,%ebp
  102d1a:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  102d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  102d20:	c1 e8 0c             	shr    $0xc,%eax
  102d23:	89 c2                	mov    %eax,%edx
  102d25:	a1 a0 de 11 00       	mov    0x11dea0,%eax
  102d2a:	39 c2                	cmp    %eax,%edx
  102d2c:	72 1c                	jb     102d4a <pa2page+0x33>
        panic("pa2page called with invalid pa");
  102d2e:	c7 44 24 08 50 6f 10 	movl   $0x106f50,0x8(%esp)
  102d35:	00 
  102d36:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  102d3d:	00 
  102d3e:	c7 04 24 6f 6f 10 00 	movl   $0x106f6f,(%esp)
  102d45:	e8 95 d6 ff ff       	call   1003df <__panic>
    }
    return &pages[PPN(pa)];
  102d4a:	8b 0d 38 df 11 00    	mov    0x11df38,%ecx
  102d50:	8b 45 08             	mov    0x8(%ebp),%eax
  102d53:	c1 e8 0c             	shr    $0xc,%eax
  102d56:	89 c2                	mov    %eax,%edx
  102d58:	89 d0                	mov    %edx,%eax
  102d5a:	c1 e0 02             	shl    $0x2,%eax
  102d5d:	01 d0                	add    %edx,%eax
  102d5f:	c1 e0 02             	shl    $0x2,%eax
  102d62:	01 c8                	add    %ecx,%eax
}
  102d64:	c9                   	leave  
  102d65:	c3                   	ret    

00102d66 <page2kva>:

static inline void *
page2kva(struct Page *page) {
  102d66:	55                   	push   %ebp
  102d67:	89 e5                	mov    %esp,%ebp
  102d69:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  102d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  102d6f:	89 04 24             	mov    %eax,(%esp)
  102d72:	e8 8a ff ff ff       	call   102d01 <page2pa>
  102d77:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102d7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d7d:	c1 e8 0c             	shr    $0xc,%eax
  102d80:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102d83:	a1 a0 de 11 00       	mov    0x11dea0,%eax
  102d88:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  102d8b:	72 23                	jb     102db0 <page2kva+0x4a>
  102d8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d90:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102d94:	c7 44 24 08 80 6f 10 	movl   $0x106f80,0x8(%esp)
  102d9b:	00 
  102d9c:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  102da3:	00 
  102da4:	c7 04 24 6f 6f 10 00 	movl   $0x106f6f,(%esp)
  102dab:	e8 2f d6 ff ff       	call   1003df <__panic>
  102db0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102db3:	c9                   	leave  
  102db4:	c3                   	ret    

00102db5 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  102db5:	55                   	push   %ebp
  102db6:	89 e5                	mov    %esp,%ebp
  102db8:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  102dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  102dbe:	83 e0 01             	and    $0x1,%eax
  102dc1:	85 c0                	test   %eax,%eax
  102dc3:	75 1c                	jne    102de1 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  102dc5:	c7 44 24 08 a4 6f 10 	movl   $0x106fa4,0x8(%esp)
  102dcc:	00 
  102dcd:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  102dd4:	00 
  102dd5:	c7 04 24 6f 6f 10 00 	movl   $0x106f6f,(%esp)
  102ddc:	e8 fe d5 ff ff       	call   1003df <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  102de1:	8b 45 08             	mov    0x8(%ebp),%eax
  102de4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  102de9:	89 04 24             	mov    %eax,(%esp)
  102dec:	e8 26 ff ff ff       	call   102d17 <pa2page>
}
  102df1:	c9                   	leave  
  102df2:	c3                   	ret    

00102df3 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
  102df3:	55                   	push   %ebp
  102df4:	89 e5                	mov    %esp,%ebp
  102df6:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
  102df9:	8b 45 08             	mov    0x8(%ebp),%eax
  102dfc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  102e01:	89 04 24             	mov    %eax,(%esp)
  102e04:	e8 0e ff ff ff       	call   102d17 <pa2page>
}
  102e09:	c9                   	leave  
  102e0a:	c3                   	ret    

00102e0b <page_ref>:

static inline int
page_ref(struct Page *page) {
  102e0b:	55                   	push   %ebp
  102e0c:	89 e5                	mov    %esp,%ebp
    return page->ref;
  102e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  102e11:	8b 00                	mov    (%eax),%eax
}
  102e13:	5d                   	pop    %ebp
  102e14:	c3                   	ret    

00102e15 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  102e15:	55                   	push   %ebp
  102e16:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  102e18:	8b 45 08             	mov    0x8(%ebp),%eax
  102e1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  102e1e:	89 10                	mov    %edx,(%eax)
}
  102e20:	90                   	nop
  102e21:	5d                   	pop    %ebp
  102e22:	c3                   	ret    

00102e23 <page_ref_inc>:

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
  102e68:	e8 05 ea ff ff       	call   101872 <intr_disable>
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
  102e87:	e8 df e9 ff ff       	call   10186b <intr_enable>
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
  102ecb:	a3 c4 de 11 00       	mov    %eax,0x11dec4
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
  102ed9:	b8 00 a0 11 00       	mov    $0x11a000,%eax
  102ede:	89 04 24             	mov    %eax,(%esp)
  102ee1:	e8 df ff ff ff       	call   102ec5 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  102ee6:	66 c7 05 c8 de 11 00 	movw   $0x10,0x11dec8
  102eed:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  102eef:	66 c7 05 28 aa 11 00 	movw   $0x68,0x11aa28
  102ef6:	68 00 
  102ef8:	b8 c0 de 11 00       	mov    $0x11dec0,%eax
  102efd:	0f b7 c0             	movzwl %ax,%eax
  102f00:	66 a3 2a aa 11 00    	mov    %ax,0x11aa2a
  102f06:	b8 c0 de 11 00       	mov    $0x11dec0,%eax
  102f0b:	c1 e8 10             	shr    $0x10,%eax
  102f0e:	a2 2c aa 11 00       	mov    %al,0x11aa2c
  102f13:	0f b6 05 2d aa 11 00 	movzbl 0x11aa2d,%eax
  102f1a:	24 f0                	and    $0xf0,%al
  102f1c:	0c 09                	or     $0x9,%al
  102f1e:	a2 2d aa 11 00       	mov    %al,0x11aa2d
  102f23:	0f b6 05 2d aa 11 00 	movzbl 0x11aa2d,%eax
  102f2a:	24 ef                	and    $0xef,%al
  102f2c:	a2 2d aa 11 00       	mov    %al,0x11aa2d
  102f31:	0f b6 05 2d aa 11 00 	movzbl 0x11aa2d,%eax
  102f38:	24 9f                	and    $0x9f,%al
  102f3a:	a2 2d aa 11 00       	mov    %al,0x11aa2d
  102f3f:	0f b6 05 2d aa 11 00 	movzbl 0x11aa2d,%eax
  102f46:	0c 80                	or     $0x80,%al
  102f48:	a2 2d aa 11 00       	mov    %al,0x11aa2d
  102f4d:	0f b6 05 2e aa 11 00 	movzbl 0x11aa2e,%eax
  102f54:	24 f0                	and    $0xf0,%al
  102f56:	a2 2e aa 11 00       	mov    %al,0x11aa2e
  102f5b:	0f b6 05 2e aa 11 00 	movzbl 0x11aa2e,%eax
  102f62:	24 ef                	and    $0xef,%al
  102f64:	a2 2e aa 11 00       	mov    %al,0x11aa2e
  102f69:	0f b6 05 2e aa 11 00 	movzbl 0x11aa2e,%eax
  102f70:	24 df                	and    $0xdf,%al
  102f72:	a2 2e aa 11 00       	mov    %al,0x11aa2e
  102f77:	0f b6 05 2e aa 11 00 	movzbl 0x11aa2e,%eax
  102f7e:	0c 40                	or     $0x40,%al
  102f80:	a2 2e aa 11 00       	mov    %al,0x11aa2e
  102f85:	0f b6 05 2e aa 11 00 	movzbl 0x11aa2e,%eax
  102f8c:	24 7f                	and    $0x7f,%al
  102f8e:	a2 2e aa 11 00       	mov    %al,0x11aa2e
  102f93:	b8 c0 de 11 00       	mov    $0x11dec0,%eax
  102f98:	c1 e8 18             	shr    $0x18,%eax
  102f9b:	a2 2f aa 11 00       	mov    %al,0x11aa2f

    // reload all segment registers
    lgdt(&gdt_pd);
  102fa0:	c7 04 24 30 aa 11 00 	movl   $0x11aa30,(%esp)
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
  102fc2:	c7 05 30 df 11 00 c4 	movl   $0x107ac4,0x11df30
  102fc9:	7a 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  102fcc:	a1 30 df 11 00       	mov    0x11df30,%eax
  102fd1:	8b 00                	mov    (%eax),%eax
  102fd3:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fd7:	c7 04 24 d0 6f 10 00 	movl   $0x106fd0,(%esp)
  102fde:	e8 a4 d2 ff ff       	call   100287 <cprintf>
    pmm_manager->init();
  102fe3:	a1 30 df 11 00       	mov    0x11df30,%eax
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
  102ff6:	a1 30 df 11 00       	mov    0x11df30,%eax
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
  103025:	a1 30 df 11 00       	mov    0x11df30,%eax
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
  103056:	a1 30 df 11 00       	mov    0x11df30,%eax
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
  103089:	a1 30 df 11 00       	mov    0x11df30,%eax
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
  1030b2:	c7 45 c4 00 80 00 00 	movl   $0x8000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  1030b9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  1030c0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  1030c7:	c7 04 24 e7 6f 10 00 	movl   $0x106fe7,(%esp)
  1030ce:	e8 b4 d1 ff ff       	call   100287 <cprintf>
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
  1031a0:	c7 04 24 f4 6f 10 00 	movl   $0x106ff4,(%esp)
  1031a7:	e8 db d0 ff ff       	call   100287 <cprintf>
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
  10323a:	a3 a0 de 11 00       	mov    %eax,0x11dea0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  10323f:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  103246:	b8 48 df 11 00       	mov    $0x11df48,%eax
  10324b:	8d 50 ff             	lea    -0x1(%eax),%edx
  10324e:	8b 45 ac             	mov    -0x54(%ebp),%eax
  103251:	01 d0                	add    %edx,%eax
  103253:	89 45 a8             	mov    %eax,-0x58(%ebp)
  103256:	8b 45 a8             	mov    -0x58(%ebp),%eax
  103259:	ba 00 00 00 00       	mov    $0x0,%edx
  10325e:	f7 75 ac             	divl   -0x54(%ebp)
  103261:	8b 45 a8             	mov    -0x58(%ebp),%eax
  103264:	29 d0                	sub    %edx,%eax
  103266:	a3 38 df 11 00       	mov    %eax,0x11df38

    for (i = 0; i < npage; i ++) {
  10326b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103272:	eb 2e                	jmp    1032a2 <page_init+0x1fc>
        SetPageReserved(pages + i);
  103274:	8b 0d 38 df 11 00    	mov    0x11df38,%ecx
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
  1032a5:	a1 a0 de 11 00       	mov    0x11dea0,%eax
  1032aa:	39 c2                	cmp    %eax,%edx
  1032ac:	72 c6                	jb     103274 <page_init+0x1ce>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  1032ae:	8b 15 a0 de 11 00    	mov    0x11dea0,%edx
  1032b4:	89 d0                	mov    %edx,%eax
  1032b6:	c1 e0 02             	shl    $0x2,%eax
  1032b9:	01 d0                	add    %edx,%eax
  1032bb:	c1 e0 02             	shl    $0x2,%eax
  1032be:	89 c2                	mov    %eax,%edx
  1032c0:	a1 38 df 11 00       	mov    0x11df38,%eax
  1032c5:	01 d0                	add    %edx,%eax
  1032c7:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  1032ca:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  1032cd:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  1032d0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1032d7:	e9 53 01 00 00       	jmp    10342f <page_init+0x389>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  1032dc:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1032df:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1032e2:	89 d0                	mov    %edx,%eax
  1032e4:	c1 e0 02             	shl    $0x2,%eax
  1032e7:	01 d0                	add    %edx,%eax
  1032e9:	c1 e0 02             	shl    $0x2,%eax
  1032ec:	01 c8                	add    %ecx,%eax
  1032ee:	8b 50 08             	mov    0x8(%eax),%edx
  1032f1:	8b 40 04             	mov    0x4(%eax),%eax
  1032f4:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1032f7:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1032fa:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1032fd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103300:	89 d0                	mov    %edx,%eax
  103302:	c1 e0 02             	shl    $0x2,%eax
  103305:	01 d0                	add    %edx,%eax
  103307:	c1 e0 02             	shl    $0x2,%eax
  10330a:	01 c8                	add    %ecx,%eax
  10330c:	8b 48 0c             	mov    0xc(%eax),%ecx
  10330f:	8b 58 10             	mov    0x10(%eax),%ebx
  103312:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103315:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103318:	01 c8                	add    %ecx,%eax
  10331a:	11 da                	adc    %ebx,%edx
  10331c:	89 45 c8             	mov    %eax,-0x38(%ebp)
  10331f:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  103322:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103325:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103328:	89 d0                	mov    %edx,%eax
  10332a:	c1 e0 02             	shl    $0x2,%eax
  10332d:	01 d0                	add    %edx,%eax
  10332f:	c1 e0 02             	shl    $0x2,%eax
  103332:	01 c8                	add    %ecx,%eax
  103334:	83 c0 14             	add    $0x14,%eax
  103337:	8b 00                	mov    (%eax),%eax
  103339:	83 f8 01             	cmp    $0x1,%eax
  10333c:	0f 85 ea 00 00 00    	jne    10342c <page_init+0x386>
            if (begin < freemem) {
  103342:	8b 45 a0             	mov    -0x60(%ebp),%eax
  103345:	ba 00 00 00 00       	mov    $0x0,%edx
  10334a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  10334d:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  103350:	19 d1                	sbb    %edx,%ecx
  103352:	73 0d                	jae    103361 <page_init+0x2bb>
                begin = freemem;
  103354:	8b 45 a0             	mov    -0x60(%ebp),%eax
  103357:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10335a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  103361:	ba 00 00 00 38       	mov    $0x38000000,%edx
  103366:	b8 00 00 00 00       	mov    $0x0,%eax
  10336b:	3b 55 c8             	cmp    -0x38(%ebp),%edx
  10336e:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  103371:	73 0e                	jae    103381 <page_init+0x2db>
                end = KMEMSIZE;
  103373:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  10337a:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  103381:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103384:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103387:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  10338a:	89 d0                	mov    %edx,%eax
  10338c:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  10338f:	0f 83 97 00 00 00    	jae    10342c <page_init+0x386>
                begin = ROUNDUP(begin, PGSIZE);
  103395:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
  10339c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  10339f:	8b 45 9c             	mov    -0x64(%ebp),%eax
  1033a2:	01 d0                	add    %edx,%eax
  1033a4:	48                   	dec    %eax
  1033a5:	89 45 98             	mov    %eax,-0x68(%ebp)
  1033a8:	8b 45 98             	mov    -0x68(%ebp),%eax
  1033ab:	ba 00 00 00 00       	mov    $0x0,%edx
  1033b0:	f7 75 9c             	divl   -0x64(%ebp)
  1033b3:	8b 45 98             	mov    -0x68(%ebp),%eax
  1033b6:	29 d0                	sub    %edx,%eax
  1033b8:	ba 00 00 00 00       	mov    $0x0,%edx
  1033bd:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1033c0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  1033c3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1033c6:	89 45 94             	mov    %eax,-0x6c(%ebp)
  1033c9:	8b 45 94             	mov    -0x6c(%ebp),%eax
  1033cc:	ba 00 00 00 00       	mov    $0x0,%edx
  1033d1:	89 c3                	mov    %eax,%ebx
  1033d3:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  1033d9:	89 de                	mov    %ebx,%esi
  1033db:	89 d0                	mov    %edx,%eax
  1033dd:	83 e0 00             	and    $0x0,%eax
  1033e0:	89 c7                	mov    %eax,%edi
  1033e2:	89 75 c8             	mov    %esi,-0x38(%ebp)
  1033e5:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
  1033e8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1033eb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1033ee:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  1033f1:	89 d0                	mov    %edx,%eax
  1033f3:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  1033f6:	73 34                	jae    10342c <page_init+0x386>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  1033f8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1033fb:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1033fe:	2b 45 d0             	sub    -0x30(%ebp),%eax
  103401:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
  103404:	89 c1                	mov    %eax,%ecx
  103406:	89 d3                	mov    %edx,%ebx
  103408:	89 c8                	mov    %ecx,%eax
  10340a:	89 da                	mov    %ebx,%edx
  10340c:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  103410:	c1 ea 0c             	shr    $0xc,%edx
  103413:	89 c3                	mov    %eax,%ebx
  103415:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103418:	89 04 24             	mov    %eax,(%esp)
  10341b:	e8 f7 f8 ff ff       	call   102d17 <pa2page>
  103420:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  103424:	89 04 24             	mov    %eax,(%esp)
  103427:	e8 c4 fb ff ff       	call   102ff0 <init_memmap>
    for (i = 0; i < memmap->nr_map; i ++) {
  10342c:	ff 45 dc             	incl   -0x24(%ebp)
  10342f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103432:	8b 00                	mov    (%eax),%eax
  103434:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  103437:	0f 8c 9f fe ff ff    	jl     1032dc <page_init+0x236>
                }
            }
        }
    }
}
  10343d:	90                   	nop
  10343e:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  103444:	5b                   	pop    %ebx
  103445:	5e                   	pop    %esi
  103446:	5f                   	pop    %edi
  103447:	5d                   	pop    %ebp
  103448:	c3                   	ret    

00103449 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  103449:	55                   	push   %ebp
  10344a:	89 e5                	mov    %esp,%ebp
  10344c:	83 ec 38             	sub    $0x38,%esp
	boot_pgdir[1] &= ~PTE_P;
  10344f:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  103454:	83 c0 04             	add    $0x4,%eax
  103457:	8b 10                	mov    (%eax),%edx
  103459:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  10345e:	83 c0 04             	add    $0x4,%eax
  103461:	83 e2 fe             	and    $0xfffffffe,%edx
  103464:	89 10                	mov    %edx,(%eax)
    assert(PGOFF(la) == PGOFF(pa));
  103466:	8b 45 0c             	mov    0xc(%ebp),%eax
  103469:	33 45 14             	xor    0x14(%ebp),%eax
  10346c:	25 ff 0f 00 00       	and    $0xfff,%eax
  103471:	85 c0                	test   %eax,%eax
  103473:	74 24                	je     103499 <boot_map_segment+0x50>
  103475:	c7 44 24 0c 24 70 10 	movl   $0x107024,0xc(%esp)
  10347c:	00 
  10347d:	c7 44 24 08 3b 70 10 	movl   $0x10703b,0x8(%esp)
  103484:	00 
  103485:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
  10348c:	00 
  10348d:	c7 04 24 50 70 10 00 	movl   $0x107050,(%esp)
  103494:	e8 46 cf ff ff       	call   1003df <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  103499:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  1034a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034a3:	25 ff 0f 00 00       	and    $0xfff,%eax
  1034a8:	89 c2                	mov    %eax,%edx
  1034aa:	8b 45 10             	mov    0x10(%ebp),%eax
  1034ad:	01 c2                	add    %eax,%edx
  1034af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1034b2:	01 d0                	add    %edx,%eax
  1034b4:	48                   	dec    %eax
  1034b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1034b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1034bb:	ba 00 00 00 00       	mov    $0x0,%edx
  1034c0:	f7 75 f0             	divl   -0x10(%ebp)
  1034c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1034c6:	29 d0                	sub    %edx,%eax
  1034c8:	c1 e8 0c             	shr    $0xc,%eax
  1034cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  1034ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1034d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1034d7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1034dc:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  1034df:	8b 45 14             	mov    0x14(%ebp),%eax
  1034e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1034e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1034e8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1034ed:	89 45 14             	mov    %eax,0x14(%ebp)
	assert(la == pa);
  1034f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034f3:	3b 45 14             	cmp    0x14(%ebp),%eax
  1034f6:	0f 84 8c 00 00 00    	je     103588 <boot_map_segment+0x13f>
  1034fc:	c7 44 24 0c 5e 70 10 	movl   $0x10705e,0xc(%esp)
  103503:	00 
  103504:	c7 44 24 08 3b 70 10 	movl   $0x10703b,0x8(%esp)
  10350b:	00 
  10350c:	c7 44 24 04 05 01 00 	movl   $0x105,0x4(%esp)
  103513:	00 
  103514:	c7 04 24 50 70 10 00 	movl   $0x107050,(%esp)
  10351b:	e8 bf ce ff ff       	call   1003df <__panic>
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
        pte_t *ptep = get_pte(pgdir, la, 1);
  103520:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  103527:	00 
  103528:	8b 45 0c             	mov    0xc(%ebp),%eax
  10352b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10352f:	8b 45 08             	mov    0x8(%ebp),%eax
  103532:	89 04 24             	mov    %eax,(%esp)
  103535:	e8 14 01 00 00       	call   10364e <get_pte>
  10353a:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  10353d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  103541:	75 24                	jne    103567 <boot_map_segment+0x11e>
  103543:	c7 44 24 0c 67 70 10 	movl   $0x107067,0xc(%esp)
  10354a:	00 
  10354b:	c7 44 24 08 3b 70 10 	movl   $0x10703b,0x8(%esp)
  103552:	00 
  103553:	c7 44 24 04 08 01 00 	movl   $0x108,0x4(%esp)
  10355a:	00 
  10355b:	c7 04 24 50 70 10 00 	movl   $0x107050,(%esp)
  103562:	e8 78 ce ff ff       	call   1003df <__panic>
        *ptep = pa | PTE_P | perm;
  103567:	8b 45 14             	mov    0x14(%ebp),%eax
  10356a:	0b 45 18             	or     0x18(%ebp),%eax
  10356d:	83 c8 01             	or     $0x1,%eax
  103570:	89 c2                	mov    %eax,%edx
  103572:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103575:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  103577:	ff 4d f4             	decl   -0xc(%ebp)
  10357a:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  103581:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  103588:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10358c:	75 92                	jne    103520 <boot_map_segment+0xd7>
    }
}
  10358e:	90                   	nop
  10358f:	c9                   	leave  
  103590:	c3                   	ret    

00103591 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  103591:	55                   	push   %ebp
  103592:	89 e5                	mov    %esp,%ebp
  103594:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  103597:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10359e:	e8 6d fa ff ff       	call   103010 <alloc_pages>
  1035a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  1035a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1035aa:	75 1c                	jne    1035c8 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
  1035ac:	c7 44 24 08 74 70 10 	movl   $0x107074,0x8(%esp)
  1035b3:	00 
  1035b4:	c7 44 24 04 14 01 00 	movl   $0x114,0x4(%esp)
  1035bb:	00 
  1035bc:	c7 04 24 50 70 10 00 	movl   $0x107050,(%esp)
  1035c3:	e8 17 ce ff ff       	call   1003df <__panic>
    }
    return page2kva(p);
  1035c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1035cb:	89 04 24             	mov    %eax,(%esp)
  1035ce:	e8 93 f7 ff ff       	call   102d66 <page2kva>
}
  1035d3:	c9                   	leave  
  1035d4:	c3                   	ret    

001035d5 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  1035d5:	55                   	push   %ebp
  1035d6:	89 e5                	mov    %esp,%ebp
  1035d8:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
  1035db:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  1035e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1035e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1035e6:	a3 34 df 11 00       	mov    %eax,0x11df34
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  1035eb:	e8 cc f9 ff ff       	call   102fbc <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  1035f0:	e8 b1 fa ff ff       	call   1030a6 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  1035f5:	e8 3b 05 00 00       	call   103b35 <check_alloc_page>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  1035fa:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  1035ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103602:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103605:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  10360a:	05 2c 0c 00 00       	add    $0xc2c,%eax
  10360f:	83 ca 03             	or     $0x3,%edx
  103612:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  103614:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  103619:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  103620:	00 
  103621:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  103628:	00 
  103629:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  103630:	38 
  103631:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103638:	00 
  103639:	89 04 24             	mov    %eax,(%esp)
  10363c:	e8 08 fe ff ff       	call   103449 <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  103641:	e8 8d f8 ff ff       	call   102ed3 <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    // check_boot_pgdir();

    print_pgdir();
  103646:	e8 e8 0f 00 00       	call   104633 <print_pgdir>

}
  10364b:	90                   	nop
  10364c:	c9                   	leave  
  10364d:	c3                   	ret    

0010364e <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  10364e:	55                   	push   %ebp
  10364f:	89 e5                	mov    %esp,%ebp
  103651:	83 ec 68             	sub    $0x68,%esp
     *   PTE_W           0x002                   // page table/directory entry flags bit : Writeable
     *   PTE_U           0x004                   // page table/directory entry flags bit : User can access
     */
	
// #if 0
	assert(pgdir != NULL);
  103654:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103658:	75 24                	jne    10367e <get_pte+0x30>
  10365a:	c7 44 24 0c 8d 70 10 	movl   $0x10708d,0xc(%esp)
  103661:	00 
  103662:	c7 44 24 08 3b 70 10 	movl   $0x10703b,0x8(%esp)
  103669:	00 
  10366a:	c7 44 24 04 68 01 00 	movl   $0x168,0x4(%esp)
  103671:	00 
  103672:	c7 04 24 50 70 10 00 	movl   $0x107050,(%esp)
  103679:	e8 61 cd ff ff       	call   1003df <__panic>
	struct Page *struct_page_vp;	// virtual address of struct page
	uint32_t pdx = PDX(la), ptx = PTX(la);	// index of PDE, PTE
  10367e:	8b 45 0c             	mov    0xc(%ebp),%eax
  103681:	c1 e8 16             	shr    $0x16,%eax
  103684:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103687:	8b 45 0c             	mov    0xc(%ebp),%eax
  10368a:	c1 e8 0c             	shr    $0xc,%eax
  10368d:	25 ff 03 00 00       	and    $0x3ff,%eax
  103692:	89 45 f0             	mov    %eax,-0x10(%ebp)

    pde_t *pdep, *ptep;   // (1) find page directory entry
	pte_t *page_pa;			// physical address of page
	pdep = pgdir + pdx;
  103695:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103698:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10369f:	8b 45 08             	mov    0x8(%ebp),%eax
  1036a2:	01 d0                	add    %edx,%eax
  1036a4:	89 45 ec             	mov    %eax,-0x14(%ebp)
	ptep = (pte_t *)KADDR(PDE_ADDR(*pdep)) + ptx;
  1036a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1036aa:	8b 00                	mov    (%eax),%eax
  1036ac:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1036b1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1036b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1036b7:	c1 e8 0c             	shr    $0xc,%eax
  1036ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1036bd:	a1 a0 de 11 00       	mov    0x11dea0,%eax
  1036c2:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  1036c5:	72 23                	jb     1036ea <get_pte+0x9c>
  1036c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1036ca:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1036ce:	c7 44 24 08 80 6f 10 	movl   $0x106f80,0x8(%esp)
  1036d5:	00 
  1036d6:	c7 44 24 04 6f 01 00 	movl   $0x16f,0x4(%esp)
  1036dd:	00 
  1036de:	c7 04 24 50 70 10 00 	movl   $0x107050,(%esp)
  1036e5:	e8 f5 cc ff ff       	call   1003df <__panic>
  1036ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1036ed:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1036f0:	c1 e2 02             	shl    $0x2,%edx
  1036f3:	01 d0                	add    %edx,%eax
  1036f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1036f8:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  1036ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103702:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103705:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103708:	8b 55 c8             	mov    -0x38(%ebp),%edx
  10370b:	0f a3 10             	bt     %edx,(%eax)
  10370e:	19 c0                	sbb    %eax,%eax
  103710:	89 45 c0             	mov    %eax,-0x40(%ebp)
    return oldbit != 0;
  103713:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  103717:	0f 95 c0             	setne  %al
  10371a:	0f b6 c0             	movzbl %al,%eax

	// if PDE exists 
	if (test_bit(0, pdep)) {
  10371d:	85 c0                	test   %eax,%eax
  10371f:	74 08                	je     103729 <get_pte+0xdb>
		return ptep;
  103721:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103724:	e9 32 01 00 00       	jmp    10385b <get_pte+0x20d>
  103729:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
  103730:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103733:	89 45 b8             	mov    %eax,-0x48(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103736:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103739:	8b 55 bc             	mov    -0x44(%ebp),%edx
  10373c:	0f a3 10             	bt     %edx,(%eax)
  10373f:	19 c0                	sbb    %eax,%eax
  103741:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    return oldbit != 0;
  103744:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  103748:	0f 95 c0             	setne  %al
  10374b:	0f b6 c0             	movzbl %al,%eax
	}
	/* if PDE not exsits, allocate one page for PT and create corresponding PDE */
    if ((!test_bit(0, pdep)) && create) {              // (2) check if entry is not present
  10374e:	85 c0                	test   %eax,%eax
  103750:	0f 85 00 01 00 00    	jne    103856 <get_pte+0x208>
  103756:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10375a:	0f 84 f6 00 00 00    	je     103856 <get_pte+0x208>
		struct_page_vp = alloc_page();
  103760:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103767:	e8 a4 f8 ff ff       	call   103010 <alloc_pages>
  10376c:	89 45 dc             	mov    %eax,-0x24(%ebp)
		assert(struct_page_vp != NULL);
  10376f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  103773:	75 24                	jne    103799 <get_pte+0x14b>
  103775:	c7 44 24 0c 9b 70 10 	movl   $0x10709b,0xc(%esp)
  10377c:	00 
  10377d:	c7 44 24 08 3b 70 10 	movl   $0x10703b,0x8(%esp)
  103784:	00 
  103785:	c7 44 24 04 78 01 00 	movl   $0x178,0x4(%esp)
  10378c:	00 
  10378d:	c7 04 24 50 70 10 00 	movl   $0x107050,(%esp)
  103794:	e8 46 cc ff ff       	call   1003df <__panic>
		set_page_ref(struct_page_vp, 1);
  103799:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1037a0:	00 
  1037a1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1037a4:	89 04 24             	mov    %eax,(%esp)
  1037a7:	e8 69 f6 ff ff       	call   102e15 <set_page_ref>
		page_pa = (pte_t *)page2pa(struct_page_vp);
  1037ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1037af:	89 04 24             	mov    %eax,(%esp)
  1037b2:	e8 4a f5 ff ff       	call   102d01 <page2pa>
  1037b7:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptep = KADDR(page_pa + ptx);
  1037ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1037bd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1037c4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1037c7:	01 d0                	add    %edx,%eax
  1037c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1037cc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1037cf:	c1 e8 0c             	shr    $0xc,%eax
  1037d2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1037d5:	a1 a0 de 11 00       	mov    0x11dea0,%eax
  1037da:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  1037dd:	72 23                	jb     103802 <get_pte+0x1b4>
  1037df:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1037e2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1037e6:	c7 44 24 08 80 6f 10 	movl   $0x106f80,0x8(%esp)
  1037ed:	00 
  1037ee:	c7 44 24 04 7b 01 00 	movl   $0x17b,0x4(%esp)
  1037f5:	00 
  1037f6:	c7 04 24 50 70 10 00 	movl   $0x107050,(%esp)
  1037fd:	e8 dd cb ff ff       	call   1003df <__panic>
  103802:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  103805:	89 45 e0             	mov    %eax,-0x20(%ebp)
		memset(pdep, 0, sizeof(pde_t));
  103808:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  10380f:	00 
  103810:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103817:	00 
  103818:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10381b:	89 04 24             	mov    %eax,(%esp)
  10381e:	e8 e6 27 00 00       	call   106009 <memset>
		*pdep = (PADDR(ptep)) | PTE_P | PTE_U | PTE_W;
  103823:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103826:	89 45 cc             	mov    %eax,-0x34(%ebp)
  103829:	8b 45 cc             	mov    -0x34(%ebp),%eax
  10382c:	83 c8 07             	or     $0x7,%eax
  10382f:	89 c2                	mov    %eax,%edx
  103831:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103834:	89 10                	mov    %edx,(%eax)
		memset(ptep, 0, PGSIZE);
  103836:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  10383d:	00 
  10383e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103845:	00 
  103846:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103849:	89 04 24             	mov    %eax,(%esp)
  10384c:	e8 b8 27 00 00       	call   106009 <memset>
		return ptep;
  103851:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103854:	eb 05                	jmp    10385b <get_pte+0x20d>
							// (5) get linear address of page
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    
	// if PDE not exists and caller don't require get_pte allocate PTE.
    return NULL;          // (8) return page table entry
  103856:	b8 00 00 00 00       	mov    $0x0,%eax
// #endif
}
  10385b:	c9                   	leave  
  10385c:	c3                   	ret    

0010385d <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  10385d:	55                   	push   %ebp
  10385e:	89 e5                	mov    %esp,%ebp
  103860:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  103863:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10386a:	00 
  10386b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10386e:	89 44 24 04          	mov    %eax,0x4(%esp)
  103872:	8b 45 08             	mov    0x8(%ebp),%eax
  103875:	89 04 24             	mov    %eax,(%esp)
  103878:	e8 d1 fd ff ff       	call   10364e <get_pte>
  10387d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  103880:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103884:	74 08                	je     10388e <get_page+0x31>
        *ptep_store = ptep;
  103886:	8b 45 10             	mov    0x10(%ebp),%eax
  103889:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10388c:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  10388e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103892:	74 1b                	je     1038af <get_page+0x52>
  103894:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103897:	8b 00                	mov    (%eax),%eax
  103899:	83 e0 01             	and    $0x1,%eax
  10389c:	85 c0                	test   %eax,%eax
  10389e:	74 0f                	je     1038af <get_page+0x52>
        return pte2page(*ptep);
  1038a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1038a3:	8b 00                	mov    (%eax),%eax
  1038a5:	89 04 24             	mov    %eax,(%esp)
  1038a8:	e8 08 f5 ff ff       	call   102db5 <pte2page>
  1038ad:	eb 05                	jmp    1038b4 <get_page+0x57>
    }
    return NULL;
  1038af:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1038b4:	c9                   	leave  
  1038b5:	c3                   	ret    

001038b6 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  1038b6:	55                   	push   %ebp
  1038b7:	89 e5                	mov    %esp,%ebp
  1038b9:	83 ec 48             	sub    $0x48,%esp
     *                        edited are the ones currently in use by the processor.
     * DEFINEs:
     *   PTE_P           0x001                   // page table/directory entry flags bit : Present
     */
// #if 0
	assert(pgdir != NULL);
  1038bc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1038c0:	75 24                	jne    1038e6 <page_remove_pte+0x30>
  1038c2:	c7 44 24 0c 8d 70 10 	movl   $0x10708d,0xc(%esp)
  1038c9:	00 
  1038ca:	c7 44 24 08 3b 70 10 	movl   $0x10703b,0x8(%esp)
  1038d1:	00 
  1038d2:	c7 44 24 04 b9 01 00 	movl   $0x1b9,0x4(%esp)
  1038d9:	00 
  1038da:	c7 04 24 50 70 10 00 	movl   $0x107050,(%esp)
  1038e1:	e8 f9 ca ff ff       	call   1003df <__panic>
	assert(ptep != NULL);
  1038e6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1038ea:	75 24                	jne    103910 <page_remove_pte+0x5a>
  1038ec:	c7 44 24 0c 67 70 10 	movl   $0x107067,0xc(%esp)
  1038f3:	00 
  1038f4:	c7 44 24 08 3b 70 10 	movl   $0x10703b,0x8(%esp)
  1038fb:	00 
  1038fc:	c7 44 24 04 ba 01 00 	movl   $0x1ba,0x4(%esp)
  103903:	00 
  103904:	c7 04 24 50 70 10 00 	movl   $0x107050,(%esp)
  10390b:	e8 cf ca ff ff       	call   1003df <__panic>
	pde_t *pdep = pgdir + PDX(la);
  103910:	8b 45 0c             	mov    0xc(%ebp),%eax
  103913:	c1 e8 16             	shr    $0x16,%eax
  103916:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10391d:	8b 45 08             	mov    0x8(%ebp),%eax
  103920:	01 d0                	add    %edx,%eax
  103922:	89 45 f4             	mov    %eax,-0xc(%ebp)
	assert(PDE_ADDR(*pdep) == PADDR(ROUNDDOWN(ptep, PGSIZE)));
  103925:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103928:	8b 00                	mov    (%eax),%eax
  10392a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10392f:	89 c2                	mov    %eax,%edx
  103931:	8b 45 10             	mov    0x10(%ebp),%eax
  103934:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103937:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10393a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10393f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103942:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103945:	39 d0                	cmp    %edx,%eax
  103947:	74 24                	je     10396d <page_remove_pte+0xb7>
  103949:	c7 44 24 0c b4 70 10 	movl   $0x1070b4,0xc(%esp)
  103950:	00 
  103951:	c7 44 24 08 3b 70 10 	movl   $0x10703b,0x8(%esp)
  103958:	00 
  103959:	c7 44 24 04 bc 01 00 	movl   $0x1bc,0x4(%esp)
  103960:	00 
  103961:	c7 04 24 50 70 10 00 	movl   $0x107050,(%esp)
  103968:	e8 72 ca ff ff       	call   1003df <__panic>
  10396d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  103974:	8b 45 10             	mov    0x10(%ebp),%eax
  103977:	89 45 e0             	mov    %eax,-0x20(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10397a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10397d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103980:	0f a3 10             	bt     %edx,(%eax)
  103983:	19 c0                	sbb    %eax,%eax
  103985:	89 45 dc             	mov    %eax,-0x24(%ebp)
    return oldbit != 0;
  103988:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  10398c:	0f 95 c0             	setne  %al
  10398f:	0f b6 c0             	movzbl %al,%eax
    if (test_bit(0, ptep)) {                      //(1) check if this page table entry is present
  103992:	85 c0                	test   %eax,%eax
  103994:	74 67                	je     1039fd <page_remove_pte+0x147>
        struct Page *page = pte2page(*ptep); //(2) find corresponding page to pte
  103996:	8b 45 10             	mov    0x10(%ebp),%eax
  103999:	8b 00                	mov    (%eax),%eax
  10399b:	89 04 24             	mov    %eax,(%esp)
  10399e:	e8 12 f4 ff ff       	call   102db5 <pte2page>
  1039a3:	89 45 e8             	mov    %eax,-0x18(%ebp)
        page_ref_dec(page);                          //(3) decrease page reference
  1039a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1039a9:	89 04 24             	mov    %eax,(%esp)
  1039ac:	e8 89 f4 ff ff       	call   102e3a <page_ref_dec>
        if (page_ref(page) == 0)
  1039b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1039b4:	89 04 24             	mov    %eax,(%esp)
  1039b7:	e8 4f f4 ff ff       	call   102e0b <page_ref>
  1039bc:	85 c0                	test   %eax,%eax
  1039be:	75 13                	jne    1039d3 <page_remove_pte+0x11d>
			free_page(page);			//(4) and free this page when page reference reachs 0
  1039c0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1039c7:	00 
  1039c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1039cb:	89 04 24             	mov    %eax,(%esp)
  1039ce:	e8 75 f6 ff ff       	call   103048 <free_pages>
  1039d3:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
  1039da:	8b 45 10             	mov    0x10(%ebp),%eax
  1039dd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1039e0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1039e3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1039e6:	0f b3 10             	btr    %edx,(%eax)
        clear_bit(PTE_P, ptep);                        //(5) clear second page table entry
        tlb_invalidate(pgdir, la);                          //(6) flush tlb
  1039e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1039ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  1039f0:	8b 45 08             	mov    0x8(%ebp),%eax
  1039f3:	89 04 24             	mov    %eax,(%esp)
  1039f6:	e8 0f 01 00 00       	call   103b0a <tlb_invalidate>
    }
	else 
		cprintf("test_bit(PTE_P, ptep) error\n");
// #endif
}
  1039fb:	eb 0c                	jmp    103a09 <page_remove_pte+0x153>
		cprintf("test_bit(PTE_P, ptep) error\n");
  1039fd:	c7 04 24 e6 70 10 00 	movl   $0x1070e6,(%esp)
  103a04:	e8 7e c8 ff ff       	call   100287 <cprintf>
}
  103a09:	90                   	nop
  103a0a:	c9                   	leave  
  103a0b:	c3                   	ret    

00103a0c <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  103a0c:	55                   	push   %ebp
  103a0d:	89 e5                	mov    %esp,%ebp
  103a0f:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  103a12:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103a19:	00 
  103a1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  103a1d:	89 44 24 04          	mov    %eax,0x4(%esp)
  103a21:	8b 45 08             	mov    0x8(%ebp),%eax
  103a24:	89 04 24             	mov    %eax,(%esp)
  103a27:	e8 22 fc ff ff       	call   10364e <get_pte>
  103a2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
  103a2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103a33:	74 19                	je     103a4e <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
  103a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103a38:	89 44 24 08          	mov    %eax,0x8(%esp)
  103a3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  103a3f:	89 44 24 04          	mov    %eax,0x4(%esp)
  103a43:	8b 45 08             	mov    0x8(%ebp),%eax
  103a46:	89 04 24             	mov    %eax,(%esp)
  103a49:	e8 68 fe ff ff       	call   1038b6 <page_remove_pte>
    }
}
  103a4e:	90                   	nop
  103a4f:	c9                   	leave  
  103a50:	c3                   	ret    

00103a51 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  103a51:	55                   	push   %ebp
  103a52:	89 e5                	mov    %esp,%ebp
  103a54:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  103a57:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  103a5e:	00 
  103a5f:	8b 45 10             	mov    0x10(%ebp),%eax
  103a62:	89 44 24 04          	mov    %eax,0x4(%esp)
  103a66:	8b 45 08             	mov    0x8(%ebp),%eax
  103a69:	89 04 24             	mov    %eax,(%esp)
  103a6c:	e8 dd fb ff ff       	call   10364e <get_pte>
  103a71:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  103a74:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103a78:	75 0a                	jne    103a84 <page_insert+0x33>
        return -E_NO_MEM;
  103a7a:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  103a7f:	e9 84 00 00 00       	jmp    103b08 <page_insert+0xb7>
    }
    page_ref_inc(page);
  103a84:	8b 45 0c             	mov    0xc(%ebp),%eax
  103a87:	89 04 24             	mov    %eax,(%esp)
  103a8a:	e8 94 f3 ff ff       	call   102e23 <page_ref_inc>
    if (*ptep & PTE_P) {
  103a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103a92:	8b 00                	mov    (%eax),%eax
  103a94:	83 e0 01             	and    $0x1,%eax
  103a97:	85 c0                	test   %eax,%eax
  103a99:	74 3e                	je     103ad9 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
  103a9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103a9e:	8b 00                	mov    (%eax),%eax
  103aa0:	89 04 24             	mov    %eax,(%esp)
  103aa3:	e8 0d f3 ff ff       	call   102db5 <pte2page>
  103aa8:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  103aab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103aae:	3b 45 0c             	cmp    0xc(%ebp),%eax
  103ab1:	75 0d                	jne    103ac0 <page_insert+0x6f>
            page_ref_dec(page);
  103ab3:	8b 45 0c             	mov    0xc(%ebp),%eax
  103ab6:	89 04 24             	mov    %eax,(%esp)
  103ab9:	e8 7c f3 ff ff       	call   102e3a <page_ref_dec>
  103abe:	eb 19                	jmp    103ad9 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  103ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103ac3:	89 44 24 08          	mov    %eax,0x8(%esp)
  103ac7:	8b 45 10             	mov    0x10(%ebp),%eax
  103aca:	89 44 24 04          	mov    %eax,0x4(%esp)
  103ace:	8b 45 08             	mov    0x8(%ebp),%eax
  103ad1:	89 04 24             	mov    %eax,(%esp)
  103ad4:	e8 dd fd ff ff       	call   1038b6 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  103ad9:	8b 45 0c             	mov    0xc(%ebp),%eax
  103adc:	89 04 24             	mov    %eax,(%esp)
  103adf:	e8 1d f2 ff ff       	call   102d01 <page2pa>
  103ae4:	0b 45 14             	or     0x14(%ebp),%eax
  103ae7:	83 c8 01             	or     $0x1,%eax
  103aea:	89 c2                	mov    %eax,%edx
  103aec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103aef:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  103af1:	8b 45 10             	mov    0x10(%ebp),%eax
  103af4:	89 44 24 04          	mov    %eax,0x4(%esp)
  103af8:	8b 45 08             	mov    0x8(%ebp),%eax
  103afb:	89 04 24             	mov    %eax,(%esp)
  103afe:	e8 07 00 00 00       	call   103b0a <tlb_invalidate>
    return 0;
  103b03:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103b08:	c9                   	leave  
  103b09:	c3                   	ret    

00103b0a <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  103b0a:	55                   	push   %ebp
  103b0b:	89 e5                	mov    %esp,%ebp
  103b0d:	83 ec 10             	sub    $0x10,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  103b10:	0f 20 d8             	mov    %cr3,%eax
  103b13:	89 45 f8             	mov    %eax,-0x8(%ebp)
    return cr3;
  103b16:	8b 55 f8             	mov    -0x8(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
  103b19:	8b 45 08             	mov    0x8(%ebp),%eax
  103b1c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  103b1f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103b22:	39 d0                	cmp    %edx,%eax
  103b24:	75 0c                	jne    103b32 <tlb_invalidate+0x28>
        invlpg((void *)la);
  103b26:	8b 45 0c             	mov    0xc(%ebp),%eax
  103b29:	89 45 f4             	mov    %eax,-0xc(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  103b2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103b2f:	0f 01 38             	invlpg (%eax)
    }
}
  103b32:	90                   	nop
  103b33:	c9                   	leave  
  103b34:	c3                   	ret    

00103b35 <check_alloc_page>:

static void
check_alloc_page(void) {
  103b35:	55                   	push   %ebp
  103b36:	89 e5                	mov    %esp,%ebp
  103b38:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  103b3b:	a1 30 df 11 00       	mov    0x11df30,%eax
  103b40:	8b 40 18             	mov    0x18(%eax),%eax
  103b43:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  103b45:	c7 04 24 04 71 10 00 	movl   $0x107104,(%esp)
  103b4c:	e8 36 c7 ff ff       	call   100287 <cprintf>
}
  103b51:	90                   	nop
  103b52:	c9                   	leave  
  103b53:	c3                   	ret    

00103b54 <check_pgdir>:

static void
check_pgdir(void) {
  103b54:	55                   	push   %ebp
  103b55:	89 e5                	mov    %esp,%ebp
  103b57:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  103b5a:	a1 a0 de 11 00       	mov    0x11dea0,%eax
  103b5f:	3d 00 80 03 00       	cmp    $0x38000,%eax
  103b64:	76 24                	jbe    103b8a <check_pgdir+0x36>
  103b66:	c7 44 24 0c 23 71 10 	movl   $0x107123,0xc(%esp)
  103b6d:	00 
  103b6e:	c7 44 24 08 3b 70 10 	movl   $0x10703b,0x8(%esp)
  103b75:	00 
  103b76:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
  103b7d:	00 
  103b7e:	c7 04 24 50 70 10 00 	movl   $0x107050,(%esp)
  103b85:	e8 55 c8 ff ff       	call   1003df <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  103b8a:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  103b8f:	85 c0                	test   %eax,%eax
  103b91:	74 0e                	je     103ba1 <check_pgdir+0x4d>
  103b93:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  103b98:	25 ff 0f 00 00       	and    $0xfff,%eax
  103b9d:	85 c0                	test   %eax,%eax
  103b9f:	74 24                	je     103bc5 <check_pgdir+0x71>
  103ba1:	c7 44 24 0c 40 71 10 	movl   $0x107140,0xc(%esp)
  103ba8:	00 
  103ba9:	c7 44 24 08 3b 70 10 	movl   $0x10703b,0x8(%esp)
  103bb0:	00 
  103bb1:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
  103bb8:	00 
  103bb9:	c7 04 24 50 70 10 00 	movl   $0x107050,(%esp)
  103bc0:	e8 1a c8 ff ff       	call   1003df <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  103bc5:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  103bca:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103bd1:	00 
  103bd2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103bd9:	00 
  103bda:	89 04 24             	mov    %eax,(%esp)
  103bdd:	e8 7b fc ff ff       	call   10385d <get_page>
  103be2:	85 c0                	test   %eax,%eax
  103be4:	74 24                	je     103c0a <check_pgdir+0xb6>
  103be6:	c7 44 24 0c 78 71 10 	movl   $0x107178,0xc(%esp)
  103bed:	00 
  103bee:	c7 44 24 08 3b 70 10 	movl   $0x10703b,0x8(%esp)
  103bf5:	00 
  103bf6:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
  103bfd:	00 
  103bfe:	c7 04 24 50 70 10 00 	movl   $0x107050,(%esp)
  103c05:	e8 d5 c7 ff ff       	call   1003df <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  103c0a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103c11:	e8 fa f3 ff ff       	call   103010 <alloc_pages>
  103c16:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  103c19:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  103c1e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  103c25:	00 
  103c26:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103c2d:	00 
  103c2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103c31:	89 54 24 04          	mov    %edx,0x4(%esp)
  103c35:	89 04 24             	mov    %eax,(%esp)
  103c38:	e8 14 fe ff ff       	call   103a51 <page_insert>
  103c3d:	85 c0                	test   %eax,%eax
  103c3f:	74 24                	je     103c65 <check_pgdir+0x111>
  103c41:	c7 44 24 0c a0 71 10 	movl   $0x1071a0,0xc(%esp)
  103c48:	00 
  103c49:	c7 44 24 08 3b 70 10 	movl   $0x10703b,0x8(%esp)
  103c50:	00 
  103c51:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
  103c58:	00 
  103c59:	c7 04 24 50 70 10 00 	movl   $0x107050,(%esp)
  103c60:	e8 7a c7 ff ff       	call   1003df <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  103c65:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  103c6a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103c71:	00 
  103c72:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103c79:	00 
  103c7a:	89 04 24             	mov    %eax,(%esp)
  103c7d:	e8 cc f9 ff ff       	call   10364e <get_pte>
  103c82:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103c85:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103c89:	75 24                	jne    103caf <check_pgdir+0x15b>
  103c8b:	c7 44 24 0c cc 71 10 	movl   $0x1071cc,0xc(%esp)
  103c92:	00 
  103c93:	c7 44 24 08 3b 70 10 	movl   $0x10703b,0x8(%esp)
  103c9a:	00 
  103c9b:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
  103ca2:	00 
  103ca3:	c7 04 24 50 70 10 00 	movl   $0x107050,(%esp)
  103caa:	e8 30 c7 ff ff       	call   1003df <__panic>
    assert(pte2page(*ptep) == p1);
  103caf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103cb2:	8b 00                	mov    (%eax),%eax
  103cb4:	89 04 24             	mov    %eax,(%esp)
  103cb7:	e8 f9 f0 ff ff       	call   102db5 <pte2page>
  103cbc:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  103cbf:	74 24                	je     103ce5 <check_pgdir+0x191>
  103cc1:	c7 44 24 0c f9 71 10 	movl   $0x1071f9,0xc(%esp)
  103cc8:	00 
  103cc9:	c7 44 24 08 3b 70 10 	movl   $0x10703b,0x8(%esp)
  103cd0:	00 
  103cd1:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
  103cd8:	00 
  103cd9:	c7 04 24 50 70 10 00 	movl   $0x107050,(%esp)
  103ce0:	e8 fa c6 ff ff       	call   1003df <__panic>
    assert(page_ref(p1) == 1);
  103ce5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103ce8:	89 04 24             	mov    %eax,(%esp)
  103ceb:	e8 1b f1 ff ff       	call   102e0b <page_ref>
  103cf0:	83 f8 01             	cmp    $0x1,%eax
  103cf3:	74 24                	je     103d19 <check_pgdir+0x1c5>
  103cf5:	c7 44 24 0c 0f 72 10 	movl   $0x10720f,0xc(%esp)
  103cfc:	00 
  103cfd:	c7 44 24 08 3b 70 10 	movl   $0x10703b,0x8(%esp)
  103d04:	00 
  103d05:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
  103d0c:	00 
  103d0d:	c7 04 24 50 70 10 00 	movl   $0x107050,(%esp)
  103d14:	e8 c6 c6 ff ff       	call   1003df <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  103d19:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  103d1e:	8b 00                	mov    (%eax),%eax
  103d20:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103d25:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103d28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103d2b:	c1 e8 0c             	shr    $0xc,%eax
  103d2e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103d31:	a1 a0 de 11 00       	mov    0x11dea0,%eax
  103d36:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  103d39:	72 23                	jb     103d5e <check_pgdir+0x20a>
  103d3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103d3e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103d42:	c7 44 24 08 80 6f 10 	movl   $0x106f80,0x8(%esp)
  103d49:	00 
  103d4a:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
  103d51:	00 
  103d52:	c7 04 24 50 70 10 00 	movl   $0x107050,(%esp)
  103d59:	e8 81 c6 ff ff       	call   1003df <__panic>
  103d5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103d61:	83 c0 04             	add    $0x4,%eax
  103d64:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  103d67:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  103d6c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103d73:	00 
  103d74:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103d7b:	00 
  103d7c:	89 04 24             	mov    %eax,(%esp)
  103d7f:	e8 ca f8 ff ff       	call   10364e <get_pte>
  103d84:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  103d87:	74 24                	je     103dad <check_pgdir+0x259>
  103d89:	c7 44 24 0c 24 72 10 	movl   $0x107224,0xc(%esp)
  103d90:	00 
  103d91:	c7 44 24 08 3b 70 10 	movl   $0x10703b,0x8(%esp)
  103d98:	00 
  103d99:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
  103da0:	00 
  103da1:	c7 04 24 50 70 10 00 	movl   $0x107050,(%esp)
  103da8:	e8 32 c6 ff ff       	call   1003df <__panic>

    p2 = alloc_page();
  103dad:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103db4:	e8 57 f2 ff ff       	call   103010 <alloc_pages>
  103db9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  103dbc:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  103dc1:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  103dc8:	00 
  103dc9:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  103dd0:	00 
  103dd1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103dd4:	89 54 24 04          	mov    %edx,0x4(%esp)
  103dd8:	89 04 24             	mov    %eax,(%esp)
  103ddb:	e8 71 fc ff ff       	call   103a51 <page_insert>
  103de0:	85 c0                	test   %eax,%eax
  103de2:	74 24                	je     103e08 <check_pgdir+0x2b4>
  103de4:	c7 44 24 0c 4c 72 10 	movl   $0x10724c,0xc(%esp)
  103deb:	00 
  103dec:	c7 44 24 08 3b 70 10 	movl   $0x10703b,0x8(%esp)
  103df3:	00 
  103df4:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
  103dfb:	00 
  103dfc:	c7 04 24 50 70 10 00 	movl   $0x107050,(%esp)
  103e03:	e8 d7 c5 ff ff       	call   1003df <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  103e08:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  103e0d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103e14:	00 
  103e15:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103e1c:	00 
  103e1d:	89 04 24             	mov    %eax,(%esp)
  103e20:	e8 29 f8 ff ff       	call   10364e <get_pte>
  103e25:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103e28:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103e2c:	75 24                	jne    103e52 <check_pgdir+0x2fe>
  103e2e:	c7 44 24 0c 84 72 10 	movl   $0x107284,0xc(%esp)
  103e35:	00 
  103e36:	c7 44 24 08 3b 70 10 	movl   $0x10703b,0x8(%esp)
  103e3d:	00 
  103e3e:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
  103e45:	00 
  103e46:	c7 04 24 50 70 10 00 	movl   $0x107050,(%esp)
  103e4d:	e8 8d c5 ff ff       	call   1003df <__panic>
    assert(*ptep & PTE_U);
  103e52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103e55:	8b 00                	mov    (%eax),%eax
  103e57:	83 e0 04             	and    $0x4,%eax
  103e5a:	85 c0                	test   %eax,%eax
  103e5c:	75 24                	jne    103e82 <check_pgdir+0x32e>
  103e5e:	c7 44 24 0c b4 72 10 	movl   $0x1072b4,0xc(%esp)
  103e65:	00 
  103e66:	c7 44 24 08 3b 70 10 	movl   $0x10703b,0x8(%esp)
  103e6d:	00 
  103e6e:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
  103e75:	00 
  103e76:	c7 04 24 50 70 10 00 	movl   $0x107050,(%esp)
  103e7d:	e8 5d c5 ff ff       	call   1003df <__panic>
    assert(*ptep & PTE_W);
  103e82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103e85:	8b 00                	mov    (%eax),%eax
  103e87:	83 e0 02             	and    $0x2,%eax
  103e8a:	85 c0                	test   %eax,%eax
  103e8c:	75 24                	jne    103eb2 <check_pgdir+0x35e>
  103e8e:	c7 44 24 0c c2 72 10 	movl   $0x1072c2,0xc(%esp)
  103e95:	00 
  103e96:	c7 44 24 08 3b 70 10 	movl   $0x10703b,0x8(%esp)
  103e9d:	00 
  103e9e:	c7 44 24 04 15 02 00 	movl   $0x215,0x4(%esp)
  103ea5:	00 
  103ea6:	c7 04 24 50 70 10 00 	movl   $0x107050,(%esp)
  103ead:	e8 2d c5 ff ff       	call   1003df <__panic>
    assert(boot_pgdir[0] & PTE_U);
  103eb2:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  103eb7:	8b 00                	mov    (%eax),%eax
  103eb9:	83 e0 04             	and    $0x4,%eax
  103ebc:	85 c0                	test   %eax,%eax
  103ebe:	75 24                	jne    103ee4 <check_pgdir+0x390>
  103ec0:	c7 44 24 0c d0 72 10 	movl   $0x1072d0,0xc(%esp)
  103ec7:	00 
  103ec8:	c7 44 24 08 3b 70 10 	movl   $0x10703b,0x8(%esp)
  103ecf:	00 
  103ed0:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
  103ed7:	00 
  103ed8:	c7 04 24 50 70 10 00 	movl   $0x107050,(%esp)
  103edf:	e8 fb c4 ff ff       	call   1003df <__panic>
    assert(page_ref(p2) == 1);
  103ee4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103ee7:	89 04 24             	mov    %eax,(%esp)
  103eea:	e8 1c ef ff ff       	call   102e0b <page_ref>
  103eef:	83 f8 01             	cmp    $0x1,%eax
  103ef2:	74 24                	je     103f18 <check_pgdir+0x3c4>
  103ef4:	c7 44 24 0c e6 72 10 	movl   $0x1072e6,0xc(%esp)
  103efb:	00 
  103efc:	c7 44 24 08 3b 70 10 	movl   $0x10703b,0x8(%esp)
  103f03:	00 
  103f04:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
  103f0b:	00 
  103f0c:	c7 04 24 50 70 10 00 	movl   $0x107050,(%esp)
  103f13:	e8 c7 c4 ff ff       	call   1003df <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  103f18:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  103f1d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  103f24:	00 
  103f25:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  103f2c:	00 
  103f2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103f30:	89 54 24 04          	mov    %edx,0x4(%esp)
  103f34:	89 04 24             	mov    %eax,(%esp)
  103f37:	e8 15 fb ff ff       	call   103a51 <page_insert>
  103f3c:	85 c0                	test   %eax,%eax
  103f3e:	74 24                	je     103f64 <check_pgdir+0x410>
  103f40:	c7 44 24 0c f8 72 10 	movl   $0x1072f8,0xc(%esp)
  103f47:	00 
  103f48:	c7 44 24 08 3b 70 10 	movl   $0x10703b,0x8(%esp)
  103f4f:	00 
  103f50:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
  103f57:	00 
  103f58:	c7 04 24 50 70 10 00 	movl   $0x107050,(%esp)
  103f5f:	e8 7b c4 ff ff       	call   1003df <__panic>
    assert(page_ref(p1) == 2);
  103f64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103f67:	89 04 24             	mov    %eax,(%esp)
  103f6a:	e8 9c ee ff ff       	call   102e0b <page_ref>
  103f6f:	83 f8 02             	cmp    $0x2,%eax
  103f72:	74 24                	je     103f98 <check_pgdir+0x444>
  103f74:	c7 44 24 0c 24 73 10 	movl   $0x107324,0xc(%esp)
  103f7b:	00 
  103f7c:	c7 44 24 08 3b 70 10 	movl   $0x10703b,0x8(%esp)
  103f83:	00 
  103f84:	c7 44 24 04 1a 02 00 	movl   $0x21a,0x4(%esp)
  103f8b:	00 
  103f8c:	c7 04 24 50 70 10 00 	movl   $0x107050,(%esp)
  103f93:	e8 47 c4 ff ff       	call   1003df <__panic>
    assert(page_ref(p2) == 0);
  103f98:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103f9b:	89 04 24             	mov    %eax,(%esp)
  103f9e:	e8 68 ee ff ff       	call   102e0b <page_ref>
  103fa3:	85 c0                	test   %eax,%eax
  103fa5:	74 24                	je     103fcb <check_pgdir+0x477>
  103fa7:	c7 44 24 0c 36 73 10 	movl   $0x107336,0xc(%esp)
  103fae:	00 
  103faf:	c7 44 24 08 3b 70 10 	movl   $0x10703b,0x8(%esp)
  103fb6:	00 
  103fb7:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
  103fbe:	00 
  103fbf:	c7 04 24 50 70 10 00 	movl   $0x107050,(%esp)
  103fc6:	e8 14 c4 ff ff       	call   1003df <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  103fcb:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  103fd0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103fd7:	00 
  103fd8:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103fdf:	00 
  103fe0:	89 04 24             	mov    %eax,(%esp)
  103fe3:	e8 66 f6 ff ff       	call   10364e <get_pte>
  103fe8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103feb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103fef:	75 24                	jne    104015 <check_pgdir+0x4c1>
  103ff1:	c7 44 24 0c 84 72 10 	movl   $0x107284,0xc(%esp)
  103ff8:	00 
  103ff9:	c7 44 24 08 3b 70 10 	movl   $0x10703b,0x8(%esp)
  104000:	00 
  104001:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
  104008:	00 
  104009:	c7 04 24 50 70 10 00 	movl   $0x107050,(%esp)
  104010:	e8 ca c3 ff ff       	call   1003df <__panic>
    assert(pte2page(*ptep) == p1);
  104015:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104018:	8b 00                	mov    (%eax),%eax
  10401a:	89 04 24             	mov    %eax,(%esp)
  10401d:	e8 93 ed ff ff       	call   102db5 <pte2page>
  104022:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104025:	74 24                	je     10404b <check_pgdir+0x4f7>
  104027:	c7 44 24 0c f9 71 10 	movl   $0x1071f9,0xc(%esp)
  10402e:	00 
  10402f:	c7 44 24 08 3b 70 10 	movl   $0x10703b,0x8(%esp)
  104036:	00 
  104037:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
  10403e:	00 
  10403f:	c7 04 24 50 70 10 00 	movl   $0x107050,(%esp)
  104046:	e8 94 c3 ff ff       	call   1003df <__panic>
    assert((*ptep & PTE_U) == 0);
  10404b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10404e:	8b 00                	mov    (%eax),%eax
  104050:	83 e0 04             	and    $0x4,%eax
  104053:	85 c0                	test   %eax,%eax
  104055:	74 24                	je     10407b <check_pgdir+0x527>
  104057:	c7 44 24 0c 48 73 10 	movl   $0x107348,0xc(%esp)
  10405e:	00 
  10405f:	c7 44 24 08 3b 70 10 	movl   $0x10703b,0x8(%esp)
  104066:	00 
  104067:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
  10406e:	00 
  10406f:	c7 04 24 50 70 10 00 	movl   $0x107050,(%esp)
  104076:	e8 64 c3 ff ff       	call   1003df <__panic>

    page_remove(boot_pgdir, 0x0);
  10407b:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  104080:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104087:	00 
  104088:	89 04 24             	mov    %eax,(%esp)
  10408b:	e8 7c f9 ff ff       	call   103a0c <page_remove>
    assert(page_ref(p1) == 1);
  104090:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104093:	89 04 24             	mov    %eax,(%esp)
  104096:	e8 70 ed ff ff       	call   102e0b <page_ref>
  10409b:	83 f8 01             	cmp    $0x1,%eax
  10409e:	74 24                	je     1040c4 <check_pgdir+0x570>
  1040a0:	c7 44 24 0c 0f 72 10 	movl   $0x10720f,0xc(%esp)
  1040a7:	00 
  1040a8:	c7 44 24 08 3b 70 10 	movl   $0x10703b,0x8(%esp)
  1040af:	00 
  1040b0:	c7 44 24 04 21 02 00 	movl   $0x221,0x4(%esp)
  1040b7:	00 
  1040b8:	c7 04 24 50 70 10 00 	movl   $0x107050,(%esp)
  1040bf:	e8 1b c3 ff ff       	call   1003df <__panic>
    assert(page_ref(p2) == 0);
  1040c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1040c7:	89 04 24             	mov    %eax,(%esp)
  1040ca:	e8 3c ed ff ff       	call   102e0b <page_ref>
  1040cf:	85 c0                	test   %eax,%eax
  1040d1:	74 24                	je     1040f7 <check_pgdir+0x5a3>
  1040d3:	c7 44 24 0c 36 73 10 	movl   $0x107336,0xc(%esp)
  1040da:	00 
  1040db:	c7 44 24 08 3b 70 10 	movl   $0x10703b,0x8(%esp)
  1040e2:	00 
  1040e3:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
  1040ea:	00 
  1040eb:	c7 04 24 50 70 10 00 	movl   $0x107050,(%esp)
  1040f2:	e8 e8 c2 ff ff       	call   1003df <__panic>

    page_remove(boot_pgdir, PGSIZE);
  1040f7:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  1040fc:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104103:	00 
  104104:	89 04 24             	mov    %eax,(%esp)
  104107:	e8 00 f9 ff ff       	call   103a0c <page_remove>
    assert(page_ref(p1) == 0);
  10410c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10410f:	89 04 24             	mov    %eax,(%esp)
  104112:	e8 f4 ec ff ff       	call   102e0b <page_ref>
  104117:	85 c0                	test   %eax,%eax
  104119:	74 24                	je     10413f <check_pgdir+0x5eb>
  10411b:	c7 44 24 0c 5d 73 10 	movl   $0x10735d,0xc(%esp)
  104122:	00 
  104123:	c7 44 24 08 3b 70 10 	movl   $0x10703b,0x8(%esp)
  10412a:	00 
  10412b:	c7 44 24 04 25 02 00 	movl   $0x225,0x4(%esp)
  104132:	00 
  104133:	c7 04 24 50 70 10 00 	movl   $0x107050,(%esp)
  10413a:	e8 a0 c2 ff ff       	call   1003df <__panic>
    assert(page_ref(p2) == 0);
  10413f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104142:	89 04 24             	mov    %eax,(%esp)
  104145:	e8 c1 ec ff ff       	call   102e0b <page_ref>
  10414a:	85 c0                	test   %eax,%eax
  10414c:	74 24                	je     104172 <check_pgdir+0x61e>
  10414e:	c7 44 24 0c 36 73 10 	movl   $0x107336,0xc(%esp)
  104155:	00 
  104156:	c7 44 24 08 3b 70 10 	movl   $0x10703b,0x8(%esp)
  10415d:	00 
  10415e:	c7 44 24 04 26 02 00 	movl   $0x226,0x4(%esp)
  104165:	00 
  104166:	c7 04 24 50 70 10 00 	movl   $0x107050,(%esp)
  10416d:	e8 6d c2 ff ff       	call   1003df <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
  104172:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  104177:	8b 00                	mov    (%eax),%eax
  104179:	89 04 24             	mov    %eax,(%esp)
  10417c:	e8 72 ec ff ff       	call   102df3 <pde2page>
  104181:	89 04 24             	mov    %eax,(%esp)
  104184:	e8 82 ec ff ff       	call   102e0b <page_ref>
  104189:	83 f8 01             	cmp    $0x1,%eax
  10418c:	74 24                	je     1041b2 <check_pgdir+0x65e>
  10418e:	c7 44 24 0c 70 73 10 	movl   $0x107370,0xc(%esp)
  104195:	00 
  104196:	c7 44 24 08 3b 70 10 	movl   $0x10703b,0x8(%esp)
  10419d:	00 
  10419e:	c7 44 24 04 28 02 00 	movl   $0x228,0x4(%esp)
  1041a5:	00 
  1041a6:	c7 04 24 50 70 10 00 	movl   $0x107050,(%esp)
  1041ad:	e8 2d c2 ff ff       	call   1003df <__panic>
    free_page(pde2page(boot_pgdir[0]));
  1041b2:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  1041b7:	8b 00                	mov    (%eax),%eax
  1041b9:	89 04 24             	mov    %eax,(%esp)
  1041bc:	e8 32 ec ff ff       	call   102df3 <pde2page>
  1041c1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1041c8:	00 
  1041c9:	89 04 24             	mov    %eax,(%esp)
  1041cc:	e8 77 ee ff ff       	call   103048 <free_pages>
    boot_pgdir[0] = 0;
  1041d1:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  1041d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  1041dc:	c7 04 24 97 73 10 00 	movl   $0x107397,(%esp)
  1041e3:	e8 9f c0 ff ff       	call   100287 <cprintf>
}
  1041e8:	90                   	nop
  1041e9:	c9                   	leave  
  1041ea:	c3                   	ret    

001041eb <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  1041eb:	55                   	push   %ebp
  1041ec:	89 e5                	mov    %esp,%ebp
  1041ee:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  1041f1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1041f8:	e9 c5 00 00 00       	jmp    1042c2 <check_boot_pgdir+0xd7>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  1041fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104200:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104203:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104206:	c1 e8 0c             	shr    $0xc,%eax
  104209:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10420c:	a1 a0 de 11 00       	mov    0x11dea0,%eax
  104211:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  104214:	72 23                	jb     104239 <check_boot_pgdir+0x4e>
  104216:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104219:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10421d:	c7 44 24 08 80 6f 10 	movl   $0x106f80,0x8(%esp)
  104224:	00 
  104225:	c7 44 24 04 34 02 00 	movl   $0x234,0x4(%esp)
  10422c:	00 
  10422d:	c7 04 24 50 70 10 00 	movl   $0x107050,(%esp)
  104234:	e8 a6 c1 ff ff       	call   1003df <__panic>
  104239:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10423c:	89 c2                	mov    %eax,%edx
  10423e:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  104243:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10424a:	00 
  10424b:	89 54 24 04          	mov    %edx,0x4(%esp)
  10424f:	89 04 24             	mov    %eax,(%esp)
  104252:	e8 f7 f3 ff ff       	call   10364e <get_pte>
  104257:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10425a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10425e:	75 24                	jne    104284 <check_boot_pgdir+0x99>
  104260:	c7 44 24 0c b4 73 10 	movl   $0x1073b4,0xc(%esp)
  104267:	00 
  104268:	c7 44 24 08 3b 70 10 	movl   $0x10703b,0x8(%esp)
  10426f:	00 
  104270:	c7 44 24 04 34 02 00 	movl   $0x234,0x4(%esp)
  104277:	00 
  104278:	c7 04 24 50 70 10 00 	movl   $0x107050,(%esp)
  10427f:	e8 5b c1 ff ff       	call   1003df <__panic>
        assert(PTE_ADDR(*ptep) == i);
  104284:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104287:	8b 00                	mov    (%eax),%eax
  104289:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10428e:	89 c2                	mov    %eax,%edx
  104290:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104293:	39 c2                	cmp    %eax,%edx
  104295:	74 24                	je     1042bb <check_boot_pgdir+0xd0>
  104297:	c7 44 24 0c f1 73 10 	movl   $0x1073f1,0xc(%esp)
  10429e:	00 
  10429f:	c7 44 24 08 3b 70 10 	movl   $0x10703b,0x8(%esp)
  1042a6:	00 
  1042a7:	c7 44 24 04 35 02 00 	movl   $0x235,0x4(%esp)
  1042ae:	00 
  1042af:	c7 04 24 50 70 10 00 	movl   $0x107050,(%esp)
  1042b6:	e8 24 c1 ff ff       	call   1003df <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
  1042bb:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  1042c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1042c5:	a1 a0 de 11 00       	mov    0x11dea0,%eax
  1042ca:	39 c2                	cmp    %eax,%edx
  1042cc:	0f 82 2b ff ff ff    	jb     1041fd <check_boot_pgdir+0x12>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  1042d2:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  1042d7:	05 2c 0c 00 00       	add    $0xc2c,%eax
  1042dc:	8b 00                	mov    (%eax),%eax
  1042de:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1042e3:	89 c2                	mov    %eax,%edx
  1042e5:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  1042ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1042ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1042f0:	39 d0                	cmp    %edx,%eax
  1042f2:	74 24                	je     104318 <check_boot_pgdir+0x12d>
  1042f4:	c7 44 24 0c 08 74 10 	movl   $0x107408,0xc(%esp)
  1042fb:	00 
  1042fc:	c7 44 24 08 3b 70 10 	movl   $0x10703b,0x8(%esp)
  104303:	00 
  104304:	c7 44 24 04 38 02 00 	movl   $0x238,0x4(%esp)
  10430b:	00 
  10430c:	c7 04 24 50 70 10 00 	movl   $0x107050,(%esp)
  104313:	e8 c7 c0 ff ff       	call   1003df <__panic>

    assert(boot_pgdir[0] == 0);
  104318:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  10431d:	8b 00                	mov    (%eax),%eax
  10431f:	85 c0                	test   %eax,%eax
  104321:	74 24                	je     104347 <check_boot_pgdir+0x15c>
  104323:	c7 44 24 0c 3c 74 10 	movl   $0x10743c,0xc(%esp)
  10432a:	00 
  10432b:	c7 44 24 08 3b 70 10 	movl   $0x10703b,0x8(%esp)
  104332:	00 
  104333:	c7 44 24 04 3a 02 00 	movl   $0x23a,0x4(%esp)
  10433a:	00 
  10433b:	c7 04 24 50 70 10 00 	movl   $0x107050,(%esp)
  104342:	e8 98 c0 ff ff       	call   1003df <__panic>

    struct Page *p;
    p = alloc_page();
  104347:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10434e:	e8 bd ec ff ff       	call   103010 <alloc_pages>
  104353:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  104356:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  10435b:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  104362:	00 
  104363:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  10436a:	00 
  10436b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10436e:	89 54 24 04          	mov    %edx,0x4(%esp)
  104372:	89 04 24             	mov    %eax,(%esp)
  104375:	e8 d7 f6 ff ff       	call   103a51 <page_insert>
  10437a:	85 c0                	test   %eax,%eax
  10437c:	74 24                	je     1043a2 <check_boot_pgdir+0x1b7>
  10437e:	c7 44 24 0c 50 74 10 	movl   $0x107450,0xc(%esp)
  104385:	00 
  104386:	c7 44 24 08 3b 70 10 	movl   $0x10703b,0x8(%esp)
  10438d:	00 
  10438e:	c7 44 24 04 3e 02 00 	movl   $0x23e,0x4(%esp)
  104395:	00 
  104396:	c7 04 24 50 70 10 00 	movl   $0x107050,(%esp)
  10439d:	e8 3d c0 ff ff       	call   1003df <__panic>
    assert(page_ref(p) == 1);
  1043a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1043a5:	89 04 24             	mov    %eax,(%esp)
  1043a8:	e8 5e ea ff ff       	call   102e0b <page_ref>
  1043ad:	83 f8 01             	cmp    $0x1,%eax
  1043b0:	74 24                	je     1043d6 <check_boot_pgdir+0x1eb>
  1043b2:	c7 44 24 0c 7e 74 10 	movl   $0x10747e,0xc(%esp)
  1043b9:	00 
  1043ba:	c7 44 24 08 3b 70 10 	movl   $0x10703b,0x8(%esp)
  1043c1:	00 
  1043c2:	c7 44 24 04 3f 02 00 	movl   $0x23f,0x4(%esp)
  1043c9:	00 
  1043ca:	c7 04 24 50 70 10 00 	movl   $0x107050,(%esp)
  1043d1:	e8 09 c0 ff ff       	call   1003df <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  1043d6:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  1043db:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  1043e2:	00 
  1043e3:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  1043ea:	00 
  1043eb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1043ee:	89 54 24 04          	mov    %edx,0x4(%esp)
  1043f2:	89 04 24             	mov    %eax,(%esp)
  1043f5:	e8 57 f6 ff ff       	call   103a51 <page_insert>
  1043fa:	85 c0                	test   %eax,%eax
  1043fc:	74 24                	je     104422 <check_boot_pgdir+0x237>
  1043fe:	c7 44 24 0c 90 74 10 	movl   $0x107490,0xc(%esp)
  104405:	00 
  104406:	c7 44 24 08 3b 70 10 	movl   $0x10703b,0x8(%esp)
  10440d:	00 
  10440e:	c7 44 24 04 40 02 00 	movl   $0x240,0x4(%esp)
  104415:	00 
  104416:	c7 04 24 50 70 10 00 	movl   $0x107050,(%esp)
  10441d:	e8 bd bf ff ff       	call   1003df <__panic>
    assert(page_ref(p) == 2);
  104422:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104425:	89 04 24             	mov    %eax,(%esp)
  104428:	e8 de e9 ff ff       	call   102e0b <page_ref>
  10442d:	83 f8 02             	cmp    $0x2,%eax
  104430:	74 24                	je     104456 <check_boot_pgdir+0x26b>
  104432:	c7 44 24 0c c7 74 10 	movl   $0x1074c7,0xc(%esp)
  104439:	00 
  10443a:	c7 44 24 08 3b 70 10 	movl   $0x10703b,0x8(%esp)
  104441:	00 
  104442:	c7 44 24 04 41 02 00 	movl   $0x241,0x4(%esp)
  104449:	00 
  10444a:	c7 04 24 50 70 10 00 	movl   $0x107050,(%esp)
  104451:	e8 89 bf ff ff       	call   1003df <__panic>

    const char *str = "ucore: Hello world!!";
  104456:	c7 45 dc d8 74 10 00 	movl   $0x1074d8,-0x24(%ebp)
    strcpy((void *)0x100, str);
  10445d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104460:	89 44 24 04          	mov    %eax,0x4(%esp)
  104464:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  10446b:	e8 cf 18 00 00       	call   105d3f <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  104470:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  104477:	00 
  104478:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  10447f:	e8 32 19 00 00       	call   105db6 <strcmp>
  104484:	85 c0                	test   %eax,%eax
  104486:	74 24                	je     1044ac <check_boot_pgdir+0x2c1>
  104488:	c7 44 24 0c f0 74 10 	movl   $0x1074f0,0xc(%esp)
  10448f:	00 
  104490:	c7 44 24 08 3b 70 10 	movl   $0x10703b,0x8(%esp)
  104497:	00 
  104498:	c7 44 24 04 45 02 00 	movl   $0x245,0x4(%esp)
  10449f:	00 
  1044a0:	c7 04 24 50 70 10 00 	movl   $0x107050,(%esp)
  1044a7:	e8 33 bf ff ff       	call   1003df <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  1044ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1044af:	89 04 24             	mov    %eax,(%esp)
  1044b2:	e8 af e8 ff ff       	call   102d66 <page2kva>
  1044b7:	05 00 01 00 00       	add    $0x100,%eax
  1044bc:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  1044bf:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1044c6:	e8 1e 18 00 00       	call   105ce9 <strlen>
  1044cb:	85 c0                	test   %eax,%eax
  1044cd:	74 24                	je     1044f3 <check_boot_pgdir+0x308>
  1044cf:	c7 44 24 0c 28 75 10 	movl   $0x107528,0xc(%esp)
  1044d6:	00 
  1044d7:	c7 44 24 08 3b 70 10 	movl   $0x10703b,0x8(%esp)
  1044de:	00 
  1044df:	c7 44 24 04 48 02 00 	movl   $0x248,0x4(%esp)
  1044e6:	00 
  1044e7:	c7 04 24 50 70 10 00 	movl   $0x107050,(%esp)
  1044ee:	e8 ec be ff ff       	call   1003df <__panic>

    free_page(p);
  1044f3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1044fa:	00 
  1044fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1044fe:	89 04 24             	mov    %eax,(%esp)
  104501:	e8 42 eb ff ff       	call   103048 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
  104506:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  10450b:	8b 00                	mov    (%eax),%eax
  10450d:	89 04 24             	mov    %eax,(%esp)
  104510:	e8 de e8 ff ff       	call   102df3 <pde2page>
  104515:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10451c:	00 
  10451d:	89 04 24             	mov    %eax,(%esp)
  104520:	e8 23 eb ff ff       	call   103048 <free_pages>
    boot_pgdir[0] = 0;
  104525:	a1 e0 a9 11 00       	mov    0x11a9e0,%eax
  10452a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  104530:	c7 04 24 4c 75 10 00 	movl   $0x10754c,(%esp)
  104537:	e8 4b bd ff ff       	call   100287 <cprintf>
}
  10453c:	90                   	nop
  10453d:	c9                   	leave  
  10453e:	c3                   	ret    

0010453f <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  10453f:	55                   	push   %ebp
  104540:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  104542:	8b 45 08             	mov    0x8(%ebp),%eax
  104545:	83 e0 04             	and    $0x4,%eax
  104548:	85 c0                	test   %eax,%eax
  10454a:	74 04                	je     104550 <perm2str+0x11>
  10454c:	b0 75                	mov    $0x75,%al
  10454e:	eb 02                	jmp    104552 <perm2str+0x13>
  104550:	b0 2d                	mov    $0x2d,%al
  104552:	a2 28 df 11 00       	mov    %al,0x11df28
    str[1] = 'r';
  104557:	c6 05 29 df 11 00 72 	movb   $0x72,0x11df29
    str[2] = (perm & PTE_W) ? 'w' : '-';
  10455e:	8b 45 08             	mov    0x8(%ebp),%eax
  104561:	83 e0 02             	and    $0x2,%eax
  104564:	85 c0                	test   %eax,%eax
  104566:	74 04                	je     10456c <perm2str+0x2d>
  104568:	b0 77                	mov    $0x77,%al
  10456a:	eb 02                	jmp    10456e <perm2str+0x2f>
  10456c:	b0 2d                	mov    $0x2d,%al
  10456e:	a2 2a df 11 00       	mov    %al,0x11df2a
    str[3] = '\0';
  104573:	c6 05 2b df 11 00 00 	movb   $0x0,0x11df2b
    return str;
  10457a:	b8 28 df 11 00       	mov    $0x11df28,%eax
}
  10457f:	5d                   	pop    %ebp
  104580:	c3                   	ret    

00104581 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  104581:	55                   	push   %ebp
  104582:	89 e5                	mov    %esp,%ebp
  104584:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  104587:	8b 45 10             	mov    0x10(%ebp),%eax
  10458a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10458d:	72 0d                	jb     10459c <get_pgtable_items+0x1b>
        return 0;
  10458f:	b8 00 00 00 00       	mov    $0x0,%eax
  104594:	e9 98 00 00 00       	jmp    104631 <get_pgtable_items+0xb0>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
  104599:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
  10459c:	8b 45 10             	mov    0x10(%ebp),%eax
  10459f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1045a2:	73 18                	jae    1045bc <get_pgtable_items+0x3b>
  1045a4:	8b 45 10             	mov    0x10(%ebp),%eax
  1045a7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1045ae:	8b 45 14             	mov    0x14(%ebp),%eax
  1045b1:	01 d0                	add    %edx,%eax
  1045b3:	8b 00                	mov    (%eax),%eax
  1045b5:	83 e0 01             	and    $0x1,%eax
  1045b8:	85 c0                	test   %eax,%eax
  1045ba:	74 dd                	je     104599 <get_pgtable_items+0x18>
    }
    if (start < right) {
  1045bc:	8b 45 10             	mov    0x10(%ebp),%eax
  1045bf:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1045c2:	73 68                	jae    10462c <get_pgtable_items+0xab>
        if (left_store != NULL) {
  1045c4:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  1045c8:	74 08                	je     1045d2 <get_pgtable_items+0x51>
            *left_store = start;
  1045ca:	8b 45 18             	mov    0x18(%ebp),%eax
  1045cd:	8b 55 10             	mov    0x10(%ebp),%edx
  1045d0:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  1045d2:	8b 45 10             	mov    0x10(%ebp),%eax
  1045d5:	8d 50 01             	lea    0x1(%eax),%edx
  1045d8:	89 55 10             	mov    %edx,0x10(%ebp)
  1045db:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1045e2:	8b 45 14             	mov    0x14(%ebp),%eax
  1045e5:	01 d0                	add    %edx,%eax
  1045e7:	8b 00                	mov    (%eax),%eax
  1045e9:	83 e0 07             	and    $0x7,%eax
  1045ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  1045ef:	eb 03                	jmp    1045f4 <get_pgtable_items+0x73>
            start ++;
  1045f1:	ff 45 10             	incl   0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  1045f4:	8b 45 10             	mov    0x10(%ebp),%eax
  1045f7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1045fa:	73 1d                	jae    104619 <get_pgtable_items+0x98>
  1045fc:	8b 45 10             	mov    0x10(%ebp),%eax
  1045ff:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  104606:	8b 45 14             	mov    0x14(%ebp),%eax
  104609:	01 d0                	add    %edx,%eax
  10460b:	8b 00                	mov    (%eax),%eax
  10460d:	83 e0 07             	and    $0x7,%eax
  104610:	89 c2                	mov    %eax,%edx
  104612:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104615:	39 c2                	cmp    %eax,%edx
  104617:	74 d8                	je     1045f1 <get_pgtable_items+0x70>
        }
        if (right_store != NULL) {
  104619:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  10461d:	74 08                	je     104627 <get_pgtable_items+0xa6>
            *right_store = start;
  10461f:	8b 45 1c             	mov    0x1c(%ebp),%eax
  104622:	8b 55 10             	mov    0x10(%ebp),%edx
  104625:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  104627:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10462a:	eb 05                	jmp    104631 <get_pgtable_items+0xb0>
    }
    return 0;
  10462c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  104631:	c9                   	leave  
  104632:	c3                   	ret    

00104633 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  104633:	55                   	push   %ebp
  104634:	89 e5                	mov    %esp,%ebp
  104636:	57                   	push   %edi
  104637:	56                   	push   %esi
  104638:	53                   	push   %ebx
  104639:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  10463c:	c7 04 24 6c 75 10 00 	movl   $0x10756c,(%esp)
  104643:	e8 3f bc ff ff       	call   100287 <cprintf>
    size_t left, right = 0, perm;
  104648:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  10464f:	e9 fa 00 00 00       	jmp    10474e <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  104654:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104657:	89 04 24             	mov    %eax,(%esp)
  10465a:	e8 e0 fe ff ff       	call   10453f <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  10465f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  104662:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104665:	29 d1                	sub    %edx,%ecx
  104667:	89 ca                	mov    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  104669:	89 d6                	mov    %edx,%esi
  10466b:	c1 e6 16             	shl    $0x16,%esi
  10466e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104671:	89 d3                	mov    %edx,%ebx
  104673:	c1 e3 16             	shl    $0x16,%ebx
  104676:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104679:	89 d1                	mov    %edx,%ecx
  10467b:	c1 e1 16             	shl    $0x16,%ecx
  10467e:	8b 7d dc             	mov    -0x24(%ebp),%edi
  104681:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104684:	29 d7                	sub    %edx,%edi
  104686:	89 fa                	mov    %edi,%edx
  104688:	89 44 24 14          	mov    %eax,0x14(%esp)
  10468c:	89 74 24 10          	mov    %esi,0x10(%esp)
  104690:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  104694:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  104698:	89 54 24 04          	mov    %edx,0x4(%esp)
  10469c:	c7 04 24 9d 75 10 00 	movl   $0x10759d,(%esp)
  1046a3:	e8 df bb ff ff       	call   100287 <cprintf>
        size_t l, r = left * NPTEENTRY;
  1046a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1046ab:	c1 e0 0a             	shl    $0xa,%eax
  1046ae:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  1046b1:	eb 54                	jmp    104707 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  1046b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1046b6:	89 04 24             	mov    %eax,(%esp)
  1046b9:	e8 81 fe ff ff       	call   10453f <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  1046be:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  1046c1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1046c4:	29 d1                	sub    %edx,%ecx
  1046c6:	89 ca                	mov    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  1046c8:	89 d6                	mov    %edx,%esi
  1046ca:	c1 e6 0c             	shl    $0xc,%esi
  1046cd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1046d0:	89 d3                	mov    %edx,%ebx
  1046d2:	c1 e3 0c             	shl    $0xc,%ebx
  1046d5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1046d8:	89 d1                	mov    %edx,%ecx
  1046da:	c1 e1 0c             	shl    $0xc,%ecx
  1046dd:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  1046e0:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1046e3:	29 d7                	sub    %edx,%edi
  1046e5:	89 fa                	mov    %edi,%edx
  1046e7:	89 44 24 14          	mov    %eax,0x14(%esp)
  1046eb:	89 74 24 10          	mov    %esi,0x10(%esp)
  1046ef:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1046f3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1046f7:	89 54 24 04          	mov    %edx,0x4(%esp)
  1046fb:	c7 04 24 bc 75 10 00 	movl   $0x1075bc,(%esp)
  104702:	e8 80 bb ff ff       	call   100287 <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  104707:	be 00 00 c0 c2       	mov    $0xc2c00000,%esi
  10470c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10470f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104712:	89 d3                	mov    %edx,%ebx
  104714:	c1 e3 0a             	shl    $0xa,%ebx
  104717:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10471a:	89 d1                	mov    %edx,%ecx
  10471c:	c1 e1 0a             	shl    $0xa,%ecx
  10471f:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  104722:	89 54 24 14          	mov    %edx,0x14(%esp)
  104726:	8d 55 d8             	lea    -0x28(%ebp),%edx
  104729:	89 54 24 10          	mov    %edx,0x10(%esp)
  10472d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  104731:	89 44 24 08          	mov    %eax,0x8(%esp)
  104735:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104739:	89 0c 24             	mov    %ecx,(%esp)
  10473c:	e8 40 fe ff ff       	call   104581 <get_pgtable_items>
  104741:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104744:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  104748:	0f 85 65 ff ff ff    	jne    1046b3 <print_pgdir+0x80>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  10474e:	b9 00 b0 f0 c2       	mov    $0xc2f0b000,%ecx
  104753:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104756:	8d 55 dc             	lea    -0x24(%ebp),%edx
  104759:	89 54 24 14          	mov    %edx,0x14(%esp)
  10475d:	8d 55 e0             	lea    -0x20(%ebp),%edx
  104760:	89 54 24 10          	mov    %edx,0x10(%esp)
  104764:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  104768:	89 44 24 08          	mov    %eax,0x8(%esp)
  10476c:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  104773:	00 
  104774:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10477b:	e8 01 fe ff ff       	call   104581 <get_pgtable_items>
  104780:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104783:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  104787:	0f 85 c7 fe ff ff    	jne    104654 <print_pgdir+0x21>
        }
    }
    cprintf("--------------------- END ---------------------\n");
  10478d:	c7 04 24 e0 75 10 00 	movl   $0x1075e0,(%esp)
  104794:	e8 ee ba ff ff       	call   100287 <cprintf>
}
  104799:	90                   	nop
  10479a:	83 c4 4c             	add    $0x4c,%esp
  10479d:	5b                   	pop    %ebx
  10479e:	5e                   	pop    %esi
  10479f:	5f                   	pop    %edi
  1047a0:	5d                   	pop    %ebp
  1047a1:	c3                   	ret    

001047a2 <page2ppn>:
page2ppn(struct Page *page) {
  1047a2:	55                   	push   %ebp
  1047a3:	89 e5                	mov    %esp,%ebp
    return page - pages;
  1047a5:	a1 38 df 11 00       	mov    0x11df38,%eax
  1047aa:	8b 55 08             	mov    0x8(%ebp),%edx
  1047ad:	29 c2                	sub    %eax,%edx
  1047af:	89 d0                	mov    %edx,%eax
  1047b1:	c1 f8 02             	sar    $0x2,%eax
  1047b4:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  1047ba:	5d                   	pop    %ebp
  1047bb:	c3                   	ret    

001047bc <page2pa>:
page2pa(struct Page *page) {
  1047bc:	55                   	push   %ebp
  1047bd:	89 e5                	mov    %esp,%ebp
  1047bf:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  1047c2:	8b 45 08             	mov    0x8(%ebp),%eax
  1047c5:	89 04 24             	mov    %eax,(%esp)
  1047c8:	e8 d5 ff ff ff       	call   1047a2 <page2ppn>
  1047cd:	c1 e0 0c             	shl    $0xc,%eax
}
  1047d0:	c9                   	leave  
  1047d1:	c3                   	ret    

001047d2 <page_ref>:
page_ref(struct Page *page) {
  1047d2:	55                   	push   %ebp
  1047d3:	89 e5                	mov    %esp,%ebp
    return page->ref;
  1047d5:	8b 45 08             	mov    0x8(%ebp),%eax
  1047d8:	8b 00                	mov    (%eax),%eax
}
  1047da:	5d                   	pop    %ebp
  1047db:	c3                   	ret    

001047dc <set_page_ref>:
set_page_ref(struct Page *page, int val) {
  1047dc:	55                   	push   %ebp
  1047dd:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  1047df:	8b 45 08             	mov    0x8(%ebp),%eax
  1047e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  1047e5:	89 10                	mov    %edx,(%eax)
}
  1047e7:	90                   	nop
  1047e8:	5d                   	pop    %ebp
  1047e9:	c3                   	ret    

001047ea <default_init>:
#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)


static void
default_init(void) {
  1047ea:	55                   	push   %ebp
  1047eb:	89 e5                	mov    %esp,%ebp
  1047ed:	83 ec 10             	sub    $0x10,%esp
  1047f0:	c7 45 fc 3c df 11 00 	movl   $0x11df3c,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  1047f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1047fa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1047fd:	89 50 04             	mov    %edx,0x4(%eax)
  104800:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104803:	8b 50 04             	mov    0x4(%eax),%edx
  104806:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104809:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
  10480b:	c7 05 44 df 11 00 00 	movl   $0x0,0x11df44
  104812:	00 00 00 
}
  104815:	90                   	nop
  104816:	c9                   	leave  
  104817:	c3                   	ret    

00104818 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
  104818:	55                   	push   %ebp
  104819:	89 e5                	mov    %esp,%ebp
  10481b:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
  10481e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  104822:	75 24                	jne    104848 <default_init_memmap+0x30>
  104824:	c7 44 24 0c 14 76 10 	movl   $0x107614,0xc(%esp)
  10482b:	00 
  10482c:	c7 44 24 08 1a 76 10 	movl   $0x10761a,0x8(%esp)
  104833:	00 
  104834:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
  10483b:	00 
  10483c:	c7 04 24 2f 76 10 00 	movl   $0x10762f,(%esp)
  104843:	e8 97 bb ff ff       	call   1003df <__panic>
    struct Page *p = base;
  104848:	8b 45 08             	mov    0x8(%ebp),%eax
  10484b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  10484e:	e9 b3 00 00 00       	jmp    104906 <default_init_memmap+0xee>
		// 在查找可用内存并分配struct Page数组时就已经将将全部Page设置为Reserved
		// 将Page标记为可用的:清除Reserved,设置Property,并把property设置为0( 不是空闲块的第一个物理页 )
        assert(PageReserved(p));
  104853:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104856:	83 c0 04             	add    $0x4,%eax
  104859:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  104860:	89 45 ec             	mov    %eax,-0x14(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104863:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104866:	8b 55 f0             	mov    -0x10(%ebp),%edx
  104869:	0f a3 10             	bt     %edx,(%eax)
  10486c:	19 c0                	sbb    %eax,%eax
  10486e:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  104871:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  104875:	0f 95 c0             	setne  %al
  104878:	0f b6 c0             	movzbl %al,%eax
  10487b:	85 c0                	test   %eax,%eax
  10487d:	75 24                	jne    1048a3 <default_init_memmap+0x8b>
  10487f:	c7 44 24 0c 45 76 10 	movl   $0x107645,0xc(%esp)
  104886:	00 
  104887:	c7 44 24 08 1a 76 10 	movl   $0x10761a,0x8(%esp)
  10488e:	00 
  10488f:	c7 44 24 04 75 00 00 	movl   $0x75,0x4(%esp)
  104896:	00 
  104897:	c7 04 24 2f 76 10 00 	movl   $0x10762f,(%esp)
  10489e:	e8 3c bb ff ff       	call   1003df <__panic>
        p->flags = p->property = 0;
  1048a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048a6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  1048ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048b0:	8b 50 08             	mov    0x8(%eax),%edx
  1048b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048b6:	89 50 04             	mov    %edx,0x4(%eax)
		SetPageProperty(p);
  1048b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048bc:	83 c0 04             	add    $0x4,%eax
  1048bf:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  1048c6:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1048c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1048cc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1048cf:	0f ab 10             	bts    %edx,(%eax)
        set_page_ref(p, 0);
  1048d2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1048d9:	00 
  1048da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048dd:	89 04 24             	mov    %eax,(%esp)
  1048e0:	e8 f7 fe ff ff       	call   1047dc <set_page_ref>
		list_init(&(p->page_link));
  1048e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048e8:	83 c0 0c             	add    $0xc,%eax
  1048eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1048ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1048f1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1048f4:	89 50 04             	mov    %edx,0x4(%eax)
  1048f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1048fa:	8b 50 04             	mov    0x4(%eax),%edx
  1048fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104900:	89 10                	mov    %edx,(%eax)
    for (; p != base + n; p ++) {
  104902:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  104906:	8b 55 0c             	mov    0xc(%ebp),%edx
  104909:	89 d0                	mov    %edx,%eax
  10490b:	c1 e0 02             	shl    $0x2,%eax
  10490e:	01 d0                	add    %edx,%eax
  104910:	c1 e0 02             	shl    $0x2,%eax
  104913:	89 c2                	mov    %eax,%edx
  104915:	8b 45 08             	mov    0x8(%ebp),%eax
  104918:	01 d0                	add    %edx,%eax
  10491a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  10491d:	0f 85 30 ff ff ff    	jne    104853 <default_init_memmap+0x3b>
    }
	cprintf("Page address is %x\n", (uintptr_t)base);
  104923:	8b 45 08             	mov    0x8(%ebp),%eax
  104926:	89 44 24 04          	mov    %eax,0x4(%esp)
  10492a:	c7 04 24 55 76 10 00 	movl   $0x107655,(%esp)
  104931:	e8 51 b9 ff ff       	call   100287 <cprintf>
    base->property = n;
  104936:	8b 45 08             	mov    0x8(%ebp),%eax
  104939:	8b 55 0c             	mov    0xc(%ebp),%edx
  10493c:	89 50 08             	mov    %edx,0x8(%eax)
    nr_free += n;
  10493f:	8b 15 44 df 11 00    	mov    0x11df44,%edx
  104945:	8b 45 0c             	mov    0xc(%ebp),%eax
  104948:	01 d0                	add    %edx,%eax
  10494a:	a3 44 df 11 00       	mov    %eax,0x11df44
    list_add(free_list.prev, &(base->page_link));
  10494f:	8b 45 08             	mov    0x8(%ebp),%eax
  104952:	8d 50 0c             	lea    0xc(%eax),%edx
  104955:	a1 3c df 11 00       	mov    0x11df3c,%eax
  10495a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  10495d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  104960:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104963:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104966:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104969:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  10496c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10496f:	8b 40 04             	mov    0x4(%eax),%eax
  104972:	8b 55 cc             	mov    -0x34(%ebp),%edx
  104975:	89 55 c8             	mov    %edx,-0x38(%ebp)
  104978:	8b 55 d0             	mov    -0x30(%ebp),%edx
  10497b:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  10497e:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  104981:	8b 45 c0             	mov    -0x40(%ebp),%eax
  104984:	8b 55 c8             	mov    -0x38(%ebp),%edx
  104987:	89 10                	mov    %edx,(%eax)
  104989:	8b 45 c0             	mov    -0x40(%ebp),%eax
  10498c:	8b 10                	mov    (%eax),%edx
  10498e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104991:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  104994:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104997:	8b 55 c0             	mov    -0x40(%ebp),%edx
  10499a:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  10499d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1049a0:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  1049a3:	89 10                	mov    %edx,(%eax)
}
  1049a5:	90                   	nop
  1049a6:	c9                   	leave  
  1049a7:	c3                   	ret    

001049a8 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
  1049a8:	55                   	push   %ebp
  1049a9:	89 e5                	mov    %esp,%ebp
  1049ab:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
  1049ae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1049b2:	75 24                	jne    1049d8 <default_alloc_pages+0x30>
  1049b4:	c7 44 24 0c 14 76 10 	movl   $0x107614,0xc(%esp)
  1049bb:	00 
  1049bc:	c7 44 24 08 1a 76 10 	movl   $0x10761a,0x8(%esp)
  1049c3:	00 
  1049c4:	c7 44 24 04 83 00 00 	movl   $0x83,0x4(%esp)
  1049cb:	00 
  1049cc:	c7 04 24 2f 76 10 00 	movl   $0x10762f,(%esp)
  1049d3:	e8 07 ba ff ff       	call   1003df <__panic>
	/* There are not enough physical memory */
    if (n > nr_free) {
  1049d8:	a1 44 df 11 00       	mov    0x11df44,%eax
  1049dd:	39 45 08             	cmp    %eax,0x8(%ebp)
  1049e0:	76 26                	jbe    104a08 <default_alloc_pages+0x60>
		warn("memory shortage");
  1049e2:	c7 44 24 08 69 76 10 	movl   $0x107669,0x8(%esp)
  1049e9:	00 
  1049ea:	c7 44 24 04 86 00 00 	movl   $0x86,0x4(%esp)
  1049f1:	00 
  1049f2:	c7 04 24 2f 76 10 00 	movl   $0x10762f,(%esp)
  1049f9:	e8 5f ba ff ff       	call   10045d <__warn>
        return NULL;
  1049fe:	b8 00 00 00 00       	mov    $0x0,%eax
  104a03:	e9 96 01 00 00       	jmp    104b9e <default_alloc_pages+0x1f6>
    }
    struct Page *page = NULL;
  104a08:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	struct Page *p    = NULL;
  104a0f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  104a16:	c7 45 ec 3c df 11 00 	movl   $0x11df3c,-0x14(%ebp)
	/* try to find empty space to allocate */
    while ((le = list_next(le)) != &free_list) {
  104a1d:	eb 1c                	jmp    104a3b <default_alloc_pages+0x93>
        p = le2page(le, page_link);
  104a1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104a22:	83 e8 0c             	sub    $0xc,%eax
  104a25:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p->property >= n) {
  104a28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104a2b:	8b 40 08             	mov    0x8(%eax),%eax
  104a2e:	39 45 08             	cmp    %eax,0x8(%ebp)
  104a31:	77 08                	ja     104a3b <default_alloc_pages+0x93>
            page = p;
  104a33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104a36:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  104a39:	eb 18                	jmp    104a53 <default_alloc_pages+0xab>
  104a3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104a3e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return listelm->next;
  104a41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104a44:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  104a47:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104a4a:	81 7d ec 3c df 11 00 	cmpl   $0x11df3c,-0x14(%ebp)
  104a51:	75 cc                	jne    104a1f <default_alloc_pages+0x77>
        }
    }
	/* external fragmentation */
	if (page == NULL) {
  104a53:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104a57:	75 26                	jne    104a7f <default_alloc_pages+0xd7>
		warn("external fragmentation: There are enough memory, but can't find continuous space to allocate");
  104a59:	c7 44 24 08 7c 76 10 	movl   $0x10767c,0x8(%esp)
  104a60:	00 
  104a61:	c7 44 24 04 96 00 00 	movl   $0x96,0x4(%esp)
  104a68:	00 
  104a69:	c7 04 24 2f 76 10 00 	movl   $0x10762f,(%esp)
  104a70:	e8 e8 b9 ff ff       	call   10045d <__warn>
		return NULL;
  104a75:	b8 00 00 00 00       	mov    $0x0,%eax
  104a7a:	e9 1f 01 00 00       	jmp    104b9e <default_alloc_pages+0x1f6>
	}

	unsigned int property = page->property;
  104a7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104a82:	8b 40 08             	mov    0x8(%eax),%eax
  104a85:	89 45 e8             	mov    %eax,-0x18(%ebp)
	/* modify pages in allocated block(except of first page)*/
	p = page + 1;
  104a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104a8b:	83 c0 14             	add    $0x14,%eax
  104a8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	for (; p < page + n; ++p) {
  104a91:	eb 1d                	jmp    104ab0 <default_alloc_pages+0x108>
		ClearPageProperty(p);
  104a93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104a96:	83 c0 04             	add    $0x4,%eax
  104a99:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  104aa0:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104aa3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104aa6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104aa9:	0f b3 10             	btr    %edx,(%eax)
	for (; p < page + n; ++p) {
  104aac:	83 45 f0 14          	addl   $0x14,-0x10(%ebp)
  104ab0:	8b 55 08             	mov    0x8(%ebp),%edx
  104ab3:	89 d0                	mov    %edx,%eax
  104ab5:	c1 e0 02             	shl    $0x2,%eax
  104ab8:	01 d0                	add    %edx,%eax
  104aba:	c1 e0 02             	shl    $0x2,%eax
  104abd:	89 c2                	mov    %eax,%edx
  104abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104ac2:	01 d0                	add    %edx,%eax
  104ac4:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  104ac7:	72 ca                	jb     104a93 <default_alloc_pages+0xeb>
		// property is zero, so we needn't modiry it.
	}
	/* modify first page of allcoated block */
	ClearPageProperty(page);
  104ac9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104acc:	83 c0 04             	add    $0x4,%eax
  104acf:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
  104ad6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  104ad9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104adc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  104adf:	0f b3 10             	btr    %edx,(%eax)
	page->property = n;
  104ae2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104ae5:	8b 55 08             	mov    0x8(%ebp),%edx
  104ae8:	89 50 08             	mov    %edx,0x8(%eax)
	nr_free -= n;
  104aeb:	a1 44 df 11 00       	mov    0x11df44,%eax
  104af0:	2b 45 08             	sub    0x8(%ebp),%eax
  104af3:	a3 44 df 11 00       	mov    %eax,0x11df44
	/*
	 * If block size is bigger than requested size, split it;
	 * */
	if (property > n) {
  104af8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104afb:	3b 45 08             	cmp    0x8(%ebp),%eax
  104afe:	76 70                	jbe    104b70 <default_alloc_pages+0x1c8>
		p = page + n;
  104b00:	8b 55 08             	mov    0x8(%ebp),%edx
  104b03:	89 d0                	mov    %edx,%eax
  104b05:	c1 e0 02             	shl    $0x2,%eax
  104b08:	01 d0                	add    %edx,%eax
  104b0a:	c1 e0 02             	shl    $0x2,%eax
  104b0d:	89 c2                	mov    %eax,%edx
  104b0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104b12:	01 d0                	add    %edx,%eax
  104b14:	89 45 f0             	mov    %eax,-0x10(%ebp)
		p->property = property - n;
  104b17:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104b1a:	2b 45 08             	sub    0x8(%ebp),%eax
  104b1d:	89 c2                	mov    %eax,%edx
  104b1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104b22:	89 50 08             	mov    %edx,0x8(%eax)
		list_add_after(&(page->page_link), &(p->page_link));
  104b25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104b28:	83 c0 0c             	add    $0xc,%eax
  104b2b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104b2e:	83 c2 0c             	add    $0xc,%edx
  104b31:	89 55 d0             	mov    %edx,-0x30(%ebp)
  104b34:	89 45 cc             	mov    %eax,-0x34(%ebp)
    __list_add(elm, listelm, listelm->next);
  104b37:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104b3a:	8b 40 04             	mov    0x4(%eax),%eax
  104b3d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  104b40:	89 55 c8             	mov    %edx,-0x38(%ebp)
  104b43:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104b46:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  104b49:	89 45 c0             	mov    %eax,-0x40(%ebp)
    prev->next = next->prev = elm;
  104b4c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  104b4f:	8b 55 c8             	mov    -0x38(%ebp),%edx
  104b52:	89 10                	mov    %edx,(%eax)
  104b54:	8b 45 c0             	mov    -0x40(%ebp),%eax
  104b57:	8b 10                	mov    (%eax),%edx
  104b59:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104b5c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  104b5f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104b62:	8b 55 c0             	mov    -0x40(%ebp),%edx
  104b65:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  104b68:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104b6b:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  104b6e:	89 10                	mov    %edx,(%eax)
	}
	list_del(&(page->page_link));
  104b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104b73:	83 c0 0c             	add    $0xc,%eax
  104b76:	89 45 bc             	mov    %eax,-0x44(%ebp)
    __list_del(listelm->prev, listelm->next);
  104b79:	8b 45 bc             	mov    -0x44(%ebp),%eax
  104b7c:	8b 40 04             	mov    0x4(%eax),%eax
  104b7f:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104b82:	8b 12                	mov    (%edx),%edx
  104b84:	89 55 b8             	mov    %edx,-0x48(%ebp)
  104b87:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  104b8a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  104b8d:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  104b90:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  104b93:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  104b96:	8b 55 b8             	mov    -0x48(%ebp),%edx
  104b99:	89 10                	mov    %edx,(%eax)
    return page;
  104b9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  104b9e:	c9                   	leave  
  104b9f:	c3                   	ret    

00104ba0 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
  104ba0:	55                   	push   %ebp
  104ba1:	89 e5                	mov    %esp,%ebp
  104ba3:	81 ec c8 00 00 00    	sub    $0xc8,%esp
    assert(n > 0);
  104ba9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  104bad:	75 24                	jne    104bd3 <default_free_pages+0x33>
  104baf:	c7 44 24 0c 14 76 10 	movl   $0x107614,0xc(%esp)
  104bb6:	00 
  104bb7:	c7 44 24 08 1a 76 10 	movl   $0x10761a,0x8(%esp)
  104bbe:	00 
  104bbf:	c7 44 24 04 b3 00 00 	movl   $0xb3,0x4(%esp)
  104bc6:	00 
  104bc7:	c7 04 24 2f 76 10 00 	movl   $0x10762f,(%esp)
  104bce:	e8 0c b8 ff ff       	call   1003df <__panic>
	 */

	/* find the beginning of the allocated block.
	 * only begging page's #property fild is non-zero.
	 */
    struct Page *begin = base;
  104bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  104bd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	size_t count = 0;
  104bd9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	for ( ; begin->property == 0; ++count, --begin) {
  104be0:	e9 83 00 00 00       	jmp    104c68 <default_free_pages+0xc8>
		assert(!PageReserved(begin) && !PageProperty(begin));
  104be5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104be8:	83 c0 04             	add    $0x4,%eax
  104beb:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  104bf2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104bf5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104bf8:	8b 55 d8             	mov    -0x28(%ebp),%edx
  104bfb:	0f a3 10             	bt     %edx,(%eax)
  104bfe:	19 c0                	sbb    %eax,%eax
  104c00:	89 45 d0             	mov    %eax,-0x30(%ebp)
    return oldbit != 0;
  104c03:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  104c07:	0f 95 c0             	setne  %al
  104c0a:	0f b6 c0             	movzbl %al,%eax
  104c0d:	85 c0                	test   %eax,%eax
  104c0f:	75 2c                	jne    104c3d <default_free_pages+0x9d>
  104c11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104c14:	83 c0 04             	add    $0x4,%eax
  104c17:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  104c1e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104c21:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104c24:	8b 55 cc             	mov    -0x34(%ebp),%edx
  104c27:	0f a3 10             	bt     %edx,(%eax)
  104c2a:	19 c0                	sbb    %eax,%eax
  104c2c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return oldbit != 0;
  104c2f:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  104c33:	0f 95 c0             	setne  %al
  104c36:	0f b6 c0             	movzbl %al,%eax
  104c39:	85 c0                	test   %eax,%eax
  104c3b:	74 24                	je     104c61 <default_free_pages+0xc1>
  104c3d:	c7 44 24 0c dc 76 10 	movl   $0x1076dc,0xc(%esp)
  104c44:	00 
  104c45:	c7 44 24 08 1a 76 10 	movl   $0x10761a,0x8(%esp)
  104c4c:	00 
  104c4d:	c7 44 24 04 bf 00 00 	movl   $0xbf,0x4(%esp)
  104c54:	00 
  104c55:	c7 04 24 2f 76 10 00 	movl   $0x10762f,(%esp)
  104c5c:	e8 7e b7 ff ff       	call   1003df <__panic>
	for ( ; begin->property == 0; ++count, --begin) {
  104c61:	ff 45 f0             	incl   -0x10(%ebp)
  104c64:	83 6d f4 14          	subl   $0x14,-0xc(%ebp)
  104c68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104c6b:	8b 40 08             	mov    0x8(%eax),%eax
  104c6e:	85 c0                	test   %eax,%eax
  104c70:	0f 84 6f ff ff ff    	je     104be5 <default_free_pages+0x45>
	/* If @base is not the beginning of the allocated block,
	 * split the allocated block into two part. 
	 * One part is @begin to @base, 
	 * other part is @base to the end of the original part.
	 */
	if (begin != base) {
  104c76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104c79:	3b 45 08             	cmp    0x8(%ebp),%eax
  104c7c:	74 1a                	je     104c98 <default_free_pages+0xf8>
		base->property  = begin->property - count;
  104c7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104c81:	8b 40 08             	mov    0x8(%eax),%eax
  104c84:	2b 45 f0             	sub    -0x10(%ebp),%eax
  104c87:	89 c2                	mov    %eax,%edx
  104c89:	8b 45 08             	mov    0x8(%ebp),%eax
  104c8c:	89 50 08             	mov    %edx,0x8(%eax)
		begin->property = count;
  104c8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104c92:	8b 55 f0             	mov    -0x10(%ebp),%edx
  104c95:	89 50 08             	mov    %edx,0x8(%eax)
	}
	
	/* If @n is bigger than the number of pages in the @base block,
	 * it is not an error, just free all pages in block.
	 */
	if (n > base->property) {
  104c98:	8b 45 08             	mov    0x8(%ebp),%eax
  104c9b:	8b 40 08             	mov    0x8(%eax),%eax
  104c9e:	39 45 0c             	cmp    %eax,0xc(%ebp)
  104ca1:	76 0b                	jbe    104cae <default_free_pages+0x10e>
		n = base->property;
  104ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  104ca6:	8b 40 08             	mov    0x8(%eax),%eax
  104ca9:	89 45 0c             	mov    %eax,0xc(%ebp)
  104cac:	eb 36                	jmp    104ce4 <default_free_pages+0x144>
	}
	/* If @n is smaller than the number of pages in @base block,
	 * split @base block into two block.
	 */
	else if (n < base->property) {
  104cae:	8b 45 08             	mov    0x8(%ebp),%eax
  104cb1:	8b 40 08             	mov    0x8(%eax),%eax
  104cb4:	39 45 0c             	cmp    %eax,0xc(%ebp)
  104cb7:	73 2b                	jae    104ce4 <default_free_pages+0x144>
		(base + n)->property = base->property - n;
  104cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  104cbc:	8b 48 08             	mov    0x8(%eax),%ecx
  104cbf:	8b 55 0c             	mov    0xc(%ebp),%edx
  104cc2:	89 d0                	mov    %edx,%eax
  104cc4:	c1 e0 02             	shl    $0x2,%eax
  104cc7:	01 d0                	add    %edx,%eax
  104cc9:	c1 e0 02             	shl    $0x2,%eax
  104ccc:	89 c2                	mov    %eax,%edx
  104cce:	8b 45 08             	mov    0x8(%ebp),%eax
  104cd1:	01 c2                	add    %eax,%edx
  104cd3:	89 c8                	mov    %ecx,%eax
  104cd5:	2b 45 0c             	sub    0xc(%ebp),%eax
  104cd8:	89 42 08             	mov    %eax,0x8(%edx)
		base->property = n;
  104cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  104cde:	8b 55 0c             	mov    0xc(%ebp),%edx
  104ce1:	89 50 08             	mov    %edx,0x8(%eax)
	}	
	/* modify status information */
	struct Page *p = base;
  104ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  104ce7:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for (; p != base + n; ++p) {
  104cea:	e9 b6 00 00 00       	jmp    104da5 <default_free_pages+0x205>
        assert(!PageReserved(p) && !PageProperty(p));
  104cef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104cf2:	83 c0 04             	add    $0x4,%eax
  104cf5:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  104cfc:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104cff:	8b 45 bc             	mov    -0x44(%ebp),%eax
  104d02:	8b 55 c0             	mov    -0x40(%ebp),%edx
  104d05:	0f a3 10             	bt     %edx,(%eax)
  104d08:	19 c0                	sbb    %eax,%eax
  104d0a:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  104d0d:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  104d11:	0f 95 c0             	setne  %al
  104d14:	0f b6 c0             	movzbl %al,%eax
  104d17:	85 c0                	test   %eax,%eax
  104d19:	75 2c                	jne    104d47 <default_free_pages+0x1a7>
  104d1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104d1e:	83 c0 04             	add    $0x4,%eax
  104d21:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
  104d28:	89 45 b0             	mov    %eax,-0x50(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104d2b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  104d2e:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  104d31:	0f a3 10             	bt     %edx,(%eax)
  104d34:	19 c0                	sbb    %eax,%eax
  104d36:	89 45 ac             	mov    %eax,-0x54(%ebp)
    return oldbit != 0;
  104d39:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
  104d3d:	0f 95 c0             	setne  %al
  104d40:	0f b6 c0             	movzbl %al,%eax
  104d43:	85 c0                	test   %eax,%eax
  104d45:	74 24                	je     104d6b <default_free_pages+0x1cb>
  104d47:	c7 44 24 0c 0c 77 10 	movl   $0x10770c,0xc(%esp)
  104d4e:	00 
  104d4f:	c7 44 24 08 1a 76 10 	movl   $0x10761a,0x8(%esp)
  104d56:	00 
  104d57:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
  104d5e:	00 
  104d5f:	c7 04 24 2f 76 10 00 	movl   $0x10762f,(%esp)
  104d66:	e8 74 b6 ff ff       	call   1003df <__panic>
        p->flags = 0;
  104d6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104d6e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
		SetPageProperty(p);
  104d75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104d78:	83 c0 04             	add    $0x4,%eax
  104d7b:	c7 45 a8 01 00 00 00 	movl   $0x1,-0x58(%ebp)
  104d82:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104d85:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  104d88:	8b 55 a8             	mov    -0x58(%ebp),%edx
  104d8b:	0f ab 10             	bts    %edx,(%eax)
		set_page_ref(p, 0);
  104d8e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104d95:	00 
  104d96:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104d99:	89 04 24             	mov    %eax,(%esp)
  104d9c:	e8 3b fa ff ff       	call   1047dc <set_page_ref>
    for (; p != base + n; ++p) {
  104da1:	83 45 ec 14          	addl   $0x14,-0x14(%ebp)
  104da5:	8b 55 0c             	mov    0xc(%ebp),%edx
  104da8:	89 d0                	mov    %edx,%eax
  104daa:	c1 e0 02             	shl    $0x2,%eax
  104dad:	01 d0                	add    %edx,%eax
  104daf:	c1 e0 02             	shl    $0x2,%eax
  104db2:	89 c2                	mov    %eax,%edx
  104db4:	8b 45 08             	mov    0x8(%ebp),%eax
  104db7:	01 d0                	add    %edx,%eax
  104db9:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  104dbc:	0f 85 2d ff ff ff    	jne    104cef <default_free_pages+0x14f>
  104dc2:	c7 45 a0 3c df 11 00 	movl   $0x11df3c,-0x60(%ebp)
    return listelm->next;
  104dc9:	8b 45 a0             	mov    -0x60(%ebp),%eax
  104dcc:	8b 40 04             	mov    0x4(%eax),%eax

	 // list_add(pos, &base->page_link);
	 // nr_free += n;
	
	 /* merge adjcent free blocks */
  	 list_entry_t *le = list_next(&free_list), *pos = free_list.prev, *merge_before_ptr = NULL;
  104dcf:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104dd2:	a1 3c df 11 00       	mov    0x11df3c,%eax
  104dd7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104dda:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	 unsigned int old_base_property = base->property;
  104de1:	8b 45 08             	mov    0x8(%ebp),%eax
  104de4:	8b 40 08             	mov    0x8(%eax),%eax
  104de7:	89 45 dc             	mov    %eax,-0x24(%ebp)
	 /* merge free blocks */
 	 while (le != &free_list) {
  104dea:	e9 f8 00 00 00       	jmp    104ee7 <default_free_pages+0x347>
		 p = le2page(le, page_link);
  104def:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104df2:	83 e8 0c             	sub    $0xc,%eax
  104df5:	89 45 ec             	mov    %eax,-0x14(%ebp)
		 /* free_list is ascending sorted, only one free block before @base block will be merged */
		 if ((p + p->property == base)) {
  104df8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104dfb:	8b 50 08             	mov    0x8(%eax),%edx
  104dfe:	89 d0                	mov    %edx,%eax
  104e00:	c1 e0 02             	shl    $0x2,%eax
  104e03:	01 d0                	add    %edx,%eax
  104e05:	c1 e0 02             	shl    $0x2,%eax
  104e08:	89 c2                	mov    %eax,%edx
  104e0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104e0d:	01 d0                	add    %edx,%eax
  104e0f:	39 45 08             	cmp    %eax,0x8(%ebp)
  104e12:	75 5a                	jne    104e6e <default_free_pages+0x2ce>
			 p->property      += base->property;
  104e14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104e17:	8b 50 08             	mov    0x8(%eax),%edx
  104e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  104e1d:	8b 40 08             	mov    0x8(%eax),%eax
  104e20:	01 c2                	add    %eax,%edx
  104e22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104e25:	89 50 08             	mov    %edx,0x8(%eax)
			 base->property    = 0;
  104e28:	8b 45 08             	mov    0x8(%ebp),%eax
  104e2b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			 base              = p;
  104e32:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104e35:	89 45 08             	mov    %eax,0x8(%ebp)
			 pos               = le->prev;
  104e38:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104e3b:	8b 00                	mov    (%eax),%eax
  104e3d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			 merge_before_ptr  = le;
  104e40:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104e43:	89 45 e0             	mov    %eax,-0x20(%ebp)
  104e46:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104e49:	89 45 9c             	mov    %eax,-0x64(%ebp)
    __list_del(listelm->prev, listelm->next);
  104e4c:	8b 45 9c             	mov    -0x64(%ebp),%eax
  104e4f:	8b 40 04             	mov    0x4(%eax),%eax
  104e52:	8b 55 9c             	mov    -0x64(%ebp),%edx
  104e55:	8b 12                	mov    (%edx),%edx
  104e57:	89 55 98             	mov    %edx,-0x68(%ebp)
  104e5a:	89 45 94             	mov    %eax,-0x6c(%ebp)
    prev->next = next;
  104e5d:	8b 45 98             	mov    -0x68(%ebp),%eax
  104e60:	8b 55 94             	mov    -0x6c(%ebp),%edx
  104e63:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  104e66:	8b 45 94             	mov    -0x6c(%ebp),%eax
  104e69:	8b 55 98             	mov    -0x68(%ebp),%edx
  104e6c:	89 10                	mov    %edx,(%eax)
			 list_del(le);
		 }
		 if ((base + base->property) == p) {
  104e6e:	8b 45 08             	mov    0x8(%ebp),%eax
  104e71:	8b 50 08             	mov    0x8(%eax),%edx
  104e74:	89 d0                	mov    %edx,%eax
  104e76:	c1 e0 02             	shl    $0x2,%eax
  104e79:	01 d0                	add    %edx,%eax
  104e7b:	c1 e0 02             	shl    $0x2,%eax
  104e7e:	89 c2                	mov    %eax,%edx
  104e80:	8b 45 08             	mov    0x8(%ebp),%eax
  104e83:	01 d0                	add    %edx,%eax
  104e85:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  104e88:	75 4e                	jne    104ed8 <default_free_pages+0x338>
			 base->property += p->property;
  104e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  104e8d:	8b 50 08             	mov    0x8(%eax),%edx
  104e90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104e93:	8b 40 08             	mov    0x8(%eax),%eax
  104e96:	01 c2                	add    %eax,%edx
  104e98:	8b 45 08             	mov    0x8(%ebp),%eax
  104e9b:	89 50 08             	mov    %edx,0x8(%eax)
			 p->property     = 0;
  104e9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104ea1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			 pos             = le->prev;
  104ea8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104eab:	8b 00                	mov    (%eax),%eax
  104ead:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104eb0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104eb3:	89 45 90             	mov    %eax,-0x70(%ebp)
    __list_del(listelm->prev, listelm->next);
  104eb6:	8b 45 90             	mov    -0x70(%ebp),%eax
  104eb9:	8b 40 04             	mov    0x4(%eax),%eax
  104ebc:	8b 55 90             	mov    -0x70(%ebp),%edx
  104ebf:	8b 12                	mov    (%edx),%edx
  104ec1:	89 55 8c             	mov    %edx,-0x74(%ebp)
  104ec4:	89 45 88             	mov    %eax,-0x78(%ebp)
    prev->next = next;
  104ec7:	8b 45 8c             	mov    -0x74(%ebp),%eax
  104eca:	8b 55 88             	mov    -0x78(%ebp),%edx
  104ecd:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  104ed0:	8b 45 88             	mov    -0x78(%ebp),%eax
  104ed3:	8b 55 8c             	mov    -0x74(%ebp),%edx
  104ed6:	89 10                	mov    %edx,(%eax)
  104ed8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104edb:	89 45 84             	mov    %eax,-0x7c(%ebp)
    return listelm->next;
  104ede:	8b 45 84             	mov    -0x7c(%ebp),%eax
  104ee1:	8b 40 04             	mov    0x4(%eax),%eax
			 list_del(le);
		 }
		 le = list_next(le);
  104ee4:	89 45 e8             	mov    %eax,-0x18(%ebp)
 	 while (le != &free_list) {
  104ee7:	81 7d e8 3c df 11 00 	cmpl   $0x11df3c,-0x18(%ebp)
  104eee:	0f 85 fb fe ff ff    	jne    104def <default_free_pages+0x24f>
	 }
	 /* if there may be free blocks before @base block, try to merge them */
	 if (merge_before_ptr != NULL) {
  104ef4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  104ef8:	0f 84 b9 00 00 00    	je     104fb7 <default_free_pages+0x417>
		 le = merge_before_ptr->prev;
  104efe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104f01:	8b 00                	mov    (%eax),%eax
  104f03:	89 45 e8             	mov    %eax,-0x18(%ebp)
		 while (le != &free_list) {
  104f06:	e9 9f 00 00 00       	jmp    104faa <default_free_pages+0x40a>
			 p = le2page(le, page_link);
  104f0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104f0e:	83 e8 0c             	sub    $0xc,%eax
  104f11:	89 45 ec             	mov    %eax,-0x14(%ebp)
			 if (p + p->property == base) {
  104f14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104f17:	8b 50 08             	mov    0x8(%eax),%edx
  104f1a:	89 d0                	mov    %edx,%eax
  104f1c:	c1 e0 02             	shl    $0x2,%eax
  104f1f:	01 d0                	add    %edx,%eax
  104f21:	c1 e0 02             	shl    $0x2,%eax
  104f24:	89 c2                	mov    %eax,%edx
  104f26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104f29:	01 d0                	add    %edx,%eax
  104f2b:	39 45 08             	cmp    %eax,0x8(%ebp)
  104f2e:	75 66                	jne    104f96 <default_free_pages+0x3f6>
				 p->property    += base->property;
  104f30:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104f33:	8b 50 08             	mov    0x8(%eax),%edx
  104f36:	8b 45 08             	mov    0x8(%ebp),%eax
  104f39:	8b 40 08             	mov    0x8(%eax),%eax
  104f3c:	01 c2                	add    %eax,%edx
  104f3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104f41:	89 50 08             	mov    %edx,0x8(%eax)
				 base->property  = 0;
  104f44:	8b 45 08             	mov    0x8(%ebp),%eax
  104f47:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				 base            = p;
  104f4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104f51:	89 45 08             	mov    %eax,0x8(%ebp)
				 pos             = le->prev;
  104f54:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104f57:	8b 00                	mov    (%eax),%eax
  104f59:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104f5c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104f5f:	89 45 80             	mov    %eax,-0x80(%ebp)
    __list_del(listelm->prev, listelm->next);
  104f62:	8b 45 80             	mov    -0x80(%ebp),%eax
  104f65:	8b 40 04             	mov    0x4(%eax),%eax
  104f68:	8b 55 80             	mov    -0x80(%ebp),%edx
  104f6b:	8b 12                	mov    (%edx),%edx
  104f6d:	89 95 7c ff ff ff    	mov    %edx,-0x84(%ebp)
  104f73:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
    prev->next = next;
  104f79:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  104f7f:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
  104f85:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  104f88:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  104f8e:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
  104f94:	89 10                	mov    %edx,(%eax)
  104f96:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104f99:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
    return listelm->prev;
  104f9f:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  104fa5:	8b 00                	mov    (%eax),%eax
				 list_del(le);
			 }
			 le = list_prev(le);
  104fa7:	89 45 e8             	mov    %eax,-0x18(%ebp)
		 while (le != &free_list) {
  104faa:	81 7d e8 3c df 11 00 	cmpl   $0x11df3c,-0x18(%ebp)
  104fb1:	0f 85 54 ff ff ff    	jne    104f0b <default_free_pages+0x36b>
		 }
	 } 
	 /* @pos indicate position in whith @base's page_link should insert;
	  * only when there are no adjcent free blocks, should we try to find insertion position
	  */
	 if (base->property == old_base_property) {
  104fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  104fba:	8b 40 08             	mov    0x8(%eax),%eax
  104fbd:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  104fc0:	0f 85 90 00 00 00    	jne    105056 <default_free_pages+0x4b6>
  104fc6:	c7 85 70 ff ff ff 3c 	movl   $0x11df3c,-0x90(%ebp)
  104fcd:	df 11 00 
    return listelm->next;
  104fd0:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  104fd6:	8b 40 04             	mov    0x4(%eax),%eax
		 le = list_next(&free_list);
  104fd9:	89 45 e8             	mov    %eax,-0x18(%ebp)
		 while (le != &free_list) {
  104fdc:	eb 6f                	jmp    10504d <default_free_pages+0x4ad>
			 if (le2page(le, page_link) > base) {
  104fde:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104fe1:	83 e8 0c             	sub    $0xc,%eax
  104fe4:	39 45 08             	cmp    %eax,0x8(%ebp)
  104fe7:	73 4f                	jae    105038 <default_free_pages+0x498>
				 assert((base + base->property) < le2page(le, page_link));
  104fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  104fec:	8b 50 08             	mov    0x8(%eax),%edx
  104fef:	89 d0                	mov    %edx,%eax
  104ff1:	c1 e0 02             	shl    $0x2,%eax
  104ff4:	01 d0                	add    %edx,%eax
  104ff6:	c1 e0 02             	shl    $0x2,%eax
  104ff9:	89 c2                	mov    %eax,%edx
  104ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  104ffe:	01 c2                	add    %eax,%edx
  105000:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105003:	83 e8 0c             	sub    $0xc,%eax
  105006:	39 c2                	cmp    %eax,%edx
  105008:	72 24                	jb     10502e <default_free_pages+0x48e>
  10500a:	c7 44 24 0c 34 77 10 	movl   $0x107734,0xc(%esp)
  105011:	00 
  105012:	c7 44 24 08 1a 76 10 	movl   $0x10761a,0x8(%esp)
  105019:	00 
  10501a:	c7 44 24 04 3f 01 00 	movl   $0x13f,0x4(%esp)
  105021:	00 
  105022:	c7 04 24 2f 76 10 00 	movl   $0x10762f,(%esp)
  105029:	e8 b1 b3 ff ff       	call   1003df <__panic>
				 pos = le->prev;
  10502e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105031:	8b 00                	mov    (%eax),%eax
  105033:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				 break;
  105036:	eb 1e                	jmp    105056 <default_free_pages+0x4b6>
  105038:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10503b:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  105041:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  105047:	8b 40 04             	mov    0x4(%eax),%eax
			 }
			 le = list_next(le);
  10504a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		 while (le != &free_list) {
  10504d:	81 7d e8 3c df 11 00 	cmpl   $0x11df3c,-0x18(%ebp)
  105054:	75 88                	jne    104fde <default_free_pages+0x43e>
		 }
	 }
	 list_add(pos, &base->page_link);
  105056:	8b 45 08             	mov    0x8(%ebp),%eax
  105059:	8d 50 0c             	lea    0xc(%eax),%edx
  10505c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10505f:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
  105065:	89 95 64 ff ff ff    	mov    %edx,-0x9c(%ebp)
  10506b:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  105071:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  105077:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  10507d:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
    __list_add(elm, listelm, listelm->next);
  105083:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  105089:	8b 40 04             	mov    0x4(%eax),%eax
  10508c:	8b 95 5c ff ff ff    	mov    -0xa4(%ebp),%edx
  105092:	89 95 58 ff ff ff    	mov    %edx,-0xa8(%ebp)
  105098:	8b 95 60 ff ff ff    	mov    -0xa0(%ebp),%edx
  10509e:	89 95 54 ff ff ff    	mov    %edx,-0xac(%ebp)
  1050a4:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
    prev->next = next->prev = elm;
  1050aa:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  1050b0:	8b 95 58 ff ff ff    	mov    -0xa8(%ebp),%edx
  1050b6:	89 10                	mov    %edx,(%eax)
  1050b8:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  1050be:	8b 10                	mov    (%eax),%edx
  1050c0:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  1050c6:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  1050c9:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  1050cf:	8b 95 50 ff ff ff    	mov    -0xb0(%ebp),%edx
  1050d5:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  1050d8:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  1050de:	8b 95 54 ff ff ff    	mov    -0xac(%ebp),%edx
  1050e4:	89 10                	mov    %edx,(%eax)
	 nr_free += n;
  1050e6:	8b 15 44 df 11 00    	mov    0x11df44,%edx
  1050ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  1050ef:	01 d0                	add    %edx,%eax
  1050f1:	a3 44 df 11 00       	mov    %eax,0x11df44
}
  1050f6:	90                   	nop
  1050f7:	c9                   	leave  
  1050f8:	c3                   	ret    

001050f9 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  1050f9:	55                   	push   %ebp
  1050fa:	89 e5                	mov    %esp,%ebp
    return nr_free;
  1050fc:	a1 44 df 11 00       	mov    0x11df44,%eax
}
  105101:	5d                   	pop    %ebp
  105102:	c3                   	ret    

00105103 <basic_check>:

static void
basic_check(void) {
  105103:	55                   	push   %ebp
  105104:	89 e5                	mov    %esp,%ebp
  105106:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  105109:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  105110:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105113:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105116:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105119:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  10511c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105123:	e8 e8 de ff ff       	call   103010 <alloc_pages>
  105128:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10512b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  10512f:	75 24                	jne    105155 <basic_check+0x52>
  105131:	c7 44 24 0c 65 77 10 	movl   $0x107765,0xc(%esp)
  105138:	00 
  105139:	c7 44 24 08 1a 76 10 	movl   $0x10761a,0x8(%esp)
  105140:	00 
  105141:	c7 44 24 04 53 01 00 	movl   $0x153,0x4(%esp)
  105148:	00 
  105149:	c7 04 24 2f 76 10 00 	movl   $0x10762f,(%esp)
  105150:	e8 8a b2 ff ff       	call   1003df <__panic>
    assert((p1 = alloc_page()) != NULL);
  105155:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10515c:	e8 af de ff ff       	call   103010 <alloc_pages>
  105161:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105164:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105168:	75 24                	jne    10518e <basic_check+0x8b>
  10516a:	c7 44 24 0c 81 77 10 	movl   $0x107781,0xc(%esp)
  105171:	00 
  105172:	c7 44 24 08 1a 76 10 	movl   $0x10761a,0x8(%esp)
  105179:	00 
  10517a:	c7 44 24 04 54 01 00 	movl   $0x154,0x4(%esp)
  105181:	00 
  105182:	c7 04 24 2f 76 10 00 	movl   $0x10762f,(%esp)
  105189:	e8 51 b2 ff ff       	call   1003df <__panic>
    assert((p2 = alloc_page()) != NULL);
  10518e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105195:	e8 76 de ff ff       	call   103010 <alloc_pages>
  10519a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10519d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1051a1:	75 24                	jne    1051c7 <basic_check+0xc4>
  1051a3:	c7 44 24 0c 9d 77 10 	movl   $0x10779d,0xc(%esp)
  1051aa:	00 
  1051ab:	c7 44 24 08 1a 76 10 	movl   $0x10761a,0x8(%esp)
  1051b2:	00 
  1051b3:	c7 44 24 04 55 01 00 	movl   $0x155,0x4(%esp)
  1051ba:	00 
  1051bb:	c7 04 24 2f 76 10 00 	movl   $0x10762f,(%esp)
  1051c2:	e8 18 b2 ff ff       	call   1003df <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  1051c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1051ca:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  1051cd:	74 10                	je     1051df <basic_check+0xdc>
  1051cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1051d2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1051d5:	74 08                	je     1051df <basic_check+0xdc>
  1051d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1051da:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1051dd:	75 24                	jne    105203 <basic_check+0x100>
  1051df:	c7 44 24 0c bc 77 10 	movl   $0x1077bc,0xc(%esp)
  1051e6:	00 
  1051e7:	c7 44 24 08 1a 76 10 	movl   $0x10761a,0x8(%esp)
  1051ee:	00 
  1051ef:	c7 44 24 04 57 01 00 	movl   $0x157,0x4(%esp)
  1051f6:	00 
  1051f7:	c7 04 24 2f 76 10 00 	movl   $0x10762f,(%esp)
  1051fe:	e8 dc b1 ff ff       	call   1003df <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  105203:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105206:	89 04 24             	mov    %eax,(%esp)
  105209:	e8 c4 f5 ff ff       	call   1047d2 <page_ref>
  10520e:	85 c0                	test   %eax,%eax
  105210:	75 1e                	jne    105230 <basic_check+0x12d>
  105212:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105215:	89 04 24             	mov    %eax,(%esp)
  105218:	e8 b5 f5 ff ff       	call   1047d2 <page_ref>
  10521d:	85 c0                	test   %eax,%eax
  10521f:	75 0f                	jne    105230 <basic_check+0x12d>
  105221:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105224:	89 04 24             	mov    %eax,(%esp)
  105227:	e8 a6 f5 ff ff       	call   1047d2 <page_ref>
  10522c:	85 c0                	test   %eax,%eax
  10522e:	74 24                	je     105254 <basic_check+0x151>
  105230:	c7 44 24 0c e0 77 10 	movl   $0x1077e0,0xc(%esp)
  105237:	00 
  105238:	c7 44 24 08 1a 76 10 	movl   $0x10761a,0x8(%esp)
  10523f:	00 
  105240:	c7 44 24 04 58 01 00 	movl   $0x158,0x4(%esp)
  105247:	00 
  105248:	c7 04 24 2f 76 10 00 	movl   $0x10762f,(%esp)
  10524f:	e8 8b b1 ff ff       	call   1003df <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  105254:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105257:	89 04 24             	mov    %eax,(%esp)
  10525a:	e8 5d f5 ff ff       	call   1047bc <page2pa>
  10525f:	8b 15 a0 de 11 00    	mov    0x11dea0,%edx
  105265:	c1 e2 0c             	shl    $0xc,%edx
  105268:	39 d0                	cmp    %edx,%eax
  10526a:	72 24                	jb     105290 <basic_check+0x18d>
  10526c:	c7 44 24 0c 1c 78 10 	movl   $0x10781c,0xc(%esp)
  105273:	00 
  105274:	c7 44 24 08 1a 76 10 	movl   $0x10761a,0x8(%esp)
  10527b:	00 
  10527c:	c7 44 24 04 5a 01 00 	movl   $0x15a,0x4(%esp)
  105283:	00 
  105284:	c7 04 24 2f 76 10 00 	movl   $0x10762f,(%esp)
  10528b:	e8 4f b1 ff ff       	call   1003df <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  105290:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105293:	89 04 24             	mov    %eax,(%esp)
  105296:	e8 21 f5 ff ff       	call   1047bc <page2pa>
  10529b:	8b 15 a0 de 11 00    	mov    0x11dea0,%edx
  1052a1:	c1 e2 0c             	shl    $0xc,%edx
  1052a4:	39 d0                	cmp    %edx,%eax
  1052a6:	72 24                	jb     1052cc <basic_check+0x1c9>
  1052a8:	c7 44 24 0c 39 78 10 	movl   $0x107839,0xc(%esp)
  1052af:	00 
  1052b0:	c7 44 24 08 1a 76 10 	movl   $0x10761a,0x8(%esp)
  1052b7:	00 
  1052b8:	c7 44 24 04 5b 01 00 	movl   $0x15b,0x4(%esp)
  1052bf:	00 
  1052c0:	c7 04 24 2f 76 10 00 	movl   $0x10762f,(%esp)
  1052c7:	e8 13 b1 ff ff       	call   1003df <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  1052cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1052cf:	89 04 24             	mov    %eax,(%esp)
  1052d2:	e8 e5 f4 ff ff       	call   1047bc <page2pa>
  1052d7:	8b 15 a0 de 11 00    	mov    0x11dea0,%edx
  1052dd:	c1 e2 0c             	shl    $0xc,%edx
  1052e0:	39 d0                	cmp    %edx,%eax
  1052e2:	72 24                	jb     105308 <basic_check+0x205>
  1052e4:	c7 44 24 0c 56 78 10 	movl   $0x107856,0xc(%esp)
  1052eb:	00 
  1052ec:	c7 44 24 08 1a 76 10 	movl   $0x10761a,0x8(%esp)
  1052f3:	00 
  1052f4:	c7 44 24 04 5c 01 00 	movl   $0x15c,0x4(%esp)
  1052fb:	00 
  1052fc:	c7 04 24 2f 76 10 00 	movl   $0x10762f,(%esp)
  105303:	e8 d7 b0 ff ff       	call   1003df <__panic>

    list_entry_t free_list_store = free_list;
  105308:	a1 3c df 11 00       	mov    0x11df3c,%eax
  10530d:	8b 15 40 df 11 00    	mov    0x11df40,%edx
  105313:	89 45 d0             	mov    %eax,-0x30(%ebp)
  105316:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  105319:	c7 45 dc 3c df 11 00 	movl   $0x11df3c,-0x24(%ebp)
    elm->prev = elm->next = elm;
  105320:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105323:	8b 55 dc             	mov    -0x24(%ebp),%edx
  105326:	89 50 04             	mov    %edx,0x4(%eax)
  105329:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10532c:	8b 50 04             	mov    0x4(%eax),%edx
  10532f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105332:	89 10                	mov    %edx,(%eax)
  105334:	c7 45 e0 3c df 11 00 	movl   $0x11df3c,-0x20(%ebp)
    return list->next == list;
  10533b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10533e:	8b 40 04             	mov    0x4(%eax),%eax
  105341:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  105344:	0f 94 c0             	sete   %al
  105347:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  10534a:	85 c0                	test   %eax,%eax
  10534c:	75 24                	jne    105372 <basic_check+0x26f>
  10534e:	c7 44 24 0c 73 78 10 	movl   $0x107873,0xc(%esp)
  105355:	00 
  105356:	c7 44 24 08 1a 76 10 	movl   $0x10761a,0x8(%esp)
  10535d:	00 
  10535e:	c7 44 24 04 60 01 00 	movl   $0x160,0x4(%esp)
  105365:	00 
  105366:	c7 04 24 2f 76 10 00 	movl   $0x10762f,(%esp)
  10536d:	e8 6d b0 ff ff       	call   1003df <__panic>

    unsigned int nr_free_store = nr_free;
  105372:	a1 44 df 11 00       	mov    0x11df44,%eax
  105377:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  10537a:	c7 05 44 df 11 00 00 	movl   $0x0,0x11df44
  105381:	00 00 00 

    assert(alloc_page() == NULL);
  105384:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10538b:	e8 80 dc ff ff       	call   103010 <alloc_pages>
  105390:	85 c0                	test   %eax,%eax
  105392:	74 24                	je     1053b8 <basic_check+0x2b5>
  105394:	c7 44 24 0c 8a 78 10 	movl   $0x10788a,0xc(%esp)
  10539b:	00 
  10539c:	c7 44 24 08 1a 76 10 	movl   $0x10761a,0x8(%esp)
  1053a3:	00 
  1053a4:	c7 44 24 04 65 01 00 	movl   $0x165,0x4(%esp)
  1053ab:	00 
  1053ac:	c7 04 24 2f 76 10 00 	movl   $0x10762f,(%esp)
  1053b3:	e8 27 b0 ff ff       	call   1003df <__panic>

    free_page(p0);
  1053b8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1053bf:	00 
  1053c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1053c3:	89 04 24             	mov    %eax,(%esp)
  1053c6:	e8 7d dc ff ff       	call   103048 <free_pages>
    free_page(p1);
  1053cb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1053d2:	00 
  1053d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1053d6:	89 04 24             	mov    %eax,(%esp)
  1053d9:	e8 6a dc ff ff       	call   103048 <free_pages>
    free_page(p2);
  1053de:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1053e5:	00 
  1053e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1053e9:	89 04 24             	mov    %eax,(%esp)
  1053ec:	e8 57 dc ff ff       	call   103048 <free_pages>
    assert(nr_free == 3);
  1053f1:	a1 44 df 11 00       	mov    0x11df44,%eax
  1053f6:	83 f8 03             	cmp    $0x3,%eax
  1053f9:	74 24                	je     10541f <basic_check+0x31c>
  1053fb:	c7 44 24 0c 9f 78 10 	movl   $0x10789f,0xc(%esp)
  105402:	00 
  105403:	c7 44 24 08 1a 76 10 	movl   $0x10761a,0x8(%esp)
  10540a:	00 
  10540b:	c7 44 24 04 6a 01 00 	movl   $0x16a,0x4(%esp)
  105412:	00 
  105413:	c7 04 24 2f 76 10 00 	movl   $0x10762f,(%esp)
  10541a:	e8 c0 af ff ff       	call   1003df <__panic>

    assert((p0 = alloc_page()) != NULL);
  10541f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105426:	e8 e5 db ff ff       	call   103010 <alloc_pages>
  10542b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10542e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  105432:	75 24                	jne    105458 <basic_check+0x355>
  105434:	c7 44 24 0c 65 77 10 	movl   $0x107765,0xc(%esp)
  10543b:	00 
  10543c:	c7 44 24 08 1a 76 10 	movl   $0x10761a,0x8(%esp)
  105443:	00 
  105444:	c7 44 24 04 6c 01 00 	movl   $0x16c,0x4(%esp)
  10544b:	00 
  10544c:	c7 04 24 2f 76 10 00 	movl   $0x10762f,(%esp)
  105453:	e8 87 af ff ff       	call   1003df <__panic>
    assert((p1 = alloc_page()) != NULL);
  105458:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10545f:	e8 ac db ff ff       	call   103010 <alloc_pages>
  105464:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105467:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10546b:	75 24                	jne    105491 <basic_check+0x38e>
  10546d:	c7 44 24 0c 81 77 10 	movl   $0x107781,0xc(%esp)
  105474:	00 
  105475:	c7 44 24 08 1a 76 10 	movl   $0x10761a,0x8(%esp)
  10547c:	00 
  10547d:	c7 44 24 04 6d 01 00 	movl   $0x16d,0x4(%esp)
  105484:	00 
  105485:	c7 04 24 2f 76 10 00 	movl   $0x10762f,(%esp)
  10548c:	e8 4e af ff ff       	call   1003df <__panic>
    assert((p2 = alloc_page()) != NULL);
  105491:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105498:	e8 73 db ff ff       	call   103010 <alloc_pages>
  10549d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1054a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1054a4:	75 24                	jne    1054ca <basic_check+0x3c7>
  1054a6:	c7 44 24 0c 9d 77 10 	movl   $0x10779d,0xc(%esp)
  1054ad:	00 
  1054ae:	c7 44 24 08 1a 76 10 	movl   $0x10761a,0x8(%esp)
  1054b5:	00 
  1054b6:	c7 44 24 04 6e 01 00 	movl   $0x16e,0x4(%esp)
  1054bd:	00 
  1054be:	c7 04 24 2f 76 10 00 	movl   $0x10762f,(%esp)
  1054c5:	e8 15 af ff ff       	call   1003df <__panic>

    assert(alloc_page() == NULL);
  1054ca:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1054d1:	e8 3a db ff ff       	call   103010 <alloc_pages>
  1054d6:	85 c0                	test   %eax,%eax
  1054d8:	74 24                	je     1054fe <basic_check+0x3fb>
  1054da:	c7 44 24 0c 8a 78 10 	movl   $0x10788a,0xc(%esp)
  1054e1:	00 
  1054e2:	c7 44 24 08 1a 76 10 	movl   $0x10761a,0x8(%esp)
  1054e9:	00 
  1054ea:	c7 44 24 04 70 01 00 	movl   $0x170,0x4(%esp)
  1054f1:	00 
  1054f2:	c7 04 24 2f 76 10 00 	movl   $0x10762f,(%esp)
  1054f9:	e8 e1 ae ff ff       	call   1003df <__panic>

    free_page(p0);
  1054fe:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105505:	00 
  105506:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105509:	89 04 24             	mov    %eax,(%esp)
  10550c:	e8 37 db ff ff       	call   103048 <free_pages>
  105511:	c7 45 d8 3c df 11 00 	movl   $0x11df3c,-0x28(%ebp)
  105518:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10551b:	8b 40 04             	mov    0x4(%eax),%eax
  10551e:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  105521:	0f 94 c0             	sete   %al
  105524:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  105527:	85 c0                	test   %eax,%eax
  105529:	74 24                	je     10554f <basic_check+0x44c>
  10552b:	c7 44 24 0c ac 78 10 	movl   $0x1078ac,0xc(%esp)
  105532:	00 
  105533:	c7 44 24 08 1a 76 10 	movl   $0x10761a,0x8(%esp)
  10553a:	00 
  10553b:	c7 44 24 04 73 01 00 	movl   $0x173,0x4(%esp)
  105542:	00 
  105543:	c7 04 24 2f 76 10 00 	movl   $0x10762f,(%esp)
  10554a:	e8 90 ae ff ff       	call   1003df <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  10554f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105556:	e8 b5 da ff ff       	call   103010 <alloc_pages>
  10555b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10555e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105561:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  105564:	74 24                	je     10558a <basic_check+0x487>
  105566:	c7 44 24 0c c4 78 10 	movl   $0x1078c4,0xc(%esp)
  10556d:	00 
  10556e:	c7 44 24 08 1a 76 10 	movl   $0x10761a,0x8(%esp)
  105575:	00 
  105576:	c7 44 24 04 76 01 00 	movl   $0x176,0x4(%esp)
  10557d:	00 
  10557e:	c7 04 24 2f 76 10 00 	movl   $0x10762f,(%esp)
  105585:	e8 55 ae ff ff       	call   1003df <__panic>
    assert(alloc_page() == NULL);
  10558a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105591:	e8 7a da ff ff       	call   103010 <alloc_pages>
  105596:	85 c0                	test   %eax,%eax
  105598:	74 24                	je     1055be <basic_check+0x4bb>
  10559a:	c7 44 24 0c 8a 78 10 	movl   $0x10788a,0xc(%esp)
  1055a1:	00 
  1055a2:	c7 44 24 08 1a 76 10 	movl   $0x10761a,0x8(%esp)
  1055a9:	00 
  1055aa:	c7 44 24 04 77 01 00 	movl   $0x177,0x4(%esp)
  1055b1:	00 
  1055b2:	c7 04 24 2f 76 10 00 	movl   $0x10762f,(%esp)
  1055b9:	e8 21 ae ff ff       	call   1003df <__panic>

    assert(nr_free == 0);
  1055be:	a1 44 df 11 00       	mov    0x11df44,%eax
  1055c3:	85 c0                	test   %eax,%eax
  1055c5:	74 24                	je     1055eb <basic_check+0x4e8>
  1055c7:	c7 44 24 0c dd 78 10 	movl   $0x1078dd,0xc(%esp)
  1055ce:	00 
  1055cf:	c7 44 24 08 1a 76 10 	movl   $0x10761a,0x8(%esp)
  1055d6:	00 
  1055d7:	c7 44 24 04 79 01 00 	movl   $0x179,0x4(%esp)
  1055de:	00 
  1055df:	c7 04 24 2f 76 10 00 	movl   $0x10762f,(%esp)
  1055e6:	e8 f4 ad ff ff       	call   1003df <__panic>
    free_list = free_list_store;
  1055eb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1055ee:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1055f1:	a3 3c df 11 00       	mov    %eax,0x11df3c
  1055f6:	89 15 40 df 11 00    	mov    %edx,0x11df40
    nr_free = nr_free_store;
  1055fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1055ff:	a3 44 df 11 00       	mov    %eax,0x11df44

    free_page(p);
  105604:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10560b:	00 
  10560c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10560f:	89 04 24             	mov    %eax,(%esp)
  105612:	e8 31 da ff ff       	call   103048 <free_pages>
    free_page(p1);
  105617:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10561e:	00 
  10561f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105622:	89 04 24             	mov    %eax,(%esp)
  105625:	e8 1e da ff ff       	call   103048 <free_pages>
    free_page(p2);
  10562a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105631:	00 
  105632:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105635:	89 04 24             	mov    %eax,(%esp)
  105638:	e8 0b da ff ff       	call   103048 <free_pages>
}
  10563d:	90                   	nop
  10563e:	c9                   	leave  
  10563f:	c3                   	ret    

00105640 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  105640:	55                   	push   %ebp
  105641:	89 e5                	mov    %esp,%ebp
  105643:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
  105649:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  105650:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  105657:	c7 45 ec 3c df 11 00 	movl   $0x11df3c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  10565e:	e9 ac 00 00 00       	jmp    10570f <default_check+0xcf>
        struct Page *p = le2page(le, page_link);
  105663:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105666:	83 e8 0c             	sub    $0xc,%eax
  105669:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
  10566c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10566f:	83 c0 04             	add    $0x4,%eax
  105672:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  105679:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10567c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  10567f:	8b 55 d0             	mov    -0x30(%ebp),%edx
  105682:	0f a3 10             	bt     %edx,(%eax)
  105685:	19 c0                	sbb    %eax,%eax
  105687:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  10568a:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  10568e:	0f 95 c0             	setne  %al
  105691:	0f b6 c0             	movzbl %al,%eax
  105694:	85 c0                	test   %eax,%eax
  105696:	75 24                	jne    1056bc <default_check+0x7c>
  105698:	c7 44 24 0c ea 78 10 	movl   $0x1078ea,0xc(%esp)
  10569f:	00 
  1056a0:	c7 44 24 08 1a 76 10 	movl   $0x10761a,0x8(%esp)
  1056a7:	00 
  1056a8:	c7 44 24 04 8a 01 00 	movl   $0x18a,0x4(%esp)
  1056af:	00 
  1056b0:	c7 04 24 2f 76 10 00 	movl   $0x10762f,(%esp)
  1056b7:	e8 23 ad ff ff       	call   1003df <__panic>
        count ++, total += p->property;
  1056bc:	ff 45 f4             	incl   -0xc(%ebp)
  1056bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1056c2:	8b 50 08             	mov    0x8(%eax),%edx
  1056c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1056c8:	01 d0                	add    %edx,%eax
  1056ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
		//debug
		cprintf("page flags: %d\n", p->flags);
  1056cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1056d0:	8b 40 04             	mov    0x4(%eax),%eax
  1056d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1056d7:	c7 04 24 fa 78 10 00 	movl   $0x1078fa,(%esp)
  1056de:	e8 a4 ab ff ff       	call   100287 <cprintf>
		cprintf("page prev: 0x%x\n", (uintptr_t)(p->page_link).prev);
  1056e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1056e6:	8b 40 0c             	mov    0xc(%eax),%eax
  1056e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1056ed:	c7 04 24 0a 79 10 00 	movl   $0x10790a,(%esp)
  1056f4:	e8 8e ab ff ff       	call   100287 <cprintf>
		cprintf("page next: 0x%x\n", (uintptr_t)(p->page_link).next);
  1056f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1056fc:	8b 40 10             	mov    0x10(%eax),%eax
  1056ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  105703:	c7 04 24 1b 79 10 00 	movl   $0x10791b,(%esp)
  10570a:	e8 78 ab ff ff       	call   100287 <cprintf>
  10570f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105712:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
  105715:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  105718:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  10571b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10571e:	81 7d ec 3c df 11 00 	cmpl   $0x11df3c,-0x14(%ebp)
  105725:	0f 85 38 ff ff ff    	jne    105663 <default_check+0x23>

    }
	//debug
	cprintf("free_list element number: %d\n", count);
  10572b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10572e:	89 44 24 04          	mov    %eax,0x4(%esp)
  105732:	c7 04 24 2c 79 10 00 	movl   $0x10792c,(%esp)
  105739:	e8 49 ab ff ff       	call   100287 <cprintf>
    assert(total == nr_free_pages());
  10573e:	e8 38 d9 ff ff       	call   10307b <nr_free_pages>
  105743:	89 c2                	mov    %eax,%edx
  105745:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105748:	39 c2                	cmp    %eax,%edx
  10574a:	74 24                	je     105770 <default_check+0x130>
  10574c:	c7 44 24 0c 4a 79 10 	movl   $0x10794a,0xc(%esp)
  105753:	00 
  105754:	c7 44 24 08 1a 76 10 	movl   $0x10761a,0x8(%esp)
  10575b:	00 
  10575c:	c7 44 24 04 94 01 00 	movl   $0x194,0x4(%esp)
  105763:	00 
  105764:	c7 04 24 2f 76 10 00 	movl   $0x10762f,(%esp)
  10576b:	e8 6f ac ff ff       	call   1003df <__panic>

    basic_check();
  105770:	e8 8e f9 ff ff       	call   105103 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  105775:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  10577c:	e8 8f d8 ff ff       	call   103010 <alloc_pages>
  105781:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
  105784:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105788:	75 24                	jne    1057ae <default_check+0x16e>
  10578a:	c7 44 24 0c 63 79 10 	movl   $0x107963,0xc(%esp)
  105791:	00 
  105792:	c7 44 24 08 1a 76 10 	movl   $0x10761a,0x8(%esp)
  105799:	00 
  10579a:	c7 44 24 04 99 01 00 	movl   $0x199,0x4(%esp)
  1057a1:	00 
  1057a2:	c7 04 24 2f 76 10 00 	movl   $0x10762f,(%esp)
  1057a9:	e8 31 ac ff ff       	call   1003df <__panic>
    assert(!PageProperty(p0));
  1057ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1057b1:	83 c0 04             	add    $0x4,%eax
  1057b4:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  1057bb:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1057be:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1057c1:	8b 55 c0             	mov    -0x40(%ebp),%edx
  1057c4:	0f a3 10             	bt     %edx,(%eax)
  1057c7:	19 c0                	sbb    %eax,%eax
  1057c9:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  1057cc:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  1057d0:	0f 95 c0             	setne  %al
  1057d3:	0f b6 c0             	movzbl %al,%eax
  1057d6:	85 c0                	test   %eax,%eax
  1057d8:	74 24                	je     1057fe <default_check+0x1be>
  1057da:	c7 44 24 0c 6e 79 10 	movl   $0x10796e,0xc(%esp)
  1057e1:	00 
  1057e2:	c7 44 24 08 1a 76 10 	movl   $0x10761a,0x8(%esp)
  1057e9:	00 
  1057ea:	c7 44 24 04 9a 01 00 	movl   $0x19a,0x4(%esp)
  1057f1:	00 
  1057f2:	c7 04 24 2f 76 10 00 	movl   $0x10762f,(%esp)
  1057f9:	e8 e1 ab ff ff       	call   1003df <__panic>

    list_entry_t free_list_store = free_list;
  1057fe:	a1 3c df 11 00       	mov    0x11df3c,%eax
  105803:	8b 15 40 df 11 00    	mov    0x11df40,%edx
  105809:	89 45 80             	mov    %eax,-0x80(%ebp)
  10580c:	89 55 84             	mov    %edx,-0x7c(%ebp)
  10580f:	c7 45 b0 3c df 11 00 	movl   $0x11df3c,-0x50(%ebp)
    elm->prev = elm->next = elm;
  105816:	8b 45 b0             	mov    -0x50(%ebp),%eax
  105819:	8b 55 b0             	mov    -0x50(%ebp),%edx
  10581c:	89 50 04             	mov    %edx,0x4(%eax)
  10581f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  105822:	8b 50 04             	mov    0x4(%eax),%edx
  105825:	8b 45 b0             	mov    -0x50(%ebp),%eax
  105828:	89 10                	mov    %edx,(%eax)
  10582a:	c7 45 b4 3c df 11 00 	movl   $0x11df3c,-0x4c(%ebp)
    return list->next == list;
  105831:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  105834:	8b 40 04             	mov    0x4(%eax),%eax
  105837:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
  10583a:	0f 94 c0             	sete   %al
  10583d:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  105840:	85 c0                	test   %eax,%eax
  105842:	75 24                	jne    105868 <default_check+0x228>
  105844:	c7 44 24 0c 73 78 10 	movl   $0x107873,0xc(%esp)
  10584b:	00 
  10584c:	c7 44 24 08 1a 76 10 	movl   $0x10761a,0x8(%esp)
  105853:	00 
  105854:	c7 44 24 04 9e 01 00 	movl   $0x19e,0x4(%esp)
  10585b:	00 
  10585c:	c7 04 24 2f 76 10 00 	movl   $0x10762f,(%esp)
  105863:	e8 77 ab ff ff       	call   1003df <__panic>
    assert(alloc_page() == NULL);
  105868:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10586f:	e8 9c d7 ff ff       	call   103010 <alloc_pages>
  105874:	85 c0                	test   %eax,%eax
  105876:	74 24                	je     10589c <default_check+0x25c>
  105878:	c7 44 24 0c 8a 78 10 	movl   $0x10788a,0xc(%esp)
  10587f:	00 
  105880:	c7 44 24 08 1a 76 10 	movl   $0x10761a,0x8(%esp)
  105887:	00 
  105888:	c7 44 24 04 9f 01 00 	movl   $0x19f,0x4(%esp)
  10588f:	00 
  105890:	c7 04 24 2f 76 10 00 	movl   $0x10762f,(%esp)
  105897:	e8 43 ab ff ff       	call   1003df <__panic>

    unsigned int nr_free_store = nr_free;
  10589c:	a1 44 df 11 00       	mov    0x11df44,%eax
  1058a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
  1058a4:	c7 05 44 df 11 00 00 	movl   $0x0,0x11df44
  1058ab:	00 00 00 

    free_pages(p0 + 2, 3);
  1058ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1058b1:	83 c0 28             	add    $0x28,%eax
  1058b4:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  1058bb:	00 
  1058bc:	89 04 24             	mov    %eax,(%esp)
  1058bf:	e8 84 d7 ff ff       	call   103048 <free_pages>
    assert(alloc_pages(4) == NULL);
  1058c4:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  1058cb:	e8 40 d7 ff ff       	call   103010 <alloc_pages>
  1058d0:	85 c0                	test   %eax,%eax
  1058d2:	74 24                	je     1058f8 <default_check+0x2b8>
  1058d4:	c7 44 24 0c 80 79 10 	movl   $0x107980,0xc(%esp)
  1058db:	00 
  1058dc:	c7 44 24 08 1a 76 10 	movl   $0x10761a,0x8(%esp)
  1058e3:	00 
  1058e4:	c7 44 24 04 a5 01 00 	movl   $0x1a5,0x4(%esp)
  1058eb:	00 
  1058ec:	c7 04 24 2f 76 10 00 	movl   $0x10762f,(%esp)
  1058f3:	e8 e7 aa ff ff       	call   1003df <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  1058f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1058fb:	83 c0 28             	add    $0x28,%eax
  1058fe:	83 c0 04             	add    $0x4,%eax
  105901:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  105908:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10590b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  10590e:	8b 55 ac             	mov    -0x54(%ebp),%edx
  105911:	0f a3 10             	bt     %edx,(%eax)
  105914:	19 c0                	sbb    %eax,%eax
  105916:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  105919:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  10591d:	0f 95 c0             	setne  %al
  105920:	0f b6 c0             	movzbl %al,%eax
  105923:	85 c0                	test   %eax,%eax
  105925:	74 0e                	je     105935 <default_check+0x2f5>
  105927:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10592a:	83 c0 28             	add    $0x28,%eax
  10592d:	8b 40 08             	mov    0x8(%eax),%eax
  105930:	83 f8 03             	cmp    $0x3,%eax
  105933:	74 24                	je     105959 <default_check+0x319>
  105935:	c7 44 24 0c 98 79 10 	movl   $0x107998,0xc(%esp)
  10593c:	00 
  10593d:	c7 44 24 08 1a 76 10 	movl   $0x10761a,0x8(%esp)
  105944:	00 
  105945:	c7 44 24 04 a6 01 00 	movl   $0x1a6,0x4(%esp)
  10594c:	00 
  10594d:	c7 04 24 2f 76 10 00 	movl   $0x10762f,(%esp)
  105954:	e8 86 aa ff ff       	call   1003df <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  105959:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  105960:	e8 ab d6 ff ff       	call   103010 <alloc_pages>
  105965:	89 45 dc             	mov    %eax,-0x24(%ebp)
  105968:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  10596c:	75 24                	jne    105992 <default_check+0x352>
  10596e:	c7 44 24 0c c4 79 10 	movl   $0x1079c4,0xc(%esp)
  105975:	00 
  105976:	c7 44 24 08 1a 76 10 	movl   $0x10761a,0x8(%esp)
  10597d:	00 
  10597e:	c7 44 24 04 a7 01 00 	movl   $0x1a7,0x4(%esp)
  105985:	00 
  105986:	c7 04 24 2f 76 10 00 	movl   $0x10762f,(%esp)
  10598d:	e8 4d aa ff ff       	call   1003df <__panic>
    assert(alloc_page() == NULL);
  105992:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105999:	e8 72 d6 ff ff       	call   103010 <alloc_pages>
  10599e:	85 c0                	test   %eax,%eax
  1059a0:	74 24                	je     1059c6 <default_check+0x386>
  1059a2:	c7 44 24 0c 8a 78 10 	movl   $0x10788a,0xc(%esp)
  1059a9:	00 
  1059aa:	c7 44 24 08 1a 76 10 	movl   $0x10761a,0x8(%esp)
  1059b1:	00 
  1059b2:	c7 44 24 04 a8 01 00 	movl   $0x1a8,0x4(%esp)
  1059b9:	00 
  1059ba:	c7 04 24 2f 76 10 00 	movl   $0x10762f,(%esp)
  1059c1:	e8 19 aa ff ff       	call   1003df <__panic>
    assert(p0 + 2 == p1);
  1059c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1059c9:	83 c0 28             	add    $0x28,%eax
  1059cc:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  1059cf:	74 24                	je     1059f5 <default_check+0x3b5>
  1059d1:	c7 44 24 0c e2 79 10 	movl   $0x1079e2,0xc(%esp)
  1059d8:	00 
  1059d9:	c7 44 24 08 1a 76 10 	movl   $0x10761a,0x8(%esp)
  1059e0:	00 
  1059e1:	c7 44 24 04 a9 01 00 	movl   $0x1a9,0x4(%esp)
  1059e8:	00 
  1059e9:	c7 04 24 2f 76 10 00 	movl   $0x10762f,(%esp)
  1059f0:	e8 ea a9 ff ff       	call   1003df <__panic>

    p2 = p0 + 1;
  1059f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1059f8:	83 c0 14             	add    $0x14,%eax
  1059fb:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
  1059fe:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105a05:	00 
  105a06:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105a09:	89 04 24             	mov    %eax,(%esp)
  105a0c:	e8 37 d6 ff ff       	call   103048 <free_pages>
    free_pages(p1, 3);
  105a11:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  105a18:	00 
  105a19:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105a1c:	89 04 24             	mov    %eax,(%esp)
  105a1f:	e8 24 d6 ff ff       	call   103048 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  105a24:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105a27:	83 c0 04             	add    $0x4,%eax
  105a2a:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  105a31:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  105a34:	8b 45 9c             	mov    -0x64(%ebp),%eax
  105a37:	8b 55 a0             	mov    -0x60(%ebp),%edx
  105a3a:	0f a3 10             	bt     %edx,(%eax)
  105a3d:	19 c0                	sbb    %eax,%eax
  105a3f:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  105a42:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  105a46:	0f 95 c0             	setne  %al
  105a49:	0f b6 c0             	movzbl %al,%eax
  105a4c:	85 c0                	test   %eax,%eax
  105a4e:	74 0b                	je     105a5b <default_check+0x41b>
  105a50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105a53:	8b 40 08             	mov    0x8(%eax),%eax
  105a56:	83 f8 01             	cmp    $0x1,%eax
  105a59:	74 24                	je     105a7f <default_check+0x43f>
  105a5b:	c7 44 24 0c f0 79 10 	movl   $0x1079f0,0xc(%esp)
  105a62:	00 
  105a63:	c7 44 24 08 1a 76 10 	movl   $0x10761a,0x8(%esp)
  105a6a:	00 
  105a6b:	c7 44 24 04 ae 01 00 	movl   $0x1ae,0x4(%esp)
  105a72:	00 
  105a73:	c7 04 24 2f 76 10 00 	movl   $0x10762f,(%esp)
  105a7a:	e8 60 a9 ff ff       	call   1003df <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  105a7f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105a82:	83 c0 04             	add    $0x4,%eax
  105a85:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  105a8c:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  105a8f:	8b 45 90             	mov    -0x70(%ebp),%eax
  105a92:	8b 55 94             	mov    -0x6c(%ebp),%edx
  105a95:	0f a3 10             	bt     %edx,(%eax)
  105a98:	19 c0                	sbb    %eax,%eax
  105a9a:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  105a9d:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  105aa1:	0f 95 c0             	setne  %al
  105aa4:	0f b6 c0             	movzbl %al,%eax
  105aa7:	85 c0                	test   %eax,%eax
  105aa9:	74 0b                	je     105ab6 <default_check+0x476>
  105aab:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105aae:	8b 40 08             	mov    0x8(%eax),%eax
  105ab1:	83 f8 03             	cmp    $0x3,%eax
  105ab4:	74 24                	je     105ada <default_check+0x49a>
  105ab6:	c7 44 24 0c 18 7a 10 	movl   $0x107a18,0xc(%esp)
  105abd:	00 
  105abe:	c7 44 24 08 1a 76 10 	movl   $0x10761a,0x8(%esp)
  105ac5:	00 
  105ac6:	c7 44 24 04 af 01 00 	movl   $0x1af,0x4(%esp)
  105acd:	00 
  105ace:	c7 04 24 2f 76 10 00 	movl   $0x10762f,(%esp)
  105ad5:	e8 05 a9 ff ff       	call   1003df <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  105ada:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105ae1:	e8 2a d5 ff ff       	call   103010 <alloc_pages>
  105ae6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105ae9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105aec:	83 e8 14             	sub    $0x14,%eax
  105aef:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  105af2:	74 24                	je     105b18 <default_check+0x4d8>
  105af4:	c7 44 24 0c 3e 7a 10 	movl   $0x107a3e,0xc(%esp)
  105afb:	00 
  105afc:	c7 44 24 08 1a 76 10 	movl   $0x10761a,0x8(%esp)
  105b03:	00 
  105b04:	c7 44 24 04 b1 01 00 	movl   $0x1b1,0x4(%esp)
  105b0b:	00 
  105b0c:	c7 04 24 2f 76 10 00 	movl   $0x10762f,(%esp)
  105b13:	e8 c7 a8 ff ff       	call   1003df <__panic>
    free_page(p0);
  105b18:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105b1f:	00 
  105b20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105b23:	89 04 24             	mov    %eax,(%esp)
  105b26:	e8 1d d5 ff ff       	call   103048 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  105b2b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  105b32:	e8 d9 d4 ff ff       	call   103010 <alloc_pages>
  105b37:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105b3a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105b3d:	83 c0 14             	add    $0x14,%eax
  105b40:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  105b43:	74 24                	je     105b69 <default_check+0x529>
  105b45:	c7 44 24 0c 5c 7a 10 	movl   $0x107a5c,0xc(%esp)
  105b4c:	00 
  105b4d:	c7 44 24 08 1a 76 10 	movl   $0x10761a,0x8(%esp)
  105b54:	00 
  105b55:	c7 44 24 04 b3 01 00 	movl   $0x1b3,0x4(%esp)
  105b5c:	00 
  105b5d:	c7 04 24 2f 76 10 00 	movl   $0x10762f,(%esp)
  105b64:	e8 76 a8 ff ff       	call   1003df <__panic>

    free_pages(p0, 2);
  105b69:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  105b70:	00 
  105b71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105b74:	89 04 24             	mov    %eax,(%esp)
  105b77:	e8 cc d4 ff ff       	call   103048 <free_pages>
    free_page(p2);
  105b7c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105b83:	00 
  105b84:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105b87:	89 04 24             	mov    %eax,(%esp)
  105b8a:	e8 b9 d4 ff ff       	call   103048 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  105b8f:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  105b96:	e8 75 d4 ff ff       	call   103010 <alloc_pages>
  105b9b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105b9e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105ba2:	75 24                	jne    105bc8 <default_check+0x588>
  105ba4:	c7 44 24 0c 7c 7a 10 	movl   $0x107a7c,0xc(%esp)
  105bab:	00 
  105bac:	c7 44 24 08 1a 76 10 	movl   $0x10761a,0x8(%esp)
  105bb3:	00 
  105bb4:	c7 44 24 04 b8 01 00 	movl   $0x1b8,0x4(%esp)
  105bbb:	00 
  105bbc:	c7 04 24 2f 76 10 00 	movl   $0x10762f,(%esp)
  105bc3:	e8 17 a8 ff ff       	call   1003df <__panic>
    assert(alloc_page() == NULL);
  105bc8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105bcf:	e8 3c d4 ff ff       	call   103010 <alloc_pages>
  105bd4:	85 c0                	test   %eax,%eax
  105bd6:	74 24                	je     105bfc <default_check+0x5bc>
  105bd8:	c7 44 24 0c 8a 78 10 	movl   $0x10788a,0xc(%esp)
  105bdf:	00 
  105be0:	c7 44 24 08 1a 76 10 	movl   $0x10761a,0x8(%esp)
  105be7:	00 
  105be8:	c7 44 24 04 b9 01 00 	movl   $0x1b9,0x4(%esp)
  105bef:	00 
  105bf0:	c7 04 24 2f 76 10 00 	movl   $0x10762f,(%esp)
  105bf7:	e8 e3 a7 ff ff       	call   1003df <__panic>

    assert(nr_free == 0);
  105bfc:	a1 44 df 11 00       	mov    0x11df44,%eax
  105c01:	85 c0                	test   %eax,%eax
  105c03:	74 24                	je     105c29 <default_check+0x5e9>
  105c05:	c7 44 24 0c dd 78 10 	movl   $0x1078dd,0xc(%esp)
  105c0c:	00 
  105c0d:	c7 44 24 08 1a 76 10 	movl   $0x10761a,0x8(%esp)
  105c14:	00 
  105c15:	c7 44 24 04 bb 01 00 	movl   $0x1bb,0x4(%esp)
  105c1c:	00 
  105c1d:	c7 04 24 2f 76 10 00 	movl   $0x10762f,(%esp)
  105c24:	e8 b6 a7 ff ff       	call   1003df <__panic>
    nr_free = nr_free_store;
  105c29:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105c2c:	a3 44 df 11 00       	mov    %eax,0x11df44

    free_list = free_list_store;
  105c31:	8b 45 80             	mov    -0x80(%ebp),%eax
  105c34:	8b 55 84             	mov    -0x7c(%ebp),%edx
  105c37:	a3 3c df 11 00       	mov    %eax,0x11df3c
  105c3c:	89 15 40 df 11 00    	mov    %edx,0x11df40
    free_pages(p0, 5);
  105c42:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  105c49:	00 
  105c4a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105c4d:	89 04 24             	mov    %eax,(%esp)
  105c50:	e8 f3 d3 ff ff       	call   103048 <free_pages>

    le = &free_list;
  105c55:	c7 45 ec 3c df 11 00 	movl   $0x11df3c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  105c5c:	eb 1c                	jmp    105c7a <default_check+0x63a>
        struct Page *p = le2page(le, page_link);
  105c5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105c61:	83 e8 0c             	sub    $0xc,%eax
  105c64:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
  105c67:	ff 4d f4             	decl   -0xc(%ebp)
  105c6a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105c6d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  105c70:	8b 40 08             	mov    0x8(%eax),%eax
  105c73:	29 c2                	sub    %eax,%edx
  105c75:	89 d0                	mov    %edx,%eax
  105c77:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105c7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105c7d:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
  105c80:	8b 45 88             	mov    -0x78(%ebp),%eax
  105c83:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  105c86:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105c89:	81 7d ec 3c df 11 00 	cmpl   $0x11df3c,-0x14(%ebp)
  105c90:	75 cc                	jne    105c5e <default_check+0x61e>
    }
    assert(count == 0);
  105c92:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  105c96:	74 24                	je     105cbc <default_check+0x67c>
  105c98:	c7 44 24 0c 9a 7a 10 	movl   $0x107a9a,0xc(%esp)
  105c9f:	00 
  105ca0:	c7 44 24 08 1a 76 10 	movl   $0x10761a,0x8(%esp)
  105ca7:	00 
  105ca8:	c7 44 24 04 c6 01 00 	movl   $0x1c6,0x4(%esp)
  105caf:	00 
  105cb0:	c7 04 24 2f 76 10 00 	movl   $0x10762f,(%esp)
  105cb7:	e8 23 a7 ff ff       	call   1003df <__panic>
    assert(total == 0);
  105cbc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105cc0:	74 24                	je     105ce6 <default_check+0x6a6>
  105cc2:	c7 44 24 0c a5 7a 10 	movl   $0x107aa5,0xc(%esp)
  105cc9:	00 
  105cca:	c7 44 24 08 1a 76 10 	movl   $0x10761a,0x8(%esp)
  105cd1:	00 
  105cd2:	c7 44 24 04 c7 01 00 	movl   $0x1c7,0x4(%esp)
  105cd9:	00 
  105cda:	c7 04 24 2f 76 10 00 	movl   $0x10762f,(%esp)
  105ce1:	e8 f9 a6 ff ff       	call   1003df <__panic>
}
  105ce6:	90                   	nop
  105ce7:	c9                   	leave  
  105ce8:	c3                   	ret    

00105ce9 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  105ce9:	55                   	push   %ebp
  105cea:	89 e5                	mov    %esp,%ebp
  105cec:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105cef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  105cf6:	eb 03                	jmp    105cfb <strlen+0x12>
        cnt ++;
  105cf8:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
  105cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  105cfe:	8d 50 01             	lea    0x1(%eax),%edx
  105d01:	89 55 08             	mov    %edx,0x8(%ebp)
  105d04:	0f b6 00             	movzbl (%eax),%eax
  105d07:	84 c0                	test   %al,%al
  105d09:	75 ed                	jne    105cf8 <strlen+0xf>
    }
    return cnt;
  105d0b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105d0e:	c9                   	leave  
  105d0f:	c3                   	ret    

00105d10 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  105d10:	55                   	push   %ebp
  105d11:	89 e5                	mov    %esp,%ebp
  105d13:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105d16:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105d1d:	eb 03                	jmp    105d22 <strnlen+0x12>
        cnt ++;
  105d1f:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105d22:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105d25:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105d28:	73 10                	jae    105d3a <strnlen+0x2a>
  105d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  105d2d:	8d 50 01             	lea    0x1(%eax),%edx
  105d30:	89 55 08             	mov    %edx,0x8(%ebp)
  105d33:	0f b6 00             	movzbl (%eax),%eax
  105d36:	84 c0                	test   %al,%al
  105d38:	75 e5                	jne    105d1f <strnlen+0xf>
    }
    return cnt;
  105d3a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105d3d:	c9                   	leave  
  105d3e:	c3                   	ret    

00105d3f <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  105d3f:	55                   	push   %ebp
  105d40:	89 e5                	mov    %esp,%ebp
  105d42:	57                   	push   %edi
  105d43:	56                   	push   %esi
  105d44:	83 ec 20             	sub    $0x20,%esp
  105d47:	8b 45 08             	mov    0x8(%ebp),%eax
  105d4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105d4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d50:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  105d53:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105d56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105d59:	89 d1                	mov    %edx,%ecx
  105d5b:	89 c2                	mov    %eax,%edx
  105d5d:	89 ce                	mov    %ecx,%esi
  105d5f:	89 d7                	mov    %edx,%edi
  105d61:	ac                   	lods   %ds:(%esi),%al
  105d62:	aa                   	stos   %al,%es:(%edi)
  105d63:	84 c0                	test   %al,%al
  105d65:	75 fa                	jne    105d61 <strcpy+0x22>
  105d67:	89 fa                	mov    %edi,%edx
  105d69:	89 f1                	mov    %esi,%ecx
  105d6b:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105d6e:	89 55 e8             	mov    %edx,-0x18(%ebp)
  105d71:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  105d74:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
  105d77:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  105d78:	83 c4 20             	add    $0x20,%esp
  105d7b:	5e                   	pop    %esi
  105d7c:	5f                   	pop    %edi
  105d7d:	5d                   	pop    %ebp
  105d7e:	c3                   	ret    

00105d7f <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  105d7f:	55                   	push   %ebp
  105d80:	89 e5                	mov    %esp,%ebp
  105d82:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  105d85:	8b 45 08             	mov    0x8(%ebp),%eax
  105d88:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  105d8b:	eb 1e                	jmp    105dab <strncpy+0x2c>
        if ((*p = *src) != '\0') {
  105d8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d90:	0f b6 10             	movzbl (%eax),%edx
  105d93:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105d96:	88 10                	mov    %dl,(%eax)
  105d98:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105d9b:	0f b6 00             	movzbl (%eax),%eax
  105d9e:	84 c0                	test   %al,%al
  105da0:	74 03                	je     105da5 <strncpy+0x26>
            src ++;
  105da2:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
  105da5:	ff 45 fc             	incl   -0x4(%ebp)
  105da8:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
  105dab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105daf:	75 dc                	jne    105d8d <strncpy+0xe>
    }
    return dst;
  105db1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105db4:	c9                   	leave  
  105db5:	c3                   	ret    

00105db6 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  105db6:	55                   	push   %ebp
  105db7:	89 e5                	mov    %esp,%ebp
  105db9:	57                   	push   %edi
  105dba:	56                   	push   %esi
  105dbb:	83 ec 20             	sub    $0x20,%esp
  105dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  105dc1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105dc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  105dc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  105dca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105dcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105dd0:	89 d1                	mov    %edx,%ecx
  105dd2:	89 c2                	mov    %eax,%edx
  105dd4:	89 ce                	mov    %ecx,%esi
  105dd6:	89 d7                	mov    %edx,%edi
  105dd8:	ac                   	lods   %ds:(%esi),%al
  105dd9:	ae                   	scas   %es:(%edi),%al
  105dda:	75 08                	jne    105de4 <strcmp+0x2e>
  105ddc:	84 c0                	test   %al,%al
  105dde:	75 f8                	jne    105dd8 <strcmp+0x22>
  105de0:	31 c0                	xor    %eax,%eax
  105de2:	eb 04                	jmp    105de8 <strcmp+0x32>
  105de4:	19 c0                	sbb    %eax,%eax
  105de6:	0c 01                	or     $0x1,%al
  105de8:	89 fa                	mov    %edi,%edx
  105dea:	89 f1                	mov    %esi,%ecx
  105dec:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105def:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105df2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  105df5:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
  105df8:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  105df9:	83 c4 20             	add    $0x20,%esp
  105dfc:	5e                   	pop    %esi
  105dfd:	5f                   	pop    %edi
  105dfe:	5d                   	pop    %ebp
  105dff:	c3                   	ret    

00105e00 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  105e00:	55                   	push   %ebp
  105e01:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105e03:	eb 09                	jmp    105e0e <strncmp+0xe>
        n --, s1 ++, s2 ++;
  105e05:	ff 4d 10             	decl   0x10(%ebp)
  105e08:	ff 45 08             	incl   0x8(%ebp)
  105e0b:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105e0e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105e12:	74 1a                	je     105e2e <strncmp+0x2e>
  105e14:	8b 45 08             	mov    0x8(%ebp),%eax
  105e17:	0f b6 00             	movzbl (%eax),%eax
  105e1a:	84 c0                	test   %al,%al
  105e1c:	74 10                	je     105e2e <strncmp+0x2e>
  105e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  105e21:	0f b6 10             	movzbl (%eax),%edx
  105e24:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e27:	0f b6 00             	movzbl (%eax),%eax
  105e2a:	38 c2                	cmp    %al,%dl
  105e2c:	74 d7                	je     105e05 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  105e2e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105e32:	74 18                	je     105e4c <strncmp+0x4c>
  105e34:	8b 45 08             	mov    0x8(%ebp),%eax
  105e37:	0f b6 00             	movzbl (%eax),%eax
  105e3a:	0f b6 d0             	movzbl %al,%edx
  105e3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e40:	0f b6 00             	movzbl (%eax),%eax
  105e43:	0f b6 c0             	movzbl %al,%eax
  105e46:	29 c2                	sub    %eax,%edx
  105e48:	89 d0                	mov    %edx,%eax
  105e4a:	eb 05                	jmp    105e51 <strncmp+0x51>
  105e4c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105e51:	5d                   	pop    %ebp
  105e52:	c3                   	ret    

00105e53 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  105e53:	55                   	push   %ebp
  105e54:	89 e5                	mov    %esp,%ebp
  105e56:	83 ec 04             	sub    $0x4,%esp
  105e59:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e5c:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105e5f:	eb 13                	jmp    105e74 <strchr+0x21>
        if (*s == c) {
  105e61:	8b 45 08             	mov    0x8(%ebp),%eax
  105e64:	0f b6 00             	movzbl (%eax),%eax
  105e67:	38 45 fc             	cmp    %al,-0x4(%ebp)
  105e6a:	75 05                	jne    105e71 <strchr+0x1e>
            return (char *)s;
  105e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  105e6f:	eb 12                	jmp    105e83 <strchr+0x30>
        }
        s ++;
  105e71:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  105e74:	8b 45 08             	mov    0x8(%ebp),%eax
  105e77:	0f b6 00             	movzbl (%eax),%eax
  105e7a:	84 c0                	test   %al,%al
  105e7c:	75 e3                	jne    105e61 <strchr+0xe>
    }
    return NULL;
  105e7e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105e83:	c9                   	leave  
  105e84:	c3                   	ret    

00105e85 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  105e85:	55                   	push   %ebp
  105e86:	89 e5                	mov    %esp,%ebp
  105e88:	83 ec 04             	sub    $0x4,%esp
  105e8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e8e:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105e91:	eb 0e                	jmp    105ea1 <strfind+0x1c>
        if (*s == c) {
  105e93:	8b 45 08             	mov    0x8(%ebp),%eax
  105e96:	0f b6 00             	movzbl (%eax),%eax
  105e99:	38 45 fc             	cmp    %al,-0x4(%ebp)
  105e9c:	74 0f                	je     105ead <strfind+0x28>
            break;
        }
        s ++;
  105e9e:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  105ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  105ea4:	0f b6 00             	movzbl (%eax),%eax
  105ea7:	84 c0                	test   %al,%al
  105ea9:	75 e8                	jne    105e93 <strfind+0xe>
  105eab:	eb 01                	jmp    105eae <strfind+0x29>
            break;
  105ead:	90                   	nop
    }
    return (char *)s;
  105eae:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105eb1:	c9                   	leave  
  105eb2:	c3                   	ret    

00105eb3 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  105eb3:	55                   	push   %ebp
  105eb4:	89 e5                	mov    %esp,%ebp
  105eb6:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  105eb9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  105ec0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105ec7:	eb 03                	jmp    105ecc <strtol+0x19>
        s ++;
  105ec9:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  105ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  105ecf:	0f b6 00             	movzbl (%eax),%eax
  105ed2:	3c 20                	cmp    $0x20,%al
  105ed4:	74 f3                	je     105ec9 <strtol+0x16>
  105ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  105ed9:	0f b6 00             	movzbl (%eax),%eax
  105edc:	3c 09                	cmp    $0x9,%al
  105ede:	74 e9                	je     105ec9 <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
  105ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  105ee3:	0f b6 00             	movzbl (%eax),%eax
  105ee6:	3c 2b                	cmp    $0x2b,%al
  105ee8:	75 05                	jne    105eef <strtol+0x3c>
        s ++;
  105eea:	ff 45 08             	incl   0x8(%ebp)
  105eed:	eb 14                	jmp    105f03 <strtol+0x50>
    }
    else if (*s == '-') {
  105eef:	8b 45 08             	mov    0x8(%ebp),%eax
  105ef2:	0f b6 00             	movzbl (%eax),%eax
  105ef5:	3c 2d                	cmp    $0x2d,%al
  105ef7:	75 0a                	jne    105f03 <strtol+0x50>
        s ++, neg = 1;
  105ef9:	ff 45 08             	incl   0x8(%ebp)
  105efc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  105f03:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105f07:	74 06                	je     105f0f <strtol+0x5c>
  105f09:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  105f0d:	75 22                	jne    105f31 <strtol+0x7e>
  105f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  105f12:	0f b6 00             	movzbl (%eax),%eax
  105f15:	3c 30                	cmp    $0x30,%al
  105f17:	75 18                	jne    105f31 <strtol+0x7e>
  105f19:	8b 45 08             	mov    0x8(%ebp),%eax
  105f1c:	40                   	inc    %eax
  105f1d:	0f b6 00             	movzbl (%eax),%eax
  105f20:	3c 78                	cmp    $0x78,%al
  105f22:	75 0d                	jne    105f31 <strtol+0x7e>
        s += 2, base = 16;
  105f24:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  105f28:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  105f2f:	eb 29                	jmp    105f5a <strtol+0xa7>
    }
    else if (base == 0 && s[0] == '0') {
  105f31:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105f35:	75 16                	jne    105f4d <strtol+0x9a>
  105f37:	8b 45 08             	mov    0x8(%ebp),%eax
  105f3a:	0f b6 00             	movzbl (%eax),%eax
  105f3d:	3c 30                	cmp    $0x30,%al
  105f3f:	75 0c                	jne    105f4d <strtol+0x9a>
        s ++, base = 8;
  105f41:	ff 45 08             	incl   0x8(%ebp)
  105f44:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  105f4b:	eb 0d                	jmp    105f5a <strtol+0xa7>
    }
    else if (base == 0) {
  105f4d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105f51:	75 07                	jne    105f5a <strtol+0xa7>
        base = 10;
  105f53:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  105f5a:	8b 45 08             	mov    0x8(%ebp),%eax
  105f5d:	0f b6 00             	movzbl (%eax),%eax
  105f60:	3c 2f                	cmp    $0x2f,%al
  105f62:	7e 1b                	jle    105f7f <strtol+0xcc>
  105f64:	8b 45 08             	mov    0x8(%ebp),%eax
  105f67:	0f b6 00             	movzbl (%eax),%eax
  105f6a:	3c 39                	cmp    $0x39,%al
  105f6c:	7f 11                	jg     105f7f <strtol+0xcc>
            dig = *s - '0';
  105f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  105f71:	0f b6 00             	movzbl (%eax),%eax
  105f74:	0f be c0             	movsbl %al,%eax
  105f77:	83 e8 30             	sub    $0x30,%eax
  105f7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105f7d:	eb 48                	jmp    105fc7 <strtol+0x114>
        }
        else if (*s >= 'a' && *s <= 'z') {
  105f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  105f82:	0f b6 00             	movzbl (%eax),%eax
  105f85:	3c 60                	cmp    $0x60,%al
  105f87:	7e 1b                	jle    105fa4 <strtol+0xf1>
  105f89:	8b 45 08             	mov    0x8(%ebp),%eax
  105f8c:	0f b6 00             	movzbl (%eax),%eax
  105f8f:	3c 7a                	cmp    $0x7a,%al
  105f91:	7f 11                	jg     105fa4 <strtol+0xf1>
            dig = *s - 'a' + 10;
  105f93:	8b 45 08             	mov    0x8(%ebp),%eax
  105f96:	0f b6 00             	movzbl (%eax),%eax
  105f99:	0f be c0             	movsbl %al,%eax
  105f9c:	83 e8 57             	sub    $0x57,%eax
  105f9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105fa2:	eb 23                	jmp    105fc7 <strtol+0x114>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  105fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  105fa7:	0f b6 00             	movzbl (%eax),%eax
  105faa:	3c 40                	cmp    $0x40,%al
  105fac:	7e 3b                	jle    105fe9 <strtol+0x136>
  105fae:	8b 45 08             	mov    0x8(%ebp),%eax
  105fb1:	0f b6 00             	movzbl (%eax),%eax
  105fb4:	3c 5a                	cmp    $0x5a,%al
  105fb6:	7f 31                	jg     105fe9 <strtol+0x136>
            dig = *s - 'A' + 10;
  105fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  105fbb:	0f b6 00             	movzbl (%eax),%eax
  105fbe:	0f be c0             	movsbl %al,%eax
  105fc1:	83 e8 37             	sub    $0x37,%eax
  105fc4:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  105fc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105fca:	3b 45 10             	cmp    0x10(%ebp),%eax
  105fcd:	7d 19                	jge    105fe8 <strtol+0x135>
            break;
        }
        s ++, val = (val * base) + dig;
  105fcf:	ff 45 08             	incl   0x8(%ebp)
  105fd2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105fd5:	0f af 45 10          	imul   0x10(%ebp),%eax
  105fd9:	89 c2                	mov    %eax,%edx
  105fdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105fde:	01 d0                	add    %edx,%eax
  105fe0:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  105fe3:	e9 72 ff ff ff       	jmp    105f5a <strtol+0xa7>
            break;
  105fe8:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  105fe9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105fed:	74 08                	je     105ff7 <strtol+0x144>
        *endptr = (char *) s;
  105fef:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ff2:	8b 55 08             	mov    0x8(%ebp),%edx
  105ff5:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  105ff7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  105ffb:	74 07                	je     106004 <strtol+0x151>
  105ffd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  106000:	f7 d8                	neg    %eax
  106002:	eb 03                	jmp    106007 <strtol+0x154>
  106004:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  106007:	c9                   	leave  
  106008:	c3                   	ret    

00106009 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  106009:	55                   	push   %ebp
  10600a:	89 e5                	mov    %esp,%ebp
  10600c:	57                   	push   %edi
  10600d:	83 ec 24             	sub    $0x24,%esp
  106010:	8b 45 0c             	mov    0xc(%ebp),%eax
  106013:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  106016:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  10601a:	8b 45 08             	mov    0x8(%ebp),%eax
  10601d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  106020:	88 55 f7             	mov    %dl,-0x9(%ebp)
  106023:	8b 45 10             	mov    0x10(%ebp),%eax
  106026:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  106029:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  10602c:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  106030:	8b 55 f8             	mov    -0x8(%ebp),%edx
  106033:	89 d7                	mov    %edx,%edi
  106035:	f3 aa                	rep stos %al,%es:(%edi)
  106037:	89 fa                	mov    %edi,%edx
  106039:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  10603c:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  10603f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  106042:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  106043:	83 c4 24             	add    $0x24,%esp
  106046:	5f                   	pop    %edi
  106047:	5d                   	pop    %ebp
  106048:	c3                   	ret    

00106049 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  106049:	55                   	push   %ebp
  10604a:	89 e5                	mov    %esp,%ebp
  10604c:	57                   	push   %edi
  10604d:	56                   	push   %esi
  10604e:	53                   	push   %ebx
  10604f:	83 ec 30             	sub    $0x30,%esp
  106052:	8b 45 08             	mov    0x8(%ebp),%eax
  106055:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106058:	8b 45 0c             	mov    0xc(%ebp),%eax
  10605b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10605e:	8b 45 10             	mov    0x10(%ebp),%eax
  106061:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  106064:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106067:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10606a:	73 42                	jae    1060ae <memmove+0x65>
  10606c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10606f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  106072:	8b 45 ec             	mov    -0x14(%ebp),%eax
  106075:	89 45 e0             	mov    %eax,-0x20(%ebp)
  106078:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10607b:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  10607e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  106081:	c1 e8 02             	shr    $0x2,%eax
  106084:	89 c1                	mov    %eax,%ecx
    asm volatile (
  106086:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106089:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10608c:	89 d7                	mov    %edx,%edi
  10608e:	89 c6                	mov    %eax,%esi
  106090:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  106092:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  106095:	83 e1 03             	and    $0x3,%ecx
  106098:	74 02                	je     10609c <memmove+0x53>
  10609a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10609c:	89 f0                	mov    %esi,%eax
  10609e:	89 fa                	mov    %edi,%edx
  1060a0:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  1060a3:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1060a6:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
  1060a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
  1060ac:	eb 36                	jmp    1060e4 <memmove+0x9b>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  1060ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1060b1:	8d 50 ff             	lea    -0x1(%eax),%edx
  1060b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1060b7:	01 c2                	add    %eax,%edx
  1060b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1060bc:	8d 48 ff             	lea    -0x1(%eax),%ecx
  1060bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1060c2:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  1060c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1060c8:	89 c1                	mov    %eax,%ecx
  1060ca:	89 d8                	mov    %ebx,%eax
  1060cc:	89 d6                	mov    %edx,%esi
  1060ce:	89 c7                	mov    %eax,%edi
  1060d0:	fd                   	std    
  1060d1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1060d3:	fc                   	cld    
  1060d4:	89 f8                	mov    %edi,%eax
  1060d6:	89 f2                	mov    %esi,%edx
  1060d8:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  1060db:	89 55 c8             	mov    %edx,-0x38(%ebp)
  1060de:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  1060e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  1060e4:	83 c4 30             	add    $0x30,%esp
  1060e7:	5b                   	pop    %ebx
  1060e8:	5e                   	pop    %esi
  1060e9:	5f                   	pop    %edi
  1060ea:	5d                   	pop    %ebp
  1060eb:	c3                   	ret    

001060ec <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  1060ec:	55                   	push   %ebp
  1060ed:	89 e5                	mov    %esp,%ebp
  1060ef:	57                   	push   %edi
  1060f0:	56                   	push   %esi
  1060f1:	83 ec 20             	sub    $0x20,%esp
  1060f4:	8b 45 08             	mov    0x8(%ebp),%eax
  1060f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1060fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1060fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106100:	8b 45 10             	mov    0x10(%ebp),%eax
  106103:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  106106:	8b 45 ec             	mov    -0x14(%ebp),%eax
  106109:	c1 e8 02             	shr    $0x2,%eax
  10610c:	89 c1                	mov    %eax,%ecx
    asm volatile (
  10610e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  106111:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106114:	89 d7                	mov    %edx,%edi
  106116:	89 c6                	mov    %eax,%esi
  106118:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  10611a:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  10611d:	83 e1 03             	and    $0x3,%ecx
  106120:	74 02                	je     106124 <memcpy+0x38>
  106122:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  106124:	89 f0                	mov    %esi,%eax
  106126:	89 fa                	mov    %edi,%edx
  106128:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  10612b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  10612e:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  106131:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
  106134:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  106135:	83 c4 20             	add    $0x20,%esp
  106138:	5e                   	pop    %esi
  106139:	5f                   	pop    %edi
  10613a:	5d                   	pop    %ebp
  10613b:	c3                   	ret    

0010613c <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  10613c:	55                   	push   %ebp
  10613d:	89 e5                	mov    %esp,%ebp
  10613f:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  106142:	8b 45 08             	mov    0x8(%ebp),%eax
  106145:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  106148:	8b 45 0c             	mov    0xc(%ebp),%eax
  10614b:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  10614e:	eb 2e                	jmp    10617e <memcmp+0x42>
        if (*s1 != *s2) {
  106150:	8b 45 fc             	mov    -0x4(%ebp),%eax
  106153:	0f b6 10             	movzbl (%eax),%edx
  106156:	8b 45 f8             	mov    -0x8(%ebp),%eax
  106159:	0f b6 00             	movzbl (%eax),%eax
  10615c:	38 c2                	cmp    %al,%dl
  10615e:	74 18                	je     106178 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  106160:	8b 45 fc             	mov    -0x4(%ebp),%eax
  106163:	0f b6 00             	movzbl (%eax),%eax
  106166:	0f b6 d0             	movzbl %al,%edx
  106169:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10616c:	0f b6 00             	movzbl (%eax),%eax
  10616f:	0f b6 c0             	movzbl %al,%eax
  106172:	29 c2                	sub    %eax,%edx
  106174:	89 d0                	mov    %edx,%eax
  106176:	eb 18                	jmp    106190 <memcmp+0x54>
        }
        s1 ++, s2 ++;
  106178:	ff 45 fc             	incl   -0x4(%ebp)
  10617b:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
  10617e:	8b 45 10             	mov    0x10(%ebp),%eax
  106181:	8d 50 ff             	lea    -0x1(%eax),%edx
  106184:	89 55 10             	mov    %edx,0x10(%ebp)
  106187:	85 c0                	test   %eax,%eax
  106189:	75 c5                	jne    106150 <memcmp+0x14>
    }
    return 0;
  10618b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  106190:	c9                   	leave  
  106191:	c3                   	ret    

00106192 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  106192:	55                   	push   %ebp
  106193:	89 e5                	mov    %esp,%ebp
  106195:	83 ec 58             	sub    $0x58,%esp
  106198:	8b 45 10             	mov    0x10(%ebp),%eax
  10619b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10619e:	8b 45 14             	mov    0x14(%ebp),%eax
  1061a1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  1061a4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1061a7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1061aa:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1061ad:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  1061b0:	8b 45 18             	mov    0x18(%ebp),%eax
  1061b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1061b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1061b9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1061bc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1061bf:	89 55 f0             	mov    %edx,-0x10(%ebp)
  1061c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1061c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1061c8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1061cc:	74 1c                	je     1061ea <printnum+0x58>
  1061ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1061d1:	ba 00 00 00 00       	mov    $0x0,%edx
  1061d6:	f7 75 e4             	divl   -0x1c(%ebp)
  1061d9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1061dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1061df:	ba 00 00 00 00       	mov    $0x0,%edx
  1061e4:	f7 75 e4             	divl   -0x1c(%ebp)
  1061e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1061ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1061ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1061f0:	f7 75 e4             	divl   -0x1c(%ebp)
  1061f3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1061f6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  1061f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1061fc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1061ff:	89 45 e8             	mov    %eax,-0x18(%ebp)
  106202:	89 55 ec             	mov    %edx,-0x14(%ebp)
  106205:	8b 45 dc             	mov    -0x24(%ebp),%eax
  106208:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  10620b:	8b 45 18             	mov    0x18(%ebp),%eax
  10620e:	ba 00 00 00 00       	mov    $0x0,%edx
  106213:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  106216:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  106219:	19 d1                	sbb    %edx,%ecx
  10621b:	72 4c                	jb     106269 <printnum+0xd7>
        printnum(putch, putdat, result, base, width - 1, padc);
  10621d:	8b 45 1c             	mov    0x1c(%ebp),%eax
  106220:	8d 50 ff             	lea    -0x1(%eax),%edx
  106223:	8b 45 20             	mov    0x20(%ebp),%eax
  106226:	89 44 24 18          	mov    %eax,0x18(%esp)
  10622a:	89 54 24 14          	mov    %edx,0x14(%esp)
  10622e:	8b 45 18             	mov    0x18(%ebp),%eax
  106231:	89 44 24 10          	mov    %eax,0x10(%esp)
  106235:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106238:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10623b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10623f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  106243:	8b 45 0c             	mov    0xc(%ebp),%eax
  106246:	89 44 24 04          	mov    %eax,0x4(%esp)
  10624a:	8b 45 08             	mov    0x8(%ebp),%eax
  10624d:	89 04 24             	mov    %eax,(%esp)
  106250:	e8 3d ff ff ff       	call   106192 <printnum>
  106255:	eb 1b                	jmp    106272 <printnum+0xe0>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  106257:	8b 45 0c             	mov    0xc(%ebp),%eax
  10625a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10625e:	8b 45 20             	mov    0x20(%ebp),%eax
  106261:	89 04 24             	mov    %eax,(%esp)
  106264:	8b 45 08             	mov    0x8(%ebp),%eax
  106267:	ff d0                	call   *%eax
        while (-- width > 0)
  106269:	ff 4d 1c             	decl   0x1c(%ebp)
  10626c:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  106270:	7f e5                	jg     106257 <printnum+0xc5>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  106272:	8b 45 d8             	mov    -0x28(%ebp),%eax
  106275:	05 60 7b 10 00       	add    $0x107b60,%eax
  10627a:	0f b6 00             	movzbl (%eax),%eax
  10627d:	0f be c0             	movsbl %al,%eax
  106280:	8b 55 0c             	mov    0xc(%ebp),%edx
  106283:	89 54 24 04          	mov    %edx,0x4(%esp)
  106287:	89 04 24             	mov    %eax,(%esp)
  10628a:	8b 45 08             	mov    0x8(%ebp),%eax
  10628d:	ff d0                	call   *%eax
}
  10628f:	90                   	nop
  106290:	c9                   	leave  
  106291:	c3                   	ret    

00106292 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  106292:	55                   	push   %ebp
  106293:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  106295:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  106299:	7e 14                	jle    1062af <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  10629b:	8b 45 08             	mov    0x8(%ebp),%eax
  10629e:	8b 00                	mov    (%eax),%eax
  1062a0:	8d 48 08             	lea    0x8(%eax),%ecx
  1062a3:	8b 55 08             	mov    0x8(%ebp),%edx
  1062a6:	89 0a                	mov    %ecx,(%edx)
  1062a8:	8b 50 04             	mov    0x4(%eax),%edx
  1062ab:	8b 00                	mov    (%eax),%eax
  1062ad:	eb 30                	jmp    1062df <getuint+0x4d>
    }
    else if (lflag) {
  1062af:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1062b3:	74 16                	je     1062cb <getuint+0x39>
        return va_arg(*ap, unsigned long);
  1062b5:	8b 45 08             	mov    0x8(%ebp),%eax
  1062b8:	8b 00                	mov    (%eax),%eax
  1062ba:	8d 48 04             	lea    0x4(%eax),%ecx
  1062bd:	8b 55 08             	mov    0x8(%ebp),%edx
  1062c0:	89 0a                	mov    %ecx,(%edx)
  1062c2:	8b 00                	mov    (%eax),%eax
  1062c4:	ba 00 00 00 00       	mov    $0x0,%edx
  1062c9:	eb 14                	jmp    1062df <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  1062cb:	8b 45 08             	mov    0x8(%ebp),%eax
  1062ce:	8b 00                	mov    (%eax),%eax
  1062d0:	8d 48 04             	lea    0x4(%eax),%ecx
  1062d3:	8b 55 08             	mov    0x8(%ebp),%edx
  1062d6:	89 0a                	mov    %ecx,(%edx)
  1062d8:	8b 00                	mov    (%eax),%eax
  1062da:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  1062df:	5d                   	pop    %ebp
  1062e0:	c3                   	ret    

001062e1 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  1062e1:	55                   	push   %ebp
  1062e2:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1062e4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1062e8:	7e 14                	jle    1062fe <getint+0x1d>
        return va_arg(*ap, long long);
  1062ea:	8b 45 08             	mov    0x8(%ebp),%eax
  1062ed:	8b 00                	mov    (%eax),%eax
  1062ef:	8d 48 08             	lea    0x8(%eax),%ecx
  1062f2:	8b 55 08             	mov    0x8(%ebp),%edx
  1062f5:	89 0a                	mov    %ecx,(%edx)
  1062f7:	8b 50 04             	mov    0x4(%eax),%edx
  1062fa:	8b 00                	mov    (%eax),%eax
  1062fc:	eb 28                	jmp    106326 <getint+0x45>
    }
    else if (lflag) {
  1062fe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  106302:	74 12                	je     106316 <getint+0x35>
        return va_arg(*ap, long);
  106304:	8b 45 08             	mov    0x8(%ebp),%eax
  106307:	8b 00                	mov    (%eax),%eax
  106309:	8d 48 04             	lea    0x4(%eax),%ecx
  10630c:	8b 55 08             	mov    0x8(%ebp),%edx
  10630f:	89 0a                	mov    %ecx,(%edx)
  106311:	8b 00                	mov    (%eax),%eax
  106313:	99                   	cltd   
  106314:	eb 10                	jmp    106326 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  106316:	8b 45 08             	mov    0x8(%ebp),%eax
  106319:	8b 00                	mov    (%eax),%eax
  10631b:	8d 48 04             	lea    0x4(%eax),%ecx
  10631e:	8b 55 08             	mov    0x8(%ebp),%edx
  106321:	89 0a                	mov    %ecx,(%edx)
  106323:	8b 00                	mov    (%eax),%eax
  106325:	99                   	cltd   
    }
}
  106326:	5d                   	pop    %ebp
  106327:	c3                   	ret    

00106328 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  106328:	55                   	push   %ebp
  106329:	89 e5                	mov    %esp,%ebp
  10632b:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  10632e:	8d 45 14             	lea    0x14(%ebp),%eax
  106331:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  106334:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106337:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10633b:	8b 45 10             	mov    0x10(%ebp),%eax
  10633e:	89 44 24 08          	mov    %eax,0x8(%esp)
  106342:	8b 45 0c             	mov    0xc(%ebp),%eax
  106345:	89 44 24 04          	mov    %eax,0x4(%esp)
  106349:	8b 45 08             	mov    0x8(%ebp),%eax
  10634c:	89 04 24             	mov    %eax,(%esp)
  10634f:	e8 03 00 00 00       	call   106357 <vprintfmt>
    va_end(ap);
}
  106354:	90                   	nop
  106355:	c9                   	leave  
  106356:	c3                   	ret    

00106357 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  106357:	55                   	push   %ebp
  106358:	89 e5                	mov    %esp,%ebp
  10635a:	56                   	push   %esi
  10635b:	53                   	push   %ebx
  10635c:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  10635f:	eb 17                	jmp    106378 <vprintfmt+0x21>
            if (ch == '\0') {
  106361:	85 db                	test   %ebx,%ebx
  106363:	0f 84 bf 03 00 00    	je     106728 <vprintfmt+0x3d1>
                return;
            }
            putch(ch, putdat);
  106369:	8b 45 0c             	mov    0xc(%ebp),%eax
  10636c:	89 44 24 04          	mov    %eax,0x4(%esp)
  106370:	89 1c 24             	mov    %ebx,(%esp)
  106373:	8b 45 08             	mov    0x8(%ebp),%eax
  106376:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  106378:	8b 45 10             	mov    0x10(%ebp),%eax
  10637b:	8d 50 01             	lea    0x1(%eax),%edx
  10637e:	89 55 10             	mov    %edx,0x10(%ebp)
  106381:	0f b6 00             	movzbl (%eax),%eax
  106384:	0f b6 d8             	movzbl %al,%ebx
  106387:	83 fb 25             	cmp    $0x25,%ebx
  10638a:	75 d5                	jne    106361 <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
  10638c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  106390:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  106397:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10639a:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  10639d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1063a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1063a7:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  1063aa:	8b 45 10             	mov    0x10(%ebp),%eax
  1063ad:	8d 50 01             	lea    0x1(%eax),%edx
  1063b0:	89 55 10             	mov    %edx,0x10(%ebp)
  1063b3:	0f b6 00             	movzbl (%eax),%eax
  1063b6:	0f b6 d8             	movzbl %al,%ebx
  1063b9:	8d 43 dd             	lea    -0x23(%ebx),%eax
  1063bc:	83 f8 55             	cmp    $0x55,%eax
  1063bf:	0f 87 37 03 00 00    	ja     1066fc <vprintfmt+0x3a5>
  1063c5:	8b 04 85 84 7b 10 00 	mov    0x107b84(,%eax,4),%eax
  1063cc:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  1063ce:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  1063d2:	eb d6                	jmp    1063aa <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  1063d4:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  1063d8:	eb d0                	jmp    1063aa <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  1063da:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  1063e1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1063e4:	89 d0                	mov    %edx,%eax
  1063e6:	c1 e0 02             	shl    $0x2,%eax
  1063e9:	01 d0                	add    %edx,%eax
  1063eb:	01 c0                	add    %eax,%eax
  1063ed:	01 d8                	add    %ebx,%eax
  1063ef:	83 e8 30             	sub    $0x30,%eax
  1063f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  1063f5:	8b 45 10             	mov    0x10(%ebp),%eax
  1063f8:	0f b6 00             	movzbl (%eax),%eax
  1063fb:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  1063fe:	83 fb 2f             	cmp    $0x2f,%ebx
  106401:	7e 38                	jle    10643b <vprintfmt+0xe4>
  106403:	83 fb 39             	cmp    $0x39,%ebx
  106406:	7f 33                	jg     10643b <vprintfmt+0xe4>
            for (precision = 0; ; ++ fmt) {
  106408:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
  10640b:	eb d4                	jmp    1063e1 <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  10640d:	8b 45 14             	mov    0x14(%ebp),%eax
  106410:	8d 50 04             	lea    0x4(%eax),%edx
  106413:	89 55 14             	mov    %edx,0x14(%ebp)
  106416:	8b 00                	mov    (%eax),%eax
  106418:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  10641b:	eb 1f                	jmp    10643c <vprintfmt+0xe5>

        case '.':
            if (width < 0)
  10641d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  106421:	79 87                	jns    1063aa <vprintfmt+0x53>
                width = 0;
  106423:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  10642a:	e9 7b ff ff ff       	jmp    1063aa <vprintfmt+0x53>

        case '#':
            altflag = 1;
  10642f:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  106436:	e9 6f ff ff ff       	jmp    1063aa <vprintfmt+0x53>
            goto process_precision;
  10643b:	90                   	nop

        process_precision:
            if (width < 0)
  10643c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  106440:	0f 89 64 ff ff ff    	jns    1063aa <vprintfmt+0x53>
                width = precision, precision = -1;
  106446:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106449:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10644c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  106453:	e9 52 ff ff ff       	jmp    1063aa <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  106458:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
  10645b:	e9 4a ff ff ff       	jmp    1063aa <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  106460:	8b 45 14             	mov    0x14(%ebp),%eax
  106463:	8d 50 04             	lea    0x4(%eax),%edx
  106466:	89 55 14             	mov    %edx,0x14(%ebp)
  106469:	8b 00                	mov    (%eax),%eax
  10646b:	8b 55 0c             	mov    0xc(%ebp),%edx
  10646e:	89 54 24 04          	mov    %edx,0x4(%esp)
  106472:	89 04 24             	mov    %eax,(%esp)
  106475:	8b 45 08             	mov    0x8(%ebp),%eax
  106478:	ff d0                	call   *%eax
            break;
  10647a:	e9 a4 02 00 00       	jmp    106723 <vprintfmt+0x3cc>

        // error message
        case 'e':
            err = va_arg(ap, int);
  10647f:	8b 45 14             	mov    0x14(%ebp),%eax
  106482:	8d 50 04             	lea    0x4(%eax),%edx
  106485:	89 55 14             	mov    %edx,0x14(%ebp)
  106488:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  10648a:	85 db                	test   %ebx,%ebx
  10648c:	79 02                	jns    106490 <vprintfmt+0x139>
                err = -err;
  10648e:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  106490:	83 fb 06             	cmp    $0x6,%ebx
  106493:	7f 0b                	jg     1064a0 <vprintfmt+0x149>
  106495:	8b 34 9d 44 7b 10 00 	mov    0x107b44(,%ebx,4),%esi
  10649c:	85 f6                	test   %esi,%esi
  10649e:	75 23                	jne    1064c3 <vprintfmt+0x16c>
                printfmt(putch, putdat, "error %d", err);
  1064a0:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1064a4:	c7 44 24 08 71 7b 10 	movl   $0x107b71,0x8(%esp)
  1064ab:	00 
  1064ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  1064af:	89 44 24 04          	mov    %eax,0x4(%esp)
  1064b3:	8b 45 08             	mov    0x8(%ebp),%eax
  1064b6:	89 04 24             	mov    %eax,(%esp)
  1064b9:	e8 6a fe ff ff       	call   106328 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  1064be:	e9 60 02 00 00       	jmp    106723 <vprintfmt+0x3cc>
                printfmt(putch, putdat, "%s", p);
  1064c3:	89 74 24 0c          	mov    %esi,0xc(%esp)
  1064c7:	c7 44 24 08 7a 7b 10 	movl   $0x107b7a,0x8(%esp)
  1064ce:	00 
  1064cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1064d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1064d6:	8b 45 08             	mov    0x8(%ebp),%eax
  1064d9:	89 04 24             	mov    %eax,(%esp)
  1064dc:	e8 47 fe ff ff       	call   106328 <printfmt>
            break;
  1064e1:	e9 3d 02 00 00       	jmp    106723 <vprintfmt+0x3cc>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  1064e6:	8b 45 14             	mov    0x14(%ebp),%eax
  1064e9:	8d 50 04             	lea    0x4(%eax),%edx
  1064ec:	89 55 14             	mov    %edx,0x14(%ebp)
  1064ef:	8b 30                	mov    (%eax),%esi
  1064f1:	85 f6                	test   %esi,%esi
  1064f3:	75 05                	jne    1064fa <vprintfmt+0x1a3>
                p = "(null)";
  1064f5:	be 7d 7b 10 00       	mov    $0x107b7d,%esi
            }
            if (width > 0 && padc != '-') {
  1064fa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1064fe:	7e 76                	jle    106576 <vprintfmt+0x21f>
  106500:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  106504:	74 70                	je     106576 <vprintfmt+0x21f>
                for (width -= strnlen(p, precision); width > 0; width --) {
  106506:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106509:	89 44 24 04          	mov    %eax,0x4(%esp)
  10650d:	89 34 24             	mov    %esi,(%esp)
  106510:	e8 fb f7 ff ff       	call   105d10 <strnlen>
  106515:	8b 55 e8             	mov    -0x18(%ebp),%edx
  106518:	29 c2                	sub    %eax,%edx
  10651a:	89 d0                	mov    %edx,%eax
  10651c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10651f:	eb 16                	jmp    106537 <vprintfmt+0x1e0>
                    putch(padc, putdat);
  106521:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  106525:	8b 55 0c             	mov    0xc(%ebp),%edx
  106528:	89 54 24 04          	mov    %edx,0x4(%esp)
  10652c:	89 04 24             	mov    %eax,(%esp)
  10652f:	8b 45 08             	mov    0x8(%ebp),%eax
  106532:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
  106534:	ff 4d e8             	decl   -0x18(%ebp)
  106537:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10653b:	7f e4                	jg     106521 <vprintfmt+0x1ca>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  10653d:	eb 37                	jmp    106576 <vprintfmt+0x21f>
                if (altflag && (ch < ' ' || ch > '~')) {
  10653f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  106543:	74 1f                	je     106564 <vprintfmt+0x20d>
  106545:	83 fb 1f             	cmp    $0x1f,%ebx
  106548:	7e 05                	jle    10654f <vprintfmt+0x1f8>
  10654a:	83 fb 7e             	cmp    $0x7e,%ebx
  10654d:	7e 15                	jle    106564 <vprintfmt+0x20d>
                    putch('?', putdat);
  10654f:	8b 45 0c             	mov    0xc(%ebp),%eax
  106552:	89 44 24 04          	mov    %eax,0x4(%esp)
  106556:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  10655d:	8b 45 08             	mov    0x8(%ebp),%eax
  106560:	ff d0                	call   *%eax
  106562:	eb 0f                	jmp    106573 <vprintfmt+0x21c>
                }
                else {
                    putch(ch, putdat);
  106564:	8b 45 0c             	mov    0xc(%ebp),%eax
  106567:	89 44 24 04          	mov    %eax,0x4(%esp)
  10656b:	89 1c 24             	mov    %ebx,(%esp)
  10656e:	8b 45 08             	mov    0x8(%ebp),%eax
  106571:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  106573:	ff 4d e8             	decl   -0x18(%ebp)
  106576:	89 f0                	mov    %esi,%eax
  106578:	8d 70 01             	lea    0x1(%eax),%esi
  10657b:	0f b6 00             	movzbl (%eax),%eax
  10657e:	0f be d8             	movsbl %al,%ebx
  106581:	85 db                	test   %ebx,%ebx
  106583:	74 27                	je     1065ac <vprintfmt+0x255>
  106585:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  106589:	78 b4                	js     10653f <vprintfmt+0x1e8>
  10658b:	ff 4d e4             	decl   -0x1c(%ebp)
  10658e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  106592:	79 ab                	jns    10653f <vprintfmt+0x1e8>
                }
            }
            for (; width > 0; width --) {
  106594:	eb 16                	jmp    1065ac <vprintfmt+0x255>
                putch(' ', putdat);
  106596:	8b 45 0c             	mov    0xc(%ebp),%eax
  106599:	89 44 24 04          	mov    %eax,0x4(%esp)
  10659d:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1065a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1065a7:	ff d0                	call   *%eax
            for (; width > 0; width --) {
  1065a9:	ff 4d e8             	decl   -0x18(%ebp)
  1065ac:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1065b0:	7f e4                	jg     106596 <vprintfmt+0x23f>
            }
            break;
  1065b2:	e9 6c 01 00 00       	jmp    106723 <vprintfmt+0x3cc>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  1065b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1065ba:	89 44 24 04          	mov    %eax,0x4(%esp)
  1065be:	8d 45 14             	lea    0x14(%ebp),%eax
  1065c1:	89 04 24             	mov    %eax,(%esp)
  1065c4:	e8 18 fd ff ff       	call   1062e1 <getint>
  1065c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1065cc:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  1065cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1065d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1065d5:	85 d2                	test   %edx,%edx
  1065d7:	79 26                	jns    1065ff <vprintfmt+0x2a8>
                putch('-', putdat);
  1065d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1065dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  1065e0:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  1065e7:	8b 45 08             	mov    0x8(%ebp),%eax
  1065ea:	ff d0                	call   *%eax
                num = -(long long)num;
  1065ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1065ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1065f2:	f7 d8                	neg    %eax
  1065f4:	83 d2 00             	adc    $0x0,%edx
  1065f7:	f7 da                	neg    %edx
  1065f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1065fc:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  1065ff:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  106606:	e9 a8 00 00 00       	jmp    1066b3 <vprintfmt+0x35c>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  10660b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10660e:	89 44 24 04          	mov    %eax,0x4(%esp)
  106612:	8d 45 14             	lea    0x14(%ebp),%eax
  106615:	89 04 24             	mov    %eax,(%esp)
  106618:	e8 75 fc ff ff       	call   106292 <getuint>
  10661d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106620:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  106623:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  10662a:	e9 84 00 00 00       	jmp    1066b3 <vprintfmt+0x35c>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  10662f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  106632:	89 44 24 04          	mov    %eax,0x4(%esp)
  106636:	8d 45 14             	lea    0x14(%ebp),%eax
  106639:	89 04 24             	mov    %eax,(%esp)
  10663c:	e8 51 fc ff ff       	call   106292 <getuint>
  106641:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106644:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  106647:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  10664e:	eb 63                	jmp    1066b3 <vprintfmt+0x35c>

        // pointer
        case 'p':
            putch('0', putdat);
  106650:	8b 45 0c             	mov    0xc(%ebp),%eax
  106653:	89 44 24 04          	mov    %eax,0x4(%esp)
  106657:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  10665e:	8b 45 08             	mov    0x8(%ebp),%eax
  106661:	ff d0                	call   *%eax
            putch('x', putdat);
  106663:	8b 45 0c             	mov    0xc(%ebp),%eax
  106666:	89 44 24 04          	mov    %eax,0x4(%esp)
  10666a:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  106671:	8b 45 08             	mov    0x8(%ebp),%eax
  106674:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  106676:	8b 45 14             	mov    0x14(%ebp),%eax
  106679:	8d 50 04             	lea    0x4(%eax),%edx
  10667c:	89 55 14             	mov    %edx,0x14(%ebp)
  10667f:	8b 00                	mov    (%eax),%eax
  106681:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106684:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  10668b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  106692:	eb 1f                	jmp    1066b3 <vprintfmt+0x35c>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  106694:	8b 45 e0             	mov    -0x20(%ebp),%eax
  106697:	89 44 24 04          	mov    %eax,0x4(%esp)
  10669b:	8d 45 14             	lea    0x14(%ebp),%eax
  10669e:	89 04 24             	mov    %eax,(%esp)
  1066a1:	e8 ec fb ff ff       	call   106292 <getuint>
  1066a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1066a9:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  1066ac:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  1066b3:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  1066b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1066ba:	89 54 24 18          	mov    %edx,0x18(%esp)
  1066be:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1066c1:	89 54 24 14          	mov    %edx,0x14(%esp)
  1066c5:	89 44 24 10          	mov    %eax,0x10(%esp)
  1066c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1066cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1066cf:	89 44 24 08          	mov    %eax,0x8(%esp)
  1066d3:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1066d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1066da:	89 44 24 04          	mov    %eax,0x4(%esp)
  1066de:	8b 45 08             	mov    0x8(%ebp),%eax
  1066e1:	89 04 24             	mov    %eax,(%esp)
  1066e4:	e8 a9 fa ff ff       	call   106192 <printnum>
            break;
  1066e9:	eb 38                	jmp    106723 <vprintfmt+0x3cc>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  1066eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1066ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  1066f2:	89 1c 24             	mov    %ebx,(%esp)
  1066f5:	8b 45 08             	mov    0x8(%ebp),%eax
  1066f8:	ff d0                	call   *%eax
            break;
  1066fa:	eb 27                	jmp    106723 <vprintfmt+0x3cc>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  1066fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1066ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  106703:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  10670a:	8b 45 08             	mov    0x8(%ebp),%eax
  10670d:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  10670f:	ff 4d 10             	decl   0x10(%ebp)
  106712:	eb 03                	jmp    106717 <vprintfmt+0x3c0>
  106714:	ff 4d 10             	decl   0x10(%ebp)
  106717:	8b 45 10             	mov    0x10(%ebp),%eax
  10671a:	48                   	dec    %eax
  10671b:	0f b6 00             	movzbl (%eax),%eax
  10671e:	3c 25                	cmp    $0x25,%al
  106720:	75 f2                	jne    106714 <vprintfmt+0x3bd>
                /* do nothing */;
            break;
  106722:	90                   	nop
    while (1) {
  106723:	e9 37 fc ff ff       	jmp    10635f <vprintfmt+0x8>
                return;
  106728:	90                   	nop
        }
    }
}
  106729:	83 c4 40             	add    $0x40,%esp
  10672c:	5b                   	pop    %ebx
  10672d:	5e                   	pop    %esi
  10672e:	5d                   	pop    %ebp
  10672f:	c3                   	ret    

00106730 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  106730:	55                   	push   %ebp
  106731:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  106733:	8b 45 0c             	mov    0xc(%ebp),%eax
  106736:	8b 40 08             	mov    0x8(%eax),%eax
  106739:	8d 50 01             	lea    0x1(%eax),%edx
  10673c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10673f:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  106742:	8b 45 0c             	mov    0xc(%ebp),%eax
  106745:	8b 10                	mov    (%eax),%edx
  106747:	8b 45 0c             	mov    0xc(%ebp),%eax
  10674a:	8b 40 04             	mov    0x4(%eax),%eax
  10674d:	39 c2                	cmp    %eax,%edx
  10674f:	73 12                	jae    106763 <sprintputch+0x33>
        *b->buf ++ = ch;
  106751:	8b 45 0c             	mov    0xc(%ebp),%eax
  106754:	8b 00                	mov    (%eax),%eax
  106756:	8d 48 01             	lea    0x1(%eax),%ecx
  106759:	8b 55 0c             	mov    0xc(%ebp),%edx
  10675c:	89 0a                	mov    %ecx,(%edx)
  10675e:	8b 55 08             	mov    0x8(%ebp),%edx
  106761:	88 10                	mov    %dl,(%eax)
    }
}
  106763:	90                   	nop
  106764:	5d                   	pop    %ebp
  106765:	c3                   	ret    

00106766 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  106766:	55                   	push   %ebp
  106767:	89 e5                	mov    %esp,%ebp
  106769:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  10676c:	8d 45 14             	lea    0x14(%ebp),%eax
  10676f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  106772:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106775:	89 44 24 0c          	mov    %eax,0xc(%esp)
  106779:	8b 45 10             	mov    0x10(%ebp),%eax
  10677c:	89 44 24 08          	mov    %eax,0x8(%esp)
  106780:	8b 45 0c             	mov    0xc(%ebp),%eax
  106783:	89 44 24 04          	mov    %eax,0x4(%esp)
  106787:	8b 45 08             	mov    0x8(%ebp),%eax
  10678a:	89 04 24             	mov    %eax,(%esp)
  10678d:	e8 08 00 00 00       	call   10679a <vsnprintf>
  106792:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  106795:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  106798:	c9                   	leave  
  106799:	c3                   	ret    

0010679a <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  10679a:	55                   	push   %ebp
  10679b:	89 e5                	mov    %esp,%ebp
  10679d:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  1067a0:	8b 45 08             	mov    0x8(%ebp),%eax
  1067a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1067a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1067a9:	8d 50 ff             	lea    -0x1(%eax),%edx
  1067ac:	8b 45 08             	mov    0x8(%ebp),%eax
  1067af:	01 d0                	add    %edx,%eax
  1067b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1067b4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  1067bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1067bf:	74 0a                	je     1067cb <vsnprintf+0x31>
  1067c1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1067c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1067c7:	39 c2                	cmp    %eax,%edx
  1067c9:	76 07                	jbe    1067d2 <vsnprintf+0x38>
        return -E_INVAL;
  1067cb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  1067d0:	eb 2a                	jmp    1067fc <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  1067d2:	8b 45 14             	mov    0x14(%ebp),%eax
  1067d5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1067d9:	8b 45 10             	mov    0x10(%ebp),%eax
  1067dc:	89 44 24 08          	mov    %eax,0x8(%esp)
  1067e0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1067e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1067e7:	c7 04 24 30 67 10 00 	movl   $0x106730,(%esp)
  1067ee:	e8 64 fb ff ff       	call   106357 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  1067f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1067f6:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  1067f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1067fc:	c9                   	leave  
  1067fd:	c3                   	ret    
