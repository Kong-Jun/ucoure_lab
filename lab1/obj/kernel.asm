
bin/kernel：     文件格式 elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
static void lab1_print_cur_status(void);
static void lab1_switch_test(void);


int
kern_init(void) {
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	83 ec 18             	sub    $0x18,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100006:	b8 40 1d 11 00       	mov    $0x111d40,%eax
  10000b:	2d 16 0a 11 00       	sub    $0x110a16,%eax
  100010:	83 ec 04             	sub    $0x4,%esp
  100013:	50                   	push   %eax
  100014:	6a 00                	push   $0x0
  100016:	68 16 0a 11 00       	push   $0x110a16
  10001b:	e8 ca 30 00 00       	call   1030ea <memset>
  100020:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
  100023:	e8 82 15 00 00       	call   1015aa <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100028:	c7 45 f0 80 38 10 00 	movl   $0x103880,-0x10(%ebp)
    cprintf("%s\n\n", message);
  10002f:	83 ec 08             	sub    $0x8,%esp
  100032:	ff 75 f0             	pushl  -0x10(%ebp)
  100035:	68 9c 38 10 00       	push   $0x10389c
  10003a:	e8 41 02 00 00       	call   100280 <cprintf>
  10003f:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
  100042:	e8 cd 08 00 00       	call   100914 <print_kerninfo>

    grade_backtrace();
  100047:	e8 af 00 00 00       	call   1000fb <grade_backtrace>

    pmm_init();                 // init physical memory management
  10004c:	e8 5d 2d 00 00       	call   102dae <pmm_init>

    pic_init();                 // init interrupt controller
  100051:	e8 97 16 00 00       	call   1016ed <pic_init>
    idt_init();                 // init interrupt descriptor table
  100056:	e8 2a 18 00 00       	call   101885 <idt_init>

    clock_init();               // init clock interrupt
  10005b:	e8 2b 0d 00 00       	call   100d8b <clock_init>
    intr_enable();              // enable irq interrupt
  100060:	e8 c5 17 00 00       	call   10182a <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    lab1_switch_test();
  100065:	e8 87 01 00 00       	call   1001f1 <lab1_switch_test>

    /* do nothing */
	long cnt = 0;
  10006a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
		if ((++cnt) % 10000000 == 0)
  100071:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100075:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  100078:	ba 6b ca 5f 6b       	mov    $0x6b5fca6b,%edx
  10007d:	89 c8                	mov    %ecx,%eax
  10007f:	f7 ea                	imul   %edx
  100081:	c1 fa 16             	sar    $0x16,%edx
  100084:	89 c8                	mov    %ecx,%eax
  100086:	c1 f8 1f             	sar    $0x1f,%eax
  100089:	29 c2                	sub    %eax,%edx
  10008b:	89 d0                	mov    %edx,%eax
  10008d:	69 c0 80 96 98 00    	imul   $0x989680,%eax,%eax
  100093:	29 c1                	sub    %eax,%ecx
  100095:	89 c8                	mov    %ecx,%eax
  100097:	85 c0                	test   %eax,%eax
  100099:	75 d6                	jne    100071 <kern_init+0x71>
			lab1_print_cur_status();
  10009b:	e8 7c 00 00 00       	call   10011c <lab1_print_cur_status>
		if ((++cnt) % 10000000 == 0)
  1000a0:	eb cf                	jmp    100071 <kern_init+0x71>

001000a2 <grade_backtrace2>:
	}
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  1000a2:	55                   	push   %ebp
  1000a3:	89 e5                	mov    %esp,%ebp
  1000a5:	83 ec 08             	sub    $0x8,%esp
    mon_backtrace(0, NULL, NULL);
  1000a8:	83 ec 04             	sub    $0x4,%esp
  1000ab:	6a 00                	push   $0x0
  1000ad:	6a 00                	push   $0x0
  1000af:	6a 00                	push   $0x0
  1000b1:	e8 c3 0c 00 00       	call   100d79 <mon_backtrace>
  1000b6:	83 c4 10             	add    $0x10,%esp
}
  1000b9:	90                   	nop
  1000ba:	c9                   	leave  
  1000bb:	c3                   	ret    

001000bc <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000bc:	55                   	push   %ebp
  1000bd:	89 e5                	mov    %esp,%ebp
  1000bf:	53                   	push   %ebx
  1000c0:	83 ec 04             	sub    $0x4,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000c3:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  1000c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  1000c9:	8d 5d 08             	lea    0x8(%ebp),%ebx
  1000cc:	8b 45 08             	mov    0x8(%ebp),%eax
  1000cf:	51                   	push   %ecx
  1000d0:	52                   	push   %edx
  1000d1:	53                   	push   %ebx
  1000d2:	50                   	push   %eax
  1000d3:	e8 ca ff ff ff       	call   1000a2 <grade_backtrace2>
  1000d8:	83 c4 10             	add    $0x10,%esp
}
  1000db:	90                   	nop
  1000dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1000df:	c9                   	leave  
  1000e0:	c3                   	ret    

001000e1 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000e1:	55                   	push   %ebp
  1000e2:	89 e5                	mov    %esp,%ebp
  1000e4:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace1(arg0, arg2);
  1000e7:	83 ec 08             	sub    $0x8,%esp
  1000ea:	ff 75 10             	pushl  0x10(%ebp)
  1000ed:	ff 75 08             	pushl  0x8(%ebp)
  1000f0:	e8 c7 ff ff ff       	call   1000bc <grade_backtrace1>
  1000f5:	83 c4 10             	add    $0x10,%esp
}
  1000f8:	90                   	nop
  1000f9:	c9                   	leave  
  1000fa:	c3                   	ret    

001000fb <grade_backtrace>:

void
grade_backtrace(void) {
  1000fb:	55                   	push   %ebp
  1000fc:	89 e5                	mov    %esp,%ebp
  1000fe:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  100101:	b8 00 00 10 00       	mov    $0x100000,%eax
  100106:	83 ec 04             	sub    $0x4,%esp
  100109:	68 00 00 ff ff       	push   $0xffff0000
  10010e:	50                   	push   %eax
  10010f:	6a 00                	push   $0x0
  100111:	e8 cb ff ff ff       	call   1000e1 <grade_backtrace0>
  100116:	83 c4 10             	add    $0x10,%esp
}
  100119:	90                   	nop
  10011a:	c9                   	leave  
  10011b:	c3                   	ret    

0010011c <lab1_print_cur_status>:

/* print segment register info and privilege info */
static void
lab1_print_cur_status(void) {
  10011c:	55                   	push   %ebp
  10011d:	89 e5                	mov    %esp,%ebp
  10011f:	83 ec 18             	sub    $0x18,%esp
    uint16_t reg1, reg2, reg3, reg4;
	static int round;
    asm volatile (
  100122:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100125:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100128:	8c 45 f2             	mov    %es,-0xe(%ebp)
  10012b:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  10012e:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100132:	0f b7 c0             	movzwl %ax,%eax
  100135:	83 e0 03             	and    $0x3,%eax
  100138:	89 c2                	mov    %eax,%edx
  10013a:	a1 20 0a 11 00       	mov    0x110a20,%eax
  10013f:	83 ec 04             	sub    $0x4,%esp
  100142:	52                   	push   %edx
  100143:	50                   	push   %eax
  100144:	68 a1 38 10 00       	push   $0x1038a1
  100149:	e8 32 01 00 00       	call   100280 <cprintf>
  10014e:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
  100151:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100155:	0f b7 d0             	movzwl %ax,%edx
  100158:	a1 20 0a 11 00       	mov    0x110a20,%eax
  10015d:	83 ec 04             	sub    $0x4,%esp
  100160:	52                   	push   %edx
  100161:	50                   	push   %eax
  100162:	68 af 38 10 00       	push   $0x1038af
  100167:	e8 14 01 00 00       	call   100280 <cprintf>
  10016c:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
  10016f:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100173:	0f b7 d0             	movzwl %ax,%edx
  100176:	a1 20 0a 11 00       	mov    0x110a20,%eax
  10017b:	83 ec 04             	sub    $0x4,%esp
  10017e:	52                   	push   %edx
  10017f:	50                   	push   %eax
  100180:	68 bd 38 10 00       	push   $0x1038bd
  100185:	e8 f6 00 00 00       	call   100280 <cprintf>
  10018a:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
  10018d:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100191:	0f b7 d0             	movzwl %ax,%edx
  100194:	a1 20 0a 11 00       	mov    0x110a20,%eax
  100199:	83 ec 04             	sub    $0x4,%esp
  10019c:	52                   	push   %edx
  10019d:	50                   	push   %eax
  10019e:	68 cb 38 10 00       	push   $0x1038cb
  1001a3:	e8 d8 00 00 00       	call   100280 <cprintf>
  1001a8:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
  1001ab:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001af:	0f b7 d0             	movzwl %ax,%edx
  1001b2:	a1 20 0a 11 00       	mov    0x110a20,%eax
  1001b7:	83 ec 04             	sub    $0x4,%esp
  1001ba:	52                   	push   %edx
  1001bb:	50                   	push   %eax
  1001bc:	68 d9 38 10 00       	push   $0x1038d9
  1001c1:	e8 ba 00 00 00       	call   100280 <cprintf>
  1001c6:	83 c4 10             	add    $0x10,%esp
	++round;
  1001c9:	a1 20 0a 11 00       	mov    0x110a20,%eax
  1001ce:	83 c0 01             	add    $0x1,%eax
  1001d1:	a3 20 0a 11 00       	mov    %eax,0x110a20
}
  1001d6:	90                   	nop
  1001d7:	c9                   	leave  
  1001d8:	c3                   	ret    

001001d9 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001d9:	55                   	push   %ebp
  1001da:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
	__asm__ __volatile__ (
  1001dc:	b8 23 00 00 00       	mov    $0x23,%eax
  1001e1:	50                   	push   %eax
  1001e2:	54                   	push   %esp
  1001e3:	cd 78                	int    $0x78
		"pushl %%esp\n\t"
		"int %0\n\t"
		:
		:"i" (T_SWITCH_TOU), "a" (USER_DS)
	);
}
  1001e5:	90                   	nop
  1001e6:	5d                   	pop    %ebp
  1001e7:	c3                   	ret    

001001e8 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001e8:	55                   	push   %ebp
  1001e9:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
	__asm__ __volatile__ (
  1001eb:	cd 79                	int    $0x79
  1001ed:	5c                   	pop    %esp
		"int %0\n\t"
		"popl %%esp\n\t"
		:
		:"i" (T_SWITCH_TOK)
	);
}
  1001ee:	90                   	nop
  1001ef:	5d                   	pop    %ebp
  1001f0:	c3                   	ret    

001001f1 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001f1:	55                   	push   %ebp
  1001f2:	89 e5                	mov    %esp,%ebp
  1001f4:	83 ec 08             	sub    $0x8,%esp
    lab1_print_cur_status();
  1001f7:	e8 20 ff ff ff       	call   10011c <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001fc:	83 ec 0c             	sub    $0xc,%esp
  1001ff:	68 e8 38 10 00       	push   $0x1038e8
  100204:	e8 77 00 00 00       	call   100280 <cprintf>
  100209:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
  10020c:	e8 c8 ff ff ff       	call   1001d9 <lab1_switch_to_user>
    lab1_print_cur_status();
  100211:	e8 06 ff ff ff       	call   10011c <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  100216:	83 ec 0c             	sub    $0xc,%esp
  100219:	68 08 39 10 00       	push   $0x103908
  10021e:	e8 5d 00 00 00       	call   100280 <cprintf>
  100223:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_kernel();
  100226:	e8 bd ff ff ff       	call   1001e8 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  10022b:	e8 ec fe ff ff       	call   10011c <lab1_print_cur_status>
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
  100236:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
  100239:	83 ec 0c             	sub    $0xc,%esp
  10023c:	ff 75 08             	pushl  0x8(%ebp)
  10023f:	e8 97 13 00 00       	call   1015db <cons_putc>
  100244:	83 c4 10             	add    $0x10,%esp
    (*cnt) ++;
  100247:	8b 45 0c             	mov    0xc(%ebp),%eax
  10024a:	8b 00                	mov    (%eax),%eax
  10024c:	8d 50 01             	lea    0x1(%eax),%edx
  10024f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100252:	89 10                	mov    %edx,(%eax)
}
  100254:	90                   	nop
  100255:	c9                   	leave  
  100256:	c3                   	ret    

00100257 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100257:	55                   	push   %ebp
  100258:	89 e5                	mov    %esp,%ebp
  10025a:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
  10025d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100264:	ff 75 0c             	pushl  0xc(%ebp)
  100267:	ff 75 08             	pushl  0x8(%ebp)
  10026a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10026d:	50                   	push   %eax
  10026e:	68 33 02 10 00       	push   $0x100233
  100273:	e8 a3 31 00 00       	call   10341b <vprintfmt>
  100278:	83 c4 10             	add    $0x10,%esp
    return cnt;
  10027b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10027e:	c9                   	leave  
  10027f:	c3                   	ret    

00100280 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100280:	55                   	push   %ebp
  100281:	89 e5                	mov    %esp,%ebp
  100283:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100286:	8d 45 0c             	lea    0xc(%ebp),%eax
  100289:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  10028c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10028f:	83 ec 08             	sub    $0x8,%esp
  100292:	50                   	push   %eax
  100293:	ff 75 08             	pushl  0x8(%ebp)
  100296:	e8 bc ff ff ff       	call   100257 <vcprintf>
  10029b:	83 c4 10             	add    $0x10,%esp
  10029e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1002a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002a4:	c9                   	leave  
  1002a5:	c3                   	ret    

001002a6 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  1002a6:	55                   	push   %ebp
  1002a7:	89 e5                	mov    %esp,%ebp
  1002a9:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
  1002ac:	83 ec 0c             	sub    $0xc,%esp
  1002af:	ff 75 08             	pushl  0x8(%ebp)
  1002b2:	e8 24 13 00 00       	call   1015db <cons_putc>
  1002b7:	83 c4 10             	add    $0x10,%esp
}
  1002ba:	90                   	nop
  1002bb:	c9                   	leave  
  1002bc:	c3                   	ret    

001002bd <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  1002bd:	55                   	push   %ebp
  1002be:	89 e5                	mov    %esp,%ebp
  1002c0:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
  1002c3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  1002ca:	eb 14                	jmp    1002e0 <cputs+0x23>
        cputch(c, &cnt);
  1002cc:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  1002d0:	83 ec 08             	sub    $0x8,%esp
  1002d3:	8d 55 f0             	lea    -0x10(%ebp),%edx
  1002d6:	52                   	push   %edx
  1002d7:	50                   	push   %eax
  1002d8:	e8 56 ff ff ff       	call   100233 <cputch>
  1002dd:	83 c4 10             	add    $0x10,%esp
    while ((c = *str ++) != '\0') {
  1002e0:	8b 45 08             	mov    0x8(%ebp),%eax
  1002e3:	8d 50 01             	lea    0x1(%eax),%edx
  1002e6:	89 55 08             	mov    %edx,0x8(%ebp)
  1002e9:	0f b6 00             	movzbl (%eax),%eax
  1002ec:	88 45 f7             	mov    %al,-0x9(%ebp)
  1002ef:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1002f3:	75 d7                	jne    1002cc <cputs+0xf>
    }
    cputch('\n', &cnt);
  1002f5:	83 ec 08             	sub    $0x8,%esp
  1002f8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1002fb:	50                   	push   %eax
  1002fc:	6a 0a                	push   $0xa
  1002fe:	e8 30 ff ff ff       	call   100233 <cputch>
  100303:	83 c4 10             	add    $0x10,%esp
    return cnt;
  100306:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  100309:	c9                   	leave  
  10030a:	c3                   	ret    

0010030b <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  10030b:	55                   	push   %ebp
  10030c:	89 e5                	mov    %esp,%ebp
  10030e:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  100311:	90                   	nop
  100312:	e8 f4 12 00 00       	call   10160b <cons_getc>
  100317:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10031a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10031e:	74 f2                	je     100312 <getchar+0x7>
        /* do nothing */;
    return c;
  100320:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100323:	c9                   	leave  
  100324:	c3                   	ret    

00100325 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100325:	55                   	push   %ebp
  100326:	89 e5                	mov    %esp,%ebp
  100328:	83 ec 18             	sub    $0x18,%esp
    if (prompt != NULL) {
  10032b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10032f:	74 13                	je     100344 <readline+0x1f>
        cprintf("%s", prompt);
  100331:	83 ec 08             	sub    $0x8,%esp
  100334:	ff 75 08             	pushl  0x8(%ebp)
  100337:	68 27 39 10 00       	push   $0x103927
  10033c:	e8 3f ff ff ff       	call   100280 <cprintf>
  100341:	83 c4 10             	add    $0x10,%esp
    }
    int i = 0, c;
  100344:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  10034b:	e8 bb ff ff ff       	call   10030b <getchar>
  100350:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100353:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100357:	79 0a                	jns    100363 <readline+0x3e>
            return NULL;
  100359:	b8 00 00 00 00       	mov    $0x0,%eax
  10035e:	e9 82 00 00 00       	jmp    1003e5 <readline+0xc0>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100363:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100367:	7e 2b                	jle    100394 <readline+0x6f>
  100369:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100370:	7f 22                	jg     100394 <readline+0x6f>
            cputchar(c);
  100372:	83 ec 0c             	sub    $0xc,%esp
  100375:	ff 75 f0             	pushl  -0x10(%ebp)
  100378:	e8 29 ff ff ff       	call   1002a6 <cputchar>
  10037d:	83 c4 10             	add    $0x10,%esp
            buf[i ++] = c;
  100380:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100383:	8d 50 01             	lea    0x1(%eax),%edx
  100386:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100389:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10038c:	88 90 40 0a 11 00    	mov    %dl,0x110a40(%eax)
  100392:	eb 4c                	jmp    1003e0 <readline+0xbb>
        }
        else if (c == '\b' && i > 0) {
  100394:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  100398:	75 1a                	jne    1003b4 <readline+0x8f>
  10039a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10039e:	7e 14                	jle    1003b4 <readline+0x8f>
            cputchar(c);
  1003a0:	83 ec 0c             	sub    $0xc,%esp
  1003a3:	ff 75 f0             	pushl  -0x10(%ebp)
  1003a6:	e8 fb fe ff ff       	call   1002a6 <cputchar>
  1003ab:	83 c4 10             	add    $0x10,%esp
            i --;
  1003ae:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1003b2:	eb 2c                	jmp    1003e0 <readline+0xbb>
        }
        else if (c == '\n' || c == '\r') {
  1003b4:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1003b8:	74 06                	je     1003c0 <readline+0x9b>
  1003ba:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1003be:	75 8b                	jne    10034b <readline+0x26>
            cputchar(c);
  1003c0:	83 ec 0c             	sub    $0xc,%esp
  1003c3:	ff 75 f0             	pushl  -0x10(%ebp)
  1003c6:	e8 db fe ff ff       	call   1002a6 <cputchar>
  1003cb:	83 c4 10             	add    $0x10,%esp
            buf[i] = '\0';
  1003ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003d1:	05 40 0a 11 00       	add    $0x110a40,%eax
  1003d6:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1003d9:	b8 40 0a 11 00       	mov    $0x110a40,%eax
  1003de:	eb 05                	jmp    1003e5 <readline+0xc0>
        c = getchar();
  1003e0:	e9 66 ff ff ff       	jmp    10034b <readline+0x26>
        }
    }
}
  1003e5:	c9                   	leave  
  1003e6:	c3                   	ret    

001003e7 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  1003e7:	55                   	push   %ebp
  1003e8:	89 e5                	mov    %esp,%ebp
  1003ea:	83 ec 18             	sub    $0x18,%esp
    if (is_panic) {
  1003ed:	a1 40 0e 11 00       	mov    0x110e40,%eax
  1003f2:	85 c0                	test   %eax,%eax
  1003f4:	75 5f                	jne    100455 <__panic+0x6e>
        goto panic_dead;
    }
    is_panic = 1;
  1003f6:	c7 05 40 0e 11 00 01 	movl   $0x1,0x110e40
  1003fd:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100400:	8d 45 14             	lea    0x14(%ebp),%eax
  100403:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100406:	83 ec 04             	sub    $0x4,%esp
  100409:	ff 75 0c             	pushl  0xc(%ebp)
  10040c:	ff 75 08             	pushl  0x8(%ebp)
  10040f:	68 2a 39 10 00       	push   $0x10392a
  100414:	e8 67 fe ff ff       	call   100280 <cprintf>
  100419:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  10041c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10041f:	83 ec 08             	sub    $0x8,%esp
  100422:	50                   	push   %eax
  100423:	ff 75 10             	pushl  0x10(%ebp)
  100426:	e8 2c fe ff ff       	call   100257 <vcprintf>
  10042b:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  10042e:	83 ec 0c             	sub    $0xc,%esp
  100431:	68 46 39 10 00       	push   $0x103946
  100436:	e8 45 fe ff ff       	call   100280 <cprintf>
  10043b:	83 c4 10             	add    $0x10,%esp
    
    cprintf("stack trackback:\n");
  10043e:	83 ec 0c             	sub    $0xc,%esp
  100441:	68 48 39 10 00       	push   $0x103948
  100446:	e8 35 fe ff ff       	call   100280 <cprintf>
  10044b:	83 c4 10             	add    $0x10,%esp
    print_stackframe();
  10044e:	e8 09 06 00 00       	call   100a5c <print_stackframe>
  100453:	eb 01                	jmp    100456 <__panic+0x6f>
        goto panic_dead;
  100455:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
  100456:	e8 d6 13 00 00       	call   101831 <intr_disable>
    while (1) {
        kmonitor(NULL);
  10045b:	83 ec 0c             	sub    $0xc,%esp
  10045e:	6a 00                	push   $0x0
  100460:	e8 3a 08 00 00       	call   100c9f <kmonitor>
  100465:	83 c4 10             	add    $0x10,%esp
  100468:	eb f1                	jmp    10045b <__panic+0x74>

0010046a <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  10046a:	55                   	push   %ebp
  10046b:	89 e5                	mov    %esp,%ebp
  10046d:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    va_start(ap, fmt);
  100470:	8d 45 14             	lea    0x14(%ebp),%eax
  100473:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100476:	83 ec 04             	sub    $0x4,%esp
  100479:	ff 75 0c             	pushl  0xc(%ebp)
  10047c:	ff 75 08             	pushl  0x8(%ebp)
  10047f:	68 5a 39 10 00       	push   $0x10395a
  100484:	e8 f7 fd ff ff       	call   100280 <cprintf>
  100489:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  10048c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10048f:	83 ec 08             	sub    $0x8,%esp
  100492:	50                   	push   %eax
  100493:	ff 75 10             	pushl  0x10(%ebp)
  100496:	e8 bc fd ff ff       	call   100257 <vcprintf>
  10049b:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  10049e:	83 ec 0c             	sub    $0xc,%esp
  1004a1:	68 46 39 10 00       	push   $0x103946
  1004a6:	e8 d5 fd ff ff       	call   100280 <cprintf>
  1004ab:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  1004ae:	90                   	nop
  1004af:	c9                   	leave  
  1004b0:	c3                   	ret    

001004b1 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  1004b1:	55                   	push   %ebp
  1004b2:	89 e5                	mov    %esp,%ebp
    return is_panic;
  1004b4:	a1 40 0e 11 00       	mov    0x110e40,%eax
}
  1004b9:	5d                   	pop    %ebp
  1004ba:	c3                   	ret    

001004bb <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1004bb:	55                   	push   %ebp
  1004bc:	89 e5                	mov    %esp,%ebp
  1004be:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1004c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004c4:	8b 00                	mov    (%eax),%eax
  1004c6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1004c9:	8b 45 10             	mov    0x10(%ebp),%eax
  1004cc:	8b 00                	mov    (%eax),%eax
  1004ce:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1004d8:	e9 d2 00 00 00       	jmp    1005af <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1004dd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1004e3:	01 d0                	add    %edx,%eax
  1004e5:	89 c2                	mov    %eax,%edx
  1004e7:	c1 ea 1f             	shr    $0x1f,%edx
  1004ea:	01 d0                	add    %edx,%eax
  1004ec:	d1 f8                	sar    %eax
  1004ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1004f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004f4:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1004f7:	eb 04                	jmp    1004fd <stab_binsearch+0x42>
            m --;
  1004f9:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  1004fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100500:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100503:	7c 1f                	jl     100524 <stab_binsearch+0x69>
  100505:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100508:	89 d0                	mov    %edx,%eax
  10050a:	01 c0                	add    %eax,%eax
  10050c:	01 d0                	add    %edx,%eax
  10050e:	c1 e0 02             	shl    $0x2,%eax
  100511:	89 c2                	mov    %eax,%edx
  100513:	8b 45 08             	mov    0x8(%ebp),%eax
  100516:	01 d0                	add    %edx,%eax
  100518:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10051c:	0f b6 c0             	movzbl %al,%eax
  10051f:	39 45 14             	cmp    %eax,0x14(%ebp)
  100522:	75 d5                	jne    1004f9 <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
  100524:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100527:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10052a:	7d 0b                	jge    100537 <stab_binsearch+0x7c>
            l = true_m + 1;
  10052c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10052f:	83 c0 01             	add    $0x1,%eax
  100532:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100535:	eb 78                	jmp    1005af <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  100537:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  10053e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100541:	89 d0                	mov    %edx,%eax
  100543:	01 c0                	add    %eax,%eax
  100545:	01 d0                	add    %edx,%eax
  100547:	c1 e0 02             	shl    $0x2,%eax
  10054a:	89 c2                	mov    %eax,%edx
  10054c:	8b 45 08             	mov    0x8(%ebp),%eax
  10054f:	01 d0                	add    %edx,%eax
  100551:	8b 40 08             	mov    0x8(%eax),%eax
  100554:	39 45 18             	cmp    %eax,0x18(%ebp)
  100557:	76 13                	jbe    10056c <stab_binsearch+0xb1>
            *region_left = m;
  100559:	8b 45 0c             	mov    0xc(%ebp),%eax
  10055c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10055f:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100561:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100564:	83 c0 01             	add    $0x1,%eax
  100567:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10056a:	eb 43                	jmp    1005af <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  10056c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10056f:	89 d0                	mov    %edx,%eax
  100571:	01 c0                	add    %eax,%eax
  100573:	01 d0                	add    %edx,%eax
  100575:	c1 e0 02             	shl    $0x2,%eax
  100578:	89 c2                	mov    %eax,%edx
  10057a:	8b 45 08             	mov    0x8(%ebp),%eax
  10057d:	01 d0                	add    %edx,%eax
  10057f:	8b 40 08             	mov    0x8(%eax),%eax
  100582:	39 45 18             	cmp    %eax,0x18(%ebp)
  100585:	73 16                	jae    10059d <stab_binsearch+0xe2>
            *region_right = m - 1;
  100587:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10058a:	8d 50 ff             	lea    -0x1(%eax),%edx
  10058d:	8b 45 10             	mov    0x10(%ebp),%eax
  100590:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  100592:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100595:	83 e8 01             	sub    $0x1,%eax
  100598:	89 45 f8             	mov    %eax,-0x8(%ebp)
  10059b:	eb 12                	jmp    1005af <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  10059d:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005a0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005a3:	89 10                	mov    %edx,(%eax)
            l = m;
  1005a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005a8:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1005ab:	83 45 18 01          	addl   $0x1,0x18(%ebp)
    while (l <= r) {
  1005af:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1005b2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1005b5:	0f 8e 22 ff ff ff    	jle    1004dd <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
  1005bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1005bf:	75 0f                	jne    1005d0 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  1005c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005c4:	8b 00                	mov    (%eax),%eax
  1005c6:	8d 50 ff             	lea    -0x1(%eax),%edx
  1005c9:	8b 45 10             	mov    0x10(%ebp),%eax
  1005cc:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  1005ce:	eb 3f                	jmp    10060f <stab_binsearch+0x154>
        l = *region_right;
  1005d0:	8b 45 10             	mov    0x10(%ebp),%eax
  1005d3:	8b 00                	mov    (%eax),%eax
  1005d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1005d8:	eb 04                	jmp    1005de <stab_binsearch+0x123>
  1005da:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  1005de:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005e1:	8b 00                	mov    (%eax),%eax
  1005e3:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  1005e6:	7e 1f                	jle    100607 <stab_binsearch+0x14c>
  1005e8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005eb:	89 d0                	mov    %edx,%eax
  1005ed:	01 c0                	add    %eax,%eax
  1005ef:	01 d0                	add    %edx,%eax
  1005f1:	c1 e0 02             	shl    $0x2,%eax
  1005f4:	89 c2                	mov    %eax,%edx
  1005f6:	8b 45 08             	mov    0x8(%ebp),%eax
  1005f9:	01 d0                	add    %edx,%eax
  1005fb:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1005ff:	0f b6 c0             	movzbl %al,%eax
  100602:	39 45 14             	cmp    %eax,0x14(%ebp)
  100605:	75 d3                	jne    1005da <stab_binsearch+0x11f>
        *region_left = l;
  100607:	8b 45 0c             	mov    0xc(%ebp),%eax
  10060a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10060d:	89 10                	mov    %edx,(%eax)
}
  10060f:	90                   	nop
  100610:	c9                   	leave  
  100611:	c3                   	ret    

