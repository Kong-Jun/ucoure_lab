
kernel：     文件格式 elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	83 ec 18             	sub    $0x18,%esp
  100006:	b8 20 0d 11 00       	mov    $0x110d20,%eax
  10000b:	2d 16 fa 10 00       	sub    $0x10fa16,%eax
  100010:	83 ec 04             	sub    $0x4,%esp
  100013:	50                   	push   %eax
  100014:	6a 00                	push   $0x0
  100016:	68 16 fa 10 00       	push   $0x10fa16
  10001b:	e8 95 2f 00 00       	call   102fb5 <memset>
  100020:	83 c4 10             	add    $0x10,%esp
  100023:	e8 4c 15 00 00       	call   101574 <cons_init>
  100028:	c7 45 f4 60 37 10 00 	movl   $0x103760,-0xc(%ebp)
  10002f:	83 ec 08             	sub    $0x8,%esp
  100032:	ff 75 f4             	pushl  -0xc(%ebp)
  100035:	68 7c 37 10 00       	push   $0x10377c
  10003a:	e8 0b 02 00 00       	call   10024a <cprintf>
  10003f:	83 c4 10             	add    $0x10,%esp
  100042:	e8 97 08 00 00       	call   1008de <print_kerninfo>
  100047:	e8 79 00 00 00       	call   1000c5 <grade_backtrace>
  10004c:	e8 28 2c 00 00       	call   102c79 <pmm_init>
  100051:	e8 61 16 00 00       	call   1016b7 <pic_init>
  100056:	e8 f4 17 00 00       	call   10184f <idt_init>
  10005b:	e8 f5 0c 00 00       	call   100d55 <clock_init>
  100060:	e8 8f 17 00 00       	call   1017f4 <intr_enable>
  100065:	e8 51 01 00 00       	call   1001bb <lab1_switch_test>
  10006a:	eb fe                	jmp    10006a <kern_init+0x6a>

0010006c <grade_backtrace2>:
  10006c:	55                   	push   %ebp
  10006d:	89 e5                	mov    %esp,%ebp
  10006f:	83 ec 08             	sub    $0x8,%esp
  100072:	83 ec 04             	sub    $0x4,%esp
  100075:	6a 00                	push   $0x0
  100077:	6a 00                	push   $0x0
  100079:	6a 00                	push   $0x0
  10007b:	e8 c3 0c 00 00       	call   100d43 <mon_backtrace>
  100080:	83 c4 10             	add    $0x10,%esp
  100083:	90                   	nop
  100084:	c9                   	leave  
  100085:	c3                   	ret    

00100086 <grade_backtrace1>:
  100086:	55                   	push   %ebp
  100087:	89 e5                	mov    %esp,%ebp
  100089:	53                   	push   %ebx
  10008a:	83 ec 04             	sub    $0x4,%esp
  10008d:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  100090:	8b 55 0c             	mov    0xc(%ebp),%edx
  100093:	8d 5d 08             	lea    0x8(%ebp),%ebx
  100096:	8b 45 08             	mov    0x8(%ebp),%eax
  100099:	51                   	push   %ecx
  10009a:	52                   	push   %edx
  10009b:	53                   	push   %ebx
  10009c:	50                   	push   %eax
  10009d:	e8 ca ff ff ff       	call   10006c <grade_backtrace2>
  1000a2:	83 c4 10             	add    $0x10,%esp
  1000a5:	90                   	nop
  1000a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1000a9:	c9                   	leave  
  1000aa:	c3                   	ret    

001000ab <grade_backtrace0>:
  1000ab:	55                   	push   %ebp
  1000ac:	89 e5                	mov    %esp,%ebp
  1000ae:	83 ec 08             	sub    $0x8,%esp
  1000b1:	83 ec 08             	sub    $0x8,%esp
  1000b4:	ff 75 10             	pushl  0x10(%ebp)
  1000b7:	ff 75 08             	pushl  0x8(%ebp)
  1000ba:	e8 c7 ff ff ff       	call   100086 <grade_backtrace1>
  1000bf:	83 c4 10             	add    $0x10,%esp
  1000c2:	90                   	nop
  1000c3:	c9                   	leave  
  1000c4:	c3                   	ret    

001000c5 <grade_backtrace>:
  1000c5:	55                   	push   %ebp
  1000c6:	89 e5                	mov    %esp,%ebp
  1000c8:	83 ec 08             	sub    $0x8,%esp
  1000cb:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000d0:	83 ec 04             	sub    $0x4,%esp
  1000d3:	68 00 00 ff ff       	push   $0xffff0000
  1000d8:	50                   	push   %eax
  1000d9:	6a 00                	push   $0x0
  1000db:	e8 cb ff ff ff       	call   1000ab <grade_backtrace0>
  1000e0:	83 c4 10             	add    $0x10,%esp
  1000e3:	90                   	nop
  1000e4:	c9                   	leave  
  1000e5:	c3                   	ret    

001000e6 <lab1_print_cur_status>:
  1000e6:	55                   	push   %ebp
  1000e7:	89 e5                	mov    %esp,%ebp
  1000e9:	83 ec 18             	sub    $0x18,%esp
  1000ec:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  1000ef:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  1000f2:	8c 45 f2             	mov    %es,-0xe(%ebp)
  1000f5:	8c 55 f0             	mov    %ss,-0x10(%ebp)
  1000f8:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1000fc:	0f b7 c0             	movzwl %ax,%eax
  1000ff:	83 e0 03             	and    $0x3,%eax
  100102:	89 c2                	mov    %eax,%edx
  100104:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  100109:	83 ec 04             	sub    $0x4,%esp
  10010c:	52                   	push   %edx
  10010d:	50                   	push   %eax
  10010e:	68 81 37 10 00       	push   $0x103781
  100113:	e8 32 01 00 00       	call   10024a <cprintf>
  100118:	83 c4 10             	add    $0x10,%esp
  10011b:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10011f:	0f b7 d0             	movzwl %ax,%edx
  100122:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  100127:	83 ec 04             	sub    $0x4,%esp
  10012a:	52                   	push   %edx
  10012b:	50                   	push   %eax
  10012c:	68 8f 37 10 00       	push   $0x10378f
  100131:	e8 14 01 00 00       	call   10024a <cprintf>
  100136:	83 c4 10             	add    $0x10,%esp
  100139:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  10013d:	0f b7 d0             	movzwl %ax,%edx
  100140:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  100145:	83 ec 04             	sub    $0x4,%esp
  100148:	52                   	push   %edx
  100149:	50                   	push   %eax
  10014a:	68 9d 37 10 00       	push   $0x10379d
  10014f:	e8 f6 00 00 00       	call   10024a <cprintf>
  100154:	83 c4 10             	add    $0x10,%esp
  100157:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10015b:	0f b7 d0             	movzwl %ax,%edx
  10015e:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  100163:	83 ec 04             	sub    $0x4,%esp
  100166:	52                   	push   %edx
  100167:	50                   	push   %eax
  100168:	68 ab 37 10 00       	push   $0x1037ab
  10016d:	e8 d8 00 00 00       	call   10024a <cprintf>
  100172:	83 c4 10             	add    $0x10,%esp
  100175:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  100179:	0f b7 d0             	movzwl %ax,%edx
  10017c:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  100181:	83 ec 04             	sub    $0x4,%esp
  100184:	52                   	push   %edx
  100185:	50                   	push   %eax
  100186:	68 b9 37 10 00       	push   $0x1037b9
  10018b:	e8 ba 00 00 00       	call   10024a <cprintf>
  100190:	83 c4 10             	add    $0x10,%esp
  100193:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  100198:	83 c0 01             	add    $0x1,%eax
  10019b:	a3 20 fa 10 00       	mov    %eax,0x10fa20
  1001a0:	90                   	nop
  1001a1:	c9                   	leave  
  1001a2:	c3                   	ret    

001001a3 <lab1_switch_to_user>:
  1001a3:	55                   	push   %ebp
  1001a4:	89 e5                	mov    %esp,%ebp
  1001a6:	b8 23 00 00 00       	mov    $0x23,%eax
  1001ab:	50                   	push   %eax
  1001ac:	54                   	push   %esp
  1001ad:	cd 78                	int    $0x78
  1001af:	90                   	nop
  1001b0:	5d                   	pop    %ebp
  1001b1:	c3                   	ret    

001001b2 <lab1_switch_to_kernel>:
  1001b2:	55                   	push   %ebp
  1001b3:	89 e5                	mov    %esp,%ebp
  1001b5:	cd 79                	int    $0x79
  1001b7:	5c                   	pop    %esp
  1001b8:	90                   	nop
  1001b9:	5d                   	pop    %ebp
  1001ba:	c3                   	ret    

001001bb <lab1_switch_test>:
  1001bb:	55                   	push   %ebp
  1001bc:	89 e5                	mov    %esp,%ebp
  1001be:	83 ec 08             	sub    $0x8,%esp
  1001c1:	e8 20 ff ff ff       	call   1000e6 <lab1_print_cur_status>
  1001c6:	83 ec 0c             	sub    $0xc,%esp
  1001c9:	68 c8 37 10 00       	push   $0x1037c8
  1001ce:	e8 77 00 00 00       	call   10024a <cprintf>
  1001d3:	83 c4 10             	add    $0x10,%esp
  1001d6:	e8 c8 ff ff ff       	call   1001a3 <lab1_switch_to_user>
  1001db:	e8 06 ff ff ff       	call   1000e6 <lab1_print_cur_status>
  1001e0:	83 ec 0c             	sub    $0xc,%esp
  1001e3:	68 e8 37 10 00       	push   $0x1037e8
  1001e8:	e8 5d 00 00 00       	call   10024a <cprintf>
  1001ed:	83 c4 10             	add    $0x10,%esp
  1001f0:	e8 bd ff ff ff       	call   1001b2 <lab1_switch_to_kernel>
  1001f5:	e8 ec fe ff ff       	call   1000e6 <lab1_print_cur_status>
  1001fa:	90                   	nop
  1001fb:	c9                   	leave  
  1001fc:	c3                   	ret    

001001fd <cputch>:
  1001fd:	55                   	push   %ebp
  1001fe:	89 e5                	mov    %esp,%ebp
  100200:	83 ec 08             	sub    $0x8,%esp
  100203:	83 ec 0c             	sub    $0xc,%esp
  100206:	ff 75 08             	pushl  0x8(%ebp)
  100209:	e8 97 13 00 00       	call   1015a5 <cons_putc>
  10020e:	83 c4 10             	add    $0x10,%esp
  100211:	8b 45 0c             	mov    0xc(%ebp),%eax
  100214:	8b 00                	mov    (%eax),%eax
  100216:	8d 50 01             	lea    0x1(%eax),%edx
  100219:	8b 45 0c             	mov    0xc(%ebp),%eax
  10021c:	89 10                	mov    %edx,(%eax)
  10021e:	90                   	nop
  10021f:	c9                   	leave  
  100220:	c3                   	ret    

00100221 <vcprintf>:
  100221:	55                   	push   %ebp
  100222:	89 e5                	mov    %esp,%ebp
  100224:	83 ec 18             	sub    $0x18,%esp
  100227:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  10022e:	ff 75 0c             	pushl  0xc(%ebp)
  100231:	ff 75 08             	pushl  0x8(%ebp)
  100234:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100237:	50                   	push   %eax
  100238:	68 fd 01 10 00       	push   $0x1001fd
  10023d:	e8 a4 30 00 00       	call   1032e6 <vprintfmt>
  100242:	83 c4 10             	add    $0x10,%esp
  100245:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100248:	c9                   	leave  
  100249:	c3                   	ret    

0010024a <cprintf>:
  10024a:	55                   	push   %ebp
  10024b:	89 e5                	mov    %esp,%ebp
  10024d:	83 ec 18             	sub    $0x18,%esp
  100250:	8d 45 0c             	lea    0xc(%ebp),%eax
  100253:	89 45 f0             	mov    %eax,-0x10(%ebp)
  100256:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100259:	83 ec 08             	sub    $0x8,%esp
  10025c:	50                   	push   %eax
  10025d:	ff 75 08             	pushl  0x8(%ebp)
  100260:	e8 bc ff ff ff       	call   100221 <vcprintf>
  100265:	83 c4 10             	add    $0x10,%esp
  100268:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10026b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10026e:	c9                   	leave  
  10026f:	c3                   	ret    

00100270 <cputchar>:
  100270:	55                   	push   %ebp
  100271:	89 e5                	mov    %esp,%ebp
  100273:	83 ec 08             	sub    $0x8,%esp
  100276:	83 ec 0c             	sub    $0xc,%esp
  100279:	ff 75 08             	pushl  0x8(%ebp)
  10027c:	e8 24 13 00 00       	call   1015a5 <cons_putc>
  100281:	83 c4 10             	add    $0x10,%esp
  100284:	90                   	nop
  100285:	c9                   	leave  
  100286:	c3                   	ret    

00100287 <cputs>:
  100287:	55                   	push   %ebp
  100288:	89 e5                	mov    %esp,%ebp
  10028a:	83 ec 18             	sub    $0x18,%esp
  10028d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  100294:	eb 14                	jmp    1002aa <cputs+0x23>
  100296:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  10029a:	83 ec 08             	sub    $0x8,%esp
  10029d:	8d 55 f0             	lea    -0x10(%ebp),%edx
  1002a0:	52                   	push   %edx
  1002a1:	50                   	push   %eax
  1002a2:	e8 56 ff ff ff       	call   1001fd <cputch>
  1002a7:	83 c4 10             	add    $0x10,%esp
  1002aa:	8b 45 08             	mov    0x8(%ebp),%eax
  1002ad:	8d 50 01             	lea    0x1(%eax),%edx
  1002b0:	89 55 08             	mov    %edx,0x8(%ebp)
  1002b3:	0f b6 00             	movzbl (%eax),%eax
  1002b6:	88 45 f7             	mov    %al,-0x9(%ebp)
  1002b9:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1002bd:	75 d7                	jne    100296 <cputs+0xf>
  1002bf:	83 ec 08             	sub    $0x8,%esp
  1002c2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1002c5:	50                   	push   %eax
  1002c6:	6a 0a                	push   $0xa
  1002c8:	e8 30 ff ff ff       	call   1001fd <cputch>
  1002cd:	83 c4 10             	add    $0x10,%esp
  1002d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002d3:	c9                   	leave  
  1002d4:	c3                   	ret    

001002d5 <getchar>:
  1002d5:	55                   	push   %ebp
  1002d6:	89 e5                	mov    %esp,%ebp
  1002d8:	83 ec 18             	sub    $0x18,%esp
  1002db:	90                   	nop
  1002dc:	e8 f4 12 00 00       	call   1015d5 <cons_getc>
  1002e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1002e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1002e8:	74 f2                	je     1002dc <getchar+0x7>
  1002ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002ed:	c9                   	leave  
  1002ee:	c3                   	ret    

001002ef <readline>:
  1002ef:	55                   	push   %ebp
  1002f0:	89 e5                	mov    %esp,%ebp
  1002f2:	83 ec 18             	sub    $0x18,%esp
  1002f5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1002f9:	74 13                	je     10030e <readline+0x1f>
  1002fb:	83 ec 08             	sub    $0x8,%esp
  1002fe:	ff 75 08             	pushl  0x8(%ebp)
  100301:	68 07 38 10 00       	push   $0x103807
  100306:	e8 3f ff ff ff       	call   10024a <cprintf>
  10030b:	83 c4 10             	add    $0x10,%esp
  10030e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100315:	e8 bb ff ff ff       	call   1002d5 <getchar>
  10031a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10031d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100321:	79 0a                	jns    10032d <readline+0x3e>
  100323:	b8 00 00 00 00       	mov    $0x0,%eax
  100328:	e9 82 00 00 00       	jmp    1003af <readline+0xc0>
  10032d:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100331:	7e 2b                	jle    10035e <readline+0x6f>
  100333:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  10033a:	7f 22                	jg     10035e <readline+0x6f>
  10033c:	83 ec 0c             	sub    $0xc,%esp
  10033f:	ff 75 f0             	pushl  -0x10(%ebp)
  100342:	e8 29 ff ff ff       	call   100270 <cputchar>
  100347:	83 c4 10             	add    $0x10,%esp
  10034a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10034d:	8d 50 01             	lea    0x1(%eax),%edx
  100350:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100353:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100356:	88 90 40 fa 10 00    	mov    %dl,0x10fa40(%eax)
  10035c:	eb 4c                	jmp    1003aa <readline+0xbb>
  10035e:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  100362:	75 1a                	jne    10037e <readline+0x8f>
  100364:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100368:	7e 14                	jle    10037e <readline+0x8f>
  10036a:	83 ec 0c             	sub    $0xc,%esp
  10036d:	ff 75 f0             	pushl  -0x10(%ebp)
  100370:	e8 fb fe ff ff       	call   100270 <cputchar>
  100375:	83 c4 10             	add    $0x10,%esp
  100378:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  10037c:	eb 2c                	jmp    1003aa <readline+0xbb>
  10037e:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  100382:	74 06                	je     10038a <readline+0x9b>
  100384:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  100388:	75 8b                	jne    100315 <readline+0x26>
  10038a:	83 ec 0c             	sub    $0xc,%esp
  10038d:	ff 75 f0             	pushl  -0x10(%ebp)
  100390:	e8 db fe ff ff       	call   100270 <cputchar>
  100395:	83 c4 10             	add    $0x10,%esp
  100398:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10039b:	05 40 fa 10 00       	add    $0x10fa40,%eax
  1003a0:	c6 00 00             	movb   $0x0,(%eax)
  1003a3:	b8 40 fa 10 00       	mov    $0x10fa40,%eax
  1003a8:	eb 05                	jmp    1003af <readline+0xc0>
  1003aa:	e9 66 ff ff ff       	jmp    100315 <readline+0x26>
  1003af:	c9                   	leave  
  1003b0:	c3                   	ret    

001003b1 <__panic>:
  1003b1:	55                   	push   %ebp
  1003b2:	89 e5                	mov    %esp,%ebp
  1003b4:	83 ec 18             	sub    $0x18,%esp
  1003b7:	a1 40 fe 10 00       	mov    0x10fe40,%eax
  1003bc:	85 c0                	test   %eax,%eax
  1003be:	75 5f                	jne    10041f <__panic+0x6e>
  1003c0:	c7 05 40 fe 10 00 01 	movl   $0x1,0x10fe40
  1003c7:	00 00 00 
  1003ca:	8d 45 14             	lea    0x14(%ebp),%eax
  1003cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003d0:	83 ec 04             	sub    $0x4,%esp
  1003d3:	ff 75 0c             	pushl  0xc(%ebp)
  1003d6:	ff 75 08             	pushl  0x8(%ebp)
  1003d9:	68 0a 38 10 00       	push   $0x10380a
  1003de:	e8 67 fe ff ff       	call   10024a <cprintf>
  1003e3:	83 c4 10             	add    $0x10,%esp
  1003e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003e9:	83 ec 08             	sub    $0x8,%esp
  1003ec:	50                   	push   %eax
  1003ed:	ff 75 10             	pushl  0x10(%ebp)
  1003f0:	e8 2c fe ff ff       	call   100221 <vcprintf>
  1003f5:	83 c4 10             	add    $0x10,%esp
  1003f8:	83 ec 0c             	sub    $0xc,%esp
  1003fb:	68 26 38 10 00       	push   $0x103826
  100400:	e8 45 fe ff ff       	call   10024a <cprintf>
  100405:	83 c4 10             	add    $0x10,%esp
  100408:	83 ec 0c             	sub    $0xc,%esp
  10040b:	68 28 38 10 00       	push   $0x103828
  100410:	e8 35 fe ff ff       	call   10024a <cprintf>
  100415:	83 c4 10             	add    $0x10,%esp
  100418:	e8 09 06 00 00       	call   100a26 <print_stackframe>
  10041d:	eb 01                	jmp    100420 <__panic+0x6f>
  10041f:	90                   	nop
  100420:	e8 d6 13 00 00       	call   1017fb <intr_disable>
  100425:	83 ec 0c             	sub    $0xc,%esp
  100428:	6a 00                	push   $0x0
  10042a:	e8 3a 08 00 00       	call   100c69 <kmonitor>
  10042f:	83 c4 10             	add    $0x10,%esp
  100432:	eb f1                	jmp    100425 <__panic+0x74>

00100434 <__warn>:
  100434:	55                   	push   %ebp
  100435:	89 e5                	mov    %esp,%ebp
  100437:	83 ec 18             	sub    $0x18,%esp
  10043a:	8d 45 14             	lea    0x14(%ebp),%eax
  10043d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100440:	83 ec 04             	sub    $0x4,%esp
  100443:	ff 75 0c             	pushl  0xc(%ebp)
  100446:	ff 75 08             	pushl  0x8(%ebp)
  100449:	68 3a 38 10 00       	push   $0x10383a
  10044e:	e8 f7 fd ff ff       	call   10024a <cprintf>
  100453:	83 c4 10             	add    $0x10,%esp
  100456:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100459:	83 ec 08             	sub    $0x8,%esp
  10045c:	50                   	push   %eax
  10045d:	ff 75 10             	pushl  0x10(%ebp)
  100460:	e8 bc fd ff ff       	call   100221 <vcprintf>
  100465:	83 c4 10             	add    $0x10,%esp
  100468:	83 ec 0c             	sub    $0xc,%esp
  10046b:	68 26 38 10 00       	push   $0x103826
  100470:	e8 d5 fd ff ff       	call   10024a <cprintf>
  100475:	83 c4 10             	add    $0x10,%esp
  100478:	90                   	nop
  100479:	c9                   	leave  
  10047a:	c3                   	ret    

0010047b <is_kernel_panic>:
  10047b:	55                   	push   %ebp
  10047c:	89 e5                	mov    %esp,%ebp
  10047e:	a1 40 fe 10 00       	mov    0x10fe40,%eax
  100483:	5d                   	pop    %ebp
  100484:	c3                   	ret    

00100485 <stab_binsearch>:
  100485:	55                   	push   %ebp
  100486:	89 e5                	mov    %esp,%ebp
  100488:	83 ec 20             	sub    $0x20,%esp
  10048b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10048e:	8b 00                	mov    (%eax),%eax
  100490:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100493:	8b 45 10             	mov    0x10(%ebp),%eax
  100496:	8b 00                	mov    (%eax),%eax
  100498:	89 45 f8             	mov    %eax,-0x8(%ebp)
  10049b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1004a2:	e9 d2 00 00 00       	jmp    100579 <stab_binsearch+0xf4>
  1004a7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1004ad:	01 d0                	add    %edx,%eax
  1004af:	89 c2                	mov    %eax,%edx
  1004b1:	c1 ea 1f             	shr    $0x1f,%edx
  1004b4:	01 d0                	add    %edx,%eax
  1004b6:	d1 f8                	sar    %eax
  1004b8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1004bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1004c1:	eb 04                	jmp    1004c7 <stab_binsearch+0x42>
  1004c3:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
  1004c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004ca:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004cd:	7c 1f                	jl     1004ee <stab_binsearch+0x69>
  1004cf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004d2:	89 d0                	mov    %edx,%eax
  1004d4:	01 c0                	add    %eax,%eax
  1004d6:	01 d0                	add    %edx,%eax
  1004d8:	c1 e0 02             	shl    $0x2,%eax
  1004db:	89 c2                	mov    %eax,%edx
  1004dd:	8b 45 08             	mov    0x8(%ebp),%eax
  1004e0:	01 d0                	add    %edx,%eax
  1004e2:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1004e6:	0f b6 c0             	movzbl %al,%eax
  1004e9:	39 45 14             	cmp    %eax,0x14(%ebp)
  1004ec:	75 d5                	jne    1004c3 <stab_binsearch+0x3e>
  1004ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004f1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004f4:	7d 0b                	jge    100501 <stab_binsearch+0x7c>
  1004f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004f9:	83 c0 01             	add    $0x1,%eax
  1004fc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1004ff:	eb 78                	jmp    100579 <stab_binsearch+0xf4>
  100501:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  100508:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10050b:	89 d0                	mov    %edx,%eax
  10050d:	01 c0                	add    %eax,%eax
  10050f:	01 d0                	add    %edx,%eax
  100511:	c1 e0 02             	shl    $0x2,%eax
  100514:	89 c2                	mov    %eax,%edx
  100516:	8b 45 08             	mov    0x8(%ebp),%eax
  100519:	01 d0                	add    %edx,%eax
  10051b:	8b 40 08             	mov    0x8(%eax),%eax
  10051e:	39 45 18             	cmp    %eax,0x18(%ebp)
  100521:	76 13                	jbe    100536 <stab_binsearch+0xb1>
  100523:	8b 45 0c             	mov    0xc(%ebp),%eax
  100526:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100529:	89 10                	mov    %edx,(%eax)
  10052b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10052e:	83 c0 01             	add    $0x1,%eax
  100531:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100534:	eb 43                	jmp    100579 <stab_binsearch+0xf4>
  100536:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100539:	89 d0                	mov    %edx,%eax
  10053b:	01 c0                	add    %eax,%eax
  10053d:	01 d0                	add    %edx,%eax
  10053f:	c1 e0 02             	shl    $0x2,%eax
  100542:	89 c2                	mov    %eax,%edx
  100544:	8b 45 08             	mov    0x8(%ebp),%eax
  100547:	01 d0                	add    %edx,%eax
  100549:	8b 40 08             	mov    0x8(%eax),%eax
  10054c:	39 45 18             	cmp    %eax,0x18(%ebp)
  10054f:	73 16                	jae    100567 <stab_binsearch+0xe2>
  100551:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100554:	8d 50 ff             	lea    -0x1(%eax),%edx
  100557:	8b 45 10             	mov    0x10(%ebp),%eax
  10055a:	89 10                	mov    %edx,(%eax)
  10055c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10055f:	83 e8 01             	sub    $0x1,%eax
  100562:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100565:	eb 12                	jmp    100579 <stab_binsearch+0xf4>
  100567:	8b 45 0c             	mov    0xc(%ebp),%eax
  10056a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10056d:	89 10                	mov    %edx,(%eax)
  10056f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100572:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100575:	83 45 18 01          	addl   $0x1,0x18(%ebp)
  100579:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10057c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  10057f:	0f 8e 22 ff ff ff    	jle    1004a7 <stab_binsearch+0x22>
  100585:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100589:	75 0f                	jne    10059a <stab_binsearch+0x115>
  10058b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10058e:	8b 00                	mov    (%eax),%eax
  100590:	8d 50 ff             	lea    -0x1(%eax),%edx
  100593:	8b 45 10             	mov    0x10(%ebp),%eax
  100596:	89 10                	mov    %edx,(%eax)
  100598:	eb 3f                	jmp    1005d9 <stab_binsearch+0x154>
  10059a:	8b 45 10             	mov    0x10(%ebp),%eax
  10059d:	8b 00                	mov    (%eax),%eax
  10059f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1005a2:	eb 04                	jmp    1005a8 <stab_binsearch+0x123>
  1005a4:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  1005a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005ab:	8b 00                	mov    (%eax),%eax
  1005ad:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  1005b0:	7e 1f                	jle    1005d1 <stab_binsearch+0x14c>
  1005b2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005b5:	89 d0                	mov    %edx,%eax
  1005b7:	01 c0                	add    %eax,%eax
  1005b9:	01 d0                	add    %edx,%eax
  1005bb:	c1 e0 02             	shl    $0x2,%eax
  1005be:	89 c2                	mov    %eax,%edx
  1005c0:	8b 45 08             	mov    0x8(%ebp),%eax
  1005c3:	01 d0                	add    %edx,%eax
  1005c5:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1005c9:	0f b6 c0             	movzbl %al,%eax
  1005cc:	39 45 14             	cmp    %eax,0x14(%ebp)
  1005cf:	75 d3                	jne    1005a4 <stab_binsearch+0x11f>
  1005d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005d4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005d7:	89 10                	mov    %edx,(%eax)
  1005d9:	90                   	nop
  1005da:	c9                   	leave  
  1005db:	c3                   	ret    

