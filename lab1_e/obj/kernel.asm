
bin/kernel：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000080200000 <kern_entry>:
    80200000:	00004117          	auipc	sp,0x4
    80200004:	00010113          	mv	sp,sp
    80200008:	a009                	j	8020000a <kern_init>

000000008020000a <kern_init>:
    8020000a:	00004517          	auipc	a0,0x4
    8020000e:	00650513          	addi	a0,a0,6 # 80204010 <ticks>
    80200012:	00004617          	auipc	a2,0x4
    80200016:	01660613          	addi	a2,a2,22 # 80204028 <end>
    8020001a:	1141                	addi	sp,sp,-16
    8020001c:	8e09                	sub	a2,a2,a0
    8020001e:	4581                	li	a1,0
    80200020:	e406                	sd	ra,8(sp)
    80200022:	5a0000ef          	jal	ra,802005c2 <memset>
    80200026:	14a000ef          	jal	ra,80200170 <cons_init>
    8020002a:	00001597          	auipc	a1,0x1
    8020002e:	9e658593          	addi	a1,a1,-1562 # 80200a10 <etext>
    80200032:	00001517          	auipc	a0,0x1
    80200036:	9fe50513          	addi	a0,a0,-1538 # 80200a30 <etext+0x20>
    8020003a:	030000ef          	jal	ra,8020006a <cprintf>
    8020003e:	062000ef          	jal	ra,802000a0 <print_kerninfo>
    80200042:	13e000ef          	jal	ra,80200180 <idt_init>
    80200046:	0e8000ef          	jal	ra,8020012e <clock_init>
    8020004a:	130000ef          	jal	ra,8020017a <intr_enable>
    8020004e:	a001                	j	8020004e <kern_init+0x44>

0000000080200050 <cputch>:
    80200050:	1141                	addi	sp,sp,-16
    80200052:	e022                	sd	s0,0(sp)
    80200054:	e406                	sd	ra,8(sp)
    80200056:	842e                	mv	s0,a1
    80200058:	11a000ef          	jal	ra,80200172 <cons_putc>
    8020005c:	401c                	lw	a5,0(s0)
    8020005e:	60a2                	ld	ra,8(sp)
    80200060:	2785                	addiw	a5,a5,1
    80200062:	c01c                	sw	a5,0(s0)
    80200064:	6402                	ld	s0,0(sp)
    80200066:	0141                	addi	sp,sp,16
    80200068:	8082                	ret

000000008020006a <cprintf>:
    8020006a:	711d                	addi	sp,sp,-96
    8020006c:	02810313          	addi	t1,sp,40 # 80204028 <end>
    80200070:	8e2a                	mv	t3,a0
    80200072:	f42e                	sd	a1,40(sp)
    80200074:	f832                	sd	a2,48(sp)
    80200076:	fc36                	sd	a3,56(sp)
    80200078:	00000517          	auipc	a0,0x0
    8020007c:	fd850513          	addi	a0,a0,-40 # 80200050 <cputch>
    80200080:	004c                	addi	a1,sp,4
    80200082:	869a                	mv	a3,t1
    80200084:	8672                	mv	a2,t3
    80200086:	ec06                	sd	ra,24(sp)
    80200088:	e0ba                	sd	a4,64(sp)
    8020008a:	e4be                	sd	a5,72(sp)
    8020008c:	e8c2                	sd	a6,80(sp)
    8020008e:	ecc6                	sd	a7,88(sp)
    80200090:	e41a                	sd	t1,8(sp)
    80200092:	c202                	sw	zero,4(sp)
    80200094:	5ac000ef          	jal	ra,80200640 <vprintfmt>
    80200098:	60e2                	ld	ra,24(sp)
    8020009a:	4512                	lw	a0,4(sp)
    8020009c:	6125                	addi	sp,sp,96
    8020009e:	8082                	ret

00000000802000a0 <print_kerninfo>:
    802000a0:	1141                	addi	sp,sp,-16
    802000a2:	00001517          	auipc	a0,0x1
    802000a6:	99650513          	addi	a0,a0,-1642 # 80200a38 <etext+0x28>
    802000aa:	e406                	sd	ra,8(sp)
    802000ac:	fbfff0ef          	jal	ra,8020006a <cprintf>
    802000b0:	00000597          	auipc	a1,0x0
    802000b4:	f5a58593          	addi	a1,a1,-166 # 8020000a <kern_init>
    802000b8:	00001517          	auipc	a0,0x1
    802000bc:	9a050513          	addi	a0,a0,-1632 # 80200a58 <etext+0x48>
    802000c0:	fabff0ef          	jal	ra,8020006a <cprintf>
    802000c4:	00001597          	auipc	a1,0x1
    802000c8:	94c58593          	addi	a1,a1,-1716 # 80200a10 <etext>
    802000cc:	00001517          	auipc	a0,0x1
    802000d0:	9ac50513          	addi	a0,a0,-1620 # 80200a78 <etext+0x68>
    802000d4:	f97ff0ef          	jal	ra,8020006a <cprintf>
    802000d8:	00004597          	auipc	a1,0x4
    802000dc:	f3858593          	addi	a1,a1,-200 # 80204010 <ticks>
    802000e0:	00001517          	auipc	a0,0x1
    802000e4:	9b850513          	addi	a0,a0,-1608 # 80200a98 <etext+0x88>
    802000e8:	f83ff0ef          	jal	ra,8020006a <cprintf>
    802000ec:	00004597          	auipc	a1,0x4
    802000f0:	f3c58593          	addi	a1,a1,-196 # 80204028 <end>
    802000f4:	00001517          	auipc	a0,0x1
    802000f8:	9c450513          	addi	a0,a0,-1596 # 80200ab8 <etext+0xa8>
    802000fc:	f6fff0ef          	jal	ra,8020006a <cprintf>
    80200100:	00004597          	auipc	a1,0x4
    80200104:	32758593          	addi	a1,a1,807 # 80204427 <end+0x3ff>
    80200108:	00000797          	auipc	a5,0x0
    8020010c:	f0278793          	addi	a5,a5,-254 # 8020000a <kern_init>
    80200110:	40f587b3          	sub	a5,a1,a5
    80200114:	43f7d593          	srai	a1,a5,0x3f
    80200118:	60a2                	ld	ra,8(sp)
    8020011a:	3ff5f593          	andi	a1,a1,1023
    8020011e:	95be                	add	a1,a1,a5
    80200120:	85a9                	srai	a1,a1,0xa
    80200122:	00001517          	auipc	a0,0x1
    80200126:	9b650513          	addi	a0,a0,-1610 # 80200ad8 <etext+0xc8>
    8020012a:	0141                	addi	sp,sp,16
    8020012c:	bf3d                	j	8020006a <cprintf>

000000008020012e <clock_init>:
    8020012e:	1141                	addi	sp,sp,-16
    80200130:	e406                	sd	ra,8(sp)
    80200132:	02000793          	li	a5,32
    80200136:	1047a7f3          	csrrs	a5,sie,a5
    8020013a:	c0102573          	rdtime	a0
    8020013e:	67e1                	lui	a5,0x18
    80200140:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0x801e7960>
    80200144:	953e                	add	a0,a0,a5
    80200146:	097000ef          	jal	ra,802009dc <sbi_set_timer>
    8020014a:	60a2                	ld	ra,8(sp)
    8020014c:	00004797          	auipc	a5,0x4
    80200150:	ec07b223          	sd	zero,-316(a5) # 80204010 <ticks>
    80200154:	00001517          	auipc	a0,0x1
    80200158:	9b450513          	addi	a0,a0,-1612 # 80200b08 <etext+0xf8>
    8020015c:	0141                	addi	sp,sp,16
    8020015e:	b731                	j	8020006a <cprintf>