00100612 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100612:	55                   	push   %ebp
  100613:	89 e5                	mov    %esp,%ebp
  100615:	83 ec 38             	sub    $0x38,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100618:	8b 45 0c             	mov    0xc(%ebp),%eax
  10061b:	c7 00 78 39 10 00    	movl   $0x103978,(%eax)
    info->eip_line = 0;
  100621:	8b 45 0c             	mov    0xc(%ebp),%eax
  100624:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  10062b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10062e:	c7 40 08 78 39 10 00 	movl   $0x103978,0x8(%eax)
    info->eip_fn_namelen = 9;
  100635:	8b 45 0c             	mov    0xc(%ebp),%eax
  100638:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  10063f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100642:	8b 55 08             	mov    0x8(%ebp),%edx
  100645:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100648:	8b 45 0c             	mov    0xc(%ebp),%eax
  10064b:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100652:	c7 45 f4 ac 41 10 00 	movl   $0x1041ac,-0xc(%ebp)
    stab_end = __STAB_END__;
  100659:	c7 45 f0 f8 d0 10 00 	movl   $0x10d0f8,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100660:	c7 45 ec f9 d0 10 00 	movl   $0x10d0f9,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100667:	c7 45 e8 5e f2 10 00 	movl   $0x10f25e,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  10066e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100671:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100674:	76 0d                	jbe    100683 <debuginfo_eip+0x71>
  100676:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100679:	83 e8 01             	sub    $0x1,%eax
  10067c:	0f b6 00             	movzbl (%eax),%eax
  10067f:	84 c0                	test   %al,%al
  100681:	74 0a                	je     10068d <debuginfo_eip+0x7b>
        return -1;
  100683:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100688:	e9 85 02 00 00       	jmp    100912 <debuginfo_eip+0x300>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  10068d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  100694:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100697:	2b 45 f4             	sub    -0xc(%ebp),%eax
  10069a:	c1 f8 02             	sar    $0x2,%eax
  10069d:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1006a3:	83 e8 01             	sub    $0x1,%eax
  1006a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1006a9:	ff 75 08             	pushl  0x8(%ebp)
  1006ac:	6a 64                	push   $0x64
  1006ae:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1006b1:	50                   	push   %eax
  1006b2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1006b5:	50                   	push   %eax
  1006b6:	ff 75 f4             	pushl  -0xc(%ebp)
  1006b9:	e8 fd fd ff ff       	call   1004bb <stab_binsearch>
  1006be:	83 c4 14             	add    $0x14,%esp
    if (lfile == 0)
  1006c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006c4:	85 c0                	test   %eax,%eax
  1006c6:	75 0a                	jne    1006d2 <debuginfo_eip+0xc0>
        return -1;
  1006c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006cd:	e9 40 02 00 00       	jmp    100912 <debuginfo_eip+0x300>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1006d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006d5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1006d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006db:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1006de:	ff 75 08             	pushl  0x8(%ebp)
  1006e1:	6a 24                	push   $0x24
  1006e3:	8d 45 d8             	lea    -0x28(%ebp),%eax
  1006e6:	50                   	push   %eax
  1006e7:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1006ea:	50                   	push   %eax
  1006eb:	ff 75 f4             	pushl  -0xc(%ebp)
  1006ee:	e8 c8 fd ff ff       	call   1004bb <stab_binsearch>
  1006f3:	83 c4 14             	add    $0x14,%esp

    if (lfun <= rfun) {
  1006f6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1006f9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006fc:	39 c2                	cmp    %eax,%edx
  1006fe:	7f 78                	jg     100778 <debuginfo_eip+0x166>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  100700:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100703:	89 c2                	mov    %eax,%edx
  100705:	89 d0                	mov    %edx,%eax
  100707:	01 c0                	add    %eax,%eax
  100709:	01 d0                	add    %edx,%eax
  10070b:	c1 e0 02             	shl    $0x2,%eax
  10070e:	89 c2                	mov    %eax,%edx
  100710:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100713:	01 d0                	add    %edx,%eax
  100715:	8b 10                	mov    (%eax),%edx
  100717:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10071a:	2b 45 ec             	sub    -0x14(%ebp),%eax
  10071d:	39 c2                	cmp    %eax,%edx
  10071f:	73 22                	jae    100743 <debuginfo_eip+0x131>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100721:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100724:	89 c2                	mov    %eax,%edx
  100726:	89 d0                	mov    %edx,%eax
  100728:	01 c0                	add    %eax,%eax
  10072a:	01 d0                	add    %edx,%eax
  10072c:	c1 e0 02             	shl    $0x2,%eax
  10072f:	89 c2                	mov    %eax,%edx
  100731:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100734:	01 d0                	add    %edx,%eax
  100736:	8b 10                	mov    (%eax),%edx
  100738:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10073b:	01 c2                	add    %eax,%edx
  10073d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100740:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100743:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100746:	89 c2                	mov    %eax,%edx
  100748:	89 d0                	mov    %edx,%eax
  10074a:	01 c0                	add    %eax,%eax
  10074c:	01 d0                	add    %edx,%eax
  10074e:	c1 e0 02             	shl    $0x2,%eax
  100751:	89 c2                	mov    %eax,%edx
  100753:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100756:	01 d0                	add    %edx,%eax
  100758:	8b 50 08             	mov    0x8(%eax),%edx
  10075b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10075e:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  100761:	8b 45 0c             	mov    0xc(%ebp),%eax
  100764:	8b 40 10             	mov    0x10(%eax),%eax
  100767:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  10076a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10076d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  100770:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100773:	89 45 d0             	mov    %eax,-0x30(%ebp)
  100776:	eb 15                	jmp    10078d <debuginfo_eip+0x17b>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  100778:	8b 45 0c             	mov    0xc(%ebp),%eax
  10077b:	8b 55 08             	mov    0x8(%ebp),%edx
  10077e:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  100781:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100784:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  100787:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10078a:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  10078d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100790:	8b 40 08             	mov    0x8(%eax),%eax
  100793:	83 ec 08             	sub    $0x8,%esp
  100796:	6a 3a                	push   $0x3a
  100798:	50                   	push   %eax
  100799:	e8 c0 27 00 00       	call   102f5e <strfind>
  10079e:	83 c4 10             	add    $0x10,%esp
  1007a1:	89 c2                	mov    %eax,%edx
  1007a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007a6:	8b 40 08             	mov    0x8(%eax),%eax
  1007a9:	29 c2                	sub    %eax,%edx
  1007ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007ae:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1007b1:	83 ec 0c             	sub    $0xc,%esp
  1007b4:	ff 75 08             	pushl  0x8(%ebp)
  1007b7:	6a 44                	push   $0x44
  1007b9:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1007bc:	50                   	push   %eax
  1007bd:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1007c0:	50                   	push   %eax
  1007c1:	ff 75 f4             	pushl  -0xc(%ebp)
  1007c4:	e8 f2 fc ff ff       	call   1004bb <stab_binsearch>
  1007c9:	83 c4 20             	add    $0x20,%esp
    if (lline <= rline) {
  1007cc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007cf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007d2:	39 c2                	cmp    %eax,%edx
  1007d4:	7f 24                	jg     1007fa <debuginfo_eip+0x1e8>
        info->eip_line = stabs[rline].n_desc;
  1007d6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007d9:	89 c2                	mov    %eax,%edx
  1007db:	89 d0                	mov    %edx,%eax
  1007dd:	01 c0                	add    %eax,%eax
  1007df:	01 d0                	add    %edx,%eax
  1007e1:	c1 e0 02             	shl    $0x2,%eax
  1007e4:	89 c2                	mov    %eax,%edx
  1007e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007e9:	01 d0                	add    %edx,%eax
  1007eb:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  1007ef:	0f b7 d0             	movzwl %ax,%edx
  1007f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007f5:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  1007f8:	eb 13                	jmp    10080d <debuginfo_eip+0x1fb>
        return -1;
  1007fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1007ff:	e9 0e 01 00 00       	jmp    100912 <debuginfo_eip+0x300>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100804:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100807:	83 e8 01             	sub    $0x1,%eax
  10080a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  10080d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100810:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100813:	39 c2                	cmp    %eax,%edx
  100815:	7c 56                	jl     10086d <debuginfo_eip+0x25b>
           && stabs[lline].n_type != N_SOL
  100817:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10081a:	89 c2                	mov    %eax,%edx
  10081c:	89 d0                	mov    %edx,%eax
  10081e:	01 c0                	add    %eax,%eax
  100820:	01 d0                	add    %edx,%eax
  100822:	c1 e0 02             	shl    $0x2,%eax
  100825:	89 c2                	mov    %eax,%edx
  100827:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10082a:	01 d0                	add    %edx,%eax
  10082c:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100830:	3c 84                	cmp    $0x84,%al
  100832:	74 39                	je     10086d <debuginfo_eip+0x25b>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100834:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100837:	89 c2                	mov    %eax,%edx
  100839:	89 d0                	mov    %edx,%eax
  10083b:	01 c0                	add    %eax,%eax
  10083d:	01 d0                	add    %edx,%eax
  10083f:	c1 e0 02             	shl    $0x2,%eax
  100842:	89 c2                	mov    %eax,%edx
  100844:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100847:	01 d0                	add    %edx,%eax
  100849:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10084d:	3c 64                	cmp    $0x64,%al
  10084f:	75 b3                	jne    100804 <debuginfo_eip+0x1f2>
  100851:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100854:	89 c2                	mov    %eax,%edx
  100856:	89 d0                	mov    %edx,%eax
  100858:	01 c0                	add    %eax,%eax
  10085a:	01 d0                	add    %edx,%eax
  10085c:	c1 e0 02             	shl    $0x2,%eax
  10085f:	89 c2                	mov    %eax,%edx
  100861:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100864:	01 d0                	add    %edx,%eax
  100866:	8b 40 08             	mov    0x8(%eax),%eax
  100869:	85 c0                	test   %eax,%eax
  10086b:	74 97                	je     100804 <debuginfo_eip+0x1f2>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  10086d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100870:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100873:	39 c2                	cmp    %eax,%edx
  100875:	7c 42                	jl     1008b9 <debuginfo_eip+0x2a7>
  100877:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10087a:	89 c2                	mov    %eax,%edx
  10087c:	89 d0                	mov    %edx,%eax
  10087e:	01 c0                	add    %eax,%eax
  100880:	01 d0                	add    %edx,%eax
  100882:	c1 e0 02             	shl    $0x2,%eax
  100885:	89 c2                	mov    %eax,%edx
  100887:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10088a:	01 d0                	add    %edx,%eax
  10088c:	8b 10                	mov    (%eax),%edx
  10088e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100891:	2b 45 ec             	sub    -0x14(%ebp),%eax
  100894:	39 c2                	cmp    %eax,%edx
  100896:	73 21                	jae    1008b9 <debuginfo_eip+0x2a7>
        info->eip_file = stabstr + stabs[lline].n_strx;
  100898:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10089b:	89 c2                	mov    %eax,%edx
  10089d:	89 d0                	mov    %edx,%eax
  10089f:	01 c0                	add    %eax,%eax
  1008a1:	01 d0                	add    %edx,%eax
  1008a3:	c1 e0 02             	shl    $0x2,%eax
  1008a6:	89 c2                	mov    %eax,%edx
  1008a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008ab:	01 d0                	add    %edx,%eax
  1008ad:	8b 10                	mov    (%eax),%edx
  1008af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1008b2:	01 c2                	add    %eax,%edx
  1008b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008b7:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1008b9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1008bc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1008bf:	39 c2                	cmp    %eax,%edx
  1008c1:	7d 4a                	jge    10090d <debuginfo_eip+0x2fb>
        for (lline = lfun + 1;
  1008c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1008c6:	83 c0 01             	add    $0x1,%eax
  1008c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1008cc:	eb 18                	jmp    1008e6 <debuginfo_eip+0x2d4>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  1008ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008d1:	8b 40 14             	mov    0x14(%eax),%eax
  1008d4:	8d 50 01             	lea    0x1(%eax),%edx
  1008d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008da:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  1008dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008e0:	83 c0 01             	add    $0x1,%eax
  1008e3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008e6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1008e9:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
  1008ec:	39 c2                	cmp    %eax,%edx
  1008ee:	7d 1d                	jge    10090d <debuginfo_eip+0x2fb>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008f0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008f3:	89 c2                	mov    %eax,%edx
  1008f5:	89 d0                	mov    %edx,%eax
  1008f7:	01 c0                	add    %eax,%eax
  1008f9:	01 d0                	add    %edx,%eax
  1008fb:	c1 e0 02             	shl    $0x2,%eax
  1008fe:	89 c2                	mov    %eax,%edx
  100900:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100903:	01 d0                	add    %edx,%eax
  100905:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100909:	3c a0                	cmp    $0xa0,%al
  10090b:	74 c1                	je     1008ce <debuginfo_eip+0x2bc>
        }
    }
    return 0;
  10090d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100912:	c9                   	leave  
  100913:	c3                   	ret    

00100914 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100914:	55                   	push   %ebp
  100915:	89 e5                	mov    %esp,%ebp
  100917:	83 ec 08             	sub    $0x8,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  10091a:	83 ec 0c             	sub    $0xc,%esp
  10091d:	68 82 39 10 00       	push   $0x103982
  100922:	e8 59 f9 ff ff       	call   100280 <cprintf>
  100927:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  10092a:	83 ec 08             	sub    $0x8,%esp
  10092d:	68 00 00 10 00       	push   $0x100000
  100932:	68 9b 39 10 00       	push   $0x10399b
  100937:	e8 44 f9 ff ff       	call   100280 <cprintf>
  10093c:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
  10093f:	83 ec 08             	sub    $0x8,%esp
  100942:	68 7c 38 10 00       	push   $0x10387c
  100947:	68 b3 39 10 00       	push   $0x1039b3
  10094c:	e8 2f f9 ff ff       	call   100280 <cprintf>
  100951:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
  100954:	83 ec 08             	sub    $0x8,%esp
  100957:	68 16 0a 11 00       	push   $0x110a16
  10095c:	68 cb 39 10 00       	push   $0x1039cb
  100961:	e8 1a f9 ff ff       	call   100280 <cprintf>
  100966:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
  100969:	83 ec 08             	sub    $0x8,%esp
  10096c:	68 40 1d 11 00       	push   $0x111d40
  100971:	68 e3 39 10 00       	push   $0x1039e3
  100976:	e8 05 f9 ff ff       	call   100280 <cprintf>
  10097b:	83 c4 10             	add    $0x10,%esp
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  10097e:	b8 40 1d 11 00       	mov    $0x111d40,%eax
  100983:	2d 00 00 10 00       	sub    $0x100000,%eax
  100988:	05 ff 03 00 00       	add    $0x3ff,%eax
  10098d:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  100993:	85 c0                	test   %eax,%eax
  100995:	0f 48 c2             	cmovs  %edx,%eax
  100998:	c1 f8 0a             	sar    $0xa,%eax
  10099b:	83 ec 08             	sub    $0x8,%esp
  10099e:	50                   	push   %eax
  10099f:	68 fc 39 10 00       	push   $0x1039fc
  1009a4:	e8 d7 f8 ff ff       	call   100280 <cprintf>
  1009a9:	83 c4 10             	add    $0x10,%esp
}
  1009ac:	90                   	nop
  1009ad:	c9                   	leave  
  1009ae:	c3                   	ret    

001009af <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1009af:	55                   	push   %ebp
  1009b0:	89 e5                	mov    %esp,%ebp
  1009b2:	81 ec 28 01 00 00    	sub    $0x128,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1009b8:	83 ec 08             	sub    $0x8,%esp
  1009bb:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1009be:	50                   	push   %eax
  1009bf:	ff 75 08             	pushl  0x8(%ebp)
  1009c2:	e8 4b fc ff ff       	call   100612 <debuginfo_eip>
  1009c7:	83 c4 10             	add    $0x10,%esp
  1009ca:	85 c0                	test   %eax,%eax
  1009cc:	74 15                	je     1009e3 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  1009ce:	83 ec 08             	sub    $0x8,%esp
  1009d1:	ff 75 08             	pushl  0x8(%ebp)
  1009d4:	68 26 3a 10 00       	push   $0x103a26
  1009d9:	e8 a2 f8 ff ff       	call   100280 <cprintf>
  1009de:	83 c4 10             	add    $0x10,%esp
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  1009e1:	eb 65                	jmp    100a48 <print_debuginfo+0x99>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009e3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1009ea:	eb 1c                	jmp    100a08 <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  1009ec:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1009ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009f2:	01 d0                	add    %edx,%eax
  1009f4:	0f b6 00             	movzbl (%eax),%eax
  1009f7:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  1009fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100a00:	01 ca                	add    %ecx,%edx
  100a02:	88 02                	mov    %al,(%edx)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a04:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100a08:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a0b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  100a0e:	7c dc                	jl     1009ec <print_debuginfo+0x3d>
        fnname[j] = '\0';
  100a10:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a19:	01 d0                	add    %edx,%eax
  100a1b:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
  100a1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100a21:	8b 55 08             	mov    0x8(%ebp),%edx
  100a24:	89 d1                	mov    %edx,%ecx
  100a26:	29 c1                	sub    %eax,%ecx
  100a28:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100a2b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100a2e:	83 ec 0c             	sub    $0xc,%esp
  100a31:	51                   	push   %ecx
  100a32:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a38:	51                   	push   %ecx
  100a39:	52                   	push   %edx
  100a3a:	50                   	push   %eax
  100a3b:	68 42 3a 10 00       	push   $0x103a42
  100a40:	e8 3b f8 ff ff       	call   100280 <cprintf>
  100a45:	83 c4 20             	add    $0x20,%esp
}
  100a48:	90                   	nop
  100a49:	c9                   	leave  
  100a4a:	c3                   	ret    

00100a4b <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100a4b:	55                   	push   %ebp
  100a4c:	89 e5                	mov    %esp,%ebp
  100a4e:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100a51:	8b 45 04             	mov    0x4(%ebp),%eax
  100a54:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100a57:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100a5a:	c9                   	leave  
  100a5b:	c3                   	ret    

00100a5c <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100a5c:	55                   	push   %ebp
  100a5d:	89 e5                	mov    %esp,%ebp
  100a5f:	83 ec 28             	sub    $0x28,%esp

	/* In my version, I don't popup the calling stackframe. After exeution of print_stackframe,
	 * PC still point to current stackframe(the stackframe of print_stackframe()) 
	 */
	uint32_t eip, ebp;
	size_t i = 0, j = 0;
  100a62:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100a69:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	eip = read_eip();
  100a70:	e8 d6 ff ff ff       	call   100a4b <read_eip>
  100a75:	89 45 f4             	mov    %eax,-0xc(%ebp)
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100a78:	89 e8                	mov    %ebp,%eax
  100a7a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return ebp;
  100a7d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
	ebp = read_ebp();
  100a80:	89 45 f0             	mov    %eax,-0x10(%ebp)
	for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i++) {
  100a83:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100a8a:	e9 95 00 00 00       	jmp    100b24 <print_stackframe+0xc8>
		cprintf("ebp:0x%08x eip:0x%08x ", ebp, eip);
  100a8f:	83 ec 04             	sub    $0x4,%esp
  100a92:	ff 75 f4             	pushl  -0xc(%ebp)
  100a95:	ff 75 f0             	pushl  -0x10(%ebp)
  100a98:	68 54 3a 10 00       	push   $0x103a54
  100a9d:	e8 de f7 ff ff       	call   100280 <cprintf>
  100aa2:	83 c4 10             	add    $0x10,%esp
		cprintf("args:");
  100aa5:	83 ec 0c             	sub    $0xc,%esp
  100aa8:	68 6b 3a 10 00       	push   $0x103a6b
  100aad:	e8 ce f7 ff ff       	call   100280 <cprintf>
  100ab2:	83 c4 10             	add    $0x10,%esp
		for(j = 0; j < 4; j++) {
  100ab5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100abc:	eb 27                	jmp    100ae5 <print_stackframe+0x89>
			cprintf("0x%08x ", (uint32_t*)(ebp) + 2 + j);
  100abe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100ac1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100ac8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100acb:	01 d0                	add    %edx,%eax
  100acd:	83 c0 08             	add    $0x8,%eax
  100ad0:	83 ec 08             	sub    $0x8,%esp
  100ad3:	50                   	push   %eax
  100ad4:	68 71 3a 10 00       	push   $0x103a71
  100ad9:	e8 a2 f7 ff ff       	call   100280 <cprintf>
  100ade:	83 c4 10             	add    $0x10,%esp
		for(j = 0; j < 4; j++) {
  100ae1:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100ae5:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100ae9:	76 d3                	jbe    100abe <print_stackframe+0x62>
		}
		cprintf("\n");
  100aeb:	83 ec 0c             	sub    $0xc,%esp
  100aee:	68 79 3a 10 00       	push   $0x103a79
  100af3:	e8 88 f7 ff ff       	call   100280 <cprintf>
  100af8:	83 c4 10             	add    $0x10,%esp
		print_debuginfo(eip - 1);
  100afb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100afe:	83 e8 01             	sub    $0x1,%eax
  100b01:	83 ec 0c             	sub    $0xc,%esp
  100b04:	50                   	push   %eax
  100b05:	e8 a5 fe ff ff       	call   1009af <print_debuginfo>
  100b0a:	83 c4 10             	add    $0x10,%esp
		ebp = *((uint32_t *)ebp);		
  100b0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100b10:	8b 00                	mov    (%eax),%eax
  100b12:	89 45 f0             	mov    %eax,-0x10(%ebp)
		eip = *((uint32_t *)ebp + 1);
  100b15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100b18:	83 c0 04             	add    $0x4,%eax
  100b1b:	8b 00                	mov    (%eax),%eax
  100b1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i++) {
  100b20:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100b24:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b28:	74 0a                	je     100b34 <print_stackframe+0xd8>
  100b2a:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100b2e:	0f 86 5b ff ff ff    	jbe    100a8f <print_stackframe+0x33>
        ebp = ((uint32_t *)ebp)[0];
    }
	*/


}
  100b34:	90                   	nop
  100b35:	c9                   	leave  
  100b36:	c3                   	ret    

00100b37 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100b37:	55                   	push   %ebp
  100b38:	89 e5                	mov    %esp,%ebp
  100b3a:	83 ec 18             	sub    $0x18,%esp
    int argc = 0;
  100b3d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b44:	eb 0c                	jmp    100b52 <parse+0x1b>
            *buf ++ = '\0';
  100b46:	8b 45 08             	mov    0x8(%ebp),%eax
  100b49:	8d 50 01             	lea    0x1(%eax),%edx
  100b4c:	89 55 08             	mov    %edx,0x8(%ebp)
  100b4f:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b52:	8b 45 08             	mov    0x8(%ebp),%eax
  100b55:	0f b6 00             	movzbl (%eax),%eax
  100b58:	84 c0                	test   %al,%al
  100b5a:	74 1e                	je     100b7a <parse+0x43>
  100b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  100b5f:	0f b6 00             	movzbl (%eax),%eax
  100b62:	0f be c0             	movsbl %al,%eax
  100b65:	83 ec 08             	sub    $0x8,%esp
  100b68:	50                   	push   %eax
  100b69:	68 fc 3a 10 00       	push   $0x103afc
  100b6e:	e8 b8 23 00 00       	call   102f2b <strchr>
  100b73:	83 c4 10             	add    $0x10,%esp
  100b76:	85 c0                	test   %eax,%eax
  100b78:	75 cc                	jne    100b46 <parse+0xf>
        }
        if (*buf == '\0') {
  100b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  100b7d:	0f b6 00             	movzbl (%eax),%eax
  100b80:	84 c0                	test   %al,%al
  100b82:	74 65                	je     100be9 <parse+0xb2>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100b84:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100b88:	75 12                	jne    100b9c <parse+0x65>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100b8a:	83 ec 08             	sub    $0x8,%esp
  100b8d:	6a 10                	push   $0x10
  100b8f:	68 01 3b 10 00       	push   $0x103b01
  100b94:	e8 e7 f6 ff ff       	call   100280 <cprintf>
  100b99:	83 c4 10             	add    $0x10,%esp
        }
        argv[argc ++] = buf;
  100b9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b9f:	8d 50 01             	lea    0x1(%eax),%edx
  100ba2:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100ba5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100bac:	8b 45 0c             	mov    0xc(%ebp),%eax
  100baf:	01 c2                	add    %eax,%edx
  100bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  100bb4:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100bb6:	eb 04                	jmp    100bbc <parse+0x85>
            buf ++;
  100bb8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  100bbf:	0f b6 00             	movzbl (%eax),%eax
  100bc2:	84 c0                	test   %al,%al
  100bc4:	74 8c                	je     100b52 <parse+0x1b>
  100bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  100bc9:	0f b6 00             	movzbl (%eax),%eax
  100bcc:	0f be c0             	movsbl %al,%eax
  100bcf:	83 ec 08             	sub    $0x8,%esp
  100bd2:	50                   	push   %eax
  100bd3:	68 fc 3a 10 00       	push   $0x103afc
  100bd8:	e8 4e 23 00 00       	call   102f2b <strchr>
  100bdd:	83 c4 10             	add    $0x10,%esp
  100be0:	85 c0                	test   %eax,%eax
  100be2:	74 d4                	je     100bb8 <parse+0x81>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100be4:	e9 69 ff ff ff       	jmp    100b52 <parse+0x1b>
            break;
  100be9:	90                   	nop
        }
    }
    return argc;
  100bea:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100bed:	c9                   	leave  
  100bee:	c3                   	ret    

00100bef <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100bef:	55                   	push   %ebp
  100bf0:	89 e5                	mov    %esp,%ebp
  100bf2:	83 ec 58             	sub    $0x58,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100bf5:	83 ec 08             	sub    $0x8,%esp
  100bf8:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100bfb:	50                   	push   %eax
  100bfc:	ff 75 08             	pushl  0x8(%ebp)
  100bff:	e8 33 ff ff ff       	call   100b37 <parse>
  100c04:	83 c4 10             	add    $0x10,%esp
  100c07:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100c0a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100c0e:	75 0a                	jne    100c1a <runcmd+0x2b>
        return 0;
  100c10:	b8 00 00 00 00       	mov    $0x0,%eax
  100c15:	e9 83 00 00 00       	jmp    100c9d <runcmd+0xae>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c1a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c21:	eb 59                	jmp    100c7c <runcmd+0x8d>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100c23:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100c26:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c29:	89 d0                	mov    %edx,%eax
  100c2b:	01 c0                	add    %eax,%eax
  100c2d:	01 d0                	add    %edx,%eax
  100c2f:	c1 e0 02             	shl    $0x2,%eax
  100c32:	05 00 00 11 00       	add    $0x110000,%eax
  100c37:	8b 00                	mov    (%eax),%eax
  100c39:	83 ec 08             	sub    $0x8,%esp
  100c3c:	51                   	push   %ecx
  100c3d:	50                   	push   %eax
  100c3e:	e8 48 22 00 00       	call   102e8b <strcmp>
  100c43:	83 c4 10             	add    $0x10,%esp
  100c46:	85 c0                	test   %eax,%eax
  100c48:	75 2e                	jne    100c78 <runcmd+0x89>
            return commands[i].func(argc - 1, argv + 1, tf);
  100c4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c4d:	89 d0                	mov    %edx,%eax
  100c4f:	01 c0                	add    %eax,%eax
  100c51:	01 d0                	add    %edx,%eax
  100c53:	c1 e0 02             	shl    $0x2,%eax
  100c56:	05 08 00 11 00       	add    $0x110008,%eax
  100c5b:	8b 10                	mov    (%eax),%edx
  100c5d:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c60:	83 c0 04             	add    $0x4,%eax
  100c63:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100c66:	83 e9 01             	sub    $0x1,%ecx
  100c69:	83 ec 04             	sub    $0x4,%esp
  100c6c:	ff 75 0c             	pushl  0xc(%ebp)
  100c6f:	50                   	push   %eax
  100c70:	51                   	push   %ecx
  100c71:	ff d2                	call   *%edx
  100c73:	83 c4 10             	add    $0x10,%esp
  100c76:	eb 25                	jmp    100c9d <runcmd+0xae>
    for (i = 0; i < NCOMMANDS; i ++) {
  100c78:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c7f:	83 f8 02             	cmp    $0x2,%eax
  100c82:	76 9f                	jbe    100c23 <runcmd+0x34>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100c84:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100c87:	83 ec 08             	sub    $0x8,%esp
  100c8a:	50                   	push   %eax
  100c8b:	68 1f 3b 10 00       	push   $0x103b1f
  100c90:	e8 eb f5 ff ff       	call   100280 <cprintf>
  100c95:	83 c4 10             	add    $0x10,%esp
    return 0;
  100c98:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c9d:	c9                   	leave  
  100c9e:	c3                   	ret    

00100c9f <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100c9f:	55                   	push   %ebp
  100ca0:	89 e5                	mov    %esp,%ebp
  100ca2:	83 ec 18             	sub    $0x18,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100ca5:	83 ec 0c             	sub    $0xc,%esp
  100ca8:	68 38 3b 10 00       	push   $0x103b38
  100cad:	e8 ce f5 ff ff       	call   100280 <cprintf>
  100cb2:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
  100cb5:	83 ec 0c             	sub    $0xc,%esp
  100cb8:	68 60 3b 10 00       	push   $0x103b60
  100cbd:	e8 be f5 ff ff       	call   100280 <cprintf>
  100cc2:	83 c4 10             	add    $0x10,%esp

    if (tf != NULL) {
  100cc5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100cc9:	74 0e                	je     100cd9 <kmonitor+0x3a>
        print_trapframe(tf);
  100ccb:	83 ec 0c             	sub    $0xc,%esp
  100cce:	ff 75 08             	pushl  0x8(%ebp)
  100cd1:	e8 62 0e 00 00       	call   101b38 <print_trapframe>
  100cd6:	83 c4 10             	add    $0x10,%esp
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100cd9:	83 ec 0c             	sub    $0xc,%esp
  100cdc:	68 85 3b 10 00       	push   $0x103b85
  100ce1:	e8 3f f6 ff ff       	call   100325 <readline>
  100ce6:	83 c4 10             	add    $0x10,%esp
  100ce9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100cec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100cf0:	74 e7                	je     100cd9 <kmonitor+0x3a>
            if (runcmd(buf, tf) < 0) {
  100cf2:	83 ec 08             	sub    $0x8,%esp
  100cf5:	ff 75 08             	pushl  0x8(%ebp)
  100cf8:	ff 75 f4             	pushl  -0xc(%ebp)
  100cfb:	e8 ef fe ff ff       	call   100bef <runcmd>
  100d00:	83 c4 10             	add    $0x10,%esp
  100d03:	85 c0                	test   %eax,%eax
  100d05:	78 02                	js     100d09 <kmonitor+0x6a>
        if ((buf = readline("K> ")) != NULL) {
  100d07:	eb d0                	jmp    100cd9 <kmonitor+0x3a>
                break;
  100d09:	90                   	nop
            }
        }
    }
}
  100d0a:	90                   	nop
  100d0b:	c9                   	leave  
  100d0c:	c3                   	ret    

00100d0d <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100d0d:	55                   	push   %ebp
  100d0e:	89 e5                	mov    %esp,%ebp
  100d10:	83 ec 18             	sub    $0x18,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100d13:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100d1a:	eb 3c                	jmp    100d58 <mon_help+0x4b>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100d1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d1f:	89 d0                	mov    %edx,%eax
  100d21:	01 c0                	add    %eax,%eax
  100d23:	01 d0                	add    %edx,%eax
  100d25:	c1 e0 02             	shl    $0x2,%eax
  100d28:	05 04 00 11 00       	add    $0x110004,%eax
  100d2d:	8b 08                	mov    (%eax),%ecx
  100d2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d32:	89 d0                	mov    %edx,%eax
  100d34:	01 c0                	add    %eax,%eax
  100d36:	01 d0                	add    %edx,%eax
  100d38:	c1 e0 02             	shl    $0x2,%eax
  100d3b:	05 00 00 11 00       	add    $0x110000,%eax
  100d40:	8b 00                	mov    (%eax),%eax
  100d42:	83 ec 04             	sub    $0x4,%esp
  100d45:	51                   	push   %ecx
  100d46:	50                   	push   %eax
  100d47:	68 89 3b 10 00       	push   $0x103b89
  100d4c:	e8 2f f5 ff ff       	call   100280 <cprintf>
  100d51:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < NCOMMANDS; i ++) {
  100d54:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100d58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d5b:	83 f8 02             	cmp    $0x2,%eax
  100d5e:	76 bc                	jbe    100d1c <mon_help+0xf>
    }
    return 0;
  100d60:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d65:	c9                   	leave  
  100d66:	c3                   	ret    

00100d67 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100d67:	55                   	push   %ebp
  100d68:	89 e5                	mov    %esp,%ebp
  100d6a:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100d6d:	e8 a2 fb ff ff       	call   100914 <print_kerninfo>
    return 0;
  100d72:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d77:	c9                   	leave  
  100d78:	c3                   	ret    

00100d79 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100d79:	55                   	push   %ebp
  100d7a:	89 e5                	mov    %esp,%ebp
  100d7c:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100d7f:	e8 d8 fc ff ff       	call   100a5c <print_stackframe>
    return 0;
  100d84:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d89:	c9                   	leave  
  100d8a:	c3                   	ret    

00100d8b <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d8b:	55                   	push   %ebp
  100d8c:	89 e5                	mov    %esp,%ebp
  100d8e:	83 ec 18             	sub    $0x18,%esp
  100d91:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100d97:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d9b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100d9f:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100da3:	ee                   	out    %al,(%dx)
  100da4:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100daa:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100dae:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100db2:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100db6:	ee                   	out    %al,(%dx)
  100db7:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100dbd:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
  100dc1:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100dc5:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100dc9:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100dca:	c7 05 28 19 11 00 00 	movl   $0x0,0x111928
  100dd1:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100dd4:	83 ec 0c             	sub    $0xc,%esp
  100dd7:	68 92 3b 10 00       	push   $0x103b92
  100ddc:	e8 9f f4 ff ff       	call   100280 <cprintf>
  100de1:	83 c4 10             	add    $0x10,%esp
    pic_enable(IRQ_TIMER);
  100de4:	83 ec 0c             	sub    $0xc,%esp
  100de7:	6a 00                	push   $0x0
  100de9:	e8 d2 08 00 00       	call   1016c0 <pic_enable>
  100dee:	83 c4 10             	add    $0x10,%esp
}
  100df1:	90                   	nop
  100df2:	c9                   	leave  
  100df3:	c3                   	ret    

00100df4 <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100df4:	55                   	push   %ebp
  100df5:	89 e5                	mov    %esp,%ebp
  100df7:	83 ec 10             	sub    $0x10,%esp
  100dfa:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e00:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e04:	89 c2                	mov    %eax,%edx
  100e06:	ec                   	in     (%dx),%al
  100e07:	88 45 f1             	mov    %al,-0xf(%ebp)
  100e0a:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e10:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e14:	89 c2                	mov    %eax,%edx
  100e16:	ec                   	in     (%dx),%al
  100e17:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e1a:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e20:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e24:	89 c2                	mov    %eax,%edx
  100e26:	ec                   	in     (%dx),%al
  100e27:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e2a:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  100e30:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e34:	89 c2                	mov    %eax,%edx
  100e36:	ec                   	in     (%dx),%al
  100e37:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e3a:	90                   	nop
  100e3b:	c9                   	leave  
  100e3c:	c3                   	ret    

00100e3d <cga_init>:
//    -- 数据寄存器 映射 到 端口 0x3D5或0x3B5 
//    -- 索引寄存器 0x3D4或0x3B4,决定在数据寄存器中的数据表示什么。

/* TEXT-mode CGA/VGA display output */
static void
cga_init(void) {
  100e3d:	55                   	push   %ebp
  100e3e:	89 e5                	mov    %esp,%ebp
  100e40:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;   //CGA_BUF: 0xB8000 (彩色显示的显存物理基址)
  100e43:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;                                            //保存当前显存0xB8000处的值
  100e4a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e4d:	0f b7 00             	movzwl (%eax),%eax
  100e50:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;                                   // 给这个地址随便写个值，看看能否再读出同样的值
  100e54:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e57:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {                                            // 如果读不出来，说明没有这块显存，即是单显配置
  100e5c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e5f:	0f b7 00             	movzwl (%eax),%eax
  100e62:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e66:	74 12                	je     100e7a <cga_init+0x3d>
        cp = (uint16_t*)MONO_BUF;                         //设置为单显的显存基址 MONO_BUF： 0xB0000
  100e68:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;                           //设置为单显控制的IO地址，MONO_BASE: 0x3B4
  100e6f:	66 c7 05 66 0e 11 00 	movw   $0x3b4,0x110e66
  100e76:	b4 03 
  100e78:	eb 13                	jmp    100e8d <cga_init+0x50>
    } else {                                                                // 如果读出来了，有这块显存，即是彩显配置
        *cp = was;                                                      //还原原来显存位置的值
  100e7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e7d:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e81:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;                               // 设置为彩显控制的IO地址，CGA_BASE: 0x3D4 
  100e84:	66 c7 05 66 0e 11 00 	movw   $0x3d4,0x110e66
  100e8b:	d4 03 
    // Extract cursor location
    // 6845索引寄存器的index 0x0E（及十进制的14）== 光标位置(高位)
    // 6845索引寄存器的index 0x0F（及十进制的15）== 光标位置(低位)
    // 6845 reg 15 : Cursor Address (Low Byte)
    uint32_t pos;
    outb(addr_6845, 14);                                        
  100e8d:	0f b7 05 66 0e 11 00 	movzwl 0x110e66,%eax
  100e94:	0f b7 c0             	movzwl %ax,%eax
  100e97:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100e9b:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e9f:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100ea3:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100ea7:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;                       //读出了光标位置(高位)
  100ea8:	0f b7 05 66 0e 11 00 	movzwl 0x110e66,%eax
  100eaf:	83 c0 01             	add    $0x1,%eax
  100eb2:	0f b7 c0             	movzwl %ax,%eax
  100eb5:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100eb9:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
  100ebd:	89 c2                	mov    %eax,%edx
  100ebf:	ec                   	in     (%dx),%al
  100ec0:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  100ec3:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100ec7:	0f b6 c0             	movzbl %al,%eax
  100eca:	c1 e0 08             	shl    $0x8,%eax
  100ecd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100ed0:	0f b7 05 66 0e 11 00 	movzwl 0x110e66,%eax
  100ed7:	0f b7 c0             	movzwl %ax,%eax
  100eda:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100ede:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ee2:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100ee6:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100eea:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);                             //读出了光标位置(低位)
  100eeb:	0f b7 05 66 0e 11 00 	movzwl 0x110e66,%eax
  100ef2:	83 c0 01             	add    $0x1,%eax
  100ef5:	0f b7 c0             	movzwl %ax,%eax
  100ef8:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100efc:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100f00:	89 c2                	mov    %eax,%edx
  100f02:	ec                   	in     (%dx),%al
  100f03:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  100f06:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f0a:	0f b6 c0             	movzbl %al,%eax
  100f0d:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;                                  //crt_buf是CGA显存起始地址
  100f10:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f13:	a3 60 0e 11 00       	mov    %eax,0x110e60
    crt_pos = pos;                                                  //crt_pos是CGA当前光标位置
  100f18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f1b:	66 a3 64 0e 11 00    	mov    %ax,0x110e64
}
  100f21:	90                   	nop
  100f22:	c9                   	leave  
  100f23:	c3                   	ret    