001005dc <debuginfo_eip>:
  1005dc:	55                   	push   %ebp
  1005dd:	89 e5                	mov    %esp,%ebp
  1005df:	83 ec 38             	sub    $0x38,%esp
  1005e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005e5:	c7 00 58 38 10 00    	movl   $0x103858,(%eax)
  1005eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005ee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  1005f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005f8:	c7 40 08 58 38 10 00 	movl   $0x103858,0x8(%eax)
  1005ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  100602:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
  100609:	8b 45 0c             	mov    0xc(%ebp),%eax
  10060c:	8b 55 08             	mov    0x8(%ebp),%edx
  10060f:	89 50 10             	mov    %edx,0x10(%eax)
  100612:	8b 45 0c             	mov    0xc(%ebp),%eax
  100615:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  10061c:	c7 45 f4 8c 40 10 00 	movl   $0x10408c,-0xc(%ebp)
  100623:	c7 45 f0 e0 cd 10 00 	movl   $0x10cde0,-0x10(%ebp)
  10062a:	c7 45 ec e1 cd 10 00 	movl   $0x10cde1,-0x14(%ebp)
  100631:	c7 45 e8 13 ef 10 00 	movl   $0x10ef13,-0x18(%ebp)
  100638:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10063b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10063e:	76 0d                	jbe    10064d <debuginfo_eip+0x71>
  100640:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100643:	83 e8 01             	sub    $0x1,%eax
  100646:	0f b6 00             	movzbl (%eax),%eax
  100649:	84 c0                	test   %al,%al
  10064b:	74 0a                	je     100657 <debuginfo_eip+0x7b>
  10064d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100652:	e9 85 02 00 00       	jmp    1008dc <debuginfo_eip+0x300>
  100657:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  10065e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100661:	2b 45 f4             	sub    -0xc(%ebp),%eax
  100664:	c1 f8 02             	sar    $0x2,%eax
  100667:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  10066d:	83 e8 01             	sub    $0x1,%eax
  100670:	89 45 e0             	mov    %eax,-0x20(%ebp)
  100673:	ff 75 08             	pushl  0x8(%ebp)
  100676:	6a 64                	push   $0x64
  100678:	8d 45 e0             	lea    -0x20(%ebp),%eax
  10067b:	50                   	push   %eax
  10067c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  10067f:	50                   	push   %eax
  100680:	ff 75 f4             	pushl  -0xc(%ebp)
  100683:	e8 fd fd ff ff       	call   100485 <stab_binsearch>
  100688:	83 c4 14             	add    $0x14,%esp
  10068b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10068e:	85 c0                	test   %eax,%eax
  100690:	75 0a                	jne    10069c <debuginfo_eip+0xc0>
  100692:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100697:	e9 40 02 00 00       	jmp    1008dc <debuginfo_eip+0x300>
  10069c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10069f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1006a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006a5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  1006a8:	ff 75 08             	pushl  0x8(%ebp)
  1006ab:	6a 24                	push   $0x24
  1006ad:	8d 45 d8             	lea    -0x28(%ebp),%eax
  1006b0:	50                   	push   %eax
  1006b1:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1006b4:	50                   	push   %eax
  1006b5:	ff 75 f4             	pushl  -0xc(%ebp)
  1006b8:	e8 c8 fd ff ff       	call   100485 <stab_binsearch>
  1006bd:	83 c4 14             	add    $0x14,%esp
  1006c0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1006c3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006c6:	39 c2                	cmp    %eax,%edx
  1006c8:	7f 78                	jg     100742 <debuginfo_eip+0x166>
  1006ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006cd:	89 c2                	mov    %eax,%edx
  1006cf:	89 d0                	mov    %edx,%eax
  1006d1:	01 c0                	add    %eax,%eax
  1006d3:	01 d0                	add    %edx,%eax
  1006d5:	c1 e0 02             	shl    $0x2,%eax
  1006d8:	89 c2                	mov    %eax,%edx
  1006da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006dd:	01 d0                	add    %edx,%eax
  1006df:	8b 10                	mov    (%eax),%edx
  1006e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1006e4:	2b 45 ec             	sub    -0x14(%ebp),%eax
  1006e7:	39 c2                	cmp    %eax,%edx
  1006e9:	73 22                	jae    10070d <debuginfo_eip+0x131>
  1006eb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006ee:	89 c2                	mov    %eax,%edx
  1006f0:	89 d0                	mov    %edx,%eax
  1006f2:	01 c0                	add    %eax,%eax
  1006f4:	01 d0                	add    %edx,%eax
  1006f6:	c1 e0 02             	shl    $0x2,%eax
  1006f9:	89 c2                	mov    %eax,%edx
  1006fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006fe:	01 d0                	add    %edx,%eax
  100700:	8b 10                	mov    (%eax),%edx
  100702:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100705:	01 c2                	add    %eax,%edx
  100707:	8b 45 0c             	mov    0xc(%ebp),%eax
  10070a:	89 50 08             	mov    %edx,0x8(%eax)
  10070d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100710:	89 c2                	mov    %eax,%edx
  100712:	89 d0                	mov    %edx,%eax
  100714:	01 c0                	add    %eax,%eax
  100716:	01 d0                	add    %edx,%eax
  100718:	c1 e0 02             	shl    $0x2,%eax
  10071b:	89 c2                	mov    %eax,%edx
  10071d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100720:	01 d0                	add    %edx,%eax
  100722:	8b 50 08             	mov    0x8(%eax),%edx
  100725:	8b 45 0c             	mov    0xc(%ebp),%eax
  100728:	89 50 10             	mov    %edx,0x10(%eax)
  10072b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10072e:	8b 40 10             	mov    0x10(%eax),%eax
  100731:	29 45 08             	sub    %eax,0x8(%ebp)
  100734:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100737:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  10073a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10073d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  100740:	eb 15                	jmp    100757 <debuginfo_eip+0x17b>
  100742:	8b 45 0c             	mov    0xc(%ebp),%eax
  100745:	8b 55 08             	mov    0x8(%ebp),%edx
  100748:	89 50 10             	mov    %edx,0x10(%eax)
  10074b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10074e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100751:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100754:	89 45 d0             	mov    %eax,-0x30(%ebp)
  100757:	8b 45 0c             	mov    0xc(%ebp),%eax
  10075a:	8b 40 08             	mov    0x8(%eax),%eax
  10075d:	83 ec 08             	sub    $0x8,%esp
  100760:	6a 3a                	push   $0x3a
  100762:	50                   	push   %eax
  100763:	e8 c1 26 00 00       	call   102e29 <strfind>
  100768:	83 c4 10             	add    $0x10,%esp
  10076b:	89 c2                	mov    %eax,%edx
  10076d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100770:	8b 40 08             	mov    0x8(%eax),%eax
  100773:	29 c2                	sub    %eax,%edx
  100775:	8b 45 0c             	mov    0xc(%ebp),%eax
  100778:	89 50 0c             	mov    %edx,0xc(%eax)
  10077b:	83 ec 0c             	sub    $0xc,%esp
  10077e:	ff 75 08             	pushl  0x8(%ebp)
  100781:	6a 44                	push   $0x44
  100783:	8d 45 d0             	lea    -0x30(%ebp),%eax
  100786:	50                   	push   %eax
  100787:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  10078a:	50                   	push   %eax
  10078b:	ff 75 f4             	pushl  -0xc(%ebp)
  10078e:	e8 f2 fc ff ff       	call   100485 <stab_binsearch>
  100793:	83 c4 20             	add    $0x20,%esp
  100796:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100799:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10079c:	39 c2                	cmp    %eax,%edx
  10079e:	7f 24                	jg     1007c4 <debuginfo_eip+0x1e8>
  1007a0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007a3:	89 c2                	mov    %eax,%edx
  1007a5:	89 d0                	mov    %edx,%eax
  1007a7:	01 c0                	add    %eax,%eax
  1007a9:	01 d0                	add    %edx,%eax
  1007ab:	c1 e0 02             	shl    $0x2,%eax
  1007ae:	89 c2                	mov    %eax,%edx
  1007b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007b3:	01 d0                	add    %edx,%eax
  1007b5:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  1007b9:	0f b7 d0             	movzwl %ax,%edx
  1007bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007bf:	89 50 04             	mov    %edx,0x4(%eax)
  1007c2:	eb 13                	jmp    1007d7 <debuginfo_eip+0x1fb>
  1007c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1007c9:	e9 0e 01 00 00       	jmp    1008dc <debuginfo_eip+0x300>
  1007ce:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007d1:	83 e8 01             	sub    $0x1,%eax
  1007d4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1007d7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007dd:	39 c2                	cmp    %eax,%edx
  1007df:	7c 56                	jl     100837 <debuginfo_eip+0x25b>
  1007e1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007e4:	89 c2                	mov    %eax,%edx
  1007e6:	89 d0                	mov    %edx,%eax
  1007e8:	01 c0                	add    %eax,%eax
  1007ea:	01 d0                	add    %edx,%eax
  1007ec:	c1 e0 02             	shl    $0x2,%eax
  1007ef:	89 c2                	mov    %eax,%edx
  1007f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007f4:	01 d0                	add    %edx,%eax
  1007f6:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1007fa:	3c 84                	cmp    $0x84,%al
  1007fc:	74 39                	je     100837 <debuginfo_eip+0x25b>
  1007fe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100801:	89 c2                	mov    %eax,%edx
  100803:	89 d0                	mov    %edx,%eax
  100805:	01 c0                	add    %eax,%eax
  100807:	01 d0                	add    %edx,%eax
  100809:	c1 e0 02             	shl    $0x2,%eax
  10080c:	89 c2                	mov    %eax,%edx
  10080e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100811:	01 d0                	add    %edx,%eax
  100813:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100817:	3c 64                	cmp    $0x64,%al
  100819:	75 b3                	jne    1007ce <debuginfo_eip+0x1f2>
  10081b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10081e:	89 c2                	mov    %eax,%edx
  100820:	89 d0                	mov    %edx,%eax
  100822:	01 c0                	add    %eax,%eax
  100824:	01 d0                	add    %edx,%eax
  100826:	c1 e0 02             	shl    $0x2,%eax
  100829:	89 c2                	mov    %eax,%edx
  10082b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10082e:	01 d0                	add    %edx,%eax
  100830:	8b 40 08             	mov    0x8(%eax),%eax
  100833:	85 c0                	test   %eax,%eax
  100835:	74 97                	je     1007ce <debuginfo_eip+0x1f2>
  100837:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10083a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10083d:	39 c2                	cmp    %eax,%edx
  10083f:	7c 42                	jl     100883 <debuginfo_eip+0x2a7>
  100841:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100844:	89 c2                	mov    %eax,%edx
  100846:	89 d0                	mov    %edx,%eax
  100848:	01 c0                	add    %eax,%eax
  10084a:	01 d0                	add    %edx,%eax
  10084c:	c1 e0 02             	shl    $0x2,%eax
  10084f:	89 c2                	mov    %eax,%edx
  100851:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100854:	01 d0                	add    %edx,%eax
  100856:	8b 10                	mov    (%eax),%edx
  100858:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10085b:	2b 45 ec             	sub    -0x14(%ebp),%eax
  10085e:	39 c2                	cmp    %eax,%edx
  100860:	73 21                	jae    100883 <debuginfo_eip+0x2a7>
  100862:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100865:	89 c2                	mov    %eax,%edx
  100867:	89 d0                	mov    %edx,%eax
  100869:	01 c0                	add    %eax,%eax
  10086b:	01 d0                	add    %edx,%eax
  10086d:	c1 e0 02             	shl    $0x2,%eax
  100870:	89 c2                	mov    %eax,%edx
  100872:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100875:	01 d0                	add    %edx,%eax
  100877:	8b 10                	mov    (%eax),%edx
  100879:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10087c:	01 c2                	add    %eax,%edx
  10087e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100881:	89 10                	mov    %edx,(%eax)
  100883:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100886:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100889:	39 c2                	cmp    %eax,%edx
  10088b:	7d 4a                	jge    1008d7 <debuginfo_eip+0x2fb>
  10088d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100890:	83 c0 01             	add    $0x1,%eax
  100893:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100896:	eb 18                	jmp    1008b0 <debuginfo_eip+0x2d4>
  100898:	8b 45 0c             	mov    0xc(%ebp),%eax
  10089b:	8b 40 14             	mov    0x14(%eax),%eax
  10089e:	8d 50 01             	lea    0x1(%eax),%edx
  1008a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008a4:	89 50 14             	mov    %edx,0x14(%eax)
  1008a7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008aa:	83 c0 01             	add    $0x1,%eax
  1008ad:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1008b0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1008b3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1008b6:	39 c2                	cmp    %eax,%edx
  1008b8:	7d 1d                	jge    1008d7 <debuginfo_eip+0x2fb>
  1008ba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008bd:	89 c2                	mov    %eax,%edx
  1008bf:	89 d0                	mov    %edx,%eax
  1008c1:	01 c0                	add    %eax,%eax
  1008c3:	01 d0                	add    %edx,%eax
  1008c5:	c1 e0 02             	shl    $0x2,%eax
  1008c8:	89 c2                	mov    %eax,%edx
  1008ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008cd:	01 d0                	add    %edx,%eax
  1008cf:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1008d3:	3c a0                	cmp    $0xa0,%al
  1008d5:	74 c1                	je     100898 <debuginfo_eip+0x2bc>
  1008d7:	b8 00 00 00 00       	mov    $0x0,%eax
  1008dc:	c9                   	leave  
  1008dd:	c3                   	ret    

001008de <print_kerninfo>:
  1008de:	55                   	push   %ebp
  1008df:	89 e5                	mov    %esp,%ebp
  1008e1:	83 ec 08             	sub    $0x8,%esp
  1008e4:	83 ec 0c             	sub    $0xc,%esp
  1008e7:	68 62 38 10 00       	push   $0x103862
  1008ec:	e8 59 f9 ff ff       	call   10024a <cprintf>
  1008f1:	83 c4 10             	add    $0x10,%esp
  1008f4:	83 ec 08             	sub    $0x8,%esp
  1008f7:	68 00 00 10 00       	push   $0x100000
  1008fc:	68 7b 38 10 00       	push   $0x10387b
  100901:	e8 44 f9 ff ff       	call   10024a <cprintf>
  100906:	83 c4 10             	add    $0x10,%esp
  100909:	83 ec 08             	sub    $0x8,%esp
  10090c:	68 47 37 10 00       	push   $0x103747
  100911:	68 93 38 10 00       	push   $0x103893
  100916:	e8 2f f9 ff ff       	call   10024a <cprintf>
  10091b:	83 c4 10             	add    $0x10,%esp
  10091e:	83 ec 08             	sub    $0x8,%esp
  100921:	68 16 fa 10 00       	push   $0x10fa16
  100926:	68 ab 38 10 00       	push   $0x1038ab
  10092b:	e8 1a f9 ff ff       	call   10024a <cprintf>
  100930:	83 c4 10             	add    $0x10,%esp
  100933:	83 ec 08             	sub    $0x8,%esp
  100936:	68 20 0d 11 00       	push   $0x110d20
  10093b:	68 c3 38 10 00       	push   $0x1038c3
  100940:	e8 05 f9 ff ff       	call   10024a <cprintf>
  100945:	83 c4 10             	add    $0x10,%esp
  100948:	b8 20 0d 11 00       	mov    $0x110d20,%eax
  10094d:	2d 00 00 10 00       	sub    $0x100000,%eax
  100952:	05 ff 03 00 00       	add    $0x3ff,%eax
  100957:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  10095d:	85 c0                	test   %eax,%eax
  10095f:	0f 48 c2             	cmovs  %edx,%eax
  100962:	c1 f8 0a             	sar    $0xa,%eax
  100965:	83 ec 08             	sub    $0x8,%esp
  100968:	50                   	push   %eax
  100969:	68 dc 38 10 00       	push   $0x1038dc
  10096e:	e8 d7 f8 ff ff       	call   10024a <cprintf>
  100973:	83 c4 10             	add    $0x10,%esp
  100976:	90                   	nop
  100977:	c9                   	leave  
  100978:	c3                   	ret    

00100979 <print_debuginfo>:
  100979:	55                   	push   %ebp
  10097a:	89 e5                	mov    %esp,%ebp
  10097c:	81 ec 28 01 00 00    	sub    $0x128,%esp
  100982:	83 ec 08             	sub    $0x8,%esp
  100985:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100988:	50                   	push   %eax
  100989:	ff 75 08             	pushl  0x8(%ebp)
  10098c:	e8 4b fc ff ff       	call   1005dc <debuginfo_eip>
  100991:	83 c4 10             	add    $0x10,%esp
  100994:	85 c0                	test   %eax,%eax
  100996:	74 15                	je     1009ad <print_debuginfo+0x34>
  100998:	83 ec 08             	sub    $0x8,%esp
  10099b:	ff 75 08             	pushl  0x8(%ebp)
  10099e:	68 06 39 10 00       	push   $0x103906
  1009a3:	e8 a2 f8 ff ff       	call   10024a <cprintf>
  1009a8:	83 c4 10             	add    $0x10,%esp
  1009ab:	eb 65                	jmp    100a12 <print_debuginfo+0x99>
  1009ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1009b4:	eb 1c                	jmp    1009d2 <print_debuginfo+0x59>
  1009b6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1009b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009bc:	01 d0                	add    %edx,%eax
  1009be:	0f b6 00             	movzbl (%eax),%eax
  1009c1:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  1009c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1009ca:	01 ca                	add    %ecx,%edx
  1009cc:	88 02                	mov    %al,(%edx)
  1009ce:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1009d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009d5:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  1009d8:	7c dc                	jl     1009b6 <print_debuginfo+0x3d>
  1009da:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  1009e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009e3:	01 d0                	add    %edx,%eax
  1009e5:	c6 00 00             	movb   $0x0,(%eax)
  1009e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1009eb:	8b 55 08             	mov    0x8(%ebp),%edx
  1009ee:	89 d1                	mov    %edx,%ecx
  1009f0:	29 c1                	sub    %eax,%ecx
  1009f2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1009f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1009f8:	83 ec 0c             	sub    $0xc,%esp
  1009fb:	51                   	push   %ecx
  1009fc:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a02:	51                   	push   %ecx
  100a03:	52                   	push   %edx
  100a04:	50                   	push   %eax
  100a05:	68 22 39 10 00       	push   $0x103922
  100a0a:	e8 3b f8 ff ff       	call   10024a <cprintf>
  100a0f:	83 c4 20             	add    $0x20,%esp
  100a12:	90                   	nop
  100a13:	c9                   	leave  
  100a14:	c3                   	ret    

00100a15 <read_eip>:
  100a15:	55                   	push   %ebp
  100a16:	89 e5                	mov    %esp,%ebp
  100a18:	83 ec 10             	sub    $0x10,%esp
  100a1b:	8b 45 04             	mov    0x4(%ebp),%eax
  100a1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100a21:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100a24:	c9                   	leave  
  100a25:	c3                   	ret    

00100a26 <print_stackframe>:
  100a26:	55                   	push   %ebp
  100a27:	89 e5                	mov    %esp,%ebp
  100a29:	83 ec 28             	sub    $0x28,%esp
  100a2c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100a33:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100a3a:	e8 d6 ff ff ff       	call   100a15 <read_eip>
  100a3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100a42:	89 e8                	mov    %ebp,%eax
  100a44:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  100a47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100a4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  100a4d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100a54:	e9 95 00 00 00       	jmp    100aee <print_stackframe+0xc8>
  100a59:	83 ec 04             	sub    $0x4,%esp
  100a5c:	ff 75 f4             	pushl  -0xc(%ebp)
  100a5f:	ff 75 f0             	pushl  -0x10(%ebp)
  100a62:	68 34 39 10 00       	push   $0x103934
  100a67:	e8 de f7 ff ff       	call   10024a <cprintf>
  100a6c:	83 c4 10             	add    $0x10,%esp
  100a6f:	83 ec 0c             	sub    $0xc,%esp
  100a72:	68 4b 39 10 00       	push   $0x10394b
  100a77:	e8 ce f7 ff ff       	call   10024a <cprintf>
  100a7c:	83 c4 10             	add    $0x10,%esp
  100a7f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100a86:	eb 27                	jmp    100aaf <print_stackframe+0x89>
  100a88:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a8b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100a92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a95:	01 d0                	add    %edx,%eax
  100a97:	83 c0 08             	add    $0x8,%eax
  100a9a:	83 ec 08             	sub    $0x8,%esp
  100a9d:	50                   	push   %eax
  100a9e:	68 51 39 10 00       	push   $0x103951
  100aa3:	e8 a2 f7 ff ff       	call   10024a <cprintf>
  100aa8:	83 c4 10             	add    $0x10,%esp
  100aab:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100aaf:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100ab3:	76 d3                	jbe    100a88 <print_stackframe+0x62>
  100ab5:	83 ec 0c             	sub    $0xc,%esp
  100ab8:	68 59 39 10 00       	push   $0x103959
  100abd:	e8 88 f7 ff ff       	call   10024a <cprintf>
  100ac2:	83 c4 10             	add    $0x10,%esp
  100ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ac8:	83 e8 01             	sub    $0x1,%eax
  100acb:	83 ec 0c             	sub    $0xc,%esp
  100ace:	50                   	push   %eax
  100acf:	e8 a5 fe ff ff       	call   100979 <print_debuginfo>
  100ad4:	83 c4 10             	add    $0x10,%esp
  100ad7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100ada:	8b 00                	mov    (%eax),%eax
  100adc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  100adf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100ae2:	83 c0 04             	add    $0x4,%eax
  100ae5:	8b 00                	mov    (%eax),%eax
  100ae7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100aea:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100aee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100af2:	74 0a                	je     100afe <print_stackframe+0xd8>
  100af4:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100af8:	0f 86 5b ff ff ff    	jbe    100a59 <print_stackframe+0x33>
  100afe:	90                   	nop
  100aff:	c9                   	leave  
  100b00:	c3                   	ret    

00100b01 <parse>:
  100b01:	55                   	push   %ebp
  100b02:	89 e5                	mov    %esp,%ebp
  100b04:	83 ec 18             	sub    $0x18,%esp
  100b07:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b0e:	eb 0c                	jmp    100b1c <parse+0x1b>
  100b10:	8b 45 08             	mov    0x8(%ebp),%eax
  100b13:	8d 50 01             	lea    0x1(%eax),%edx
  100b16:	89 55 08             	mov    %edx,0x8(%ebp)
  100b19:	c6 00 00             	movb   $0x0,(%eax)
  100b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  100b1f:	0f b6 00             	movzbl (%eax),%eax
  100b22:	84 c0                	test   %al,%al
  100b24:	74 1e                	je     100b44 <parse+0x43>
  100b26:	8b 45 08             	mov    0x8(%ebp),%eax
  100b29:	0f b6 00             	movzbl (%eax),%eax
  100b2c:	0f be c0             	movsbl %al,%eax
  100b2f:	83 ec 08             	sub    $0x8,%esp
  100b32:	50                   	push   %eax
  100b33:	68 dc 39 10 00       	push   $0x1039dc
  100b38:	e8 b9 22 00 00       	call   102df6 <strchr>
  100b3d:	83 c4 10             	add    $0x10,%esp
  100b40:	85 c0                	test   %eax,%eax
  100b42:	75 cc                	jne    100b10 <parse+0xf>
  100b44:	8b 45 08             	mov    0x8(%ebp),%eax
  100b47:	0f b6 00             	movzbl (%eax),%eax
  100b4a:	84 c0                	test   %al,%al
  100b4c:	74 65                	je     100bb3 <parse+0xb2>
  100b4e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100b52:	75 12                	jne    100b66 <parse+0x65>
  100b54:	83 ec 08             	sub    $0x8,%esp
  100b57:	6a 10                	push   $0x10
  100b59:	68 e1 39 10 00       	push   $0x1039e1
  100b5e:	e8 e7 f6 ff ff       	call   10024a <cprintf>
  100b63:	83 c4 10             	add    $0x10,%esp
  100b66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b69:	8d 50 01             	lea    0x1(%eax),%edx
  100b6c:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100b6f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100b76:	8b 45 0c             	mov    0xc(%ebp),%eax
  100b79:	01 c2                	add    %eax,%edx
  100b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  100b7e:	89 02                	mov    %eax,(%edx)
  100b80:	eb 04                	jmp    100b86 <parse+0x85>
  100b82:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  100b86:	8b 45 08             	mov    0x8(%ebp),%eax
  100b89:	0f b6 00             	movzbl (%eax),%eax
  100b8c:	84 c0                	test   %al,%al
  100b8e:	74 8c                	je     100b1c <parse+0x1b>
  100b90:	8b 45 08             	mov    0x8(%ebp),%eax
  100b93:	0f b6 00             	movzbl (%eax),%eax
  100b96:	0f be c0             	movsbl %al,%eax
  100b99:	83 ec 08             	sub    $0x8,%esp
  100b9c:	50                   	push   %eax
  100b9d:	68 dc 39 10 00       	push   $0x1039dc
  100ba2:	e8 4f 22 00 00       	call   102df6 <strchr>
  100ba7:	83 c4 10             	add    $0x10,%esp
  100baa:	85 c0                	test   %eax,%eax
  100bac:	74 d4                	je     100b82 <parse+0x81>
  100bae:	e9 69 ff ff ff       	jmp    100b1c <parse+0x1b>
  100bb3:	90                   	nop
  100bb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bb7:	c9                   	leave  
  100bb8:	c3                   	ret    

00100bb9 <runcmd>:
  100bb9:	55                   	push   %ebp
  100bba:	89 e5                	mov    %esp,%ebp
  100bbc:	83 ec 58             	sub    $0x58,%esp
  100bbf:	83 ec 08             	sub    $0x8,%esp
  100bc2:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100bc5:	50                   	push   %eax
  100bc6:	ff 75 08             	pushl  0x8(%ebp)
  100bc9:	e8 33 ff ff ff       	call   100b01 <parse>
  100bce:	83 c4 10             	add    $0x10,%esp
  100bd1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  100bd4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100bd8:	75 0a                	jne    100be4 <runcmd+0x2b>
  100bda:	b8 00 00 00 00       	mov    $0x0,%eax
  100bdf:	e9 83 00 00 00       	jmp    100c67 <runcmd+0xae>
  100be4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100beb:	eb 59                	jmp    100c46 <runcmd+0x8d>
  100bed:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100bf0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100bf3:	89 d0                	mov    %edx,%eax
  100bf5:	01 c0                	add    %eax,%eax
  100bf7:	01 d0                	add    %edx,%eax
  100bf9:	c1 e0 02             	shl    $0x2,%eax
  100bfc:	05 00 f0 10 00       	add    $0x10f000,%eax
  100c01:	8b 00                	mov    (%eax),%eax
  100c03:	83 ec 08             	sub    $0x8,%esp
  100c06:	51                   	push   %ecx
  100c07:	50                   	push   %eax
  100c08:	e8 49 21 00 00       	call   102d56 <strcmp>
  100c0d:	83 c4 10             	add    $0x10,%esp
  100c10:	85 c0                	test   %eax,%eax
  100c12:	75 2e                	jne    100c42 <runcmd+0x89>
  100c14:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c17:	89 d0                	mov    %edx,%eax
  100c19:	01 c0                	add    %eax,%eax
  100c1b:	01 d0                	add    %edx,%eax
  100c1d:	c1 e0 02             	shl    $0x2,%eax
  100c20:	05 08 f0 10 00       	add    $0x10f008,%eax
  100c25:	8b 10                	mov    (%eax),%edx
  100c27:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c2a:	83 c0 04             	add    $0x4,%eax
  100c2d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100c30:	83 e9 01             	sub    $0x1,%ecx
  100c33:	83 ec 04             	sub    $0x4,%esp
  100c36:	ff 75 0c             	pushl  0xc(%ebp)
  100c39:	50                   	push   %eax
  100c3a:	51                   	push   %ecx
  100c3b:	ff d2                	call   *%edx
  100c3d:	83 c4 10             	add    $0x10,%esp
  100c40:	eb 25                	jmp    100c67 <runcmd+0xae>
  100c42:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c49:	83 f8 02             	cmp    $0x2,%eax
  100c4c:	76 9f                	jbe    100bed <runcmd+0x34>
  100c4e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100c51:	83 ec 08             	sub    $0x8,%esp
  100c54:	50                   	push   %eax
  100c55:	68 ff 39 10 00       	push   $0x1039ff
  100c5a:	e8 eb f5 ff ff       	call   10024a <cprintf>
  100c5f:	83 c4 10             	add    $0x10,%esp
  100c62:	b8 00 00 00 00       	mov    $0x0,%eax
  100c67:	c9                   	leave  
  100c68:	c3                   	ret    

00100c69 <kmonitor>:
  100c69:	55                   	push   %ebp
  100c6a:	89 e5                	mov    %esp,%ebp
  100c6c:	83 ec 18             	sub    $0x18,%esp
  100c6f:	83 ec 0c             	sub    $0xc,%esp
  100c72:	68 18 3a 10 00       	push   $0x103a18
  100c77:	e8 ce f5 ff ff       	call   10024a <cprintf>
  100c7c:	83 c4 10             	add    $0x10,%esp
  100c7f:	83 ec 0c             	sub    $0xc,%esp
  100c82:	68 40 3a 10 00       	push   $0x103a40
  100c87:	e8 be f5 ff ff       	call   10024a <cprintf>
  100c8c:	83 c4 10             	add    $0x10,%esp
  100c8f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c93:	74 0e                	je     100ca3 <kmonitor+0x3a>
  100c95:	83 ec 0c             	sub    $0xc,%esp
  100c98:	ff 75 08             	pushl  0x8(%ebp)
  100c9b:	e8 62 0e 00 00       	call   101b02 <print_trapframe>
  100ca0:	83 c4 10             	add    $0x10,%esp
  100ca3:	83 ec 0c             	sub    $0xc,%esp
  100ca6:	68 65 3a 10 00       	push   $0x103a65
  100cab:	e8 3f f6 ff ff       	call   1002ef <readline>
  100cb0:	83 c4 10             	add    $0x10,%esp
  100cb3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100cb6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100cba:	74 e7                	je     100ca3 <kmonitor+0x3a>
  100cbc:	83 ec 08             	sub    $0x8,%esp
  100cbf:	ff 75 08             	pushl  0x8(%ebp)
  100cc2:	ff 75 f4             	pushl  -0xc(%ebp)
  100cc5:	e8 ef fe ff ff       	call   100bb9 <runcmd>
  100cca:	83 c4 10             	add    $0x10,%esp
  100ccd:	85 c0                	test   %eax,%eax
  100ccf:	78 02                	js     100cd3 <kmonitor+0x6a>
  100cd1:	eb d0                	jmp    100ca3 <kmonitor+0x3a>
  100cd3:	90                   	nop
  100cd4:	90                   	nop
  100cd5:	c9                   	leave  
  100cd6:	c3                   	ret    

00100cd7 <mon_help>:
  100cd7:	55                   	push   %ebp
  100cd8:	89 e5                	mov    %esp,%ebp
  100cda:	83 ec 18             	sub    $0x18,%esp
  100cdd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100ce4:	eb 3c                	jmp    100d22 <mon_help+0x4b>
  100ce6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100ce9:	89 d0                	mov    %edx,%eax
  100ceb:	01 c0                	add    %eax,%eax
  100ced:	01 d0                	add    %edx,%eax
  100cef:	c1 e0 02             	shl    $0x2,%eax
  100cf2:	05 04 f0 10 00       	add    $0x10f004,%eax
  100cf7:	8b 08                	mov    (%eax),%ecx
  100cf9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100cfc:	89 d0                	mov    %edx,%eax
  100cfe:	01 c0                	add    %eax,%eax
  100d00:	01 d0                	add    %edx,%eax
  100d02:	c1 e0 02             	shl    $0x2,%eax
  100d05:	05 00 f0 10 00       	add    $0x10f000,%eax
  100d0a:	8b 00                	mov    (%eax),%eax
  100d0c:	83 ec 04             	sub    $0x4,%esp
  100d0f:	51                   	push   %ecx
  100d10:	50                   	push   %eax
  100d11:	68 69 3a 10 00       	push   $0x103a69
  100d16:	e8 2f f5 ff ff       	call   10024a <cprintf>
  100d1b:	83 c4 10             	add    $0x10,%esp
  100d1e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100d22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d25:	83 f8 02             	cmp    $0x2,%eax
  100d28:	76 bc                	jbe    100ce6 <mon_help+0xf>
  100d2a:	b8 00 00 00 00       	mov    $0x0,%eax
  100d2f:	c9                   	leave  
  100d30:	c3                   	ret    

00100d31 <mon_kerninfo>:
  100d31:	55                   	push   %ebp
  100d32:	89 e5                	mov    %esp,%ebp
  100d34:	83 ec 08             	sub    $0x8,%esp
  100d37:	e8 a2 fb ff ff       	call   1008de <print_kerninfo>
  100d3c:	b8 00 00 00 00       	mov    $0x0,%eax
  100d41:	c9                   	leave  
  100d42:	c3                   	ret    

00100d43 <mon_backtrace>:
  100d43:	55                   	push   %ebp
  100d44:	89 e5                	mov    %esp,%ebp
  100d46:	83 ec 08             	sub    $0x8,%esp
  100d49:	e8 d8 fc ff ff       	call   100a26 <print_stackframe>
  100d4e:	b8 00 00 00 00       	mov    $0x0,%eax
  100d53:	c9                   	leave  
  100d54:	c3                   	ret    

00100d55 <clock_init>:
  100d55:	55                   	push   %ebp
  100d56:	89 e5                	mov    %esp,%ebp
  100d58:	83 ec 18             	sub    $0x18,%esp
  100d5b:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100d61:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
  100d65:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100d69:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100d6d:	ee                   	out    %al,(%dx)
  100d6e:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d74:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100d78:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100d7c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100d80:	ee                   	out    %al,(%dx)
  100d81:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100d87:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
  100d8b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100d8f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d93:	ee                   	out    %al,(%dx)
  100d94:	c7 05 08 09 11 00 00 	movl   $0x0,0x110908
  100d9b:	00 00 00 
  100d9e:	83 ec 0c             	sub    $0xc,%esp
  100da1:	68 72 3a 10 00       	push   $0x103a72
  100da6:	e8 9f f4 ff ff       	call   10024a <cprintf>
  100dab:	83 c4 10             	add    $0x10,%esp
  100dae:	83 ec 0c             	sub    $0xc,%esp
  100db1:	6a 00                	push   $0x0
  100db3:	e8 d2 08 00 00       	call   10168a <pic_enable>
  100db8:	83 c4 10             	add    $0x10,%esp
  100dbb:	90                   	nop
  100dbc:	c9                   	leave  
  100dbd:	c3                   	ret    