0000000080200160 <clock_set_next_event>:
    80200160:	c0102573          	rdtime	a0
    80200164:	67e1                	lui	a5,0x18
    80200166:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0x801e7960>
    8020016a:	953e                	add	a0,a0,a5
    8020016c:	0710006f          	j	802009dc <sbi_set_timer>

0000000080200170 <cons_init>:
    80200170:	8082                	ret

0000000080200172 <cons_putc>:
    80200172:	0ff57513          	andi	a0,a0,255
    80200176:	04d0006f          	j	802009c2 <sbi_console_putchar>

000000008020017a <intr_enable>:
    8020017a:	100167f3          	csrrsi	a5,sstatus,2
    8020017e:	8082                	ret

0000000080200180 <idt_init>:
 */
void idt_init(void) {
    extern void __alltraps(void);
    /* Set sscratch register to 0, indicating to exception vector that we are
     * presently executing in the kernel */
    write_csr(sscratch, 0);
    80200180:	14005073          	csrwi	sscratch,0
    /* Set the exception vector address */
    write_csr(stvec, &__alltraps);
    80200184:	00000797          	auipc	a5,0x0
    80200188:	36c78793          	addi	a5,a5,876 # 802004f0 <__alltraps>
    8020018c:	10579073          	csrw	stvec,a5
}
    80200190:	8082                	ret

0000000080200192 <print_regs>:
    cprintf("  badvaddr 0x%08x\n", tf->badvaddr);
    cprintf("  cause    0x%08x\n", tf->cause);
}