00100f24 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f24:	55                   	push   %ebp
  100f25:	89 e5                	mov    %esp,%ebp
  100f27:	83 ec 38             	sub    $0x38,%esp
  100f2a:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  100f30:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f34:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  100f38:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  100f3c:	ee                   	out    %al,(%dx)
  100f3d:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  100f43:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
  100f47:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  100f4b:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  100f4f:	ee                   	out    %al,(%dx)
  100f50:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  100f56:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
  100f5a:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  100f5e:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  100f62:	ee                   	out    %al,(%dx)
  100f63:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100f69:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
  100f6d:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f71:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100f75:	ee                   	out    %al,(%dx)
  100f76:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  100f7c:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
  100f80:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100f84:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100f88:	ee                   	out    %al,(%dx)
  100f89:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  100f8f:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
  100f93:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f97:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f9b:	ee                   	out    %al,(%dx)
  100f9c:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100fa2:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
  100fa6:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100faa:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100fae:	ee                   	out    %al,(%dx)
  100faf:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100fb5:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100fb9:	89 c2                	mov    %eax,%edx
  100fbb:	ec                   	in     (%dx),%al
  100fbc:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100fbf:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100fc3:	3c ff                	cmp    $0xff,%al
  100fc5:	0f 95 c0             	setne  %al
  100fc8:	0f b6 c0             	movzbl %al,%eax
  100fcb:	a3 68 0e 11 00       	mov    %eax,0x110e68
  100fd0:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100fd6:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100fda:	89 c2                	mov    %eax,%edx
  100fdc:	ec                   	in     (%dx),%al
  100fdd:	88 45 f1             	mov    %al,-0xf(%ebp)
  100fe0:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  100fe6:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100fea:	89 c2                	mov    %eax,%edx
  100fec:	ec                   	in     (%dx),%al
  100fed:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100ff0:	a1 68 0e 11 00       	mov    0x110e68,%eax
  100ff5:	85 c0                	test   %eax,%eax
  100ff7:	74 0d                	je     101006 <serial_init+0xe2>
        pic_enable(IRQ_COM1);
  100ff9:	83 ec 0c             	sub    $0xc,%esp
  100ffc:	6a 04                	push   $0x4
  100ffe:	e8 bd 06 00 00       	call   1016c0 <pic_enable>
  101003:	83 c4 10             	add    $0x10,%esp
    }
}
  101006:	90                   	nop
  101007:	c9                   	leave  
  101008:	c3                   	ret    

00101009 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  101009:	55                   	push   %ebp
  10100a:	89 e5                	mov    %esp,%ebp
  10100c:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  10100f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101016:	eb 09                	jmp    101021 <lpt_putc_sub+0x18>
        delay();
  101018:	e8 d7 fd ff ff       	call   100df4 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  10101d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101021:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  101027:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10102b:	89 c2                	mov    %eax,%edx
  10102d:	ec                   	in     (%dx),%al
  10102e:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101031:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101035:	84 c0                	test   %al,%al
  101037:	78 09                	js     101042 <lpt_putc_sub+0x39>
  101039:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101040:	7e d6                	jle    101018 <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
  101042:	8b 45 08             	mov    0x8(%ebp),%eax
  101045:	0f b6 c0             	movzbl %al,%eax
  101048:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  10104e:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101051:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101055:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101059:	ee                   	out    %al,(%dx)
  10105a:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  101060:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  101064:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101068:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10106c:	ee                   	out    %al,(%dx)
  10106d:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  101073:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
  101077:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10107b:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10107f:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101080:	90                   	nop
  101081:	c9                   	leave  
  101082:	c3                   	ret    

00101083 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  101083:	55                   	push   %ebp
  101084:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  101086:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  10108a:	74 0d                	je     101099 <lpt_putc+0x16>
        lpt_putc_sub(c);
  10108c:	ff 75 08             	pushl  0x8(%ebp)
  10108f:	e8 75 ff ff ff       	call   101009 <lpt_putc_sub>
  101094:	83 c4 04             	add    $0x4,%esp
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  101097:	eb 1e                	jmp    1010b7 <lpt_putc+0x34>
        lpt_putc_sub('\b');
  101099:	6a 08                	push   $0x8
  10109b:	e8 69 ff ff ff       	call   101009 <lpt_putc_sub>
  1010a0:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub(' ');
  1010a3:	6a 20                	push   $0x20
  1010a5:	e8 5f ff ff ff       	call   101009 <lpt_putc_sub>
  1010aa:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub('\b');
  1010ad:	6a 08                	push   $0x8
  1010af:	e8 55 ff ff ff       	call   101009 <lpt_putc_sub>
  1010b4:	83 c4 04             	add    $0x4,%esp
}
  1010b7:	90                   	nop
  1010b8:	c9                   	leave  
  1010b9:	c3                   	ret    

001010ba <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  1010ba:	55                   	push   %ebp
  1010bb:	89 e5                	mov    %esp,%ebp
  1010bd:	53                   	push   %ebx
  1010be:	83 ec 24             	sub    $0x24,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  1010c1:	8b 45 08             	mov    0x8(%ebp),%eax
  1010c4:	b0 00                	mov    $0x0,%al
  1010c6:	85 c0                	test   %eax,%eax
  1010c8:	75 07                	jne    1010d1 <cga_putc+0x17>
        c |= 0x0700;
  1010ca:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  1010d1:	8b 45 08             	mov    0x8(%ebp),%eax
  1010d4:	0f b6 c0             	movzbl %al,%eax
  1010d7:	83 f8 0a             	cmp    $0xa,%eax
  1010da:	74 52                	je     10112e <cga_putc+0x74>
  1010dc:	83 f8 0d             	cmp    $0xd,%eax
  1010df:	74 5d                	je     10113e <cga_putc+0x84>
  1010e1:	83 f8 08             	cmp    $0x8,%eax
  1010e4:	0f 85 8e 00 00 00    	jne    101178 <cga_putc+0xbe>
    case '\b':
        if (crt_pos > 0) {
  1010ea:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  1010f1:	66 85 c0             	test   %ax,%ax
  1010f4:	0f 84 a4 00 00 00    	je     10119e <cga_putc+0xe4>
            crt_pos --;
  1010fa:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  101101:	83 e8 01             	sub    $0x1,%eax
  101104:	66 a3 64 0e 11 00    	mov    %ax,0x110e64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  10110a:	8b 45 08             	mov    0x8(%ebp),%eax
  10110d:	b0 00                	mov    $0x0,%al
  10110f:	83 c8 20             	or     $0x20,%eax
  101112:	89 c1                	mov    %eax,%ecx
  101114:	a1 60 0e 11 00       	mov    0x110e60,%eax
  101119:	0f b7 15 64 0e 11 00 	movzwl 0x110e64,%edx
  101120:	0f b7 d2             	movzwl %dx,%edx
  101123:	01 d2                	add    %edx,%edx
  101125:	01 d0                	add    %edx,%eax
  101127:	89 ca                	mov    %ecx,%edx
  101129:	66 89 10             	mov    %dx,(%eax)
        }
        break;
  10112c:	eb 70                	jmp    10119e <cga_putc+0xe4>
    case '\n':
        crt_pos += CRT_COLS;
  10112e:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  101135:	83 c0 50             	add    $0x50,%eax
  101138:	66 a3 64 0e 11 00    	mov    %ax,0x110e64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  10113e:	0f b7 1d 64 0e 11 00 	movzwl 0x110e64,%ebx
  101145:	0f b7 0d 64 0e 11 00 	movzwl 0x110e64,%ecx
  10114c:	0f b7 c1             	movzwl %cx,%eax
  10114f:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  101155:	c1 e8 10             	shr    $0x10,%eax
  101158:	89 c2                	mov    %eax,%edx
  10115a:	66 c1 ea 06          	shr    $0x6,%dx
  10115e:	89 d0                	mov    %edx,%eax
  101160:	c1 e0 02             	shl    $0x2,%eax
  101163:	01 d0                	add    %edx,%eax
  101165:	c1 e0 04             	shl    $0x4,%eax
  101168:	29 c1                	sub    %eax,%ecx
  10116a:	89 ca                	mov    %ecx,%edx
  10116c:	89 d8                	mov    %ebx,%eax
  10116e:	29 d0                	sub    %edx,%eax
  101170:	66 a3 64 0e 11 00    	mov    %ax,0x110e64
        break;
  101176:	eb 27                	jmp    10119f <cga_putc+0xe5>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  101178:	8b 0d 60 0e 11 00    	mov    0x110e60,%ecx
  10117e:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  101185:	8d 50 01             	lea    0x1(%eax),%edx
  101188:	66 89 15 64 0e 11 00 	mov    %dx,0x110e64
  10118f:	0f b7 c0             	movzwl %ax,%eax
  101192:	01 c0                	add    %eax,%eax
  101194:	01 c8                	add    %ecx,%eax
  101196:	8b 55 08             	mov    0x8(%ebp),%edx
  101199:	66 89 10             	mov    %dx,(%eax)
        break;
  10119c:	eb 01                	jmp    10119f <cga_putc+0xe5>
        break;
  10119e:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  10119f:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  1011a6:	66 3d cf 07          	cmp    $0x7cf,%ax
  1011aa:	76 59                	jbe    101205 <cga_putc+0x14b>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  1011ac:	a1 60 0e 11 00       	mov    0x110e60,%eax
  1011b1:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1011b7:	a1 60 0e 11 00       	mov    0x110e60,%eax
  1011bc:	83 ec 04             	sub    $0x4,%esp
  1011bf:	68 00 0f 00 00       	push   $0xf00
  1011c4:	52                   	push   %edx
  1011c5:	50                   	push   %eax
  1011c6:	e8 5f 1f 00 00       	call   10312a <memmove>
  1011cb:	83 c4 10             	add    $0x10,%esp
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011ce:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  1011d5:	eb 15                	jmp    1011ec <cga_putc+0x132>
            crt_buf[i] = 0x0700 | ' ';
  1011d7:	a1 60 0e 11 00       	mov    0x110e60,%eax
  1011dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1011df:	01 d2                	add    %edx,%edx
  1011e1:	01 d0                	add    %edx,%eax
  1011e3:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011e8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1011ec:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1011f3:	7e e2                	jle    1011d7 <cga_putc+0x11d>
        }
        crt_pos -= CRT_COLS;
  1011f5:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  1011fc:	83 e8 50             	sub    $0x50,%eax
  1011ff:	66 a3 64 0e 11 00    	mov    %ax,0x110e64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  101205:	0f b7 05 66 0e 11 00 	movzwl 0x110e66,%eax
  10120c:	0f b7 c0             	movzwl %ax,%eax
  10120f:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  101213:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
  101217:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10121b:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10121f:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  101220:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  101227:	66 c1 e8 08          	shr    $0x8,%ax
  10122b:	0f b6 c0             	movzbl %al,%eax
  10122e:	0f b7 15 66 0e 11 00 	movzwl 0x110e66,%edx
  101235:	83 c2 01             	add    $0x1,%edx
  101238:	0f b7 d2             	movzwl %dx,%edx
  10123b:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  10123f:	88 45 e9             	mov    %al,-0x17(%ebp)
  101242:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101246:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10124a:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  10124b:	0f b7 05 66 0e 11 00 	movzwl 0x110e66,%eax
  101252:	0f b7 c0             	movzwl %ax,%eax
  101255:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  101259:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
  10125d:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101261:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101265:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  101266:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  10126d:	0f b6 c0             	movzbl %al,%eax
  101270:	0f b7 15 66 0e 11 00 	movzwl 0x110e66,%edx
  101277:	83 c2 01             	add    $0x1,%edx
  10127a:	0f b7 d2             	movzwl %dx,%edx
  10127d:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  101281:	88 45 f1             	mov    %al,-0xf(%ebp)
  101284:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101288:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10128c:	ee                   	out    %al,(%dx)
}
  10128d:	90                   	nop
  10128e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  101291:	c9                   	leave  
  101292:	c3                   	ret    

00101293 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101293:	55                   	push   %ebp
  101294:	89 e5                	mov    %esp,%ebp
  101296:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101299:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1012a0:	eb 09                	jmp    1012ab <serial_putc_sub+0x18>
        delay();
  1012a2:	e8 4d fb ff ff       	call   100df4 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012a7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1012ab:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1012b1:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1012b5:	89 c2                	mov    %eax,%edx
  1012b7:	ec                   	in     (%dx),%al
  1012b8:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1012bb:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1012bf:	0f b6 c0             	movzbl %al,%eax
  1012c2:	83 e0 20             	and    $0x20,%eax
  1012c5:	85 c0                	test   %eax,%eax
  1012c7:	75 09                	jne    1012d2 <serial_putc_sub+0x3f>
  1012c9:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1012d0:	7e d0                	jle    1012a2 <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
  1012d2:	8b 45 08             	mov    0x8(%ebp),%eax
  1012d5:	0f b6 c0             	movzbl %al,%eax
  1012d8:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  1012de:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012e1:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1012e5:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1012e9:	ee                   	out    %al,(%dx)
}
  1012ea:	90                   	nop
  1012eb:	c9                   	leave  
  1012ec:	c3                   	ret    

001012ed <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1012ed:	55                   	push   %ebp
  1012ee:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  1012f0:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1012f4:	74 0d                	je     101303 <serial_putc+0x16>
        serial_putc_sub(c);
  1012f6:	ff 75 08             	pushl  0x8(%ebp)
  1012f9:	e8 95 ff ff ff       	call   101293 <serial_putc_sub>
  1012fe:	83 c4 04             	add    $0x4,%esp
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  101301:	eb 1e                	jmp    101321 <serial_putc+0x34>
        serial_putc_sub('\b');
  101303:	6a 08                	push   $0x8
  101305:	e8 89 ff ff ff       	call   101293 <serial_putc_sub>
  10130a:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub(' ');
  10130d:	6a 20                	push   $0x20
  10130f:	e8 7f ff ff ff       	call   101293 <serial_putc_sub>
  101314:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub('\b');
  101317:	6a 08                	push   $0x8
  101319:	e8 75 ff ff ff       	call   101293 <serial_putc_sub>
  10131e:	83 c4 04             	add    $0x4,%esp
}
  101321:	90                   	nop
  101322:	c9                   	leave  
  101323:	c3                   	ret    

00101324 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  101324:	55                   	push   %ebp
  101325:	89 e5                	mov    %esp,%ebp
  101327:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  10132a:	eb 33                	jmp    10135f <cons_intr+0x3b>
        if (c != 0) {
  10132c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  101330:	74 2d                	je     10135f <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  101332:	a1 84 10 11 00       	mov    0x111084,%eax
  101337:	8d 50 01             	lea    0x1(%eax),%edx
  10133a:	89 15 84 10 11 00    	mov    %edx,0x111084
  101340:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101343:	88 90 80 0e 11 00    	mov    %dl,0x110e80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101349:	a1 84 10 11 00       	mov    0x111084,%eax
  10134e:	3d 00 02 00 00       	cmp    $0x200,%eax
  101353:	75 0a                	jne    10135f <cons_intr+0x3b>
                cons.wpos = 0;
  101355:	c7 05 84 10 11 00 00 	movl   $0x0,0x111084
  10135c:	00 00 00 
    while ((c = (*proc)()) != -1) {
  10135f:	8b 45 08             	mov    0x8(%ebp),%eax
  101362:	ff d0                	call   *%eax
  101364:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101367:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  10136b:	75 bf                	jne    10132c <cons_intr+0x8>
            }
        }
    }
}
  10136d:	90                   	nop
  10136e:	c9                   	leave  
  10136f:	c3                   	ret    

00101370 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  101370:	55                   	push   %ebp
  101371:	89 e5                	mov    %esp,%ebp
  101373:	83 ec 10             	sub    $0x10,%esp
  101376:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10137c:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101380:	89 c2                	mov    %eax,%edx
  101382:	ec                   	in     (%dx),%al
  101383:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101386:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  10138a:	0f b6 c0             	movzbl %al,%eax
  10138d:	83 e0 01             	and    $0x1,%eax
  101390:	85 c0                	test   %eax,%eax
  101392:	75 07                	jne    10139b <serial_proc_data+0x2b>
        return -1;
  101394:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101399:	eb 2a                	jmp    1013c5 <serial_proc_data+0x55>
  10139b:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013a1:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1013a5:	89 c2                	mov    %eax,%edx
  1013a7:	ec                   	in     (%dx),%al
  1013a8:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  1013ab:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1013af:	0f b6 c0             	movzbl %al,%eax
  1013b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1013b5:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  1013b9:	75 07                	jne    1013c2 <serial_proc_data+0x52>
        c = '\b';
  1013bb:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  1013c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1013c5:	c9                   	leave  
  1013c6:	c3                   	ret    

001013c7 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  1013c7:	55                   	push   %ebp
  1013c8:	89 e5                	mov    %esp,%ebp
  1013ca:	83 ec 08             	sub    $0x8,%esp
    if (serial_exists) {
  1013cd:	a1 68 0e 11 00       	mov    0x110e68,%eax
  1013d2:	85 c0                	test   %eax,%eax
  1013d4:	74 10                	je     1013e6 <serial_intr+0x1f>
        cons_intr(serial_proc_data);
  1013d6:	83 ec 0c             	sub    $0xc,%esp
  1013d9:	68 70 13 10 00       	push   $0x101370
  1013de:	e8 41 ff ff ff       	call   101324 <cons_intr>
  1013e3:	83 c4 10             	add    $0x10,%esp
    }
}
  1013e6:	90                   	nop
  1013e7:	c9                   	leave  
  1013e8:	c3                   	ret    

001013e9 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1013e9:	55                   	push   %ebp
  1013ea:	89 e5                	mov    %esp,%ebp
  1013ec:	83 ec 28             	sub    $0x28,%esp
  1013ef:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013f5:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1013f9:	89 c2                	mov    %eax,%edx
  1013fb:	ec                   	in     (%dx),%al
  1013fc:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  1013ff:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  101403:	0f b6 c0             	movzbl %al,%eax
  101406:	83 e0 01             	and    $0x1,%eax
  101409:	85 c0                	test   %eax,%eax
  10140b:	75 0a                	jne    101417 <kbd_proc_data+0x2e>
        return -1;
  10140d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101412:	e9 5d 01 00 00       	jmp    101574 <kbd_proc_data+0x18b>
  101417:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10141d:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101421:	89 c2                	mov    %eax,%edx
  101423:	ec                   	in     (%dx),%al
  101424:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  101427:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  10142b:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  10142e:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101432:	75 17                	jne    10144b <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  101434:	a1 88 10 11 00       	mov    0x111088,%eax
  101439:	83 c8 40             	or     $0x40,%eax
  10143c:	a3 88 10 11 00       	mov    %eax,0x111088
        return 0;
  101441:	b8 00 00 00 00       	mov    $0x0,%eax
  101446:	e9 29 01 00 00       	jmp    101574 <kbd_proc_data+0x18b>
    } else if (data & 0x80) {
  10144b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10144f:	84 c0                	test   %al,%al
  101451:	79 47                	jns    10149a <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101453:	a1 88 10 11 00       	mov    0x111088,%eax
  101458:	83 e0 40             	and    $0x40,%eax
  10145b:	85 c0                	test   %eax,%eax
  10145d:	75 09                	jne    101468 <kbd_proc_data+0x7f>
  10145f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101463:	83 e0 7f             	and    $0x7f,%eax
  101466:	eb 04                	jmp    10146c <kbd_proc_data+0x83>
  101468:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10146c:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  10146f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101473:	0f b6 80 40 00 11 00 	movzbl 0x110040(%eax),%eax
  10147a:	83 c8 40             	or     $0x40,%eax
  10147d:	0f b6 c0             	movzbl %al,%eax
  101480:	f7 d0                	not    %eax
  101482:	89 c2                	mov    %eax,%edx
  101484:	a1 88 10 11 00       	mov    0x111088,%eax
  101489:	21 d0                	and    %edx,%eax
  10148b:	a3 88 10 11 00       	mov    %eax,0x111088
        return 0;
  101490:	b8 00 00 00 00       	mov    $0x0,%eax
  101495:	e9 da 00 00 00       	jmp    101574 <kbd_proc_data+0x18b>
    } else if (shift & E0ESC) {
  10149a:	a1 88 10 11 00       	mov    0x111088,%eax
  10149f:	83 e0 40             	and    $0x40,%eax
  1014a2:	85 c0                	test   %eax,%eax
  1014a4:	74 11                	je     1014b7 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1014a6:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1014aa:	a1 88 10 11 00       	mov    0x111088,%eax
  1014af:	83 e0 bf             	and    $0xffffffbf,%eax
  1014b2:	a3 88 10 11 00       	mov    %eax,0x111088
    }

    shift |= shiftcode[data];
  1014b7:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014bb:	0f b6 80 40 00 11 00 	movzbl 0x110040(%eax),%eax
  1014c2:	0f b6 d0             	movzbl %al,%edx
  1014c5:	a1 88 10 11 00       	mov    0x111088,%eax
  1014ca:	09 d0                	or     %edx,%eax
  1014cc:	a3 88 10 11 00       	mov    %eax,0x111088
    shift ^= togglecode[data];
  1014d1:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014d5:	0f b6 80 40 01 11 00 	movzbl 0x110140(%eax),%eax
  1014dc:	0f b6 d0             	movzbl %al,%edx
  1014df:	a1 88 10 11 00       	mov    0x111088,%eax
  1014e4:	31 d0                	xor    %edx,%eax
  1014e6:	a3 88 10 11 00       	mov    %eax,0x111088

    c = charcode[shift & (CTL | SHIFT)][data];
  1014eb:	a1 88 10 11 00       	mov    0x111088,%eax
  1014f0:	83 e0 03             	and    $0x3,%eax
  1014f3:	8b 14 85 40 05 11 00 	mov    0x110540(,%eax,4),%edx
  1014fa:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014fe:	01 d0                	add    %edx,%eax
  101500:	0f b6 00             	movzbl (%eax),%eax
  101503:	0f b6 c0             	movzbl %al,%eax
  101506:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  101509:	a1 88 10 11 00       	mov    0x111088,%eax
  10150e:	83 e0 08             	and    $0x8,%eax
  101511:	85 c0                	test   %eax,%eax
  101513:	74 22                	je     101537 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  101515:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  101519:	7e 0c                	jle    101527 <kbd_proc_data+0x13e>
  10151b:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  10151f:	7f 06                	jg     101527 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  101521:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  101525:	eb 10                	jmp    101537 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  101527:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  10152b:	7e 0a                	jle    101537 <kbd_proc_data+0x14e>
  10152d:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101531:	7f 04                	jg     101537 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  101533:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  101537:	a1 88 10 11 00       	mov    0x111088,%eax
  10153c:	f7 d0                	not    %eax
  10153e:	83 e0 06             	and    $0x6,%eax
  101541:	85 c0                	test   %eax,%eax
  101543:	75 2c                	jne    101571 <kbd_proc_data+0x188>
  101545:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  10154c:	75 23                	jne    101571 <kbd_proc_data+0x188>
        cprintf("Rebooting!\n");
  10154e:	83 ec 0c             	sub    $0xc,%esp
  101551:	68 ad 3b 10 00       	push   $0x103bad
  101556:	e8 25 ed ff ff       	call   100280 <cprintf>
  10155b:	83 c4 10             	add    $0x10,%esp
  10155e:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101564:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101568:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  10156c:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  101570:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101571:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101574:	c9                   	leave  
  101575:	c3                   	ret    

00101576 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  101576:	55                   	push   %ebp
  101577:	89 e5                	mov    %esp,%ebp
  101579:	83 ec 08             	sub    $0x8,%esp
    cons_intr(kbd_proc_data);
  10157c:	83 ec 0c             	sub    $0xc,%esp
  10157f:	68 e9 13 10 00       	push   $0x1013e9
  101584:	e8 9b fd ff ff       	call   101324 <cons_intr>
  101589:	83 c4 10             	add    $0x10,%esp
}
  10158c:	90                   	nop
  10158d:	c9                   	leave  
  10158e:	c3                   	ret    

0010158f <kbd_init>:

static void
kbd_init(void) {
  10158f:	55                   	push   %ebp
  101590:	89 e5                	mov    %esp,%ebp
  101592:	83 ec 08             	sub    $0x8,%esp
    // drain the kbd buffer
    kbd_intr();
  101595:	e8 dc ff ff ff       	call   101576 <kbd_intr>
    pic_enable(IRQ_KBD);
  10159a:	83 ec 0c             	sub    $0xc,%esp
  10159d:	6a 01                	push   $0x1
  10159f:	e8 1c 01 00 00       	call   1016c0 <pic_enable>
  1015a4:	83 c4 10             	add    $0x10,%esp
}
  1015a7:	90                   	nop
  1015a8:	c9                   	leave  
  1015a9:	c3                   	ret    

001015aa <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1015aa:	55                   	push   %ebp
  1015ab:	89 e5                	mov    %esp,%ebp
  1015ad:	83 ec 08             	sub    $0x8,%esp
    cga_init();
  1015b0:	e8 88 f8 ff ff       	call   100e3d <cga_init>
    serial_init();
  1015b5:	e8 6a f9 ff ff       	call   100f24 <serial_init>
    kbd_init();
  1015ba:	e8 d0 ff ff ff       	call   10158f <kbd_init>
    if (!serial_exists) {
  1015bf:	a1 68 0e 11 00       	mov    0x110e68,%eax
  1015c4:	85 c0                	test   %eax,%eax
  1015c6:	75 10                	jne    1015d8 <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
  1015c8:	83 ec 0c             	sub    $0xc,%esp
  1015cb:	68 b9 3b 10 00       	push   $0x103bb9
  1015d0:	e8 ab ec ff ff       	call   100280 <cprintf>
  1015d5:	83 c4 10             	add    $0x10,%esp
    }
}
  1015d8:	90                   	nop
  1015d9:	c9                   	leave  
  1015da:	c3                   	ret    

001015db <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1015db:	55                   	push   %ebp
  1015dc:	89 e5                	mov    %esp,%ebp
  1015de:	83 ec 08             	sub    $0x8,%esp
    lpt_putc(c);
  1015e1:	ff 75 08             	pushl  0x8(%ebp)
  1015e4:	e8 9a fa ff ff       	call   101083 <lpt_putc>
  1015e9:	83 c4 04             	add    $0x4,%esp
    cga_putc(c);
  1015ec:	83 ec 0c             	sub    $0xc,%esp
  1015ef:	ff 75 08             	pushl  0x8(%ebp)
  1015f2:	e8 c3 fa ff ff       	call   1010ba <cga_putc>
  1015f7:	83 c4 10             	add    $0x10,%esp
    serial_putc(c);
  1015fa:	83 ec 0c             	sub    $0xc,%esp
  1015fd:	ff 75 08             	pushl  0x8(%ebp)
  101600:	e8 e8 fc ff ff       	call   1012ed <serial_putc>
  101605:	83 c4 10             	add    $0x10,%esp
}
  101608:	90                   	nop
  101609:	c9                   	leave  
  10160a:	c3                   	ret    

0010160b <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  10160b:	55                   	push   %ebp
  10160c:	89 e5                	mov    %esp,%ebp
  10160e:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  101611:	e8 b1 fd ff ff       	call   1013c7 <serial_intr>
    kbd_intr();
  101616:	e8 5b ff ff ff       	call   101576 <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  10161b:	8b 15 80 10 11 00    	mov    0x111080,%edx
  101621:	a1 84 10 11 00       	mov    0x111084,%eax
  101626:	39 c2                	cmp    %eax,%edx
  101628:	74 36                	je     101660 <cons_getc+0x55>
        c = cons.buf[cons.rpos ++];
  10162a:	a1 80 10 11 00       	mov    0x111080,%eax
  10162f:	8d 50 01             	lea    0x1(%eax),%edx
  101632:	89 15 80 10 11 00    	mov    %edx,0x111080
  101638:	0f b6 80 80 0e 11 00 	movzbl 0x110e80(%eax),%eax
  10163f:	0f b6 c0             	movzbl %al,%eax
  101642:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  101645:	a1 80 10 11 00       	mov    0x111080,%eax
  10164a:	3d 00 02 00 00       	cmp    $0x200,%eax
  10164f:	75 0a                	jne    10165b <cons_getc+0x50>
            cons.rpos = 0;
  101651:	c7 05 80 10 11 00 00 	movl   $0x0,0x111080
  101658:	00 00 00 
        }
        return c;
  10165b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10165e:	eb 05                	jmp    101665 <cons_getc+0x5a>
    }
    return 0;
  101660:	b8 00 00 00 00       	mov    $0x0,%eax
}
  101665:	c9                   	leave  
  101666:	c3                   	ret    

00101667 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101667:	55                   	push   %ebp
  101668:	89 e5                	mov    %esp,%ebp
  10166a:	83 ec 14             	sub    $0x14,%esp
  10166d:	8b 45 08             	mov    0x8(%ebp),%eax
  101670:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101674:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101678:	66 a3 50 05 11 00    	mov    %ax,0x110550
    if (did_init) {
  10167e:	a1 8c 10 11 00       	mov    0x11108c,%eax
  101683:	85 c0                	test   %eax,%eax
  101685:	74 36                	je     1016bd <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  101687:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10168b:	0f b6 c0             	movzbl %al,%eax
  10168e:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  101694:	88 45 f9             	mov    %al,-0x7(%ebp)
  101697:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10169b:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10169f:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  1016a0:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016a4:	66 c1 e8 08          	shr    $0x8,%ax
  1016a8:	0f b6 c0             	movzbl %al,%eax
  1016ab:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  1016b1:	88 45 fd             	mov    %al,-0x3(%ebp)
  1016b4:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016b8:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016bc:	ee                   	out    %al,(%dx)
    }
}
  1016bd:	90                   	nop
  1016be:	c9                   	leave  
  1016bf:	c3                   	ret    

001016c0 <pic_enable>:

void
pic_enable(unsigned int irq) {
  1016c0:	55                   	push   %ebp
  1016c1:	89 e5                	mov    %esp,%ebp
    pic_setmask(irq_mask & ~(1 << irq));
  1016c3:	8b 45 08             	mov    0x8(%ebp),%eax
  1016c6:	ba 01 00 00 00       	mov    $0x1,%edx
  1016cb:	89 c1                	mov    %eax,%ecx
  1016cd:	d3 e2                	shl    %cl,%edx
  1016cf:	89 d0                	mov    %edx,%eax
  1016d1:	f7 d0                	not    %eax
  1016d3:	89 c2                	mov    %eax,%edx
  1016d5:	0f b7 05 50 05 11 00 	movzwl 0x110550,%eax
  1016dc:	21 d0                	and    %edx,%eax
  1016de:	0f b7 c0             	movzwl %ax,%eax
  1016e1:	50                   	push   %eax
  1016e2:	e8 80 ff ff ff       	call   101667 <pic_setmask>
  1016e7:	83 c4 04             	add    $0x4,%esp
}
  1016ea:	90                   	nop
  1016eb:	c9                   	leave  
  1016ec:	c3                   	ret    

001016ed <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  1016ed:	55                   	push   %ebp
  1016ee:	89 e5                	mov    %esp,%ebp
  1016f0:	83 ec 40             	sub    $0x40,%esp
    did_init = 1;
  1016f3:	c7 05 8c 10 11 00 01 	movl   $0x1,0x11108c
  1016fa:	00 00 00 
  1016fd:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  101703:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
  101707:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  10170b:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  10170f:	ee                   	out    %al,(%dx)
  101710:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  101716:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
  10171a:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  10171e:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101722:	ee                   	out    %al,(%dx)
  101723:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  101729:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
  10172d:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  101731:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  101735:	ee                   	out    %al,(%dx)
  101736:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  10173c:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
  101740:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101744:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101748:	ee                   	out    %al,(%dx)
  101749:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  10174f:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
  101753:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101757:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  10175b:	ee                   	out    %al,(%dx)
  10175c:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  101762:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
  101766:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  10176a:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  10176e:	ee                   	out    %al,(%dx)
  10176f:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  101775:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
  101779:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  10177d:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101781:	ee                   	out    %al,(%dx)
  101782:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  101788:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
  10178c:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101790:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101794:	ee                   	out    %al,(%dx)
  101795:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  10179b:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
  10179f:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1017a3:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1017a7:	ee                   	out    %al,(%dx)
  1017a8:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  1017ae:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
  1017b2:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1017b6:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1017ba:	ee                   	out    %al,(%dx)
  1017bb:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  1017c1:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
  1017c5:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1017c9:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1017cd:	ee                   	out    %al,(%dx)
  1017ce:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  1017d4:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
  1017d8:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1017dc:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1017e0:	ee                   	out    %al,(%dx)
  1017e1:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  1017e7:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
  1017eb:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1017ef:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1017f3:	ee                   	out    %al,(%dx)
  1017f4:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  1017fa:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
  1017fe:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101802:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101806:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  101807:	0f b7 05 50 05 11 00 	movzwl 0x110550,%eax
  10180e:	66 83 f8 ff          	cmp    $0xffff,%ax
  101812:	74 13                	je     101827 <pic_init+0x13a>
        pic_setmask(irq_mask);
  101814:	0f b7 05 50 05 11 00 	movzwl 0x110550,%eax
  10181b:	0f b7 c0             	movzwl %ax,%eax
  10181e:	50                   	push   %eax
  10181f:	e8 43 fe ff ff       	call   101667 <pic_setmask>
  101824:	83 c4 04             	add    $0x4,%esp
    }
}
  101827:	90                   	nop
  101828:	c9                   	leave  
  101829:	c3                   	ret    

0010182a <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  10182a:	55                   	push   %ebp
  10182b:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  10182d:	fb                   	sti    
    sti();
}
  10182e:	90                   	nop
  10182f:	5d                   	pop    %ebp
  101830:	c3                   	ret    

00101831 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  101831:	55                   	push   %ebp
  101832:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli");
  101834:	fa                   	cli    
    cli();
}
  101835:	90                   	nop
  101836:	5d                   	pop    %ebp
  101837:	c3                   	ret    