00100dbe <delay>:
  100dbe:	55                   	push   %ebp
  100dbf:	89 e5                	mov    %esp,%ebp
  100dc1:	83 ec 10             	sub    $0x10,%esp
  100dc4:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100dca:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100dce:	89 c2                	mov    %eax,%edx
  100dd0:	ec                   	in     (%dx),%al
  100dd1:	88 45 f1             	mov    %al,-0xf(%ebp)
  100dd4:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100dda:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100dde:	89 c2                	mov    %eax,%edx
  100de0:	ec                   	in     (%dx),%al
  100de1:	88 45 f5             	mov    %al,-0xb(%ebp)
  100de4:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100dea:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100dee:	89 c2                	mov    %eax,%edx
  100df0:	ec                   	in     (%dx),%al
  100df1:	88 45 f9             	mov    %al,-0x7(%ebp)
  100df4:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  100dfa:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100dfe:	89 c2                	mov    %eax,%edx
  100e00:	ec                   	in     (%dx),%al
  100e01:	88 45 fd             	mov    %al,-0x3(%ebp)
  100e04:	90                   	nop
  100e05:	c9                   	leave  
  100e06:	c3                   	ret    

00100e07 <cga_init>:
  100e07:	55                   	push   %ebp
  100e08:	89 e5                	mov    %esp,%ebp
  100e0a:	83 ec 20             	sub    $0x20,%esp
  100e0d:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
  100e14:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e17:	0f b7 00             	movzwl (%eax),%eax
  100e1a:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  100e1e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e21:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
  100e26:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e29:	0f b7 00             	movzwl (%eax),%eax
  100e2c:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e30:	74 12                	je     100e44 <cga_init+0x3d>
  100e32:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
  100e39:	66 c7 05 66 fe 10 00 	movw   $0x3b4,0x10fe66
  100e40:	b4 03 
  100e42:	eb 13                	jmp    100e57 <cga_init+0x50>
  100e44:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e47:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e4b:	66 89 10             	mov    %dx,(%eax)
  100e4e:	66 c7 05 66 fe 10 00 	movw   $0x3d4,0x10fe66
  100e55:	d4 03 
  100e57:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  100e5e:	0f b7 c0             	movzwl %ax,%eax
  100e61:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100e65:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
  100e69:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100e6d:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100e71:	ee                   	out    %al,(%dx)
  100e72:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  100e79:	83 c0 01             	add    $0x1,%eax
  100e7c:	0f b7 c0             	movzwl %ax,%eax
  100e7f:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100e83:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
  100e87:	89 c2                	mov    %eax,%edx
  100e89:	ec                   	in     (%dx),%al
  100e8a:	88 45 e9             	mov    %al,-0x17(%ebp)
  100e8d:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100e91:	0f b6 c0             	movzbl %al,%eax
  100e94:	c1 e0 08             	shl    $0x8,%eax
  100e97:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100e9a:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  100ea1:	0f b7 c0             	movzwl %ax,%eax
  100ea4:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100ea8:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
  100eac:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100eb0:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100eb4:	ee                   	out    %al,(%dx)
  100eb5:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  100ebc:	83 c0 01             	add    $0x1,%eax
  100ebf:	0f b7 c0             	movzwl %ax,%eax
  100ec2:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100ec6:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100eca:	89 c2                	mov    %eax,%edx
  100ecc:	ec                   	in     (%dx),%al
  100ecd:	88 45 f1             	mov    %al,-0xf(%ebp)
  100ed0:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100ed4:	0f b6 c0             	movzbl %al,%eax
  100ed7:	09 45 f4             	or     %eax,-0xc(%ebp)
  100eda:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100edd:	a3 60 fe 10 00       	mov    %eax,0x10fe60
  100ee2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ee5:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
  100eeb:	90                   	nop
  100eec:	c9                   	leave  
  100eed:	c3                   	ret    

00100eee <serial_init>:
  100eee:	55                   	push   %ebp
  100eef:	89 e5                	mov    %esp,%ebp
  100ef1:	83 ec 38             	sub    $0x38,%esp
  100ef4:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  100efa:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
  100efe:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  100f02:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  100f06:	ee                   	out    %al,(%dx)
  100f07:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  100f0d:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
  100f11:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  100f15:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  100f19:	ee                   	out    %al,(%dx)
  100f1a:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  100f20:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
  100f24:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  100f28:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  100f2c:	ee                   	out    %al,(%dx)
  100f2d:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100f33:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
  100f37:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f3b:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100f3f:	ee                   	out    %al,(%dx)
  100f40:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  100f46:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
  100f4a:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100f4e:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100f52:	ee                   	out    %al,(%dx)
  100f53:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  100f59:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
  100f5d:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f61:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f65:	ee                   	out    %al,(%dx)
  100f66:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f6c:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
  100f70:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f74:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f78:	ee                   	out    %al,(%dx)
  100f79:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
  100f7f:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100f83:	89 c2                	mov    %eax,%edx
  100f85:	ec                   	in     (%dx),%al
  100f86:	88 45 ed             	mov    %al,-0x13(%ebp)
  100f89:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f8d:	3c ff                	cmp    $0xff,%al
  100f8f:	0f 95 c0             	setne  %al
  100f92:	0f b6 c0             	movzbl %al,%eax
  100f95:	a3 68 fe 10 00       	mov    %eax,0x10fe68
  100f9a:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
  100fa0:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100fa4:	89 c2                	mov    %eax,%edx
  100fa6:	ec                   	in     (%dx),%al
  100fa7:	88 45 f1             	mov    %al,-0xf(%ebp)
  100faa:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  100fb0:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100fb4:	89 c2                	mov    %eax,%edx
  100fb6:	ec                   	in     (%dx),%al
  100fb7:	88 45 f5             	mov    %al,-0xb(%ebp)
  100fba:	a1 68 fe 10 00       	mov    0x10fe68,%eax
  100fbf:	85 c0                	test   %eax,%eax
  100fc1:	74 0d                	je     100fd0 <serial_init+0xe2>
  100fc3:	83 ec 0c             	sub    $0xc,%esp
  100fc6:	6a 04                	push   $0x4
  100fc8:	e8 bd 06 00 00       	call   10168a <pic_enable>
  100fcd:	83 c4 10             	add    $0x10,%esp
  100fd0:	90                   	nop
  100fd1:	c9                   	leave  
  100fd2:	c3                   	ret    

00100fd3 <lpt_putc_sub>:
  100fd3:	55                   	push   %ebp
  100fd4:	89 e5                	mov    %esp,%ebp
  100fd6:	83 ec 20             	sub    $0x20,%esp
  100fd9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100fe0:	eb 09                	jmp    100feb <lpt_putc_sub+0x18>
  100fe2:	e8 d7 fd ff ff       	call   100dbe <delay>
  100fe7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100feb:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  100ff1:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100ff5:	89 c2                	mov    %eax,%edx
  100ff7:	ec                   	in     (%dx),%al
  100ff8:	88 45 f9             	mov    %al,-0x7(%ebp)
  100ffb:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  100fff:	84 c0                	test   %al,%al
  101001:	78 09                	js     10100c <lpt_putc_sub+0x39>
  101003:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10100a:	7e d6                	jle    100fe2 <lpt_putc_sub+0xf>
  10100c:	8b 45 08             	mov    0x8(%ebp),%eax
  10100f:	0f b6 c0             	movzbl %al,%eax
  101012:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  101018:	88 45 ed             	mov    %al,-0x13(%ebp)
  10101b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10101f:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101023:	ee                   	out    %al,(%dx)
  101024:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  10102a:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  10102e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101032:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101036:	ee                   	out    %al,(%dx)
  101037:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  10103d:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
  101041:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101045:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101049:	ee                   	out    %al,(%dx)
  10104a:	90                   	nop
  10104b:	c9                   	leave  
  10104c:	c3                   	ret    

0010104d <lpt_putc>:
  10104d:	55                   	push   %ebp
  10104e:	89 e5                	mov    %esp,%ebp
  101050:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101054:	74 0d                	je     101063 <lpt_putc+0x16>
  101056:	ff 75 08             	pushl  0x8(%ebp)
  101059:	e8 75 ff ff ff       	call   100fd3 <lpt_putc_sub>
  10105e:	83 c4 04             	add    $0x4,%esp
  101061:	eb 1e                	jmp    101081 <lpt_putc+0x34>
  101063:	6a 08                	push   $0x8
  101065:	e8 69 ff ff ff       	call   100fd3 <lpt_putc_sub>
  10106a:	83 c4 04             	add    $0x4,%esp
  10106d:	6a 20                	push   $0x20
  10106f:	e8 5f ff ff ff       	call   100fd3 <lpt_putc_sub>
  101074:	83 c4 04             	add    $0x4,%esp
  101077:	6a 08                	push   $0x8
  101079:	e8 55 ff ff ff       	call   100fd3 <lpt_putc_sub>
  10107e:	83 c4 04             	add    $0x4,%esp
  101081:	90                   	nop
  101082:	c9                   	leave  
  101083:	c3                   	ret    

00101084 <cga_putc>:
  101084:	55                   	push   %ebp
  101085:	89 e5                	mov    %esp,%ebp
  101087:	53                   	push   %ebx
  101088:	83 ec 24             	sub    $0x24,%esp
  10108b:	8b 45 08             	mov    0x8(%ebp),%eax
  10108e:	b0 00                	mov    $0x0,%al
  101090:	85 c0                	test   %eax,%eax
  101092:	75 07                	jne    10109b <cga_putc+0x17>
  101094:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
  10109b:	8b 45 08             	mov    0x8(%ebp),%eax
  10109e:	0f b6 c0             	movzbl %al,%eax
  1010a1:	83 f8 0a             	cmp    $0xa,%eax
  1010a4:	74 52                	je     1010f8 <cga_putc+0x74>
  1010a6:	83 f8 0d             	cmp    $0xd,%eax
  1010a9:	74 5d                	je     101108 <cga_putc+0x84>
  1010ab:	83 f8 08             	cmp    $0x8,%eax
  1010ae:	0f 85 8e 00 00 00    	jne    101142 <cga_putc+0xbe>
  1010b4:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  1010bb:	66 85 c0             	test   %ax,%ax
  1010be:	0f 84 a4 00 00 00    	je     101168 <cga_putc+0xe4>
  1010c4:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  1010cb:	83 e8 01             	sub    $0x1,%eax
  1010ce:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
  1010d4:	8b 45 08             	mov    0x8(%ebp),%eax
  1010d7:	b0 00                	mov    $0x0,%al
  1010d9:	83 c8 20             	or     $0x20,%eax
  1010dc:	89 c1                	mov    %eax,%ecx
  1010de:	a1 60 fe 10 00       	mov    0x10fe60,%eax
  1010e3:	0f b7 15 64 fe 10 00 	movzwl 0x10fe64,%edx
  1010ea:	0f b7 d2             	movzwl %dx,%edx
  1010ed:	01 d2                	add    %edx,%edx
  1010ef:	01 d0                	add    %edx,%eax
  1010f1:	89 ca                	mov    %ecx,%edx
  1010f3:	66 89 10             	mov    %dx,(%eax)
  1010f6:	eb 70                	jmp    101168 <cga_putc+0xe4>
  1010f8:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  1010ff:	83 c0 50             	add    $0x50,%eax
  101102:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
  101108:	0f b7 1d 64 fe 10 00 	movzwl 0x10fe64,%ebx
  10110f:	0f b7 0d 64 fe 10 00 	movzwl 0x10fe64,%ecx
  101116:	0f b7 c1             	movzwl %cx,%eax
  101119:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  10111f:	c1 e8 10             	shr    $0x10,%eax
  101122:	89 c2                	mov    %eax,%edx
  101124:	66 c1 ea 06          	shr    $0x6,%dx
  101128:	89 d0                	mov    %edx,%eax
  10112a:	c1 e0 02             	shl    $0x2,%eax
  10112d:	01 d0                	add    %edx,%eax
  10112f:	c1 e0 04             	shl    $0x4,%eax
  101132:	29 c1                	sub    %eax,%ecx
  101134:	89 ca                	mov    %ecx,%edx
  101136:	89 d8                	mov    %ebx,%eax
  101138:	29 d0                	sub    %edx,%eax
  10113a:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
  101140:	eb 27                	jmp    101169 <cga_putc+0xe5>
  101142:	8b 0d 60 fe 10 00    	mov    0x10fe60,%ecx
  101148:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  10114f:	8d 50 01             	lea    0x1(%eax),%edx
  101152:	66 89 15 64 fe 10 00 	mov    %dx,0x10fe64
  101159:	0f b7 c0             	movzwl %ax,%eax
  10115c:	01 c0                	add    %eax,%eax
  10115e:	01 c8                	add    %ecx,%eax
  101160:	8b 55 08             	mov    0x8(%ebp),%edx
  101163:	66 89 10             	mov    %dx,(%eax)
  101166:	eb 01                	jmp    101169 <cga_putc+0xe5>
  101168:	90                   	nop
  101169:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  101170:	66 3d cf 07          	cmp    $0x7cf,%ax
  101174:	76 59                	jbe    1011cf <cga_putc+0x14b>
  101176:	a1 60 fe 10 00       	mov    0x10fe60,%eax
  10117b:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  101181:	a1 60 fe 10 00       	mov    0x10fe60,%eax
  101186:	83 ec 04             	sub    $0x4,%esp
  101189:	68 00 0f 00 00       	push   $0xf00
  10118e:	52                   	push   %edx
  10118f:	50                   	push   %eax
  101190:	e8 60 1e 00 00       	call   102ff5 <memmove>
  101195:	83 c4 10             	add    $0x10,%esp
  101198:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  10119f:	eb 15                	jmp    1011b6 <cga_putc+0x132>
  1011a1:	a1 60 fe 10 00       	mov    0x10fe60,%eax
  1011a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1011a9:	01 d2                	add    %edx,%edx
  1011ab:	01 d0                	add    %edx,%eax
  1011ad:	66 c7 00 20 07       	movw   $0x720,(%eax)
  1011b2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1011b6:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1011bd:	7e e2                	jle    1011a1 <cga_putc+0x11d>
  1011bf:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  1011c6:	83 e8 50             	sub    $0x50,%eax
  1011c9:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
  1011cf:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  1011d6:	0f b7 c0             	movzwl %ax,%eax
  1011d9:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  1011dd:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
  1011e1:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1011e5:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1011e9:	ee                   	out    %al,(%dx)
  1011ea:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  1011f1:	66 c1 e8 08          	shr    $0x8,%ax
  1011f5:	0f b6 c0             	movzbl %al,%eax
  1011f8:	0f b7 15 66 fe 10 00 	movzwl 0x10fe66,%edx
  1011ff:	83 c2 01             	add    $0x1,%edx
  101202:	0f b7 d2             	movzwl %dx,%edx
  101205:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  101209:	88 45 e9             	mov    %al,-0x17(%ebp)
  10120c:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101210:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101214:	ee                   	out    %al,(%dx)
  101215:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  10121c:	0f b7 c0             	movzwl %ax,%eax
  10121f:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  101223:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
  101227:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10122b:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10122f:	ee                   	out    %al,(%dx)
  101230:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  101237:	0f b6 c0             	movzbl %al,%eax
  10123a:	0f b7 15 66 fe 10 00 	movzwl 0x10fe66,%edx
  101241:	83 c2 01             	add    $0x1,%edx
  101244:	0f b7 d2             	movzwl %dx,%edx
  101247:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  10124b:	88 45 f1             	mov    %al,-0xf(%ebp)
  10124e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101252:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101256:	ee                   	out    %al,(%dx)
  101257:	90                   	nop
  101258:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  10125b:	c9                   	leave  
  10125c:	c3                   	ret    

0010125d <serial_putc_sub>:
  10125d:	55                   	push   %ebp
  10125e:	89 e5                	mov    %esp,%ebp
  101260:	83 ec 10             	sub    $0x10,%esp
  101263:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10126a:	eb 09                	jmp    101275 <serial_putc_sub+0x18>
  10126c:	e8 4d fb ff ff       	call   100dbe <delay>
  101271:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101275:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
  10127b:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10127f:	89 c2                	mov    %eax,%edx
  101281:	ec                   	in     (%dx),%al
  101282:	88 45 f9             	mov    %al,-0x7(%ebp)
  101285:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101289:	0f b6 c0             	movzbl %al,%eax
  10128c:	83 e0 20             	and    $0x20,%eax
  10128f:	85 c0                	test   %eax,%eax
  101291:	75 09                	jne    10129c <serial_putc_sub+0x3f>
  101293:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10129a:	7e d0                	jle    10126c <serial_putc_sub+0xf>
  10129c:	8b 45 08             	mov    0x8(%ebp),%eax
  10129f:	0f b6 c0             	movzbl %al,%eax
  1012a2:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  1012a8:	88 45 f5             	mov    %al,-0xb(%ebp)
  1012ab:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1012af:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1012b3:	ee                   	out    %al,(%dx)
  1012b4:	90                   	nop
  1012b5:	c9                   	leave  
  1012b6:	c3                   	ret    

001012b7 <serial_putc>:
  1012b7:	55                   	push   %ebp
  1012b8:	89 e5                	mov    %esp,%ebp
  1012ba:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1012be:	74 0d                	je     1012cd <serial_putc+0x16>
  1012c0:	ff 75 08             	pushl  0x8(%ebp)
  1012c3:	e8 95 ff ff ff       	call   10125d <serial_putc_sub>
  1012c8:	83 c4 04             	add    $0x4,%esp
  1012cb:	eb 1e                	jmp    1012eb <serial_putc+0x34>
  1012cd:	6a 08                	push   $0x8
  1012cf:	e8 89 ff ff ff       	call   10125d <serial_putc_sub>
  1012d4:	83 c4 04             	add    $0x4,%esp
  1012d7:	6a 20                	push   $0x20
  1012d9:	e8 7f ff ff ff       	call   10125d <serial_putc_sub>
  1012de:	83 c4 04             	add    $0x4,%esp
  1012e1:	6a 08                	push   $0x8
  1012e3:	e8 75 ff ff ff       	call   10125d <serial_putc_sub>
  1012e8:	83 c4 04             	add    $0x4,%esp
  1012eb:	90                   	nop
  1012ec:	c9                   	leave  
  1012ed:	c3                   	ret    

001012ee <cons_intr>:
  1012ee:	55                   	push   %ebp
  1012ef:	89 e5                	mov    %esp,%ebp
  1012f1:	83 ec 18             	sub    $0x18,%esp
  1012f4:	eb 33                	jmp    101329 <cons_intr+0x3b>
  1012f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1012fa:	74 2d                	je     101329 <cons_intr+0x3b>
  1012fc:	a1 84 00 11 00       	mov    0x110084,%eax
  101301:	8d 50 01             	lea    0x1(%eax),%edx
  101304:	89 15 84 00 11 00    	mov    %edx,0x110084
  10130a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10130d:	88 90 80 fe 10 00    	mov    %dl,0x10fe80(%eax)
  101313:	a1 84 00 11 00       	mov    0x110084,%eax
  101318:	3d 00 02 00 00       	cmp    $0x200,%eax
  10131d:	75 0a                	jne    101329 <cons_intr+0x3b>
  10131f:	c7 05 84 00 11 00 00 	movl   $0x0,0x110084
  101326:	00 00 00 
  101329:	8b 45 08             	mov    0x8(%ebp),%eax
  10132c:	ff d0                	call   *%eax
  10132e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101331:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  101335:	75 bf                	jne    1012f6 <cons_intr+0x8>
  101337:	90                   	nop
  101338:	c9                   	leave  
  101339:	c3                   	ret    

0010133a <serial_proc_data>:
  10133a:	55                   	push   %ebp
  10133b:	89 e5                	mov    %esp,%ebp
  10133d:	83 ec 10             	sub    $0x10,%esp
  101340:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
  101346:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10134a:	89 c2                	mov    %eax,%edx
  10134c:	ec                   	in     (%dx),%al
  10134d:	88 45 f9             	mov    %al,-0x7(%ebp)
  101350:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101354:	0f b6 c0             	movzbl %al,%eax
  101357:	83 e0 01             	and    $0x1,%eax
  10135a:	85 c0                	test   %eax,%eax
  10135c:	75 07                	jne    101365 <serial_proc_data+0x2b>
  10135e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101363:	eb 2a                	jmp    10138f <serial_proc_data+0x55>
  101365:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  10136b:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10136f:	89 c2                	mov    %eax,%edx
  101371:	ec                   	in     (%dx),%al
  101372:	88 45 f5             	mov    %al,-0xb(%ebp)
  101375:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101379:	0f b6 c0             	movzbl %al,%eax
  10137c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10137f:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  101383:	75 07                	jne    10138c <serial_proc_data+0x52>
  101385:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
  10138c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10138f:	c9                   	leave  
  101390:	c3                   	ret    

00101391 <serial_intr>:
  101391:	55                   	push   %ebp
  101392:	89 e5                	mov    %esp,%ebp
  101394:	83 ec 08             	sub    $0x8,%esp
  101397:	a1 68 fe 10 00       	mov    0x10fe68,%eax
  10139c:	85 c0                	test   %eax,%eax
  10139e:	74 10                	je     1013b0 <serial_intr+0x1f>
  1013a0:	83 ec 0c             	sub    $0xc,%esp
  1013a3:	68 3a 13 10 00       	push   $0x10133a
  1013a8:	e8 41 ff ff ff       	call   1012ee <cons_intr>
  1013ad:	83 c4 10             	add    $0x10,%esp
  1013b0:	90                   	nop
  1013b1:	c9                   	leave  
  1013b2:	c3                   	ret    

001013b3 <kbd_proc_data>:
  1013b3:	55                   	push   %ebp
  1013b4:	89 e5                	mov    %esp,%ebp
  1013b6:	83 ec 28             	sub    $0x28,%esp
  1013b9:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
  1013bf:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1013c3:	89 c2                	mov    %eax,%edx
  1013c5:	ec                   	in     (%dx),%al
  1013c6:	88 45 ef             	mov    %al,-0x11(%ebp)
  1013c9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
  1013cd:	0f b6 c0             	movzbl %al,%eax
  1013d0:	83 e0 01             	and    $0x1,%eax
  1013d3:	85 c0                	test   %eax,%eax
  1013d5:	75 0a                	jne    1013e1 <kbd_proc_data+0x2e>
  1013d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013dc:	e9 5d 01 00 00       	jmp    10153e <kbd_proc_data+0x18b>
  1013e1:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
  1013e7:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1013eb:	89 c2                	mov    %eax,%edx
  1013ed:	ec                   	in     (%dx),%al
  1013ee:	88 45 eb             	mov    %al,-0x15(%ebp)
  1013f1:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
  1013f5:	88 45 f3             	mov    %al,-0xd(%ebp)
  1013f8:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  1013fc:	75 17                	jne    101415 <kbd_proc_data+0x62>
  1013fe:	a1 88 00 11 00       	mov    0x110088,%eax
  101403:	83 c8 40             	or     $0x40,%eax
  101406:	a3 88 00 11 00       	mov    %eax,0x110088
  10140b:	b8 00 00 00 00       	mov    $0x0,%eax
  101410:	e9 29 01 00 00       	jmp    10153e <kbd_proc_data+0x18b>
  101415:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101419:	84 c0                	test   %al,%al
  10141b:	79 47                	jns    101464 <kbd_proc_data+0xb1>
  10141d:	a1 88 00 11 00       	mov    0x110088,%eax
  101422:	83 e0 40             	and    $0x40,%eax
  101425:	85 c0                	test   %eax,%eax
  101427:	75 09                	jne    101432 <kbd_proc_data+0x7f>
  101429:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10142d:	83 e0 7f             	and    $0x7f,%eax
  101430:	eb 04                	jmp    101436 <kbd_proc_data+0x83>
  101432:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101436:	88 45 f3             	mov    %al,-0xd(%ebp)
  101439:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10143d:	0f b6 80 40 f0 10 00 	movzbl 0x10f040(%eax),%eax
  101444:	83 c8 40             	or     $0x40,%eax
  101447:	0f b6 c0             	movzbl %al,%eax
  10144a:	f7 d0                	not    %eax
  10144c:	89 c2                	mov    %eax,%edx
  10144e:	a1 88 00 11 00       	mov    0x110088,%eax
  101453:	21 d0                	and    %edx,%eax
  101455:	a3 88 00 11 00       	mov    %eax,0x110088
  10145a:	b8 00 00 00 00       	mov    $0x0,%eax
  10145f:	e9 da 00 00 00       	jmp    10153e <kbd_proc_data+0x18b>
  101464:	a1 88 00 11 00       	mov    0x110088,%eax
  101469:	83 e0 40             	and    $0x40,%eax
  10146c:	85 c0                	test   %eax,%eax
  10146e:	74 11                	je     101481 <kbd_proc_data+0xce>
  101470:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
  101474:	a1 88 00 11 00       	mov    0x110088,%eax
  101479:	83 e0 bf             	and    $0xffffffbf,%eax
  10147c:	a3 88 00 11 00       	mov    %eax,0x110088
  101481:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101485:	0f b6 80 40 f0 10 00 	movzbl 0x10f040(%eax),%eax
  10148c:	0f b6 d0             	movzbl %al,%edx
  10148f:	a1 88 00 11 00       	mov    0x110088,%eax
  101494:	09 d0                	or     %edx,%eax
  101496:	a3 88 00 11 00       	mov    %eax,0x110088
  10149b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10149f:	0f b6 80 40 f1 10 00 	movzbl 0x10f140(%eax),%eax
  1014a6:	0f b6 d0             	movzbl %al,%edx
  1014a9:	a1 88 00 11 00       	mov    0x110088,%eax
  1014ae:	31 d0                	xor    %edx,%eax
  1014b0:	a3 88 00 11 00       	mov    %eax,0x110088
  1014b5:	a1 88 00 11 00       	mov    0x110088,%eax
  1014ba:	83 e0 03             	and    $0x3,%eax
  1014bd:	8b 14 85 40 f5 10 00 	mov    0x10f540(,%eax,4),%edx
  1014c4:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014c8:	01 d0                	add    %edx,%eax
  1014ca:	0f b6 00             	movzbl (%eax),%eax
  1014cd:	0f b6 c0             	movzbl %al,%eax
  1014d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1014d3:	a1 88 00 11 00       	mov    0x110088,%eax
  1014d8:	83 e0 08             	and    $0x8,%eax
  1014db:	85 c0                	test   %eax,%eax
  1014dd:	74 22                	je     101501 <kbd_proc_data+0x14e>
  1014df:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1014e3:	7e 0c                	jle    1014f1 <kbd_proc_data+0x13e>
  1014e5:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1014e9:	7f 06                	jg     1014f1 <kbd_proc_data+0x13e>
  1014eb:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1014ef:	eb 10                	jmp    101501 <kbd_proc_data+0x14e>
  1014f1:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1014f5:	7e 0a                	jle    101501 <kbd_proc_data+0x14e>
  1014f7:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  1014fb:	7f 04                	jg     101501 <kbd_proc_data+0x14e>
  1014fd:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
  101501:	a1 88 00 11 00       	mov    0x110088,%eax
  101506:	f7 d0                	not    %eax
  101508:	83 e0 06             	and    $0x6,%eax
  10150b:	85 c0                	test   %eax,%eax
  10150d:	75 2c                	jne    10153b <kbd_proc_data+0x188>
  10150f:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101516:	75 23                	jne    10153b <kbd_proc_data+0x188>
  101518:	83 ec 0c             	sub    $0xc,%esp
  10151b:	68 8d 3a 10 00       	push   $0x103a8d
  101520:	e8 25 ed ff ff       	call   10024a <cprintf>
  101525:	83 c4 10             	add    $0x10,%esp
  101528:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  10152e:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
  101532:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  101536:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  10153a:	ee                   	out    %al,(%dx)
  10153b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10153e:	c9                   	leave  
  10153f:	c3                   	ret    

00101540 <kbd_intr>:
  101540:	55                   	push   %ebp
  101541:	89 e5                	mov    %esp,%ebp
  101543:	83 ec 08             	sub    $0x8,%esp
  101546:	83 ec 0c             	sub    $0xc,%esp
  101549:	68 b3 13 10 00       	push   $0x1013b3
  10154e:	e8 9b fd ff ff       	call   1012ee <cons_intr>
  101553:	83 c4 10             	add    $0x10,%esp
  101556:	90                   	nop
  101557:	c9                   	leave  
  101558:	c3                   	ret    

00101559 <kbd_init>:
  101559:	55                   	push   %ebp
  10155a:	89 e5                	mov    %esp,%ebp
  10155c:	83 ec 08             	sub    $0x8,%esp
  10155f:	e8 dc ff ff ff       	call   101540 <kbd_intr>
  101564:	83 ec 0c             	sub    $0xc,%esp
  101567:	6a 01                	push   $0x1
  101569:	e8 1c 01 00 00       	call   10168a <pic_enable>
  10156e:	83 c4 10             	add    $0x10,%esp
  101571:	90                   	nop
  101572:	c9                   	leave  
  101573:	c3                   	ret    

00101574 <cons_init>:
  101574:	55                   	push   %ebp
  101575:	89 e5                	mov    %esp,%ebp
  101577:	83 ec 08             	sub    $0x8,%esp
  10157a:	e8 88 f8 ff ff       	call   100e07 <cga_init>
  10157f:	e8 6a f9 ff ff       	call   100eee <serial_init>
  101584:	e8 d0 ff ff ff       	call   101559 <kbd_init>
  101589:	a1 68 fe 10 00       	mov    0x10fe68,%eax
  10158e:	85 c0                	test   %eax,%eax
  101590:	75 10                	jne    1015a2 <cons_init+0x2e>
  101592:	83 ec 0c             	sub    $0xc,%esp
  101595:	68 99 3a 10 00       	push   $0x103a99
  10159a:	e8 ab ec ff ff       	call   10024a <cprintf>
  10159f:	83 c4 10             	add    $0x10,%esp
  1015a2:	90                   	nop
  1015a3:	c9                   	leave  
  1015a4:	c3                   	ret    

001015a5 <cons_putc>:
  1015a5:	55                   	push   %ebp
  1015a6:	89 e5                	mov    %esp,%ebp
  1015a8:	83 ec 08             	sub    $0x8,%esp
  1015ab:	ff 75 08             	pushl  0x8(%ebp)
  1015ae:	e8 9a fa ff ff       	call   10104d <lpt_putc>
  1015b3:	83 c4 04             	add    $0x4,%esp
  1015b6:	83 ec 0c             	sub    $0xc,%esp
  1015b9:	ff 75 08             	pushl  0x8(%ebp)
  1015bc:	e8 c3 fa ff ff       	call   101084 <cga_putc>
  1015c1:	83 c4 10             	add    $0x10,%esp
  1015c4:	83 ec 0c             	sub    $0xc,%esp
  1015c7:	ff 75 08             	pushl  0x8(%ebp)
  1015ca:	e8 e8 fc ff ff       	call   1012b7 <serial_putc>
  1015cf:	83 c4 10             	add    $0x10,%esp
  1015d2:	90                   	nop
  1015d3:	c9                   	leave  
  1015d4:	c3                   	ret    

