
bin/kernel:     file format elf64-littleriscv


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
    80200022:	1c5000ef          	jal	ra,802009e6 <memset>
    80200026:	14a000ef          	jal	ra,80200170 <cons_init>
    8020002a:	00001597          	auipc	a1,0x1
    8020002e:	9ce58593          	addi	a1,a1,-1586 # 802009f8 <etext>
    80200032:	00001517          	auipc	a0,0x1
    80200036:	9e650513          	addi	a0,a0,-1562 # 80200a18 <etext+0x20>
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
    80200094:	566000ef          	jal	ra,802005fa <vprintfmt>
    80200098:	60e2                	ld	ra,24(sp)
    8020009a:	4512                	lw	a0,4(sp)
    8020009c:	6125                	addi	sp,sp,96
    8020009e:	8082                	ret

00000000802000a0 <print_kerninfo>:
    802000a0:	1141                	addi	sp,sp,-16
    802000a2:	00001517          	auipc	a0,0x1
    802000a6:	97e50513          	addi	a0,a0,-1666 # 80200a20 <etext+0x28>
    802000aa:	e406                	sd	ra,8(sp)
    802000ac:	fbfff0ef          	jal	ra,8020006a <cprintf>
    802000b0:	00000597          	auipc	a1,0x0
    802000b4:	f5a58593          	addi	a1,a1,-166 # 8020000a <kern_init>
    802000b8:	00001517          	auipc	a0,0x1
    802000bc:	98850513          	addi	a0,a0,-1656 # 80200a40 <etext+0x48>
    802000c0:	fabff0ef          	jal	ra,8020006a <cprintf>
    802000c4:	00001597          	auipc	a1,0x1
    802000c8:	93458593          	addi	a1,a1,-1740 # 802009f8 <etext>
    802000cc:	00001517          	auipc	a0,0x1
    802000d0:	99450513          	addi	a0,a0,-1644 # 80200a60 <etext+0x68>
    802000d4:	f97ff0ef          	jal	ra,8020006a <cprintf>
    802000d8:	00004597          	auipc	a1,0x4
    802000dc:	f3858593          	addi	a1,a1,-200 # 80204010 <ticks>
    802000e0:	00001517          	auipc	a0,0x1
    802000e4:	9a050513          	addi	a0,a0,-1632 # 80200a80 <etext+0x88>
    802000e8:	f83ff0ef          	jal	ra,8020006a <cprintf>
    802000ec:	00004597          	auipc	a1,0x4
    802000f0:	f3c58593          	addi	a1,a1,-196 # 80204028 <end>
    802000f4:	00001517          	auipc	a0,0x1
    802000f8:	9ac50513          	addi	a0,a0,-1620 # 80200aa0 <etext+0xa8>
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
    80200126:	99e50513          	addi	a0,a0,-1634 # 80200ac0 <etext+0xc8>
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
    80200146:	051000ef          	jal	ra,80200996 <sbi_set_timer>
    8020014a:	60a2                	ld	ra,8(sp)
    8020014c:	00004797          	auipc	a5,0x4
    80200150:	ec07b223          	sd	zero,-316(a5) # 80204010 <ticks>
    80200154:	00001517          	auipc	a0,0x1
    80200158:	99c50513          	addi	a0,a0,-1636 # 80200af0 <etext+0xf8>
    8020015c:	0141                	addi	sp,sp,16
    8020015e:	b731                	j	8020006a <cprintf>

0000000080200160 <clock_set_next_event>:
    80200160:	c0102573          	rdtime	a0
    80200164:	67e1                	lui	a5,0x18
    80200166:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0x801e7960>
    8020016a:	953e                	add	a0,a0,a5
    8020016c:	02b0006f          	j	80200996 <sbi_set_timer>

0000000080200170 <cons_init>:
    80200170:	8082                	ret

0000000080200172 <cons_putc>:
    80200172:	0ff57513          	zext.b	a0,a0
    80200176:	0070006f          	j	8020097c <sbi_console_putchar>

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
    80200188:	35478793          	addi	a5,a5,852 # 802004d8 <__alltraps>
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
    8020019e:	97650513          	addi	a0,a0,-1674 # 80200b10 <etext+0x118>