00101838 <print_switch_to_user>:
#include <assert.h>
#include <console.h>
#include <kdebug.h>
#define TICK_NUM 100
void print_switch_to_user()
{
  101838:	55                   	push   %ebp
  101839:	89 e5                	mov    %esp,%ebp
  10183b:	83 ec 08             	sub    $0x8,%esp
	cprintf("switch to user");
  10183e:	83 ec 0c             	sub    $0xc,%esp
  101841:	68 e0 3b 10 00       	push   $0x103be0
  101846:	e8 35 ea ff ff       	call   100280 <cprintf>
  10184b:	83 c4 10             	add    $0x10,%esp
}
  10184e:	90                   	nop
  10184f:	c9                   	leave  
  101850:	c3                   	ret    

00101851 <print_switch_to_kernel>:

void print_switch_to_kernel()
{
  101851:	55                   	push   %ebp
  101852:	89 e5                	mov    %esp,%ebp
  101854:	83 ec 08             	sub    $0x8,%esp
	cprintf("switch to kernel\n");
  101857:	83 ec 0c             	sub    $0xc,%esp
  10185a:	68 ef 3b 10 00       	push   $0x103bef
  10185f:	e8 1c ea ff ff       	call   100280 <cprintf>
  101864:	83 c4 10             	add    $0x10,%esp
}
  101867:	90                   	nop
  101868:	c9                   	leave  
  101869:	c3                   	ret    

0010186a <print_ticks>:

static void print_ticks() {
  10186a:	55                   	push   %ebp
  10186b:	89 e5                	mov    %esp,%ebp
  10186d:	83 ec 08             	sub    $0x8,%esp
    cprintf("%d ticks\n",TICK_NUM);
  101870:	83 ec 08             	sub    $0x8,%esp
  101873:	6a 64                	push   $0x64
  101875:	68 01 3c 10 00       	push   $0x103c01
  10187a:	e8 01 ea ff ff       	call   100280 <cprintf>
  10187f:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
     cprintf("End of Test.\n");
     panic("EOT: kernel seems ok.");
 #endif
}
  101882:	90                   	nop
  101883:	c9                   	leave  
  101884:	c3                   	ret    

00101885 <idt_init>:

extern uint32_t __vectors[256];

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  101885:	55                   	push   %ebp
  101886:	89 e5                	mov    %esp,%ebp
  101888:	83 ec 10             	sub    $0x10,%esp
      *     Can you see idt[256] in this file? Yes, it's IDT! you can use SETGATE macro to setup each item of IDT
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	int intrno = 0;
  10188b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	/* ucore don't use task gate.*/
	for(; intrno < 256; intrno++) 
  101892:	e9 c3 00 00 00       	jmp    10195a <idt_init+0xd5>
		SETGATE(idt[intrno], 0, KERNEL_CS, __vectors[intrno], DPL_KERNEL);
  101897:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10189a:	8b 04 85 e0 05 11 00 	mov    0x1105e0(,%eax,4),%eax
  1018a1:	89 c2                	mov    %eax,%edx
  1018a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018a6:	66 89 14 c5 a0 10 11 	mov    %dx,0x1110a0(,%eax,8)
  1018ad:	00 
  1018ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018b1:	66 c7 04 c5 a2 10 11 	movw   $0x8,0x1110a2(,%eax,8)
  1018b8:	00 08 00 
  1018bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018be:	0f b6 14 c5 a4 10 11 	movzbl 0x1110a4(,%eax,8),%edx
  1018c5:	00 
  1018c6:	83 e2 e0             	and    $0xffffffe0,%edx
  1018c9:	88 14 c5 a4 10 11 00 	mov    %dl,0x1110a4(,%eax,8)
  1018d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018d3:	0f b6 14 c5 a4 10 11 	movzbl 0x1110a4(,%eax,8),%edx
  1018da:	00 
  1018db:	83 e2 1f             	and    $0x1f,%edx
  1018de:	88 14 c5 a4 10 11 00 	mov    %dl,0x1110a4(,%eax,8)
  1018e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018e8:	0f b6 14 c5 a5 10 11 	movzbl 0x1110a5(,%eax,8),%edx
  1018ef:	00 
  1018f0:	83 e2 f0             	and    $0xfffffff0,%edx
  1018f3:	83 ca 0e             	or     $0xe,%edx
  1018f6:	88 14 c5 a5 10 11 00 	mov    %dl,0x1110a5(,%eax,8)
  1018fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101900:	0f b6 14 c5 a5 10 11 	movzbl 0x1110a5(,%eax,8),%edx
  101907:	00 
  101908:	83 e2 ef             	and    $0xffffffef,%edx
  10190b:	88 14 c5 a5 10 11 00 	mov    %dl,0x1110a5(,%eax,8)
  101912:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101915:	0f b6 14 c5 a5 10 11 	movzbl 0x1110a5(,%eax,8),%edx
  10191c:	00 
  10191d:	83 e2 9f             	and    $0xffffff9f,%edx
  101920:	88 14 c5 a5 10 11 00 	mov    %dl,0x1110a5(,%eax,8)
  101927:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10192a:	0f b6 14 c5 a5 10 11 	movzbl 0x1110a5(,%eax,8),%edx
  101931:	00 
  101932:	83 ca 80             	or     $0xffffff80,%edx
  101935:	88 14 c5 a5 10 11 00 	mov    %dl,0x1110a5(,%eax,8)
  10193c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10193f:	8b 04 85 e0 05 11 00 	mov    0x1105e0(,%eax,4),%eax
  101946:	c1 e8 10             	shr    $0x10,%eax
  101949:	89 c2                	mov    %eax,%edx
  10194b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10194e:	66 89 14 c5 a6 10 11 	mov    %dx,0x1110a6(,%eax,8)
  101955:	00 
	for(; intrno < 256; intrno++) 
  101956:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10195a:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  101961:	0f 8e 30 ff ff ff    	jle    101897 <idt_init+0x12>

	SETGATE(idt[T_SYSCALL], 1, KERNEL_CS, __vectors[T_SYSCALL], DPL_USER);
  101967:	a1 e0 07 11 00       	mov    0x1107e0,%eax
  10196c:	66 a3 a0 14 11 00    	mov    %ax,0x1114a0
  101972:	66 c7 05 a2 14 11 00 	movw   $0x8,0x1114a2
  101979:	08 00 
  10197b:	0f b6 05 a4 14 11 00 	movzbl 0x1114a4,%eax
  101982:	83 e0 e0             	and    $0xffffffe0,%eax
  101985:	a2 a4 14 11 00       	mov    %al,0x1114a4
  10198a:	0f b6 05 a4 14 11 00 	movzbl 0x1114a4,%eax
  101991:	83 e0 1f             	and    $0x1f,%eax
  101994:	a2 a4 14 11 00       	mov    %al,0x1114a4
  101999:	0f b6 05 a5 14 11 00 	movzbl 0x1114a5,%eax
  1019a0:	83 c8 0f             	or     $0xf,%eax
  1019a3:	a2 a5 14 11 00       	mov    %al,0x1114a5
  1019a8:	0f b6 05 a5 14 11 00 	movzbl 0x1114a5,%eax
  1019af:	83 e0 ef             	and    $0xffffffef,%eax
  1019b2:	a2 a5 14 11 00       	mov    %al,0x1114a5
  1019b7:	0f b6 05 a5 14 11 00 	movzbl 0x1114a5,%eax
  1019be:	83 c8 60             	or     $0x60,%eax
  1019c1:	a2 a5 14 11 00       	mov    %al,0x1114a5
  1019c6:	0f b6 05 a5 14 11 00 	movzbl 0x1114a5,%eax
  1019cd:	83 c8 80             	or     $0xffffff80,%eax
  1019d0:	a2 a5 14 11 00       	mov    %al,0x1114a5
  1019d5:	a1 e0 07 11 00       	mov    0x1107e0,%eax
  1019da:	c1 e8 10             	shr    $0x10,%eax
  1019dd:	66 a3 a6 14 11 00    	mov    %ax,0x1114a6
	SETGATE(idt[T_SWITCH_TOK], 0, KERNEL_CS, __vectors[T_SWITCH_TOK], DPL_USER);
  1019e3:	a1 c4 07 11 00       	mov    0x1107c4,%eax
  1019e8:	66 a3 68 14 11 00    	mov    %ax,0x111468
  1019ee:	66 c7 05 6a 14 11 00 	movw   $0x8,0x11146a
  1019f5:	08 00 
  1019f7:	0f b6 05 6c 14 11 00 	movzbl 0x11146c,%eax
  1019fe:	83 e0 e0             	and    $0xffffffe0,%eax
  101a01:	a2 6c 14 11 00       	mov    %al,0x11146c
  101a06:	0f b6 05 6c 14 11 00 	movzbl 0x11146c,%eax
  101a0d:	83 e0 1f             	and    $0x1f,%eax
  101a10:	a2 6c 14 11 00       	mov    %al,0x11146c
  101a15:	0f b6 05 6d 14 11 00 	movzbl 0x11146d,%eax
  101a1c:	83 e0 f0             	and    $0xfffffff0,%eax
  101a1f:	83 c8 0e             	or     $0xe,%eax
  101a22:	a2 6d 14 11 00       	mov    %al,0x11146d
  101a27:	0f b6 05 6d 14 11 00 	movzbl 0x11146d,%eax
  101a2e:	83 e0 ef             	and    $0xffffffef,%eax
  101a31:	a2 6d 14 11 00       	mov    %al,0x11146d
  101a36:	0f b6 05 6d 14 11 00 	movzbl 0x11146d,%eax
  101a3d:	83 c8 60             	or     $0x60,%eax
  101a40:	a2 6d 14 11 00       	mov    %al,0x11146d
  101a45:	0f b6 05 6d 14 11 00 	movzbl 0x11146d,%eax
  101a4c:	83 c8 80             	or     $0xffffff80,%eax
  101a4f:	a2 6d 14 11 00       	mov    %al,0x11146d
  101a54:	a1 c4 07 11 00       	mov    0x1107c4,%eax
  101a59:	c1 e8 10             	shr    $0x10,%eax
  101a5c:	66 a3 6e 14 11 00    	mov    %ax,0x11146e
	SETGATE(idt[T_SWITCH_TOU], 0, KERNEL_CS, __vectors[T_SWITCH_TOU], DPL_KERNEL);
  101a62:	a1 c0 07 11 00       	mov    0x1107c0,%eax
  101a67:	66 a3 60 14 11 00    	mov    %ax,0x111460
  101a6d:	66 c7 05 62 14 11 00 	movw   $0x8,0x111462
  101a74:	08 00 
  101a76:	0f b6 05 64 14 11 00 	movzbl 0x111464,%eax
  101a7d:	83 e0 e0             	and    $0xffffffe0,%eax
  101a80:	a2 64 14 11 00       	mov    %al,0x111464
  101a85:	0f b6 05 64 14 11 00 	movzbl 0x111464,%eax
  101a8c:	83 e0 1f             	and    $0x1f,%eax
  101a8f:	a2 64 14 11 00       	mov    %al,0x111464
  101a94:	0f b6 05 65 14 11 00 	movzbl 0x111465,%eax
  101a9b:	83 e0 f0             	and    $0xfffffff0,%eax
  101a9e:	83 c8 0e             	or     $0xe,%eax
  101aa1:	a2 65 14 11 00       	mov    %al,0x111465
  101aa6:	0f b6 05 65 14 11 00 	movzbl 0x111465,%eax
  101aad:	83 e0 ef             	and    $0xffffffef,%eax
  101ab0:	a2 65 14 11 00       	mov    %al,0x111465
  101ab5:	0f b6 05 65 14 11 00 	movzbl 0x111465,%eax
  101abc:	83 e0 9f             	and    $0xffffff9f,%eax
  101abf:	a2 65 14 11 00       	mov    %al,0x111465
  101ac4:	0f b6 05 65 14 11 00 	movzbl 0x111465,%eax
  101acb:	83 c8 80             	or     $0xffffff80,%eax
  101ace:	a2 65 14 11 00       	mov    %al,0x111465
  101ad3:	a1 c0 07 11 00       	mov    0x1107c0,%eax
  101ad8:	c1 e8 10             	shr    $0x10,%eax
  101adb:	66 a3 66 14 11 00    	mov    %ax,0x111466
  101ae1:	c7 45 f8 60 05 11 00 	movl   $0x110560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd));
  101ae8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101aeb:	0f 01 18             	lidtl  (%eax)

	lidt(&idt_pd);

}
  101aee:	90                   	nop
  101aef:	c9                   	leave  
  101af0:	c3                   	ret    

00101af1 <trapname>:

static const char *
trapname(int trapno) {
  101af1:	55                   	push   %ebp
  101af2:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101af4:	8b 45 08             	mov    0x8(%ebp),%eax
  101af7:	83 f8 13             	cmp    $0x13,%eax
  101afa:	77 0c                	ja     101b08 <trapname+0x17>
        return excnames[trapno];
  101afc:	8b 45 08             	mov    0x8(%ebp),%eax
  101aff:	8b 04 85 60 3f 10 00 	mov    0x103f60(,%eax,4),%eax
  101b06:	eb 18                	jmp    101b20 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101b08:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101b0c:	7e 0d                	jle    101b1b <trapname+0x2a>
  101b0e:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101b12:	7f 07                	jg     101b1b <trapname+0x2a>
        return "Hardware Interrupt";
  101b14:	b8 0b 3c 10 00       	mov    $0x103c0b,%eax
  101b19:	eb 05                	jmp    101b20 <trapname+0x2f>
    }
    return "(unknown trap)";
  101b1b:	b8 1e 3c 10 00       	mov    $0x103c1e,%eax
}
  101b20:	5d                   	pop    %ebp
  101b21:	c3                   	ret    

00101b22 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101b22:	55                   	push   %ebp
  101b23:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101b25:	8b 45 08             	mov    0x8(%ebp),%eax
  101b28:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b2c:	66 83 f8 08          	cmp    $0x8,%ax
  101b30:	0f 94 c0             	sete   %al
  101b33:	0f b6 c0             	movzbl %al,%eax
}
  101b36:	5d                   	pop    %ebp
  101b37:	c3                   	ret    

00101b38 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101b38:	55                   	push   %ebp
  101b39:	89 e5                	mov    %esp,%ebp
  101b3b:	83 ec 18             	sub    $0x18,%esp
    cprintf("trapframe at %p\n", tf);
  101b3e:	83 ec 08             	sub    $0x8,%esp
  101b41:	ff 75 08             	pushl  0x8(%ebp)
  101b44:	68 5f 3c 10 00       	push   $0x103c5f
  101b49:	e8 32 e7 ff ff       	call   100280 <cprintf>
  101b4e:	83 c4 10             	add    $0x10,%esp
    print_regs(&tf->tf_regs);
  101b51:	8b 45 08             	mov    0x8(%ebp),%eax
  101b54:	83 ec 0c             	sub    $0xc,%esp
  101b57:	50                   	push   %eax
  101b58:	e8 b6 01 00 00       	call   101d13 <print_regs>
  101b5d:	83 c4 10             	add    $0x10,%esp
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101b60:	8b 45 08             	mov    0x8(%ebp),%eax
  101b63:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101b67:	0f b7 c0             	movzwl %ax,%eax
  101b6a:	83 ec 08             	sub    $0x8,%esp
  101b6d:	50                   	push   %eax
  101b6e:	68 70 3c 10 00       	push   $0x103c70
  101b73:	e8 08 e7 ff ff       	call   100280 <cprintf>
  101b78:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  101b7e:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101b82:	0f b7 c0             	movzwl %ax,%eax
  101b85:	83 ec 08             	sub    $0x8,%esp
  101b88:	50                   	push   %eax
  101b89:	68 83 3c 10 00       	push   $0x103c83
  101b8e:	e8 ed e6 ff ff       	call   100280 <cprintf>
  101b93:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101b96:	8b 45 08             	mov    0x8(%ebp),%eax
  101b99:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101b9d:	0f b7 c0             	movzwl %ax,%eax
  101ba0:	83 ec 08             	sub    $0x8,%esp
  101ba3:	50                   	push   %eax
  101ba4:	68 96 3c 10 00       	push   $0x103c96
  101ba9:	e8 d2 e6 ff ff       	call   100280 <cprintf>
  101bae:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  101bb4:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101bb8:	0f b7 c0             	movzwl %ax,%eax
  101bbb:	83 ec 08             	sub    $0x8,%esp
  101bbe:	50                   	push   %eax
  101bbf:	68 a9 3c 10 00       	push   $0x103ca9
  101bc4:	e8 b7 e6 ff ff       	call   100280 <cprintf>
  101bc9:	83 c4 10             	add    $0x10,%esp
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  101bcf:	8b 40 30             	mov    0x30(%eax),%eax
  101bd2:	83 ec 0c             	sub    $0xc,%esp
  101bd5:	50                   	push   %eax
  101bd6:	e8 16 ff ff ff       	call   101af1 <trapname>
  101bdb:	83 c4 10             	add    $0x10,%esp
  101bde:	89 c2                	mov    %eax,%edx
  101be0:	8b 45 08             	mov    0x8(%ebp),%eax
  101be3:	8b 40 30             	mov    0x30(%eax),%eax
  101be6:	83 ec 04             	sub    $0x4,%esp
  101be9:	52                   	push   %edx
  101bea:	50                   	push   %eax
  101beb:	68 bc 3c 10 00       	push   $0x103cbc
  101bf0:	e8 8b e6 ff ff       	call   100280 <cprintf>
  101bf5:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
  101bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  101bfb:	8b 40 34             	mov    0x34(%eax),%eax
  101bfe:	83 ec 08             	sub    $0x8,%esp
  101c01:	50                   	push   %eax
  101c02:	68 ce 3c 10 00       	push   $0x103cce
  101c07:	e8 74 e6 ff ff       	call   100280 <cprintf>
  101c0c:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  101c12:	8b 40 38             	mov    0x38(%eax),%eax
  101c15:	83 ec 08             	sub    $0x8,%esp
  101c18:	50                   	push   %eax
  101c19:	68 dd 3c 10 00       	push   $0x103cdd
  101c1e:	e8 5d e6 ff ff       	call   100280 <cprintf>
  101c23:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101c26:	8b 45 08             	mov    0x8(%ebp),%eax
  101c29:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101c2d:	0f b7 c0             	movzwl %ax,%eax
  101c30:	83 ec 08             	sub    $0x8,%esp
  101c33:	50                   	push   %eax
  101c34:	68 ec 3c 10 00       	push   $0x103cec
  101c39:	e8 42 e6 ff ff       	call   100280 <cprintf>
  101c3e:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101c41:	8b 45 08             	mov    0x8(%ebp),%eax
  101c44:	8b 40 40             	mov    0x40(%eax),%eax
  101c47:	83 ec 08             	sub    $0x8,%esp
  101c4a:	50                   	push   %eax
  101c4b:	68 ff 3c 10 00       	push   $0x103cff
  101c50:	e8 2b e6 ff ff       	call   100280 <cprintf>
  101c55:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101c58:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101c5f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101c66:	eb 3f                	jmp    101ca7 <print_trapframe+0x16f>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101c68:	8b 45 08             	mov    0x8(%ebp),%eax
  101c6b:	8b 50 40             	mov    0x40(%eax),%edx
  101c6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101c71:	21 d0                	and    %edx,%eax
  101c73:	85 c0                	test   %eax,%eax
  101c75:	74 29                	je     101ca0 <print_trapframe+0x168>
  101c77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c7a:	8b 04 85 80 05 11 00 	mov    0x110580(,%eax,4),%eax
  101c81:	85 c0                	test   %eax,%eax
  101c83:	74 1b                	je     101ca0 <print_trapframe+0x168>
            cprintf("%s,", IA32flags[i]);
  101c85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c88:	8b 04 85 80 05 11 00 	mov    0x110580(,%eax,4),%eax
  101c8f:	83 ec 08             	sub    $0x8,%esp
  101c92:	50                   	push   %eax
  101c93:	68 0e 3d 10 00       	push   $0x103d0e
  101c98:	e8 e3 e5 ff ff       	call   100280 <cprintf>
  101c9d:	83 c4 10             	add    $0x10,%esp
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101ca0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101ca4:	d1 65 f0             	shll   -0x10(%ebp)
  101ca7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101caa:	83 f8 17             	cmp    $0x17,%eax
  101cad:	76 b9                	jbe    101c68 <print_trapframe+0x130>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101caf:	8b 45 08             	mov    0x8(%ebp),%eax
  101cb2:	8b 40 40             	mov    0x40(%eax),%eax
  101cb5:	c1 e8 0c             	shr    $0xc,%eax
  101cb8:	83 e0 03             	and    $0x3,%eax
  101cbb:	83 ec 08             	sub    $0x8,%esp
  101cbe:	50                   	push   %eax
  101cbf:	68 12 3d 10 00       	push   $0x103d12
  101cc4:	e8 b7 e5 ff ff       	call   100280 <cprintf>
  101cc9:	83 c4 10             	add    $0x10,%esp

    if (!trap_in_kernel(tf)) {
  101ccc:	83 ec 0c             	sub    $0xc,%esp
  101ccf:	ff 75 08             	pushl  0x8(%ebp)
  101cd2:	e8 4b fe ff ff       	call   101b22 <trap_in_kernel>
  101cd7:	83 c4 10             	add    $0x10,%esp
  101cda:	85 c0                	test   %eax,%eax
  101cdc:	75 32                	jne    101d10 <print_trapframe+0x1d8>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101cde:	8b 45 08             	mov    0x8(%ebp),%eax
  101ce1:	8b 40 44             	mov    0x44(%eax),%eax
  101ce4:	83 ec 08             	sub    $0x8,%esp
  101ce7:	50                   	push   %eax
  101ce8:	68 1b 3d 10 00       	push   $0x103d1b
  101ced:	e8 8e e5 ff ff       	call   100280 <cprintf>
  101cf2:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  101cf8:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101cfc:	0f b7 c0             	movzwl %ax,%eax
  101cff:	83 ec 08             	sub    $0x8,%esp
  101d02:	50                   	push   %eax
  101d03:	68 2a 3d 10 00       	push   $0x103d2a
  101d08:	e8 73 e5 ff ff       	call   100280 <cprintf>
  101d0d:	83 c4 10             	add    $0x10,%esp
    }
}
  101d10:	90                   	nop
  101d11:	c9                   	leave  
  101d12:	c3                   	ret    

00101d13 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101d13:	55                   	push   %ebp
  101d14:	89 e5                	mov    %esp,%ebp
  101d16:	83 ec 08             	sub    $0x8,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101d19:	8b 45 08             	mov    0x8(%ebp),%eax
  101d1c:	8b 00                	mov    (%eax),%eax
  101d1e:	83 ec 08             	sub    $0x8,%esp
  101d21:	50                   	push   %eax
  101d22:	68 3d 3d 10 00       	push   $0x103d3d
  101d27:	e8 54 e5 ff ff       	call   100280 <cprintf>
  101d2c:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  101d32:	8b 40 04             	mov    0x4(%eax),%eax
  101d35:	83 ec 08             	sub    $0x8,%esp
  101d38:	50                   	push   %eax
  101d39:	68 4c 3d 10 00       	push   $0x103d4c
  101d3e:	e8 3d e5 ff ff       	call   100280 <cprintf>
  101d43:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101d46:	8b 45 08             	mov    0x8(%ebp),%eax
  101d49:	8b 40 08             	mov    0x8(%eax),%eax
  101d4c:	83 ec 08             	sub    $0x8,%esp
  101d4f:	50                   	push   %eax
  101d50:	68 5b 3d 10 00       	push   $0x103d5b
  101d55:	e8 26 e5 ff ff       	call   100280 <cprintf>
  101d5a:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  101d60:	8b 40 0c             	mov    0xc(%eax),%eax
  101d63:	83 ec 08             	sub    $0x8,%esp
  101d66:	50                   	push   %eax
  101d67:	68 6a 3d 10 00       	push   $0x103d6a
  101d6c:	e8 0f e5 ff ff       	call   100280 <cprintf>
  101d71:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101d74:	8b 45 08             	mov    0x8(%ebp),%eax
  101d77:	8b 40 10             	mov    0x10(%eax),%eax
  101d7a:	83 ec 08             	sub    $0x8,%esp
  101d7d:	50                   	push   %eax
  101d7e:	68 79 3d 10 00       	push   $0x103d79
  101d83:	e8 f8 e4 ff ff       	call   100280 <cprintf>
  101d88:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  101d8e:	8b 40 14             	mov    0x14(%eax),%eax
  101d91:	83 ec 08             	sub    $0x8,%esp
  101d94:	50                   	push   %eax
  101d95:	68 88 3d 10 00       	push   $0x103d88
  101d9a:	e8 e1 e4 ff ff       	call   100280 <cprintf>
  101d9f:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101da2:	8b 45 08             	mov    0x8(%ebp),%eax
  101da5:	8b 40 18             	mov    0x18(%eax),%eax
  101da8:	83 ec 08             	sub    $0x8,%esp
  101dab:	50                   	push   %eax
  101dac:	68 97 3d 10 00       	push   $0x103d97
  101db1:	e8 ca e4 ff ff       	call   100280 <cprintf>
  101db6:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101db9:	8b 45 08             	mov    0x8(%ebp),%eax
  101dbc:	8b 40 1c             	mov    0x1c(%eax),%eax
  101dbf:	83 ec 08             	sub    $0x8,%esp
  101dc2:	50                   	push   %eax
  101dc3:	68 a6 3d 10 00       	push   $0x103da6
  101dc8:	e8 b3 e4 ff ff       	call   100280 <cprintf>
  101dcd:	83 c4 10             	add    $0x10,%esp
}
  101dd0:	90                   	nop
  101dd1:	c9                   	leave  
  101dd2:	c3                   	ret    