001015d5 <cons_getc>:
  1015d5:	55                   	push   %ebp
  1015d6:	89 e5                	mov    %esp,%ebp
  1015d8:	83 ec 18             	sub    $0x18,%esp
  1015db:	e8 b1 fd ff ff       	call   101391 <serial_intr>
  1015e0:	e8 5b ff ff ff       	call   101540 <kbd_intr>
  1015e5:	8b 15 80 00 11 00    	mov    0x110080,%edx
  1015eb:	a1 84 00 11 00       	mov    0x110084,%eax
  1015f0:	39 c2                	cmp    %eax,%edx
  1015f2:	74 36                	je     10162a <cons_getc+0x55>
  1015f4:	a1 80 00 11 00       	mov    0x110080,%eax
  1015f9:	8d 50 01             	lea    0x1(%eax),%edx
  1015fc:	89 15 80 00 11 00    	mov    %edx,0x110080
  101602:	0f b6 80 80 fe 10 00 	movzbl 0x10fe80(%eax),%eax
  101609:	0f b6 c0             	movzbl %al,%eax
  10160c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10160f:	a1 80 00 11 00       	mov    0x110080,%eax
  101614:	3d 00 02 00 00       	cmp    $0x200,%eax
  101619:	75 0a                	jne    101625 <cons_getc+0x50>
  10161b:	c7 05 80 00 11 00 00 	movl   $0x0,0x110080
  101622:	00 00 00 
  101625:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101628:	eb 05                	jmp    10162f <cons_getc+0x5a>
  10162a:	b8 00 00 00 00       	mov    $0x0,%eax
  10162f:	c9                   	leave  
  101630:	c3                   	ret    

00101631 <pic_setmask>:
  101631:	55                   	push   %ebp
  101632:	89 e5                	mov    %esp,%ebp
  101634:	83 ec 14             	sub    $0x14,%esp
  101637:	8b 45 08             	mov    0x8(%ebp),%eax
  10163a:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  10163e:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101642:	66 a3 50 f5 10 00    	mov    %ax,0x10f550
  101648:	a1 8c 00 11 00       	mov    0x11008c,%eax
  10164d:	85 c0                	test   %eax,%eax
  10164f:	74 36                	je     101687 <pic_setmask+0x56>
  101651:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101655:	0f b6 c0             	movzbl %al,%eax
  101658:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  10165e:	88 45 f9             	mov    %al,-0x7(%ebp)
  101661:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101665:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101669:	ee                   	out    %al,(%dx)
  10166a:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10166e:	66 c1 e8 08          	shr    $0x8,%ax
  101672:	0f b6 c0             	movzbl %al,%eax
  101675:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  10167b:	88 45 fd             	mov    %al,-0x3(%ebp)
  10167e:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101682:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101686:	ee                   	out    %al,(%dx)
  101687:	90                   	nop
  101688:	c9                   	leave  
  101689:	c3                   	ret    

0010168a <pic_enable>:
  10168a:	55                   	push   %ebp
  10168b:	89 e5                	mov    %esp,%ebp
  10168d:	8b 45 08             	mov    0x8(%ebp),%eax
  101690:	ba 01 00 00 00       	mov    $0x1,%edx
  101695:	89 c1                	mov    %eax,%ecx
  101697:	d3 e2                	shl    %cl,%edx
  101699:	89 d0                	mov    %edx,%eax
  10169b:	f7 d0                	not    %eax
  10169d:	89 c2                	mov    %eax,%edx
  10169f:	0f b7 05 50 f5 10 00 	movzwl 0x10f550,%eax
  1016a6:	21 d0                	and    %edx,%eax
  1016a8:	0f b7 c0             	movzwl %ax,%eax
  1016ab:	50                   	push   %eax
  1016ac:	e8 80 ff ff ff       	call   101631 <pic_setmask>
  1016b1:	83 c4 04             	add    $0x4,%esp
  1016b4:	90                   	nop
  1016b5:	c9                   	leave  
  1016b6:	c3                   	ret    

001016b7 <pic_init>:
  1016b7:	55                   	push   %ebp
  1016b8:	89 e5                	mov    %esp,%ebp
  1016ba:	83 ec 40             	sub    $0x40,%esp
  1016bd:	c7 05 8c 00 11 00 01 	movl   $0x1,0x11008c
  1016c4:	00 00 00 
  1016c7:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  1016cd:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
  1016d1:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  1016d5:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  1016d9:	ee                   	out    %al,(%dx)
  1016da:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  1016e0:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
  1016e4:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  1016e8:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  1016ec:	ee                   	out    %al,(%dx)
  1016ed:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  1016f3:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
  1016f7:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  1016fb:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  1016ff:	ee                   	out    %al,(%dx)
  101700:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  101706:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
  10170a:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  10170e:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101712:	ee                   	out    %al,(%dx)
  101713:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  101719:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
  10171d:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101721:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101725:	ee                   	out    %al,(%dx)
  101726:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  10172c:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
  101730:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101734:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101738:	ee                   	out    %al,(%dx)
  101739:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  10173f:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
  101743:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101747:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  10174b:	ee                   	out    %al,(%dx)
  10174c:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  101752:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
  101756:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10175a:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10175e:	ee                   	out    %al,(%dx)
  10175f:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  101765:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
  101769:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10176d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101771:	ee                   	out    %al,(%dx)
  101772:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  101778:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
  10177c:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101780:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101784:	ee                   	out    %al,(%dx)
  101785:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  10178b:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
  10178f:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101793:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101797:	ee                   	out    %al,(%dx)
  101798:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  10179e:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
  1017a2:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1017a6:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1017aa:	ee                   	out    %al,(%dx)
  1017ab:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  1017b1:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
  1017b5:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1017b9:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1017bd:	ee                   	out    %al,(%dx)
  1017be:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  1017c4:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
  1017c8:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1017cc:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1017d0:	ee                   	out    %al,(%dx)
  1017d1:	0f b7 05 50 f5 10 00 	movzwl 0x10f550,%eax
  1017d8:	66 83 f8 ff          	cmp    $0xffff,%ax
  1017dc:	74 13                	je     1017f1 <pic_init+0x13a>
  1017de:	0f b7 05 50 f5 10 00 	movzwl 0x10f550,%eax
  1017e5:	0f b7 c0             	movzwl %ax,%eax
  1017e8:	50                   	push   %eax
  1017e9:	e8 43 fe ff ff       	call   101631 <pic_setmask>
  1017ee:	83 c4 04             	add    $0x4,%esp
  1017f1:	90                   	nop
  1017f2:	c9                   	leave  
  1017f3:	c3                   	ret    

001017f4 <intr_enable>:
  1017f4:	55                   	push   %ebp
  1017f5:	89 e5                	mov    %esp,%ebp
  1017f7:	fb                   	sti    
  1017f8:	90                   	nop
  1017f9:	5d                   	pop    %ebp
  1017fa:	c3                   	ret    

001017fb <intr_disable>:
  1017fb:	55                   	push   %ebp
  1017fc:	89 e5                	mov    %esp,%ebp
  1017fe:	fa                   	cli    
  1017ff:	90                   	nop
  101800:	5d                   	pop    %ebp
  101801:	c3                   	ret    

00101802 <print_switch_to_user>:
  101802:	55                   	push   %ebp
  101803:	89 e5                	mov    %esp,%ebp
  101805:	83 ec 08             	sub    $0x8,%esp
  101808:	83 ec 0c             	sub    $0xc,%esp
  10180b:	68 c0 3a 10 00       	push   $0x103ac0
  101810:	e8 35 ea ff ff       	call   10024a <cprintf>
  101815:	83 c4 10             	add    $0x10,%esp
  101818:	90                   	nop
  101819:	c9                   	leave  
  10181a:	c3                   	ret    

0010181b <print_switch_to_kernel>:
  10181b:	55                   	push   %ebp
  10181c:	89 e5                	mov    %esp,%ebp
  10181e:	83 ec 08             	sub    $0x8,%esp
  101821:	83 ec 0c             	sub    $0xc,%esp
  101824:	68 cf 3a 10 00       	push   $0x103acf
  101829:	e8 1c ea ff ff       	call   10024a <cprintf>
  10182e:	83 c4 10             	add    $0x10,%esp
  101831:	90                   	nop
  101832:	c9                   	leave  
  101833:	c3                   	ret    

00101834 <print_ticks>:
  101834:	55                   	push   %ebp
  101835:	89 e5                	mov    %esp,%ebp
  101837:	83 ec 08             	sub    $0x8,%esp
  10183a:	83 ec 08             	sub    $0x8,%esp
  10183d:	6a 64                	push   $0x64
  10183f:	68 e1 3a 10 00       	push   $0x103ae1
  101844:	e8 01 ea ff ff       	call   10024a <cprintf>
  101849:	83 c4 10             	add    $0x10,%esp
  10184c:	90                   	nop
  10184d:	c9                   	leave  
  10184e:	c3                   	ret    

0010184f <idt_init>:
  10184f:	55                   	push   %ebp
  101850:	89 e5                	mov    %esp,%ebp
  101852:	83 ec 10             	sub    $0x10,%esp
  101855:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10185c:	e9 c3 00 00 00       	jmp    101924 <idt_init+0xd5>
  101861:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101864:	8b 04 85 e0 f5 10 00 	mov    0x10f5e0(,%eax,4),%eax
  10186b:	89 c2                	mov    %eax,%edx
  10186d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101870:	66 89 14 c5 a0 00 11 	mov    %dx,0x1100a0(,%eax,8)
  101877:	00 
  101878:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10187b:	66 c7 04 c5 a2 00 11 	movw   $0x8,0x1100a2(,%eax,8)
  101882:	00 08 00 
  101885:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101888:	0f b6 14 c5 a4 00 11 	movzbl 0x1100a4(,%eax,8),%edx
  10188f:	00 
  101890:	83 e2 e0             	and    $0xffffffe0,%edx
  101893:	88 14 c5 a4 00 11 00 	mov    %dl,0x1100a4(,%eax,8)
  10189a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10189d:	0f b6 14 c5 a4 00 11 	movzbl 0x1100a4(,%eax,8),%edx
  1018a4:	00 
  1018a5:	83 e2 1f             	and    $0x1f,%edx
  1018a8:	88 14 c5 a4 00 11 00 	mov    %dl,0x1100a4(,%eax,8)
  1018af:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018b2:	0f b6 14 c5 a5 00 11 	movzbl 0x1100a5(,%eax,8),%edx
  1018b9:	00 
  1018ba:	83 e2 f0             	and    $0xfffffff0,%edx
  1018bd:	83 ca 0e             	or     $0xe,%edx
  1018c0:	88 14 c5 a5 00 11 00 	mov    %dl,0x1100a5(,%eax,8)
  1018c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018ca:	0f b6 14 c5 a5 00 11 	movzbl 0x1100a5(,%eax,8),%edx
  1018d1:	00 
  1018d2:	83 e2 ef             	and    $0xffffffef,%edx
  1018d5:	88 14 c5 a5 00 11 00 	mov    %dl,0x1100a5(,%eax,8)
  1018dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018df:	0f b6 14 c5 a5 00 11 	movzbl 0x1100a5(,%eax,8),%edx
  1018e6:	00 
  1018e7:	83 e2 9f             	and    $0xffffff9f,%edx
  1018ea:	88 14 c5 a5 00 11 00 	mov    %dl,0x1100a5(,%eax,8)
  1018f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018f4:	0f b6 14 c5 a5 00 11 	movzbl 0x1100a5(,%eax,8),%edx
  1018fb:	00 
  1018fc:	83 ca 80             	or     $0xffffff80,%edx
  1018ff:	88 14 c5 a5 00 11 00 	mov    %dl,0x1100a5(,%eax,8)
  101906:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101909:	8b 04 85 e0 f5 10 00 	mov    0x10f5e0(,%eax,4),%eax
  101910:	c1 e8 10             	shr    $0x10,%eax
  101913:	89 c2                	mov    %eax,%edx
  101915:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101918:	66 89 14 c5 a6 00 11 	mov    %dx,0x1100a6(,%eax,8)
  10191f:	00 
  101920:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101924:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  10192b:	0f 8e 30 ff ff ff    	jle    101861 <idt_init+0x12>
  101931:	a1 e0 f7 10 00       	mov    0x10f7e0,%eax
  101936:	66 a3 a0 04 11 00    	mov    %ax,0x1104a0
  10193c:	66 c7 05 a2 04 11 00 	movw   $0x8,0x1104a2
  101943:	08 00 
  101945:	0f b6 05 a4 04 11 00 	movzbl 0x1104a4,%eax
  10194c:	83 e0 e0             	and    $0xffffffe0,%eax
  10194f:	a2 a4 04 11 00       	mov    %al,0x1104a4
  101954:	0f b6 05 a4 04 11 00 	movzbl 0x1104a4,%eax
  10195b:	83 e0 1f             	and    $0x1f,%eax
  10195e:	a2 a4 04 11 00       	mov    %al,0x1104a4
  101963:	0f b6 05 a5 04 11 00 	movzbl 0x1104a5,%eax
  10196a:	83 c8 0f             	or     $0xf,%eax
  10196d:	a2 a5 04 11 00       	mov    %al,0x1104a5
  101972:	0f b6 05 a5 04 11 00 	movzbl 0x1104a5,%eax
  101979:	83 e0 ef             	and    $0xffffffef,%eax
  10197c:	a2 a5 04 11 00       	mov    %al,0x1104a5
  101981:	0f b6 05 a5 04 11 00 	movzbl 0x1104a5,%eax
  101988:	83 c8 60             	or     $0x60,%eax
  10198b:	a2 a5 04 11 00       	mov    %al,0x1104a5
  101990:	0f b6 05 a5 04 11 00 	movzbl 0x1104a5,%eax
  101997:	83 c8 80             	or     $0xffffff80,%eax
  10199a:	a2 a5 04 11 00       	mov    %al,0x1104a5
  10199f:	a1 e0 f7 10 00       	mov    0x10f7e0,%eax
  1019a4:	c1 e8 10             	shr    $0x10,%eax
  1019a7:	66 a3 a6 04 11 00    	mov    %ax,0x1104a6
  1019ad:	a1 c4 f7 10 00       	mov    0x10f7c4,%eax
  1019b2:	66 a3 68 04 11 00    	mov    %ax,0x110468
  1019b8:	66 c7 05 6a 04 11 00 	movw   $0x8,0x11046a
  1019bf:	08 00 
  1019c1:	0f b6 05 6c 04 11 00 	movzbl 0x11046c,%eax
  1019c8:	83 e0 e0             	and    $0xffffffe0,%eax
  1019cb:	a2 6c 04 11 00       	mov    %al,0x11046c
  1019d0:	0f b6 05 6c 04 11 00 	movzbl 0x11046c,%eax
  1019d7:	83 e0 1f             	and    $0x1f,%eax
  1019da:	a2 6c 04 11 00       	mov    %al,0x11046c
  1019df:	0f b6 05 6d 04 11 00 	movzbl 0x11046d,%eax
  1019e6:	83 e0 f0             	and    $0xfffffff0,%eax
  1019e9:	83 c8 0e             	or     $0xe,%eax
  1019ec:	a2 6d 04 11 00       	mov    %al,0x11046d
  1019f1:	0f b6 05 6d 04 11 00 	movzbl 0x11046d,%eax
  1019f8:	83 e0 ef             	and    $0xffffffef,%eax
  1019fb:	a2 6d 04 11 00       	mov    %al,0x11046d
  101a00:	0f b6 05 6d 04 11 00 	movzbl 0x11046d,%eax
  101a07:	83 c8 60             	or     $0x60,%eax
  101a0a:	a2 6d 04 11 00       	mov    %al,0x11046d
  101a0f:	0f b6 05 6d 04 11 00 	movzbl 0x11046d,%eax
  101a16:	83 c8 80             	or     $0xffffff80,%eax
  101a19:	a2 6d 04 11 00       	mov    %al,0x11046d
  101a1e:	a1 c4 f7 10 00       	mov    0x10f7c4,%eax
  101a23:	c1 e8 10             	shr    $0x10,%eax
  101a26:	66 a3 6e 04 11 00    	mov    %ax,0x11046e
  101a2c:	a1 c0 f7 10 00       	mov    0x10f7c0,%eax
  101a31:	66 a3 60 04 11 00    	mov    %ax,0x110460
  101a37:	66 c7 05 62 04 11 00 	movw   $0x8,0x110462
  101a3e:	08 00 
  101a40:	0f b6 05 64 04 11 00 	movzbl 0x110464,%eax
  101a47:	83 e0 e0             	and    $0xffffffe0,%eax
  101a4a:	a2 64 04 11 00       	mov    %al,0x110464
  101a4f:	0f b6 05 64 04 11 00 	movzbl 0x110464,%eax
  101a56:	83 e0 1f             	and    $0x1f,%eax
  101a59:	a2 64 04 11 00       	mov    %al,0x110464
  101a5e:	0f b6 05 65 04 11 00 	movzbl 0x110465,%eax
  101a65:	83 e0 f0             	and    $0xfffffff0,%eax
  101a68:	83 c8 0e             	or     $0xe,%eax
  101a6b:	a2 65 04 11 00       	mov    %al,0x110465
  101a70:	0f b6 05 65 04 11 00 	movzbl 0x110465,%eax
  101a77:	83 e0 ef             	and    $0xffffffef,%eax
  101a7a:	a2 65 04 11 00       	mov    %al,0x110465
  101a7f:	0f b6 05 65 04 11 00 	movzbl 0x110465,%eax
  101a86:	83 e0 9f             	and    $0xffffff9f,%eax
  101a89:	a2 65 04 11 00       	mov    %al,0x110465
  101a8e:	0f b6 05 65 04 11 00 	movzbl 0x110465,%eax
  101a95:	83 c8 80             	or     $0xffffff80,%eax
  101a98:	a2 65 04 11 00       	mov    %al,0x110465
  101a9d:	a1 c0 f7 10 00       	mov    0x10f7c0,%eax
  101aa2:	c1 e8 10             	shr    $0x10,%eax
  101aa5:	66 a3 66 04 11 00    	mov    %ax,0x110466
  101aab:	c7 45 f8 60 f5 10 00 	movl   $0x10f560,-0x8(%ebp)
  101ab2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101ab5:	0f 01 18             	lidtl  (%eax)
  101ab8:	90                   	nop
  101ab9:	c9                   	leave  
  101aba:	c3                   	ret    

00101abb <trapname>:
  101abb:	55                   	push   %ebp
  101abc:	89 e5                	mov    %esp,%ebp
  101abe:	8b 45 08             	mov    0x8(%ebp),%eax
  101ac1:	83 f8 13             	cmp    $0x13,%eax
  101ac4:	77 0c                	ja     101ad2 <trapname+0x17>
  101ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  101ac9:	8b 04 85 40 3e 10 00 	mov    0x103e40(,%eax,4),%eax
  101ad0:	eb 18                	jmp    101aea <trapname+0x2f>
  101ad2:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101ad6:	7e 0d                	jle    101ae5 <trapname+0x2a>
  101ad8:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101adc:	7f 07                	jg     101ae5 <trapname+0x2a>
  101ade:	b8 eb 3a 10 00       	mov    $0x103aeb,%eax
  101ae3:	eb 05                	jmp    101aea <trapname+0x2f>
  101ae5:	b8 fe 3a 10 00       	mov    $0x103afe,%eax
  101aea:	5d                   	pop    %ebp
  101aeb:	c3                   	ret    

00101aec <trap_in_kernel>:
  101aec:	55                   	push   %ebp
  101aed:	89 e5                	mov    %esp,%ebp
  101aef:	8b 45 08             	mov    0x8(%ebp),%eax
  101af2:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101af6:	66 83 f8 08          	cmp    $0x8,%ax
  101afa:	0f 94 c0             	sete   %al
  101afd:	0f b6 c0             	movzbl %al,%eax
  101b00:	5d                   	pop    %ebp
  101b01:	c3                   	ret    

00101b02 <print_trapframe>:
  101b02:	55                   	push   %ebp
  101b03:	89 e5                	mov    %esp,%ebp
  101b05:	83 ec 18             	sub    $0x18,%esp
  101b08:	83 ec 08             	sub    $0x8,%esp
  101b0b:	ff 75 08             	pushl  0x8(%ebp)
  101b0e:	68 3f 3b 10 00       	push   $0x103b3f
  101b13:	e8 32 e7 ff ff       	call   10024a <cprintf>
  101b18:	83 c4 10             	add    $0x10,%esp
  101b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  101b1e:	83 ec 0c             	sub    $0xc,%esp
  101b21:	50                   	push   %eax
  101b22:	e8 b6 01 00 00       	call   101cdd <print_regs>
  101b27:	83 c4 10             	add    $0x10,%esp
  101b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  101b2d:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101b31:	0f b7 c0             	movzwl %ax,%eax
  101b34:	83 ec 08             	sub    $0x8,%esp
  101b37:	50                   	push   %eax
  101b38:	68 50 3b 10 00       	push   $0x103b50
  101b3d:	e8 08 e7 ff ff       	call   10024a <cprintf>
  101b42:	83 c4 10             	add    $0x10,%esp
  101b45:	8b 45 08             	mov    0x8(%ebp),%eax
  101b48:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101b4c:	0f b7 c0             	movzwl %ax,%eax
  101b4f:	83 ec 08             	sub    $0x8,%esp
  101b52:	50                   	push   %eax
  101b53:	68 63 3b 10 00       	push   $0x103b63
  101b58:	e8 ed e6 ff ff       	call   10024a <cprintf>
  101b5d:	83 c4 10             	add    $0x10,%esp
  101b60:	8b 45 08             	mov    0x8(%ebp),%eax
  101b63:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101b67:	0f b7 c0             	movzwl %ax,%eax
  101b6a:	83 ec 08             	sub    $0x8,%esp
  101b6d:	50                   	push   %eax
  101b6e:	68 76 3b 10 00       	push   $0x103b76
  101b73:	e8 d2 e6 ff ff       	call   10024a <cprintf>
  101b78:	83 c4 10             	add    $0x10,%esp
  101b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  101b7e:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101b82:	0f b7 c0             	movzwl %ax,%eax
  101b85:	83 ec 08             	sub    $0x8,%esp
  101b88:	50                   	push   %eax
  101b89:	68 89 3b 10 00       	push   $0x103b89
  101b8e:	e8 b7 e6 ff ff       	call   10024a <cprintf>
  101b93:	83 c4 10             	add    $0x10,%esp
  101b96:	8b 45 08             	mov    0x8(%ebp),%eax
  101b99:	8b 40 30             	mov    0x30(%eax),%eax
  101b9c:	83 ec 0c             	sub    $0xc,%esp
  101b9f:	50                   	push   %eax
  101ba0:	e8 16 ff ff ff       	call   101abb <trapname>
  101ba5:	83 c4 10             	add    $0x10,%esp
  101ba8:	89 c2                	mov    %eax,%edx
  101baa:	8b 45 08             	mov    0x8(%ebp),%eax
  101bad:	8b 40 30             	mov    0x30(%eax),%eax
  101bb0:	83 ec 04             	sub    $0x4,%esp
  101bb3:	52                   	push   %edx
  101bb4:	50                   	push   %eax
  101bb5:	68 9c 3b 10 00       	push   $0x103b9c
  101bba:	e8 8b e6 ff ff       	call   10024a <cprintf>
  101bbf:	83 c4 10             	add    $0x10,%esp
  101bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  101bc5:	8b 40 34             	mov    0x34(%eax),%eax
  101bc8:	83 ec 08             	sub    $0x8,%esp
  101bcb:	50                   	push   %eax
  101bcc:	68 ae 3b 10 00       	push   $0x103bae
  101bd1:	e8 74 e6 ff ff       	call   10024a <cprintf>
  101bd6:	83 c4 10             	add    $0x10,%esp
  101bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  101bdc:	8b 40 38             	mov    0x38(%eax),%eax
  101bdf:	83 ec 08             	sub    $0x8,%esp
  101be2:	50                   	push   %eax
  101be3:	68 bd 3b 10 00       	push   $0x103bbd
  101be8:	e8 5d e6 ff ff       	call   10024a <cprintf>
  101bed:	83 c4 10             	add    $0x10,%esp
  101bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  101bf3:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101bf7:	0f b7 c0             	movzwl %ax,%eax
  101bfa:	83 ec 08             	sub    $0x8,%esp
  101bfd:	50                   	push   %eax
  101bfe:	68 cc 3b 10 00       	push   $0x103bcc
  101c03:	e8 42 e6 ff ff       	call   10024a <cprintf>
  101c08:	83 c4 10             	add    $0x10,%esp
  101c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  101c0e:	8b 40 40             	mov    0x40(%eax),%eax
  101c11:	83 ec 08             	sub    $0x8,%esp
  101c14:	50                   	push   %eax
  101c15:	68 df 3b 10 00       	push   $0x103bdf
  101c1a:	e8 2b e6 ff ff       	call   10024a <cprintf>
  101c1f:	83 c4 10             	add    $0x10,%esp
  101c22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101c29:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101c30:	eb 3f                	jmp    101c71 <print_trapframe+0x16f>
  101c32:	8b 45 08             	mov    0x8(%ebp),%eax
  101c35:	8b 50 40             	mov    0x40(%eax),%edx
  101c38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101c3b:	21 d0                	and    %edx,%eax
  101c3d:	85 c0                	test   %eax,%eax
  101c3f:	74 29                	je     101c6a <print_trapframe+0x168>
  101c41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c44:	8b 04 85 80 f5 10 00 	mov    0x10f580(,%eax,4),%eax
  101c4b:	85 c0                	test   %eax,%eax
  101c4d:	74 1b                	je     101c6a <print_trapframe+0x168>
  101c4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c52:	8b 04 85 80 f5 10 00 	mov    0x10f580(,%eax,4),%eax
  101c59:	83 ec 08             	sub    $0x8,%esp
  101c5c:	50                   	push   %eax
  101c5d:	68 ee 3b 10 00       	push   $0x103bee
  101c62:	e8 e3 e5 ff ff       	call   10024a <cprintf>
  101c67:	83 c4 10             	add    $0x10,%esp
  101c6a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101c6e:	d1 65 f0             	shll   -0x10(%ebp)
  101c71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c74:	83 f8 17             	cmp    $0x17,%eax
  101c77:	76 b9                	jbe    101c32 <print_trapframe+0x130>
  101c79:	8b 45 08             	mov    0x8(%ebp),%eax
  101c7c:	8b 40 40             	mov    0x40(%eax),%eax
  101c7f:	c1 e8 0c             	shr    $0xc,%eax
  101c82:	83 e0 03             	and    $0x3,%eax
  101c85:	83 ec 08             	sub    $0x8,%esp
  101c88:	50                   	push   %eax
  101c89:	68 f2 3b 10 00       	push   $0x103bf2
  101c8e:	e8 b7 e5 ff ff       	call   10024a <cprintf>
  101c93:	83 c4 10             	add    $0x10,%esp
  101c96:	83 ec 0c             	sub    $0xc,%esp
  101c99:	ff 75 08             	pushl  0x8(%ebp)
  101c9c:	e8 4b fe ff ff       	call   101aec <trap_in_kernel>
  101ca1:	83 c4 10             	add    $0x10,%esp
  101ca4:	85 c0                	test   %eax,%eax
  101ca6:	75 32                	jne    101cda <print_trapframe+0x1d8>
  101ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  101cab:	8b 40 44             	mov    0x44(%eax),%eax
  101cae:	83 ec 08             	sub    $0x8,%esp
  101cb1:	50                   	push   %eax
  101cb2:	68 fb 3b 10 00       	push   $0x103bfb
  101cb7:	e8 8e e5 ff ff       	call   10024a <cprintf>
  101cbc:	83 c4 10             	add    $0x10,%esp
  101cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  101cc2:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101cc6:	0f b7 c0             	movzwl %ax,%eax
  101cc9:	83 ec 08             	sub    $0x8,%esp
  101ccc:	50                   	push   %eax
  101ccd:	68 0a 3c 10 00       	push   $0x103c0a
  101cd2:	e8 73 e5 ff ff       	call   10024a <cprintf>
  101cd7:	83 c4 10             	add    $0x10,%esp
  101cda:	90                   	nop
  101cdb:	c9                   	leave  
  101cdc:	c3                   	ret    

00101cdd <print_regs>:
  101cdd:	55                   	push   %ebp
  101cde:	89 e5                	mov    %esp,%ebp
  101ce0:	83 ec 08             	sub    $0x8,%esp
  101ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  101ce6:	8b 00                	mov    (%eax),%eax
  101ce8:	83 ec 08             	sub    $0x8,%esp
  101ceb:	50                   	push   %eax
  101cec:	68 1d 3c 10 00       	push   $0x103c1d
  101cf1:	e8 54 e5 ff ff       	call   10024a <cprintf>
  101cf6:	83 c4 10             	add    $0x10,%esp
  101cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  101cfc:	8b 40 04             	mov    0x4(%eax),%eax
  101cff:	83 ec 08             	sub    $0x8,%esp
  101d02:	50                   	push   %eax
  101d03:	68 2c 3c 10 00       	push   $0x103c2c
  101d08:	e8 3d e5 ff ff       	call   10024a <cprintf>
  101d0d:	83 c4 10             	add    $0x10,%esp
  101d10:	8b 45 08             	mov    0x8(%ebp),%eax
  101d13:	8b 40 08             	mov    0x8(%eax),%eax
  101d16:	83 ec 08             	sub    $0x8,%esp
  101d19:	50                   	push   %eax
  101d1a:	68 3b 3c 10 00       	push   $0x103c3b
  101d1f:	e8 26 e5 ff ff       	call   10024a <cprintf>
  101d24:	83 c4 10             	add    $0x10,%esp
  101d27:	8b 45 08             	mov    0x8(%ebp),%eax
  101d2a:	8b 40 0c             	mov    0xc(%eax),%eax
  101d2d:	83 ec 08             	sub    $0x8,%esp
  101d30:	50                   	push   %eax
  101d31:	68 4a 3c 10 00       	push   $0x103c4a
  101d36:	e8 0f e5 ff ff       	call   10024a <cprintf>
  101d3b:	83 c4 10             	add    $0x10,%esp
  101d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  101d41:	8b 40 10             	mov    0x10(%eax),%eax
  101d44:	83 ec 08             	sub    $0x8,%esp
  101d47:	50                   	push   %eax
  101d48:	68 59 3c 10 00       	push   $0x103c59
  101d4d:	e8 f8 e4 ff ff       	call   10024a <cprintf>
  101d52:	83 c4 10             	add    $0x10,%esp
  101d55:	8b 45 08             	mov    0x8(%ebp),%eax
  101d58:	8b 40 14             	mov    0x14(%eax),%eax
  101d5b:	83 ec 08             	sub    $0x8,%esp
  101d5e:	50                   	push   %eax
  101d5f:	68 68 3c 10 00       	push   $0x103c68
  101d64:	e8 e1 e4 ff ff       	call   10024a <cprintf>
  101d69:	83 c4 10             	add    $0x10,%esp
  101d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  101d6f:	8b 40 18             	mov    0x18(%eax),%eax
  101d72:	83 ec 08             	sub    $0x8,%esp
  101d75:	50                   	push   %eax
  101d76:	68 77 3c 10 00       	push   $0x103c77
  101d7b:	e8 ca e4 ff ff       	call   10024a <cprintf>
  101d80:	83 c4 10             	add    $0x10,%esp
  101d83:	8b 45 08             	mov    0x8(%ebp),%eax
  101d86:	8b 40 1c             	mov    0x1c(%eax),%eax
  101d89:	83 ec 08             	sub    $0x8,%esp
  101d8c:	50                   	push   %eax
  101d8d:	68 86 3c 10 00       	push   $0x103c86
  101d92:	e8 b3 e4 ff ff       	call   10024a <cprintf>
  101d97:	83 c4 10             	add    $0x10,%esp
  101d9a:	90                   	nop
  101d9b:	c9                   	leave  
  101d9c:	c3                   	ret    

