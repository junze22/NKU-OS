
bin/kernel：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000080200000 <kern_entry>:
#include <memlayout.h>

    .section .text,"ax",%progbits
    .globl kern_entry
kern_entry:
    la sp, bootstacktop
    80200000:	00004117          	auipc	sp,0x4
    80200004:	00010113          	mv	sp,sp

    tail kern_init
    80200008:	a009                	j	8020000a <kern_init>

000000008020000a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);

int kern_init(void) {
    extern char edata[], end[];
    memset(edata, 0, end - edata);
    8020000a:	00004517          	auipc	a0,0x4
    8020000e:	ffe50513          	addi	a0,a0,-2 # 80204008 <ticks>
    80200012:	00004617          	auipc	a2,0x4
    80200016:	00660613          	addi	a2,a2,6 # 80204018 <end>
int kern_init(void) {
    8020001a:	1141                	addi	sp,sp,-16
    memset(edata, 0, end - edata);
    8020001c:	8e09                	sub	a2,a2,a0
    8020001e:	4581                	li	a1,0
int kern_init(void) {
    80200020:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
    80200022:	504000ef          	jal	ra,80200526 <memset>

    cons_init();  // init the console初始化控制台
    80200026:	146000ef          	jal	ra,8020016c <cons_init>

    const char *message = "(THU.CST) os is loading ...\n";
    cprintf("%s\n\n", message);
    8020002a:	00001597          	auipc	a1,0x1
    8020002e:	93658593          	addi	a1,a1,-1738 # 80200960 <etext+0x6>
    80200032:	00001517          	auipc	a0,0x1
    80200036:	94e50513          	addi	a0,a0,-1714 # 80200980 <etext+0x26>
    8020003a:	02c000ef          	jal	ra,80200066 <cprintf>

    print_kerninfo();//打印内核信息
    8020003e:	05e000ef          	jal	ra,8020009c <print_kerninfo>

    // grade_backtrace();
    //trap.h的函数，初始化中断
    idt_init();  // init interrupt descriptor table
    80200042:	134000ef          	jal	ra,80200176 <idt_init>
                 // 初始化中断描述符表（IDT）

    // rdtime in mbare mode crashes
    //clock.h的函数，初始化时钟中断
    clock_init();  // init clock interrupt
    80200046:	0e4000ef          	jal	ra,8020012a <clock_init>
    //初始化时钟中断

    //intr.h的函数，使能中断
    ////intr_enable();  // enable irq interrupt
    //调用intr_enable函数启用中断请求（IRQ）
    while (1)
    8020004a:	a001                	j	8020004a <kern_init+0x40>

000000008020004c <cputch>:

/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void cputch(int c, int *cnt) {
    8020004c:	1141                	addi	sp,sp,-16
    8020004e:	e022                	sd	s0,0(sp)
    80200050:	e406                	sd	ra,8(sp)
    80200052:	842e                	mv	s0,a1
    cons_putc(c);
    80200054:	11a000ef          	jal	ra,8020016e <cons_putc>
    (*cnt)++;
    80200058:	401c                	lw	a5,0(s0)
}
    8020005a:	60a2                	ld	ra,8(sp)
    (*cnt)++;
    8020005c:	2785                	addiw	a5,a5,1
    8020005e:	c01c                	sw	a5,0(s0)
}
    80200060:	6402                	ld	s0,0(sp)
    80200062:	0141                	addi	sp,sp,16
    80200064:	8082                	ret

0000000080200066 <cprintf>:
 * cprintf - formats a string and writes it to stdout
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int cprintf(const char *fmt, ...) {
    80200066:	711d                	addi	sp,sp,-96
    va_list ap;
    int cnt;
    va_start(ap, fmt);
    80200068:	02810313          	addi	t1,sp,40 # 80204028 <end+0x10>
int cprintf(const char *fmt, ...) {
    8020006c:	8e2a                	mv	t3,a0
    8020006e:	f42e                	sd	a1,40(sp)
    80200070:	f832                	sd	a2,48(sp)
    80200072:	fc36                	sd	a3,56(sp)
    vprintfmt((void *)cputch, &cnt, fmt, ap);
    80200074:	00000517          	auipc	a0,0x0
    80200078:	fd850513          	addi	a0,a0,-40 # 8020004c <cputch>
    8020007c:	004c                	addi	a1,sp,4
    8020007e:	869a                	mv	a3,t1
    80200080:	8672                	mv	a2,t3
int cprintf(const char *fmt, ...) {
    80200082:	ec06                	sd	ra,24(sp)
    80200084:	e0ba                	sd	a4,64(sp)
    80200086:	e4be                	sd	a5,72(sp)
    80200088:	e8c2                	sd	a6,80(sp)
    8020008a:	ecc6                	sd	a7,88(sp)
    va_start(ap, fmt);
    8020008c:	e41a                	sd	t1,8(sp)
    int cnt = 0;
    8020008e:	c202                	sw	zero,4(sp)
    vprintfmt((void *)cputch, &cnt, fmt, ap);
    80200090:	514000ef          	jal	ra,802005a4 <vprintfmt>
    cnt = vcprintf(fmt, ap);
    va_end(ap);
    return cnt;
}
    80200094:	60e2                	ld	ra,24(sp)
    80200096:	4512                	lw	a0,4(sp)
    80200098:	6125                	addi	sp,sp,96
    8020009a:	8082                	ret

000000008020009c <print_kerninfo>:
/* *
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void) {
    8020009c:	1141                	addi	sp,sp,-16
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
    8020009e:	00001517          	auipc	a0,0x1
    802000a2:	8ea50513          	addi	a0,a0,-1814 # 80200988 <etext+0x2e>
void print_kerninfo(void) {
    802000a6:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
    802000a8:	fbfff0ef          	jal	ra,80200066 <cprintf>
    cprintf("  entry  0x%016x (virtual)\n", kern_init);
    802000ac:	00000597          	auipc	a1,0x0
    802000b0:	f5e58593          	addi	a1,a1,-162 # 8020000a <kern_init>
    802000b4:	00001517          	auipc	a0,0x1
    802000b8:	8f450513          	addi	a0,a0,-1804 # 802009a8 <etext+0x4e>
    802000bc:	fabff0ef          	jal	ra,80200066 <cprintf>
    cprintf("  etext  0x%016x (virtual)\n", etext);
    802000c0:	00001597          	auipc	a1,0x1
    802000c4:	89a58593          	addi	a1,a1,-1894 # 8020095a <etext>
    802000c8:	00001517          	auipc	a0,0x1
    802000cc:	90050513          	addi	a0,a0,-1792 # 802009c8 <etext+0x6e>
    802000d0:	f97ff0ef          	jal	ra,80200066 <cprintf>
    cprintf("  edata  0x%016x (virtual)\n", edata);
    802000d4:	00004597          	auipc	a1,0x4
    802000d8:	f3458593          	addi	a1,a1,-204 # 80204008 <ticks>
    802000dc:	00001517          	auipc	a0,0x1
    802000e0:	90c50513          	addi	a0,a0,-1780 # 802009e8 <etext+0x8e>
    802000e4:	f83ff0ef          	jal	ra,80200066 <cprintf>
    cprintf("  end    0x%016x (virtual)\n", end);
    802000e8:	00004597          	auipc	a1,0x4
    802000ec:	f3058593          	addi	a1,a1,-208 # 80204018 <end>
    802000f0:	00001517          	auipc	a0,0x1
    802000f4:	91850513          	addi	a0,a0,-1768 # 80200a08 <etext+0xae>
    802000f8:	f6fff0ef          	jal	ra,80200066 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - kern_init + 1023) / 1024);
    802000fc:	00004597          	auipc	a1,0x4
    80200100:	31b58593          	addi	a1,a1,795 # 80204417 <end+0x3ff>
    80200104:	00000797          	auipc	a5,0x0
    80200108:	f0678793          	addi	a5,a5,-250 # 8020000a <kern_init>
    8020010c:	40f587b3          	sub	a5,a1,a5
    cprintf("Kernel executable memory footprint: %dKB\n",
    80200110:	43f7d593          	srai	a1,a5,0x3f
}
    80200114:	60a2                	ld	ra,8(sp)
    cprintf("Kernel executable memory footprint: %dKB\n",
    80200116:	3ff5f593          	andi	a1,a1,1023
    8020011a:	95be                	add	a1,a1,a5
    8020011c:	85a9                	srai	a1,a1,0xa
    8020011e:	00001517          	auipc	a0,0x1
    80200122:	90a50513          	addi	a0,a0,-1782 # 80200a28 <etext+0xce>
}
    80200126:	0141                	addi	sp,sp,16
    cprintf("Kernel executable memory footprint: %dKB\n",
    80200128:	bf3d                	j	80200066 <cprintf>

000000008020012a <clock_init>:

/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void clock_init(void) {
    8020012a:	1141                	addi	sp,sp,-16
    8020012c:	e406                	sd	ra,8(sp)
    // enable timer interrupt in sie
    set_csr(sie, MIP_STIP);
    8020012e:	02000793          	li	a5,32
    80200132:	1047a7f3          	csrrs	a5,sie,a5
    __asm__ __volatile__("rdtime %0" : "=r"(n));
    80200136:	c0102573          	rdtime	a0
    ticks = 0;

    cprintf("++ setup timer interrupts\n");
}

void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
    8020013a:	67e1                	lui	a5,0x18
    8020013c:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0x801e7960>
    80200140:	953e                	add	a0,a0,a5
    80200142:	7fe000ef          	jal	ra,80200940 <sbi_set_timer>
}
    80200146:	60a2                	ld	ra,8(sp)
    ticks = 0;
    80200148:	00004797          	auipc	a5,0x4
    8020014c:	ec07b023          	sd	zero,-320(a5) # 80204008 <ticks>
    cprintf("++ setup timer interrupts\n");
    80200150:	00001517          	auipc	a0,0x1
    80200154:	90850513          	addi	a0,a0,-1784 # 80200a58 <etext+0xfe>
}
    80200158:	0141                	addi	sp,sp,16
    cprintf("++ setup timer interrupts\n");
    8020015a:	b731                	j	80200066 <cprintf>

000000008020015c <clock_set_next_event>:
    __asm__ __volatile__("rdtime %0" : "=r"(n));
    8020015c:	c0102573          	rdtime	a0
void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
    80200160:	67e1                	lui	a5,0x18
    80200162:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0x801e7960>
    80200166:	953e                	add	a0,a0,a5
    80200168:	7d80006f          	j	80200940 <sbi_set_timer>

000000008020016c <cons_init>:

/* serial_intr - try to feed input characters from serial port */
void serial_intr(void) {}

/* cons_init - initializes the console devices */
void cons_init(void) {}
    8020016c:	8082                	ret

000000008020016e <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) { sbi_console_putchar((unsigned char)c); }
    8020016e:	0ff57513          	andi	a0,a0,255
    80200172:	7b40006f          	j	80200926 <sbi_console_putchar>

0000000080200176 <idt_init>:
 */
void idt_init(void) {
    extern void __alltraps(void);
    /* Set sscratch register to 0, indicating to exception vector that we are
     * presently executing in the kernel */
    write_csr(sscratch, 0);
    80200176:	14005073          	csrwi	sscratch,0
    /* Set the exception vector address */
    write_csr(stvec, &__alltraps);
    8020017a:	00000797          	auipc	a5,0x0
    8020017e:	2da78793          	addi	a5,a5,730 # 80200454 <__alltraps>
    80200182:	10579073          	csrw	stvec,a5
}
    80200186:	8082                	ret

0000000080200188 <print_regs>:
    cprintf("  badvaddr 0x%08x\n", tf->badvaddr);
    cprintf("  cause    0x%08x\n", tf->cause);
}

void print_regs(struct pushregs *gpr) {
    cprintf("  zero     0x%08x\n", gpr->zero);
    80200188:	610c                	ld	a1,0(a0)
void print_regs(struct pushregs *gpr) {
    8020018a:	1141                	addi	sp,sp,-16
    8020018c:	e022                	sd	s0,0(sp)
    8020018e:	842a                	mv	s0,a0
    cprintf("  zero     0x%08x\n", gpr->zero);
    80200190:	00001517          	auipc	a0,0x1
    80200194:	8e850513          	addi	a0,a0,-1816 # 80200a78 <etext+0x11e>
void print_regs(struct pushregs *gpr) {
    80200198:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
    8020019a:	ecdff0ef          	jal	ra,80200066 <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
    8020019e:	640c                	ld	a1,8(s0)
    802001a0:	00001517          	auipc	a0,0x1
    802001a4:	8f050513          	addi	a0,a0,-1808 # 80200a90 <etext+0x136>
    802001a8:	ebfff0ef          	jal	ra,80200066 <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
    802001ac:	680c                	ld	a1,16(s0)
    802001ae:	00001517          	auipc	a0,0x1
    802001b2:	8fa50513          	addi	a0,a0,-1798 # 80200aa8 <etext+0x14e>
    802001b6:	eb1ff0ef          	jal	ra,80200066 <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
    802001ba:	6c0c                	ld	a1,24(s0)
    802001bc:	00001517          	auipc	a0,0x1
    802001c0:	90450513          	addi	a0,a0,-1788 # 80200ac0 <etext+0x166>
    802001c4:	ea3ff0ef          	jal	ra,80200066 <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
    802001c8:	700c                	ld	a1,32(s0)
    802001ca:	00001517          	auipc	a0,0x1
    802001ce:	90e50513          	addi	a0,a0,-1778 # 80200ad8 <etext+0x17e>
    802001d2:	e95ff0ef          	jal	ra,80200066 <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
    802001d6:	740c                	ld	a1,40(s0)
    802001d8:	00001517          	auipc	a0,0x1
    802001dc:	91850513          	addi	a0,a0,-1768 # 80200af0 <etext+0x196>
    802001e0:	e87ff0ef          	jal	ra,80200066 <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
    802001e4:	780c                	ld	a1,48(s0)
    802001e6:	00001517          	auipc	a0,0x1
    802001ea:	92250513          	addi	a0,a0,-1758 # 80200b08 <etext+0x1ae>
    802001ee:	e79ff0ef          	jal	ra,80200066 <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
    802001f2:	7c0c                	ld	a1,56(s0)
    802001f4:	00001517          	auipc	a0,0x1
    802001f8:	92c50513          	addi	a0,a0,-1748 # 80200b20 <etext+0x1c6>
    802001fc:	e6bff0ef          	jal	ra,80200066 <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
    80200200:	602c                	ld	a1,64(s0)
    80200202:	00001517          	auipc	a0,0x1
    80200206:	93650513          	addi	a0,a0,-1738 # 80200b38 <etext+0x1de>
    8020020a:	e5dff0ef          	jal	ra,80200066 <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
    8020020e:	642c                	ld	a1,72(s0)
    80200210:	00001517          	auipc	a0,0x1
    80200214:	94050513          	addi	a0,a0,-1728 # 80200b50 <etext+0x1f6>
    80200218:	e4fff0ef          	jal	ra,80200066 <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
    8020021c:	682c                	ld	a1,80(s0)
    8020021e:	00001517          	auipc	a0,0x1
    80200222:	94a50513          	addi	a0,a0,-1718 # 80200b68 <etext+0x20e>
    80200226:	e41ff0ef          	jal	ra,80200066 <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
    8020022a:	6c2c                	ld	a1,88(s0)
    8020022c:	00001517          	auipc	a0,0x1
    80200230:	95450513          	addi	a0,a0,-1708 # 80200b80 <etext+0x226>
    80200234:	e33ff0ef          	jal	ra,80200066 <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
    80200238:	702c                	ld	a1,96(s0)
    8020023a:	00001517          	auipc	a0,0x1
    8020023e:	95e50513          	addi	a0,a0,-1698 # 80200b98 <etext+0x23e>
    80200242:	e25ff0ef          	jal	ra,80200066 <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
    80200246:	742c                	ld	a1,104(s0)
    80200248:	00001517          	auipc	a0,0x1
    8020024c:	96850513          	addi	a0,a0,-1688 # 80200bb0 <etext+0x256>
    80200250:	e17ff0ef          	jal	ra,80200066 <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
    80200254:	782c                	ld	a1,112(s0)
    80200256:	00001517          	auipc	a0,0x1
    8020025a:	97250513          	addi	a0,a0,-1678 # 80200bc8 <etext+0x26e>
    8020025e:	e09ff0ef          	jal	ra,80200066 <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
    80200262:	7c2c                	ld	a1,120(s0)
    80200264:	00001517          	auipc	a0,0x1
    80200268:	97c50513          	addi	a0,a0,-1668 # 80200be0 <etext+0x286>
    8020026c:	dfbff0ef          	jal	ra,80200066 <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
    80200270:	604c                	ld	a1,128(s0)
    80200272:	00001517          	auipc	a0,0x1
    80200276:	98650513          	addi	a0,a0,-1658 # 80200bf8 <etext+0x29e>
    8020027a:	dedff0ef          	jal	ra,80200066 <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
    8020027e:	644c                	ld	a1,136(s0)
    80200280:	00001517          	auipc	a0,0x1
    80200284:	99050513          	addi	a0,a0,-1648 # 80200c10 <etext+0x2b6>
    80200288:	ddfff0ef          	jal	ra,80200066 <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
    8020028c:	684c                	ld	a1,144(s0)
    8020028e:	00001517          	auipc	a0,0x1
    80200292:	99a50513          	addi	a0,a0,-1638 # 80200c28 <etext+0x2ce>
    80200296:	dd1ff0ef          	jal	ra,80200066 <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
    8020029a:	6c4c                	ld	a1,152(s0)
    8020029c:	00001517          	auipc	a0,0x1
    802002a0:	9a450513          	addi	a0,a0,-1628 # 80200c40 <etext+0x2e6>
    802002a4:	dc3ff0ef          	jal	ra,80200066 <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
    802002a8:	704c                	ld	a1,160(s0)
    802002aa:	00001517          	auipc	a0,0x1
    802002ae:	9ae50513          	addi	a0,a0,-1618 # 80200c58 <etext+0x2fe>
    802002b2:	db5ff0ef          	jal	ra,80200066 <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
    802002b6:	744c                	ld	a1,168(s0)
    802002b8:	00001517          	auipc	a0,0x1
    802002bc:	9b850513          	addi	a0,a0,-1608 # 80200c70 <etext+0x316>
    802002c0:	da7ff0ef          	jal	ra,80200066 <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
    802002c4:	784c                	ld	a1,176(s0)
    802002c6:	00001517          	auipc	a0,0x1
    802002ca:	9c250513          	addi	a0,a0,-1598 # 80200c88 <etext+0x32e>
    802002ce:	d99ff0ef          	jal	ra,80200066 <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
    802002d2:	7c4c                	ld	a1,184(s0)
    802002d4:	00001517          	auipc	a0,0x1
    802002d8:	9cc50513          	addi	a0,a0,-1588 # 80200ca0 <etext+0x346>
    802002dc:	d8bff0ef          	jal	ra,80200066 <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
    802002e0:	606c                	ld	a1,192(s0)
    802002e2:	00001517          	auipc	a0,0x1
    802002e6:	9d650513          	addi	a0,a0,-1578 # 80200cb8 <etext+0x35e>
    802002ea:	d7dff0ef          	jal	ra,80200066 <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
    802002ee:	646c                	ld	a1,200(s0)
    802002f0:	00001517          	auipc	a0,0x1
    802002f4:	9e050513          	addi	a0,a0,-1568 # 80200cd0 <etext+0x376>
    802002f8:	d6fff0ef          	jal	ra,80200066 <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
    802002fc:	686c                	ld	a1,208(s0)
    802002fe:	00001517          	auipc	a0,0x1
    80200302:	9ea50513          	addi	a0,a0,-1558 # 80200ce8 <etext+0x38e>
    80200306:	d61ff0ef          	jal	ra,80200066 <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
    8020030a:	6c6c                	ld	a1,216(s0)
    8020030c:	00001517          	auipc	a0,0x1
    80200310:	9f450513          	addi	a0,a0,-1548 # 80200d00 <etext+0x3a6>
    80200314:	d53ff0ef          	jal	ra,80200066 <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
    80200318:	706c                	ld	a1,224(s0)
    8020031a:	00001517          	auipc	a0,0x1
    8020031e:	9fe50513          	addi	a0,a0,-1538 # 80200d18 <etext+0x3be>
    80200322:	d45ff0ef          	jal	ra,80200066 <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
    80200326:	746c                	ld	a1,232(s0)
    80200328:	00001517          	auipc	a0,0x1
    8020032c:	a0850513          	addi	a0,a0,-1528 # 80200d30 <etext+0x3d6>
    80200330:	d37ff0ef          	jal	ra,80200066 <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
    80200334:	786c                	ld	a1,240(s0)
    80200336:	00001517          	auipc	a0,0x1
    8020033a:	a1250513          	addi	a0,a0,-1518 # 80200d48 <etext+0x3ee>
    8020033e:	d29ff0ef          	jal	ra,80200066 <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
    80200342:	7c6c                	ld	a1,248(s0)
}
    80200344:	6402                	ld	s0,0(sp)
    80200346:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
    80200348:	00001517          	auipc	a0,0x1
    8020034c:	a1850513          	addi	a0,a0,-1512 # 80200d60 <etext+0x406>
}
    80200350:	0141                	addi	sp,sp,16
    cprintf("  t6       0x%08x\n", gpr->t6);
    80200352:	bb11                	j	80200066 <cprintf>

0000000080200354 <print_trapframe>:
void print_trapframe(struct trapframe *tf) {
    80200354:	1141                	addi	sp,sp,-16
    80200356:	e022                	sd	s0,0(sp)
    cprintf("trapframe at %p\n", tf);
    80200358:	85aa                	mv	a1,a0
void print_trapframe(struct trapframe *tf) {
    8020035a:	842a                	mv	s0,a0
    cprintf("trapframe at %p\n", tf);
    8020035c:	00001517          	auipc	a0,0x1
    80200360:	a1c50513          	addi	a0,a0,-1508 # 80200d78 <etext+0x41e>
void print_trapframe(struct trapframe *tf) {
    80200364:	e406                	sd	ra,8(sp)
    cprintf("trapframe at %p\n", tf);
    80200366:	d01ff0ef          	jal	ra,80200066 <cprintf>
    print_regs(&tf->gpr);
    8020036a:	8522                	mv	a0,s0
    8020036c:	e1dff0ef          	jal	ra,80200188 <print_regs>
    cprintf("  status   0x%08x\n", tf->status);
    80200370:	10043583          	ld	a1,256(s0)
    80200374:	00001517          	auipc	a0,0x1
    80200378:	a1c50513          	addi	a0,a0,-1508 # 80200d90 <etext+0x436>
    8020037c:	cebff0ef          	jal	ra,80200066 <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
    80200380:	10843583          	ld	a1,264(s0)
    80200384:	00001517          	auipc	a0,0x1
    80200388:	a2450513          	addi	a0,a0,-1500 # 80200da8 <etext+0x44e>
    8020038c:	cdbff0ef          	jal	ra,80200066 <cprintf>
    cprintf("  badvaddr 0x%08x\n", tf->badvaddr);
    80200390:	11043583          	ld	a1,272(s0)
    80200394:	00001517          	auipc	a0,0x1
    80200398:	a2c50513          	addi	a0,a0,-1492 # 80200dc0 <etext+0x466>
    8020039c:	ccbff0ef          	jal	ra,80200066 <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
    802003a0:	11843583          	ld	a1,280(s0)
}
    802003a4:	6402                	ld	s0,0(sp)
    802003a6:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
    802003a8:	00001517          	auipc	a0,0x1
    802003ac:	a3050513          	addi	a0,a0,-1488 # 80200dd8 <etext+0x47e>
}
    802003b0:	0141                	addi	sp,sp,16
    cprintf("  cause    0x%08x\n", tf->cause);
    802003b2:	b955                	j	80200066 <cprintf>

00000000802003b4 <interrupt_handler>:

void interrupt_handler(struct trapframe *tf) {
    //抹掉scause最高位代表“这是中断不是异常”的1

    intptr_t cause = (tf->cause << 1) >> 1;
    802003b4:	11853783          	ld	a5,280(a0)
    802003b8:	472d                	li	a4,11
    802003ba:	0786                	slli	a5,a5,0x1
    802003bc:	8385                	srli	a5,a5,0x1
    802003be:	06f76763          	bltu	a4,a5,8020042c <interrupt_handler+0x78>
    802003c2:	00001717          	auipc	a4,0x1
    802003c6:	ade70713          	addi	a4,a4,-1314 # 80200ea0 <etext+0x546>
    802003ca:	078a                	slli	a5,a5,0x2
    802003cc:	97ba                	add	a5,a5,a4
    802003ce:	439c                	lw	a5,0(a5)
    802003d0:	97ba                	add	a5,a5,a4
    802003d2:	8782                	jr	a5
            break;
        case IRQ_H_SOFT:
            cprintf("Hypervisor software interrupt\n");
            break;
        case IRQ_M_SOFT:
            cprintf("Machine software interrupt\n");
    802003d4:	00001517          	auipc	a0,0x1
    802003d8:	a7c50513          	addi	a0,a0,-1412 # 80200e50 <etext+0x4f6>
    802003dc:	b169                	j	80200066 <cprintf>
            cprintf("Hypervisor software interrupt\n");
    802003de:	00001517          	auipc	a0,0x1
    802003e2:	a5250513          	addi	a0,a0,-1454 # 80200e30 <etext+0x4d6>
    802003e6:	b141                	j	80200066 <cprintf>
            cprintf("User software interrupt\n");
    802003e8:	00001517          	auipc	a0,0x1
    802003ec:	a0850513          	addi	a0,a0,-1528 # 80200df0 <etext+0x496>
    802003f0:	b99d                	j	80200066 <cprintf>
            cprintf("Supervisor software interrupt\n");
    802003f2:	00001517          	auipc	a0,0x1
    802003f6:	a1e50513          	addi	a0,a0,-1506 # 80200e10 <etext+0x4b6>
    802003fa:	b1b5                	j	80200066 <cprintf>
void interrupt_handler(struct trapframe *tf) {
    802003fc:	1141                	addi	sp,sp,-16
    802003fe:	e406                	sd	ra,8(sp)
             *(3)当计数器加到100的时候，我们会输出一个`100ticks`表示我们触发了100次时钟中断，同时打印次数（num）加一
            * (4)判断打印次数，当打印次数为10时，调用<sbi.h>中的关机函数关机
            */
       
            
            clock_set_next_event();//发生这次时钟中断的时候，我们要设置下一次时钟中断
    80200400:	d5dff0ef          	jal	ra,8020015c <clock_set_next_event>
            if (++ticks % TICK_NUM == 0) {
    80200404:	00004697          	auipc	a3,0x4
    80200408:	c0468693          	addi	a3,a3,-1020 # 80204008 <ticks>
    8020040c:	629c                	ld	a5,0(a3)
    8020040e:	06400713          	li	a4,100
    80200412:	0785                	addi	a5,a5,1
    80200414:	02e7f733          	remu	a4,a5,a4
    80200418:	e29c                	sd	a5,0(a3)
    8020041a:	cb11                	beqz	a4,8020042e <interrupt_handler+0x7a>
            break;
        default:
            print_trapframe(tf);
            break;
    }
}
    8020041c:	60a2                	ld	ra,8(sp)
    8020041e:	0141                	addi	sp,sp,16
    80200420:	8082                	ret
            cprintf("Supervisor external interrupt\n");
    80200422:	00001517          	auipc	a0,0x1
    80200426:	a5e50513          	addi	a0,a0,-1442 # 80200e80 <etext+0x526>
    8020042a:	b935                	j	80200066 <cprintf>
            print_trapframe(tf);
    8020042c:	b725                	j	80200354 <print_trapframe>
}
    8020042e:	60a2                	ld	ra,8(sp)
    cprintf("%d ticks\n", TICK_NUM);
    80200430:	06400593          	li	a1,100
    80200434:	00001517          	auipc	a0,0x1
    80200438:	a3c50513          	addi	a0,a0,-1476 # 80200e70 <etext+0x516>
}
    8020043c:	0141                	addi	sp,sp,16
    cprintf("%d ticks\n", TICK_NUM);
    8020043e:	b125                	j	80200066 <cprintf>

0000000080200440 <trap>:
}

/* trap_dispatch - dispatch based on what type of trap occurred */
static inline void trap_dispatch(struct trapframe *tf) {
    //scause的最高位是1，说明trap是由中断引起的
    if ((intptr_t)tf->cause < 0) {
    80200440:	11853783          	ld	a5,280(a0)
    80200444:	0007c763          	bltz	a5,80200452 <trap+0x12>
    switch (tf->cause) {
    80200448:	472d                	li	a4,11
    8020044a:	00f76363          	bltu	a4,a5,80200450 <trap+0x10>
 * trap - handles or dispatches an exception/interrupt. if and when trap()
 * returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void trap(struct trapframe *tf) { trap_dispatch(tf); }
    8020044e:	8082                	ret
            print_trapframe(tf);
    80200450:	b711                	j	80200354 <print_trapframe>
        interrupt_handler(tf);
    80200452:	b78d                	j	802003b4 <interrupt_handler>

0000000080200454 <__alltraps>:
    .endm

    .globl __alltraps #陷入
.align(2)
__alltraps:
    SAVE_ALL  #保存寄存器的值入栈
    80200454:	14011073          	csrw	sscratch,sp
    80200458:	712d                	addi	sp,sp,-288
    8020045a:	e002                	sd	zero,0(sp)
    8020045c:	e406                	sd	ra,8(sp)
    8020045e:	ec0e                	sd	gp,24(sp)
    80200460:	f012                	sd	tp,32(sp)
    80200462:	f416                	sd	t0,40(sp)
    80200464:	f81a                	sd	t1,48(sp)
    80200466:	fc1e                	sd	t2,56(sp)
    80200468:	e0a2                	sd	s0,64(sp)
    8020046a:	e4a6                	sd	s1,72(sp)
    8020046c:	e8aa                	sd	a0,80(sp)
    8020046e:	ecae                	sd	a1,88(sp)
    80200470:	f0b2                	sd	a2,96(sp)
    80200472:	f4b6                	sd	a3,104(sp)
    80200474:	f8ba                	sd	a4,112(sp)
    80200476:	fcbe                	sd	a5,120(sp)
    80200478:	e142                	sd	a6,128(sp)
    8020047a:	e546                	sd	a7,136(sp)
    8020047c:	e94a                	sd	s2,144(sp)
    8020047e:	ed4e                	sd	s3,152(sp)
    80200480:	f152                	sd	s4,160(sp)
    80200482:	f556                	sd	s5,168(sp)
    80200484:	f95a                	sd	s6,176(sp)
    80200486:	fd5e                	sd	s7,184(sp)
    80200488:	e1e2                	sd	s8,192(sp)
    8020048a:	e5e6                	sd	s9,200(sp)
    8020048c:	e9ea                	sd	s10,208(sp)
    8020048e:	edee                	sd	s11,216(sp)
    80200490:	f1f2                	sd	t3,224(sp)
    80200492:	f5f6                	sd	t4,232(sp)
    80200494:	f9fa                	sd	t5,240(sp)
    80200496:	fdfe                	sd	t6,248(sp)
    80200498:	14001473          	csrrw	s0,sscratch,zero
    8020049c:	100024f3          	csrr	s1,sstatus
    802004a0:	14102973          	csrr	s2,sepc
    802004a4:	143029f3          	csrr	s3,stval
    802004a8:	14202a73          	csrr	s4,scause
    802004ac:	e822                	sd	s0,16(sp)
    802004ae:	e226                	sd	s1,256(sp)
    802004b0:	e64a                	sd	s2,264(sp)
    802004b2:	ea4e                	sd	s3,272(sp)
    802004b4:	ee52                	sd	s4,280(sp)

    move  a0, sp #a0拿着参数
    802004b6:	850a                	mv	a0,sp
    jal trap   #调用trap()函数
    802004b8:	f89ff0ef          	jal	ra,80200440 <trap>

00000000802004bc <__trapret>:
    # sp should be the same as before "jal trap"

    .globl __trapret #中断返回
__trapret:
    RESTORE_ALL # 寄存器恢复 
    802004bc:	6492                	ld	s1,256(sp)
    802004be:	6932                	ld	s2,264(sp)
    802004c0:	10049073          	csrw	sstatus,s1
    802004c4:	14191073          	csrw	sepc,s2
    802004c8:	60a2                	ld	ra,8(sp)
    802004ca:	61e2                	ld	gp,24(sp)
    802004cc:	7202                	ld	tp,32(sp)
    802004ce:	72a2                	ld	t0,40(sp)
    802004d0:	7342                	ld	t1,48(sp)
    802004d2:	73e2                	ld	t2,56(sp)
    802004d4:	6406                	ld	s0,64(sp)
    802004d6:	64a6                	ld	s1,72(sp)
    802004d8:	6546                	ld	a0,80(sp)
    802004da:	65e6                	ld	a1,88(sp)
    802004dc:	7606                	ld	a2,96(sp)
    802004de:	76a6                	ld	a3,104(sp)
    802004e0:	7746                	ld	a4,112(sp)
    802004e2:	77e6                	ld	a5,120(sp)
    802004e4:	680a                	ld	a6,128(sp)
    802004e6:	68aa                	ld	a7,136(sp)
    802004e8:	694a                	ld	s2,144(sp)
    802004ea:	69ea                	ld	s3,152(sp)
    802004ec:	7a0a                	ld	s4,160(sp)
    802004ee:	7aaa                	ld	s5,168(sp)
    802004f0:	7b4a                	ld	s6,176(sp)
    802004f2:	7bea                	ld	s7,184(sp)
    802004f4:	6c0e                	ld	s8,192(sp)
    802004f6:	6cae                	ld	s9,200(sp)
    802004f8:	6d4e                	ld	s10,208(sp)
    802004fa:	6dee                	ld	s11,216(sp)
    802004fc:	7e0e                	ld	t3,224(sp)
    802004fe:	7eae                	ld	t4,232(sp)
    80200500:	7f4e                	ld	t5,240(sp)
    80200502:	7fee                	ld	t6,248(sp)
    80200504:	6142                	ld	sp,16(sp)
    # return from supervisor call
    sret
    80200506:	10200073          	sret

000000008020050a <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    8020050a:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
    8020050c:	e589                	bnez	a1,80200516 <strnlen+0xc>
    8020050e:	a811                	j	80200522 <strnlen+0x18>
        cnt ++;
    80200510:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
    80200512:	00f58863          	beq	a1,a5,80200522 <strnlen+0x18>
    80200516:	00f50733          	add	a4,a0,a5
    8020051a:	00074703          	lbu	a4,0(a4)
    8020051e:	fb6d                	bnez	a4,80200510 <strnlen+0x6>
    80200520:	85be                	mv	a1,a5
    }
    return cnt;
}
    80200522:	852e                	mv	a0,a1
    80200524:	8082                	ret

0000000080200526 <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
    80200526:	ca01                	beqz	a2,80200536 <memset+0x10>
    80200528:	962a                	add	a2,a2,a0
    char *p = s;
    8020052a:	87aa                	mv	a5,a0
        *p ++ = c;
    8020052c:	0785                	addi	a5,a5,1
    8020052e:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
    80200532:	fec79de3          	bne	a5,a2,8020052c <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
    80200536:	8082                	ret

0000000080200538 <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
    80200538:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
    8020053c:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
    8020053e:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
    80200542:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
    80200544:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
    80200548:	f022                	sd	s0,32(sp)
    8020054a:	ec26                	sd	s1,24(sp)
    8020054c:	e84a                	sd	s2,16(sp)
    8020054e:	f406                	sd	ra,40(sp)
    80200550:	e44e                	sd	s3,8(sp)
    80200552:	84aa                	mv	s1,a0
    80200554:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
    80200556:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
    8020055a:	2a01                	sext.w	s4,s4
    if (num >= base) {
    8020055c:	03067e63          	bgeu	a2,a6,80200598 <printnum+0x60>
    80200560:	89be                	mv	s3,a5
        while (-- width > 0)
    80200562:	00805763          	blez	s0,80200570 <printnum+0x38>
    80200566:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
    80200568:	85ca                	mv	a1,s2
    8020056a:	854e                	mv	a0,s3
    8020056c:	9482                	jalr	s1
        while (-- width > 0)
    8020056e:	fc65                	bnez	s0,80200566 <printnum+0x2e>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
    80200570:	1a02                	slli	s4,s4,0x20
    80200572:	00001797          	auipc	a5,0x1
    80200576:	95e78793          	addi	a5,a5,-1698 # 80200ed0 <etext+0x576>
    8020057a:	020a5a13          	srli	s4,s4,0x20
    8020057e:	9a3e                	add	s4,s4,a5
}
    80200580:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
    80200582:	000a4503          	lbu	a0,0(s4)
}
    80200586:	70a2                	ld	ra,40(sp)
    80200588:	69a2                	ld	s3,8(sp)
    8020058a:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
    8020058c:	85ca                	mv	a1,s2
    8020058e:	87a6                	mv	a5,s1
}
    80200590:	6942                	ld	s2,16(sp)
    80200592:	64e2                	ld	s1,24(sp)
    80200594:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
    80200596:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
    80200598:	03065633          	divu	a2,a2,a6
    8020059c:	8722                	mv	a4,s0
    8020059e:	f9bff0ef          	jal	ra,80200538 <printnum>
    802005a2:	b7f9                	j	80200570 <printnum+0x38>

00000000802005a4 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
    802005a4:	7119                	addi	sp,sp,-128
    802005a6:	f4a6                	sd	s1,104(sp)
    802005a8:	f0ca                	sd	s2,96(sp)
    802005aa:	ecce                	sd	s3,88(sp)
    802005ac:	e8d2                	sd	s4,80(sp)
    802005ae:	e4d6                	sd	s5,72(sp)
    802005b0:	e0da                	sd	s6,64(sp)
    802005b2:	fc5e                	sd	s7,56(sp)
    802005b4:	f06a                	sd	s10,32(sp)
    802005b6:	fc86                	sd	ra,120(sp)
    802005b8:	f8a2                	sd	s0,112(sp)
    802005ba:	f862                	sd	s8,48(sp)
    802005bc:	f466                	sd	s9,40(sp)
    802005be:	ec6e                	sd	s11,24(sp)
    802005c0:	892a                	mv	s2,a0
    802005c2:	84ae                	mv	s1,a1
    802005c4:	8d32                	mv	s10,a2
    802005c6:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
    802005c8:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
    802005cc:	5b7d                	li	s6,-1
    802005ce:	00001a97          	auipc	s5,0x1
    802005d2:	936a8a93          	addi	s5,s5,-1738 # 80200f04 <etext+0x5aa>
        case 'e':
            err = va_arg(ap, int);
            if (err < 0) {
                err = -err;
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
    802005d6:	00001b97          	auipc	s7,0x1
    802005da:	b0ab8b93          	addi	s7,s7,-1270 # 802010e0 <error_string>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
    802005de:	000d4503          	lbu	a0,0(s10)
    802005e2:	001d0413          	addi	s0,s10,1
    802005e6:	01350a63          	beq	a0,s3,802005fa <vprintfmt+0x56>
            if (ch == '\0') {
    802005ea:	c121                	beqz	a0,8020062a <vprintfmt+0x86>
            putch(ch, putdat);
    802005ec:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
    802005ee:	0405                	addi	s0,s0,1
            putch(ch, putdat);
    802005f0:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
    802005f2:	fff44503          	lbu	a0,-1(s0)
    802005f6:	ff351ae3          	bne	a0,s3,802005ea <vprintfmt+0x46>
        switch (ch = *(unsigned char *)fmt ++) {
    802005fa:	00044603          	lbu	a2,0(s0)
        char padc = ' ';
    802005fe:	02000793          	li	a5,32
        lflag = altflag = 0;
    80200602:	4c81                	li	s9,0
    80200604:	4881                	li	a7,0
        width = precision = -1;
    80200606:	5c7d                	li	s8,-1
    80200608:	5dfd                	li	s11,-1
    8020060a:	05500513          	li	a0,85
                if (ch < '0' || ch > '9') {
    8020060e:	4825                	li	a6,9
        switch (ch = *(unsigned char *)fmt ++) {
    80200610:	fdd6059b          	addiw	a1,a2,-35
    80200614:	0ff5f593          	andi	a1,a1,255
    80200618:	00140d13          	addi	s10,s0,1
    8020061c:	04b56263          	bltu	a0,a1,80200660 <vprintfmt+0xbc>
    80200620:	058a                	slli	a1,a1,0x2
    80200622:	95d6                	add	a1,a1,s5
    80200624:	4194                	lw	a3,0(a1)
    80200626:	96d6                	add	a3,a3,s5
    80200628:	8682                	jr	a3
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
    8020062a:	70e6                	ld	ra,120(sp)
    8020062c:	7446                	ld	s0,112(sp)
    8020062e:	74a6                	ld	s1,104(sp)
    80200630:	7906                	ld	s2,96(sp)
    80200632:	69e6                	ld	s3,88(sp)
    80200634:	6a46                	ld	s4,80(sp)
    80200636:	6aa6                	ld	s5,72(sp)
    80200638:	6b06                	ld	s6,64(sp)
    8020063a:	7be2                	ld	s7,56(sp)
    8020063c:	7c42                	ld	s8,48(sp)
    8020063e:	7ca2                	ld	s9,40(sp)
    80200640:	7d02                	ld	s10,32(sp)
    80200642:	6de2                	ld	s11,24(sp)
    80200644:	6109                	addi	sp,sp,128
    80200646:	8082                	ret
            padc = '0';
    80200648:	87b2                	mv	a5,a2
            goto reswitch;
    8020064a:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
    8020064e:	846a                	mv	s0,s10
    80200650:	00140d13          	addi	s10,s0,1
    80200654:	fdd6059b          	addiw	a1,a2,-35
    80200658:	0ff5f593          	andi	a1,a1,255
    8020065c:	fcb572e3          	bgeu	a0,a1,80200620 <vprintfmt+0x7c>
            putch('%', putdat);
    80200660:	85a6                	mv	a1,s1
    80200662:	02500513          	li	a0,37
    80200666:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
    80200668:	fff44783          	lbu	a5,-1(s0)
    8020066c:	8d22                	mv	s10,s0
    8020066e:	f73788e3          	beq	a5,s3,802005de <vprintfmt+0x3a>
    80200672:	ffed4783          	lbu	a5,-2(s10)
    80200676:	1d7d                	addi	s10,s10,-1
    80200678:	ff379de3          	bne	a5,s3,80200672 <vprintfmt+0xce>
    8020067c:	b78d                	j	802005de <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
    8020067e:	fd060c1b          	addiw	s8,a2,-48
                ch = *fmt;
    80200682:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
    80200686:	846a                	mv	s0,s10
                if (ch < '0' || ch > '9') {
    80200688:	fd06069b          	addiw	a3,a2,-48
                ch = *fmt;
    8020068c:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
    80200690:	02d86463          	bltu	a6,a3,802006b8 <vprintfmt+0x114>
                ch = *fmt;
    80200694:	00144603          	lbu	a2,1(s0)
                precision = precision * 10 + ch - '0';
    80200698:	002c169b          	slliw	a3,s8,0x2
    8020069c:	0186873b          	addw	a4,a3,s8
    802006a0:	0017171b          	slliw	a4,a4,0x1
    802006a4:	9f2d                	addw	a4,a4,a1
                if (ch < '0' || ch > '9') {
    802006a6:	fd06069b          	addiw	a3,a2,-48
            for (precision = 0; ; ++ fmt) {
    802006aa:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
    802006ac:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
    802006b0:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
    802006b4:	fed870e3          	bgeu	a6,a3,80200694 <vprintfmt+0xf0>
            if (width < 0)
    802006b8:	f40ddce3          	bgez	s11,80200610 <vprintfmt+0x6c>
                width = precision, precision = -1;
    802006bc:	8de2                	mv	s11,s8
    802006be:	5c7d                	li	s8,-1
    802006c0:	bf81                	j	80200610 <vprintfmt+0x6c>
            if (width < 0)
    802006c2:	fffdc693          	not	a3,s11
    802006c6:	96fd                	srai	a3,a3,0x3f
    802006c8:	00ddfdb3          	and	s11,s11,a3
        switch (ch = *(unsigned char *)fmt ++) {
    802006cc:	00144603          	lbu	a2,1(s0)
    802006d0:	2d81                	sext.w	s11,s11
    802006d2:	846a                	mv	s0,s10
            goto reswitch;
    802006d4:	bf35                	j	80200610 <vprintfmt+0x6c>
            precision = va_arg(ap, int);
    802006d6:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
    802006da:	00144603          	lbu	a2,1(s0)
            precision = va_arg(ap, int);
    802006de:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
    802006e0:	846a                	mv	s0,s10
            goto process_precision;
    802006e2:	bfd9                	j	802006b8 <vprintfmt+0x114>
    if (lflag >= 2) {
    802006e4:	4705                	li	a4,1
            precision = va_arg(ap, int);
    802006e6:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
    802006ea:	01174463          	blt	a4,a7,802006f2 <vprintfmt+0x14e>
    else if (lflag) {
    802006ee:	1a088e63          	beqz	a7,802008aa <vprintfmt+0x306>
        return va_arg(*ap, unsigned long);
    802006f2:	000a3603          	ld	a2,0(s4)
    802006f6:	46c1                	li	a3,16
    802006f8:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
    802006fa:	2781                	sext.w	a5,a5
    802006fc:	876e                	mv	a4,s11
    802006fe:	85a6                	mv	a1,s1
    80200700:	854a                	mv	a0,s2
    80200702:	e37ff0ef          	jal	ra,80200538 <printnum>
            break;
    80200706:	bde1                	j	802005de <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
    80200708:	000a2503          	lw	a0,0(s4)
    8020070c:	85a6                	mv	a1,s1
    8020070e:	0a21                	addi	s4,s4,8
    80200710:	9902                	jalr	s2
            break;
    80200712:	b5f1                	j	802005de <vprintfmt+0x3a>
    if (lflag >= 2) {
    80200714:	4705                	li	a4,1
            precision = va_arg(ap, int);
    80200716:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
    8020071a:	01174463          	blt	a4,a7,80200722 <vprintfmt+0x17e>
    else if (lflag) {
    8020071e:	18088163          	beqz	a7,802008a0 <vprintfmt+0x2fc>
        return va_arg(*ap, unsigned long);
    80200722:	000a3603          	ld	a2,0(s4)
    80200726:	46a9                	li	a3,10
    80200728:	8a2e                	mv	s4,a1
    8020072a:	bfc1                	j	802006fa <vprintfmt+0x156>
        switch (ch = *(unsigned char *)fmt ++) {
    8020072c:	00144603          	lbu	a2,1(s0)
            altflag = 1;
    80200730:	4c85                	li	s9,1
        switch (ch = *(unsigned char *)fmt ++) {
    80200732:	846a                	mv	s0,s10
            goto reswitch;
    80200734:	bdf1                	j	80200610 <vprintfmt+0x6c>
            putch(ch, putdat);
    80200736:	85a6                	mv	a1,s1
    80200738:	02500513          	li	a0,37
    8020073c:	9902                	jalr	s2
            break;
    8020073e:	b545                	j	802005de <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
    80200740:	00144603          	lbu	a2,1(s0)
            lflag ++;
    80200744:	2885                	addiw	a7,a7,1
        switch (ch = *(unsigned char *)fmt ++) {
    80200746:	846a                	mv	s0,s10
            goto reswitch;
    80200748:	b5e1                	j	80200610 <vprintfmt+0x6c>
    if (lflag >= 2) {
    8020074a:	4705                	li	a4,1
            precision = va_arg(ap, int);
    8020074c:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
    80200750:	01174463          	blt	a4,a7,80200758 <vprintfmt+0x1b4>
    else if (lflag) {
    80200754:	14088163          	beqz	a7,80200896 <vprintfmt+0x2f2>
        return va_arg(*ap, unsigned long);
    80200758:	000a3603          	ld	a2,0(s4)
    8020075c:	46a1                	li	a3,8
    8020075e:	8a2e                	mv	s4,a1
    80200760:	bf69                	j	802006fa <vprintfmt+0x156>
            putch('0', putdat);
    80200762:	03000513          	li	a0,48
    80200766:	85a6                	mv	a1,s1
    80200768:	e03e                	sd	a5,0(sp)
    8020076a:	9902                	jalr	s2
            putch('x', putdat);
    8020076c:	85a6                	mv	a1,s1
    8020076e:	07800513          	li	a0,120
    80200772:	9902                	jalr	s2
            num = (unsigned long long)va_arg(ap, void *);
    80200774:	0a21                	addi	s4,s4,8
            goto number;
    80200776:	6782                	ld	a5,0(sp)
    80200778:	46c1                	li	a3,16
            num = (unsigned long long)va_arg(ap, void *);
    8020077a:	ff8a3603          	ld	a2,-8(s4)
            goto number;
    8020077e:	bfb5                	j	802006fa <vprintfmt+0x156>
            if ((p = va_arg(ap, char *)) == NULL) {
    80200780:	000a3403          	ld	s0,0(s4)
    80200784:	008a0713          	addi	a4,s4,8
    80200788:	e03a                	sd	a4,0(sp)
    8020078a:	14040263          	beqz	s0,802008ce <vprintfmt+0x32a>
            if (width > 0 && padc != '-') {
    8020078e:	0fb05763          	blez	s11,8020087c <vprintfmt+0x2d8>
    80200792:	02d00693          	li	a3,45
    80200796:	0cd79163          	bne	a5,a3,80200858 <vprintfmt+0x2b4>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
    8020079a:	00044783          	lbu	a5,0(s0)
    8020079e:	0007851b          	sext.w	a0,a5
    802007a2:	cf85                	beqz	a5,802007da <vprintfmt+0x236>
    802007a4:	00140a13          	addi	s4,s0,1
                if (altflag && (ch < ' ' || ch > '~')) {
    802007a8:	05e00413          	li	s0,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
    802007ac:	000c4563          	bltz	s8,802007b6 <vprintfmt+0x212>
    802007b0:	3c7d                	addiw	s8,s8,-1
    802007b2:	036c0263          	beq	s8,s6,802007d6 <vprintfmt+0x232>
                    putch('?', putdat);
    802007b6:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
    802007b8:	0e0c8e63          	beqz	s9,802008b4 <vprintfmt+0x310>
    802007bc:	3781                	addiw	a5,a5,-32
    802007be:	0ef47b63          	bgeu	s0,a5,802008b4 <vprintfmt+0x310>
                    putch('?', putdat);
    802007c2:	03f00513          	li	a0,63
    802007c6:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
    802007c8:	000a4783          	lbu	a5,0(s4)
    802007cc:	3dfd                	addiw	s11,s11,-1
    802007ce:	0a05                	addi	s4,s4,1
    802007d0:	0007851b          	sext.w	a0,a5
    802007d4:	ffe1                	bnez	a5,802007ac <vprintfmt+0x208>
            for (; width > 0; width --) {
    802007d6:	01b05963          	blez	s11,802007e8 <vprintfmt+0x244>
    802007da:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
    802007dc:	85a6                	mv	a1,s1
    802007de:	02000513          	li	a0,32
    802007e2:	9902                	jalr	s2
            for (; width > 0; width --) {
    802007e4:	fe0d9be3          	bnez	s11,802007da <vprintfmt+0x236>
            if ((p = va_arg(ap, char *)) == NULL) {
    802007e8:	6a02                	ld	s4,0(sp)
    802007ea:	bbd5                	j	802005de <vprintfmt+0x3a>
    if (lflag >= 2) {
    802007ec:	4705                	li	a4,1
            precision = va_arg(ap, int);
    802007ee:	008a0c93          	addi	s9,s4,8
    if (lflag >= 2) {
    802007f2:	01174463          	blt	a4,a7,802007fa <vprintfmt+0x256>
    else if (lflag) {
    802007f6:	08088d63          	beqz	a7,80200890 <vprintfmt+0x2ec>
        return va_arg(*ap, long);
    802007fa:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
    802007fe:	0a044d63          	bltz	s0,802008b8 <vprintfmt+0x314>
            num = getint(&ap, lflag);
    80200802:	8622                	mv	a2,s0
    80200804:	8a66                	mv	s4,s9
    80200806:	46a9                	li	a3,10
    80200808:	bdcd                	j	802006fa <vprintfmt+0x156>
            err = va_arg(ap, int);
    8020080a:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
    8020080e:	4719                	li	a4,6
            err = va_arg(ap, int);
    80200810:	0a21                	addi	s4,s4,8
            if (err < 0) {
    80200812:	41f7d69b          	sraiw	a3,a5,0x1f
    80200816:	8fb5                	xor	a5,a5,a3
    80200818:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
    8020081c:	02d74163          	blt	a4,a3,8020083e <vprintfmt+0x29a>
    80200820:	00369793          	slli	a5,a3,0x3
    80200824:	97de                	add	a5,a5,s7
    80200826:	639c                	ld	a5,0(a5)
    80200828:	cb99                	beqz	a5,8020083e <vprintfmt+0x29a>
                printfmt(putch, putdat, "%s", p);
    8020082a:	86be                	mv	a3,a5
    8020082c:	00000617          	auipc	a2,0x0
    80200830:	6d460613          	addi	a2,a2,1748 # 80200f00 <etext+0x5a6>
    80200834:	85a6                	mv	a1,s1
    80200836:	854a                	mv	a0,s2
    80200838:	0ce000ef          	jal	ra,80200906 <printfmt>
    8020083c:	b34d                	j	802005de <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
    8020083e:	00000617          	auipc	a2,0x0
    80200842:	6b260613          	addi	a2,a2,1714 # 80200ef0 <etext+0x596>
    80200846:	85a6                	mv	a1,s1
    80200848:	854a                	mv	a0,s2
    8020084a:	0bc000ef          	jal	ra,80200906 <printfmt>
    8020084e:	bb41                	j	802005de <vprintfmt+0x3a>
                p = "(null)";
    80200850:	00000417          	auipc	s0,0x0
    80200854:	69840413          	addi	s0,s0,1688 # 80200ee8 <etext+0x58e>
                for (width -= strnlen(p, precision); width > 0; width --) {
    80200858:	85e2                	mv	a1,s8
    8020085a:	8522                	mv	a0,s0
    8020085c:	e43e                	sd	a5,8(sp)
    8020085e:	cadff0ef          	jal	ra,8020050a <strnlen>
    80200862:	40ad8dbb          	subw	s11,s11,a0
    80200866:	01b05b63          	blez	s11,8020087c <vprintfmt+0x2d8>
                    putch(padc, putdat);
    8020086a:	67a2                	ld	a5,8(sp)
    8020086c:	00078a1b          	sext.w	s4,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
    80200870:	3dfd                	addiw	s11,s11,-1
                    putch(padc, putdat);
    80200872:	85a6                	mv	a1,s1
    80200874:	8552                	mv	a0,s4
    80200876:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
    80200878:	fe0d9ce3          	bnez	s11,80200870 <vprintfmt+0x2cc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
    8020087c:	00044783          	lbu	a5,0(s0)
    80200880:	00140a13          	addi	s4,s0,1
    80200884:	0007851b          	sext.w	a0,a5
    80200888:	d3a5                	beqz	a5,802007e8 <vprintfmt+0x244>
                if (altflag && (ch < ' ' || ch > '~')) {
    8020088a:	05e00413          	li	s0,94
    8020088e:	bf39                	j	802007ac <vprintfmt+0x208>
        return va_arg(*ap, int);
    80200890:	000a2403          	lw	s0,0(s4)
    80200894:	b7ad                	j	802007fe <vprintfmt+0x25a>
        return va_arg(*ap, unsigned int);
    80200896:	000a6603          	lwu	a2,0(s4)
    8020089a:	46a1                	li	a3,8
    8020089c:	8a2e                	mv	s4,a1
    8020089e:	bdb1                	j	802006fa <vprintfmt+0x156>
    802008a0:	000a6603          	lwu	a2,0(s4)
    802008a4:	46a9                	li	a3,10
    802008a6:	8a2e                	mv	s4,a1
    802008a8:	bd89                	j	802006fa <vprintfmt+0x156>
    802008aa:	000a6603          	lwu	a2,0(s4)
    802008ae:	46c1                	li	a3,16
    802008b0:	8a2e                	mv	s4,a1
    802008b2:	b5a1                	j	802006fa <vprintfmt+0x156>
                    putch(ch, putdat);
    802008b4:	9902                	jalr	s2
    802008b6:	bf09                	j	802007c8 <vprintfmt+0x224>
                putch('-', putdat);
    802008b8:	85a6                	mv	a1,s1
    802008ba:	02d00513          	li	a0,45
    802008be:	e03e                	sd	a5,0(sp)
    802008c0:	9902                	jalr	s2
                num = -(long long)num;
    802008c2:	6782                	ld	a5,0(sp)
    802008c4:	8a66                	mv	s4,s9
    802008c6:	40800633          	neg	a2,s0
    802008ca:	46a9                	li	a3,10
    802008cc:	b53d                	j	802006fa <vprintfmt+0x156>
            if (width > 0 && padc != '-') {
    802008ce:	03b05163          	blez	s11,802008f0 <vprintfmt+0x34c>
    802008d2:	02d00693          	li	a3,45
    802008d6:	f6d79de3          	bne	a5,a3,80200850 <vprintfmt+0x2ac>
                p = "(null)";
    802008da:	00000417          	auipc	s0,0x0
    802008de:	60e40413          	addi	s0,s0,1550 # 80200ee8 <etext+0x58e>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
    802008e2:	02800793          	li	a5,40
    802008e6:	02800513          	li	a0,40
    802008ea:	00140a13          	addi	s4,s0,1
    802008ee:	bd6d                	j	802007a8 <vprintfmt+0x204>
    802008f0:	00000a17          	auipc	s4,0x0
    802008f4:	5f9a0a13          	addi	s4,s4,1529 # 80200ee9 <etext+0x58f>
    802008f8:	02800513          	li	a0,40
    802008fc:	02800793          	li	a5,40
                if (altflag && (ch < ' ' || ch > '~')) {
    80200900:	05e00413          	li	s0,94
    80200904:	b565                	j	802007ac <vprintfmt+0x208>

0000000080200906 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
    80200906:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
    80200908:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
    8020090c:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
    8020090e:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
    80200910:	ec06                	sd	ra,24(sp)
    80200912:	f83a                	sd	a4,48(sp)
    80200914:	fc3e                	sd	a5,56(sp)
    80200916:	e0c2                	sd	a6,64(sp)
    80200918:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
    8020091a:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
    8020091c:	c89ff0ef          	jal	ra,802005a4 <vprintfmt>
}
    80200920:	60e2                	ld	ra,24(sp)
    80200922:	6161                	addi	sp,sp,80
    80200924:	8082                	ret

0000000080200926 <sbi_console_putchar>:
uint64_t SBI_REMOTE_SFENCE_VMA_ASID = 7;
uint64_t SBI_SHUTDOWN = 8;

uint64_t sbi_call(uint64_t sbi_type, uint64_t arg0, uint64_t arg1, uint64_t arg2) {
    uint64_t ret_val;
    __asm__ volatile (
    80200926:	4781                	li	a5,0
    80200928:	00003717          	auipc	a4,0x3
    8020092c:	6d873703          	ld	a4,1752(a4) # 80204000 <SBI_CONSOLE_PUTCHAR>
    80200930:	88ba                	mv	a7,a4
    80200932:	852a                	mv	a0,a0
    80200934:	85be                	mv	a1,a5
    80200936:	863e                	mv	a2,a5
    80200938:	00000073          	ecall
    8020093c:	87aa                	mv	a5,a0
int sbi_console_getchar(void) {
    return sbi_call(SBI_CONSOLE_GETCHAR, 0, 0, 0);
}
void sbi_console_putchar(unsigned char ch) {
    sbi_call(SBI_CONSOLE_PUTCHAR, ch, 0, 0);
}
    8020093e:	8082                	ret

0000000080200940 <sbi_set_timer>:
    __asm__ volatile (
    80200940:	4781                	li	a5,0
    80200942:	00003717          	auipc	a4,0x3
    80200946:	6ce73703          	ld	a4,1742(a4) # 80204010 <SBI_SET_TIMER>
    8020094a:	88ba                	mv	a7,a4
    8020094c:	852a                	mv	a0,a0
    8020094e:	85be                	mv	a1,a5
    80200950:	863e                	mv	a2,a5
    80200952:	00000073          	ecall
    80200956:	87aa                	mv	a5,a0
//当time寄存器(rdtime的返回值)为stime_value的时候触发一个时钟中断
void sbi_set_timer(unsigned long long stime_value) {
    sbi_call(SBI_SET_TIMER, stime_value, 0, 0);
}
    80200958:	8082                	ret