00101dd3 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101dd3:	55                   	push   %ebp
  101dd4:	89 e5                	mov    %esp,%ebp
  101dd6:	57                   	push   %edi
  101dd7:	56                   	push   %esi
  101dd8:	53                   	push   %ebx
  101dd9:	83 ec 1c             	sub    $0x1c,%esp
    char c;
	static struct trapframe *correct_tf;
	correct_tf = (struct trapframe *) ((uint32_t)(tf) - 8);
  101ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  101ddf:	83 e8 08             	sub    $0x8,%eax
  101de2:	a3 a0 18 11 00       	mov    %eax,0x1118a0

    switch (tf->tf_trapno) {
  101de7:	8b 45 08             	mov    0x8(%ebp),%eax
  101dea:	8b 40 30             	mov    0x30(%eax),%eax
  101ded:	83 f8 24             	cmp    $0x24,%eax
  101df0:	0f 84 87 00 00 00    	je     101e7d <trap_dispatch+0xaa>
  101df6:	83 f8 24             	cmp    $0x24,%eax
  101df9:	77 1c                	ja     101e17 <trap_dispatch+0x44>
  101dfb:	83 f8 20             	cmp    $0x20,%eax
  101dfe:	74 44                	je     101e44 <trap_dispatch+0x71>
  101e00:	83 f8 21             	cmp    $0x21,%eax
  101e03:	0f 84 9b 00 00 00    	je     101ea4 <trap_dispatch+0xd1>
  101e09:	83 f8 0d             	cmp    $0xd,%eax
  101e0c:	0f 84 53 03 00 00    	je     102165 <loop+0x16d>
  101e12:	e9 6e 03 00 00       	jmp    102185 <loop+0x18d>
  101e17:	83 f8 78             	cmp    $0x78,%eax
  101e1a:	0f 84 4f 02 00 00    	je     10206f <loop+0x77>
  101e20:	83 f8 78             	cmp    $0x78,%eax
  101e23:	77 11                	ja     101e36 <trap_dispatch+0x63>
  101e25:	83 e8 2e             	sub    $0x2e,%eax
  101e28:	83 f8 01             	cmp    $0x1,%eax
  101e2b:	0f 87 54 03 00 00    	ja     102185 <loop+0x18d>
		}
			break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101e31:	e9 8c 03 00 00       	jmp    1021c2 <loop+0x1ca>
    switch (tf->tf_trapno) {
  101e36:	83 f8 79             	cmp    $0x79,%eax
  101e39:	0f 84 b4 02 00 00    	je     1020f3 <loop+0xfb>
  101e3f:	e9 41 03 00 00       	jmp    102185 <loop+0x18d>
		ticks = (ticks + 1) % 100;
  101e44:	a1 28 19 11 00       	mov    0x111928,%eax
  101e49:	8d 48 01             	lea    0x1(%eax),%ecx
  101e4c:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101e51:	89 c8                	mov    %ecx,%eax
  101e53:	f7 e2                	mul    %edx
  101e55:	89 d0                	mov    %edx,%eax
  101e57:	c1 e8 05             	shr    $0x5,%eax
  101e5a:	6b c0 64             	imul   $0x64,%eax,%eax
  101e5d:	29 c1                	sub    %eax,%ecx
  101e5f:	89 c8                	mov    %ecx,%eax
  101e61:	a3 28 19 11 00       	mov    %eax,0x111928
		if (ticks == 0)
  101e66:	a1 28 19 11 00       	mov    0x111928,%eax
  101e6b:	85 c0                	test   %eax,%eax
  101e6d:	0f 85 48 03 00 00    	jne    1021bb <loop+0x1c3>
			print_ticks();
  101e73:	e8 f2 f9 ff ff       	call   10186a <print_ticks>
        break;
  101e78:	e9 3e 03 00 00       	jmp    1021bb <loop+0x1c3>
        c = cons_getc();
  101e7d:	e8 89 f7 ff ff       	call   10160b <cons_getc>
  101e82:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101e85:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101e89:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101e8d:	83 ec 04             	sub    $0x4,%esp
  101e90:	52                   	push   %edx
  101e91:	50                   	push   %eax
  101e92:	68 b5 3d 10 00       	push   $0x103db5
  101e97:	e8 e4 e3 ff ff       	call   100280 <cprintf>
  101e9c:	83 c4 10             	add    $0x10,%esp
        break;
  101e9f:	e9 1e 03 00 00       	jmp    1021c2 <loop+0x1ca>
        c = cons_getc();
  101ea4:	e8 62 f7 ff ff       	call   10160b <cons_getc>
  101ea9:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101eac:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101eb0:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101eb4:	83 ec 04             	sub    $0x4,%esp
  101eb7:	52                   	push   %edx
  101eb8:	50                   	push   %eax
  101eb9:	68 c7 3d 10 00       	push   $0x103dc7
  101ebe:	e8 bd e3 ff ff       	call   100280 <cprintf>
  101ec3:	83 c4 10             	add    $0x10,%esp
		switch (c) {
  101ec6:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101eca:	83 f8 30             	cmp    $0x30,%eax
  101ecd:	74 0e                	je     101edd <trap_dispatch+0x10a>
  101ecf:	83 f8 33             	cmp    $0x33,%eax
  101ed2:	0f 84 e3 00 00 00    	je     101fbb <trap_dispatch+0x1e8>
        break;
  101ed8:	e9 e5 02 00 00       	jmp    1021c2 <loop+0x1ca>
				if (!trap_in_kernel(tf)) {
  101edd:	83 ec 0c             	sub    $0xc,%esp
  101ee0:	ff 75 08             	pushl  0x8(%ebp)
  101ee3:	e8 3a fc ff ff       	call   101b22 <trap_in_kernel>
  101ee8:	83 c4 10             	add    $0x10,%esp
  101eeb:	85 c0                	test   %eax,%eax
  101eed:	0f 85 70 01 00 00    	jne    102063 <loop+0x6b>
					tf->tf_cs = KERNEL_CS;
  101ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  101ef6:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
					tf->tf_ds = tf->tf_es = tf->tf_gs = tf->tf_fs = KERNEL_DS;
  101efc:	8b 45 08             	mov    0x8(%ebp),%eax
  101eff:	66 c7 40 24 10 00    	movw   $0x10,0x24(%eax)
  101f05:	8b 45 08             	mov    0x8(%ebp),%eax
  101f08:	0f b7 50 24          	movzwl 0x24(%eax),%edx
  101f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  101f0f:	66 89 50 20          	mov    %dx,0x20(%eax)
  101f13:	8b 45 08             	mov    0x8(%ebp),%eax
  101f16:	0f b7 50 20          	movzwl 0x20(%eax),%edx
  101f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  101f1d:	66 89 50 28          	mov    %dx,0x28(%eax)
  101f21:	8b 45 08             	mov    0x8(%ebp),%eax
  101f24:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101f28:	8b 45 08             	mov    0x8(%ebp),%eax
  101f2b:	66 89 50 2c          	mov    %dx,0x2c(%eax)
					tf->tf_eflags &= ~FL_IOPL_MASK;
  101f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  101f32:	8b 40 40             	mov    0x40(%eax),%eax
  101f35:	80 e4 cf             	and    $0xcf,%ah
  101f38:	89 c2                	mov    %eax,%edx
  101f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  101f3d:	89 50 40             	mov    %edx,0x40(%eax)
					uintptr_t user_stack_ptr = (uintptr_t)tf->tf_esp;
  101f40:	8b 45 08             	mov    0x8(%ebp),%eax
  101f43:	8b 40 44             	mov    0x44(%eax),%eax
  101f46:	89 45 e0             	mov    %eax,-0x20(%ebp)
					tf->tf_esp = *((uint32_t *) user_stack_ptr);
  101f49:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101f4c:	8b 10                	mov    (%eax),%edx
  101f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  101f51:	89 50 44             	mov    %edx,0x44(%eax)
					tf->tf_ss = *((uint16_t *) (user_stack_ptr + 4));
  101f54:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101f57:	83 c0 04             	add    $0x4,%eax
  101f5a:	0f b7 10             	movzwl (%eax),%edx
  101f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  101f60:	66 89 50 48          	mov    %dx,0x48(%eax)
					tf->tf_padding0 = *((uint16_t *) (user_stack_ptr + 6));
  101f64:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101f67:	83 c0 06             	add    $0x6,%eax
  101f6a:	0f b7 10             	movzwl (%eax),%edx
  101f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  101f70:	66 89 50 22          	mov    %dx,0x22(%eax)
					user_stack_ptr -= (uintptr_t) (sizeof(struct trapframe) - 8);
  101f74:	83 6d e0 44          	subl   $0x44,-0x20(%ebp)
					*((struct trapframe *) user_stack_ptr) = *tf;
  101f78:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101f7b:	8b 55 08             	mov    0x8(%ebp),%edx
  101f7e:	89 d3                	mov    %edx,%ebx
  101f80:	ba 4c 00 00 00       	mov    $0x4c,%edx
  101f85:	8b 0b                	mov    (%ebx),%ecx
  101f87:	89 08                	mov    %ecx,(%eax)
  101f89:	8b 4c 13 fc          	mov    -0x4(%ebx,%edx,1),%ecx
  101f8d:	89 4c 10 fc          	mov    %ecx,-0x4(%eax,%edx,1)
  101f91:	8d 78 04             	lea    0x4(%eax),%edi
  101f94:	83 e7 fc             	and    $0xfffffffc,%edi
  101f97:	29 f8                	sub    %edi,%eax
  101f99:	29 c3                	sub    %eax,%ebx
  101f9b:	01 c2                	add    %eax,%edx
  101f9d:	83 e2 fc             	and    $0xfffffffc,%edx
  101fa0:	89 d0                	mov    %edx,%eax
  101fa2:	c1 e8 02             	shr    $0x2,%eax
  101fa5:	89 de                	mov    %ebx,%esi
  101fa7:	89 c1                	mov    %eax,%ecx
  101fa9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
						:"a" ((uint32_t) tf),
  101fab:	8b 45 08             	mov    0x8(%ebp),%eax
					__asm__ __volatile__ (
  101fae:	8b 55 e0             	mov    -0x20(%ebp),%edx
  101fb1:	89 d3                	mov    %edx,%ebx
  101fb3:	89 58 fc             	mov    %ebx,-0x4(%eax)
				break;
  101fb6:	e9 a8 00 00 00       	jmp    102063 <loop+0x6b>
				if (trap_in_kernel(tf)) {
  101fbb:	83 ec 0c             	sub    $0xc,%esp
  101fbe:	ff 75 08             	pushl  0x8(%ebp)
  101fc1:	e8 5c fb ff ff       	call   101b22 <trap_in_kernel>
  101fc6:	83 c4 10             	add    $0x10,%esp
  101fc9:	85 c0                	test   %eax,%eax
  101fcb:	0f 84 98 00 00 00    	je     102069 <loop+0x71>
						:"a" ((uint32_t)(&tf->tf_esp)),
  101fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  101fd4:	83 c0 44             	add    $0x44,%eax
						 "d" ((uint32_t)(tf)),
  101fd7:	8b 55 08             	mov    0x8(%ebp),%edx
					__asm__ __volatile__ (
  101fda:	56                   	push   %esi
  101fdb:	57                   	push   %edi
  101fdc:	53                   	push   %ebx
  101fdd:	83 6a fc 08          	subl   $0x8,-0x4(%edx)
  101fe1:	89 e6                	mov    %esp,%esi
  101fe3:	89 c1                	mov    %eax,%ecx
  101fe5:	29 f1                	sub    %esi,%ecx
  101fe7:	41                   	inc    %ecx
  101fe8:	89 e7                	mov    %esp,%edi
  101fea:	83 ef 08             	sub    $0x8,%edi
  101fed:	fc                   	cld    
  101fee:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  101ff0:	83 ec 08             	sub    $0x8,%esp
  101ff3:	83 ed 08             	sub    $0x8,%ebp
  101ff6:	89 eb                	mov    %ebp,%ebx

00101ff8 <loop>:
  101ff8:	83 2b 08             	subl   $0x8,(%ebx)
  101ffb:	8b 1b                	mov    (%ebx),%ebx
  101ffd:	39 d8                	cmp    %ebx,%eax
  101fff:	7f f7                	jg     101ff8 <loop>
  102001:	89 40 f8             	mov    %eax,-0x8(%eax)
  102004:	c7 40 fc 23 00 00 00 	movl   $0x23,-0x4(%eax)
  10200b:	5b                   	pop    %ebx
  10200c:	5f                   	pop    %edi
  10200d:	5e                   	pop    %esi
					correct_tf->tf_cs = USER_CS;
  10200e:	a1 a0 18 11 00       	mov    0x1118a0,%eax
  102013:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
					correct_tf->tf_ds = tf->tf_es = tf->tf_gs = tf->tf_fs = USER_DS;
  102019:	8b 45 08             	mov    0x8(%ebp),%eax
  10201c:	66 c7 40 24 23 00    	movw   $0x23,0x24(%eax)
  102022:	8b 45 08             	mov    0x8(%ebp),%eax
  102025:	0f b7 50 24          	movzwl 0x24(%eax),%edx
  102029:	8b 45 08             	mov    0x8(%ebp),%eax
  10202c:	66 89 50 20          	mov    %dx,0x20(%eax)
  102030:	8b 45 08             	mov    0x8(%ebp),%eax
  102033:	0f b7 50 20          	movzwl 0x20(%eax),%edx
  102037:	8b 45 08             	mov    0x8(%ebp),%eax
  10203a:	66 89 50 28          	mov    %dx,0x28(%eax)
  10203e:	a1 a0 18 11 00       	mov    0x1118a0,%eax
  102043:	8b 55 08             	mov    0x8(%ebp),%edx
  102046:	0f b7 52 28          	movzwl 0x28(%edx),%edx
  10204a:	66 89 50 2c          	mov    %dx,0x2c(%eax)
					correct_tf->tf_eflags |= FL_IOPL_MASK;
  10204e:	a1 a0 18 11 00       	mov    0x1118a0,%eax
  102053:	8b 50 40             	mov    0x40(%eax),%edx
  102056:	a1 a0 18 11 00       	mov    0x1118a0,%eax
  10205b:	80 ce 30             	or     $0x30,%dh
  10205e:	89 50 40             	mov    %edx,0x40(%eax)
				break;
  102061:	eb 06                	jmp    102069 <loop+0x71>
				break;
  102063:	90                   	nop
  102064:	e9 59 01 00 00       	jmp    1021c2 <loop+0x1ca>
				break;
  102069:	90                   	nop
        break;
  10206a:	e9 53 01 00 00       	jmp    1021c2 <loop+0x1ca>
		if ((tf->tf_cs & 3) == 0) {
  10206f:	8b 45 08             	mov    0x8(%ebp),%eax
  102072:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  102076:	0f b7 c0             	movzwl %ax,%eax
  102079:	83 e0 03             	and    $0x3,%eax
  10207c:	85 c0                	test   %eax,%eax
  10207e:	0f 85 3a 01 00 00    	jne    1021be <loop+0x1c6>
			tf->tf_cs = USER_CS;
  102084:	8b 45 08             	mov    0x8(%ebp),%eax
  102087:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
			tf->tf_ss = tf->tf_ds = tf->tf_es = tf->tf_gs = tf->tf_fs = USER_DS;
  10208d:	8b 45 08             	mov    0x8(%ebp),%eax
  102090:	66 c7 40 24 23 00    	movw   $0x23,0x24(%eax)
  102096:	8b 45 08             	mov    0x8(%ebp),%eax
  102099:	0f b7 50 24          	movzwl 0x24(%eax),%edx
  10209d:	8b 45 08             	mov    0x8(%ebp),%eax
  1020a0:	66 89 50 20          	mov    %dx,0x20(%eax)
  1020a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1020a7:	0f b7 50 20          	movzwl 0x20(%eax),%edx
  1020ab:	8b 45 08             	mov    0x8(%ebp),%eax
  1020ae:	66 89 50 28          	mov    %dx,0x28(%eax)
  1020b2:	8b 45 08             	mov    0x8(%ebp),%eax
  1020b5:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  1020b9:	8b 45 08             	mov    0x8(%ebp),%eax
  1020bc:	66 89 50 2c          	mov    %dx,0x2c(%eax)
  1020c0:	8b 45 08             	mov    0x8(%ebp),%eax
  1020c3:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
  1020c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1020ca:	66 89 50 48          	mov    %dx,0x48(%eax)
			tf->tf_esp += 4;
  1020ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1020d1:	8b 40 44             	mov    0x44(%eax),%eax
  1020d4:	8d 50 04             	lea    0x4(%eax),%edx
  1020d7:	8b 45 08             	mov    0x8(%ebp),%eax
  1020da:	89 50 44             	mov    %edx,0x44(%eax)
			tf->tf_eflags |= FL_IOPL_MASK;
  1020dd:	8b 45 08             	mov    0x8(%ebp),%eax
  1020e0:	8b 40 40             	mov    0x40(%eax),%eax
  1020e3:	80 cc 30             	or     $0x30,%ah
  1020e6:	89 c2                	mov    %eax,%edx
  1020e8:	8b 45 08             	mov    0x8(%ebp),%eax
  1020eb:	89 50 40             	mov    %edx,0x40(%eax)
		break;
  1020ee:	e9 cb 00 00 00       	jmp    1021be <loop+0x1c6>
		if ((tf->tf_cs & 3) != 0) {
  1020f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1020f6:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  1020fa:	0f b7 c0             	movzwl %ax,%eax
  1020fd:	83 e0 03             	and    $0x3,%eax
  102100:	85 c0                	test   %eax,%eax
  102102:	0f 84 b9 00 00 00    	je     1021c1 <loop+0x1c9>
			tf->tf_cs = KERNEL_CS;
  102108:	8b 45 08             	mov    0x8(%ebp),%eax
  10210b:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
			tf->tf_ss = tf->tf_ds = tf->tf_es = tf->tf_gs = tf->tf_fs = KERNEL_DS;
  102111:	8b 45 08             	mov    0x8(%ebp),%eax
  102114:	66 c7 40 24 10 00    	movw   $0x10,0x24(%eax)
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
			tf->tf_eflags &= ~FL_IOPL_MASK;
  102152:	8b 45 08             	mov    0x8(%ebp),%eax
  102155:	8b 40 40             	mov    0x40(%eax),%eax
  102158:	80 e4 cf             	and    $0xcf,%ah
  10215b:	89 c2                	mov    %eax,%edx
  10215d:	8b 45 08             	mov    0x8(%ebp),%eax
  102160:	89 50 40             	mov    %edx,0x40(%eax)
			break;
  102163:	eb 5c                	jmp    1021c1 <loop+0x1c9>
	case T_GPFLT:
		cprintf("GP Fault!!!\n");
  102165:	83 ec 0c             	sub    $0xc,%esp
  102168:	68 d6 3d 10 00       	push   $0x103dd6
  10216d:	e8 0e e1 ff ff       	call   100280 <cprintf>
  102172:	83 c4 10             	add    $0x10,%esp
		print_trapframe(tf);
  102175:	83 ec 0c             	sub    $0xc,%esp
  102178:	ff 75 08             	pushl  0x8(%ebp)
  10217b:	e8 b8 f9 ff ff       	call   101b38 <print_trapframe>
  102180:	83 c4 10             	add    $0x10,%esp
		break;
  102183:	eb 3d                	jmp    1021c2 <loop+0x1ca>
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  102185:	8b 45 08             	mov    0x8(%ebp),%eax
  102188:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  10218c:	0f b7 c0             	movzwl %ax,%eax
  10218f:	83 e0 03             	and    $0x3,%eax
  102192:	85 c0                	test   %eax,%eax
  102194:	75 2c                	jne    1021c2 <loop+0x1ca>
            print_trapframe(tf);
  102196:	83 ec 0c             	sub    $0xc,%esp
  102199:	ff 75 08             	pushl  0x8(%ebp)
  10219c:	e8 97 f9 ff ff       	call   101b38 <print_trapframe>
  1021a1:	83 c4 10             	add    $0x10,%esp
            panic("unexpected trap in kernel.\n");
  1021a4:	83 ec 04             	sub    $0x4,%esp
  1021a7:	68 e3 3d 10 00       	push   $0x103de3
  1021ac:	68 35 01 00 00       	push   $0x135
  1021b1:	68 ff 3d 10 00       	push   $0x103dff
  1021b6:	e8 2c e2 ff ff       	call   1003e7 <__panic>
        break;
  1021bb:	90                   	nop
  1021bc:	eb 04                	jmp    1021c2 <loop+0x1ca>
		break;
  1021be:	90                   	nop
  1021bf:	eb 01                	jmp    1021c2 <loop+0x1ca>
			break;
  1021c1:	90                   	nop
        }
    }
}
  1021c2:	90                   	nop
  1021c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  1021c6:	5b                   	pop    %ebx
  1021c7:	5e                   	pop    %esi
  1021c8:	5f                   	pop    %edi
  1021c9:	5d                   	pop    %ebp
  1021ca:	c3                   	ret    

001021cb <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  1021cb:	55                   	push   %ebp
  1021cc:	89 e5                	mov    %esp,%ebp
  1021ce:	83 ec 08             	sub    $0x8,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  1021d1:	83 ec 0c             	sub    $0xc,%esp
  1021d4:	ff 75 08             	pushl  0x8(%ebp)
  1021d7:	e8 f7 fb ff ff       	call   101dd3 <trap_dispatch>
  1021dc:	83 c4 10             	add    $0x10,%esp
}
  1021df:	90                   	nop
  1021e0:	c9                   	leave  
  1021e1:	c3                   	ret    

001021e2 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  1021e2:	6a 00                	push   $0x0
  pushl $0
  1021e4:	6a 00                	push   $0x0
  jmp __alltraps
  1021e6:	e9 69 0a 00 00       	jmp    102c54 <__alltraps>

001021eb <vector1>:
.globl vector1
vector1:
  pushl $0
  1021eb:	6a 00                	push   $0x0
  pushl $1
  1021ed:	6a 01                	push   $0x1
  jmp __alltraps
  1021ef:	e9 60 0a 00 00       	jmp    102c54 <__alltraps>

001021f4 <vector2>:
.globl vector2
vector2:
  pushl $0
  1021f4:	6a 00                	push   $0x0
  pushl $2
  1021f6:	6a 02                	push   $0x2
  jmp __alltraps
  1021f8:	e9 57 0a 00 00       	jmp    102c54 <__alltraps>

001021fd <vector3>:
.globl vector3
vector3:
  pushl $0
  1021fd:	6a 00                	push   $0x0
  pushl $3
  1021ff:	6a 03                	push   $0x3
  jmp __alltraps
  102201:	e9 4e 0a 00 00       	jmp    102c54 <__alltraps>

00102206 <vector4>:
.globl vector4
vector4:
  pushl $0
  102206:	6a 00                	push   $0x0
  pushl $4
  102208:	6a 04                	push   $0x4
  jmp __alltraps
  10220a:	e9 45 0a 00 00       	jmp    102c54 <__alltraps>

0010220f <vector5>:
.globl vector5
vector5:
  pushl $0
  10220f:	6a 00                	push   $0x0
  pushl $5
  102211:	6a 05                	push   $0x5
  jmp __alltraps
  102213:	e9 3c 0a 00 00       	jmp    102c54 <__alltraps>

00102218 <vector6>:
.globl vector6
vector6:
  pushl $0
  102218:	6a 00                	push   $0x0
  pushl $6
  10221a:	6a 06                	push   $0x6
  jmp __alltraps
  10221c:	e9 33 0a 00 00       	jmp    102c54 <__alltraps>

00102221 <vector7>:
.globl vector7
vector7:
  pushl $0
  102221:	6a 00                	push   $0x0
  pushl $7
  102223:	6a 07                	push   $0x7
  jmp __alltraps
  102225:	e9 2a 0a 00 00       	jmp    102c54 <__alltraps>

0010222a <vector8>:
.globl vector8
vector8:
  pushl $8
  10222a:	6a 08                	push   $0x8
  jmp __alltraps
  10222c:	e9 23 0a 00 00       	jmp    102c54 <__alltraps>

00102231 <vector9>:
.globl vector9
vector9:
  pushl $0
  102231:	6a 00                	push   $0x0
  pushl $9
  102233:	6a 09                	push   $0x9
  jmp __alltraps
  102235:	e9 1a 0a 00 00       	jmp    102c54 <__alltraps>

0010223a <vector10>:
.globl vector10
vector10:
  pushl $10
  10223a:	6a 0a                	push   $0xa
  jmp __alltraps
  10223c:	e9 13 0a 00 00       	jmp    102c54 <__alltraps>

00102241 <vector11>:
.globl vector11
vector11:
  pushl $11
  102241:	6a 0b                	push   $0xb
  jmp __alltraps
  102243:	e9 0c 0a 00 00       	jmp    102c54 <__alltraps>

00102248 <vector12>:
.globl vector12
vector12:
  pushl $12
  102248:	6a 0c                	push   $0xc
  jmp __alltraps
  10224a:	e9 05 0a 00 00       	jmp    102c54 <__alltraps>

0010224f <vector13>:
.globl vector13
vector13:
  pushl $13
  10224f:	6a 0d                	push   $0xd
  jmp __alltraps
  102251:	e9 fe 09 00 00       	jmp    102c54 <__alltraps>

00102256 <vector14>:
.globl vector14
vector14:
  pushl $14
  102256:	6a 0e                	push   $0xe
  jmp __alltraps
  102258:	e9 f7 09 00 00       	jmp    102c54 <__alltraps>

0010225d <vector15>:
.globl vector15
vector15:
  pushl $0
  10225d:	6a 00                	push   $0x0
  pushl $15
  10225f:	6a 0f                	push   $0xf
  jmp __alltraps
  102261:	e9 ee 09 00 00       	jmp    102c54 <__alltraps>

00102266 <vector16>:
.globl vector16
vector16:
  pushl $0
  102266:	6a 00                	push   $0x0
  pushl $16
  102268:	6a 10                	push   $0x10
  jmp __alltraps
  10226a:	e9 e5 09 00 00       	jmp    102c54 <__alltraps>

0010226f <vector17>:
.globl vector17
vector17:
  pushl $17
  10226f:	6a 11                	push   $0x11
  jmp __alltraps
  102271:	e9 de 09 00 00       	jmp    102c54 <__alltraps>

00102276 <vector18>:
.globl vector18
vector18:
  pushl $0
  102276:	6a 00                	push   $0x0
  pushl $18
  102278:	6a 12                	push   $0x12
  jmp __alltraps
  10227a:	e9 d5 09 00 00       	jmp    102c54 <__alltraps>

0010227f <vector19>:
.globl vector19
vector19:
  pushl $0
  10227f:	6a 00                	push   $0x0
  pushl $19
  102281:	6a 13                	push   $0x13
  jmp __alltraps
  102283:	e9 cc 09 00 00       	jmp    102c54 <__alltraps>

00102288 <vector20>:
.globl vector20
vector20:
  pushl $0
  102288:	6a 00                	push   $0x0
  pushl $20
  10228a:	6a 14                	push   $0x14
  jmp __alltraps
  10228c:	e9 c3 09 00 00       	jmp    102c54 <__alltraps>

00102291 <vector21>:
.globl vector21
vector21:
  pushl $0
  102291:	6a 00                	push   $0x0
  pushl $21
  102293:	6a 15                	push   $0x15
  jmp __alltraps
  102295:	e9 ba 09 00 00       	jmp    102c54 <__alltraps>

0010229a <vector22>:
.globl vector22
vector22:
  pushl $0
  10229a:	6a 00                	push   $0x0
  pushl $22
  10229c:	6a 16                	push   $0x16
  jmp __alltraps
  10229e:	e9 b1 09 00 00       	jmp    102c54 <__alltraps>

001022a3 <vector23>:
.globl vector23
vector23:
  pushl $0
  1022a3:	6a 00                	push   $0x0
  pushl $23
  1022a5:	6a 17                	push   $0x17
  jmp __alltraps
  1022a7:	e9 a8 09 00 00       	jmp    102c54 <__alltraps>

001022ac <vector24>:
.globl vector24
vector24:
  pushl $0
  1022ac:	6a 00                	push   $0x0
  pushl $24
  1022ae:	6a 18                	push   $0x18
  jmp __alltraps
  1022b0:	e9 9f 09 00 00       	jmp    102c54 <__alltraps>

001022b5 <vector25>:
.globl vector25
vector25:
  pushl $0
  1022b5:	6a 00                	push   $0x0
  pushl $25
  1022b7:	6a 19                	push   $0x19
  jmp __alltraps
  1022b9:	e9 96 09 00 00       	jmp    102c54 <__alltraps>

001022be <vector26>:
.globl vector26
vector26:
  pushl $0
  1022be:	6a 00                	push   $0x0
  pushl $26
  1022c0:	6a 1a                	push   $0x1a
  jmp __alltraps
  1022c2:	e9 8d 09 00 00       	jmp    102c54 <__alltraps>

001022c7 <vector27>:
.globl vector27
vector27:
  pushl $0
  1022c7:	6a 00                	push   $0x0
  pushl $27
  1022c9:	6a 1b                	push   $0x1b
  jmp __alltraps
  1022cb:	e9 84 09 00 00       	jmp    102c54 <__alltraps>

001022d0 <vector28>:
.globl vector28
vector28:
  pushl $0
  1022d0:	6a 00                	push   $0x0
  pushl $28
  1022d2:	6a 1c                	push   $0x1c
  jmp __alltraps
  1022d4:	e9 7b 09 00 00       	jmp    102c54 <__alltraps>

001022d9 <vector29>:
.globl vector29
vector29:
  pushl $0
  1022d9:	6a 00                	push   $0x0
  pushl $29
  1022db:	6a 1d                	push   $0x1d
  jmp __alltraps
  1022dd:	e9 72 09 00 00       	jmp    102c54 <__alltraps>

001022e2 <vector30>:
.globl vector30
vector30:
  pushl $0
  1022e2:	6a 00                	push   $0x0
  pushl $30
  1022e4:	6a 1e                	push   $0x1e
  jmp __alltraps
  1022e6:	e9 69 09 00 00       	jmp    102c54 <__alltraps>

001022eb <vector31>:
.globl vector31
vector31:
  pushl $0
  1022eb:	6a 00                	push   $0x0
  pushl $31
  1022ed:	6a 1f                	push   $0x1f
  jmp __alltraps
  1022ef:	e9 60 09 00 00       	jmp    102c54 <__alltraps>

001022f4 <vector32>:
.globl vector32
vector32:
  pushl $0
  1022f4:	6a 00                	push   $0x0
  pushl $32
  1022f6:	6a 20                	push   $0x20
  jmp __alltraps
  1022f8:	e9 57 09 00 00       	jmp    102c54 <__alltraps>

001022fd <vector33>:
.globl vector33
vector33:
  pushl $0
  1022fd:	6a 00                	push   $0x0
  pushl $33
  1022ff:	6a 21                	push   $0x21
  jmp __alltraps
  102301:	e9 4e 09 00 00       	jmp    102c54 <__alltraps>

00102306 <vector34>:
.globl vector34
vector34:
  pushl $0
  102306:	6a 00                	push   $0x0
  pushl $34
  102308:	6a 22                	push   $0x22
  jmp __alltraps
  10230a:	e9 45 09 00 00       	jmp    102c54 <__alltraps>

0010230f <vector35>:
.globl vector35
vector35:
  pushl $0
  10230f:	6a 00                	push   $0x0
  pushl $35
  102311:	6a 23                	push   $0x23
  jmp __alltraps
  102313:	e9 3c 09 00 00       	jmp    102c54 <__alltraps>

00102318 <vector36>:
.globl vector36
vector36:
  pushl $0
  102318:	6a 00                	push   $0x0
  pushl $36
  10231a:	6a 24                	push   $0x24
  jmp __alltraps
  10231c:	e9 33 09 00 00       	jmp    102c54 <__alltraps>

00102321 <vector37>:
.globl vector37
vector37:
  pushl $0
  102321:	6a 00                	push   $0x0
  pushl $37
  102323:	6a 25                	push   $0x25
  jmp __alltraps
  102325:	e9 2a 09 00 00       	jmp    102c54 <__alltraps>

0010232a <vector38>:
.globl vector38
vector38:
  pushl $0
  10232a:	6a 00                	push   $0x0
  pushl $38
  10232c:	6a 26                	push   $0x26
  jmp __alltraps
  10232e:	e9 21 09 00 00       	jmp    102c54 <__alltraps>

00102333 <vector39>:
.globl vector39
vector39:
  pushl $0
  102333:	6a 00                	push   $0x0
  pushl $39
  102335:	6a 27                	push   $0x27
  jmp __alltraps
  102337:	e9 18 09 00 00       	jmp    102c54 <__alltraps>

0010233c <vector40>:
.globl vector40
vector40:
  pushl $0
  10233c:	6a 00                	push   $0x0
  pushl $40
  10233e:	6a 28                	push   $0x28
  jmp __alltraps
  102340:	e9 0f 09 00 00       	jmp    102c54 <__alltraps>

00102345 <vector41>:
.globl vector41
vector41:
  pushl $0
  102345:	6a 00                	push   $0x0
  pushl $41
  102347:	6a 29                	push   $0x29
  jmp __alltraps
  102349:	e9 06 09 00 00       	jmp    102c54 <__alltraps>

0010234e <vector42>:
.globl vector42
vector42:
  pushl $0
  10234e:	6a 00                	push   $0x0
  pushl $42
  102350:	6a 2a                	push   $0x2a
  jmp __alltraps
  102352:	e9 fd 08 00 00       	jmp    102c54 <__alltraps>

00102357 <vector43>:
.globl vector43
vector43:
  pushl $0
  102357:	6a 00                	push   $0x0
  pushl $43
  102359:	6a 2b                	push   $0x2b
  jmp __alltraps
  10235b:	e9 f4 08 00 00       	jmp    102c54 <__alltraps>

00102360 <vector44>:
.globl vector44
vector44:
  pushl $0
  102360:	6a 00                	push   $0x0
  pushl $44
  102362:	6a 2c                	push   $0x2c
  jmp __alltraps
  102364:	e9 eb 08 00 00       	jmp    102c54 <__alltraps>

00102369 <vector45>:
.globl vector45
vector45:
  pushl $0
  102369:	6a 00                	push   $0x0
  pushl $45
  10236b:	6a 2d                	push   $0x2d
  jmp __alltraps
  10236d:	e9 e2 08 00 00       	jmp    102c54 <__alltraps>

00102372 <vector46>:
.globl vector46
vector46:
  pushl $0
  102372:	6a 00                	push   $0x0
  pushl $46
  102374:	6a 2e                	push   $0x2e
  jmp __alltraps
  102376:	e9 d9 08 00 00       	jmp    102c54 <__alltraps>

0010237b <vector47>:
.globl vector47
vector47:
  pushl $0
  10237b:	6a 00                	push   $0x0
  pushl $47
  10237d:	6a 2f                	push   $0x2f
  jmp __alltraps
  10237f:	e9 d0 08 00 00       	jmp    102c54 <__alltraps>

00102384 <vector48>:
.globl vector48
vector48:
  pushl $0
  102384:	6a 00                	push   $0x0
  pushl $48
  102386:	6a 30                	push   $0x30
  jmp __alltraps
  102388:	e9 c7 08 00 00       	jmp    102c54 <__alltraps>

0010238d <vector49>:
.globl vector49
vector49:
  pushl $0
  10238d:	6a 00                	push   $0x0
  pushl $49
  10238f:	6a 31                	push   $0x31
  jmp __alltraps
  102391:	e9 be 08 00 00       	jmp    102c54 <__alltraps>

00102396 <vector50>:
.globl vector50
vector50:
  pushl $0
  102396:	6a 00                	push   $0x0
  pushl $50
  102398:	6a 32                	push   $0x32
  jmp __alltraps
  10239a:	e9 b5 08 00 00       	jmp    102c54 <__alltraps>

0010239f <vector51>:
.globl vector51
vector51:
  pushl $0
  10239f:	6a 00                	push   $0x0
  pushl $51
  1023a1:	6a 33                	push   $0x33
  jmp __alltraps
  1023a3:	e9 ac 08 00 00       	jmp    102c54 <__alltraps>

001023a8 <vector52>:
.globl vector52
vector52:
  pushl $0
  1023a8:	6a 00                	push   $0x0
  pushl $52
  1023aa:	6a 34                	push   $0x34
  jmp __alltraps
  1023ac:	e9 a3 08 00 00       	jmp    102c54 <__alltraps>

001023b1 <vector53>:
.globl vector53
vector53:
  pushl $0
  1023b1:	6a 00                	push   $0x0
  pushl $53
  1023b3:	6a 35                	push   $0x35
  jmp __alltraps
  1023b5:	e9 9a 08 00 00       	jmp    102c54 <__alltraps>

001023ba <vector54>:
.globl vector54
vector54:
  pushl $0
  1023ba:	6a 00                	push   $0x0
  pushl $54
  1023bc:	6a 36                	push   $0x36
  jmp __alltraps
  1023be:	e9 91 08 00 00       	jmp    102c54 <__alltraps>

001023c3 <vector55>:
.globl vector55
vector55:
  pushl $0
  1023c3:	6a 00                	push   $0x0
  pushl $55
  1023c5:	6a 37                	push   $0x37
  jmp __alltraps
  1023c7:	e9 88 08 00 00       	jmp    102c54 <__alltraps>

001023cc <vector56>:
.globl vector56
vector56:
  pushl $0
  1023cc:	6a 00                	push   $0x0
  pushl $56
  1023ce:	6a 38                	push   $0x38
  jmp __alltraps
  1023d0:	e9 7f 08 00 00       	jmp    102c54 <__alltraps>

001023d5 <vector57>:
.globl vector57
vector57:
  pushl $0
  1023d5:	6a 00                	push   $0x0
  pushl $57
  1023d7:	6a 39                	push   $0x39
  jmp __alltraps
  1023d9:	e9 76 08 00 00       	jmp    102c54 <__alltraps>

001023de <vector58>:
.globl vector58
vector58:
  pushl $0
  1023de:	6a 00                	push   $0x0
  pushl $58
  1023e0:	6a 3a                	push   $0x3a
  jmp __alltraps
  1023e2:	e9 6d 08 00 00       	jmp    102c54 <__alltraps>

001023e7 <vector59>:
.globl vector59
vector59:
  pushl $0
  1023e7:	6a 00                	push   $0x0
  pushl $59
  1023e9:	6a 3b                	push   $0x3b
  jmp __alltraps
  1023eb:	e9 64 08 00 00       	jmp    102c54 <__alltraps>

001023f0 <vector60>:
.globl vector60
vector60:
  pushl $0
  1023f0:	6a 00                	push   $0x0
  pushl $60
  1023f2:	6a 3c                	push   $0x3c
  jmp __alltraps
  1023f4:	e9 5b 08 00 00       	jmp    102c54 <__alltraps>

001023f9 <vector61>:
.globl vector61
vector61:
  pushl $0
  1023f9:	6a 00                	push   $0x0
  pushl $61
  1023fb:	6a 3d                	push   $0x3d
  jmp __alltraps
  1023fd:	e9 52 08 00 00       	jmp    102c54 <__alltraps>

00102402 <vector62>:
.globl vector62
vector62:
  pushl $0
  102402:	6a 00                	push   $0x0
  pushl $62
  102404:	6a 3e                	push   $0x3e
  jmp __alltraps
  102406:	e9 49 08 00 00       	jmp    102c54 <__alltraps>

0010240b <vector63>:
.globl vector63
vector63:
  pushl $0
  10240b:	6a 00                	push   $0x0
  pushl $63
  10240d:	6a 3f                	push   $0x3f
  jmp __alltraps
  10240f:	e9 40 08 00 00       	jmp    102c54 <__alltraps>

00102414 <vector64>:
.globl vector64
vector64:
  pushl $0
  102414:	6a 00                	push   $0x0
  pushl $64
  102416:	6a 40                	push   $0x40
  jmp __alltraps
  102418:	e9 37 08 00 00       	jmp    102c54 <__alltraps>

0010241d <vector65>:
.globl vector65
vector65:
  pushl $0
  10241d:	6a 00                	push   $0x0
  pushl $65
  10241f:	6a 41                	push   $0x41
  jmp __alltraps
  102421:	e9 2e 08 00 00       	jmp    102c54 <__alltraps>

00102426 <vector66>:
.globl vector66
vector66:
  pushl $0
  102426:	6a 00                	push   $0x0
  pushl $66
  102428:	6a 42                	push   $0x42
  jmp __alltraps
  10242a:	e9 25 08 00 00       	jmp    102c54 <__alltraps>

0010242f <vector67>:
.globl vector67
vector67:
  pushl $0
  10242f:	6a 00                	push   $0x0
  pushl $67
  102431:	6a 43                	push   $0x43
  jmp __alltraps
  102433:	e9 1c 08 00 00       	jmp    102c54 <__alltraps>

00102438 <vector68>:
.globl vector68
vector68:
  pushl $0
  102438:	6a 00                	push   $0x0
  pushl $68
  10243a:	6a 44                	push   $0x44
  jmp __alltraps
  10243c:	e9 13 08 00 00       	jmp    102c54 <__alltraps>

00102441 <vector69>:
.globl vector69
vector69:
  pushl $0
  102441:	6a 00                	push   $0x0
  pushl $69
  102443:	6a 45                	push   $0x45
  jmp __alltraps
  102445:	e9 0a 08 00 00       	jmp    102c54 <__alltraps>

0010244a <vector70>:
.globl vector70
vector70:
  pushl $0
  10244a:	6a 00                	push   $0x0
  pushl $70
  10244c:	6a 46                	push   $0x46
  jmp __alltraps
  10244e:	e9 01 08 00 00       	jmp    102c54 <__alltraps>

00102453 <vector71>:
.globl vector71
vector71:
  pushl $0
  102453:	6a 00                	push   $0x0
  pushl $71
  102455:	6a 47                	push   $0x47
  jmp __alltraps
  102457:	e9 f8 07 00 00       	jmp    102c54 <__alltraps>

0010245c <vector72>:
.globl vector72
vector72:
  pushl $0
  10245c:	6a 00                	push   $0x0
  pushl $72
  10245e:	6a 48                	push   $0x48
  jmp __alltraps
  102460:	e9 ef 07 00 00       	jmp    102c54 <__alltraps>

00102465 <vector73>:
.globl vector73
vector73:
  pushl $0
  102465:	6a 00                	push   $0x0
  pushl $73
  102467:	6a 49                	push   $0x49
  jmp __alltraps
  102469:	e9 e6 07 00 00       	jmp    102c54 <__alltraps>

0010246e <vector74>:
.globl vector74
vector74:
  pushl $0
  10246e:	6a 00                	push   $0x0
  pushl $74
  102470:	6a 4a                	push   $0x4a
  jmp __alltraps
  102472:	e9 dd 07 00 00       	jmp    102c54 <__alltraps>

00102477 <vector75>:
.globl vector75
vector75:
  pushl $0
  102477:	6a 00                	push   $0x0
  pushl $75
  102479:	6a 4b                	push   $0x4b
  jmp __alltraps
  10247b:	e9 d4 07 00 00       	jmp    102c54 <__alltraps>

00102480 <vector76>:
.globl vector76
vector76:
  pushl $0
  102480:	6a 00                	push   $0x0
  pushl $76
  102482:	6a 4c                	push   $0x4c
  jmp __alltraps
  102484:	e9 cb 07 00 00       	jmp    102c54 <__alltraps>

00102489 <vector77>:
.globl vector77
vector77:
  pushl $0
  102489:	6a 00                	push   $0x0
  pushl $77
  10248b:	6a 4d                	push   $0x4d
  jmp __alltraps
  10248d:	e9 c2 07 00 00       	jmp    102c54 <__alltraps>

00102492 <vector78>:
.globl vector78
vector78:
  pushl $0
  102492:	6a 00                	push   $0x0
  pushl $78
  102494:	6a 4e                	push   $0x4e
  jmp __alltraps
  102496:	e9 b9 07 00 00       	jmp    102c54 <__alltraps>

0010249b <vector79>:
.globl vector79
vector79:
  pushl $0
  10249b:	6a 00                	push   $0x0
  pushl $79
  10249d:	6a 4f                	push   $0x4f
  jmp __alltraps
  10249f:	e9 b0 07 00 00       	jmp    102c54 <__alltraps>

001024a4 <vector80>:
.globl vector80
vector80:
  pushl $0
  1024a4:	6a 00                	push   $0x0
  pushl $80
  1024a6:	6a 50                	push   $0x50
  jmp __alltraps
  1024a8:	e9 a7 07 00 00       	jmp    102c54 <__alltraps>

001024ad <vector81>:
.globl vector81
vector81:
  pushl $0
  1024ad:	6a 00                	push   $0x0
  pushl $81
  1024af:	6a 51                	push   $0x51
  jmp __alltraps
  1024b1:	e9 9e 07 00 00       	jmp    102c54 <__alltraps>

001024b6 <vector82>:
.globl vector82
vector82:
  pushl $0
  1024b6:	6a 00                	push   $0x0
  pushl $82
  1024b8:	6a 52                	push   $0x52
  jmp __alltraps
  1024ba:	e9 95 07 00 00       	jmp    102c54 <__alltraps>

001024bf <vector83>:
.globl vector83
vector83:
  pushl $0
  1024bf:	6a 00                	push   $0x0
  pushl $83
  1024c1:	6a 53                	push   $0x53
  jmp __alltraps
  1024c3:	e9 8c 07 00 00       	jmp    102c54 <__alltraps>

001024c8 <vector84>:
.globl vector84
vector84:
  pushl $0
  1024c8:	6a 00                	push   $0x0
  pushl $84
  1024ca:	6a 54                	push   $0x54
  jmp __alltraps
  1024cc:	e9 83 07 00 00       	jmp    102c54 <__alltraps>

001024d1 <vector85>:
.globl vector85
vector85:
  pushl $0
  1024d1:	6a 00                	push   $0x0
  pushl $85
  1024d3:	6a 55                	push   $0x55
  jmp __alltraps
  1024d5:	e9 7a 07 00 00       	jmp    102c54 <__alltraps>

001024da <vector86>:
.globl vector86
vector86:
  pushl $0
  1024da:	6a 00                	push   $0x0
  pushl $86
  1024dc:	6a 56                	push   $0x56
  jmp __alltraps
  1024de:	e9 71 07 00 00       	jmp    102c54 <__alltraps>

001024e3 <vector87>:
.globl vector87
vector87:
  pushl $0
  1024e3:	6a 00                	push   $0x0
  pushl $87
  1024e5:	6a 57                	push   $0x57
  jmp __alltraps
  1024e7:	e9 68 07 00 00       	jmp    102c54 <__alltraps>

001024ec <vector88>:
.globl vector88
vector88:
  pushl $0
  1024ec:	6a 00                	push   $0x0
  pushl $88
  1024ee:	6a 58                	push   $0x58
  jmp __alltraps
  1024f0:	e9 5f 07 00 00       	jmp    102c54 <__alltraps>

001024f5 <vector89>:
.globl vector89
vector89:
  pushl $0
  1024f5:	6a 00                	push   $0x0
  pushl $89
  1024f7:	6a 59                	push   $0x59
  jmp __alltraps
  1024f9:	e9 56 07 00 00       	jmp    102c54 <__alltraps>

001024fe <vector90>:
.globl vector90
vector90:
  pushl $0
  1024fe:	6a 00                	push   $0x0
  pushl $90
  102500:	6a 5a                	push   $0x5a
  jmp __alltraps
  102502:	e9 4d 07 00 00       	jmp    102c54 <__alltraps>

00102507 <vector91>:
.globl vector91
vector91:
  pushl $0
  102507:	6a 00                	push   $0x0
  pushl $91
  102509:	6a 5b                	push   $0x5b
  jmp __alltraps
  10250b:	e9 44 07 00 00       	jmp    102c54 <__alltraps>

00102510 <vector92>:
.globl vector92
vector92:
  pushl $0
  102510:	6a 00                	push   $0x0
  pushl $92
  102512:	6a 5c                	push   $0x5c
  jmp __alltraps
  102514:	e9 3b 07 00 00       	jmp    102c54 <__alltraps>

00102519 <vector93>:
.globl vector93
vector93:
  pushl $0
  102519:	6a 00                	push   $0x0
  pushl $93
  10251b:	6a 5d                	push   $0x5d
  jmp __alltraps
  10251d:	e9 32 07 00 00       	jmp    102c54 <__alltraps>

00102522 <vector94>:
.globl vector94
vector94:
  pushl $0
  102522:	6a 00                	push   $0x0
  pushl $94
  102524:	6a 5e                	push   $0x5e
  jmp __alltraps
  102526:	e9 29 07 00 00       	jmp    102c54 <__alltraps>

0010252b <vector95>:
.globl vector95
vector95:
  pushl $0
  10252b:	6a 00                	push   $0x0
  pushl $95
  10252d:	6a 5f                	push   $0x5f
  jmp __alltraps
  10252f:	e9 20 07 00 00       	jmp    102c54 <__alltraps>

00102534 <vector96>:
.globl vector96
vector96:
  pushl $0
  102534:	6a 00                	push   $0x0
  pushl $96
  102536:	6a 60                	push   $0x60
  jmp __alltraps
  102538:	e9 17 07 00 00       	jmp    102c54 <__alltraps>

0010253d <vector97>:
.globl vector97
vector97:
  pushl $0
  10253d:	6a 00                	push   $0x0
  pushl $97
  10253f:	6a 61                	push   $0x61
  jmp __alltraps
  102541:	e9 0e 07 00 00       	jmp    102c54 <__alltraps>

00102546 <vector98>:
.globl vector98
vector98:
  pushl $0
  102546:	6a 00                	push   $0x0
  pushl $98
  102548:	6a 62                	push   $0x62
  jmp __alltraps
  10254a:	e9 05 07 00 00       	jmp    102c54 <__alltraps>

0010254f <vector99>:
.globl vector99
vector99:
  pushl $0
  10254f:	6a 00                	push   $0x0
  pushl $99
  102551:	6a 63                	push   $0x63
  jmp __alltraps
  102553:	e9 fc 06 00 00       	jmp    102c54 <__alltraps>

00102558 <vector100>:
.globl vector100
vector100:
  pushl $0
  102558:	6a 00                	push   $0x0
  pushl $100
  10255a:	6a 64                	push   $0x64
  jmp __alltraps
  10255c:	e9 f3 06 00 00       	jmp    102c54 <__alltraps>

00102561 <vector101>:
.globl vector101
vector101:
  pushl $0
  102561:	6a 00                	push   $0x0
  pushl $101
  102563:	6a 65                	push   $0x65
  jmp __alltraps
  102565:	e9 ea 06 00 00       	jmp    102c54 <__alltraps>

0010256a <vector102>:
.globl vector102
vector102:
  pushl $0
  10256a:	6a 00                	push   $0x0
  pushl $102
  10256c:	6a 66                	push   $0x66
  jmp __alltraps
  10256e:	e9 e1 06 00 00       	jmp    102c54 <__alltraps>

00102573 <vector103>:
.globl vector103
vector103:
  pushl $0
  102573:	6a 00                	push   $0x0
  pushl $103
  102575:	6a 67                	push   $0x67
  jmp __alltraps
  102577:	e9 d8 06 00 00       	jmp    102c54 <__alltraps>

0010257c <vector104>:
.globl vector104
vector104:
  pushl $0
  10257c:	6a 00                	push   $0x0
  pushl $104
  10257e:	6a 68                	push   $0x68
  jmp __alltraps
  102580:	e9 cf 06 00 00       	jmp    102c54 <__alltraps>

00102585 <vector105>:
.globl vector105
vector105:
  pushl $0
  102585:	6a 00                	push   $0x0
  pushl $105
  102587:	6a 69                	push   $0x69
  jmp __alltraps
  102589:	e9 c6 06 00 00       	jmp    102c54 <__alltraps>

0010258e <vector106>:
.globl vector106
vector106:
  pushl $0
  10258e:	6a 00                	push   $0x0
  pushl $106
  102590:	6a 6a                	push   $0x6a
  jmp __alltraps
  102592:	e9 bd 06 00 00       	jmp    102c54 <__alltraps>

00102597 <vector107>:
.globl vector107
vector107:
  pushl $0
  102597:	6a 00                	push   $0x0
  pushl $107
  102599:	6a 6b                	push   $0x6b
  jmp __alltraps
  10259b:	e9 b4 06 00 00       	jmp    102c54 <__alltraps>

001025a0 <vector108>:
.globl vector108
vector108:
  pushl $0
  1025a0:	6a 00                	push   $0x0
  pushl $108
  1025a2:	6a 6c                	push   $0x6c
  jmp __alltraps
  1025a4:	e9 ab 06 00 00       	jmp    102c54 <__alltraps>

001025a9 <vector109>:
.globl vector109
vector109:
  pushl $0
  1025a9:	6a 00                	push   $0x0
  pushl $109
  1025ab:	6a 6d                	push   $0x6d
  jmp __alltraps
  1025ad:	e9 a2 06 00 00       	jmp    102c54 <__alltraps>

001025b2 <vector110>:
.globl vector110
vector110:
  pushl $0
  1025b2:	6a 00                	push   $0x0
  pushl $110
  1025b4:	6a 6e                	push   $0x6e
  jmp __alltraps
  1025b6:	e9 99 06 00 00       	jmp    102c54 <__alltraps>

001025bb <vector111>:
.globl vector111
vector111:
  pushl $0
  1025bb:	6a 00                	push   $0x0
  pushl $111
  1025bd:	6a 6f                	push   $0x6f
  jmp __alltraps
  1025bf:	e9 90 06 00 00       	jmp    102c54 <__alltraps>

001025c4 <vector112>:
.globl vector112
vector112:
  pushl $0
  1025c4:	6a 00                	push   $0x0
  pushl $112
  1025c6:	6a 70                	push   $0x70
  jmp __alltraps
  1025c8:	e9 87 06 00 00       	jmp    102c54 <__alltraps>

001025cd <vector113>:
.globl vector113
vector113:
  pushl $0
  1025cd:	6a 00                	push   $0x0
  pushl $113
  1025cf:	6a 71                	push   $0x71
  jmp __alltraps
  1025d1:	e9 7e 06 00 00       	jmp    102c54 <__alltraps>

001025d6 <vector114>:
.globl vector114
vector114:
  pushl $0
  1025d6:	6a 00                	push   $0x0
  pushl $114
  1025d8:	6a 72                	push   $0x72
  jmp __alltraps
  1025da:	e9 75 06 00 00       	jmp    102c54 <__alltraps>

001025df <vector115>:
.globl vector115
vector115:
  pushl $0
  1025df:	6a 00                	push   $0x0
  pushl $115
  1025e1:	6a 73                	push   $0x73
  jmp __alltraps
  1025e3:	e9 6c 06 00 00       	jmp    102c54 <__alltraps>

001025e8 <vector116>:
.globl vector116
vector116:
  pushl $0
  1025e8:	6a 00                	push   $0x0
  pushl $116
  1025ea:	6a 74                	push   $0x74
  jmp __alltraps
  1025ec:	e9 63 06 00 00       	jmp    102c54 <__alltraps>

001025f1 <vector117>:
.globl vector117
vector117:
  pushl $0
  1025f1:	6a 00                	push   $0x0
  pushl $117
  1025f3:	6a 75                	push   $0x75
  jmp __alltraps
  1025f5:	e9 5a 06 00 00       	jmp    102c54 <__alltraps>

001025fa <vector118>:
.globl vector118
vector118:
  pushl $0
  1025fa:	6a 00                	push   $0x0
  pushl $118
  1025fc:	6a 76                	push   $0x76
  jmp __alltraps
  1025fe:	e9 51 06 00 00       	jmp    102c54 <__alltraps>

00102603 <vector119>:
.globl vector119
vector119:
  pushl $0
  102603:	6a 00                	push   $0x0
  pushl $119
  102605:	6a 77                	push   $0x77
  jmp __alltraps
  102607:	e9 48 06 00 00       	jmp    102c54 <__alltraps>

0010260c <vector120>:
.globl vector120
vector120:
  pushl $0
  10260c:	6a 00                	push   $0x0
  pushl $120
  10260e:	6a 78                	push   $0x78
  jmp __alltraps
  102610:	e9 3f 06 00 00       	jmp    102c54 <__alltraps>

00102615 <vector121>:
.globl vector121
vector121:
  pushl $0
  102615:	6a 00                	push   $0x0
  pushl $121
  102617:	6a 79                	push   $0x79
  jmp __alltraps
  102619:	e9 36 06 00 00       	jmp    102c54 <__alltraps>

0010261e <vector122>:
.globl vector122
vector122:
  pushl $0
  10261e:	6a 00                	push   $0x0
  pushl $122
  102620:	6a 7a                	push   $0x7a
  jmp __alltraps
  102622:	e9 2d 06 00 00       	jmp    102c54 <__alltraps>

00102627 <vector123>:
.globl vector123
vector123:
  pushl $0
  102627:	6a 00                	push   $0x0
  pushl $123
  102629:	6a 7b                	push   $0x7b
  jmp __alltraps
  10262b:	e9 24 06 00 00       	jmp    102c54 <__alltraps>

00102630 <vector124>:
.globl vector124
vector124:
  pushl $0
  102630:	6a 00                	push   $0x0
  pushl $124
  102632:	6a 7c                	push   $0x7c
  jmp __alltraps
  102634:	e9 1b 06 00 00       	jmp    102c54 <__alltraps>

00102639 <vector125>:
.globl vector125
vector125:
  pushl $0
  102639:	6a 00                	push   $0x0
  pushl $125
  10263b:	6a 7d                	push   $0x7d
  jmp __alltraps
  10263d:	e9 12 06 00 00       	jmp    102c54 <__alltraps>

00102642 <vector126>:
.globl vector126
vector126:
  pushl $0
  102642:	6a 00                	push   $0x0
  pushl $126
  102644:	6a 7e                	push   $0x7e
  jmp __alltraps
  102646:	e9 09 06 00 00       	jmp    102c54 <__alltraps>

0010264b <vector127>:
.globl vector127
vector127:
  pushl $0
  10264b:	6a 00                	push   $0x0
  pushl $127
  10264d:	6a 7f                	push   $0x7f
  jmp __alltraps
  10264f:	e9 00 06 00 00       	jmp    102c54 <__alltraps>

00102654 <vector128>:
.globl vector128
vector128:
  pushl $0
  102654:	6a 00                	push   $0x0
  pushl $128
  102656:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  10265b:	e9 f4 05 00 00       	jmp    102c54 <__alltraps>

00102660 <vector129>:
.globl vector129
vector129:
  pushl $0
  102660:	6a 00                	push   $0x0
  pushl $129
  102662:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102667:	e9 e8 05 00 00       	jmp    102c54 <__alltraps>

0010266c <vector130>:
.globl vector130
vector130:
  pushl $0
  10266c:	6a 00                	push   $0x0
  pushl $130
  10266e:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  102673:	e9 dc 05 00 00       	jmp    102c54 <__alltraps>

00102678 <vector131>:
.globl vector131
vector131:
  pushl $0
  102678:	6a 00                	push   $0x0
  pushl $131
  10267a:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  10267f:	e9 d0 05 00 00       	jmp    102c54 <__alltraps>

00102684 <vector132>:
.globl vector132
vector132:
  pushl $0
  102684:	6a 00                	push   $0x0
  pushl $132
  102686:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  10268b:	e9 c4 05 00 00       	jmp    102c54 <__alltraps>

00102690 <vector133>:
.globl vector133
vector133:
  pushl $0
  102690:	6a 00                	push   $0x0
  pushl $133
  102692:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102697:	e9 b8 05 00 00       	jmp    102c54 <__alltraps>

0010269c <vector134>:
.globl vector134
vector134:
  pushl $0
  10269c:	6a 00                	push   $0x0
  pushl $134
  10269e:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  1026a3:	e9 ac 05 00 00       	jmp    102c54 <__alltraps>

001026a8 <vector135>:
.globl vector135
vector135:
  pushl $0
  1026a8:	6a 00                	push   $0x0
  pushl $135
  1026aa:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  1026af:	e9 a0 05 00 00       	jmp    102c54 <__alltraps>

001026b4 <vector136>:
.globl vector136
vector136:
  pushl $0
  1026b4:	6a 00                	push   $0x0
  pushl $136
  1026b6:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  1026bb:	e9 94 05 00 00       	jmp    102c54 <__alltraps>

001026c0 <vector137>:
.globl vector137
vector137:
  pushl $0
  1026c0:	6a 00                	push   $0x0
  pushl $137
  1026c2:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1026c7:	e9 88 05 00 00       	jmp    102c54 <__alltraps>

001026cc <vector138>:
.globl vector138
vector138:
  pushl $0
  1026cc:	6a 00                	push   $0x0
  pushl $138
  1026ce:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1026d3:	e9 7c 05 00 00       	jmp    102c54 <__alltraps>

001026d8 <vector139>:
.globl vector139
vector139:
  pushl $0
  1026d8:	6a 00                	push   $0x0
  pushl $139
  1026da:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1026df:	e9 70 05 00 00       	jmp    102c54 <__alltraps>

001026e4 <vector140>:
.globl vector140
vector140:
  pushl $0
  1026e4:	6a 00                	push   $0x0
  pushl $140
  1026e6:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1026eb:	e9 64 05 00 00       	jmp    102c54 <__alltraps>

001026f0 <vector141>:
.globl vector141
vector141:
  pushl $0
  1026f0:	6a 00                	push   $0x0
  pushl $141
  1026f2:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1026f7:	e9 58 05 00 00       	jmp    102c54 <__alltraps>

001026fc <vector142>:
.globl vector142
vector142:
  pushl $0
  1026fc:	6a 00                	push   $0x0
  pushl $142
  1026fe:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  102703:	e9 4c 05 00 00       	jmp    102c54 <__alltraps>

00102708 <vector143>:
.globl vector143
vector143:
  pushl $0
  102708:	6a 00                	push   $0x0
  pushl $143
  10270a:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  10270f:	e9 40 05 00 00       	jmp    102c54 <__alltraps>

00102714 <vector144>:
.globl vector144
vector144:
  pushl $0
  102714:	6a 00                	push   $0x0
  pushl $144
  102716:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  10271b:	e9 34 05 00 00       	jmp    102c54 <__alltraps>

00102720 <vector145>:
.globl vector145
vector145:
  pushl $0
  102720:	6a 00                	push   $0x0
  pushl $145
  102722:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102727:	e9 28 05 00 00       	jmp    102c54 <__alltraps>

0010272c <vector146>:
.globl vector146
vector146:
  pushl $0
  10272c:	6a 00                	push   $0x0
  pushl $146
  10272e:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  102733:	e9 1c 05 00 00       	jmp    102c54 <__alltraps>

00102738 <vector147>:
.globl vector147
vector147:
  pushl $0
  102738:	6a 00                	push   $0x0
  pushl $147
  10273a:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  10273f:	e9 10 05 00 00       	jmp    102c54 <__alltraps>

00102744 <vector148>:
.globl vector148
vector148:
  pushl $0
  102744:	6a 00                	push   $0x0
  pushl $148
  102746:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  10274b:	e9 04 05 00 00       	jmp    102c54 <__alltraps>

00102750 <vector149>:
.globl vector149
vector149:
  pushl $0
  102750:	6a 00                	push   $0x0
  pushl $149
  102752:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102757:	e9 f8 04 00 00       	jmp    102c54 <__alltraps>

0010275c <vector150>:
.globl vector150
vector150:
  pushl $0
  10275c:	6a 00                	push   $0x0
  pushl $150
  10275e:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  102763:	e9 ec 04 00 00       	jmp    102c54 <__alltraps>

00102768 <vector151>:
.globl vector151
vector151:
  pushl $0
  102768:	6a 00                	push   $0x0
  pushl $151
  10276a:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  10276f:	e9 e0 04 00 00       	jmp    102c54 <__alltraps>

00102774 <vector152>:
.globl vector152
vector152:
  pushl $0
  102774:	6a 00                	push   $0x0
  pushl $152
  102776:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  10277b:	e9 d4 04 00 00       	jmp    102c54 <__alltraps>

00102780 <vector153>:
.globl vector153
vector153:
  pushl $0
  102780:	6a 00                	push   $0x0
  pushl $153
  102782:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102787:	e9 c8 04 00 00       	jmp    102c54 <__alltraps>

0010278c <vector154>:
.globl vector154
vector154:
  pushl $0
  10278c:	6a 00                	push   $0x0
  pushl $154
  10278e:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  102793:	e9 bc 04 00 00       	jmp    102c54 <__alltraps>

00102798 <vector155>:
.globl vector155
vector155:
  pushl $0
  102798:	6a 00                	push   $0x0
  pushl $155
  10279a:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  10279f:	e9 b0 04 00 00       	jmp    102c54 <__alltraps>

001027a4 <vector156>:
.globl vector156
vector156:
  pushl $0
  1027a4:	6a 00                	push   $0x0
  pushl $156
  1027a6:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  1027ab:	e9 a4 04 00 00       	jmp    102c54 <__alltraps>

001027b0 <vector157>:
.globl vector157
vector157:
  pushl $0
  1027b0:	6a 00                	push   $0x0
  pushl $157
  1027b2:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  1027b7:	e9 98 04 00 00       	jmp    102c54 <__alltraps>

001027bc <vector158>:
.globl vector158
vector158:
  pushl $0
  1027bc:	6a 00                	push   $0x0
  pushl $158
  1027be:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  1027c3:	e9 8c 04 00 00       	jmp    102c54 <__alltraps>

001027c8 <vector159>:
.globl vector159
vector159:
  pushl $0
  1027c8:	6a 00                	push   $0x0
  pushl $159
  1027ca:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1027cf:	e9 80 04 00 00       	jmp    102c54 <__alltraps>

001027d4 <vector160>:
.globl vector160
vector160:
  pushl $0
  1027d4:	6a 00                	push   $0x0
  pushl $160
  1027d6:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1027db:	e9 74 04 00 00       	jmp    102c54 <__alltraps>

001027e0 <vector161>:
.globl vector161
vector161:
  pushl $0
  1027e0:	6a 00                	push   $0x0
  pushl $161
  1027e2:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1027e7:	e9 68 04 00 00       	jmp    102c54 <__alltraps>

001027ec <vector162>:
.globl vector162
vector162:
  pushl $0
  1027ec:	6a 00                	push   $0x0
  pushl $162
  1027ee:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1027f3:	e9 5c 04 00 00       	jmp    102c54 <__alltraps>

001027f8 <vector163>:
.globl vector163
vector163:
  pushl $0
  1027f8:	6a 00                	push   $0x0
  pushl $163
  1027fa:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1027ff:	e9 50 04 00 00       	jmp    102c54 <__alltraps>

00102804 <vector164>:
.globl vector164
vector164:
  pushl $0
  102804:	6a 00                	push   $0x0
  pushl $164
  102806:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  10280b:	e9 44 04 00 00       	jmp    102c54 <__alltraps>

00102810 <vector165>:
.globl vector165
vector165:
  pushl $0
  102810:	6a 00                	push   $0x0
  pushl $165
  102812:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  102817:	e9 38 04 00 00       	jmp    102c54 <__alltraps>

0010281c <vector166>:
.globl vector166
vector166:
  pushl $0
  10281c:	6a 00                	push   $0x0
  pushl $166
  10281e:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  102823:	e9 2c 04 00 00       	jmp    102c54 <__alltraps>

00102828 <vector167>:
.globl vector167
vector167:
  pushl $0
  102828:	6a 00                	push   $0x0
  pushl $167
  10282a:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  10282f:	e9 20 04 00 00       	jmp    102c54 <__alltraps>

00102834 <vector168>:
.globl vector168
vector168:
  pushl $0
  102834:	6a 00                	push   $0x0
  pushl $168
  102836:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  10283b:	e9 14 04 00 00       	jmp    102c54 <__alltraps>

00102840 <vector169>:
.globl vector169
vector169:
  pushl $0
  102840:	6a 00                	push   $0x0
  pushl $169
  102842:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102847:	e9 08 04 00 00       	jmp    102c54 <__alltraps>

0010284c <vector170>:
.globl vector170
vector170:
  pushl $0
  10284c:	6a 00                	push   $0x0
  pushl $170
  10284e:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  102853:	e9 fc 03 00 00       	jmp    102c54 <__alltraps>

00102858 <vector171>:
.globl vector171
vector171:
  pushl $0
  102858:	6a 00                	push   $0x0
  pushl $171
  10285a:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  10285f:	e9 f0 03 00 00       	jmp    102c54 <__alltraps>

00102864 <vector172>:
.globl vector172
vector172:
  pushl $0
  102864:	6a 00                	push   $0x0
  pushl $172
  102866:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  10286b:	e9 e4 03 00 00       	jmp    102c54 <__alltraps>

00102870 <vector173>:
.globl vector173
vector173:
  pushl $0
  102870:	6a 00                	push   $0x0
  pushl $173
  102872:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102877:	e9 d8 03 00 00       	jmp    102c54 <__alltraps>

0010287c <vector174>:
.globl vector174
vector174:
  pushl $0
  10287c:	6a 00                	push   $0x0
  pushl $174
  10287e:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  102883:	e9 cc 03 00 00       	jmp    102c54 <__alltraps>

00102888 <vector175>:
.globl vector175
vector175:
  pushl $0
  102888:	6a 00                	push   $0x0
  pushl $175
  10288a:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  10288f:	e9 c0 03 00 00       	jmp    102c54 <__alltraps>

00102894 <vector176>:
.globl vector176
vector176:
  pushl $0
  102894:	6a 00                	push   $0x0
  pushl $176
  102896:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  10289b:	e9 b4 03 00 00       	jmp    102c54 <__alltraps>

001028a0 <vector177>:
.globl vector177
vector177:
  pushl $0
  1028a0:	6a 00                	push   $0x0
  pushl $177
  1028a2:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  1028a7:	e9 a8 03 00 00       	jmp    102c54 <__alltraps>

001028ac <vector178>:
.globl vector178
vector178:
  pushl $0
  1028ac:	6a 00                	push   $0x0
  pushl $178
  1028ae:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  1028b3:	e9 9c 03 00 00       	jmp    102c54 <__alltraps>

001028b8 <vector179>:
.globl vector179
vector179:
  pushl $0
  1028b8:	6a 00                	push   $0x0
  pushl $179
  1028ba:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  1028bf:	e9 90 03 00 00       	jmp    102c54 <__alltraps>

001028c4 <vector180>:
.globl vector180
vector180:
  pushl $0
  1028c4:	6a 00                	push   $0x0
  pushl $180
  1028c6:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1028cb:	e9 84 03 00 00       	jmp    102c54 <__alltraps>

001028d0 <vector181>:
.globl vector181
vector181:
  pushl $0
  1028d0:	6a 00                	push   $0x0
  pushl $181
  1028d2:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1028d7:	e9 78 03 00 00       	jmp    102c54 <__alltraps>

001028dc <vector182>:
.globl vector182
vector182:
  pushl $0
  1028dc:	6a 00                	push   $0x0
  pushl $182
  1028de:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1028e3:	e9 6c 03 00 00       	jmp    102c54 <__alltraps>

001028e8 <vector183>:
.globl vector183
vector183:
  pushl $0
  1028e8:	6a 00                	push   $0x0
  pushl $183
  1028ea:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1028ef:	e9 60 03 00 00       	jmp    102c54 <__alltraps>

001028f4 <vector184>:
.globl vector184
vector184:
  pushl $0
  1028f4:	6a 00                	push   $0x0
  pushl $184
  1028f6:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1028fb:	e9 54 03 00 00       	jmp    102c54 <__alltraps>

00102900 <vector185>:
.globl vector185
vector185:
  pushl $0
  102900:	6a 00                	push   $0x0
  pushl $185
  102902:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102907:	e9 48 03 00 00       	jmp    102c54 <__alltraps>

0010290c <vector186>:
.globl vector186
vector186:
  pushl $0
  10290c:	6a 00                	push   $0x0
  pushl $186
  10290e:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  102913:	e9 3c 03 00 00       	jmp    102c54 <__alltraps>

00102918 <vector187>:
.globl vector187
vector187:
  pushl $0
  102918:	6a 00                	push   $0x0
  pushl $187
  10291a:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  10291f:	e9 30 03 00 00       	jmp    102c54 <__alltraps>

00102924 <vector188>:
.globl vector188
vector188:
  pushl $0
  102924:	6a 00                	push   $0x0
  pushl $188
  102926:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  10292b:	e9 24 03 00 00       	jmp    102c54 <__alltraps>

00102930 <vector189>:
.globl vector189
vector189:
  pushl $0
  102930:	6a 00                	push   $0x0
  pushl $189
  102932:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102937:	e9 18 03 00 00       	jmp    102c54 <__alltraps>

0010293c <vector190>:
.globl vector190
vector190:
  pushl $0
  10293c:	6a 00                	push   $0x0
  pushl $190
  10293e:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  102943:	e9 0c 03 00 00       	jmp    102c54 <__alltraps>

00102948 <vector191>:
.globl vector191
vector191:
  pushl $0
  102948:	6a 00                	push   $0x0
  pushl $191
  10294a:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  10294f:	e9 00 03 00 00       	jmp    102c54 <__alltraps>

00102954 <vector192>:
.globl vector192
vector192:
  pushl $0
  102954:	6a 00                	push   $0x0
  pushl $192
  102956:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  10295b:	e9 f4 02 00 00       	jmp    102c54 <__alltraps>

00102960 <vector193>:
.globl vector193
vector193:
  pushl $0
  102960:	6a 00                	push   $0x0
  pushl $193
  102962:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102967:	e9 e8 02 00 00       	jmp    102c54 <__alltraps>

0010296c <vector194>:
.globl vector194
vector194:
  pushl $0
  10296c:	6a 00                	push   $0x0
  pushl $194
  10296e:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102973:	e9 dc 02 00 00       	jmp    102c54 <__alltraps>

00102978 <vector195>:
.globl vector195
vector195:
  pushl $0
  102978:	6a 00                	push   $0x0
  pushl $195
  10297a:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  10297f:	e9 d0 02 00 00       	jmp    102c54 <__alltraps>

00102984 <vector196>:
.globl vector196
vector196:
  pushl $0
  102984:	6a 00                	push   $0x0
  pushl $196
  102986:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  10298b:	e9 c4 02 00 00       	jmp    102c54 <__alltraps>

00102990 <vector197>:
.globl vector197
vector197:
  pushl $0
  102990:	6a 00                	push   $0x0
  pushl $197
  102992:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102997:	e9 b8 02 00 00       	jmp    102c54 <__alltraps>

0010299c <vector198>:
.globl vector198
vector198:
  pushl $0
  10299c:	6a 00                	push   $0x0
  pushl $198
  10299e:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  1029a3:	e9 ac 02 00 00       	jmp    102c54 <__alltraps>

001029a8 <vector199>:
.globl vector199
vector199:
  pushl $0
  1029a8:	6a 00                	push   $0x0
  pushl $199
  1029aa:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  1029af:	e9 a0 02 00 00       	jmp    102c54 <__alltraps>

001029b4 <vector200>:
.globl vector200
vector200:
  pushl $0
  1029b4:	6a 00                	push   $0x0
  pushl $200
  1029b6:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  1029bb:	e9 94 02 00 00       	jmp    102c54 <__alltraps>

001029c0 <vector201>:
.globl vector201
vector201:
  pushl $0
  1029c0:	6a 00                	push   $0x0
  pushl $201
  1029c2:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1029c7:	e9 88 02 00 00       	jmp    102c54 <__alltraps>

001029cc <vector202>:
.globl vector202
vector202:
  pushl $0
  1029cc:	6a 00                	push   $0x0
  pushl $202
  1029ce:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1029d3:	e9 7c 02 00 00       	jmp    102c54 <__alltraps>

001029d8 <vector203>:
.globl vector203
vector203:
  pushl $0
  1029d8:	6a 00                	push   $0x0
  pushl $203
  1029da:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  1029df:	e9 70 02 00 00       	jmp    102c54 <__alltraps>

001029e4 <vector204>:
.globl vector204
vector204:
  pushl $0
  1029e4:	6a 00                	push   $0x0
  pushl $204
  1029e6:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1029eb:	e9 64 02 00 00       	jmp    102c54 <__alltraps>

001029f0 <vector205>:
.globl vector205
vector205:
  pushl $0
  1029f0:	6a 00                	push   $0x0
  pushl $205
  1029f2:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  1029f7:	e9 58 02 00 00       	jmp    102c54 <__alltraps>

001029fc <vector206>:
.globl vector206
vector206:
  pushl $0
  1029fc:	6a 00                	push   $0x0
  pushl $206
  1029fe:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102a03:	e9 4c 02 00 00       	jmp    102c54 <__alltraps>

00102a08 <vector207>:
.globl vector207
vector207:
  pushl $0
  102a08:	6a 00                	push   $0x0
  pushl $207
  102a0a:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102a0f:	e9 40 02 00 00       	jmp    102c54 <__alltraps>

00102a14 <vector208>:
.globl vector208
vector208:
  pushl $0
  102a14:	6a 00                	push   $0x0
  pushl $208
  102a16:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102a1b:	e9 34 02 00 00       	jmp    102c54 <__alltraps>

00102a20 <vector209>:
.globl vector209
vector209:
  pushl $0
  102a20:	6a 00                	push   $0x0
  pushl $209
  102a22:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102a27:	e9 28 02 00 00       	jmp    102c54 <__alltraps>

00102a2c <vector210>:
.globl vector210
vector210:
  pushl $0
  102a2c:	6a 00                	push   $0x0
  pushl $210
  102a2e:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102a33:	e9 1c 02 00 00       	jmp    102c54 <__alltraps>

00102a38 <vector211>:
.globl vector211
vector211:
  pushl $0
  102a38:	6a 00                	push   $0x0
  pushl $211
  102a3a:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102a3f:	e9 10 02 00 00       	jmp    102c54 <__alltraps>

00102a44 <vector212>:
.globl vector212
vector212:
  pushl $0
  102a44:	6a 00                	push   $0x0
  pushl $212
  102a46:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102a4b:	e9 04 02 00 00       	jmp    102c54 <__alltraps>

00102a50 <vector213>:
.globl vector213
vector213:
  pushl $0
  102a50:	6a 00                	push   $0x0
  pushl $213
  102a52:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102a57:	e9 f8 01 00 00       	jmp    102c54 <__alltraps>

00102a5c <vector214>:
.globl vector214
vector214:
  pushl $0
  102a5c:	6a 00                	push   $0x0
  pushl $214
  102a5e:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102a63:	e9 ec 01 00 00       	jmp    102c54 <__alltraps>

00102a68 <vector215>:
.globl vector215
vector215:
  pushl $0
  102a68:	6a 00                	push   $0x0
  pushl $215
  102a6a:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102a6f:	e9 e0 01 00 00       	jmp    102c54 <__alltraps>

00102a74 <vector216>:
.globl vector216
vector216:
  pushl $0
  102a74:	6a 00                	push   $0x0
  pushl $216
  102a76:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102a7b:	e9 d4 01 00 00       	jmp    102c54 <__alltraps>

00102a80 <vector217>:
.globl vector217
vector217:
  pushl $0
  102a80:	6a 00                	push   $0x0
  pushl $217
  102a82:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102a87:	e9 c8 01 00 00       	jmp    102c54 <__alltraps>

00102a8c <vector218>:
.globl vector218
vector218:
  pushl $0
  102a8c:	6a 00                	push   $0x0
  pushl $218
  102a8e:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102a93:	e9 bc 01 00 00       	jmp    102c54 <__alltraps>

00102a98 <vector219>:
.globl vector219
vector219:
  pushl $0
  102a98:	6a 00                	push   $0x0
  pushl $219
  102a9a:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102a9f:	e9 b0 01 00 00       	jmp    102c54 <__alltraps>

00102aa4 <vector220>:
.globl vector220
vector220:
  pushl $0
  102aa4:	6a 00                	push   $0x0
  pushl $220
  102aa6:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102aab:	e9 a4 01 00 00       	jmp    102c54 <__alltraps>

00102ab0 <vector221>:
.globl vector221
vector221:
  pushl $0
  102ab0:	6a 00                	push   $0x0
  pushl $221
  102ab2:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102ab7:	e9 98 01 00 00       	jmp    102c54 <__alltraps>

00102abc <vector222>:
.globl vector222
vector222:
  pushl $0
  102abc:	6a 00                	push   $0x0
  pushl $222
  102abe:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102ac3:	e9 8c 01 00 00       	jmp    102c54 <__alltraps>

00102ac8 <vector223>:
.globl vector223
vector223:
  pushl $0
  102ac8:	6a 00                	push   $0x0
  pushl $223
  102aca:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102acf:	e9 80 01 00 00       	jmp    102c54 <__alltraps>

00102ad4 <vector224>:
.globl vector224
vector224:
  pushl $0
  102ad4:	6a 00                	push   $0x0
  pushl $224
  102ad6:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102adb:	e9 74 01 00 00       	jmp    102c54 <__alltraps>

00102ae0 <vector225>:
.globl vector225
vector225:
  pushl $0
  102ae0:	6a 00                	push   $0x0
  pushl $225
  102ae2:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  102ae7:	e9 68 01 00 00       	jmp    102c54 <__alltraps>

00102aec <vector226>:
.globl vector226
vector226:
  pushl $0
  102aec:	6a 00                	push   $0x0
  pushl $226
  102aee:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102af3:	e9 5c 01 00 00       	jmp    102c54 <__alltraps>

00102af8 <vector227>:
.globl vector227
vector227:
  pushl $0
  102af8:	6a 00                	push   $0x0
  pushl $227
  102afa:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102aff:	e9 50 01 00 00       	jmp    102c54 <__alltraps>

00102b04 <vector228>:
.globl vector228
vector228:
  pushl $0
  102b04:	6a 00                	push   $0x0
  pushl $228
  102b06:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102b0b:	e9 44 01 00 00       	jmp    102c54 <__alltraps>

00102b10 <vector229>:
.globl vector229
vector229:
  pushl $0
  102b10:	6a 00                	push   $0x0
  pushl $229
  102b12:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102b17:	e9 38 01 00 00       	jmp    102c54 <__alltraps>

00102b1c <vector230>:
.globl vector230
vector230:
  pushl $0
  102b1c:	6a 00                	push   $0x0
  pushl $230
  102b1e:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102b23:	e9 2c 01 00 00       	jmp    102c54 <__alltraps>

00102b28 <vector231>:
.globl vector231
vector231:
  pushl $0
  102b28:	6a 00                	push   $0x0
  pushl $231
  102b2a:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102b2f:	e9 20 01 00 00       	jmp    102c54 <__alltraps>

00102b34 <vector232>:
.globl vector232
vector232:
  pushl $0
  102b34:	6a 00                	push   $0x0
  pushl $232
  102b36:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102b3b:	e9 14 01 00 00       	jmp    102c54 <__alltraps>

00102b40 <vector233>:
.globl vector233
vector233:
  pushl $0
  102b40:	6a 00                	push   $0x0
  pushl $233
  102b42:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102b47:	e9 08 01 00 00       	jmp    102c54 <__alltraps>

00102b4c <vector234>:
.globl vector234
vector234:
  pushl $0
  102b4c:	6a 00                	push   $0x0
  pushl $234
  102b4e:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102b53:	e9 fc 00 00 00       	jmp    102c54 <__alltraps>

00102b58 <vector235>:
.globl vector235
vector235:
  pushl $0
  102b58:	6a 00                	push   $0x0
  pushl $235
  102b5a:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102b5f:	e9 f0 00 00 00       	jmp    102c54 <__alltraps>

00102b64 <vector236>:
.globl vector236
vector236:
  pushl $0
  102b64:	6a 00                	push   $0x0
  pushl $236
  102b66:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102b6b:	e9 e4 00 00 00       	jmp    102c54 <__alltraps>

00102b70 <vector237>:
.globl vector237
vector237:
  pushl $0
  102b70:	6a 00                	push   $0x0
  pushl $237
  102b72:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102b77:	e9 d8 00 00 00       	jmp    102c54 <__alltraps>

00102b7c <vector238>:
.globl vector238
vector238:
  pushl $0
  102b7c:	6a 00                	push   $0x0
  pushl $238
  102b7e:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102b83:	e9 cc 00 00 00       	jmp    102c54 <__alltraps>

00102b88 <vector239>:
.globl vector239
vector239:
  pushl $0
  102b88:	6a 00                	push   $0x0
  pushl $239
  102b8a:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102b8f:	e9 c0 00 00 00       	jmp    102c54 <__alltraps>

00102b94 <vector240>:
.globl vector240
vector240:
  pushl $0
  102b94:	6a 00                	push   $0x0
  pushl $240
  102b96:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102b9b:	e9 b4 00 00 00       	jmp    102c54 <__alltraps>

00102ba0 <vector241>:
.globl vector241
vector241:
  pushl $0
  102ba0:	6a 00                	push   $0x0
  pushl $241
  102ba2:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102ba7:	e9 a8 00 00 00       	jmp    102c54 <__alltraps>

00102bac <vector242>:
.globl vector242
vector242:
  pushl $0
  102bac:	6a 00                	push   $0x0
  pushl $242
  102bae:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102bb3:	e9 9c 00 00 00       	jmp    102c54 <__alltraps>

00102bb8 <vector243>:
.globl vector243
vector243:
  pushl $0
  102bb8:	6a 00                	push   $0x0
  pushl $243
  102bba:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102bbf:	e9 90 00 00 00       	jmp    102c54 <__alltraps>

00102bc4 <vector244>:
.globl vector244
vector244:
  pushl $0
  102bc4:	6a 00                	push   $0x0
  pushl $244
  102bc6:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102bcb:	e9 84 00 00 00       	jmp    102c54 <__alltraps>

00102bd0 <vector245>:
.globl vector245
vector245:
  pushl $0
  102bd0:	6a 00                	push   $0x0
  pushl $245
  102bd2:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102bd7:	e9 78 00 00 00       	jmp    102c54 <__alltraps>

00102bdc <vector246>:
.globl vector246
vector246:
  pushl $0
  102bdc:	6a 00                	push   $0x0
  pushl $246
  102bde:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102be3:	e9 6c 00 00 00       	jmp    102c54 <__alltraps>

00102be8 <vector247>:
.globl vector247
vector247:
  pushl $0
  102be8:	6a 00                	push   $0x0
  pushl $247
  102bea:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102bef:	e9 60 00 00 00       	jmp    102c54 <__alltraps>

00102bf4 <vector248>:
.globl vector248
vector248:
  pushl $0
  102bf4:	6a 00                	push   $0x0
  pushl $248
  102bf6:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102bfb:	e9 54 00 00 00       	jmp    102c54 <__alltraps>

00102c00 <vector249>:
.globl vector249
vector249:
  pushl $0
  102c00:	6a 00                	push   $0x0
  pushl $249
  102c02:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102c07:	e9 48 00 00 00       	jmp    102c54 <__alltraps>

00102c0c <vector250>:
.globl vector250
vector250:
  pushl $0
  102c0c:	6a 00                	push   $0x0
  pushl $250
  102c0e:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102c13:	e9 3c 00 00 00       	jmp    102c54 <__alltraps>

00102c18 <vector251>:
.globl vector251
vector251:
  pushl $0
  102c18:	6a 00                	push   $0x0
  pushl $251
  102c1a:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102c1f:	e9 30 00 00 00       	jmp    102c54 <__alltraps>

00102c24 <vector252>:
.globl vector252
vector252:
  pushl $0
  102c24:	6a 00                	push   $0x0
  pushl $252
  102c26:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102c2b:	e9 24 00 00 00       	jmp    102c54 <__alltraps>

00102c30 <vector253>:
.globl vector253
vector253:
  pushl $0
  102c30:	6a 00                	push   $0x0
  pushl $253
  102c32:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102c37:	e9 18 00 00 00       	jmp    102c54 <__alltraps>

00102c3c <vector254>:
.globl vector254
vector254:
  pushl $0
  102c3c:	6a 00                	push   $0x0
  pushl $254
  102c3e:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102c43:	e9 0c 00 00 00       	jmp    102c54 <__alltraps>

00102c48 <vector255>:
.globl vector255
vector255:
  pushl $0
  102c48:	6a 00                	push   $0x0
  pushl $255
  102c4a:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102c4f:	e9 00 00 00 00       	jmp    102c54 <__alltraps>

00102c54 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  102c54:	1e                   	push   %ds
    pushl %es
  102c55:	06                   	push   %es
    pushl %fs
  102c56:	0f a0                	push   %fs
    pushl %gs
  102c58:	0f a8                	push   %gs
    pushal
  102c5a:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  102c5b:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  102c60:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  102c62:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  102c64:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  102c65:	e8 61 f5 ff ff       	call   1021cb <trap>

    # pop the pushed stack pointer
    popl %esp
  102c6a:	5c                   	pop    %esp

00102c6b <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  102c6b:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  102c6c:	0f a9                	pop    %gs
    popl %fs
  102c6e:	0f a1                	pop    %fs
    popl %es
  102c70:	07                   	pop    %es
    popl %ds
  102c71:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  102c72:	83 c4 08             	add    $0x8,%esp
    iret
  102c75:	cf                   	iret   

00102c76 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102c76:	55                   	push   %ebp
  102c77:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102c79:	8b 45 08             	mov    0x8(%ebp),%eax
  102c7c:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102c7f:	b8 23 00 00 00       	mov    $0x23,%eax
  102c84:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102c86:	b8 23 00 00 00       	mov    $0x23,%eax
  102c8b:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102c8d:	b8 10 00 00 00       	mov    $0x10,%eax
  102c92:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102c94:	b8 10 00 00 00       	mov    $0x10,%eax
  102c99:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102c9b:	b8 10 00 00 00       	mov    $0x10,%eax
  102ca0:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102ca2:	ea a9 2c 10 00 08 00 	ljmp   $0x8,$0x102ca9
}
  102ca9:	90                   	nop
  102caa:	5d                   	pop    %ebp
  102cab:	c3                   	ret    

00102cac <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102cac:	55                   	push   %ebp
  102cad:	89 e5                	mov    %esp,%ebp
  102caf:	83 ec 10             	sub    $0x10,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  102cb2:	b8 40 19 11 00       	mov    $0x111940,%eax
  102cb7:	05 00 04 00 00       	add    $0x400,%eax
  102cbc:	a3 c4 18 11 00       	mov    %eax,0x1118c4
    ts.ts_ss0 = KERNEL_DS;
  102cc1:	66 c7 05 c8 18 11 00 	movw   $0x10,0x1118c8
  102cc8:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  102cca:	66 c7 05 08 0a 11 00 	movw   $0x68,0x110a08
  102cd1:	68 00 
  102cd3:	b8 c0 18 11 00       	mov    $0x1118c0,%eax
  102cd8:	66 a3 0a 0a 11 00    	mov    %ax,0x110a0a
  102cde:	b8 c0 18 11 00       	mov    $0x1118c0,%eax
  102ce3:	c1 e8 10             	shr    $0x10,%eax
  102ce6:	a2 0c 0a 11 00       	mov    %al,0x110a0c
  102ceb:	0f b6 05 0d 0a 11 00 	movzbl 0x110a0d,%eax
  102cf2:	83 e0 f0             	and    $0xfffffff0,%eax
  102cf5:	83 c8 09             	or     $0x9,%eax
  102cf8:	a2 0d 0a 11 00       	mov    %al,0x110a0d
  102cfd:	0f b6 05 0d 0a 11 00 	movzbl 0x110a0d,%eax
  102d04:	83 c8 10             	or     $0x10,%eax
  102d07:	a2 0d 0a 11 00       	mov    %al,0x110a0d
  102d0c:	0f b6 05 0d 0a 11 00 	movzbl 0x110a0d,%eax
  102d13:	83 e0 9f             	and    $0xffffff9f,%eax
  102d16:	a2 0d 0a 11 00       	mov    %al,0x110a0d
  102d1b:	0f b6 05 0d 0a 11 00 	movzbl 0x110a0d,%eax
  102d22:	83 c8 80             	or     $0xffffff80,%eax
  102d25:	a2 0d 0a 11 00       	mov    %al,0x110a0d
  102d2a:	0f b6 05 0e 0a 11 00 	movzbl 0x110a0e,%eax
  102d31:	83 e0 f0             	and    $0xfffffff0,%eax
  102d34:	a2 0e 0a 11 00       	mov    %al,0x110a0e
  102d39:	0f b6 05 0e 0a 11 00 	movzbl 0x110a0e,%eax
  102d40:	83 e0 ef             	and    $0xffffffef,%eax
  102d43:	a2 0e 0a 11 00       	mov    %al,0x110a0e
  102d48:	0f b6 05 0e 0a 11 00 	movzbl 0x110a0e,%eax
  102d4f:	83 e0 df             	and    $0xffffffdf,%eax
  102d52:	a2 0e 0a 11 00       	mov    %al,0x110a0e
  102d57:	0f b6 05 0e 0a 11 00 	movzbl 0x110a0e,%eax
  102d5e:	83 c8 40             	or     $0x40,%eax
  102d61:	a2 0e 0a 11 00       	mov    %al,0x110a0e
  102d66:	0f b6 05 0e 0a 11 00 	movzbl 0x110a0e,%eax
  102d6d:	83 e0 7f             	and    $0x7f,%eax
  102d70:	a2 0e 0a 11 00       	mov    %al,0x110a0e
  102d75:	b8 c0 18 11 00       	mov    $0x1118c0,%eax
  102d7a:	c1 e8 18             	shr    $0x18,%eax
  102d7d:	a2 0f 0a 11 00       	mov    %al,0x110a0f
    gdt[SEG_TSS].sd_s = 0;
  102d82:	0f b6 05 0d 0a 11 00 	movzbl 0x110a0d,%eax
  102d89:	83 e0 ef             	and    $0xffffffef,%eax
  102d8c:	a2 0d 0a 11 00       	mov    %al,0x110a0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102d91:	68 10 0a 11 00       	push   $0x110a10
  102d96:	e8 db fe ff ff       	call   102c76 <lgdt>
  102d9b:	83 c4 04             	add    $0x4,%esp
  102d9e:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102da4:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102da8:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  102dab:	90                   	nop
  102dac:	c9                   	leave  
  102dad:	c3                   	ret    

00102dae <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  102dae:	55                   	push   %ebp
  102daf:	89 e5                	mov    %esp,%ebp
    gdt_init();
  102db1:	e8 f6 fe ff ff       	call   102cac <gdt_init>
}
  102db6:	90                   	nop
  102db7:	5d                   	pop    %ebp
  102db8:	c3                   	ret    

00102db9 <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  102db9:	55                   	push   %ebp
  102dba:	89 e5                	mov    %esp,%ebp
  102dbc:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102dbf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  102dc6:	eb 04                	jmp    102dcc <strlen+0x13>
        cnt ++;
  102dc8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (*s ++ != '\0') {
  102dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  102dcf:	8d 50 01             	lea    0x1(%eax),%edx
  102dd2:	89 55 08             	mov    %edx,0x8(%ebp)
  102dd5:	0f b6 00             	movzbl (%eax),%eax
  102dd8:	84 c0                	test   %al,%al
  102dda:	75 ec                	jne    102dc8 <strlen+0xf>
    }
    return cnt;
  102ddc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102ddf:	c9                   	leave  
  102de0:	c3                   	ret    

00102de1 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  102de1:	55                   	push   %ebp
  102de2:	89 e5                	mov    %esp,%ebp
  102de4:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102de7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102dee:	eb 04                	jmp    102df4 <strnlen+0x13>
        cnt ++;
  102df0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102df4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102df7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  102dfa:	73 10                	jae    102e0c <strnlen+0x2b>
  102dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  102dff:	8d 50 01             	lea    0x1(%eax),%edx
  102e02:	89 55 08             	mov    %edx,0x8(%ebp)
  102e05:	0f b6 00             	movzbl (%eax),%eax
  102e08:	84 c0                	test   %al,%al
  102e0a:	75 e4                	jne    102df0 <strnlen+0xf>
    }
    return cnt;
  102e0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102e0f:	c9                   	leave  
  102e10:	c3                   	ret    

00102e11 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  102e11:	55                   	push   %ebp
  102e12:	89 e5                	mov    %esp,%ebp
  102e14:	57                   	push   %edi
  102e15:	56                   	push   %esi
  102e16:	83 ec 20             	sub    $0x20,%esp
  102e19:	8b 45 08             	mov    0x8(%ebp),%eax
  102e1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102e1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e22:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  102e25:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102e28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e2b:	89 d1                	mov    %edx,%ecx
  102e2d:	89 c2                	mov    %eax,%edx
  102e2f:	89 ce                	mov    %ecx,%esi
  102e31:	89 d7                	mov    %edx,%edi
  102e33:	ac                   	lods   %ds:(%esi),%al
  102e34:	aa                   	stos   %al,%es:(%edi)
  102e35:	84 c0                	test   %al,%al
  102e37:	75 fa                	jne    102e33 <strcpy+0x22>
  102e39:	89 fa                	mov    %edi,%edx
  102e3b:	89 f1                	mov    %esi,%ecx
  102e3d:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102e40:	89 55 e8             	mov    %edx,-0x18(%ebp)
  102e43:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  102e46:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
  102e49:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  102e4a:	83 c4 20             	add    $0x20,%esp
  102e4d:	5e                   	pop    %esi
  102e4e:	5f                   	pop    %edi
  102e4f:	5d                   	pop    %ebp
  102e50:	c3                   	ret    

00102e51 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  102e51:	55                   	push   %ebp
  102e52:	89 e5                	mov    %esp,%ebp
  102e54:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  102e57:	8b 45 08             	mov    0x8(%ebp),%eax
  102e5a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  102e5d:	eb 21                	jmp    102e80 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  102e5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e62:	0f b6 10             	movzbl (%eax),%edx
  102e65:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102e68:	88 10                	mov    %dl,(%eax)
  102e6a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102e6d:	0f b6 00             	movzbl (%eax),%eax
  102e70:	84 c0                	test   %al,%al
  102e72:	74 04                	je     102e78 <strncpy+0x27>
            src ++;
  102e74:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  102e78:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  102e7c:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    while (len > 0) {
  102e80:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102e84:	75 d9                	jne    102e5f <strncpy+0xe>
    }
    return dst;
  102e86:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102e89:	c9                   	leave  
  102e8a:	c3                   	ret    

00102e8b <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  102e8b:	55                   	push   %ebp
  102e8c:	89 e5                	mov    %esp,%ebp
  102e8e:	57                   	push   %edi
  102e8f:	56                   	push   %esi
  102e90:	83 ec 20             	sub    $0x20,%esp
  102e93:	8b 45 08             	mov    0x8(%ebp),%eax
  102e96:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102e99:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  102e9f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102ea2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ea5:	89 d1                	mov    %edx,%ecx
  102ea7:	89 c2                	mov    %eax,%edx
  102ea9:	89 ce                	mov    %ecx,%esi
  102eab:	89 d7                	mov    %edx,%edi
  102ead:	ac                   	lods   %ds:(%esi),%al
  102eae:	ae                   	scas   %es:(%edi),%al
  102eaf:	75 08                	jne    102eb9 <strcmp+0x2e>
  102eb1:	84 c0                	test   %al,%al
  102eb3:	75 f8                	jne    102ead <strcmp+0x22>
  102eb5:	31 c0                	xor    %eax,%eax
  102eb7:	eb 04                	jmp    102ebd <strcmp+0x32>
  102eb9:	19 c0                	sbb    %eax,%eax
  102ebb:	0c 01                	or     $0x1,%al
  102ebd:	89 fa                	mov    %edi,%edx
  102ebf:	89 f1                	mov    %esi,%ecx
  102ec1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102ec4:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102ec7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  102eca:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
  102ecd:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  102ece:	83 c4 20             	add    $0x20,%esp
  102ed1:	5e                   	pop    %esi
  102ed2:	5f                   	pop    %edi
  102ed3:	5d                   	pop    %ebp
  102ed4:	c3                   	ret    

00102ed5 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  102ed5:	55                   	push   %ebp
  102ed6:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102ed8:	eb 0c                	jmp    102ee6 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  102eda:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102ede:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102ee2:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102ee6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102eea:	74 1a                	je     102f06 <strncmp+0x31>
  102eec:	8b 45 08             	mov    0x8(%ebp),%eax
  102eef:	0f b6 00             	movzbl (%eax),%eax
  102ef2:	84 c0                	test   %al,%al
  102ef4:	74 10                	je     102f06 <strncmp+0x31>
  102ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  102ef9:	0f b6 10             	movzbl (%eax),%edx
  102efc:	8b 45 0c             	mov    0xc(%ebp),%eax
  102eff:	0f b6 00             	movzbl (%eax),%eax
  102f02:	38 c2                	cmp    %al,%dl
  102f04:	74 d4                	je     102eda <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  102f06:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102f0a:	74 18                	je     102f24 <strncmp+0x4f>
  102f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  102f0f:	0f b6 00             	movzbl (%eax),%eax
  102f12:	0f b6 d0             	movzbl %al,%edx
  102f15:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f18:	0f b6 00             	movzbl (%eax),%eax
  102f1b:	0f b6 c0             	movzbl %al,%eax
  102f1e:	29 c2                	sub    %eax,%edx
  102f20:	89 d0                	mov    %edx,%eax
  102f22:	eb 05                	jmp    102f29 <strncmp+0x54>
  102f24:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102f29:	5d                   	pop    %ebp
  102f2a:	c3                   	ret    

00102f2b <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  102f2b:	55                   	push   %ebp
  102f2c:	89 e5                	mov    %esp,%ebp
  102f2e:	83 ec 04             	sub    $0x4,%esp
  102f31:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f34:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102f37:	eb 14                	jmp    102f4d <strchr+0x22>
        if (*s == c) {
  102f39:	8b 45 08             	mov    0x8(%ebp),%eax
  102f3c:	0f b6 00             	movzbl (%eax),%eax
  102f3f:	38 45 fc             	cmp    %al,-0x4(%ebp)
  102f42:	75 05                	jne    102f49 <strchr+0x1e>
            return (char *)s;
  102f44:	8b 45 08             	mov    0x8(%ebp),%eax
  102f47:	eb 13                	jmp    102f5c <strchr+0x31>
        }
        s ++;
  102f49:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
  102f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  102f50:	0f b6 00             	movzbl (%eax),%eax
  102f53:	84 c0                	test   %al,%al
  102f55:	75 e2                	jne    102f39 <strchr+0xe>
    }
    return NULL;
  102f57:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102f5c:	c9                   	leave  
  102f5d:	c3                   	ret    