void print_regs(struct pushregs *gpr) {
    cprintf("  zero     0x%08x\n", gpr->zero);
    80200192:	610c                	ld	a1,0(a0)
void print_regs(struct pushregs *gpr) {
    80200194:	1141                	addi	sp,sp,-16
    80200196:	e022                	sd	s0,0(sp)
    80200198:	842a                	mv	s0,a0
    cprintf("  zero     0x%08x\n", gpr->zero);
    8020019a:	00001517          	auipc	a0,0x1
    8020019e:	98e50513          	addi	a0,a0,-1650 # 80200b28 <etext+0x118>
void print_regs(struct pushregs *gpr) {
    802001a2:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
    802001a4:	ec7ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
    802001a8:	640c                	ld	a1,8(s0)
    802001aa:	00001517          	auipc	a0,0x1
    802001ae:	99650513          	addi	a0,a0,-1642 # 80200b40 <etext+0x130>
    802001b2:	eb9ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
    802001b6:	680c                	ld	a1,16(s0)
    802001b8:	00001517          	auipc	a0,0x1
    802001bc:	9a050513          	addi	a0,a0,-1632 # 80200b58 <etext+0x148>
    802001c0:	eabff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
    802001c4:	6c0c                	ld	a1,24(s0)
    802001c6:	00001517          	auipc	a0,0x1
    802001ca:	9aa50513          	addi	a0,a0,-1622 # 80200b70 <etext+0x160>
    802001ce:	e9dff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
    802001d2:	700c                	ld	a1,32(s0)
    802001d4:	00001517          	auipc	a0,0x1
    802001d8:	9b450513          	addi	a0,a0,-1612 # 80200b88 <etext+0x178>
    802001dc:	e8fff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
    802001e0:	740c                	ld	a1,40(s0)
    802001e2:	00001517          	auipc	a0,0x1
    802001e6:	9be50513          	addi	a0,a0,-1602 # 80200ba0 <etext+0x190>
    802001ea:	e81ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
    802001ee:	780c                	ld	a1,48(s0)
    802001f0:	00001517          	auipc	a0,0x1
    802001f4:	9c850513          	addi	a0,a0,-1592 # 80200bb8 <etext+0x1a8>
    802001f8:	e73ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
    802001fc:	7c0c                	ld	a1,56(s0)
    802001fe:	00001517          	auipc	a0,0x1
    80200202:	9d250513          	addi	a0,a0,-1582 # 80200bd0 <etext+0x1c0>
    80200206:	e65ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
    8020020a:	602c                	ld	a1,64(s0)
    8020020c:	00001517          	auipc	a0,0x1
    80200210:	9dc50513          	addi	a0,a0,-1572 # 80200be8 <etext+0x1d8>
    80200214:	e57ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
    80200218:	642c                	ld	a1,72(s0)
    8020021a:	00001517          	auipc	a0,0x1
    8020021e:	9e650513          	addi	a0,a0,-1562 # 80200c00 <etext+0x1f0>
    80200222:	e49ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
    80200226:	682c                	ld	a1,80(s0)
    80200228:	00001517          	auipc	a0,0x1
    8020022c:	9f050513          	addi	a0,a0,-1552 # 80200c18 <etext+0x208>
    80200230:	e3bff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
    80200234:	6c2c                	ld	a1,88(s0)
    80200236:	00001517          	auipc	a0,0x1
    8020023a:	9fa50513          	addi	a0,a0,-1542 # 80200c30 <etext+0x220>
    8020023e:	e2dff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
    80200242:	702c                	ld	a1,96(s0)
    80200244:	00001517          	auipc	a0,0x1
    80200248:	a0450513          	addi	a0,a0,-1532 # 80200c48 <etext+0x238>
    8020024c:	e1fff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
    80200250:	742c                	ld	a1,104(s0)
    80200252:	00001517          	auipc	a0,0x1
    80200256:	a0e50513          	addi	a0,a0,-1522 # 80200c60 <etext+0x250>
    8020025a:	e11ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
    8020025e:	782c                	ld	a1,112(s0)
    80200260:	00001517          	auipc	a0,0x1
    80200264:	a1850513          	addi	a0,a0,-1512 # 80200c78 <etext+0x268>
    80200268:	e03ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
    8020026c:	7c2c                	ld	a1,120(s0)
    8020026e:	00001517          	auipc	a0,0x1
    80200272:	a2250513          	addi	a0,a0,-1502 # 80200c90 <etext+0x280>
    80200276:	df5ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
    8020027a:	604c                	ld	a1,128(s0)
    8020027c:	00001517          	auipc	a0,0x1
    80200280:	a2c50513          	addi	a0,a0,-1492 # 80200ca8 <etext+0x298>
    80200284:	de7ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
    80200288:	644c                	ld	a1,136(s0)
    8020028a:	00001517          	auipc	a0,0x1
    8020028e:	a3650513          	addi	a0,a0,-1482 # 80200cc0 <etext+0x2b0>
    80200292:	dd9ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
    80200296:	684c                	ld	a1,144(s0)
    80200298:	00001517          	auipc	a0,0x1
    8020029c:	a4050513          	addi	a0,a0,-1472 # 80200cd8 <etext+0x2c8>
    802002a0:	dcbff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
    802002a4:	6c4c                	ld	a1,152(s0)
    802002a6:	00001517          	auipc	a0,0x1
    802002aa:	a4a50513          	addi	a0,a0,-1462 # 80200cf0 <etext+0x2e0>
    802002ae:	dbdff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
    802002b2:	704c                	ld	a1,160(s0)
    802002b4:	00001517          	auipc	a0,0x1
    802002b8:	a5450513          	addi	a0,a0,-1452 # 80200d08 <etext+0x2f8>
    802002bc:	dafff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
    802002c0:	744c                	ld	a1,168(s0)
    802002c2:	00001517          	auipc	a0,0x1
    802002c6:	a5e50513          	addi	a0,a0,-1442 # 80200d20 <etext+0x310>
    802002ca:	da1ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
    802002ce:	784c                	ld	a1,176(s0)
    802002d0:	00001517          	auipc	a0,0x1
    802002d4:	a6850513          	addi	a0,a0,-1432 # 80200d38 <etext+0x328>
    802002d8:	d93ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
    802002dc:	7c4c                	ld	a1,184(s0)
    802002de:	00001517          	auipc	a0,0x1
    802002e2:	a7250513          	addi	a0,a0,-1422 # 80200d50 <etext+0x340>
    802002e6:	d85ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
    802002ea:	606c                	ld	a1,192(s0)
    802002ec:	00001517          	auipc	a0,0x1
    802002f0:	a7c50513          	addi	a0,a0,-1412 # 80200d68 <etext+0x358>
    802002f4:	d77ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
    802002f8:	646c                	ld	a1,200(s0)
    802002fa:	00001517          	auipc	a0,0x1
    802002fe:	a8650513          	addi	a0,a0,-1402 # 80200d80 <etext+0x370>
    80200302:	d69ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
    80200306:	686c                	ld	a1,208(s0)
    80200308:	00001517          	auipc	a0,0x1
    8020030c:	a9050513          	addi	a0,a0,-1392 # 80200d98 <etext+0x388>
    80200310:	d5bff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
    80200314:	6c6c                	ld	a1,216(s0)
    80200316:	00001517          	auipc	a0,0x1
    8020031a:	a9a50513          	addi	a0,a0,-1382 # 80200db0 <etext+0x3a0>
    8020031e:	d4dff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
    80200322:	706c                	ld	a1,224(s0)
    80200324:	00001517          	auipc	a0,0x1
    80200328:	aa450513          	addi	a0,a0,-1372 # 80200dc8 <etext+0x3b8>
    8020032c:	d3fff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
    80200330:	746c                	ld	a1,232(s0)
    80200332:	00001517          	auipc	a0,0x1
    80200336:	aae50513          	addi	a0,a0,-1362 # 80200de0 <etext+0x3d0>
    8020033a:	d31ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
    8020033e:	786c                	ld	a1,240(s0)
    80200340:	00001517          	auipc	a0,0x1
    80200344:	ab850513          	addi	a0,a0,-1352 # 80200df8 <etext+0x3e8>
    80200348:	d23ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
    8020034c:	7c6c                	ld	a1,248(s0)
}
    8020034e:	6402                	ld	s0,0(sp)
    80200350:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
    80200352:	00001517          	auipc	a0,0x1
    80200356:	abe50513          	addi	a0,a0,-1346 # 80200e10 <etext+0x400>
}
    8020035a:	0141                	addi	sp,sp,16
    cprintf("  t6       0x%08x\n", gpr->t6);
    8020035c:	b339                	j	8020006a <cprintf>

000000008020035e <print_trapframe>:
void print_trapframe(struct trapframe *tf) {
    8020035e:	1141                	addi	sp,sp,-16
    80200360:	e022                	sd	s0,0(sp)
    cprintf("trapframe at %p\n", tf);
    80200362:	85aa                	mv	a1,a0
void print_trapframe(struct trapframe *tf) {
    80200364:	842a                	mv	s0,a0
    cprintf("trapframe at %p\n", tf);
    80200366:	00001517          	auipc	a0,0x1
    8020036a:	ac250513          	addi	a0,a0,-1342 # 80200e28 <etext+0x418>
void print_trapframe(struct trapframe *tf) {
    8020036e:	e406                	sd	ra,8(sp)
    cprintf("trapframe at %p\n", tf);
    80200370:	cfbff0ef          	jal	ra,8020006a <cprintf>
    print_regs(&tf->gpr);
    80200374:	8522                	mv	a0,s0
    80200376:	e1dff0ef          	jal	ra,80200192 <print_regs>
    cprintf("  status   0x%08x\n", tf->status);
    8020037a:	10043583          	ld	a1,256(s0)
    8020037e:	00001517          	auipc	a0,0x1
    80200382:	ac250513          	addi	a0,a0,-1342 # 80200e40 <etext+0x430>
    80200386:	ce5ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
    8020038a:	10843583          	ld	a1,264(s0)
    8020038e:	00001517          	auipc	a0,0x1
    80200392:	aca50513          	addi	a0,a0,-1334 # 80200e58 <etext+0x448>
    80200396:	cd5ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  badvaddr 0x%08x\n", tf->badvaddr);
    8020039a:	11043583          	ld	a1,272(s0)
    8020039e:	00001517          	auipc	a0,0x1
    802003a2:	ad250513          	addi	a0,a0,-1326 # 80200e70 <etext+0x460>
    802003a6:	cc5ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
    802003aa:	11843583          	ld	a1,280(s0)
}
    802003ae:	6402                	ld	s0,0(sp)
    802003b0:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
    802003b2:	00001517          	auipc	a0,0x1
    802003b6:	ad650513          	addi	a0,a0,-1322 # 80200e88 <etext+0x478>
}
    802003ba:	0141                	addi	sp,sp,16
    cprintf("  cause    0x%08x\n", tf->cause);
    802003bc:	b17d                	j	8020006a <cprintf>

00000000802003be <interrupt_handler>:

void interrupt_handler(struct trapframe *tf) {
    intptr_t cause = (tf->cause << 1) >> 1;
    802003be:	11853783          	ld	a5,280(a0)
    802003c2:	472d                	li	a4,11
    802003c4:	0786                	slli	a5,a5,0x1
    802003c6:	8385                	srli	a5,a5,0x1
    802003c8:	0af76763          	bltu	a4,a5,80200476 <interrupt_handler+0xb8>
    802003cc:	00001717          	auipc	a4,0x1
    802003d0:	b8470713          	addi	a4,a4,-1148 # 80200f50 <etext+0x540>
    802003d4:	078a                	slli	a5,a5,0x2
    802003d6:	97ba                	add	a5,a5,a4
    802003d8:	439c                	lw	a5,0(a5)
    802003da:	97ba                	add	a5,a5,a4
    802003dc:	8782                	jr	a5
            break;
        case IRQ_H_SOFT:
            cprintf("Hypervisor software interrupt\n");
            break;
        case IRQ_M_SOFT:
            cprintf("Machine software interrupt\n");
    802003de:	00001517          	auipc	a0,0x1
    802003e2:	b2250513          	addi	a0,a0,-1246 # 80200f00 <etext+0x4f0>
    802003e6:	b151                	j	8020006a <cprintf>
            cprintf("Hypervisor software interrupt\n");
    802003e8:	00001517          	auipc	a0,0x1
    802003ec:	af850513          	addi	a0,a0,-1288 # 80200ee0 <etext+0x4d0>
    802003f0:	b9ad                	j	8020006a <cprintf>
            cprintf("User software interrupt\n");
    802003f2:	00001517          	auipc	a0,0x1
    802003f6:	aae50513          	addi	a0,a0,-1362 # 80200ea0 <etext+0x490>
    802003fa:	b985                	j	8020006a <cprintf>
            cprintf("Supervisor software interrupt\n");
    802003fc:	00001517          	auipc	a0,0x1
    80200400:	ac450513          	addi	a0,a0,-1340 # 80200ec0 <etext+0x4b0>
    80200404:	b19d                	j	8020006a <cprintf>
void interrupt_handler(struct trapframe *tf) {
    80200406:	1141                	addi	sp,sp,-16
    80200408:	e406                	sd	ra,8(sp)
    8020040a:	e022                	sd	s0,0(sp)
            /*(1)设置下次时钟中断- clock_set_next_event()
             *(2)计数器（ticks）加一
             *(3)当计数器加到100的时候，我们会输出一个`100ticks`表示我们触发了100次时钟中断，同时打印次数（num）加一
            * (4)判断打印次数，当打印次数为10时，调用<sbi.h>中的关机函数关机
            */
            clock_set_next_event();//发生这次时钟中断的时候，我们要设置下一次时钟中断
    8020040c:	d55ff0ef          	jal	ra,80200160 <clock_set_next_event>
            if (++ticks % TICK_NUM == 0) {
    80200410:	00004697          	auipc	a3,0x4
    80200414:	c0068693          	addi	a3,a3,-1024 # 80204010 <ticks>
    80200418:	629c                	ld	a5,0(a3)
    8020041a:	06400713          	li	a4,100
    8020041e:	0785                	addi	a5,a5,1
    80200420:	02e7f733          	remu	a4,a5,a4
    80200424:	e29c                	sd	a5,0(a3)
    80200426:	ef1d                	bnez	a4,80200464 <interrupt_handler+0xa6>
                if(num == 1)
    80200428:	00004417          	auipc	s0,0x4
    8020042c:	bf040413          	addi	s0,s0,-1040 # 80204018 <num>
    80200430:	6018                	ld	a4,0(s0)
    80200432:	4785                	li	a5,1
    80200434:	00f71463          	bne	a4,a5,8020043c <interrupt_handler+0x7e>
                trigger_illegal_instruction();
    80200438:	ffff                	0xffff
    8020043a:	ffff                	0xffff
                if(num==2) 
    8020043c:	6018                	ld	a4,0(s0)
    8020043e:	4789                	li	a5,2
    80200440:	00f71363          	bne	a4,a5,80200446 <interrupt_handler+0x88>
    asm volatile ("ebreak");  // 触发断点
    80200444:	9002                	ebreak
                trigger_breakpoint();
                if(num>=10){
    80200446:	6018                	ld	a4,0(s0)
    80200448:	47a5                	li	a5,9
    8020044a:	02e7e763          	bltu	a5,a4,80200478 <interrupt_handler+0xba>
    cprintf("%d ticks\n", TICK_NUM);
    8020044e:	06400593          	li	a1,100
    80200452:	00001517          	auipc	a0,0x1
    80200456:	ace50513          	addi	a0,a0,-1330 # 80200f20 <etext+0x510>
    8020045a:	c11ff0ef          	jal	ra,8020006a <cprintf>
                    sbi_shutdown();
                }
                print_ticks();
                num++;
    8020045e:	601c                	ld	a5,0(s0)
    80200460:	0785                	addi	a5,a5,1
    80200462:	e01c                	sd	a5,0(s0)
            break;
        default:
            print_trapframe(tf);
            break;
    }
}
    80200464:	60a2                	ld	ra,8(sp)
    80200466:	6402                	ld	s0,0(sp)
    80200468:	0141                	addi	sp,sp,16
    8020046a:	8082                	ret
            cprintf("Supervisor external interrupt\n");
    8020046c:	00001517          	auipc	a0,0x1
    80200470:	ac450513          	addi	a0,a0,-1340 # 80200f30 <etext+0x520>
    80200474:	bedd                	j	8020006a <cprintf>
            print_trapframe(tf);
    80200476:	b5e5                	j	8020035e <print_trapframe>
                    sbi_shutdown();
    80200478:	57e000ef          	jal	ra,802009f6 <sbi_shutdown>
    8020047c:	bfc9                	j	8020044e <interrupt_handler+0x90>

000000008020047e <exception_handler>:

void exception_handler(struct trapframe *tf) {
    switch (tf->cause) {
    8020047e:	11853783          	ld	a5,280(a0)
void exception_handler(struct trapframe *tf) {
    80200482:	1141                	addi	sp,sp,-16
    80200484:	e022                	sd	s0,0(sp)
    80200486:	e406                	sd	ra,8(sp)
    switch (tf->cause) {
    80200488:	470d                	li	a4,3
void exception_handler(struct trapframe *tf) {
    8020048a:	842a                	mv	s0,a0
    switch (tf->cause) {
    8020048c:	04e78663          	beq	a5,a4,802004d8 <exception_handler+0x5a>
    80200490:	02f76c63          	bltu	a4,a5,802004c8 <exception_handler+0x4a>
    80200494:	4709                	li	a4,2
            break;
        case CAUSE_ILLEGAL_INSTRUCTION: 
           // 非法指令异常处理
            /* LAB1 CHALLENGE3   2210643 :  */
                // (1) 输出非法指令异常类型
            cprintf("Exception: Illegal instruction\n");
    80200496:	00001517          	auipc	a0,0x1
    8020049a:	aea50513          	addi	a0,a0,-1302 # 80200f80 <etext+0x570>
    switch (tf->cause) {
    8020049e:	02e79163          	bne	a5,a4,802004c0 <exception_handler+0x42>
                break;
        case CAUSE_BREAKPOINT:
                //断点异常处理
                /* LAB1 CHALLLENGE3   2210643 :  */
                //*(1)输出指令异常类型（ breakpoint）
            cprintf("Exception: breakpoint\n");
    802004a2:	bc9ff0ef          	jal	ra,8020006a <cprintf>

               // *(2)输出异常指令地址
            cprintf("Faulting instruction address caught at: 0x%lx\n", tf->epc);
    802004a6:	10843583          	ld	a1,264(s0)
    802004aa:	00001517          	auipc	a0,0x1
    802004ae:	af650513          	addi	a0,a0,-1290 # 80200fa0 <etext+0x590>
    802004b2:	bb9ff0ef          	jal	ra,8020006a <cprintf>
                //*(3)更新 tf->epc寄存器
            tf->epc += 4;  // 跳过这条非法指令
    802004b6:	10843783          	ld	a5,264(s0)
    802004ba:	0791                	addi	a5,a5,4
    802004bc:	10f43423          	sd	a5,264(s0)
            break;
        default:
            print_trapframe(tf);
            break;
    }
}
    802004c0:	60a2                	ld	ra,8(sp)
    802004c2:	6402                	ld	s0,0(sp)
    802004c4:	0141                	addi	sp,sp,16
    802004c6:	8082                	ret
    switch (tf->cause) {
    802004c8:	17f1                	addi	a5,a5,-4
    802004ca:	471d                	li	a4,7
    802004cc:	fef77ae3          	bgeu	a4,a5,802004c0 <exception_handler+0x42>
}
    802004d0:	6402                	ld	s0,0(sp)
    802004d2:	60a2                	ld	ra,8(sp)
    802004d4:	0141                	addi	sp,sp,16
            print_trapframe(tf);
    802004d6:	b561                	j	8020035e <print_trapframe>
            cprintf("Exception: breakpoint\n");
    802004d8:	00001517          	auipc	a0,0x1
    802004dc:	af850513          	addi	a0,a0,-1288 # 80200fd0 <etext+0x5c0>
    802004e0:	b7c9                	j	802004a2 <exception_handler+0x24>

00000000802004e2 <trap>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static inline void trap_dispatch(struct trapframe *tf) {
    if ((intptr_t)tf->cause < 0) {
    802004e2:	11853783          	ld	a5,280(a0)
    802004e6:	0007c363          	bltz	a5,802004ec <trap+0xa>
        // interrupts
        interrupt_handler(tf);
    } else {
        // exceptions
        exception_handler(tf);
    802004ea:	bf51                	j	8020047e <exception_handler>
        interrupt_handler(tf);
    802004ec:	bdc9                	j	802003be <interrupt_handler>
	...

00000000802004f0 <__alltraps>:
    802004f0:	14011073          	csrw	sscratch,sp
    802004f4:	712d                	addi	sp,sp,-288
    802004f6:	e002                	sd	zero,0(sp)
    802004f8:	e406                	sd	ra,8(sp)
    802004fa:	ec0e                	sd	gp,24(sp)
    802004fc:	f012                	sd	tp,32(sp)
    802004fe:	f416                	sd	t0,40(sp)
    80200500:	f81a                	sd	t1,48(sp)
    80200502:	fc1e                	sd	t2,56(sp)
    80200504:	e0a2                	sd	s0,64(sp)
    80200506:	e4a6                	sd	s1,72(sp)
    80200508:	e8aa                	sd	a0,80(sp)
    8020050a:	ecae                	sd	a1,88(sp)
    8020050c:	f0b2                	sd	a2,96(sp)
    8020050e:	f4b6                	sd	a3,104(sp)
    80200510:	f8ba                	sd	a4,112(sp)
    80200512:	fcbe                	sd	a5,120(sp)
    80200514:	e142                	sd	a6,128(sp)
    80200516:	e546                	sd	a7,136(sp)
    80200518:	e94a                	sd	s2,144(sp)
    8020051a:	ed4e                	sd	s3,152(sp)
    8020051c:	f152                	sd	s4,160(sp)
    8020051e:	f556                	sd	s5,168(sp)
    80200520:	f95a                	sd	s6,176(sp)
    80200522:	fd5e                	sd	s7,184(sp)
    80200524:	e1e2                	sd	s8,192(sp)
    80200526:	e5e6                	sd	s9,200(sp)
    80200528:	e9ea                	sd	s10,208(sp)
    8020052a:	edee                	sd	s11,216(sp)
    8020052c:	f1f2                	sd	t3,224(sp)
    8020052e:	f5f6                	sd	t4,232(sp)
    80200530:	f9fa                	sd	t5,240(sp)
    80200532:	fdfe                	sd	t6,248(sp)
    80200534:	14001473          	csrrw	s0,sscratch,zero
    80200538:	100024f3          	csrr	s1,sstatus
    8020053c:	14102973          	csrr	s2,sepc
    80200540:	143029f3          	csrr	s3,stval
    80200544:	14202a73          	csrr	s4,scause
    80200548:	e822                	sd	s0,16(sp)
    8020054a:	e226                	sd	s1,256(sp)
    8020054c:	e64a                	sd	s2,264(sp)
    8020054e:	ea4e                	sd	s3,272(sp)
    80200550:	ee52                	sd	s4,280(sp)
    80200552:	850a                	mv	a0,sp
    80200554:	f8fff0ef          	jal	ra,802004e2 <trap>

0000000080200558 <__trapret>:
    80200558:	6492                	ld	s1,256(sp)
    8020055a:	6932                	ld	s2,264(sp)
    8020055c:	10049073          	csrw	sstatus,s1
    80200560:	14191073          	csrw	sepc,s2
    80200564:	60a2                	ld	ra,8(sp)
    80200566:	61e2                	ld	gp,24(sp)
    80200568:	7202                	ld	tp,32(sp)
    8020056a:	72a2                	ld	t0,40(sp)
    8020056c:	7342                	ld	t1,48(sp)
    8020056e:	73e2                	ld	t2,56(sp)
    80200570:	6406                	ld	s0,64(sp)
    80200572:	64a6                	ld	s1,72(sp)
    80200574:	6546                	ld	a0,80(sp)
    80200576:	65e6                	ld	a1,88(sp)
    80200578:	7606                	ld	a2,96(sp)
    8020057a:	76a6                	ld	a3,104(sp)
    8020057c:	7746                	ld	a4,112(sp)
    8020057e:	77e6                	ld	a5,120(sp)
    80200580:	680a                	ld	a6,128(sp)
    80200582:	68aa                	ld	a7,136(sp)
    80200584:	694a                	ld	s2,144(sp)
    80200586:	69ea                	ld	s3,152(sp)
    80200588:	7a0a                	ld	s4,160(sp)
    8020058a:	7aaa                	ld	s5,168(sp)
    8020058c:	7b4a                	ld	s6,176(sp)
    8020058e:	7bea                	ld	s7,184(sp)
    80200590:	6c0e                	ld	s8,192(sp)
    80200592:	6cae                	ld	s9,200(sp)
    80200594:	6d4e                	ld	s10,208(sp)
    80200596:	6dee                	ld	s11,216(sp)
    80200598:	7e0e                	ld	t3,224(sp)
    8020059a:	7eae                	ld	t4,232(sp)
    8020059c:	7f4e                	ld	t5,240(sp)
    8020059e:	7fee                	ld	t6,248(sp)
    802005a0:	6142                	ld	sp,16(sp)
    802005a2:	10200073          	sret

00000000802005a6 <strnlen>:
    802005a6:	4781                	li	a5,0
    802005a8:	e589                	bnez	a1,802005b2 <strnlen+0xc>
    802005aa:	a811                	j	802005be <strnlen+0x18>
    802005ac:	0785                	addi	a5,a5,1
    802005ae:	00f58863          	beq	a1,a5,802005be <strnlen+0x18>
    802005b2:	00f50733          	add	a4,a0,a5
    802005b6:	00074703          	lbu	a4,0(a4)
    802005ba:	fb6d                	bnez	a4,802005ac <strnlen+0x6>
    802005bc:	85be                	mv	a1,a5
    802005be:	852e                	mv	a0,a1
    802005c0:	8082                	ret

00000000802005c2 <memset>:
    802005c2:	ca01                	beqz	a2,802005d2 <memset+0x10>
    802005c4:	962a                	add	a2,a2,a0
    802005c6:	87aa                	mv	a5,a0
    802005c8:	0785                	addi	a5,a5,1
    802005ca:	feb78fa3          	sb	a1,-1(a5)
    802005ce:	fec79de3          	bne	a5,a2,802005c8 <memset+0x6>
    802005d2:	8082                	ret

00000000802005d4 <printnum>:
    802005d4:	02069813          	slli	a6,a3,0x20
    802005d8:	7179                	addi	sp,sp,-48
    802005da:	02085813          	srli	a6,a6,0x20
    802005de:	e052                	sd	s4,0(sp)
    802005e0:	03067a33          	remu	s4,a2,a6
    802005e4:	f022                	sd	s0,32(sp)
    802005e6:	ec26                	sd	s1,24(sp)
    802005e8:	e84a                	sd	s2,16(sp)
    802005ea:	f406                	sd	ra,40(sp)
    802005ec:	e44e                	sd	s3,8(sp)
    802005ee:	84aa                	mv	s1,a0
    802005f0:	892e                	mv	s2,a1
    802005f2:	fff7041b          	addiw	s0,a4,-1
    802005f6:	2a01                	sext.w	s4,s4
    802005f8:	03067e63          	bgeu	a2,a6,80200634 <printnum+0x60>
    802005fc:	89be                	mv	s3,a5
    802005fe:	00805763          	blez	s0,8020060c <printnum+0x38>
    80200602:	347d                	addiw	s0,s0,-1
    80200604:	85ca                	mv	a1,s2
    80200606:	854e                	mv	a0,s3
    80200608:	9482                	jalr	s1
    8020060a:	fc65                	bnez	s0,80200602 <printnum+0x2e>
    8020060c:	1a02                	slli	s4,s4,0x20
    8020060e:	00001797          	auipc	a5,0x1
    80200612:	9da78793          	addi	a5,a5,-1574 # 80200fe8 <etext+0x5d8>
    80200616:	020a5a13          	srli	s4,s4,0x20
    8020061a:	9a3e                	add	s4,s4,a5
    8020061c:	7402                	ld	s0,32(sp)
    8020061e:	000a4503          	lbu	a0,0(s4)
    80200622:	70a2                	ld	ra,40(sp)
    80200624:	69a2                	ld	s3,8(sp)
    80200626:	6a02                	ld	s4,0(sp)
    80200628:	85ca                	mv	a1,s2
    8020062a:	87a6                	mv	a5,s1
    8020062c:	6942                	ld	s2,16(sp)
    8020062e:	64e2                	ld	s1,24(sp)
    80200630:	6145                	addi	sp,sp,48
    80200632:	8782                	jr	a5
    80200634:	03065633          	divu	a2,a2,a6
    80200638:	8722                	mv	a4,s0
    8020063a:	f9bff0ef          	jal	ra,802005d4 <printnum>
    8020063e:	b7f9                	j	8020060c <printnum+0x38>

0000000080200640 <vprintfmt>:
    80200640:	7119                	addi	sp,sp,-128
    80200642:	f4a6                	sd	s1,104(sp)
    80200644:	f0ca                	sd	s2,96(sp)
    80200646:	ecce                	sd	s3,88(sp)
    80200648:	e8d2                	sd	s4,80(sp)
    8020064a:	e4d6                	sd	s5,72(sp)
    8020064c:	e0da                	sd	s6,64(sp)
    8020064e:	fc5e                	sd	s7,56(sp)
    80200650:	f06a                	sd	s10,32(sp)
    80200652:	fc86                	sd	ra,120(sp)
    80200654:	f8a2                	sd	s0,112(sp)
    80200656:	f862                	sd	s8,48(sp)
    80200658:	f466                	sd	s9,40(sp)
    8020065a:	ec6e                	sd	s11,24(sp)
    8020065c:	892a                	mv	s2,a0
    8020065e:	84ae                	mv	s1,a1
    80200660:	8d32                	mv	s10,a2
    80200662:	8a36                	mv	s4,a3
    80200664:	02500993          	li	s3,37
    80200668:	5b7d                	li	s6,-1
    8020066a:	00001a97          	auipc	s5,0x1
    8020066e:	9b2a8a93          	addi	s5,s5,-1614 # 8020101c <etext+0x60c>
    80200672:	00001b97          	auipc	s7,0x1
    80200676:	b86b8b93          	addi	s7,s7,-1146 # 802011f8 <error_string>
    8020067a:	000d4503          	lbu	a0,0(s10)
    8020067e:	001d0413          	addi	s0,s10,1
    80200682:	01350a63          	beq	a0,s3,80200696 <vprintfmt+0x56>
    80200686:	c121                	beqz	a0,802006c6 <vprintfmt+0x86>
    80200688:	85a6                	mv	a1,s1
    8020068a:	0405                	addi	s0,s0,1
    8020068c:	9902                	jalr	s2
    8020068e:	fff44503          	lbu	a0,-1(s0)
    80200692:	ff351ae3          	bne	a0,s3,80200686 <vprintfmt+0x46>
    80200696:	00044603          	lbu	a2,0(s0)
    8020069a:	02000793          	li	a5,32
    8020069e:	4c81                	li	s9,0
    802006a0:	4881                	li	a7,0
    802006a2:	5c7d                	li	s8,-1
    802006a4:	5dfd                	li	s11,-1
    802006a6:	05500513          	li	a0,85
    802006aa:	4825                	li	a6,9
    802006ac:	fdd6059b          	addiw	a1,a2,-35
    802006b0:	0ff5f593          	andi	a1,a1,255
    802006b4:	00140d13          	addi	s10,s0,1
    802006b8:	04b56263          	bltu	a0,a1,802006fc <vprintfmt+0xbc>
    802006bc:	058a                	slli	a1,a1,0x2
    802006be:	95d6                	add	a1,a1,s5
    802006c0:	4194                	lw	a3,0(a1)
    802006c2:	96d6                	add	a3,a3,s5
    802006c4:	8682                	jr	a3
    802006c6:	70e6                	ld	ra,120(sp)
    802006c8:	7446                	ld	s0,112(sp)
    802006ca:	74a6                	ld	s1,104(sp)
    802006cc:	7906                	ld	s2,96(sp)
    802006ce:	69e6                	ld	s3,88(sp)
    802006d0:	6a46                	ld	s4,80(sp)
    802006d2:	6aa6                	ld	s5,72(sp)
    802006d4:	6b06                	ld	s6,64(sp)
    802006d6:	7be2                	ld	s7,56(sp)
    802006d8:	7c42                	ld	s8,48(sp)
    802006da:	7ca2                	ld	s9,40(sp)
    802006dc:	7d02                	ld	s10,32(sp)
    802006de:	6de2                	ld	s11,24(sp)
    802006e0:	6109                	addi	sp,sp,128
    802006e2:	8082                	ret
    802006e4:	87b2                	mv	a5,a2
    802006e6:	00144603          	lbu	a2,1(s0)
    802006ea:	846a                	mv	s0,s10
    802006ec:	00140d13          	addi	s10,s0,1
    802006f0:	fdd6059b          	addiw	a1,a2,-35
    802006f4:	0ff5f593          	andi	a1,a1,255
    802006f8:	fcb572e3          	bgeu	a0,a1,802006bc <vprintfmt+0x7c>
    802006fc:	85a6                	mv	a1,s1
    802006fe:	02500513          	li	a0,37
    80200702:	9902                	jalr	s2
    80200704:	fff44783          	lbu	a5,-1(s0)
    80200708:	8d22                	mv	s10,s0
    8020070a:	f73788e3          	beq	a5,s3,8020067a <vprintfmt+0x3a>
    8020070e:	ffed4783          	lbu	a5,-2(s10)
    80200712:	1d7d                	addi	s10,s10,-1
    80200714:	ff379de3          	bne	a5,s3,8020070e <vprintfmt+0xce>
    80200718:	b78d                	j	8020067a <vprintfmt+0x3a>
    8020071a:	fd060c1b          	addiw	s8,a2,-48
    8020071e:	00144603          	lbu	a2,1(s0)
    80200722:	846a                	mv	s0,s10
    80200724:	fd06069b          	addiw	a3,a2,-48
    80200728:	0006059b          	sext.w	a1,a2
    8020072c:	02d86463          	bltu	a6,a3,80200754 <vprintfmt+0x114>
    80200730:	00144603          	lbu	a2,1(s0)
    80200734:	002c169b          	slliw	a3,s8,0x2
    80200738:	0186873b          	addw	a4,a3,s8
    8020073c:	0017171b          	slliw	a4,a4,0x1
    80200740:	9f2d                	addw	a4,a4,a1
    80200742:	fd06069b          	addiw	a3,a2,-48
    80200746:	0405                	addi	s0,s0,1
    80200748:	fd070c1b          	addiw	s8,a4,-48
    8020074c:	0006059b          	sext.w	a1,a2
    80200750:	fed870e3          	bgeu	a6,a3,80200730 <vprintfmt+0xf0>
    80200754:	f40ddce3          	bgez	s11,802006ac <vprintfmt+0x6c>
    80200758:	8de2                	mv	s11,s8
    8020075a:	5c7d                	li	s8,-1
    8020075c:	bf81                	j	802006ac <vprintfmt+0x6c>
    8020075e:	fffdc693          	not	a3,s11
    80200762:	96fd                	srai	a3,a3,0x3f
    80200764:	00ddfdb3          	and	s11,s11,a3
    80200768:	00144603          	lbu	a2,1(s0)
    8020076c:	2d81                	sext.w	s11,s11
    8020076e:	846a                	mv	s0,s10
    80200770:	bf35                	j	802006ac <vprintfmt+0x6c>
    80200772:	000a2c03          	lw	s8,0(s4)
    80200776:	00144603          	lbu	a2,1(s0)
    8020077a:	0a21                	addi	s4,s4,8
    8020077c:	846a                	mv	s0,s10
    8020077e:	bfd9                	j	80200754 <vprintfmt+0x114>
    80200780:	4705                	li	a4,1
    80200782:	008a0593          	addi	a1,s4,8
    80200786:	01174463          	blt	a4,a7,8020078e <vprintfmt+0x14e>
    8020078a:	1a088e63          	beqz	a7,80200946 <vprintfmt+0x306>
    8020078e:	000a3603          	ld	a2,0(s4)
    80200792:	46c1                	li	a3,16
    80200794:	8a2e                	mv	s4,a1
    80200796:	2781                	sext.w	a5,a5
    80200798:	876e                	mv	a4,s11
    8020079a:	85a6                	mv	a1,s1
    8020079c:	854a                	mv	a0,s2
    8020079e:	e37ff0ef          	jal	ra,802005d4 <printnum>
    802007a2:	bde1                	j	8020067a <vprintfmt+0x3a>
    802007a4:	000a2503          	lw	a0,0(s4)
    802007a8:	85a6                	mv	a1,s1
    802007aa:	0a21                	addi	s4,s4,8
    802007ac:	9902                	jalr	s2
    802007ae:	b5f1                	j	8020067a <vprintfmt+0x3a>
    802007b0:	4705                	li	a4,1
    802007b2:	008a0593          	addi	a1,s4,8
    802007b6:	01174463          	blt	a4,a7,802007be <vprintfmt+0x17e>
    802007ba:	18088163          	beqz	a7,8020093c <vprintfmt+0x2fc>
    802007be:	000a3603          	ld	a2,0(s4)
    802007c2:	46a9                	li	a3,10
    802007c4:	8a2e                	mv	s4,a1
    802007c6:	bfc1                	j	80200796 <vprintfmt+0x156>
    802007c8:	00144603          	lbu	a2,1(s0)
    802007cc:	4c85                	li	s9,1
    802007ce:	846a                	mv	s0,s10
    802007d0:	bdf1                	j	802006ac <vprintfmt+0x6c>
    802007d2:	85a6                	mv	a1,s1
    802007d4:	02500513          	li	a0,37
    802007d8:	9902                	jalr	s2
    802007da:	b545                	j	8020067a <vprintfmt+0x3a>
    802007dc:	00144603          	lbu	a2,1(s0)
    802007e0:	2885                	addiw	a7,a7,1
    802007e2:	846a                	mv	s0,s10
    802007e4:	b5e1                	j	802006ac <vprintfmt+0x6c>
    802007e6:	4705                	li	a4,1
    802007e8:	008a0593          	addi	a1,s4,8
    802007ec:	01174463          	blt	a4,a7,802007f4 <vprintfmt+0x1b4>
    802007f0:	14088163          	beqz	a7,80200932 <vprintfmt+0x2f2>
    802007f4:	000a3603          	ld	a2,0(s4)
    802007f8:	46a1                	li	a3,8
    802007fa:	8a2e                	mv	s4,a1
    802007fc:	bf69                	j	80200796 <vprintfmt+0x156>
    802007fe:	03000513          	li	a0,48
    80200802:	85a6                	mv	a1,s1
    80200804:	e03e                	sd	a5,0(sp)
    80200806:	9902                	jalr	s2
    80200808:	85a6                	mv	a1,s1
    8020080a:	07800513          	li	a0,120
    8020080e:	9902                	jalr	s2
    80200810:	0a21                	addi	s4,s4,8
    80200812:	6782                	ld	a5,0(sp)
    80200814:	46c1                	li	a3,16
    80200816:	ff8a3603          	ld	a2,-8(s4)
    8020081a:	bfb5                	j	80200796 <vprintfmt+0x156>
    8020081c:	000a3403          	ld	s0,0(s4)
    80200820:	008a0713          	addi	a4,s4,8
    80200824:	e03a                	sd	a4,0(sp)
    80200826:	14040263          	beqz	s0,8020096a <vprintfmt+0x32a>
    8020082a:	0fb05763          	blez	s11,80200918 <vprintfmt+0x2d8>
    8020082e:	02d00693          	li	a3,45
    80200832:	0cd79163          	bne	a5,a3,802008f4 <vprintfmt+0x2b4>
    80200836:	00044783          	lbu	a5,0(s0)
    8020083a:	0007851b          	sext.w	a0,a5
    8020083e:	cf85                	beqz	a5,80200876 <vprintfmt+0x236>
    80200840:	00140a13          	addi	s4,s0,1
    80200844:	05e00413          	li	s0,94
    80200848:	000c4563          	bltz	s8,80200852 <vprintfmt+0x212>
    8020084c:	3c7d                	addiw	s8,s8,-1
    8020084e:	036c0263          	beq	s8,s6,80200872 <vprintfmt+0x232>
    80200852:	85a6                	mv	a1,s1
    80200854:	0e0c8e63          	beqz	s9,80200950 <vprintfmt+0x310>
    80200858:	3781                	addiw	a5,a5,-32
    8020085a:	0ef47b63          	bgeu	s0,a5,80200950 <vprintfmt+0x310>
    8020085e:	03f00513          	li	a0,63
    80200862:	9902                	jalr	s2
    80200864:	000a4783          	lbu	a5,0(s4)
    80200868:	3dfd                	addiw	s11,s11,-1
    8020086a:	0a05                	addi	s4,s4,1
    8020086c:	0007851b          	sext.w	a0,a5
    80200870:	ffe1                	bnez	a5,80200848 <vprintfmt+0x208>
    80200872:	01b05963          	blez	s11,80200884 <vprintfmt+0x244>
    80200876:	3dfd                	addiw	s11,s11,-1
    80200878:	85a6                	mv	a1,s1
    8020087a:	02000513          	li	a0,32
    8020087e:	9902                	jalr	s2
    80200880:	fe0d9be3          	bnez	s11,80200876 <vprintfmt+0x236>
    80200884:	6a02                	ld	s4,0(sp)
    80200886:	bbd5                	j	8020067a <vprintfmt+0x3a>
    80200888:	4705                	li	a4,1
    8020088a:	008a0c93          	addi	s9,s4,8
    8020088e:	01174463          	blt	a4,a7,80200896 <vprintfmt+0x256>
    80200892:	08088d63          	beqz	a7,8020092c <vprintfmt+0x2ec>
    80200896:	000a3403          	ld	s0,0(s4)
    8020089a:	0a044d63          	bltz	s0,80200954 <vprintfmt+0x314>
    8020089e:	8622                	mv	a2,s0
    802008a0:	8a66                	mv	s4,s9
    802008a2:	46a9                	li	a3,10
    802008a4:	bdcd                	j	80200796 <vprintfmt+0x156>
    802008a6:	000a2783          	lw	a5,0(s4)
    802008aa:	4719                	li	a4,6
    802008ac:	0a21                	addi	s4,s4,8
    802008ae:	41f7d69b          	sraiw	a3,a5,0x1f
    802008b2:	8fb5                	xor	a5,a5,a3
    802008b4:	40d786bb          	subw	a3,a5,a3
    802008b8:	02d74163          	blt	a4,a3,802008da <vprintfmt+0x29a>
    802008bc:	00369793          	slli	a5,a3,0x3
    802008c0:	97de                	add	a5,a5,s7
    802008c2:	639c                	ld	a5,0(a5)
    802008c4:	cb99                	beqz	a5,802008da <vprintfmt+0x29a>
    802008c6:	86be                	mv	a3,a5
    802008c8:	00000617          	auipc	a2,0x0
    802008cc:	75060613          	addi	a2,a2,1872 # 80201018 <etext+0x608>
    802008d0:	85a6                	mv	a1,s1
    802008d2:	854a                	mv	a0,s2
    802008d4:	0ce000ef          	jal	ra,802009a2 <printfmt>
    802008d8:	b34d                	j	8020067a <vprintfmt+0x3a>
    802008da:	00000617          	auipc	a2,0x0
    802008de:	72e60613          	addi	a2,a2,1838 # 80201008 <etext+0x5f8>
    802008e2:	85a6                	mv	a1,s1
    802008e4:	854a                	mv	a0,s2
    802008e6:	0bc000ef          	jal	ra,802009a2 <printfmt>
    802008ea:	bb41                	j	8020067a <vprintfmt+0x3a>
    802008ec:	00000417          	auipc	s0,0x0
    802008f0:	71440413          	addi	s0,s0,1812 # 80201000 <etext+0x5f0>
    802008f4:	85e2                	mv	a1,s8
    802008f6:	8522                	mv	a0,s0
    802008f8:	e43e                	sd	a5,8(sp)
    802008fa:	cadff0ef          	jal	ra,802005a6 <strnlen>
    802008fe:	40ad8dbb          	subw	s11,s11,a0
    80200902:	01b05b63          	blez	s11,80200918 <vprintfmt+0x2d8>
    80200906:	67a2                	ld	a5,8(sp)
    80200908:	00078a1b          	sext.w	s4,a5
    8020090c:	3dfd                	addiw	s11,s11,-1
    8020090e:	85a6                	mv	a1,s1
    80200910:	8552                	mv	a0,s4
    80200912:	9902                	jalr	s2
    80200914:	fe0d9ce3          	bnez	s11,8020090c <vprintfmt+0x2cc>
    80200918:	00044783          	lbu	a5,0(s0)
    8020091c:	00140a13          	addi	s4,s0,1
    80200920:	0007851b          	sext.w	a0,a5
    80200924:	d3a5                	beqz	a5,80200884 <vprintfmt+0x244>
    80200926:	05e00413          	li	s0,94
    8020092a:	bf39                	j	80200848 <vprintfmt+0x208>
    8020092c:	000a2403          	lw	s0,0(s4)
    80200930:	b7ad                	j	8020089a <vprintfmt+0x25a>
    80200932:	000a6603          	lwu	a2,0(s4)
    80200936:	46a1                	li	a3,8
    80200938:	8a2e                	mv	s4,a1
    8020093a:	bdb1                	j	80200796 <vprintfmt+0x156>
    8020093c:	000a6603          	lwu	a2,0(s4)
    80200940:	46a9                	li	a3,10
    80200942:	8a2e                	mv	s4,a1
    80200944:	bd89                	j	80200796 <vprintfmt+0x156>
    80200946:	000a6603          	lwu	a2,0(s4)
    8020094a:	46c1                	li	a3,16
    8020094c:	8a2e                	mv	s4,a1
    8020094e:	b5a1                	j	80200796 <vprintfmt+0x156>
    80200950:	9902                	jalr	s2
    80200952:	bf09                	j	80200864 <vprintfmt+0x224>
    80200954:	85a6                	mv	a1,s1
    80200956:	02d00513          	li	a0,45
    8020095a:	e03e                	sd	a5,0(sp)
    8020095c:	9902                	jalr	s2
    8020095e:	6782                	ld	a5,0(sp)
    80200960:	8a66                	mv	s4,s9
    80200962:	40800633          	neg	a2,s0
    80200966:	46a9                	li	a3,10
    80200968:	b53d                	j	80200796 <vprintfmt+0x156>
    8020096a:	03b05163          	blez	s11,8020098c <vprintfmt+0x34c>
    8020096e:	02d00693          	li	a3,45
    80200972:	f6d79de3          	bne	a5,a3,802008ec <vprintfmt+0x2ac>
    80200976:	00000417          	auipc	s0,0x0
    8020097a:	68a40413          	addi	s0,s0,1674 # 80201000 <etext+0x5f0>
    8020097e:	02800793          	li	a5,40
    80200982:	02800513          	li	a0,40
    80200986:	00140a13          	addi	s4,s0,1
    8020098a:	bd6d                	j	80200844 <vprintfmt+0x204>
    8020098c:	00000a17          	auipc	s4,0x0
    80200990:	675a0a13          	addi	s4,s4,1653 # 80201001 <etext+0x5f1>
    80200994:	02800513          	li	a0,40
    80200998:	02800793          	li	a5,40
    8020099c:	05e00413          	li	s0,94
    802009a0:	b565                	j	80200848 <vprintfmt+0x208>

00000000802009a2 <printfmt>:
    802009a2:	715d                	addi	sp,sp,-80
    802009a4:	02810313          	addi	t1,sp,40
    802009a8:	f436                	sd	a3,40(sp)
    802009aa:	869a                	mv	a3,t1
    802009ac:	ec06                	sd	ra,24(sp)
    802009ae:	f83a                	sd	a4,48(sp)
    802009b0:	fc3e                	sd	a5,56(sp)
    802009b2:	e0c2                	sd	a6,64(sp)
    802009b4:	e4c6                	sd	a7,72(sp)
    802009b6:	e41a                	sd	t1,8(sp)
    802009b8:	c89ff0ef          	jal	ra,80200640 <vprintfmt>
    802009bc:	60e2                	ld	ra,24(sp)
    802009be:	6161                	addi	sp,sp,80
    802009c0:	8082                	ret

00000000802009c2 <sbi_console_putchar>:
    802009c2:	4781                	li	a5,0
    802009c4:	00003717          	auipc	a4,0x3
    802009c8:	63c73703          	ld	a4,1596(a4) # 80204000 <SBI_CONSOLE_PUTCHAR>
    802009cc:	88ba                	mv	a7,a4
    802009ce:	852a                	mv	a0,a0
    802009d0:	85be                	mv	a1,a5
    802009d2:	863e                	mv	a2,a5
    802009d4:	00000073          	ecall
    802009d8:	87aa                	mv	a5,a0
    802009da:	8082                	ret

00000000802009dc <sbi_set_timer>:
    802009dc:	4781                	li	a5,0
    802009de:	00003717          	auipc	a4,0x3
    802009e2:	64273703          	ld	a4,1602(a4) # 80204020 <SBI_SET_TIMER>
    802009e6:	88ba                	mv	a7,a4
    802009e8:	852a                	mv	a0,a0
    802009ea:	85be                	mv	a1,a5
    802009ec:	863e                	mv	a2,a5
    802009ee:	00000073          	ecall
    802009f2:	87aa                	mv	a5,a0
    802009f4:	8082                	ret

00000000802009f6 <sbi_shutdown>:
    802009f6:	4781                	li	a5,0
    802009f8:	00003717          	auipc	a4,0x3
    802009fc:	61073703          	ld	a4,1552(a4) # 80204008 <SBI_SHUTDOWN>
    80200a00:	88ba                	mv	a7,a4
    80200a02:	853e                	mv	a0,a5
    80200a04:	85be                	mv	a1,a5
    80200a06:	863e                	mv	a2,a5
    80200a08:	00000073          	ecall
    80200a0c:	87aa                	mv	a5,a0
    80200a0e:	8082                	ret