00101d9d <trap_dispatch>:
  101d9d:	55                   	push   %ebp
  101d9e:	89 e5                	mov    %esp,%ebp
  101da0:	57                   	push   %edi
  101da1:	56                   	push   %esi
  101da2:	83 ec 10             	sub    $0x10,%esp
  101da5:	8b 45 08             	mov    0x8(%ebp),%eax
  101da8:	8b 40 30             	mov    0x30(%eax),%eax
  101dab:	83 f8 24             	cmp    $0x24,%eax
  101dae:	0f 84 87 00 00 00    	je     101e3b <trap_dispatch+0x9e>
  101db4:	83 f8 24             	cmp    $0x24,%eax
  101db7:	77 1c                	ja     101dd5 <trap_dispatch+0x38>
  101db9:	83 f8 20             	cmp    $0x20,%eax
  101dbc:	74 44                	je     101e02 <trap_dispatch+0x65>
  101dbe:	83 f8 21             	cmp    $0x21,%eax
  101dc1:	0f 84 9b 00 00 00    	je     101e62 <trap_dispatch+0xc5>
  101dc7:	83 f8 0d             	cmp    $0xd,%eax
  101dca:	0f 84 61 02 00 00    	je     102031 <trap_dispatch+0x294>
  101dd0:	e9 7c 02 00 00       	jmp    102051 <trap_dispatch+0x2b4>
  101dd5:	83 f8 78             	cmp    $0x78,%eax
  101dd8:	0f 84 54 01 00 00    	je     101f32 <trap_dispatch+0x195>
  101dde:	83 f8 78             	cmp    $0x78,%eax
  101de1:	77 11                	ja     101df4 <trap_dispatch+0x57>
  101de3:	83 e8 2e             	sub    $0x2e,%eax
  101de6:	83 f8 01             	cmp    $0x1,%eax
  101de9:	0f 87 62 02 00 00    	ja     102051 <trap_dispatch+0x2b4>
  101def:	e9 9a 02 00 00       	jmp    10208e <trap_dispatch+0x2f1>
  101df4:	83 f8 79             	cmp    $0x79,%eax
  101df7:	0f 84 b9 01 00 00    	je     101fb6 <trap_dispatch+0x219>
  101dfd:	e9 4f 02 00 00       	jmp    102051 <trap_dispatch+0x2b4>
  101e02:	a1 08 09 11 00       	mov    0x110908,%eax
  101e07:	8d 48 01             	lea    0x1(%eax),%ecx
  101e0a:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101e0f:	89 c8                	mov    %ecx,%eax
  101e11:	f7 e2                	mul    %edx
  101e13:	89 d0                	mov    %edx,%eax
  101e15:	c1 e8 05             	shr    $0x5,%eax
  101e18:	6b c0 64             	imul   $0x64,%eax,%eax
  101e1b:	29 c1                	sub    %eax,%ecx
  101e1d:	89 c8                	mov    %ecx,%eax
  101e1f:	a3 08 09 11 00       	mov    %eax,0x110908
  101e24:	a1 08 09 11 00       	mov    0x110908,%eax
  101e29:	85 c0                	test   %eax,%eax
  101e2b:	0f 85 56 02 00 00    	jne    102087 <trap_dispatch+0x2ea>
  101e31:	e8 fe f9 ff ff       	call   101834 <print_ticks>
  101e36:	e9 4c 02 00 00       	jmp    102087 <trap_dispatch+0x2ea>
  101e3b:	e8 95 f7 ff ff       	call   1015d5 <cons_getc>
  101e40:	88 45 f7             	mov    %al,-0x9(%ebp)
  101e43:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101e47:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101e4b:	83 ec 04             	sub    $0x4,%esp
  101e4e:	52                   	push   %edx
  101e4f:	50                   	push   %eax
  101e50:	68 95 3c 10 00       	push   $0x103c95
  101e55:	e8 f0 e3 ff ff       	call   10024a <cprintf>
  101e5a:	83 c4 10             	add    $0x10,%esp
  101e5d:	e9 2c 02 00 00       	jmp    10208e <trap_dispatch+0x2f1>
  101e62:	e8 6e f7 ff ff       	call   1015d5 <cons_getc>
  101e67:	88 45 f7             	mov    %al,-0x9(%ebp)
  101e6a:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101e6e:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101e72:	83 ec 04             	sub    $0x4,%esp
  101e75:	52                   	push   %edx
  101e76:	50                   	push   %eax
  101e77:	68 a7 3c 10 00       	push   $0x103ca7
  101e7c:	e8 c9 e3 ff ff       	call   10024a <cprintf>
  101e81:	83 c4 10             	add    $0x10,%esp
  101e84:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101e88:	83 f8 30             	cmp    $0x30,%eax
  101e8b:	74 0a                	je     101e97 <trap_dispatch+0xfa>
  101e8d:	83 f8 33             	cmp    $0x33,%eax
  101e90:	74 18                	je     101eaa <trap_dispatch+0x10d>
  101e92:	e9 f7 01 00 00       	jmp    10208e <trap_dispatch+0x2f1>
  101e97:	83 ec 0c             	sub    $0xc,%esp
  101e9a:	ff 75 08             	pushl  0x8(%ebp)
  101e9d:	e8 4a fc ff ff       	call   101aec <trap_in_kernel>
  101ea2:	83 c4 10             	add    $0x10,%esp
  101ea5:	e9 83 00 00 00       	jmp    101f2d <trap_dispatch+0x190>
  101eaa:	83 ec 0c             	sub    $0xc,%esp
  101ead:	ff 75 08             	pushl  0x8(%ebp)
  101eb0:	e8 37 fc ff ff       	call   101aec <trap_in_kernel>
  101eb5:	83 c4 10             	add    $0x10,%esp
  101eb8:	85 c0                	test   %eax,%eax
  101eba:	74 70                	je     101f2c <trap_dispatch+0x18f>
  101ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  101ebf:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  101ec5:	8b 45 08             	mov    0x8(%ebp),%eax
  101ec8:	66 c7 40 24 23 00    	movw   $0x23,0x24(%eax)
  101ece:	8b 45 08             	mov    0x8(%ebp),%eax
  101ed1:	0f b7 50 24          	movzwl 0x24(%eax),%edx
  101ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  101ed8:	66 89 50 20          	mov    %dx,0x20(%eax)
  101edc:	8b 45 08             	mov    0x8(%ebp),%eax
  101edf:	0f b7 50 20          	movzwl 0x20(%eax),%edx
  101ee3:	8b 45 08             	mov    0x8(%ebp),%eax
  101ee6:	66 89 50 28          	mov    %dx,0x28(%eax)
  101eea:	8b 45 08             	mov    0x8(%ebp),%eax
  101eed:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  101ef4:	66 89 50 2c          	mov    %dx,0x2c(%eax)
  101ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  101efb:	8b 40 40             	mov    0x40(%eax),%eax
  101efe:	80 cc 30             	or     $0x30,%ah
  101f01:	89 c2                	mov    %eax,%edx
  101f03:	8b 45 08             	mov    0x8(%ebp),%eax
  101f06:	89 50 40             	mov    %edx,0x40(%eax)
  101f09:	8b 45 08             	mov    0x8(%ebp),%eax
  101f0c:	8b 40 44             	mov    0x44(%eax),%eax
  101f0f:	89 e6                	mov    %esp,%esi
  101f11:	89 c1                	mov    %eax,%ecx
  101f13:	29 f1                	sub    %esi,%ecx
  101f15:	41                   	inc    %ecx
  101f16:	83 ec 08             	sub    $0x8,%esp
  101f19:	89 e7                	mov    %esp,%edi
  101f1b:	fc                   	cld    
  101f1c:	83 6d 00 08          	subl   $0x8,0x0(%ebp)
  101f20:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  101f22:	89 40 f8             	mov    %eax,-0x8(%eax)
  101f25:	c7 40 fc 23 00 00 00 	movl   $0x23,-0x4(%eax)
  101f2c:	90                   	nop
  101f2d:	e9 5c 01 00 00       	jmp    10208e <trap_dispatch+0x2f1>
  101f32:	8b 45 08             	mov    0x8(%ebp),%eax
  101f35:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101f39:	0f b7 c0             	movzwl %ax,%eax
  101f3c:	83 e0 03             	and    $0x3,%eax
  101f3f:	85 c0                	test   %eax,%eax
  101f41:	0f 85 43 01 00 00    	jne    10208a <trap_dispatch+0x2ed>
  101f47:	8b 45 08             	mov    0x8(%ebp),%eax
  101f4a:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  101f50:	8b 45 08             	mov    0x8(%ebp),%eax
  101f53:	66 c7 40 24 23 00    	movw   $0x23,0x24(%eax)
  101f59:	8b 45 08             	mov    0x8(%ebp),%eax
  101f5c:	0f b7 50 24          	movzwl 0x24(%eax),%edx
  101f60:	8b 45 08             	mov    0x8(%ebp),%eax
  101f63:	66 89 50 20          	mov    %dx,0x20(%eax)
  101f67:	8b 45 08             	mov    0x8(%ebp),%eax
  101f6a:	0f b7 50 20          	movzwl 0x20(%eax),%edx
  101f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  101f71:	66 89 50 28          	mov    %dx,0x28(%eax)
  101f75:	8b 45 08             	mov    0x8(%ebp),%eax
  101f78:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  101f7f:	66 89 50 2c          	mov    %dx,0x2c(%eax)
  101f83:	8b 45 08             	mov    0x8(%ebp),%eax
  101f86:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
  101f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  101f8d:	66 89 50 48          	mov    %dx,0x48(%eax)
  101f91:	8b 45 08             	mov    0x8(%ebp),%eax
  101f94:	8b 40 44             	mov    0x44(%eax),%eax
  101f97:	8d 50 04             	lea    0x4(%eax),%edx
  101f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  101f9d:	89 50 44             	mov    %edx,0x44(%eax)
  101fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  101fa3:	8b 40 40             	mov    0x40(%eax),%eax
  101fa6:	80 cc 30             	or     $0x30,%ah
  101fa9:	89 c2                	mov    %eax,%edx
  101fab:	8b 45 08             	mov    0x8(%ebp),%eax
  101fae:	89 50 40             	mov    %edx,0x40(%eax)
  101fb1:	e9 d4 00 00 00       	jmp    10208a <trap_dispatch+0x2ed>
  101fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  101fb9:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101fbd:	0f b7 c0             	movzwl %ax,%eax
  101fc0:	83 e0 03             	and    $0x3,%eax
  101fc3:	85 c0                	test   %eax,%eax
  101fc5:	0f 84 c2 00 00 00    	je     10208d <trap_dispatch+0x2f0>
  101fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  101fce:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
  101fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  101fd7:	66 c7 40 24 10 00    	movw   $0x10,0x24(%eax)
  101fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  101fe0:	0f b7 50 24          	movzwl 0x24(%eax),%edx
  101fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  101fe7:	66 89 50 20          	mov    %dx,0x20(%eax)
  101feb:	8b 45 08             	mov    0x8(%ebp),%eax
  101fee:	0f b7 50 20          	movzwl 0x20(%eax),%edx
  101ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  101ff5:	66 89 50 28          	mov    %dx,0x28(%eax)
  101ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  101ffc:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  102000:	8b 45 08             	mov    0x8(%ebp),%eax
  102003:	66 89 50 2c          	mov    %dx,0x2c(%eax)
  102007:	8b 45 08             	mov    0x8(%ebp),%eax
  10200a:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
  10200e:	8b 45 08             	mov    0x8(%ebp),%eax
  102011:	66 89 50 48          	mov    %dx,0x48(%eax)
  102015:	8b 45 08             	mov    0x8(%ebp),%eax
  102018:	8b 40 40             	mov    0x40(%eax),%eax
  10201b:	80 e4 cf             	and    $0xcf,%ah
  10201e:	89 c2                	mov    %eax,%edx
  102020:	8b 45 08             	mov    0x8(%ebp),%eax
  102023:	89 50 40             	mov    %edx,0x40(%eax)
  102026:	8b 45 08             	mov    0x8(%ebp),%eax
  102029:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  10202d:	8e d0                	mov    %eax,%ss
  10202f:	eb 5c                	jmp    10208d <trap_dispatch+0x2f0>
  102031:	83 ec 0c             	sub    $0xc,%esp
  102034:	68 b6 3c 10 00       	push   $0x103cb6
  102039:	e8 0c e2 ff ff       	call   10024a <cprintf>
  10203e:	83 c4 10             	add    $0x10,%esp
  102041:	83 ec 0c             	sub    $0xc,%esp
  102044:	ff 75 08             	pushl  0x8(%ebp)
  102047:	e8 b6 fa ff ff       	call   101b02 <print_trapframe>
  10204c:	83 c4 10             	add    $0x10,%esp
  10204f:	eb 3d                	jmp    10208e <trap_dispatch+0x2f1>
  102051:	8b 45 08             	mov    0x8(%ebp),%eax
  102054:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  102058:	0f b7 c0             	movzwl %ax,%eax
  10205b:	83 e0 03             	and    $0x3,%eax
  10205e:	85 c0                	test   %eax,%eax
  102060:	75 2c                	jne    10208e <trap_dispatch+0x2f1>
  102062:	83 ec 0c             	sub    $0xc,%esp
  102065:	ff 75 08             	pushl  0x8(%ebp)
  102068:	e8 95 fa ff ff       	call   101b02 <print_trapframe>
  10206d:	83 c4 10             	add    $0x10,%esp
  102070:	83 ec 04             	sub    $0x4,%esp
  102073:	68 c3 3c 10 00       	push   $0x103cc3
  102078:	68 03 01 00 00       	push   $0x103
  10207d:	68 df 3c 10 00       	push   $0x103cdf
  102082:	e8 2a e3 ff ff       	call   1003b1 <__panic>
  102087:	90                   	nop
  102088:	eb 04                	jmp    10208e <trap_dispatch+0x2f1>
  10208a:	90                   	nop
  10208b:	eb 01                	jmp    10208e <trap_dispatch+0x2f1>
  10208d:	90                   	nop
  10208e:	90                   	nop
  10208f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  102092:	5e                   	pop    %esi
  102093:	5f                   	pop    %edi
  102094:	5d                   	pop    %ebp
  102095:	c3                   	ret    

00102096 <trap>:
  102096:	55                   	push   %ebp
  102097:	89 e5                	mov    %esp,%ebp
  102099:	83 ec 08             	sub    $0x8,%esp
  10209c:	83 ec 0c             	sub    $0xc,%esp
  10209f:	ff 75 08             	pushl  0x8(%ebp)
  1020a2:	e8 f6 fc ff ff       	call   101d9d <trap_dispatch>
  1020a7:	83 c4 10             	add    $0x10,%esp
  1020aa:	90                   	nop
  1020ab:	c9                   	leave  
  1020ac:	c3                   	ret    

001020ad <vector0>:
  1020ad:	6a 00                	push   $0x0
  1020af:	6a 00                	push   $0x0
  1020b1:	e9 69 0a 00 00       	jmp    102b1f <__alltraps>

001020b6 <vector1>:
  1020b6:	6a 00                	push   $0x0
  1020b8:	6a 01                	push   $0x1
  1020ba:	e9 60 0a 00 00       	jmp    102b1f <__alltraps>

001020bf <vector2>:
  1020bf:	6a 00                	push   $0x0
  1020c1:	6a 02                	push   $0x2
  1020c3:	e9 57 0a 00 00       	jmp    102b1f <__alltraps>

001020c8 <vector3>:
  1020c8:	6a 00                	push   $0x0
  1020ca:	6a 03                	push   $0x3
  1020cc:	e9 4e 0a 00 00       	jmp    102b1f <__alltraps>

001020d1 <vector4>:
  1020d1:	6a 00                	push   $0x0
  1020d3:	6a 04                	push   $0x4
  1020d5:	e9 45 0a 00 00       	jmp    102b1f <__alltraps>

001020da <vector5>:
  1020da:	6a 00                	push   $0x0
  1020dc:	6a 05                	push   $0x5
  1020de:	e9 3c 0a 00 00       	jmp    102b1f <__alltraps>

001020e3 <vector6>:
  1020e3:	6a 00                	push   $0x0
  1020e5:	6a 06                	push   $0x6
  1020e7:	e9 33 0a 00 00       	jmp    102b1f <__alltraps>

001020ec <vector7>:
  1020ec:	6a 00                	push   $0x0
  1020ee:	6a 07                	push   $0x7
  1020f0:	e9 2a 0a 00 00       	jmp    102b1f <__alltraps>

001020f5 <vector8>:
  1020f5:	6a 08                	push   $0x8
  1020f7:	e9 23 0a 00 00       	jmp    102b1f <__alltraps>

001020fc <vector9>:
  1020fc:	6a 00                	push   $0x0
  1020fe:	6a 09                	push   $0x9
  102100:	e9 1a 0a 00 00       	jmp    102b1f <__alltraps>

00102105 <vector10>:
  102105:	6a 0a                	push   $0xa
  102107:	e9 13 0a 00 00       	jmp    102b1f <__alltraps>

0010210c <vector11>:
  10210c:	6a 0b                	push   $0xb
  10210e:	e9 0c 0a 00 00       	jmp    102b1f <__alltraps>

00102113 <vector12>:
  102113:	6a 0c                	push   $0xc
  102115:	e9 05 0a 00 00       	jmp    102b1f <__alltraps>

0010211a <vector13>:
  10211a:	6a 0d                	push   $0xd
  10211c:	e9 fe 09 00 00       	jmp    102b1f <__alltraps>

00102121 <vector14>:
  102121:	6a 0e                	push   $0xe
  102123:	e9 f7 09 00 00       	jmp    102b1f <__alltraps>

00102128 <vector15>:
  102128:	6a 00                	push   $0x0
  10212a:	6a 0f                	push   $0xf
  10212c:	e9 ee 09 00 00       	jmp    102b1f <__alltraps>

00102131 <vector16>:
  102131:	6a 00                	push   $0x0
  102133:	6a 10                	push   $0x10
  102135:	e9 e5 09 00 00       	jmp    102b1f <__alltraps>

0010213a <vector17>:
  10213a:	6a 11                	push   $0x11
  10213c:	e9 de 09 00 00       	jmp    102b1f <__alltraps>

00102141 <vector18>:
  102141:	6a 00                	push   $0x0
  102143:	6a 12                	push   $0x12
  102145:	e9 d5 09 00 00       	jmp    102b1f <__alltraps>

0010214a <vector19>:
  10214a:	6a 00                	push   $0x0
  10214c:	6a 13                	push   $0x13
  10214e:	e9 cc 09 00 00       	jmp    102b1f <__alltraps>

00102153 <vector20>:
  102153:	6a 00                	push   $0x0
  102155:	6a 14                	push   $0x14
  102157:	e9 c3 09 00 00       	jmp    102b1f <__alltraps>

0010215c <vector21>:
  10215c:	6a 00                	push   $0x0
  10215e:	6a 15                	push   $0x15
  102160:	e9 ba 09 00 00       	jmp    102b1f <__alltraps>

00102165 <vector22>:
  102165:	6a 00                	push   $0x0
  102167:	6a 16                	push   $0x16
  102169:	e9 b1 09 00 00       	jmp    102b1f <__alltraps>

0010216e <vector23>:
  10216e:	6a 00                	push   $0x0
  102170:	6a 17                	push   $0x17
  102172:	e9 a8 09 00 00       	jmp    102b1f <__alltraps>

00102177 <vector24>:
  102177:	6a 00                	push   $0x0
  102179:	6a 18                	push   $0x18
  10217b:	e9 9f 09 00 00       	jmp    102b1f <__alltraps>

00102180 <vector25>:
  102180:	6a 00                	push   $0x0
  102182:	6a 19                	push   $0x19
  102184:	e9 96 09 00 00       	jmp    102b1f <__alltraps>

00102189 <vector26>:
  102189:	6a 00                	push   $0x0
  10218b:	6a 1a                	push   $0x1a
  10218d:	e9 8d 09 00 00       	jmp    102b1f <__alltraps>

00102192 <vector27>:
  102192:	6a 00                	push   $0x0
  102194:	6a 1b                	push   $0x1b
  102196:	e9 84 09 00 00       	jmp    102b1f <__alltraps>

0010219b <vector28>:
  10219b:	6a 00                	push   $0x0
  10219d:	6a 1c                	push   $0x1c
  10219f:	e9 7b 09 00 00       	jmp    102b1f <__alltraps>

001021a4 <vector29>:
  1021a4:	6a 00                	push   $0x0
  1021a6:	6a 1d                	push   $0x1d
  1021a8:	e9 72 09 00 00       	jmp    102b1f <__alltraps>

001021ad <vector30>:
  1021ad:	6a 00                	push   $0x0
  1021af:	6a 1e                	push   $0x1e
  1021b1:	e9 69 09 00 00       	jmp    102b1f <__alltraps>

001021b6 <vector31>:
  1021b6:	6a 00                	push   $0x0
  1021b8:	6a 1f                	push   $0x1f
  1021ba:	e9 60 09 00 00       	jmp    102b1f <__alltraps>

001021bf <vector32>:
  1021bf:	6a 00                	push   $0x0
  1021c1:	6a 20                	push   $0x20
  1021c3:	e9 57 09 00 00       	jmp    102b1f <__alltraps>

001021c8 <vector33>:
  1021c8:	6a 00                	push   $0x0
  1021ca:	6a 21                	push   $0x21
  1021cc:	e9 4e 09 00 00       	jmp    102b1f <__alltraps>

001021d1 <vector34>:
  1021d1:	6a 00                	push   $0x0
  1021d3:	6a 22                	push   $0x22
  1021d5:	e9 45 09 00 00       	jmp    102b1f <__alltraps>

001021da <vector35>:
  1021da:	6a 00                	push   $0x0
  1021dc:	6a 23                	push   $0x23
  1021de:	e9 3c 09 00 00       	jmp    102b1f <__alltraps>

001021e3 <vector36>:
  1021e3:	6a 00                	push   $0x0
  1021e5:	6a 24                	push   $0x24
  1021e7:	e9 33 09 00 00       	jmp    102b1f <__alltraps>

001021ec <vector37>:
  1021ec:	6a 00                	push   $0x0
  1021ee:	6a 25                	push   $0x25
  1021f0:	e9 2a 09 00 00       	jmp    102b1f <__alltraps>

001021f5 <vector38>:
  1021f5:	6a 00                	push   $0x0
  1021f7:	6a 26                	push   $0x26
  1021f9:	e9 21 09 00 00       	jmp    102b1f <__alltraps>

001021fe <vector39>:
  1021fe:	6a 00                	push   $0x0
  102200:	6a 27                	push   $0x27
  102202:	e9 18 09 00 00       	jmp    102b1f <__alltraps>

00102207 <vector40>:
  102207:	6a 00                	push   $0x0
  102209:	6a 28                	push   $0x28
  10220b:	e9 0f 09 00 00       	jmp    102b1f <__alltraps>

00102210 <vector41>:
  102210:	6a 00                	push   $0x0
  102212:	6a 29                	push   $0x29
  102214:	e9 06 09 00 00       	jmp    102b1f <__alltraps>

00102219 <vector42>:
  102219:	6a 00                	push   $0x0
  10221b:	6a 2a                	push   $0x2a
  10221d:	e9 fd 08 00 00       	jmp    102b1f <__alltraps>

00102222 <vector43>:
  102222:	6a 00                	push   $0x0
  102224:	6a 2b                	push   $0x2b
  102226:	e9 f4 08 00 00       	jmp    102b1f <__alltraps>

0010222b <vector44>:
  10222b:	6a 00                	push   $0x0
  10222d:	6a 2c                	push   $0x2c
  10222f:	e9 eb 08 00 00       	jmp    102b1f <__alltraps>

00102234 <vector45>:
  102234:	6a 00                	push   $0x0
  102236:	6a 2d                	push   $0x2d
  102238:	e9 e2 08 00 00       	jmp    102b1f <__alltraps>

0010223d <vector46>:
  10223d:	6a 00                	push   $0x0
  10223f:	6a 2e                	push   $0x2e
  102241:	e9 d9 08 00 00       	jmp    102b1f <__alltraps>

00102246 <vector47>:
  102246:	6a 00                	push   $0x0
  102248:	6a 2f                	push   $0x2f
  10224a:	e9 d0 08 00 00       	jmp    102b1f <__alltraps>

0010224f <vector48>:
  10224f:	6a 00                	push   $0x0
  102251:	6a 30                	push   $0x30
  102253:	e9 c7 08 00 00       	jmp    102b1f <__alltraps>

00102258 <vector49>:
  102258:	6a 00                	push   $0x0
  10225a:	6a 31                	push   $0x31
  10225c:	e9 be 08 00 00       	jmp    102b1f <__alltraps>

00102261 <vector50>:
  102261:	6a 00                	push   $0x0
  102263:	6a 32                	push   $0x32
  102265:	e9 b5 08 00 00       	jmp    102b1f <__alltraps>

0010226a <vector51>:
  10226a:	6a 00                	push   $0x0
  10226c:	6a 33                	push   $0x33
  10226e:	e9 ac 08 00 00       	jmp    102b1f <__alltraps>

00102273 <vector52>:
  102273:	6a 00                	push   $0x0
  102275:	6a 34                	push   $0x34
  102277:	e9 a3 08 00 00       	jmp    102b1f <__alltraps>

0010227c <vector53>:
  10227c:	6a 00                	push   $0x0
  10227e:	6a 35                	push   $0x35
  102280:	e9 9a 08 00 00       	jmp    102b1f <__alltraps>

00102285 <vector54>:
  102285:	6a 00                	push   $0x0
  102287:	6a 36                	push   $0x36
  102289:	e9 91 08 00 00       	jmp    102b1f <__alltraps>

0010228e <vector55>:
  10228e:	6a 00                	push   $0x0
  102290:	6a 37                	push   $0x37
  102292:	e9 88 08 00 00       	jmp    102b1f <__alltraps>

00102297 <vector56>:
  102297:	6a 00                	push   $0x0
  102299:	6a 38                	push   $0x38
  10229b:	e9 7f 08 00 00       	jmp    102b1f <__alltraps>

001022a0 <vector57>:
  1022a0:	6a 00                	push   $0x0
  1022a2:	6a 39                	push   $0x39
  1022a4:	e9 76 08 00 00       	jmp    102b1f <__alltraps>

001022a9 <vector58>:
  1022a9:	6a 00                	push   $0x0
  1022ab:	6a 3a                	push   $0x3a
  1022ad:	e9 6d 08 00 00       	jmp    102b1f <__alltraps>

001022b2 <vector59>:
  1022b2:	6a 00                	push   $0x0
  1022b4:	6a 3b                	push   $0x3b
  1022b6:	e9 64 08 00 00       	jmp    102b1f <__alltraps>

001022bb <vector60>:
  1022bb:	6a 00                	push   $0x0
  1022bd:	6a 3c                	push   $0x3c
  1022bf:	e9 5b 08 00 00       	jmp    102b1f <__alltraps>

001022c4 <vector61>:
  1022c4:	6a 00                	push   $0x0
  1022c6:	6a 3d                	push   $0x3d
  1022c8:	e9 52 08 00 00       	jmp    102b1f <__alltraps>

001022cd <vector62>:
  1022cd:	6a 00                	push   $0x0
  1022cf:	6a 3e                	push   $0x3e
  1022d1:	e9 49 08 00 00       	jmp    102b1f <__alltraps>

001022d6 <vector63>:
  1022d6:	6a 00                	push   $0x0
  1022d8:	6a 3f                	push   $0x3f
  1022da:	e9 40 08 00 00       	jmp    102b1f <__alltraps>

001022df <vector64>:
  1022df:	6a 00                	push   $0x0
  1022e1:	6a 40                	push   $0x40
  1022e3:	e9 37 08 00 00       	jmp    102b1f <__alltraps>

001022e8 <vector65>:
  1022e8:	6a 00                	push   $0x0
  1022ea:	6a 41                	push   $0x41
  1022ec:	e9 2e 08 00 00       	jmp    102b1f <__alltraps>

001022f1 <vector66>:
  1022f1:	6a 00                	push   $0x0
  1022f3:	6a 42                	push   $0x42
  1022f5:	e9 25 08 00 00       	jmp    102b1f <__alltraps>

001022fa <vector67>:
  1022fa:	6a 00                	push   $0x0
  1022fc:	6a 43                	push   $0x43
  1022fe:	e9 1c 08 00 00       	jmp    102b1f <__alltraps>

00102303 <vector68>:
  102303:	6a 00                	push   $0x0
  102305:	6a 44                	push   $0x44
  102307:	e9 13 08 00 00       	jmp    102b1f <__alltraps>

0010230c <vector69>:
  10230c:	6a 00                	push   $0x0
  10230e:	6a 45                	push   $0x45
  102310:	e9 0a 08 00 00       	jmp    102b1f <__alltraps>

00102315 <vector70>:
  102315:	6a 00                	push   $0x0
  102317:	6a 46                	push   $0x46
  102319:	e9 01 08 00 00       	jmp    102b1f <__alltraps>

0010231e <vector71>:
  10231e:	6a 00                	push   $0x0
  102320:	6a 47                	push   $0x47
  102322:	e9 f8 07 00 00       	jmp    102b1f <__alltraps>

00102327 <vector72>:
  102327:	6a 00                	push   $0x0
  102329:	6a 48                	push   $0x48
  10232b:	e9 ef 07 00 00       	jmp    102b1f <__alltraps>

00102330 <vector73>:
  102330:	6a 00                	push   $0x0
  102332:	6a 49                	push   $0x49
  102334:	e9 e6 07 00 00       	jmp    102b1f <__alltraps>

00102339 <vector74>:
  102339:	6a 00                	push   $0x0
  10233b:	6a 4a                	push   $0x4a
  10233d:	e9 dd 07 00 00       	jmp    102b1f <__alltraps>

00102342 <vector75>:
  102342:	6a 00                	push   $0x0
  102344:	6a 4b                	push   $0x4b
  102346:	e9 d4 07 00 00       	jmp    102b1f <__alltraps>

0010234b <vector76>:
  10234b:	6a 00                	push   $0x0
  10234d:	6a 4c                	push   $0x4c
  10234f:	e9 cb 07 00 00       	jmp    102b1f <__alltraps>

00102354 <vector77>:
  102354:	6a 00                	push   $0x0
  102356:	6a 4d                	push   $0x4d
  102358:	e9 c2 07 00 00       	jmp    102b1f <__alltraps>

0010235d <vector78>:
  10235d:	6a 00                	push   $0x0
  10235f:	6a 4e                	push   $0x4e
  102361:	e9 b9 07 00 00       	jmp    102b1f <__alltraps>

00102366 <vector79>:
  102366:	6a 00                	push   $0x0
  102368:	6a 4f                	push   $0x4f
  10236a:	e9 b0 07 00 00       	jmp    102b1f <__alltraps>

0010236f <vector80>:
  10236f:	6a 00                	push   $0x0
  102371:	6a 50                	push   $0x50
  102373:	e9 a7 07 00 00       	jmp    102b1f <__alltraps>