00102f5e <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  102f5e:	55                   	push   %ebp
  102f5f:	89 e5                	mov    %esp,%ebp
  102f61:	83 ec 04             	sub    $0x4,%esp
  102f64:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f67:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102f6a:	eb 0f                	jmp    102f7b <strfind+0x1d>
        if (*s == c) {
  102f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  102f6f:	0f b6 00             	movzbl (%eax),%eax
  102f72:	38 45 fc             	cmp    %al,-0x4(%ebp)
  102f75:	74 10                	je     102f87 <strfind+0x29>
            break;
        }
        s ++;
  102f77:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
  102f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  102f7e:	0f b6 00             	movzbl (%eax),%eax
  102f81:	84 c0                	test   %al,%al
  102f83:	75 e7                	jne    102f6c <strfind+0xe>
  102f85:	eb 01                	jmp    102f88 <strfind+0x2a>
            break;
  102f87:	90                   	nop
    }
    return (char *)s;
  102f88:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102f8b:	c9                   	leave  
  102f8c:	c3                   	ret    

00102f8d <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  102f8d:	55                   	push   %ebp
  102f8e:	89 e5                	mov    %esp,%ebp
  102f90:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  102f93:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  102f9a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  102fa1:	eb 04                	jmp    102fa7 <strtol+0x1a>
        s ++;
  102fa3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  102fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  102faa:	0f b6 00             	movzbl (%eax),%eax
  102fad:	3c 20                	cmp    $0x20,%al
  102faf:	74 f2                	je     102fa3 <strtol+0x16>
  102fb1:	8b 45 08             	mov    0x8(%ebp),%eax
  102fb4:	0f b6 00             	movzbl (%eax),%eax
  102fb7:	3c 09                	cmp    $0x9,%al
  102fb9:	74 e8                	je     102fa3 <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
  102fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  102fbe:	0f b6 00             	movzbl (%eax),%eax
  102fc1:	3c 2b                	cmp    $0x2b,%al
  102fc3:	75 06                	jne    102fcb <strtol+0x3e>
        s ++;
  102fc5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102fc9:	eb 15                	jmp    102fe0 <strtol+0x53>
    }
    else if (*s == '-') {
  102fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  102fce:	0f b6 00             	movzbl (%eax),%eax
  102fd1:	3c 2d                	cmp    $0x2d,%al
  102fd3:	75 0b                	jne    102fe0 <strtol+0x53>
        s ++, neg = 1;
  102fd5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102fd9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  102fe0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102fe4:	74 06                	je     102fec <strtol+0x5f>
  102fe6:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  102fea:	75 24                	jne    103010 <strtol+0x83>
  102fec:	8b 45 08             	mov    0x8(%ebp),%eax
  102fef:	0f b6 00             	movzbl (%eax),%eax
  102ff2:	3c 30                	cmp    $0x30,%al
  102ff4:	75 1a                	jne    103010 <strtol+0x83>
  102ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  102ff9:	83 c0 01             	add    $0x1,%eax
  102ffc:	0f b6 00             	movzbl (%eax),%eax
  102fff:	3c 78                	cmp    $0x78,%al
  103001:	75 0d                	jne    103010 <strtol+0x83>
        s += 2, base = 16;
  103003:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  103007:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  10300e:	eb 2a                	jmp    10303a <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  103010:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103014:	75 17                	jne    10302d <strtol+0xa0>
  103016:	8b 45 08             	mov    0x8(%ebp),%eax
  103019:	0f b6 00             	movzbl (%eax),%eax
  10301c:	3c 30                	cmp    $0x30,%al
  10301e:	75 0d                	jne    10302d <strtol+0xa0>
        s ++, base = 8;
  103020:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  103024:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  10302b:	eb 0d                	jmp    10303a <strtol+0xad>
    }
    else if (base == 0) {
  10302d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103031:	75 07                	jne    10303a <strtol+0xad>
        base = 10;
  103033:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  10303a:	8b 45 08             	mov    0x8(%ebp),%eax
  10303d:	0f b6 00             	movzbl (%eax),%eax
  103040:	3c 2f                	cmp    $0x2f,%al
  103042:	7e 1b                	jle    10305f <strtol+0xd2>
  103044:	8b 45 08             	mov    0x8(%ebp),%eax
  103047:	0f b6 00             	movzbl (%eax),%eax
  10304a:	3c 39                	cmp    $0x39,%al
  10304c:	7f 11                	jg     10305f <strtol+0xd2>
            dig = *s - '0';
  10304e:	8b 45 08             	mov    0x8(%ebp),%eax
  103051:	0f b6 00             	movzbl (%eax),%eax
  103054:	0f be c0             	movsbl %al,%eax
  103057:	83 e8 30             	sub    $0x30,%eax
  10305a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10305d:	eb 48                	jmp    1030a7 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  10305f:	8b 45 08             	mov    0x8(%ebp),%eax
  103062:	0f b6 00             	movzbl (%eax),%eax
  103065:	3c 60                	cmp    $0x60,%al
  103067:	7e 1b                	jle    103084 <strtol+0xf7>
  103069:	8b 45 08             	mov    0x8(%ebp),%eax
  10306c:	0f b6 00             	movzbl (%eax),%eax
  10306f:	3c 7a                	cmp    $0x7a,%al
  103071:	7f 11                	jg     103084 <strtol+0xf7>
            dig = *s - 'a' + 10;
  103073:	8b 45 08             	mov    0x8(%ebp),%eax
  103076:	0f b6 00             	movzbl (%eax),%eax
  103079:	0f be c0             	movsbl %al,%eax
  10307c:	83 e8 57             	sub    $0x57,%eax
  10307f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103082:	eb 23                	jmp    1030a7 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  103084:	8b 45 08             	mov    0x8(%ebp),%eax
  103087:	0f b6 00             	movzbl (%eax),%eax
  10308a:	3c 40                	cmp    $0x40,%al
  10308c:	7e 3c                	jle    1030ca <strtol+0x13d>
  10308e:	8b 45 08             	mov    0x8(%ebp),%eax
  103091:	0f b6 00             	movzbl (%eax),%eax
  103094:	3c 5a                	cmp    $0x5a,%al
  103096:	7f 32                	jg     1030ca <strtol+0x13d>
            dig = *s - 'A' + 10;
  103098:	8b 45 08             	mov    0x8(%ebp),%eax
  10309b:	0f b6 00             	movzbl (%eax),%eax
  10309e:	0f be c0             	movsbl %al,%eax
  1030a1:	83 e8 37             	sub    $0x37,%eax
  1030a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  1030a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1030aa:	3b 45 10             	cmp    0x10(%ebp),%eax
  1030ad:	7d 1a                	jge    1030c9 <strtol+0x13c>
            break;
        }
        s ++, val = (val * base) + dig;
  1030af:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1030b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1030b6:	0f af 45 10          	imul   0x10(%ebp),%eax
  1030ba:	89 c2                	mov    %eax,%edx
  1030bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1030bf:	01 d0                	add    %edx,%eax
  1030c1:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  1030c4:	e9 71 ff ff ff       	jmp    10303a <strtol+0xad>
            break;
  1030c9:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  1030ca:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1030ce:	74 08                	je     1030d8 <strtol+0x14b>
        *endptr = (char *) s;
  1030d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030d3:	8b 55 08             	mov    0x8(%ebp),%edx
  1030d6:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  1030d8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  1030dc:	74 07                	je     1030e5 <strtol+0x158>
  1030de:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1030e1:	f7 d8                	neg    %eax
  1030e3:	eb 03                	jmp    1030e8 <strtol+0x15b>
  1030e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  1030e8:	c9                   	leave  
  1030e9:	c3                   	ret    

