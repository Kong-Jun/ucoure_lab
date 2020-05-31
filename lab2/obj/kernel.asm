
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
c0100000:	b8 00 b0 11 00       	mov    $0x11b000,%eax
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
c0100020:	a3 00 b0 11 c0       	mov    %eax,0xc011b000

    # set ebp, esp
    movl $0x0, %ebp
c0100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010002a:	bc 00 a0 11 c0       	mov    $0xc011a000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c010002f:	e8 02 00 00 00       	call   c0100036 <kern_init>

c0100034 <spin>:

# should never get here
spin:
    jmp spin
c0100034:	eb fe                	jmp    c0100034 <spin>

c0100036 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c0100036:	55                   	push   %ebp
c0100037:	89 e5                	mov    %esp,%ebp
c0100039:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c010003c:	b8 48 df 11 c0       	mov    $0xc011df48,%eax
c0100041:	2d 00 d0 11 c0       	sub    $0xc011d000,%eax
c0100046:	89 44 24 08          	mov    %eax,0x8(%esp)
c010004a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100051:	00 
c0100052:	c7 04 24 00 d0 11 c0 	movl   $0xc011d000,(%esp)
c0100059:	e8 77 60 00 00       	call   c01060d5 <memset>

    cons_init();                // init the console
c010005e:	e8 70 15 00 00       	call   c01015d3 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100063:	c7 45 f4 e0 68 10 c0 	movl   $0xc01068e0,-0xc(%ebp)
    cprintf("%s\n\n", message);
c010006a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010006d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100071:	c7 04 24 fc 68 10 c0 	movl   $0xc01068fc,(%esp)
c0100078:	e8 11 02 00 00       	call   c010028e <cprintf>

    print_kerninfo();
c010007d:	e8 a7 08 00 00       	call   c0100929 <print_kerninfo>

    grade_backtrace();
c0100082:	e8 89 00 00 00       	call   c0100110 <grade_backtrace>

    pmm_init();                 // init physical memory management
c0100087:	e8 41 35 00 00       	call   c01035cd <pmm_init>

    pic_init();                 // init interrupt controller
c010008c:	e8 a7 16 00 00       	call   c0101738 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100091:	e8 31 18 00 00       	call   c01018c7 <idt_init>

    clock_init();               // init clock interrupt
c0100096:	e8 db 0c 00 00       	call   c0100d76 <clock_init>
    intr_enable();              // enable irq interrupt
c010009b:	e8 d2 17 00 00       	call   c0101872 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    // lab1_switch_test();

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
c01000bf:	e8 a0 0c 00 00       	call   c0100d64 <mon_backtrace>
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
c0100151:	a1 00 d0 11 c0       	mov    0xc011d000,%eax
c0100156:	89 54 24 08          	mov    %edx,0x8(%esp)
c010015a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010015e:	c7 04 24 01 69 10 c0 	movl   $0xc0106901,(%esp)
c0100165:	e8 24 01 00 00       	call   c010028e <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c010016a:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010016e:	89 c2                	mov    %eax,%edx
c0100170:	a1 00 d0 11 c0       	mov    0xc011d000,%eax
c0100175:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100179:	89 44 24 04          	mov    %eax,0x4(%esp)
c010017d:	c7 04 24 0f 69 10 c0 	movl   $0xc010690f,(%esp)
c0100184:	e8 05 01 00 00       	call   c010028e <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100189:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c010018d:	89 c2                	mov    %eax,%edx
c010018f:	a1 00 d0 11 c0       	mov    0xc011d000,%eax
c0100194:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100198:	89 44 24 04          	mov    %eax,0x4(%esp)
c010019c:	c7 04 24 1d 69 10 c0 	movl   $0xc010691d,(%esp)
c01001a3:	e8 e6 00 00 00       	call   c010028e <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001a8:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001ac:	89 c2                	mov    %eax,%edx
c01001ae:	a1 00 d0 11 c0       	mov    0xc011d000,%eax
c01001b3:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001b7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001bb:	c7 04 24 2b 69 10 c0 	movl   $0xc010692b,(%esp)
c01001c2:	e8 c7 00 00 00       	call   c010028e <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001c7:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001cb:	89 c2                	mov    %eax,%edx
c01001cd:	a1 00 d0 11 c0       	mov    0xc011d000,%eax
c01001d2:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001d6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001da:	c7 04 24 39 69 10 c0 	movl   $0xc0106939,(%esp)
c01001e1:	e8 a8 00 00 00       	call   c010028e <cprintf>
    round ++;
c01001e6:	a1 00 d0 11 c0       	mov    0xc011d000,%eax
c01001eb:	40                   	inc    %eax
c01001ec:	a3 00 d0 11 c0       	mov    %eax,0xc011d000
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
}
c01001f7:	90                   	nop
c01001f8:	5d                   	pop    %ebp
c01001f9:	c3                   	ret    

c01001fa <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c01001fa:	55                   	push   %ebp
c01001fb:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c01001fd:	90                   	nop
c01001fe:	5d                   	pop    %ebp
c01001ff:	c3                   	ret    

c0100200 <lab1_switch_test>:

static void
lab1_switch_test(void) {
c0100200:	55                   	push   %ebp
c0100201:	89 e5                	mov    %esp,%ebp
c0100203:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c0100206:	e8 2b ff ff ff       	call   c0100136 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c010020b:	c7 04 24 48 69 10 c0 	movl   $0xc0106948,(%esp)
c0100212:	e8 77 00 00 00       	call   c010028e <cprintf>
    lab1_switch_to_user();
c0100217:	e8 d8 ff ff ff       	call   c01001f4 <lab1_switch_to_user>
    lab1_print_cur_status();
c010021c:	e8 15 ff ff ff       	call   c0100136 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100221:	c7 04 24 68 69 10 c0 	movl   $0xc0106968,(%esp)
c0100228:	e8 61 00 00 00       	call   c010028e <cprintf>
    lab1_switch_to_kernel();
c010022d:	e8 c8 ff ff ff       	call   c01001fa <lab1_switch_to_kernel>
    lab1_print_cur_status();
c0100232:	e8 ff fe ff ff       	call   c0100136 <lab1_print_cur_status>
}
c0100237:	90                   	nop
c0100238:	c9                   	leave  
c0100239:	c3                   	ret    

c010023a <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c010023a:	55                   	push   %ebp
c010023b:	89 e5                	mov    %esp,%ebp
c010023d:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100240:	8b 45 08             	mov    0x8(%ebp),%eax
c0100243:	89 04 24             	mov    %eax,(%esp)
c0100246:	e8 b5 13 00 00       	call   c0101600 <cons_putc>
    (*cnt) ++;
c010024b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010024e:	8b 00                	mov    (%eax),%eax
c0100250:	8d 50 01             	lea    0x1(%eax),%edx
c0100253:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100256:	89 10                	mov    %edx,(%eax)
}
c0100258:	90                   	nop
c0100259:	c9                   	leave  
c010025a:	c3                   	ret    

c010025b <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c010025b:	55                   	push   %ebp
c010025c:	89 e5                	mov    %esp,%ebp
c010025e:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c0100261:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100268:	8b 45 0c             	mov    0xc(%ebp),%eax
c010026b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010026f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100272:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100276:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100279:	89 44 24 04          	mov    %eax,0x4(%esp)
c010027d:	c7 04 24 3a 02 10 c0 	movl   $0xc010023a,(%esp)
c0100284:	e8 9a 61 00 00       	call   c0106423 <vprintfmt>
    return cnt;
c0100289:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010028c:	c9                   	leave  
c010028d:	c3                   	ret    

c010028e <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c010028e:	55                   	push   %ebp
c010028f:	89 e5                	mov    %esp,%ebp
c0100291:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0100294:	8d 45 0c             	lea    0xc(%ebp),%eax
c0100297:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c010029a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010029d:	89 44 24 04          	mov    %eax,0x4(%esp)
c01002a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01002a4:	89 04 24             	mov    %eax,(%esp)
c01002a7:	e8 af ff ff ff       	call   c010025b <vcprintf>
c01002ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c01002af:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01002b2:	c9                   	leave  
c01002b3:	c3                   	ret    

c01002b4 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c01002b4:	55                   	push   %ebp
c01002b5:	89 e5                	mov    %esp,%ebp
c01002b7:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002ba:	8b 45 08             	mov    0x8(%ebp),%eax
c01002bd:	89 04 24             	mov    %eax,(%esp)
c01002c0:	e8 3b 13 00 00       	call   c0101600 <cons_putc>
}
c01002c5:	90                   	nop
c01002c6:	c9                   	leave  
c01002c7:	c3                   	ret    

c01002c8 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c01002c8:	55                   	push   %ebp
c01002c9:	89 e5                	mov    %esp,%ebp
c01002cb:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c01002ce:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c01002d5:	eb 13                	jmp    c01002ea <cputs+0x22>
        cputch(c, &cnt);
c01002d7:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c01002db:	8d 55 f0             	lea    -0x10(%ebp),%edx
c01002de:	89 54 24 04          	mov    %edx,0x4(%esp)
c01002e2:	89 04 24             	mov    %eax,(%esp)
c01002e5:	e8 50 ff ff ff       	call   c010023a <cputch>
    while ((c = *str ++) != '\0') {
c01002ea:	8b 45 08             	mov    0x8(%ebp),%eax
c01002ed:	8d 50 01             	lea    0x1(%eax),%edx
c01002f0:	89 55 08             	mov    %edx,0x8(%ebp)
c01002f3:	0f b6 00             	movzbl (%eax),%eax
c01002f6:	88 45 f7             	mov    %al,-0x9(%ebp)
c01002f9:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01002fd:	75 d8                	jne    c01002d7 <cputs+0xf>
    }
    cputch('\n', &cnt);
c01002ff:	8d 45 f0             	lea    -0x10(%ebp),%eax
c0100302:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100306:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c010030d:	e8 28 ff ff ff       	call   c010023a <cputch>
    return cnt;
c0100312:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0100315:	c9                   	leave  
c0100316:	c3                   	ret    

c0100317 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c0100317:	55                   	push   %ebp
c0100318:	89 e5                	mov    %esp,%ebp
c010031a:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c010031d:	90                   	nop
c010031e:	e8 1a 13 00 00       	call   c010163d <cons_getc>
c0100323:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100326:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010032a:	74 f2                	je     c010031e <getchar+0x7>
        /* do nothing */;
    return c;
c010032c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010032f:	c9                   	leave  
c0100330:	c3                   	ret    

c0100331 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100331:	55                   	push   %ebp
c0100332:	89 e5                	mov    %esp,%ebp
c0100334:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100337:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010033b:	74 13                	je     c0100350 <readline+0x1f>
        cprintf("%s", prompt);
c010033d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100340:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100344:	c7 04 24 87 69 10 c0 	movl   $0xc0106987,(%esp)
c010034b:	e8 3e ff ff ff       	call   c010028e <cprintf>
    }
    int i = 0, c;
c0100350:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100357:	e8 bb ff ff ff       	call   c0100317 <getchar>
c010035c:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c010035f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100363:	79 07                	jns    c010036c <readline+0x3b>
            return NULL;
c0100365:	b8 00 00 00 00       	mov    $0x0,%eax
c010036a:	eb 78                	jmp    c01003e4 <readline+0xb3>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c010036c:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100370:	7e 28                	jle    c010039a <readline+0x69>
c0100372:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c0100379:	7f 1f                	jg     c010039a <readline+0x69>
            cputchar(c);
c010037b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010037e:	89 04 24             	mov    %eax,(%esp)
c0100381:	e8 2e ff ff ff       	call   c01002b4 <cputchar>
            buf[i ++] = c;
c0100386:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100389:	8d 50 01             	lea    0x1(%eax),%edx
c010038c:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010038f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100392:	88 90 20 d0 11 c0    	mov    %dl,-0x3fee2fe0(%eax)
c0100398:	eb 45                	jmp    c01003df <readline+0xae>
        }
        else if (c == '\b' && i > 0) {
c010039a:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c010039e:	75 16                	jne    c01003b6 <readline+0x85>
c01003a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003a4:	7e 10                	jle    c01003b6 <readline+0x85>
            cputchar(c);
c01003a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01003a9:	89 04 24             	mov    %eax,(%esp)
c01003ac:	e8 03 ff ff ff       	call   c01002b4 <cputchar>
            i --;
c01003b1:	ff 4d f4             	decl   -0xc(%ebp)
c01003b4:	eb 29                	jmp    c01003df <readline+0xae>
        }
        else if (c == '\n' || c == '\r') {
c01003b6:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01003ba:	74 06                	je     c01003c2 <readline+0x91>
c01003bc:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01003c0:	75 95                	jne    c0100357 <readline+0x26>
            cputchar(c);
c01003c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01003c5:	89 04 24             	mov    %eax,(%esp)
c01003c8:	e8 e7 fe ff ff       	call   c01002b4 <cputchar>
            buf[i] = '\0';
c01003cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01003d0:	05 20 d0 11 c0       	add    $0xc011d020,%eax
c01003d5:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01003d8:	b8 20 d0 11 c0       	mov    $0xc011d020,%eax
c01003dd:	eb 05                	jmp    c01003e4 <readline+0xb3>
        c = getchar();
c01003df:	e9 73 ff ff ff       	jmp    c0100357 <readline+0x26>
        }
    }
}
c01003e4:	c9                   	leave  
c01003e5:	c3                   	ret    

c01003e6 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c01003e6:	55                   	push   %ebp
c01003e7:	89 e5                	mov    %esp,%ebp
c01003e9:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c01003ec:	a1 20 d4 11 c0       	mov    0xc011d420,%eax
c01003f1:	85 c0                	test   %eax,%eax
c01003f3:	75 5b                	jne    c0100450 <__panic+0x6a>
        goto panic_dead;
    }
    is_panic = 1;
c01003f5:	c7 05 20 d4 11 c0 01 	movl   $0x1,0xc011d420
c01003fc:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c01003ff:	8d 45 14             	lea    0x14(%ebp),%eax
c0100402:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100405:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100408:	89 44 24 08          	mov    %eax,0x8(%esp)
c010040c:	8b 45 08             	mov    0x8(%ebp),%eax
c010040f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100413:	c7 04 24 8a 69 10 c0 	movl   $0xc010698a,(%esp)
c010041a:	e8 6f fe ff ff       	call   c010028e <cprintf>
    vcprintf(fmt, ap);
c010041f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100422:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100426:	8b 45 10             	mov    0x10(%ebp),%eax
c0100429:	89 04 24             	mov    %eax,(%esp)
c010042c:	e8 2a fe ff ff       	call   c010025b <vcprintf>
    cprintf("\n");
c0100431:	c7 04 24 a6 69 10 c0 	movl   $0xc01069a6,(%esp)
c0100438:	e8 51 fe ff ff       	call   c010028e <cprintf>
    
    cprintf("stack trackback:\n");
c010043d:	c7 04 24 a8 69 10 c0 	movl   $0xc01069a8,(%esp)
c0100444:	e8 45 fe ff ff       	call   c010028e <cprintf>
    print_stackframe();
c0100449:	e8 21 06 00 00       	call   c0100a6f <print_stackframe>
c010044e:	eb 01                	jmp    c0100451 <__panic+0x6b>
        goto panic_dead;
c0100450:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
c0100451:	e8 23 14 00 00       	call   c0101879 <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100456:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010045d:	e8 35 08 00 00       	call   c0100c97 <kmonitor>
c0100462:	eb f2                	jmp    c0100456 <__panic+0x70>

c0100464 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100464:	55                   	push   %ebp
c0100465:	89 e5                	mov    %esp,%ebp
c0100467:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c010046a:	8d 45 14             	lea    0x14(%ebp),%eax
c010046d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100470:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100473:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100477:	8b 45 08             	mov    0x8(%ebp),%eax
c010047a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010047e:	c7 04 24 ba 69 10 c0 	movl   $0xc01069ba,(%esp)
c0100485:	e8 04 fe ff ff       	call   c010028e <cprintf>
    vcprintf(fmt, ap);
c010048a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010048d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100491:	8b 45 10             	mov    0x10(%ebp),%eax
c0100494:	89 04 24             	mov    %eax,(%esp)
c0100497:	e8 bf fd ff ff       	call   c010025b <vcprintf>
    cprintf("\n");
c010049c:	c7 04 24 a6 69 10 c0 	movl   $0xc01069a6,(%esp)
c01004a3:	e8 e6 fd ff ff       	call   c010028e <cprintf>
    va_end(ap);
}
c01004a8:	90                   	nop
c01004a9:	c9                   	leave  
c01004aa:	c3                   	ret    

c01004ab <is_kernel_panic>:

bool
is_kernel_panic(void) {
c01004ab:	55                   	push   %ebp
c01004ac:	89 e5                	mov    %esp,%ebp
    return is_panic;
c01004ae:	a1 20 d4 11 c0       	mov    0xc011d420,%eax
}
c01004b3:	5d                   	pop    %ebp
c01004b4:	c3                   	ret    

c01004b5 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01004b5:	55                   	push   %ebp
c01004b6:	89 e5                	mov    %esp,%ebp
c01004b8:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01004bb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004be:	8b 00                	mov    (%eax),%eax
c01004c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01004c3:	8b 45 10             	mov    0x10(%ebp),%eax
c01004c6:	8b 00                	mov    (%eax),%eax
c01004c8:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004cb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c01004d2:	e9 ca 00 00 00       	jmp    c01005a1 <stab_binsearch+0xec>
        int true_m = (l + r) / 2, m = true_m;
c01004d7:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01004da:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01004dd:	01 d0                	add    %edx,%eax
c01004df:	89 c2                	mov    %eax,%edx
c01004e1:	c1 ea 1f             	shr    $0x1f,%edx
c01004e4:	01 d0                	add    %edx,%eax
c01004e6:	d1 f8                	sar    %eax
c01004e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01004eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01004ee:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c01004f1:	eb 03                	jmp    c01004f6 <stab_binsearch+0x41>
            m --;
c01004f3:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
c01004f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004f9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c01004fc:	7c 1f                	jl     c010051d <stab_binsearch+0x68>
c01004fe:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100501:	89 d0                	mov    %edx,%eax
c0100503:	01 c0                	add    %eax,%eax
c0100505:	01 d0                	add    %edx,%eax
c0100507:	c1 e0 02             	shl    $0x2,%eax
c010050a:	89 c2                	mov    %eax,%edx
c010050c:	8b 45 08             	mov    0x8(%ebp),%eax
c010050f:	01 d0                	add    %edx,%eax
c0100511:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100515:	0f b6 c0             	movzbl %al,%eax
c0100518:	39 45 14             	cmp    %eax,0x14(%ebp)
c010051b:	75 d6                	jne    c01004f3 <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
c010051d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100520:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100523:	7d 09                	jge    c010052e <stab_binsearch+0x79>
            l = true_m + 1;
c0100525:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100528:	40                   	inc    %eax
c0100529:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c010052c:	eb 73                	jmp    c01005a1 <stab_binsearch+0xec>
        }

        // actual binary search
        any_matches = 1;
c010052e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100535:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100538:	89 d0                	mov    %edx,%eax
c010053a:	01 c0                	add    %eax,%eax
c010053c:	01 d0                	add    %edx,%eax
c010053e:	c1 e0 02             	shl    $0x2,%eax
c0100541:	89 c2                	mov    %eax,%edx
c0100543:	8b 45 08             	mov    0x8(%ebp),%eax
c0100546:	01 d0                	add    %edx,%eax
c0100548:	8b 40 08             	mov    0x8(%eax),%eax
c010054b:	39 45 18             	cmp    %eax,0x18(%ebp)
c010054e:	76 11                	jbe    c0100561 <stab_binsearch+0xac>
            *region_left = m;
c0100550:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100553:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100556:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c0100558:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010055b:	40                   	inc    %eax
c010055c:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010055f:	eb 40                	jmp    c01005a1 <stab_binsearch+0xec>
        } else if (stabs[m].n_value > addr) {
c0100561:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100564:	89 d0                	mov    %edx,%eax
c0100566:	01 c0                	add    %eax,%eax
c0100568:	01 d0                	add    %edx,%eax
c010056a:	c1 e0 02             	shl    $0x2,%eax
c010056d:	89 c2                	mov    %eax,%edx
c010056f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100572:	01 d0                	add    %edx,%eax
c0100574:	8b 40 08             	mov    0x8(%eax),%eax
c0100577:	39 45 18             	cmp    %eax,0x18(%ebp)
c010057a:	73 14                	jae    c0100590 <stab_binsearch+0xdb>
            *region_right = m - 1;
c010057c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010057f:	8d 50 ff             	lea    -0x1(%eax),%edx
c0100582:	8b 45 10             	mov    0x10(%ebp),%eax
c0100585:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c0100587:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010058a:	48                   	dec    %eax
c010058b:	89 45 f8             	mov    %eax,-0x8(%ebp)
c010058e:	eb 11                	jmp    c01005a1 <stab_binsearch+0xec>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c0100590:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100593:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100596:	89 10                	mov    %edx,(%eax)
            l = m;
c0100598:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010059b:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c010059e:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
c01005a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01005a4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01005a7:	0f 8e 2a ff ff ff    	jle    c01004d7 <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
c01005ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01005b1:	75 0f                	jne    c01005c2 <stab_binsearch+0x10d>
        *region_right = *region_left - 1;
c01005b3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005b6:	8b 00                	mov    (%eax),%eax
c01005b8:	8d 50 ff             	lea    -0x1(%eax),%edx
c01005bb:	8b 45 10             	mov    0x10(%ebp),%eax
c01005be:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
c01005c0:	eb 3e                	jmp    c0100600 <stab_binsearch+0x14b>
        l = *region_right;
c01005c2:	8b 45 10             	mov    0x10(%ebp),%eax
c01005c5:	8b 00                	mov    (%eax),%eax
c01005c7:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c01005ca:	eb 03                	jmp    c01005cf <stab_binsearch+0x11a>
c01005cc:	ff 4d fc             	decl   -0x4(%ebp)
c01005cf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005d2:	8b 00                	mov    (%eax),%eax
c01005d4:	39 45 fc             	cmp    %eax,-0x4(%ebp)
c01005d7:	7e 1f                	jle    c01005f8 <stab_binsearch+0x143>
c01005d9:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01005dc:	89 d0                	mov    %edx,%eax
c01005de:	01 c0                	add    %eax,%eax
c01005e0:	01 d0                	add    %edx,%eax
c01005e2:	c1 e0 02             	shl    $0x2,%eax
c01005e5:	89 c2                	mov    %eax,%edx
c01005e7:	8b 45 08             	mov    0x8(%ebp),%eax
c01005ea:	01 d0                	add    %edx,%eax
c01005ec:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01005f0:	0f b6 c0             	movzbl %al,%eax
c01005f3:	39 45 14             	cmp    %eax,0x14(%ebp)
c01005f6:	75 d4                	jne    c01005cc <stab_binsearch+0x117>
        *region_left = l;
c01005f8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005fb:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01005fe:	89 10                	mov    %edx,(%eax)
}
c0100600:	90                   	nop
c0100601:	c9                   	leave  
c0100602:	c3                   	ret    

c0100603 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c0100603:	55                   	push   %ebp
c0100604:	89 e5                	mov    %esp,%ebp
c0100606:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100609:	8b 45 0c             	mov    0xc(%ebp),%eax
c010060c:	c7 00 d8 69 10 c0    	movl   $0xc01069d8,(%eax)
    info->eip_line = 0;
c0100612:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100615:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c010061c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010061f:	c7 40 08 d8 69 10 c0 	movl   $0xc01069d8,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100626:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100629:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100630:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100633:	8b 55 08             	mov    0x8(%ebp),%edx
c0100636:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100639:	8b 45 0c             	mov    0xc(%ebp),%eax
c010063c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c0100643:	c7 45 f4 88 7d 10 c0 	movl   $0xc0107d88,-0xc(%ebp)
    stab_end = __STAB_END__;
c010064a:	c7 45 f0 e0 4e 11 c0 	movl   $0xc0114ee0,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100651:	c7 45 ec e1 4e 11 c0 	movl   $0xc0114ee1,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100658:	c7 45 e8 42 7b 11 c0 	movl   $0xc0117b42,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c010065f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100662:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0100665:	76 0b                	jbe    c0100672 <debuginfo_eip+0x6f>
c0100667:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010066a:	48                   	dec    %eax
c010066b:	0f b6 00             	movzbl (%eax),%eax
c010066e:	84 c0                	test   %al,%al
c0100670:	74 0a                	je     c010067c <debuginfo_eip+0x79>
        return -1;
c0100672:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100677:	e9 ab 02 00 00       	jmp    c0100927 <debuginfo_eip+0x324>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c010067c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c0100683:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100686:	2b 45 f4             	sub    -0xc(%ebp),%eax
c0100689:	c1 f8 02             	sar    $0x2,%eax
c010068c:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c0100692:	48                   	dec    %eax
c0100693:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c0100696:	8b 45 08             	mov    0x8(%ebp),%eax
c0100699:	89 44 24 10          	mov    %eax,0x10(%esp)
c010069d:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01006a4:	00 
c01006a5:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01006a8:	89 44 24 08          	mov    %eax,0x8(%esp)
c01006ac:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01006af:	89 44 24 04          	mov    %eax,0x4(%esp)
c01006b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006b6:	89 04 24             	mov    %eax,(%esp)
c01006b9:	e8 f7 fd ff ff       	call   c01004b5 <stab_binsearch>
    if (lfile == 0)
c01006be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006c1:	85 c0                	test   %eax,%eax
c01006c3:	75 0a                	jne    c01006cf <debuginfo_eip+0xcc>
        return -1;
c01006c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01006ca:	e9 58 02 00 00       	jmp    c0100927 <debuginfo_eip+0x324>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c01006cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006d2:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01006d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006d8:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c01006db:	8b 45 08             	mov    0x8(%ebp),%eax
c01006de:	89 44 24 10          	mov    %eax,0x10(%esp)
c01006e2:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c01006e9:	00 
c01006ea:	8d 45 d8             	lea    -0x28(%ebp),%eax
c01006ed:	89 44 24 08          	mov    %eax,0x8(%esp)
c01006f1:	8d 45 dc             	lea    -0x24(%ebp),%eax
c01006f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01006f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006fb:	89 04 24             	mov    %eax,(%esp)
c01006fe:	e8 b2 fd ff ff       	call   c01004b5 <stab_binsearch>

    if (lfun <= rfun) {
c0100703:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100706:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100709:	39 c2                	cmp    %eax,%edx
c010070b:	7f 78                	jg     c0100785 <debuginfo_eip+0x182>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c010070d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100710:	89 c2                	mov    %eax,%edx
c0100712:	89 d0                	mov    %edx,%eax
c0100714:	01 c0                	add    %eax,%eax
c0100716:	01 d0                	add    %edx,%eax
c0100718:	c1 e0 02             	shl    $0x2,%eax
c010071b:	89 c2                	mov    %eax,%edx
c010071d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100720:	01 d0                	add    %edx,%eax
c0100722:	8b 10                	mov    (%eax),%edx
c0100724:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100727:	2b 45 ec             	sub    -0x14(%ebp),%eax
c010072a:	39 c2                	cmp    %eax,%edx
c010072c:	73 22                	jae    c0100750 <debuginfo_eip+0x14d>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c010072e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100731:	89 c2                	mov    %eax,%edx
c0100733:	89 d0                	mov    %edx,%eax
c0100735:	01 c0                	add    %eax,%eax
c0100737:	01 d0                	add    %edx,%eax
c0100739:	c1 e0 02             	shl    $0x2,%eax
c010073c:	89 c2                	mov    %eax,%edx
c010073e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100741:	01 d0                	add    %edx,%eax
c0100743:	8b 10                	mov    (%eax),%edx
c0100745:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100748:	01 c2                	add    %eax,%edx
c010074a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010074d:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c0100750:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100753:	89 c2                	mov    %eax,%edx
c0100755:	89 d0                	mov    %edx,%eax
c0100757:	01 c0                	add    %eax,%eax
c0100759:	01 d0                	add    %edx,%eax
c010075b:	c1 e0 02             	shl    $0x2,%eax
c010075e:	89 c2                	mov    %eax,%edx
c0100760:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100763:	01 d0                	add    %edx,%eax
c0100765:	8b 50 08             	mov    0x8(%eax),%edx
c0100768:	8b 45 0c             	mov    0xc(%ebp),%eax
c010076b:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c010076e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100771:	8b 40 10             	mov    0x10(%eax),%eax
c0100774:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c0100777:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010077a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c010077d:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100780:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0100783:	eb 15                	jmp    c010079a <debuginfo_eip+0x197>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c0100785:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100788:	8b 55 08             	mov    0x8(%ebp),%edx
c010078b:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c010078e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100791:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c0100794:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100797:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c010079a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010079d:	8b 40 08             	mov    0x8(%eax),%eax
c01007a0:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01007a7:	00 
c01007a8:	89 04 24             	mov    %eax,(%esp)
c01007ab:	e8 a1 57 00 00       	call   c0105f51 <strfind>
c01007b0:	89 c2                	mov    %eax,%edx
c01007b2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007b5:	8b 40 08             	mov    0x8(%eax),%eax
c01007b8:	29 c2                	sub    %eax,%edx
c01007ba:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007bd:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c01007c0:	8b 45 08             	mov    0x8(%ebp),%eax
c01007c3:	89 44 24 10          	mov    %eax,0x10(%esp)
c01007c7:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c01007ce:	00 
c01007cf:	8d 45 d0             	lea    -0x30(%ebp),%eax
c01007d2:	89 44 24 08          	mov    %eax,0x8(%esp)
c01007d6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c01007d9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01007dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007e0:	89 04 24             	mov    %eax,(%esp)
c01007e3:	e8 cd fc ff ff       	call   c01004b5 <stab_binsearch>
    if (lline <= rline) {
c01007e8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007eb:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01007ee:	39 c2                	cmp    %eax,%edx
c01007f0:	7f 23                	jg     c0100815 <debuginfo_eip+0x212>
        info->eip_line = stabs[rline].n_desc;
c01007f2:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01007f5:	89 c2                	mov    %eax,%edx
c01007f7:	89 d0                	mov    %edx,%eax
c01007f9:	01 c0                	add    %eax,%eax
c01007fb:	01 d0                	add    %edx,%eax
c01007fd:	c1 e0 02             	shl    $0x2,%eax
c0100800:	89 c2                	mov    %eax,%edx
c0100802:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100805:	01 d0                	add    %edx,%eax
c0100807:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c010080b:	89 c2                	mov    %eax,%edx
c010080d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100810:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100813:	eb 11                	jmp    c0100826 <debuginfo_eip+0x223>
        return -1;
c0100815:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010081a:	e9 08 01 00 00       	jmp    c0100927 <debuginfo_eip+0x324>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c010081f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100822:	48                   	dec    %eax
c0100823:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
c0100826:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100829:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010082c:	39 c2                	cmp    %eax,%edx
c010082e:	7c 56                	jl     c0100886 <debuginfo_eip+0x283>
           && stabs[lline].n_type != N_SOL
c0100830:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100833:	89 c2                	mov    %eax,%edx
c0100835:	89 d0                	mov    %edx,%eax
c0100837:	01 c0                	add    %eax,%eax
c0100839:	01 d0                	add    %edx,%eax
c010083b:	c1 e0 02             	shl    $0x2,%eax
c010083e:	89 c2                	mov    %eax,%edx
c0100840:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100843:	01 d0                	add    %edx,%eax
c0100845:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100849:	3c 84                	cmp    $0x84,%al
c010084b:	74 39                	je     c0100886 <debuginfo_eip+0x283>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c010084d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100850:	89 c2                	mov    %eax,%edx
c0100852:	89 d0                	mov    %edx,%eax
c0100854:	01 c0                	add    %eax,%eax
c0100856:	01 d0                	add    %edx,%eax
c0100858:	c1 e0 02             	shl    $0x2,%eax
c010085b:	89 c2                	mov    %eax,%edx
c010085d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100860:	01 d0                	add    %edx,%eax
c0100862:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100866:	3c 64                	cmp    $0x64,%al
c0100868:	75 b5                	jne    c010081f <debuginfo_eip+0x21c>
c010086a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010086d:	89 c2                	mov    %eax,%edx
c010086f:	89 d0                	mov    %edx,%eax
c0100871:	01 c0                	add    %eax,%eax
c0100873:	01 d0                	add    %edx,%eax
c0100875:	c1 e0 02             	shl    $0x2,%eax
c0100878:	89 c2                	mov    %eax,%edx
c010087a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010087d:	01 d0                	add    %edx,%eax
c010087f:	8b 40 08             	mov    0x8(%eax),%eax
c0100882:	85 c0                	test   %eax,%eax
c0100884:	74 99                	je     c010081f <debuginfo_eip+0x21c>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c0100886:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100889:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010088c:	39 c2                	cmp    %eax,%edx
c010088e:	7c 42                	jl     c01008d2 <debuginfo_eip+0x2cf>
c0100890:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100893:	89 c2                	mov    %eax,%edx
c0100895:	89 d0                	mov    %edx,%eax
c0100897:	01 c0                	add    %eax,%eax
c0100899:	01 d0                	add    %edx,%eax
c010089b:	c1 e0 02             	shl    $0x2,%eax
c010089e:	89 c2                	mov    %eax,%edx
c01008a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008a3:	01 d0                	add    %edx,%eax
c01008a5:	8b 10                	mov    (%eax),%edx
c01008a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01008aa:	2b 45 ec             	sub    -0x14(%ebp),%eax
c01008ad:	39 c2                	cmp    %eax,%edx
c01008af:	73 21                	jae    c01008d2 <debuginfo_eip+0x2cf>
        info->eip_file = stabstr + stabs[lline].n_strx;
c01008b1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008b4:	89 c2                	mov    %eax,%edx
c01008b6:	89 d0                	mov    %edx,%eax
c01008b8:	01 c0                	add    %eax,%eax
c01008ba:	01 d0                	add    %edx,%eax
c01008bc:	c1 e0 02             	shl    $0x2,%eax
c01008bf:	89 c2                	mov    %eax,%edx
c01008c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008c4:	01 d0                	add    %edx,%eax
c01008c6:	8b 10                	mov    (%eax),%edx
c01008c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01008cb:	01 c2                	add    %eax,%edx
c01008cd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008d0:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c01008d2:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01008d5:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01008d8:	39 c2                	cmp    %eax,%edx
c01008da:	7d 46                	jge    c0100922 <debuginfo_eip+0x31f>
        for (lline = lfun + 1;
c01008dc:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01008df:	40                   	inc    %eax
c01008e0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c01008e3:	eb 16                	jmp    c01008fb <debuginfo_eip+0x2f8>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c01008e5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008e8:	8b 40 14             	mov    0x14(%eax),%eax
c01008eb:	8d 50 01             	lea    0x1(%eax),%edx
c01008ee:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008f1:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
c01008f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008f7:	40                   	inc    %eax
c01008f8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
c01008fb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01008fe:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
c0100901:	39 c2                	cmp    %eax,%edx
c0100903:	7d 1d                	jge    c0100922 <debuginfo_eip+0x31f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100905:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100908:	89 c2                	mov    %eax,%edx
c010090a:	89 d0                	mov    %edx,%eax
c010090c:	01 c0                	add    %eax,%eax
c010090e:	01 d0                	add    %edx,%eax
c0100910:	c1 e0 02             	shl    $0x2,%eax
c0100913:	89 c2                	mov    %eax,%edx
c0100915:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100918:	01 d0                	add    %edx,%eax
c010091a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010091e:	3c a0                	cmp    $0xa0,%al
c0100920:	74 c3                	je     c01008e5 <debuginfo_eip+0x2e2>
        }
    }
    return 0;
c0100922:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100927:	c9                   	leave  
c0100928:	c3                   	ret    

c0100929 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100929:	55                   	push   %ebp
c010092a:	89 e5                	mov    %esp,%ebp
c010092c:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c010092f:	c7 04 24 e2 69 10 c0 	movl   $0xc01069e2,(%esp)
c0100936:	e8 53 f9 ff ff       	call   c010028e <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c010093b:	c7 44 24 04 36 00 10 	movl   $0xc0100036,0x4(%esp)
c0100942:	c0 
c0100943:	c7 04 24 fb 69 10 c0 	movl   $0xc01069fb,(%esp)
c010094a:	e8 3f f9 ff ff       	call   c010028e <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c010094f:	c7 44 24 04 ca 68 10 	movl   $0xc01068ca,0x4(%esp)
c0100956:	c0 
c0100957:	c7 04 24 13 6a 10 c0 	movl   $0xc0106a13,(%esp)
c010095e:	e8 2b f9 ff ff       	call   c010028e <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c0100963:	c7 44 24 04 00 d0 11 	movl   $0xc011d000,0x4(%esp)
c010096a:	c0 
c010096b:	c7 04 24 2b 6a 10 c0 	movl   $0xc0106a2b,(%esp)
c0100972:	e8 17 f9 ff ff       	call   c010028e <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c0100977:	c7 44 24 04 48 df 11 	movl   $0xc011df48,0x4(%esp)
c010097e:	c0 
c010097f:	c7 04 24 43 6a 10 c0 	movl   $0xc0106a43,(%esp)
c0100986:	e8 03 f9 ff ff       	call   c010028e <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c010098b:	b8 48 df 11 c0       	mov    $0xc011df48,%eax
c0100990:	2d 36 00 10 c0       	sub    $0xc0100036,%eax
c0100995:	05 ff 03 00 00       	add    $0x3ff,%eax
c010099a:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01009a0:	85 c0                	test   %eax,%eax
c01009a2:	0f 48 c2             	cmovs  %edx,%eax
c01009a5:	c1 f8 0a             	sar    $0xa,%eax
c01009a8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009ac:	c7 04 24 5c 6a 10 c0 	movl   $0xc0106a5c,(%esp)
c01009b3:	e8 d6 f8 ff ff       	call   c010028e <cprintf>
}
c01009b8:	90                   	nop
c01009b9:	c9                   	leave  
c01009ba:	c3                   	ret    

c01009bb <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c01009bb:	55                   	push   %ebp
c01009bc:	89 e5                	mov    %esp,%ebp
c01009be:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c01009c4:	8d 45 dc             	lea    -0x24(%ebp),%eax
c01009c7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009cb:	8b 45 08             	mov    0x8(%ebp),%eax
c01009ce:	89 04 24             	mov    %eax,(%esp)
c01009d1:	e8 2d fc ff ff       	call   c0100603 <debuginfo_eip>
c01009d6:	85 c0                	test   %eax,%eax
c01009d8:	74 15                	je     c01009ef <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c01009da:	8b 45 08             	mov    0x8(%ebp),%eax
c01009dd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009e1:	c7 04 24 86 6a 10 c0 	movl   $0xc0106a86,(%esp)
c01009e8:	e8 a1 f8 ff ff       	call   c010028e <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
c01009ed:	eb 6c                	jmp    c0100a5b <print_debuginfo+0xa0>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c01009ef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01009f6:	eb 1b                	jmp    c0100a13 <print_debuginfo+0x58>
            fnname[j] = info.eip_fn_name[j];
c01009f8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01009fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009fe:	01 d0                	add    %edx,%eax
c0100a00:	0f b6 10             	movzbl (%eax),%edx
c0100a03:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a09:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a0c:	01 c8                	add    %ecx,%eax
c0100a0e:	88 10                	mov    %dl,(%eax)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a10:	ff 45 f4             	incl   -0xc(%ebp)
c0100a13:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a16:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0100a19:	7c dd                	jl     c01009f8 <print_debuginfo+0x3d>
        fnname[j] = '\0';
c0100a1b:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a24:	01 d0                	add    %edx,%eax
c0100a26:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
c0100a29:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100a2c:	8b 55 08             	mov    0x8(%ebp),%edx
c0100a2f:	89 d1                	mov    %edx,%ecx
c0100a31:	29 c1                	sub    %eax,%ecx
c0100a33:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100a36:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100a39:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100a3d:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a43:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100a47:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100a4b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a4f:	c7 04 24 a2 6a 10 c0 	movl   $0xc0106aa2,(%esp)
c0100a56:	e8 33 f8 ff ff       	call   c010028e <cprintf>
}
c0100a5b:	90                   	nop
c0100a5c:	c9                   	leave  
c0100a5d:	c3                   	ret    

c0100a5e <read_eip>:

static __noinline uint32_t
read_eip(void) {
c0100a5e:	55                   	push   %ebp
c0100a5f:	89 e5                	mov    %esp,%ebp
c0100a61:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c0100a64:	8b 45 04             	mov    0x4(%ebp),%eax
c0100a67:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c0100a6a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0100a6d:	c9                   	leave  
c0100a6e:	c3                   	ret    

c0100a6f <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c0100a6f:	55                   	push   %ebp
c0100a70:	89 e5                	mov    %esp,%ebp
c0100a72:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c0100a75:	89 e8                	mov    %ebp,%eax
c0100a77:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
c0100a7a:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();
c0100a7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100a80:	e8 d9 ff ff ff       	call   c0100a5e <read_eip>
c0100a85:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
c0100a88:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0100a8f:	e9 84 00 00 00       	jmp    c0100b18 <print_stackframe+0xa9>
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
c0100a94:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a97:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100a9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a9e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100aa2:	c7 04 24 b4 6a 10 c0 	movl   $0xc0106ab4,(%esp)
c0100aa9:	e8 e0 f7 ff ff       	call   c010028e <cprintf>
        uint32_t *args = (uint32_t *)ebp + 2;
c0100aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ab1:	83 c0 08             	add    $0x8,%eax
c0100ab4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (j = 0; j < 4; j ++) {
c0100ab7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100abe:	eb 24                	jmp    c0100ae4 <print_stackframe+0x75>
            cprintf("0x%08x ", args[j]);
c0100ac0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100ac3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100aca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100acd:	01 d0                	add    %edx,%eax
c0100acf:	8b 00                	mov    (%eax),%eax
c0100ad1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ad5:	c7 04 24 d0 6a 10 c0 	movl   $0xc0106ad0,(%esp)
c0100adc:	e8 ad f7 ff ff       	call   c010028e <cprintf>
        for (j = 0; j < 4; j ++) {
c0100ae1:	ff 45 e8             	incl   -0x18(%ebp)
c0100ae4:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100ae8:	7e d6                	jle    c0100ac0 <print_stackframe+0x51>
        }
        cprintf("\n");
c0100aea:	c7 04 24 d8 6a 10 c0 	movl   $0xc0106ad8,(%esp)
c0100af1:	e8 98 f7 ff ff       	call   c010028e <cprintf>
        print_debuginfo(eip - 1);
c0100af6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100af9:	48                   	dec    %eax
c0100afa:	89 04 24             	mov    %eax,(%esp)
c0100afd:	e8 b9 fe ff ff       	call   c01009bb <print_debuginfo>
        eip = ((uint32_t *)ebp)[1];
c0100b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b05:	83 c0 04             	add    $0x4,%eax
c0100b08:	8b 00                	mov    (%eax),%eax
c0100b0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
c0100b0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b10:	8b 00                	mov    (%eax),%eax
c0100b12:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
c0100b15:	ff 45 ec             	incl   -0x14(%ebp)
c0100b18:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100b1c:	74 0a                	je     c0100b28 <print_stackframe+0xb9>
c0100b1e:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100b22:	0f 8e 6c ff ff ff    	jle    c0100a94 <print_stackframe+0x25>
    }
}
c0100b28:	90                   	nop
c0100b29:	c9                   	leave  
c0100b2a:	c3                   	ret    

c0100b2b <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100b2b:	55                   	push   %ebp
c0100b2c:	89 e5                	mov    %esp,%ebp
c0100b2e:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100b31:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b38:	eb 0c                	jmp    c0100b46 <parse+0x1b>
            *buf ++ = '\0';
c0100b3a:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b3d:	8d 50 01             	lea    0x1(%eax),%edx
c0100b40:	89 55 08             	mov    %edx,0x8(%ebp)
c0100b43:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b46:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b49:	0f b6 00             	movzbl (%eax),%eax
c0100b4c:	84 c0                	test   %al,%al
c0100b4e:	74 1d                	je     c0100b6d <parse+0x42>
c0100b50:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b53:	0f b6 00             	movzbl (%eax),%eax
c0100b56:	0f be c0             	movsbl %al,%eax
c0100b59:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b5d:	c7 04 24 5c 6b 10 c0 	movl   $0xc0106b5c,(%esp)
c0100b64:	e8 b6 53 00 00       	call   c0105f1f <strchr>
c0100b69:	85 c0                	test   %eax,%eax
c0100b6b:	75 cd                	jne    c0100b3a <parse+0xf>
        }
        if (*buf == '\0') {
c0100b6d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b70:	0f b6 00             	movzbl (%eax),%eax
c0100b73:	84 c0                	test   %al,%al
c0100b75:	74 65                	je     c0100bdc <parse+0xb1>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100b77:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100b7b:	75 14                	jne    c0100b91 <parse+0x66>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100b7d:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100b84:	00 
c0100b85:	c7 04 24 61 6b 10 c0 	movl   $0xc0106b61,(%esp)
c0100b8c:	e8 fd f6 ff ff       	call   c010028e <cprintf>
        }
        argv[argc ++] = buf;
c0100b91:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b94:	8d 50 01             	lea    0x1(%eax),%edx
c0100b97:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100b9a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100ba1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100ba4:	01 c2                	add    %eax,%edx
c0100ba6:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ba9:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100bab:	eb 03                	jmp    c0100bb0 <parse+0x85>
            buf ++;
c0100bad:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100bb0:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bb3:	0f b6 00             	movzbl (%eax),%eax
c0100bb6:	84 c0                	test   %al,%al
c0100bb8:	74 8c                	je     c0100b46 <parse+0x1b>
c0100bba:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bbd:	0f b6 00             	movzbl (%eax),%eax
c0100bc0:	0f be c0             	movsbl %al,%eax
c0100bc3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bc7:	c7 04 24 5c 6b 10 c0 	movl   $0xc0106b5c,(%esp)
c0100bce:	e8 4c 53 00 00       	call   c0105f1f <strchr>
c0100bd3:	85 c0                	test   %eax,%eax
c0100bd5:	74 d6                	je     c0100bad <parse+0x82>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100bd7:	e9 6a ff ff ff       	jmp    c0100b46 <parse+0x1b>
            break;
c0100bdc:	90                   	nop
        }
    }
    return argc;
c0100bdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100be0:	c9                   	leave  
c0100be1:	c3                   	ret    

c0100be2 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100be2:	55                   	push   %ebp
c0100be3:	89 e5                	mov    %esp,%ebp
c0100be5:	53                   	push   %ebx
c0100be6:	83 ec 64             	sub    $0x64,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100be9:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100bec:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bf0:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bf3:	89 04 24             	mov    %eax,(%esp)
c0100bf6:	e8 30 ff ff ff       	call   c0100b2b <parse>
c0100bfb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100bfe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100c02:	75 0a                	jne    c0100c0e <runcmd+0x2c>
        return 0;
c0100c04:	b8 00 00 00 00       	mov    $0x0,%eax
c0100c09:	e9 83 00 00 00       	jmp    c0100c91 <runcmd+0xaf>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c0e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c15:	eb 5a                	jmp    c0100c71 <runcmd+0x8f>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100c17:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100c1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c1d:	89 d0                	mov    %edx,%eax
c0100c1f:	01 c0                	add    %eax,%eax
c0100c21:	01 d0                	add    %edx,%eax
c0100c23:	c1 e0 02             	shl    $0x2,%eax
c0100c26:	05 00 a0 11 c0       	add    $0xc011a000,%eax
c0100c2b:	8b 00                	mov    (%eax),%eax
c0100c2d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100c31:	89 04 24             	mov    %eax,(%esp)
c0100c34:	e8 49 52 00 00       	call   c0105e82 <strcmp>
c0100c39:	85 c0                	test   %eax,%eax
c0100c3b:	75 31                	jne    c0100c6e <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100c3d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c40:	89 d0                	mov    %edx,%eax
c0100c42:	01 c0                	add    %eax,%eax
c0100c44:	01 d0                	add    %edx,%eax
c0100c46:	c1 e0 02             	shl    $0x2,%eax
c0100c49:	05 08 a0 11 c0       	add    $0xc011a008,%eax
c0100c4e:	8b 10                	mov    (%eax),%edx
c0100c50:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100c53:	83 c0 04             	add    $0x4,%eax
c0100c56:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0100c59:	8d 59 ff             	lea    -0x1(%ecx),%ebx
c0100c5c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c0100c5f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100c63:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c67:	89 1c 24             	mov    %ebx,(%esp)
c0100c6a:	ff d2                	call   *%edx
c0100c6c:	eb 23                	jmp    c0100c91 <runcmd+0xaf>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c6e:	ff 45 f4             	incl   -0xc(%ebp)
c0100c71:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c74:	83 f8 02             	cmp    $0x2,%eax
c0100c77:	76 9e                	jbe    c0100c17 <runcmd+0x35>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100c79:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100c7c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c80:	c7 04 24 7f 6b 10 c0 	movl   $0xc0106b7f,(%esp)
c0100c87:	e8 02 f6 ff ff       	call   c010028e <cprintf>
    return 0;
c0100c8c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100c91:	83 c4 64             	add    $0x64,%esp
c0100c94:	5b                   	pop    %ebx
c0100c95:	5d                   	pop    %ebp
c0100c96:	c3                   	ret    

c0100c97 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100c97:	55                   	push   %ebp
c0100c98:	89 e5                	mov    %esp,%ebp
c0100c9a:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100c9d:	c7 04 24 98 6b 10 c0 	movl   $0xc0106b98,(%esp)
c0100ca4:	e8 e5 f5 ff ff       	call   c010028e <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100ca9:	c7 04 24 c0 6b 10 c0 	movl   $0xc0106bc0,(%esp)
c0100cb0:	e8 d9 f5 ff ff       	call   c010028e <cprintf>

    if (tf != NULL) {
c0100cb5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100cb9:	74 0b                	je     c0100cc6 <kmonitor+0x2f>
        print_trapframe(tf);
c0100cbb:	8b 45 08             	mov    0x8(%ebp),%eax
c0100cbe:	89 04 24             	mov    %eax,(%esp)
c0100cc1:	e8 b2 0e 00 00       	call   c0101b78 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100cc6:	c7 04 24 e5 6b 10 c0 	movl   $0xc0106be5,(%esp)
c0100ccd:	e8 5f f6 ff ff       	call   c0100331 <readline>
c0100cd2:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100cd5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100cd9:	74 eb                	je     c0100cc6 <kmonitor+0x2f>
            if (runcmd(buf, tf) < 0) {
c0100cdb:	8b 45 08             	mov    0x8(%ebp),%eax
c0100cde:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ce5:	89 04 24             	mov    %eax,(%esp)
c0100ce8:	e8 f5 fe ff ff       	call   c0100be2 <runcmd>
c0100ced:	85 c0                	test   %eax,%eax
c0100cef:	78 02                	js     c0100cf3 <kmonitor+0x5c>
        if ((buf = readline("K> ")) != NULL) {
c0100cf1:	eb d3                	jmp    c0100cc6 <kmonitor+0x2f>
                break;
c0100cf3:	90                   	nop
            }
        }
    }
}
c0100cf4:	90                   	nop
c0100cf5:	c9                   	leave  
c0100cf6:	c3                   	ret    

c0100cf7 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100cf7:	55                   	push   %ebp
c0100cf8:	89 e5                	mov    %esp,%ebp
c0100cfa:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100cfd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100d04:	eb 3d                	jmp    c0100d43 <mon_help+0x4c>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100d06:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d09:	89 d0                	mov    %edx,%eax
c0100d0b:	01 c0                	add    %eax,%eax
c0100d0d:	01 d0                	add    %edx,%eax
c0100d0f:	c1 e0 02             	shl    $0x2,%eax
c0100d12:	05 04 a0 11 c0       	add    $0xc011a004,%eax
c0100d17:	8b 08                	mov    (%eax),%ecx
c0100d19:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d1c:	89 d0                	mov    %edx,%eax
c0100d1e:	01 c0                	add    %eax,%eax
c0100d20:	01 d0                	add    %edx,%eax
c0100d22:	c1 e0 02             	shl    $0x2,%eax
c0100d25:	05 00 a0 11 c0       	add    $0xc011a000,%eax
c0100d2a:	8b 00                	mov    (%eax),%eax
c0100d2c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100d30:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d34:	c7 04 24 e9 6b 10 c0 	movl   $0xc0106be9,(%esp)
c0100d3b:	e8 4e f5 ff ff       	call   c010028e <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100d40:	ff 45 f4             	incl   -0xc(%ebp)
c0100d43:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d46:	83 f8 02             	cmp    $0x2,%eax
c0100d49:	76 bb                	jbe    c0100d06 <mon_help+0xf>
    }
    return 0;
c0100d4b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d50:	c9                   	leave  
c0100d51:	c3                   	ret    

c0100d52 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100d52:	55                   	push   %ebp
c0100d53:	89 e5                	mov    %esp,%ebp
c0100d55:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100d58:	e8 cc fb ff ff       	call   c0100929 <print_kerninfo>
    return 0;
c0100d5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d62:	c9                   	leave  
c0100d63:	c3                   	ret    

c0100d64 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100d64:	55                   	push   %ebp
c0100d65:	89 e5                	mov    %esp,%ebp
c0100d67:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100d6a:	e8 00 fd ff ff       	call   c0100a6f <print_stackframe>
    return 0;
c0100d6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d74:	c9                   	leave  
c0100d75:	c3                   	ret    

c0100d76 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100d76:	55                   	push   %ebp
c0100d77:	89 e5                	mov    %esp,%ebp
c0100d79:	83 ec 28             	sub    $0x28,%esp
c0100d7c:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
c0100d82:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100d86:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100d8a:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100d8e:	ee                   	out    %al,(%dx)
c0100d8f:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100d95:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100d99:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100d9d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100da1:	ee                   	out    %al,(%dx)
c0100da2:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
c0100da8:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
c0100dac:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100db0:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100db4:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100db5:	c7 05 2c df 11 c0 00 	movl   $0x0,0xc011df2c
c0100dbc:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100dbf:	c7 04 24 f2 6b 10 c0 	movl   $0xc0106bf2,(%esp)
c0100dc6:	e8 c3 f4 ff ff       	call   c010028e <cprintf>
    pic_enable(IRQ_TIMER);
c0100dcb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100dd2:	e8 2e 09 00 00       	call   c0101705 <pic_enable>
}
c0100dd7:	90                   	nop
c0100dd8:	c9                   	leave  
c0100dd9:	c3                   	ret    

c0100dda <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100dda:	55                   	push   %ebp
c0100ddb:	89 e5                	mov    %esp,%ebp
c0100ddd:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100de0:	9c                   	pushf  
c0100de1:	58                   	pop    %eax
c0100de2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100de5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100de8:	25 00 02 00 00       	and    $0x200,%eax
c0100ded:	85 c0                	test   %eax,%eax
c0100def:	74 0c                	je     c0100dfd <__intr_save+0x23>
        intr_disable();
c0100df1:	e8 83 0a 00 00       	call   c0101879 <intr_disable>
        return 1;
c0100df6:	b8 01 00 00 00       	mov    $0x1,%eax
c0100dfb:	eb 05                	jmp    c0100e02 <__intr_save+0x28>
    }
    return 0;
c0100dfd:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e02:	c9                   	leave  
c0100e03:	c3                   	ret    

c0100e04 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e04:	55                   	push   %ebp
c0100e05:	89 e5                	mov    %esp,%ebp
c0100e07:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e0a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e0e:	74 05                	je     c0100e15 <__intr_restore+0x11>
        intr_enable();
c0100e10:	e8 5d 0a 00 00       	call   c0101872 <intr_enable>
    }
}
c0100e15:	90                   	nop
c0100e16:	c9                   	leave  
c0100e17:	c3                   	ret    

c0100e18 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e18:	55                   	push   %ebp
c0100e19:	89 e5                	mov    %esp,%ebp
c0100e1b:	83 ec 10             	sub    $0x10,%esp
c0100e1e:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e24:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e28:	89 c2                	mov    %eax,%edx
c0100e2a:	ec                   	in     (%dx),%al
c0100e2b:	88 45 f1             	mov    %al,-0xf(%ebp)
c0100e2e:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e34:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e38:	89 c2                	mov    %eax,%edx
c0100e3a:	ec                   	in     (%dx),%al
c0100e3b:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e3e:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e44:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e48:	89 c2                	mov    %eax,%edx
c0100e4a:	ec                   	in     (%dx),%al
c0100e4b:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100e4e:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
c0100e54:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e58:	89 c2                	mov    %eax,%edx
c0100e5a:	ec                   	in     (%dx),%al
c0100e5b:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e5e:	90                   	nop
c0100e5f:	c9                   	leave  
c0100e60:	c3                   	ret    

c0100e61 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e61:	55                   	push   %ebp
c0100e62:	89 e5                	mov    %esp,%ebp
c0100e64:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e67:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100e6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e71:	0f b7 00             	movzwl (%eax),%eax
c0100e74:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100e78:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e7b:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100e80:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e83:	0f b7 00             	movzwl (%eax),%eax
c0100e86:	0f b7 c0             	movzwl %ax,%eax
c0100e89:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
c0100e8e:	74 12                	je     c0100ea2 <cga_init+0x41>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100e90:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100e97:	66 c7 05 46 d4 11 c0 	movw   $0x3b4,0xc011d446
c0100e9e:	b4 03 
c0100ea0:	eb 13                	jmp    c0100eb5 <cga_init+0x54>
    } else {
        *cp = was;
c0100ea2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ea5:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100ea9:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100eac:	66 c7 05 46 d4 11 c0 	movw   $0x3d4,0xc011d446
c0100eb3:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100eb5:	0f b7 05 46 d4 11 c0 	movzwl 0xc011d446,%eax
c0100ebc:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c0100ec0:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ec4:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100ec8:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100ecc:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100ecd:	0f b7 05 46 d4 11 c0 	movzwl 0xc011d446,%eax
c0100ed4:	40                   	inc    %eax
c0100ed5:	0f b7 c0             	movzwl %ax,%eax
c0100ed8:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100edc:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100ee0:	89 c2                	mov    %eax,%edx
c0100ee2:	ec                   	in     (%dx),%al
c0100ee3:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
c0100ee6:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100eea:	0f b6 c0             	movzbl %al,%eax
c0100eed:	c1 e0 08             	shl    $0x8,%eax
c0100ef0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100ef3:	0f b7 05 46 d4 11 c0 	movzwl 0xc011d446,%eax
c0100efa:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0100efe:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f02:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f06:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f0a:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100f0b:	0f b7 05 46 d4 11 c0 	movzwl 0xc011d446,%eax
c0100f12:	40                   	inc    %eax
c0100f13:	0f b7 c0             	movzwl %ax,%eax
c0100f16:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f1a:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100f1e:	89 c2                	mov    %eax,%edx
c0100f20:	ec                   	in     (%dx),%al
c0100f21:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
c0100f24:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f28:	0f b6 c0             	movzbl %al,%eax
c0100f2b:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f2e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f31:	a3 40 d4 11 c0       	mov    %eax,0xc011d440
    crt_pos = pos;
c0100f36:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f39:	0f b7 c0             	movzwl %ax,%eax
c0100f3c:	66 a3 44 d4 11 c0    	mov    %ax,0xc011d444
}
c0100f42:	90                   	nop
c0100f43:	c9                   	leave  
c0100f44:	c3                   	ret    

c0100f45 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f45:	55                   	push   %ebp
c0100f46:	89 e5                	mov    %esp,%ebp
c0100f48:	83 ec 48             	sub    $0x48,%esp
c0100f4b:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
c0100f51:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f55:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0100f59:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0100f5d:	ee                   	out    %al,(%dx)
c0100f5e:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
c0100f64:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
c0100f68:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0100f6c:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0100f70:	ee                   	out    %al,(%dx)
c0100f71:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
c0100f77:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
c0100f7b:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0100f7f:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0100f83:	ee                   	out    %al,(%dx)
c0100f84:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100f8a:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
c0100f8e:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100f92:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100f96:	ee                   	out    %al,(%dx)
c0100f97:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
c0100f9d:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
c0100fa1:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100fa5:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100fa9:	ee                   	out    %al,(%dx)
c0100faa:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
c0100fb0:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
c0100fb4:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100fb8:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100fbc:	ee                   	out    %al,(%dx)
c0100fbd:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100fc3:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
c0100fc7:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100fcb:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100fcf:	ee                   	out    %al,(%dx)
c0100fd0:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100fd6:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100fda:	89 c2                	mov    %eax,%edx
c0100fdc:	ec                   	in     (%dx),%al
c0100fdd:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100fe0:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0100fe4:	3c ff                	cmp    $0xff,%al
c0100fe6:	0f 95 c0             	setne  %al
c0100fe9:	0f b6 c0             	movzbl %al,%eax
c0100fec:	a3 48 d4 11 c0       	mov    %eax,0xc011d448
c0100ff1:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ff7:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100ffb:	89 c2                	mov    %eax,%edx
c0100ffd:	ec                   	in     (%dx),%al
c0100ffe:	88 45 f1             	mov    %al,-0xf(%ebp)
c0101001:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101007:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010100b:	89 c2                	mov    %eax,%edx
c010100d:	ec                   	in     (%dx),%al
c010100e:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c0101011:	a1 48 d4 11 c0       	mov    0xc011d448,%eax
c0101016:	85 c0                	test   %eax,%eax
c0101018:	74 0c                	je     c0101026 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c010101a:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0101021:	e8 df 06 00 00       	call   c0101705 <pic_enable>
    }
}
c0101026:	90                   	nop
c0101027:	c9                   	leave  
c0101028:	c3                   	ret    

c0101029 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c0101029:	55                   	push   %ebp
c010102a:	89 e5                	mov    %esp,%ebp
c010102c:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c010102f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101036:	eb 08                	jmp    c0101040 <lpt_putc_sub+0x17>
        delay();
c0101038:	e8 db fd ff ff       	call   c0100e18 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c010103d:	ff 45 fc             	incl   -0x4(%ebp)
c0101040:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c0101046:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c010104a:	89 c2                	mov    %eax,%edx
c010104c:	ec                   	in     (%dx),%al
c010104d:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101050:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101054:	84 c0                	test   %al,%al
c0101056:	78 09                	js     c0101061 <lpt_putc_sub+0x38>
c0101058:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c010105f:	7e d7                	jle    c0101038 <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
c0101061:	8b 45 08             	mov    0x8(%ebp),%eax
c0101064:	0f b6 c0             	movzbl %al,%eax
c0101067:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
c010106d:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101070:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101074:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101078:	ee                   	out    %al,(%dx)
c0101079:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c010107f:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c0101083:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101087:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010108b:	ee                   	out    %al,(%dx)
c010108c:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
c0101092:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
c0101096:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010109a:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010109e:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c010109f:	90                   	nop
c01010a0:	c9                   	leave  
c01010a1:	c3                   	ret    

c01010a2 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01010a2:	55                   	push   %ebp
c01010a3:	89 e5                	mov    %esp,%ebp
c01010a5:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01010a8:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01010ac:	74 0d                	je     c01010bb <lpt_putc+0x19>
        lpt_putc_sub(c);
c01010ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01010b1:	89 04 24             	mov    %eax,(%esp)
c01010b4:	e8 70 ff ff ff       	call   c0101029 <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
c01010b9:	eb 24                	jmp    c01010df <lpt_putc+0x3d>
        lpt_putc_sub('\b');
c01010bb:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010c2:	e8 62 ff ff ff       	call   c0101029 <lpt_putc_sub>
        lpt_putc_sub(' ');
c01010c7:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01010ce:	e8 56 ff ff ff       	call   c0101029 <lpt_putc_sub>
        lpt_putc_sub('\b');
c01010d3:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010da:	e8 4a ff ff ff       	call   c0101029 <lpt_putc_sub>
}
c01010df:	90                   	nop
c01010e0:	c9                   	leave  
c01010e1:	c3                   	ret    

c01010e2 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c01010e2:	55                   	push   %ebp
c01010e3:	89 e5                	mov    %esp,%ebp
c01010e5:	53                   	push   %ebx
c01010e6:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c01010e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01010ec:	25 00 ff ff ff       	and    $0xffffff00,%eax
c01010f1:	85 c0                	test   %eax,%eax
c01010f3:	75 07                	jne    c01010fc <cga_putc+0x1a>
        c |= 0x0700;
c01010f5:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c01010fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01010ff:	0f b6 c0             	movzbl %al,%eax
c0101102:	83 f8 0a             	cmp    $0xa,%eax
c0101105:	74 55                	je     c010115c <cga_putc+0x7a>
c0101107:	83 f8 0d             	cmp    $0xd,%eax
c010110a:	74 63                	je     c010116f <cga_putc+0x8d>
c010110c:	83 f8 08             	cmp    $0x8,%eax
c010110f:	0f 85 94 00 00 00    	jne    c01011a9 <cga_putc+0xc7>
    case '\b':
        if (crt_pos > 0) {
c0101115:	0f b7 05 44 d4 11 c0 	movzwl 0xc011d444,%eax
c010111c:	85 c0                	test   %eax,%eax
c010111e:	0f 84 af 00 00 00    	je     c01011d3 <cga_putc+0xf1>
            crt_pos --;
c0101124:	0f b7 05 44 d4 11 c0 	movzwl 0xc011d444,%eax
c010112b:	48                   	dec    %eax
c010112c:	0f b7 c0             	movzwl %ax,%eax
c010112f:	66 a3 44 d4 11 c0    	mov    %ax,0xc011d444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c0101135:	8b 45 08             	mov    0x8(%ebp),%eax
c0101138:	98                   	cwtl   
c0101139:	25 00 ff ff ff       	and    $0xffffff00,%eax
c010113e:	98                   	cwtl   
c010113f:	83 c8 20             	or     $0x20,%eax
c0101142:	98                   	cwtl   
c0101143:	8b 15 40 d4 11 c0    	mov    0xc011d440,%edx
c0101149:	0f b7 0d 44 d4 11 c0 	movzwl 0xc011d444,%ecx
c0101150:	01 c9                	add    %ecx,%ecx
c0101152:	01 ca                	add    %ecx,%edx
c0101154:	0f b7 c0             	movzwl %ax,%eax
c0101157:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c010115a:	eb 77                	jmp    c01011d3 <cga_putc+0xf1>
    case '\n':
        crt_pos += CRT_COLS;
c010115c:	0f b7 05 44 d4 11 c0 	movzwl 0xc011d444,%eax
c0101163:	83 c0 50             	add    $0x50,%eax
c0101166:	0f b7 c0             	movzwl %ax,%eax
c0101169:	66 a3 44 d4 11 c0    	mov    %ax,0xc011d444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c010116f:	0f b7 1d 44 d4 11 c0 	movzwl 0xc011d444,%ebx
c0101176:	0f b7 0d 44 d4 11 c0 	movzwl 0xc011d444,%ecx
c010117d:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
c0101182:	89 c8                	mov    %ecx,%eax
c0101184:	f7 e2                	mul    %edx
c0101186:	c1 ea 06             	shr    $0x6,%edx
c0101189:	89 d0                	mov    %edx,%eax
c010118b:	c1 e0 02             	shl    $0x2,%eax
c010118e:	01 d0                	add    %edx,%eax
c0101190:	c1 e0 04             	shl    $0x4,%eax
c0101193:	29 c1                	sub    %eax,%ecx
c0101195:	89 c8                	mov    %ecx,%eax
c0101197:	0f b7 c0             	movzwl %ax,%eax
c010119a:	29 c3                	sub    %eax,%ebx
c010119c:	89 d8                	mov    %ebx,%eax
c010119e:	0f b7 c0             	movzwl %ax,%eax
c01011a1:	66 a3 44 d4 11 c0    	mov    %ax,0xc011d444
        break;
c01011a7:	eb 2b                	jmp    c01011d4 <cga_putc+0xf2>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01011a9:	8b 0d 40 d4 11 c0    	mov    0xc011d440,%ecx
c01011af:	0f b7 05 44 d4 11 c0 	movzwl 0xc011d444,%eax
c01011b6:	8d 50 01             	lea    0x1(%eax),%edx
c01011b9:	0f b7 d2             	movzwl %dx,%edx
c01011bc:	66 89 15 44 d4 11 c0 	mov    %dx,0xc011d444
c01011c3:	01 c0                	add    %eax,%eax
c01011c5:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c01011c8:	8b 45 08             	mov    0x8(%ebp),%eax
c01011cb:	0f b7 c0             	movzwl %ax,%eax
c01011ce:	66 89 02             	mov    %ax,(%edx)
        break;
c01011d1:	eb 01                	jmp    c01011d4 <cga_putc+0xf2>
        break;
c01011d3:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01011d4:	0f b7 05 44 d4 11 c0 	movzwl 0xc011d444,%eax
c01011db:	3d cf 07 00 00       	cmp    $0x7cf,%eax
c01011e0:	76 5d                	jbe    c010123f <cga_putc+0x15d>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01011e2:	a1 40 d4 11 c0       	mov    0xc011d440,%eax
c01011e7:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01011ed:	a1 40 d4 11 c0       	mov    0xc011d440,%eax
c01011f2:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c01011f9:	00 
c01011fa:	89 54 24 04          	mov    %edx,0x4(%esp)
c01011fe:	89 04 24             	mov    %eax,(%esp)
c0101201:	e8 0f 4f 00 00       	call   c0106115 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101206:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c010120d:	eb 14                	jmp    c0101223 <cga_putc+0x141>
            crt_buf[i] = 0x0700 | ' ';
c010120f:	a1 40 d4 11 c0       	mov    0xc011d440,%eax
c0101214:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101217:	01 d2                	add    %edx,%edx
c0101219:	01 d0                	add    %edx,%eax
c010121b:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101220:	ff 45 f4             	incl   -0xc(%ebp)
c0101223:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c010122a:	7e e3                	jle    c010120f <cga_putc+0x12d>
        }
        crt_pos -= CRT_COLS;
c010122c:	0f b7 05 44 d4 11 c0 	movzwl 0xc011d444,%eax
c0101233:	83 e8 50             	sub    $0x50,%eax
c0101236:	0f b7 c0             	movzwl %ax,%eax
c0101239:	66 a3 44 d4 11 c0    	mov    %ax,0xc011d444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c010123f:	0f b7 05 46 d4 11 c0 	movzwl 0xc011d446,%eax
c0101246:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c010124a:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
c010124e:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101252:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101256:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c0101257:	0f b7 05 44 d4 11 c0 	movzwl 0xc011d444,%eax
c010125e:	c1 e8 08             	shr    $0x8,%eax
c0101261:	0f b7 c0             	movzwl %ax,%eax
c0101264:	0f b6 c0             	movzbl %al,%eax
c0101267:	0f b7 15 46 d4 11 c0 	movzwl 0xc011d446,%edx
c010126e:	42                   	inc    %edx
c010126f:	0f b7 d2             	movzwl %dx,%edx
c0101272:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101276:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101279:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010127d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101281:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c0101282:	0f b7 05 46 d4 11 c0 	movzwl 0xc011d446,%eax
c0101289:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c010128d:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
c0101291:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101295:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101299:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c010129a:	0f b7 05 44 d4 11 c0 	movzwl 0xc011d444,%eax
c01012a1:	0f b6 c0             	movzbl %al,%eax
c01012a4:	0f b7 15 46 d4 11 c0 	movzwl 0xc011d446,%edx
c01012ab:	42                   	inc    %edx
c01012ac:	0f b7 d2             	movzwl %dx,%edx
c01012af:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
c01012b3:	88 45 f1             	mov    %al,-0xf(%ebp)
c01012b6:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01012ba:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01012be:	ee                   	out    %al,(%dx)
}
c01012bf:	90                   	nop
c01012c0:	83 c4 34             	add    $0x34,%esp
c01012c3:	5b                   	pop    %ebx
c01012c4:	5d                   	pop    %ebp
c01012c5:	c3                   	ret    

c01012c6 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01012c6:	55                   	push   %ebp
c01012c7:	89 e5                	mov    %esp,%ebp
c01012c9:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01012d3:	eb 08                	jmp    c01012dd <serial_putc_sub+0x17>
        delay();
c01012d5:	e8 3e fb ff ff       	call   c0100e18 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012da:	ff 45 fc             	incl   -0x4(%ebp)
c01012dd:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01012e3:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01012e7:	89 c2                	mov    %eax,%edx
c01012e9:	ec                   	in     (%dx),%al
c01012ea:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01012ed:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01012f1:	0f b6 c0             	movzbl %al,%eax
c01012f4:	83 e0 20             	and    $0x20,%eax
c01012f7:	85 c0                	test   %eax,%eax
c01012f9:	75 09                	jne    c0101304 <serial_putc_sub+0x3e>
c01012fb:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101302:	7e d1                	jle    c01012d5 <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
c0101304:	8b 45 08             	mov    0x8(%ebp),%eax
c0101307:	0f b6 c0             	movzbl %al,%eax
c010130a:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101310:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101313:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101317:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010131b:	ee                   	out    %al,(%dx)
}
c010131c:	90                   	nop
c010131d:	c9                   	leave  
c010131e:	c3                   	ret    

c010131f <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c010131f:	55                   	push   %ebp
c0101320:	89 e5                	mov    %esp,%ebp
c0101322:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101325:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101329:	74 0d                	je     c0101338 <serial_putc+0x19>
        serial_putc_sub(c);
c010132b:	8b 45 08             	mov    0x8(%ebp),%eax
c010132e:	89 04 24             	mov    %eax,(%esp)
c0101331:	e8 90 ff ff ff       	call   c01012c6 <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
c0101336:	eb 24                	jmp    c010135c <serial_putc+0x3d>
        serial_putc_sub('\b');
c0101338:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010133f:	e8 82 ff ff ff       	call   c01012c6 <serial_putc_sub>
        serial_putc_sub(' ');
c0101344:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010134b:	e8 76 ff ff ff       	call   c01012c6 <serial_putc_sub>
        serial_putc_sub('\b');
c0101350:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101357:	e8 6a ff ff ff       	call   c01012c6 <serial_putc_sub>
}
c010135c:	90                   	nop
c010135d:	c9                   	leave  
c010135e:	c3                   	ret    

c010135f <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c010135f:	55                   	push   %ebp
c0101360:	89 e5                	mov    %esp,%ebp
c0101362:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c0101365:	eb 33                	jmp    c010139a <cons_intr+0x3b>
        if (c != 0) {
c0101367:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010136b:	74 2d                	je     c010139a <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c010136d:	a1 64 d6 11 c0       	mov    0xc011d664,%eax
c0101372:	8d 50 01             	lea    0x1(%eax),%edx
c0101375:	89 15 64 d6 11 c0    	mov    %edx,0xc011d664
c010137b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010137e:	88 90 60 d4 11 c0    	mov    %dl,-0x3fee2ba0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c0101384:	a1 64 d6 11 c0       	mov    0xc011d664,%eax
c0101389:	3d 00 02 00 00       	cmp    $0x200,%eax
c010138e:	75 0a                	jne    c010139a <cons_intr+0x3b>
                cons.wpos = 0;
c0101390:	c7 05 64 d6 11 c0 00 	movl   $0x0,0xc011d664
c0101397:	00 00 00 
    while ((c = (*proc)()) != -1) {
c010139a:	8b 45 08             	mov    0x8(%ebp),%eax
c010139d:	ff d0                	call   *%eax
c010139f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01013a2:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c01013a6:	75 bf                	jne    c0101367 <cons_intr+0x8>
            }
        }
    }
}
c01013a8:	90                   	nop
c01013a9:	c9                   	leave  
c01013aa:	c3                   	ret    

c01013ab <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01013ab:	55                   	push   %ebp
c01013ac:	89 e5                	mov    %esp,%ebp
c01013ae:	83 ec 10             	sub    $0x10,%esp
c01013b1:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013b7:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013bb:	89 c2                	mov    %eax,%edx
c01013bd:	ec                   	in     (%dx),%al
c01013be:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013c1:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01013c5:	0f b6 c0             	movzbl %al,%eax
c01013c8:	83 e0 01             	and    $0x1,%eax
c01013cb:	85 c0                	test   %eax,%eax
c01013cd:	75 07                	jne    c01013d6 <serial_proc_data+0x2b>
        return -1;
c01013cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01013d4:	eb 2a                	jmp    c0101400 <serial_proc_data+0x55>
c01013d6:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013dc:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01013e0:	89 c2                	mov    %eax,%edx
c01013e2:	ec                   	in     (%dx),%al
c01013e3:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01013e6:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01013ea:	0f b6 c0             	movzbl %al,%eax
c01013ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01013f0:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01013f4:	75 07                	jne    c01013fd <serial_proc_data+0x52>
        c = '\b';
c01013f6:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c01013fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0101400:	c9                   	leave  
c0101401:	c3                   	ret    

c0101402 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c0101402:	55                   	push   %ebp
c0101403:	89 e5                	mov    %esp,%ebp
c0101405:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c0101408:	a1 48 d4 11 c0       	mov    0xc011d448,%eax
c010140d:	85 c0                	test   %eax,%eax
c010140f:	74 0c                	je     c010141d <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c0101411:	c7 04 24 ab 13 10 c0 	movl   $0xc01013ab,(%esp)
c0101418:	e8 42 ff ff ff       	call   c010135f <cons_intr>
    }
}
c010141d:	90                   	nop
c010141e:	c9                   	leave  
c010141f:	c3                   	ret    

c0101420 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c0101420:	55                   	push   %ebp
c0101421:	89 e5                	mov    %esp,%ebp
c0101423:	83 ec 38             	sub    $0x38,%esp
c0101426:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010142c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010142f:	89 c2                	mov    %eax,%edx
c0101431:	ec                   	in     (%dx),%al
c0101432:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c0101435:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c0101439:	0f b6 c0             	movzbl %al,%eax
c010143c:	83 e0 01             	and    $0x1,%eax
c010143f:	85 c0                	test   %eax,%eax
c0101441:	75 0a                	jne    c010144d <kbd_proc_data+0x2d>
        return -1;
c0101443:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101448:	e9 55 01 00 00       	jmp    c01015a2 <kbd_proc_data+0x182>
c010144d:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101453:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101456:	89 c2                	mov    %eax,%edx
c0101458:	ec                   	in     (%dx),%al
c0101459:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c010145c:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c0101460:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c0101463:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c0101467:	75 17                	jne    c0101480 <kbd_proc_data+0x60>
        // E0 escape character
        shift |= E0ESC;
c0101469:	a1 68 d6 11 c0       	mov    0xc011d668,%eax
c010146e:	83 c8 40             	or     $0x40,%eax
c0101471:	a3 68 d6 11 c0       	mov    %eax,0xc011d668
        return 0;
c0101476:	b8 00 00 00 00       	mov    $0x0,%eax
c010147b:	e9 22 01 00 00       	jmp    c01015a2 <kbd_proc_data+0x182>
    } else if (data & 0x80) {
c0101480:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101484:	84 c0                	test   %al,%al
c0101486:	79 45                	jns    c01014cd <kbd_proc_data+0xad>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101488:	a1 68 d6 11 c0       	mov    0xc011d668,%eax
c010148d:	83 e0 40             	and    $0x40,%eax
c0101490:	85 c0                	test   %eax,%eax
c0101492:	75 08                	jne    c010149c <kbd_proc_data+0x7c>
c0101494:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101498:	24 7f                	and    $0x7f,%al
c010149a:	eb 04                	jmp    c01014a0 <kbd_proc_data+0x80>
c010149c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014a0:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c01014a3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014a7:	0f b6 80 40 a0 11 c0 	movzbl -0x3fee5fc0(%eax),%eax
c01014ae:	0c 40                	or     $0x40,%al
c01014b0:	0f b6 c0             	movzbl %al,%eax
c01014b3:	f7 d0                	not    %eax
c01014b5:	89 c2                	mov    %eax,%edx
c01014b7:	a1 68 d6 11 c0       	mov    0xc011d668,%eax
c01014bc:	21 d0                	and    %edx,%eax
c01014be:	a3 68 d6 11 c0       	mov    %eax,0xc011d668
        return 0;
c01014c3:	b8 00 00 00 00       	mov    $0x0,%eax
c01014c8:	e9 d5 00 00 00       	jmp    c01015a2 <kbd_proc_data+0x182>
    } else if (shift & E0ESC) {
c01014cd:	a1 68 d6 11 c0       	mov    0xc011d668,%eax
c01014d2:	83 e0 40             	and    $0x40,%eax
c01014d5:	85 c0                	test   %eax,%eax
c01014d7:	74 11                	je     c01014ea <kbd_proc_data+0xca>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01014d9:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01014dd:	a1 68 d6 11 c0       	mov    0xc011d668,%eax
c01014e2:	83 e0 bf             	and    $0xffffffbf,%eax
c01014e5:	a3 68 d6 11 c0       	mov    %eax,0xc011d668
    }

    shift |= shiftcode[data];
c01014ea:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014ee:	0f b6 80 40 a0 11 c0 	movzbl -0x3fee5fc0(%eax),%eax
c01014f5:	0f b6 d0             	movzbl %al,%edx
c01014f8:	a1 68 d6 11 c0       	mov    0xc011d668,%eax
c01014fd:	09 d0                	or     %edx,%eax
c01014ff:	a3 68 d6 11 c0       	mov    %eax,0xc011d668
    shift ^= togglecode[data];
c0101504:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101508:	0f b6 80 40 a1 11 c0 	movzbl -0x3fee5ec0(%eax),%eax
c010150f:	0f b6 d0             	movzbl %al,%edx
c0101512:	a1 68 d6 11 c0       	mov    0xc011d668,%eax
c0101517:	31 d0                	xor    %edx,%eax
c0101519:	a3 68 d6 11 c0       	mov    %eax,0xc011d668

    c = charcode[shift & (CTL | SHIFT)][data];
c010151e:	a1 68 d6 11 c0       	mov    0xc011d668,%eax
c0101523:	83 e0 03             	and    $0x3,%eax
c0101526:	8b 14 85 40 a5 11 c0 	mov    -0x3fee5ac0(,%eax,4),%edx
c010152d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101531:	01 d0                	add    %edx,%eax
c0101533:	0f b6 00             	movzbl (%eax),%eax
c0101536:	0f b6 c0             	movzbl %al,%eax
c0101539:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c010153c:	a1 68 d6 11 c0       	mov    0xc011d668,%eax
c0101541:	83 e0 08             	and    $0x8,%eax
c0101544:	85 c0                	test   %eax,%eax
c0101546:	74 22                	je     c010156a <kbd_proc_data+0x14a>
        if ('a' <= c && c <= 'z')
c0101548:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c010154c:	7e 0c                	jle    c010155a <kbd_proc_data+0x13a>
c010154e:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101552:	7f 06                	jg     c010155a <kbd_proc_data+0x13a>
            c += 'A' - 'a';
c0101554:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101558:	eb 10                	jmp    c010156a <kbd_proc_data+0x14a>
        else if ('A' <= c && c <= 'Z')
c010155a:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c010155e:	7e 0a                	jle    c010156a <kbd_proc_data+0x14a>
c0101560:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c0101564:	7f 04                	jg     c010156a <kbd_proc_data+0x14a>
            c += 'a' - 'A';
c0101566:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c010156a:	a1 68 d6 11 c0       	mov    0xc011d668,%eax
c010156f:	f7 d0                	not    %eax
c0101571:	83 e0 06             	and    $0x6,%eax
c0101574:	85 c0                	test   %eax,%eax
c0101576:	75 27                	jne    c010159f <kbd_proc_data+0x17f>
c0101578:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c010157f:	75 1e                	jne    c010159f <kbd_proc_data+0x17f>
        cprintf("Rebooting!\n");
c0101581:	c7 04 24 0d 6c 10 c0 	movl   $0xc0106c0d,(%esp)
c0101588:	e8 01 ed ff ff       	call   c010028e <cprintf>
c010158d:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c0101593:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101597:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c010159b:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010159e:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c010159f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01015a2:	c9                   	leave  
c01015a3:	c3                   	ret    

c01015a4 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c01015a4:	55                   	push   %ebp
c01015a5:	89 e5                	mov    %esp,%ebp
c01015a7:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c01015aa:	c7 04 24 20 14 10 c0 	movl   $0xc0101420,(%esp)
c01015b1:	e8 a9 fd ff ff       	call   c010135f <cons_intr>
}
c01015b6:	90                   	nop
c01015b7:	c9                   	leave  
c01015b8:	c3                   	ret    

c01015b9 <kbd_init>:

static void
kbd_init(void) {
c01015b9:	55                   	push   %ebp
c01015ba:	89 e5                	mov    %esp,%ebp
c01015bc:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c01015bf:	e8 e0 ff ff ff       	call   c01015a4 <kbd_intr>
    pic_enable(IRQ_KBD);
c01015c4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01015cb:	e8 35 01 00 00       	call   c0101705 <pic_enable>
}
c01015d0:	90                   	nop
c01015d1:	c9                   	leave  
c01015d2:	c3                   	ret    

c01015d3 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01015d3:	55                   	push   %ebp
c01015d4:	89 e5                	mov    %esp,%ebp
c01015d6:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01015d9:	e8 83 f8 ff ff       	call   c0100e61 <cga_init>
    serial_init();
c01015de:	e8 62 f9 ff ff       	call   c0100f45 <serial_init>
    kbd_init();
c01015e3:	e8 d1 ff ff ff       	call   c01015b9 <kbd_init>
    if (!serial_exists) {
c01015e8:	a1 48 d4 11 c0       	mov    0xc011d448,%eax
c01015ed:	85 c0                	test   %eax,%eax
c01015ef:	75 0c                	jne    c01015fd <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c01015f1:	c7 04 24 19 6c 10 c0 	movl   $0xc0106c19,(%esp)
c01015f8:	e8 91 ec ff ff       	call   c010028e <cprintf>
    }
}
c01015fd:	90                   	nop
c01015fe:	c9                   	leave  
c01015ff:	c3                   	ret    

c0101600 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c0101600:	55                   	push   %ebp
c0101601:	89 e5                	mov    %esp,%ebp
c0101603:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0101606:	e8 cf f7 ff ff       	call   c0100dda <__intr_save>
c010160b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c010160e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101611:	89 04 24             	mov    %eax,(%esp)
c0101614:	e8 89 fa ff ff       	call   c01010a2 <lpt_putc>
        cga_putc(c);
c0101619:	8b 45 08             	mov    0x8(%ebp),%eax
c010161c:	89 04 24             	mov    %eax,(%esp)
c010161f:	e8 be fa ff ff       	call   c01010e2 <cga_putc>
        serial_putc(c);
c0101624:	8b 45 08             	mov    0x8(%ebp),%eax
c0101627:	89 04 24             	mov    %eax,(%esp)
c010162a:	e8 f0 fc ff ff       	call   c010131f <serial_putc>
    }
    local_intr_restore(intr_flag);
c010162f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101632:	89 04 24             	mov    %eax,(%esp)
c0101635:	e8 ca f7 ff ff       	call   c0100e04 <__intr_restore>
}
c010163a:	90                   	nop
c010163b:	c9                   	leave  
c010163c:	c3                   	ret    

c010163d <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c010163d:	55                   	push   %ebp
c010163e:	89 e5                	mov    %esp,%ebp
c0101640:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c0101643:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c010164a:	e8 8b f7 ff ff       	call   c0100dda <__intr_save>
c010164f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101652:	e8 ab fd ff ff       	call   c0101402 <serial_intr>
        kbd_intr();
c0101657:	e8 48 ff ff ff       	call   c01015a4 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c010165c:	8b 15 60 d6 11 c0    	mov    0xc011d660,%edx
c0101662:	a1 64 d6 11 c0       	mov    0xc011d664,%eax
c0101667:	39 c2                	cmp    %eax,%edx
c0101669:	74 31                	je     c010169c <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c010166b:	a1 60 d6 11 c0       	mov    0xc011d660,%eax
c0101670:	8d 50 01             	lea    0x1(%eax),%edx
c0101673:	89 15 60 d6 11 c0    	mov    %edx,0xc011d660
c0101679:	0f b6 80 60 d4 11 c0 	movzbl -0x3fee2ba0(%eax),%eax
c0101680:	0f b6 c0             	movzbl %al,%eax
c0101683:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c0101686:	a1 60 d6 11 c0       	mov    0xc011d660,%eax
c010168b:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101690:	75 0a                	jne    c010169c <cons_getc+0x5f>
                cons.rpos = 0;
c0101692:	c7 05 60 d6 11 c0 00 	movl   $0x0,0xc011d660
c0101699:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c010169c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010169f:	89 04 24             	mov    %eax,(%esp)
c01016a2:	e8 5d f7 ff ff       	call   c0100e04 <__intr_restore>
    return c;
c01016a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01016aa:	c9                   	leave  
c01016ab:	c3                   	ret    

c01016ac <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c01016ac:	55                   	push   %ebp
c01016ad:	89 e5                	mov    %esp,%ebp
c01016af:	83 ec 14             	sub    $0x14,%esp
c01016b2:	8b 45 08             	mov    0x8(%ebp),%eax
c01016b5:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c01016b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01016bc:	66 a3 50 a5 11 c0    	mov    %ax,0xc011a550
    if (did_init) {
c01016c2:	a1 6c d6 11 c0       	mov    0xc011d66c,%eax
c01016c7:	85 c0                	test   %eax,%eax
c01016c9:	74 37                	je     c0101702 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c01016cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01016ce:	0f b6 c0             	movzbl %al,%eax
c01016d1:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
c01016d7:	88 45 f9             	mov    %al,-0x7(%ebp)
c01016da:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01016de:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c01016e2:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c01016e3:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016e7:	c1 e8 08             	shr    $0x8,%eax
c01016ea:	0f b7 c0             	movzwl %ax,%eax
c01016ed:	0f b6 c0             	movzbl %al,%eax
c01016f0:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
c01016f6:	88 45 fd             	mov    %al,-0x3(%ebp)
c01016f9:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c01016fd:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101701:	ee                   	out    %al,(%dx)
    }
}
c0101702:	90                   	nop
c0101703:	c9                   	leave  
c0101704:	c3                   	ret    

c0101705 <pic_enable>:

void
pic_enable(unsigned int irq) {
c0101705:	55                   	push   %ebp
c0101706:	89 e5                	mov    %esp,%ebp
c0101708:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c010170b:	8b 45 08             	mov    0x8(%ebp),%eax
c010170e:	ba 01 00 00 00       	mov    $0x1,%edx
c0101713:	88 c1                	mov    %al,%cl
c0101715:	d3 e2                	shl    %cl,%edx
c0101717:	89 d0                	mov    %edx,%eax
c0101719:	98                   	cwtl   
c010171a:	f7 d0                	not    %eax
c010171c:	0f bf d0             	movswl %ax,%edx
c010171f:	0f b7 05 50 a5 11 c0 	movzwl 0xc011a550,%eax
c0101726:	98                   	cwtl   
c0101727:	21 d0                	and    %edx,%eax
c0101729:	98                   	cwtl   
c010172a:	0f b7 c0             	movzwl %ax,%eax
c010172d:	89 04 24             	mov    %eax,(%esp)
c0101730:	e8 77 ff ff ff       	call   c01016ac <pic_setmask>
}
c0101735:	90                   	nop
c0101736:	c9                   	leave  
c0101737:	c3                   	ret    

c0101738 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101738:	55                   	push   %ebp
c0101739:	89 e5                	mov    %esp,%ebp
c010173b:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c010173e:	c7 05 6c d6 11 c0 01 	movl   $0x1,0xc011d66c
c0101745:	00 00 00 
c0101748:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
c010174e:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
c0101752:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c0101756:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c010175a:	ee                   	out    %al,(%dx)
c010175b:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
c0101761:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
c0101765:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c0101769:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c010176d:	ee                   	out    %al,(%dx)
c010176e:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c0101774:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
c0101778:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c010177c:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0101780:	ee                   	out    %al,(%dx)
c0101781:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
c0101787:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
c010178b:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c010178f:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101793:	ee                   	out    %al,(%dx)
c0101794:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
c010179a:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
c010179e:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c01017a2:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c01017a6:	ee                   	out    %al,(%dx)
c01017a7:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
c01017ad:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
c01017b1:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01017b5:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c01017b9:	ee                   	out    %al,(%dx)
c01017ba:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
c01017c0:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
c01017c4:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01017c8:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01017cc:	ee                   	out    %al,(%dx)
c01017cd:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
c01017d3:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
c01017d7:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01017db:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01017df:	ee                   	out    %al,(%dx)
c01017e0:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
c01017e6:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
c01017ea:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01017ee:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01017f2:	ee                   	out    %al,(%dx)
c01017f3:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
c01017f9:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
c01017fd:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101801:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101805:	ee                   	out    %al,(%dx)
c0101806:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
c010180c:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
c0101810:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101814:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101818:	ee                   	out    %al,(%dx)
c0101819:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c010181f:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
c0101823:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101827:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010182b:	ee                   	out    %al,(%dx)
c010182c:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
c0101832:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
c0101836:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010183a:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c010183e:	ee                   	out    %al,(%dx)
c010183f:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
c0101845:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
c0101849:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c010184d:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101851:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c0101852:	0f b7 05 50 a5 11 c0 	movzwl 0xc011a550,%eax
c0101859:	3d ff ff 00 00       	cmp    $0xffff,%eax
c010185e:	74 0f                	je     c010186f <pic_init+0x137>
        pic_setmask(irq_mask);
c0101860:	0f b7 05 50 a5 11 c0 	movzwl 0xc011a550,%eax
c0101867:	89 04 24             	mov    %eax,(%esp)
c010186a:	e8 3d fe ff ff       	call   c01016ac <pic_setmask>
    }
}
c010186f:	90                   	nop
c0101870:	c9                   	leave  
c0101871:	c3                   	ret    

c0101872 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c0101872:	55                   	push   %ebp
c0101873:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
c0101875:	fb                   	sti    
    sti();
}
c0101876:	90                   	nop
c0101877:	5d                   	pop    %ebp
c0101878:	c3                   	ret    

c0101879 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c0101879:	55                   	push   %ebp
c010187a:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
c010187c:	fa                   	cli    
    cli();
}
c010187d:	90                   	nop
c010187e:	5d                   	pop    %ebp
c010187f:	c3                   	ret    

c0101880 <print_switch_to_user>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100
void print_switch_to_user()
{
c0101880:	55                   	push   %ebp
c0101881:	89 e5                	mov    %esp,%ebp
c0101883:	83 ec 18             	sub    $0x18,%esp
	cprintf("switch to user");
c0101886:	c7 04 24 40 6c 10 c0 	movl   $0xc0106c40,(%esp)
c010188d:	e8 fc e9 ff ff       	call   c010028e <cprintf>
}
c0101892:	90                   	nop
c0101893:	c9                   	leave  
c0101894:	c3                   	ret    

c0101895 <print_switch_to_kernel>:

void print_switch_to_kernel()
{
c0101895:	55                   	push   %ebp
c0101896:	89 e5                	mov    %esp,%ebp
c0101898:	83 ec 18             	sub    $0x18,%esp
	cprintf("switch to kernel\n");
c010189b:	c7 04 24 4f 6c 10 c0 	movl   $0xc0106c4f,(%esp)
c01018a2:	e8 e7 e9 ff ff       	call   c010028e <cprintf>
}
c01018a7:	90                   	nop
c01018a8:	c9                   	leave  
c01018a9:	c3                   	ret    

c01018aa <print_ticks>:

static void print_ticks() {
c01018aa:	55                   	push   %ebp
c01018ab:	89 e5                	mov    %esp,%ebp
c01018ad:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c01018b0:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c01018b7:	00 
c01018b8:	c7 04 24 61 6c 10 c0 	movl   $0xc0106c61,(%esp)
c01018bf:	e8 ca e9 ff ff       	call   c010028e <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
c01018c4:	90                   	nop
c01018c5:	c9                   	leave  
c01018c6:	c3                   	ret    

c01018c7 <idt_init>:

extern uint32_t __vectors[256];

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c01018c7:	55                   	push   %ebp
c01018c8:	89 e5                	mov    %esp,%ebp
c01018ca:	83 ec 10             	sub    $0x10,%esp
      *     Can you see idt[256] in this file? Yes, it's IDT! you can use SETGATE macro to setup each item of IDT
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	int intrno = 0;
c01018cd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	/* ucore don't use task gate.*/
	for(; intrno < 256; intrno++) 
c01018d4:	e9 c4 00 00 00       	jmp    c010199d <idt_init+0xd6>
		SETGATE(idt[intrno], 0, KERNEL_CS, __vectors[intrno], DPL_KERNEL);
c01018d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018dc:	8b 04 85 e0 a5 11 c0 	mov    -0x3fee5a20(,%eax,4),%eax
c01018e3:	0f b7 d0             	movzwl %ax,%edx
c01018e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018e9:	66 89 14 c5 80 d6 11 	mov    %dx,-0x3fee2980(,%eax,8)
c01018f0:	c0 
c01018f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018f4:	66 c7 04 c5 82 d6 11 	movw   $0x8,-0x3fee297e(,%eax,8)
c01018fb:	c0 08 00 
c01018fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101901:	0f b6 14 c5 84 d6 11 	movzbl -0x3fee297c(,%eax,8),%edx
c0101908:	c0 
c0101909:	80 e2 e0             	and    $0xe0,%dl
c010190c:	88 14 c5 84 d6 11 c0 	mov    %dl,-0x3fee297c(,%eax,8)
c0101913:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101916:	0f b6 14 c5 84 d6 11 	movzbl -0x3fee297c(,%eax,8),%edx
c010191d:	c0 
c010191e:	80 e2 1f             	and    $0x1f,%dl
c0101921:	88 14 c5 84 d6 11 c0 	mov    %dl,-0x3fee297c(,%eax,8)
c0101928:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010192b:	0f b6 14 c5 85 d6 11 	movzbl -0x3fee297b(,%eax,8),%edx
c0101932:	c0 
c0101933:	80 e2 f0             	and    $0xf0,%dl
c0101936:	80 ca 0e             	or     $0xe,%dl
c0101939:	88 14 c5 85 d6 11 c0 	mov    %dl,-0x3fee297b(,%eax,8)
c0101940:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101943:	0f b6 14 c5 85 d6 11 	movzbl -0x3fee297b(,%eax,8),%edx
c010194a:	c0 
c010194b:	80 e2 ef             	and    $0xef,%dl
c010194e:	88 14 c5 85 d6 11 c0 	mov    %dl,-0x3fee297b(,%eax,8)
c0101955:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101958:	0f b6 14 c5 85 d6 11 	movzbl -0x3fee297b(,%eax,8),%edx
c010195f:	c0 
c0101960:	80 e2 9f             	and    $0x9f,%dl
c0101963:	88 14 c5 85 d6 11 c0 	mov    %dl,-0x3fee297b(,%eax,8)
c010196a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010196d:	0f b6 14 c5 85 d6 11 	movzbl -0x3fee297b(,%eax,8),%edx
c0101974:	c0 
c0101975:	80 ca 80             	or     $0x80,%dl
c0101978:	88 14 c5 85 d6 11 c0 	mov    %dl,-0x3fee297b(,%eax,8)
c010197f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101982:	8b 04 85 e0 a5 11 c0 	mov    -0x3fee5a20(,%eax,4),%eax
c0101989:	c1 e8 10             	shr    $0x10,%eax
c010198c:	0f b7 d0             	movzwl %ax,%edx
c010198f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101992:	66 89 14 c5 86 d6 11 	mov    %dx,-0x3fee297a(,%eax,8)
c0101999:	c0 
	for(; intrno < 256; intrno++) 
c010199a:	ff 45 fc             	incl   -0x4(%ebp)
c010199d:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c01019a4:	0f 8e 2f ff ff ff    	jle    c01018d9 <idt_init+0x12>

	SETGATE(idt[T_SYSCALL], 1, KERNEL_CS, __vectors[T_SYSCALL], DPL_USER);
c01019aa:	a1 e0 a7 11 c0       	mov    0xc011a7e0,%eax
c01019af:	0f b7 c0             	movzwl %ax,%eax
c01019b2:	66 a3 80 da 11 c0    	mov    %ax,0xc011da80
c01019b8:	66 c7 05 82 da 11 c0 	movw   $0x8,0xc011da82
c01019bf:	08 00 
c01019c1:	0f b6 05 84 da 11 c0 	movzbl 0xc011da84,%eax
c01019c8:	24 e0                	and    $0xe0,%al
c01019ca:	a2 84 da 11 c0       	mov    %al,0xc011da84
c01019cf:	0f b6 05 84 da 11 c0 	movzbl 0xc011da84,%eax
c01019d6:	24 1f                	and    $0x1f,%al
c01019d8:	a2 84 da 11 c0       	mov    %al,0xc011da84
c01019dd:	0f b6 05 85 da 11 c0 	movzbl 0xc011da85,%eax
c01019e4:	0c 0f                	or     $0xf,%al
c01019e6:	a2 85 da 11 c0       	mov    %al,0xc011da85
c01019eb:	0f b6 05 85 da 11 c0 	movzbl 0xc011da85,%eax
c01019f2:	24 ef                	and    $0xef,%al
c01019f4:	a2 85 da 11 c0       	mov    %al,0xc011da85
c01019f9:	0f b6 05 85 da 11 c0 	movzbl 0xc011da85,%eax
c0101a00:	0c 60                	or     $0x60,%al
c0101a02:	a2 85 da 11 c0       	mov    %al,0xc011da85
c0101a07:	0f b6 05 85 da 11 c0 	movzbl 0xc011da85,%eax
c0101a0e:	0c 80                	or     $0x80,%al
c0101a10:	a2 85 da 11 c0       	mov    %al,0xc011da85
c0101a15:	a1 e0 a7 11 c0       	mov    0xc011a7e0,%eax
c0101a1a:	c1 e8 10             	shr    $0x10,%eax
c0101a1d:	0f b7 c0             	movzwl %ax,%eax
c0101a20:	66 a3 86 da 11 c0    	mov    %ax,0xc011da86
	SETGATE(idt[T_SWITCH_TOK], 0, KERNEL_CS, __vectors[T_SWITCH_TOK], DPL_USER);
c0101a26:	a1 c4 a7 11 c0       	mov    0xc011a7c4,%eax
c0101a2b:	0f b7 c0             	movzwl %ax,%eax
c0101a2e:	66 a3 48 da 11 c0    	mov    %ax,0xc011da48
c0101a34:	66 c7 05 4a da 11 c0 	movw   $0x8,0xc011da4a
c0101a3b:	08 00 
c0101a3d:	0f b6 05 4c da 11 c0 	movzbl 0xc011da4c,%eax
c0101a44:	24 e0                	and    $0xe0,%al
c0101a46:	a2 4c da 11 c0       	mov    %al,0xc011da4c
c0101a4b:	0f b6 05 4c da 11 c0 	movzbl 0xc011da4c,%eax
c0101a52:	24 1f                	and    $0x1f,%al
c0101a54:	a2 4c da 11 c0       	mov    %al,0xc011da4c
c0101a59:	0f b6 05 4d da 11 c0 	movzbl 0xc011da4d,%eax
c0101a60:	24 f0                	and    $0xf0,%al
c0101a62:	0c 0e                	or     $0xe,%al
c0101a64:	a2 4d da 11 c0       	mov    %al,0xc011da4d
c0101a69:	0f b6 05 4d da 11 c0 	movzbl 0xc011da4d,%eax
c0101a70:	24 ef                	and    $0xef,%al
c0101a72:	a2 4d da 11 c0       	mov    %al,0xc011da4d
c0101a77:	0f b6 05 4d da 11 c0 	movzbl 0xc011da4d,%eax
c0101a7e:	0c 60                	or     $0x60,%al
c0101a80:	a2 4d da 11 c0       	mov    %al,0xc011da4d
c0101a85:	0f b6 05 4d da 11 c0 	movzbl 0xc011da4d,%eax
c0101a8c:	0c 80                	or     $0x80,%al
c0101a8e:	a2 4d da 11 c0       	mov    %al,0xc011da4d
c0101a93:	a1 c4 a7 11 c0       	mov    0xc011a7c4,%eax
c0101a98:	c1 e8 10             	shr    $0x10,%eax
c0101a9b:	0f b7 c0             	movzwl %ax,%eax
c0101a9e:	66 a3 4e da 11 c0    	mov    %ax,0xc011da4e
	SETGATE(idt[T_SWITCH_TOU], 0, KERNEL_CS, __vectors[T_SWITCH_TOU], DPL_KERNEL);
c0101aa4:	a1 c0 a7 11 c0       	mov    0xc011a7c0,%eax
c0101aa9:	0f b7 c0             	movzwl %ax,%eax
c0101aac:	66 a3 40 da 11 c0    	mov    %ax,0xc011da40
c0101ab2:	66 c7 05 42 da 11 c0 	movw   $0x8,0xc011da42
c0101ab9:	08 00 
c0101abb:	0f b6 05 44 da 11 c0 	movzbl 0xc011da44,%eax
c0101ac2:	24 e0                	and    $0xe0,%al
c0101ac4:	a2 44 da 11 c0       	mov    %al,0xc011da44
c0101ac9:	0f b6 05 44 da 11 c0 	movzbl 0xc011da44,%eax
c0101ad0:	24 1f                	and    $0x1f,%al
c0101ad2:	a2 44 da 11 c0       	mov    %al,0xc011da44
c0101ad7:	0f b6 05 45 da 11 c0 	movzbl 0xc011da45,%eax
c0101ade:	24 f0                	and    $0xf0,%al
c0101ae0:	0c 0e                	or     $0xe,%al
c0101ae2:	a2 45 da 11 c0       	mov    %al,0xc011da45
c0101ae7:	0f b6 05 45 da 11 c0 	movzbl 0xc011da45,%eax
c0101aee:	24 ef                	and    $0xef,%al
c0101af0:	a2 45 da 11 c0       	mov    %al,0xc011da45
c0101af5:	0f b6 05 45 da 11 c0 	movzbl 0xc011da45,%eax
c0101afc:	24 9f                	and    $0x9f,%al
c0101afe:	a2 45 da 11 c0       	mov    %al,0xc011da45
c0101b03:	0f b6 05 45 da 11 c0 	movzbl 0xc011da45,%eax
c0101b0a:	0c 80                	or     $0x80,%al
c0101b0c:	a2 45 da 11 c0       	mov    %al,0xc011da45
c0101b11:	a1 c0 a7 11 c0       	mov    0xc011a7c0,%eax
c0101b16:	c1 e8 10             	shr    $0x10,%eax
c0101b19:	0f b7 c0             	movzwl %ax,%eax
c0101b1c:	66 a3 46 da 11 c0    	mov    %ax,0xc011da46
c0101b22:	c7 45 f8 60 a5 11 c0 	movl   $0xc011a560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0101b29:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101b2c:	0f 01 18             	lidtl  (%eax)

	lidt(&idt_pd);

}
c0101b2f:	90                   	nop
c0101b30:	c9                   	leave  
c0101b31:	c3                   	ret    

c0101b32 <trapname>:

static const char *
trapname(int trapno) {
c0101b32:	55                   	push   %ebp
c0101b33:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0101b35:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b38:	83 f8 13             	cmp    $0x13,%eax
c0101b3b:	77 0c                	ja     c0101b49 <trapname+0x17>
        return excnames[trapno];
c0101b3d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b40:	8b 04 85 e0 6f 10 c0 	mov    -0x3fef9020(,%eax,4),%eax
c0101b47:	eb 18                	jmp    c0101b61 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101b49:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101b4d:	7e 0d                	jle    c0101b5c <trapname+0x2a>
c0101b4f:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101b53:	7f 07                	jg     c0101b5c <trapname+0x2a>
        return "Hardware Interrupt";
c0101b55:	b8 6b 6c 10 c0       	mov    $0xc0106c6b,%eax
c0101b5a:	eb 05                	jmp    c0101b61 <trapname+0x2f>
    }
    return "(unknown trap)";
c0101b5c:	b8 7e 6c 10 c0       	mov    $0xc0106c7e,%eax
}
c0101b61:	5d                   	pop    %ebp
c0101b62:	c3                   	ret    

c0101b63 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0101b63:	55                   	push   %ebp
c0101b64:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101b66:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b69:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101b6d:	83 f8 08             	cmp    $0x8,%eax
c0101b70:	0f 94 c0             	sete   %al
c0101b73:	0f b6 c0             	movzbl %al,%eax
}
c0101b76:	5d                   	pop    %ebp
c0101b77:	c3                   	ret    

c0101b78 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101b78:	55                   	push   %ebp
c0101b79:	89 e5                	mov    %esp,%ebp
c0101b7b:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c0101b7e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b81:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b85:	c7 04 24 bf 6c 10 c0 	movl   $0xc0106cbf,(%esp)
c0101b8c:	e8 fd e6 ff ff       	call   c010028e <cprintf>
    print_regs(&tf->tf_regs);
c0101b91:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b94:	89 04 24             	mov    %eax,(%esp)
c0101b97:	e8 8f 01 00 00       	call   c0101d2b <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101b9c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b9f:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101ba3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ba7:	c7 04 24 d0 6c 10 c0 	movl   $0xc0106cd0,(%esp)
c0101bae:	e8 db e6 ff ff       	call   c010028e <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101bb3:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bb6:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101bba:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bbe:	c7 04 24 e3 6c 10 c0 	movl   $0xc0106ce3,(%esp)
c0101bc5:	e8 c4 e6 ff ff       	call   c010028e <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101bca:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bcd:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101bd1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bd5:	c7 04 24 f6 6c 10 c0 	movl   $0xc0106cf6,(%esp)
c0101bdc:	e8 ad e6 ff ff       	call   c010028e <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101be1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101be4:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101be8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bec:	c7 04 24 09 6d 10 c0 	movl   $0xc0106d09,(%esp)
c0101bf3:	e8 96 e6 ff ff       	call   c010028e <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101bf8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bfb:	8b 40 30             	mov    0x30(%eax),%eax
c0101bfe:	89 04 24             	mov    %eax,(%esp)
c0101c01:	e8 2c ff ff ff       	call   c0101b32 <trapname>
c0101c06:	89 c2                	mov    %eax,%edx
c0101c08:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c0b:	8b 40 30             	mov    0x30(%eax),%eax
c0101c0e:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101c12:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c16:	c7 04 24 1c 6d 10 c0 	movl   $0xc0106d1c,(%esp)
c0101c1d:	e8 6c e6 ff ff       	call   c010028e <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101c22:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c25:	8b 40 34             	mov    0x34(%eax),%eax
c0101c28:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c2c:	c7 04 24 2e 6d 10 c0 	movl   $0xc0106d2e,(%esp)
c0101c33:	e8 56 e6 ff ff       	call   c010028e <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101c38:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c3b:	8b 40 38             	mov    0x38(%eax),%eax
c0101c3e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c42:	c7 04 24 3d 6d 10 c0 	movl   $0xc0106d3d,(%esp)
c0101c49:	e8 40 e6 ff ff       	call   c010028e <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101c4e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c51:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101c55:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c59:	c7 04 24 4c 6d 10 c0 	movl   $0xc0106d4c,(%esp)
c0101c60:	e8 29 e6 ff ff       	call   c010028e <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101c65:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c68:	8b 40 40             	mov    0x40(%eax),%eax
c0101c6b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c6f:	c7 04 24 5f 6d 10 c0 	movl   $0xc0106d5f,(%esp)
c0101c76:	e8 13 e6 ff ff       	call   c010028e <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101c7b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101c82:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101c89:	eb 3d                	jmp    c0101cc8 <print_trapframe+0x150>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101c8b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c8e:	8b 50 40             	mov    0x40(%eax),%edx
c0101c91:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101c94:	21 d0                	and    %edx,%eax
c0101c96:	85 c0                	test   %eax,%eax
c0101c98:	74 28                	je     c0101cc2 <print_trapframe+0x14a>
c0101c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c9d:	8b 04 85 80 a5 11 c0 	mov    -0x3fee5a80(,%eax,4),%eax
c0101ca4:	85 c0                	test   %eax,%eax
c0101ca6:	74 1a                	je     c0101cc2 <print_trapframe+0x14a>
            cprintf("%s,", IA32flags[i]);
c0101ca8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101cab:	8b 04 85 80 a5 11 c0 	mov    -0x3fee5a80(,%eax,4),%eax
c0101cb2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cb6:	c7 04 24 6e 6d 10 c0 	movl   $0xc0106d6e,(%esp)
c0101cbd:	e8 cc e5 ff ff       	call   c010028e <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101cc2:	ff 45 f4             	incl   -0xc(%ebp)
c0101cc5:	d1 65 f0             	shll   -0x10(%ebp)
c0101cc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101ccb:	83 f8 17             	cmp    $0x17,%eax
c0101cce:	76 bb                	jbe    c0101c8b <print_trapframe+0x113>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101cd0:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cd3:	8b 40 40             	mov    0x40(%eax),%eax
c0101cd6:	c1 e8 0c             	shr    $0xc,%eax
c0101cd9:	83 e0 03             	and    $0x3,%eax
c0101cdc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ce0:	c7 04 24 72 6d 10 c0 	movl   $0xc0106d72,(%esp)
c0101ce7:	e8 a2 e5 ff ff       	call   c010028e <cprintf>

    if (!trap_in_kernel(tf)) {
c0101cec:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cef:	89 04 24             	mov    %eax,(%esp)
c0101cf2:	e8 6c fe ff ff       	call   c0101b63 <trap_in_kernel>
c0101cf7:	85 c0                	test   %eax,%eax
c0101cf9:	75 2d                	jne    c0101d28 <print_trapframe+0x1b0>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101cfb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cfe:	8b 40 44             	mov    0x44(%eax),%eax
c0101d01:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d05:	c7 04 24 7b 6d 10 c0 	movl   $0xc0106d7b,(%esp)
c0101d0c:	e8 7d e5 ff ff       	call   c010028e <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101d11:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d14:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101d18:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d1c:	c7 04 24 8a 6d 10 c0 	movl   $0xc0106d8a,(%esp)
c0101d23:	e8 66 e5 ff ff       	call   c010028e <cprintf>
    }
}
c0101d28:	90                   	nop
c0101d29:	c9                   	leave  
c0101d2a:	c3                   	ret    

c0101d2b <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101d2b:	55                   	push   %ebp
c0101d2c:	89 e5                	mov    %esp,%ebp
c0101d2e:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101d31:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d34:	8b 00                	mov    (%eax),%eax
c0101d36:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d3a:	c7 04 24 9d 6d 10 c0 	movl   $0xc0106d9d,(%esp)
c0101d41:	e8 48 e5 ff ff       	call   c010028e <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101d46:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d49:	8b 40 04             	mov    0x4(%eax),%eax
c0101d4c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d50:	c7 04 24 ac 6d 10 c0 	movl   $0xc0106dac,(%esp)
c0101d57:	e8 32 e5 ff ff       	call   c010028e <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101d5c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d5f:	8b 40 08             	mov    0x8(%eax),%eax
c0101d62:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d66:	c7 04 24 bb 6d 10 c0 	movl   $0xc0106dbb,(%esp)
c0101d6d:	e8 1c e5 ff ff       	call   c010028e <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101d72:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d75:	8b 40 0c             	mov    0xc(%eax),%eax
c0101d78:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d7c:	c7 04 24 ca 6d 10 c0 	movl   $0xc0106dca,(%esp)
c0101d83:	e8 06 e5 ff ff       	call   c010028e <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101d88:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d8b:	8b 40 10             	mov    0x10(%eax),%eax
c0101d8e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d92:	c7 04 24 d9 6d 10 c0 	movl   $0xc0106dd9,(%esp)
c0101d99:	e8 f0 e4 ff ff       	call   c010028e <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101d9e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101da1:	8b 40 14             	mov    0x14(%eax),%eax
c0101da4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101da8:	c7 04 24 e8 6d 10 c0 	movl   $0xc0106de8,(%esp)
c0101daf:	e8 da e4 ff ff       	call   c010028e <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101db4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101db7:	8b 40 18             	mov    0x18(%eax),%eax
c0101dba:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101dbe:	c7 04 24 f7 6d 10 c0 	movl   $0xc0106df7,(%esp)
c0101dc5:	e8 c4 e4 ff ff       	call   c010028e <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101dca:	8b 45 08             	mov    0x8(%ebp),%eax
c0101dcd:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101dd0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101dd4:	c7 04 24 06 6e 10 c0 	movl   $0xc0106e06,(%esp)
c0101ddb:	e8 ae e4 ff ff       	call   c010028e <cprintf>
}
c0101de0:	90                   	nop
c0101de1:	c9                   	leave  
c0101de2:	c3                   	ret    

c0101de3 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101de3:	55                   	push   %ebp
c0101de4:	89 e5                	mov    %esp,%ebp
c0101de6:	57                   	push   %edi
c0101de7:	56                   	push   %esi
c0101de8:	53                   	push   %ebx
c0101de9:	83 ec 2c             	sub    $0x2c,%esp
    char c;
	static struct trapframe *correct_tf;
	correct_tf = (struct trapframe *) ((uint32_t)(tf) - 8);
c0101dec:	8b 45 08             	mov    0x8(%ebp),%eax
c0101def:	83 e8 08             	sub    $0x8,%eax
c0101df2:	a3 80 de 11 c0       	mov    %eax,0xc011de80

    switch (tf->tf_trapno) {
c0101df7:	8b 45 08             	mov    0x8(%ebp),%eax
c0101dfa:	8b 40 30             	mov    0x30(%eax),%eax
c0101dfd:	83 f8 24             	cmp    $0x24,%eax
c0101e00:	0f 84 96 00 00 00    	je     c0101e9c <trap_dispatch+0xb9>
c0101e06:	83 f8 24             	cmp    $0x24,%eax
c0101e09:	77 1c                	ja     c0101e27 <trap_dispatch+0x44>
c0101e0b:	83 f8 20             	cmp    $0x20,%eax
c0101e0e:	74 44                	je     c0101e54 <trap_dispatch+0x71>
c0101e10:	83 f8 21             	cmp    $0x21,%eax
c0101e13:	0f 84 ac 00 00 00    	je     c0101ec5 <trap_dispatch+0xe2>
c0101e19:	83 f8 0d             	cmp    $0xd,%eax
c0101e1c:	0f 84 aa 03 00 00    	je     c01021cc <loop+0x16e>
c0101e22:	e9 be 03 00 00       	jmp    c01021e5 <loop+0x187>
c0101e27:	83 f8 78             	cmp    $0x78,%eax
c0101e2a:	0f 84 a8 02 00 00    	je     c01020d8 <loop+0x7a>
c0101e30:	83 f8 78             	cmp    $0x78,%eax
c0101e33:	77 11                	ja     c0101e46 <trap_dispatch+0x63>
c0101e35:	83 e8 2e             	sub    $0x2e,%eax
c0101e38:	83 f8 01             	cmp    $0x1,%eax
c0101e3b:	0f 87 a4 03 00 00    	ja     c01021e5 <loop+0x187>
		}
			break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0101e41:	e9 f7 03 00 00       	jmp    c010223d <loop+0x1df>
    switch (tf->tf_trapno) {
c0101e46:	83 f8 79             	cmp    $0x79,%eax
c0101e49:	0f 84 0c 03 00 00    	je     c010215b <loop+0xfd>
c0101e4f:	e9 91 03 00 00       	jmp    c01021e5 <loop+0x187>
		ticks = (ticks + 1) % 100;
c0101e54:	a1 2c df 11 c0       	mov    0xc011df2c,%eax
c0101e59:	8d 48 01             	lea    0x1(%eax),%ecx
c0101e5c:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0101e61:	89 c8                	mov    %ecx,%eax
c0101e63:	f7 e2                	mul    %edx
c0101e65:	c1 ea 05             	shr    $0x5,%edx
c0101e68:	89 d0                	mov    %edx,%eax
c0101e6a:	c1 e0 02             	shl    $0x2,%eax
c0101e6d:	01 d0                	add    %edx,%eax
c0101e6f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0101e76:	01 d0                	add    %edx,%eax
c0101e78:	c1 e0 02             	shl    $0x2,%eax
c0101e7b:	29 c1                	sub    %eax,%ecx
c0101e7d:	89 ca                	mov    %ecx,%edx
c0101e7f:	89 15 2c df 11 c0    	mov    %edx,0xc011df2c
		if (ticks == 0)
c0101e85:	a1 2c df 11 c0       	mov    0xc011df2c,%eax
c0101e8a:	85 c0                	test   %eax,%eax
c0101e8c:	0f 85 a4 03 00 00    	jne    c0102236 <loop+0x1d8>
			print_ticks();
c0101e92:	e8 13 fa ff ff       	call   c01018aa <print_ticks>
        break;
c0101e97:	e9 9a 03 00 00       	jmp    c0102236 <loop+0x1d8>
        c = cons_getc();
c0101e9c:	e8 9c f7 ff ff       	call   c010163d <cons_getc>
c0101ea1:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101ea4:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
c0101ea8:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
c0101eac:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101eb0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101eb4:	c7 04 24 15 6e 10 c0 	movl   $0xc0106e15,(%esp)
c0101ebb:	e8 ce e3 ff ff       	call   c010028e <cprintf>
        break;
c0101ec0:	e9 78 03 00 00       	jmp    c010223d <loop+0x1df>
        c = cons_getc();
c0101ec5:	e8 73 f7 ff ff       	call   c010163d <cons_getc>
c0101eca:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101ecd:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
c0101ed1:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
c0101ed5:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101ed9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101edd:	c7 04 24 27 6e 10 c0 	movl   $0xc0106e27,(%esp)
c0101ee4:	e8 a5 e3 ff ff       	call   c010028e <cprintf>
		switch (c) {
c0101ee9:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
c0101eed:	83 f8 30             	cmp    $0x30,%eax
c0101ef0:	74 0e                	je     c0101f00 <trap_dispatch+0x11d>
c0101ef2:	83 f8 33             	cmp    $0x33,%eax
c0101ef5:	0f 84 29 01 00 00    	je     c0102024 <trap_dispatch+0x241>
        break;
c0101efb:	e9 3d 03 00 00       	jmp    c010223d <loop+0x1df>
				if (!trap_in_kernel(tf)) {
c0101f00:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f03:	89 04 24             	mov    %eax,(%esp)
c0101f06:	e8 58 fc ff ff       	call   c0101b63 <trap_in_kernel>
c0101f0b:	85 c0                	test   %eax,%eax
c0101f0d:	0f 85 b9 01 00 00    	jne    c01020cc <loop+0x6e>
					tf->tf_cs = KERNEL_CS;
c0101f13:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f16:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
					tf->tf_ds = tf->tf_es = tf->tf_gs = tf->tf_fs = KERNEL_DS;
c0101f1c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f1f:	66 c7 40 24 10 00    	movw   $0x10,0x24(%eax)
c0101f25:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f28:	0f b7 50 24          	movzwl 0x24(%eax),%edx
c0101f2c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f2f:	66 89 50 20          	mov    %dx,0x20(%eax)
c0101f33:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f36:	0f b7 50 20          	movzwl 0x20(%eax),%edx
c0101f3a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f3d:	66 89 50 28          	mov    %dx,0x28(%eax)
c0101f41:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f44:	0f b7 50 28          	movzwl 0x28(%eax),%edx
c0101f48:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f4b:	66 89 50 2c          	mov    %dx,0x2c(%eax)
					tf->tf_eflags &= ~FL_IOPL_MASK;
c0101f4f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f52:	8b 40 40             	mov    0x40(%eax),%eax
c0101f55:	25 ff cf ff ff       	and    $0xffffcfff,%eax
c0101f5a:	89 c2                	mov    %eax,%edx
c0101f5c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f5f:	89 50 40             	mov    %edx,0x40(%eax)
					uintptr_t user_stack_ptr = (uintptr_t)tf->tf_esp;
c0101f62:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f65:	8b 40 44             	mov    0x44(%eax),%eax
c0101f68:	89 45 e0             	mov    %eax,-0x20(%ebp)
					tf->tf_esp = *((uint32_t *) user_stack_ptr);
c0101f6b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0101f6e:	8b 10                	mov    (%eax),%edx
c0101f70:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f73:	89 50 44             	mov    %edx,0x44(%eax)
					tf->tf_ss = *((uint16_t *) (user_stack_ptr + 4));
c0101f76:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0101f79:	83 c0 04             	add    $0x4,%eax
c0101f7c:	0f b7 10             	movzwl (%eax),%edx
c0101f7f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f82:	66 89 50 48          	mov    %dx,0x48(%eax)
					tf->tf_padding0 = *((uint16_t *) (user_stack_ptr + 6));
c0101f86:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0101f89:	83 c0 06             	add    $0x6,%eax
c0101f8c:	0f b7 10             	movzwl (%eax),%edx
c0101f8f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f92:	66 89 50 22          	mov    %dx,0x22(%eax)
					user_stack_ptr -= (uintptr_t) (sizeof(struct trapframe) - 8);
c0101f96:	83 6d e0 44          	subl   $0x44,-0x20(%ebp)
					*((struct trapframe *) user_stack_ptr) = *tf;
c0101f9a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0101f9d:	8b 55 08             	mov    0x8(%ebp),%edx
c0101fa0:	bb 4c 00 00 00       	mov    $0x4c,%ebx
c0101fa5:	89 c1                	mov    %eax,%ecx
c0101fa7:	83 e1 01             	and    $0x1,%ecx
c0101faa:	85 c9                	test   %ecx,%ecx
c0101fac:	74 0c                	je     c0101fba <trap_dispatch+0x1d7>
c0101fae:	0f b6 0a             	movzbl (%edx),%ecx
c0101fb1:	88 08                	mov    %cl,(%eax)
c0101fb3:	8d 40 01             	lea    0x1(%eax),%eax
c0101fb6:	8d 52 01             	lea    0x1(%edx),%edx
c0101fb9:	4b                   	dec    %ebx
c0101fba:	89 c1                	mov    %eax,%ecx
c0101fbc:	83 e1 02             	and    $0x2,%ecx
c0101fbf:	85 c9                	test   %ecx,%ecx
c0101fc1:	74 0f                	je     c0101fd2 <trap_dispatch+0x1ef>
c0101fc3:	0f b7 0a             	movzwl (%edx),%ecx
c0101fc6:	66 89 08             	mov    %cx,(%eax)
c0101fc9:	8d 40 02             	lea    0x2(%eax),%eax
c0101fcc:	8d 52 02             	lea    0x2(%edx),%edx
c0101fcf:	83 eb 02             	sub    $0x2,%ebx
c0101fd2:	89 df                	mov    %ebx,%edi
c0101fd4:	83 e7 fc             	and    $0xfffffffc,%edi
c0101fd7:	b9 00 00 00 00       	mov    $0x0,%ecx
c0101fdc:	8b 34 0a             	mov    (%edx,%ecx,1),%esi
c0101fdf:	89 34 08             	mov    %esi,(%eax,%ecx,1)
c0101fe2:	83 c1 04             	add    $0x4,%ecx
c0101fe5:	39 f9                	cmp    %edi,%ecx
c0101fe7:	72 f3                	jb     c0101fdc <trap_dispatch+0x1f9>
c0101fe9:	01 c8                	add    %ecx,%eax
c0101feb:	01 ca                	add    %ecx,%edx
c0101fed:	b9 00 00 00 00       	mov    $0x0,%ecx
c0101ff2:	89 de                	mov    %ebx,%esi
c0101ff4:	83 e6 02             	and    $0x2,%esi
c0101ff7:	85 f6                	test   %esi,%esi
c0101ff9:	74 0b                	je     c0102006 <trap_dispatch+0x223>
c0101ffb:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
c0101fff:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
c0102003:	83 c1 02             	add    $0x2,%ecx
c0102006:	83 e3 01             	and    $0x1,%ebx
c0102009:	85 db                	test   %ebx,%ebx
c010200b:	74 07                	je     c0102014 <trap_dispatch+0x231>
c010200d:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
c0102011:	88 14 08             	mov    %dl,(%eax,%ecx,1)
						:"a" ((uint32_t) tf),
c0102014:	8b 45 08             	mov    0x8(%ebp),%eax
					__asm__ __volatile__ (
c0102017:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010201a:	89 d3                	mov    %edx,%ebx
c010201c:	89 58 fc             	mov    %ebx,-0x4(%eax)
				break;
c010201f:	e9 a8 00 00 00       	jmp    c01020cc <loop+0x6e>
				if (trap_in_kernel(tf)) {
c0102024:	8b 45 08             	mov    0x8(%ebp),%eax
c0102027:	89 04 24             	mov    %eax,(%esp)
c010202a:	e8 34 fb ff ff       	call   c0101b63 <trap_in_kernel>
c010202f:	85 c0                	test   %eax,%eax
c0102031:	0f 84 9b 00 00 00    	je     c01020d2 <loop+0x74>
						:"a" ((uint32_t)(&tf->tf_esp)),
c0102037:	8b 45 08             	mov    0x8(%ebp),%eax
c010203a:	83 c0 44             	add    $0x44,%eax
						 "d" ((uint32_t)(tf)),
c010203d:	8b 55 08             	mov    0x8(%ebp),%edx
					__asm__ __volatile__ (
c0102040:	56                   	push   %esi
c0102041:	57                   	push   %edi
c0102042:	53                   	push   %ebx
c0102043:	83 6a fc 08          	subl   $0x8,-0x4(%edx)
c0102047:	89 e6                	mov    %esp,%esi
c0102049:	89 c1                	mov    %eax,%ecx
c010204b:	29 f1                	sub    %esi,%ecx
c010204d:	41                   	inc    %ecx
c010204e:	89 e7                	mov    %esp,%edi
c0102050:	83 ef 08             	sub    $0x8,%edi
c0102053:	fc                   	cld    
c0102054:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0102056:	83 ec 08             	sub    $0x8,%esp
c0102059:	83 ed 08             	sub    $0x8,%ebp
c010205c:	89 eb                	mov    %ebp,%ebx

c010205e <loop>:
c010205e:	83 2b 08             	subl   $0x8,(%ebx)
c0102061:	8b 1b                	mov    (%ebx),%ebx
c0102063:	39 d8                	cmp    %ebx,%eax
c0102065:	7f f7                	jg     c010205e <loop>
c0102067:	89 40 f8             	mov    %eax,-0x8(%eax)
c010206a:	c7 40 fc 23 00 00 00 	movl   $0x23,-0x4(%eax)
c0102071:	5b                   	pop    %ebx
c0102072:	5f                   	pop    %edi
c0102073:	5e                   	pop    %esi
					correct_tf->tf_cs = USER_CS;
c0102074:	a1 80 de 11 c0       	mov    0xc011de80,%eax
c0102079:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
					correct_tf->tf_ds = tf->tf_es = tf->tf_gs = tf->tf_fs = USER_DS;
c010207f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102082:	66 c7 40 24 23 00    	movw   $0x23,0x24(%eax)
c0102088:	8b 45 08             	mov    0x8(%ebp),%eax
c010208b:	0f b7 50 24          	movzwl 0x24(%eax),%edx
c010208f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102092:	66 89 50 20          	mov    %dx,0x20(%eax)
c0102096:	8b 45 08             	mov    0x8(%ebp),%eax
c0102099:	0f b7 50 20          	movzwl 0x20(%eax),%edx
c010209d:	8b 45 08             	mov    0x8(%ebp),%eax
c01020a0:	66 89 50 28          	mov    %dx,0x28(%eax)
c01020a4:	a1 80 de 11 c0       	mov    0xc011de80,%eax
c01020a9:	8b 55 08             	mov    0x8(%ebp),%edx
c01020ac:	0f b7 52 28          	movzwl 0x28(%edx),%edx
c01020b0:	66 89 50 2c          	mov    %dx,0x2c(%eax)
					correct_tf->tf_eflags |= FL_IOPL_MASK;
c01020b4:	a1 80 de 11 c0       	mov    0xc011de80,%eax
c01020b9:	8b 50 40             	mov    0x40(%eax),%edx
c01020bc:	a1 80 de 11 c0       	mov    0xc011de80,%eax
c01020c1:	81 ca 00 30 00 00    	or     $0x3000,%edx
c01020c7:	89 50 40             	mov    %edx,0x40(%eax)
				break;
c01020ca:	eb 06                	jmp    c01020d2 <loop+0x74>
				break;
c01020cc:	90                   	nop
c01020cd:	e9 6b 01 00 00       	jmp    c010223d <loop+0x1df>
				break;
c01020d2:	90                   	nop
        break;
c01020d3:	e9 65 01 00 00       	jmp    c010223d <loop+0x1df>
		if ((tf->tf_cs & 3) == 0) {
c01020d8:	8b 45 08             	mov    0x8(%ebp),%eax
c01020db:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01020df:	83 e0 03             	and    $0x3,%eax
c01020e2:	85 c0                	test   %eax,%eax
c01020e4:	0f 85 4f 01 00 00    	jne    c0102239 <loop+0x1db>
			tf->tf_cs = USER_CS;
c01020ea:	8b 45 08             	mov    0x8(%ebp),%eax
c01020ed:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
			tf->tf_ss = tf->tf_ds = tf->tf_es = tf->tf_gs = tf->tf_fs = USER_DS;
c01020f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01020f6:	66 c7 40 24 23 00    	movw   $0x23,0x24(%eax)
c01020fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01020ff:	0f b7 50 24          	movzwl 0x24(%eax),%edx
c0102103:	8b 45 08             	mov    0x8(%ebp),%eax
c0102106:	66 89 50 20          	mov    %dx,0x20(%eax)
c010210a:	8b 45 08             	mov    0x8(%ebp),%eax
c010210d:	0f b7 50 20          	movzwl 0x20(%eax),%edx
c0102111:	8b 45 08             	mov    0x8(%ebp),%eax
c0102114:	66 89 50 28          	mov    %dx,0x28(%eax)
c0102118:	8b 45 08             	mov    0x8(%ebp),%eax
c010211b:	0f b7 50 28          	movzwl 0x28(%eax),%edx
c010211f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102122:	66 89 50 2c          	mov    %dx,0x2c(%eax)
c0102126:	8b 45 08             	mov    0x8(%ebp),%eax
c0102129:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
c010212d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102130:	66 89 50 48          	mov    %dx,0x48(%eax)
			tf->tf_esp += 4;
c0102134:	8b 45 08             	mov    0x8(%ebp),%eax
c0102137:	8b 40 44             	mov    0x44(%eax),%eax
c010213a:	8d 50 04             	lea    0x4(%eax),%edx
c010213d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102140:	89 50 44             	mov    %edx,0x44(%eax)
			tf->tf_eflags |= FL_IOPL_MASK;
c0102143:	8b 45 08             	mov    0x8(%ebp),%eax
c0102146:	8b 40 40             	mov    0x40(%eax),%eax
c0102149:	0d 00 30 00 00       	or     $0x3000,%eax
c010214e:	89 c2                	mov    %eax,%edx
c0102150:	8b 45 08             	mov    0x8(%ebp),%eax
c0102153:	89 50 40             	mov    %edx,0x40(%eax)
		break;
c0102156:	e9 de 00 00 00       	jmp    c0102239 <loop+0x1db>
		if ((tf->tf_cs & 3) != 0) {
c010215b:	8b 45 08             	mov    0x8(%ebp),%eax
c010215e:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0102162:	83 e0 03             	and    $0x3,%eax
c0102165:	85 c0                	test   %eax,%eax
c0102167:	0f 84 cf 00 00 00    	je     c010223c <loop+0x1de>
			tf->tf_cs = KERNEL_CS;
c010216d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102170:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
			tf->tf_ss = tf->tf_ds = tf->tf_es = tf->tf_gs = tf->tf_fs = KERNEL_DS;
c0102176:	8b 45 08             	mov    0x8(%ebp),%eax
c0102179:	66 c7 40 24 10 00    	movw   $0x10,0x24(%eax)
c010217f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102182:	0f b7 50 24          	movzwl 0x24(%eax),%edx
c0102186:	8b 45 08             	mov    0x8(%ebp),%eax
c0102189:	66 89 50 20          	mov    %dx,0x20(%eax)
c010218d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102190:	0f b7 50 20          	movzwl 0x20(%eax),%edx
c0102194:	8b 45 08             	mov    0x8(%ebp),%eax
c0102197:	66 89 50 28          	mov    %dx,0x28(%eax)
c010219b:	8b 45 08             	mov    0x8(%ebp),%eax
c010219e:	0f b7 50 28          	movzwl 0x28(%eax),%edx
c01021a2:	8b 45 08             	mov    0x8(%ebp),%eax
c01021a5:	66 89 50 2c          	mov    %dx,0x2c(%eax)
c01021a9:	8b 45 08             	mov    0x8(%ebp),%eax
c01021ac:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
c01021b0:	8b 45 08             	mov    0x8(%ebp),%eax
c01021b3:	66 89 50 48          	mov    %dx,0x48(%eax)
			tf->tf_eflags &= ~FL_IOPL_MASK;
c01021b7:	8b 45 08             	mov    0x8(%ebp),%eax
c01021ba:	8b 40 40             	mov    0x40(%eax),%eax
c01021bd:	25 ff cf ff ff       	and    $0xffffcfff,%eax
c01021c2:	89 c2                	mov    %eax,%edx
c01021c4:	8b 45 08             	mov    0x8(%ebp),%eax
c01021c7:	89 50 40             	mov    %edx,0x40(%eax)
			break;
c01021ca:	eb 70                	jmp    c010223c <loop+0x1de>
	case T_GPFLT:
		cprintf("GP Fault!!!\n");
c01021cc:	c7 04 24 36 6e 10 c0 	movl   $0xc0106e36,(%esp)
c01021d3:	e8 b6 e0 ff ff       	call   c010028e <cprintf>
		print_trapframe(tf);
c01021d8:	8b 45 08             	mov    0x8(%ebp),%eax
c01021db:	89 04 24             	mov    %eax,(%esp)
c01021de:	e8 95 f9 ff ff       	call   c0101b78 <print_trapframe>
		break;
c01021e3:	eb 58                	jmp    c010223d <loop+0x1df>
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c01021e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01021e8:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01021ec:	83 e0 03             	and    $0x3,%eax
c01021ef:	85 c0                	test   %eax,%eax
c01021f1:	75 27                	jne    c010221a <loop+0x1bc>
            print_trapframe(tf);
c01021f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01021f6:	89 04 24             	mov    %eax,(%esp)
c01021f9:	e8 7a f9 ff ff       	call   c0101b78 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c01021fe:	c7 44 24 08 43 6e 10 	movl   $0xc0106e43,0x8(%esp)
c0102205:	c0 
c0102206:	c7 44 24 04 36 01 00 	movl   $0x136,0x4(%esp)
c010220d:	00 
c010220e:	c7 04 24 5f 6e 10 c0 	movl   $0xc0106e5f,(%esp)
c0102215:	e8 cc e1 ff ff       	call   c01003e6 <__panic>
        }
		else 
			panic("unexpected trap \n");
c010221a:	c7 44 24 08 70 6e 10 	movl   $0xc0106e70,0x8(%esp)
c0102221:	c0 
c0102222:	c7 44 24 04 39 01 00 	movl   $0x139,0x4(%esp)
c0102229:	00 
c010222a:	c7 04 24 5f 6e 10 c0 	movl   $0xc0106e5f,(%esp)
c0102231:	e8 b0 e1 ff ff       	call   c01003e6 <__panic>
        break;
c0102236:	90                   	nop
c0102237:	eb 04                	jmp    c010223d <loop+0x1df>
		break;
c0102239:	90                   	nop
c010223a:	eb 01                	jmp    c010223d <loop+0x1df>
			break;
c010223c:	90                   	nop
    }
}
c010223d:	90                   	nop
c010223e:	83 c4 2c             	add    $0x2c,%esp
c0102241:	5b                   	pop    %ebx
c0102242:	5e                   	pop    %esi
c0102243:	5f                   	pop    %edi
c0102244:	5d                   	pop    %ebp
c0102245:	c3                   	ret    

c0102246 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0102246:	55                   	push   %ebp
c0102247:	89 e5                	mov    %esp,%ebp
c0102249:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c010224c:	8b 45 08             	mov    0x8(%ebp),%eax
c010224f:	89 04 24             	mov    %eax,(%esp)
c0102252:	e8 8c fb ff ff       	call   c0101de3 <trap_dispatch>
}
c0102257:	90                   	nop
c0102258:	c9                   	leave  
c0102259:	c3                   	ret    

c010225a <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c010225a:	6a 00                	push   $0x0
  pushl $0
c010225c:	6a 00                	push   $0x0
  jmp __alltraps
c010225e:	e9 69 0a 00 00       	jmp    c0102ccc <__alltraps>

c0102263 <vector1>:
.globl vector1
vector1:
  pushl $0
c0102263:	6a 00                	push   $0x0
  pushl $1
c0102265:	6a 01                	push   $0x1
  jmp __alltraps
c0102267:	e9 60 0a 00 00       	jmp    c0102ccc <__alltraps>

c010226c <vector2>:
.globl vector2
vector2:
  pushl $0
c010226c:	6a 00                	push   $0x0
  pushl $2
c010226e:	6a 02                	push   $0x2
  jmp __alltraps
c0102270:	e9 57 0a 00 00       	jmp    c0102ccc <__alltraps>

c0102275 <vector3>:
.globl vector3
vector3:
  pushl $0
c0102275:	6a 00                	push   $0x0
  pushl $3
c0102277:	6a 03                	push   $0x3
  jmp __alltraps
c0102279:	e9 4e 0a 00 00       	jmp    c0102ccc <__alltraps>

c010227e <vector4>:
.globl vector4
vector4:
  pushl $0
c010227e:	6a 00                	push   $0x0
  pushl $4
c0102280:	6a 04                	push   $0x4
  jmp __alltraps
c0102282:	e9 45 0a 00 00       	jmp    c0102ccc <__alltraps>

c0102287 <vector5>:
.globl vector5
vector5:
  pushl $0
c0102287:	6a 00                	push   $0x0
  pushl $5
c0102289:	6a 05                	push   $0x5
  jmp __alltraps
c010228b:	e9 3c 0a 00 00       	jmp    c0102ccc <__alltraps>

c0102290 <vector6>:
.globl vector6
vector6:
  pushl $0
c0102290:	6a 00                	push   $0x0
  pushl $6
c0102292:	6a 06                	push   $0x6
  jmp __alltraps
c0102294:	e9 33 0a 00 00       	jmp    c0102ccc <__alltraps>

c0102299 <vector7>:
.globl vector7
vector7:
  pushl $0
c0102299:	6a 00                	push   $0x0
  pushl $7
c010229b:	6a 07                	push   $0x7
  jmp __alltraps
c010229d:	e9 2a 0a 00 00       	jmp    c0102ccc <__alltraps>

c01022a2 <vector8>:
.globl vector8
vector8:
  pushl $8
c01022a2:	6a 08                	push   $0x8
  jmp __alltraps
c01022a4:	e9 23 0a 00 00       	jmp    c0102ccc <__alltraps>

c01022a9 <vector9>:
.globl vector9
vector9:
  pushl $0
c01022a9:	6a 00                	push   $0x0
  pushl $9
c01022ab:	6a 09                	push   $0x9
  jmp __alltraps
c01022ad:	e9 1a 0a 00 00       	jmp    c0102ccc <__alltraps>

c01022b2 <vector10>:
.globl vector10
vector10:
  pushl $10
c01022b2:	6a 0a                	push   $0xa
  jmp __alltraps
c01022b4:	e9 13 0a 00 00       	jmp    c0102ccc <__alltraps>

c01022b9 <vector11>:
.globl vector11
vector11:
  pushl $11
c01022b9:	6a 0b                	push   $0xb
  jmp __alltraps
c01022bb:	e9 0c 0a 00 00       	jmp    c0102ccc <__alltraps>

c01022c0 <vector12>:
.globl vector12
vector12:
  pushl $12
c01022c0:	6a 0c                	push   $0xc
  jmp __alltraps
c01022c2:	e9 05 0a 00 00       	jmp    c0102ccc <__alltraps>

c01022c7 <vector13>:
.globl vector13
vector13:
  pushl $13
c01022c7:	6a 0d                	push   $0xd
  jmp __alltraps
c01022c9:	e9 fe 09 00 00       	jmp    c0102ccc <__alltraps>

c01022ce <vector14>:
.globl vector14
vector14:
  pushl $14
c01022ce:	6a 0e                	push   $0xe
  jmp __alltraps
c01022d0:	e9 f7 09 00 00       	jmp    c0102ccc <__alltraps>

c01022d5 <vector15>:
.globl vector15
vector15:
  pushl $0
c01022d5:	6a 00                	push   $0x0
  pushl $15
c01022d7:	6a 0f                	push   $0xf
  jmp __alltraps
c01022d9:	e9 ee 09 00 00       	jmp    c0102ccc <__alltraps>

c01022de <vector16>:
.globl vector16
vector16:
  pushl $0
c01022de:	6a 00                	push   $0x0
  pushl $16
c01022e0:	6a 10                	push   $0x10
  jmp __alltraps
c01022e2:	e9 e5 09 00 00       	jmp    c0102ccc <__alltraps>

c01022e7 <vector17>:
.globl vector17
vector17:
  pushl $17
c01022e7:	6a 11                	push   $0x11
  jmp __alltraps
c01022e9:	e9 de 09 00 00       	jmp    c0102ccc <__alltraps>

c01022ee <vector18>:
.globl vector18
vector18:
  pushl $0
c01022ee:	6a 00                	push   $0x0
  pushl $18
c01022f0:	6a 12                	push   $0x12
  jmp __alltraps
c01022f2:	e9 d5 09 00 00       	jmp    c0102ccc <__alltraps>

c01022f7 <vector19>:
.globl vector19
vector19:
  pushl $0
c01022f7:	6a 00                	push   $0x0
  pushl $19
c01022f9:	6a 13                	push   $0x13
  jmp __alltraps
c01022fb:	e9 cc 09 00 00       	jmp    c0102ccc <__alltraps>

c0102300 <vector20>:
.globl vector20
vector20:
  pushl $0
c0102300:	6a 00                	push   $0x0
  pushl $20
c0102302:	6a 14                	push   $0x14
  jmp __alltraps
c0102304:	e9 c3 09 00 00       	jmp    c0102ccc <__alltraps>

c0102309 <vector21>:
.globl vector21
vector21:
  pushl $0
c0102309:	6a 00                	push   $0x0
  pushl $21
c010230b:	6a 15                	push   $0x15
  jmp __alltraps
c010230d:	e9 ba 09 00 00       	jmp    c0102ccc <__alltraps>

c0102312 <vector22>:
.globl vector22
vector22:
  pushl $0
c0102312:	6a 00                	push   $0x0
  pushl $22
c0102314:	6a 16                	push   $0x16
  jmp __alltraps
c0102316:	e9 b1 09 00 00       	jmp    c0102ccc <__alltraps>

c010231b <vector23>:
.globl vector23
vector23:
  pushl $0
c010231b:	6a 00                	push   $0x0
  pushl $23
c010231d:	6a 17                	push   $0x17
  jmp __alltraps
c010231f:	e9 a8 09 00 00       	jmp    c0102ccc <__alltraps>

c0102324 <vector24>:
.globl vector24
vector24:
  pushl $0
c0102324:	6a 00                	push   $0x0
  pushl $24
c0102326:	6a 18                	push   $0x18
  jmp __alltraps
c0102328:	e9 9f 09 00 00       	jmp    c0102ccc <__alltraps>

c010232d <vector25>:
.globl vector25
vector25:
  pushl $0
c010232d:	6a 00                	push   $0x0
  pushl $25
c010232f:	6a 19                	push   $0x19
  jmp __alltraps
c0102331:	e9 96 09 00 00       	jmp    c0102ccc <__alltraps>

c0102336 <vector26>:
.globl vector26
vector26:
  pushl $0
c0102336:	6a 00                	push   $0x0
  pushl $26
c0102338:	6a 1a                	push   $0x1a
  jmp __alltraps
c010233a:	e9 8d 09 00 00       	jmp    c0102ccc <__alltraps>

c010233f <vector27>:
.globl vector27
vector27:
  pushl $0
c010233f:	6a 00                	push   $0x0
  pushl $27
c0102341:	6a 1b                	push   $0x1b
  jmp __alltraps
c0102343:	e9 84 09 00 00       	jmp    c0102ccc <__alltraps>

c0102348 <vector28>:
.globl vector28
vector28:
  pushl $0
c0102348:	6a 00                	push   $0x0
  pushl $28
c010234a:	6a 1c                	push   $0x1c
  jmp __alltraps
c010234c:	e9 7b 09 00 00       	jmp    c0102ccc <__alltraps>

c0102351 <vector29>:
.globl vector29
vector29:
  pushl $0
c0102351:	6a 00                	push   $0x0
  pushl $29
c0102353:	6a 1d                	push   $0x1d
  jmp __alltraps
c0102355:	e9 72 09 00 00       	jmp    c0102ccc <__alltraps>

c010235a <vector30>:
.globl vector30
vector30:
  pushl $0
c010235a:	6a 00                	push   $0x0
  pushl $30
c010235c:	6a 1e                	push   $0x1e
  jmp __alltraps
c010235e:	e9 69 09 00 00       	jmp    c0102ccc <__alltraps>

c0102363 <vector31>:
.globl vector31
vector31:
  pushl $0
c0102363:	6a 00                	push   $0x0
  pushl $31
c0102365:	6a 1f                	push   $0x1f
  jmp __alltraps
c0102367:	e9 60 09 00 00       	jmp    c0102ccc <__alltraps>

c010236c <vector32>:
.globl vector32
vector32:
  pushl $0
c010236c:	6a 00                	push   $0x0
  pushl $32
c010236e:	6a 20                	push   $0x20
  jmp __alltraps
c0102370:	e9 57 09 00 00       	jmp    c0102ccc <__alltraps>

c0102375 <vector33>:
.globl vector33
vector33:
  pushl $0
c0102375:	6a 00                	push   $0x0
  pushl $33
c0102377:	6a 21                	push   $0x21
  jmp __alltraps
c0102379:	e9 4e 09 00 00       	jmp    c0102ccc <__alltraps>

c010237e <vector34>:
.globl vector34
vector34:
  pushl $0
c010237e:	6a 00                	push   $0x0
  pushl $34
c0102380:	6a 22                	push   $0x22
  jmp __alltraps
c0102382:	e9 45 09 00 00       	jmp    c0102ccc <__alltraps>

c0102387 <vector35>:
.globl vector35
vector35:
  pushl $0
c0102387:	6a 00                	push   $0x0
  pushl $35
c0102389:	6a 23                	push   $0x23
  jmp __alltraps
c010238b:	e9 3c 09 00 00       	jmp    c0102ccc <__alltraps>

c0102390 <vector36>:
.globl vector36
vector36:
  pushl $0
c0102390:	6a 00                	push   $0x0
  pushl $36
c0102392:	6a 24                	push   $0x24
  jmp __alltraps
c0102394:	e9 33 09 00 00       	jmp    c0102ccc <__alltraps>

c0102399 <vector37>:
.globl vector37
vector37:
  pushl $0
c0102399:	6a 00                	push   $0x0
  pushl $37
c010239b:	6a 25                	push   $0x25
  jmp __alltraps
c010239d:	e9 2a 09 00 00       	jmp    c0102ccc <__alltraps>

c01023a2 <vector38>:
.globl vector38
vector38:
  pushl $0
c01023a2:	6a 00                	push   $0x0
  pushl $38
c01023a4:	6a 26                	push   $0x26
  jmp __alltraps
c01023a6:	e9 21 09 00 00       	jmp    c0102ccc <__alltraps>

c01023ab <vector39>:
.globl vector39
vector39:
  pushl $0
c01023ab:	6a 00                	push   $0x0
  pushl $39
c01023ad:	6a 27                	push   $0x27
  jmp __alltraps
c01023af:	e9 18 09 00 00       	jmp    c0102ccc <__alltraps>

c01023b4 <vector40>:
.globl vector40
vector40:
  pushl $0
c01023b4:	6a 00                	push   $0x0
  pushl $40
c01023b6:	6a 28                	push   $0x28
  jmp __alltraps
c01023b8:	e9 0f 09 00 00       	jmp    c0102ccc <__alltraps>

c01023bd <vector41>:
.globl vector41
vector41:
  pushl $0
c01023bd:	6a 00                	push   $0x0
  pushl $41
c01023bf:	6a 29                	push   $0x29
  jmp __alltraps
c01023c1:	e9 06 09 00 00       	jmp    c0102ccc <__alltraps>

c01023c6 <vector42>:
.globl vector42
vector42:
  pushl $0
c01023c6:	6a 00                	push   $0x0
  pushl $42
c01023c8:	6a 2a                	push   $0x2a
  jmp __alltraps
c01023ca:	e9 fd 08 00 00       	jmp    c0102ccc <__alltraps>

c01023cf <vector43>:
.globl vector43
vector43:
  pushl $0
c01023cf:	6a 00                	push   $0x0
  pushl $43
c01023d1:	6a 2b                	push   $0x2b
  jmp __alltraps
c01023d3:	e9 f4 08 00 00       	jmp    c0102ccc <__alltraps>

c01023d8 <vector44>:
.globl vector44
vector44:
  pushl $0
c01023d8:	6a 00                	push   $0x0
  pushl $44
c01023da:	6a 2c                	push   $0x2c
  jmp __alltraps
c01023dc:	e9 eb 08 00 00       	jmp    c0102ccc <__alltraps>

c01023e1 <vector45>:
.globl vector45
vector45:
  pushl $0
c01023e1:	6a 00                	push   $0x0
  pushl $45
c01023e3:	6a 2d                	push   $0x2d
  jmp __alltraps
c01023e5:	e9 e2 08 00 00       	jmp    c0102ccc <__alltraps>

c01023ea <vector46>:
.globl vector46
vector46:
  pushl $0
c01023ea:	6a 00                	push   $0x0
  pushl $46
c01023ec:	6a 2e                	push   $0x2e
  jmp __alltraps
c01023ee:	e9 d9 08 00 00       	jmp    c0102ccc <__alltraps>

c01023f3 <vector47>:
.globl vector47
vector47:
  pushl $0
c01023f3:	6a 00                	push   $0x0
  pushl $47
c01023f5:	6a 2f                	push   $0x2f
  jmp __alltraps
c01023f7:	e9 d0 08 00 00       	jmp    c0102ccc <__alltraps>

c01023fc <vector48>:
.globl vector48
vector48:
  pushl $0
c01023fc:	6a 00                	push   $0x0
  pushl $48
c01023fe:	6a 30                	push   $0x30
  jmp __alltraps
c0102400:	e9 c7 08 00 00       	jmp    c0102ccc <__alltraps>

c0102405 <vector49>:
.globl vector49
vector49:
  pushl $0
c0102405:	6a 00                	push   $0x0
  pushl $49
c0102407:	6a 31                	push   $0x31
  jmp __alltraps
c0102409:	e9 be 08 00 00       	jmp    c0102ccc <__alltraps>

c010240e <vector50>:
.globl vector50
vector50:
  pushl $0
c010240e:	6a 00                	push   $0x0
  pushl $50
c0102410:	6a 32                	push   $0x32
  jmp __alltraps
c0102412:	e9 b5 08 00 00       	jmp    c0102ccc <__alltraps>

c0102417 <vector51>:
.globl vector51
vector51:
  pushl $0
c0102417:	6a 00                	push   $0x0
  pushl $51
c0102419:	6a 33                	push   $0x33
  jmp __alltraps
c010241b:	e9 ac 08 00 00       	jmp    c0102ccc <__alltraps>

c0102420 <vector52>:
.globl vector52
vector52:
  pushl $0
c0102420:	6a 00                	push   $0x0
  pushl $52
c0102422:	6a 34                	push   $0x34
  jmp __alltraps
c0102424:	e9 a3 08 00 00       	jmp    c0102ccc <__alltraps>

c0102429 <vector53>:
.globl vector53
vector53:
  pushl $0
c0102429:	6a 00                	push   $0x0
  pushl $53
c010242b:	6a 35                	push   $0x35
  jmp __alltraps
c010242d:	e9 9a 08 00 00       	jmp    c0102ccc <__alltraps>

c0102432 <vector54>:
.globl vector54
vector54:
  pushl $0
c0102432:	6a 00                	push   $0x0
  pushl $54
c0102434:	6a 36                	push   $0x36
  jmp __alltraps
c0102436:	e9 91 08 00 00       	jmp    c0102ccc <__alltraps>

c010243b <vector55>:
.globl vector55
vector55:
  pushl $0
c010243b:	6a 00                	push   $0x0
  pushl $55
c010243d:	6a 37                	push   $0x37
  jmp __alltraps
c010243f:	e9 88 08 00 00       	jmp    c0102ccc <__alltraps>

c0102444 <vector56>:
.globl vector56
vector56:
  pushl $0
c0102444:	6a 00                	push   $0x0
  pushl $56
c0102446:	6a 38                	push   $0x38
  jmp __alltraps
c0102448:	e9 7f 08 00 00       	jmp    c0102ccc <__alltraps>

c010244d <vector57>:
.globl vector57
vector57:
  pushl $0
c010244d:	6a 00                	push   $0x0
  pushl $57
c010244f:	6a 39                	push   $0x39
  jmp __alltraps
c0102451:	e9 76 08 00 00       	jmp    c0102ccc <__alltraps>

c0102456 <vector58>:
.globl vector58
vector58:
  pushl $0
c0102456:	6a 00                	push   $0x0
  pushl $58
c0102458:	6a 3a                	push   $0x3a
  jmp __alltraps
c010245a:	e9 6d 08 00 00       	jmp    c0102ccc <__alltraps>

c010245f <vector59>:
.globl vector59
vector59:
  pushl $0
c010245f:	6a 00                	push   $0x0
  pushl $59
c0102461:	6a 3b                	push   $0x3b
  jmp __alltraps
c0102463:	e9 64 08 00 00       	jmp    c0102ccc <__alltraps>

c0102468 <vector60>:
.globl vector60
vector60:
  pushl $0
c0102468:	6a 00                	push   $0x0
  pushl $60
c010246a:	6a 3c                	push   $0x3c
  jmp __alltraps
c010246c:	e9 5b 08 00 00       	jmp    c0102ccc <__alltraps>

c0102471 <vector61>:
.globl vector61
vector61:
  pushl $0
c0102471:	6a 00                	push   $0x0
  pushl $61
c0102473:	6a 3d                	push   $0x3d
  jmp __alltraps
c0102475:	e9 52 08 00 00       	jmp    c0102ccc <__alltraps>

c010247a <vector62>:
.globl vector62
vector62:
  pushl $0
c010247a:	6a 00                	push   $0x0
  pushl $62
c010247c:	6a 3e                	push   $0x3e
  jmp __alltraps
c010247e:	e9 49 08 00 00       	jmp    c0102ccc <__alltraps>

c0102483 <vector63>:
.globl vector63
vector63:
  pushl $0
c0102483:	6a 00                	push   $0x0
  pushl $63
c0102485:	6a 3f                	push   $0x3f
  jmp __alltraps
c0102487:	e9 40 08 00 00       	jmp    c0102ccc <__alltraps>

c010248c <vector64>:
.globl vector64
vector64:
  pushl $0
c010248c:	6a 00                	push   $0x0
  pushl $64
c010248e:	6a 40                	push   $0x40
  jmp __alltraps
c0102490:	e9 37 08 00 00       	jmp    c0102ccc <__alltraps>

c0102495 <vector65>:
.globl vector65
vector65:
  pushl $0
c0102495:	6a 00                	push   $0x0
  pushl $65
c0102497:	6a 41                	push   $0x41
  jmp __alltraps
c0102499:	e9 2e 08 00 00       	jmp    c0102ccc <__alltraps>

c010249e <vector66>:
.globl vector66
vector66:
  pushl $0
c010249e:	6a 00                	push   $0x0
  pushl $66
c01024a0:	6a 42                	push   $0x42
  jmp __alltraps
c01024a2:	e9 25 08 00 00       	jmp    c0102ccc <__alltraps>

c01024a7 <vector67>:
.globl vector67
vector67:
  pushl $0
c01024a7:	6a 00                	push   $0x0
  pushl $67
c01024a9:	6a 43                	push   $0x43
  jmp __alltraps
c01024ab:	e9 1c 08 00 00       	jmp    c0102ccc <__alltraps>

c01024b0 <vector68>:
.globl vector68
vector68:
  pushl $0
c01024b0:	6a 00                	push   $0x0
  pushl $68
c01024b2:	6a 44                	push   $0x44
  jmp __alltraps
c01024b4:	e9 13 08 00 00       	jmp    c0102ccc <__alltraps>

c01024b9 <vector69>:
.globl vector69
vector69:
  pushl $0
c01024b9:	6a 00                	push   $0x0
  pushl $69
c01024bb:	6a 45                	push   $0x45
  jmp __alltraps
c01024bd:	e9 0a 08 00 00       	jmp    c0102ccc <__alltraps>

c01024c2 <vector70>:
.globl vector70
vector70:
  pushl $0
c01024c2:	6a 00                	push   $0x0
  pushl $70
c01024c4:	6a 46                	push   $0x46
  jmp __alltraps
c01024c6:	e9 01 08 00 00       	jmp    c0102ccc <__alltraps>

c01024cb <vector71>:
.globl vector71
vector71:
  pushl $0
c01024cb:	6a 00                	push   $0x0
  pushl $71
c01024cd:	6a 47                	push   $0x47
  jmp __alltraps
c01024cf:	e9 f8 07 00 00       	jmp    c0102ccc <__alltraps>

c01024d4 <vector72>:
.globl vector72
vector72:
  pushl $0
c01024d4:	6a 00                	push   $0x0
  pushl $72
c01024d6:	6a 48                	push   $0x48
  jmp __alltraps
c01024d8:	e9 ef 07 00 00       	jmp    c0102ccc <__alltraps>

c01024dd <vector73>:
.globl vector73
vector73:
  pushl $0
c01024dd:	6a 00                	push   $0x0
  pushl $73
c01024df:	6a 49                	push   $0x49
  jmp __alltraps
c01024e1:	e9 e6 07 00 00       	jmp    c0102ccc <__alltraps>

c01024e6 <vector74>:
.globl vector74
vector74:
  pushl $0
c01024e6:	6a 00                	push   $0x0
  pushl $74
c01024e8:	6a 4a                	push   $0x4a
  jmp __alltraps
c01024ea:	e9 dd 07 00 00       	jmp    c0102ccc <__alltraps>

c01024ef <vector75>:
.globl vector75
vector75:
  pushl $0
c01024ef:	6a 00                	push   $0x0
  pushl $75
c01024f1:	6a 4b                	push   $0x4b
  jmp __alltraps
c01024f3:	e9 d4 07 00 00       	jmp    c0102ccc <__alltraps>

c01024f8 <vector76>:
.globl vector76
vector76:
  pushl $0
c01024f8:	6a 00                	push   $0x0
  pushl $76
c01024fa:	6a 4c                	push   $0x4c
  jmp __alltraps
c01024fc:	e9 cb 07 00 00       	jmp    c0102ccc <__alltraps>

c0102501 <vector77>:
.globl vector77
vector77:
  pushl $0
c0102501:	6a 00                	push   $0x0
  pushl $77
c0102503:	6a 4d                	push   $0x4d
  jmp __alltraps
c0102505:	e9 c2 07 00 00       	jmp    c0102ccc <__alltraps>

c010250a <vector78>:
.globl vector78
vector78:
  pushl $0
c010250a:	6a 00                	push   $0x0
  pushl $78
c010250c:	6a 4e                	push   $0x4e
  jmp __alltraps
c010250e:	e9 b9 07 00 00       	jmp    c0102ccc <__alltraps>

c0102513 <vector79>:
.globl vector79
vector79:
  pushl $0
c0102513:	6a 00                	push   $0x0
  pushl $79
c0102515:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102517:	e9 b0 07 00 00       	jmp    c0102ccc <__alltraps>

c010251c <vector80>:
.globl vector80
vector80:
  pushl $0
c010251c:	6a 00                	push   $0x0
  pushl $80
c010251e:	6a 50                	push   $0x50
  jmp __alltraps
c0102520:	e9 a7 07 00 00       	jmp    c0102ccc <__alltraps>

c0102525 <vector81>:
.globl vector81
vector81:
  pushl $0
c0102525:	6a 00                	push   $0x0
  pushl $81
c0102527:	6a 51                	push   $0x51
  jmp __alltraps
c0102529:	e9 9e 07 00 00       	jmp    c0102ccc <__alltraps>

c010252e <vector82>:
.globl vector82
vector82:
  pushl $0
c010252e:	6a 00                	push   $0x0
  pushl $82
c0102530:	6a 52                	push   $0x52
  jmp __alltraps
c0102532:	e9 95 07 00 00       	jmp    c0102ccc <__alltraps>

c0102537 <vector83>:
.globl vector83
vector83:
  pushl $0
c0102537:	6a 00                	push   $0x0
  pushl $83
c0102539:	6a 53                	push   $0x53
  jmp __alltraps
c010253b:	e9 8c 07 00 00       	jmp    c0102ccc <__alltraps>

c0102540 <vector84>:
.globl vector84
vector84:
  pushl $0
c0102540:	6a 00                	push   $0x0
  pushl $84
c0102542:	6a 54                	push   $0x54
  jmp __alltraps
c0102544:	e9 83 07 00 00       	jmp    c0102ccc <__alltraps>

c0102549 <vector85>:
.globl vector85
vector85:
  pushl $0
c0102549:	6a 00                	push   $0x0
  pushl $85
c010254b:	6a 55                	push   $0x55
  jmp __alltraps
c010254d:	e9 7a 07 00 00       	jmp    c0102ccc <__alltraps>

c0102552 <vector86>:
.globl vector86
vector86:
  pushl $0
c0102552:	6a 00                	push   $0x0
  pushl $86
c0102554:	6a 56                	push   $0x56
  jmp __alltraps
c0102556:	e9 71 07 00 00       	jmp    c0102ccc <__alltraps>

c010255b <vector87>:
.globl vector87
vector87:
  pushl $0
c010255b:	6a 00                	push   $0x0
  pushl $87
c010255d:	6a 57                	push   $0x57
  jmp __alltraps
c010255f:	e9 68 07 00 00       	jmp    c0102ccc <__alltraps>

c0102564 <vector88>:
.globl vector88
vector88:
  pushl $0
c0102564:	6a 00                	push   $0x0
  pushl $88
c0102566:	6a 58                	push   $0x58
  jmp __alltraps
c0102568:	e9 5f 07 00 00       	jmp    c0102ccc <__alltraps>

c010256d <vector89>:
.globl vector89
vector89:
  pushl $0
c010256d:	6a 00                	push   $0x0
  pushl $89
c010256f:	6a 59                	push   $0x59
  jmp __alltraps
c0102571:	e9 56 07 00 00       	jmp    c0102ccc <__alltraps>

c0102576 <vector90>:
.globl vector90
vector90:
  pushl $0
c0102576:	6a 00                	push   $0x0
  pushl $90
c0102578:	6a 5a                	push   $0x5a
  jmp __alltraps
c010257a:	e9 4d 07 00 00       	jmp    c0102ccc <__alltraps>

c010257f <vector91>:
.globl vector91
vector91:
  pushl $0
c010257f:	6a 00                	push   $0x0
  pushl $91
c0102581:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102583:	e9 44 07 00 00       	jmp    c0102ccc <__alltraps>

c0102588 <vector92>:
.globl vector92
vector92:
  pushl $0
c0102588:	6a 00                	push   $0x0
  pushl $92
c010258a:	6a 5c                	push   $0x5c
  jmp __alltraps
c010258c:	e9 3b 07 00 00       	jmp    c0102ccc <__alltraps>

c0102591 <vector93>:
.globl vector93
vector93:
  pushl $0
c0102591:	6a 00                	push   $0x0
  pushl $93
c0102593:	6a 5d                	push   $0x5d
  jmp __alltraps
c0102595:	e9 32 07 00 00       	jmp    c0102ccc <__alltraps>

c010259a <vector94>:
.globl vector94
vector94:
  pushl $0
c010259a:	6a 00                	push   $0x0
  pushl $94
c010259c:	6a 5e                	push   $0x5e
  jmp __alltraps
c010259e:	e9 29 07 00 00       	jmp    c0102ccc <__alltraps>

c01025a3 <vector95>:
.globl vector95
vector95:
  pushl $0
c01025a3:	6a 00                	push   $0x0
  pushl $95
c01025a5:	6a 5f                	push   $0x5f
  jmp __alltraps
c01025a7:	e9 20 07 00 00       	jmp    c0102ccc <__alltraps>

c01025ac <vector96>:
.globl vector96
vector96:
  pushl $0
c01025ac:	6a 00                	push   $0x0
  pushl $96
c01025ae:	6a 60                	push   $0x60
  jmp __alltraps
c01025b0:	e9 17 07 00 00       	jmp    c0102ccc <__alltraps>

c01025b5 <vector97>:
.globl vector97
vector97:
  pushl $0
c01025b5:	6a 00                	push   $0x0
  pushl $97
c01025b7:	6a 61                	push   $0x61
  jmp __alltraps
c01025b9:	e9 0e 07 00 00       	jmp    c0102ccc <__alltraps>

c01025be <vector98>:
.globl vector98
vector98:
  pushl $0
c01025be:	6a 00                	push   $0x0
  pushl $98
c01025c0:	6a 62                	push   $0x62
  jmp __alltraps
c01025c2:	e9 05 07 00 00       	jmp    c0102ccc <__alltraps>

c01025c7 <vector99>:
.globl vector99
vector99:
  pushl $0
c01025c7:	6a 00                	push   $0x0
  pushl $99
c01025c9:	6a 63                	push   $0x63
  jmp __alltraps
c01025cb:	e9 fc 06 00 00       	jmp    c0102ccc <__alltraps>

c01025d0 <vector100>:
.globl vector100
vector100:
  pushl $0
c01025d0:	6a 00                	push   $0x0
  pushl $100
c01025d2:	6a 64                	push   $0x64
  jmp __alltraps
c01025d4:	e9 f3 06 00 00       	jmp    c0102ccc <__alltraps>

c01025d9 <vector101>:
.globl vector101
vector101:
  pushl $0
c01025d9:	6a 00                	push   $0x0
  pushl $101
c01025db:	6a 65                	push   $0x65
  jmp __alltraps
c01025dd:	e9 ea 06 00 00       	jmp    c0102ccc <__alltraps>

c01025e2 <vector102>:
.globl vector102
vector102:
  pushl $0
c01025e2:	6a 00                	push   $0x0
  pushl $102
c01025e4:	6a 66                	push   $0x66
  jmp __alltraps
c01025e6:	e9 e1 06 00 00       	jmp    c0102ccc <__alltraps>

c01025eb <vector103>:
.globl vector103
vector103:
  pushl $0
c01025eb:	6a 00                	push   $0x0
  pushl $103
c01025ed:	6a 67                	push   $0x67
  jmp __alltraps
c01025ef:	e9 d8 06 00 00       	jmp    c0102ccc <__alltraps>

c01025f4 <vector104>:
.globl vector104
vector104:
  pushl $0
c01025f4:	6a 00                	push   $0x0
  pushl $104
c01025f6:	6a 68                	push   $0x68
  jmp __alltraps
c01025f8:	e9 cf 06 00 00       	jmp    c0102ccc <__alltraps>

c01025fd <vector105>:
.globl vector105
vector105:
  pushl $0
c01025fd:	6a 00                	push   $0x0
  pushl $105
c01025ff:	6a 69                	push   $0x69
  jmp __alltraps
c0102601:	e9 c6 06 00 00       	jmp    c0102ccc <__alltraps>

c0102606 <vector106>:
.globl vector106
vector106:
  pushl $0
c0102606:	6a 00                	push   $0x0
  pushl $106
c0102608:	6a 6a                	push   $0x6a
  jmp __alltraps
c010260a:	e9 bd 06 00 00       	jmp    c0102ccc <__alltraps>

c010260f <vector107>:
.globl vector107
vector107:
  pushl $0
c010260f:	6a 00                	push   $0x0
  pushl $107
c0102611:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102613:	e9 b4 06 00 00       	jmp    c0102ccc <__alltraps>

c0102618 <vector108>:
.globl vector108
vector108:
  pushl $0
c0102618:	6a 00                	push   $0x0
  pushl $108
c010261a:	6a 6c                	push   $0x6c
  jmp __alltraps
c010261c:	e9 ab 06 00 00       	jmp    c0102ccc <__alltraps>

c0102621 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102621:	6a 00                	push   $0x0
  pushl $109
c0102623:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102625:	e9 a2 06 00 00       	jmp    c0102ccc <__alltraps>

c010262a <vector110>:
.globl vector110
vector110:
  pushl $0
c010262a:	6a 00                	push   $0x0
  pushl $110
c010262c:	6a 6e                	push   $0x6e
  jmp __alltraps
c010262e:	e9 99 06 00 00       	jmp    c0102ccc <__alltraps>

c0102633 <vector111>:
.globl vector111
vector111:
  pushl $0
c0102633:	6a 00                	push   $0x0
  pushl $111
c0102635:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102637:	e9 90 06 00 00       	jmp    c0102ccc <__alltraps>

c010263c <vector112>:
.globl vector112
vector112:
  pushl $0
c010263c:	6a 00                	push   $0x0
  pushl $112
c010263e:	6a 70                	push   $0x70
  jmp __alltraps
c0102640:	e9 87 06 00 00       	jmp    c0102ccc <__alltraps>

c0102645 <vector113>:
.globl vector113
vector113:
  pushl $0
c0102645:	6a 00                	push   $0x0
  pushl $113
c0102647:	6a 71                	push   $0x71
  jmp __alltraps
c0102649:	e9 7e 06 00 00       	jmp    c0102ccc <__alltraps>

c010264e <vector114>:
.globl vector114
vector114:
  pushl $0
c010264e:	6a 00                	push   $0x0
  pushl $114
c0102650:	6a 72                	push   $0x72
  jmp __alltraps
c0102652:	e9 75 06 00 00       	jmp    c0102ccc <__alltraps>

c0102657 <vector115>:
.globl vector115
vector115:
  pushl $0
c0102657:	6a 00                	push   $0x0
  pushl $115
c0102659:	6a 73                	push   $0x73
  jmp __alltraps
c010265b:	e9 6c 06 00 00       	jmp    c0102ccc <__alltraps>

c0102660 <vector116>:
.globl vector116
vector116:
  pushl $0
c0102660:	6a 00                	push   $0x0
  pushl $116
c0102662:	6a 74                	push   $0x74
  jmp __alltraps
c0102664:	e9 63 06 00 00       	jmp    c0102ccc <__alltraps>

c0102669 <vector117>:
.globl vector117
vector117:
  pushl $0
c0102669:	6a 00                	push   $0x0
  pushl $117
c010266b:	6a 75                	push   $0x75
  jmp __alltraps
c010266d:	e9 5a 06 00 00       	jmp    c0102ccc <__alltraps>

c0102672 <vector118>:
.globl vector118
vector118:
  pushl $0
c0102672:	6a 00                	push   $0x0
  pushl $118
c0102674:	6a 76                	push   $0x76
  jmp __alltraps
c0102676:	e9 51 06 00 00       	jmp    c0102ccc <__alltraps>

c010267b <vector119>:
.globl vector119
vector119:
  pushl $0
c010267b:	6a 00                	push   $0x0
  pushl $119
c010267d:	6a 77                	push   $0x77
  jmp __alltraps
c010267f:	e9 48 06 00 00       	jmp    c0102ccc <__alltraps>

c0102684 <vector120>:
.globl vector120
vector120:
  pushl $0
c0102684:	6a 00                	push   $0x0
  pushl $120
c0102686:	6a 78                	push   $0x78
  jmp __alltraps
c0102688:	e9 3f 06 00 00       	jmp    c0102ccc <__alltraps>

c010268d <vector121>:
.globl vector121
vector121:
  pushl $0
c010268d:	6a 00                	push   $0x0
  pushl $121
c010268f:	6a 79                	push   $0x79
  jmp __alltraps
c0102691:	e9 36 06 00 00       	jmp    c0102ccc <__alltraps>

c0102696 <vector122>:
.globl vector122
vector122:
  pushl $0
c0102696:	6a 00                	push   $0x0
  pushl $122
c0102698:	6a 7a                	push   $0x7a
  jmp __alltraps
c010269a:	e9 2d 06 00 00       	jmp    c0102ccc <__alltraps>

c010269f <vector123>:
.globl vector123
vector123:
  pushl $0
c010269f:	6a 00                	push   $0x0
  pushl $123
c01026a1:	6a 7b                	push   $0x7b
  jmp __alltraps
c01026a3:	e9 24 06 00 00       	jmp    c0102ccc <__alltraps>

c01026a8 <vector124>:
.globl vector124
vector124:
  pushl $0
c01026a8:	6a 00                	push   $0x0
  pushl $124
c01026aa:	6a 7c                	push   $0x7c
  jmp __alltraps
c01026ac:	e9 1b 06 00 00       	jmp    c0102ccc <__alltraps>

c01026b1 <vector125>:
.globl vector125
vector125:
  pushl $0
c01026b1:	6a 00                	push   $0x0
  pushl $125
c01026b3:	6a 7d                	push   $0x7d
  jmp __alltraps
c01026b5:	e9 12 06 00 00       	jmp    c0102ccc <__alltraps>

c01026ba <vector126>:
.globl vector126
vector126:
  pushl $0
c01026ba:	6a 00                	push   $0x0
  pushl $126
c01026bc:	6a 7e                	push   $0x7e
  jmp __alltraps
c01026be:	e9 09 06 00 00       	jmp    c0102ccc <__alltraps>

c01026c3 <vector127>:
.globl vector127
vector127:
  pushl $0
c01026c3:	6a 00                	push   $0x0
  pushl $127
c01026c5:	6a 7f                	push   $0x7f
  jmp __alltraps
c01026c7:	e9 00 06 00 00       	jmp    c0102ccc <__alltraps>

c01026cc <vector128>:
.globl vector128
vector128:
  pushl $0
c01026cc:	6a 00                	push   $0x0
  pushl $128
c01026ce:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c01026d3:	e9 f4 05 00 00       	jmp    c0102ccc <__alltraps>

c01026d8 <vector129>:
.globl vector129
vector129:
  pushl $0
c01026d8:	6a 00                	push   $0x0
  pushl $129
c01026da:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c01026df:	e9 e8 05 00 00       	jmp    c0102ccc <__alltraps>

c01026e4 <vector130>:
.globl vector130
vector130:
  pushl $0
c01026e4:	6a 00                	push   $0x0
  pushl $130
c01026e6:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c01026eb:	e9 dc 05 00 00       	jmp    c0102ccc <__alltraps>

c01026f0 <vector131>:
.globl vector131
vector131:
  pushl $0
c01026f0:	6a 00                	push   $0x0
  pushl $131
c01026f2:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c01026f7:	e9 d0 05 00 00       	jmp    c0102ccc <__alltraps>

c01026fc <vector132>:
.globl vector132
vector132:
  pushl $0
c01026fc:	6a 00                	push   $0x0
  pushl $132
c01026fe:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102703:	e9 c4 05 00 00       	jmp    c0102ccc <__alltraps>

c0102708 <vector133>:
.globl vector133
vector133:
  pushl $0
c0102708:	6a 00                	push   $0x0
  pushl $133
c010270a:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c010270f:	e9 b8 05 00 00       	jmp    c0102ccc <__alltraps>

c0102714 <vector134>:
.globl vector134
vector134:
  pushl $0
c0102714:	6a 00                	push   $0x0
  pushl $134
c0102716:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c010271b:	e9 ac 05 00 00       	jmp    c0102ccc <__alltraps>

c0102720 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102720:	6a 00                	push   $0x0
  pushl $135
c0102722:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102727:	e9 a0 05 00 00       	jmp    c0102ccc <__alltraps>

c010272c <vector136>:
.globl vector136
vector136:
  pushl $0
c010272c:	6a 00                	push   $0x0
  pushl $136
c010272e:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102733:	e9 94 05 00 00       	jmp    c0102ccc <__alltraps>

c0102738 <vector137>:
.globl vector137
vector137:
  pushl $0
c0102738:	6a 00                	push   $0x0
  pushl $137
c010273a:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c010273f:	e9 88 05 00 00       	jmp    c0102ccc <__alltraps>

c0102744 <vector138>:
.globl vector138
vector138:
  pushl $0
c0102744:	6a 00                	push   $0x0
  pushl $138
c0102746:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c010274b:	e9 7c 05 00 00       	jmp    c0102ccc <__alltraps>

c0102750 <vector139>:
.globl vector139
vector139:
  pushl $0
c0102750:	6a 00                	push   $0x0
  pushl $139
c0102752:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102757:	e9 70 05 00 00       	jmp    c0102ccc <__alltraps>

c010275c <vector140>:
.globl vector140
vector140:
  pushl $0
c010275c:	6a 00                	push   $0x0
  pushl $140
c010275e:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102763:	e9 64 05 00 00       	jmp    c0102ccc <__alltraps>

c0102768 <vector141>:
.globl vector141
vector141:
  pushl $0
c0102768:	6a 00                	push   $0x0
  pushl $141
c010276a:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c010276f:	e9 58 05 00 00       	jmp    c0102ccc <__alltraps>

c0102774 <vector142>:
.globl vector142
vector142:
  pushl $0
c0102774:	6a 00                	push   $0x0
  pushl $142
c0102776:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c010277b:	e9 4c 05 00 00       	jmp    c0102ccc <__alltraps>

c0102780 <vector143>:
.globl vector143
vector143:
  pushl $0
c0102780:	6a 00                	push   $0x0
  pushl $143
c0102782:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102787:	e9 40 05 00 00       	jmp    c0102ccc <__alltraps>

c010278c <vector144>:
.globl vector144
vector144:
  pushl $0
c010278c:	6a 00                	push   $0x0
  pushl $144
c010278e:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102793:	e9 34 05 00 00       	jmp    c0102ccc <__alltraps>

c0102798 <vector145>:
.globl vector145
vector145:
  pushl $0
c0102798:	6a 00                	push   $0x0
  pushl $145
c010279a:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c010279f:	e9 28 05 00 00       	jmp    c0102ccc <__alltraps>

c01027a4 <vector146>:
.globl vector146
vector146:
  pushl $0
c01027a4:	6a 00                	push   $0x0
  pushl $146
c01027a6:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c01027ab:	e9 1c 05 00 00       	jmp    c0102ccc <__alltraps>

c01027b0 <vector147>:
.globl vector147
vector147:
  pushl $0
c01027b0:	6a 00                	push   $0x0
  pushl $147
c01027b2:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c01027b7:	e9 10 05 00 00       	jmp    c0102ccc <__alltraps>

c01027bc <vector148>:
.globl vector148
vector148:
  pushl $0
c01027bc:	6a 00                	push   $0x0
  pushl $148
c01027be:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c01027c3:	e9 04 05 00 00       	jmp    c0102ccc <__alltraps>

c01027c8 <vector149>:
.globl vector149
vector149:
  pushl $0
c01027c8:	6a 00                	push   $0x0
  pushl $149
c01027ca:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c01027cf:	e9 f8 04 00 00       	jmp    c0102ccc <__alltraps>

c01027d4 <vector150>:
.globl vector150
vector150:
  pushl $0
c01027d4:	6a 00                	push   $0x0
  pushl $150
c01027d6:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c01027db:	e9 ec 04 00 00       	jmp    c0102ccc <__alltraps>

c01027e0 <vector151>:
.globl vector151
vector151:
  pushl $0
c01027e0:	6a 00                	push   $0x0
  pushl $151
c01027e2:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c01027e7:	e9 e0 04 00 00       	jmp    c0102ccc <__alltraps>

c01027ec <vector152>:
.globl vector152
vector152:
  pushl $0
c01027ec:	6a 00                	push   $0x0
  pushl $152
c01027ee:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c01027f3:	e9 d4 04 00 00       	jmp    c0102ccc <__alltraps>

c01027f8 <vector153>:
.globl vector153
vector153:
  pushl $0
c01027f8:	6a 00                	push   $0x0
  pushl $153
c01027fa:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c01027ff:	e9 c8 04 00 00       	jmp    c0102ccc <__alltraps>

c0102804 <vector154>:
.globl vector154
vector154:
  pushl $0
c0102804:	6a 00                	push   $0x0
  pushl $154
c0102806:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c010280b:	e9 bc 04 00 00       	jmp    c0102ccc <__alltraps>

c0102810 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102810:	6a 00                	push   $0x0
  pushl $155
c0102812:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102817:	e9 b0 04 00 00       	jmp    c0102ccc <__alltraps>

c010281c <vector156>:
.globl vector156
vector156:
  pushl $0
c010281c:	6a 00                	push   $0x0
  pushl $156
c010281e:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102823:	e9 a4 04 00 00       	jmp    c0102ccc <__alltraps>

c0102828 <vector157>:
.globl vector157
vector157:
  pushl $0
c0102828:	6a 00                	push   $0x0
  pushl $157
c010282a:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c010282f:	e9 98 04 00 00       	jmp    c0102ccc <__alltraps>

c0102834 <vector158>:
.globl vector158
vector158:
  pushl $0
c0102834:	6a 00                	push   $0x0
  pushl $158
c0102836:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c010283b:	e9 8c 04 00 00       	jmp    c0102ccc <__alltraps>

c0102840 <vector159>:
.globl vector159
vector159:
  pushl $0
c0102840:	6a 00                	push   $0x0
  pushl $159
c0102842:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102847:	e9 80 04 00 00       	jmp    c0102ccc <__alltraps>

c010284c <vector160>:
.globl vector160
vector160:
  pushl $0
c010284c:	6a 00                	push   $0x0
  pushl $160
c010284e:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0102853:	e9 74 04 00 00       	jmp    c0102ccc <__alltraps>

c0102858 <vector161>:
.globl vector161
vector161:
  pushl $0
c0102858:	6a 00                	push   $0x0
  pushl $161
c010285a:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c010285f:	e9 68 04 00 00       	jmp    c0102ccc <__alltraps>

c0102864 <vector162>:
.globl vector162
vector162:
  pushl $0
c0102864:	6a 00                	push   $0x0
  pushl $162
c0102866:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c010286b:	e9 5c 04 00 00       	jmp    c0102ccc <__alltraps>

c0102870 <vector163>:
.globl vector163
vector163:
  pushl $0
c0102870:	6a 00                	push   $0x0
  pushl $163
c0102872:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0102877:	e9 50 04 00 00       	jmp    c0102ccc <__alltraps>

c010287c <vector164>:
.globl vector164
vector164:
  pushl $0
c010287c:	6a 00                	push   $0x0
  pushl $164
c010287e:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0102883:	e9 44 04 00 00       	jmp    c0102ccc <__alltraps>

c0102888 <vector165>:
.globl vector165
vector165:
  pushl $0
c0102888:	6a 00                	push   $0x0
  pushl $165
c010288a:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c010288f:	e9 38 04 00 00       	jmp    c0102ccc <__alltraps>

c0102894 <vector166>:
.globl vector166
vector166:
  pushl $0
c0102894:	6a 00                	push   $0x0
  pushl $166
c0102896:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c010289b:	e9 2c 04 00 00       	jmp    c0102ccc <__alltraps>

c01028a0 <vector167>:
.globl vector167
vector167:
  pushl $0
c01028a0:	6a 00                	push   $0x0
  pushl $167
c01028a2:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c01028a7:	e9 20 04 00 00       	jmp    c0102ccc <__alltraps>

c01028ac <vector168>:
.globl vector168
vector168:
  pushl $0
c01028ac:	6a 00                	push   $0x0
  pushl $168
c01028ae:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c01028b3:	e9 14 04 00 00       	jmp    c0102ccc <__alltraps>

c01028b8 <vector169>:
.globl vector169
vector169:
  pushl $0
c01028b8:	6a 00                	push   $0x0
  pushl $169
c01028ba:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c01028bf:	e9 08 04 00 00       	jmp    c0102ccc <__alltraps>

c01028c4 <vector170>:
.globl vector170
vector170:
  pushl $0
c01028c4:	6a 00                	push   $0x0
  pushl $170
c01028c6:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c01028cb:	e9 fc 03 00 00       	jmp    c0102ccc <__alltraps>

c01028d0 <vector171>:
.globl vector171
vector171:
  pushl $0
c01028d0:	6a 00                	push   $0x0
  pushl $171
c01028d2:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c01028d7:	e9 f0 03 00 00       	jmp    c0102ccc <__alltraps>

c01028dc <vector172>:
.globl vector172
vector172:
  pushl $0
c01028dc:	6a 00                	push   $0x0
  pushl $172
c01028de:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c01028e3:	e9 e4 03 00 00       	jmp    c0102ccc <__alltraps>

c01028e8 <vector173>:
.globl vector173
vector173:
  pushl $0
c01028e8:	6a 00                	push   $0x0
  pushl $173
c01028ea:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c01028ef:	e9 d8 03 00 00       	jmp    c0102ccc <__alltraps>

c01028f4 <vector174>:
.globl vector174
vector174:
  pushl $0
c01028f4:	6a 00                	push   $0x0
  pushl $174
c01028f6:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c01028fb:	e9 cc 03 00 00       	jmp    c0102ccc <__alltraps>

c0102900 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102900:	6a 00                	push   $0x0
  pushl $175
c0102902:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c0102907:	e9 c0 03 00 00       	jmp    c0102ccc <__alltraps>

c010290c <vector176>:
.globl vector176
vector176:
  pushl $0
c010290c:	6a 00                	push   $0x0
  pushl $176
c010290e:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102913:	e9 b4 03 00 00       	jmp    c0102ccc <__alltraps>

c0102918 <vector177>:
.globl vector177
vector177:
  pushl $0
c0102918:	6a 00                	push   $0x0
  pushl $177
c010291a:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c010291f:	e9 a8 03 00 00       	jmp    c0102ccc <__alltraps>

c0102924 <vector178>:
.globl vector178
vector178:
  pushl $0
c0102924:	6a 00                	push   $0x0
  pushl $178
c0102926:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c010292b:	e9 9c 03 00 00       	jmp    c0102ccc <__alltraps>

c0102930 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102930:	6a 00                	push   $0x0
  pushl $179
c0102932:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0102937:	e9 90 03 00 00       	jmp    c0102ccc <__alltraps>

c010293c <vector180>:
.globl vector180
vector180:
  pushl $0
c010293c:	6a 00                	push   $0x0
  pushl $180
c010293e:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0102943:	e9 84 03 00 00       	jmp    c0102ccc <__alltraps>

c0102948 <vector181>:
.globl vector181
vector181:
  pushl $0
c0102948:	6a 00                	push   $0x0
  pushl $181
c010294a:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c010294f:	e9 78 03 00 00       	jmp    c0102ccc <__alltraps>

c0102954 <vector182>:
.globl vector182
vector182:
  pushl $0
c0102954:	6a 00                	push   $0x0
  pushl $182
c0102956:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c010295b:	e9 6c 03 00 00       	jmp    c0102ccc <__alltraps>

c0102960 <vector183>:
.globl vector183
vector183:
  pushl $0
c0102960:	6a 00                	push   $0x0
  pushl $183
c0102962:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0102967:	e9 60 03 00 00       	jmp    c0102ccc <__alltraps>

c010296c <vector184>:
.globl vector184
vector184:
  pushl $0
c010296c:	6a 00                	push   $0x0
  pushl $184
c010296e:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c0102973:	e9 54 03 00 00       	jmp    c0102ccc <__alltraps>

c0102978 <vector185>:
.globl vector185
vector185:
  pushl $0
c0102978:	6a 00                	push   $0x0
  pushl $185
c010297a:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c010297f:	e9 48 03 00 00       	jmp    c0102ccc <__alltraps>

c0102984 <vector186>:
.globl vector186
vector186:
  pushl $0
c0102984:	6a 00                	push   $0x0
  pushl $186
c0102986:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c010298b:	e9 3c 03 00 00       	jmp    c0102ccc <__alltraps>

c0102990 <vector187>:
.globl vector187
vector187:
  pushl $0
c0102990:	6a 00                	push   $0x0
  pushl $187
c0102992:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c0102997:	e9 30 03 00 00       	jmp    c0102ccc <__alltraps>

c010299c <vector188>:
.globl vector188
vector188:
  pushl $0
c010299c:	6a 00                	push   $0x0
  pushl $188
c010299e:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c01029a3:	e9 24 03 00 00       	jmp    c0102ccc <__alltraps>

c01029a8 <vector189>:
.globl vector189
vector189:
  pushl $0
c01029a8:	6a 00                	push   $0x0
  pushl $189
c01029aa:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c01029af:	e9 18 03 00 00       	jmp    c0102ccc <__alltraps>

c01029b4 <vector190>:
.globl vector190
vector190:
  pushl $0
c01029b4:	6a 00                	push   $0x0
  pushl $190
c01029b6:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c01029bb:	e9 0c 03 00 00       	jmp    c0102ccc <__alltraps>

c01029c0 <vector191>:
.globl vector191
vector191:
  pushl $0
c01029c0:	6a 00                	push   $0x0
  pushl $191
c01029c2:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c01029c7:	e9 00 03 00 00       	jmp    c0102ccc <__alltraps>

c01029cc <vector192>:
.globl vector192
vector192:
  pushl $0
c01029cc:	6a 00                	push   $0x0
  pushl $192
c01029ce:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c01029d3:	e9 f4 02 00 00       	jmp    c0102ccc <__alltraps>

c01029d8 <vector193>:
.globl vector193
vector193:
  pushl $0
c01029d8:	6a 00                	push   $0x0
  pushl $193
c01029da:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c01029df:	e9 e8 02 00 00       	jmp    c0102ccc <__alltraps>

c01029e4 <vector194>:
.globl vector194
vector194:
  pushl $0
c01029e4:	6a 00                	push   $0x0
  pushl $194
c01029e6:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c01029eb:	e9 dc 02 00 00       	jmp    c0102ccc <__alltraps>

c01029f0 <vector195>:
.globl vector195
vector195:
  pushl $0
c01029f0:	6a 00                	push   $0x0
  pushl $195
c01029f2:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c01029f7:	e9 d0 02 00 00       	jmp    c0102ccc <__alltraps>

c01029fc <vector196>:
.globl vector196
vector196:
  pushl $0
c01029fc:	6a 00                	push   $0x0
  pushl $196
c01029fe:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0102a03:	e9 c4 02 00 00       	jmp    c0102ccc <__alltraps>

c0102a08 <vector197>:
.globl vector197
vector197:
  pushl $0
c0102a08:	6a 00                	push   $0x0
  pushl $197
c0102a0a:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102a0f:	e9 b8 02 00 00       	jmp    c0102ccc <__alltraps>

c0102a14 <vector198>:
.globl vector198
vector198:
  pushl $0
c0102a14:	6a 00                	push   $0x0
  pushl $198
c0102a16:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0102a1b:	e9 ac 02 00 00       	jmp    c0102ccc <__alltraps>

c0102a20 <vector199>:
.globl vector199
vector199:
  pushl $0
c0102a20:	6a 00                	push   $0x0
  pushl $199
c0102a22:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c0102a27:	e9 a0 02 00 00       	jmp    c0102ccc <__alltraps>

c0102a2c <vector200>:
.globl vector200
vector200:
  pushl $0
c0102a2c:	6a 00                	push   $0x0
  pushl $200
c0102a2e:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0102a33:	e9 94 02 00 00       	jmp    c0102ccc <__alltraps>

c0102a38 <vector201>:
.globl vector201
vector201:
  pushl $0
c0102a38:	6a 00                	push   $0x0
  pushl $201
c0102a3a:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0102a3f:	e9 88 02 00 00       	jmp    c0102ccc <__alltraps>

c0102a44 <vector202>:
.globl vector202
vector202:
  pushl $0
c0102a44:	6a 00                	push   $0x0
  pushl $202
c0102a46:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c0102a4b:	e9 7c 02 00 00       	jmp    c0102ccc <__alltraps>

c0102a50 <vector203>:
.globl vector203
vector203:
  pushl $0
c0102a50:	6a 00                	push   $0x0
  pushl $203
c0102a52:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0102a57:	e9 70 02 00 00       	jmp    c0102ccc <__alltraps>

c0102a5c <vector204>:
.globl vector204
vector204:
  pushl $0
c0102a5c:	6a 00                	push   $0x0
  pushl $204
c0102a5e:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c0102a63:	e9 64 02 00 00       	jmp    c0102ccc <__alltraps>

c0102a68 <vector205>:
.globl vector205
vector205:
  pushl $0
c0102a68:	6a 00                	push   $0x0
  pushl $205
c0102a6a:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c0102a6f:	e9 58 02 00 00       	jmp    c0102ccc <__alltraps>

c0102a74 <vector206>:
.globl vector206
vector206:
  pushl $0
c0102a74:	6a 00                	push   $0x0
  pushl $206
c0102a76:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c0102a7b:	e9 4c 02 00 00       	jmp    c0102ccc <__alltraps>

c0102a80 <vector207>:
.globl vector207
vector207:
  pushl $0
c0102a80:	6a 00                	push   $0x0
  pushl $207
c0102a82:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c0102a87:	e9 40 02 00 00       	jmp    c0102ccc <__alltraps>

c0102a8c <vector208>:
.globl vector208
vector208:
  pushl $0
c0102a8c:	6a 00                	push   $0x0
  pushl $208
c0102a8e:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c0102a93:	e9 34 02 00 00       	jmp    c0102ccc <__alltraps>

c0102a98 <vector209>:
.globl vector209
vector209:
  pushl $0
c0102a98:	6a 00                	push   $0x0
  pushl $209
c0102a9a:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0102a9f:	e9 28 02 00 00       	jmp    c0102ccc <__alltraps>

c0102aa4 <vector210>:
.globl vector210
vector210:
  pushl $0
c0102aa4:	6a 00                	push   $0x0
  pushl $210
c0102aa6:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c0102aab:	e9 1c 02 00 00       	jmp    c0102ccc <__alltraps>

c0102ab0 <vector211>:
.globl vector211
vector211:
  pushl $0
c0102ab0:	6a 00                	push   $0x0
  pushl $211
c0102ab2:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c0102ab7:	e9 10 02 00 00       	jmp    c0102ccc <__alltraps>

c0102abc <vector212>:
.globl vector212
vector212:
  pushl $0
c0102abc:	6a 00                	push   $0x0
  pushl $212
c0102abe:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c0102ac3:	e9 04 02 00 00       	jmp    c0102ccc <__alltraps>

c0102ac8 <vector213>:
.globl vector213
vector213:
  pushl $0
c0102ac8:	6a 00                	push   $0x0
  pushl $213
c0102aca:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c0102acf:	e9 f8 01 00 00       	jmp    c0102ccc <__alltraps>

c0102ad4 <vector214>:
.globl vector214
vector214:
  pushl $0
c0102ad4:	6a 00                	push   $0x0
  pushl $214
c0102ad6:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c0102adb:	e9 ec 01 00 00       	jmp    c0102ccc <__alltraps>

c0102ae0 <vector215>:
.globl vector215
vector215:
  pushl $0
c0102ae0:	6a 00                	push   $0x0
  pushl $215
c0102ae2:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c0102ae7:	e9 e0 01 00 00       	jmp    c0102ccc <__alltraps>

c0102aec <vector216>:
.globl vector216
vector216:
  pushl $0
c0102aec:	6a 00                	push   $0x0
  pushl $216
c0102aee:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c0102af3:	e9 d4 01 00 00       	jmp    c0102ccc <__alltraps>

c0102af8 <vector217>:
.globl vector217
vector217:
  pushl $0
c0102af8:	6a 00                	push   $0x0
  pushl $217
c0102afa:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0102aff:	e9 c8 01 00 00       	jmp    c0102ccc <__alltraps>

c0102b04 <vector218>:
.globl vector218
vector218:
  pushl $0
c0102b04:	6a 00                	push   $0x0
  pushl $218
c0102b06:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c0102b0b:	e9 bc 01 00 00       	jmp    c0102ccc <__alltraps>

c0102b10 <vector219>:
.globl vector219
vector219:
  pushl $0
c0102b10:	6a 00                	push   $0x0
  pushl $219
c0102b12:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c0102b17:	e9 b0 01 00 00       	jmp    c0102ccc <__alltraps>

c0102b1c <vector220>:
.globl vector220
vector220:
  pushl $0
c0102b1c:	6a 00                	push   $0x0
  pushl $220
c0102b1e:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c0102b23:	e9 a4 01 00 00       	jmp    c0102ccc <__alltraps>

c0102b28 <vector221>:
.globl vector221
vector221:
  pushl $0
c0102b28:	6a 00                	push   $0x0
  pushl $221
c0102b2a:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0102b2f:	e9 98 01 00 00       	jmp    c0102ccc <__alltraps>

c0102b34 <vector222>:
.globl vector222
vector222:
  pushl $0
c0102b34:	6a 00                	push   $0x0
  pushl $222
c0102b36:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c0102b3b:	e9 8c 01 00 00       	jmp    c0102ccc <__alltraps>

c0102b40 <vector223>:
.globl vector223
vector223:
  pushl $0
c0102b40:	6a 00                	push   $0x0
  pushl $223
c0102b42:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c0102b47:	e9 80 01 00 00       	jmp    c0102ccc <__alltraps>

c0102b4c <vector224>:
.globl vector224
vector224:
  pushl $0
c0102b4c:	6a 00                	push   $0x0
  pushl $224
c0102b4e:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c0102b53:	e9 74 01 00 00       	jmp    c0102ccc <__alltraps>

c0102b58 <vector225>:
.globl vector225
vector225:
  pushl $0
c0102b58:	6a 00                	push   $0x0
  pushl $225
c0102b5a:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c0102b5f:	e9 68 01 00 00       	jmp    c0102ccc <__alltraps>

c0102b64 <vector226>:
.globl vector226
vector226:
  pushl $0
c0102b64:	6a 00                	push   $0x0
  pushl $226
c0102b66:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c0102b6b:	e9 5c 01 00 00       	jmp    c0102ccc <__alltraps>

c0102b70 <vector227>:
.globl vector227
vector227:
  pushl $0
c0102b70:	6a 00                	push   $0x0
  pushl $227
c0102b72:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c0102b77:	e9 50 01 00 00       	jmp    c0102ccc <__alltraps>

c0102b7c <vector228>:
.globl vector228
vector228:
  pushl $0
c0102b7c:	6a 00                	push   $0x0
  pushl $228
c0102b7e:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c0102b83:	e9 44 01 00 00       	jmp    c0102ccc <__alltraps>

c0102b88 <vector229>:
.globl vector229
vector229:
  pushl $0
c0102b88:	6a 00                	push   $0x0
  pushl $229
c0102b8a:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c0102b8f:	e9 38 01 00 00       	jmp    c0102ccc <__alltraps>

c0102b94 <vector230>:
.globl vector230
vector230:
  pushl $0
c0102b94:	6a 00                	push   $0x0
  pushl $230
c0102b96:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c0102b9b:	e9 2c 01 00 00       	jmp    c0102ccc <__alltraps>

c0102ba0 <vector231>:
.globl vector231
vector231:
  pushl $0
c0102ba0:	6a 00                	push   $0x0
  pushl $231
c0102ba2:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c0102ba7:	e9 20 01 00 00       	jmp    c0102ccc <__alltraps>

c0102bac <vector232>:
.globl vector232
vector232:
  pushl $0
c0102bac:	6a 00                	push   $0x0
  pushl $232
c0102bae:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c0102bb3:	e9 14 01 00 00       	jmp    c0102ccc <__alltraps>

c0102bb8 <vector233>:
.globl vector233
vector233:
  pushl $0
c0102bb8:	6a 00                	push   $0x0
  pushl $233
c0102bba:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c0102bbf:	e9 08 01 00 00       	jmp    c0102ccc <__alltraps>

c0102bc4 <vector234>:
.globl vector234
vector234:
  pushl $0
c0102bc4:	6a 00                	push   $0x0
  pushl $234
c0102bc6:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c0102bcb:	e9 fc 00 00 00       	jmp    c0102ccc <__alltraps>

c0102bd0 <vector235>:
.globl vector235
vector235:
  pushl $0
c0102bd0:	6a 00                	push   $0x0
  pushl $235
c0102bd2:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c0102bd7:	e9 f0 00 00 00       	jmp    c0102ccc <__alltraps>

c0102bdc <vector236>:
.globl vector236
vector236:
  pushl $0
c0102bdc:	6a 00                	push   $0x0
  pushl $236
c0102bde:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c0102be3:	e9 e4 00 00 00       	jmp    c0102ccc <__alltraps>

c0102be8 <vector237>:
.globl vector237
vector237:
  pushl $0
c0102be8:	6a 00                	push   $0x0
  pushl $237
c0102bea:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c0102bef:	e9 d8 00 00 00       	jmp    c0102ccc <__alltraps>

c0102bf4 <vector238>:
.globl vector238
vector238:
  pushl $0
c0102bf4:	6a 00                	push   $0x0
  pushl $238
c0102bf6:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c0102bfb:	e9 cc 00 00 00       	jmp    c0102ccc <__alltraps>

c0102c00 <vector239>:
.globl vector239
vector239:
  pushl $0
c0102c00:	6a 00                	push   $0x0
  pushl $239
c0102c02:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c0102c07:	e9 c0 00 00 00       	jmp    c0102ccc <__alltraps>

c0102c0c <vector240>:
.globl vector240
vector240:
  pushl $0
c0102c0c:	6a 00                	push   $0x0
  pushl $240
c0102c0e:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c0102c13:	e9 b4 00 00 00       	jmp    c0102ccc <__alltraps>

c0102c18 <vector241>:
.globl vector241
vector241:
  pushl $0
c0102c18:	6a 00                	push   $0x0
  pushl $241
c0102c1a:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0102c1f:	e9 a8 00 00 00       	jmp    c0102ccc <__alltraps>

c0102c24 <vector242>:
.globl vector242
vector242:
  pushl $0
c0102c24:	6a 00                	push   $0x0
  pushl $242
c0102c26:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c0102c2b:	e9 9c 00 00 00       	jmp    c0102ccc <__alltraps>

c0102c30 <vector243>:
.globl vector243
vector243:
  pushl $0
c0102c30:	6a 00                	push   $0x0
  pushl $243
c0102c32:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c0102c37:	e9 90 00 00 00       	jmp    c0102ccc <__alltraps>

c0102c3c <vector244>:
.globl vector244
vector244:
  pushl $0
c0102c3c:	6a 00                	push   $0x0
  pushl $244
c0102c3e:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c0102c43:	e9 84 00 00 00       	jmp    c0102ccc <__alltraps>

c0102c48 <vector245>:
.globl vector245
vector245:
  pushl $0
c0102c48:	6a 00                	push   $0x0
  pushl $245
c0102c4a:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c0102c4f:	e9 78 00 00 00       	jmp    c0102ccc <__alltraps>

c0102c54 <vector246>:
.globl vector246
vector246:
  pushl $0
c0102c54:	6a 00                	push   $0x0
  pushl $246
c0102c56:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c0102c5b:	e9 6c 00 00 00       	jmp    c0102ccc <__alltraps>

c0102c60 <vector247>:
.globl vector247
vector247:
  pushl $0
c0102c60:	6a 00                	push   $0x0
  pushl $247
c0102c62:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c0102c67:	e9 60 00 00 00       	jmp    c0102ccc <__alltraps>

c0102c6c <vector248>:
.globl vector248
vector248:
  pushl $0
c0102c6c:	6a 00                	push   $0x0
  pushl $248
c0102c6e:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c0102c73:	e9 54 00 00 00       	jmp    c0102ccc <__alltraps>

c0102c78 <vector249>:
.globl vector249
vector249:
  pushl $0
c0102c78:	6a 00                	push   $0x0
  pushl $249
c0102c7a:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c0102c7f:	e9 48 00 00 00       	jmp    c0102ccc <__alltraps>

c0102c84 <vector250>:
.globl vector250
vector250:
  pushl $0
c0102c84:	6a 00                	push   $0x0
  pushl $250
c0102c86:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c0102c8b:	e9 3c 00 00 00       	jmp    c0102ccc <__alltraps>

c0102c90 <vector251>:
.globl vector251
vector251:
  pushl $0
c0102c90:	6a 00                	push   $0x0
  pushl $251
c0102c92:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c0102c97:	e9 30 00 00 00       	jmp    c0102ccc <__alltraps>

c0102c9c <vector252>:
.globl vector252
vector252:
  pushl $0
c0102c9c:	6a 00                	push   $0x0
  pushl $252
c0102c9e:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c0102ca3:	e9 24 00 00 00       	jmp    c0102ccc <__alltraps>

c0102ca8 <vector253>:
.globl vector253
vector253:
  pushl $0
c0102ca8:	6a 00                	push   $0x0
  pushl $253
c0102caa:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c0102caf:	e9 18 00 00 00       	jmp    c0102ccc <__alltraps>

c0102cb4 <vector254>:
.globl vector254
vector254:
  pushl $0
c0102cb4:	6a 00                	push   $0x0
  pushl $254
c0102cb6:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c0102cbb:	e9 0c 00 00 00       	jmp    c0102ccc <__alltraps>

c0102cc0 <vector255>:
.globl vector255
vector255:
  pushl $0
c0102cc0:	6a 00                	push   $0x0
  pushl $255
c0102cc2:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c0102cc7:	e9 00 00 00 00       	jmp    c0102ccc <__alltraps>

c0102ccc <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0102ccc:	1e                   	push   %ds
    pushl %es
c0102ccd:	06                   	push   %es
    pushl %fs
c0102cce:	0f a0                	push   %fs
    pushl %gs
c0102cd0:	0f a8                	push   %gs
    pushal
c0102cd2:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0102cd3:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0102cd8:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0102cda:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0102cdc:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0102cdd:	e8 64 f5 ff ff       	call   c0102246 <trap>

    # pop the pushed stack pointer
    popl %esp
c0102ce2:	5c                   	pop    %esp

c0102ce3 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0102ce3:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0102ce4:	0f a9                	pop    %gs
    popl %fs
c0102ce6:	0f a1                	pop    %fs
    popl %es
c0102ce8:	07                   	pop    %es
    popl %ds
c0102ce9:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0102cea:	83 c4 08             	add    $0x8,%esp
    iret
c0102ced:	cf                   	iret   

c0102cee <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0102cee:	55                   	push   %ebp
c0102cef:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0102cf1:	a1 38 df 11 c0       	mov    0xc011df38,%eax
c0102cf6:	8b 55 08             	mov    0x8(%ebp),%edx
c0102cf9:	29 c2                	sub    %eax,%edx
c0102cfb:	89 d0                	mov    %edx,%eax
c0102cfd:	c1 f8 02             	sar    $0x2,%eax
c0102d00:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0102d06:	5d                   	pop    %ebp
c0102d07:	c3                   	ret    

c0102d08 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0102d08:	55                   	push   %ebp
c0102d09:	89 e5                	mov    %esp,%ebp
c0102d0b:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0102d0e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d11:	89 04 24             	mov    %eax,(%esp)
c0102d14:	e8 d5 ff ff ff       	call   c0102cee <page2ppn>
c0102d19:	c1 e0 0c             	shl    $0xc,%eax
}
c0102d1c:	c9                   	leave  
c0102d1d:	c3                   	ret    

c0102d1e <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0102d1e:	55                   	push   %ebp
c0102d1f:	89 e5                	mov    %esp,%ebp
c0102d21:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0102d24:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d27:	c1 e8 0c             	shr    $0xc,%eax
c0102d2a:	89 c2                	mov    %eax,%edx
c0102d2c:	a1 a0 de 11 c0       	mov    0xc011dea0,%eax
c0102d31:	39 c2                	cmp    %eax,%edx
c0102d33:	72 1c                	jb     c0102d51 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0102d35:	c7 44 24 08 30 70 10 	movl   $0xc0107030,0x8(%esp)
c0102d3c:	c0 
c0102d3d:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0102d44:	00 
c0102d45:	c7 04 24 4f 70 10 c0 	movl   $0xc010704f,(%esp)
c0102d4c:	e8 95 d6 ff ff       	call   c01003e6 <__panic>
    }
    return &pages[PPN(pa)];
c0102d51:	8b 0d 38 df 11 c0    	mov    0xc011df38,%ecx
c0102d57:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d5a:	c1 e8 0c             	shr    $0xc,%eax
c0102d5d:	89 c2                	mov    %eax,%edx
c0102d5f:	89 d0                	mov    %edx,%eax
c0102d61:	c1 e0 02             	shl    $0x2,%eax
c0102d64:	01 d0                	add    %edx,%eax
c0102d66:	c1 e0 02             	shl    $0x2,%eax
c0102d69:	01 c8                	add    %ecx,%eax
}
c0102d6b:	c9                   	leave  
c0102d6c:	c3                   	ret    

c0102d6d <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0102d6d:	55                   	push   %ebp
c0102d6e:	89 e5                	mov    %esp,%ebp
c0102d70:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0102d73:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d76:	89 04 24             	mov    %eax,(%esp)
c0102d79:	e8 8a ff ff ff       	call   c0102d08 <page2pa>
c0102d7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102d81:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d84:	c1 e8 0c             	shr    $0xc,%eax
c0102d87:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102d8a:	a1 a0 de 11 c0       	mov    0xc011dea0,%eax
c0102d8f:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0102d92:	72 23                	jb     c0102db7 <page2kva+0x4a>
c0102d94:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d97:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0102d9b:	c7 44 24 08 60 70 10 	movl   $0xc0107060,0x8(%esp)
c0102da2:	c0 
c0102da3:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0102daa:	00 
c0102dab:	c7 04 24 4f 70 10 c0 	movl   $0xc010704f,(%esp)
c0102db2:	e8 2f d6 ff ff       	call   c01003e6 <__panic>
c0102db7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102dba:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0102dbf:	c9                   	leave  
c0102dc0:	c3                   	ret    

c0102dc1 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0102dc1:	55                   	push   %ebp
c0102dc2:	89 e5                	mov    %esp,%ebp
c0102dc4:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0102dc7:	8b 45 08             	mov    0x8(%ebp),%eax
c0102dca:	83 e0 01             	and    $0x1,%eax
c0102dcd:	85 c0                	test   %eax,%eax
c0102dcf:	75 1c                	jne    c0102ded <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0102dd1:	c7 44 24 08 84 70 10 	movl   $0xc0107084,0x8(%esp)
c0102dd8:	c0 
c0102dd9:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0102de0:	00 
c0102de1:	c7 04 24 4f 70 10 c0 	movl   $0xc010704f,(%esp)
c0102de8:	e8 f9 d5 ff ff       	call   c01003e6 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0102ded:	8b 45 08             	mov    0x8(%ebp),%eax
c0102df0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0102df5:	89 04 24             	mov    %eax,(%esp)
c0102df8:	e8 21 ff ff ff       	call   c0102d1e <pa2page>
}
c0102dfd:	c9                   	leave  
c0102dfe:	c3                   	ret    

c0102dff <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c0102dff:	55                   	push   %ebp
c0102e00:	89 e5                	mov    %esp,%ebp
c0102e02:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c0102e05:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e08:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0102e0d:	89 04 24             	mov    %eax,(%esp)
c0102e10:	e8 09 ff ff ff       	call   c0102d1e <pa2page>
}
c0102e15:	c9                   	leave  
c0102e16:	c3                   	ret    

c0102e17 <page_ref>:

static inline int
page_ref(struct Page *page) {
c0102e17:	55                   	push   %ebp
c0102e18:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0102e1a:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e1d:	8b 00                	mov    (%eax),%eax
}
c0102e1f:	5d                   	pop    %ebp
c0102e20:	c3                   	ret    

c0102e21 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0102e21:	55                   	push   %ebp
c0102e22:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0102e24:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e27:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102e2a:	89 10                	mov    %edx,(%eax)
}
c0102e2c:	90                   	nop
c0102e2d:	5d                   	pop    %ebp
c0102e2e:	c3                   	ret    

c0102e2f <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0102e2f:	55                   	push   %ebp
c0102e30:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0102e32:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e35:	8b 00                	mov    (%eax),%eax
c0102e37:	8d 50 01             	lea    0x1(%eax),%edx
c0102e3a:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e3d:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0102e3f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e42:	8b 00                	mov    (%eax),%eax
}
c0102e44:	5d                   	pop    %ebp
c0102e45:	c3                   	ret    

c0102e46 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0102e46:	55                   	push   %ebp
c0102e47:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0102e49:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e4c:	8b 00                	mov    (%eax),%eax
c0102e4e:	8d 50 ff             	lea    -0x1(%eax),%edx
c0102e51:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e54:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0102e56:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e59:	8b 00                	mov    (%eax),%eax
}
c0102e5b:	5d                   	pop    %ebp
c0102e5c:	c3                   	ret    

c0102e5d <__intr_save>:
__intr_save(void) {
c0102e5d:	55                   	push   %ebp
c0102e5e:	89 e5                	mov    %esp,%ebp
c0102e60:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0102e63:	9c                   	pushf  
c0102e64:	58                   	pop    %eax
c0102e65:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0102e68:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0102e6b:	25 00 02 00 00       	and    $0x200,%eax
c0102e70:	85 c0                	test   %eax,%eax
c0102e72:	74 0c                	je     c0102e80 <__intr_save+0x23>
        intr_disable();
c0102e74:	e8 00 ea ff ff       	call   c0101879 <intr_disable>
        return 1;
c0102e79:	b8 01 00 00 00       	mov    $0x1,%eax
c0102e7e:	eb 05                	jmp    c0102e85 <__intr_save+0x28>
    return 0;
c0102e80:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0102e85:	c9                   	leave  
c0102e86:	c3                   	ret    

c0102e87 <__intr_restore>:
__intr_restore(bool flag) {
c0102e87:	55                   	push   %ebp
c0102e88:	89 e5                	mov    %esp,%ebp
c0102e8a:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0102e8d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102e91:	74 05                	je     c0102e98 <__intr_restore+0x11>
        intr_enable();
c0102e93:	e8 da e9 ff ff       	call   c0101872 <intr_enable>
}
c0102e98:	90                   	nop
c0102e99:	c9                   	leave  
c0102e9a:	c3                   	ret    

c0102e9b <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0102e9b:	55                   	push   %ebp
c0102e9c:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0102e9e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ea1:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0102ea4:	b8 23 00 00 00       	mov    $0x23,%eax
c0102ea9:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0102eab:	b8 23 00 00 00       	mov    $0x23,%eax
c0102eb0:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0102eb2:	b8 10 00 00 00       	mov    $0x10,%eax
c0102eb7:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0102eb9:	b8 10 00 00 00       	mov    $0x10,%eax
c0102ebe:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0102ec0:	b8 10 00 00 00       	mov    $0x10,%eax
c0102ec5:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0102ec7:	ea ce 2e 10 c0 08 00 	ljmp   $0x8,$0xc0102ece
}
c0102ece:	90                   	nop
c0102ecf:	5d                   	pop    %ebp
c0102ed0:	c3                   	ret    

c0102ed1 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0102ed1:	55                   	push   %ebp
c0102ed2:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0102ed4:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ed7:	a3 c4 de 11 c0       	mov    %eax,0xc011dec4
}
c0102edc:	90                   	nop
c0102edd:	5d                   	pop    %ebp
c0102ede:	c3                   	ret    

c0102edf <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0102edf:	55                   	push   %ebp
c0102ee0:	89 e5                	mov    %esp,%ebp
c0102ee2:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0102ee5:	b8 00 a0 11 c0       	mov    $0xc011a000,%eax
c0102eea:	89 04 24             	mov    %eax,(%esp)
c0102eed:	e8 df ff ff ff       	call   c0102ed1 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0102ef2:	66 c7 05 c8 de 11 c0 	movw   $0x10,0xc011dec8
c0102ef9:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0102efb:	66 c7 05 28 aa 11 c0 	movw   $0x68,0xc011aa28
c0102f02:	68 00 
c0102f04:	b8 c0 de 11 c0       	mov    $0xc011dec0,%eax
c0102f09:	0f b7 c0             	movzwl %ax,%eax
c0102f0c:	66 a3 2a aa 11 c0    	mov    %ax,0xc011aa2a
c0102f12:	b8 c0 de 11 c0       	mov    $0xc011dec0,%eax
c0102f17:	c1 e8 10             	shr    $0x10,%eax
c0102f1a:	a2 2c aa 11 c0       	mov    %al,0xc011aa2c
c0102f1f:	0f b6 05 2d aa 11 c0 	movzbl 0xc011aa2d,%eax
c0102f26:	24 f0                	and    $0xf0,%al
c0102f28:	0c 09                	or     $0x9,%al
c0102f2a:	a2 2d aa 11 c0       	mov    %al,0xc011aa2d
c0102f2f:	0f b6 05 2d aa 11 c0 	movzbl 0xc011aa2d,%eax
c0102f36:	24 ef                	and    $0xef,%al
c0102f38:	a2 2d aa 11 c0       	mov    %al,0xc011aa2d
c0102f3d:	0f b6 05 2d aa 11 c0 	movzbl 0xc011aa2d,%eax
c0102f44:	24 9f                	and    $0x9f,%al
c0102f46:	a2 2d aa 11 c0       	mov    %al,0xc011aa2d
c0102f4b:	0f b6 05 2d aa 11 c0 	movzbl 0xc011aa2d,%eax
c0102f52:	0c 80                	or     $0x80,%al
c0102f54:	a2 2d aa 11 c0       	mov    %al,0xc011aa2d
c0102f59:	0f b6 05 2e aa 11 c0 	movzbl 0xc011aa2e,%eax
c0102f60:	24 f0                	and    $0xf0,%al
c0102f62:	a2 2e aa 11 c0       	mov    %al,0xc011aa2e
c0102f67:	0f b6 05 2e aa 11 c0 	movzbl 0xc011aa2e,%eax
c0102f6e:	24 ef                	and    $0xef,%al
c0102f70:	a2 2e aa 11 c0       	mov    %al,0xc011aa2e
c0102f75:	0f b6 05 2e aa 11 c0 	movzbl 0xc011aa2e,%eax
c0102f7c:	24 df                	and    $0xdf,%al
c0102f7e:	a2 2e aa 11 c0       	mov    %al,0xc011aa2e
c0102f83:	0f b6 05 2e aa 11 c0 	movzbl 0xc011aa2e,%eax
c0102f8a:	0c 40                	or     $0x40,%al
c0102f8c:	a2 2e aa 11 c0       	mov    %al,0xc011aa2e
c0102f91:	0f b6 05 2e aa 11 c0 	movzbl 0xc011aa2e,%eax
c0102f98:	24 7f                	and    $0x7f,%al
c0102f9a:	a2 2e aa 11 c0       	mov    %al,0xc011aa2e
c0102f9f:	b8 c0 de 11 c0       	mov    $0xc011dec0,%eax
c0102fa4:	c1 e8 18             	shr    $0x18,%eax
c0102fa7:	a2 2f aa 11 c0       	mov    %al,0xc011aa2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0102fac:	c7 04 24 30 aa 11 c0 	movl   $0xc011aa30,(%esp)
c0102fb3:	e8 e3 fe ff ff       	call   c0102e9b <lgdt>
c0102fb8:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0102fbe:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0102fc2:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0102fc5:	90                   	nop
c0102fc6:	c9                   	leave  
c0102fc7:	c3                   	ret    

c0102fc8 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0102fc8:	55                   	push   %ebp
c0102fc9:	89 e5                	mov    %esp,%ebp
c0102fcb:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0102fce:	c7 05 30 df 11 c0 70 	movl   $0xc0107b70,0xc011df30
c0102fd5:	7b 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0102fd8:	a1 30 df 11 c0       	mov    0xc011df30,%eax
c0102fdd:	8b 00                	mov    (%eax),%eax
c0102fdf:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102fe3:	c7 04 24 b0 70 10 c0 	movl   $0xc01070b0,(%esp)
c0102fea:	e8 9f d2 ff ff       	call   c010028e <cprintf>
    pmm_manager->init();
c0102fef:	a1 30 df 11 c0       	mov    0xc011df30,%eax
c0102ff4:	8b 40 04             	mov    0x4(%eax),%eax
c0102ff7:	ff d0                	call   *%eax
}
c0102ff9:	90                   	nop
c0102ffa:	c9                   	leave  
c0102ffb:	c3                   	ret    

c0102ffc <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0102ffc:	55                   	push   %ebp
c0102ffd:	89 e5                	mov    %esp,%ebp
c0102fff:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0103002:	a1 30 df 11 c0       	mov    0xc011df30,%eax
c0103007:	8b 40 08             	mov    0x8(%eax),%eax
c010300a:	8b 55 0c             	mov    0xc(%ebp),%edx
c010300d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103011:	8b 55 08             	mov    0x8(%ebp),%edx
c0103014:	89 14 24             	mov    %edx,(%esp)
c0103017:	ff d0                	call   *%eax
}
c0103019:	90                   	nop
c010301a:	c9                   	leave  
c010301b:	c3                   	ret    

c010301c <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c010301c:	55                   	push   %ebp
c010301d:	89 e5                	mov    %esp,%ebp
c010301f:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0103022:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0103029:	e8 2f fe ff ff       	call   c0102e5d <__intr_save>
c010302e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0103031:	a1 30 df 11 c0       	mov    0xc011df30,%eax
c0103036:	8b 40 0c             	mov    0xc(%eax),%eax
c0103039:	8b 55 08             	mov    0x8(%ebp),%edx
c010303c:	89 14 24             	mov    %edx,(%esp)
c010303f:	ff d0                	call   *%eax
c0103041:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0103044:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103047:	89 04 24             	mov    %eax,(%esp)
c010304a:	e8 38 fe ff ff       	call   c0102e87 <__intr_restore>
    return page;
c010304f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103052:	c9                   	leave  
c0103053:	c3                   	ret    

c0103054 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0103054:	55                   	push   %ebp
c0103055:	89 e5                	mov    %esp,%ebp
c0103057:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c010305a:	e8 fe fd ff ff       	call   c0102e5d <__intr_save>
c010305f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0103062:	a1 30 df 11 c0       	mov    0xc011df30,%eax
c0103067:	8b 40 10             	mov    0x10(%eax),%eax
c010306a:	8b 55 0c             	mov    0xc(%ebp),%edx
c010306d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103071:	8b 55 08             	mov    0x8(%ebp),%edx
c0103074:	89 14 24             	mov    %edx,(%esp)
c0103077:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0103079:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010307c:	89 04 24             	mov    %eax,(%esp)
c010307f:	e8 03 fe ff ff       	call   c0102e87 <__intr_restore>
}
c0103084:	90                   	nop
c0103085:	c9                   	leave  
c0103086:	c3                   	ret    

c0103087 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0103087:	55                   	push   %ebp
c0103088:	89 e5                	mov    %esp,%ebp
c010308a:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c010308d:	e8 cb fd ff ff       	call   c0102e5d <__intr_save>
c0103092:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0103095:	a1 30 df 11 c0       	mov    0xc011df30,%eax
c010309a:	8b 40 14             	mov    0x14(%eax),%eax
c010309d:	ff d0                	call   *%eax
c010309f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c01030a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01030a5:	89 04 24             	mov    %eax,(%esp)
c01030a8:	e8 da fd ff ff       	call   c0102e87 <__intr_restore>
    return ret;
c01030ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01030b0:	c9                   	leave  
c01030b1:	c3                   	ret    

c01030b2 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c01030b2:	55                   	push   %ebp
c01030b3:	89 e5                	mov    %esp,%ebp
c01030b5:	57                   	push   %edi
c01030b6:	56                   	push   %esi
c01030b7:	53                   	push   %ebx
c01030b8:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c01030be:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c01030c5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c01030cc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c01030d3:	c7 04 24 c7 70 10 c0 	movl   $0xc01070c7,(%esp)
c01030da:	e8 af d1 ff ff       	call   c010028e <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c01030df:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01030e6:	e9 1a 01 00 00       	jmp    c0103205 <page_init+0x153>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c01030eb:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01030ee:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01030f1:	89 d0                	mov    %edx,%eax
c01030f3:	c1 e0 02             	shl    $0x2,%eax
c01030f6:	01 d0                	add    %edx,%eax
c01030f8:	c1 e0 02             	shl    $0x2,%eax
c01030fb:	01 c8                	add    %ecx,%eax
c01030fd:	8b 50 08             	mov    0x8(%eax),%edx
c0103100:	8b 40 04             	mov    0x4(%eax),%eax
c0103103:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0103106:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0103109:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010310c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010310f:	89 d0                	mov    %edx,%eax
c0103111:	c1 e0 02             	shl    $0x2,%eax
c0103114:	01 d0                	add    %edx,%eax
c0103116:	c1 e0 02             	shl    $0x2,%eax
c0103119:	01 c8                	add    %ecx,%eax
c010311b:	8b 48 0c             	mov    0xc(%eax),%ecx
c010311e:	8b 58 10             	mov    0x10(%eax),%ebx
c0103121:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103124:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103127:	01 c8                	add    %ecx,%eax
c0103129:	11 da                	adc    %ebx,%edx
c010312b:	89 45 b0             	mov    %eax,-0x50(%ebp)
c010312e:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0103131:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103134:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103137:	89 d0                	mov    %edx,%eax
c0103139:	c1 e0 02             	shl    $0x2,%eax
c010313c:	01 d0                	add    %edx,%eax
c010313e:	c1 e0 02             	shl    $0x2,%eax
c0103141:	01 c8                	add    %ecx,%eax
c0103143:	83 c0 14             	add    $0x14,%eax
c0103146:	8b 00                	mov    (%eax),%eax
c0103148:	89 45 84             	mov    %eax,-0x7c(%ebp)
c010314b:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010314e:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103151:	83 c0 ff             	add    $0xffffffff,%eax
c0103154:	83 d2 ff             	adc    $0xffffffff,%edx
c0103157:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
c010315d:	89 95 7c ff ff ff    	mov    %edx,-0x84(%ebp)
c0103163:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103166:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103169:	89 d0                	mov    %edx,%eax
c010316b:	c1 e0 02             	shl    $0x2,%eax
c010316e:	01 d0                	add    %edx,%eax
c0103170:	c1 e0 02             	shl    $0x2,%eax
c0103173:	01 c8                	add    %ecx,%eax
c0103175:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103178:	8b 58 10             	mov    0x10(%eax),%ebx
c010317b:	8b 55 84             	mov    -0x7c(%ebp),%edx
c010317e:	89 54 24 1c          	mov    %edx,0x1c(%esp)
c0103182:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
c0103188:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
c010318e:	89 44 24 14          	mov    %eax,0x14(%esp)
c0103192:	89 54 24 18          	mov    %edx,0x18(%esp)
c0103196:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103199:	8b 55 bc             	mov    -0x44(%ebp),%edx
c010319c:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01031a0:	89 54 24 10          	mov    %edx,0x10(%esp)
c01031a4:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c01031a8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c01031ac:	c7 04 24 d4 70 10 c0 	movl   $0xc01070d4,(%esp)
c01031b3:	e8 d6 d0 ff ff       	call   c010028e <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c01031b8:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01031bb:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01031be:	89 d0                	mov    %edx,%eax
c01031c0:	c1 e0 02             	shl    $0x2,%eax
c01031c3:	01 d0                	add    %edx,%eax
c01031c5:	c1 e0 02             	shl    $0x2,%eax
c01031c8:	01 c8                	add    %ecx,%eax
c01031ca:	83 c0 14             	add    $0x14,%eax
c01031cd:	8b 00                	mov    (%eax),%eax
c01031cf:	83 f8 01             	cmp    $0x1,%eax
c01031d2:	75 2e                	jne    c0103202 <page_init+0x150>
            if (maxpa < end && begin < KMEMSIZE) {
c01031d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01031d7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01031da:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c01031dd:	89 d0                	mov    %edx,%eax
c01031df:	1b 45 b4             	sbb    -0x4c(%ebp),%eax
c01031e2:	73 1e                	jae    c0103202 <page_init+0x150>
c01031e4:	ba ff ff ff 37       	mov    $0x37ffffff,%edx
c01031e9:	b8 00 00 00 00       	mov    $0x0,%eax
c01031ee:	3b 55 b8             	cmp    -0x48(%ebp),%edx
c01031f1:	1b 45 bc             	sbb    -0x44(%ebp),%eax
c01031f4:	72 0c                	jb     c0103202 <page_init+0x150>
                maxpa = end;
c01031f6:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01031f9:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01031fc:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01031ff:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
c0103202:	ff 45 dc             	incl   -0x24(%ebp)
c0103205:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103208:	8b 00                	mov    (%eax),%eax
c010320a:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c010320d:	0f 8c d8 fe ff ff    	jl     c01030eb <page_init+0x39>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0103213:	ba 00 00 00 38       	mov    $0x38000000,%edx
c0103218:	b8 00 00 00 00       	mov    $0x0,%eax
c010321d:	3b 55 e0             	cmp    -0x20(%ebp),%edx
c0103220:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
c0103223:	73 0e                	jae    c0103233 <page_init+0x181>
        maxpa = KMEMSIZE;
c0103225:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c010322c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0103233:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103236:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103239:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c010323d:	c1 ea 0c             	shr    $0xc,%edx
c0103240:	89 c1                	mov    %eax,%ecx
c0103242:	89 d3                	mov    %edx,%ebx
c0103244:	89 c8                	mov    %ecx,%eax
c0103246:	a3 a0 de 11 c0       	mov    %eax,0xc011dea0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c010324b:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0103252:	b8 48 df 11 c0       	mov    $0xc011df48,%eax
c0103257:	8d 50 ff             	lea    -0x1(%eax),%edx
c010325a:	8b 45 ac             	mov    -0x54(%ebp),%eax
c010325d:	01 d0                	add    %edx,%eax
c010325f:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0103262:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103265:	ba 00 00 00 00       	mov    $0x0,%edx
c010326a:	f7 75 ac             	divl   -0x54(%ebp)
c010326d:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103270:	29 d0                	sub    %edx,%eax
c0103272:	a3 38 df 11 c0       	mov    %eax,0xc011df38

    for (i = 0; i < npage; i ++) {
c0103277:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010327e:	eb 2e                	jmp    c01032ae <page_init+0x1fc>
        SetPageReserved(pages + i);
c0103280:	8b 0d 38 df 11 c0    	mov    0xc011df38,%ecx
c0103286:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103289:	89 d0                	mov    %edx,%eax
c010328b:	c1 e0 02             	shl    $0x2,%eax
c010328e:	01 d0                	add    %edx,%eax
c0103290:	c1 e0 02             	shl    $0x2,%eax
c0103293:	01 c8                	add    %ecx,%eax
c0103295:	83 c0 04             	add    $0x4,%eax
c0103298:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c010329f:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01032a2:	8b 45 8c             	mov    -0x74(%ebp),%eax
c01032a5:	8b 55 90             	mov    -0x70(%ebp),%edx
c01032a8:	0f ab 10             	bts    %edx,(%eax)
    for (i = 0; i < npage; i ++) {
c01032ab:	ff 45 dc             	incl   -0x24(%ebp)
c01032ae:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01032b1:	a1 a0 de 11 c0       	mov    0xc011dea0,%eax
c01032b6:	39 c2                	cmp    %eax,%edx
c01032b8:	72 c6                	jb     c0103280 <page_init+0x1ce>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c01032ba:	8b 15 a0 de 11 c0    	mov    0xc011dea0,%edx
c01032c0:	89 d0                	mov    %edx,%eax
c01032c2:	c1 e0 02             	shl    $0x2,%eax
c01032c5:	01 d0                	add    %edx,%eax
c01032c7:	c1 e0 02             	shl    $0x2,%eax
c01032ca:	89 c2                	mov    %eax,%edx
c01032cc:	a1 38 df 11 c0       	mov    0xc011df38,%eax
c01032d1:	01 d0                	add    %edx,%eax
c01032d3:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c01032d6:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c01032dd:	77 23                	ja     c0103302 <page_init+0x250>
c01032df:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c01032e2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01032e6:	c7 44 24 08 04 71 10 	movl   $0xc0107104,0x8(%esp)
c01032ed:	c0 
c01032ee:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
c01032f5:	00 
c01032f6:	c7 04 24 28 71 10 c0 	movl   $0xc0107128,(%esp)
c01032fd:	e8 e4 d0 ff ff       	call   c01003e6 <__panic>
c0103302:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0103305:	05 00 00 00 40       	add    $0x40000000,%eax
c010330a:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c010330d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103314:	e9 53 01 00 00       	jmp    c010346c <page_init+0x3ba>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103319:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010331c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010331f:	89 d0                	mov    %edx,%eax
c0103321:	c1 e0 02             	shl    $0x2,%eax
c0103324:	01 d0                	add    %edx,%eax
c0103326:	c1 e0 02             	shl    $0x2,%eax
c0103329:	01 c8                	add    %ecx,%eax
c010332b:	8b 50 08             	mov    0x8(%eax),%edx
c010332e:	8b 40 04             	mov    0x4(%eax),%eax
c0103331:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103334:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103337:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010333a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010333d:	89 d0                	mov    %edx,%eax
c010333f:	c1 e0 02             	shl    $0x2,%eax
c0103342:	01 d0                	add    %edx,%eax
c0103344:	c1 e0 02             	shl    $0x2,%eax
c0103347:	01 c8                	add    %ecx,%eax
c0103349:	8b 48 0c             	mov    0xc(%eax),%ecx
c010334c:	8b 58 10             	mov    0x10(%eax),%ebx
c010334f:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103352:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103355:	01 c8                	add    %ecx,%eax
c0103357:	11 da                	adc    %ebx,%edx
c0103359:	89 45 c8             	mov    %eax,-0x38(%ebp)
c010335c:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c010335f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103362:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103365:	89 d0                	mov    %edx,%eax
c0103367:	c1 e0 02             	shl    $0x2,%eax
c010336a:	01 d0                	add    %edx,%eax
c010336c:	c1 e0 02             	shl    $0x2,%eax
c010336f:	01 c8                	add    %ecx,%eax
c0103371:	83 c0 14             	add    $0x14,%eax
c0103374:	8b 00                	mov    (%eax),%eax
c0103376:	83 f8 01             	cmp    $0x1,%eax
c0103379:	0f 85 ea 00 00 00    	jne    c0103469 <page_init+0x3b7>
            if (begin < freemem) {
c010337f:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0103382:	ba 00 00 00 00       	mov    $0x0,%edx
c0103387:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c010338a:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c010338d:	19 d1                	sbb    %edx,%ecx
c010338f:	73 0d                	jae    c010339e <page_init+0x2ec>
                begin = freemem;
c0103391:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0103394:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103397:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c010339e:	ba 00 00 00 38       	mov    $0x38000000,%edx
c01033a3:	b8 00 00 00 00       	mov    $0x0,%eax
c01033a8:	3b 55 c8             	cmp    -0x38(%ebp),%edx
c01033ab:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c01033ae:	73 0e                	jae    c01033be <page_init+0x30c>
                end = KMEMSIZE;
c01033b0:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c01033b7:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c01033be:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01033c1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01033c4:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01033c7:	89 d0                	mov    %edx,%eax
c01033c9:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c01033cc:	0f 83 97 00 00 00    	jae    c0103469 <page_init+0x3b7>
                begin = ROUNDUP(begin, PGSIZE);
c01033d2:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c01033d9:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01033dc:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01033df:	01 d0                	add    %edx,%eax
c01033e1:	48                   	dec    %eax
c01033e2:	89 45 98             	mov    %eax,-0x68(%ebp)
c01033e5:	8b 45 98             	mov    -0x68(%ebp),%eax
c01033e8:	ba 00 00 00 00       	mov    $0x0,%edx
c01033ed:	f7 75 9c             	divl   -0x64(%ebp)
c01033f0:	8b 45 98             	mov    -0x68(%ebp),%eax
c01033f3:	29 d0                	sub    %edx,%eax
c01033f5:	ba 00 00 00 00       	mov    $0x0,%edx
c01033fa:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01033fd:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0103400:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103403:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0103406:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0103409:	ba 00 00 00 00       	mov    $0x0,%edx
c010340e:	89 c3                	mov    %eax,%ebx
c0103410:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
c0103416:	89 de                	mov    %ebx,%esi
c0103418:	89 d0                	mov    %edx,%eax
c010341a:	83 e0 00             	and    $0x0,%eax
c010341d:	89 c7                	mov    %eax,%edi
c010341f:	89 75 c8             	mov    %esi,-0x38(%ebp)
c0103422:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
c0103425:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103428:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010342b:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c010342e:	89 d0                	mov    %edx,%eax
c0103430:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c0103433:	73 34                	jae    c0103469 <page_init+0x3b7>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0103435:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103438:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010343b:	2b 45 d0             	sub    -0x30(%ebp),%eax
c010343e:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
c0103441:	89 c1                	mov    %eax,%ecx
c0103443:	89 d3                	mov    %edx,%ebx
c0103445:	89 c8                	mov    %ecx,%eax
c0103447:	89 da                	mov    %ebx,%edx
c0103449:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c010344d:	c1 ea 0c             	shr    $0xc,%edx
c0103450:	89 c3                	mov    %eax,%ebx
c0103452:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103455:	89 04 24             	mov    %eax,(%esp)
c0103458:	e8 c1 f8 ff ff       	call   c0102d1e <pa2page>
c010345d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0103461:	89 04 24             	mov    %eax,(%esp)
c0103464:	e8 93 fb ff ff       	call   c0102ffc <init_memmap>
    for (i = 0; i < memmap->nr_map; i ++) {
c0103469:	ff 45 dc             	incl   -0x24(%ebp)
c010346c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010346f:	8b 00                	mov    (%eax),%eax
c0103471:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0103474:	0f 8c 9f fe ff ff    	jl     c0103319 <page_init+0x267>
                }
            }
        }
    }
}
c010347a:	90                   	nop
c010347b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c0103481:	5b                   	pop    %ebx
c0103482:	5e                   	pop    %esi
c0103483:	5f                   	pop    %edi
c0103484:	5d                   	pop    %ebp
c0103485:	c3                   	ret    

c0103486 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0103486:	55                   	push   %ebp
c0103487:	89 e5                	mov    %esp,%ebp
c0103489:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c010348c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010348f:	33 45 14             	xor    0x14(%ebp),%eax
c0103492:	25 ff 0f 00 00       	and    $0xfff,%eax
c0103497:	85 c0                	test   %eax,%eax
c0103499:	74 24                	je     c01034bf <boot_map_segment+0x39>
c010349b:	c7 44 24 0c 36 71 10 	movl   $0xc0107136,0xc(%esp)
c01034a2:	c0 
c01034a3:	c7 44 24 08 4d 71 10 	movl   $0xc010714d,0x8(%esp)
c01034aa:	c0 
c01034ab:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
c01034b2:	00 
c01034b3:	c7 04 24 28 71 10 c0 	movl   $0xc0107128,(%esp)
c01034ba:	e8 27 cf ff ff       	call   c01003e6 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c01034bf:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c01034c6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01034c9:	25 ff 0f 00 00       	and    $0xfff,%eax
c01034ce:	89 c2                	mov    %eax,%edx
c01034d0:	8b 45 10             	mov    0x10(%ebp),%eax
c01034d3:	01 c2                	add    %eax,%edx
c01034d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01034d8:	01 d0                	add    %edx,%eax
c01034da:	48                   	dec    %eax
c01034db:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01034de:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01034e1:	ba 00 00 00 00       	mov    $0x0,%edx
c01034e6:	f7 75 f0             	divl   -0x10(%ebp)
c01034e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01034ec:	29 d0                	sub    %edx,%eax
c01034ee:	c1 e8 0c             	shr    $0xc,%eax
c01034f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c01034f4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01034f7:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01034fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01034fd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103502:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0103505:	8b 45 14             	mov    0x14(%ebp),%eax
c0103508:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010350b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010350e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103513:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0103516:	eb 68                	jmp    c0103580 <boot_map_segment+0xfa>
        pte_t *ptep = get_pte(pgdir, la, 1);
c0103518:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c010351f:	00 
c0103520:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103523:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103527:	8b 45 08             	mov    0x8(%ebp),%eax
c010352a:	89 04 24             	mov    %eax,(%esp)
c010352d:	e8 81 01 00 00       	call   c01036b3 <get_pte>
c0103532:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0103535:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0103539:	75 24                	jne    c010355f <boot_map_segment+0xd9>
c010353b:	c7 44 24 0c 62 71 10 	movl   $0xc0107162,0xc(%esp)
c0103542:	c0 
c0103543:	c7 44 24 08 4d 71 10 	movl   $0xc010714d,0x8(%esp)
c010354a:	c0 
c010354b:	c7 44 24 04 05 01 00 	movl   $0x105,0x4(%esp)
c0103552:	00 
c0103553:	c7 04 24 28 71 10 c0 	movl   $0xc0107128,(%esp)
c010355a:	e8 87 ce ff ff       	call   c01003e6 <__panic>
        *ptep = pa | PTE_P | perm;
c010355f:	8b 45 14             	mov    0x14(%ebp),%eax
c0103562:	0b 45 18             	or     0x18(%ebp),%eax
c0103565:	83 c8 01             	or     $0x1,%eax
c0103568:	89 c2                	mov    %eax,%edx
c010356a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010356d:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c010356f:	ff 4d f4             	decl   -0xc(%ebp)
c0103572:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c0103579:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0103580:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103584:	75 92                	jne    c0103518 <boot_map_segment+0x92>
    }
}
c0103586:	90                   	nop
c0103587:	c9                   	leave  
c0103588:	c3                   	ret    

c0103589 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c0103589:	55                   	push   %ebp
c010358a:	89 e5                	mov    %esp,%ebp
c010358c:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c010358f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103596:	e8 81 fa ff ff       	call   c010301c <alloc_pages>
c010359b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c010359e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01035a2:	75 1c                	jne    c01035c0 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c01035a4:	c7 44 24 08 6f 71 10 	movl   $0xc010716f,0x8(%esp)
c01035ab:	c0 
c01035ac:	c7 44 24 04 11 01 00 	movl   $0x111,0x4(%esp)
c01035b3:	00 
c01035b4:	c7 04 24 28 71 10 c0 	movl   $0xc0107128,(%esp)
c01035bb:	e8 26 ce ff ff       	call   c01003e6 <__panic>
    }
    return page2kva(p);
c01035c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035c3:	89 04 24             	mov    %eax,(%esp)
c01035c6:	e8 a2 f7 ff ff       	call   c0102d6d <page2kva>
}
c01035cb:	c9                   	leave  
c01035cc:	c3                   	ret    

c01035cd <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c01035cd:	55                   	push   %ebp
c01035ce:	89 e5                	mov    %esp,%ebp
c01035d0:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
c01035d3:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c01035d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01035db:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01035e2:	77 23                	ja     c0103607 <pmm_init+0x3a>
c01035e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035e7:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01035eb:	c7 44 24 08 04 71 10 	movl   $0xc0107104,0x8(%esp)
c01035f2:	c0 
c01035f3:	c7 44 24 04 1b 01 00 	movl   $0x11b,0x4(%esp)
c01035fa:	00 
c01035fb:	c7 04 24 28 71 10 c0 	movl   $0xc0107128,(%esp)
c0103602:	e8 df cd ff ff       	call   c01003e6 <__panic>
c0103607:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010360a:	05 00 00 00 40       	add    $0x40000000,%eax
c010360f:	a3 34 df 11 c0       	mov    %eax,0xc011df34
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0103614:	e8 af f9 ff ff       	call   c0102fc8 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c0103619:	e8 94 fa ff ff       	call   c01030b2 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c010361e:	e8 fb 05 00 00       	call   c0103c1e <check_alloc_page>

    check_pgdir();
c0103623:	e8 15 06 00 00       	call   c0103c3d <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0103628:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c010362d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103630:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0103637:	77 23                	ja     c010365c <pmm_init+0x8f>
c0103639:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010363c:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103640:	c7 44 24 08 04 71 10 	movl   $0xc0107104,0x8(%esp)
c0103647:	c0 
c0103648:	c7 44 24 04 31 01 00 	movl   $0x131,0x4(%esp)
c010364f:	00 
c0103650:	c7 04 24 28 71 10 c0 	movl   $0xc0107128,(%esp)
c0103657:	e8 8a cd ff ff       	call   c01003e6 <__panic>
c010365c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010365f:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
c0103665:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c010366a:	05 ac 0f 00 00       	add    $0xfac,%eax
c010366f:	83 ca 03             	or     $0x3,%edx
c0103672:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c0103674:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0103679:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c0103680:	00 
c0103681:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0103688:	00 
c0103689:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c0103690:	38 
c0103691:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c0103698:	c0 
c0103699:	89 04 24             	mov    %eax,(%esp)
c010369c:	e8 e5 fd ff ff       	call   c0103486 <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c01036a1:	e8 39 f8 ff ff       	call   c0102edf <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c01036a6:	e8 2e 0c 00 00       	call   c01042d9 <check_boot_pgdir>

    print_pgdir();
c01036ab:	e8 a7 10 00 00       	call   c0104757 <print_pgdir>

}
c01036b0:	90                   	nop
c01036b1:	c9                   	leave  
c01036b2:	c3                   	ret    

c01036b3 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c01036b3:	55                   	push   %ebp
c01036b4:	89 e5                	mov    %esp,%ebp
c01036b6:	83 ec 68             	sub    $0x68,%esp
     *   PTE_W           0x002                   // page table/directory entry flags bit : Writeable
     *   PTE_U           0x004                   // page table/directory entry flags bit : User can access
     */
	
// #if 0
	assert(pgdir != NULL);
c01036b9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01036bd:	75 24                	jne    c01036e3 <get_pte+0x30>
c01036bf:	c7 44 24 0c 88 71 10 	movl   $0xc0107188,0xc(%esp)
c01036c6:	c0 
c01036c7:	c7 44 24 08 4d 71 10 	movl   $0xc010714d,0x8(%esp)
c01036ce:	c0 
c01036cf:	c7 44 24 04 65 01 00 	movl   $0x165,0x4(%esp)
c01036d6:	00 
c01036d7:	c7 04 24 28 71 10 c0 	movl   $0xc0107128,(%esp)
c01036de:	e8 03 cd ff ff       	call   c01003e6 <__panic>
	struct Page *struct_page_vp;	// virtual address of struct page
	uint32_t pdx = PDX(la), ptx = PTX(la);	// index of PDE, PTE
c01036e3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01036e6:	c1 e8 16             	shr    $0x16,%eax
c01036e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01036ec:	8b 45 0c             	mov    0xc(%ebp),%eax
c01036ef:	c1 e8 0c             	shr    $0xc,%eax
c01036f2:	25 ff 03 00 00       	and    $0x3ff,%eax
c01036f7:	89 45 f0             	mov    %eax,-0x10(%ebp)

    pde_t *pdep, *ptep;   // (1) find page directory entry
	pte_t *page_pa;			// physical address of page
	pdep = pgdir + pdx;
c01036fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036fd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0103704:	8b 45 08             	mov    0x8(%ebp),%eax
c0103707:	01 d0                	add    %edx,%eax
c0103709:	89 45 ec             	mov    %eax,-0x14(%ebp)
	ptep = (pte_t *)KADDR(PDE_ADDR(*pdep)) + ptx;
c010370c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010370f:	8b 00                	mov    (%eax),%eax
c0103711:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103716:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103719:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010371c:	c1 e8 0c             	shr    $0xc,%eax
c010371f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103722:	a1 a0 de 11 c0       	mov    0xc011dea0,%eax
c0103727:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c010372a:	72 23                	jb     c010374f <get_pte+0x9c>
c010372c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010372f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103733:	c7 44 24 08 60 70 10 	movl   $0xc0107060,0x8(%esp)
c010373a:	c0 
c010373b:	c7 44 24 04 6c 01 00 	movl   $0x16c,0x4(%esp)
c0103742:	00 
c0103743:	c7 04 24 28 71 10 c0 	movl   $0xc0107128,(%esp)
c010374a:	e8 97 cc ff ff       	call   c01003e6 <__panic>
c010374f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103752:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103757:	89 c2                	mov    %eax,%edx
c0103759:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010375c:	c1 e0 02             	shl    $0x2,%eax
c010375f:	01 d0                	add    %edx,%eax
c0103761:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103764:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
c010376b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010376e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103771:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103774:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0103777:	0f a3 10             	bt     %edx,(%eax)
c010377a:	19 c0                	sbb    %eax,%eax
c010377c:	89 45 c0             	mov    %eax,-0x40(%ebp)
    return oldbit != 0;
c010377f:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
c0103783:	0f 95 c0             	setne  %al
c0103786:	0f b6 c0             	movzbl %al,%eax

	// if PDE exists 
	if (test_bit(0, pdep)) {
c0103789:	85 c0                	test   %eax,%eax
c010378b:	74 08                	je     c0103795 <get_pte+0xe2>
		return ptep;
c010378d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103790:	e9 4d 01 00 00       	jmp    c01038e2 <get_pte+0x22f>
c0103795:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
c010379c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010379f:	89 45 b8             	mov    %eax,-0x48(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01037a2:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01037a5:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01037a8:	0f a3 10             	bt     %edx,(%eax)
c01037ab:	19 c0                	sbb    %eax,%eax
c01037ad:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    return oldbit != 0;
c01037b0:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
c01037b4:	0f 95 c0             	setne  %al
c01037b7:	0f b6 c0             	movzbl %al,%eax
	}
	/* if PDE not exsits, allocate one page for PT and create corresponding PDE */
    if ((!test_bit(0, pdep)) && create) {              // (2) check if entry is not present
c01037ba:	85 c0                	test   %eax,%eax
c01037bc:	0f 85 1b 01 00 00    	jne    c01038dd <get_pte+0x22a>
c01037c2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01037c6:	0f 84 11 01 00 00    	je     c01038dd <get_pte+0x22a>
		struct_page_vp = alloc_page();
c01037cc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01037d3:	e8 44 f8 ff ff       	call   c010301c <alloc_pages>
c01037d8:	89 45 dc             	mov    %eax,-0x24(%ebp)
		assert(struct_page_vp != NULL);
c01037db:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01037df:	75 24                	jne    c0103805 <get_pte+0x152>
c01037e1:	c7 44 24 0c 96 71 10 	movl   $0xc0107196,0xc(%esp)
c01037e8:	c0 
c01037e9:	c7 44 24 08 4d 71 10 	movl   $0xc010714d,0x8(%esp)
c01037f0:	c0 
c01037f1:	c7 44 24 04 75 01 00 	movl   $0x175,0x4(%esp)
c01037f8:	00 
c01037f9:	c7 04 24 28 71 10 c0 	movl   $0xc0107128,(%esp)
c0103800:	e8 e1 cb ff ff       	call   c01003e6 <__panic>
		set_page_ref(struct_page_vp, 1);
c0103805:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010380c:	00 
c010380d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103810:	89 04 24             	mov    %eax,(%esp)
c0103813:	e8 09 f6 ff ff       	call   c0102e21 <set_page_ref>
		page_pa = (pte_t *)page2pa(struct_page_vp);
c0103818:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010381b:	89 04 24             	mov    %eax,(%esp)
c010381e:	e8 e5 f4 ff ff       	call   c0102d08 <page2pa>
c0103823:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptep = KADDR(page_pa + ptx);
c0103826:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103829:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0103830:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103833:	01 d0                	add    %edx,%eax
c0103835:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0103838:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010383b:	c1 e8 0c             	shr    $0xc,%eax
c010383e:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103841:	a1 a0 de 11 c0       	mov    0xc011dea0,%eax
c0103846:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c0103849:	72 23                	jb     c010386e <get_pte+0x1bb>
c010384b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010384e:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103852:	c7 44 24 08 60 70 10 	movl   $0xc0107060,0x8(%esp)
c0103859:	c0 
c010385a:	c7 44 24 04 78 01 00 	movl   $0x178,0x4(%esp)
c0103861:	00 
c0103862:	c7 04 24 28 71 10 c0 	movl   $0xc0107128,(%esp)
c0103869:	e8 78 cb ff ff       	call   c01003e6 <__panic>
c010386e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103871:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103876:	89 45 e0             	mov    %eax,-0x20(%ebp)
		*pdep = (PADDR(ptep)) | PTE_P | PTE_U | PTE_W;
c0103879:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010387c:	89 45 cc             	mov    %eax,-0x34(%ebp)
c010387f:	81 7d cc ff ff ff bf 	cmpl   $0xbfffffff,-0x34(%ebp)
c0103886:	77 23                	ja     c01038ab <get_pte+0x1f8>
c0103888:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010388b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010388f:	c7 44 24 08 04 71 10 	movl   $0xc0107104,0x8(%esp)
c0103896:	c0 
c0103897:	c7 44 24 04 79 01 00 	movl   $0x179,0x4(%esp)
c010389e:	00 
c010389f:	c7 04 24 28 71 10 c0 	movl   $0xc0107128,(%esp)
c01038a6:	e8 3b cb ff ff       	call   c01003e6 <__panic>
c01038ab:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01038ae:	05 00 00 00 40       	add    $0x40000000,%eax
c01038b3:	83 c8 07             	or     $0x7,%eax
c01038b6:	89 c2                	mov    %eax,%edx
c01038b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01038bb:	89 10                	mov    %edx,(%eax)
		memset(ptep, 0, PGSIZE);
c01038bd:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01038c4:	00 
c01038c5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01038cc:	00 
c01038cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01038d0:	89 04 24             	mov    %eax,(%esp)
c01038d3:	e8 fd 27 00 00       	call   c01060d5 <memset>
		return ptep;
c01038d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01038db:	eb 05                	jmp    c01038e2 <get_pte+0x22f>
							// (5) get linear address of page
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    
	// if PDE not exists and caller don't require get_pte allocate PTE.
    return NULL;          // (8) return page table entry
c01038dd:	b8 00 00 00 00       	mov    $0x0,%eax
// #endif
}
c01038e2:	c9                   	leave  
c01038e3:	c3                   	ret    

c01038e4 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c01038e4:	55                   	push   %ebp
c01038e5:	89 e5                	mov    %esp,%ebp
c01038e7:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01038ea:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01038f1:	00 
c01038f2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01038f5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01038f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01038fc:	89 04 24             	mov    %eax,(%esp)
c01038ff:	e8 af fd ff ff       	call   c01036b3 <get_pte>
c0103904:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c0103907:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010390b:	74 08                	je     c0103915 <get_page+0x31>
        *ptep_store = ptep;
c010390d:	8b 45 10             	mov    0x10(%ebp),%eax
c0103910:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103913:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0103915:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103919:	74 1b                	je     c0103936 <get_page+0x52>
c010391b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010391e:	8b 00                	mov    (%eax),%eax
c0103920:	83 e0 01             	and    $0x1,%eax
c0103923:	85 c0                	test   %eax,%eax
c0103925:	74 0f                	je     c0103936 <get_page+0x52>
        return pte2page(*ptep);
c0103927:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010392a:	8b 00                	mov    (%eax),%eax
c010392c:	89 04 24             	mov    %eax,(%esp)
c010392f:	e8 8d f4 ff ff       	call   c0102dc1 <pte2page>
c0103934:	eb 05                	jmp    c010393b <get_page+0x57>
    }
    return NULL;
c0103936:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010393b:	c9                   	leave  
c010393c:	c3                   	ret    

c010393d <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c010393d:	55                   	push   %ebp
c010393e:	89 e5                	mov    %esp,%ebp
c0103940:	83 ec 48             	sub    $0x48,%esp
     *                        edited are the ones currently in use by the processor.
     * DEFINEs:
     *   PTE_P           0x001                   // page table/directory entry flags bit : Present
     */
// #if 0
	assert(pgdir != NULL);
c0103943:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103947:	75 24                	jne    c010396d <page_remove_pte+0x30>
c0103949:	c7 44 24 0c 88 71 10 	movl   $0xc0107188,0xc(%esp)
c0103950:	c0 
c0103951:	c7 44 24 08 4d 71 10 	movl   $0xc010714d,0x8(%esp)
c0103958:	c0 
c0103959:	c7 44 24 04 b5 01 00 	movl   $0x1b5,0x4(%esp)
c0103960:	00 
c0103961:	c7 04 24 28 71 10 c0 	movl   $0xc0107128,(%esp)
c0103968:	e8 79 ca ff ff       	call   c01003e6 <__panic>
	assert(ptep != NULL);
c010396d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0103971:	75 24                	jne    c0103997 <page_remove_pte+0x5a>
c0103973:	c7 44 24 0c 62 71 10 	movl   $0xc0107162,0xc(%esp)
c010397a:	c0 
c010397b:	c7 44 24 08 4d 71 10 	movl   $0xc010714d,0x8(%esp)
c0103982:	c0 
c0103983:	c7 44 24 04 b6 01 00 	movl   $0x1b6,0x4(%esp)
c010398a:	00 
c010398b:	c7 04 24 28 71 10 c0 	movl   $0xc0107128,(%esp)
c0103992:	e8 4f ca ff ff       	call   c01003e6 <__panic>
	pde_t *pdep = pgdir + PDX(la);
c0103997:	8b 45 0c             	mov    0xc(%ebp),%eax
c010399a:	c1 e8 16             	shr    $0x16,%eax
c010399d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01039a4:	8b 45 08             	mov    0x8(%ebp),%eax
c01039a7:	01 d0                	add    %edx,%eax
c01039a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	assert(PDE_ADDR(*pdep) == PADDR(ROUNDDOWN(ptep, PGSIZE)));
c01039ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039af:	8b 00                	mov    (%eax),%eax
c01039b1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01039b6:	89 c2                	mov    %eax,%edx
c01039b8:	8b 45 10             	mov    0x10(%ebp),%eax
c01039bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01039be:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01039c1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01039c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01039c9:	81 7d ec ff ff ff bf 	cmpl   $0xbfffffff,-0x14(%ebp)
c01039d0:	77 23                	ja     c01039f5 <page_remove_pte+0xb8>
c01039d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01039d5:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01039d9:	c7 44 24 08 04 71 10 	movl   $0xc0107104,0x8(%esp)
c01039e0:	c0 
c01039e1:	c7 44 24 04 b8 01 00 	movl   $0x1b8,0x4(%esp)
c01039e8:	00 
c01039e9:	c7 04 24 28 71 10 c0 	movl   $0xc0107128,(%esp)
c01039f0:	e8 f1 c9 ff ff       	call   c01003e6 <__panic>
c01039f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01039f8:	05 00 00 00 40       	add    $0x40000000,%eax
c01039fd:	39 d0                	cmp    %edx,%eax
c01039ff:	74 24                	je     c0103a25 <page_remove_pte+0xe8>
c0103a01:	c7 44 24 0c b0 71 10 	movl   $0xc01071b0,0xc(%esp)
c0103a08:	c0 
c0103a09:	c7 44 24 08 4d 71 10 	movl   $0xc010714d,0x8(%esp)
c0103a10:	c0 
c0103a11:	c7 44 24 04 b8 01 00 	movl   $0x1b8,0x4(%esp)
c0103a18:	00 
c0103a19:	c7 04 24 28 71 10 c0 	movl   $0xc0107128,(%esp)
c0103a20:	e8 c1 c9 ff ff       	call   c01003e6 <__panic>
c0103a25:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c0103a2c:	8b 45 10             	mov    0x10(%ebp),%eax
c0103a2f:	89 45 e0             	mov    %eax,-0x20(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103a32:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103a35:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103a38:	0f a3 10             	bt     %edx,(%eax)
c0103a3b:	19 c0                	sbb    %eax,%eax
c0103a3d:	89 45 dc             	mov    %eax,-0x24(%ebp)
    return oldbit != 0;
c0103a40:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0103a44:	0f 95 c0             	setne  %al
c0103a47:	0f b6 c0             	movzbl %al,%eax
    if (test_bit(0, ptep)) {                      //(1) check if this page table entry is present
c0103a4a:	85 c0                	test   %eax,%eax
c0103a4c:	74 67                	je     c0103ab5 <page_remove_pte+0x178>
        struct Page *page = pte2page(*ptep); //(2) find corresponding page to pte
c0103a4e:	8b 45 10             	mov    0x10(%ebp),%eax
c0103a51:	8b 00                	mov    (%eax),%eax
c0103a53:	89 04 24             	mov    %eax,(%esp)
c0103a56:	e8 66 f3 ff ff       	call   c0102dc1 <pte2page>
c0103a5b:	89 45 e8             	mov    %eax,-0x18(%ebp)
        page_ref_dec(page);                          //(3) decrease page reference
c0103a5e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103a61:	89 04 24             	mov    %eax,(%esp)
c0103a64:	e8 dd f3 ff ff       	call   c0102e46 <page_ref_dec>
        if (page_ref(page) == 0)
c0103a69:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103a6c:	89 04 24             	mov    %eax,(%esp)
c0103a6f:	e8 a3 f3 ff ff       	call   c0102e17 <page_ref>
c0103a74:	85 c0                	test   %eax,%eax
c0103a76:	75 13                	jne    c0103a8b <page_remove_pte+0x14e>
			free_page(page);			//(4) and free this page when page reference reachs 0
c0103a78:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103a7f:	00 
c0103a80:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103a83:	89 04 24             	mov    %eax,(%esp)
c0103a86:	e8 c9 f5 ff ff       	call   c0103054 <free_pages>
c0103a8b:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
c0103a92:	8b 45 10             	mov    0x10(%ebp),%eax
c0103a95:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103a98:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103a9b:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0103a9e:	0f b3 10             	btr    %edx,(%eax)
        clear_bit(PTE_P, ptep);                        //(5) clear second page table entry
        tlb_invalidate(pgdir, la);                          //(6) flush tlb
c0103aa1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103aa4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103aa8:	8b 45 08             	mov    0x8(%ebp),%eax
c0103aab:	89 04 24             	mov    %eax,(%esp)
c0103aae:	e8 0f 01 00 00       	call   c0103bc2 <tlb_invalidate>
    }
	else 
		cprintf("test_bit(PTE_P, ptep) error\n");
// #endif
}
c0103ab3:	eb 0c                	jmp    c0103ac1 <page_remove_pte+0x184>
		cprintf("test_bit(PTE_P, ptep) error\n");
c0103ab5:	c7 04 24 e2 71 10 c0 	movl   $0xc01071e2,(%esp)
c0103abc:	e8 cd c7 ff ff       	call   c010028e <cprintf>
}
c0103ac1:	90                   	nop
c0103ac2:	c9                   	leave  
c0103ac3:	c3                   	ret    

c0103ac4 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c0103ac4:	55                   	push   %ebp
c0103ac5:	89 e5                	mov    %esp,%ebp
c0103ac7:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0103aca:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103ad1:	00 
c0103ad2:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103ad5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103ad9:	8b 45 08             	mov    0x8(%ebp),%eax
c0103adc:	89 04 24             	mov    %eax,(%esp)
c0103adf:	e8 cf fb ff ff       	call   c01036b3 <get_pte>
c0103ae4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c0103ae7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103aeb:	74 19                	je     c0103b06 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c0103aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103af0:	89 44 24 08          	mov    %eax,0x8(%esp)
c0103af4:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103af7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103afb:	8b 45 08             	mov    0x8(%ebp),%eax
c0103afe:	89 04 24             	mov    %eax,(%esp)
c0103b01:	e8 37 fe ff ff       	call   c010393d <page_remove_pte>
    }
}
c0103b06:	90                   	nop
c0103b07:	c9                   	leave  
c0103b08:	c3                   	ret    

c0103b09 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c0103b09:	55                   	push   %ebp
c0103b0a:	89 e5                	mov    %esp,%ebp
c0103b0c:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0103b0f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0103b16:	00 
c0103b17:	8b 45 10             	mov    0x10(%ebp),%eax
c0103b1a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103b1e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b21:	89 04 24             	mov    %eax,(%esp)
c0103b24:	e8 8a fb ff ff       	call   c01036b3 <get_pte>
c0103b29:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c0103b2c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103b30:	75 0a                	jne    c0103b3c <page_insert+0x33>
        return -E_NO_MEM;
c0103b32:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0103b37:	e9 84 00 00 00       	jmp    c0103bc0 <page_insert+0xb7>
    }
    page_ref_inc(page);
c0103b3c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103b3f:	89 04 24             	mov    %eax,(%esp)
c0103b42:	e8 e8 f2 ff ff       	call   c0102e2f <page_ref_inc>
    if (*ptep & PTE_P) {
c0103b47:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b4a:	8b 00                	mov    (%eax),%eax
c0103b4c:	83 e0 01             	and    $0x1,%eax
c0103b4f:	85 c0                	test   %eax,%eax
c0103b51:	74 3e                	je     c0103b91 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c0103b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b56:	8b 00                	mov    (%eax),%eax
c0103b58:	89 04 24             	mov    %eax,(%esp)
c0103b5b:	e8 61 f2 ff ff       	call   c0102dc1 <pte2page>
c0103b60:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c0103b63:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103b66:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103b69:	75 0d                	jne    c0103b78 <page_insert+0x6f>
            page_ref_dec(page);
c0103b6b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103b6e:	89 04 24             	mov    %eax,(%esp)
c0103b71:	e8 d0 f2 ff ff       	call   c0102e46 <page_ref_dec>
c0103b76:	eb 19                	jmp    c0103b91 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0103b78:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b7b:	89 44 24 08          	mov    %eax,0x8(%esp)
c0103b7f:	8b 45 10             	mov    0x10(%ebp),%eax
c0103b82:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103b86:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b89:	89 04 24             	mov    %eax,(%esp)
c0103b8c:	e8 ac fd ff ff       	call   c010393d <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0103b91:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103b94:	89 04 24             	mov    %eax,(%esp)
c0103b97:	e8 6c f1 ff ff       	call   c0102d08 <page2pa>
c0103b9c:	0b 45 14             	or     0x14(%ebp),%eax
c0103b9f:	83 c8 01             	or     $0x1,%eax
c0103ba2:	89 c2                	mov    %eax,%edx
c0103ba4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ba7:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c0103ba9:	8b 45 10             	mov    0x10(%ebp),%eax
c0103bac:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103bb0:	8b 45 08             	mov    0x8(%ebp),%eax
c0103bb3:	89 04 24             	mov    %eax,(%esp)
c0103bb6:	e8 07 00 00 00       	call   c0103bc2 <tlb_invalidate>
    return 0;
c0103bbb:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103bc0:	c9                   	leave  
c0103bc1:	c3                   	ret    

c0103bc2 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c0103bc2:	55                   	push   %ebp
c0103bc3:	89 e5                	mov    %esp,%ebp
c0103bc5:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c0103bc8:	0f 20 d8             	mov    %cr3,%eax
c0103bcb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c0103bce:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
c0103bd1:	8b 45 08             	mov    0x8(%ebp),%eax
c0103bd4:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103bd7:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0103bde:	77 23                	ja     c0103c03 <tlb_invalidate+0x41>
c0103be0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103be3:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103be7:	c7 44 24 08 04 71 10 	movl   $0xc0107104,0x8(%esp)
c0103bee:	c0 
c0103bef:	c7 44 24 04 f0 01 00 	movl   $0x1f0,0x4(%esp)
c0103bf6:	00 
c0103bf7:	c7 04 24 28 71 10 c0 	movl   $0xc0107128,(%esp)
c0103bfe:	e8 e3 c7 ff ff       	call   c01003e6 <__panic>
c0103c03:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c06:	05 00 00 00 40       	add    $0x40000000,%eax
c0103c0b:	39 d0                	cmp    %edx,%eax
c0103c0d:	75 0c                	jne    c0103c1b <tlb_invalidate+0x59>
        invlpg((void *)la);
c0103c0f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103c12:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c0103c15:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103c18:	0f 01 38             	invlpg (%eax)
    }
}
c0103c1b:	90                   	nop
c0103c1c:	c9                   	leave  
c0103c1d:	c3                   	ret    

c0103c1e <check_alloc_page>:

static void
check_alloc_page(void) {
c0103c1e:	55                   	push   %ebp
c0103c1f:	89 e5                	mov    %esp,%ebp
c0103c21:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c0103c24:	a1 30 df 11 c0       	mov    0xc011df30,%eax
c0103c29:	8b 40 18             	mov    0x18(%eax),%eax
c0103c2c:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c0103c2e:	c7 04 24 00 72 10 c0 	movl   $0xc0107200,(%esp)
c0103c35:	e8 54 c6 ff ff       	call   c010028e <cprintf>
}
c0103c3a:	90                   	nop
c0103c3b:	c9                   	leave  
c0103c3c:	c3                   	ret    

c0103c3d <check_pgdir>:

static void
check_pgdir(void) {
c0103c3d:	55                   	push   %ebp
c0103c3e:	89 e5                	mov    %esp,%ebp
c0103c40:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c0103c43:	a1 a0 de 11 c0       	mov    0xc011dea0,%eax
c0103c48:	3d 00 80 03 00       	cmp    $0x38000,%eax
c0103c4d:	76 24                	jbe    c0103c73 <check_pgdir+0x36>
c0103c4f:	c7 44 24 0c 1f 72 10 	movl   $0xc010721f,0xc(%esp)
c0103c56:	c0 
c0103c57:	c7 44 24 08 4d 71 10 	movl   $0xc010714d,0x8(%esp)
c0103c5e:	c0 
c0103c5f:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
c0103c66:	00 
c0103c67:	c7 04 24 28 71 10 c0 	movl   $0xc0107128,(%esp)
c0103c6e:	e8 73 c7 ff ff       	call   c01003e6 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c0103c73:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0103c78:	85 c0                	test   %eax,%eax
c0103c7a:	74 0e                	je     c0103c8a <check_pgdir+0x4d>
c0103c7c:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0103c81:	25 ff 0f 00 00       	and    $0xfff,%eax
c0103c86:	85 c0                	test   %eax,%eax
c0103c88:	74 24                	je     c0103cae <check_pgdir+0x71>
c0103c8a:	c7 44 24 0c 3c 72 10 	movl   $0xc010723c,0xc(%esp)
c0103c91:	c0 
c0103c92:	c7 44 24 08 4d 71 10 	movl   $0xc010714d,0x8(%esp)
c0103c99:	c0 
c0103c9a:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
c0103ca1:	00 
c0103ca2:	c7 04 24 28 71 10 c0 	movl   $0xc0107128,(%esp)
c0103ca9:	e8 38 c7 ff ff       	call   c01003e6 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0103cae:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0103cb3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103cba:	00 
c0103cbb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103cc2:	00 
c0103cc3:	89 04 24             	mov    %eax,(%esp)
c0103cc6:	e8 19 fc ff ff       	call   c01038e4 <get_page>
c0103ccb:	85 c0                	test   %eax,%eax
c0103ccd:	74 24                	je     c0103cf3 <check_pgdir+0xb6>
c0103ccf:	c7 44 24 0c 74 72 10 	movl   $0xc0107274,0xc(%esp)
c0103cd6:	c0 
c0103cd7:	c7 44 24 08 4d 71 10 	movl   $0xc010714d,0x8(%esp)
c0103cde:	c0 
c0103cdf:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
c0103ce6:	00 
c0103ce7:	c7 04 24 28 71 10 c0 	movl   $0xc0107128,(%esp)
c0103cee:	e8 f3 c6 ff ff       	call   c01003e6 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0103cf3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103cfa:	e8 1d f3 ff ff       	call   c010301c <alloc_pages>
c0103cff:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0103d02:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0103d07:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0103d0e:	00 
c0103d0f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103d16:	00 
c0103d17:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103d1a:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103d1e:	89 04 24             	mov    %eax,(%esp)
c0103d21:	e8 e3 fd ff ff       	call   c0103b09 <page_insert>
c0103d26:	85 c0                	test   %eax,%eax
c0103d28:	74 24                	je     c0103d4e <check_pgdir+0x111>
c0103d2a:	c7 44 24 0c 9c 72 10 	movl   $0xc010729c,0xc(%esp)
c0103d31:	c0 
c0103d32:	c7 44 24 08 4d 71 10 	movl   $0xc010714d,0x8(%esp)
c0103d39:	c0 
c0103d3a:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
c0103d41:	00 
c0103d42:	c7 04 24 28 71 10 c0 	movl   $0xc0107128,(%esp)
c0103d49:	e8 98 c6 ff ff       	call   c01003e6 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0103d4e:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0103d53:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103d5a:	00 
c0103d5b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103d62:	00 
c0103d63:	89 04 24             	mov    %eax,(%esp)
c0103d66:	e8 48 f9 ff ff       	call   c01036b3 <get_pte>
c0103d6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103d6e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103d72:	75 24                	jne    c0103d98 <check_pgdir+0x15b>
c0103d74:	c7 44 24 0c c8 72 10 	movl   $0xc01072c8,0xc(%esp)
c0103d7b:	c0 
c0103d7c:	c7 44 24 08 4d 71 10 	movl   $0xc010714d,0x8(%esp)
c0103d83:	c0 
c0103d84:	c7 44 24 04 06 02 00 	movl   $0x206,0x4(%esp)
c0103d8b:	00 
c0103d8c:	c7 04 24 28 71 10 c0 	movl   $0xc0107128,(%esp)
c0103d93:	e8 4e c6 ff ff       	call   c01003e6 <__panic>
    assert(pte2page(*ptep) == p1);
c0103d98:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103d9b:	8b 00                	mov    (%eax),%eax
c0103d9d:	89 04 24             	mov    %eax,(%esp)
c0103da0:	e8 1c f0 ff ff       	call   c0102dc1 <pte2page>
c0103da5:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0103da8:	74 24                	je     c0103dce <check_pgdir+0x191>
c0103daa:	c7 44 24 0c f5 72 10 	movl   $0xc01072f5,0xc(%esp)
c0103db1:	c0 
c0103db2:	c7 44 24 08 4d 71 10 	movl   $0xc010714d,0x8(%esp)
c0103db9:	c0 
c0103dba:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
c0103dc1:	00 
c0103dc2:	c7 04 24 28 71 10 c0 	movl   $0xc0107128,(%esp)
c0103dc9:	e8 18 c6 ff ff       	call   c01003e6 <__panic>
    assert(page_ref(p1) == 1);
c0103dce:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103dd1:	89 04 24             	mov    %eax,(%esp)
c0103dd4:	e8 3e f0 ff ff       	call   c0102e17 <page_ref>
c0103dd9:	83 f8 01             	cmp    $0x1,%eax
c0103ddc:	74 24                	je     c0103e02 <check_pgdir+0x1c5>
c0103dde:	c7 44 24 0c 0b 73 10 	movl   $0xc010730b,0xc(%esp)
c0103de5:	c0 
c0103de6:	c7 44 24 08 4d 71 10 	movl   $0xc010714d,0x8(%esp)
c0103ded:	c0 
c0103dee:	c7 44 24 04 08 02 00 	movl   $0x208,0x4(%esp)
c0103df5:	00 
c0103df6:	c7 04 24 28 71 10 c0 	movl   $0xc0107128,(%esp)
c0103dfd:	e8 e4 c5 ff ff       	call   c01003e6 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0103e02:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0103e07:	8b 00                	mov    (%eax),%eax
c0103e09:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103e0e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103e11:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103e14:	c1 e8 0c             	shr    $0xc,%eax
c0103e17:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103e1a:	a1 a0 de 11 c0       	mov    0xc011dea0,%eax
c0103e1f:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0103e22:	72 23                	jb     c0103e47 <check_pgdir+0x20a>
c0103e24:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103e27:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103e2b:	c7 44 24 08 60 70 10 	movl   $0xc0107060,0x8(%esp)
c0103e32:	c0 
c0103e33:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
c0103e3a:	00 
c0103e3b:	c7 04 24 28 71 10 c0 	movl   $0xc0107128,(%esp)
c0103e42:	e8 9f c5 ff ff       	call   c01003e6 <__panic>
c0103e47:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103e4a:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103e4f:	83 c0 04             	add    $0x4,%eax
c0103e52:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0103e55:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0103e5a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103e61:	00 
c0103e62:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0103e69:	00 
c0103e6a:	89 04 24             	mov    %eax,(%esp)
c0103e6d:	e8 41 f8 ff ff       	call   c01036b3 <get_pte>
c0103e72:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0103e75:	74 24                	je     c0103e9b <check_pgdir+0x25e>
c0103e77:	c7 44 24 0c 20 73 10 	movl   $0xc0107320,0xc(%esp)
c0103e7e:	c0 
c0103e7f:	c7 44 24 08 4d 71 10 	movl   $0xc010714d,0x8(%esp)
c0103e86:	c0 
c0103e87:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
c0103e8e:	00 
c0103e8f:	c7 04 24 28 71 10 c0 	movl   $0xc0107128,(%esp)
c0103e96:	e8 4b c5 ff ff       	call   c01003e6 <__panic>

    p2 = alloc_page();
c0103e9b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103ea2:	e8 75 f1 ff ff       	call   c010301c <alloc_pages>
c0103ea7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0103eaa:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0103eaf:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0103eb6:	00 
c0103eb7:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0103ebe:	00 
c0103ebf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103ec2:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103ec6:	89 04 24             	mov    %eax,(%esp)
c0103ec9:	e8 3b fc ff ff       	call   c0103b09 <page_insert>
c0103ece:	85 c0                	test   %eax,%eax
c0103ed0:	74 24                	je     c0103ef6 <check_pgdir+0x2b9>
c0103ed2:	c7 44 24 0c 48 73 10 	movl   $0xc0107348,0xc(%esp)
c0103ed9:	c0 
c0103eda:	c7 44 24 08 4d 71 10 	movl   $0xc010714d,0x8(%esp)
c0103ee1:	c0 
c0103ee2:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
c0103ee9:	00 
c0103eea:	c7 04 24 28 71 10 c0 	movl   $0xc0107128,(%esp)
c0103ef1:	e8 f0 c4 ff ff       	call   c01003e6 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0103ef6:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0103efb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103f02:	00 
c0103f03:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0103f0a:	00 
c0103f0b:	89 04 24             	mov    %eax,(%esp)
c0103f0e:	e8 a0 f7 ff ff       	call   c01036b3 <get_pte>
c0103f13:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103f16:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103f1a:	75 24                	jne    c0103f40 <check_pgdir+0x303>
c0103f1c:	c7 44 24 0c 80 73 10 	movl   $0xc0107380,0xc(%esp)
c0103f23:	c0 
c0103f24:	c7 44 24 08 4d 71 10 	movl   $0xc010714d,0x8(%esp)
c0103f2b:	c0 
c0103f2c:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
c0103f33:	00 
c0103f34:	c7 04 24 28 71 10 c0 	movl   $0xc0107128,(%esp)
c0103f3b:	e8 a6 c4 ff ff       	call   c01003e6 <__panic>
    assert(*ptep & PTE_U);
c0103f40:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103f43:	8b 00                	mov    (%eax),%eax
c0103f45:	83 e0 04             	and    $0x4,%eax
c0103f48:	85 c0                	test   %eax,%eax
c0103f4a:	75 24                	jne    c0103f70 <check_pgdir+0x333>
c0103f4c:	c7 44 24 0c b0 73 10 	movl   $0xc01073b0,0xc(%esp)
c0103f53:	c0 
c0103f54:	c7 44 24 08 4d 71 10 	movl   $0xc010714d,0x8(%esp)
c0103f5b:	c0 
c0103f5c:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
c0103f63:	00 
c0103f64:	c7 04 24 28 71 10 c0 	movl   $0xc0107128,(%esp)
c0103f6b:	e8 76 c4 ff ff       	call   c01003e6 <__panic>
    assert(*ptep & PTE_W);
c0103f70:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103f73:	8b 00                	mov    (%eax),%eax
c0103f75:	83 e0 02             	and    $0x2,%eax
c0103f78:	85 c0                	test   %eax,%eax
c0103f7a:	75 24                	jne    c0103fa0 <check_pgdir+0x363>
c0103f7c:	c7 44 24 0c be 73 10 	movl   $0xc01073be,0xc(%esp)
c0103f83:	c0 
c0103f84:	c7 44 24 08 4d 71 10 	movl   $0xc010714d,0x8(%esp)
c0103f8b:	c0 
c0103f8c:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
c0103f93:	00 
c0103f94:	c7 04 24 28 71 10 c0 	movl   $0xc0107128,(%esp)
c0103f9b:	e8 46 c4 ff ff       	call   c01003e6 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0103fa0:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0103fa5:	8b 00                	mov    (%eax),%eax
c0103fa7:	83 e0 04             	and    $0x4,%eax
c0103faa:	85 c0                	test   %eax,%eax
c0103fac:	75 24                	jne    c0103fd2 <check_pgdir+0x395>
c0103fae:	c7 44 24 0c cc 73 10 	movl   $0xc01073cc,0xc(%esp)
c0103fb5:	c0 
c0103fb6:	c7 44 24 08 4d 71 10 	movl   $0xc010714d,0x8(%esp)
c0103fbd:	c0 
c0103fbe:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
c0103fc5:	00 
c0103fc6:	c7 04 24 28 71 10 c0 	movl   $0xc0107128,(%esp)
c0103fcd:	e8 14 c4 ff ff       	call   c01003e6 <__panic>
    assert(page_ref(p2) == 1);
c0103fd2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103fd5:	89 04 24             	mov    %eax,(%esp)
c0103fd8:	e8 3a ee ff ff       	call   c0102e17 <page_ref>
c0103fdd:	83 f8 01             	cmp    $0x1,%eax
c0103fe0:	74 24                	je     c0104006 <check_pgdir+0x3c9>
c0103fe2:	c7 44 24 0c e2 73 10 	movl   $0xc01073e2,0xc(%esp)
c0103fe9:	c0 
c0103fea:	c7 44 24 08 4d 71 10 	movl   $0xc010714d,0x8(%esp)
c0103ff1:	c0 
c0103ff2:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
c0103ff9:	00 
c0103ffa:	c7 04 24 28 71 10 c0 	movl   $0xc0107128,(%esp)
c0104001:	e8 e0 c3 ff ff       	call   c01003e6 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0104006:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c010400b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104012:	00 
c0104013:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c010401a:	00 
c010401b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010401e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104022:	89 04 24             	mov    %eax,(%esp)
c0104025:	e8 df fa ff ff       	call   c0103b09 <page_insert>
c010402a:	85 c0                	test   %eax,%eax
c010402c:	74 24                	je     c0104052 <check_pgdir+0x415>
c010402e:	c7 44 24 0c f4 73 10 	movl   $0xc01073f4,0xc(%esp)
c0104035:	c0 
c0104036:	c7 44 24 08 4d 71 10 	movl   $0xc010714d,0x8(%esp)
c010403d:	c0 
c010403e:	c7 44 24 04 15 02 00 	movl   $0x215,0x4(%esp)
c0104045:	00 
c0104046:	c7 04 24 28 71 10 c0 	movl   $0xc0107128,(%esp)
c010404d:	e8 94 c3 ff ff       	call   c01003e6 <__panic>
    assert(page_ref(p1) == 2);
c0104052:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104055:	89 04 24             	mov    %eax,(%esp)
c0104058:	e8 ba ed ff ff       	call   c0102e17 <page_ref>
c010405d:	83 f8 02             	cmp    $0x2,%eax
c0104060:	74 24                	je     c0104086 <check_pgdir+0x449>
c0104062:	c7 44 24 0c 20 74 10 	movl   $0xc0107420,0xc(%esp)
c0104069:	c0 
c010406a:	c7 44 24 08 4d 71 10 	movl   $0xc010714d,0x8(%esp)
c0104071:	c0 
c0104072:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
c0104079:	00 
c010407a:	c7 04 24 28 71 10 c0 	movl   $0xc0107128,(%esp)
c0104081:	e8 60 c3 ff ff       	call   c01003e6 <__panic>
    assert(page_ref(p2) == 0);
c0104086:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104089:	89 04 24             	mov    %eax,(%esp)
c010408c:	e8 86 ed ff ff       	call   c0102e17 <page_ref>
c0104091:	85 c0                	test   %eax,%eax
c0104093:	74 24                	je     c01040b9 <check_pgdir+0x47c>
c0104095:	c7 44 24 0c 32 74 10 	movl   $0xc0107432,0xc(%esp)
c010409c:	c0 
c010409d:	c7 44 24 08 4d 71 10 	movl   $0xc010714d,0x8(%esp)
c01040a4:	c0 
c01040a5:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
c01040ac:	00 
c01040ad:	c7 04 24 28 71 10 c0 	movl   $0xc0107128,(%esp)
c01040b4:	e8 2d c3 ff ff       	call   c01003e6 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c01040b9:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c01040be:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01040c5:	00 
c01040c6:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01040cd:	00 
c01040ce:	89 04 24             	mov    %eax,(%esp)
c01040d1:	e8 dd f5 ff ff       	call   c01036b3 <get_pte>
c01040d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01040d9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01040dd:	75 24                	jne    c0104103 <check_pgdir+0x4c6>
c01040df:	c7 44 24 0c 80 73 10 	movl   $0xc0107380,0xc(%esp)
c01040e6:	c0 
c01040e7:	c7 44 24 08 4d 71 10 	movl   $0xc010714d,0x8(%esp)
c01040ee:	c0 
c01040ef:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
c01040f6:	00 
c01040f7:	c7 04 24 28 71 10 c0 	movl   $0xc0107128,(%esp)
c01040fe:	e8 e3 c2 ff ff       	call   c01003e6 <__panic>
    assert(pte2page(*ptep) == p1);
c0104103:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104106:	8b 00                	mov    (%eax),%eax
c0104108:	89 04 24             	mov    %eax,(%esp)
c010410b:	e8 b1 ec ff ff       	call   c0102dc1 <pte2page>
c0104110:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104113:	74 24                	je     c0104139 <check_pgdir+0x4fc>
c0104115:	c7 44 24 0c f5 72 10 	movl   $0xc01072f5,0xc(%esp)
c010411c:	c0 
c010411d:	c7 44 24 08 4d 71 10 	movl   $0xc010714d,0x8(%esp)
c0104124:	c0 
c0104125:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
c010412c:	00 
c010412d:	c7 04 24 28 71 10 c0 	movl   $0xc0107128,(%esp)
c0104134:	e8 ad c2 ff ff       	call   c01003e6 <__panic>
    assert((*ptep & PTE_U) == 0);
c0104139:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010413c:	8b 00                	mov    (%eax),%eax
c010413e:	83 e0 04             	and    $0x4,%eax
c0104141:	85 c0                	test   %eax,%eax
c0104143:	74 24                	je     c0104169 <check_pgdir+0x52c>
c0104145:	c7 44 24 0c 44 74 10 	movl   $0xc0107444,0xc(%esp)
c010414c:	c0 
c010414d:	c7 44 24 08 4d 71 10 	movl   $0xc010714d,0x8(%esp)
c0104154:	c0 
c0104155:	c7 44 24 04 1a 02 00 	movl   $0x21a,0x4(%esp)
c010415c:	00 
c010415d:	c7 04 24 28 71 10 c0 	movl   $0xc0107128,(%esp)
c0104164:	e8 7d c2 ff ff       	call   c01003e6 <__panic>

    page_remove(boot_pgdir, 0x0);
c0104169:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c010416e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104175:	00 
c0104176:	89 04 24             	mov    %eax,(%esp)
c0104179:	e8 46 f9 ff ff       	call   c0103ac4 <page_remove>
    assert(page_ref(p1) == 1);
c010417e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104181:	89 04 24             	mov    %eax,(%esp)
c0104184:	e8 8e ec ff ff       	call   c0102e17 <page_ref>
c0104189:	83 f8 01             	cmp    $0x1,%eax
c010418c:	74 24                	je     c01041b2 <check_pgdir+0x575>
c010418e:	c7 44 24 0c 0b 73 10 	movl   $0xc010730b,0xc(%esp)
c0104195:	c0 
c0104196:	c7 44 24 08 4d 71 10 	movl   $0xc010714d,0x8(%esp)
c010419d:	c0 
c010419e:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
c01041a5:	00 
c01041a6:	c7 04 24 28 71 10 c0 	movl   $0xc0107128,(%esp)
c01041ad:	e8 34 c2 ff ff       	call   c01003e6 <__panic>
    assert(page_ref(p2) == 0);
c01041b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01041b5:	89 04 24             	mov    %eax,(%esp)
c01041b8:	e8 5a ec ff ff       	call   c0102e17 <page_ref>
c01041bd:	85 c0                	test   %eax,%eax
c01041bf:	74 24                	je     c01041e5 <check_pgdir+0x5a8>
c01041c1:	c7 44 24 0c 32 74 10 	movl   $0xc0107432,0xc(%esp)
c01041c8:	c0 
c01041c9:	c7 44 24 08 4d 71 10 	movl   $0xc010714d,0x8(%esp)
c01041d0:	c0 
c01041d1:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
c01041d8:	00 
c01041d9:	c7 04 24 28 71 10 c0 	movl   $0xc0107128,(%esp)
c01041e0:	e8 01 c2 ff ff       	call   c01003e6 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c01041e5:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c01041ea:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01041f1:	00 
c01041f2:	89 04 24             	mov    %eax,(%esp)
c01041f5:	e8 ca f8 ff ff       	call   c0103ac4 <page_remove>
    assert(page_ref(p1) == 0);
c01041fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01041fd:	89 04 24             	mov    %eax,(%esp)
c0104200:	e8 12 ec ff ff       	call   c0102e17 <page_ref>
c0104205:	85 c0                	test   %eax,%eax
c0104207:	74 24                	je     c010422d <check_pgdir+0x5f0>
c0104209:	c7 44 24 0c 59 74 10 	movl   $0xc0107459,0xc(%esp)
c0104210:	c0 
c0104211:	c7 44 24 08 4d 71 10 	movl   $0xc010714d,0x8(%esp)
c0104218:	c0 
c0104219:	c7 44 24 04 21 02 00 	movl   $0x221,0x4(%esp)
c0104220:	00 
c0104221:	c7 04 24 28 71 10 c0 	movl   $0xc0107128,(%esp)
c0104228:	e8 b9 c1 ff ff       	call   c01003e6 <__panic>
    assert(page_ref(p2) == 0);
c010422d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104230:	89 04 24             	mov    %eax,(%esp)
c0104233:	e8 df eb ff ff       	call   c0102e17 <page_ref>
c0104238:	85 c0                	test   %eax,%eax
c010423a:	74 24                	je     c0104260 <check_pgdir+0x623>
c010423c:	c7 44 24 0c 32 74 10 	movl   $0xc0107432,0xc(%esp)
c0104243:	c0 
c0104244:	c7 44 24 08 4d 71 10 	movl   $0xc010714d,0x8(%esp)
c010424b:	c0 
c010424c:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
c0104253:	00 
c0104254:	c7 04 24 28 71 10 c0 	movl   $0xc0107128,(%esp)
c010425b:	e8 86 c1 ff ff       	call   c01003e6 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0104260:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0104265:	8b 00                	mov    (%eax),%eax
c0104267:	89 04 24             	mov    %eax,(%esp)
c010426a:	e8 90 eb ff ff       	call   c0102dff <pde2page>
c010426f:	89 04 24             	mov    %eax,(%esp)
c0104272:	e8 a0 eb ff ff       	call   c0102e17 <page_ref>
c0104277:	83 f8 01             	cmp    $0x1,%eax
c010427a:	74 24                	je     c01042a0 <check_pgdir+0x663>
c010427c:	c7 44 24 0c 6c 74 10 	movl   $0xc010746c,0xc(%esp)
c0104283:	c0 
c0104284:	c7 44 24 08 4d 71 10 	movl   $0xc010714d,0x8(%esp)
c010428b:	c0 
c010428c:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
c0104293:	00 
c0104294:	c7 04 24 28 71 10 c0 	movl   $0xc0107128,(%esp)
c010429b:	e8 46 c1 ff ff       	call   c01003e6 <__panic>
    free_page(pde2page(boot_pgdir[0]));
c01042a0:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c01042a5:	8b 00                	mov    (%eax),%eax
c01042a7:	89 04 24             	mov    %eax,(%esp)
c01042aa:	e8 50 eb ff ff       	call   c0102dff <pde2page>
c01042af:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01042b6:	00 
c01042b7:	89 04 24             	mov    %eax,(%esp)
c01042ba:	e8 95 ed ff ff       	call   c0103054 <free_pages>
    boot_pgdir[0] = 0;
c01042bf:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c01042c4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c01042ca:	c7 04 24 93 74 10 c0 	movl   $0xc0107493,(%esp)
c01042d1:	e8 b8 bf ff ff       	call   c010028e <cprintf>
}
c01042d6:	90                   	nop
c01042d7:	c9                   	leave  
c01042d8:	c3                   	ret    

c01042d9 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c01042d9:	55                   	push   %ebp
c01042da:	89 e5                	mov    %esp,%ebp
c01042dc:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c01042df:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01042e6:	e9 ca 00 00 00       	jmp    c01043b5 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c01042eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01042ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01042f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01042f4:	c1 e8 0c             	shr    $0xc,%eax
c01042f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01042fa:	a1 a0 de 11 c0       	mov    0xc011dea0,%eax
c01042ff:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0104302:	72 23                	jb     c0104327 <check_boot_pgdir+0x4e>
c0104304:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104307:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010430b:	c7 44 24 08 60 70 10 	movl   $0xc0107060,0x8(%esp)
c0104312:	c0 
c0104313:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
c010431a:	00 
c010431b:	c7 04 24 28 71 10 c0 	movl   $0xc0107128,(%esp)
c0104322:	e8 bf c0 ff ff       	call   c01003e6 <__panic>
c0104327:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010432a:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010432f:	89 c2                	mov    %eax,%edx
c0104331:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0104336:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010433d:	00 
c010433e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104342:	89 04 24             	mov    %eax,(%esp)
c0104345:	e8 69 f3 ff ff       	call   c01036b3 <get_pte>
c010434a:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010434d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104351:	75 24                	jne    c0104377 <check_boot_pgdir+0x9e>
c0104353:	c7 44 24 0c b0 74 10 	movl   $0xc01074b0,0xc(%esp)
c010435a:	c0 
c010435b:	c7 44 24 08 4d 71 10 	movl   $0xc010714d,0x8(%esp)
c0104362:	c0 
c0104363:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
c010436a:	00 
c010436b:	c7 04 24 28 71 10 c0 	movl   $0xc0107128,(%esp)
c0104372:	e8 6f c0 ff ff       	call   c01003e6 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0104377:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010437a:	8b 00                	mov    (%eax),%eax
c010437c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104381:	89 c2                	mov    %eax,%edx
c0104383:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104386:	39 c2                	cmp    %eax,%edx
c0104388:	74 24                	je     c01043ae <check_boot_pgdir+0xd5>
c010438a:	c7 44 24 0c ed 74 10 	movl   $0xc01074ed,0xc(%esp)
c0104391:	c0 
c0104392:	c7 44 24 08 4d 71 10 	movl   $0xc010714d,0x8(%esp)
c0104399:	c0 
c010439a:	c7 44 24 04 31 02 00 	movl   $0x231,0x4(%esp)
c01043a1:	00 
c01043a2:	c7 04 24 28 71 10 c0 	movl   $0xc0107128,(%esp)
c01043a9:	e8 38 c0 ff ff       	call   c01003e6 <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
c01043ae:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c01043b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01043b8:	a1 a0 de 11 c0       	mov    0xc011dea0,%eax
c01043bd:	39 c2                	cmp    %eax,%edx
c01043bf:	0f 82 26 ff ff ff    	jb     c01042eb <check_boot_pgdir+0x12>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c01043c5:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c01043ca:	05 ac 0f 00 00       	add    $0xfac,%eax
c01043cf:	8b 00                	mov    (%eax),%eax
c01043d1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01043d6:	89 c2                	mov    %eax,%edx
c01043d8:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c01043dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01043e0:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c01043e7:	77 23                	ja     c010440c <check_boot_pgdir+0x133>
c01043e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01043ec:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01043f0:	c7 44 24 08 04 71 10 	movl   $0xc0107104,0x8(%esp)
c01043f7:	c0 
c01043f8:	c7 44 24 04 34 02 00 	movl   $0x234,0x4(%esp)
c01043ff:	00 
c0104400:	c7 04 24 28 71 10 c0 	movl   $0xc0107128,(%esp)
c0104407:	e8 da bf ff ff       	call   c01003e6 <__panic>
c010440c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010440f:	05 00 00 00 40       	add    $0x40000000,%eax
c0104414:	39 d0                	cmp    %edx,%eax
c0104416:	74 24                	je     c010443c <check_boot_pgdir+0x163>
c0104418:	c7 44 24 0c 04 75 10 	movl   $0xc0107504,0xc(%esp)
c010441f:	c0 
c0104420:	c7 44 24 08 4d 71 10 	movl   $0xc010714d,0x8(%esp)
c0104427:	c0 
c0104428:	c7 44 24 04 34 02 00 	movl   $0x234,0x4(%esp)
c010442f:	00 
c0104430:	c7 04 24 28 71 10 c0 	movl   $0xc0107128,(%esp)
c0104437:	e8 aa bf ff ff       	call   c01003e6 <__panic>

    assert(boot_pgdir[0] == 0);
c010443c:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c0104441:	8b 00                	mov    (%eax),%eax
c0104443:	85 c0                	test   %eax,%eax
c0104445:	74 24                	je     c010446b <check_boot_pgdir+0x192>
c0104447:	c7 44 24 0c 38 75 10 	movl   $0xc0107538,0xc(%esp)
c010444e:	c0 
c010444f:	c7 44 24 08 4d 71 10 	movl   $0xc010714d,0x8(%esp)
c0104456:	c0 
c0104457:	c7 44 24 04 36 02 00 	movl   $0x236,0x4(%esp)
c010445e:	00 
c010445f:	c7 04 24 28 71 10 c0 	movl   $0xc0107128,(%esp)
c0104466:	e8 7b bf ff ff       	call   c01003e6 <__panic>

    struct Page *p;
    p = alloc_page();
c010446b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104472:	e8 a5 eb ff ff       	call   c010301c <alloc_pages>
c0104477:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c010447a:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c010447f:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0104486:	00 
c0104487:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c010448e:	00 
c010448f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104492:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104496:	89 04 24             	mov    %eax,(%esp)
c0104499:	e8 6b f6 ff ff       	call   c0103b09 <page_insert>
c010449e:	85 c0                	test   %eax,%eax
c01044a0:	74 24                	je     c01044c6 <check_boot_pgdir+0x1ed>
c01044a2:	c7 44 24 0c 4c 75 10 	movl   $0xc010754c,0xc(%esp)
c01044a9:	c0 
c01044aa:	c7 44 24 08 4d 71 10 	movl   $0xc010714d,0x8(%esp)
c01044b1:	c0 
c01044b2:	c7 44 24 04 3a 02 00 	movl   $0x23a,0x4(%esp)
c01044b9:	00 
c01044ba:	c7 04 24 28 71 10 c0 	movl   $0xc0107128,(%esp)
c01044c1:	e8 20 bf ff ff       	call   c01003e6 <__panic>
    assert(page_ref(p) == 1);
c01044c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01044c9:	89 04 24             	mov    %eax,(%esp)
c01044cc:	e8 46 e9 ff ff       	call   c0102e17 <page_ref>
c01044d1:	83 f8 01             	cmp    $0x1,%eax
c01044d4:	74 24                	je     c01044fa <check_boot_pgdir+0x221>
c01044d6:	c7 44 24 0c 7a 75 10 	movl   $0xc010757a,0xc(%esp)
c01044dd:	c0 
c01044de:	c7 44 24 08 4d 71 10 	movl   $0xc010714d,0x8(%esp)
c01044e5:	c0 
c01044e6:	c7 44 24 04 3b 02 00 	movl   $0x23b,0x4(%esp)
c01044ed:	00 
c01044ee:	c7 04 24 28 71 10 c0 	movl   $0xc0107128,(%esp)
c01044f5:	e8 ec be ff ff       	call   c01003e6 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c01044fa:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c01044ff:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0104506:	00 
c0104507:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c010450e:	00 
c010450f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104512:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104516:	89 04 24             	mov    %eax,(%esp)
c0104519:	e8 eb f5 ff ff       	call   c0103b09 <page_insert>
c010451e:	85 c0                	test   %eax,%eax
c0104520:	74 24                	je     c0104546 <check_boot_pgdir+0x26d>
c0104522:	c7 44 24 0c 8c 75 10 	movl   $0xc010758c,0xc(%esp)
c0104529:	c0 
c010452a:	c7 44 24 08 4d 71 10 	movl   $0xc010714d,0x8(%esp)
c0104531:	c0 
c0104532:	c7 44 24 04 3c 02 00 	movl   $0x23c,0x4(%esp)
c0104539:	00 
c010453a:	c7 04 24 28 71 10 c0 	movl   $0xc0107128,(%esp)
c0104541:	e8 a0 be ff ff       	call   c01003e6 <__panic>
    assert(page_ref(p) == 2);
c0104546:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104549:	89 04 24             	mov    %eax,(%esp)
c010454c:	e8 c6 e8 ff ff       	call   c0102e17 <page_ref>
c0104551:	83 f8 02             	cmp    $0x2,%eax
c0104554:	74 24                	je     c010457a <check_boot_pgdir+0x2a1>
c0104556:	c7 44 24 0c c3 75 10 	movl   $0xc01075c3,0xc(%esp)
c010455d:	c0 
c010455e:	c7 44 24 08 4d 71 10 	movl   $0xc010714d,0x8(%esp)
c0104565:	c0 
c0104566:	c7 44 24 04 3d 02 00 	movl   $0x23d,0x4(%esp)
c010456d:	00 
c010456e:	c7 04 24 28 71 10 c0 	movl   $0xc0107128,(%esp)
c0104575:	e8 6c be ff ff       	call   c01003e6 <__panic>

    const char *str = "ucore: Hello world!!";
c010457a:	c7 45 dc d4 75 10 c0 	movl   $0xc01075d4,-0x24(%ebp)
    strcpy((void *)0x100, str);
c0104581:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104584:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104588:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c010458f:	e8 77 18 00 00       	call   c0105e0b <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0104594:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c010459b:	00 
c010459c:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01045a3:	e8 da 18 00 00       	call   c0105e82 <strcmp>
c01045a8:	85 c0                	test   %eax,%eax
c01045aa:	74 24                	je     c01045d0 <check_boot_pgdir+0x2f7>
c01045ac:	c7 44 24 0c ec 75 10 	movl   $0xc01075ec,0xc(%esp)
c01045b3:	c0 
c01045b4:	c7 44 24 08 4d 71 10 	movl   $0xc010714d,0x8(%esp)
c01045bb:	c0 
c01045bc:	c7 44 24 04 41 02 00 	movl   $0x241,0x4(%esp)
c01045c3:	00 
c01045c4:	c7 04 24 28 71 10 c0 	movl   $0xc0107128,(%esp)
c01045cb:	e8 16 be ff ff       	call   c01003e6 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c01045d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01045d3:	89 04 24             	mov    %eax,(%esp)
c01045d6:	e8 92 e7 ff ff       	call   c0102d6d <page2kva>
c01045db:	05 00 01 00 00       	add    $0x100,%eax
c01045e0:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c01045e3:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01045ea:	e8 c6 17 00 00       	call   c0105db5 <strlen>
c01045ef:	85 c0                	test   %eax,%eax
c01045f1:	74 24                	je     c0104617 <check_boot_pgdir+0x33e>
c01045f3:	c7 44 24 0c 24 76 10 	movl   $0xc0107624,0xc(%esp)
c01045fa:	c0 
c01045fb:	c7 44 24 08 4d 71 10 	movl   $0xc010714d,0x8(%esp)
c0104602:	c0 
c0104603:	c7 44 24 04 44 02 00 	movl   $0x244,0x4(%esp)
c010460a:	00 
c010460b:	c7 04 24 28 71 10 c0 	movl   $0xc0107128,(%esp)
c0104612:	e8 cf bd ff ff       	call   c01003e6 <__panic>

    free_page(p);
c0104617:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010461e:	00 
c010461f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104622:	89 04 24             	mov    %eax,(%esp)
c0104625:	e8 2a ea ff ff       	call   c0103054 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
c010462a:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c010462f:	8b 00                	mov    (%eax),%eax
c0104631:	89 04 24             	mov    %eax,(%esp)
c0104634:	e8 c6 e7 ff ff       	call   c0102dff <pde2page>
c0104639:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104640:	00 
c0104641:	89 04 24             	mov    %eax,(%esp)
c0104644:	e8 0b ea ff ff       	call   c0103054 <free_pages>
    boot_pgdir[0] = 0;
c0104649:	a1 e0 a9 11 c0       	mov    0xc011a9e0,%eax
c010464e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0104654:	c7 04 24 48 76 10 c0 	movl   $0xc0107648,(%esp)
c010465b:	e8 2e bc ff ff       	call   c010028e <cprintf>
}
c0104660:	90                   	nop
c0104661:	c9                   	leave  
c0104662:	c3                   	ret    

c0104663 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0104663:	55                   	push   %ebp
c0104664:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0104666:	8b 45 08             	mov    0x8(%ebp),%eax
c0104669:	83 e0 04             	and    $0x4,%eax
c010466c:	85 c0                	test   %eax,%eax
c010466e:	74 04                	je     c0104674 <perm2str+0x11>
c0104670:	b0 75                	mov    $0x75,%al
c0104672:	eb 02                	jmp    c0104676 <perm2str+0x13>
c0104674:	b0 2d                	mov    $0x2d,%al
c0104676:	a2 28 df 11 c0       	mov    %al,0xc011df28
    str[1] = 'r';
c010467b:	c6 05 29 df 11 c0 72 	movb   $0x72,0xc011df29
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0104682:	8b 45 08             	mov    0x8(%ebp),%eax
c0104685:	83 e0 02             	and    $0x2,%eax
c0104688:	85 c0                	test   %eax,%eax
c010468a:	74 04                	je     c0104690 <perm2str+0x2d>
c010468c:	b0 77                	mov    $0x77,%al
c010468e:	eb 02                	jmp    c0104692 <perm2str+0x2f>
c0104690:	b0 2d                	mov    $0x2d,%al
c0104692:	a2 2a df 11 c0       	mov    %al,0xc011df2a
    str[3] = '\0';
c0104697:	c6 05 2b df 11 c0 00 	movb   $0x0,0xc011df2b
    return str;
c010469e:	b8 28 df 11 c0       	mov    $0xc011df28,%eax
}
c01046a3:	5d                   	pop    %ebp
c01046a4:	c3                   	ret    

c01046a5 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c01046a5:	55                   	push   %ebp
c01046a6:	89 e5                	mov    %esp,%ebp
c01046a8:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c01046ab:	8b 45 10             	mov    0x10(%ebp),%eax
c01046ae:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01046b1:	72 0d                	jb     c01046c0 <get_pgtable_items+0x1b>
        return 0;
c01046b3:	b8 00 00 00 00       	mov    $0x0,%eax
c01046b8:	e9 98 00 00 00       	jmp    c0104755 <get_pgtable_items+0xb0>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
c01046bd:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
c01046c0:	8b 45 10             	mov    0x10(%ebp),%eax
c01046c3:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01046c6:	73 18                	jae    c01046e0 <get_pgtable_items+0x3b>
c01046c8:	8b 45 10             	mov    0x10(%ebp),%eax
c01046cb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01046d2:	8b 45 14             	mov    0x14(%ebp),%eax
c01046d5:	01 d0                	add    %edx,%eax
c01046d7:	8b 00                	mov    (%eax),%eax
c01046d9:	83 e0 01             	and    $0x1,%eax
c01046dc:	85 c0                	test   %eax,%eax
c01046de:	74 dd                	je     c01046bd <get_pgtable_items+0x18>
    }
    if (start < right) {
c01046e0:	8b 45 10             	mov    0x10(%ebp),%eax
c01046e3:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01046e6:	73 68                	jae    c0104750 <get_pgtable_items+0xab>
        if (left_store != NULL) {
c01046e8:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c01046ec:	74 08                	je     c01046f6 <get_pgtable_items+0x51>
            *left_store = start;
c01046ee:	8b 45 18             	mov    0x18(%ebp),%eax
c01046f1:	8b 55 10             	mov    0x10(%ebp),%edx
c01046f4:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c01046f6:	8b 45 10             	mov    0x10(%ebp),%eax
c01046f9:	8d 50 01             	lea    0x1(%eax),%edx
c01046fc:	89 55 10             	mov    %edx,0x10(%ebp)
c01046ff:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104706:	8b 45 14             	mov    0x14(%ebp),%eax
c0104709:	01 d0                	add    %edx,%eax
c010470b:	8b 00                	mov    (%eax),%eax
c010470d:	83 e0 07             	and    $0x7,%eax
c0104710:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0104713:	eb 03                	jmp    c0104718 <get_pgtable_items+0x73>
            start ++;
c0104715:	ff 45 10             	incl   0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0104718:	8b 45 10             	mov    0x10(%ebp),%eax
c010471b:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010471e:	73 1d                	jae    c010473d <get_pgtable_items+0x98>
c0104720:	8b 45 10             	mov    0x10(%ebp),%eax
c0104723:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010472a:	8b 45 14             	mov    0x14(%ebp),%eax
c010472d:	01 d0                	add    %edx,%eax
c010472f:	8b 00                	mov    (%eax),%eax
c0104731:	83 e0 07             	and    $0x7,%eax
c0104734:	89 c2                	mov    %eax,%edx
c0104736:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104739:	39 c2                	cmp    %eax,%edx
c010473b:	74 d8                	je     c0104715 <get_pgtable_items+0x70>
        }
        if (right_store != NULL) {
c010473d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0104741:	74 08                	je     c010474b <get_pgtable_items+0xa6>
            *right_store = start;
c0104743:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0104746:	8b 55 10             	mov    0x10(%ebp),%edx
c0104749:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c010474b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010474e:	eb 05                	jmp    c0104755 <get_pgtable_items+0xb0>
    }
    return 0;
c0104750:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104755:	c9                   	leave  
c0104756:	c3                   	ret    

c0104757 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0104757:	55                   	push   %ebp
c0104758:	89 e5                	mov    %esp,%ebp
c010475a:	57                   	push   %edi
c010475b:	56                   	push   %esi
c010475c:	53                   	push   %ebx
c010475d:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c0104760:	c7 04 24 68 76 10 c0 	movl   $0xc0107668,(%esp)
c0104767:	e8 22 bb ff ff       	call   c010028e <cprintf>
    size_t left, right = 0, perm;
c010476c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0104773:	e9 fa 00 00 00       	jmp    c0104872 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0104778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010477b:	89 04 24             	mov    %eax,(%esp)
c010477e:	e8 e0 fe ff ff       	call   c0104663 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0104783:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0104786:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104789:	29 d1                	sub    %edx,%ecx
c010478b:	89 ca                	mov    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c010478d:	89 d6                	mov    %edx,%esi
c010478f:	c1 e6 16             	shl    $0x16,%esi
c0104792:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104795:	89 d3                	mov    %edx,%ebx
c0104797:	c1 e3 16             	shl    $0x16,%ebx
c010479a:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010479d:	89 d1                	mov    %edx,%ecx
c010479f:	c1 e1 16             	shl    $0x16,%ecx
c01047a2:	8b 7d dc             	mov    -0x24(%ebp),%edi
c01047a5:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01047a8:	29 d7                	sub    %edx,%edi
c01047aa:	89 fa                	mov    %edi,%edx
c01047ac:	89 44 24 14          	mov    %eax,0x14(%esp)
c01047b0:	89 74 24 10          	mov    %esi,0x10(%esp)
c01047b4:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01047b8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01047bc:	89 54 24 04          	mov    %edx,0x4(%esp)
c01047c0:	c7 04 24 99 76 10 c0 	movl   $0xc0107699,(%esp)
c01047c7:	e8 c2 ba ff ff       	call   c010028e <cprintf>
        size_t l, r = left * NPTEENTRY;
c01047cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01047cf:	c1 e0 0a             	shl    $0xa,%eax
c01047d2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01047d5:	eb 54                	jmp    c010482b <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01047d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01047da:	89 04 24             	mov    %eax,(%esp)
c01047dd:	e8 81 fe ff ff       	call   c0104663 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c01047e2:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c01047e5:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01047e8:	29 d1                	sub    %edx,%ecx
c01047ea:	89 ca                	mov    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01047ec:	89 d6                	mov    %edx,%esi
c01047ee:	c1 e6 0c             	shl    $0xc,%esi
c01047f1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01047f4:	89 d3                	mov    %edx,%ebx
c01047f6:	c1 e3 0c             	shl    $0xc,%ebx
c01047f9:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01047fc:	89 d1                	mov    %edx,%ecx
c01047fe:	c1 e1 0c             	shl    $0xc,%ecx
c0104801:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c0104804:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104807:	29 d7                	sub    %edx,%edi
c0104809:	89 fa                	mov    %edi,%edx
c010480b:	89 44 24 14          	mov    %eax,0x14(%esp)
c010480f:	89 74 24 10          	mov    %esi,0x10(%esp)
c0104813:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0104817:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c010481b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010481f:	c7 04 24 b8 76 10 c0 	movl   $0xc01076b8,(%esp)
c0104826:	e8 63 ba ff ff       	call   c010028e <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c010482b:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
c0104830:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104833:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104836:	89 d3                	mov    %edx,%ebx
c0104838:	c1 e3 0a             	shl    $0xa,%ebx
c010483b:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010483e:	89 d1                	mov    %edx,%ecx
c0104840:	c1 e1 0a             	shl    $0xa,%ecx
c0104843:	8d 55 d4             	lea    -0x2c(%ebp),%edx
c0104846:	89 54 24 14          	mov    %edx,0x14(%esp)
c010484a:	8d 55 d8             	lea    -0x28(%ebp),%edx
c010484d:	89 54 24 10          	mov    %edx,0x10(%esp)
c0104851:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0104855:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104859:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c010485d:	89 0c 24             	mov    %ecx,(%esp)
c0104860:	e8 40 fe ff ff       	call   c01046a5 <get_pgtable_items>
c0104865:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104868:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010486c:	0f 85 65 ff ff ff    	jne    c01047d7 <print_pgdir+0x80>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0104872:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
c0104877:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010487a:	8d 55 dc             	lea    -0x24(%ebp),%edx
c010487d:	89 54 24 14          	mov    %edx,0x14(%esp)
c0104881:	8d 55 e0             	lea    -0x20(%ebp),%edx
c0104884:	89 54 24 10          	mov    %edx,0x10(%esp)
c0104888:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c010488c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104890:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c0104897:	00 
c0104898:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010489f:	e8 01 fe ff ff       	call   c01046a5 <get_pgtable_items>
c01048a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01048a7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01048ab:	0f 85 c7 fe ff ff    	jne    c0104778 <print_pgdir+0x21>
        }
    }
    cprintf("--------------------- END ---------------------\n");
c01048b1:	c7 04 24 dc 76 10 c0 	movl   $0xc01076dc,(%esp)
c01048b8:	e8 d1 b9 ff ff       	call   c010028e <cprintf>
}
c01048bd:	90                   	nop
c01048be:	83 c4 4c             	add    $0x4c,%esp
c01048c1:	5b                   	pop    %ebx
c01048c2:	5e                   	pop    %esi
c01048c3:	5f                   	pop    %edi
c01048c4:	5d                   	pop    %ebp
c01048c5:	c3                   	ret    

c01048c6 <page2ppn>:
page2ppn(struct Page *page) {
c01048c6:	55                   	push   %ebp
c01048c7:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01048c9:	a1 38 df 11 c0       	mov    0xc011df38,%eax
c01048ce:	8b 55 08             	mov    0x8(%ebp),%edx
c01048d1:	29 c2                	sub    %eax,%edx
c01048d3:	89 d0                	mov    %edx,%eax
c01048d5:	c1 f8 02             	sar    $0x2,%eax
c01048d8:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c01048de:	5d                   	pop    %ebp
c01048df:	c3                   	ret    

c01048e0 <page2pa>:
page2pa(struct Page *page) {
c01048e0:	55                   	push   %ebp
c01048e1:	89 e5                	mov    %esp,%ebp
c01048e3:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01048e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01048e9:	89 04 24             	mov    %eax,(%esp)
c01048ec:	e8 d5 ff ff ff       	call   c01048c6 <page2ppn>
c01048f1:	c1 e0 0c             	shl    $0xc,%eax
}
c01048f4:	c9                   	leave  
c01048f5:	c3                   	ret    

c01048f6 <page_ref>:
page_ref(struct Page *page) {
c01048f6:	55                   	push   %ebp
c01048f7:	89 e5                	mov    %esp,%ebp
    return page->ref;
c01048f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01048fc:	8b 00                	mov    (%eax),%eax
}
c01048fe:	5d                   	pop    %ebp
c01048ff:	c3                   	ret    

c0104900 <set_page_ref>:
set_page_ref(struct Page *page, int val) {
c0104900:	55                   	push   %ebp
c0104901:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0104903:	8b 45 08             	mov    0x8(%ebp),%eax
c0104906:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104909:	89 10                	mov    %edx,(%eax)
}
c010490b:	90                   	nop
c010490c:	5d                   	pop    %ebp
c010490d:	c3                   	ret    

c010490e <default_init>:
#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)


static void
default_init(void) {
c010490e:	55                   	push   %ebp
c010490f:	89 e5                	mov    %esp,%ebp
c0104911:	83 ec 10             	sub    $0x10,%esp
c0104914:	c7 45 fc 3c df 11 c0 	movl   $0xc011df3c,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010491b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010491e:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0104921:	89 50 04             	mov    %edx,0x4(%eax)
c0104924:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104927:	8b 50 04             	mov    0x4(%eax),%edx
c010492a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010492d:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c010492f:	c7 05 44 df 11 c0 00 	movl   $0x0,0xc011df44
c0104936:	00 00 00 
}
c0104939:	90                   	nop
c010493a:	c9                   	leave  
c010493b:	c3                   	ret    

c010493c <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c010493c:	55                   	push   %ebp
c010493d:	89 e5                	mov    %esp,%ebp
c010493f:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c0104942:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0104946:	75 24                	jne    c010496c <default_init_memmap+0x30>
c0104948:	c7 44 24 0c 10 77 10 	movl   $0xc0107710,0xc(%esp)
c010494f:	c0 
c0104950:	c7 44 24 08 16 77 10 	movl   $0xc0107716,0x8(%esp)
c0104957:	c0 
c0104958:	c7 44 24 04 6f 00 00 	movl   $0x6f,0x4(%esp)
c010495f:	00 
c0104960:	c7 04 24 2b 77 10 c0 	movl   $0xc010772b,(%esp)
c0104967:	e8 7a ba ff ff       	call   c01003e6 <__panic>
    struct Page *p = base;
c010496c:	8b 45 08             	mov    0x8(%ebp),%eax
c010496f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0104972:	e9 b3 00 00 00       	jmp    c0104a2a <default_init_memmap+0xee>
		// 在查找可用内存并分配struct Page数组时就已经将将全部Page设置为Reserved
		// 将Page标记为可用的:清除Reserved,设置Property,并把property设置为0( 不是空闲块的第一个物理页 )
        assert(PageReserved(p));
c0104977:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010497a:	83 c0 04             	add    $0x4,%eax
c010497d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0104984:	89 45 ec             	mov    %eax,-0x14(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104987:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010498a:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010498d:	0f a3 10             	bt     %edx,(%eax)
c0104990:	19 c0                	sbb    %eax,%eax
c0104992:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c0104995:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104999:	0f 95 c0             	setne  %al
c010499c:	0f b6 c0             	movzbl %al,%eax
c010499f:	85 c0                	test   %eax,%eax
c01049a1:	75 24                	jne    c01049c7 <default_init_memmap+0x8b>
c01049a3:	c7 44 24 0c 41 77 10 	movl   $0xc0107741,0xc(%esp)
c01049aa:	c0 
c01049ab:	c7 44 24 08 16 77 10 	movl   $0xc0107716,0x8(%esp)
c01049b2:	c0 
c01049b3:	c7 44 24 04 74 00 00 	movl   $0x74,0x4(%esp)
c01049ba:	00 
c01049bb:	c7 04 24 2b 77 10 c0 	movl   $0xc010772b,(%esp)
c01049c2:	e8 1f ba ff ff       	call   c01003e6 <__panic>
        p->flags = p->property = 0;
c01049c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049ca:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c01049d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049d4:	8b 50 08             	mov    0x8(%eax),%edx
c01049d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049da:	89 50 04             	mov    %edx,0x4(%eax)
		SetPageProperty(p);
c01049dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049e0:	83 c0 04             	add    $0x4,%eax
c01049e3:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c01049ea:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01049ed:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01049f0:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01049f3:	0f ab 10             	bts    %edx,(%eax)
        set_page_ref(p, 0);
c01049f6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01049fd:	00 
c01049fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a01:	89 04 24             	mov    %eax,(%esp)
c0104a04:	e8 f7 fe ff ff       	call   c0104900 <set_page_ref>
		list_init(&(p->page_link));
c0104a09:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a0c:	83 c0 0c             	add    $0xc,%eax
c0104a0f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104a12:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104a15:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104a18:	89 50 04             	mov    %edx,0x4(%eax)
c0104a1b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104a1e:	8b 50 04             	mov    0x4(%eax),%edx
c0104a21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104a24:	89 10                	mov    %edx,(%eax)
    for (; p != base + n; p ++) {
c0104a26:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0104a2a:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104a2d:	89 d0                	mov    %edx,%eax
c0104a2f:	c1 e0 02             	shl    $0x2,%eax
c0104a32:	01 d0                	add    %edx,%eax
c0104a34:	c1 e0 02             	shl    $0x2,%eax
c0104a37:	89 c2                	mov    %eax,%edx
c0104a39:	8b 45 08             	mov    0x8(%ebp),%eax
c0104a3c:	01 d0                	add    %edx,%eax
c0104a3e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104a41:	0f 85 30 ff ff ff    	jne    c0104977 <default_init_memmap+0x3b>
    }
	cprintf("Page address is %x\n", (uintptr_t)base);
c0104a47:	8b 45 08             	mov    0x8(%ebp),%eax
c0104a4a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104a4e:	c7 04 24 51 77 10 c0 	movl   $0xc0107751,(%esp)
c0104a55:	e8 34 b8 ff ff       	call   c010028e <cprintf>
    base->property = n;
c0104a5a:	8b 45 08             	mov    0x8(%ebp),%eax
c0104a5d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104a60:	89 50 08             	mov    %edx,0x8(%eax)
    nr_free += n;
c0104a63:	8b 15 44 df 11 c0    	mov    0xc011df44,%edx
c0104a69:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104a6c:	01 d0                	add    %edx,%eax
c0104a6e:	a3 44 df 11 c0       	mov    %eax,0xc011df44
    list_add(free_list.prev, &(base->page_link));
c0104a73:	8b 45 08             	mov    0x8(%ebp),%eax
c0104a76:	8d 50 0c             	lea    0xc(%eax),%edx
c0104a79:	a1 3c df 11 c0       	mov    0xc011df3c,%eax
c0104a7e:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0104a81:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0104a84:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104a87:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104a8a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104a8d:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0104a90:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104a93:	8b 40 04             	mov    0x4(%eax),%eax
c0104a96:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104a99:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0104a9c:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104a9f:	89 55 c4             	mov    %edx,-0x3c(%ebp)
c0104aa2:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0104aa5:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104aa8:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0104aab:	89 10                	mov    %edx,(%eax)
c0104aad:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104ab0:	8b 10                	mov    (%eax),%edx
c0104ab2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104ab5:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104ab8:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104abb:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0104abe:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104ac1:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104ac4:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0104ac7:	89 10                	mov    %edx,(%eax)
}
c0104ac9:	90                   	nop
c0104aca:	c9                   	leave  
c0104acb:	c3                   	ret    

c0104acc <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c0104acc:	55                   	push   %ebp
c0104acd:	89 e5                	mov    %esp,%ebp
c0104acf:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c0104ad2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104ad6:	75 24                	jne    c0104afc <default_alloc_pages+0x30>
c0104ad8:	c7 44 24 0c 10 77 10 	movl   $0xc0107710,0xc(%esp)
c0104adf:	c0 
c0104ae0:	c7 44 24 08 16 77 10 	movl   $0xc0107716,0x8(%esp)
c0104ae7:	c0 
c0104ae8:	c7 44 24 04 82 00 00 	movl   $0x82,0x4(%esp)
c0104aef:	00 
c0104af0:	c7 04 24 2b 77 10 c0 	movl   $0xc010772b,(%esp)
c0104af7:	e8 ea b8 ff ff       	call   c01003e6 <__panic>
	/* There are not enough physical memory */
    if (n > nr_free) {
c0104afc:	a1 44 df 11 c0       	mov    0xc011df44,%eax
c0104b01:	39 45 08             	cmp    %eax,0x8(%ebp)
c0104b04:	76 26                	jbe    c0104b2c <default_alloc_pages+0x60>
		warn("memory shortage");
c0104b06:	c7 44 24 08 65 77 10 	movl   $0xc0107765,0x8(%esp)
c0104b0d:	c0 
c0104b0e:	c7 44 24 04 85 00 00 	movl   $0x85,0x4(%esp)
c0104b15:	00 
c0104b16:	c7 04 24 2b 77 10 c0 	movl   $0xc010772b,(%esp)
c0104b1d:	e8 42 b9 ff ff       	call   c0100464 <__warn>
        return NULL;
c0104b22:	b8 00 00 00 00       	mov    $0x0,%eax
c0104b27:	e9 96 01 00 00       	jmp    c0104cc2 <default_alloc_pages+0x1f6>
    }
    struct Page *page = NULL;
c0104b2c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	struct Page *p    = NULL;
c0104b33:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0104b3a:	c7 45 ec 3c df 11 c0 	movl   $0xc011df3c,-0x14(%ebp)
	/* try to find empty space to allocate */
    while ((le = list_next(le)) != &free_list) {
c0104b41:	eb 1c                	jmp    c0104b5f <default_alloc_pages+0x93>
        p = le2page(le, page_link);
c0104b43:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104b46:	83 e8 0c             	sub    $0xc,%eax
c0104b49:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p->property >= n) {
c0104b4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b4f:	8b 40 08             	mov    0x8(%eax),%eax
c0104b52:	39 45 08             	cmp    %eax,0x8(%ebp)
c0104b55:	77 08                	ja     c0104b5f <default_alloc_pages+0x93>
            page = p;
c0104b57:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c0104b5d:	eb 18                	jmp    c0104b77 <default_alloc_pages+0xab>
c0104b5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104b62:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return listelm->next;
c0104b65:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104b68:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0104b6b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104b6e:	81 7d ec 3c df 11 c0 	cmpl   $0xc011df3c,-0x14(%ebp)
c0104b75:	75 cc                	jne    c0104b43 <default_alloc_pages+0x77>
        }
    }
	/* external fragmentation */
	if (page == NULL) {
c0104b77:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104b7b:	75 26                	jne    c0104ba3 <default_alloc_pages+0xd7>
		warn("external fragmentation: There are enough memory, but can't find continuous space to allocate");
c0104b7d:	c7 44 24 08 78 77 10 	movl   $0xc0107778,0x8(%esp)
c0104b84:	c0 
c0104b85:	c7 44 24 04 95 00 00 	movl   $0x95,0x4(%esp)
c0104b8c:	00 
c0104b8d:	c7 04 24 2b 77 10 c0 	movl   $0xc010772b,(%esp)
c0104b94:	e8 cb b8 ff ff       	call   c0100464 <__warn>
		return NULL;
c0104b99:	b8 00 00 00 00       	mov    $0x0,%eax
c0104b9e:	e9 1f 01 00 00       	jmp    c0104cc2 <default_alloc_pages+0x1f6>
	}

	unsigned int property = page->property;
c0104ba3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ba6:	8b 40 08             	mov    0x8(%eax),%eax
c0104ba9:	89 45 e8             	mov    %eax,-0x18(%ebp)
	/* modify pages in allocated block(except of first page)*/
	p = page + 1;
c0104bac:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104baf:	83 c0 14             	add    $0x14,%eax
c0104bb2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	for (; p < page + n; ++p) {
c0104bb5:	eb 1d                	jmp    c0104bd4 <default_alloc_pages+0x108>
		ClearPageProperty(p);
c0104bb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104bba:	83 c0 04             	add    $0x4,%eax
c0104bbd:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c0104bc4:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104bc7:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104bca:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104bcd:	0f b3 10             	btr    %edx,(%eax)
	for (; p < page + n; ++p) {
c0104bd0:	83 45 f0 14          	addl   $0x14,-0x10(%ebp)
c0104bd4:	8b 55 08             	mov    0x8(%ebp),%edx
c0104bd7:	89 d0                	mov    %edx,%eax
c0104bd9:	c1 e0 02             	shl    $0x2,%eax
c0104bdc:	01 d0                	add    %edx,%eax
c0104bde:	c1 e0 02             	shl    $0x2,%eax
c0104be1:	89 c2                	mov    %eax,%edx
c0104be3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104be6:	01 d0                	add    %edx,%eax
c0104be8:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0104beb:	72 ca                	jb     c0104bb7 <default_alloc_pages+0xeb>
		// property is zero, so we needn't modiry it.
	}
	/* modify first page of allcoated block */
	ClearPageProperty(page);
c0104bed:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104bf0:	83 c0 04             	add    $0x4,%eax
c0104bf3:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
c0104bfa:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0104bfd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104c00:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104c03:	0f b3 10             	btr    %edx,(%eax)
	page->property = n;
c0104c06:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c09:	8b 55 08             	mov    0x8(%ebp),%edx
c0104c0c:	89 50 08             	mov    %edx,0x8(%eax)
	nr_free -= n;
c0104c0f:	a1 44 df 11 c0       	mov    0xc011df44,%eax
c0104c14:	2b 45 08             	sub    0x8(%ebp),%eax
c0104c17:	a3 44 df 11 c0       	mov    %eax,0xc011df44
	/*
	 * If block size is bigger than requested size, split it;
	 * */
	if (property > n) {
c0104c1c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104c1f:	3b 45 08             	cmp    0x8(%ebp),%eax
c0104c22:	76 70                	jbe    c0104c94 <default_alloc_pages+0x1c8>
		p = page + n;
c0104c24:	8b 55 08             	mov    0x8(%ebp),%edx
c0104c27:	89 d0                	mov    %edx,%eax
c0104c29:	c1 e0 02             	shl    $0x2,%eax
c0104c2c:	01 d0                	add    %edx,%eax
c0104c2e:	c1 e0 02             	shl    $0x2,%eax
c0104c31:	89 c2                	mov    %eax,%edx
c0104c33:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c36:	01 d0                	add    %edx,%eax
c0104c38:	89 45 f0             	mov    %eax,-0x10(%ebp)
		p->property = property - n;
c0104c3b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104c3e:	2b 45 08             	sub    0x8(%ebp),%eax
c0104c41:	89 c2                	mov    %eax,%edx
c0104c43:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c46:	89 50 08             	mov    %edx,0x8(%eax)
		list_add_after(&(page->page_link), &(p->page_link));
c0104c49:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c4c:	83 c0 0c             	add    $0xc,%eax
c0104c4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104c52:	83 c2 0c             	add    $0xc,%edx
c0104c55:	89 55 d0             	mov    %edx,-0x30(%ebp)
c0104c58:	89 45 cc             	mov    %eax,-0x34(%ebp)
    __list_add(elm, listelm, listelm->next);
c0104c5b:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104c5e:	8b 40 04             	mov    0x4(%eax),%eax
c0104c61:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104c64:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0104c67:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104c6a:	89 55 c4             	mov    %edx,-0x3c(%ebp)
c0104c6d:	89 45 c0             	mov    %eax,-0x40(%ebp)
    prev->next = next->prev = elm;
c0104c70:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104c73:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0104c76:	89 10                	mov    %edx,(%eax)
c0104c78:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104c7b:	8b 10                	mov    (%eax),%edx
c0104c7d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104c80:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104c83:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104c86:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0104c89:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104c8c:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104c8f:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0104c92:	89 10                	mov    %edx,(%eax)
	}
	list_del(&(page->page_link));
c0104c94:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c97:	83 c0 0c             	add    $0xc,%eax
c0104c9a:	89 45 bc             	mov    %eax,-0x44(%ebp)
    __list_del(listelm->prev, listelm->next);
c0104c9d:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104ca0:	8b 40 04             	mov    0x4(%eax),%eax
c0104ca3:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104ca6:	8b 12                	mov    (%edx),%edx
c0104ca8:	89 55 b8             	mov    %edx,-0x48(%ebp)
c0104cab:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0104cae:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104cb1:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0104cb4:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0104cb7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104cba:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0104cbd:	89 10                	mov    %edx,(%eax)
    return page;
c0104cbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0104cc2:	c9                   	leave  
c0104cc3:	c3                   	ret    

c0104cc4 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0104cc4:	55                   	push   %ebp
c0104cc5:	89 e5                	mov    %esp,%ebp
c0104cc7:	81 ec c8 00 00 00    	sub    $0xc8,%esp
    assert(n > 0);
c0104ccd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0104cd1:	75 24                	jne    c0104cf7 <default_free_pages+0x33>
c0104cd3:	c7 44 24 0c 10 77 10 	movl   $0xc0107710,0xc(%esp)
c0104cda:	c0 
c0104cdb:	c7 44 24 08 16 77 10 	movl   $0xc0107716,0x8(%esp)
c0104ce2:	c0 
c0104ce3:	c7 44 24 04 b2 00 00 	movl   $0xb2,0x4(%esp)
c0104cea:	00 
c0104ceb:	c7 04 24 2b 77 10 c0 	movl   $0xc010772b,(%esp)
c0104cf2:	e8 ef b6 ff ff       	call   c01003e6 <__panic>
	 */

	/* find the beginning of the allocated block.
	 * only begging page's #property fild is non-zero.
	 */
    struct Page *begin = base;
c0104cf7:	8b 45 08             	mov    0x8(%ebp),%eax
c0104cfa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	size_t count = 0;
c0104cfd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	for ( ; begin->property == 0; ++count, --begin) {
c0104d04:	e9 83 00 00 00       	jmp    c0104d8c <default_free_pages+0xc8>
		assert(!PageReserved(begin) && !PageProperty(begin));
c0104d09:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d0c:	83 c0 04             	add    $0x4,%eax
c0104d0f:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
c0104d16:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104d19:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104d1c:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104d1f:	0f a3 10             	bt     %edx,(%eax)
c0104d22:	19 c0                	sbb    %eax,%eax
c0104d24:	89 45 d0             	mov    %eax,-0x30(%ebp)
    return oldbit != 0;
c0104d27:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c0104d2b:	0f 95 c0             	setne  %al
c0104d2e:	0f b6 c0             	movzbl %al,%eax
c0104d31:	85 c0                	test   %eax,%eax
c0104d33:	75 2c                	jne    c0104d61 <default_free_pages+0x9d>
c0104d35:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d38:	83 c0 04             	add    $0x4,%eax
c0104d3b:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
c0104d42:	89 45 c8             	mov    %eax,-0x38(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104d45:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104d48:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104d4b:	0f a3 10             	bt     %edx,(%eax)
c0104d4e:	19 c0                	sbb    %eax,%eax
c0104d50:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return oldbit != 0;
c0104d53:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
c0104d57:	0f 95 c0             	setne  %al
c0104d5a:	0f b6 c0             	movzbl %al,%eax
c0104d5d:	85 c0                	test   %eax,%eax
c0104d5f:	74 24                	je     c0104d85 <default_free_pages+0xc1>
c0104d61:	c7 44 24 0c d8 77 10 	movl   $0xc01077d8,0xc(%esp)
c0104d68:	c0 
c0104d69:	c7 44 24 08 16 77 10 	movl   $0xc0107716,0x8(%esp)
c0104d70:	c0 
c0104d71:	c7 44 24 04 be 00 00 	movl   $0xbe,0x4(%esp)
c0104d78:	00 
c0104d79:	c7 04 24 2b 77 10 c0 	movl   $0xc010772b,(%esp)
c0104d80:	e8 61 b6 ff ff       	call   c01003e6 <__panic>
	for ( ; begin->property == 0; ++count, --begin) {
c0104d85:	ff 45 f0             	incl   -0x10(%ebp)
c0104d88:	83 6d f4 14          	subl   $0x14,-0xc(%ebp)
c0104d8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d8f:	8b 40 08             	mov    0x8(%eax),%eax
c0104d92:	85 c0                	test   %eax,%eax
c0104d94:	0f 84 6f ff ff ff    	je     c0104d09 <default_free_pages+0x45>
	/* If @base is not the beginning of the allocated block,
	 * split the allocated block into two part. 
	 * One part is @begin to @base, 
	 * other part is @base to the end of the original part.
	 */
	if (begin != base) {
c0104d9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d9d:	3b 45 08             	cmp    0x8(%ebp),%eax
c0104da0:	74 1a                	je     c0104dbc <default_free_pages+0xf8>
		base->property  = begin->property - count;
c0104da2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104da5:	8b 40 08             	mov    0x8(%eax),%eax
c0104da8:	2b 45 f0             	sub    -0x10(%ebp),%eax
c0104dab:	89 c2                	mov    %eax,%edx
c0104dad:	8b 45 08             	mov    0x8(%ebp),%eax
c0104db0:	89 50 08             	mov    %edx,0x8(%eax)
		begin->property = count;
c0104db3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104db6:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104db9:	89 50 08             	mov    %edx,0x8(%eax)
	}
	
	/* If @n is bigger than the number of pages in the @base block,
	 * it is not an error, just free all pages in block.
	 */
	if (n > base->property) {
c0104dbc:	8b 45 08             	mov    0x8(%ebp),%eax
c0104dbf:	8b 40 08             	mov    0x8(%eax),%eax
c0104dc2:	39 45 0c             	cmp    %eax,0xc(%ebp)
c0104dc5:	76 0b                	jbe    c0104dd2 <default_free_pages+0x10e>
		n = base->property;
c0104dc7:	8b 45 08             	mov    0x8(%ebp),%eax
c0104dca:	8b 40 08             	mov    0x8(%eax),%eax
c0104dcd:	89 45 0c             	mov    %eax,0xc(%ebp)
c0104dd0:	eb 36                	jmp    c0104e08 <default_free_pages+0x144>
	}
	/* If @n is smaller than the number of pages in @base block,
	 * split @base block into two block.
	 */
	else if (n < base->property) {
c0104dd2:	8b 45 08             	mov    0x8(%ebp),%eax
c0104dd5:	8b 40 08             	mov    0x8(%eax),%eax
c0104dd8:	39 45 0c             	cmp    %eax,0xc(%ebp)
c0104ddb:	73 2b                	jae    c0104e08 <default_free_pages+0x144>
		(base + n)->property = base->property - n;
c0104ddd:	8b 45 08             	mov    0x8(%ebp),%eax
c0104de0:	8b 48 08             	mov    0x8(%eax),%ecx
c0104de3:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104de6:	89 d0                	mov    %edx,%eax
c0104de8:	c1 e0 02             	shl    $0x2,%eax
c0104deb:	01 d0                	add    %edx,%eax
c0104ded:	c1 e0 02             	shl    $0x2,%eax
c0104df0:	89 c2                	mov    %eax,%edx
c0104df2:	8b 45 08             	mov    0x8(%ebp),%eax
c0104df5:	01 c2                	add    %eax,%edx
c0104df7:	89 c8                	mov    %ecx,%eax
c0104df9:	2b 45 0c             	sub    0xc(%ebp),%eax
c0104dfc:	89 42 08             	mov    %eax,0x8(%edx)
		base->property = n;
c0104dff:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e02:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104e05:	89 50 08             	mov    %edx,0x8(%eax)
	}	
	/* modify status information */
	struct Page *p = base;
c0104e08:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e0b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for (; p != base + n; ++p) {
c0104e0e:	e9 b6 00 00 00       	jmp    c0104ec9 <default_free_pages+0x205>
        assert(!PageReserved(p) && !PageProperty(p));
c0104e13:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104e16:	83 c0 04             	add    $0x4,%eax
c0104e19:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
c0104e20:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104e23:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104e26:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0104e29:	0f a3 10             	bt     %edx,(%eax)
c0104e2c:	19 c0                	sbb    %eax,%eax
c0104e2e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0104e31:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0104e35:	0f 95 c0             	setne  %al
c0104e38:	0f b6 c0             	movzbl %al,%eax
c0104e3b:	85 c0                	test   %eax,%eax
c0104e3d:	75 2c                	jne    c0104e6b <default_free_pages+0x1a7>
c0104e3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104e42:	83 c0 04             	add    $0x4,%eax
c0104e45:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
c0104e4c:	89 45 b0             	mov    %eax,-0x50(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104e4f:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104e52:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0104e55:	0f a3 10             	bt     %edx,(%eax)
c0104e58:	19 c0                	sbb    %eax,%eax
c0104e5a:	89 45 ac             	mov    %eax,-0x54(%ebp)
    return oldbit != 0;
c0104e5d:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
c0104e61:	0f 95 c0             	setne  %al
c0104e64:	0f b6 c0             	movzbl %al,%eax
c0104e67:	85 c0                	test   %eax,%eax
c0104e69:	74 24                	je     c0104e8f <default_free_pages+0x1cb>
c0104e6b:	c7 44 24 0c 08 78 10 	movl   $0xc0107808,0xc(%esp)
c0104e72:	c0 
c0104e73:	c7 44 24 08 16 77 10 	movl   $0xc0107716,0x8(%esp)
c0104e7a:	c0 
c0104e7b:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c0104e82:	00 
c0104e83:	c7 04 24 2b 77 10 c0 	movl   $0xc010772b,(%esp)
c0104e8a:	e8 57 b5 ff ff       	call   c01003e6 <__panic>
        p->flags = 0;
c0104e8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104e92:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
		SetPageProperty(p);
c0104e99:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104e9c:	83 c0 04             	add    $0x4,%eax
c0104e9f:	c7 45 a8 01 00 00 00 	movl   $0x1,-0x58(%ebp)
c0104ea6:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104ea9:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0104eac:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0104eaf:	0f ab 10             	bts    %edx,(%eax)
		set_page_ref(p, 0);
c0104eb2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104eb9:	00 
c0104eba:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104ebd:	89 04 24             	mov    %eax,(%esp)
c0104ec0:	e8 3b fa ff ff       	call   c0104900 <set_page_ref>
    for (; p != base + n; ++p) {
c0104ec5:	83 45 ec 14          	addl   $0x14,-0x14(%ebp)
c0104ec9:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104ecc:	89 d0                	mov    %edx,%eax
c0104ece:	c1 e0 02             	shl    $0x2,%eax
c0104ed1:	01 d0                	add    %edx,%eax
c0104ed3:	c1 e0 02             	shl    $0x2,%eax
c0104ed6:	89 c2                	mov    %eax,%edx
c0104ed8:	8b 45 08             	mov    0x8(%ebp),%eax
c0104edb:	01 d0                	add    %edx,%eax
c0104edd:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0104ee0:	0f 85 2d ff ff ff    	jne    c0104e13 <default_free_pages+0x14f>
c0104ee6:	c7 45 a0 3c df 11 c0 	movl   $0xc011df3c,-0x60(%ebp)
    return listelm->next;
c0104eed:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104ef0:	8b 40 04             	mov    0x4(%eax),%eax

	 // list_add(pos, &base->page_link);
	 // nr_free += n;
	
	 /* merge adjcent free blocks */
  	 list_entry_t *le = list_next(&free_list), *pos = free_list.prev, *merge_before_ptr = NULL;
c0104ef3:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104ef6:	a1 3c df 11 c0       	mov    0xc011df3c,%eax
c0104efb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104efe:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	 unsigned int old_base_property = base->property;
c0104f05:	8b 45 08             	mov    0x8(%ebp),%eax
c0104f08:	8b 40 08             	mov    0x8(%eax),%eax
c0104f0b:	89 45 dc             	mov    %eax,-0x24(%ebp)
	 /* merge free blocks */
 	 while (le != &free_list) {
c0104f0e:	e9 f8 00 00 00       	jmp    c010500b <default_free_pages+0x347>
		 p = le2page(le, page_link);
c0104f13:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104f16:	83 e8 0c             	sub    $0xc,%eax
c0104f19:	89 45 ec             	mov    %eax,-0x14(%ebp)
		 /* free_list is ascending sorted, only one free block before @base block will be merged */
		 if ((p + p->property == base)) {
c0104f1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104f1f:	8b 50 08             	mov    0x8(%eax),%edx
c0104f22:	89 d0                	mov    %edx,%eax
c0104f24:	c1 e0 02             	shl    $0x2,%eax
c0104f27:	01 d0                	add    %edx,%eax
c0104f29:	c1 e0 02             	shl    $0x2,%eax
c0104f2c:	89 c2                	mov    %eax,%edx
c0104f2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104f31:	01 d0                	add    %edx,%eax
c0104f33:	39 45 08             	cmp    %eax,0x8(%ebp)
c0104f36:	75 5a                	jne    c0104f92 <default_free_pages+0x2ce>
			 p->property      += base->property;
c0104f38:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104f3b:	8b 50 08             	mov    0x8(%eax),%edx
c0104f3e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104f41:	8b 40 08             	mov    0x8(%eax),%eax
c0104f44:	01 c2                	add    %eax,%edx
c0104f46:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104f49:	89 50 08             	mov    %edx,0x8(%eax)
			 base->property    = 0;
c0104f4c:	8b 45 08             	mov    0x8(%ebp),%eax
c0104f4f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			 base              = p;
c0104f56:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104f59:	89 45 08             	mov    %eax,0x8(%ebp)
			 pos               = le->prev;
c0104f5c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104f5f:	8b 00                	mov    (%eax),%eax
c0104f61:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			 merge_before_ptr  = le;
c0104f64:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104f67:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104f6a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104f6d:	89 45 9c             	mov    %eax,-0x64(%ebp)
    __list_del(listelm->prev, listelm->next);
c0104f70:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0104f73:	8b 40 04             	mov    0x4(%eax),%eax
c0104f76:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0104f79:	8b 12                	mov    (%edx),%edx
c0104f7b:	89 55 98             	mov    %edx,-0x68(%ebp)
c0104f7e:	89 45 94             	mov    %eax,-0x6c(%ebp)
    prev->next = next;
c0104f81:	8b 45 98             	mov    -0x68(%ebp),%eax
c0104f84:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0104f87:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0104f8a:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0104f8d:	8b 55 98             	mov    -0x68(%ebp),%edx
c0104f90:	89 10                	mov    %edx,(%eax)
			 list_del(le);
		 }
		 if ((base + base->property) == p) {
c0104f92:	8b 45 08             	mov    0x8(%ebp),%eax
c0104f95:	8b 50 08             	mov    0x8(%eax),%edx
c0104f98:	89 d0                	mov    %edx,%eax
c0104f9a:	c1 e0 02             	shl    $0x2,%eax
c0104f9d:	01 d0                	add    %edx,%eax
c0104f9f:	c1 e0 02             	shl    $0x2,%eax
c0104fa2:	89 c2                	mov    %eax,%edx
c0104fa4:	8b 45 08             	mov    0x8(%ebp),%eax
c0104fa7:	01 d0                	add    %edx,%eax
c0104fa9:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0104fac:	75 4e                	jne    c0104ffc <default_free_pages+0x338>
			 base->property += p->property;
c0104fae:	8b 45 08             	mov    0x8(%ebp),%eax
c0104fb1:	8b 50 08             	mov    0x8(%eax),%edx
c0104fb4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104fb7:	8b 40 08             	mov    0x8(%eax),%eax
c0104fba:	01 c2                	add    %eax,%edx
c0104fbc:	8b 45 08             	mov    0x8(%ebp),%eax
c0104fbf:	89 50 08             	mov    %edx,0x8(%eax)
			 p->property     = 0;
c0104fc2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104fc5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			 pos             = le->prev;
c0104fcc:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104fcf:	8b 00                	mov    (%eax),%eax
c0104fd1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104fd4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104fd7:	89 45 90             	mov    %eax,-0x70(%ebp)
    __list_del(listelm->prev, listelm->next);
c0104fda:	8b 45 90             	mov    -0x70(%ebp),%eax
c0104fdd:	8b 40 04             	mov    0x4(%eax),%eax
c0104fe0:	8b 55 90             	mov    -0x70(%ebp),%edx
c0104fe3:	8b 12                	mov    (%edx),%edx
c0104fe5:	89 55 8c             	mov    %edx,-0x74(%ebp)
c0104fe8:	89 45 88             	mov    %eax,-0x78(%ebp)
    prev->next = next;
c0104feb:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0104fee:	8b 55 88             	mov    -0x78(%ebp),%edx
c0104ff1:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0104ff4:	8b 45 88             	mov    -0x78(%ebp),%eax
c0104ff7:	8b 55 8c             	mov    -0x74(%ebp),%edx
c0104ffa:	89 10                	mov    %edx,(%eax)
c0104ffc:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104fff:	89 45 84             	mov    %eax,-0x7c(%ebp)
    return listelm->next;
c0105002:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0105005:	8b 40 04             	mov    0x4(%eax),%eax
			 list_del(le);
		 }
		 le = list_next(le);
c0105008:	89 45 e8             	mov    %eax,-0x18(%ebp)
 	 while (le != &free_list) {
c010500b:	81 7d e8 3c df 11 c0 	cmpl   $0xc011df3c,-0x18(%ebp)
c0105012:	0f 85 fb fe ff ff    	jne    c0104f13 <default_free_pages+0x24f>
	 }
	 /* if there may be free blocks before @base block, try to merge them */
	 if (merge_before_ptr != NULL) {
c0105018:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c010501c:	0f 84 b9 00 00 00    	je     c01050db <default_free_pages+0x417>
		 le = merge_before_ptr->prev;
c0105022:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105025:	8b 00                	mov    (%eax),%eax
c0105027:	89 45 e8             	mov    %eax,-0x18(%ebp)
		 while (le != &free_list) {
c010502a:	e9 9f 00 00 00       	jmp    c01050ce <default_free_pages+0x40a>
			 p = le2page(le, page_link);
c010502f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105032:	83 e8 0c             	sub    $0xc,%eax
c0105035:	89 45 ec             	mov    %eax,-0x14(%ebp)
			 if (p + p->property == base) {
c0105038:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010503b:	8b 50 08             	mov    0x8(%eax),%edx
c010503e:	89 d0                	mov    %edx,%eax
c0105040:	c1 e0 02             	shl    $0x2,%eax
c0105043:	01 d0                	add    %edx,%eax
c0105045:	c1 e0 02             	shl    $0x2,%eax
c0105048:	89 c2                	mov    %eax,%edx
c010504a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010504d:	01 d0                	add    %edx,%eax
c010504f:	39 45 08             	cmp    %eax,0x8(%ebp)
c0105052:	75 66                	jne    c01050ba <default_free_pages+0x3f6>
				 p->property    += base->property;
c0105054:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105057:	8b 50 08             	mov    0x8(%eax),%edx
c010505a:	8b 45 08             	mov    0x8(%ebp),%eax
c010505d:	8b 40 08             	mov    0x8(%eax),%eax
c0105060:	01 c2                	add    %eax,%edx
c0105062:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105065:	89 50 08             	mov    %edx,0x8(%eax)
				 base->property  = 0;
c0105068:	8b 45 08             	mov    0x8(%ebp),%eax
c010506b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				 base            = p;
c0105072:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105075:	89 45 08             	mov    %eax,0x8(%ebp)
				 pos             = le->prev;
c0105078:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010507b:	8b 00                	mov    (%eax),%eax
c010507d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105080:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105083:	89 45 80             	mov    %eax,-0x80(%ebp)
    __list_del(listelm->prev, listelm->next);
c0105086:	8b 45 80             	mov    -0x80(%ebp),%eax
c0105089:	8b 40 04             	mov    0x4(%eax),%eax
c010508c:	8b 55 80             	mov    -0x80(%ebp),%edx
c010508f:	8b 12                	mov    (%edx),%edx
c0105091:	89 95 7c ff ff ff    	mov    %edx,-0x84(%ebp)
c0105097:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
    prev->next = next;
c010509d:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c01050a3:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
c01050a9:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01050ac:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
c01050b2:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
c01050b8:	89 10                	mov    %edx,(%eax)
c01050ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01050bd:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
    return listelm->prev;
c01050c3:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
c01050c9:	8b 00                	mov    (%eax),%eax
				 list_del(le);
			 }
			 le = list_prev(le);
c01050cb:	89 45 e8             	mov    %eax,-0x18(%ebp)
		 while (le != &free_list) {
c01050ce:	81 7d e8 3c df 11 c0 	cmpl   $0xc011df3c,-0x18(%ebp)
c01050d5:	0f 85 54 ff ff ff    	jne    c010502f <default_free_pages+0x36b>
		 }
	 } 
	 /* @pos indicate position in whith @base's page_link should insert;
	  * only when there are no adjcent free blocks, should we try to find insertion position
	  */
	 if (base->property == old_base_property) {
c01050db:	8b 45 08             	mov    0x8(%ebp),%eax
c01050de:	8b 40 08             	mov    0x8(%eax),%eax
c01050e1:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01050e4:	0f 85 90 00 00 00    	jne    c010517a <default_free_pages+0x4b6>
c01050ea:	c7 85 70 ff ff ff 3c 	movl   $0xc011df3c,-0x90(%ebp)
c01050f1:	df 11 c0 
    return listelm->next;
c01050f4:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
c01050fa:	8b 40 04             	mov    0x4(%eax),%eax
		 le = list_next(&free_list);
c01050fd:	89 45 e8             	mov    %eax,-0x18(%ebp)
		 while (le != &free_list) {
c0105100:	eb 6f                	jmp    c0105171 <default_free_pages+0x4ad>
			 if (le2page(le, page_link) > base) {
c0105102:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105105:	83 e8 0c             	sub    $0xc,%eax
c0105108:	39 45 08             	cmp    %eax,0x8(%ebp)
c010510b:	73 4f                	jae    c010515c <default_free_pages+0x498>
				 assert((base + base->property) < le2page(le, page_link));
c010510d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105110:	8b 50 08             	mov    0x8(%eax),%edx
c0105113:	89 d0                	mov    %edx,%eax
c0105115:	c1 e0 02             	shl    $0x2,%eax
c0105118:	01 d0                	add    %edx,%eax
c010511a:	c1 e0 02             	shl    $0x2,%eax
c010511d:	89 c2                	mov    %eax,%edx
c010511f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105122:	01 c2                	add    %eax,%edx
c0105124:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105127:	83 e8 0c             	sub    $0xc,%eax
c010512a:	39 c2                	cmp    %eax,%edx
c010512c:	72 24                	jb     c0105152 <default_free_pages+0x48e>
c010512e:	c7 44 24 0c 30 78 10 	movl   $0xc0107830,0xc(%esp)
c0105135:	c0 
c0105136:	c7 44 24 08 16 77 10 	movl   $0xc0107716,0x8(%esp)
c010513d:	c0 
c010513e:	c7 44 24 04 3e 01 00 	movl   $0x13e,0x4(%esp)
c0105145:	00 
c0105146:	c7 04 24 2b 77 10 c0 	movl   $0xc010772b,(%esp)
c010514d:	e8 94 b2 ff ff       	call   c01003e6 <__panic>
				 pos = le->prev;
c0105152:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105155:	8b 00                	mov    (%eax),%eax
c0105157:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				 break;
c010515a:	eb 1e                	jmp    c010517a <default_free_pages+0x4b6>
c010515c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010515f:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
c0105165:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
c010516b:	8b 40 04             	mov    0x4(%eax),%eax
			 }
			 le = list_next(le);
c010516e:	89 45 e8             	mov    %eax,-0x18(%ebp)
		 while (le != &free_list) {
c0105171:	81 7d e8 3c df 11 c0 	cmpl   $0xc011df3c,-0x18(%ebp)
c0105178:	75 88                	jne    c0105102 <default_free_pages+0x43e>
		 }
	 }
	 list_add(pos, &base->page_link);
c010517a:	8b 45 08             	mov    0x8(%ebp),%eax
c010517d:	8d 50 0c             	lea    0xc(%eax),%edx
c0105180:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105183:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
c0105189:	89 95 64 ff ff ff    	mov    %edx,-0x9c(%ebp)
c010518f:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
c0105195:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
c010519b:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
c01051a1:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
    __list_add(elm, listelm, listelm->next);
c01051a7:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
c01051ad:	8b 40 04             	mov    0x4(%eax),%eax
c01051b0:	8b 95 5c ff ff ff    	mov    -0xa4(%ebp),%edx
c01051b6:	89 95 58 ff ff ff    	mov    %edx,-0xa8(%ebp)
c01051bc:	8b 95 60 ff ff ff    	mov    -0xa0(%ebp),%edx
c01051c2:	89 95 54 ff ff ff    	mov    %edx,-0xac(%ebp)
c01051c8:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
    prev->next = next->prev = elm;
c01051ce:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
c01051d4:	8b 95 58 ff ff ff    	mov    -0xa8(%ebp),%edx
c01051da:	89 10                	mov    %edx,(%eax)
c01051dc:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
c01051e2:	8b 10                	mov    (%eax),%edx
c01051e4:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
c01051ea:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01051ed:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
c01051f3:	8b 95 50 ff ff ff    	mov    -0xb0(%ebp),%edx
c01051f9:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01051fc:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
c0105202:	8b 95 54 ff ff ff    	mov    -0xac(%ebp),%edx
c0105208:	89 10                	mov    %edx,(%eax)
	 nr_free += n;
c010520a:	8b 15 44 df 11 c0    	mov    0xc011df44,%edx
c0105210:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105213:	01 d0                	add    %edx,%eax
c0105215:	a3 44 df 11 c0       	mov    %eax,0xc011df44
}
c010521a:	90                   	nop
c010521b:	c9                   	leave  
c010521c:	c3                   	ret    

c010521d <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c010521d:	55                   	push   %ebp
c010521e:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0105220:	a1 44 df 11 c0       	mov    0xc011df44,%eax
}
c0105225:	5d                   	pop    %ebp
c0105226:	c3                   	ret    

c0105227 <basic_check>:

static void
basic_check(void) {
c0105227:	55                   	push   %ebp
c0105228:	89 e5                	mov    %esp,%ebp
c010522a:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c010522d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0105234:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105237:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010523a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010523d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0105240:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105247:	e8 d0 dd ff ff       	call   c010301c <alloc_pages>
c010524c:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010524f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0105253:	75 24                	jne    c0105279 <basic_check+0x52>
c0105255:	c7 44 24 0c 61 78 10 	movl   $0xc0107861,0xc(%esp)
c010525c:	c0 
c010525d:	c7 44 24 08 16 77 10 	movl   $0xc0107716,0x8(%esp)
c0105264:	c0 
c0105265:	c7 44 24 04 52 01 00 	movl   $0x152,0x4(%esp)
c010526c:	00 
c010526d:	c7 04 24 2b 77 10 c0 	movl   $0xc010772b,(%esp)
c0105274:	e8 6d b1 ff ff       	call   c01003e6 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0105279:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105280:	e8 97 dd ff ff       	call   c010301c <alloc_pages>
c0105285:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105288:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010528c:	75 24                	jne    c01052b2 <basic_check+0x8b>
c010528e:	c7 44 24 0c 7d 78 10 	movl   $0xc010787d,0xc(%esp)
c0105295:	c0 
c0105296:	c7 44 24 08 16 77 10 	movl   $0xc0107716,0x8(%esp)
c010529d:	c0 
c010529e:	c7 44 24 04 53 01 00 	movl   $0x153,0x4(%esp)
c01052a5:	00 
c01052a6:	c7 04 24 2b 77 10 c0 	movl   $0xc010772b,(%esp)
c01052ad:	e8 34 b1 ff ff       	call   c01003e6 <__panic>
    assert((p2 = alloc_page()) != NULL);
c01052b2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01052b9:	e8 5e dd ff ff       	call   c010301c <alloc_pages>
c01052be:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01052c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01052c5:	75 24                	jne    c01052eb <basic_check+0xc4>
c01052c7:	c7 44 24 0c 99 78 10 	movl   $0xc0107899,0xc(%esp)
c01052ce:	c0 
c01052cf:	c7 44 24 08 16 77 10 	movl   $0xc0107716,0x8(%esp)
c01052d6:	c0 
c01052d7:	c7 44 24 04 54 01 00 	movl   $0x154,0x4(%esp)
c01052de:	00 
c01052df:	c7 04 24 2b 77 10 c0 	movl   $0xc010772b,(%esp)
c01052e6:	e8 fb b0 ff ff       	call   c01003e6 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c01052eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01052ee:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01052f1:	74 10                	je     c0105303 <basic_check+0xdc>
c01052f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01052f6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01052f9:	74 08                	je     c0105303 <basic_check+0xdc>
c01052fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01052fe:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105301:	75 24                	jne    c0105327 <basic_check+0x100>
c0105303:	c7 44 24 0c b8 78 10 	movl   $0xc01078b8,0xc(%esp)
c010530a:	c0 
c010530b:	c7 44 24 08 16 77 10 	movl   $0xc0107716,0x8(%esp)
c0105312:	c0 
c0105313:	c7 44 24 04 56 01 00 	movl   $0x156,0x4(%esp)
c010531a:	00 
c010531b:	c7 04 24 2b 77 10 c0 	movl   $0xc010772b,(%esp)
c0105322:	e8 bf b0 ff ff       	call   c01003e6 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0105327:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010532a:	89 04 24             	mov    %eax,(%esp)
c010532d:	e8 c4 f5 ff ff       	call   c01048f6 <page_ref>
c0105332:	85 c0                	test   %eax,%eax
c0105334:	75 1e                	jne    c0105354 <basic_check+0x12d>
c0105336:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105339:	89 04 24             	mov    %eax,(%esp)
c010533c:	e8 b5 f5 ff ff       	call   c01048f6 <page_ref>
c0105341:	85 c0                	test   %eax,%eax
c0105343:	75 0f                	jne    c0105354 <basic_check+0x12d>
c0105345:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105348:	89 04 24             	mov    %eax,(%esp)
c010534b:	e8 a6 f5 ff ff       	call   c01048f6 <page_ref>
c0105350:	85 c0                	test   %eax,%eax
c0105352:	74 24                	je     c0105378 <basic_check+0x151>
c0105354:	c7 44 24 0c dc 78 10 	movl   $0xc01078dc,0xc(%esp)
c010535b:	c0 
c010535c:	c7 44 24 08 16 77 10 	movl   $0xc0107716,0x8(%esp)
c0105363:	c0 
c0105364:	c7 44 24 04 57 01 00 	movl   $0x157,0x4(%esp)
c010536b:	00 
c010536c:	c7 04 24 2b 77 10 c0 	movl   $0xc010772b,(%esp)
c0105373:	e8 6e b0 ff ff       	call   c01003e6 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0105378:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010537b:	89 04 24             	mov    %eax,(%esp)
c010537e:	e8 5d f5 ff ff       	call   c01048e0 <page2pa>
c0105383:	8b 15 a0 de 11 c0    	mov    0xc011dea0,%edx
c0105389:	c1 e2 0c             	shl    $0xc,%edx
c010538c:	39 d0                	cmp    %edx,%eax
c010538e:	72 24                	jb     c01053b4 <basic_check+0x18d>
c0105390:	c7 44 24 0c 18 79 10 	movl   $0xc0107918,0xc(%esp)
c0105397:	c0 
c0105398:	c7 44 24 08 16 77 10 	movl   $0xc0107716,0x8(%esp)
c010539f:	c0 
c01053a0:	c7 44 24 04 59 01 00 	movl   $0x159,0x4(%esp)
c01053a7:	00 
c01053a8:	c7 04 24 2b 77 10 c0 	movl   $0xc010772b,(%esp)
c01053af:	e8 32 b0 ff ff       	call   c01003e6 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c01053b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01053b7:	89 04 24             	mov    %eax,(%esp)
c01053ba:	e8 21 f5 ff ff       	call   c01048e0 <page2pa>
c01053bf:	8b 15 a0 de 11 c0    	mov    0xc011dea0,%edx
c01053c5:	c1 e2 0c             	shl    $0xc,%edx
c01053c8:	39 d0                	cmp    %edx,%eax
c01053ca:	72 24                	jb     c01053f0 <basic_check+0x1c9>
c01053cc:	c7 44 24 0c 35 79 10 	movl   $0xc0107935,0xc(%esp)
c01053d3:	c0 
c01053d4:	c7 44 24 08 16 77 10 	movl   $0xc0107716,0x8(%esp)
c01053db:	c0 
c01053dc:	c7 44 24 04 5a 01 00 	movl   $0x15a,0x4(%esp)
c01053e3:	00 
c01053e4:	c7 04 24 2b 77 10 c0 	movl   $0xc010772b,(%esp)
c01053eb:	e8 f6 af ff ff       	call   c01003e6 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c01053f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01053f3:	89 04 24             	mov    %eax,(%esp)
c01053f6:	e8 e5 f4 ff ff       	call   c01048e0 <page2pa>
c01053fb:	8b 15 a0 de 11 c0    	mov    0xc011dea0,%edx
c0105401:	c1 e2 0c             	shl    $0xc,%edx
c0105404:	39 d0                	cmp    %edx,%eax
c0105406:	72 24                	jb     c010542c <basic_check+0x205>
c0105408:	c7 44 24 0c 52 79 10 	movl   $0xc0107952,0xc(%esp)
c010540f:	c0 
c0105410:	c7 44 24 08 16 77 10 	movl   $0xc0107716,0x8(%esp)
c0105417:	c0 
c0105418:	c7 44 24 04 5b 01 00 	movl   $0x15b,0x4(%esp)
c010541f:	00 
c0105420:	c7 04 24 2b 77 10 c0 	movl   $0xc010772b,(%esp)
c0105427:	e8 ba af ff ff       	call   c01003e6 <__panic>

    list_entry_t free_list_store = free_list;
c010542c:	a1 3c df 11 c0       	mov    0xc011df3c,%eax
c0105431:	8b 15 40 df 11 c0    	mov    0xc011df40,%edx
c0105437:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010543a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010543d:	c7 45 dc 3c df 11 c0 	movl   $0xc011df3c,-0x24(%ebp)
    elm->prev = elm->next = elm;
c0105444:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105447:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010544a:	89 50 04             	mov    %edx,0x4(%eax)
c010544d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105450:	8b 50 04             	mov    0x4(%eax),%edx
c0105453:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105456:	89 10                	mov    %edx,(%eax)
c0105458:	c7 45 e0 3c df 11 c0 	movl   $0xc011df3c,-0x20(%ebp)
    return list->next == list;
c010545f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105462:	8b 40 04             	mov    0x4(%eax),%eax
c0105465:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0105468:	0f 94 c0             	sete   %al
c010546b:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c010546e:	85 c0                	test   %eax,%eax
c0105470:	75 24                	jne    c0105496 <basic_check+0x26f>
c0105472:	c7 44 24 0c 6f 79 10 	movl   $0xc010796f,0xc(%esp)
c0105479:	c0 
c010547a:	c7 44 24 08 16 77 10 	movl   $0xc0107716,0x8(%esp)
c0105481:	c0 
c0105482:	c7 44 24 04 5f 01 00 	movl   $0x15f,0x4(%esp)
c0105489:	00 
c010548a:	c7 04 24 2b 77 10 c0 	movl   $0xc010772b,(%esp)
c0105491:	e8 50 af ff ff       	call   c01003e6 <__panic>

    unsigned int nr_free_store = nr_free;
c0105496:	a1 44 df 11 c0       	mov    0xc011df44,%eax
c010549b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c010549e:	c7 05 44 df 11 c0 00 	movl   $0x0,0xc011df44
c01054a5:	00 00 00 

    assert(alloc_page() == NULL);
c01054a8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01054af:	e8 68 db ff ff       	call   c010301c <alloc_pages>
c01054b4:	85 c0                	test   %eax,%eax
c01054b6:	74 24                	je     c01054dc <basic_check+0x2b5>
c01054b8:	c7 44 24 0c 86 79 10 	movl   $0xc0107986,0xc(%esp)
c01054bf:	c0 
c01054c0:	c7 44 24 08 16 77 10 	movl   $0xc0107716,0x8(%esp)
c01054c7:	c0 
c01054c8:	c7 44 24 04 64 01 00 	movl   $0x164,0x4(%esp)
c01054cf:	00 
c01054d0:	c7 04 24 2b 77 10 c0 	movl   $0xc010772b,(%esp)
c01054d7:	e8 0a af ff ff       	call   c01003e6 <__panic>

    free_page(p0);
c01054dc:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01054e3:	00 
c01054e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01054e7:	89 04 24             	mov    %eax,(%esp)
c01054ea:	e8 65 db ff ff       	call   c0103054 <free_pages>
    free_page(p1);
c01054ef:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01054f6:	00 
c01054f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01054fa:	89 04 24             	mov    %eax,(%esp)
c01054fd:	e8 52 db ff ff       	call   c0103054 <free_pages>
    free_page(p2);
c0105502:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105509:	00 
c010550a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010550d:	89 04 24             	mov    %eax,(%esp)
c0105510:	e8 3f db ff ff       	call   c0103054 <free_pages>
    assert(nr_free == 3);
c0105515:	a1 44 df 11 c0       	mov    0xc011df44,%eax
c010551a:	83 f8 03             	cmp    $0x3,%eax
c010551d:	74 24                	je     c0105543 <basic_check+0x31c>
c010551f:	c7 44 24 0c 9b 79 10 	movl   $0xc010799b,0xc(%esp)
c0105526:	c0 
c0105527:	c7 44 24 08 16 77 10 	movl   $0xc0107716,0x8(%esp)
c010552e:	c0 
c010552f:	c7 44 24 04 69 01 00 	movl   $0x169,0x4(%esp)
c0105536:	00 
c0105537:	c7 04 24 2b 77 10 c0 	movl   $0xc010772b,(%esp)
c010553e:	e8 a3 ae ff ff       	call   c01003e6 <__panic>

    assert((p0 = alloc_page()) != NULL);
c0105543:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010554a:	e8 cd da ff ff       	call   c010301c <alloc_pages>
c010554f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105552:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0105556:	75 24                	jne    c010557c <basic_check+0x355>
c0105558:	c7 44 24 0c 61 78 10 	movl   $0xc0107861,0xc(%esp)
c010555f:	c0 
c0105560:	c7 44 24 08 16 77 10 	movl   $0xc0107716,0x8(%esp)
c0105567:	c0 
c0105568:	c7 44 24 04 6b 01 00 	movl   $0x16b,0x4(%esp)
c010556f:	00 
c0105570:	c7 04 24 2b 77 10 c0 	movl   $0xc010772b,(%esp)
c0105577:	e8 6a ae ff ff       	call   c01003e6 <__panic>
    assert((p1 = alloc_page()) != NULL);
c010557c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105583:	e8 94 da ff ff       	call   c010301c <alloc_pages>
c0105588:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010558b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010558f:	75 24                	jne    c01055b5 <basic_check+0x38e>
c0105591:	c7 44 24 0c 7d 78 10 	movl   $0xc010787d,0xc(%esp)
c0105598:	c0 
c0105599:	c7 44 24 08 16 77 10 	movl   $0xc0107716,0x8(%esp)
c01055a0:	c0 
c01055a1:	c7 44 24 04 6c 01 00 	movl   $0x16c,0x4(%esp)
c01055a8:	00 
c01055a9:	c7 04 24 2b 77 10 c0 	movl   $0xc010772b,(%esp)
c01055b0:	e8 31 ae ff ff       	call   c01003e6 <__panic>
    assert((p2 = alloc_page()) != NULL);
c01055b5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01055bc:	e8 5b da ff ff       	call   c010301c <alloc_pages>
c01055c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01055c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01055c8:	75 24                	jne    c01055ee <basic_check+0x3c7>
c01055ca:	c7 44 24 0c 99 78 10 	movl   $0xc0107899,0xc(%esp)
c01055d1:	c0 
c01055d2:	c7 44 24 08 16 77 10 	movl   $0xc0107716,0x8(%esp)
c01055d9:	c0 
c01055da:	c7 44 24 04 6d 01 00 	movl   $0x16d,0x4(%esp)
c01055e1:	00 
c01055e2:	c7 04 24 2b 77 10 c0 	movl   $0xc010772b,(%esp)
c01055e9:	e8 f8 ad ff ff       	call   c01003e6 <__panic>

    assert(alloc_page() == NULL);
c01055ee:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01055f5:	e8 22 da ff ff       	call   c010301c <alloc_pages>
c01055fa:	85 c0                	test   %eax,%eax
c01055fc:	74 24                	je     c0105622 <basic_check+0x3fb>
c01055fe:	c7 44 24 0c 86 79 10 	movl   $0xc0107986,0xc(%esp)
c0105605:	c0 
c0105606:	c7 44 24 08 16 77 10 	movl   $0xc0107716,0x8(%esp)
c010560d:	c0 
c010560e:	c7 44 24 04 6f 01 00 	movl   $0x16f,0x4(%esp)
c0105615:	00 
c0105616:	c7 04 24 2b 77 10 c0 	movl   $0xc010772b,(%esp)
c010561d:	e8 c4 ad ff ff       	call   c01003e6 <__panic>

    free_page(p0);
c0105622:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105629:	00 
c010562a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010562d:	89 04 24             	mov    %eax,(%esp)
c0105630:	e8 1f da ff ff       	call   c0103054 <free_pages>
c0105635:	c7 45 d8 3c df 11 c0 	movl   $0xc011df3c,-0x28(%ebp)
c010563c:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010563f:	8b 40 04             	mov    0x4(%eax),%eax
c0105642:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0105645:	0f 94 c0             	sete   %al
c0105648:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c010564b:	85 c0                	test   %eax,%eax
c010564d:	74 24                	je     c0105673 <basic_check+0x44c>
c010564f:	c7 44 24 0c a8 79 10 	movl   $0xc01079a8,0xc(%esp)
c0105656:	c0 
c0105657:	c7 44 24 08 16 77 10 	movl   $0xc0107716,0x8(%esp)
c010565e:	c0 
c010565f:	c7 44 24 04 72 01 00 	movl   $0x172,0x4(%esp)
c0105666:	00 
c0105667:	c7 04 24 2b 77 10 c0 	movl   $0xc010772b,(%esp)
c010566e:	e8 73 ad ff ff       	call   c01003e6 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0105673:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010567a:	e8 9d d9 ff ff       	call   c010301c <alloc_pages>
c010567f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105682:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105685:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105688:	74 24                	je     c01056ae <basic_check+0x487>
c010568a:	c7 44 24 0c c0 79 10 	movl   $0xc01079c0,0xc(%esp)
c0105691:	c0 
c0105692:	c7 44 24 08 16 77 10 	movl   $0xc0107716,0x8(%esp)
c0105699:	c0 
c010569a:	c7 44 24 04 75 01 00 	movl   $0x175,0x4(%esp)
c01056a1:	00 
c01056a2:	c7 04 24 2b 77 10 c0 	movl   $0xc010772b,(%esp)
c01056a9:	e8 38 ad ff ff       	call   c01003e6 <__panic>
    assert(alloc_page() == NULL);
c01056ae:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01056b5:	e8 62 d9 ff ff       	call   c010301c <alloc_pages>
c01056ba:	85 c0                	test   %eax,%eax
c01056bc:	74 24                	je     c01056e2 <basic_check+0x4bb>
c01056be:	c7 44 24 0c 86 79 10 	movl   $0xc0107986,0xc(%esp)
c01056c5:	c0 
c01056c6:	c7 44 24 08 16 77 10 	movl   $0xc0107716,0x8(%esp)
c01056cd:	c0 
c01056ce:	c7 44 24 04 76 01 00 	movl   $0x176,0x4(%esp)
c01056d5:	00 
c01056d6:	c7 04 24 2b 77 10 c0 	movl   $0xc010772b,(%esp)
c01056dd:	e8 04 ad ff ff       	call   c01003e6 <__panic>

    assert(nr_free == 0);
c01056e2:	a1 44 df 11 c0       	mov    0xc011df44,%eax
c01056e7:	85 c0                	test   %eax,%eax
c01056e9:	74 24                	je     c010570f <basic_check+0x4e8>
c01056eb:	c7 44 24 0c d9 79 10 	movl   $0xc01079d9,0xc(%esp)
c01056f2:	c0 
c01056f3:	c7 44 24 08 16 77 10 	movl   $0xc0107716,0x8(%esp)
c01056fa:	c0 
c01056fb:	c7 44 24 04 78 01 00 	movl   $0x178,0x4(%esp)
c0105702:	00 
c0105703:	c7 04 24 2b 77 10 c0 	movl   $0xc010772b,(%esp)
c010570a:	e8 d7 ac ff ff       	call   c01003e6 <__panic>
    free_list = free_list_store;
c010570f:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105712:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105715:	a3 3c df 11 c0       	mov    %eax,0xc011df3c
c010571a:	89 15 40 df 11 c0    	mov    %edx,0xc011df40
    nr_free = nr_free_store;
c0105720:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105723:	a3 44 df 11 c0       	mov    %eax,0xc011df44

    free_page(p);
c0105728:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010572f:	00 
c0105730:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105733:	89 04 24             	mov    %eax,(%esp)
c0105736:	e8 19 d9 ff ff       	call   c0103054 <free_pages>
    free_page(p1);
c010573b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105742:	00 
c0105743:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105746:	89 04 24             	mov    %eax,(%esp)
c0105749:	e8 06 d9 ff ff       	call   c0103054 <free_pages>
    free_page(p2);
c010574e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105755:	00 
c0105756:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105759:	89 04 24             	mov    %eax,(%esp)
c010575c:	e8 f3 d8 ff ff       	call   c0103054 <free_pages>
}
c0105761:	90                   	nop
c0105762:	c9                   	leave  
c0105763:	c3                   	ret    

c0105764 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0105764:	55                   	push   %ebp
c0105765:	89 e5                	mov    %esp,%ebp
c0105767:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
c010576d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0105774:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c010577b:	c7 45 ec 3c df 11 c0 	movl   $0xc011df3c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0105782:	eb 6a                	jmp    c01057ee <default_check+0x8a>
        struct Page *p = le2page(le, page_link);
c0105784:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105787:	83 e8 0c             	sub    $0xc,%eax
c010578a:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c010578d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105790:	83 c0 04             	add    $0x4,%eax
c0105793:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c010579a:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010579d:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01057a0:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01057a3:	0f a3 10             	bt     %edx,(%eax)
c01057a6:	19 c0                	sbb    %eax,%eax
c01057a8:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c01057ab:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c01057af:	0f 95 c0             	setne  %al
c01057b2:	0f b6 c0             	movzbl %al,%eax
c01057b5:	85 c0                	test   %eax,%eax
c01057b7:	75 24                	jne    c01057dd <default_check+0x79>
c01057b9:	c7 44 24 0c e6 79 10 	movl   $0xc01079e6,0xc(%esp)
c01057c0:	c0 
c01057c1:	c7 44 24 08 16 77 10 	movl   $0xc0107716,0x8(%esp)
c01057c8:	c0 
c01057c9:	c7 44 24 04 89 01 00 	movl   $0x189,0x4(%esp)
c01057d0:	00 
c01057d1:	c7 04 24 2b 77 10 c0 	movl   $0xc010772b,(%esp)
c01057d8:	e8 09 ac ff ff       	call   c01003e6 <__panic>
        count ++, total += p->property;
c01057dd:	ff 45 f4             	incl   -0xc(%ebp)
c01057e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01057e3:	8b 50 08             	mov    0x8(%eax),%edx
c01057e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01057e9:	01 d0                	add    %edx,%eax
c01057eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01057ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01057f1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
c01057f4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01057f7:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c01057fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01057fd:	81 7d ec 3c df 11 c0 	cmpl   $0xc011df3c,-0x14(%ebp)
c0105804:	0f 85 7a ff ff ff    	jne    c0105784 <default_check+0x20>
    }
    assert(total == nr_free_pages());
c010580a:	e8 78 d8 ff ff       	call   c0103087 <nr_free_pages>
c010580f:	89 c2                	mov    %eax,%edx
c0105811:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105814:	39 c2                	cmp    %eax,%edx
c0105816:	74 24                	je     c010583c <default_check+0xd8>
c0105818:	c7 44 24 0c f6 79 10 	movl   $0xc01079f6,0xc(%esp)
c010581f:	c0 
c0105820:	c7 44 24 08 16 77 10 	movl   $0xc0107716,0x8(%esp)
c0105827:	c0 
c0105828:	c7 44 24 04 8c 01 00 	movl   $0x18c,0x4(%esp)
c010582f:	00 
c0105830:	c7 04 24 2b 77 10 c0 	movl   $0xc010772b,(%esp)
c0105837:	e8 aa ab ff ff       	call   c01003e6 <__panic>

    basic_check();
c010583c:	e8 e6 f9 ff ff       	call   c0105227 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0105841:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0105848:	e8 cf d7 ff ff       	call   c010301c <alloc_pages>
c010584d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c0105850:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105854:	75 24                	jne    c010587a <default_check+0x116>
c0105856:	c7 44 24 0c 0f 7a 10 	movl   $0xc0107a0f,0xc(%esp)
c010585d:	c0 
c010585e:	c7 44 24 08 16 77 10 	movl   $0xc0107716,0x8(%esp)
c0105865:	c0 
c0105866:	c7 44 24 04 91 01 00 	movl   $0x191,0x4(%esp)
c010586d:	00 
c010586e:	c7 04 24 2b 77 10 c0 	movl   $0xc010772b,(%esp)
c0105875:	e8 6c ab ff ff       	call   c01003e6 <__panic>
    assert(!PageProperty(p0));
c010587a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010587d:	83 c0 04             	add    $0x4,%eax
c0105880:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0105887:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010588a:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010588d:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0105890:	0f a3 10             	bt     %edx,(%eax)
c0105893:	19 c0                	sbb    %eax,%eax
c0105895:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0105898:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c010589c:	0f 95 c0             	setne  %al
c010589f:	0f b6 c0             	movzbl %al,%eax
c01058a2:	85 c0                	test   %eax,%eax
c01058a4:	74 24                	je     c01058ca <default_check+0x166>
c01058a6:	c7 44 24 0c 1a 7a 10 	movl   $0xc0107a1a,0xc(%esp)
c01058ad:	c0 
c01058ae:	c7 44 24 08 16 77 10 	movl   $0xc0107716,0x8(%esp)
c01058b5:	c0 
c01058b6:	c7 44 24 04 92 01 00 	movl   $0x192,0x4(%esp)
c01058bd:	00 
c01058be:	c7 04 24 2b 77 10 c0 	movl   $0xc010772b,(%esp)
c01058c5:	e8 1c ab ff ff       	call   c01003e6 <__panic>

    list_entry_t free_list_store = free_list;
c01058ca:	a1 3c df 11 c0       	mov    0xc011df3c,%eax
c01058cf:	8b 15 40 df 11 c0    	mov    0xc011df40,%edx
c01058d5:	89 45 80             	mov    %eax,-0x80(%ebp)
c01058d8:	89 55 84             	mov    %edx,-0x7c(%ebp)
c01058db:	c7 45 b0 3c df 11 c0 	movl   $0xc011df3c,-0x50(%ebp)
    elm->prev = elm->next = elm;
c01058e2:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01058e5:	8b 55 b0             	mov    -0x50(%ebp),%edx
c01058e8:	89 50 04             	mov    %edx,0x4(%eax)
c01058eb:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01058ee:	8b 50 04             	mov    0x4(%eax),%edx
c01058f1:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01058f4:	89 10                	mov    %edx,(%eax)
c01058f6:	c7 45 b4 3c df 11 c0 	movl   $0xc011df3c,-0x4c(%ebp)
    return list->next == list;
c01058fd:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0105900:	8b 40 04             	mov    0x4(%eax),%eax
c0105903:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
c0105906:	0f 94 c0             	sete   %al
c0105909:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c010590c:	85 c0                	test   %eax,%eax
c010590e:	75 24                	jne    c0105934 <default_check+0x1d0>
c0105910:	c7 44 24 0c 6f 79 10 	movl   $0xc010796f,0xc(%esp)
c0105917:	c0 
c0105918:	c7 44 24 08 16 77 10 	movl   $0xc0107716,0x8(%esp)
c010591f:	c0 
c0105920:	c7 44 24 04 96 01 00 	movl   $0x196,0x4(%esp)
c0105927:	00 
c0105928:	c7 04 24 2b 77 10 c0 	movl   $0xc010772b,(%esp)
c010592f:	e8 b2 aa ff ff       	call   c01003e6 <__panic>
    assert(alloc_page() == NULL);
c0105934:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010593b:	e8 dc d6 ff ff       	call   c010301c <alloc_pages>
c0105940:	85 c0                	test   %eax,%eax
c0105942:	74 24                	je     c0105968 <default_check+0x204>
c0105944:	c7 44 24 0c 86 79 10 	movl   $0xc0107986,0xc(%esp)
c010594b:	c0 
c010594c:	c7 44 24 08 16 77 10 	movl   $0xc0107716,0x8(%esp)
c0105953:	c0 
c0105954:	c7 44 24 04 97 01 00 	movl   $0x197,0x4(%esp)
c010595b:	00 
c010595c:	c7 04 24 2b 77 10 c0 	movl   $0xc010772b,(%esp)
c0105963:	e8 7e aa ff ff       	call   c01003e6 <__panic>

    unsigned int nr_free_store = nr_free;
c0105968:	a1 44 df 11 c0       	mov    0xc011df44,%eax
c010596d:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c0105970:	c7 05 44 df 11 c0 00 	movl   $0x0,0xc011df44
c0105977:	00 00 00 

    free_pages(p0 + 2, 3);
c010597a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010597d:	83 c0 28             	add    $0x28,%eax
c0105980:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0105987:	00 
c0105988:	89 04 24             	mov    %eax,(%esp)
c010598b:	e8 c4 d6 ff ff       	call   c0103054 <free_pages>
    assert(alloc_pages(4) == NULL);
c0105990:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0105997:	e8 80 d6 ff ff       	call   c010301c <alloc_pages>
c010599c:	85 c0                	test   %eax,%eax
c010599e:	74 24                	je     c01059c4 <default_check+0x260>
c01059a0:	c7 44 24 0c 2c 7a 10 	movl   $0xc0107a2c,0xc(%esp)
c01059a7:	c0 
c01059a8:	c7 44 24 08 16 77 10 	movl   $0xc0107716,0x8(%esp)
c01059af:	c0 
c01059b0:	c7 44 24 04 9d 01 00 	movl   $0x19d,0x4(%esp)
c01059b7:	00 
c01059b8:	c7 04 24 2b 77 10 c0 	movl   $0xc010772b,(%esp)
c01059bf:	e8 22 aa ff ff       	call   c01003e6 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c01059c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01059c7:	83 c0 28             	add    $0x28,%eax
c01059ca:	83 c0 04             	add    $0x4,%eax
c01059cd:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c01059d4:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01059d7:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01059da:	8b 55 ac             	mov    -0x54(%ebp),%edx
c01059dd:	0f a3 10             	bt     %edx,(%eax)
c01059e0:	19 c0                	sbb    %eax,%eax
c01059e2:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c01059e5:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c01059e9:	0f 95 c0             	setne  %al
c01059ec:	0f b6 c0             	movzbl %al,%eax
c01059ef:	85 c0                	test   %eax,%eax
c01059f1:	74 0e                	je     c0105a01 <default_check+0x29d>
c01059f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01059f6:	83 c0 28             	add    $0x28,%eax
c01059f9:	8b 40 08             	mov    0x8(%eax),%eax
c01059fc:	83 f8 03             	cmp    $0x3,%eax
c01059ff:	74 24                	je     c0105a25 <default_check+0x2c1>
c0105a01:	c7 44 24 0c 44 7a 10 	movl   $0xc0107a44,0xc(%esp)
c0105a08:	c0 
c0105a09:	c7 44 24 08 16 77 10 	movl   $0xc0107716,0x8(%esp)
c0105a10:	c0 
c0105a11:	c7 44 24 04 9e 01 00 	movl   $0x19e,0x4(%esp)
c0105a18:	00 
c0105a19:	c7 04 24 2b 77 10 c0 	movl   $0xc010772b,(%esp)
c0105a20:	e8 c1 a9 ff ff       	call   c01003e6 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0105a25:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c0105a2c:	e8 eb d5 ff ff       	call   c010301c <alloc_pages>
c0105a31:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0105a34:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0105a38:	75 24                	jne    c0105a5e <default_check+0x2fa>
c0105a3a:	c7 44 24 0c 70 7a 10 	movl   $0xc0107a70,0xc(%esp)
c0105a41:	c0 
c0105a42:	c7 44 24 08 16 77 10 	movl   $0xc0107716,0x8(%esp)
c0105a49:	c0 
c0105a4a:	c7 44 24 04 9f 01 00 	movl   $0x19f,0x4(%esp)
c0105a51:	00 
c0105a52:	c7 04 24 2b 77 10 c0 	movl   $0xc010772b,(%esp)
c0105a59:	e8 88 a9 ff ff       	call   c01003e6 <__panic>
    assert(alloc_page() == NULL);
c0105a5e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105a65:	e8 b2 d5 ff ff       	call   c010301c <alloc_pages>
c0105a6a:	85 c0                	test   %eax,%eax
c0105a6c:	74 24                	je     c0105a92 <default_check+0x32e>
c0105a6e:	c7 44 24 0c 86 79 10 	movl   $0xc0107986,0xc(%esp)
c0105a75:	c0 
c0105a76:	c7 44 24 08 16 77 10 	movl   $0xc0107716,0x8(%esp)
c0105a7d:	c0 
c0105a7e:	c7 44 24 04 a0 01 00 	movl   $0x1a0,0x4(%esp)
c0105a85:	00 
c0105a86:	c7 04 24 2b 77 10 c0 	movl   $0xc010772b,(%esp)
c0105a8d:	e8 54 a9 ff ff       	call   c01003e6 <__panic>
    assert(p0 + 2 == p1);
c0105a92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105a95:	83 c0 28             	add    $0x28,%eax
c0105a98:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0105a9b:	74 24                	je     c0105ac1 <default_check+0x35d>
c0105a9d:	c7 44 24 0c 8e 7a 10 	movl   $0xc0107a8e,0xc(%esp)
c0105aa4:	c0 
c0105aa5:	c7 44 24 08 16 77 10 	movl   $0xc0107716,0x8(%esp)
c0105aac:	c0 
c0105aad:	c7 44 24 04 a1 01 00 	movl   $0x1a1,0x4(%esp)
c0105ab4:	00 
c0105ab5:	c7 04 24 2b 77 10 c0 	movl   $0xc010772b,(%esp)
c0105abc:	e8 25 a9 ff ff       	call   c01003e6 <__panic>

    p2 = p0 + 1;
c0105ac1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105ac4:	83 c0 14             	add    $0x14,%eax
c0105ac7:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c0105aca:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105ad1:	00 
c0105ad2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105ad5:	89 04 24             	mov    %eax,(%esp)
c0105ad8:	e8 77 d5 ff ff       	call   c0103054 <free_pages>
    free_pages(p1, 3);
c0105add:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0105ae4:	00 
c0105ae5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105ae8:	89 04 24             	mov    %eax,(%esp)
c0105aeb:	e8 64 d5 ff ff       	call   c0103054 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c0105af0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105af3:	83 c0 04             	add    $0x4,%eax
c0105af6:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c0105afd:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105b00:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0105b03:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0105b06:	0f a3 10             	bt     %edx,(%eax)
c0105b09:	19 c0                	sbb    %eax,%eax
c0105b0b:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c0105b0e:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0105b12:	0f 95 c0             	setne  %al
c0105b15:	0f b6 c0             	movzbl %al,%eax
c0105b18:	85 c0                	test   %eax,%eax
c0105b1a:	74 0b                	je     c0105b27 <default_check+0x3c3>
c0105b1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105b1f:	8b 40 08             	mov    0x8(%eax),%eax
c0105b22:	83 f8 01             	cmp    $0x1,%eax
c0105b25:	74 24                	je     c0105b4b <default_check+0x3e7>
c0105b27:	c7 44 24 0c 9c 7a 10 	movl   $0xc0107a9c,0xc(%esp)
c0105b2e:	c0 
c0105b2f:	c7 44 24 08 16 77 10 	movl   $0xc0107716,0x8(%esp)
c0105b36:	c0 
c0105b37:	c7 44 24 04 a6 01 00 	movl   $0x1a6,0x4(%esp)
c0105b3e:	00 
c0105b3f:	c7 04 24 2b 77 10 c0 	movl   $0xc010772b,(%esp)
c0105b46:	e8 9b a8 ff ff       	call   c01003e6 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0105b4b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105b4e:	83 c0 04             	add    $0x4,%eax
c0105b51:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c0105b58:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105b5b:	8b 45 90             	mov    -0x70(%ebp),%eax
c0105b5e:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0105b61:	0f a3 10             	bt     %edx,(%eax)
c0105b64:	19 c0                	sbb    %eax,%eax
c0105b66:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c0105b69:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c0105b6d:	0f 95 c0             	setne  %al
c0105b70:	0f b6 c0             	movzbl %al,%eax
c0105b73:	85 c0                	test   %eax,%eax
c0105b75:	74 0b                	je     c0105b82 <default_check+0x41e>
c0105b77:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105b7a:	8b 40 08             	mov    0x8(%eax),%eax
c0105b7d:	83 f8 03             	cmp    $0x3,%eax
c0105b80:	74 24                	je     c0105ba6 <default_check+0x442>
c0105b82:	c7 44 24 0c c4 7a 10 	movl   $0xc0107ac4,0xc(%esp)
c0105b89:	c0 
c0105b8a:	c7 44 24 08 16 77 10 	movl   $0xc0107716,0x8(%esp)
c0105b91:	c0 
c0105b92:	c7 44 24 04 a7 01 00 	movl   $0x1a7,0x4(%esp)
c0105b99:	00 
c0105b9a:	c7 04 24 2b 77 10 c0 	movl   $0xc010772b,(%esp)
c0105ba1:	e8 40 a8 ff ff       	call   c01003e6 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c0105ba6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105bad:	e8 6a d4 ff ff       	call   c010301c <alloc_pages>
c0105bb2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105bb5:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105bb8:	83 e8 14             	sub    $0x14,%eax
c0105bbb:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0105bbe:	74 24                	je     c0105be4 <default_check+0x480>
c0105bc0:	c7 44 24 0c ea 7a 10 	movl   $0xc0107aea,0xc(%esp)
c0105bc7:	c0 
c0105bc8:	c7 44 24 08 16 77 10 	movl   $0xc0107716,0x8(%esp)
c0105bcf:	c0 
c0105bd0:	c7 44 24 04 a9 01 00 	movl   $0x1a9,0x4(%esp)
c0105bd7:	00 
c0105bd8:	c7 04 24 2b 77 10 c0 	movl   $0xc010772b,(%esp)
c0105bdf:	e8 02 a8 ff ff       	call   c01003e6 <__panic>
    free_page(p0);
c0105be4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105beb:	00 
c0105bec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105bef:	89 04 24             	mov    %eax,(%esp)
c0105bf2:	e8 5d d4 ff ff       	call   c0103054 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0105bf7:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c0105bfe:	e8 19 d4 ff ff       	call   c010301c <alloc_pages>
c0105c03:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105c06:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105c09:	83 c0 14             	add    $0x14,%eax
c0105c0c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0105c0f:	74 24                	je     c0105c35 <default_check+0x4d1>
c0105c11:	c7 44 24 0c 08 7b 10 	movl   $0xc0107b08,0xc(%esp)
c0105c18:	c0 
c0105c19:	c7 44 24 08 16 77 10 	movl   $0xc0107716,0x8(%esp)
c0105c20:	c0 
c0105c21:	c7 44 24 04 ab 01 00 	movl   $0x1ab,0x4(%esp)
c0105c28:	00 
c0105c29:	c7 04 24 2b 77 10 c0 	movl   $0xc010772b,(%esp)
c0105c30:	e8 b1 a7 ff ff       	call   c01003e6 <__panic>

    free_pages(p0, 2);
c0105c35:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0105c3c:	00 
c0105c3d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105c40:	89 04 24             	mov    %eax,(%esp)
c0105c43:	e8 0c d4 ff ff       	call   c0103054 <free_pages>
    free_page(p2);
c0105c48:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105c4f:	00 
c0105c50:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105c53:	89 04 24             	mov    %eax,(%esp)
c0105c56:	e8 f9 d3 ff ff       	call   c0103054 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c0105c5b:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0105c62:	e8 b5 d3 ff ff       	call   c010301c <alloc_pages>
c0105c67:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105c6a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105c6e:	75 24                	jne    c0105c94 <default_check+0x530>
c0105c70:	c7 44 24 0c 28 7b 10 	movl   $0xc0107b28,0xc(%esp)
c0105c77:	c0 
c0105c78:	c7 44 24 08 16 77 10 	movl   $0xc0107716,0x8(%esp)
c0105c7f:	c0 
c0105c80:	c7 44 24 04 b0 01 00 	movl   $0x1b0,0x4(%esp)
c0105c87:	00 
c0105c88:	c7 04 24 2b 77 10 c0 	movl   $0xc010772b,(%esp)
c0105c8f:	e8 52 a7 ff ff       	call   c01003e6 <__panic>
    assert(alloc_page() == NULL);
c0105c94:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105c9b:	e8 7c d3 ff ff       	call   c010301c <alloc_pages>
c0105ca0:	85 c0                	test   %eax,%eax
c0105ca2:	74 24                	je     c0105cc8 <default_check+0x564>
c0105ca4:	c7 44 24 0c 86 79 10 	movl   $0xc0107986,0xc(%esp)
c0105cab:	c0 
c0105cac:	c7 44 24 08 16 77 10 	movl   $0xc0107716,0x8(%esp)
c0105cb3:	c0 
c0105cb4:	c7 44 24 04 b1 01 00 	movl   $0x1b1,0x4(%esp)
c0105cbb:	00 
c0105cbc:	c7 04 24 2b 77 10 c0 	movl   $0xc010772b,(%esp)
c0105cc3:	e8 1e a7 ff ff       	call   c01003e6 <__panic>

    assert(nr_free == 0);
c0105cc8:	a1 44 df 11 c0       	mov    0xc011df44,%eax
c0105ccd:	85 c0                	test   %eax,%eax
c0105ccf:	74 24                	je     c0105cf5 <default_check+0x591>
c0105cd1:	c7 44 24 0c d9 79 10 	movl   $0xc01079d9,0xc(%esp)
c0105cd8:	c0 
c0105cd9:	c7 44 24 08 16 77 10 	movl   $0xc0107716,0x8(%esp)
c0105ce0:	c0 
c0105ce1:	c7 44 24 04 b3 01 00 	movl   $0x1b3,0x4(%esp)
c0105ce8:	00 
c0105ce9:	c7 04 24 2b 77 10 c0 	movl   $0xc010772b,(%esp)
c0105cf0:	e8 f1 a6 ff ff       	call   c01003e6 <__panic>
    nr_free = nr_free_store;
c0105cf5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105cf8:	a3 44 df 11 c0       	mov    %eax,0xc011df44

    free_list = free_list_store;
c0105cfd:	8b 45 80             	mov    -0x80(%ebp),%eax
c0105d00:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0105d03:	a3 3c df 11 c0       	mov    %eax,0xc011df3c
c0105d08:	89 15 40 df 11 c0    	mov    %edx,0xc011df40
    free_pages(p0, 5);
c0105d0e:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0105d15:	00 
c0105d16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105d19:	89 04 24             	mov    %eax,(%esp)
c0105d1c:	e8 33 d3 ff ff       	call   c0103054 <free_pages>

    le = &free_list;
c0105d21:	c7 45 ec 3c df 11 c0 	movl   $0xc011df3c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0105d28:	eb 1c                	jmp    c0105d46 <default_check+0x5e2>
        struct Page *p = le2page(le, page_link);
c0105d2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105d2d:	83 e8 0c             	sub    $0xc,%eax
c0105d30:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c0105d33:	ff 4d f4             	decl   -0xc(%ebp)
c0105d36:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105d39:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105d3c:	8b 40 08             	mov    0x8(%eax),%eax
c0105d3f:	29 c2                	sub    %eax,%edx
c0105d41:	89 d0                	mov    %edx,%eax
c0105d43:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105d46:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105d49:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
c0105d4c:	8b 45 88             	mov    -0x78(%ebp),%eax
c0105d4f:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0105d52:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105d55:	81 7d ec 3c df 11 c0 	cmpl   $0xc011df3c,-0x14(%ebp)
c0105d5c:	75 cc                	jne    c0105d2a <default_check+0x5c6>
    }
    assert(count == 0);
c0105d5e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105d62:	74 24                	je     c0105d88 <default_check+0x624>
c0105d64:	c7 44 24 0c 46 7b 10 	movl   $0xc0107b46,0xc(%esp)
c0105d6b:	c0 
c0105d6c:	c7 44 24 08 16 77 10 	movl   $0xc0107716,0x8(%esp)
c0105d73:	c0 
c0105d74:	c7 44 24 04 be 01 00 	movl   $0x1be,0x4(%esp)
c0105d7b:	00 
c0105d7c:	c7 04 24 2b 77 10 c0 	movl   $0xc010772b,(%esp)
c0105d83:	e8 5e a6 ff ff       	call   c01003e6 <__panic>
    assert(total == 0);
c0105d88:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105d8c:	74 24                	je     c0105db2 <default_check+0x64e>
c0105d8e:	c7 44 24 0c 51 7b 10 	movl   $0xc0107b51,0xc(%esp)
c0105d95:	c0 
c0105d96:	c7 44 24 08 16 77 10 	movl   $0xc0107716,0x8(%esp)
c0105d9d:	c0 
c0105d9e:	c7 44 24 04 bf 01 00 	movl   $0x1bf,0x4(%esp)
c0105da5:	00 
c0105da6:	c7 04 24 2b 77 10 c0 	movl   $0xc010772b,(%esp)
c0105dad:	e8 34 a6 ff ff       	call   c01003e6 <__panic>
}
c0105db2:	90                   	nop
c0105db3:	c9                   	leave  
c0105db4:	c3                   	ret    

c0105db5 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0105db5:	55                   	push   %ebp
c0105db6:	89 e5                	mov    %esp,%ebp
c0105db8:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105dbb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0105dc2:	eb 03                	jmp    c0105dc7 <strlen+0x12>
        cnt ++;
c0105dc4:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
c0105dc7:	8b 45 08             	mov    0x8(%ebp),%eax
c0105dca:	8d 50 01             	lea    0x1(%eax),%edx
c0105dcd:	89 55 08             	mov    %edx,0x8(%ebp)
c0105dd0:	0f b6 00             	movzbl (%eax),%eax
c0105dd3:	84 c0                	test   %al,%al
c0105dd5:	75 ed                	jne    c0105dc4 <strlen+0xf>
    }
    return cnt;
c0105dd7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105dda:	c9                   	leave  
c0105ddb:	c3                   	ret    

c0105ddc <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0105ddc:	55                   	push   %ebp
c0105ddd:	89 e5                	mov    %esp,%ebp
c0105ddf:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105de2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105de9:	eb 03                	jmp    c0105dee <strnlen+0x12>
        cnt ++;
c0105deb:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105dee:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105df1:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105df4:	73 10                	jae    c0105e06 <strnlen+0x2a>
c0105df6:	8b 45 08             	mov    0x8(%ebp),%eax
c0105df9:	8d 50 01             	lea    0x1(%eax),%edx
c0105dfc:	89 55 08             	mov    %edx,0x8(%ebp)
c0105dff:	0f b6 00             	movzbl (%eax),%eax
c0105e02:	84 c0                	test   %al,%al
c0105e04:	75 e5                	jne    c0105deb <strnlen+0xf>
    }
    return cnt;
c0105e06:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105e09:	c9                   	leave  
c0105e0a:	c3                   	ret    

c0105e0b <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0105e0b:	55                   	push   %ebp
c0105e0c:	89 e5                	mov    %esp,%ebp
c0105e0e:	57                   	push   %edi
c0105e0f:	56                   	push   %esi
c0105e10:	83 ec 20             	sub    $0x20,%esp
c0105e13:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e16:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105e19:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0105e1f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105e22:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105e25:	89 d1                	mov    %edx,%ecx
c0105e27:	89 c2                	mov    %eax,%edx
c0105e29:	89 ce                	mov    %ecx,%esi
c0105e2b:	89 d7                	mov    %edx,%edi
c0105e2d:	ac                   	lods   %ds:(%esi),%al
c0105e2e:	aa                   	stos   %al,%es:(%edi)
c0105e2f:	84 c0                	test   %al,%al
c0105e31:	75 fa                	jne    c0105e2d <strcpy+0x22>
c0105e33:	89 fa                	mov    %edi,%edx
c0105e35:	89 f1                	mov    %esi,%ecx
c0105e37:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105e3a:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0105e3d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0105e40:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
c0105e43:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0105e44:	83 c4 20             	add    $0x20,%esp
c0105e47:	5e                   	pop    %esi
c0105e48:	5f                   	pop    %edi
c0105e49:	5d                   	pop    %ebp
c0105e4a:	c3                   	ret    

c0105e4b <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0105e4b:	55                   	push   %ebp
c0105e4c:	89 e5                	mov    %esp,%ebp
c0105e4e:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0105e51:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e54:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0105e57:	eb 1e                	jmp    c0105e77 <strncpy+0x2c>
        if ((*p = *src) != '\0') {
c0105e59:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e5c:	0f b6 10             	movzbl (%eax),%edx
c0105e5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105e62:	88 10                	mov    %dl,(%eax)
c0105e64:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105e67:	0f b6 00             	movzbl (%eax),%eax
c0105e6a:	84 c0                	test   %al,%al
c0105e6c:	74 03                	je     c0105e71 <strncpy+0x26>
            src ++;
c0105e6e:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
c0105e71:	ff 45 fc             	incl   -0x4(%ebp)
c0105e74:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
c0105e77:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105e7b:	75 dc                	jne    c0105e59 <strncpy+0xe>
    }
    return dst;
c0105e7d:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105e80:	c9                   	leave  
c0105e81:	c3                   	ret    

c0105e82 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0105e82:	55                   	push   %ebp
c0105e83:	89 e5                	mov    %esp,%ebp
c0105e85:	57                   	push   %edi
c0105e86:	56                   	push   %esi
c0105e87:	83 ec 20             	sub    $0x20,%esp
c0105e8a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105e90:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e93:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
c0105e96:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105e99:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e9c:	89 d1                	mov    %edx,%ecx
c0105e9e:	89 c2                	mov    %eax,%edx
c0105ea0:	89 ce                	mov    %ecx,%esi
c0105ea2:	89 d7                	mov    %edx,%edi
c0105ea4:	ac                   	lods   %ds:(%esi),%al
c0105ea5:	ae                   	scas   %es:(%edi),%al
c0105ea6:	75 08                	jne    c0105eb0 <strcmp+0x2e>
c0105ea8:	84 c0                	test   %al,%al
c0105eaa:	75 f8                	jne    c0105ea4 <strcmp+0x22>
c0105eac:	31 c0                	xor    %eax,%eax
c0105eae:	eb 04                	jmp    c0105eb4 <strcmp+0x32>
c0105eb0:	19 c0                	sbb    %eax,%eax
c0105eb2:	0c 01                	or     $0x1,%al
c0105eb4:	89 fa                	mov    %edi,%edx
c0105eb6:	89 f1                	mov    %esi,%ecx
c0105eb8:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105ebb:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105ebe:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
c0105ec1:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
c0105ec4:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0105ec5:	83 c4 20             	add    $0x20,%esp
c0105ec8:	5e                   	pop    %esi
c0105ec9:	5f                   	pop    %edi
c0105eca:	5d                   	pop    %ebp
c0105ecb:	c3                   	ret    

c0105ecc <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0105ecc:	55                   	push   %ebp
c0105ecd:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105ecf:	eb 09                	jmp    c0105eda <strncmp+0xe>
        n --, s1 ++, s2 ++;
c0105ed1:	ff 4d 10             	decl   0x10(%ebp)
c0105ed4:	ff 45 08             	incl   0x8(%ebp)
c0105ed7:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105eda:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105ede:	74 1a                	je     c0105efa <strncmp+0x2e>
c0105ee0:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ee3:	0f b6 00             	movzbl (%eax),%eax
c0105ee6:	84 c0                	test   %al,%al
c0105ee8:	74 10                	je     c0105efa <strncmp+0x2e>
c0105eea:	8b 45 08             	mov    0x8(%ebp),%eax
c0105eed:	0f b6 10             	movzbl (%eax),%edx
c0105ef0:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ef3:	0f b6 00             	movzbl (%eax),%eax
c0105ef6:	38 c2                	cmp    %al,%dl
c0105ef8:	74 d7                	je     c0105ed1 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105efa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105efe:	74 18                	je     c0105f18 <strncmp+0x4c>
c0105f00:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f03:	0f b6 00             	movzbl (%eax),%eax
c0105f06:	0f b6 d0             	movzbl %al,%edx
c0105f09:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f0c:	0f b6 00             	movzbl (%eax),%eax
c0105f0f:	0f b6 c0             	movzbl %al,%eax
c0105f12:	29 c2                	sub    %eax,%edx
c0105f14:	89 d0                	mov    %edx,%eax
c0105f16:	eb 05                	jmp    c0105f1d <strncmp+0x51>
c0105f18:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105f1d:	5d                   	pop    %ebp
c0105f1e:	c3                   	ret    

c0105f1f <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0105f1f:	55                   	push   %ebp
c0105f20:	89 e5                	mov    %esp,%ebp
c0105f22:	83 ec 04             	sub    $0x4,%esp
c0105f25:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f28:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105f2b:	eb 13                	jmp    c0105f40 <strchr+0x21>
        if (*s == c) {
c0105f2d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f30:	0f b6 00             	movzbl (%eax),%eax
c0105f33:	38 45 fc             	cmp    %al,-0x4(%ebp)
c0105f36:	75 05                	jne    c0105f3d <strchr+0x1e>
            return (char *)s;
c0105f38:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f3b:	eb 12                	jmp    c0105f4f <strchr+0x30>
        }
        s ++;
c0105f3d:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
c0105f40:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f43:	0f b6 00             	movzbl (%eax),%eax
c0105f46:	84 c0                	test   %al,%al
c0105f48:	75 e3                	jne    c0105f2d <strchr+0xe>
    }
    return NULL;
c0105f4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105f4f:	c9                   	leave  
c0105f50:	c3                   	ret    

c0105f51 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0105f51:	55                   	push   %ebp
c0105f52:	89 e5                	mov    %esp,%ebp
c0105f54:	83 ec 04             	sub    $0x4,%esp
c0105f57:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f5a:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105f5d:	eb 0e                	jmp    c0105f6d <strfind+0x1c>
        if (*s == c) {
c0105f5f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f62:	0f b6 00             	movzbl (%eax),%eax
c0105f65:	38 45 fc             	cmp    %al,-0x4(%ebp)
c0105f68:	74 0f                	je     c0105f79 <strfind+0x28>
            break;
        }
        s ++;
c0105f6a:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
c0105f6d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f70:	0f b6 00             	movzbl (%eax),%eax
c0105f73:	84 c0                	test   %al,%al
c0105f75:	75 e8                	jne    c0105f5f <strfind+0xe>
c0105f77:	eb 01                	jmp    c0105f7a <strfind+0x29>
            break;
c0105f79:	90                   	nop
    }
    return (char *)s;
c0105f7a:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105f7d:	c9                   	leave  
c0105f7e:	c3                   	ret    

c0105f7f <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0105f7f:	55                   	push   %ebp
c0105f80:	89 e5                	mov    %esp,%ebp
c0105f82:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0105f85:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0105f8c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105f93:	eb 03                	jmp    c0105f98 <strtol+0x19>
        s ++;
c0105f95:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
c0105f98:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f9b:	0f b6 00             	movzbl (%eax),%eax
c0105f9e:	3c 20                	cmp    $0x20,%al
c0105fa0:	74 f3                	je     c0105f95 <strtol+0x16>
c0105fa2:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fa5:	0f b6 00             	movzbl (%eax),%eax
c0105fa8:	3c 09                	cmp    $0x9,%al
c0105faa:	74 e9                	je     c0105f95 <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
c0105fac:	8b 45 08             	mov    0x8(%ebp),%eax
c0105faf:	0f b6 00             	movzbl (%eax),%eax
c0105fb2:	3c 2b                	cmp    $0x2b,%al
c0105fb4:	75 05                	jne    c0105fbb <strtol+0x3c>
        s ++;
c0105fb6:	ff 45 08             	incl   0x8(%ebp)
c0105fb9:	eb 14                	jmp    c0105fcf <strtol+0x50>
    }
    else if (*s == '-') {
c0105fbb:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fbe:	0f b6 00             	movzbl (%eax),%eax
c0105fc1:	3c 2d                	cmp    $0x2d,%al
c0105fc3:	75 0a                	jne    c0105fcf <strtol+0x50>
        s ++, neg = 1;
c0105fc5:	ff 45 08             	incl   0x8(%ebp)
c0105fc8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0105fcf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105fd3:	74 06                	je     c0105fdb <strtol+0x5c>
c0105fd5:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0105fd9:	75 22                	jne    c0105ffd <strtol+0x7e>
c0105fdb:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fde:	0f b6 00             	movzbl (%eax),%eax
c0105fe1:	3c 30                	cmp    $0x30,%al
c0105fe3:	75 18                	jne    c0105ffd <strtol+0x7e>
c0105fe5:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fe8:	40                   	inc    %eax
c0105fe9:	0f b6 00             	movzbl (%eax),%eax
c0105fec:	3c 78                	cmp    $0x78,%al
c0105fee:	75 0d                	jne    c0105ffd <strtol+0x7e>
        s += 2, base = 16;
c0105ff0:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105ff4:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0105ffb:	eb 29                	jmp    c0106026 <strtol+0xa7>
    }
    else if (base == 0 && s[0] == '0') {
c0105ffd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0106001:	75 16                	jne    c0106019 <strtol+0x9a>
c0106003:	8b 45 08             	mov    0x8(%ebp),%eax
c0106006:	0f b6 00             	movzbl (%eax),%eax
c0106009:	3c 30                	cmp    $0x30,%al
c010600b:	75 0c                	jne    c0106019 <strtol+0x9a>
        s ++, base = 8;
c010600d:	ff 45 08             	incl   0x8(%ebp)
c0106010:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0106017:	eb 0d                	jmp    c0106026 <strtol+0xa7>
    }
    else if (base == 0) {
c0106019:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010601d:	75 07                	jne    c0106026 <strtol+0xa7>
        base = 10;
c010601f:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0106026:	8b 45 08             	mov    0x8(%ebp),%eax
c0106029:	0f b6 00             	movzbl (%eax),%eax
c010602c:	3c 2f                	cmp    $0x2f,%al
c010602e:	7e 1b                	jle    c010604b <strtol+0xcc>
c0106030:	8b 45 08             	mov    0x8(%ebp),%eax
c0106033:	0f b6 00             	movzbl (%eax),%eax
c0106036:	3c 39                	cmp    $0x39,%al
c0106038:	7f 11                	jg     c010604b <strtol+0xcc>
            dig = *s - '0';
c010603a:	8b 45 08             	mov    0x8(%ebp),%eax
c010603d:	0f b6 00             	movzbl (%eax),%eax
c0106040:	0f be c0             	movsbl %al,%eax
c0106043:	83 e8 30             	sub    $0x30,%eax
c0106046:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0106049:	eb 48                	jmp    c0106093 <strtol+0x114>
        }
        else if (*s >= 'a' && *s <= 'z') {
c010604b:	8b 45 08             	mov    0x8(%ebp),%eax
c010604e:	0f b6 00             	movzbl (%eax),%eax
c0106051:	3c 60                	cmp    $0x60,%al
c0106053:	7e 1b                	jle    c0106070 <strtol+0xf1>
c0106055:	8b 45 08             	mov    0x8(%ebp),%eax
c0106058:	0f b6 00             	movzbl (%eax),%eax
c010605b:	3c 7a                	cmp    $0x7a,%al
c010605d:	7f 11                	jg     c0106070 <strtol+0xf1>
            dig = *s - 'a' + 10;
c010605f:	8b 45 08             	mov    0x8(%ebp),%eax
c0106062:	0f b6 00             	movzbl (%eax),%eax
c0106065:	0f be c0             	movsbl %al,%eax
c0106068:	83 e8 57             	sub    $0x57,%eax
c010606b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010606e:	eb 23                	jmp    c0106093 <strtol+0x114>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0106070:	8b 45 08             	mov    0x8(%ebp),%eax
c0106073:	0f b6 00             	movzbl (%eax),%eax
c0106076:	3c 40                	cmp    $0x40,%al
c0106078:	7e 3b                	jle    c01060b5 <strtol+0x136>
c010607a:	8b 45 08             	mov    0x8(%ebp),%eax
c010607d:	0f b6 00             	movzbl (%eax),%eax
c0106080:	3c 5a                	cmp    $0x5a,%al
c0106082:	7f 31                	jg     c01060b5 <strtol+0x136>
            dig = *s - 'A' + 10;
c0106084:	8b 45 08             	mov    0x8(%ebp),%eax
c0106087:	0f b6 00             	movzbl (%eax),%eax
c010608a:	0f be c0             	movsbl %al,%eax
c010608d:	83 e8 37             	sub    $0x37,%eax
c0106090:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0106093:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106096:	3b 45 10             	cmp    0x10(%ebp),%eax
c0106099:	7d 19                	jge    c01060b4 <strtol+0x135>
            break;
        }
        s ++, val = (val * base) + dig;
c010609b:	ff 45 08             	incl   0x8(%ebp)
c010609e:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01060a1:	0f af 45 10          	imul   0x10(%ebp),%eax
c01060a5:	89 c2                	mov    %eax,%edx
c01060a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01060aa:	01 d0                	add    %edx,%eax
c01060ac:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
c01060af:	e9 72 ff ff ff       	jmp    c0106026 <strtol+0xa7>
            break;
c01060b4:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
c01060b5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01060b9:	74 08                	je     c01060c3 <strtol+0x144>
        *endptr = (char *) s;
c01060bb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01060be:	8b 55 08             	mov    0x8(%ebp),%edx
c01060c1:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c01060c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c01060c7:	74 07                	je     c01060d0 <strtol+0x151>
c01060c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01060cc:	f7 d8                	neg    %eax
c01060ce:	eb 03                	jmp    c01060d3 <strtol+0x154>
c01060d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c01060d3:	c9                   	leave  
c01060d4:	c3                   	ret    

c01060d5 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c01060d5:	55                   	push   %ebp
c01060d6:	89 e5                	mov    %esp,%ebp
c01060d8:	57                   	push   %edi
c01060d9:	83 ec 24             	sub    $0x24,%esp
c01060dc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01060df:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c01060e2:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
c01060e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01060e9:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01060ec:	88 55 f7             	mov    %dl,-0x9(%ebp)
c01060ef:	8b 45 10             	mov    0x10(%ebp),%eax
c01060f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c01060f5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c01060f8:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c01060fc:	8b 55 f8             	mov    -0x8(%ebp),%edx
c01060ff:	89 d7                	mov    %edx,%edi
c0106101:	f3 aa                	rep stos %al,%es:(%edi)
c0106103:	89 fa                	mov    %edi,%edx
c0106105:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0106108:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c010610b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010610e:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c010610f:	83 c4 24             	add    $0x24,%esp
c0106112:	5f                   	pop    %edi
c0106113:	5d                   	pop    %ebp
c0106114:	c3                   	ret    

c0106115 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0106115:	55                   	push   %ebp
c0106116:	89 e5                	mov    %esp,%ebp
c0106118:	57                   	push   %edi
c0106119:	56                   	push   %esi
c010611a:	53                   	push   %ebx
c010611b:	83 ec 30             	sub    $0x30,%esp
c010611e:	8b 45 08             	mov    0x8(%ebp),%eax
c0106121:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106124:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106127:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010612a:	8b 45 10             	mov    0x10(%ebp),%eax
c010612d:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0106130:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106133:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0106136:	73 42                	jae    c010617a <memmove+0x65>
c0106138:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010613b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010613e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106141:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0106144:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106147:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c010614a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010614d:	c1 e8 02             	shr    $0x2,%eax
c0106150:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0106152:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106155:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106158:	89 d7                	mov    %edx,%edi
c010615a:	89 c6                	mov    %eax,%esi
c010615c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c010615e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0106161:	83 e1 03             	and    $0x3,%ecx
c0106164:	74 02                	je     c0106168 <memmove+0x53>
c0106166:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0106168:	89 f0                	mov    %esi,%eax
c010616a:	89 fa                	mov    %edi,%edx
c010616c:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c010616f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0106172:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
c0106175:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
c0106178:	eb 36                	jmp    c01061b0 <memmove+0x9b>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c010617a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010617d:	8d 50 ff             	lea    -0x1(%eax),%edx
c0106180:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106183:	01 c2                	add    %eax,%edx
c0106185:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106188:	8d 48 ff             	lea    -0x1(%eax),%ecx
c010618b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010618e:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
c0106191:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106194:	89 c1                	mov    %eax,%ecx
c0106196:	89 d8                	mov    %ebx,%eax
c0106198:	89 d6                	mov    %edx,%esi
c010619a:	89 c7                	mov    %eax,%edi
c010619c:	fd                   	std    
c010619d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010619f:	fc                   	cld    
c01061a0:	89 f8                	mov    %edi,%eax
c01061a2:	89 f2                	mov    %esi,%edx
c01061a4:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c01061a7:	89 55 c8             	mov    %edx,-0x38(%ebp)
c01061aa:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
c01061ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c01061b0:	83 c4 30             	add    $0x30,%esp
c01061b3:	5b                   	pop    %ebx
c01061b4:	5e                   	pop    %esi
c01061b5:	5f                   	pop    %edi
c01061b6:	5d                   	pop    %ebp
c01061b7:	c3                   	ret    

c01061b8 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c01061b8:	55                   	push   %ebp
c01061b9:	89 e5                	mov    %esp,%ebp
c01061bb:	57                   	push   %edi
c01061bc:	56                   	push   %esi
c01061bd:	83 ec 20             	sub    $0x20,%esp
c01061c0:	8b 45 08             	mov    0x8(%ebp),%eax
c01061c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01061c6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01061c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01061cc:	8b 45 10             	mov    0x10(%ebp),%eax
c01061cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c01061d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01061d5:	c1 e8 02             	shr    $0x2,%eax
c01061d8:	89 c1                	mov    %eax,%ecx
    asm volatile (
c01061da:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01061dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01061e0:	89 d7                	mov    %edx,%edi
c01061e2:	89 c6                	mov    %eax,%esi
c01061e4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c01061e6:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c01061e9:	83 e1 03             	and    $0x3,%ecx
c01061ec:	74 02                	je     c01061f0 <memcpy+0x38>
c01061ee:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01061f0:	89 f0                	mov    %esi,%eax
c01061f2:	89 fa                	mov    %edi,%edx
c01061f4:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c01061f7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c01061fa:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
c01061fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
c0106200:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0106201:	83 c4 20             	add    $0x20,%esp
c0106204:	5e                   	pop    %esi
c0106205:	5f                   	pop    %edi
c0106206:	5d                   	pop    %ebp
c0106207:	c3                   	ret    

c0106208 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0106208:	55                   	push   %ebp
c0106209:	89 e5                	mov    %esp,%ebp
c010620b:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c010620e:	8b 45 08             	mov    0x8(%ebp),%eax
c0106211:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0106214:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106217:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c010621a:	eb 2e                	jmp    c010624a <memcmp+0x42>
        if (*s1 != *s2) {
c010621c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010621f:	0f b6 10             	movzbl (%eax),%edx
c0106222:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0106225:	0f b6 00             	movzbl (%eax),%eax
c0106228:	38 c2                	cmp    %al,%dl
c010622a:	74 18                	je     c0106244 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c010622c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010622f:	0f b6 00             	movzbl (%eax),%eax
c0106232:	0f b6 d0             	movzbl %al,%edx
c0106235:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0106238:	0f b6 00             	movzbl (%eax),%eax
c010623b:	0f b6 c0             	movzbl %al,%eax
c010623e:	29 c2                	sub    %eax,%edx
c0106240:	89 d0                	mov    %edx,%eax
c0106242:	eb 18                	jmp    c010625c <memcmp+0x54>
        }
        s1 ++, s2 ++;
c0106244:	ff 45 fc             	incl   -0x4(%ebp)
c0106247:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
c010624a:	8b 45 10             	mov    0x10(%ebp),%eax
c010624d:	8d 50 ff             	lea    -0x1(%eax),%edx
c0106250:	89 55 10             	mov    %edx,0x10(%ebp)
c0106253:	85 c0                	test   %eax,%eax
c0106255:	75 c5                	jne    c010621c <memcmp+0x14>
    }
    return 0;
c0106257:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010625c:	c9                   	leave  
c010625d:	c3                   	ret    

c010625e <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c010625e:	55                   	push   %ebp
c010625f:	89 e5                	mov    %esp,%ebp
c0106261:	83 ec 58             	sub    $0x58,%esp
c0106264:	8b 45 10             	mov    0x10(%ebp),%eax
c0106267:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010626a:	8b 45 14             	mov    0x14(%ebp),%eax
c010626d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0106270:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106273:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0106276:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106279:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c010627c:	8b 45 18             	mov    0x18(%ebp),%eax
c010627f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106282:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106285:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106288:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010628b:	89 55 f0             	mov    %edx,-0x10(%ebp)
c010628e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106291:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0106294:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0106298:	74 1c                	je     c01062b6 <printnum+0x58>
c010629a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010629d:	ba 00 00 00 00       	mov    $0x0,%edx
c01062a2:	f7 75 e4             	divl   -0x1c(%ebp)
c01062a5:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01062a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01062ab:	ba 00 00 00 00       	mov    $0x0,%edx
c01062b0:	f7 75 e4             	divl   -0x1c(%ebp)
c01062b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01062b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01062b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01062bc:	f7 75 e4             	divl   -0x1c(%ebp)
c01062bf:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01062c2:	89 55 dc             	mov    %edx,-0x24(%ebp)
c01062c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01062c8:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01062cb:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01062ce:	89 55 ec             	mov    %edx,-0x14(%ebp)
c01062d1:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01062d4:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c01062d7:	8b 45 18             	mov    0x18(%ebp),%eax
c01062da:	ba 00 00 00 00       	mov    $0x0,%edx
c01062df:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c01062e2:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c01062e5:	19 d1                	sbb    %edx,%ecx
c01062e7:	72 4c                	jb     c0106335 <printnum+0xd7>
        printnum(putch, putdat, result, base, width - 1, padc);
c01062e9:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01062ec:	8d 50 ff             	lea    -0x1(%eax),%edx
c01062ef:	8b 45 20             	mov    0x20(%ebp),%eax
c01062f2:	89 44 24 18          	mov    %eax,0x18(%esp)
c01062f6:	89 54 24 14          	mov    %edx,0x14(%esp)
c01062fa:	8b 45 18             	mov    0x18(%ebp),%eax
c01062fd:	89 44 24 10          	mov    %eax,0x10(%esp)
c0106301:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106304:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106307:	89 44 24 08          	mov    %eax,0x8(%esp)
c010630b:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010630f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106312:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106316:	8b 45 08             	mov    0x8(%ebp),%eax
c0106319:	89 04 24             	mov    %eax,(%esp)
c010631c:	e8 3d ff ff ff       	call   c010625e <printnum>
c0106321:	eb 1b                	jmp    c010633e <printnum+0xe0>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c0106323:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106326:	89 44 24 04          	mov    %eax,0x4(%esp)
c010632a:	8b 45 20             	mov    0x20(%ebp),%eax
c010632d:	89 04 24             	mov    %eax,(%esp)
c0106330:	8b 45 08             	mov    0x8(%ebp),%eax
c0106333:	ff d0                	call   *%eax
        while (-- width > 0)
c0106335:	ff 4d 1c             	decl   0x1c(%ebp)
c0106338:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c010633c:	7f e5                	jg     c0106323 <printnum+0xc5>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c010633e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0106341:	05 0c 7c 10 c0       	add    $0xc0107c0c,%eax
c0106346:	0f b6 00             	movzbl (%eax),%eax
c0106349:	0f be c0             	movsbl %al,%eax
c010634c:	8b 55 0c             	mov    0xc(%ebp),%edx
c010634f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106353:	89 04 24             	mov    %eax,(%esp)
c0106356:	8b 45 08             	mov    0x8(%ebp),%eax
c0106359:	ff d0                	call   *%eax
}
c010635b:	90                   	nop
c010635c:	c9                   	leave  
c010635d:	c3                   	ret    

c010635e <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c010635e:	55                   	push   %ebp
c010635f:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0106361:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0106365:	7e 14                	jle    c010637b <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c0106367:	8b 45 08             	mov    0x8(%ebp),%eax
c010636a:	8b 00                	mov    (%eax),%eax
c010636c:	8d 48 08             	lea    0x8(%eax),%ecx
c010636f:	8b 55 08             	mov    0x8(%ebp),%edx
c0106372:	89 0a                	mov    %ecx,(%edx)
c0106374:	8b 50 04             	mov    0x4(%eax),%edx
c0106377:	8b 00                	mov    (%eax),%eax
c0106379:	eb 30                	jmp    c01063ab <getuint+0x4d>
    }
    else if (lflag) {
c010637b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010637f:	74 16                	je     c0106397 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c0106381:	8b 45 08             	mov    0x8(%ebp),%eax
c0106384:	8b 00                	mov    (%eax),%eax
c0106386:	8d 48 04             	lea    0x4(%eax),%ecx
c0106389:	8b 55 08             	mov    0x8(%ebp),%edx
c010638c:	89 0a                	mov    %ecx,(%edx)
c010638e:	8b 00                	mov    (%eax),%eax
c0106390:	ba 00 00 00 00       	mov    $0x0,%edx
c0106395:	eb 14                	jmp    c01063ab <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c0106397:	8b 45 08             	mov    0x8(%ebp),%eax
c010639a:	8b 00                	mov    (%eax),%eax
c010639c:	8d 48 04             	lea    0x4(%eax),%ecx
c010639f:	8b 55 08             	mov    0x8(%ebp),%edx
c01063a2:	89 0a                	mov    %ecx,(%edx)
c01063a4:	8b 00                	mov    (%eax),%eax
c01063a6:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c01063ab:	5d                   	pop    %ebp
c01063ac:	c3                   	ret    

c01063ad <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c01063ad:	55                   	push   %ebp
c01063ae:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01063b0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01063b4:	7e 14                	jle    c01063ca <getint+0x1d>
        return va_arg(*ap, long long);
c01063b6:	8b 45 08             	mov    0x8(%ebp),%eax
c01063b9:	8b 00                	mov    (%eax),%eax
c01063bb:	8d 48 08             	lea    0x8(%eax),%ecx
c01063be:	8b 55 08             	mov    0x8(%ebp),%edx
c01063c1:	89 0a                	mov    %ecx,(%edx)
c01063c3:	8b 50 04             	mov    0x4(%eax),%edx
c01063c6:	8b 00                	mov    (%eax),%eax
c01063c8:	eb 28                	jmp    c01063f2 <getint+0x45>
    }
    else if (lflag) {
c01063ca:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01063ce:	74 12                	je     c01063e2 <getint+0x35>
        return va_arg(*ap, long);
c01063d0:	8b 45 08             	mov    0x8(%ebp),%eax
c01063d3:	8b 00                	mov    (%eax),%eax
c01063d5:	8d 48 04             	lea    0x4(%eax),%ecx
c01063d8:	8b 55 08             	mov    0x8(%ebp),%edx
c01063db:	89 0a                	mov    %ecx,(%edx)
c01063dd:	8b 00                	mov    (%eax),%eax
c01063df:	99                   	cltd   
c01063e0:	eb 10                	jmp    c01063f2 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c01063e2:	8b 45 08             	mov    0x8(%ebp),%eax
c01063e5:	8b 00                	mov    (%eax),%eax
c01063e7:	8d 48 04             	lea    0x4(%eax),%ecx
c01063ea:	8b 55 08             	mov    0x8(%ebp),%edx
c01063ed:	89 0a                	mov    %ecx,(%edx)
c01063ef:	8b 00                	mov    (%eax),%eax
c01063f1:	99                   	cltd   
    }
}
c01063f2:	5d                   	pop    %ebp
c01063f3:	c3                   	ret    

c01063f4 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c01063f4:	55                   	push   %ebp
c01063f5:	89 e5                	mov    %esp,%ebp
c01063f7:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c01063fa:	8d 45 14             	lea    0x14(%ebp),%eax
c01063fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c0106400:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106403:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106407:	8b 45 10             	mov    0x10(%ebp),%eax
c010640a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010640e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106411:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106415:	8b 45 08             	mov    0x8(%ebp),%eax
c0106418:	89 04 24             	mov    %eax,(%esp)
c010641b:	e8 03 00 00 00       	call   c0106423 <vprintfmt>
    va_end(ap);
}
c0106420:	90                   	nop
c0106421:	c9                   	leave  
c0106422:	c3                   	ret    

c0106423 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c0106423:	55                   	push   %ebp
c0106424:	89 e5                	mov    %esp,%ebp
c0106426:	56                   	push   %esi
c0106427:	53                   	push   %ebx
c0106428:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010642b:	eb 17                	jmp    c0106444 <vprintfmt+0x21>
            if (ch == '\0') {
c010642d:	85 db                	test   %ebx,%ebx
c010642f:	0f 84 bf 03 00 00    	je     c01067f4 <vprintfmt+0x3d1>
                return;
            }
            putch(ch, putdat);
c0106435:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106438:	89 44 24 04          	mov    %eax,0x4(%esp)
c010643c:	89 1c 24             	mov    %ebx,(%esp)
c010643f:	8b 45 08             	mov    0x8(%ebp),%eax
c0106442:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0106444:	8b 45 10             	mov    0x10(%ebp),%eax
c0106447:	8d 50 01             	lea    0x1(%eax),%edx
c010644a:	89 55 10             	mov    %edx,0x10(%ebp)
c010644d:	0f b6 00             	movzbl (%eax),%eax
c0106450:	0f b6 d8             	movzbl %al,%ebx
c0106453:	83 fb 25             	cmp    $0x25,%ebx
c0106456:	75 d5                	jne    c010642d <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
c0106458:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c010645c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c0106463:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106466:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0106469:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0106470:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106473:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c0106476:	8b 45 10             	mov    0x10(%ebp),%eax
c0106479:	8d 50 01             	lea    0x1(%eax),%edx
c010647c:	89 55 10             	mov    %edx,0x10(%ebp)
c010647f:	0f b6 00             	movzbl (%eax),%eax
c0106482:	0f b6 d8             	movzbl %al,%ebx
c0106485:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0106488:	83 f8 55             	cmp    $0x55,%eax
c010648b:	0f 87 37 03 00 00    	ja     c01067c8 <vprintfmt+0x3a5>
c0106491:	8b 04 85 30 7c 10 c0 	mov    -0x3fef83d0(,%eax,4),%eax
c0106498:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c010649a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c010649e:	eb d6                	jmp    c0106476 <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c01064a0:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c01064a4:	eb d0                	jmp    c0106476 <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c01064a6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c01064ad:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01064b0:	89 d0                	mov    %edx,%eax
c01064b2:	c1 e0 02             	shl    $0x2,%eax
c01064b5:	01 d0                	add    %edx,%eax
c01064b7:	01 c0                	add    %eax,%eax
c01064b9:	01 d8                	add    %ebx,%eax
c01064bb:	83 e8 30             	sub    $0x30,%eax
c01064be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c01064c1:	8b 45 10             	mov    0x10(%ebp),%eax
c01064c4:	0f b6 00             	movzbl (%eax),%eax
c01064c7:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c01064ca:	83 fb 2f             	cmp    $0x2f,%ebx
c01064cd:	7e 38                	jle    c0106507 <vprintfmt+0xe4>
c01064cf:	83 fb 39             	cmp    $0x39,%ebx
c01064d2:	7f 33                	jg     c0106507 <vprintfmt+0xe4>
            for (precision = 0; ; ++ fmt) {
c01064d4:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
c01064d7:	eb d4                	jmp    c01064ad <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c01064d9:	8b 45 14             	mov    0x14(%ebp),%eax
c01064dc:	8d 50 04             	lea    0x4(%eax),%edx
c01064df:	89 55 14             	mov    %edx,0x14(%ebp)
c01064e2:	8b 00                	mov    (%eax),%eax
c01064e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c01064e7:	eb 1f                	jmp    c0106508 <vprintfmt+0xe5>

        case '.':
            if (width < 0)
c01064e9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01064ed:	79 87                	jns    c0106476 <vprintfmt+0x53>
                width = 0;
c01064ef:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c01064f6:	e9 7b ff ff ff       	jmp    c0106476 <vprintfmt+0x53>

        case '#':
            altflag = 1;
c01064fb:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c0106502:	e9 6f ff ff ff       	jmp    c0106476 <vprintfmt+0x53>
            goto process_precision;
c0106507:	90                   	nop

        process_precision:
            if (width < 0)
c0106508:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010650c:	0f 89 64 ff ff ff    	jns    c0106476 <vprintfmt+0x53>
                width = precision, precision = -1;
c0106512:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106515:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106518:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c010651f:	e9 52 ff ff ff       	jmp    c0106476 <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c0106524:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
c0106527:	e9 4a ff ff ff       	jmp    c0106476 <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c010652c:	8b 45 14             	mov    0x14(%ebp),%eax
c010652f:	8d 50 04             	lea    0x4(%eax),%edx
c0106532:	89 55 14             	mov    %edx,0x14(%ebp)
c0106535:	8b 00                	mov    (%eax),%eax
c0106537:	8b 55 0c             	mov    0xc(%ebp),%edx
c010653a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010653e:	89 04 24             	mov    %eax,(%esp)
c0106541:	8b 45 08             	mov    0x8(%ebp),%eax
c0106544:	ff d0                	call   *%eax
            break;
c0106546:	e9 a4 02 00 00       	jmp    c01067ef <vprintfmt+0x3cc>

        // error message
        case 'e':
            err = va_arg(ap, int);
c010654b:	8b 45 14             	mov    0x14(%ebp),%eax
c010654e:	8d 50 04             	lea    0x4(%eax),%edx
c0106551:	89 55 14             	mov    %edx,0x14(%ebp)
c0106554:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c0106556:	85 db                	test   %ebx,%ebx
c0106558:	79 02                	jns    c010655c <vprintfmt+0x139>
                err = -err;
c010655a:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c010655c:	83 fb 06             	cmp    $0x6,%ebx
c010655f:	7f 0b                	jg     c010656c <vprintfmt+0x149>
c0106561:	8b 34 9d f0 7b 10 c0 	mov    -0x3fef8410(,%ebx,4),%esi
c0106568:	85 f6                	test   %esi,%esi
c010656a:	75 23                	jne    c010658f <vprintfmt+0x16c>
                printfmt(putch, putdat, "error %d", err);
c010656c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0106570:	c7 44 24 08 1d 7c 10 	movl   $0xc0107c1d,0x8(%esp)
c0106577:	c0 
c0106578:	8b 45 0c             	mov    0xc(%ebp),%eax
c010657b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010657f:	8b 45 08             	mov    0x8(%ebp),%eax
c0106582:	89 04 24             	mov    %eax,(%esp)
c0106585:	e8 6a fe ff ff       	call   c01063f4 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c010658a:	e9 60 02 00 00       	jmp    c01067ef <vprintfmt+0x3cc>
                printfmt(putch, putdat, "%s", p);
c010658f:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0106593:	c7 44 24 08 26 7c 10 	movl   $0xc0107c26,0x8(%esp)
c010659a:	c0 
c010659b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010659e:	89 44 24 04          	mov    %eax,0x4(%esp)
c01065a2:	8b 45 08             	mov    0x8(%ebp),%eax
c01065a5:	89 04 24             	mov    %eax,(%esp)
c01065a8:	e8 47 fe ff ff       	call   c01063f4 <printfmt>
            break;
c01065ad:	e9 3d 02 00 00       	jmp    c01067ef <vprintfmt+0x3cc>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c01065b2:	8b 45 14             	mov    0x14(%ebp),%eax
c01065b5:	8d 50 04             	lea    0x4(%eax),%edx
c01065b8:	89 55 14             	mov    %edx,0x14(%ebp)
c01065bb:	8b 30                	mov    (%eax),%esi
c01065bd:	85 f6                	test   %esi,%esi
c01065bf:	75 05                	jne    c01065c6 <vprintfmt+0x1a3>
                p = "(null)";
c01065c1:	be 29 7c 10 c0       	mov    $0xc0107c29,%esi
            }
            if (width > 0 && padc != '-') {
c01065c6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01065ca:	7e 76                	jle    c0106642 <vprintfmt+0x21f>
c01065cc:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c01065d0:	74 70                	je     c0106642 <vprintfmt+0x21f>
                for (width -= strnlen(p, precision); width > 0; width --) {
c01065d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01065d5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01065d9:	89 34 24             	mov    %esi,(%esp)
c01065dc:	e8 fb f7 ff ff       	call   c0105ddc <strnlen>
c01065e1:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01065e4:	29 c2                	sub    %eax,%edx
c01065e6:	89 d0                	mov    %edx,%eax
c01065e8:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01065eb:	eb 16                	jmp    c0106603 <vprintfmt+0x1e0>
                    putch(padc, putdat);
c01065ed:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c01065f1:	8b 55 0c             	mov    0xc(%ebp),%edx
c01065f4:	89 54 24 04          	mov    %edx,0x4(%esp)
c01065f8:	89 04 24             	mov    %eax,(%esp)
c01065fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01065fe:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
c0106600:	ff 4d e8             	decl   -0x18(%ebp)
c0106603:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0106607:	7f e4                	jg     c01065ed <vprintfmt+0x1ca>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0106609:	eb 37                	jmp    c0106642 <vprintfmt+0x21f>
                if (altflag && (ch < ' ' || ch > '~')) {
c010660b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c010660f:	74 1f                	je     c0106630 <vprintfmt+0x20d>
c0106611:	83 fb 1f             	cmp    $0x1f,%ebx
c0106614:	7e 05                	jle    c010661b <vprintfmt+0x1f8>
c0106616:	83 fb 7e             	cmp    $0x7e,%ebx
c0106619:	7e 15                	jle    c0106630 <vprintfmt+0x20d>
                    putch('?', putdat);
c010661b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010661e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106622:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c0106629:	8b 45 08             	mov    0x8(%ebp),%eax
c010662c:	ff d0                	call   *%eax
c010662e:	eb 0f                	jmp    c010663f <vprintfmt+0x21c>
                }
                else {
                    putch(ch, putdat);
c0106630:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106633:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106637:	89 1c 24             	mov    %ebx,(%esp)
c010663a:	8b 45 08             	mov    0x8(%ebp),%eax
c010663d:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c010663f:	ff 4d e8             	decl   -0x18(%ebp)
c0106642:	89 f0                	mov    %esi,%eax
c0106644:	8d 70 01             	lea    0x1(%eax),%esi
c0106647:	0f b6 00             	movzbl (%eax),%eax
c010664a:	0f be d8             	movsbl %al,%ebx
c010664d:	85 db                	test   %ebx,%ebx
c010664f:	74 27                	je     c0106678 <vprintfmt+0x255>
c0106651:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0106655:	78 b4                	js     c010660b <vprintfmt+0x1e8>
c0106657:	ff 4d e4             	decl   -0x1c(%ebp)
c010665a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010665e:	79 ab                	jns    c010660b <vprintfmt+0x1e8>
                }
            }
            for (; width > 0; width --) {
c0106660:	eb 16                	jmp    c0106678 <vprintfmt+0x255>
                putch(' ', putdat);
c0106662:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106665:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106669:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0106670:	8b 45 08             	mov    0x8(%ebp),%eax
c0106673:	ff d0                	call   *%eax
            for (; width > 0; width --) {
c0106675:	ff 4d e8             	decl   -0x18(%ebp)
c0106678:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010667c:	7f e4                	jg     c0106662 <vprintfmt+0x23f>
            }
            break;
c010667e:	e9 6c 01 00 00       	jmp    c01067ef <vprintfmt+0x3cc>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0106683:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106686:	89 44 24 04          	mov    %eax,0x4(%esp)
c010668a:	8d 45 14             	lea    0x14(%ebp),%eax
c010668d:	89 04 24             	mov    %eax,(%esp)
c0106690:	e8 18 fd ff ff       	call   c01063ad <getint>
c0106695:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106698:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c010669b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010669e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01066a1:	85 d2                	test   %edx,%edx
c01066a3:	79 26                	jns    c01066cb <vprintfmt+0x2a8>
                putch('-', putdat);
c01066a5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01066a8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01066ac:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c01066b3:	8b 45 08             	mov    0x8(%ebp),%eax
c01066b6:	ff d0                	call   *%eax
                num = -(long long)num;
c01066b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01066bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01066be:	f7 d8                	neg    %eax
c01066c0:	83 d2 00             	adc    $0x0,%edx
c01066c3:	f7 da                	neg    %edx
c01066c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01066c8:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c01066cb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01066d2:	e9 a8 00 00 00       	jmp    c010677f <vprintfmt+0x35c>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c01066d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01066da:	89 44 24 04          	mov    %eax,0x4(%esp)
c01066de:	8d 45 14             	lea    0x14(%ebp),%eax
c01066e1:	89 04 24             	mov    %eax,(%esp)
c01066e4:	e8 75 fc ff ff       	call   c010635e <getuint>
c01066e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01066ec:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c01066ef:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01066f6:	e9 84 00 00 00       	jmp    c010677f <vprintfmt+0x35c>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c01066fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01066fe:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106702:	8d 45 14             	lea    0x14(%ebp),%eax
c0106705:	89 04 24             	mov    %eax,(%esp)
c0106708:	e8 51 fc ff ff       	call   c010635e <getuint>
c010670d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106710:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0106713:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c010671a:	eb 63                	jmp    c010677f <vprintfmt+0x35c>

        // pointer
        case 'p':
            putch('0', putdat);
c010671c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010671f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106723:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c010672a:	8b 45 08             	mov    0x8(%ebp),%eax
c010672d:	ff d0                	call   *%eax
            putch('x', putdat);
c010672f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106732:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106736:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c010673d:	8b 45 08             	mov    0x8(%ebp),%eax
c0106740:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0106742:	8b 45 14             	mov    0x14(%ebp),%eax
c0106745:	8d 50 04             	lea    0x4(%eax),%edx
c0106748:	89 55 14             	mov    %edx,0x14(%ebp)
c010674b:	8b 00                	mov    (%eax),%eax
c010674d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106750:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0106757:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c010675e:	eb 1f                	jmp    c010677f <vprintfmt+0x35c>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0106760:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106763:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106767:	8d 45 14             	lea    0x14(%ebp),%eax
c010676a:	89 04 24             	mov    %eax,(%esp)
c010676d:	e8 ec fb ff ff       	call   c010635e <getuint>
c0106772:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106775:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0106778:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c010677f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0106783:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106786:	89 54 24 18          	mov    %edx,0x18(%esp)
c010678a:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010678d:	89 54 24 14          	mov    %edx,0x14(%esp)
c0106791:	89 44 24 10          	mov    %eax,0x10(%esp)
c0106795:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106798:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010679b:	89 44 24 08          	mov    %eax,0x8(%esp)
c010679f:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01067a3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01067a6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01067aa:	8b 45 08             	mov    0x8(%ebp),%eax
c01067ad:	89 04 24             	mov    %eax,(%esp)
c01067b0:	e8 a9 fa ff ff       	call   c010625e <printnum>
            break;
c01067b5:	eb 38                	jmp    c01067ef <vprintfmt+0x3cc>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c01067b7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01067ba:	89 44 24 04          	mov    %eax,0x4(%esp)
c01067be:	89 1c 24             	mov    %ebx,(%esp)
c01067c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01067c4:	ff d0                	call   *%eax
            break;
c01067c6:	eb 27                	jmp    c01067ef <vprintfmt+0x3cc>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c01067c8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01067cb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01067cf:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c01067d6:	8b 45 08             	mov    0x8(%ebp),%eax
c01067d9:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c01067db:	ff 4d 10             	decl   0x10(%ebp)
c01067de:	eb 03                	jmp    c01067e3 <vprintfmt+0x3c0>
c01067e0:	ff 4d 10             	decl   0x10(%ebp)
c01067e3:	8b 45 10             	mov    0x10(%ebp),%eax
c01067e6:	48                   	dec    %eax
c01067e7:	0f b6 00             	movzbl (%eax),%eax
c01067ea:	3c 25                	cmp    $0x25,%al
c01067ec:	75 f2                	jne    c01067e0 <vprintfmt+0x3bd>
                /* do nothing */;
            break;
c01067ee:	90                   	nop
    while (1) {
c01067ef:	e9 37 fc ff ff       	jmp    c010642b <vprintfmt+0x8>
                return;
c01067f4:	90                   	nop
        }
    }
}
c01067f5:	83 c4 40             	add    $0x40,%esp
c01067f8:	5b                   	pop    %ebx
c01067f9:	5e                   	pop    %esi
c01067fa:	5d                   	pop    %ebp
c01067fb:	c3                   	ret    

c01067fc <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c01067fc:	55                   	push   %ebp
c01067fd:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c01067ff:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106802:	8b 40 08             	mov    0x8(%eax),%eax
c0106805:	8d 50 01             	lea    0x1(%eax),%edx
c0106808:	8b 45 0c             	mov    0xc(%ebp),%eax
c010680b:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c010680e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106811:	8b 10                	mov    (%eax),%edx
c0106813:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106816:	8b 40 04             	mov    0x4(%eax),%eax
c0106819:	39 c2                	cmp    %eax,%edx
c010681b:	73 12                	jae    c010682f <sprintputch+0x33>
        *b->buf ++ = ch;
c010681d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106820:	8b 00                	mov    (%eax),%eax
c0106822:	8d 48 01             	lea    0x1(%eax),%ecx
c0106825:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106828:	89 0a                	mov    %ecx,(%edx)
c010682a:	8b 55 08             	mov    0x8(%ebp),%edx
c010682d:	88 10                	mov    %dl,(%eax)
    }
}
c010682f:	90                   	nop
c0106830:	5d                   	pop    %ebp
c0106831:	c3                   	ret    

c0106832 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0106832:	55                   	push   %ebp
c0106833:	89 e5                	mov    %esp,%ebp
c0106835:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0106838:	8d 45 14             	lea    0x14(%ebp),%eax
c010683b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c010683e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106841:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106845:	8b 45 10             	mov    0x10(%ebp),%eax
c0106848:	89 44 24 08          	mov    %eax,0x8(%esp)
c010684c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010684f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106853:	8b 45 08             	mov    0x8(%ebp),%eax
c0106856:	89 04 24             	mov    %eax,(%esp)
c0106859:	e8 08 00 00 00       	call   c0106866 <vsnprintf>
c010685e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0106861:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106864:	c9                   	leave  
c0106865:	c3                   	ret    

c0106866 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0106866:	55                   	push   %ebp
c0106867:	89 e5                	mov    %esp,%ebp
c0106869:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c010686c:	8b 45 08             	mov    0x8(%ebp),%eax
c010686f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106872:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106875:	8d 50 ff             	lea    -0x1(%eax),%edx
c0106878:	8b 45 08             	mov    0x8(%ebp),%eax
c010687b:	01 d0                	add    %edx,%eax
c010687d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106880:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0106887:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010688b:	74 0a                	je     c0106897 <vsnprintf+0x31>
c010688d:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106890:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106893:	39 c2                	cmp    %eax,%edx
c0106895:	76 07                	jbe    c010689e <vsnprintf+0x38>
        return -E_INVAL;
c0106897:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c010689c:	eb 2a                	jmp    c01068c8 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c010689e:	8b 45 14             	mov    0x14(%ebp),%eax
c01068a1:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01068a5:	8b 45 10             	mov    0x10(%ebp),%eax
c01068a8:	89 44 24 08          	mov    %eax,0x8(%esp)
c01068ac:	8d 45 ec             	lea    -0x14(%ebp),%eax
c01068af:	89 44 24 04          	mov    %eax,0x4(%esp)
c01068b3:	c7 04 24 fc 67 10 c0 	movl   $0xc01067fc,(%esp)
c01068ba:	e8 64 fb ff ff       	call   c0106423 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c01068bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01068c2:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c01068c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01068c8:	c9                   	leave  
c01068c9:	c3                   	ret    