void print_regs(struct pushregs *gpr) {
    802001a2:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
    802001a4:	ec7ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
    802001a8:	640c                	ld	a1,8(s0)
    802001aa:	00001517          	auipc	a0,0x1
    802001ae:	97e50513          	addi	a0,a0,-1666 # 80200b28 <etext+0x130>
    802001b2:	eb9ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
    802001b6:	680c                	ld	a1,16(s0)
    802001b8:	00001517          	auipc	a0,0x1
    802001bc:	98850513          	addi	a0,a0,-1656 # 80200b40 <etext+0x148>
    802001c0:	eabff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
    802001c4:	6c0c                	ld	a1,24(s0)
    802001c6:	00001517          	auipc	a0,0x1
    802001ca:	99250513          	addi	a0,a0,-1646 # 80200b58 <etext+0x160>
    802001ce:	e9dff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
    802001d2:	700c                	ld	a1,32(s0)
    802001d4:	00001517          	auipc	a0,0x1
    802001d8:	99c50513          	addi	a0,a0,-1636 # 80200b70 <etext+0x178>
    802001dc:	e8fff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
    802001e0:	740c                	ld	a1,40(s0)
    802001e2:	00001517          	auipc	a0,0x1
    802001e6:	9a650513          	addi	a0,a0,-1626 # 80200b88 <etext+0x190>
    802001ea:	e81ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
    802001ee:	780c                	ld	a1,48(s0)
    802001f0:	00001517          	auipc	a0,0x1
    802001f4:	9b050513          	addi	a0,a0,-1616 # 80200ba0 <etext+0x1a8>
    802001f8:	e73ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
    802001fc:	7c0c                	ld	a1,56(s0)
    802001fe:	00001517          	auipc	a0,0x1
    80200202:	9ba50513          	addi	a0,a0,-1606 # 80200bb8 <etext+0x1c0>
    80200206:	e65ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
    8020020a:	602c                	ld	a1,64(s0)
    8020020c:	00001517          	auipc	a0,0x1
    80200210:	9c450513          	addi	a0,a0,-1596 # 80200bd0 <etext+0x1d8>
    80200214:	e57ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
    80200218:	642c                	ld	a1,72(s0)
    8020021a:	00001517          	auipc	a0,0x1
    8020021e:	9ce50513          	addi	a0,a0,-1586 # 80200be8 <etext+0x1f0>
    80200222:	e49ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
    80200226:	682c                	ld	a1,80(s0)
    80200228:	00001517          	auipc	a0,0x1
    8020022c:	9d850513          	addi	a0,a0,-1576 # 80200c00 <etext+0x208>
    80200230:	e3bff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
    80200234:	6c2c                	ld	a1,88(s0)
    80200236:	00001517          	auipc	a0,0x1
    8020023a:	9e250513          	addi	a0,a0,-1566 # 80200c18 <etext+0x220>
    8020023e:	e2dff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
    80200242:	702c                	ld	a1,96(s0)
    80200244:	00001517          	auipc	a0,0x1
    80200248:	9ec50513          	addi	a0,a0,-1556 # 80200c30 <etext+0x238>
    8020024c:	e1fff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
    80200250:	742c                	ld	a1,104(s0)
    80200252:	00001517          	auipc	a0,0x1
    80200256:	9f650513          	addi	a0,a0,-1546 # 80200c48 <etext+0x250>
    8020025a:	e11ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
    8020025e:	782c                	ld	a1,112(s0)
    80200260:	00001517          	auipc	a0,0x1
    80200264:	a0050513          	addi	a0,a0,-1536 # 80200c60 <etext+0x268>
    80200268:	e03ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
    8020026c:	7c2c                	ld	a1,120(s0)
    8020026e:	00001517          	auipc	a0,0x1
    80200272:	a0a50513          	addi	a0,a0,-1526 # 80200c78 <etext+0x280>
    80200276:	df5ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
    8020027a:	604c                	ld	a1,128(s0)
    8020027c:	00001517          	auipc	a0,0x1
    80200280:	a1450513          	addi	a0,a0,-1516 # 80200c90 <etext+0x298>
    80200284:	de7ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
    80200288:	644c                	ld	a1,136(s0)
    8020028a:	00001517          	auipc	a0,0x1
    8020028e:	a1e50513          	addi	a0,a0,-1506 # 80200ca8 <etext+0x2b0>
    80200292:	dd9ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
    80200296:	684c                	ld	a1,144(s0)
    80200298:	00001517          	auipc	a0,0x1
    8020029c:	a2850513          	addi	a0,a0,-1496 # 80200cc0 <etext+0x2c8>
    802002a0:	dcbff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
    802002a4:	6c4c                	ld	a1,152(s0)
    802002a6:	00001517          	auipc	a0,0x1
    802002aa:	a3250513          	addi	a0,a0,-1486 # 80200cd8 <etext+0x2e0>
    802002ae:	dbdff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
    802002b2:	704c                	ld	a1,160(s0)
    802002b4:	00001517          	auipc	a0,0x1
    802002b8:	a3c50513          	addi	a0,a0,-1476 # 80200cf0 <etext+0x2f8>
    802002bc:	dafff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
    802002c0:	744c                	ld	a1,168(s0)
    802002c2:	00001517          	auipc	a0,0x1
    802002c6:	a4650513          	addi	a0,a0,-1466 # 80200d08 <etext+0x310>
    802002ca:	da1ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
    802002ce:	784c                	ld	a1,176(s0)
    802002d0:	00001517          	auipc	a0,0x1
    802002d4:	a5050513          	addi	a0,a0,-1456 # 80200d20 <etext+0x328>
    802002d8:	d93ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
    802002dc:	7c4c                	ld	a1,184(s0)
    802002de:	00001517          	auipc	a0,0x1
    802002e2:	a5a50513          	addi	a0,a0,-1446 # 80200d38 <etext+0x340>
    802002e6:	d85ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
    802002ea:	606c                	ld	a1,192(s0)
    802002ec:	00001517          	auipc	a0,0x1
    802002f0:	a6450513          	addi	a0,a0,-1436 # 80200d50 <etext+0x358>
    802002f4:	d77ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
    802002f8:	646c                	ld	a1,200(s0)
    802002fa:	00001517          	auipc	a0,0x1
    802002fe:	a6e50513          	addi	a0,a0,-1426 # 80200d68 <etext+0x370>
    80200302:	d69ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
    80200306:	686c                	ld	a1,208(s0)
    80200308:	00001517          	auipc	a0,0x1
    8020030c:	a7850513          	addi	a0,a0,-1416 # 80200d80 <etext+0x388>
    80200310:	d5bff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
    80200314:	6c6c                	ld	a1,216(s0)
    80200316:	00001517          	auipc	a0,0x1
    8020031a:	a8250513          	addi	a0,a0,-1406 # 80200d98 <etext+0x3a0>
    8020031e:	d4dff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
    80200322:	706c                	ld	a1,224(s0)
    80200324:	00001517          	auipc	a0,0x1
    80200328:	a8c50513          	addi	a0,a0,-1396 # 80200db0 <etext+0x3b8>
    8020032c:	d3fff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
    80200330:	746c                	ld	a1,232(s0)
    80200332:	00001517          	auipc	a0,0x1
    80200336:	a9650513          	addi	a0,a0,-1386 # 80200dc8 <etext+0x3d0>
    8020033a:	d31ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
    8020033e:	786c                	ld	a1,240(s0)
    80200340:	00001517          	auipc	a0,0x1
    80200344:	aa050513          	addi	a0,a0,-1376 # 80200de0 <etext+0x3e8>
    80200348:	d23ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
    8020034c:	7c6c                	ld	a1,248(s0)
}
    8020034e:	6402                	ld	s0,0(sp)
    80200350:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
    80200352:	00001517          	auipc	a0,0x1
    80200356:	aa650513          	addi	a0,a0,-1370 # 80200df8 <etext+0x400>
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
    8020036a:	aaa50513          	addi	a0,a0,-1366 # 80200e10 <etext+0x418>
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
    80200382:	aaa50513          	addi	a0,a0,-1366 # 80200e28 <etext+0x430>
    80200386:	ce5ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
    8020038a:	10843583          	ld	a1,264(s0)
    8020038e:	00001517          	auipc	a0,0x1
    80200392:	ab250513          	addi	a0,a0,-1358 # 80200e40 <etext+0x448>
    80200396:	cd5ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  badvaddr 0x%08x\n", tf->badvaddr);
    8020039a:	11043583          	ld	a1,272(s0)
    8020039e:	00001517          	auipc	a0,0x1
    802003a2:	aba50513          	addi	a0,a0,-1350 # 80200e58 <etext+0x460>
    802003a6:	cc5ff0ef          	jal	ra,8020006a <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
    802003aa:	11843583          	ld	a1,280(s0)
}
    802003ae:	6402                	ld	s0,0(sp)
    802003b0:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
    802003b2:	00001517          	auipc	a0,0x1
    802003b6:	abe50513          	addi	a0,a0,-1346 # 80200e70 <etext+0x478>
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
    802003c8:	08f76c63          	bltu	a4,a5,80200460 <interrupt_handler+0xa2>
    802003cc:	00001717          	auipc	a4,0x1
    802003d0:	b6c70713          	addi	a4,a4,-1172 # 80200f38 <etext+0x540>
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
    802003e2:	b0a50513          	addi	a0,a0,-1270 # 80200ee8 <etext+0x4f0>
    802003e6:	b151                	j	8020006a <cprintf>
            cprintf("Hypervisor software interrupt\n");
    802003e8:	00001517          	auipc	a0,0x1
    802003ec:	ae050513          	addi	a0,a0,-1312 # 80200ec8 <etext+0x4d0>
    802003f0:	b9ad                	j	8020006a <cprintf>
            cprintf("User software interrupt\n");
    802003f2:	00001517          	auipc	a0,0x1
    802003f6:	a9650513          	addi	a0,a0,-1386 # 80200e88 <etext+0x490>
    802003fa:	b985                	j	8020006a <cprintf>
            cprintf("Supervisor software interrupt\n");
    802003fc:	00001517          	auipc	a0,0x1
    80200400:	aac50513          	addi	a0,a0,-1364 # 80200ea8 <etext+0x4b0>
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
    80200426:	e705                	bnez	a4,8020044e <interrupt_handler+0x90>
                if(num>=10){
    80200428:	00004417          	auipc	s0,0x4
    8020042c:	bf040413          	addi	s0,s0,-1040 # 80204018 <num>
    80200430:	6018                	ld	a4,0(s0)
    80200432:	47a5                	li	a5,9
    80200434:	02e7e763          	bltu	a5,a4,80200462 <interrupt_handler+0xa4>
    cprintf("%d ticks\n", TICK_NUM);
    80200438:	06400593          	li	a1,100
    8020043c:	00001517          	auipc	a0,0x1
    80200440:	acc50513          	addi	a0,a0,-1332 # 80200f08 <etext+0x510>
    80200444:	c27ff0ef          	jal	ra,8020006a <cprintf>
                    sbi_shutdown();
                }
                print_ticks();
                num++;
    80200448:	601c                	ld	a5,0(s0)
    8020044a:	0785                	addi	a5,a5,1
    8020044c:	e01c                	sd	a5,0(s0)
            break;
        default:
            print_trapframe(tf);
            break;
    }
}
    8020044e:	60a2                	ld	ra,8(sp)
    80200450:	6402                	ld	s0,0(sp)
    80200452:	0141                	addi	sp,sp,16
    80200454:	8082                	ret
            cprintf("Supervisor external interrupt\n");
    80200456:	00001517          	auipc	a0,0x1
    8020045a:	ac250513          	addi	a0,a0,-1342 # 80200f18 <etext+0x520>
    8020045e:	b131                	j	8020006a <cprintf>
            print_trapframe(tf);
    80200460:	bdfd                	j	8020035e <print_trapframe>
                    sbi_shutdown();
    80200462:	54e000ef          	jal	ra,802009b0 <sbi_shutdown>
    80200466:	bfc9                	j	80200438 <interrupt_handler+0x7a>