00102378 <vector81>:
  102378:	6a 00                	push   $0x0
  10237a:	6a 51                	push   $0x51
  10237c:	e9 9e 07 00 00       	jmp    102b1f <__alltraps>

00102381 <vector82>:
  102381:	6a 00                	push   $0x0
  102383:	6a 52                	push   $0x52
  102385:	e9 95 07 00 00       	jmp    102b1f <__alltraps>

0010238a <vector83>:
  10238a:	6a 00                	push   $0x0
  10238c:	6a 53                	push   $0x53
  10238e:	e9 8c 07 00 00       	jmp    102b1f <__alltraps>

00102393 <vector84>:
  102393:	6a 00                	push   $0x0
  102395:	6a 54                	push   $0x54
  102397:	e9 83 07 00 00       	jmp    102b1f <__alltraps>

0010239c <vector85>:
  10239c:	6a 00                	push   $0x0
  10239e:	6a 55                	push   $0x55
  1023a0:	e9 7a 07 00 00       	jmp    102b1f <__alltraps>

001023a5 <vector86>:
  1023a5:	6a 00                	push   $0x0
  1023a7:	6a 56                	push   $0x56
  1023a9:	e9 71 07 00 00       	jmp    102b1f <__alltraps>

001023ae <vector87>:
  1023ae:	6a 00                	push   $0x0
  1023b0:	6a 57                	push   $0x57
  1023b2:	e9 68 07 00 00       	jmp    102b1f <__alltraps>

001023b7 <vector88>:
  1023b7:	6a 00                	push   $0x0
  1023b9:	6a 58                	push   $0x58
  1023bb:	e9 5f 07 00 00       	jmp    102b1f <__alltraps>

001023c0 <vector89>:
  1023c0:	6a 00                	push   $0x0
  1023c2:	6a 59                	push   $0x59
  1023c4:	e9 56 07 00 00       	jmp    102b1f <__alltraps>

001023c9 <vector90>:
  1023c9:	6a 00                	push   $0x0
  1023cb:	6a 5a                	push   $0x5a
  1023cd:	e9 4d 07 00 00       	jmp    102b1f <__alltraps>

001023d2 <vector91>:
  1023d2:	6a 00                	push   $0x0
  1023d4:	6a 5b                	push   $0x5b
  1023d6:	e9 44 07 00 00       	jmp    102b1f <__alltraps>

001023db <vector92>:
  1023db:	6a 00                	push   $0x0
  1023dd:	6a 5c                	push   $0x5c
  1023df:	e9 3b 07 00 00       	jmp    102b1f <__alltraps>

001023e4 <vector93>:
  1023e4:	6a 00                	push   $0x0
  1023e6:	6a 5d                	push   $0x5d
  1023e8:	e9 32 07 00 00       	jmp    102b1f <__alltraps>

001023ed <vector94>:
  1023ed:	6a 00                	push   $0x0
  1023ef:	6a 5e                	push   $0x5e
  1023f1:	e9 29 07 00 00       	jmp    102b1f <__alltraps>

001023f6 <vector95>:
  1023f6:	6a 00                	push   $0x0
  1023f8:	6a 5f                	push   $0x5f
  1023fa:	e9 20 07 00 00       	jmp    102b1f <__alltraps>

001023ff <vector96>:
  1023ff:	6a 00                	push   $0x0
  102401:	6a 60                	push   $0x60
  102403:	e9 17 07 00 00       	jmp    102b1f <__alltraps>

00102408 <vector97>:
  102408:	6a 00                	push   $0x0
  10240a:	6a 61                	push   $0x61
  10240c:	e9 0e 07 00 00       	jmp    102b1f <__alltraps>

00102411 <vector98>:
  102411:	6a 00                	push   $0x0
  102413:	6a 62                	push   $0x62
  102415:	e9 05 07 00 00       	jmp    102b1f <__alltraps>

0010241a <vector99>:
  10241a:	6a 00                	push   $0x0
  10241c:	6a 63                	push   $0x63
  10241e:	e9 fc 06 00 00       	jmp    102b1f <__alltraps>

00102423 <vector100>:
  102423:	6a 00                	push   $0x0
  102425:	6a 64                	push   $0x64
  102427:	e9 f3 06 00 00       	jmp    102b1f <__alltraps>

0010242c <vector101>:
  10242c:	6a 00                	push   $0x0
  10242e:	6a 65                	push   $0x65
  102430:	e9 ea 06 00 00       	jmp    102b1f <__alltraps>

00102435 <vector102>:
  102435:	6a 00                	push   $0x0
  102437:	6a 66                	push   $0x66
  102439:	e9 e1 06 00 00       	jmp    102b1f <__alltraps>

0010243e <vector103>:
  10243e:	6a 00                	push   $0x0
  102440:	6a 67                	push   $0x67
  102442:	e9 d8 06 00 00       	jmp    102b1f <__alltraps>

00102447 <vector104>:
  102447:	6a 00                	push   $0x0
  102449:	6a 68                	push   $0x68
  10244b:	e9 cf 06 00 00       	jmp    102b1f <__alltraps>

00102450 <vector105>:
  102450:	6a 00                	push   $0x0
  102452:	6a 69                	push   $0x69
  102454:	e9 c6 06 00 00       	jmp    102b1f <__alltraps>

00102459 <vector106>:
  102459:	6a 00                	push   $0x0
  10245b:	6a 6a                	push   $0x6a
  10245d:	e9 bd 06 00 00       	jmp    102b1f <__alltraps>

00102462 <vector107>:
  102462:	6a 00                	push   $0x0
  102464:	6a 6b                	push   $0x6b
  102466:	e9 b4 06 00 00       	jmp    102b1f <__alltraps>

0010246b <vector108>:
  10246b:	6a 00                	push   $0x0
  10246d:	6a 6c                	push   $0x6c
  10246f:	e9 ab 06 00 00       	jmp    102b1f <__alltraps>

00102474 <vector109>:
  102474:	6a 00                	push   $0x0
  102476:	6a 6d                	push   $0x6d
  102478:	e9 a2 06 00 00       	jmp    102b1f <__alltraps>

0010247d <vector110>:
  10247d:	6a 00                	push   $0x0
  10247f:	6a 6e                	push   $0x6e
  102481:	e9 99 06 00 00       	jmp    102b1f <__alltraps>

00102486 <vector111>:
  102486:	6a 00                	push   $0x0
  102488:	6a 6f                	push   $0x6f
  10248a:	e9 90 06 00 00       	jmp    102b1f <__alltraps>

0010248f <vector112>:
  10248f:	6a 00                	push   $0x0
  102491:	6a 70                	push   $0x70
  102493:	e9 87 06 00 00       	jmp    102b1f <__alltraps>

00102498 <vector113>:
  102498:	6a 00                	push   $0x0
  10249a:	6a 71                	push   $0x71
  10249c:	e9 7e 06 00 00       	jmp    102b1f <__alltraps>

001024a1 <vector114>:
  1024a1:	6a 00                	push   $0x0
  1024a3:	6a 72                	push   $0x72
  1024a5:	e9 75 06 00 00       	jmp    102b1f <__alltraps>

001024aa <vector115>:
  1024aa:	6a 00                	push   $0x0
  1024ac:	6a 73                	push   $0x73
  1024ae:	e9 6c 06 00 00       	jmp    102b1f <__alltraps>

001024b3 <vector116>:
  1024b3:	6a 00                	push   $0x0
  1024b5:	6a 74                	push   $0x74
  1024b7:	e9 63 06 00 00       	jmp    102b1f <__alltraps>

001024bc <vector117>:
  1024bc:	6a 00                	push   $0x0
  1024be:	6a 75                	push   $0x75
  1024c0:	e9 5a 06 00 00       	jmp    102b1f <__alltraps>

001024c5 <vector118>:
  1024c5:	6a 00                	push   $0x0
  1024c7:	6a 76                	push   $0x76
  1024c9:	e9 51 06 00 00       	jmp    102b1f <__alltraps>

001024ce <vector119>:
  1024ce:	6a 00                	push   $0x0
  1024d0:	6a 77                	push   $0x77
  1024d2:	e9 48 06 00 00       	jmp    102b1f <__alltraps>

001024d7 <vector120>:
  1024d7:	6a 00                	push   $0x0
  1024d9:	6a 78                	push   $0x78
  1024db:	e9 3f 06 00 00       	jmp    102b1f <__alltraps>

001024e0 <vector121>:
  1024e0:	6a 00                	push   $0x0
  1024e2:	6a 79                	push   $0x79
  1024e4:	e9 36 06 00 00       	jmp    102b1f <__alltraps>

001024e9 <vector122>:
  1024e9:	6a 00                	push   $0x0
  1024eb:	6a 7a                	push   $0x7a
  1024ed:	e9 2d 06 00 00       	jmp    102b1f <__alltraps>

001024f2 <vector123>:
  1024f2:	6a 00                	push   $0x0
  1024f4:	6a 7b                	push   $0x7b
  1024f6:	e9 24 06 00 00       	jmp    102b1f <__alltraps>

001024fb <vector124>:
  1024fb:	6a 00                	push   $0x0
  1024fd:	6a 7c                	push   $0x7c
  1024ff:	e9 1b 06 00 00       	jmp    102b1f <__alltraps>

00102504 <vector125>:
  102504:	6a 00                	push   $0x0
  102506:	6a 7d                	push   $0x7d
  102508:	e9 12 06 00 00       	jmp    102b1f <__alltraps>

0010250d <vector126>:
  10250d:	6a 00                	push   $0x0
  10250f:	6a 7e                	push   $0x7e
  102511:	e9 09 06 00 00       	jmp    102b1f <__alltraps>

00102516 <vector127>:
  102516:	6a 00                	push   $0x0
  102518:	6a 7f                	push   $0x7f
  10251a:	e9 00 06 00 00       	jmp    102b1f <__alltraps>

0010251f <vector128>:
  10251f:	6a 00                	push   $0x0
  102521:	68 80 00 00 00       	push   $0x80
  102526:	e9 f4 05 00 00       	jmp    102b1f <__alltraps>

0010252b <vector129>:
  10252b:	6a 00                	push   $0x0
  10252d:	68 81 00 00 00       	push   $0x81
  102532:	e9 e8 05 00 00       	jmp    102b1f <__alltraps>

00102537 <vector130>:
  102537:	6a 00                	push   $0x0
  102539:	68 82 00 00 00       	push   $0x82
  10253e:	e9 dc 05 00 00       	jmp    102b1f <__alltraps>

00102543 <vector131>:
  102543:	6a 00                	push   $0x0
  102545:	68 83 00 00 00       	push   $0x83
  10254a:	e9 d0 05 00 00       	jmp    102b1f <__alltraps>

0010254f <vector132>:
  10254f:	6a 00                	push   $0x0
  102551:	68 84 00 00 00       	push   $0x84
  102556:	e9 c4 05 00 00       	jmp    102b1f <__alltraps>

0010255b <vector133>:
  10255b:	6a 00                	push   $0x0
  10255d:	68 85 00 00 00       	push   $0x85
  102562:	e9 b8 05 00 00       	jmp    102b1f <__alltraps>

00102567 <vector134>:
  102567:	6a 00                	push   $0x0
  102569:	68 86 00 00 00       	push   $0x86
  10256e:	e9 ac 05 00 00       	jmp    102b1f <__alltraps>

00102573 <vector135>:
  102573:	6a 00                	push   $0x0
  102575:	68 87 00 00 00       	push   $0x87
  10257a:	e9 a0 05 00 00       	jmp    102b1f <__alltraps>

0010257f <vector136>:
  10257f:	6a 00                	push   $0x0
  102581:	68 88 00 00 00       	push   $0x88
  102586:	e9 94 05 00 00       	jmp    102b1f <__alltraps>

0010258b <vector137>:
  10258b:	6a 00                	push   $0x0
  10258d:	68 89 00 00 00       	push   $0x89
  102592:	e9 88 05 00 00       	jmp    102b1f <__alltraps>

00102597 <vector138>:
  102597:	6a 00                	push   $0x0
  102599:	68 8a 00 00 00       	push   $0x8a
  10259e:	e9 7c 05 00 00       	jmp    102b1f <__alltraps>

001025a3 <vector139>:
  1025a3:	6a 00                	push   $0x0
  1025a5:	68 8b 00 00 00       	push   $0x8b
  1025aa:	e9 70 05 00 00       	jmp    102b1f <__alltraps>

001025af <vector140>:
  1025af:	6a 00                	push   $0x0
  1025b1:	68 8c 00 00 00       	push   $0x8c
  1025b6:	e9 64 05 00 00       	jmp    102b1f <__alltraps>

001025bb <vector141>:
  1025bb:	6a 00                	push   $0x0
  1025bd:	68 8d 00 00 00       	push   $0x8d
  1025c2:	e9 58 05 00 00       	jmp    102b1f <__alltraps>

001025c7 <vector142>:
  1025c7:	6a 00                	push   $0x0
  1025c9:	68 8e 00 00 00       	push   $0x8e
  1025ce:	e9 4c 05 00 00       	jmp    102b1f <__alltraps>

001025d3 <vector143>:
  1025d3:	6a 00                	push   $0x0
  1025d5:	68 8f 00 00 00       	push   $0x8f
  1025da:	e9 40 05 00 00       	jmp    102b1f <__alltraps>

001025df <vector144>:
  1025df:	6a 00                	push   $0x0
  1025e1:	68 90 00 00 00       	push   $0x90
  1025e6:	e9 34 05 00 00       	jmp    102b1f <__alltraps>

001025eb <vector145>:
  1025eb:	6a 00                	push   $0x0
  1025ed:	68 91 00 00 00       	push   $0x91
  1025f2:	e9 28 05 00 00       	jmp    102b1f <__alltraps>

001025f7 <vector146>:
  1025f7:	6a 00                	push   $0x0
  1025f9:	68 92 00 00 00       	push   $0x92
  1025fe:	e9 1c 05 00 00       	jmp    102b1f <__alltraps>

00102603 <vector147>:
  102603:	6a 00                	push   $0x0
  102605:	68 93 00 00 00       	push   $0x93
  10260a:	e9 10 05 00 00       	jmp    102b1f <__alltraps>

0010260f <vector148>:
  10260f:	6a 00                	push   $0x0
  102611:	68 94 00 00 00       	push   $0x94
  102616:	e9 04 05 00 00       	jmp    102b1f <__alltraps>

0010261b <vector149>:
  10261b:	6a 00                	push   $0x0
  10261d:	68 95 00 00 00       	push   $0x95
  102622:	e9 f8 04 00 00       	jmp    102b1f <__alltraps>

00102627 <vector150>:
  102627:	6a 00                	push   $0x0
  102629:	68 96 00 00 00       	push   $0x96
  10262e:	e9 ec 04 00 00       	jmp    102b1f <__alltraps>

00102633 <vector151>:
  102633:	6a 00                	push   $0x0
  102635:	68 97 00 00 00       	push   $0x97
  10263a:	e9 e0 04 00 00       	jmp    102b1f <__alltraps>

0010263f <vector152>:
  10263f:	6a 00                	push   $0x0
  102641:	68 98 00 00 00       	push   $0x98
  102646:	e9 d4 04 00 00       	jmp    102b1f <__alltraps>

0010264b <vector153>:
  10264b:	6a 00                	push   $0x0
  10264d:	68 99 00 00 00       	push   $0x99
  102652:	e9 c8 04 00 00       	jmp    102b1f <__alltraps>

00102657 <vector154>:
  102657:	6a 00                	push   $0x0
  102659:	68 9a 00 00 00       	push   $0x9a
  10265e:	e9 bc 04 00 00       	jmp    102b1f <__alltraps>

00102663 <vector155>:
  102663:	6a 00                	push   $0x0
  102665:	68 9b 00 00 00       	push   $0x9b
  10266a:	e9 b0 04 00 00       	jmp    102b1f <__alltraps>

0010266f <vector156>:
  10266f:	6a 00                	push   $0x0
  102671:	68 9c 00 00 00       	push   $0x9c
  102676:	e9 a4 04 00 00       	jmp    102b1f <__alltraps>

0010267b <vector157>:
  10267b:	6a 00                	push   $0x0
  10267d:	68 9d 00 00 00       	push   $0x9d
  102682:	e9 98 04 00 00       	jmp    102b1f <__alltraps>

00102687 <vector158>:
  102687:	6a 00                	push   $0x0
  102689:	68 9e 00 00 00       	push   $0x9e
  10268e:	e9 8c 04 00 00       	jmp    102b1f <__alltraps>

00102693 <vector159>:
  102693:	6a 00                	push   $0x0
  102695:	68 9f 00 00 00       	push   $0x9f
  10269a:	e9 80 04 00 00       	jmp    102b1f <__alltraps>

0010269f <vector160>:
  10269f:	6a 00                	push   $0x0
  1026a1:	68 a0 00 00 00       	push   $0xa0
  1026a6:	e9 74 04 00 00       	jmp    102b1f <__alltraps>

001026ab <vector161>:
  1026ab:	6a 00                	push   $0x0
  1026ad:	68 a1 00 00 00       	push   $0xa1
  1026b2:	e9 68 04 00 00       	jmp    102b1f <__alltraps>

001026b7 <vector162>:
  1026b7:	6a 00                	push   $0x0
  1026b9:	68 a2 00 00 00       	push   $0xa2
  1026be:	e9 5c 04 00 00       	jmp    102b1f <__alltraps>

001026c3 <vector163>:
  1026c3:	6a 00                	push   $0x0
  1026c5:	68 a3 00 00 00       	push   $0xa3
  1026ca:	e9 50 04 00 00       	jmp    102b1f <__alltraps>

001026cf <vector164>:
  1026cf:	6a 00                	push   $0x0
  1026d1:	68 a4 00 00 00       	push   $0xa4
  1026d6:	e9 44 04 00 00       	jmp    102b1f <__alltraps>

001026db <vector165>:
  1026db:	6a 00                	push   $0x0
  1026dd:	68 a5 00 00 00       	push   $0xa5
  1026e2:	e9 38 04 00 00       	jmp    102b1f <__alltraps>

001026e7 <vector166>:
  1026e7:	6a 00                	push   $0x0
  1026e9:	68 a6 00 00 00       	push   $0xa6
  1026ee:	e9 2c 04 00 00       	jmp    102b1f <__alltraps>

001026f3 <vector167>:
  1026f3:	6a 00                	push   $0x0
  1026f5:	68 a7 00 00 00       	push   $0xa7
  1026fa:	e9 20 04 00 00       	jmp    102b1f <__alltraps>

001026ff <vector168>:
  1026ff:	6a 00                	push   $0x0
  102701:	68 a8 00 00 00       	push   $0xa8
  102706:	e9 14 04 00 00       	jmp    102b1f <__alltraps>

0010270b <vector169>:
  10270b:	6a 00                	push   $0x0
  10270d:	68 a9 00 00 00       	push   $0xa9
  102712:	e9 08 04 00 00       	jmp    102b1f <__alltraps>

00102717 <vector170>:
  102717:	6a 00                	push   $0x0
  102719:	68 aa 00 00 00       	push   $0xaa
  10271e:	e9 fc 03 00 00       	jmp    102b1f <__alltraps>

00102723 <vector171>:
  102723:	6a 00                	push   $0x0
  102725:	68 ab 00 00 00       	push   $0xab
  10272a:	e9 f0 03 00 00       	jmp    102b1f <__alltraps>

0010272f <vector172>:
  10272f:	6a 00                	push   $0x0
  102731:	68 ac 00 00 00       	push   $0xac
  102736:	e9 e4 03 00 00       	jmp    102b1f <__alltraps>

0010273b <vector173>:
  10273b:	6a 00                	push   $0x0
  10273d:	68 ad 00 00 00       	push   $0xad
  102742:	e9 d8 03 00 00       	jmp    102b1f <__alltraps>

00102747 <vector174>:
  102747:	6a 00                	push   $0x0
  102749:	68 ae 00 00 00       	push   $0xae
  10274e:	e9 cc 03 00 00       	jmp    102b1f <__alltraps>

00102753 <vector175>:
  102753:	6a 00                	push   $0x0
  102755:	68 af 00 00 00       	push   $0xaf
  10275a:	e9 c0 03 00 00       	jmp    102b1f <__alltraps>

0010275f <vector176>:
  10275f:	6a 00                	push   $0x0
  102761:	68 b0 00 00 00       	push   $0xb0
  102766:	e9 b4 03 00 00       	jmp    102b1f <__alltraps>

0010276b <vector177>:
  10276b:	6a 00                	push   $0x0
  10276d:	68 b1 00 00 00       	push   $0xb1
  102772:	e9 a8 03 00 00       	jmp    102b1f <__alltraps>

00102777 <vector178>:
  102777:	6a 00                	push   $0x0
  102779:	68 b2 00 00 00       	push   $0xb2
  10277e:	e9 9c 03 00 00       	jmp    102b1f <__alltraps>

00102783 <vector179>:
  102783:	6a 00                	push   $0x0
  102785:	68 b3 00 00 00       	push   $0xb3
  10278a:	e9 90 03 00 00       	jmp    102b1f <__alltraps>

0010278f <vector180>:
  10278f:	6a 00                	push   $0x0
  102791:	68 b4 00 00 00       	push   $0xb4
  102796:	e9 84 03 00 00       	jmp    102b1f <__alltraps>

0010279b <vector181>:
  10279b:	6a 00                	push   $0x0
  10279d:	68 b5 00 00 00       	push   $0xb5
  1027a2:	e9 78 03 00 00       	jmp    102b1f <__alltraps>

001027a7 <vector182>:
  1027a7:	6a 00                	push   $0x0
  1027a9:	68 b6 00 00 00       	push   $0xb6
  1027ae:	e9 6c 03 00 00       	jmp    102b1f <__alltraps>

001027b3 <vector183>:
  1027b3:	6a 00                	push   $0x0
  1027b5:	68 b7 00 00 00       	push   $0xb7
  1027ba:	e9 60 03 00 00       	jmp    102b1f <__alltraps>

001027bf <vector184>:
  1027bf:	6a 00                	push   $0x0
  1027c1:	68 b8 00 00 00       	push   $0xb8
  1027c6:	e9 54 03 00 00       	jmp    102b1f <__alltraps>

001027cb <vector185>:
  1027cb:	6a 00                	push   $0x0
  1027cd:	68 b9 00 00 00       	push   $0xb9
  1027d2:	e9 48 03 00 00       	jmp    102b1f <__alltraps>

001027d7 <vector186>:
  1027d7:	6a 00                	push   $0x0
  1027d9:	68 ba 00 00 00       	push   $0xba
  1027de:	e9 3c 03 00 00       	jmp    102b1f <__alltraps>

001027e3 <vector187>:
  1027e3:	6a 00                	push   $0x0
  1027e5:	68 bb 00 00 00       	push   $0xbb
  1027ea:	e9 30 03 00 00       	jmp    102b1f <__alltraps>

001027ef <vector188>:
  1027ef:	6a 00                	push   $0x0
  1027f1:	68 bc 00 00 00       	push   $0xbc
  1027f6:	e9 24 03 00 00       	jmp    102b1f <__alltraps>

001027fb <vector189>:
  1027fb:	6a 00                	push   $0x0
  1027fd:	68 bd 00 00 00       	push   $0xbd
  102802:	e9 18 03 00 00       	jmp    102b1f <__alltraps>

00102807 <vector190>:
  102807:	6a 00                	push   $0x0
  102809:	68 be 00 00 00       	push   $0xbe
  10280e:	e9 0c 03 00 00       	jmp    102b1f <__alltraps>

00102813 <vector191>:
  102813:	6a 00                	push   $0x0
  102815:	68 bf 00 00 00       	push   $0xbf
  10281a:	e9 00 03 00 00       	jmp    102b1f <__alltraps>

0010281f <vector192>:
  10281f:	6a 00                	push   $0x0
  102821:	68 c0 00 00 00       	push   $0xc0
  102826:	e9 f4 02 00 00       	jmp    102b1f <__alltraps>

0010282b <vector193>:
  10282b:	6a 00                	push   $0x0
  10282d:	68 c1 00 00 00       	push   $0xc1
  102832:	e9 e8 02 00 00       	jmp    102b1f <__alltraps>

00102837 <vector194>:
  102837:	6a 00                	push   $0x0
  102839:	68 c2 00 00 00       	push   $0xc2
  10283e:	e9 dc 02 00 00       	jmp    102b1f <__alltraps>

00102843 <vector195>:
  102843:	6a 00                	push   $0x0
  102845:	68 c3 00 00 00       	push   $0xc3
  10284a:	e9 d0 02 00 00       	jmp    102b1f <__alltraps>

0010284f <vector196>:
  10284f:	6a 00                	push   $0x0
  102851:	68 c4 00 00 00       	push   $0xc4
  102856:	e9 c4 02 00 00       	jmp    102b1f <__alltraps>

0010285b <vector197>:
  10285b:	6a 00                	push   $0x0
  10285d:	68 c5 00 00 00       	push   $0xc5
  102862:	e9 b8 02 00 00       	jmp    102b1f <__alltraps>

00102867 <vector198>:
  102867:	6a 00                	push   $0x0
  102869:	68 c6 00 00 00       	push   $0xc6
  10286e:	e9 ac 02 00 00       	jmp    102b1f <__alltraps>

00102873 <vector199>:
  102873:	6a 00                	push   $0x0
  102875:	68 c7 00 00 00       	push   $0xc7
  10287a:	e9 a0 02 00 00       	jmp    102b1f <__alltraps>

0010287f <vector200>:
  10287f:	6a 00                	push   $0x0
  102881:	68 c8 00 00 00       	push   $0xc8
  102886:	e9 94 02 00 00       	jmp    102b1f <__alltraps>

0010288b <vector201>:
  10288b:	6a 00                	push   $0x0
  10288d:	68 c9 00 00 00       	push   $0xc9
  102892:	e9 88 02 00 00       	jmp    102b1f <__alltraps>

00102897 <vector202>:
  102897:	6a 00                	push   $0x0
  102899:	68 ca 00 00 00       	push   $0xca
  10289e:	e9 7c 02 00 00       	jmp    102b1f <__alltraps>

001028a3 <vector203>:
  1028a3:	6a 00                	push   $0x0
  1028a5:	68 cb 00 00 00       	push   $0xcb
  1028aa:	e9 70 02 00 00       	jmp    102b1f <__alltraps>

001028af <vector204>:
  1028af:	6a 00                	push   $0x0
  1028b1:	68 cc 00 00 00       	push   $0xcc
  1028b6:	e9 64 02 00 00       	jmp    102b1f <__alltraps>

001028bb <vector205>:
  1028bb:	6a 00                	push   $0x0
  1028bd:	68 cd 00 00 00       	push   $0xcd
  1028c2:	e9 58 02 00 00       	jmp    102b1f <__alltraps>

001028c7 <vector206>:
  1028c7:	6a 00                	push   $0x0
  1028c9:	68 ce 00 00 00       	push   $0xce
  1028ce:	e9 4c 02 00 00       	jmp    102b1f <__alltraps>

001028d3 <vector207>:
  1028d3:	6a 00                	push   $0x0
  1028d5:	68 cf 00 00 00       	push   $0xcf
  1028da:	e9 40 02 00 00       	jmp    102b1f <__alltraps>

001028df <vector208>:
  1028df:	6a 00                	push   $0x0
  1028e1:	68 d0 00 00 00       	push   $0xd0
  1028e6:	e9 34 02 00 00       	jmp    102b1f <__alltraps>

001028eb <vector209>:
  1028eb:	6a 00                	push   $0x0
  1028ed:	68 d1 00 00 00       	push   $0xd1
  1028f2:	e9 28 02 00 00       	jmp    102b1f <__alltraps>

001028f7 <vector210>:
  1028f7:	6a 00                	push   $0x0
  1028f9:	68 d2 00 00 00       	push   $0xd2
  1028fe:	e9 1c 02 00 00       	jmp    102b1f <__alltraps>

00102903 <vector211>:
  102903:	6a 00                	push   $0x0
  102905:	68 d3 00 00 00       	push   $0xd3
  10290a:	e9 10 02 00 00       	jmp    102b1f <__alltraps>

0010290f <vector212>:
  10290f:	6a 00                	push   $0x0
  102911:	68 d4 00 00 00       	push   $0xd4
  102916:	e9 04 02 00 00       	jmp    102b1f <__alltraps>

0010291b <vector213>:
  10291b:	6a 00                	push   $0x0
  10291d:	68 d5 00 00 00       	push   $0xd5
  102922:	e9 f8 01 00 00       	jmp    102b1f <__alltraps>

00102927 <vector214>:
  102927:	6a 00                	push   $0x0
  102929:	68 d6 00 00 00       	push   $0xd6
  10292e:	e9 ec 01 00 00       	jmp    102b1f <__alltraps>

00102933 <vector215>:
  102933:	6a 00                	push   $0x0
  102935:	68 d7 00 00 00       	push   $0xd7
  10293a:	e9 e0 01 00 00       	jmp    102b1f <__alltraps>

0010293f <vector216>:
  10293f:	6a 00                	push   $0x0
  102941:	68 d8 00 00 00       	push   $0xd8
  102946:	e9 d4 01 00 00       	jmp    102b1f <__alltraps>

0010294b <vector217>:
  10294b:	6a 00                	push   $0x0
  10294d:	68 d9 00 00 00       	push   $0xd9
  102952:	e9 c8 01 00 00       	jmp    102b1f <__alltraps>

00102957 <vector218>:
  102957:	6a 00                	push   $0x0
  102959:	68 da 00 00 00       	push   $0xda
  10295e:	e9 bc 01 00 00       	jmp    102b1f <__alltraps>

00102963 <vector219>:
  102963:	6a 00                	push   $0x0
  102965:	68 db 00 00 00       	push   $0xdb
  10296a:	e9 b0 01 00 00       	jmp    102b1f <__alltraps>

0010296f <vector220>:
  10296f:	6a 00                	push   $0x0
  102971:	68 dc 00 00 00       	push   $0xdc
  102976:	e9 a4 01 00 00       	jmp    102b1f <__alltraps>

0010297b <vector221>:
  10297b:	6a 00                	push   $0x0
  10297d:	68 dd 00 00 00       	push   $0xdd
  102982:	e9 98 01 00 00       	jmp    102b1f <__alltraps>

00102987 <vector222>:
  102987:	6a 00                	push   $0x0
  102989:	68 de 00 00 00       	push   $0xde
  10298e:	e9 8c 01 00 00       	jmp    102b1f <__alltraps>

00102993 <vector223>:
  102993:	6a 00                	push   $0x0
  102995:	68 df 00 00 00       	push   $0xdf
  10299a:	e9 80 01 00 00       	jmp    102b1f <__alltraps>

0010299f <vector224>:
  10299f:	6a 00                	push   $0x0
  1029a1:	68 e0 00 00 00       	push   $0xe0
  1029a6:	e9 74 01 00 00       	jmp    102b1f <__alltraps>

001029ab <vector225>:
  1029ab:	6a 00                	push   $0x0
  1029ad:	68 e1 00 00 00       	push   $0xe1
  1029b2:	e9 68 01 00 00       	jmp    102b1f <__alltraps>

001029b7 <vector226>:
  1029b7:	6a 00                	push   $0x0
  1029b9:	68 e2 00 00 00       	push   $0xe2
  1029be:	e9 5c 01 00 00       	jmp    102b1f <__alltraps>