001030ea <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  1030ea:	55                   	push   %ebp
  1030eb:	89 e5                	mov    %esp,%ebp
  1030ed:	57                   	push   %edi
  1030ee:	83 ec 24             	sub    $0x24,%esp
  1030f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030f4:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  1030f7:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  1030fb:	8b 55 08             	mov    0x8(%ebp),%edx
  1030fe:	89 55 f8             	mov    %edx,-0x8(%ebp)
  103101:	88 45 f7             	mov    %al,-0x9(%ebp)
  103104:	8b 45 10             	mov    0x10(%ebp),%eax
  103107:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  10310a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  10310d:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  103111:	8b 55 f8             	mov    -0x8(%ebp),%edx
  103114:	89 d7                	mov    %edx,%edi
  103116:	f3 aa                	rep stos %al,%es:(%edi)
  103118:	89 fa                	mov    %edi,%edx
  10311a:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  10311d:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  103120:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103123:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  103124:	83 c4 24             	add    $0x24,%esp
  103127:	5f                   	pop    %edi
  103128:	5d                   	pop    %ebp
  103129:	c3                   	ret    

0010312a <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  10312a:	55                   	push   %ebp
  10312b:	89 e5                	mov    %esp,%ebp
  10312d:	57                   	push   %edi
  10312e:	56                   	push   %esi
  10312f:	53                   	push   %ebx
  103130:	83 ec 30             	sub    $0x30,%esp
  103133:	8b 45 08             	mov    0x8(%ebp),%eax
  103136:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103139:	8b 45 0c             	mov    0xc(%ebp),%eax
  10313c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10313f:	8b 45 10             	mov    0x10(%ebp),%eax
  103142:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  103145:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103148:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10314b:	73 42                	jae    10318f <memmove+0x65>
  10314d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103150:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103153:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103156:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103159:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10315c:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  10315f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103162:	c1 e8 02             	shr    $0x2,%eax
  103165:	89 c1                	mov    %eax,%ecx
    asm volatile (
  103167:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10316a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10316d:	89 d7                	mov    %edx,%edi
  10316f:	89 c6                	mov    %eax,%esi
  103171:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  103173:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  103176:	83 e1 03             	and    $0x3,%ecx
  103179:	74 02                	je     10317d <memmove+0x53>
  10317b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10317d:	89 f0                	mov    %esi,%eax
  10317f:	89 fa                	mov    %edi,%edx
  103181:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  103184:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  103187:	89 45 d0             	mov    %eax,-0x30(%ebp)
            : "memory");
    return dst;
  10318a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
  10318d:	eb 36                	jmp    1031c5 <memmove+0x9b>
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  10318f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103192:	8d 50 ff             	lea    -0x1(%eax),%edx
  103195:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103198:	01 c2                	add    %eax,%edx
  10319a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10319d:	8d 48 ff             	lea    -0x1(%eax),%ecx
  1031a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1031a3:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  1031a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1031a9:	89 c1                	mov    %eax,%ecx
  1031ab:	89 d8                	mov    %ebx,%eax
  1031ad:	89 d6                	mov    %edx,%esi
  1031af:	89 c7                	mov    %eax,%edi
  1031b1:	fd                   	std    
  1031b2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1031b4:	fc                   	cld    
  1031b5:	89 f8                	mov    %edi,%eax
  1031b7:	89 f2                	mov    %esi,%edx
  1031b9:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  1031bc:	89 55 c8             	mov    %edx,-0x38(%ebp)
  1031bf:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  1031c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  1031c5:	83 c4 30             	add    $0x30,%esp
  1031c8:	5b                   	pop    %ebx
  1031c9:	5e                   	pop    %esi
  1031ca:	5f                   	pop    %edi
  1031cb:	5d                   	pop    %ebp
  1031cc:	c3                   	ret    