0000000080200468 <exception_handler>:

void exception_handler(struct trapframe *tf) {
    switch (tf->cause) {
    80200468:	11853783          	ld	a5,280(a0)
void exception_handler(struct trapframe *tf) {
    8020046c:	1141                	addi	sp,sp,-16
    8020046e:	e022                	sd	s0,0(sp)
    80200470:	e406                	sd	ra,8(sp)
    switch (tf->cause) {
    80200472:	470d                	li	a4,3
void exception_handler(struct trapframe *tf) {
    80200474:	842a                	mv	s0,a0
    switch (tf->cause) {
    80200476:	04e78663          	beq	a5,a4,802004c2 <exception_handler+0x5a>
    8020047a:	02f76c63          	bltu	a4,a5,802004b2 <exception_handler+0x4a>
    8020047e:	4709                	li	a4,2
            break;
        case CAUSE_ILLEGAL_INSTRUCTION: 
           // 非法指令异常处理
            /* LAB1 CHALLENGE3   2210643 :  */
                // (1) 输出非法指令异常类型
            cprintf("Exception: Illegal instruction\n");
    80200480:	00001517          	auipc	a0,0x1
    80200484:	ae850513          	addi	a0,a0,-1304 # 80200f68 <etext+0x570>
    switch (tf->cause) {
    80200488:	02e79163          	bne	a5,a4,802004aa <exception_handler+0x42>
                break;
        case CAUSE_BREAKPOINT:
                //断点异常处理
                /* LAB1 CHALLLENGE3   2210643 :  */
                //*(1)输出指令异常类型（ breakpoint）
            cprintf("Exception: breakpoint\n");
    8020048c:	bdfff0ef          	jal	ra,8020006a <cprintf>

               // *(2)输出异常指令地址
            cprintf("Faulting instruction address caught at: 0x%lx\n", tf->epc);
    80200490:	10843583          	ld	a1,264(s0)
    80200494:	00001517          	auipc	a0,0x1
    80200498:	af450513          	addi	a0,a0,-1292 # 80200f88 <etext+0x590>
    8020049c:	bcfff0ef          	jal	ra,8020006a <cprintf>
                //*(3)更新 tf->epc寄存器
            tf->epc += 4;  // 跳过这条非法指令
    802004a0:	10843783          	ld	a5,264(s0)
    802004a4:	0791                	addi	a5,a5,4
    802004a6:	10f43423          	sd	a5,264(s0)
            break;
        default:
            print_trapframe(tf);
            break;
    }
}
    802004aa:	60a2                	ld	ra,8(sp)
    802004ac:	6402                	ld	s0,0(sp)
    802004ae:	0141                	addi	sp,sp,16
    802004b0:	8082                	ret
    switch (tf->cause) {
    802004b2:	17f1                	addi	a5,a5,-4
    802004b4:	471d                	li	a4,7
    802004b6:	fef77ae3          	bgeu	a4,a5,802004aa <exception_handler+0x42>
}
    802004ba:	6402                	ld	s0,0(sp)
    802004bc:	60a2                	ld	ra,8(sp)
    802004be:	0141                	addi	sp,sp,16
            print_trapframe(tf);
    802004c0:	bd79                	j	8020035e <print_trapframe>
            cprintf("Exception: breakpoint\n");
    802004c2:	00001517          	auipc	a0,0x1
    802004c6:	af650513          	addi	a0,a0,-1290 # 80200fb8 <etext+0x5c0>
    802004ca:	b7c9                	j	8020048c <exception_handler+0x24>

00000000802004cc <trap>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static inline void trap_dispatch(struct trapframe *tf) {
    if ((intptr_t)tf->cause < 0) {
    802004cc:	11853783          	ld	a5,280(a0)
    802004d0:	0007c363          	bltz	a5,802004d6 <trap+0xa>
        // interrupts
        interrupt_handler(tf);
    } else {
        // exceptions
        exception_handler(tf);
    802004d4:	bf51                	j	80200468 <exception_handler>
        interrupt_handler(tf);
    802004d6:	b5e5                	j	802003be <interrupt_handler>

00000000802004d8 <__alltraps>:
    802004d8:	14011073          	csrw	sscratch,sp
    802004dc:	712d                	addi	sp,sp,-288
    802004de:	e002                	sd	zero,0(sp)
    802004e0:	e406                	sd	ra,8(sp)
    802004e2:	ec0e                	sd	gp,24(sp)
    802004e4:	f012                	sd	tp,32(sp)
    802004e6:	f416                	sd	t0,40(sp)
    802004e8:	f81a                	sd	t1,48(sp)
    802004ea:	fc1e                	sd	t2,56(sp)
    802004ec:	e0a2                	sd	s0,64(sp)
    802004ee:	e4a6                	sd	s1,72(sp)
    802004f0:	e8aa                	sd	a0,80(sp)
    802004f2:	ecae                	sd	a1,88(sp)
    802004f4:	f0b2                	sd	a2,96(sp)
    802004f6:	f4b6                	sd	a3,104(sp)
    802004f8:	f8ba                	sd	a4,112(sp)
    802004fa:	fcbe                	sd	a5,120(sp)
    802004fc:	e142                	sd	a6,128(sp)
    802004fe:	e546                	sd	a7,136(sp)
    80200500:	e94a                	sd	s2,144(sp)
    80200502:	ed4e                	sd	s3,152(sp)
    80200504:	f152                	sd	s4,160(sp)
    80200506:	f556                	sd	s5,168(sp)
    80200508:	f95a                	sd	s6,176(sp)
    8020050a:	fd5e                	sd	s7,184(sp)
    8020050c:	e1e2                	sd	s8,192(sp)
    8020050e:	e5e6                	sd	s9,200(sp)
    80200510:	e9ea                	sd	s10,208(sp)
    80200512:	edee                	sd	s11,216(sp)
    80200514:	f1f2                	sd	t3,224(sp)
    80200516:	f5f6                	sd	t4,232(sp)
    80200518:	f9fa                	sd	t5,240(sp)
    8020051a:	fdfe                	sd	t6,248(sp)
    8020051c:	14001473          	csrrw	s0,sscratch,zero
    80200520:	100024f3          	csrr	s1,sstatus
    80200524:	14102973          	csrr	s2,sepc
    80200528:	143029f3          	csrr	s3,stval
    8020052c:	14202a73          	csrr	s4,scause
    80200530:	e822                	sd	s0,16(sp)
    80200532:	e226                	sd	s1,256(sp)
    80200534:	e64a                	sd	s2,264(sp)
    80200536:	ea4e                	sd	s3,272(sp)
    80200538:	ee52                	sd	s4,280(sp)
    8020053a:	850a                	mv	a0,sp
    8020053c:	f91ff0ef          	jal	ra,802004cc <trap>

0000000080200540 <__trapret>:
    80200540:	6492                	ld	s1,256(sp)
    80200542:	6932                	ld	s2,264(sp)
    80200544:	10049073          	csrw	sstatus,s1
    80200548:	14191073          	csrw	sepc,s2
    8020054c:	60a2                	ld	ra,8(sp)
    8020054e:	61e2                	ld	gp,24(sp)
    80200550:	7202                	ld	tp,32(sp)
    80200552:	72a2                	ld	t0,40(sp)
    80200554:	7342                	ld	t1,48(sp)
    80200556:	73e2                	ld	t2,56(sp)
    80200558:	6406                	ld	s0,64(sp)
    8020055a:	64a6                	ld	s1,72(sp)
    8020055c:	6546                	ld	a0,80(sp)
    8020055e:	65e6                	ld	a1,88(sp)
    80200560:	7606                	ld	a2,96(sp)
    80200562:	76a6                	ld	a3,104(sp)
    80200564:	7746                	ld	a4,112(sp)
    80200566:	77e6                	ld	a5,120(sp)
    80200568:	680a                	ld	a6,128(sp)
    8020056a:	68aa                	ld	a7,136(sp)
    8020056c:	694a                	ld	s2,144(sp)
    8020056e:	69ea                	ld	s3,152(sp)
    80200570:	7a0a                	ld	s4,160(sp)
    80200572:	7aaa                	ld	s5,168(sp)
    80200574:	7b4a                	ld	s6,176(sp)
    80200576:	7bea                	ld	s7,184(sp)
    80200578:	6c0e                	ld	s8,192(sp)
    8020057a:	6cae                	ld	s9,200(sp)
    8020057c:	6d4e                	ld	s10,208(sp)
    8020057e:	6dee                	ld	s11,216(sp)
    80200580:	7e0e                	ld	t3,224(sp)
    80200582:	7eae                	ld	t4,232(sp)
    80200584:	7f4e                	ld	t5,240(sp)
    80200586:	7fee                	ld	t6,248(sp)
    80200588:	6142                	ld	sp,16(sp)
    8020058a:	10200073          	sret

000000008020058e <printnum>:
    8020058e:	02069813          	slli	a6,a3,0x20
    80200592:	7179                	addi	sp,sp,-48
    80200594:	02085813          	srli	a6,a6,0x20
    80200598:	e052                	sd	s4,0(sp)
    8020059a:	03067a33          	remu	s4,a2,a6
    8020059e:	f022                	sd	s0,32(sp)
    802005a0:	ec26                	sd	s1,24(sp)
    802005a2:	e84a                	sd	s2,16(sp)
    802005a4:	f406                	sd	ra,40(sp)
    802005a6:	e44e                	sd	s3,8(sp)
    802005a8:	84aa                	mv	s1,a0
    802005aa:	892e                	mv	s2,a1
    802005ac:	fff7041b          	addiw	s0,a4,-1
    802005b0:	2a01                	sext.w	s4,s4
    802005b2:	03067e63          	bgeu	a2,a6,802005ee <printnum+0x60>
    802005b6:	89be                	mv	s3,a5
    802005b8:	00805763          	blez	s0,802005c6 <printnum+0x38>
    802005bc:	347d                	addiw	s0,s0,-1
    802005be:	85ca                	mv	a1,s2
    802005c0:	854e                	mv	a0,s3
    802005c2:	9482                	jalr	s1
    802005c4:	fc65                	bnez	s0,802005bc <printnum+0x2e>
    802005c6:	1a02                	slli	s4,s4,0x20
    802005c8:	00001797          	auipc	a5,0x1
    802005cc:	a0878793          	addi	a5,a5,-1528 # 80200fd0 <etext+0x5d8>
    802005d0:	020a5a13          	srli	s4,s4,0x20
    802005d4:	9a3e                	add	s4,s4,a5
    802005d6:	7402                	ld	s0,32(sp)
    802005d8:	000a4503          	lbu	a0,0(s4)
    802005dc:	70a2                	ld	ra,40(sp)
    802005de:	69a2                	ld	s3,8(sp)
    802005e0:	6a02                	ld	s4,0(sp)
    802005e2:	85ca                	mv	a1,s2
    802005e4:	87a6                	mv	a5,s1
    802005e6:	6942                	ld	s2,16(sp)
    802005e8:	64e2                	ld	s1,24(sp)
    802005ea:	6145                	addi	sp,sp,48
    802005ec:	8782                	jr	a5
    802005ee:	03065633          	divu	a2,a2,a6
    802005f2:	8722                	mv	a4,s0
    802005f4:	f9bff0ef          	jal	ra,8020058e <printnum>
    802005f8:	b7f9                	j	802005c6 <printnum+0x38>

00000000802005fa <vprintfmt>:
    802005fa:	7119                	addi	sp,sp,-128
    802005fc:	f4a6                	sd	s1,104(sp)
    802005fe:	f0ca                	sd	s2,96(sp)
    80200600:	ecce                	sd	s3,88(sp)
    80200602:	e8d2                	sd	s4,80(sp)
    80200604:	e4d6                	sd	s5,72(sp)
    80200606:	e0da                	sd	s6,64(sp)
    80200608:	fc5e                	sd	s7,56(sp)
    8020060a:	f06a                	sd	s10,32(sp)
    8020060c:	fc86                	sd	ra,120(sp)
    8020060e:	f8a2                	sd	s0,112(sp)
    80200610:	f862                	sd	s8,48(sp)
    80200612:	f466                	sd	s9,40(sp)
    80200614:	ec6e                	sd	s11,24(sp)
    80200616:	892a                	mv	s2,a0
    80200618:	84ae                	mv	s1,a1
    8020061a:	8d32                	mv	s10,a2
    8020061c:	8a36                	mv	s4,a3
    8020061e:	02500993          	li	s3,37
    80200622:	5b7d                	li	s6,-1
    80200624:	00001a97          	auipc	s5,0x1
    80200628:	9e0a8a93          	addi	s5,s5,-1568 # 80201004 <etext+0x60c>
    8020062c:	00001b97          	auipc	s7,0x1
    80200630:	bb4b8b93          	addi	s7,s7,-1100 # 802011e0 <error_string>
    80200634:	000d4503          	lbu	a0,0(s10)
    80200638:	001d0413          	addi	s0,s10,1
    8020063c:	01350a63          	beq	a0,s3,80200650 <vprintfmt+0x56>
    80200640:	c121                	beqz	a0,80200680 <vprintfmt+0x86>
    80200642:	85a6                	mv	a1,s1
    80200644:	0405                	addi	s0,s0,1
    80200646:	9902                	jalr	s2
    80200648:	fff44503          	lbu	a0,-1(s0)
    8020064c:	ff351ae3          	bne	a0,s3,80200640 <vprintfmt+0x46>
    80200650:	00044603          	lbu	a2,0(s0)
    80200654:	02000793          	li	a5,32
    80200658:	4c81                	li	s9,0
    8020065a:	4881                	li	a7,0
    8020065c:	5c7d                	li	s8,-1
    8020065e:	5dfd                	li	s11,-1
    80200660:	05500513          	li	a0,85
    80200664:	4825                	li	a6,9
    80200666:	fdd6059b          	addiw	a1,a2,-35
    8020066a:	0ff5f593          	zext.b	a1,a1
    8020066e:	00140d13          	addi	s10,s0,1
    80200672:	04b56263          	bltu	a0,a1,802006b6 <vprintfmt+0xbc>
    80200676:	058a                	slli	a1,a1,0x2
    80200678:	95d6                	add	a1,a1,s5
    8020067a:	4194                	lw	a3,0(a1)
    8020067c:	96d6                	add	a3,a3,s5
    8020067e:	8682                	jr	a3
    80200680:	70e6                	ld	ra,120(sp)
    80200682:	7446                	ld	s0,112(sp)
    80200684:	74a6                	ld	s1,104(sp)
    80200686:	7906                	ld	s2,96(sp)
    80200688:	69e6                	ld	s3,88(sp)
    8020068a:	6a46                	ld	s4,80(sp)
    8020068c:	6aa6                	ld	s5,72(sp)
    8020068e:	6b06                	ld	s6,64(sp)
    80200690:	7be2                	ld	s7,56(sp)
    80200692:	7c42                	ld	s8,48(sp)
    80200694:	7ca2                	ld	s9,40(sp)
    80200696:	7d02                	ld	s10,32(sp)
    80200698:	6de2                	ld	s11,24(sp)
    8020069a:	6109                	addi	sp,sp,128
    8020069c:	8082                	ret
    8020069e:	87b2                	mv	a5,a2
    802006a0:	00144603          	lbu	a2,1(s0)
    802006a4:	846a                	mv	s0,s10
    802006a6:	00140d13          	addi	s10,s0,1
    802006aa:	fdd6059b          	addiw	a1,a2,-35
    802006ae:	0ff5f593          	zext.b	a1,a1
    802006b2:	fcb572e3          	bgeu	a0,a1,80200676 <vprintfmt+0x7c>
    802006b6:	85a6                	mv	a1,s1
    802006b8:	02500513          	li	a0,37
    802006bc:	9902                	jalr	s2
    802006be:	fff44783          	lbu	a5,-1(s0)
    802006c2:	8d22                	mv	s10,s0
    802006c4:	f73788e3          	beq	a5,s3,80200634 <vprintfmt+0x3a>
    802006c8:	ffed4783          	lbu	a5,-2(s10)
    802006cc:	1d7d                	addi	s10,s10,-1
    802006ce:	ff379de3          	bne	a5,s3,802006c8 <vprintfmt+0xce>
    802006d2:	b78d                	j	80200634 <vprintfmt+0x3a>
    802006d4:	fd060c1b          	addiw	s8,a2,-48
    802006d8:	00144603          	lbu	a2,1(s0)
    802006dc:	846a                	mv	s0,s10
    802006de:	fd06069b          	addiw	a3,a2,-48
    802006e2:	0006059b          	sext.w	a1,a2
    802006e6:	02d86463          	bltu	a6,a3,8020070e <vprintfmt+0x114>
    802006ea:	00144603          	lbu	a2,1(s0)
    802006ee:	002c169b          	slliw	a3,s8,0x2
    802006f2:	0186873b          	addw	a4,a3,s8
    802006f6:	0017171b          	slliw	a4,a4,0x1
    802006fa:	9f2d                	addw	a4,a4,a1
    802006fc:	fd06069b          	addiw	a3,a2,-48
    80200700:	0405                	addi	s0,s0,1
    80200702:	fd070c1b          	addiw	s8,a4,-48
    80200706:	0006059b          	sext.w	a1,a2
    8020070a:	fed870e3          	bgeu	a6,a3,802006ea <vprintfmt+0xf0>
    8020070e:	f40ddce3          	bgez	s11,80200666 <vprintfmt+0x6c>
    80200712:	8de2                	mv	s11,s8
    80200714:	5c7d                	li	s8,-1
    80200716:	bf81                	j	80200666 <vprintfmt+0x6c>
    80200718:	fffdc693          	not	a3,s11
    8020071c:	96fd                	srai	a3,a3,0x3f
    8020071e:	00ddfdb3          	and	s11,s11,a3
    80200722:	00144603          	lbu	a2,1(s0)
    80200726:	2d81                	sext.w	s11,s11
    80200728:	846a                	mv	s0,s10
    8020072a:	bf35                	j	80200666 <vprintfmt+0x6c>
    8020072c:	000a2c03          	lw	s8,0(s4)
    80200730:	00144603          	lbu	a2,1(s0)
    80200734:	0a21                	addi	s4,s4,8
    80200736:	846a                	mv	s0,s10
    80200738:	bfd9                	j	8020070e <vprintfmt+0x114>
    8020073a:	4705                	li	a4,1
    8020073c:	008a0593          	addi	a1,s4,8
    80200740:	01174463          	blt	a4,a7,80200748 <vprintfmt+0x14e>
    80200744:	1a088e63          	beqz	a7,80200900 <vprintfmt+0x306>
    80200748:	000a3603          	ld	a2,0(s4)
    8020074c:	46c1                	li	a3,16
    8020074e:	8a2e                	mv	s4,a1
    80200750:	2781                	sext.w	a5,a5
    80200752:	876e                	mv	a4,s11
    80200754:	85a6                	mv	a1,s1
    80200756:	854a                	mv	a0,s2
    80200758:	e37ff0ef          	jal	ra,8020058e <printnum>
    8020075c:	bde1                	j	80200634 <vprintfmt+0x3a>
    8020075e:	000a2503          	lw	a0,0(s4)
    80200762:	85a6                	mv	a1,s1
    80200764:	0a21                	addi	s4,s4,8
    80200766:	9902                	jalr	s2
    80200768:	b5f1                	j	80200634 <vprintfmt+0x3a>
    8020076a:	4705                	li	a4,1
    8020076c:	008a0593          	addi	a1,s4,8
    80200770:	01174463          	blt	a4,a7,80200778 <vprintfmt+0x17e>
    80200774:	18088163          	beqz	a7,802008f6 <vprintfmt+0x2fc>
    80200778:	000a3603          	ld	a2,0(s4)
    8020077c:	46a9                	li	a3,10
    8020077e:	8a2e                	mv	s4,a1
    80200780:	bfc1                	j	80200750 <vprintfmt+0x156>
    80200782:	00144603          	lbu	a2,1(s0)
    80200786:	4c85                	li	s9,1
    80200788:	846a                	mv	s0,s10
    8020078a:	bdf1                	j	80200666 <vprintfmt+0x6c>
    8020078c:	85a6                	mv	a1,s1
    8020078e:	02500513          	li	a0,37
    80200792:	9902                	jalr	s2
    80200794:	b545                	j	80200634 <vprintfmt+0x3a>
    80200796:	00144603          	lbu	a2,1(s0)
    8020079a:	2885                	addiw	a7,a7,1
    8020079c:	846a                	mv	s0,s10
    8020079e:	b5e1                	j	80200666 <vprintfmt+0x6c>
    802007a0:	4705                	li	a4,1
    802007a2:	008a0593          	addi	a1,s4,8
    802007a6:	01174463          	blt	a4,a7,802007ae <vprintfmt+0x1b4>
    802007aa:	14088163          	beqz	a7,802008ec <vprintfmt+0x2f2>
    802007ae:	000a3603          	ld	a2,0(s4)
    802007b2:	46a1                	li	a3,8
    802007b4:	8a2e                	mv	s4,a1
    802007b6:	bf69                	j	80200750 <vprintfmt+0x156>
    802007b8:	03000513          	li	a0,48
    802007bc:	85a6                	mv	a1,s1
    802007be:	e03e                	sd	a5,0(sp)
    802007c0:	9902                	jalr	s2
    802007c2:	85a6                	mv	a1,s1
    802007c4:	07800513          	li	a0,120
    802007c8:	9902                	jalr	s2
    802007ca:	0a21                	addi	s4,s4,8
    802007cc:	6782                	ld	a5,0(sp)
    802007ce:	46c1                	li	a3,16
    802007d0:	ff8a3603          	ld	a2,-8(s4)
    802007d4:	bfb5                	j	80200750 <vprintfmt+0x156>
    802007d6:	000a3403          	ld	s0,0(s4)
    802007da:	008a0713          	addi	a4,s4,8
    802007de:	e03a                	sd	a4,0(sp)
    802007e0:	14040263          	beqz	s0,80200924 <vprintfmt+0x32a>
    802007e4:	0fb05763          	blez	s11,802008d2 <vprintfmt+0x2d8>
    802007e8:	02d00693          	li	a3,45
    802007ec:	0cd79163          	bne	a5,a3,802008ae <vprintfmt+0x2b4>
    802007f0:	00044783          	lbu	a5,0(s0)
    802007f4:	0007851b          	sext.w	a0,a5
    802007f8:	cf85                	beqz	a5,80200830 <vprintfmt+0x236>
    802007fa:	00140a13          	addi	s4,s0,1
    802007fe:	05e00413          	li	s0,94
    80200802:	000c4563          	bltz	s8,8020080c <vprintfmt+0x212>
    80200806:	3c7d                	addiw	s8,s8,-1
    80200808:	036c0263          	beq	s8,s6,8020082c <vprintfmt+0x232>
    8020080c:	85a6                	mv	a1,s1
    8020080e:	0e0c8e63          	beqz	s9,8020090a <vprintfmt+0x310>
    80200812:	3781                	addiw	a5,a5,-32
    80200814:	0ef47b63          	bgeu	s0,a5,8020090a <vprintfmt+0x310>
    80200818:	03f00513          	li	a0,63
    8020081c:	9902                	jalr	s2
    8020081e:	000a4783          	lbu	a5,0(s4)
    80200822:	3dfd                	addiw	s11,s11,-1
    80200824:	0a05                	addi	s4,s4,1
    80200826:	0007851b          	sext.w	a0,a5
    8020082a:	ffe1                	bnez	a5,80200802 <vprintfmt+0x208>
    8020082c:	01b05963          	blez	s11,8020083e <vprintfmt+0x244>
    80200830:	3dfd                	addiw	s11,s11,-1
    80200832:	85a6                	mv	a1,s1
    80200834:	02000513          	li	a0,32
    80200838:	9902                	jalr	s2
    8020083a:	fe0d9be3          	bnez	s11,80200830 <vprintfmt+0x236>
    8020083e:	6a02                	ld	s4,0(sp)
    80200840:	bbd5                	j	80200634 <vprintfmt+0x3a>
    80200842:	4705                	li	a4,1
    80200844:	008a0c93          	addi	s9,s4,8
    80200848:	01174463          	blt	a4,a7,80200850 <vprintfmt+0x256>
    8020084c:	08088d63          	beqz	a7,802008e6 <vprintfmt+0x2ec>
    80200850:	000a3403          	ld	s0,0(s4)
    80200854:	0a044d63          	bltz	s0,8020090e <vprintfmt+0x314>
    80200858:	8622                	mv	a2,s0
    8020085a:	8a66                	mv	s4,s9
    8020085c:	46a9                	li	a3,10
    8020085e:	bdcd                	j	80200750 <vprintfmt+0x156>
    80200860:	000a2783          	lw	a5,0(s4)
    80200864:	4719                	li	a4,6
    80200866:	0a21                	addi	s4,s4,8
    80200868:	41f7d69b          	sraiw	a3,a5,0x1f
    8020086c:	8fb5                	xor	a5,a5,a3
    8020086e:	40d786bb          	subw	a3,a5,a3
    80200872:	02d74163          	blt	a4,a3,80200894 <vprintfmt+0x29a>
    80200876:	00369793          	slli	a5,a3,0x3
    8020087a:	97de                	add	a5,a5,s7
    8020087c:	639c                	ld	a5,0(a5)
    8020087e:	cb99                	beqz	a5,80200894 <vprintfmt+0x29a>
    80200880:	86be                	mv	a3,a5
    80200882:	00000617          	auipc	a2,0x0
    80200886:	77e60613          	addi	a2,a2,1918 # 80201000 <etext+0x608>
    8020088a:	85a6                	mv	a1,s1
    8020088c:	854a                	mv	a0,s2
    8020088e:	0ce000ef          	jal	ra,8020095c <printfmt>
    80200892:	b34d                	j	80200634 <vprintfmt+0x3a>
    80200894:	00000617          	auipc	a2,0x0
    80200898:	75c60613          	addi	a2,a2,1884 # 80200ff0 <etext+0x5f8>
    8020089c:	85a6                	mv	a1,s1
    8020089e:	854a                	mv	a0,s2
    802008a0:	0bc000ef          	jal	ra,8020095c <printfmt>
    802008a4:	bb41                	j	80200634 <vprintfmt+0x3a>
    802008a6:	00000417          	auipc	s0,0x0
    802008aa:	74240413          	addi	s0,s0,1858 # 80200fe8 <etext+0x5f0>
    802008ae:	85e2                	mv	a1,s8
    802008b0:	8522                	mv	a0,s0
    802008b2:	e43e                	sd	a5,8(sp)
    802008b4:	116000ef          	jal	ra,802009ca <strnlen>
    802008b8:	40ad8dbb          	subw	s11,s11,a0
    802008bc:	01b05b63          	blez	s11,802008d2 <vprintfmt+0x2d8>
    802008c0:	67a2                	ld	a5,8(sp)
    802008c2:	00078a1b          	sext.w	s4,a5
    802008c6:	3dfd                	addiw	s11,s11,-1
    802008c8:	85a6                	mv	a1,s1
    802008ca:	8552                	mv	a0,s4
    802008cc:	9902                	jalr	s2
    802008ce:	fe0d9ce3          	bnez	s11,802008c6 <vprintfmt+0x2cc>
    802008d2:	00044783          	lbu	a5,0(s0)
    802008d6:	00140a13          	addi	s4,s0,1
    802008da:	0007851b          	sext.w	a0,a5
    802008de:	d3a5                	beqz	a5,8020083e <vprintfmt+0x244>
    802008e0:	05e00413          	li	s0,94
    802008e4:	bf39                	j	80200802 <vprintfmt+0x208>
    802008e6:	000a2403          	lw	s0,0(s4)
    802008ea:	b7ad                	j	80200854 <vprintfmt+0x25a>
    802008ec:	000a6603          	lwu	a2,0(s4)
    802008f0:	46a1                	li	a3,8
    802008f2:	8a2e                	mv	s4,a1
    802008f4:	bdb1                	j	80200750 <vprintfmt+0x156>
    802008f6:	000a6603          	lwu	a2,0(s4)
    802008fa:	46a9                	li	a3,10
    802008fc:	8a2e                	mv	s4,a1
    802008fe:	bd89                	j	80200750 <vprintfmt+0x156>
    80200900:	000a6603          	lwu	a2,0(s4)
    80200904:	46c1                	li	a3,16
    80200906:	8a2e                	mv	s4,a1
    80200908:	b5a1                	j	80200750 <vprintfmt+0x156>
    8020090a:	9902                	jalr	s2
    8020090c:	bf09                	j	8020081e <vprintfmt+0x224>
    8020090e:	85a6                	mv	a1,s1
    80200910:	02d00513          	li	a0,45
    80200914:	e03e                	sd	a5,0(sp)
    80200916:	9902                	jalr	s2
    80200918:	6782                	ld	a5,0(sp)
    8020091a:	8a66                	mv	s4,s9
    8020091c:	40800633          	neg	a2,s0
    80200920:	46a9                	li	a3,10
    80200922:	b53d                	j	80200750 <vprintfmt+0x156>
    80200924:	03b05163          	blez	s11,80200946 <vprintfmt+0x34c>
    80200928:	02d00693          	li	a3,45
    8020092c:	f6d79de3          	bne	a5,a3,802008a6 <vprintfmt+0x2ac>
    80200930:	00000417          	auipc	s0,0x0
    80200934:	6b840413          	addi	s0,s0,1720 # 80200fe8 <etext+0x5f0>
    80200938:	02800793          	li	a5,40
    8020093c:	02800513          	li	a0,40
    80200940:	00140a13          	addi	s4,s0,1
    80200944:	bd6d                	j	802007fe <vprintfmt+0x204>
    80200946:	00000a17          	auipc	s4,0x0
    8020094a:	6a3a0a13          	addi	s4,s4,1699 # 80200fe9 <etext+0x5f1>
    8020094e:	02800513          	li	a0,40
    80200952:	02800793          	li	a5,40
    80200956:	05e00413          	li	s0,94
    8020095a:	b565                	j	80200802 <vprintfmt+0x208>

000000008020095c <printfmt>:
    8020095c:	715d                	addi	sp,sp,-80
    8020095e:	02810313          	addi	t1,sp,40
    80200962:	f436                	sd	a3,40(sp)
    80200964:	869a                	mv	a3,t1
    80200966:	ec06                	sd	ra,24(sp)
    80200968:	f83a                	sd	a4,48(sp)
    8020096a:	fc3e                	sd	a5,56(sp)
    8020096c:	e0c2                	sd	a6,64(sp)
    8020096e:	e4c6                	sd	a7,72(sp)
    80200970:	e41a                	sd	t1,8(sp)
    80200972:	c89ff0ef          	jal	ra,802005fa <vprintfmt>
    80200976:	60e2                	ld	ra,24(sp)
    80200978:	6161                	addi	sp,sp,80
    8020097a:	8082                	ret

000000008020097c <sbi_console_putchar>:
    8020097c:	4781                	li	a5,0
    8020097e:	00003717          	auipc	a4,0x3
    80200982:	68273703          	ld	a4,1666(a4) # 80204000 <SBI_CONSOLE_PUTCHAR>
    80200986:	88ba                	mv	a7,a4
    80200988:	852a                	mv	a0,a0
    8020098a:	85be                	mv	a1,a5
    8020098c:	863e                	mv	a2,a5
    8020098e:	00000073          	ecall
    80200992:	87aa                	mv	a5,a0
    80200994:	8082                	ret

0000000080200996 <sbi_set_timer>:
    80200996:	4781                	li	a5,0
    80200998:	00003717          	auipc	a4,0x3
    8020099c:	68873703          	ld	a4,1672(a4) # 80204020 <SBI_SET_TIMER>
    802009a0:	88ba                	mv	a7,a4
    802009a2:	852a                	mv	a0,a0
    802009a4:	85be                	mv	a1,a5
    802009a6:	863e                	mv	a2,a5
    802009a8:	00000073          	ecall
    802009ac:	87aa                	mv	a5,a0
    802009ae:	8082                	ret

00000000802009b0 <sbi_shutdown>:
    802009b0:	4781                	li	a5,0
    802009b2:	00003717          	auipc	a4,0x3
    802009b6:	65673703          	ld	a4,1622(a4) # 80204008 <SBI_SHUTDOWN>
    802009ba:	88ba                	mv	a7,a4
    802009bc:	853e                	mv	a0,a5
    802009be:	85be                	mv	a1,a5
    802009c0:	863e                	mv	a2,a5
    802009c2:	00000073          	ecall
    802009c6:	87aa                	mv	a5,a0
    802009c8:	8082                	ret

00000000802009ca <strnlen>:
    802009ca:	4781                	li	a5,0
    802009cc:	e589                	bnez	a1,802009d6 <strnlen+0xc>
    802009ce:	a811                	j	802009e2 <strnlen+0x18>
    802009d0:	0785                	addi	a5,a5,1
    802009d2:	00f58863          	beq	a1,a5,802009e2 <strnlen+0x18>
    802009d6:	00f50733          	add	a4,a0,a5
    802009da:	00074703          	lbu	a4,0(a4)
    802009de:	fb6d                	bnez	a4,802009d0 <strnlen+0x6>
    802009e0:	85be                	mv	a1,a5
    802009e2:	852e                	mv	a0,a1
    802009e4:	8082                	ret

00000000802009e6 <memset>:
    802009e6:	ca01                	beqz	a2,802009f6 <memset+0x10>
    802009e8:	962a                	add	a2,a2,a0
    802009ea:	87aa                	mv	a5,a0
    802009ec:	0785                	addi	a5,a5,1
    802009ee:	feb78fa3          	sb	a1,-1(a5)
    802009f2:	fec79de3          	bne	a5,a2,802009ec <memset+0x6>
    802009f6:	8082                	ret