001029c3 <vector227>:
  1029c3:	6a 00                	push   $0x0
  1029c5:	68 e3 00 00 00       	push   $0xe3
  1029ca:	e9 50 01 00 00       	jmp    102b1f <__alltraps>

001029cf <vector228>:
  1029cf:	6a 00                	push   $0x0
  1029d1:	68 e4 00 00 00       	push   $0xe4
  1029d6:	e9 44 01 00 00       	jmp    102b1f <__alltraps>

001029db <vector229>:
  1029db:	6a 00                	push   $0x0
  1029dd:	68 e5 00 00 00       	push   $0xe5
  1029e2:	e9 38 01 00 00       	jmp    102b1f <__alltraps>

001029e7 <vector230>:
  1029e7:	6a 00                	push   $0x0
  1029e9:	68 e6 00 00 00       	push   $0xe6
  1029ee:	e9 2c 01 00 00       	jmp    102b1f <__alltraps>

001029f3 <vector231>:
  1029f3:	6a 00                	push   $0x0
  1029f5:	68 e7 00 00 00       	push   $0xe7
  1029fa:	e9 20 01 00 00       	jmp    102b1f <__alltraps>

001029ff <vector232>:
  1029ff:	6a 00                	push   $0x0
  102a01:	68 e8 00 00 00       	push   $0xe8
  102a06:	e9 14 01 00 00       	jmp    102b1f <__alltraps>

00102a0b <vector233>:
  102a0b:	6a 00                	push   $0x0
  102a0d:	68 e9 00 00 00       	push   $0xe9
  102a12:	e9 08 01 00 00       	jmp    102b1f <__alltraps>

00102a17 <vector234>:
  102a17:	6a 00                	push   $0x0
  102a19:	68 ea 00 00 00       	push   $0xea
  102a1e:	e9 fc 00 00 00       	jmp    102b1f <__alltraps>

00102a23 <vector235>:
  102a23:	6a 00                	push   $0x0
  102a25:	68 eb 00 00 00       	push   $0xeb
  102a2a:	e9 f0 00 00 00       	jmp    102b1f <__alltraps>

00102a2f <vector236>:
  102a2f:	6a 00                	push   $0x0
  102a31:	68 ec 00 00 00       	push   $0xec
  102a36:	e9 e4 00 00 00       	jmp    102b1f <__alltraps>

00102a3b <vector237>:
  102a3b:	6a 00                	push   $0x0
  102a3d:	68 ed 00 00 00       	push   $0xed
  102a42:	e9 d8 00 00 00       	jmp    102b1f <__alltraps>

00102a47 <vector238>:
  102a47:	6a 00                	push   $0x0
  102a49:	68 ee 00 00 00       	push   $0xee
  102a4e:	e9 cc 00 00 00       	jmp    102b1f <__alltraps>

00102a53 <vector239>:
  102a53:	6a 00                	push   $0x0
  102a55:	68 ef 00 00 00       	push   $0xef
  102a5a:	e9 c0 00 00 00       	jmp    102b1f <__alltraps>

00102a5f <vector240>:
  102a5f:	6a 00                	push   $0x0
  102a61:	68 f0 00 00 00       	push   $0xf0
  102a66:	e9 b4 00 00 00       	jmp    102b1f <__alltraps>

00102a6b <vector241>:
  102a6b:	6a 00                	push   $0x0
  102a6d:	68 f1 00 00 00       	push   $0xf1
  102a72:	e9 a8 00 00 00       	jmp    102b1f <__alltraps>

00102a77 <vector242>:
  102a77:	6a 00                	push   $0x0
  102a79:	68 f2 00 00 00       	push   $0xf2
  102a7e:	e9 9c 00 00 00       	jmp    102b1f <__alltraps>

00102a83 <vector243>:
  102a83:	6a 00                	push   $0x0
  102a85:	68 f3 00 00 00       	push   $0xf3
  102a8a:	e9 90 00 00 00       	jmp    102b1f <__alltraps>

00102a8f <vector244>:
  102a8f:	6a 00                	push   $0x0
  102a91:	68 f4 00 00 00       	push   $0xf4
  102a96:	e9 84 00 00 00       	jmp    102b1f <__alltraps>

00102a9b <vector245>:
  102a9b:	6a 00                	push   $0x0
  102a9d:	68 f5 00 00 00       	push   $0xf5
  102aa2:	e9 78 00 00 00       	jmp    102b1f <__alltraps>

00102aa7 <vector246>:
  102aa7:	6a 00                	push   $0x0
  102aa9:	68 f6 00 00 00       	push   $0xf6
  102aae:	e9 6c 00 00 00       	jmp    102b1f <__alltraps>

00102ab3 <vector247>:
  102ab3:	6a 00                	push   $0x0
  102ab5:	68 f7 00 00 00       	push   $0xf7
  102aba:	e9 60 00 00 00       	jmp    102b1f <__alltraps>

00102abf <vector248>:
  102abf:	6a 00                	push   $0x0
  102ac1:	68 f8 00 00 00       	push   $0xf8
  102ac6:	e9 54 00 00 00       	jmp    102b1f <__alltraps>

00102acb <vector249>:
  102acb:	6a 00                	push   $0x0
  102acd:	68 f9 00 00 00       	push   $0xf9
  102ad2:	e9 48 00 00 00       	jmp    102b1f <__alltraps>

00102ad7 <vector250>:
  102ad7:	6a 00                	push   $0x0
  102ad9:	68 fa 00 00 00       	push   $0xfa
  102ade:	e9 3c 00 00 00       	jmp    102b1f <__alltraps>

00102ae3 <vector251>:
  102ae3:	6a 00                	push   $0x0
  102ae5:	68 fb 00 00 00       	push   $0xfb
  102aea:	e9 30 00 00 00       	jmp    102b1f <__alltraps>

00102aef <vector252>:
  102aef:	6a 00                	push   $0x0
  102af1:	68 fc 00 00 00       	push   $0xfc
  102af6:	e9 24 00 00 00       	jmp    102b1f <__alltraps>

00102afb <vector253>:
  102afb:	6a 00                	push   $0x0
  102afd:	68 fd 00 00 00       	push   $0xfd
  102b02:	e9 18 00 00 00       	jmp    102b1f <__alltraps>

00102b07 <vector254>:
  102b07:	6a 00                	push   $0x0
  102b09:	68 fe 00 00 00       	push   $0xfe
  102b0e:	e9 0c 00 00 00       	jmp    102b1f <__alltraps>

00102b13 <vector255>:
  102b13:	6a 00                	push   $0x0
  102b15:	68 ff 00 00 00       	push   $0xff
  102b1a:	e9 00 00 00 00       	jmp    102b1f <__alltraps>

00102b1f <__alltraps>:
  102b1f:	1e                   	push   %ds
  102b20:	06                   	push   %es
  102b21:	0f a0                	push   %fs
  102b23:	0f a8                	push   %gs
  102b25:	60                   	pusha  
  102b26:	b8 10 00 00 00       	mov    $0x10,%eax
  102b2b:	8e d8                	mov    %eax,%ds
  102b2d:	8e c0                	mov    %eax,%es
  102b2f:	54                   	push   %esp
  102b30:	e8 61 f5 ff ff       	call   102096 <trap>
  102b35:	5c                   	pop    %esp

00102b36 <__trapret>:
  102b36:	61                   	popa   
  102b37:	0f a9                	pop    %gs
  102b39:	0f a1                	pop    %fs
  102b3b:	07                   	pop    %es
  102b3c:	1f                   	pop    %ds
  102b3d:	83 c4 08             	add    $0x8,%esp
  102b40:	cf                   	iret   

00102b41 <lgdt>:
  102b41:	55                   	push   %ebp
  102b42:	89 e5                	mov    %esp,%ebp
  102b44:	8b 45 08             	mov    0x8(%ebp),%eax
  102b47:	0f 01 10             	lgdtl  (%eax)
  102b4a:	b8 23 00 00 00       	mov    $0x23,%eax
  102b4f:	8e e8                	mov    %eax,%gs
  102b51:	b8 23 00 00 00       	mov    $0x23,%eax
  102b56:	8e e0                	mov    %eax,%fs
  102b58:	b8 10 00 00 00       	mov    $0x10,%eax
  102b5d:	8e c0                	mov    %eax,%es
  102b5f:	b8 10 00 00 00       	mov    $0x10,%eax
  102b64:	8e d8                	mov    %eax,%ds
  102b66:	b8 10 00 00 00       	mov    $0x10,%eax
  102b6b:	8e d0                	mov    %eax,%ss
  102b6d:	ea 74 2b 10 00 08 00 	ljmp   $0x8,$0x102b74
  102b74:	90                   	nop
  102b75:	5d                   	pop    %ebp
  102b76:	c3                   	ret    

00102b77 <gdt_init>:
  102b77:	55                   	push   %ebp
  102b78:	89 e5                	mov    %esp,%ebp
  102b7a:	83 ec 10             	sub    $0x10,%esp
  102b7d:	b8 20 09 11 00       	mov    $0x110920,%eax
  102b82:	05 00 04 00 00       	add    $0x400,%eax
  102b87:	a3 a4 08 11 00       	mov    %eax,0x1108a4
  102b8c:	66 c7 05 a8 08 11 00 	movw   $0x10,0x1108a8
  102b93:	10 00 
  102b95:	66 c7 05 08 fa 10 00 	movw   $0x68,0x10fa08
  102b9c:	68 00 
  102b9e:	b8 a0 08 11 00       	mov    $0x1108a0,%eax
  102ba3:	66 a3 0a fa 10 00    	mov    %ax,0x10fa0a
  102ba9:	b8 a0 08 11 00       	mov    $0x1108a0,%eax
  102bae:	c1 e8 10             	shr    $0x10,%eax
  102bb1:	a2 0c fa 10 00       	mov    %al,0x10fa0c
  102bb6:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  102bbd:	83 e0 f0             	and    $0xfffffff0,%eax
  102bc0:	83 c8 09             	or     $0x9,%eax
  102bc3:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  102bc8:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  102bcf:	83 c8 10             	or     $0x10,%eax
  102bd2:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  102bd7:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  102bde:	83 e0 9f             	and    $0xffffff9f,%eax
  102be1:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  102be6:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  102bed:	83 c8 80             	or     $0xffffff80,%eax
  102bf0:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  102bf5:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  102bfc:	83 e0 f0             	and    $0xfffffff0,%eax
  102bff:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102c04:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  102c0b:	83 e0 ef             	and    $0xffffffef,%eax
  102c0e:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102c13:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  102c1a:	83 e0 df             	and    $0xffffffdf,%eax
  102c1d:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102c22:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  102c29:	83 c8 40             	or     $0x40,%eax
  102c2c:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102c31:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  102c38:	83 e0 7f             	and    $0x7f,%eax
  102c3b:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102c40:	b8 a0 08 11 00       	mov    $0x1108a0,%eax
  102c45:	c1 e8 18             	shr    $0x18,%eax
  102c48:	a2 0f fa 10 00       	mov    %al,0x10fa0f
  102c4d:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  102c54:	83 e0 ef             	and    $0xffffffef,%eax
  102c57:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  102c5c:	68 10 fa 10 00       	push   $0x10fa10
  102c61:	e8 db fe ff ff       	call   102b41 <lgdt>
  102c66:	83 c4 04             	add    $0x4,%esp
  102c69:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
  102c6f:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102c73:	0f 00 d8             	ltr    %ax
  102c76:	90                   	nop
  102c77:	c9                   	leave  
  102c78:	c3                   	ret    

00102c79 <pmm_init>:
  102c79:	55                   	push   %ebp
  102c7a:	89 e5                	mov    %esp,%ebp
  102c7c:	e8 f6 fe ff ff       	call   102b77 <gdt_init>
  102c81:	90                   	nop
  102c82:	5d                   	pop    %ebp
  102c83:	c3                   	ret    

00102c84 <strlen>:
  102c84:	55                   	push   %ebp
  102c85:	89 e5                	mov    %esp,%ebp
  102c87:	83 ec 10             	sub    $0x10,%esp
  102c8a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  102c91:	eb 04                	jmp    102c97 <strlen+0x13>
  102c93:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  102c97:	8b 45 08             	mov    0x8(%ebp),%eax
  102c9a:	8d 50 01             	lea    0x1(%eax),%edx
  102c9d:	89 55 08             	mov    %edx,0x8(%ebp)
  102ca0:	0f b6 00             	movzbl (%eax),%eax
  102ca3:	84 c0                	test   %al,%al
  102ca5:	75 ec                	jne    102c93 <strlen+0xf>
  102ca7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102caa:	c9                   	leave  
  102cab:	c3                   	ret    

00102cac <strnlen>:
  102cac:	55                   	push   %ebp
  102cad:	89 e5                	mov    %esp,%ebp
  102caf:	83 ec 10             	sub    $0x10,%esp
  102cb2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  102cb9:	eb 04                	jmp    102cbf <strnlen+0x13>
  102cbb:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  102cbf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102cc2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  102cc5:	73 10                	jae    102cd7 <strnlen+0x2b>
  102cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  102cca:	8d 50 01             	lea    0x1(%eax),%edx
  102ccd:	89 55 08             	mov    %edx,0x8(%ebp)
  102cd0:	0f b6 00             	movzbl (%eax),%eax
  102cd3:	84 c0                	test   %al,%al
  102cd5:	75 e4                	jne    102cbb <strnlen+0xf>
  102cd7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102cda:	c9                   	leave  
  102cdb:	c3                   	ret    

00102cdc <strcpy>:
  102cdc:	55                   	push   %ebp
  102cdd:	89 e5                	mov    %esp,%ebp
  102cdf:	57                   	push   %edi
  102ce0:	56                   	push   %esi
  102ce1:	83 ec 20             	sub    $0x20,%esp
  102ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  102ce7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102cea:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ced:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102cf0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102cf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102cf6:	89 d1                	mov    %edx,%ecx
  102cf8:	89 c2                	mov    %eax,%edx
  102cfa:	89 ce                	mov    %ecx,%esi
  102cfc:	89 d7                	mov    %edx,%edi
  102cfe:	ac                   	lods   %ds:(%esi),%al
  102cff:	aa                   	stos   %al,%es:(%edi)
  102d00:	84 c0                	test   %al,%al
  102d02:	75 fa                	jne    102cfe <strcpy+0x22>
  102d04:	89 fa                	mov    %edi,%edx
  102d06:	89 f1                	mov    %esi,%ecx
  102d08:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102d0b:	89 55 e8             	mov    %edx,-0x18(%ebp)
  102d0e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102d11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d14:	90                   	nop
  102d15:	83 c4 20             	add    $0x20,%esp
  102d18:	5e                   	pop    %esi
  102d19:	5f                   	pop    %edi
  102d1a:	5d                   	pop    %ebp
  102d1b:	c3                   	ret    

00102d1c <strncpy>:
  102d1c:	55                   	push   %ebp
  102d1d:	89 e5                	mov    %esp,%ebp
  102d1f:	83 ec 10             	sub    $0x10,%esp
  102d22:	8b 45 08             	mov    0x8(%ebp),%eax
  102d25:	89 45 fc             	mov    %eax,-0x4(%ebp)
  102d28:	eb 21                	jmp    102d4b <strncpy+0x2f>
  102d2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d2d:	0f b6 10             	movzbl (%eax),%edx
  102d30:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102d33:	88 10                	mov    %dl,(%eax)
  102d35:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102d38:	0f b6 00             	movzbl (%eax),%eax
  102d3b:	84 c0                	test   %al,%al
  102d3d:	74 04                	je     102d43 <strncpy+0x27>
  102d3f:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  102d43:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  102d47:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102d4b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102d4f:	75 d9                	jne    102d2a <strncpy+0xe>
  102d51:	8b 45 08             	mov    0x8(%ebp),%eax
  102d54:	c9                   	leave  
  102d55:	c3                   	ret    

00102d56 <strcmp>:
  102d56:	55                   	push   %ebp
  102d57:	89 e5                	mov    %esp,%ebp
  102d59:	57                   	push   %edi
  102d5a:	56                   	push   %esi
  102d5b:	83 ec 20             	sub    $0x20,%esp
  102d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  102d61:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102d64:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d67:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102d6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102d6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d70:	89 d1                	mov    %edx,%ecx
  102d72:	89 c2                	mov    %eax,%edx
  102d74:	89 ce                	mov    %ecx,%esi
  102d76:	89 d7                	mov    %edx,%edi
  102d78:	ac                   	lods   %ds:(%esi),%al
  102d79:	ae                   	scas   %es:(%edi),%al
  102d7a:	75 08                	jne    102d84 <strcmp+0x2e>
  102d7c:	84 c0                	test   %al,%al
  102d7e:	75 f8                	jne    102d78 <strcmp+0x22>
  102d80:	31 c0                	xor    %eax,%eax
  102d82:	eb 04                	jmp    102d88 <strcmp+0x32>
  102d84:	19 c0                	sbb    %eax,%eax
  102d86:	0c 01                	or     $0x1,%al
  102d88:	89 fa                	mov    %edi,%edx
  102d8a:	89 f1                	mov    %esi,%ecx
  102d8c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102d8f:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102d92:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  102d95:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102d98:	90                   	nop
  102d99:	83 c4 20             	add    $0x20,%esp
  102d9c:	5e                   	pop    %esi
  102d9d:	5f                   	pop    %edi
  102d9e:	5d                   	pop    %ebp
  102d9f:	c3                   	ret    

00102da0 <strncmp>:
  102da0:	55                   	push   %ebp
  102da1:	89 e5                	mov    %esp,%ebp
  102da3:	eb 0c                	jmp    102db1 <strncmp+0x11>
  102da5:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102da9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102dad:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  102db1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102db5:	74 1a                	je     102dd1 <strncmp+0x31>
  102db7:	8b 45 08             	mov    0x8(%ebp),%eax
  102dba:	0f b6 00             	movzbl (%eax),%eax
  102dbd:	84 c0                	test   %al,%al
  102dbf:	74 10                	je     102dd1 <strncmp+0x31>
  102dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  102dc4:	0f b6 10             	movzbl (%eax),%edx
  102dc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  102dca:	0f b6 00             	movzbl (%eax),%eax
  102dcd:	38 c2                	cmp    %al,%dl
  102dcf:	74 d4                	je     102da5 <strncmp+0x5>
  102dd1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102dd5:	74 18                	je     102def <strncmp+0x4f>
  102dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  102dda:	0f b6 00             	movzbl (%eax),%eax
  102ddd:	0f b6 d0             	movzbl %al,%edx
  102de0:	8b 45 0c             	mov    0xc(%ebp),%eax
  102de3:	0f b6 00             	movzbl (%eax),%eax
  102de6:	0f b6 c0             	movzbl %al,%eax
  102de9:	29 c2                	sub    %eax,%edx
  102deb:	89 d0                	mov    %edx,%eax
  102ded:	eb 05                	jmp    102df4 <strncmp+0x54>
  102def:	b8 00 00 00 00       	mov    $0x0,%eax
  102df4:	5d                   	pop    %ebp
  102df5:	c3                   	ret    

00102df6 <strchr>:
  102df6:	55                   	push   %ebp
  102df7:	89 e5                	mov    %esp,%ebp
  102df9:	83 ec 04             	sub    $0x4,%esp
  102dfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  102dff:	88 45 fc             	mov    %al,-0x4(%ebp)
  102e02:	eb 14                	jmp    102e18 <strchr+0x22>
  102e04:	8b 45 08             	mov    0x8(%ebp),%eax
  102e07:	0f b6 00             	movzbl (%eax),%eax
  102e0a:	38 45 fc             	cmp    %al,-0x4(%ebp)
  102e0d:	75 05                	jne    102e14 <strchr+0x1e>
  102e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  102e12:	eb 13                	jmp    102e27 <strchr+0x31>
  102e14:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102e18:	8b 45 08             	mov    0x8(%ebp),%eax
  102e1b:	0f b6 00             	movzbl (%eax),%eax
  102e1e:	84 c0                	test   %al,%al
  102e20:	75 e2                	jne    102e04 <strchr+0xe>
  102e22:	b8 00 00 00 00       	mov    $0x0,%eax
  102e27:	c9                   	leave  
  102e28:	c3                   	ret    

00102e29 <strfind>:
  102e29:	55                   	push   %ebp
  102e2a:	89 e5                	mov    %esp,%ebp
  102e2c:	83 ec 04             	sub    $0x4,%esp
  102e2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e32:	88 45 fc             	mov    %al,-0x4(%ebp)
  102e35:	eb 0f                	jmp    102e46 <strfind+0x1d>
  102e37:	8b 45 08             	mov    0x8(%ebp),%eax
  102e3a:	0f b6 00             	movzbl (%eax),%eax
  102e3d:	38 45 fc             	cmp    %al,-0x4(%ebp)
  102e40:	74 10                	je     102e52 <strfind+0x29>
  102e42:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102e46:	8b 45 08             	mov    0x8(%ebp),%eax
  102e49:	0f b6 00             	movzbl (%eax),%eax
  102e4c:	84 c0                	test   %al,%al
  102e4e:	75 e7                	jne    102e37 <strfind+0xe>
  102e50:	eb 01                	jmp    102e53 <strfind+0x2a>
  102e52:	90                   	nop
  102e53:	8b 45 08             	mov    0x8(%ebp),%eax
  102e56:	c9                   	leave  
  102e57:	c3                   	ret    

00102e58 <strtol>:
  102e58:	55                   	push   %ebp
  102e59:	89 e5                	mov    %esp,%ebp
  102e5b:	83 ec 10             	sub    $0x10,%esp
  102e5e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  102e65:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  102e6c:	eb 04                	jmp    102e72 <strtol+0x1a>
  102e6e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102e72:	8b 45 08             	mov    0x8(%ebp),%eax
  102e75:	0f b6 00             	movzbl (%eax),%eax
  102e78:	3c 20                	cmp    $0x20,%al
  102e7a:	74 f2                	je     102e6e <strtol+0x16>
  102e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  102e7f:	0f b6 00             	movzbl (%eax),%eax
  102e82:	3c 09                	cmp    $0x9,%al
  102e84:	74 e8                	je     102e6e <strtol+0x16>
  102e86:	8b 45 08             	mov    0x8(%ebp),%eax
  102e89:	0f b6 00             	movzbl (%eax),%eax
  102e8c:	3c 2b                	cmp    $0x2b,%al
  102e8e:	75 06                	jne    102e96 <strtol+0x3e>
  102e90:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102e94:	eb 15                	jmp    102eab <strtol+0x53>
  102e96:	8b 45 08             	mov    0x8(%ebp),%eax
  102e99:	0f b6 00             	movzbl (%eax),%eax
  102e9c:	3c 2d                	cmp    $0x2d,%al
  102e9e:	75 0b                	jne    102eab <strtol+0x53>
  102ea0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102ea4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
  102eab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102eaf:	74 06                	je     102eb7 <strtol+0x5f>
  102eb1:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  102eb5:	75 24                	jne    102edb <strtol+0x83>
  102eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  102eba:	0f b6 00             	movzbl (%eax),%eax
  102ebd:	3c 30                	cmp    $0x30,%al
  102ebf:	75 1a                	jne    102edb <strtol+0x83>
  102ec1:	8b 45 08             	mov    0x8(%ebp),%eax
  102ec4:	83 c0 01             	add    $0x1,%eax
  102ec7:	0f b6 00             	movzbl (%eax),%eax
  102eca:	3c 78                	cmp    $0x78,%al
  102ecc:	75 0d                	jne    102edb <strtol+0x83>
  102ece:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  102ed2:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  102ed9:	eb 2a                	jmp    102f05 <strtol+0xad>
  102edb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102edf:	75 17                	jne    102ef8 <strtol+0xa0>
  102ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  102ee4:	0f b6 00             	movzbl (%eax),%eax
  102ee7:	3c 30                	cmp    $0x30,%al
  102ee9:	75 0d                	jne    102ef8 <strtol+0xa0>
  102eeb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102eef:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  102ef6:	eb 0d                	jmp    102f05 <strtol+0xad>
  102ef8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102efc:	75 07                	jne    102f05 <strtol+0xad>
  102efe:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
  102f05:	8b 45 08             	mov    0x8(%ebp),%eax
  102f08:	0f b6 00             	movzbl (%eax),%eax
  102f0b:	3c 2f                	cmp    $0x2f,%al
  102f0d:	7e 1b                	jle    102f2a <strtol+0xd2>
  102f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  102f12:	0f b6 00             	movzbl (%eax),%eax
  102f15:	3c 39                	cmp    $0x39,%al
  102f17:	7f 11                	jg     102f2a <strtol+0xd2>
  102f19:	8b 45 08             	mov    0x8(%ebp),%eax
  102f1c:	0f b6 00             	movzbl (%eax),%eax
  102f1f:	0f be c0             	movsbl %al,%eax
  102f22:	83 e8 30             	sub    $0x30,%eax
  102f25:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102f28:	eb 48                	jmp    102f72 <strtol+0x11a>
  102f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  102f2d:	0f b6 00             	movzbl (%eax),%eax
  102f30:	3c 60                	cmp    $0x60,%al
  102f32:	7e 1b                	jle    102f4f <strtol+0xf7>
  102f34:	8b 45 08             	mov    0x8(%ebp),%eax
  102f37:	0f b6 00             	movzbl (%eax),%eax
  102f3a:	3c 7a                	cmp    $0x7a,%al
  102f3c:	7f 11                	jg     102f4f <strtol+0xf7>
  102f3e:	8b 45 08             	mov    0x8(%ebp),%eax
  102f41:	0f b6 00             	movzbl (%eax),%eax
  102f44:	0f be c0             	movsbl %al,%eax
  102f47:	83 e8 57             	sub    $0x57,%eax
  102f4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102f4d:	eb 23                	jmp    102f72 <strtol+0x11a>
  102f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  102f52:	0f b6 00             	movzbl (%eax),%eax
  102f55:	3c 40                	cmp    $0x40,%al
  102f57:	7e 3c                	jle    102f95 <strtol+0x13d>
  102f59:	8b 45 08             	mov    0x8(%ebp),%eax
  102f5c:	0f b6 00             	movzbl (%eax),%eax
  102f5f:	3c 5a                	cmp    $0x5a,%al
  102f61:	7f 32                	jg     102f95 <strtol+0x13d>
  102f63:	8b 45 08             	mov    0x8(%ebp),%eax
  102f66:	0f b6 00             	movzbl (%eax),%eax
  102f69:	0f be c0             	movsbl %al,%eax
  102f6c:	83 e8 37             	sub    $0x37,%eax
  102f6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102f72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f75:	3b 45 10             	cmp    0x10(%ebp),%eax
  102f78:	7d 1a                	jge    102f94 <strtol+0x13c>
  102f7a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102f7e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102f81:	0f af 45 10          	imul   0x10(%ebp),%eax
  102f85:	89 c2                	mov    %eax,%edx
  102f87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f8a:	01 d0                	add    %edx,%eax
  102f8c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  102f8f:	e9 71 ff ff ff       	jmp    102f05 <strtol+0xad>
  102f94:	90                   	nop
  102f95:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102f99:	74 08                	je     102fa3 <strtol+0x14b>
  102f9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f9e:	8b 55 08             	mov    0x8(%ebp),%edx
  102fa1:	89 10                	mov    %edx,(%eax)
  102fa3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  102fa7:	74 07                	je     102fb0 <strtol+0x158>
  102fa9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102fac:	f7 d8                	neg    %eax
  102fae:	eb 03                	jmp    102fb3 <strtol+0x15b>
  102fb0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102fb3:	c9                   	leave  
  102fb4:	c3                   	ret    

00102fb5 <memset>:
  102fb5:	55                   	push   %ebp
  102fb6:	89 e5                	mov    %esp,%ebp
  102fb8:	57                   	push   %edi
  102fb9:	83 ec 24             	sub    $0x24,%esp
  102fbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  102fbf:	88 45 d8             	mov    %al,-0x28(%ebp)
  102fc2:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  102fc6:	8b 55 08             	mov    0x8(%ebp),%edx
  102fc9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  102fcc:	88 45 f7             	mov    %al,-0x9(%ebp)
  102fcf:	8b 45 10             	mov    0x10(%ebp),%eax
  102fd2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102fd5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  102fd8:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  102fdc:	8b 55 f8             	mov    -0x8(%ebp),%edx
  102fdf:	89 d7                	mov    %edx,%edi
  102fe1:	f3 aa                	rep stos %al,%es:(%edi)
  102fe3:	89 fa                	mov    %edi,%edx
  102fe5:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102fe8:	89 55 e8             	mov    %edx,-0x18(%ebp)
  102feb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102fee:	90                   	nop
  102fef:	83 c4 24             	add    $0x24,%esp
  102ff2:	5f                   	pop    %edi
  102ff3:	5d                   	pop    %ebp
  102ff4:	c3                   	ret    

00102ff5 <memmove>:
  102ff5:	55                   	push   %ebp
  102ff6:	89 e5                	mov    %esp,%ebp
  102ff8:	57                   	push   %edi
  102ff9:	56                   	push   %esi
  102ffa:	53                   	push   %ebx
  102ffb:	83 ec 30             	sub    $0x30,%esp
  102ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  103001:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103004:	8b 45 0c             	mov    0xc(%ebp),%eax
  103007:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10300a:	8b 45 10             	mov    0x10(%ebp),%eax
  10300d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103010:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103013:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  103016:	73 42                	jae    10305a <memmove+0x65>
  103018:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10301b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10301e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103021:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103024:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103027:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10302a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10302d:	c1 e8 02             	shr    $0x2,%eax
  103030:	89 c1                	mov    %eax,%ecx
  103032:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103035:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103038:	89 d7                	mov    %edx,%edi
  10303a:	89 c6                	mov    %eax,%esi
  10303c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  10303e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  103041:	83 e1 03             	and    $0x3,%ecx
  103044:	74 02                	je     103048 <memmove+0x53>
  103046:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103048:	89 f0                	mov    %esi,%eax
  10304a:	89 fa                	mov    %edi,%edx
  10304c:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  10304f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  103052:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103055:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103058:	eb 36                	jmp    103090 <memmove+0x9b>
  10305a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10305d:	8d 50 ff             	lea    -0x1(%eax),%edx
  103060:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103063:	01 c2                	add    %eax,%edx
  103065:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103068:	8d 48 ff             	lea    -0x1(%eax),%ecx
  10306b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10306e:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
  103071:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103074:	89 c1                	mov    %eax,%ecx
  103076:	89 d8                	mov    %ebx,%eax
  103078:	89 d6                	mov    %edx,%esi
  10307a:	89 c7                	mov    %eax,%edi
  10307c:	fd                   	std    
  10307d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10307f:	fc                   	cld    
  103080:	89 f8                	mov    %edi,%eax
  103082:	89 f2                	mov    %esi,%edx
  103084:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  103087:	89 55 c8             	mov    %edx,-0x38(%ebp)
  10308a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  10308d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103090:	83 c4 30             	add    $0x30,%esp
  103093:	5b                   	pop    %ebx
  103094:	5e                   	pop    %esi
  103095:	5f                   	pop    %edi
  103096:	5d                   	pop    %ebp
  103097:	c3                   	ret    