001031cd <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  1031cd:	55                   	push   %ebp
  1031ce:	89 e5                	mov    %esp,%ebp
  1031d0:	57                   	push   %edi
  1031d1:	56                   	push   %esi
  1031d2:	83 ec 20             	sub    $0x20,%esp
  1031d5:	8b 45 08             	mov    0x8(%ebp),%eax
  1031d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1031db:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031de:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1031e1:	8b 45 10             	mov    0x10(%ebp),%eax
  1031e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  1031e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1031ea:	c1 e8 02             	shr    $0x2,%eax
  1031ed:	89 c1                	mov    %eax,%ecx
    asm volatile (
  1031ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1031f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1031f5:	89 d7                	mov    %edx,%edi
  1031f7:	89 c6                	mov    %eax,%esi
  1031f9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1031fb:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  1031fe:	83 e1 03             	and    $0x3,%ecx
  103201:	74 02                	je     103205 <memcpy+0x38>
  103203:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103205:	89 f0                	mov    %esi,%eax
  103207:	89 fa                	mov    %edi,%edx
  103209:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  10320c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  10320f:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  103212:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
  103215:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  103216:	83 c4 20             	add    $0x20,%esp
  103219:	5e                   	pop    %esi
  10321a:	5f                   	pop    %edi
  10321b:	5d                   	pop    %ebp
  10321c:	c3                   	ret    

0010321d <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  10321d:	55                   	push   %ebp
  10321e:	89 e5                	mov    %esp,%ebp
  103220:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  103223:	8b 45 08             	mov    0x8(%ebp),%eax
  103226:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  103229:	8b 45 0c             	mov    0xc(%ebp),%eax
  10322c:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  10322f:	eb 30                	jmp    103261 <memcmp+0x44>
        if (*s1 != *s2) {
  103231:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103234:	0f b6 10             	movzbl (%eax),%edx
  103237:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10323a:	0f b6 00             	movzbl (%eax),%eax
  10323d:	38 c2                	cmp    %al,%dl
  10323f:	74 18                	je     103259 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  103241:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103244:	0f b6 00             	movzbl (%eax),%eax
  103247:	0f b6 d0             	movzbl %al,%edx
  10324a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10324d:	0f b6 00             	movzbl (%eax),%eax
  103250:	0f b6 c0             	movzbl %al,%eax
  103253:	29 c2                	sub    %eax,%edx
  103255:	89 d0                	mov    %edx,%eax
  103257:	eb 1a                	jmp    103273 <memcmp+0x56>
        }
        s1 ++, s2 ++;
  103259:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10325d:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    while (n -- > 0) {
  103261:	8b 45 10             	mov    0x10(%ebp),%eax
  103264:	8d 50 ff             	lea    -0x1(%eax),%edx
  103267:	89 55 10             	mov    %edx,0x10(%ebp)
  10326a:	85 c0                	test   %eax,%eax
  10326c:	75 c3                	jne    103231 <memcmp+0x14>
    }
    return 0;
  10326e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103273:	c9                   	leave  
  103274:	c3                   	ret    

00103275 <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  103275:	55                   	push   %ebp
  103276:	89 e5                	mov    %esp,%ebp
  103278:	83 ec 38             	sub    $0x38,%esp
  10327b:	8b 45 10             	mov    0x10(%ebp),%eax
  10327e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103281:	8b 45 14             	mov    0x14(%ebp),%eax
  103284:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  103287:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10328a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10328d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103290:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  103293:	8b 45 18             	mov    0x18(%ebp),%eax
  103296:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103299:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10329c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10329f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1032a2:	89 55 f0             	mov    %edx,-0x10(%ebp)
  1032a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1032a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1032ab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1032af:	74 1c                	je     1032cd <printnum+0x58>
  1032b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1032b4:	ba 00 00 00 00       	mov    $0x0,%edx
  1032b9:	f7 75 e4             	divl   -0x1c(%ebp)
  1032bc:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1032bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1032c2:	ba 00 00 00 00       	mov    $0x0,%edx
  1032c7:	f7 75 e4             	divl   -0x1c(%ebp)
  1032ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1032cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1032d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1032d3:	f7 75 e4             	divl   -0x1c(%ebp)
  1032d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1032d9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  1032dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1032df:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1032e2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1032e5:	89 55 ec             	mov    %edx,-0x14(%ebp)
  1032e8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1032eb:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  1032ee:	8b 45 18             	mov    0x18(%ebp),%eax
  1032f1:	ba 00 00 00 00       	mov    $0x0,%edx
  1032f6:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  1032f9:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  1032fc:	19 d1                	sbb    %edx,%ecx
  1032fe:	72 37                	jb     103337 <printnum+0xc2>
        printnum(putch, putdat, result, base, width - 1, padc);
  103300:	8b 45 1c             	mov    0x1c(%ebp),%eax
  103303:	83 e8 01             	sub    $0x1,%eax
  103306:	83 ec 04             	sub    $0x4,%esp
  103309:	ff 75 20             	pushl  0x20(%ebp)
  10330c:	50                   	push   %eax
  10330d:	ff 75 18             	pushl  0x18(%ebp)
  103310:	ff 75 ec             	pushl  -0x14(%ebp)
  103313:	ff 75 e8             	pushl  -0x18(%ebp)
  103316:	ff 75 0c             	pushl  0xc(%ebp)
  103319:	ff 75 08             	pushl  0x8(%ebp)
  10331c:	e8 54 ff ff ff       	call   103275 <printnum>
  103321:	83 c4 20             	add    $0x20,%esp
  103324:	eb 1b                	jmp    103341 <printnum+0xcc>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  103326:	83 ec 08             	sub    $0x8,%esp
  103329:	ff 75 0c             	pushl  0xc(%ebp)
  10332c:	ff 75 20             	pushl  0x20(%ebp)
  10332f:	8b 45 08             	mov    0x8(%ebp),%eax
  103332:	ff d0                	call   *%eax
  103334:	83 c4 10             	add    $0x10,%esp
        while (-- width > 0)
  103337:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  10333b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  10333f:	7f e5                	jg     103326 <printnum+0xb1>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  103341:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103344:	05 30 40 10 00       	add    $0x104030,%eax
  103349:	0f b6 00             	movzbl (%eax),%eax
  10334c:	0f be c0             	movsbl %al,%eax
  10334f:	83 ec 08             	sub    $0x8,%esp
  103352:	ff 75 0c             	pushl  0xc(%ebp)
  103355:	50                   	push   %eax
  103356:	8b 45 08             	mov    0x8(%ebp),%eax
  103359:	ff d0                	call   *%eax
  10335b:	83 c4 10             	add    $0x10,%esp
}
  10335e:	90                   	nop
  10335f:	c9                   	leave  
  103360:	c3                   	ret    

00103361 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  103361:	55                   	push   %ebp
  103362:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  103364:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  103368:	7e 14                	jle    10337e <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  10336a:	8b 45 08             	mov    0x8(%ebp),%eax
  10336d:	8b 00                	mov    (%eax),%eax
  10336f:	8d 48 08             	lea    0x8(%eax),%ecx
  103372:	8b 55 08             	mov    0x8(%ebp),%edx
  103375:	89 0a                	mov    %ecx,(%edx)
  103377:	8b 50 04             	mov    0x4(%eax),%edx
  10337a:	8b 00                	mov    (%eax),%eax
  10337c:	eb 30                	jmp    1033ae <getuint+0x4d>
    }
    else if (lflag) {
  10337e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  103382:	74 16                	je     10339a <getuint+0x39>
        return va_arg(*ap, unsigned long);
  103384:	8b 45 08             	mov    0x8(%ebp),%eax
  103387:	8b 00                	mov    (%eax),%eax
  103389:	8d 48 04             	lea    0x4(%eax),%ecx
  10338c:	8b 55 08             	mov    0x8(%ebp),%edx
  10338f:	89 0a                	mov    %ecx,(%edx)
  103391:	8b 00                	mov    (%eax),%eax
  103393:	ba 00 00 00 00       	mov    $0x0,%edx
  103398:	eb 14                	jmp    1033ae <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  10339a:	8b 45 08             	mov    0x8(%ebp),%eax
  10339d:	8b 00                	mov    (%eax),%eax
  10339f:	8d 48 04             	lea    0x4(%eax),%ecx
  1033a2:	8b 55 08             	mov    0x8(%ebp),%edx
  1033a5:	89 0a                	mov    %ecx,(%edx)
  1033a7:	8b 00                	mov    (%eax),%eax
  1033a9:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  1033ae:	5d                   	pop    %ebp
  1033af:	c3                   	ret    

001033b0 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  1033b0:	55                   	push   %ebp
  1033b1:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1033b3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1033b7:	7e 14                	jle    1033cd <getint+0x1d>
        return va_arg(*ap, long long);
  1033b9:	8b 45 08             	mov    0x8(%ebp),%eax
  1033bc:	8b 00                	mov    (%eax),%eax
  1033be:	8d 48 08             	lea    0x8(%eax),%ecx
  1033c1:	8b 55 08             	mov    0x8(%ebp),%edx
  1033c4:	89 0a                	mov    %ecx,(%edx)
  1033c6:	8b 50 04             	mov    0x4(%eax),%edx
  1033c9:	8b 00                	mov    (%eax),%eax
  1033cb:	eb 28                	jmp    1033f5 <getint+0x45>
    }
    else if (lflag) {
  1033cd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1033d1:	74 12                	je     1033e5 <getint+0x35>
        return va_arg(*ap, long);
  1033d3:	8b 45 08             	mov    0x8(%ebp),%eax
  1033d6:	8b 00                	mov    (%eax),%eax
  1033d8:	8d 48 04             	lea    0x4(%eax),%ecx
  1033db:	8b 55 08             	mov    0x8(%ebp),%edx
  1033de:	89 0a                	mov    %ecx,(%edx)
  1033e0:	8b 00                	mov    (%eax),%eax
  1033e2:	99                   	cltd   
  1033e3:	eb 10                	jmp    1033f5 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  1033e5:	8b 45 08             	mov    0x8(%ebp),%eax
  1033e8:	8b 00                	mov    (%eax),%eax
  1033ea:	8d 48 04             	lea    0x4(%eax),%ecx
  1033ed:	8b 55 08             	mov    0x8(%ebp),%edx
  1033f0:	89 0a                	mov    %ecx,(%edx)
  1033f2:	8b 00                	mov    (%eax),%eax
  1033f4:	99                   	cltd   
    }
}
  1033f5:	5d                   	pop    %ebp
  1033f6:	c3                   	ret    

001033f7 <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  1033f7:	55                   	push   %ebp
  1033f8:	89 e5                	mov    %esp,%ebp
  1033fa:	83 ec 18             	sub    $0x18,%esp
    va_list ap;

    va_start(ap, fmt);
  1033fd:	8d 45 14             	lea    0x14(%ebp),%eax
  103400:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  103403:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103406:	50                   	push   %eax
  103407:	ff 75 10             	pushl  0x10(%ebp)
  10340a:	ff 75 0c             	pushl  0xc(%ebp)
  10340d:	ff 75 08             	pushl  0x8(%ebp)
  103410:	e8 06 00 00 00       	call   10341b <vprintfmt>
  103415:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  103418:	90                   	nop
  103419:	c9                   	leave  
  10341a:	c3                   	ret    

0010341b <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  10341b:	55                   	push   %ebp
  10341c:	89 e5                	mov    %esp,%ebp
  10341e:	56                   	push   %esi
  10341f:	53                   	push   %ebx
  103420:	83 ec 20             	sub    $0x20,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  103423:	eb 17                	jmp    10343c <vprintfmt+0x21>
            if (ch == '\0') {
  103425:	85 db                	test   %ebx,%ebx
  103427:	0f 84 8e 03 00 00    	je     1037bb <vprintfmt+0x3a0>
                return;
            }
            putch(ch, putdat);
  10342d:	83 ec 08             	sub    $0x8,%esp
  103430:	ff 75 0c             	pushl  0xc(%ebp)
  103433:	53                   	push   %ebx
  103434:	8b 45 08             	mov    0x8(%ebp),%eax
  103437:	ff d0                	call   *%eax
  103439:	83 c4 10             	add    $0x10,%esp
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  10343c:	8b 45 10             	mov    0x10(%ebp),%eax
  10343f:	8d 50 01             	lea    0x1(%eax),%edx
  103442:	89 55 10             	mov    %edx,0x10(%ebp)
  103445:	0f b6 00             	movzbl (%eax),%eax
  103448:	0f b6 d8             	movzbl %al,%ebx
  10344b:	83 fb 25             	cmp    $0x25,%ebx
  10344e:	75 d5                	jne    103425 <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
  103450:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  103454:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  10345b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10345e:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  103461:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103468:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10346b:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  10346e:	8b 45 10             	mov    0x10(%ebp),%eax
  103471:	8d 50 01             	lea    0x1(%eax),%edx
  103474:	89 55 10             	mov    %edx,0x10(%ebp)
  103477:	0f b6 00             	movzbl (%eax),%eax
  10347a:	0f b6 d8             	movzbl %al,%ebx
  10347d:	8d 43 dd             	lea    -0x23(%ebx),%eax
  103480:	83 f8 55             	cmp    $0x55,%eax
  103483:	0f 87 05 03 00 00    	ja     10378e <vprintfmt+0x373>
  103489:	8b 04 85 54 40 10 00 	mov    0x104054(,%eax,4),%eax
  103490:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  103492:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  103496:	eb d6                	jmp    10346e <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  103498:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  10349c:	eb d0                	jmp    10346e <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  10349e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  1034a5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1034a8:	89 d0                	mov    %edx,%eax
  1034aa:	c1 e0 02             	shl    $0x2,%eax
  1034ad:	01 d0                	add    %edx,%eax
  1034af:	01 c0                	add    %eax,%eax
  1034b1:	01 d8                	add    %ebx,%eax
  1034b3:	83 e8 30             	sub    $0x30,%eax
  1034b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  1034b9:	8b 45 10             	mov    0x10(%ebp),%eax
  1034bc:	0f b6 00             	movzbl (%eax),%eax
  1034bf:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  1034c2:	83 fb 2f             	cmp    $0x2f,%ebx
  1034c5:	7e 39                	jle    103500 <vprintfmt+0xe5>
  1034c7:	83 fb 39             	cmp    $0x39,%ebx
  1034ca:	7f 34                	jg     103500 <vprintfmt+0xe5>
            for (precision = 0; ; ++ fmt) {
  1034cc:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
  1034d0:	eb d3                	jmp    1034a5 <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  1034d2:	8b 45 14             	mov    0x14(%ebp),%eax
  1034d5:	8d 50 04             	lea    0x4(%eax),%edx
  1034d8:	89 55 14             	mov    %edx,0x14(%ebp)
  1034db:	8b 00                	mov    (%eax),%eax
  1034dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  1034e0:	eb 1f                	jmp    103501 <vprintfmt+0xe6>

        case '.':
            if (width < 0)
  1034e2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1034e6:	79 86                	jns    10346e <vprintfmt+0x53>
                width = 0;
  1034e8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  1034ef:	e9 7a ff ff ff       	jmp    10346e <vprintfmt+0x53>

        case '#':
            altflag = 1;
  1034f4:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  1034fb:	e9 6e ff ff ff       	jmp    10346e <vprintfmt+0x53>
            goto process_precision;
  103500:	90                   	nop

        process_precision:
            if (width < 0)
  103501:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103505:	0f 89 63 ff ff ff    	jns    10346e <vprintfmt+0x53>
                width = precision, precision = -1;
  10350b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10350e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103511:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  103518:	e9 51 ff ff ff       	jmp    10346e <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  10351d:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  103521:	e9 48 ff ff ff       	jmp    10346e <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  103526:	8b 45 14             	mov    0x14(%ebp),%eax
  103529:	8d 50 04             	lea    0x4(%eax),%edx
  10352c:	89 55 14             	mov    %edx,0x14(%ebp)
  10352f:	8b 00                	mov    (%eax),%eax
  103531:	83 ec 08             	sub    $0x8,%esp
  103534:	ff 75 0c             	pushl  0xc(%ebp)
  103537:	50                   	push   %eax
  103538:	8b 45 08             	mov    0x8(%ebp),%eax
  10353b:	ff d0                	call   *%eax
  10353d:	83 c4 10             	add    $0x10,%esp
            break;
  103540:	e9 71 02 00 00       	jmp    1037b6 <vprintfmt+0x39b>

        // error message
        case 'e':
            err = va_arg(ap, int);
  103545:	8b 45 14             	mov    0x14(%ebp),%eax
  103548:	8d 50 04             	lea    0x4(%eax),%edx
  10354b:	89 55 14             	mov    %edx,0x14(%ebp)
  10354e:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  103550:	85 db                	test   %ebx,%ebx
  103552:	79 02                	jns    103556 <vprintfmt+0x13b>
                err = -err;
  103554:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  103556:	83 fb 06             	cmp    $0x6,%ebx
  103559:	7f 0b                	jg     103566 <vprintfmt+0x14b>
  10355b:	8b 34 9d 14 40 10 00 	mov    0x104014(,%ebx,4),%esi
  103562:	85 f6                	test   %esi,%esi
  103564:	75 19                	jne    10357f <vprintfmt+0x164>
                printfmt(putch, putdat, "error %d", err);
  103566:	53                   	push   %ebx
  103567:	68 41 40 10 00       	push   $0x104041
  10356c:	ff 75 0c             	pushl  0xc(%ebp)
  10356f:	ff 75 08             	pushl  0x8(%ebp)
  103572:	e8 80 fe ff ff       	call   1033f7 <printfmt>
  103577:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  10357a:	e9 37 02 00 00       	jmp    1037b6 <vprintfmt+0x39b>
                printfmt(putch, putdat, "%s", p);
  10357f:	56                   	push   %esi
  103580:	68 4a 40 10 00       	push   $0x10404a
  103585:	ff 75 0c             	pushl  0xc(%ebp)
  103588:	ff 75 08             	pushl  0x8(%ebp)
  10358b:	e8 67 fe ff ff       	call   1033f7 <printfmt>
  103590:	83 c4 10             	add    $0x10,%esp
            break;
  103593:	e9 1e 02 00 00       	jmp    1037b6 <vprintfmt+0x39b>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  103598:	8b 45 14             	mov    0x14(%ebp),%eax
  10359b:	8d 50 04             	lea    0x4(%eax),%edx
  10359e:	89 55 14             	mov    %edx,0x14(%ebp)
  1035a1:	8b 30                	mov    (%eax),%esi
  1035a3:	85 f6                	test   %esi,%esi
  1035a5:	75 05                	jne    1035ac <vprintfmt+0x191>
                p = "(null)";
  1035a7:	be 4d 40 10 00       	mov    $0x10404d,%esi
            }
            if (width > 0 && padc != '-') {
  1035ac:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1035b0:	7e 76                	jle    103628 <vprintfmt+0x20d>
  1035b2:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  1035b6:	74 70                	je     103628 <vprintfmt+0x20d>
                for (width -= strnlen(p, precision); width > 0; width --) {
  1035b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1035bb:	83 ec 08             	sub    $0x8,%esp
  1035be:	50                   	push   %eax
  1035bf:	56                   	push   %esi
  1035c0:	e8 1c f8 ff ff       	call   102de1 <strnlen>
  1035c5:	83 c4 10             	add    $0x10,%esp
  1035c8:	89 c2                	mov    %eax,%edx
  1035ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1035cd:	29 d0                	sub    %edx,%eax
  1035cf:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1035d2:	eb 17                	jmp    1035eb <vprintfmt+0x1d0>
                    putch(padc, putdat);
  1035d4:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  1035d8:	83 ec 08             	sub    $0x8,%esp
  1035db:	ff 75 0c             	pushl  0xc(%ebp)
  1035de:	50                   	push   %eax
  1035df:	8b 45 08             	mov    0x8(%ebp),%eax
  1035e2:	ff d0                	call   *%eax
  1035e4:	83 c4 10             	add    $0x10,%esp
                for (width -= strnlen(p, precision); width > 0; width --) {
  1035e7:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1035eb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1035ef:	7f e3                	jg     1035d4 <vprintfmt+0x1b9>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1035f1:	eb 35                	jmp    103628 <vprintfmt+0x20d>
                if (altflag && (ch < ' ' || ch > '~')) {
  1035f3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  1035f7:	74 1c                	je     103615 <vprintfmt+0x1fa>
  1035f9:	83 fb 1f             	cmp    $0x1f,%ebx
  1035fc:	7e 05                	jle    103603 <vprintfmt+0x1e8>
  1035fe:	83 fb 7e             	cmp    $0x7e,%ebx
  103601:	7e 12                	jle    103615 <vprintfmt+0x1fa>
                    putch('?', putdat);
  103603:	83 ec 08             	sub    $0x8,%esp
  103606:	ff 75 0c             	pushl  0xc(%ebp)
  103609:	6a 3f                	push   $0x3f
  10360b:	8b 45 08             	mov    0x8(%ebp),%eax
  10360e:	ff d0                	call   *%eax
  103610:	83 c4 10             	add    $0x10,%esp
  103613:	eb 0f                	jmp    103624 <vprintfmt+0x209>
                }
                else {
                    putch(ch, putdat);
  103615:	83 ec 08             	sub    $0x8,%esp
  103618:	ff 75 0c             	pushl  0xc(%ebp)
  10361b:	53                   	push   %ebx
  10361c:	8b 45 08             	mov    0x8(%ebp),%eax
  10361f:	ff d0                	call   *%eax
  103621:	83 c4 10             	add    $0x10,%esp
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  103624:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  103628:	89 f0                	mov    %esi,%eax
  10362a:	8d 70 01             	lea    0x1(%eax),%esi
  10362d:	0f b6 00             	movzbl (%eax),%eax
  103630:	0f be d8             	movsbl %al,%ebx
  103633:	85 db                	test   %ebx,%ebx
  103635:	74 26                	je     10365d <vprintfmt+0x242>
  103637:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10363b:	78 b6                	js     1035f3 <vprintfmt+0x1d8>
  10363d:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  103641:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103645:	79 ac                	jns    1035f3 <vprintfmt+0x1d8>
                }
            }
            for (; width > 0; width --) {
  103647:	eb 14                	jmp    10365d <vprintfmt+0x242>
                putch(' ', putdat);
  103649:	83 ec 08             	sub    $0x8,%esp
  10364c:	ff 75 0c             	pushl  0xc(%ebp)
  10364f:	6a 20                	push   $0x20
  103651:	8b 45 08             	mov    0x8(%ebp),%eax
  103654:	ff d0                	call   *%eax
  103656:	83 c4 10             	add    $0x10,%esp
            for (; width > 0; width --) {
  103659:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  10365d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103661:	7f e6                	jg     103649 <vprintfmt+0x22e>
            }
            break;
  103663:	e9 4e 01 00 00       	jmp    1037b6 <vprintfmt+0x39b>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  103668:	83 ec 08             	sub    $0x8,%esp
  10366b:	ff 75 e0             	pushl  -0x20(%ebp)
  10366e:	8d 45 14             	lea    0x14(%ebp),%eax
  103671:	50                   	push   %eax
  103672:	e8 39 fd ff ff       	call   1033b0 <getint>
  103677:	83 c4 10             	add    $0x10,%esp
  10367a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10367d:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  103680:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103683:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103686:	85 d2                	test   %edx,%edx
  103688:	79 23                	jns    1036ad <vprintfmt+0x292>
                putch('-', putdat);
  10368a:	83 ec 08             	sub    $0x8,%esp
  10368d:	ff 75 0c             	pushl  0xc(%ebp)
  103690:	6a 2d                	push   $0x2d
  103692:	8b 45 08             	mov    0x8(%ebp),%eax
  103695:	ff d0                	call   *%eax
  103697:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
  10369a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10369d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1036a0:	f7 d8                	neg    %eax
  1036a2:	83 d2 00             	adc    $0x0,%edx
  1036a5:	f7 da                	neg    %edx
  1036a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1036aa:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  1036ad:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1036b4:	e9 9f 00 00 00       	jmp    103758 <vprintfmt+0x33d>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  1036b9:	83 ec 08             	sub    $0x8,%esp
  1036bc:	ff 75 e0             	pushl  -0x20(%ebp)
  1036bf:	8d 45 14             	lea    0x14(%ebp),%eax
  1036c2:	50                   	push   %eax
  1036c3:	e8 99 fc ff ff       	call   103361 <getuint>
  1036c8:	83 c4 10             	add    $0x10,%esp
  1036cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1036ce:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  1036d1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1036d8:	eb 7e                	jmp    103758 <vprintfmt+0x33d>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  1036da:	83 ec 08             	sub    $0x8,%esp
  1036dd:	ff 75 e0             	pushl  -0x20(%ebp)
  1036e0:	8d 45 14             	lea    0x14(%ebp),%eax
  1036e3:	50                   	push   %eax
  1036e4:	e8 78 fc ff ff       	call   103361 <getuint>
  1036e9:	83 c4 10             	add    $0x10,%esp
  1036ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1036ef:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  1036f2:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  1036f9:	eb 5d                	jmp    103758 <vprintfmt+0x33d>

        // pointer
        case 'p':
            putch('0', putdat);
  1036fb:	83 ec 08             	sub    $0x8,%esp
  1036fe:	ff 75 0c             	pushl  0xc(%ebp)
  103701:	6a 30                	push   $0x30
  103703:	8b 45 08             	mov    0x8(%ebp),%eax
  103706:	ff d0                	call   *%eax
  103708:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
  10370b:	83 ec 08             	sub    $0x8,%esp
  10370e:	ff 75 0c             	pushl  0xc(%ebp)
  103711:	6a 78                	push   $0x78
  103713:	8b 45 08             	mov    0x8(%ebp),%eax
  103716:	ff d0                	call   *%eax
  103718:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  10371b:	8b 45 14             	mov    0x14(%ebp),%eax
  10371e:	8d 50 04             	lea    0x4(%eax),%edx
  103721:	89 55 14             	mov    %edx,0x14(%ebp)
  103724:	8b 00                	mov    (%eax),%eax
  103726:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103729:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  103730:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  103737:	eb 1f                	jmp    103758 <vprintfmt+0x33d>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  103739:	83 ec 08             	sub    $0x8,%esp
  10373c:	ff 75 e0             	pushl  -0x20(%ebp)
  10373f:	8d 45 14             	lea    0x14(%ebp),%eax
  103742:	50                   	push   %eax
  103743:	e8 19 fc ff ff       	call   103361 <getuint>
  103748:	83 c4 10             	add    $0x10,%esp
  10374b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10374e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  103751:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  103758:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  10375c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10375f:	83 ec 04             	sub    $0x4,%esp
  103762:	52                   	push   %edx
  103763:	ff 75 e8             	pushl  -0x18(%ebp)
  103766:	50                   	push   %eax
  103767:	ff 75 f4             	pushl  -0xc(%ebp)
  10376a:	ff 75 f0             	pushl  -0x10(%ebp)
  10376d:	ff 75 0c             	pushl  0xc(%ebp)
  103770:	ff 75 08             	pushl  0x8(%ebp)
  103773:	e8 fd fa ff ff       	call   103275 <printnum>
  103778:	83 c4 20             	add    $0x20,%esp
            break;
  10377b:	eb 39                	jmp    1037b6 <vprintfmt+0x39b>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  10377d:	83 ec 08             	sub    $0x8,%esp
  103780:	ff 75 0c             	pushl  0xc(%ebp)
  103783:	53                   	push   %ebx
  103784:	8b 45 08             	mov    0x8(%ebp),%eax
  103787:	ff d0                	call   *%eax
  103789:	83 c4 10             	add    $0x10,%esp
            break;
  10378c:	eb 28                	jmp    1037b6 <vprintfmt+0x39b>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  10378e:	83 ec 08             	sub    $0x8,%esp
  103791:	ff 75 0c             	pushl  0xc(%ebp)
  103794:	6a 25                	push   $0x25
  103796:	8b 45 08             	mov    0x8(%ebp),%eax
  103799:	ff d0                	call   *%eax
  10379b:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
  10379e:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1037a2:	eb 04                	jmp    1037a8 <vprintfmt+0x38d>
  1037a4:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1037a8:	8b 45 10             	mov    0x10(%ebp),%eax
  1037ab:	83 e8 01             	sub    $0x1,%eax
  1037ae:	0f b6 00             	movzbl (%eax),%eax
  1037b1:	3c 25                	cmp    $0x25,%al
  1037b3:	75 ef                	jne    1037a4 <vprintfmt+0x389>
                /* do nothing */;
            break;
  1037b5:	90                   	nop
    while (1) {
  1037b6:	e9 68 fc ff ff       	jmp    103423 <vprintfmt+0x8>
                return;
  1037bb:	90                   	nop
        }
    }
}
  1037bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  1037bf:	5b                   	pop    %ebx
  1037c0:	5e                   	pop    %esi
  1037c1:	5d                   	pop    %ebp
  1037c2:	c3                   	ret    

001037c3 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  1037c3:	55                   	push   %ebp
  1037c4:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  1037c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1037c9:	8b 40 08             	mov    0x8(%eax),%eax
  1037cc:	8d 50 01             	lea    0x1(%eax),%edx
  1037cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1037d2:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  1037d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1037d8:	8b 10                	mov    (%eax),%edx
  1037da:	8b 45 0c             	mov    0xc(%ebp),%eax
  1037dd:	8b 40 04             	mov    0x4(%eax),%eax
  1037e0:	39 c2                	cmp    %eax,%edx
  1037e2:	73 12                	jae    1037f6 <sprintputch+0x33>
        *b->buf ++ = ch;
  1037e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1037e7:	8b 00                	mov    (%eax),%eax
  1037e9:	8d 48 01             	lea    0x1(%eax),%ecx
  1037ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  1037ef:	89 0a                	mov    %ecx,(%edx)
  1037f1:	8b 55 08             	mov    0x8(%ebp),%edx
  1037f4:	88 10                	mov    %dl,(%eax)
    }
}
  1037f6:	90                   	nop
  1037f7:	5d                   	pop    %ebp
  1037f8:	c3                   	ret    

001037f9 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  1037f9:	55                   	push   %ebp
  1037fa:	89 e5                	mov    %esp,%ebp
  1037fc:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  1037ff:	8d 45 14             	lea    0x14(%ebp),%eax
  103802:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  103805:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103808:	50                   	push   %eax
  103809:	ff 75 10             	pushl  0x10(%ebp)
  10380c:	ff 75 0c             	pushl  0xc(%ebp)
  10380f:	ff 75 08             	pushl  0x8(%ebp)
  103812:	e8 0b 00 00 00       	call   103822 <vsnprintf>
  103817:	83 c4 10             	add    $0x10,%esp
  10381a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10381d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103820:	c9                   	leave  
  103821:	c3                   	ret    

00103822 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  103822:	55                   	push   %ebp
  103823:	89 e5                	mov    %esp,%ebp
  103825:	83 ec 18             	sub    $0x18,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  103828:	8b 45 08             	mov    0x8(%ebp),%eax
  10382b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10382e:	8b 45 0c             	mov    0xc(%ebp),%eax
  103831:	8d 50 ff             	lea    -0x1(%eax),%edx
  103834:	8b 45 08             	mov    0x8(%ebp),%eax
  103837:	01 d0                	add    %edx,%eax
  103839:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10383c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  103843:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103847:	74 0a                	je     103853 <vsnprintf+0x31>
  103849:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10384c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10384f:	39 c2                	cmp    %eax,%edx
  103851:	76 07                	jbe    10385a <vsnprintf+0x38>
        return -E_INVAL;
  103853:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  103858:	eb 20                	jmp    10387a <vsnprintf+0x58>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  10385a:	ff 75 14             	pushl  0x14(%ebp)
  10385d:	ff 75 10             	pushl  0x10(%ebp)
  103860:	8d 45 ec             	lea    -0x14(%ebp),%eax
  103863:	50                   	push   %eax
  103864:	68 c3 37 10 00       	push   $0x1037c3
  103869:	e8 ad fb ff ff       	call   10341b <vprintfmt>
  10386e:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
  103871:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103874:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  103877:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10387a:	c9                   	leave  
  10387b:	c3                   	ret    