00103098 <memcpy>:
  103098:	55                   	push   %ebp
  103099:	89 e5                	mov    %esp,%ebp
  10309b:	57                   	push   %edi
  10309c:	56                   	push   %esi
  10309d:	83 ec 20             	sub    $0x20,%esp
  1030a0:	8b 45 08             	mov    0x8(%ebp),%eax
  1030a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1030a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1030ac:	8b 45 10             	mov    0x10(%ebp),%eax
  1030af:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1030b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1030b5:	c1 e8 02             	shr    $0x2,%eax
  1030b8:	89 c1                	mov    %eax,%ecx
  1030ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1030bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030c0:	89 d7                	mov    %edx,%edi
  1030c2:	89 c6                	mov    %eax,%esi
  1030c4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1030c6:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  1030c9:	83 e1 03             	and    $0x3,%ecx
  1030cc:	74 02                	je     1030d0 <memcpy+0x38>
  1030ce:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1030d0:	89 f0                	mov    %esi,%eax
  1030d2:	89 fa                	mov    %edi,%edx
  1030d4:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1030d7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  1030da:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1030dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1030e0:	90                   	nop
  1030e1:	83 c4 20             	add    $0x20,%esp
  1030e4:	5e                   	pop    %esi
  1030e5:	5f                   	pop    %edi
  1030e6:	5d                   	pop    %ebp
  1030e7:	c3                   	ret    

001030e8 <memcmp>:
  1030e8:	55                   	push   %ebp
  1030e9:	89 e5                	mov    %esp,%ebp
  1030eb:	83 ec 10             	sub    $0x10,%esp
  1030ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1030f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1030f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030f7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1030fa:	eb 30                	jmp    10312c <memcmp+0x44>
  1030fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1030ff:	0f b6 10             	movzbl (%eax),%edx
  103102:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103105:	0f b6 00             	movzbl (%eax),%eax
  103108:	38 c2                	cmp    %al,%dl
  10310a:	74 18                	je     103124 <memcmp+0x3c>
  10310c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10310f:	0f b6 00             	movzbl (%eax),%eax
  103112:	0f b6 d0             	movzbl %al,%edx
  103115:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103118:	0f b6 00             	movzbl (%eax),%eax
  10311b:	0f b6 c0             	movzbl %al,%eax
  10311e:	29 c2                	sub    %eax,%edx
  103120:	89 d0                	mov    %edx,%eax
  103122:	eb 1a                	jmp    10313e <memcmp+0x56>
  103124:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  103128:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  10312c:	8b 45 10             	mov    0x10(%ebp),%eax
  10312f:	8d 50 ff             	lea    -0x1(%eax),%edx
  103132:	89 55 10             	mov    %edx,0x10(%ebp)
  103135:	85 c0                	test   %eax,%eax
  103137:	75 c3                	jne    1030fc <memcmp+0x14>
  103139:	b8 00 00 00 00       	mov    $0x0,%eax
  10313e:	c9                   	leave  
  10313f:	c3                   	ret    

00103140 <printnum>:
  103140:	55                   	push   %ebp
  103141:	89 e5                	mov    %esp,%ebp
  103143:	83 ec 38             	sub    $0x38,%esp
  103146:	8b 45 10             	mov    0x10(%ebp),%eax
  103149:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10314c:	8b 45 14             	mov    0x14(%ebp),%eax
  10314f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  103152:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103155:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103158:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10315b:	89 55 ec             	mov    %edx,-0x14(%ebp)
  10315e:	8b 45 18             	mov    0x18(%ebp),%eax
  103161:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103164:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103167:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10316a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10316d:	89 55 f0             	mov    %edx,-0x10(%ebp)
  103170:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103173:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103176:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10317a:	74 1c                	je     103198 <printnum+0x58>
  10317c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10317f:	ba 00 00 00 00       	mov    $0x0,%edx
  103184:	f7 75 e4             	divl   -0x1c(%ebp)
  103187:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10318a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10318d:	ba 00 00 00 00       	mov    $0x0,%edx
  103192:	f7 75 e4             	divl   -0x1c(%ebp)
  103195:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103198:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10319b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10319e:	f7 75 e4             	divl   -0x1c(%ebp)
  1031a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1031a4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  1031a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1031aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1031ad:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1031b0:	89 55 ec             	mov    %edx,-0x14(%ebp)
  1031b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1031b6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  1031b9:	8b 45 18             	mov    0x18(%ebp),%eax
  1031bc:	ba 00 00 00 00       	mov    $0x0,%edx
  1031c1:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  1031c4:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  1031c7:	19 d1                	sbb    %edx,%ecx
  1031c9:	72 37                	jb     103202 <printnum+0xc2>
  1031cb:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1031ce:	83 e8 01             	sub    $0x1,%eax
  1031d1:	83 ec 04             	sub    $0x4,%esp
  1031d4:	ff 75 20             	pushl  0x20(%ebp)
  1031d7:	50                   	push   %eax
  1031d8:	ff 75 18             	pushl  0x18(%ebp)
  1031db:	ff 75 ec             	pushl  -0x14(%ebp)
  1031de:	ff 75 e8             	pushl  -0x18(%ebp)
  1031e1:	ff 75 0c             	pushl  0xc(%ebp)
  1031e4:	ff 75 08             	pushl  0x8(%ebp)
  1031e7:	e8 54 ff ff ff       	call   103140 <printnum>
  1031ec:	83 c4 20             	add    $0x20,%esp
  1031ef:	eb 1b                	jmp    10320c <printnum+0xcc>
  1031f1:	83 ec 08             	sub    $0x8,%esp
  1031f4:	ff 75 0c             	pushl  0xc(%ebp)
  1031f7:	ff 75 20             	pushl  0x20(%ebp)
  1031fa:	8b 45 08             	mov    0x8(%ebp),%eax
  1031fd:	ff d0                	call   *%eax
  1031ff:	83 c4 10             	add    $0x10,%esp
  103202:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  103206:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  10320a:	7f e5                	jg     1031f1 <printnum+0xb1>
  10320c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10320f:	05 10 3f 10 00       	add    $0x103f10,%eax
  103214:	0f b6 00             	movzbl (%eax),%eax
  103217:	0f be c0             	movsbl %al,%eax
  10321a:	83 ec 08             	sub    $0x8,%esp
  10321d:	ff 75 0c             	pushl  0xc(%ebp)
  103220:	50                   	push   %eax
  103221:	8b 45 08             	mov    0x8(%ebp),%eax
  103224:	ff d0                	call   *%eax
  103226:	83 c4 10             	add    $0x10,%esp
  103229:	90                   	nop
  10322a:	c9                   	leave  
  10322b:	c3                   	ret    

0010322c <getuint>:
  10322c:	55                   	push   %ebp
  10322d:	89 e5                	mov    %esp,%ebp
  10322f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  103233:	7e 14                	jle    103249 <getuint+0x1d>
  103235:	8b 45 08             	mov    0x8(%ebp),%eax
  103238:	8b 00                	mov    (%eax),%eax
  10323a:	8d 48 08             	lea    0x8(%eax),%ecx
  10323d:	8b 55 08             	mov    0x8(%ebp),%edx
  103240:	89 0a                	mov    %ecx,(%edx)
  103242:	8b 50 04             	mov    0x4(%eax),%edx
  103245:	8b 00                	mov    (%eax),%eax
  103247:	eb 30                	jmp    103279 <getuint+0x4d>
  103249:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10324d:	74 16                	je     103265 <getuint+0x39>
  10324f:	8b 45 08             	mov    0x8(%ebp),%eax
  103252:	8b 00                	mov    (%eax),%eax
  103254:	8d 48 04             	lea    0x4(%eax),%ecx
  103257:	8b 55 08             	mov    0x8(%ebp),%edx
  10325a:	89 0a                	mov    %ecx,(%edx)
  10325c:	8b 00                	mov    (%eax),%eax
  10325e:	ba 00 00 00 00       	mov    $0x0,%edx
  103263:	eb 14                	jmp    103279 <getuint+0x4d>
  103265:	8b 45 08             	mov    0x8(%ebp),%eax
  103268:	8b 00                	mov    (%eax),%eax
  10326a:	8d 48 04             	lea    0x4(%eax),%ecx
  10326d:	8b 55 08             	mov    0x8(%ebp),%edx
  103270:	89 0a                	mov    %ecx,(%edx)
  103272:	8b 00                	mov    (%eax),%eax
  103274:	ba 00 00 00 00       	mov    $0x0,%edx
  103279:	5d                   	pop    %ebp
  10327a:	c3                   	ret    

0010327b <getint>:
  10327b:	55                   	push   %ebp
  10327c:	89 e5                	mov    %esp,%ebp
  10327e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  103282:	7e 14                	jle    103298 <getint+0x1d>
  103284:	8b 45 08             	mov    0x8(%ebp),%eax
  103287:	8b 00                	mov    (%eax),%eax
  103289:	8d 48 08             	lea    0x8(%eax),%ecx
  10328c:	8b 55 08             	mov    0x8(%ebp),%edx
  10328f:	89 0a                	mov    %ecx,(%edx)
  103291:	8b 50 04             	mov    0x4(%eax),%edx
  103294:	8b 00                	mov    (%eax),%eax
  103296:	eb 28                	jmp    1032c0 <getint+0x45>
  103298:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10329c:	74 12                	je     1032b0 <getint+0x35>
  10329e:	8b 45 08             	mov    0x8(%ebp),%eax
  1032a1:	8b 00                	mov    (%eax),%eax
  1032a3:	8d 48 04             	lea    0x4(%eax),%ecx
  1032a6:	8b 55 08             	mov    0x8(%ebp),%edx
  1032a9:	89 0a                	mov    %ecx,(%edx)
  1032ab:	8b 00                	mov    (%eax),%eax
  1032ad:	99                   	cltd   
  1032ae:	eb 10                	jmp    1032c0 <getint+0x45>
  1032b0:	8b 45 08             	mov    0x8(%ebp),%eax
  1032b3:	8b 00                	mov    (%eax),%eax
  1032b5:	8d 48 04             	lea    0x4(%eax),%ecx
  1032b8:	8b 55 08             	mov    0x8(%ebp),%edx
  1032bb:	89 0a                	mov    %ecx,(%edx)
  1032bd:	8b 00                	mov    (%eax),%eax
  1032bf:	99                   	cltd   
  1032c0:	5d                   	pop    %ebp
  1032c1:	c3                   	ret    

001032c2 <printfmt>:
  1032c2:	55                   	push   %ebp
  1032c3:	89 e5                	mov    %esp,%ebp
  1032c5:	83 ec 18             	sub    $0x18,%esp
  1032c8:	8d 45 14             	lea    0x14(%ebp),%eax
  1032cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1032ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1032d1:	50                   	push   %eax
  1032d2:	ff 75 10             	pushl  0x10(%ebp)
  1032d5:	ff 75 0c             	pushl  0xc(%ebp)
  1032d8:	ff 75 08             	pushl  0x8(%ebp)
  1032db:	e8 06 00 00 00       	call   1032e6 <vprintfmt>
  1032e0:	83 c4 10             	add    $0x10,%esp
  1032e3:	90                   	nop
  1032e4:	c9                   	leave  
  1032e5:	c3                   	ret    

001032e6 <vprintfmt>:
  1032e6:	55                   	push   %ebp
  1032e7:	89 e5                	mov    %esp,%ebp
  1032e9:	56                   	push   %esi
  1032ea:	53                   	push   %ebx
  1032eb:	83 ec 20             	sub    $0x20,%esp
  1032ee:	eb 17                	jmp    103307 <vprintfmt+0x21>
  1032f0:	85 db                	test   %ebx,%ebx
  1032f2:	0f 84 8e 03 00 00    	je     103686 <vprintfmt+0x3a0>
  1032f8:	83 ec 08             	sub    $0x8,%esp
  1032fb:	ff 75 0c             	pushl  0xc(%ebp)
  1032fe:	53                   	push   %ebx
  1032ff:	8b 45 08             	mov    0x8(%ebp),%eax
  103302:	ff d0                	call   *%eax
  103304:	83 c4 10             	add    $0x10,%esp
  103307:	8b 45 10             	mov    0x10(%ebp),%eax
  10330a:	8d 50 01             	lea    0x1(%eax),%edx
  10330d:	89 55 10             	mov    %edx,0x10(%ebp)
  103310:	0f b6 00             	movzbl (%eax),%eax
  103313:	0f b6 d8             	movzbl %al,%ebx
  103316:	83 fb 25             	cmp    $0x25,%ebx
  103319:	75 d5                	jne    1032f0 <vprintfmt+0xa>
  10331b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
  10331f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  103326:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103329:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10332c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103333:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103336:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103339:	8b 45 10             	mov    0x10(%ebp),%eax
  10333c:	8d 50 01             	lea    0x1(%eax),%edx
  10333f:	89 55 10             	mov    %edx,0x10(%ebp)
  103342:	0f b6 00             	movzbl (%eax),%eax
  103345:	0f b6 d8             	movzbl %al,%ebx
  103348:	8d 43 dd             	lea    -0x23(%ebx),%eax
  10334b:	83 f8 55             	cmp    $0x55,%eax
  10334e:	0f 87 05 03 00 00    	ja     103659 <vprintfmt+0x373>
  103354:	8b 04 85 34 3f 10 00 	mov    0x103f34(,%eax,4),%eax
  10335b:	ff e0                	jmp    *%eax
  10335d:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
  103361:	eb d6                	jmp    103339 <vprintfmt+0x53>
  103363:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
  103367:	eb d0                	jmp    103339 <vprintfmt+0x53>
  103369:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  103370:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103373:	89 d0                	mov    %edx,%eax
  103375:	c1 e0 02             	shl    $0x2,%eax
  103378:	01 d0                	add    %edx,%eax
  10337a:	01 c0                	add    %eax,%eax
  10337c:	01 d8                	add    %ebx,%eax
  10337e:	83 e8 30             	sub    $0x30,%eax
  103381:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103384:	8b 45 10             	mov    0x10(%ebp),%eax
  103387:	0f b6 00             	movzbl (%eax),%eax
  10338a:	0f be d8             	movsbl %al,%ebx
  10338d:	83 fb 2f             	cmp    $0x2f,%ebx
  103390:	7e 39                	jle    1033cb <vprintfmt+0xe5>
  103392:	83 fb 39             	cmp    $0x39,%ebx
  103395:	7f 34                	jg     1033cb <vprintfmt+0xe5>
  103397:	83 45 10 01          	addl   $0x1,0x10(%ebp)
  10339b:	eb d3                	jmp    103370 <vprintfmt+0x8a>
  10339d:	8b 45 14             	mov    0x14(%ebp),%eax
  1033a0:	8d 50 04             	lea    0x4(%eax),%edx
  1033a3:	89 55 14             	mov    %edx,0x14(%ebp)
  1033a6:	8b 00                	mov    (%eax),%eax
  1033a8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1033ab:	eb 1f                	jmp    1033cc <vprintfmt+0xe6>
  1033ad:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1033b1:	79 86                	jns    103339 <vprintfmt+0x53>
  1033b3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  1033ba:	e9 7a ff ff ff       	jmp    103339 <vprintfmt+0x53>
  1033bf:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
  1033c6:	e9 6e ff ff ff       	jmp    103339 <vprintfmt+0x53>
  1033cb:	90                   	nop
  1033cc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1033d0:	0f 89 63 ff ff ff    	jns    103339 <vprintfmt+0x53>
  1033d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1033d9:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1033dc:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  1033e3:	e9 51 ff ff ff       	jmp    103339 <vprintfmt+0x53>
  1033e8:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
  1033ec:	e9 48 ff ff ff       	jmp    103339 <vprintfmt+0x53>
  1033f1:	8b 45 14             	mov    0x14(%ebp),%eax
  1033f4:	8d 50 04             	lea    0x4(%eax),%edx
  1033f7:	89 55 14             	mov    %edx,0x14(%ebp)
  1033fa:	8b 00                	mov    (%eax),%eax
  1033fc:	83 ec 08             	sub    $0x8,%esp
  1033ff:	ff 75 0c             	pushl  0xc(%ebp)
  103402:	50                   	push   %eax
  103403:	8b 45 08             	mov    0x8(%ebp),%eax
  103406:	ff d0                	call   *%eax
  103408:	83 c4 10             	add    $0x10,%esp
  10340b:	e9 71 02 00 00       	jmp    103681 <vprintfmt+0x39b>
  103410:	8b 45 14             	mov    0x14(%ebp),%eax
  103413:	8d 50 04             	lea    0x4(%eax),%edx
  103416:	89 55 14             	mov    %edx,0x14(%ebp)
  103419:	8b 18                	mov    (%eax),%ebx
  10341b:	85 db                	test   %ebx,%ebx
  10341d:	79 02                	jns    103421 <vprintfmt+0x13b>
  10341f:	f7 db                	neg    %ebx
  103421:	83 fb 06             	cmp    $0x6,%ebx
  103424:	7f 0b                	jg     103431 <vprintfmt+0x14b>
  103426:	8b 34 9d f4 3e 10 00 	mov    0x103ef4(,%ebx,4),%esi
  10342d:	85 f6                	test   %esi,%esi
  10342f:	75 19                	jne    10344a <vprintfmt+0x164>
  103431:	53                   	push   %ebx
  103432:	68 21 3f 10 00       	push   $0x103f21
  103437:	ff 75 0c             	pushl  0xc(%ebp)
  10343a:	ff 75 08             	pushl  0x8(%ebp)
  10343d:	e8 80 fe ff ff       	call   1032c2 <printfmt>
  103442:	83 c4 10             	add    $0x10,%esp
  103445:	e9 37 02 00 00       	jmp    103681 <vprintfmt+0x39b>
  10344a:	56                   	push   %esi
  10344b:	68 2a 3f 10 00       	push   $0x103f2a
  103450:	ff 75 0c             	pushl  0xc(%ebp)
  103453:	ff 75 08             	pushl  0x8(%ebp)
  103456:	e8 67 fe ff ff       	call   1032c2 <printfmt>
  10345b:	83 c4 10             	add    $0x10,%esp
  10345e:	e9 1e 02 00 00       	jmp    103681 <vprintfmt+0x39b>
  103463:	8b 45 14             	mov    0x14(%ebp),%eax
  103466:	8d 50 04             	lea    0x4(%eax),%edx
  103469:	89 55 14             	mov    %edx,0x14(%ebp)
  10346c:	8b 30                	mov    (%eax),%esi
  10346e:	85 f6                	test   %esi,%esi
  103470:	75 05                	jne    103477 <vprintfmt+0x191>
  103472:	be 2d 3f 10 00       	mov    $0x103f2d,%esi
  103477:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10347b:	7e 76                	jle    1034f3 <vprintfmt+0x20d>
  10347d:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  103481:	74 70                	je     1034f3 <vprintfmt+0x20d>
  103483:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103486:	83 ec 08             	sub    $0x8,%esp
  103489:	50                   	push   %eax
  10348a:	56                   	push   %esi
  10348b:	e8 1c f8 ff ff       	call   102cac <strnlen>
  103490:	83 c4 10             	add    $0x10,%esp
  103493:	89 c2                	mov    %eax,%edx
  103495:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103498:	29 d0                	sub    %edx,%eax
  10349a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10349d:	eb 17                	jmp    1034b6 <vprintfmt+0x1d0>
  10349f:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  1034a3:	83 ec 08             	sub    $0x8,%esp
  1034a6:	ff 75 0c             	pushl  0xc(%ebp)
  1034a9:	50                   	push   %eax
  1034aa:	8b 45 08             	mov    0x8(%ebp),%eax
  1034ad:	ff d0                	call   *%eax
  1034af:	83 c4 10             	add    $0x10,%esp
  1034b2:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1034b6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1034ba:	7f e3                	jg     10349f <vprintfmt+0x1b9>
  1034bc:	eb 35                	jmp    1034f3 <vprintfmt+0x20d>
  1034be:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  1034c2:	74 1c                	je     1034e0 <vprintfmt+0x1fa>
  1034c4:	83 fb 1f             	cmp    $0x1f,%ebx
  1034c7:	7e 05                	jle    1034ce <vprintfmt+0x1e8>
  1034c9:	83 fb 7e             	cmp    $0x7e,%ebx
  1034cc:	7e 12                	jle    1034e0 <vprintfmt+0x1fa>
  1034ce:	83 ec 08             	sub    $0x8,%esp
  1034d1:	ff 75 0c             	pushl  0xc(%ebp)
  1034d4:	6a 3f                	push   $0x3f
  1034d6:	8b 45 08             	mov    0x8(%ebp),%eax
  1034d9:	ff d0                	call   *%eax
  1034db:	83 c4 10             	add    $0x10,%esp
  1034de:	eb 0f                	jmp    1034ef <vprintfmt+0x209>
  1034e0:	83 ec 08             	sub    $0x8,%esp
  1034e3:	ff 75 0c             	pushl  0xc(%ebp)
  1034e6:	53                   	push   %ebx
  1034e7:	8b 45 08             	mov    0x8(%ebp),%eax
  1034ea:	ff d0                	call   *%eax
  1034ec:	83 c4 10             	add    $0x10,%esp
  1034ef:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1034f3:	89 f0                	mov    %esi,%eax
  1034f5:	8d 70 01             	lea    0x1(%eax),%esi
  1034f8:	0f b6 00             	movzbl (%eax),%eax
  1034fb:	0f be d8             	movsbl %al,%ebx
  1034fe:	85 db                	test   %ebx,%ebx
  103500:	74 26                	je     103528 <vprintfmt+0x242>
  103502:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103506:	78 b6                	js     1034be <vprintfmt+0x1d8>
  103508:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  10350c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103510:	79 ac                	jns    1034be <vprintfmt+0x1d8>
  103512:	eb 14                	jmp    103528 <vprintfmt+0x242>
  103514:	83 ec 08             	sub    $0x8,%esp
  103517:	ff 75 0c             	pushl  0xc(%ebp)
  10351a:	6a 20                	push   $0x20
  10351c:	8b 45 08             	mov    0x8(%ebp),%eax
  10351f:	ff d0                	call   *%eax
  103521:	83 c4 10             	add    $0x10,%esp
  103524:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  103528:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10352c:	7f e6                	jg     103514 <vprintfmt+0x22e>
  10352e:	e9 4e 01 00 00       	jmp    103681 <vprintfmt+0x39b>
  103533:	83 ec 08             	sub    $0x8,%esp
  103536:	ff 75 e0             	pushl  -0x20(%ebp)
  103539:	8d 45 14             	lea    0x14(%ebp),%eax
  10353c:	50                   	push   %eax
  10353d:	e8 39 fd ff ff       	call   10327b <getint>
  103542:	83 c4 10             	add    $0x10,%esp
  103545:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103548:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10354b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10354e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103551:	85 d2                	test   %edx,%edx
  103553:	79 23                	jns    103578 <vprintfmt+0x292>
  103555:	83 ec 08             	sub    $0x8,%esp
  103558:	ff 75 0c             	pushl  0xc(%ebp)
  10355b:	6a 2d                	push   $0x2d
  10355d:	8b 45 08             	mov    0x8(%ebp),%eax
  103560:	ff d0                	call   *%eax
  103562:	83 c4 10             	add    $0x10,%esp
  103565:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103568:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10356b:	f7 d8                	neg    %eax
  10356d:	83 d2 00             	adc    $0x0,%edx
  103570:	f7 da                	neg    %edx
  103572:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103575:	89 55 f4             	mov    %edx,-0xc(%ebp)
  103578:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
  10357f:	e9 9f 00 00 00       	jmp    103623 <vprintfmt+0x33d>
  103584:	83 ec 08             	sub    $0x8,%esp
  103587:	ff 75 e0             	pushl  -0x20(%ebp)
  10358a:	8d 45 14             	lea    0x14(%ebp),%eax
  10358d:	50                   	push   %eax
  10358e:	e8 99 fc ff ff       	call   10322c <getuint>
  103593:	83 c4 10             	add    $0x10,%esp
  103596:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103599:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10359c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
  1035a3:	eb 7e                	jmp    103623 <vprintfmt+0x33d>
  1035a5:	83 ec 08             	sub    $0x8,%esp
  1035a8:	ff 75 e0             	pushl  -0x20(%ebp)
  1035ab:	8d 45 14             	lea    0x14(%ebp),%eax
  1035ae:	50                   	push   %eax
  1035af:	e8 78 fc ff ff       	call   10322c <getuint>
  1035b4:	83 c4 10             	add    $0x10,%esp
  1035b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1035ba:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1035bd:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
  1035c4:	eb 5d                	jmp    103623 <vprintfmt+0x33d>
  1035c6:	83 ec 08             	sub    $0x8,%esp
  1035c9:	ff 75 0c             	pushl  0xc(%ebp)
  1035cc:	6a 30                	push   $0x30
  1035ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1035d1:	ff d0                	call   *%eax
  1035d3:	83 c4 10             	add    $0x10,%esp
  1035d6:	83 ec 08             	sub    $0x8,%esp
  1035d9:	ff 75 0c             	pushl  0xc(%ebp)
  1035dc:	6a 78                	push   $0x78
  1035de:	8b 45 08             	mov    0x8(%ebp),%eax
  1035e1:	ff d0                	call   *%eax
  1035e3:	83 c4 10             	add    $0x10,%esp
  1035e6:	8b 45 14             	mov    0x14(%ebp),%eax
  1035e9:	8d 50 04             	lea    0x4(%eax),%edx
  1035ec:	89 55 14             	mov    %edx,0x14(%ebp)
  1035ef:	8b 00                	mov    (%eax),%eax
  1035f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1035f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1035fb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
  103602:	eb 1f                	jmp    103623 <vprintfmt+0x33d>
  103604:	83 ec 08             	sub    $0x8,%esp
  103607:	ff 75 e0             	pushl  -0x20(%ebp)
  10360a:	8d 45 14             	lea    0x14(%ebp),%eax
  10360d:	50                   	push   %eax
  10360e:	e8 19 fc ff ff       	call   10322c <getuint>
  103613:	83 c4 10             	add    $0x10,%esp
  103616:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103619:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10361c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
  103623:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  103627:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10362a:	83 ec 04             	sub    $0x4,%esp
  10362d:	52                   	push   %edx
  10362e:	ff 75 e8             	pushl  -0x18(%ebp)
  103631:	50                   	push   %eax
  103632:	ff 75 f4             	pushl  -0xc(%ebp)
  103635:	ff 75 f0             	pushl  -0x10(%ebp)
  103638:	ff 75 0c             	pushl  0xc(%ebp)
  10363b:	ff 75 08             	pushl  0x8(%ebp)
  10363e:	e8 fd fa ff ff       	call   103140 <printnum>
  103643:	83 c4 20             	add    $0x20,%esp
  103646:	eb 39                	jmp    103681 <vprintfmt+0x39b>
  103648:	83 ec 08             	sub    $0x8,%esp
  10364b:	ff 75 0c             	pushl  0xc(%ebp)
  10364e:	53                   	push   %ebx
  10364f:	8b 45 08             	mov    0x8(%ebp),%eax
  103652:	ff d0                	call   *%eax
  103654:	83 c4 10             	add    $0x10,%esp
  103657:	eb 28                	jmp    103681 <vprintfmt+0x39b>
  103659:	83 ec 08             	sub    $0x8,%esp
  10365c:	ff 75 0c             	pushl  0xc(%ebp)
  10365f:	6a 25                	push   $0x25
  103661:	8b 45 08             	mov    0x8(%ebp),%eax
  103664:	ff d0                	call   *%eax
  103666:	83 c4 10             	add    $0x10,%esp
  103669:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  10366d:	eb 04                	jmp    103673 <vprintfmt+0x38d>
  10366f:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  103673:	8b 45 10             	mov    0x10(%ebp),%eax
  103676:	83 e8 01             	sub    $0x1,%eax
  103679:	0f b6 00             	movzbl (%eax),%eax
  10367c:	3c 25                	cmp    $0x25,%al
  10367e:	75 ef                	jne    10366f <vprintfmt+0x389>
  103680:	90                   	nop
  103681:	e9 68 fc ff ff       	jmp    1032ee <vprintfmt+0x8>
  103686:	90                   	nop
  103687:	8d 65 f8             	lea    -0x8(%ebp),%esp
  10368a:	5b                   	pop    %ebx
  10368b:	5e                   	pop    %esi
  10368c:	5d                   	pop    %ebp
  10368d:	c3                   	ret    

0010368e <sprintputch>:
  10368e:	55                   	push   %ebp
  10368f:	89 e5                	mov    %esp,%ebp
  103691:	8b 45 0c             	mov    0xc(%ebp),%eax
  103694:	8b 40 08             	mov    0x8(%eax),%eax
  103697:	8d 50 01             	lea    0x1(%eax),%edx
  10369a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10369d:	89 50 08             	mov    %edx,0x8(%eax)
  1036a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1036a3:	8b 10                	mov    (%eax),%edx
  1036a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1036a8:	8b 40 04             	mov    0x4(%eax),%eax
  1036ab:	39 c2                	cmp    %eax,%edx
  1036ad:	73 12                	jae    1036c1 <sprintputch+0x33>
  1036af:	8b 45 0c             	mov    0xc(%ebp),%eax
  1036b2:	8b 00                	mov    (%eax),%eax
  1036b4:	8d 48 01             	lea    0x1(%eax),%ecx
  1036b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  1036ba:	89 0a                	mov    %ecx,(%edx)
  1036bc:	8b 55 08             	mov    0x8(%ebp),%edx
  1036bf:	88 10                	mov    %dl,(%eax)
  1036c1:	90                   	nop
  1036c2:	5d                   	pop    %ebp
  1036c3:	c3                   	ret    

001036c4 <snprintf>:
  1036c4:	55                   	push   %ebp
  1036c5:	89 e5                	mov    %esp,%ebp
  1036c7:	83 ec 18             	sub    $0x18,%esp
  1036ca:	8d 45 14             	lea    0x14(%ebp),%eax
  1036cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1036d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1036d3:	50                   	push   %eax
  1036d4:	ff 75 10             	pushl  0x10(%ebp)
  1036d7:	ff 75 0c             	pushl  0xc(%ebp)
  1036da:	ff 75 08             	pushl  0x8(%ebp)
  1036dd:	e8 0b 00 00 00       	call   1036ed <vsnprintf>
  1036e2:	83 c4 10             	add    $0x10,%esp
  1036e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1036e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1036eb:	c9                   	leave  
  1036ec:	c3                   	ret    

001036ed <vsnprintf>:
  1036ed:	55                   	push   %ebp
  1036ee:	89 e5                	mov    %esp,%ebp
  1036f0:	83 ec 18             	sub    $0x18,%esp
  1036f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1036f6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1036f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1036fc:	8d 50 ff             	lea    -0x1(%eax),%edx
  1036ff:	8b 45 08             	mov    0x8(%ebp),%eax
  103702:	01 d0                	add    %edx,%eax
  103704:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103707:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  10370e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103712:	74 0a                	je     10371e <vsnprintf+0x31>
  103714:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103717:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10371a:	39 c2                	cmp    %eax,%edx
  10371c:	76 07                	jbe    103725 <vsnprintf+0x38>
  10371e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  103723:	eb 20                	jmp    103745 <vsnprintf+0x58>
  103725:	ff 75 14             	pushl  0x14(%ebp)
  103728:	ff 75 10             	pushl  0x10(%ebp)
  10372b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  10372e:	50                   	push   %eax
  10372f:	68 8e 36 10 00       	push   $0x10368e
  103734:	e8 ad fb ff ff       	call   1032e6 <vprintfmt>
  103739:	83 c4 10             	add    $0x10,%esp
  10373c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10373f:	c6 00 00             	movb   $0x0,(%eax)
  103742:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103745:	c9                   	leave  
  103746:	c3                   	ret    
