
bin/kernel：     文件格式 elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:

    .section .text,"ax",%progbits
    .globl kern_entry
kern_entry:
    # t0 := 三级页表的虚拟地址
    lui     t0, %hi(boot_page_table_sv39)
ffffffffc0200000:	c02052b7          	lui	t0,0xc0205
    # t1 := 0xffffffff40000000 即虚实映射偏移量
    li      t1, 0xffffffffc0000000 - 0x80000000
ffffffffc0200004:	ffd0031b          	addiw	t1,zero,-3
ffffffffc0200008:	037a                	slli	t1,t1,0x1e
    # t0 减去虚实映射偏移量 0xffffffff40000000，变为三级页表的物理地址
    sub     t0, t0, t1
ffffffffc020000a:	406282b3          	sub	t0,t0,t1
    # t0 >>= 12，变为三级页表的物理页号
    srli    t0, t0, 12
ffffffffc020000e:	00c2d293          	srli	t0,t0,0xc

    # t1 := 8 << 60，设置 satp 的 MODE 字段为 Sv39
    li      t1, 8 << 60
ffffffffc0200012:	fff0031b          	addiw	t1,zero,-1
ffffffffc0200016:	137e                	slli	t1,t1,0x3f
    # 将刚才计算出的预设三级页表物理页号附加到 satp 中
    or      t0, t0, t1
ffffffffc0200018:	0062e2b3          	or	t0,t0,t1
    # 将算出的 t0(即新的MODE|页表基址物理页号) 覆盖到 satp 中
    csrw    satp, t0
ffffffffc020001c:	18029073          	csrw	satp,t0
    # 使用 sfence.vma 指令刷新 TLB
    sfence.vma
ffffffffc0200020:	12000073          	sfence.vma
    # 从此，我们给内核搭建出了一个完美的虚拟内存空间！
    #nop # 可能映射的位置有些bug。。插入一个nop
    
    # 我们在虚拟内存空间中：随意将 sp 设置为虚拟地址！
    lui sp, %hi(bootstacktop)
ffffffffc0200024:	c0205137          	lui	sp,0xc0205

    # 我们在虚拟内存空间中：随意跳转到虚拟地址！
    # 跳转到 kern_init
    lui t0, %hi(kern_init)
ffffffffc0200028:	c02002b7          	lui	t0,0xc0200
    addi t0, t0, %lo(kern_init)
ffffffffc020002c:	03228293          	addi	t0,t0,50 # ffffffffc0200032 <kern_init>
    jr t0
ffffffffc0200030:	8282                	jr	t0

ffffffffc0200032 <kern_init>:
void grade_backtrace(void);


int kern_init(void) {
    extern char edata[], end[];
    memset(edata, 0, end - edata);
ffffffffc0200032:	00006517          	auipc	a0,0x6
ffffffffc0200036:	fde50513          	addi	a0,a0,-34 # ffffffffc0206010 <free_area>
ffffffffc020003a:	00006617          	auipc	a2,0x6
ffffffffc020003e:	43660613          	addi	a2,a2,1078 # ffffffffc0206470 <end>
int kern_init(void) {
ffffffffc0200042:	1141                	addi	sp,sp,-16
    memset(edata, 0, end - edata);
ffffffffc0200044:	8e09                	sub	a2,a2,a0
ffffffffc0200046:	4581                	li	a1,0
int kern_init(void) {
ffffffffc0200048:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc020004a:	4c0010ef          	jal	ra,ffffffffc020150a <memset>
    cons_init();  // init the console
ffffffffc020004e:	3fc000ef          	jal	ra,ffffffffc020044a <cons_init>
    const char *message = "(THU.CST) os is loading ...\0";
    //cprintf("%s\n\n", message);
    cputs(message);
ffffffffc0200052:	00002517          	auipc	a0,0x2
ffffffffc0200056:	9be50513          	addi	a0,a0,-1602 # ffffffffc0201a10 <etext+0x2>
ffffffffc020005a:	090000ef          	jal	ra,ffffffffc02000ea <cputs>

    print_kerninfo();
ffffffffc020005e:	138000ef          	jal	ra,ffffffffc0200196 <print_kerninfo>

    // grade_backtrace();
    idt_init();  // init interrupt descriptor table
ffffffffc0200062:	402000ef          	jal	ra,ffffffffc0200464 <idt_init>

    pmm_init();  // init physical memory management
ffffffffc0200066:	053000ef          	jal	ra,ffffffffc02008b8 <pmm_init>

    idt_init();  // init interrupt descriptor table
ffffffffc020006a:	3fa000ef          	jal	ra,ffffffffc0200464 <idt_init>

    clock_init();   // init clock interrupt
ffffffffc020006e:	39a000ef          	jal	ra,ffffffffc0200408 <clock_init>
    intr_enable();  // enable irq interrupt
ffffffffc0200072:	3e6000ef          	jal	ra,ffffffffc0200458 <intr_enable>



    /* do nothing */
    while (1)
ffffffffc0200076:	a001                	j	ffffffffc0200076 <kern_init+0x44>

ffffffffc0200078 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
ffffffffc0200078:	1141                	addi	sp,sp,-16
ffffffffc020007a:	e022                	sd	s0,0(sp)
ffffffffc020007c:	e406                	sd	ra,8(sp)
ffffffffc020007e:	842e                	mv	s0,a1
    cons_putc(c);
ffffffffc0200080:	3cc000ef          	jal	ra,ffffffffc020044c <cons_putc>
    (*cnt) ++;
ffffffffc0200084:	401c                	lw	a5,0(s0)
}
ffffffffc0200086:	60a2                	ld	ra,8(sp)
    (*cnt) ++;
ffffffffc0200088:	2785                	addiw	a5,a5,1
ffffffffc020008a:	c01c                	sw	a5,0(s0)
}
ffffffffc020008c:	6402                	ld	s0,0(sp)
ffffffffc020008e:	0141                	addi	sp,sp,16
ffffffffc0200090:	8082                	ret

ffffffffc0200092 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
ffffffffc0200092:	1101                	addi	sp,sp,-32
ffffffffc0200094:	862a                	mv	a2,a0
ffffffffc0200096:	86ae                	mv	a3,a1
    int cnt = 0;
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc0200098:	00000517          	auipc	a0,0x0
ffffffffc020009c:	fe050513          	addi	a0,a0,-32 # ffffffffc0200078 <cputch>
ffffffffc02000a0:	006c                	addi	a1,sp,12
vcprintf(const char *fmt, va_list ap) {
ffffffffc02000a2:	ec06                	sd	ra,24(sp)
    int cnt = 0;
ffffffffc02000a4:	c602                	sw	zero,12(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc02000a6:	4e2010ef          	jal	ra,ffffffffc0201588 <vprintfmt>
    return cnt;
}
ffffffffc02000aa:	60e2                	ld	ra,24(sp)
ffffffffc02000ac:	4532                	lw	a0,12(sp)
ffffffffc02000ae:	6105                	addi	sp,sp,32
ffffffffc02000b0:	8082                	ret

ffffffffc02000b2 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
ffffffffc02000b2:	711d                	addi	sp,sp,-96
    va_list ap;
    int cnt;
    va_start(ap, fmt);
ffffffffc02000b4:	02810313          	addi	t1,sp,40 # ffffffffc0205028 <boot_page_table_sv39+0x28>
cprintf(const char *fmt, ...) {
ffffffffc02000b8:	8e2a                	mv	t3,a0
ffffffffc02000ba:	f42e                	sd	a1,40(sp)
ffffffffc02000bc:	f832                	sd	a2,48(sp)
ffffffffc02000be:	fc36                	sd	a3,56(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc02000c0:	00000517          	auipc	a0,0x0
ffffffffc02000c4:	fb850513          	addi	a0,a0,-72 # ffffffffc0200078 <cputch>
ffffffffc02000c8:	004c                	addi	a1,sp,4
ffffffffc02000ca:	869a                	mv	a3,t1
ffffffffc02000cc:	8672                	mv	a2,t3
cprintf(const char *fmt, ...) {
ffffffffc02000ce:	ec06                	sd	ra,24(sp)
ffffffffc02000d0:	e0ba                	sd	a4,64(sp)
ffffffffc02000d2:	e4be                	sd	a5,72(sp)
ffffffffc02000d4:	e8c2                	sd	a6,80(sp)
ffffffffc02000d6:	ecc6                	sd	a7,88(sp)
    va_start(ap, fmt);
ffffffffc02000d8:	e41a                	sd	t1,8(sp)
    int cnt = 0;
ffffffffc02000da:	c202                	sw	zero,4(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc02000dc:	4ac010ef          	jal	ra,ffffffffc0201588 <vprintfmt>
    cnt = vcprintf(fmt, ap);
    va_end(ap);
    return cnt;
}
ffffffffc02000e0:	60e2                	ld	ra,24(sp)
ffffffffc02000e2:	4512                	lw	a0,4(sp)
ffffffffc02000e4:	6125                	addi	sp,sp,96
ffffffffc02000e6:	8082                	ret

ffffffffc02000e8 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
    cons_putc(c);
ffffffffc02000e8:	a695                	j	ffffffffc020044c <cons_putc>

ffffffffc02000ea <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
ffffffffc02000ea:	1101                	addi	sp,sp,-32
ffffffffc02000ec:	e822                	sd	s0,16(sp)
ffffffffc02000ee:	ec06                	sd	ra,24(sp)
ffffffffc02000f0:	e426                	sd	s1,8(sp)
ffffffffc02000f2:	842a                	mv	s0,a0
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
ffffffffc02000f4:	00054503          	lbu	a0,0(a0)
ffffffffc02000f8:	c51d                	beqz	a0,ffffffffc0200126 <cputs+0x3c>
ffffffffc02000fa:	0405                	addi	s0,s0,1
ffffffffc02000fc:	4485                	li	s1,1
ffffffffc02000fe:	9c81                	subw	s1,s1,s0
    cons_putc(c);
ffffffffc0200100:	34c000ef          	jal	ra,ffffffffc020044c <cons_putc>
    while ((c = *str ++) != '\0') {
ffffffffc0200104:	00044503          	lbu	a0,0(s0)
ffffffffc0200108:	008487bb          	addw	a5,s1,s0
ffffffffc020010c:	0405                	addi	s0,s0,1
ffffffffc020010e:	f96d                	bnez	a0,ffffffffc0200100 <cputs+0x16>
    (*cnt) ++;
ffffffffc0200110:	0017841b          	addiw	s0,a5,1
    cons_putc(c);
ffffffffc0200114:	4529                	li	a0,10
ffffffffc0200116:	336000ef          	jal	ra,ffffffffc020044c <cons_putc>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
    return cnt;
}
ffffffffc020011a:	60e2                	ld	ra,24(sp)
ffffffffc020011c:	8522                	mv	a0,s0
ffffffffc020011e:	6442                	ld	s0,16(sp)
ffffffffc0200120:	64a2                	ld	s1,8(sp)
ffffffffc0200122:	6105                	addi	sp,sp,32
ffffffffc0200124:	8082                	ret
    while ((c = *str ++) != '\0') {
ffffffffc0200126:	4405                	li	s0,1
ffffffffc0200128:	b7f5                	j	ffffffffc0200114 <cputs+0x2a>

ffffffffc020012a <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
ffffffffc020012a:	1141                	addi	sp,sp,-16
ffffffffc020012c:	e406                	sd	ra,8(sp)
    int c;
    while ((c = cons_getc()) == 0)
ffffffffc020012e:	326000ef          	jal	ra,ffffffffc0200454 <cons_getc>
ffffffffc0200132:	dd75                	beqz	a0,ffffffffc020012e <getchar+0x4>
        /* do nothing */;
    return c;
}
ffffffffc0200134:	60a2                	ld	ra,8(sp)
ffffffffc0200136:	0141                	addi	sp,sp,16
ffffffffc0200138:	8082                	ret

ffffffffc020013a <__panic>:
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
ffffffffc020013a:	00006317          	auipc	t1,0x6
ffffffffc020013e:	2ee30313          	addi	t1,t1,750 # ffffffffc0206428 <is_panic>
ffffffffc0200142:	00032e03          	lw	t3,0(t1)
__panic(const char *file, int line, const char *fmt, ...) {
ffffffffc0200146:	715d                	addi	sp,sp,-80
ffffffffc0200148:	ec06                	sd	ra,24(sp)
ffffffffc020014a:	e822                	sd	s0,16(sp)
ffffffffc020014c:	f436                	sd	a3,40(sp)
ffffffffc020014e:	f83a                	sd	a4,48(sp)
ffffffffc0200150:	fc3e                	sd	a5,56(sp)
ffffffffc0200152:	e0c2                	sd	a6,64(sp)
ffffffffc0200154:	e4c6                	sd	a7,72(sp)
    if (is_panic) {
ffffffffc0200156:	020e1a63          	bnez	t3,ffffffffc020018a <__panic+0x50>
        goto panic_dead;
    }
    is_panic = 1;
ffffffffc020015a:	4785                	li	a5,1
ffffffffc020015c:	00f32023          	sw	a5,0(t1)

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
ffffffffc0200160:	8432                	mv	s0,a2
ffffffffc0200162:	103c                	addi	a5,sp,40
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc0200164:	862e                	mv	a2,a1
ffffffffc0200166:	85aa                	mv	a1,a0
ffffffffc0200168:	00002517          	auipc	a0,0x2
ffffffffc020016c:	8c850513          	addi	a0,a0,-1848 # ffffffffc0201a30 <etext+0x22>
    va_start(ap, fmt);
ffffffffc0200170:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc0200172:	f41ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    vcprintf(fmt, ap);
ffffffffc0200176:	65a2                	ld	a1,8(sp)
ffffffffc0200178:	8522                	mv	a0,s0
ffffffffc020017a:	f19ff0ef          	jal	ra,ffffffffc0200092 <vcprintf>
    cprintf("\n");
ffffffffc020017e:	00002517          	auipc	a0,0x2
ffffffffc0200182:	99a50513          	addi	a0,a0,-1638 # ffffffffc0201b18 <etext+0x10a>
ffffffffc0200186:	f2dff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
ffffffffc020018a:	2d4000ef          	jal	ra,ffffffffc020045e <intr_disable>
    while (1) {
        kmonitor(NULL);
ffffffffc020018e:	4501                	li	a0,0
ffffffffc0200190:	130000ef          	jal	ra,ffffffffc02002c0 <kmonitor>
    while (1) {
ffffffffc0200194:	bfed                	j	ffffffffc020018e <__panic+0x54>

ffffffffc0200196 <print_kerninfo>:
/* *
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void) {
ffffffffc0200196:	1141                	addi	sp,sp,-16
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
ffffffffc0200198:	00002517          	auipc	a0,0x2
ffffffffc020019c:	8b850513          	addi	a0,a0,-1864 # ffffffffc0201a50 <etext+0x42>
void print_kerninfo(void) {
ffffffffc02001a0:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc02001a2:	f11ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  entry  0x%016lx (virtual)\n", kern_init);
ffffffffc02001a6:	00000597          	auipc	a1,0x0
ffffffffc02001aa:	e8c58593          	addi	a1,a1,-372 # ffffffffc0200032 <kern_init>
ffffffffc02001ae:	00002517          	auipc	a0,0x2
ffffffffc02001b2:	8c250513          	addi	a0,a0,-1854 # ffffffffc0201a70 <etext+0x62>
ffffffffc02001b6:	efdff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  etext  0x%016lx (virtual)\n", etext);
ffffffffc02001ba:	00002597          	auipc	a1,0x2
ffffffffc02001be:	85458593          	addi	a1,a1,-1964 # ffffffffc0201a0e <etext>
ffffffffc02001c2:	00002517          	auipc	a0,0x2
ffffffffc02001c6:	8ce50513          	addi	a0,a0,-1842 # ffffffffc0201a90 <etext+0x82>
ffffffffc02001ca:	ee9ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  edata  0x%016lx (virtual)\n", edata);
ffffffffc02001ce:	00006597          	auipc	a1,0x6
ffffffffc02001d2:	e4258593          	addi	a1,a1,-446 # ffffffffc0206010 <free_area>
ffffffffc02001d6:	00002517          	auipc	a0,0x2
ffffffffc02001da:	8da50513          	addi	a0,a0,-1830 # ffffffffc0201ab0 <etext+0xa2>
ffffffffc02001de:	ed5ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  end    0x%016lx (virtual)\n", end);
ffffffffc02001e2:	00006597          	auipc	a1,0x6
ffffffffc02001e6:	28e58593          	addi	a1,a1,654 # ffffffffc0206470 <end>
ffffffffc02001ea:	00002517          	auipc	a0,0x2
ffffffffc02001ee:	8e650513          	addi	a0,a0,-1818 # ffffffffc0201ad0 <etext+0xc2>
ffffffffc02001f2:	ec1ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - kern_init + 1023) / 1024);
ffffffffc02001f6:	00006597          	auipc	a1,0x6
ffffffffc02001fa:	67958593          	addi	a1,a1,1657 # ffffffffc020686f <end+0x3ff>
ffffffffc02001fe:	00000797          	auipc	a5,0x0
ffffffffc0200202:	e3478793          	addi	a5,a5,-460 # ffffffffc0200032 <kern_init>
ffffffffc0200206:	40f587b3          	sub	a5,a1,a5
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc020020a:	43f7d593          	srai	a1,a5,0x3f
}
ffffffffc020020e:	60a2                	ld	ra,8(sp)
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc0200210:	3ff5f593          	andi	a1,a1,1023
ffffffffc0200214:	95be                	add	a1,a1,a5
ffffffffc0200216:	85a9                	srai	a1,a1,0xa
ffffffffc0200218:	00002517          	auipc	a0,0x2
ffffffffc020021c:	8d850513          	addi	a0,a0,-1832 # ffffffffc0201af0 <etext+0xe2>
}
ffffffffc0200220:	0141                	addi	sp,sp,16
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc0200222:	bd41                	j	ffffffffc02000b2 <cprintf>

ffffffffc0200224 <print_stackframe>:
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before
 * jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the
 * boundary.
 * */
void print_stackframe(void) {
ffffffffc0200224:	1141                	addi	sp,sp,-16

    panic("Not Implemented!");
ffffffffc0200226:	00002617          	auipc	a2,0x2
ffffffffc020022a:	8fa60613          	addi	a2,a2,-1798 # ffffffffc0201b20 <etext+0x112>
ffffffffc020022e:	04e00593          	li	a1,78
ffffffffc0200232:	00002517          	auipc	a0,0x2
ffffffffc0200236:	90650513          	addi	a0,a0,-1786 # ffffffffc0201b38 <etext+0x12a>
void print_stackframe(void) {
ffffffffc020023a:	e406                	sd	ra,8(sp)
    panic("Not Implemented!");
ffffffffc020023c:	effff0ef          	jal	ra,ffffffffc020013a <__panic>

ffffffffc0200240 <mon_help>:
    }
}

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc0200240:	1141                	addi	sp,sp,-16
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc0200242:	00002617          	auipc	a2,0x2
ffffffffc0200246:	90e60613          	addi	a2,a2,-1778 # ffffffffc0201b50 <etext+0x142>
ffffffffc020024a:	00002597          	auipc	a1,0x2
ffffffffc020024e:	92658593          	addi	a1,a1,-1754 # ffffffffc0201b70 <etext+0x162>
ffffffffc0200252:	00002517          	auipc	a0,0x2
ffffffffc0200256:	92650513          	addi	a0,a0,-1754 # ffffffffc0201b78 <etext+0x16a>
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc020025a:	e406                	sd	ra,8(sp)
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc020025c:	e57ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200260:	00002617          	auipc	a2,0x2
ffffffffc0200264:	92860613          	addi	a2,a2,-1752 # ffffffffc0201b88 <etext+0x17a>
ffffffffc0200268:	00002597          	auipc	a1,0x2
ffffffffc020026c:	94858593          	addi	a1,a1,-1720 # ffffffffc0201bb0 <etext+0x1a2>
ffffffffc0200270:	00002517          	auipc	a0,0x2
ffffffffc0200274:	90850513          	addi	a0,a0,-1784 # ffffffffc0201b78 <etext+0x16a>
ffffffffc0200278:	e3bff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc020027c:	00002617          	auipc	a2,0x2
ffffffffc0200280:	94460613          	addi	a2,a2,-1724 # ffffffffc0201bc0 <etext+0x1b2>
ffffffffc0200284:	00002597          	auipc	a1,0x2
ffffffffc0200288:	95c58593          	addi	a1,a1,-1700 # ffffffffc0201be0 <etext+0x1d2>
ffffffffc020028c:	00002517          	auipc	a0,0x2
ffffffffc0200290:	8ec50513          	addi	a0,a0,-1812 # ffffffffc0201b78 <etext+0x16a>
ffffffffc0200294:	e1fff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    }
    return 0;
}
ffffffffc0200298:	60a2                	ld	ra,8(sp)
ffffffffc020029a:	4501                	li	a0,0
ffffffffc020029c:	0141                	addi	sp,sp,16
ffffffffc020029e:	8082                	ret

ffffffffc02002a0 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
ffffffffc02002a0:	1141                	addi	sp,sp,-16
ffffffffc02002a2:	e406                	sd	ra,8(sp)
    print_kerninfo();
ffffffffc02002a4:	ef3ff0ef          	jal	ra,ffffffffc0200196 <print_kerninfo>
    return 0;
}
ffffffffc02002a8:	60a2                	ld	ra,8(sp)
ffffffffc02002aa:	4501                	li	a0,0
ffffffffc02002ac:	0141                	addi	sp,sp,16
ffffffffc02002ae:	8082                	ret

ffffffffc02002b0 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
ffffffffc02002b0:	1141                	addi	sp,sp,-16
ffffffffc02002b2:	e406                	sd	ra,8(sp)
    print_stackframe();
ffffffffc02002b4:	f71ff0ef          	jal	ra,ffffffffc0200224 <print_stackframe>
    return 0;
}
ffffffffc02002b8:	60a2                	ld	ra,8(sp)
ffffffffc02002ba:	4501                	li	a0,0
ffffffffc02002bc:	0141                	addi	sp,sp,16
ffffffffc02002be:	8082                	ret

ffffffffc02002c0 <kmonitor>:
kmonitor(struct trapframe *tf) {
ffffffffc02002c0:	7115                	addi	sp,sp,-224
ffffffffc02002c2:	ed5e                	sd	s7,152(sp)
ffffffffc02002c4:	8baa                	mv	s7,a0
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc02002c6:	00002517          	auipc	a0,0x2
ffffffffc02002ca:	92a50513          	addi	a0,a0,-1750 # ffffffffc0201bf0 <etext+0x1e2>
kmonitor(struct trapframe *tf) {
ffffffffc02002ce:	ed86                	sd	ra,216(sp)
ffffffffc02002d0:	e9a2                	sd	s0,208(sp)
ffffffffc02002d2:	e5a6                	sd	s1,200(sp)
ffffffffc02002d4:	e1ca                	sd	s2,192(sp)
ffffffffc02002d6:	fd4e                	sd	s3,184(sp)
ffffffffc02002d8:	f952                	sd	s4,176(sp)
ffffffffc02002da:	f556                	sd	s5,168(sp)
ffffffffc02002dc:	f15a                	sd	s6,160(sp)
ffffffffc02002de:	e962                	sd	s8,144(sp)
ffffffffc02002e0:	e566                	sd	s9,136(sp)
ffffffffc02002e2:	e16a                	sd	s10,128(sp)
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc02002e4:	dcfff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
ffffffffc02002e8:	00002517          	auipc	a0,0x2
ffffffffc02002ec:	93050513          	addi	a0,a0,-1744 # ffffffffc0201c18 <etext+0x20a>
ffffffffc02002f0:	dc3ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    if (tf != NULL) {
ffffffffc02002f4:	000b8563          	beqz	s7,ffffffffc02002fe <kmonitor+0x3e>
        print_trapframe(tf);
ffffffffc02002f8:	855e                	mv	a0,s7
ffffffffc02002fa:	348000ef          	jal	ra,ffffffffc0200642 <print_trapframe>
ffffffffc02002fe:	00002c17          	auipc	s8,0x2
ffffffffc0200302:	98ac0c13          	addi	s8,s8,-1654 # ffffffffc0201c88 <commands>
        if ((buf = readline("K> ")) != NULL) {
ffffffffc0200306:	00002917          	auipc	s2,0x2
ffffffffc020030a:	93a90913          	addi	s2,s2,-1734 # ffffffffc0201c40 <etext+0x232>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc020030e:	00002497          	auipc	s1,0x2
ffffffffc0200312:	93a48493          	addi	s1,s1,-1734 # ffffffffc0201c48 <etext+0x23a>
        if (argc == MAXARGS - 1) {
ffffffffc0200316:	49bd                	li	s3,15
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc0200318:	00002b17          	auipc	s6,0x2
ffffffffc020031c:	938b0b13          	addi	s6,s6,-1736 # ffffffffc0201c50 <etext+0x242>
        argv[argc ++] = buf;
ffffffffc0200320:	00002a17          	auipc	s4,0x2
ffffffffc0200324:	850a0a13          	addi	s4,s4,-1968 # ffffffffc0201b70 <etext+0x162>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc0200328:	4a8d                	li	s5,3
        if ((buf = readline("K> ")) != NULL) {
ffffffffc020032a:	854a                	mv	a0,s2
ffffffffc020032c:	5de010ef          	jal	ra,ffffffffc020190a <readline>
ffffffffc0200330:	842a                	mv	s0,a0
ffffffffc0200332:	dd65                	beqz	a0,ffffffffc020032a <kmonitor+0x6a>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200334:	00054583          	lbu	a1,0(a0)
    int argc = 0;
ffffffffc0200338:	4c81                	li	s9,0
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc020033a:	e1bd                	bnez	a1,ffffffffc02003a0 <kmonitor+0xe0>
    if (argc == 0) {
ffffffffc020033c:	fe0c87e3          	beqz	s9,ffffffffc020032a <kmonitor+0x6a>
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc0200340:	6582                	ld	a1,0(sp)
ffffffffc0200342:	00002d17          	auipc	s10,0x2
ffffffffc0200346:	946d0d13          	addi	s10,s10,-1722 # ffffffffc0201c88 <commands>
        argv[argc ++] = buf;
ffffffffc020034a:	8552                	mv	a0,s4
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc020034c:	4401                	li	s0,0
ffffffffc020034e:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc0200350:	186010ef          	jal	ra,ffffffffc02014d6 <strcmp>
ffffffffc0200354:	c919                	beqz	a0,ffffffffc020036a <kmonitor+0xaa>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc0200356:	2405                	addiw	s0,s0,1
ffffffffc0200358:	0b540063          	beq	s0,s5,ffffffffc02003f8 <kmonitor+0x138>
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc020035c:	000d3503          	ld	a0,0(s10)
ffffffffc0200360:	6582                	ld	a1,0(sp)
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc0200362:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc0200364:	172010ef          	jal	ra,ffffffffc02014d6 <strcmp>
ffffffffc0200368:	f57d                	bnez	a0,ffffffffc0200356 <kmonitor+0x96>
            return commands[i].func(argc - 1, argv + 1, tf);
ffffffffc020036a:	00141793          	slli	a5,s0,0x1
ffffffffc020036e:	97a2                	add	a5,a5,s0
ffffffffc0200370:	078e                	slli	a5,a5,0x3
ffffffffc0200372:	97e2                	add	a5,a5,s8
ffffffffc0200374:	6b9c                	ld	a5,16(a5)
ffffffffc0200376:	865e                	mv	a2,s7
ffffffffc0200378:	002c                	addi	a1,sp,8
ffffffffc020037a:	fffc851b          	addiw	a0,s9,-1
ffffffffc020037e:	9782                	jalr	a5
            if (runcmd(buf, tf) < 0) {
ffffffffc0200380:	fa0555e3          	bgez	a0,ffffffffc020032a <kmonitor+0x6a>
}
ffffffffc0200384:	60ee                	ld	ra,216(sp)
ffffffffc0200386:	644e                	ld	s0,208(sp)
ffffffffc0200388:	64ae                	ld	s1,200(sp)
ffffffffc020038a:	690e                	ld	s2,192(sp)
ffffffffc020038c:	79ea                	ld	s3,184(sp)
ffffffffc020038e:	7a4a                	ld	s4,176(sp)
ffffffffc0200390:	7aaa                	ld	s5,168(sp)
ffffffffc0200392:	7b0a                	ld	s6,160(sp)
ffffffffc0200394:	6bea                	ld	s7,152(sp)
ffffffffc0200396:	6c4a                	ld	s8,144(sp)
ffffffffc0200398:	6caa                	ld	s9,136(sp)
ffffffffc020039a:	6d0a                	ld	s10,128(sp)
ffffffffc020039c:	612d                	addi	sp,sp,224
ffffffffc020039e:	8082                	ret
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02003a0:	8526                	mv	a0,s1
ffffffffc02003a2:	152010ef          	jal	ra,ffffffffc02014f4 <strchr>
ffffffffc02003a6:	c901                	beqz	a0,ffffffffc02003b6 <kmonitor+0xf6>
ffffffffc02003a8:	00144583          	lbu	a1,1(s0)
            *buf ++ = '\0';
ffffffffc02003ac:	00040023          	sb	zero,0(s0)
ffffffffc02003b0:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02003b2:	d5c9                	beqz	a1,ffffffffc020033c <kmonitor+0x7c>
ffffffffc02003b4:	b7f5                	j	ffffffffc02003a0 <kmonitor+0xe0>
        if (*buf == '\0') {
ffffffffc02003b6:	00044783          	lbu	a5,0(s0)
ffffffffc02003ba:	d3c9                	beqz	a5,ffffffffc020033c <kmonitor+0x7c>
        if (argc == MAXARGS - 1) {
ffffffffc02003bc:	033c8963          	beq	s9,s3,ffffffffc02003ee <kmonitor+0x12e>
        argv[argc ++] = buf;
ffffffffc02003c0:	003c9793          	slli	a5,s9,0x3
ffffffffc02003c4:	0118                	addi	a4,sp,128
ffffffffc02003c6:	97ba                	add	a5,a5,a4
ffffffffc02003c8:	f887b023          	sd	s0,-128(a5)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc02003cc:	00044583          	lbu	a1,0(s0)
        argv[argc ++] = buf;
ffffffffc02003d0:	2c85                	addiw	s9,s9,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc02003d2:	e591                	bnez	a1,ffffffffc02003de <kmonitor+0x11e>
ffffffffc02003d4:	b7b5                	j	ffffffffc0200340 <kmonitor+0x80>
ffffffffc02003d6:	00144583          	lbu	a1,1(s0)
            buf ++;
ffffffffc02003da:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc02003dc:	d1a5                	beqz	a1,ffffffffc020033c <kmonitor+0x7c>
ffffffffc02003de:	8526                	mv	a0,s1
ffffffffc02003e0:	114010ef          	jal	ra,ffffffffc02014f4 <strchr>
ffffffffc02003e4:	d96d                	beqz	a0,ffffffffc02003d6 <kmonitor+0x116>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02003e6:	00044583          	lbu	a1,0(s0)
ffffffffc02003ea:	d9a9                	beqz	a1,ffffffffc020033c <kmonitor+0x7c>
ffffffffc02003ec:	bf55                	j	ffffffffc02003a0 <kmonitor+0xe0>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc02003ee:	45c1                	li	a1,16
ffffffffc02003f0:	855a                	mv	a0,s6
ffffffffc02003f2:	cc1ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02003f6:	b7e9                	j	ffffffffc02003c0 <kmonitor+0x100>
    cprintf("Unknown command '%s'\n", argv[0]);
ffffffffc02003f8:	6582                	ld	a1,0(sp)
ffffffffc02003fa:	00002517          	auipc	a0,0x2
ffffffffc02003fe:	87650513          	addi	a0,a0,-1930 # ffffffffc0201c70 <etext+0x262>
ffffffffc0200402:	cb1ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    return 0;
ffffffffc0200406:	b715                	j	ffffffffc020032a <kmonitor+0x6a>

ffffffffc0200408 <clock_init>:

/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void clock_init(void) {
ffffffffc0200408:	1141                	addi	sp,sp,-16
ffffffffc020040a:	e406                	sd	ra,8(sp)
    // enable timer interrupt in sie
    set_csr(sie, MIP_STIP);
ffffffffc020040c:	02000793          	li	a5,32
ffffffffc0200410:	1047a7f3          	csrrs	a5,sie,a5
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc0200414:	c0102573          	rdtime	a0
    ticks = 0;

    cprintf("++ setup timer interrupts\n");
}

void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc0200418:	67e1                	lui	a5,0x18
ffffffffc020041a:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0xffffffffc01e7960>
ffffffffc020041e:	953e                	add	a0,a0,a5
ffffffffc0200420:	5b8010ef          	jal	ra,ffffffffc02019d8 <sbi_set_timer>
}
ffffffffc0200424:	60a2                	ld	ra,8(sp)
    ticks = 0;
ffffffffc0200426:	00006797          	auipc	a5,0x6
ffffffffc020042a:	0007b523          	sd	zero,10(a5) # ffffffffc0206430 <ticks>
    cprintf("++ setup timer interrupts\n");
ffffffffc020042e:	00002517          	auipc	a0,0x2
ffffffffc0200432:	8a250513          	addi	a0,a0,-1886 # ffffffffc0201cd0 <commands+0x48>
}
ffffffffc0200436:	0141                	addi	sp,sp,16
    cprintf("++ setup timer interrupts\n");
ffffffffc0200438:	b9ad                	j	ffffffffc02000b2 <cprintf>

ffffffffc020043a <clock_set_next_event>:
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc020043a:	c0102573          	rdtime	a0
void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc020043e:	67e1                	lui	a5,0x18
ffffffffc0200440:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0xffffffffc01e7960>
ffffffffc0200444:	953e                	add	a0,a0,a5
ffffffffc0200446:	5920106f          	j	ffffffffc02019d8 <sbi_set_timer>

ffffffffc020044a <cons_init>:

/* serial_intr - try to feed input characters from serial port */
void serial_intr(void) {}

/* cons_init - initializes the console devices */
void cons_init(void) {}
ffffffffc020044a:	8082                	ret

ffffffffc020044c <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) { sbi_console_putchar((unsigned char)c); }
ffffffffc020044c:	0ff57513          	andi	a0,a0,255
ffffffffc0200450:	56e0106f          	j	ffffffffc02019be <sbi_console_putchar>

ffffffffc0200454 <cons_getc>:
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int cons_getc(void) {
    int c = 0;
    c = sbi_console_getchar();
ffffffffc0200454:	59e0106f          	j	ffffffffc02019f2 <sbi_console_getchar>

ffffffffc0200458 <intr_enable>:
#include <intr.h>
#include <riscv.h>

/* intr_enable - enable irq interrupt */
void intr_enable(void) { set_csr(sstatus, SSTATUS_SIE); }
ffffffffc0200458:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc020045c:	8082                	ret

ffffffffc020045e <intr_disable>:

/* intr_disable - disable irq interrupt */
void intr_disable(void) { clear_csr(sstatus, SSTATUS_SIE); }
ffffffffc020045e:	100177f3          	csrrci	a5,sstatus,2
ffffffffc0200462:	8082                	ret

ffffffffc0200464 <idt_init>:
     */

    extern void __alltraps(void);
    /* Set sup0 scratch register to 0, indicating to exception vector
       that we are presently executing in the kernel */
    write_csr(sscratch, 0);
ffffffffc0200464:	14005073          	csrwi	sscratch,0
    /* Set the exception vector address */
    write_csr(stvec, &__alltraps);
ffffffffc0200468:	00000797          	auipc	a5,0x0
ffffffffc020046c:	2e478793          	addi	a5,a5,740 # ffffffffc020074c <__alltraps>
ffffffffc0200470:	10579073          	csrw	stvec,a5
}
ffffffffc0200474:	8082                	ret

ffffffffc0200476 <print_regs>:
    cprintf("  badvaddr 0x%08x\n", tf->badvaddr);
    cprintf("  cause    0x%08x\n", tf->cause);
}

void print_regs(struct pushregs *gpr) {
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc0200476:	610c                	ld	a1,0(a0)
void print_regs(struct pushregs *gpr) {
ffffffffc0200478:	1141                	addi	sp,sp,-16
ffffffffc020047a:	e022                	sd	s0,0(sp)
ffffffffc020047c:	842a                	mv	s0,a0
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc020047e:	00002517          	auipc	a0,0x2
ffffffffc0200482:	87250513          	addi	a0,a0,-1934 # ffffffffc0201cf0 <commands+0x68>
void print_regs(struct pushregs *gpr) {
ffffffffc0200486:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc0200488:	c2bff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
ffffffffc020048c:	640c                	ld	a1,8(s0)
ffffffffc020048e:	00002517          	auipc	a0,0x2
ffffffffc0200492:	87a50513          	addi	a0,a0,-1926 # ffffffffc0201d08 <commands+0x80>
ffffffffc0200496:	c1dff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
ffffffffc020049a:	680c                	ld	a1,16(s0)
ffffffffc020049c:	00002517          	auipc	a0,0x2
ffffffffc02004a0:	88450513          	addi	a0,a0,-1916 # ffffffffc0201d20 <commands+0x98>
ffffffffc02004a4:	c0fff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
ffffffffc02004a8:	6c0c                	ld	a1,24(s0)
ffffffffc02004aa:	00002517          	auipc	a0,0x2
ffffffffc02004ae:	88e50513          	addi	a0,a0,-1906 # ffffffffc0201d38 <commands+0xb0>
ffffffffc02004b2:	c01ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
ffffffffc02004b6:	700c                	ld	a1,32(s0)
ffffffffc02004b8:	00002517          	auipc	a0,0x2
ffffffffc02004bc:	89850513          	addi	a0,a0,-1896 # ffffffffc0201d50 <commands+0xc8>
ffffffffc02004c0:	bf3ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
ffffffffc02004c4:	740c                	ld	a1,40(s0)
ffffffffc02004c6:	00002517          	auipc	a0,0x2
ffffffffc02004ca:	8a250513          	addi	a0,a0,-1886 # ffffffffc0201d68 <commands+0xe0>
ffffffffc02004ce:	be5ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
ffffffffc02004d2:	780c                	ld	a1,48(s0)
ffffffffc02004d4:	00002517          	auipc	a0,0x2
ffffffffc02004d8:	8ac50513          	addi	a0,a0,-1876 # ffffffffc0201d80 <commands+0xf8>
ffffffffc02004dc:	bd7ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
ffffffffc02004e0:	7c0c                	ld	a1,56(s0)
ffffffffc02004e2:	00002517          	auipc	a0,0x2
ffffffffc02004e6:	8b650513          	addi	a0,a0,-1866 # ffffffffc0201d98 <commands+0x110>
ffffffffc02004ea:	bc9ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
ffffffffc02004ee:	602c                	ld	a1,64(s0)
ffffffffc02004f0:	00002517          	auipc	a0,0x2
ffffffffc02004f4:	8c050513          	addi	a0,a0,-1856 # ffffffffc0201db0 <commands+0x128>
ffffffffc02004f8:	bbbff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
ffffffffc02004fc:	642c                	ld	a1,72(s0)
ffffffffc02004fe:	00002517          	auipc	a0,0x2
ffffffffc0200502:	8ca50513          	addi	a0,a0,-1846 # ffffffffc0201dc8 <commands+0x140>
ffffffffc0200506:	badff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
ffffffffc020050a:	682c                	ld	a1,80(s0)
ffffffffc020050c:	00002517          	auipc	a0,0x2
ffffffffc0200510:	8d450513          	addi	a0,a0,-1836 # ffffffffc0201de0 <commands+0x158>
ffffffffc0200514:	b9fff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
ffffffffc0200518:	6c2c                	ld	a1,88(s0)
ffffffffc020051a:	00002517          	auipc	a0,0x2
ffffffffc020051e:	8de50513          	addi	a0,a0,-1826 # ffffffffc0201df8 <commands+0x170>
ffffffffc0200522:	b91ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
ffffffffc0200526:	702c                	ld	a1,96(s0)
ffffffffc0200528:	00002517          	auipc	a0,0x2
ffffffffc020052c:	8e850513          	addi	a0,a0,-1816 # ffffffffc0201e10 <commands+0x188>
ffffffffc0200530:	b83ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
ffffffffc0200534:	742c                	ld	a1,104(s0)
ffffffffc0200536:	00002517          	auipc	a0,0x2
ffffffffc020053a:	8f250513          	addi	a0,a0,-1806 # ffffffffc0201e28 <commands+0x1a0>
ffffffffc020053e:	b75ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
ffffffffc0200542:	782c                	ld	a1,112(s0)
ffffffffc0200544:	00002517          	auipc	a0,0x2
ffffffffc0200548:	8fc50513          	addi	a0,a0,-1796 # ffffffffc0201e40 <commands+0x1b8>
ffffffffc020054c:	b67ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
ffffffffc0200550:	7c2c                	ld	a1,120(s0)
ffffffffc0200552:	00002517          	auipc	a0,0x2
ffffffffc0200556:	90650513          	addi	a0,a0,-1786 # ffffffffc0201e58 <commands+0x1d0>
ffffffffc020055a:	b59ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
ffffffffc020055e:	604c                	ld	a1,128(s0)
ffffffffc0200560:	00002517          	auipc	a0,0x2
ffffffffc0200564:	91050513          	addi	a0,a0,-1776 # ffffffffc0201e70 <commands+0x1e8>
ffffffffc0200568:	b4bff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
ffffffffc020056c:	644c                	ld	a1,136(s0)
ffffffffc020056e:	00002517          	auipc	a0,0x2
ffffffffc0200572:	91a50513          	addi	a0,a0,-1766 # ffffffffc0201e88 <commands+0x200>
ffffffffc0200576:	b3dff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
ffffffffc020057a:	684c                	ld	a1,144(s0)
ffffffffc020057c:	00002517          	auipc	a0,0x2
ffffffffc0200580:	92450513          	addi	a0,a0,-1756 # ffffffffc0201ea0 <commands+0x218>
ffffffffc0200584:	b2fff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
ffffffffc0200588:	6c4c                	ld	a1,152(s0)
ffffffffc020058a:	00002517          	auipc	a0,0x2
ffffffffc020058e:	92e50513          	addi	a0,a0,-1746 # ffffffffc0201eb8 <commands+0x230>
ffffffffc0200592:	b21ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
ffffffffc0200596:	704c                	ld	a1,160(s0)
ffffffffc0200598:	00002517          	auipc	a0,0x2
ffffffffc020059c:	93850513          	addi	a0,a0,-1736 # ffffffffc0201ed0 <commands+0x248>
ffffffffc02005a0:	b13ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
ffffffffc02005a4:	744c                	ld	a1,168(s0)
ffffffffc02005a6:	00002517          	auipc	a0,0x2
ffffffffc02005aa:	94250513          	addi	a0,a0,-1726 # ffffffffc0201ee8 <commands+0x260>
ffffffffc02005ae:	b05ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
ffffffffc02005b2:	784c                	ld	a1,176(s0)
ffffffffc02005b4:	00002517          	auipc	a0,0x2
ffffffffc02005b8:	94c50513          	addi	a0,a0,-1716 # ffffffffc0201f00 <commands+0x278>
ffffffffc02005bc:	af7ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
ffffffffc02005c0:	7c4c                	ld	a1,184(s0)
ffffffffc02005c2:	00002517          	auipc	a0,0x2
ffffffffc02005c6:	95650513          	addi	a0,a0,-1706 # ffffffffc0201f18 <commands+0x290>
ffffffffc02005ca:	ae9ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
ffffffffc02005ce:	606c                	ld	a1,192(s0)
ffffffffc02005d0:	00002517          	auipc	a0,0x2
ffffffffc02005d4:	96050513          	addi	a0,a0,-1696 # ffffffffc0201f30 <commands+0x2a8>
ffffffffc02005d8:	adbff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
ffffffffc02005dc:	646c                	ld	a1,200(s0)
ffffffffc02005de:	00002517          	auipc	a0,0x2
ffffffffc02005e2:	96a50513          	addi	a0,a0,-1686 # ffffffffc0201f48 <commands+0x2c0>
ffffffffc02005e6:	acdff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
ffffffffc02005ea:	686c                	ld	a1,208(s0)
ffffffffc02005ec:	00002517          	auipc	a0,0x2
ffffffffc02005f0:	97450513          	addi	a0,a0,-1676 # ffffffffc0201f60 <commands+0x2d8>
ffffffffc02005f4:	abfff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
ffffffffc02005f8:	6c6c                	ld	a1,216(s0)
ffffffffc02005fa:	00002517          	auipc	a0,0x2
ffffffffc02005fe:	97e50513          	addi	a0,a0,-1666 # ffffffffc0201f78 <commands+0x2f0>
ffffffffc0200602:	ab1ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
ffffffffc0200606:	706c                	ld	a1,224(s0)
ffffffffc0200608:	00002517          	auipc	a0,0x2
ffffffffc020060c:	98850513          	addi	a0,a0,-1656 # ffffffffc0201f90 <commands+0x308>
ffffffffc0200610:	aa3ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
ffffffffc0200614:	746c                	ld	a1,232(s0)
ffffffffc0200616:	00002517          	auipc	a0,0x2
ffffffffc020061a:	99250513          	addi	a0,a0,-1646 # ffffffffc0201fa8 <commands+0x320>
ffffffffc020061e:	a95ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
ffffffffc0200622:	786c                	ld	a1,240(s0)
ffffffffc0200624:	00002517          	auipc	a0,0x2
ffffffffc0200628:	99c50513          	addi	a0,a0,-1636 # ffffffffc0201fc0 <commands+0x338>
ffffffffc020062c:	a87ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200630:	7c6c                	ld	a1,248(s0)
}
ffffffffc0200632:	6402                	ld	s0,0(sp)
ffffffffc0200634:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200636:	00002517          	auipc	a0,0x2
ffffffffc020063a:	9a250513          	addi	a0,a0,-1630 # ffffffffc0201fd8 <commands+0x350>
}
ffffffffc020063e:	0141                	addi	sp,sp,16
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200640:	bc8d                	j	ffffffffc02000b2 <cprintf>

ffffffffc0200642 <print_trapframe>:
void print_trapframe(struct trapframe *tf) {
ffffffffc0200642:	1141                	addi	sp,sp,-16
ffffffffc0200644:	e022                	sd	s0,0(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200646:	85aa                	mv	a1,a0
void print_trapframe(struct trapframe *tf) {
ffffffffc0200648:	842a                	mv	s0,a0
    cprintf("trapframe at %p\n", tf);
ffffffffc020064a:	00002517          	auipc	a0,0x2
ffffffffc020064e:	9a650513          	addi	a0,a0,-1626 # ffffffffc0201ff0 <commands+0x368>
void print_trapframe(struct trapframe *tf) {
ffffffffc0200652:	e406                	sd	ra,8(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200654:	a5fff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    print_regs(&tf->gpr);
ffffffffc0200658:	8522                	mv	a0,s0
ffffffffc020065a:	e1dff0ef          	jal	ra,ffffffffc0200476 <print_regs>
    cprintf("  status   0x%08x\n", tf->status);
ffffffffc020065e:	10043583          	ld	a1,256(s0)
ffffffffc0200662:	00002517          	auipc	a0,0x2
ffffffffc0200666:	9a650513          	addi	a0,a0,-1626 # ffffffffc0202008 <commands+0x380>
ffffffffc020066a:	a49ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
ffffffffc020066e:	10843583          	ld	a1,264(s0)
ffffffffc0200672:	00002517          	auipc	a0,0x2
ffffffffc0200676:	9ae50513          	addi	a0,a0,-1618 # ffffffffc0202020 <commands+0x398>
ffffffffc020067a:	a39ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  badvaddr 0x%08x\n", tf->badvaddr);
ffffffffc020067e:	11043583          	ld	a1,272(s0)
ffffffffc0200682:	00002517          	auipc	a0,0x2
ffffffffc0200686:	9b650513          	addi	a0,a0,-1610 # ffffffffc0202038 <commands+0x3b0>
ffffffffc020068a:	a29ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc020068e:	11843583          	ld	a1,280(s0)
}
ffffffffc0200692:	6402                	ld	s0,0(sp)
ffffffffc0200694:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200696:	00002517          	auipc	a0,0x2
ffffffffc020069a:	9ba50513          	addi	a0,a0,-1606 # ffffffffc0202050 <commands+0x3c8>
}
ffffffffc020069e:	0141                	addi	sp,sp,16
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc02006a0:	bc09                	j	ffffffffc02000b2 <cprintf>

ffffffffc02006a2 <interrupt_handler>:

void interrupt_handler(struct trapframe *tf) {
    intptr_t cause = (tf->cause << 1) >> 1;
ffffffffc02006a2:	11853783          	ld	a5,280(a0)
ffffffffc02006a6:	472d                	li	a4,11
ffffffffc02006a8:	0786                	slli	a5,a5,0x1
ffffffffc02006aa:	8385                	srli	a5,a5,0x1
ffffffffc02006ac:	06f76c63          	bltu	a4,a5,ffffffffc0200724 <interrupt_handler+0x82>
ffffffffc02006b0:	00002717          	auipc	a4,0x2
ffffffffc02006b4:	a8070713          	addi	a4,a4,-1408 # ffffffffc0202130 <commands+0x4a8>
ffffffffc02006b8:	078a                	slli	a5,a5,0x2
ffffffffc02006ba:	97ba                	add	a5,a5,a4
ffffffffc02006bc:	439c                	lw	a5,0(a5)
ffffffffc02006be:	97ba                	add	a5,a5,a4
ffffffffc02006c0:	8782                	jr	a5
            break;
        case IRQ_H_SOFT:
            cprintf("Hypervisor software interrupt\n");
            break;
        case IRQ_M_SOFT:
            cprintf("Machine software interrupt\n");
ffffffffc02006c2:	00002517          	auipc	a0,0x2
ffffffffc02006c6:	a0650513          	addi	a0,a0,-1530 # ffffffffc02020c8 <commands+0x440>
ffffffffc02006ca:	b2e5                	j	ffffffffc02000b2 <cprintf>
            cprintf("Hypervisor software interrupt\n");
ffffffffc02006cc:	00002517          	auipc	a0,0x2
ffffffffc02006d0:	9dc50513          	addi	a0,a0,-1572 # ffffffffc02020a8 <commands+0x420>
ffffffffc02006d4:	baf9                	j	ffffffffc02000b2 <cprintf>
            cprintf("User software interrupt\n");
ffffffffc02006d6:	00002517          	auipc	a0,0x2
ffffffffc02006da:	99250513          	addi	a0,a0,-1646 # ffffffffc0202068 <commands+0x3e0>
ffffffffc02006de:	bad1                	j	ffffffffc02000b2 <cprintf>
            break;
        case IRQ_U_TIMER:
            cprintf("User Timer interrupt\n");
ffffffffc02006e0:	00002517          	auipc	a0,0x2
ffffffffc02006e4:	a0850513          	addi	a0,a0,-1528 # ffffffffc02020e8 <commands+0x460>
ffffffffc02006e8:	b2e9                	j	ffffffffc02000b2 <cprintf>
void interrupt_handler(struct trapframe *tf) {
ffffffffc02006ea:	1141                	addi	sp,sp,-16
ffffffffc02006ec:	e406                	sd	ra,8(sp)
            // read-only." -- privileged spec1.9.1, 4.1.4, p59
            // In fact, Call sbi_set_timer will clear STIP, or you can clear it
            // directly.
            // cprintf("Supervisor timer interrupt\n");
            // clear_csr(sip, SIP_STIP);
            clock_set_next_event();
ffffffffc02006ee:	d4dff0ef          	jal	ra,ffffffffc020043a <clock_set_next_event>
            if (++ticks % TICK_NUM == 0) {
ffffffffc02006f2:	00006697          	auipc	a3,0x6
ffffffffc02006f6:	d3e68693          	addi	a3,a3,-706 # ffffffffc0206430 <ticks>
ffffffffc02006fa:	629c                	ld	a5,0(a3)
ffffffffc02006fc:	06400713          	li	a4,100
ffffffffc0200700:	0785                	addi	a5,a5,1
ffffffffc0200702:	02e7f733          	remu	a4,a5,a4
ffffffffc0200706:	e29c                	sd	a5,0(a3)
ffffffffc0200708:	cf19                	beqz	a4,ffffffffc0200726 <interrupt_handler+0x84>
            break;
        default:
            print_trapframe(tf);
            break;
    }
}
ffffffffc020070a:	60a2                	ld	ra,8(sp)
ffffffffc020070c:	0141                	addi	sp,sp,16
ffffffffc020070e:	8082                	ret
            cprintf("Supervisor external interrupt\n");
ffffffffc0200710:	00002517          	auipc	a0,0x2
ffffffffc0200714:	a0050513          	addi	a0,a0,-1536 # ffffffffc0202110 <commands+0x488>
ffffffffc0200718:	ba69                	j	ffffffffc02000b2 <cprintf>
            cprintf("Supervisor software interrupt\n");
ffffffffc020071a:	00002517          	auipc	a0,0x2
ffffffffc020071e:	96e50513          	addi	a0,a0,-1682 # ffffffffc0202088 <commands+0x400>
ffffffffc0200722:	ba41                	j	ffffffffc02000b2 <cprintf>
            print_trapframe(tf);
ffffffffc0200724:	bf39                	j	ffffffffc0200642 <print_trapframe>
}
ffffffffc0200726:	60a2                	ld	ra,8(sp)
    cprintf("%d ticks\n", TICK_NUM);
ffffffffc0200728:	06400593          	li	a1,100
ffffffffc020072c:	00002517          	auipc	a0,0x2
ffffffffc0200730:	9d450513          	addi	a0,a0,-1580 # ffffffffc0202100 <commands+0x478>
}
ffffffffc0200734:	0141                	addi	sp,sp,16
    cprintf("%d ticks\n", TICK_NUM);
ffffffffc0200736:	bab5                	j	ffffffffc02000b2 <cprintf>

ffffffffc0200738 <trap>:
            break;
    }
}

static inline void trap_dispatch(struct trapframe *tf) {
    if ((intptr_t)tf->cause < 0) {
ffffffffc0200738:	11853783          	ld	a5,280(a0)
ffffffffc020073c:	0007c763          	bltz	a5,ffffffffc020074a <trap+0x12>
    switch (tf->cause) {
ffffffffc0200740:	472d                	li	a4,11
ffffffffc0200742:	00f76363          	bltu	a4,a5,ffffffffc0200748 <trap+0x10>
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void trap(struct trapframe *tf) {
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
}
ffffffffc0200746:	8082                	ret
            print_trapframe(tf);
ffffffffc0200748:	bded                	j	ffffffffc0200642 <print_trapframe>
        interrupt_handler(tf);
ffffffffc020074a:	bfa1                	j	ffffffffc02006a2 <interrupt_handler>

ffffffffc020074c <__alltraps>:
    .endm

    .globl __alltraps
    .align(2)
__alltraps:
    SAVE_ALL
ffffffffc020074c:	14011073          	csrw	sscratch,sp
ffffffffc0200750:	712d                	addi	sp,sp,-288
ffffffffc0200752:	e002                	sd	zero,0(sp)
ffffffffc0200754:	e406                	sd	ra,8(sp)
ffffffffc0200756:	ec0e                	sd	gp,24(sp)
ffffffffc0200758:	f012                	sd	tp,32(sp)
ffffffffc020075a:	f416                	sd	t0,40(sp)
ffffffffc020075c:	f81a                	sd	t1,48(sp)
ffffffffc020075e:	fc1e                	sd	t2,56(sp)
ffffffffc0200760:	e0a2                	sd	s0,64(sp)
ffffffffc0200762:	e4a6                	sd	s1,72(sp)
ffffffffc0200764:	e8aa                	sd	a0,80(sp)
ffffffffc0200766:	ecae                	sd	a1,88(sp)
ffffffffc0200768:	f0b2                	sd	a2,96(sp)
ffffffffc020076a:	f4b6                	sd	a3,104(sp)
ffffffffc020076c:	f8ba                	sd	a4,112(sp)
ffffffffc020076e:	fcbe                	sd	a5,120(sp)
ffffffffc0200770:	e142                	sd	a6,128(sp)
ffffffffc0200772:	e546                	sd	a7,136(sp)
ffffffffc0200774:	e94a                	sd	s2,144(sp)
ffffffffc0200776:	ed4e                	sd	s3,152(sp)
ffffffffc0200778:	f152                	sd	s4,160(sp)
ffffffffc020077a:	f556                	sd	s5,168(sp)
ffffffffc020077c:	f95a                	sd	s6,176(sp)
ffffffffc020077e:	fd5e                	sd	s7,184(sp)
ffffffffc0200780:	e1e2                	sd	s8,192(sp)
ffffffffc0200782:	e5e6                	sd	s9,200(sp)
ffffffffc0200784:	e9ea                	sd	s10,208(sp)
ffffffffc0200786:	edee                	sd	s11,216(sp)
ffffffffc0200788:	f1f2                	sd	t3,224(sp)
ffffffffc020078a:	f5f6                	sd	t4,232(sp)
ffffffffc020078c:	f9fa                	sd	t5,240(sp)
ffffffffc020078e:	fdfe                	sd	t6,248(sp)
ffffffffc0200790:	14001473          	csrrw	s0,sscratch,zero
ffffffffc0200794:	100024f3          	csrr	s1,sstatus
ffffffffc0200798:	14102973          	csrr	s2,sepc
ffffffffc020079c:	143029f3          	csrr	s3,stval
ffffffffc02007a0:	14202a73          	csrr	s4,scause
ffffffffc02007a4:	e822                	sd	s0,16(sp)
ffffffffc02007a6:	e226                	sd	s1,256(sp)
ffffffffc02007a8:	e64a                	sd	s2,264(sp)
ffffffffc02007aa:	ea4e                	sd	s3,272(sp)
ffffffffc02007ac:	ee52                	sd	s4,280(sp)

    move  a0, sp
ffffffffc02007ae:	850a                	mv	a0,sp
    jal trap
ffffffffc02007b0:	f89ff0ef          	jal	ra,ffffffffc0200738 <trap>

ffffffffc02007b4 <__trapret>:
    # sp should be the same as before "jal trap"

    .globl __trapret
__trapret:
    RESTORE_ALL
ffffffffc02007b4:	6492                	ld	s1,256(sp)
ffffffffc02007b6:	6932                	ld	s2,264(sp)
ffffffffc02007b8:	10049073          	csrw	sstatus,s1
ffffffffc02007bc:	14191073          	csrw	sepc,s2
ffffffffc02007c0:	60a2                	ld	ra,8(sp)
ffffffffc02007c2:	61e2                	ld	gp,24(sp)
ffffffffc02007c4:	7202                	ld	tp,32(sp)
ffffffffc02007c6:	72a2                	ld	t0,40(sp)
ffffffffc02007c8:	7342                	ld	t1,48(sp)
ffffffffc02007ca:	73e2                	ld	t2,56(sp)
ffffffffc02007cc:	6406                	ld	s0,64(sp)
ffffffffc02007ce:	64a6                	ld	s1,72(sp)
ffffffffc02007d0:	6546                	ld	a0,80(sp)
ffffffffc02007d2:	65e6                	ld	a1,88(sp)
ffffffffc02007d4:	7606                	ld	a2,96(sp)
ffffffffc02007d6:	76a6                	ld	a3,104(sp)
ffffffffc02007d8:	7746                	ld	a4,112(sp)
ffffffffc02007da:	77e6                	ld	a5,120(sp)
ffffffffc02007dc:	680a                	ld	a6,128(sp)
ffffffffc02007de:	68aa                	ld	a7,136(sp)
ffffffffc02007e0:	694a                	ld	s2,144(sp)
ffffffffc02007e2:	69ea                	ld	s3,152(sp)
ffffffffc02007e4:	7a0a                	ld	s4,160(sp)
ffffffffc02007e6:	7aaa                	ld	s5,168(sp)
ffffffffc02007e8:	7b4a                	ld	s6,176(sp)
ffffffffc02007ea:	7bea                	ld	s7,184(sp)
ffffffffc02007ec:	6c0e                	ld	s8,192(sp)
ffffffffc02007ee:	6cae                	ld	s9,200(sp)
ffffffffc02007f0:	6d4e                	ld	s10,208(sp)
ffffffffc02007f2:	6dee                	ld	s11,216(sp)
ffffffffc02007f4:	7e0e                	ld	t3,224(sp)
ffffffffc02007f6:	7eae                	ld	t4,232(sp)
ffffffffc02007f8:	7f4e                	ld	t5,240(sp)
ffffffffc02007fa:	7fee                	ld	t6,248(sp)
ffffffffc02007fc:	6142                	ld	sp,16(sp)
    # return from supervisor call
    sret
ffffffffc02007fe:	10200073          	sret

ffffffffc0200802 <alloc_pages>:
#include <defs.h>
#include <intr.h>
#include <riscv.h>

static inline bool __intr_save(void) {
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0200802:	100027f3          	csrr	a5,sstatus
ffffffffc0200806:	8b89                	andi	a5,a5,2
ffffffffc0200808:	e799                	bnez	a5,ffffffffc0200816 <alloc_pages+0x14>
struct Page *alloc_pages(size_t n) {
    struct Page *page = NULL;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        page = pmm_manager->alloc_pages(n);
ffffffffc020080a:	00006797          	auipc	a5,0x6
ffffffffc020080e:	c3e7b783          	ld	a5,-962(a5) # ffffffffc0206448 <pmm_manager>
ffffffffc0200812:	6f9c                	ld	a5,24(a5)
ffffffffc0200814:	8782                	jr	a5
struct Page *alloc_pages(size_t n) {
ffffffffc0200816:	1141                	addi	sp,sp,-16
ffffffffc0200818:	e406                	sd	ra,8(sp)
ffffffffc020081a:	e022                	sd	s0,0(sp)
ffffffffc020081c:	842a                	mv	s0,a0
        intr_disable();
ffffffffc020081e:	c41ff0ef          	jal	ra,ffffffffc020045e <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0200822:	00006797          	auipc	a5,0x6
ffffffffc0200826:	c267b783          	ld	a5,-986(a5) # ffffffffc0206448 <pmm_manager>
ffffffffc020082a:	6f9c                	ld	a5,24(a5)
ffffffffc020082c:	8522                	mv	a0,s0
ffffffffc020082e:	9782                	jalr	a5
ffffffffc0200830:	842a                	mv	s0,a0
    return 0;
}

static inline void __intr_restore(bool flag) {
    if (flag) {
        intr_enable();
ffffffffc0200832:	c27ff0ef          	jal	ra,ffffffffc0200458 <intr_enable>
    }
    local_intr_restore(intr_flag);
    return page;
}
ffffffffc0200836:	60a2                	ld	ra,8(sp)
ffffffffc0200838:	8522                	mv	a0,s0
ffffffffc020083a:	6402                	ld	s0,0(sp)
ffffffffc020083c:	0141                	addi	sp,sp,16
ffffffffc020083e:	8082                	ret

ffffffffc0200840 <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0200840:	100027f3          	csrr	a5,sstatus
ffffffffc0200844:	8b89                	andi	a5,a5,2
ffffffffc0200846:	e799                	bnez	a5,ffffffffc0200854 <free_pages+0x14>
// free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory
void free_pages(struct Page *base, size_t n) {
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        pmm_manager->free_pages(base, n);
ffffffffc0200848:	00006797          	auipc	a5,0x6
ffffffffc020084c:	c007b783          	ld	a5,-1024(a5) # ffffffffc0206448 <pmm_manager>
ffffffffc0200850:	739c                	ld	a5,32(a5)
ffffffffc0200852:	8782                	jr	a5
void free_pages(struct Page *base, size_t n) {
ffffffffc0200854:	1101                	addi	sp,sp,-32
ffffffffc0200856:	ec06                	sd	ra,24(sp)
ffffffffc0200858:	e822                	sd	s0,16(sp)
ffffffffc020085a:	e426                	sd	s1,8(sp)
ffffffffc020085c:	842a                	mv	s0,a0
ffffffffc020085e:	84ae                	mv	s1,a1
        intr_disable();
ffffffffc0200860:	bffff0ef          	jal	ra,ffffffffc020045e <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0200864:	00006797          	auipc	a5,0x6
ffffffffc0200868:	be47b783          	ld	a5,-1052(a5) # ffffffffc0206448 <pmm_manager>
ffffffffc020086c:	739c                	ld	a5,32(a5)
ffffffffc020086e:	85a6                	mv	a1,s1
ffffffffc0200870:	8522                	mv	a0,s0
ffffffffc0200872:	9782                	jalr	a5
    }
    local_intr_restore(intr_flag);
}
ffffffffc0200874:	6442                	ld	s0,16(sp)
ffffffffc0200876:	60e2                	ld	ra,24(sp)
ffffffffc0200878:	64a2                	ld	s1,8(sp)
ffffffffc020087a:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc020087c:	bef1                	j	ffffffffc0200458 <intr_enable>

ffffffffc020087e <nr_free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020087e:	100027f3          	csrr	a5,sstatus
ffffffffc0200882:	8b89                	andi	a5,a5,2
ffffffffc0200884:	e799                	bnez	a5,ffffffffc0200892 <nr_free_pages+0x14>
size_t nr_free_pages(void) {
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        ret = pmm_manager->nr_free_pages();
ffffffffc0200886:	00006797          	auipc	a5,0x6
ffffffffc020088a:	bc27b783          	ld	a5,-1086(a5) # ffffffffc0206448 <pmm_manager>
ffffffffc020088e:	779c                	ld	a5,40(a5)
ffffffffc0200890:	8782                	jr	a5
size_t nr_free_pages(void) {
ffffffffc0200892:	1141                	addi	sp,sp,-16
ffffffffc0200894:	e406                	sd	ra,8(sp)
ffffffffc0200896:	e022                	sd	s0,0(sp)
        intr_disable();
ffffffffc0200898:	bc7ff0ef          	jal	ra,ffffffffc020045e <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc020089c:	00006797          	auipc	a5,0x6
ffffffffc02008a0:	bac7b783          	ld	a5,-1108(a5) # ffffffffc0206448 <pmm_manager>
ffffffffc02008a4:	779c                	ld	a5,40(a5)
ffffffffc02008a6:	9782                	jalr	a5
ffffffffc02008a8:	842a                	mv	s0,a0
        intr_enable();
ffffffffc02008aa:	bafff0ef          	jal	ra,ffffffffc0200458 <intr_enable>
    }
    local_intr_restore(intr_flag);
    return ret;
}
ffffffffc02008ae:	60a2                	ld	ra,8(sp)
ffffffffc02008b0:	8522                	mv	a0,s0
ffffffffc02008b2:	6402                	ld	s0,0(sp)
ffffffffc02008b4:	0141                	addi	sp,sp,16
ffffffffc02008b6:	8082                	ret

ffffffffc02008b8 <pmm_init>:
    pmm_manager = &best_fit_pmm_manager;
ffffffffc02008b8:	00002797          	auipc	a5,0x2
ffffffffc02008bc:	d3878793          	addi	a5,a5,-712 # ffffffffc02025f0 <best_fit_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc02008c0:	638c                	ld	a1,0(a5)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
    }
}

/* pmm_init - initialize the physical memory management */
void pmm_init(void) {
ffffffffc02008c2:	1101                	addi	sp,sp,-32
ffffffffc02008c4:	e426                	sd	s1,8(sp)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc02008c6:	00002517          	auipc	a0,0x2
ffffffffc02008ca:	89a50513          	addi	a0,a0,-1894 # ffffffffc0202160 <commands+0x4d8>
    pmm_manager = &best_fit_pmm_manager;
ffffffffc02008ce:	00006497          	auipc	s1,0x6
ffffffffc02008d2:	b7a48493          	addi	s1,s1,-1158 # ffffffffc0206448 <pmm_manager>
void pmm_init(void) {
ffffffffc02008d6:	ec06                	sd	ra,24(sp)
ffffffffc02008d8:	e822                	sd	s0,16(sp)
    pmm_manager = &best_fit_pmm_manager;
ffffffffc02008da:	e09c                	sd	a5,0(s1)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc02008dc:	fd6ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    pmm_manager->init();
ffffffffc02008e0:	609c                	ld	a5,0(s1)
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc02008e2:	00006417          	auipc	s0,0x6
ffffffffc02008e6:	b7e40413          	addi	s0,s0,-1154 # ffffffffc0206460 <va_pa_offset>
    pmm_manager->init();
ffffffffc02008ea:	679c                	ld	a5,8(a5)
ffffffffc02008ec:	9782                	jalr	a5
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc02008ee:	57f5                	li	a5,-3
ffffffffc02008f0:	07fa                	slli	a5,a5,0x1e
    cprintf("physcial memory map:\n");
ffffffffc02008f2:	00002517          	auipc	a0,0x2
ffffffffc02008f6:	88650513          	addi	a0,a0,-1914 # ffffffffc0202178 <commands+0x4f0>
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc02008fa:	e01c                	sd	a5,0(s0)
    cprintf("physcial memory map:\n");
ffffffffc02008fc:	fb6ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  memory: 0x%016lx, [0x%016lx, 0x%016lx].\n", mem_size, mem_begin,
ffffffffc0200900:	46c5                	li	a3,17
ffffffffc0200902:	06ee                	slli	a3,a3,0x1b
ffffffffc0200904:	40100613          	li	a2,1025
ffffffffc0200908:	16fd                	addi	a3,a3,-1
ffffffffc020090a:	07e005b7          	lui	a1,0x7e00
ffffffffc020090e:	0656                	slli	a2,a2,0x15
ffffffffc0200910:	00002517          	auipc	a0,0x2
ffffffffc0200914:	88050513          	addi	a0,a0,-1920 # ffffffffc0202190 <commands+0x508>
ffffffffc0200918:	f9aff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc020091c:	777d                	lui	a4,0xfffff
ffffffffc020091e:	00007797          	auipc	a5,0x7
ffffffffc0200922:	b5178793          	addi	a5,a5,-1199 # ffffffffc020746f <end+0xfff>
ffffffffc0200926:	8ff9                	and	a5,a5,a4
    npage = maxpa / PGSIZE;
ffffffffc0200928:	00006517          	auipc	a0,0x6
ffffffffc020092c:	b1050513          	addi	a0,a0,-1264 # ffffffffc0206438 <npage>
ffffffffc0200930:	00088737          	lui	a4,0x88
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0200934:	00006597          	auipc	a1,0x6
ffffffffc0200938:	b0c58593          	addi	a1,a1,-1268 # ffffffffc0206440 <pages>
    npage = maxpa / PGSIZE;
ffffffffc020093c:	e118                	sd	a4,0(a0)
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc020093e:	e19c                	sd	a5,0(a1)
ffffffffc0200940:	4681                	li	a3,0
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0200942:	4701                	li	a4,0
 *
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void set_bit(int nr, volatile void *addr) {
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0200944:	4885                	li	a7,1
ffffffffc0200946:	fff80837          	lui	a6,0xfff80
ffffffffc020094a:	a011                	j	ffffffffc020094e <pmm_init+0x96>
        SetPageReserved(pages + i);
ffffffffc020094c:	619c                	ld	a5,0(a1)
ffffffffc020094e:	97b6                	add	a5,a5,a3
ffffffffc0200950:	07a1                	addi	a5,a5,8
ffffffffc0200952:	4117b02f          	amoor.d	zero,a7,(a5)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0200956:	611c                	ld	a5,0(a0)
ffffffffc0200958:	0705                	addi	a4,a4,1
ffffffffc020095a:	02868693          	addi	a3,a3,40
ffffffffc020095e:	01078633          	add	a2,a5,a6
ffffffffc0200962:	fec765e3          	bltu	a4,a2,ffffffffc020094c <pmm_init+0x94>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0200966:	6190                	ld	a2,0(a1)
ffffffffc0200968:	00279713          	slli	a4,a5,0x2
ffffffffc020096c:	973e                	add	a4,a4,a5
ffffffffc020096e:	fec006b7          	lui	a3,0xfec00
ffffffffc0200972:	070e                	slli	a4,a4,0x3
ffffffffc0200974:	96b2                	add	a3,a3,a2
ffffffffc0200976:	96ba                	add	a3,a3,a4
ffffffffc0200978:	c0200737          	lui	a4,0xc0200
ffffffffc020097c:	08e6ef63          	bltu	a3,a4,ffffffffc0200a1a <pmm_init+0x162>
ffffffffc0200980:	6018                	ld	a4,0(s0)
    if (freemem < mem_end) {
ffffffffc0200982:	45c5                	li	a1,17
ffffffffc0200984:	05ee                	slli	a1,a1,0x1b
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0200986:	8e99                	sub	a3,a3,a4
    if (freemem < mem_end) {
ffffffffc0200988:	04b6e863          	bltu	a3,a1,ffffffffc02009d8 <pmm_init+0x120>
    satp_physical = PADDR(satp_virtual);
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
}

static void check_alloc_page(void) {
    pmm_manager->check();
ffffffffc020098c:	609c                	ld	a5,0(s1)
ffffffffc020098e:	7b9c                	ld	a5,48(a5)
ffffffffc0200990:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc0200992:	00002517          	auipc	a0,0x2
ffffffffc0200996:	89650513          	addi	a0,a0,-1898 # ffffffffc0202228 <commands+0x5a0>
ffffffffc020099a:	f18ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    satp_virtual = (pte_t*)boot_page_table_sv39;
ffffffffc020099e:	00004597          	auipc	a1,0x4
ffffffffc02009a2:	66258593          	addi	a1,a1,1634 # ffffffffc0205000 <boot_page_table_sv39>
ffffffffc02009a6:	00006797          	auipc	a5,0x6
ffffffffc02009aa:	aab7b923          	sd	a1,-1358(a5) # ffffffffc0206458 <satp_virtual>
    satp_physical = PADDR(satp_virtual);
ffffffffc02009ae:	c02007b7          	lui	a5,0xc0200
ffffffffc02009b2:	08f5e063          	bltu	a1,a5,ffffffffc0200a32 <pmm_init+0x17a>
ffffffffc02009b6:	6010                	ld	a2,0(s0)
}
ffffffffc02009b8:	6442                	ld	s0,16(sp)
ffffffffc02009ba:	60e2                	ld	ra,24(sp)
ffffffffc02009bc:	64a2                	ld	s1,8(sp)
    satp_physical = PADDR(satp_virtual);
ffffffffc02009be:	40c58633          	sub	a2,a1,a2
ffffffffc02009c2:	00006797          	auipc	a5,0x6
ffffffffc02009c6:	a8c7b723          	sd	a2,-1394(a5) # ffffffffc0206450 <satp_physical>
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc02009ca:	00002517          	auipc	a0,0x2
ffffffffc02009ce:	87e50513          	addi	a0,a0,-1922 # ffffffffc0202248 <commands+0x5c0>
}
ffffffffc02009d2:	6105                	addi	sp,sp,32
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc02009d4:	edeff06f          	j	ffffffffc02000b2 <cprintf>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc02009d8:	6705                	lui	a4,0x1
ffffffffc02009da:	177d                	addi	a4,a4,-1
ffffffffc02009dc:	96ba                	add	a3,a3,a4
ffffffffc02009de:	777d                	lui	a4,0xfffff
ffffffffc02009e0:	8ef9                	and	a3,a3,a4
static inline int page_ref_dec(struct Page *page) {
    page->ref -= 1;
    return page->ref;
}
static inline struct Page *pa2page(uintptr_t pa) {
    if (PPN(pa) >= npage) {
ffffffffc02009e2:	00c6d513          	srli	a0,a3,0xc
ffffffffc02009e6:	00f57e63          	bgeu	a0,a5,ffffffffc0200a02 <pmm_init+0x14a>
    pmm_manager->init_memmap(base, n);
ffffffffc02009ea:	609c                	ld	a5,0(s1)
        panic("pa2page called with invalid pa");
    }
    return &pages[PPN(pa) - nbase];
ffffffffc02009ec:	982a                	add	a6,a6,a0
ffffffffc02009ee:	00281513          	slli	a0,a6,0x2
ffffffffc02009f2:	9542                	add	a0,a0,a6
ffffffffc02009f4:	6b9c                	ld	a5,16(a5)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc02009f6:	8d95                	sub	a1,a1,a3
ffffffffc02009f8:	050e                	slli	a0,a0,0x3
    pmm_manager->init_memmap(base, n);
ffffffffc02009fa:	81b1                	srli	a1,a1,0xc
ffffffffc02009fc:	9532                	add	a0,a0,a2
ffffffffc02009fe:	9782                	jalr	a5
}
ffffffffc0200a00:	b771                	j	ffffffffc020098c <pmm_init+0xd4>
        panic("pa2page called with invalid pa");
ffffffffc0200a02:	00001617          	auipc	a2,0x1
ffffffffc0200a06:	7f660613          	addi	a2,a2,2038 # ffffffffc02021f8 <commands+0x570>
ffffffffc0200a0a:	06b00593          	li	a1,107
ffffffffc0200a0e:	00002517          	auipc	a0,0x2
ffffffffc0200a12:	80a50513          	addi	a0,a0,-2038 # ffffffffc0202218 <commands+0x590>
ffffffffc0200a16:	f24ff0ef          	jal	ra,ffffffffc020013a <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0200a1a:	00001617          	auipc	a2,0x1
ffffffffc0200a1e:	7a660613          	addi	a2,a2,1958 # ffffffffc02021c0 <commands+0x538>
ffffffffc0200a22:	06e00593          	li	a1,110
ffffffffc0200a26:	00001517          	auipc	a0,0x1
ffffffffc0200a2a:	7c250513          	addi	a0,a0,1986 # ffffffffc02021e8 <commands+0x560>
ffffffffc0200a2e:	f0cff0ef          	jal	ra,ffffffffc020013a <__panic>
    satp_physical = PADDR(satp_virtual);
ffffffffc0200a32:	86ae                	mv	a3,a1
ffffffffc0200a34:	00001617          	auipc	a2,0x1
ffffffffc0200a38:	78c60613          	addi	a2,a2,1932 # ffffffffc02021c0 <commands+0x538>
ffffffffc0200a3c:	08900593          	li	a1,137
ffffffffc0200a40:	00001517          	auipc	a0,0x1
ffffffffc0200a44:	7a850513          	addi	a0,a0,1960 # ffffffffc02021e8 <commands+0x560>
ffffffffc0200a48:	ef2ff0ef          	jal	ra,ffffffffc020013a <__panic>

ffffffffc0200a4c <best_fit_init>:
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc0200a4c:	00005797          	auipc	a5,0x5
ffffffffc0200a50:	5c478793          	addi	a5,a5,1476 # ffffffffc0206010 <free_area>
ffffffffc0200a54:	e79c                	sd	a5,8(a5)
ffffffffc0200a56:	e39c                	sd	a5,0(a5)
#define nr_free (free_area.nr_free)

static void
best_fit_init(void) {
    list_init(&free_list);
    nr_free = 0;
ffffffffc0200a58:	0007a823          	sw	zero,16(a5)
}
ffffffffc0200a5c:	8082                	ret

ffffffffc0200a5e <best_fit_nr_free_pages>:
}

static size_t
best_fit_nr_free_pages(void) {
    return nr_free;
}
ffffffffc0200a5e:	00005517          	auipc	a0,0x5
ffffffffc0200a62:	5c256503          	lwu	a0,1474(a0) # ffffffffc0206020 <free_area+0x10>
ffffffffc0200a66:	8082                	ret

ffffffffc0200a68 <best_fit_check>:
}

// LAB2: below code is used to check the best fit allocation algorithm 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
best_fit_check(void) {
ffffffffc0200a68:	715d                	addi	sp,sp,-80
ffffffffc0200a6a:	e0a2                	sd	s0,64(sp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc0200a6c:	00005417          	auipc	s0,0x5
ffffffffc0200a70:	5a440413          	addi	s0,s0,1444 # ffffffffc0206010 <free_area>
ffffffffc0200a74:	641c                	ld	a5,8(s0)
ffffffffc0200a76:	e486                	sd	ra,72(sp)
ffffffffc0200a78:	fc26                	sd	s1,56(sp)
ffffffffc0200a7a:	f84a                	sd	s2,48(sp)
ffffffffc0200a7c:	f44e                	sd	s3,40(sp)
ffffffffc0200a7e:	f052                	sd	s4,32(sp)
ffffffffc0200a80:	ec56                	sd	s5,24(sp)
ffffffffc0200a82:	e85a                	sd	s6,16(sp)
ffffffffc0200a84:	e45e                	sd	s7,8(sp)
ffffffffc0200a86:	e062                	sd	s8,0(sp)
    int score = 0 ,sumscore = 6;
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200a88:	2c878b63          	beq	a5,s0,ffffffffc0200d5e <best_fit_check+0x2f6>
    int count = 0, total = 0;
ffffffffc0200a8c:	4481                	li	s1,0
ffffffffc0200a8e:	4901                	li	s2,0
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0200a90:	ff07b703          	ld	a4,-16(a5)
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc0200a94:	8b09                	andi	a4,a4,2
ffffffffc0200a96:	2c070863          	beqz	a4,ffffffffc0200d66 <best_fit_check+0x2fe>
        count ++, total += p->property;
ffffffffc0200a9a:	ff87a703          	lw	a4,-8(a5)
ffffffffc0200a9e:	679c                	ld	a5,8(a5)
ffffffffc0200aa0:	2905                	addiw	s2,s2,1
ffffffffc0200aa2:	9cb9                	addw	s1,s1,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200aa4:	fe8796e3          	bne	a5,s0,ffffffffc0200a90 <best_fit_check+0x28>
    }
    assert(total == nr_free_pages());
ffffffffc0200aa8:	89a6                	mv	s3,s1
ffffffffc0200aaa:	dd5ff0ef          	jal	ra,ffffffffc020087e <nr_free_pages>
ffffffffc0200aae:	39351c63          	bne	a0,s3,ffffffffc0200e46 <best_fit_check+0x3de>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200ab2:	4505                	li	a0,1
ffffffffc0200ab4:	d4fff0ef          	jal	ra,ffffffffc0200802 <alloc_pages>
ffffffffc0200ab8:	8a2a                	mv	s4,a0
ffffffffc0200aba:	3c050663          	beqz	a0,ffffffffc0200e86 <best_fit_check+0x41e>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200abe:	4505                	li	a0,1
ffffffffc0200ac0:	d43ff0ef          	jal	ra,ffffffffc0200802 <alloc_pages>
ffffffffc0200ac4:	89aa                	mv	s3,a0
ffffffffc0200ac6:	3a050063          	beqz	a0,ffffffffc0200e66 <best_fit_check+0x3fe>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200aca:	4505                	li	a0,1
ffffffffc0200acc:	d37ff0ef          	jal	ra,ffffffffc0200802 <alloc_pages>
ffffffffc0200ad0:	8aaa                	mv	s5,a0
ffffffffc0200ad2:	32050a63          	beqz	a0,ffffffffc0200e06 <best_fit_check+0x39e>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0200ad6:	2b3a0863          	beq	s4,s3,ffffffffc0200d86 <best_fit_check+0x31e>
ffffffffc0200ada:	2aaa0663          	beq	s4,a0,ffffffffc0200d86 <best_fit_check+0x31e>
ffffffffc0200ade:	2aa98463          	beq	s3,a0,ffffffffc0200d86 <best_fit_check+0x31e>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0200ae2:	000a2783          	lw	a5,0(s4)
ffffffffc0200ae6:	2c079063          	bnez	a5,ffffffffc0200da6 <best_fit_check+0x33e>
ffffffffc0200aea:	0009a783          	lw	a5,0(s3)
ffffffffc0200aee:	2a079c63          	bnez	a5,ffffffffc0200da6 <best_fit_check+0x33e>
ffffffffc0200af2:	411c                	lw	a5,0(a0)
ffffffffc0200af4:	2a079963          	bnez	a5,ffffffffc0200da6 <best_fit_check+0x33e>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200af8:	00006797          	auipc	a5,0x6
ffffffffc0200afc:	9487b783          	ld	a5,-1720(a5) # ffffffffc0206440 <pages>
ffffffffc0200b00:	40fa0733          	sub	a4,s4,a5
ffffffffc0200b04:	870d                	srai	a4,a4,0x3
ffffffffc0200b06:	00002597          	auipc	a1,0x2
ffffffffc0200b0a:	d725b583          	ld	a1,-654(a1) # ffffffffc0202878 <nbase+0x8>
ffffffffc0200b0e:	02b70733          	mul	a4,a4,a1
ffffffffc0200b12:	00002617          	auipc	a2,0x2
ffffffffc0200b16:	d5e63603          	ld	a2,-674(a2) # ffffffffc0202870 <nbase>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0200b1a:	00006697          	auipc	a3,0x6
ffffffffc0200b1e:	91e6b683          	ld	a3,-1762(a3) # ffffffffc0206438 <npage>
ffffffffc0200b22:	06b2                	slli	a3,a3,0xc
ffffffffc0200b24:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0200b26:	0732                	slli	a4,a4,0xc
ffffffffc0200b28:	28d77f63          	bgeu	a4,a3,ffffffffc0200dc6 <best_fit_check+0x35e>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200b2c:	40f98733          	sub	a4,s3,a5
ffffffffc0200b30:	870d                	srai	a4,a4,0x3
ffffffffc0200b32:	02b70733          	mul	a4,a4,a1
ffffffffc0200b36:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0200b38:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0200b3a:	44d77663          	bgeu	a4,a3,ffffffffc0200f86 <best_fit_check+0x51e>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200b3e:	40f507b3          	sub	a5,a0,a5
ffffffffc0200b42:	878d                	srai	a5,a5,0x3
ffffffffc0200b44:	02b787b3          	mul	a5,a5,a1
ffffffffc0200b48:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0200b4a:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0200b4c:	40d7fd63          	bgeu	a5,a3,ffffffffc0200f66 <best_fit_check+0x4fe>
    assert(alloc_page() == NULL);
ffffffffc0200b50:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0200b52:	00043c03          	ld	s8,0(s0)
ffffffffc0200b56:	00843b83          	ld	s7,8(s0)
    unsigned int nr_free_store = nr_free;
ffffffffc0200b5a:	01042b03          	lw	s6,16(s0)
    elm->prev = elm->next = elm;
ffffffffc0200b5e:	e400                	sd	s0,8(s0)
ffffffffc0200b60:	e000                	sd	s0,0(s0)
    nr_free = 0;
ffffffffc0200b62:	00005797          	auipc	a5,0x5
ffffffffc0200b66:	4a07af23          	sw	zero,1214(a5) # ffffffffc0206020 <free_area+0x10>
    assert(alloc_page() == NULL);
ffffffffc0200b6a:	c99ff0ef          	jal	ra,ffffffffc0200802 <alloc_pages>
ffffffffc0200b6e:	3c051c63          	bnez	a0,ffffffffc0200f46 <best_fit_check+0x4de>
    free_page(p0);
ffffffffc0200b72:	4585                	li	a1,1
ffffffffc0200b74:	8552                	mv	a0,s4
ffffffffc0200b76:	ccbff0ef          	jal	ra,ffffffffc0200840 <free_pages>
    free_page(p1);
ffffffffc0200b7a:	4585                	li	a1,1
ffffffffc0200b7c:	854e                	mv	a0,s3
ffffffffc0200b7e:	cc3ff0ef          	jal	ra,ffffffffc0200840 <free_pages>
    free_page(p2);
ffffffffc0200b82:	4585                	li	a1,1
ffffffffc0200b84:	8556                	mv	a0,s5
ffffffffc0200b86:	cbbff0ef          	jal	ra,ffffffffc0200840 <free_pages>
    assert(nr_free == 3);
ffffffffc0200b8a:	4818                	lw	a4,16(s0)
ffffffffc0200b8c:	478d                	li	a5,3
ffffffffc0200b8e:	38f71c63          	bne	a4,a5,ffffffffc0200f26 <best_fit_check+0x4be>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200b92:	4505                	li	a0,1
ffffffffc0200b94:	c6fff0ef          	jal	ra,ffffffffc0200802 <alloc_pages>
ffffffffc0200b98:	89aa                	mv	s3,a0
ffffffffc0200b9a:	36050663          	beqz	a0,ffffffffc0200f06 <best_fit_check+0x49e>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200b9e:	4505                	li	a0,1
ffffffffc0200ba0:	c63ff0ef          	jal	ra,ffffffffc0200802 <alloc_pages>
ffffffffc0200ba4:	8aaa                	mv	s5,a0
ffffffffc0200ba6:	34050063          	beqz	a0,ffffffffc0200ee6 <best_fit_check+0x47e>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200baa:	4505                	li	a0,1
ffffffffc0200bac:	c57ff0ef          	jal	ra,ffffffffc0200802 <alloc_pages>
ffffffffc0200bb0:	8a2a                	mv	s4,a0
ffffffffc0200bb2:	30050a63          	beqz	a0,ffffffffc0200ec6 <best_fit_check+0x45e>
    assert(alloc_page() == NULL);
ffffffffc0200bb6:	4505                	li	a0,1
ffffffffc0200bb8:	c4bff0ef          	jal	ra,ffffffffc0200802 <alloc_pages>
ffffffffc0200bbc:	2e051563          	bnez	a0,ffffffffc0200ea6 <best_fit_check+0x43e>
    free_page(p0);
ffffffffc0200bc0:	4585                	li	a1,1
ffffffffc0200bc2:	854e                	mv	a0,s3
ffffffffc0200bc4:	c7dff0ef          	jal	ra,ffffffffc0200840 <free_pages>
    assert(!list_empty(&free_list));
ffffffffc0200bc8:	641c                	ld	a5,8(s0)
ffffffffc0200bca:	20878e63          	beq	a5,s0,ffffffffc0200de6 <best_fit_check+0x37e>
    assert((p = alloc_page()) == p0);
ffffffffc0200bce:	4505                	li	a0,1
ffffffffc0200bd0:	c33ff0ef          	jal	ra,ffffffffc0200802 <alloc_pages>
ffffffffc0200bd4:	58a99963          	bne	s3,a0,ffffffffc0201166 <best_fit_check+0x6fe>
    assert(alloc_page() == NULL);
ffffffffc0200bd8:	4505                	li	a0,1
ffffffffc0200bda:	c29ff0ef          	jal	ra,ffffffffc0200802 <alloc_pages>
ffffffffc0200bde:	56051463          	bnez	a0,ffffffffc0201146 <best_fit_check+0x6de>
    assert(nr_free == 0);
ffffffffc0200be2:	481c                	lw	a5,16(s0)
ffffffffc0200be4:	54079163          	bnez	a5,ffffffffc0201126 <best_fit_check+0x6be>
    free_page(p);
ffffffffc0200be8:	854e                	mv	a0,s3
ffffffffc0200bea:	4585                	li	a1,1
    free_list = free_list_store;
ffffffffc0200bec:	01843023          	sd	s8,0(s0)
ffffffffc0200bf0:	01743423          	sd	s7,8(s0)
    nr_free = nr_free_store;
ffffffffc0200bf4:	01642823          	sw	s6,16(s0)
    free_page(p);
ffffffffc0200bf8:	c49ff0ef          	jal	ra,ffffffffc0200840 <free_pages>
    free_page(p1);
ffffffffc0200bfc:	4585                	li	a1,1
ffffffffc0200bfe:	8556                	mv	a0,s5
ffffffffc0200c00:	c41ff0ef          	jal	ra,ffffffffc0200840 <free_pages>
    free_page(p2);
ffffffffc0200c04:	4585                	li	a1,1
ffffffffc0200c06:	8552                	mv	a0,s4
ffffffffc0200c08:	c39ff0ef          	jal	ra,ffffffffc0200840 <free_pages>

    basic_check();

    #ifdef ucore_test
    score += 1;
    cprintf("grading: %d / %d points\n",score, sumscore);
ffffffffc0200c0c:	4619                	li	a2,6
ffffffffc0200c0e:	4585                	li	a1,1
ffffffffc0200c10:	00002517          	auipc	a0,0x2
ffffffffc0200c14:	87050513          	addi	a0,a0,-1936 # ffffffffc0202480 <commands+0x7f8>
ffffffffc0200c18:	c9aff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    #endif
    struct Page *p0 = alloc_pages(5), *p1, *p2;
ffffffffc0200c1c:	4515                	li	a0,5
ffffffffc0200c1e:	be5ff0ef          	jal	ra,ffffffffc0200802 <alloc_pages>
ffffffffc0200c22:	89aa                	mv	s3,a0
    assert(p0 != NULL);
ffffffffc0200c24:	4e050163          	beqz	a0,ffffffffc0201106 <best_fit_check+0x69e>
ffffffffc0200c28:	651c                	ld	a5,8(a0)
ffffffffc0200c2a:	8385                	srli	a5,a5,0x1
    assert(!PageProperty(p0));
ffffffffc0200c2c:	8b85                	andi	a5,a5,1
ffffffffc0200c2e:	4a079c63          	bnez	a5,ffffffffc02010e6 <best_fit_check+0x67e>

    #ifdef ucore_test
    score += 1;
    cprintf("grading: %d / %d points\n",score, sumscore);
ffffffffc0200c32:	4619                	li	a2,6
ffffffffc0200c34:	4589                	li	a1,2
ffffffffc0200c36:	00002517          	auipc	a0,0x2
ffffffffc0200c3a:	84a50513          	addi	a0,a0,-1974 # ffffffffc0202480 <commands+0x7f8>
ffffffffc0200c3e:	c74ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    #endif
    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
ffffffffc0200c42:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0200c44:	00043a83          	ld	s5,0(s0)
ffffffffc0200c48:	00843a03          	ld	s4,8(s0)
ffffffffc0200c4c:	e000                	sd	s0,0(s0)
ffffffffc0200c4e:	e400                	sd	s0,8(s0)
    assert(alloc_page() == NULL);
ffffffffc0200c50:	bb3ff0ef          	jal	ra,ffffffffc0200802 <alloc_pages>
ffffffffc0200c54:	46051963          	bnez	a0,ffffffffc02010c6 <best_fit_check+0x65e>

    #ifdef ucore_test
    score += 1;
    cprintf("grading: %d / %d points\n",score, sumscore);
ffffffffc0200c58:	4619                	li	a2,6
ffffffffc0200c5a:	458d                	li	a1,3
ffffffffc0200c5c:	00002517          	auipc	a0,0x2
ffffffffc0200c60:	82450513          	addi	a0,a0,-2012 # ffffffffc0202480 <commands+0x7f8>
ffffffffc0200c64:	c4eff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    #endif
    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    // * - - * -
    free_pages(p0 + 1, 2);
ffffffffc0200c68:	4589                	li	a1,2
ffffffffc0200c6a:	02898513          	addi	a0,s3,40
    unsigned int nr_free_store = nr_free;
ffffffffc0200c6e:	01042b03          	lw	s6,16(s0)
    free_pages(p0 + 4, 1);
ffffffffc0200c72:	0a098c13          	addi	s8,s3,160
    nr_free = 0;
ffffffffc0200c76:	00005797          	auipc	a5,0x5
ffffffffc0200c7a:	3a07a523          	sw	zero,938(a5) # ffffffffc0206020 <free_area+0x10>
    free_pages(p0 + 1, 2);
ffffffffc0200c7e:	bc3ff0ef          	jal	ra,ffffffffc0200840 <free_pages>
    free_pages(p0 + 4, 1);
ffffffffc0200c82:	8562                	mv	a0,s8
ffffffffc0200c84:	4585                	li	a1,1
ffffffffc0200c86:	bbbff0ef          	jal	ra,ffffffffc0200840 <free_pages>
    assert(alloc_pages(4) == NULL);
ffffffffc0200c8a:	4511                	li	a0,4
ffffffffc0200c8c:	b77ff0ef          	jal	ra,ffffffffc0200802 <alloc_pages>
ffffffffc0200c90:	40051b63          	bnez	a0,ffffffffc02010a6 <best_fit_check+0x63e>
ffffffffc0200c94:	0309b783          	ld	a5,48(s3)
ffffffffc0200c98:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p0 + 1) && p0[1].property == 2);
ffffffffc0200c9a:	8b85                	andi	a5,a5,1
ffffffffc0200c9c:	3e078563          	beqz	a5,ffffffffc0201086 <best_fit_check+0x61e>
ffffffffc0200ca0:	0389a703          	lw	a4,56(s3)
ffffffffc0200ca4:	4789                	li	a5,2
ffffffffc0200ca6:	3ef71063          	bne	a4,a5,ffffffffc0201086 <best_fit_check+0x61e>
    // * - - * *
    assert((p1 = alloc_pages(1)) != NULL);
ffffffffc0200caa:	4505                	li	a0,1
ffffffffc0200cac:	b57ff0ef          	jal	ra,ffffffffc0200802 <alloc_pages>
ffffffffc0200cb0:	8baa                	mv	s7,a0
ffffffffc0200cb2:	3a050a63          	beqz	a0,ffffffffc0201066 <best_fit_check+0x5fe>
    assert(alloc_pages(2) != NULL);      // best fit feature
ffffffffc0200cb6:	4509                	li	a0,2
ffffffffc0200cb8:	b4bff0ef          	jal	ra,ffffffffc0200802 <alloc_pages>
ffffffffc0200cbc:	38050563          	beqz	a0,ffffffffc0201046 <best_fit_check+0x5de>
    assert(p0 + 4 == p1);
ffffffffc0200cc0:	377c1363          	bne	s8,s7,ffffffffc0201026 <best_fit_check+0x5be>

    #ifdef ucore_test
    score += 1;
    cprintf("grading: %d / %d points\n",score, sumscore);
ffffffffc0200cc4:	4619                	li	a2,6
ffffffffc0200cc6:	4591                	li	a1,4
ffffffffc0200cc8:	00001517          	auipc	a0,0x1
ffffffffc0200ccc:	7b850513          	addi	a0,a0,1976 # ffffffffc0202480 <commands+0x7f8>
ffffffffc0200cd0:	be2ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    #endif
    p2 = p0 + 1;
    free_pages(p0, 5);
ffffffffc0200cd4:	854e                	mv	a0,s3
ffffffffc0200cd6:	4595                	li	a1,5
ffffffffc0200cd8:	b69ff0ef          	jal	ra,ffffffffc0200840 <free_pages>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0200cdc:	4515                	li	a0,5
ffffffffc0200cde:	b25ff0ef          	jal	ra,ffffffffc0200802 <alloc_pages>
ffffffffc0200ce2:	89aa                	mv	s3,a0
ffffffffc0200ce4:	32050163          	beqz	a0,ffffffffc0201006 <best_fit_check+0x59e>
    assert(alloc_page() == NULL);
ffffffffc0200ce8:	4505                	li	a0,1
ffffffffc0200cea:	b19ff0ef          	jal	ra,ffffffffc0200802 <alloc_pages>
ffffffffc0200cee:	2e051c63          	bnez	a0,ffffffffc0200fe6 <best_fit_check+0x57e>

    #ifdef ucore_test
    score += 1;
    cprintf("grading: %d / %d points\n",score, sumscore);
ffffffffc0200cf2:	4619                	li	a2,6
ffffffffc0200cf4:	4595                	li	a1,5
ffffffffc0200cf6:	00001517          	auipc	a0,0x1
ffffffffc0200cfa:	78a50513          	addi	a0,a0,1930 # ffffffffc0202480 <commands+0x7f8>
ffffffffc0200cfe:	bb4ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    #endif
    assert(nr_free == 0);
ffffffffc0200d02:	481c                	lw	a5,16(s0)
ffffffffc0200d04:	2c079163          	bnez	a5,ffffffffc0200fc6 <best_fit_check+0x55e>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
ffffffffc0200d08:	4595                	li	a1,5
ffffffffc0200d0a:	854e                	mv	a0,s3
    nr_free = nr_free_store;
ffffffffc0200d0c:	01642823          	sw	s6,16(s0)
    free_list = free_list_store;
ffffffffc0200d10:	01543023          	sd	s5,0(s0)
ffffffffc0200d14:	01443423          	sd	s4,8(s0)
    free_pages(p0, 5);
ffffffffc0200d18:	b29ff0ef          	jal	ra,ffffffffc0200840 <free_pages>
    return listelm->next;
ffffffffc0200d1c:	641c                	ld	a5,8(s0)

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200d1e:	00878963          	beq	a5,s0,ffffffffc0200d30 <best_fit_check+0x2c8>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
ffffffffc0200d22:	ff87a703          	lw	a4,-8(a5)
ffffffffc0200d26:	679c                	ld	a5,8(a5)
ffffffffc0200d28:	397d                	addiw	s2,s2,-1
ffffffffc0200d2a:	9c99                	subw	s1,s1,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200d2c:	fe879be3          	bne	a5,s0,ffffffffc0200d22 <best_fit_check+0x2ba>
    }
    assert(count == 0);
ffffffffc0200d30:	26091b63          	bnez	s2,ffffffffc0200fa6 <best_fit_check+0x53e>
    assert(total == 0);
ffffffffc0200d34:	0e049963          	bnez	s1,ffffffffc0200e26 <best_fit_check+0x3be>
    #ifdef ucore_test
    score += 1;
    cprintf("grading: %d / %d points\n",score, sumscore);
    #endif
}
ffffffffc0200d38:	6406                	ld	s0,64(sp)
ffffffffc0200d3a:	60a6                	ld	ra,72(sp)
ffffffffc0200d3c:	74e2                	ld	s1,56(sp)
ffffffffc0200d3e:	7942                	ld	s2,48(sp)
ffffffffc0200d40:	79a2                	ld	s3,40(sp)
ffffffffc0200d42:	7a02                	ld	s4,32(sp)
ffffffffc0200d44:	6ae2                	ld	s5,24(sp)
ffffffffc0200d46:	6b42                	ld	s6,16(sp)
ffffffffc0200d48:	6ba2                	ld	s7,8(sp)
ffffffffc0200d4a:	6c02                	ld	s8,0(sp)
    cprintf("grading: %d / %d points\n",score, sumscore);
ffffffffc0200d4c:	4619                	li	a2,6
ffffffffc0200d4e:	4599                	li	a1,6
ffffffffc0200d50:	00001517          	auipc	a0,0x1
ffffffffc0200d54:	73050513          	addi	a0,a0,1840 # ffffffffc0202480 <commands+0x7f8>
}
ffffffffc0200d58:	6161                	addi	sp,sp,80
    cprintf("grading: %d / %d points\n",score, sumscore);
ffffffffc0200d5a:	b58ff06f          	j	ffffffffc02000b2 <cprintf>
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200d5e:	4981                	li	s3,0
    int count = 0, total = 0;
ffffffffc0200d60:	4481                	li	s1,0
ffffffffc0200d62:	4901                	li	s2,0
ffffffffc0200d64:	b399                	j	ffffffffc0200aaa <best_fit_check+0x42>
        assert(PageProperty(p));
ffffffffc0200d66:	00001697          	auipc	a3,0x1
ffffffffc0200d6a:	52268693          	addi	a3,a3,1314 # ffffffffc0202288 <commands+0x600>
ffffffffc0200d6e:	00001617          	auipc	a2,0x1
ffffffffc0200d72:	52a60613          	addi	a2,a2,1322 # ffffffffc0202298 <commands+0x610>
ffffffffc0200d76:	10e00593          	li	a1,270
ffffffffc0200d7a:	00001517          	auipc	a0,0x1
ffffffffc0200d7e:	53650513          	addi	a0,a0,1334 # ffffffffc02022b0 <commands+0x628>
ffffffffc0200d82:	bb8ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0200d86:	00001697          	auipc	a3,0x1
ffffffffc0200d8a:	5c268693          	addi	a3,a3,1474 # ffffffffc0202348 <commands+0x6c0>
ffffffffc0200d8e:	00001617          	auipc	a2,0x1
ffffffffc0200d92:	50a60613          	addi	a2,a2,1290 # ffffffffc0202298 <commands+0x610>
ffffffffc0200d96:	0da00593          	li	a1,218
ffffffffc0200d9a:	00001517          	auipc	a0,0x1
ffffffffc0200d9e:	51650513          	addi	a0,a0,1302 # ffffffffc02022b0 <commands+0x628>
ffffffffc0200da2:	b98ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0200da6:	00001697          	auipc	a3,0x1
ffffffffc0200daa:	5ca68693          	addi	a3,a3,1482 # ffffffffc0202370 <commands+0x6e8>
ffffffffc0200dae:	00001617          	auipc	a2,0x1
ffffffffc0200db2:	4ea60613          	addi	a2,a2,1258 # ffffffffc0202298 <commands+0x610>
ffffffffc0200db6:	0db00593          	li	a1,219
ffffffffc0200dba:	00001517          	auipc	a0,0x1
ffffffffc0200dbe:	4f650513          	addi	a0,a0,1270 # ffffffffc02022b0 <commands+0x628>
ffffffffc0200dc2:	b78ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0200dc6:	00001697          	auipc	a3,0x1
ffffffffc0200dca:	5ea68693          	addi	a3,a3,1514 # ffffffffc02023b0 <commands+0x728>
ffffffffc0200dce:	00001617          	auipc	a2,0x1
ffffffffc0200dd2:	4ca60613          	addi	a2,a2,1226 # ffffffffc0202298 <commands+0x610>
ffffffffc0200dd6:	0dd00593          	li	a1,221
ffffffffc0200dda:	00001517          	auipc	a0,0x1
ffffffffc0200dde:	4d650513          	addi	a0,a0,1238 # ffffffffc02022b0 <commands+0x628>
ffffffffc0200de2:	b58ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(!list_empty(&free_list));
ffffffffc0200de6:	00001697          	auipc	a3,0x1
ffffffffc0200dea:	65268693          	addi	a3,a3,1618 # ffffffffc0202438 <commands+0x7b0>
ffffffffc0200dee:	00001617          	auipc	a2,0x1
ffffffffc0200df2:	4aa60613          	addi	a2,a2,1194 # ffffffffc0202298 <commands+0x610>
ffffffffc0200df6:	0f600593          	li	a1,246
ffffffffc0200dfa:	00001517          	auipc	a0,0x1
ffffffffc0200dfe:	4b650513          	addi	a0,a0,1206 # ffffffffc02022b0 <commands+0x628>
ffffffffc0200e02:	b38ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200e06:	00001697          	auipc	a3,0x1
ffffffffc0200e0a:	52268693          	addi	a3,a3,1314 # ffffffffc0202328 <commands+0x6a0>
ffffffffc0200e0e:	00001617          	auipc	a2,0x1
ffffffffc0200e12:	48a60613          	addi	a2,a2,1162 # ffffffffc0202298 <commands+0x610>
ffffffffc0200e16:	0d800593          	li	a1,216
ffffffffc0200e1a:	00001517          	auipc	a0,0x1
ffffffffc0200e1e:	49650513          	addi	a0,a0,1174 # ffffffffc02022b0 <commands+0x628>
ffffffffc0200e22:	b18ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(total == 0);
ffffffffc0200e26:	00001697          	auipc	a3,0x1
ffffffffc0200e2a:	76268693          	addi	a3,a3,1890 # ffffffffc0202588 <commands+0x900>
ffffffffc0200e2e:	00001617          	auipc	a2,0x1
ffffffffc0200e32:	46a60613          	addi	a2,a2,1130 # ffffffffc0202298 <commands+0x610>
ffffffffc0200e36:	15000593          	li	a1,336
ffffffffc0200e3a:	00001517          	auipc	a0,0x1
ffffffffc0200e3e:	47650513          	addi	a0,a0,1142 # ffffffffc02022b0 <commands+0x628>
ffffffffc0200e42:	af8ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(total == nr_free_pages());
ffffffffc0200e46:	00001697          	auipc	a3,0x1
ffffffffc0200e4a:	48268693          	addi	a3,a3,1154 # ffffffffc02022c8 <commands+0x640>
ffffffffc0200e4e:	00001617          	auipc	a2,0x1
ffffffffc0200e52:	44a60613          	addi	a2,a2,1098 # ffffffffc0202298 <commands+0x610>
ffffffffc0200e56:	11100593          	li	a1,273
ffffffffc0200e5a:	00001517          	auipc	a0,0x1
ffffffffc0200e5e:	45650513          	addi	a0,a0,1110 # ffffffffc02022b0 <commands+0x628>
ffffffffc0200e62:	ad8ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200e66:	00001697          	auipc	a3,0x1
ffffffffc0200e6a:	4a268693          	addi	a3,a3,1186 # ffffffffc0202308 <commands+0x680>
ffffffffc0200e6e:	00001617          	auipc	a2,0x1
ffffffffc0200e72:	42a60613          	addi	a2,a2,1066 # ffffffffc0202298 <commands+0x610>
ffffffffc0200e76:	0d700593          	li	a1,215
ffffffffc0200e7a:	00001517          	auipc	a0,0x1
ffffffffc0200e7e:	43650513          	addi	a0,a0,1078 # ffffffffc02022b0 <commands+0x628>
ffffffffc0200e82:	ab8ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200e86:	00001697          	auipc	a3,0x1
ffffffffc0200e8a:	46268693          	addi	a3,a3,1122 # ffffffffc02022e8 <commands+0x660>
ffffffffc0200e8e:	00001617          	auipc	a2,0x1
ffffffffc0200e92:	40a60613          	addi	a2,a2,1034 # ffffffffc0202298 <commands+0x610>
ffffffffc0200e96:	0d600593          	li	a1,214
ffffffffc0200e9a:	00001517          	auipc	a0,0x1
ffffffffc0200e9e:	41650513          	addi	a0,a0,1046 # ffffffffc02022b0 <commands+0x628>
ffffffffc0200ea2:	a98ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(alloc_page() == NULL);
ffffffffc0200ea6:	00001697          	auipc	a3,0x1
ffffffffc0200eaa:	56a68693          	addi	a3,a3,1386 # ffffffffc0202410 <commands+0x788>
ffffffffc0200eae:	00001617          	auipc	a2,0x1
ffffffffc0200eb2:	3ea60613          	addi	a2,a2,1002 # ffffffffc0202298 <commands+0x610>
ffffffffc0200eb6:	0f300593          	li	a1,243
ffffffffc0200eba:	00001517          	auipc	a0,0x1
ffffffffc0200ebe:	3f650513          	addi	a0,a0,1014 # ffffffffc02022b0 <commands+0x628>
ffffffffc0200ec2:	a78ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200ec6:	00001697          	auipc	a3,0x1
ffffffffc0200eca:	46268693          	addi	a3,a3,1122 # ffffffffc0202328 <commands+0x6a0>
ffffffffc0200ece:	00001617          	auipc	a2,0x1
ffffffffc0200ed2:	3ca60613          	addi	a2,a2,970 # ffffffffc0202298 <commands+0x610>
ffffffffc0200ed6:	0f100593          	li	a1,241
ffffffffc0200eda:	00001517          	auipc	a0,0x1
ffffffffc0200ede:	3d650513          	addi	a0,a0,982 # ffffffffc02022b0 <commands+0x628>
ffffffffc0200ee2:	a58ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200ee6:	00001697          	auipc	a3,0x1
ffffffffc0200eea:	42268693          	addi	a3,a3,1058 # ffffffffc0202308 <commands+0x680>
ffffffffc0200eee:	00001617          	auipc	a2,0x1
ffffffffc0200ef2:	3aa60613          	addi	a2,a2,938 # ffffffffc0202298 <commands+0x610>
ffffffffc0200ef6:	0f000593          	li	a1,240
ffffffffc0200efa:	00001517          	auipc	a0,0x1
ffffffffc0200efe:	3b650513          	addi	a0,a0,950 # ffffffffc02022b0 <commands+0x628>
ffffffffc0200f02:	a38ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200f06:	00001697          	auipc	a3,0x1
ffffffffc0200f0a:	3e268693          	addi	a3,a3,994 # ffffffffc02022e8 <commands+0x660>
ffffffffc0200f0e:	00001617          	auipc	a2,0x1
ffffffffc0200f12:	38a60613          	addi	a2,a2,906 # ffffffffc0202298 <commands+0x610>
ffffffffc0200f16:	0ef00593          	li	a1,239
ffffffffc0200f1a:	00001517          	auipc	a0,0x1
ffffffffc0200f1e:	39650513          	addi	a0,a0,918 # ffffffffc02022b0 <commands+0x628>
ffffffffc0200f22:	a18ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(nr_free == 3);
ffffffffc0200f26:	00001697          	auipc	a3,0x1
ffffffffc0200f2a:	50268693          	addi	a3,a3,1282 # ffffffffc0202428 <commands+0x7a0>
ffffffffc0200f2e:	00001617          	auipc	a2,0x1
ffffffffc0200f32:	36a60613          	addi	a2,a2,874 # ffffffffc0202298 <commands+0x610>
ffffffffc0200f36:	0ed00593          	li	a1,237
ffffffffc0200f3a:	00001517          	auipc	a0,0x1
ffffffffc0200f3e:	37650513          	addi	a0,a0,886 # ffffffffc02022b0 <commands+0x628>
ffffffffc0200f42:	9f8ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(alloc_page() == NULL);
ffffffffc0200f46:	00001697          	auipc	a3,0x1
ffffffffc0200f4a:	4ca68693          	addi	a3,a3,1226 # ffffffffc0202410 <commands+0x788>
ffffffffc0200f4e:	00001617          	auipc	a2,0x1
ffffffffc0200f52:	34a60613          	addi	a2,a2,842 # ffffffffc0202298 <commands+0x610>
ffffffffc0200f56:	0e800593          	li	a1,232
ffffffffc0200f5a:	00001517          	auipc	a0,0x1
ffffffffc0200f5e:	35650513          	addi	a0,a0,854 # ffffffffc02022b0 <commands+0x628>
ffffffffc0200f62:	9d8ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0200f66:	00001697          	auipc	a3,0x1
ffffffffc0200f6a:	48a68693          	addi	a3,a3,1162 # ffffffffc02023f0 <commands+0x768>
ffffffffc0200f6e:	00001617          	auipc	a2,0x1
ffffffffc0200f72:	32a60613          	addi	a2,a2,810 # ffffffffc0202298 <commands+0x610>
ffffffffc0200f76:	0df00593          	li	a1,223
ffffffffc0200f7a:	00001517          	auipc	a0,0x1
ffffffffc0200f7e:	33650513          	addi	a0,a0,822 # ffffffffc02022b0 <commands+0x628>
ffffffffc0200f82:	9b8ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0200f86:	00001697          	auipc	a3,0x1
ffffffffc0200f8a:	44a68693          	addi	a3,a3,1098 # ffffffffc02023d0 <commands+0x748>
ffffffffc0200f8e:	00001617          	auipc	a2,0x1
ffffffffc0200f92:	30a60613          	addi	a2,a2,778 # ffffffffc0202298 <commands+0x610>
ffffffffc0200f96:	0de00593          	li	a1,222
ffffffffc0200f9a:	00001517          	auipc	a0,0x1
ffffffffc0200f9e:	31650513          	addi	a0,a0,790 # ffffffffc02022b0 <commands+0x628>
ffffffffc0200fa2:	998ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(count == 0);
ffffffffc0200fa6:	00001697          	auipc	a3,0x1
ffffffffc0200faa:	5d268693          	addi	a3,a3,1490 # ffffffffc0202578 <commands+0x8f0>
ffffffffc0200fae:	00001617          	auipc	a2,0x1
ffffffffc0200fb2:	2ea60613          	addi	a2,a2,746 # ffffffffc0202298 <commands+0x610>
ffffffffc0200fb6:	14f00593          	li	a1,335
ffffffffc0200fba:	00001517          	auipc	a0,0x1
ffffffffc0200fbe:	2f650513          	addi	a0,a0,758 # ffffffffc02022b0 <commands+0x628>
ffffffffc0200fc2:	978ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(nr_free == 0);
ffffffffc0200fc6:	00001697          	auipc	a3,0x1
ffffffffc0200fca:	4aa68693          	addi	a3,a3,1194 # ffffffffc0202470 <commands+0x7e8>
ffffffffc0200fce:	00001617          	auipc	a2,0x1
ffffffffc0200fd2:	2ca60613          	addi	a2,a2,714 # ffffffffc0202298 <commands+0x610>
ffffffffc0200fd6:	14400593          	li	a1,324
ffffffffc0200fda:	00001517          	auipc	a0,0x1
ffffffffc0200fde:	2d650513          	addi	a0,a0,726 # ffffffffc02022b0 <commands+0x628>
ffffffffc0200fe2:	958ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(alloc_page() == NULL);
ffffffffc0200fe6:	00001697          	auipc	a3,0x1
ffffffffc0200fea:	42a68693          	addi	a3,a3,1066 # ffffffffc0202410 <commands+0x788>
ffffffffc0200fee:	00001617          	auipc	a2,0x1
ffffffffc0200ff2:	2aa60613          	addi	a2,a2,682 # ffffffffc0202298 <commands+0x610>
ffffffffc0200ff6:	13e00593          	li	a1,318
ffffffffc0200ffa:	00001517          	auipc	a0,0x1
ffffffffc0200ffe:	2b650513          	addi	a0,a0,694 # ffffffffc02022b0 <commands+0x628>
ffffffffc0201002:	938ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0201006:	00001697          	auipc	a3,0x1
ffffffffc020100a:	55268693          	addi	a3,a3,1362 # ffffffffc0202558 <commands+0x8d0>
ffffffffc020100e:	00001617          	auipc	a2,0x1
ffffffffc0201012:	28a60613          	addi	a2,a2,650 # ffffffffc0202298 <commands+0x610>
ffffffffc0201016:	13d00593          	li	a1,317
ffffffffc020101a:	00001517          	auipc	a0,0x1
ffffffffc020101e:	29650513          	addi	a0,a0,662 # ffffffffc02022b0 <commands+0x628>
ffffffffc0201022:	918ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(p0 + 4 == p1);
ffffffffc0201026:	00001697          	auipc	a3,0x1
ffffffffc020102a:	52268693          	addi	a3,a3,1314 # ffffffffc0202548 <commands+0x8c0>
ffffffffc020102e:	00001617          	auipc	a2,0x1
ffffffffc0201032:	26a60613          	addi	a2,a2,618 # ffffffffc0202298 <commands+0x610>
ffffffffc0201036:	13500593          	li	a1,309
ffffffffc020103a:	00001517          	auipc	a0,0x1
ffffffffc020103e:	27650513          	addi	a0,a0,630 # ffffffffc02022b0 <commands+0x628>
ffffffffc0201042:	8f8ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(alloc_pages(2) != NULL);      // best fit feature
ffffffffc0201046:	00001697          	auipc	a3,0x1
ffffffffc020104a:	4ea68693          	addi	a3,a3,1258 # ffffffffc0202530 <commands+0x8a8>
ffffffffc020104e:	00001617          	auipc	a2,0x1
ffffffffc0201052:	24a60613          	addi	a2,a2,586 # ffffffffc0202298 <commands+0x610>
ffffffffc0201056:	13400593          	li	a1,308
ffffffffc020105a:	00001517          	auipc	a0,0x1
ffffffffc020105e:	25650513          	addi	a0,a0,598 # ffffffffc02022b0 <commands+0x628>
ffffffffc0201062:	8d8ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert((p1 = alloc_pages(1)) != NULL);
ffffffffc0201066:	00001697          	auipc	a3,0x1
ffffffffc020106a:	4aa68693          	addi	a3,a3,1194 # ffffffffc0202510 <commands+0x888>
ffffffffc020106e:	00001617          	auipc	a2,0x1
ffffffffc0201072:	22a60613          	addi	a2,a2,554 # ffffffffc0202298 <commands+0x610>
ffffffffc0201076:	13300593          	li	a1,307
ffffffffc020107a:	00001517          	auipc	a0,0x1
ffffffffc020107e:	23650513          	addi	a0,a0,566 # ffffffffc02022b0 <commands+0x628>
ffffffffc0201082:	8b8ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(PageProperty(p0 + 1) && p0[1].property == 2);
ffffffffc0201086:	00001697          	auipc	a3,0x1
ffffffffc020108a:	45a68693          	addi	a3,a3,1114 # ffffffffc02024e0 <commands+0x858>
ffffffffc020108e:	00001617          	auipc	a2,0x1
ffffffffc0201092:	20a60613          	addi	a2,a2,522 # ffffffffc0202298 <commands+0x610>
ffffffffc0201096:	13100593          	li	a1,305
ffffffffc020109a:	00001517          	auipc	a0,0x1
ffffffffc020109e:	21650513          	addi	a0,a0,534 # ffffffffc02022b0 <commands+0x628>
ffffffffc02010a2:	898ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc02010a6:	00001697          	auipc	a3,0x1
ffffffffc02010aa:	42268693          	addi	a3,a3,1058 # ffffffffc02024c8 <commands+0x840>
ffffffffc02010ae:	00001617          	auipc	a2,0x1
ffffffffc02010b2:	1ea60613          	addi	a2,a2,490 # ffffffffc0202298 <commands+0x610>
ffffffffc02010b6:	13000593          	li	a1,304
ffffffffc02010ba:	00001517          	auipc	a0,0x1
ffffffffc02010be:	1f650513          	addi	a0,a0,502 # ffffffffc02022b0 <commands+0x628>
ffffffffc02010c2:	878ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(alloc_page() == NULL);
ffffffffc02010c6:	00001697          	auipc	a3,0x1
ffffffffc02010ca:	34a68693          	addi	a3,a3,842 # ffffffffc0202410 <commands+0x788>
ffffffffc02010ce:	00001617          	auipc	a2,0x1
ffffffffc02010d2:	1ca60613          	addi	a2,a2,458 # ffffffffc0202298 <commands+0x610>
ffffffffc02010d6:	12400593          	li	a1,292
ffffffffc02010da:	00001517          	auipc	a0,0x1
ffffffffc02010de:	1d650513          	addi	a0,a0,470 # ffffffffc02022b0 <commands+0x628>
ffffffffc02010e2:	858ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(!PageProperty(p0));
ffffffffc02010e6:	00001697          	auipc	a3,0x1
ffffffffc02010ea:	3ca68693          	addi	a3,a3,970 # ffffffffc02024b0 <commands+0x828>
ffffffffc02010ee:	00001617          	auipc	a2,0x1
ffffffffc02010f2:	1aa60613          	addi	a2,a2,426 # ffffffffc0202298 <commands+0x610>
ffffffffc02010f6:	11b00593          	li	a1,283
ffffffffc02010fa:	00001517          	auipc	a0,0x1
ffffffffc02010fe:	1b650513          	addi	a0,a0,438 # ffffffffc02022b0 <commands+0x628>
ffffffffc0201102:	838ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(p0 != NULL);
ffffffffc0201106:	00001697          	auipc	a3,0x1
ffffffffc020110a:	39a68693          	addi	a3,a3,922 # ffffffffc02024a0 <commands+0x818>
ffffffffc020110e:	00001617          	auipc	a2,0x1
ffffffffc0201112:	18a60613          	addi	a2,a2,394 # ffffffffc0202298 <commands+0x610>
ffffffffc0201116:	11a00593          	li	a1,282
ffffffffc020111a:	00001517          	auipc	a0,0x1
ffffffffc020111e:	19650513          	addi	a0,a0,406 # ffffffffc02022b0 <commands+0x628>
ffffffffc0201122:	818ff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(nr_free == 0);
ffffffffc0201126:	00001697          	auipc	a3,0x1
ffffffffc020112a:	34a68693          	addi	a3,a3,842 # ffffffffc0202470 <commands+0x7e8>
ffffffffc020112e:	00001617          	auipc	a2,0x1
ffffffffc0201132:	16a60613          	addi	a2,a2,362 # ffffffffc0202298 <commands+0x610>
ffffffffc0201136:	0fc00593          	li	a1,252
ffffffffc020113a:	00001517          	auipc	a0,0x1
ffffffffc020113e:	17650513          	addi	a0,a0,374 # ffffffffc02022b0 <commands+0x628>
ffffffffc0201142:	ff9fe0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201146:	00001697          	auipc	a3,0x1
ffffffffc020114a:	2ca68693          	addi	a3,a3,714 # ffffffffc0202410 <commands+0x788>
ffffffffc020114e:	00001617          	auipc	a2,0x1
ffffffffc0201152:	14a60613          	addi	a2,a2,330 # ffffffffc0202298 <commands+0x610>
ffffffffc0201156:	0fa00593          	li	a1,250
ffffffffc020115a:	00001517          	auipc	a0,0x1
ffffffffc020115e:	15650513          	addi	a0,a0,342 # ffffffffc02022b0 <commands+0x628>
ffffffffc0201162:	fd9fe0ef          	jal	ra,ffffffffc020013a <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc0201166:	00001697          	auipc	a3,0x1
ffffffffc020116a:	2ea68693          	addi	a3,a3,746 # ffffffffc0202450 <commands+0x7c8>
ffffffffc020116e:	00001617          	auipc	a2,0x1
ffffffffc0201172:	12a60613          	addi	a2,a2,298 # ffffffffc0202298 <commands+0x610>
ffffffffc0201176:	0f900593          	li	a1,249
ffffffffc020117a:	00001517          	auipc	a0,0x1
ffffffffc020117e:	13650513          	addi	a0,a0,310 # ffffffffc02022b0 <commands+0x628>
ffffffffc0201182:	fb9fe0ef          	jal	ra,ffffffffc020013a <__panic>

ffffffffc0201186 <best_fit_free_pages>:
best_fit_free_pages(struct Page *base, size_t n) {
ffffffffc0201186:	1141                	addi	sp,sp,-16
ffffffffc0201188:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc020118a:	14058a63          	beqz	a1,ffffffffc02012de <best_fit_free_pages+0x158>
    for (; p != base + n; p ++) {
ffffffffc020118e:	00259693          	slli	a3,a1,0x2
ffffffffc0201192:	96ae                	add	a3,a3,a1
ffffffffc0201194:	068e                	slli	a3,a3,0x3
ffffffffc0201196:	96aa                	add	a3,a3,a0
ffffffffc0201198:	87aa                	mv	a5,a0
ffffffffc020119a:	02d50263          	beq	a0,a3,ffffffffc02011be <best_fit_free_pages+0x38>
ffffffffc020119e:	6798                	ld	a4,8(a5)
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc02011a0:	8b05                	andi	a4,a4,1
ffffffffc02011a2:	10071e63          	bnez	a4,ffffffffc02012be <best_fit_free_pages+0x138>
ffffffffc02011a6:	6798                	ld	a4,8(a5)
ffffffffc02011a8:	8b09                	andi	a4,a4,2
ffffffffc02011aa:	10071a63          	bnez	a4,ffffffffc02012be <best_fit_free_pages+0x138>
        p->flags = 0;
ffffffffc02011ae:	0007b423          	sd	zero,8(a5)
static inline void set_page_ref(struct Page *page, int val) { page->ref = val; }
ffffffffc02011b2:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc02011b6:	02878793          	addi	a5,a5,40
ffffffffc02011ba:	fed792e3          	bne	a5,a3,ffffffffc020119e <best_fit_free_pages+0x18>
    base->property = n;
ffffffffc02011be:	2581                	sext.w	a1,a1
ffffffffc02011c0:	c90c                	sw	a1,16(a0)
    SetPageProperty(base);
ffffffffc02011c2:	00850893          	addi	a7,a0,8
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02011c6:	4789                	li	a5,2
ffffffffc02011c8:	40f8b02f          	amoor.d	zero,a5,(a7)
    nr_free += n;
ffffffffc02011cc:	00005697          	auipc	a3,0x5
ffffffffc02011d0:	e4468693          	addi	a3,a3,-444 # ffffffffc0206010 <free_area>
ffffffffc02011d4:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc02011d6:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc02011d8:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc02011dc:	9db9                	addw	a1,a1,a4
ffffffffc02011de:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list)) {
ffffffffc02011e0:	0ad78863          	beq	a5,a3,ffffffffc0201290 <best_fit_free_pages+0x10a>
            struct Page* page = le2page(le, page_link);
ffffffffc02011e4:	fe878713          	addi	a4,a5,-24
ffffffffc02011e8:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list)) {
ffffffffc02011ec:	4581                	li	a1,0
            if (base < page) {
ffffffffc02011ee:	00e56a63          	bltu	a0,a4,ffffffffc0201202 <best_fit_free_pages+0x7c>
    return listelm->next;
ffffffffc02011f2:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc02011f4:	06d70263          	beq	a4,a3,ffffffffc0201258 <best_fit_free_pages+0xd2>
    for (; p != base + n; p ++) {
ffffffffc02011f8:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc02011fa:	fe878713          	addi	a4,a5,-24
            if (base < page) {
ffffffffc02011fe:	fee57ae3          	bgeu	a0,a4,ffffffffc02011f2 <best_fit_free_pages+0x6c>
ffffffffc0201202:	c199                	beqz	a1,ffffffffc0201208 <best_fit_free_pages+0x82>
ffffffffc0201204:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc0201208:	6398                	ld	a4,0(a5)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
ffffffffc020120a:	e390                	sd	a2,0(a5)
ffffffffc020120c:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc020120e:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201210:	ed18                	sd	a4,24(a0)
    if (le != &free_list) {
ffffffffc0201212:	02d70063          	beq	a4,a3,ffffffffc0201232 <best_fit_free_pages+0xac>
        if (p + p->property == base) {
ffffffffc0201216:	ff872803          	lw	a6,-8(a4) # ffffffffffffeff8 <end+0x3fdf8b88>
        p = le2page(le, page_link);
ffffffffc020121a:	fe870593          	addi	a1,a4,-24
        if (p + p->property == base) {
ffffffffc020121e:	02081613          	slli	a2,a6,0x20
ffffffffc0201222:	9201                	srli	a2,a2,0x20
ffffffffc0201224:	00261793          	slli	a5,a2,0x2
ffffffffc0201228:	97b2                	add	a5,a5,a2
ffffffffc020122a:	078e                	slli	a5,a5,0x3
ffffffffc020122c:	97ae                	add	a5,a5,a1
ffffffffc020122e:	02f50f63          	beq	a0,a5,ffffffffc020126c <best_fit_free_pages+0xe6>
    return listelm->next;
ffffffffc0201232:	7118                	ld	a4,32(a0)
    if (le != &free_list) {
ffffffffc0201234:	00d70f63          	beq	a4,a3,ffffffffc0201252 <best_fit_free_pages+0xcc>
        if (base + base->property == p) {
ffffffffc0201238:	490c                	lw	a1,16(a0)
        p = le2page(le, page_link);
ffffffffc020123a:	fe870693          	addi	a3,a4,-24
        if (base + base->property == p) {
ffffffffc020123e:	02059613          	slli	a2,a1,0x20
ffffffffc0201242:	9201                	srli	a2,a2,0x20
ffffffffc0201244:	00261793          	slli	a5,a2,0x2
ffffffffc0201248:	97b2                	add	a5,a5,a2
ffffffffc020124a:	078e                	slli	a5,a5,0x3
ffffffffc020124c:	97aa                	add	a5,a5,a0
ffffffffc020124e:	04f68863          	beq	a3,a5,ffffffffc020129e <best_fit_free_pages+0x118>
}
ffffffffc0201252:	60a2                	ld	ra,8(sp)
ffffffffc0201254:	0141                	addi	sp,sp,16
ffffffffc0201256:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0201258:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc020125a:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc020125c:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc020125e:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list) {
ffffffffc0201260:	02d70563          	beq	a4,a3,ffffffffc020128a <best_fit_free_pages+0x104>
    prev->next = next->prev = elm;
ffffffffc0201264:	8832                	mv	a6,a2
ffffffffc0201266:	4585                	li	a1,1
    for (; p != base + n; p ++) {
ffffffffc0201268:	87ba                	mv	a5,a4
ffffffffc020126a:	bf41                	j	ffffffffc02011fa <best_fit_free_pages+0x74>
            p->property += base->property;
ffffffffc020126c:	491c                	lw	a5,16(a0)
ffffffffc020126e:	0107883b          	addw	a6,a5,a6
ffffffffc0201272:	ff072c23          	sw	a6,-8(a4)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0201276:	57f5                	li	a5,-3
ffffffffc0201278:	60f8b02f          	amoand.d	zero,a5,(a7)
    __list_del(listelm->prev, listelm->next);
ffffffffc020127c:	6d10                	ld	a2,24(a0)
ffffffffc020127e:	711c                	ld	a5,32(a0)
            base = p;
ffffffffc0201280:	852e                	mv	a0,a1
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc0201282:	e61c                	sd	a5,8(a2)
    return listelm->next;
ffffffffc0201284:	6718                	ld	a4,8(a4)
    next->prev = prev;
ffffffffc0201286:	e390                	sd	a2,0(a5)
ffffffffc0201288:	b775                	j	ffffffffc0201234 <best_fit_free_pages+0xae>
ffffffffc020128a:	e290                	sd	a2,0(a3)
        while ((le = list_next(le)) != &free_list) {
ffffffffc020128c:	873e                	mv	a4,a5
ffffffffc020128e:	b761                	j	ffffffffc0201216 <best_fit_free_pages+0x90>
}
ffffffffc0201290:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc0201292:	e390                	sd	a2,0(a5)
ffffffffc0201294:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201296:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201298:	ed1c                	sd	a5,24(a0)
ffffffffc020129a:	0141                	addi	sp,sp,16
ffffffffc020129c:	8082                	ret
            base->property += p->property;
ffffffffc020129e:	ff872783          	lw	a5,-8(a4)
ffffffffc02012a2:	ff070693          	addi	a3,a4,-16
ffffffffc02012a6:	9dbd                	addw	a1,a1,a5
ffffffffc02012a8:	c90c                	sw	a1,16(a0)
ffffffffc02012aa:	57f5                	li	a5,-3
ffffffffc02012ac:	60f6b02f          	amoand.d	zero,a5,(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc02012b0:	6314                	ld	a3,0(a4)
ffffffffc02012b2:	671c                	ld	a5,8(a4)
}
ffffffffc02012b4:	60a2                	ld	ra,8(sp)
    prev->next = next;
ffffffffc02012b6:	e69c                	sd	a5,8(a3)
    next->prev = prev;
ffffffffc02012b8:	e394                	sd	a3,0(a5)
ffffffffc02012ba:	0141                	addi	sp,sp,16
ffffffffc02012bc:	8082                	ret
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc02012be:	00001697          	auipc	a3,0x1
ffffffffc02012c2:	2e268693          	addi	a3,a3,738 # ffffffffc02025a0 <commands+0x918>
ffffffffc02012c6:	00001617          	auipc	a2,0x1
ffffffffc02012ca:	fd260613          	addi	a2,a2,-46 # ffffffffc0202298 <commands+0x610>
ffffffffc02012ce:	09600593          	li	a1,150
ffffffffc02012d2:	00001517          	auipc	a0,0x1
ffffffffc02012d6:	fde50513          	addi	a0,a0,-34 # ffffffffc02022b0 <commands+0x628>
ffffffffc02012da:	e61fe0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(n > 0);
ffffffffc02012de:	00001697          	auipc	a3,0x1
ffffffffc02012e2:	2ba68693          	addi	a3,a3,698 # ffffffffc0202598 <commands+0x910>
ffffffffc02012e6:	00001617          	auipc	a2,0x1
ffffffffc02012ea:	fb260613          	addi	a2,a2,-78 # ffffffffc0202298 <commands+0x610>
ffffffffc02012ee:	09300593          	li	a1,147
ffffffffc02012f2:	00001517          	auipc	a0,0x1
ffffffffc02012f6:	fbe50513          	addi	a0,a0,-66 # ffffffffc02022b0 <commands+0x628>
ffffffffc02012fa:	e41fe0ef          	jal	ra,ffffffffc020013a <__panic>

ffffffffc02012fe <best_fit_alloc_pages>:
    assert(n > 0);
ffffffffc02012fe:	c155                	beqz	a0,ffffffffc02013a2 <best_fit_alloc_pages+0xa4>
    if (n > nr_free) {
ffffffffc0201300:	00005597          	auipc	a1,0x5
ffffffffc0201304:	d1058593          	addi	a1,a1,-752 # ffffffffc0206010 <free_area>
ffffffffc0201308:	0105a883          	lw	a7,16(a1)
ffffffffc020130c:	86aa                	mv	a3,a0
ffffffffc020130e:	02089793          	slli	a5,a7,0x20
ffffffffc0201312:	9381                	srli	a5,a5,0x20
ffffffffc0201314:	08a7e563          	bltu	a5,a0,ffffffffc020139e <best_fit_alloc_pages+0xa0>
    return listelm->next;
ffffffffc0201318:	659c                	ld	a5,8(a1)
    struct Page *page = NULL;
ffffffffc020131a:	4501                	li	a0,0
    while ((le = list_next(le)) != &free_list) {
ffffffffc020131c:	08b78063          	beq	a5,a1,ffffffffc020139c <best_fit_alloc_pages+0x9e>
        if (p->property >= n) {
ffffffffc0201320:	ff87a703          	lw	a4,-8(a5)
        struct Page *p = le2page(le, page_link);
ffffffffc0201324:	fe878813          	addi	a6,a5,-24
        if (p->property >= n) {
ffffffffc0201328:	02071613          	slli	a2,a4,0x20
ffffffffc020132c:	9201                	srli	a2,a2,0x20
ffffffffc020132e:	00d66763          	bltu	a2,a3,ffffffffc020133c <best_fit_alloc_pages+0x3e>
            if(page == NULL){
ffffffffc0201332:	c501                	beqz	a0,ffffffffc020133a <best_fit_alloc_pages+0x3c>
                if(page->property > p->property){//如果新的页块符合要求且比page小
ffffffffc0201334:	4910                	lw	a2,16(a0)
ffffffffc0201336:	00c77363          	bgeu	a4,a2,ffffffffc020133c <best_fit_alloc_pages+0x3e>
                page = p;
ffffffffc020133a:	8542                	mv	a0,a6
ffffffffc020133c:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list) {
ffffffffc020133e:	feb791e3          	bne	a5,a1,ffffffffc0201320 <best_fit_alloc_pages+0x22>
    if (page != NULL) {
ffffffffc0201342:	cd29                	beqz	a0,ffffffffc020139c <best_fit_alloc_pages+0x9e>
    __list_del(listelm->prev, listelm->next);
ffffffffc0201344:	711c                	ld	a5,32(a0)
    return listelm->prev;
ffffffffc0201346:	6d18                	ld	a4,24(a0)
        if (page->property > n) {
ffffffffc0201348:	4910                	lw	a2,16(a0)
            p->property = page->property - n;
ffffffffc020134a:	0006881b          	sext.w	a6,a3
    prev->next = next;
ffffffffc020134e:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc0201350:	e398                	sd	a4,0(a5)
        if (page->property > n) {
ffffffffc0201352:	02061793          	slli	a5,a2,0x20
ffffffffc0201356:	9381                	srli	a5,a5,0x20
ffffffffc0201358:	02f6f863          	bgeu	a3,a5,ffffffffc0201388 <best_fit_alloc_pages+0x8a>
            struct Page *p = page + n;
ffffffffc020135c:	00269793          	slli	a5,a3,0x2
ffffffffc0201360:	97b6                	add	a5,a5,a3
ffffffffc0201362:	078e                	slli	a5,a5,0x3
ffffffffc0201364:	97aa                	add	a5,a5,a0
            p->property = page->property - n;
ffffffffc0201366:	4106063b          	subw	a2,a2,a6
ffffffffc020136a:	cb90                	sw	a2,16(a5)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc020136c:	4689                	li	a3,2
ffffffffc020136e:	00878613          	addi	a2,a5,8
ffffffffc0201372:	40d6302f          	amoor.d	zero,a3,(a2)
    __list_add(elm, listelm, listelm->next);
ffffffffc0201376:	6714                	ld	a3,8(a4)
            list_add(prev, &(p->page_link));
ffffffffc0201378:	01878613          	addi	a2,a5,24
        nr_free -= n;
ffffffffc020137c:	0105a883          	lw	a7,16(a1)
    prev->next = next->prev = elm;
ffffffffc0201380:	e290                	sd	a2,0(a3)
ffffffffc0201382:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc0201384:	f394                	sd	a3,32(a5)
    elm->prev = prev;
ffffffffc0201386:	ef98                	sd	a4,24(a5)
ffffffffc0201388:	410888bb          	subw	a7,a7,a6
ffffffffc020138c:	0115a823          	sw	a7,16(a1)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0201390:	57f5                	li	a5,-3
ffffffffc0201392:	00850713          	addi	a4,a0,8
ffffffffc0201396:	60f7302f          	amoand.d	zero,a5,(a4)
}
ffffffffc020139a:	8082                	ret
}
ffffffffc020139c:	8082                	ret
        return NULL;
ffffffffc020139e:	4501                	li	a0,0
ffffffffc02013a0:	8082                	ret
best_fit_alloc_pages(size_t n) {
ffffffffc02013a2:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc02013a4:	00001697          	auipc	a3,0x1
ffffffffc02013a8:	1f468693          	addi	a3,a3,500 # ffffffffc0202598 <commands+0x910>
ffffffffc02013ac:	00001617          	auipc	a2,0x1
ffffffffc02013b0:	eec60613          	addi	a2,a2,-276 # ffffffffc0202298 <commands+0x610>
ffffffffc02013b4:	06900593          	li	a1,105
ffffffffc02013b8:	00001517          	auipc	a0,0x1
ffffffffc02013bc:	ef850513          	addi	a0,a0,-264 # ffffffffc02022b0 <commands+0x628>
best_fit_alloc_pages(size_t n) {
ffffffffc02013c0:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc02013c2:	d79fe0ef          	jal	ra,ffffffffc020013a <__panic>

ffffffffc02013c6 <best_fit_init_memmap>:
best_fit_init_memmap(struct Page *base, size_t n) {
ffffffffc02013c6:	1141                	addi	sp,sp,-16
ffffffffc02013c8:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc02013ca:	c9e1                	beqz	a1,ffffffffc020149a <best_fit_init_memmap+0xd4>
    for (; p != base + n; p ++) {
ffffffffc02013cc:	00259693          	slli	a3,a1,0x2
ffffffffc02013d0:	96ae                	add	a3,a3,a1
ffffffffc02013d2:	068e                	slli	a3,a3,0x3
ffffffffc02013d4:	96aa                	add	a3,a3,a0
ffffffffc02013d6:	87aa                	mv	a5,a0
ffffffffc02013d8:	00d50f63          	beq	a0,a3,ffffffffc02013f6 <best_fit_init_memmap+0x30>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc02013dc:	6798                	ld	a4,8(a5)
        assert(PageReserved(p));
ffffffffc02013de:	8b05                	andi	a4,a4,1
ffffffffc02013e0:	cf49                	beqz	a4,ffffffffc020147a <best_fit_init_memmap+0xb4>
        p->flags = p->property = 0;
ffffffffc02013e2:	0007a823          	sw	zero,16(a5)
ffffffffc02013e6:	0007b423          	sd	zero,8(a5)
ffffffffc02013ea:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc02013ee:	02878793          	addi	a5,a5,40
ffffffffc02013f2:	fed795e3          	bne	a5,a3,ffffffffc02013dc <best_fit_init_memmap+0x16>
    base->property = n;
ffffffffc02013f6:	2581                	sext.w	a1,a1
ffffffffc02013f8:	c90c                	sw	a1,16(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02013fa:	4789                	li	a5,2
ffffffffc02013fc:	00850713          	addi	a4,a0,8
ffffffffc0201400:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
ffffffffc0201404:	00005697          	auipc	a3,0x5
ffffffffc0201408:	c0c68693          	addi	a3,a3,-1012 # ffffffffc0206010 <free_area>
ffffffffc020140c:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc020140e:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc0201410:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc0201414:	9db9                	addw	a1,a1,a4
ffffffffc0201416:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list)) {
ffffffffc0201418:	04d78a63          	beq	a5,a3,ffffffffc020146c <best_fit_init_memmap+0xa6>
            struct Page* page = le2page(le, page_link);
ffffffffc020141c:	fe878713          	addi	a4,a5,-24
ffffffffc0201420:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list)) {
ffffffffc0201424:	4581                	li	a1,0
            if (base < page) {
ffffffffc0201426:	00e56a63          	bltu	a0,a4,ffffffffc020143a <best_fit_init_memmap+0x74>
    return listelm->next;
ffffffffc020142a:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc020142c:	02d70263          	beq	a4,a3,ffffffffc0201450 <best_fit_init_memmap+0x8a>
    for (; p != base + n; p ++) {
ffffffffc0201430:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc0201432:	fe878713          	addi	a4,a5,-24
            if (base < page) {
ffffffffc0201436:	fee57ae3          	bgeu	a0,a4,ffffffffc020142a <best_fit_init_memmap+0x64>
ffffffffc020143a:	c199                	beqz	a1,ffffffffc0201440 <best_fit_init_memmap+0x7a>
ffffffffc020143c:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc0201440:	6398                	ld	a4,0(a5)
}
ffffffffc0201442:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc0201444:	e390                	sd	a2,0(a5)
ffffffffc0201446:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc0201448:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc020144a:	ed18                	sd	a4,24(a0)
ffffffffc020144c:	0141                	addi	sp,sp,16
ffffffffc020144e:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0201450:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201452:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc0201454:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0201456:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list) {
ffffffffc0201458:	00d70663          	beq	a4,a3,ffffffffc0201464 <best_fit_init_memmap+0x9e>
    prev->next = next->prev = elm;
ffffffffc020145c:	8832                	mv	a6,a2
ffffffffc020145e:	4585                	li	a1,1
    for (; p != base + n; p ++) {
ffffffffc0201460:	87ba                	mv	a5,a4
ffffffffc0201462:	bfc1                	j	ffffffffc0201432 <best_fit_init_memmap+0x6c>
}
ffffffffc0201464:	60a2                	ld	ra,8(sp)
ffffffffc0201466:	e290                	sd	a2,0(a3)
ffffffffc0201468:	0141                	addi	sp,sp,16
ffffffffc020146a:	8082                	ret
ffffffffc020146c:	60a2                	ld	ra,8(sp)
ffffffffc020146e:	e390                	sd	a2,0(a5)
ffffffffc0201470:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201472:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201474:	ed1c                	sd	a5,24(a0)
ffffffffc0201476:	0141                	addi	sp,sp,16
ffffffffc0201478:	8082                	ret
        assert(PageReserved(p));
ffffffffc020147a:	00001697          	auipc	a3,0x1
ffffffffc020147e:	14e68693          	addi	a3,a3,334 # ffffffffc02025c8 <commands+0x940>
ffffffffc0201482:	00001617          	auipc	a2,0x1
ffffffffc0201486:	e1660613          	addi	a2,a2,-490 # ffffffffc0202298 <commands+0x610>
ffffffffc020148a:	04a00593          	li	a1,74
ffffffffc020148e:	00001517          	auipc	a0,0x1
ffffffffc0201492:	e2250513          	addi	a0,a0,-478 # ffffffffc02022b0 <commands+0x628>
ffffffffc0201496:	ca5fe0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(n > 0);
ffffffffc020149a:	00001697          	auipc	a3,0x1
ffffffffc020149e:	0fe68693          	addi	a3,a3,254 # ffffffffc0202598 <commands+0x910>
ffffffffc02014a2:	00001617          	auipc	a2,0x1
ffffffffc02014a6:	df660613          	addi	a2,a2,-522 # ffffffffc0202298 <commands+0x610>
ffffffffc02014aa:	04700593          	li	a1,71
ffffffffc02014ae:	00001517          	auipc	a0,0x1
ffffffffc02014b2:	e0250513          	addi	a0,a0,-510 # ffffffffc02022b0 <commands+0x628>
ffffffffc02014b6:	c85fe0ef          	jal	ra,ffffffffc020013a <__panic>

ffffffffc02014ba <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc02014ba:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc02014bc:	e589                	bnez	a1,ffffffffc02014c6 <strnlen+0xc>
ffffffffc02014be:	a811                	j	ffffffffc02014d2 <strnlen+0x18>
        cnt ++;
ffffffffc02014c0:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc02014c2:	00f58863          	beq	a1,a5,ffffffffc02014d2 <strnlen+0x18>
ffffffffc02014c6:	00f50733          	add	a4,a0,a5
ffffffffc02014ca:	00074703          	lbu	a4,0(a4)
ffffffffc02014ce:	fb6d                	bnez	a4,ffffffffc02014c0 <strnlen+0x6>
ffffffffc02014d0:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc02014d2:	852e                	mv	a0,a1
ffffffffc02014d4:	8082                	ret

ffffffffc02014d6 <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc02014d6:	00054783          	lbu	a5,0(a0)
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02014da:	0005c703          	lbu	a4,0(a1)
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc02014de:	cb89                	beqz	a5,ffffffffc02014f0 <strcmp+0x1a>
        s1 ++, s2 ++;
ffffffffc02014e0:	0505                	addi	a0,a0,1
ffffffffc02014e2:	0585                	addi	a1,a1,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc02014e4:	fee789e3          	beq	a5,a4,ffffffffc02014d6 <strcmp>
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02014e8:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc02014ec:	9d19                	subw	a0,a0,a4
ffffffffc02014ee:	8082                	ret
ffffffffc02014f0:	4501                	li	a0,0
ffffffffc02014f2:	bfed                	j	ffffffffc02014ec <strcmp+0x16>

ffffffffc02014f4 <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
ffffffffc02014f4:	00054783          	lbu	a5,0(a0)
ffffffffc02014f8:	c799                	beqz	a5,ffffffffc0201506 <strchr+0x12>
        if (*s == c) {
ffffffffc02014fa:	00f58763          	beq	a1,a5,ffffffffc0201508 <strchr+0x14>
    while (*s != '\0') {
ffffffffc02014fe:	00154783          	lbu	a5,1(a0)
            return (char *)s;
        }
        s ++;
ffffffffc0201502:	0505                	addi	a0,a0,1
    while (*s != '\0') {
ffffffffc0201504:	fbfd                	bnez	a5,ffffffffc02014fa <strchr+0x6>
    }
    return NULL;
ffffffffc0201506:	4501                	li	a0,0
}
ffffffffc0201508:	8082                	ret

ffffffffc020150a <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc020150a:	ca01                	beqz	a2,ffffffffc020151a <memset+0x10>
ffffffffc020150c:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc020150e:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc0201510:	0785                	addi	a5,a5,1
ffffffffc0201512:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc0201516:	fec79de3          	bne	a5,a2,ffffffffc0201510 <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc020151a:	8082                	ret

ffffffffc020151c <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc020151c:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0201520:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
ffffffffc0201522:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0201526:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc0201528:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc020152c:	f022                	sd	s0,32(sp)
ffffffffc020152e:	ec26                	sd	s1,24(sp)
ffffffffc0201530:	e84a                	sd	s2,16(sp)
ffffffffc0201532:	f406                	sd	ra,40(sp)
ffffffffc0201534:	e44e                	sd	s3,8(sp)
ffffffffc0201536:	84aa                	mv	s1,a0
ffffffffc0201538:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc020153a:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
ffffffffc020153e:	2a01                	sext.w	s4,s4
    if (num >= base) {
ffffffffc0201540:	03067e63          	bgeu	a2,a6,ffffffffc020157c <printnum+0x60>
ffffffffc0201544:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc0201546:	00805763          	blez	s0,ffffffffc0201554 <printnum+0x38>
ffffffffc020154a:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc020154c:	85ca                	mv	a1,s2
ffffffffc020154e:	854e                	mv	a0,s3
ffffffffc0201550:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc0201552:	fc65                	bnez	s0,ffffffffc020154a <printnum+0x2e>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0201554:	1a02                	slli	s4,s4,0x20
ffffffffc0201556:	00001797          	auipc	a5,0x1
ffffffffc020155a:	0d278793          	addi	a5,a5,210 # ffffffffc0202628 <best_fit_pmm_manager+0x38>
ffffffffc020155e:	020a5a13          	srli	s4,s4,0x20
ffffffffc0201562:	9a3e                	add	s4,s4,a5
}
ffffffffc0201564:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0201566:	000a4503          	lbu	a0,0(s4)
}
ffffffffc020156a:	70a2                	ld	ra,40(sp)
ffffffffc020156c:	69a2                	ld	s3,8(sp)
ffffffffc020156e:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0201570:	85ca                	mv	a1,s2
ffffffffc0201572:	87a6                	mv	a5,s1
}
ffffffffc0201574:	6942                	ld	s2,16(sp)
ffffffffc0201576:	64e2                	ld	s1,24(sp)
ffffffffc0201578:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc020157a:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc020157c:	03065633          	divu	a2,a2,a6
ffffffffc0201580:	8722                	mv	a4,s0
ffffffffc0201582:	f9bff0ef          	jal	ra,ffffffffc020151c <printnum>
ffffffffc0201586:	b7f9                	j	ffffffffc0201554 <printnum+0x38>

ffffffffc0201588 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc0201588:	7119                	addi	sp,sp,-128
ffffffffc020158a:	f4a6                	sd	s1,104(sp)
ffffffffc020158c:	f0ca                	sd	s2,96(sp)
ffffffffc020158e:	ecce                	sd	s3,88(sp)
ffffffffc0201590:	e8d2                	sd	s4,80(sp)
ffffffffc0201592:	e4d6                	sd	s5,72(sp)
ffffffffc0201594:	e0da                	sd	s6,64(sp)
ffffffffc0201596:	fc5e                	sd	s7,56(sp)
ffffffffc0201598:	f06a                	sd	s10,32(sp)
ffffffffc020159a:	fc86                	sd	ra,120(sp)
ffffffffc020159c:	f8a2                	sd	s0,112(sp)
ffffffffc020159e:	f862                	sd	s8,48(sp)
ffffffffc02015a0:	f466                	sd	s9,40(sp)
ffffffffc02015a2:	ec6e                	sd	s11,24(sp)
ffffffffc02015a4:	892a                	mv	s2,a0
ffffffffc02015a6:	84ae                	mv	s1,a1
ffffffffc02015a8:	8d32                	mv	s10,a2
ffffffffc02015aa:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02015ac:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
ffffffffc02015b0:	5b7d                	li	s6,-1
ffffffffc02015b2:	00001a97          	auipc	s5,0x1
ffffffffc02015b6:	0aaa8a93          	addi	s5,s5,170 # ffffffffc020265c <best_fit_pmm_manager+0x6c>
        case 'e':
            err = va_arg(ap, int);
            if (err < 0) {
                err = -err;
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc02015ba:	00001b97          	auipc	s7,0x1
ffffffffc02015be:	27eb8b93          	addi	s7,s7,638 # ffffffffc0202838 <error_string>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02015c2:	000d4503          	lbu	a0,0(s10)
ffffffffc02015c6:	001d0413          	addi	s0,s10,1
ffffffffc02015ca:	01350a63          	beq	a0,s3,ffffffffc02015de <vprintfmt+0x56>
            if (ch == '\0') {
ffffffffc02015ce:	c121                	beqz	a0,ffffffffc020160e <vprintfmt+0x86>
            putch(ch, putdat);
ffffffffc02015d0:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02015d2:	0405                	addi	s0,s0,1
            putch(ch, putdat);
ffffffffc02015d4:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02015d6:	fff44503          	lbu	a0,-1(s0)
ffffffffc02015da:	ff351ae3          	bne	a0,s3,ffffffffc02015ce <vprintfmt+0x46>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02015de:	00044603          	lbu	a2,0(s0)
        char padc = ' ';
ffffffffc02015e2:	02000793          	li	a5,32
        lflag = altflag = 0;
ffffffffc02015e6:	4c81                	li	s9,0
ffffffffc02015e8:	4881                	li	a7,0
        width = precision = -1;
ffffffffc02015ea:	5c7d                	li	s8,-1
ffffffffc02015ec:	5dfd                	li	s11,-1
ffffffffc02015ee:	05500513          	li	a0,85
                if (ch < '0' || ch > '9') {
ffffffffc02015f2:	4825                	li	a6,9
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02015f4:	fdd6059b          	addiw	a1,a2,-35
ffffffffc02015f8:	0ff5f593          	andi	a1,a1,255
ffffffffc02015fc:	00140d13          	addi	s10,s0,1
ffffffffc0201600:	04b56263          	bltu	a0,a1,ffffffffc0201644 <vprintfmt+0xbc>
ffffffffc0201604:	058a                	slli	a1,a1,0x2
ffffffffc0201606:	95d6                	add	a1,a1,s5
ffffffffc0201608:	4194                	lw	a3,0(a1)
ffffffffc020160a:	96d6                	add	a3,a3,s5
ffffffffc020160c:	8682                	jr	a3
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc020160e:	70e6                	ld	ra,120(sp)
ffffffffc0201610:	7446                	ld	s0,112(sp)
ffffffffc0201612:	74a6                	ld	s1,104(sp)
ffffffffc0201614:	7906                	ld	s2,96(sp)
ffffffffc0201616:	69e6                	ld	s3,88(sp)
ffffffffc0201618:	6a46                	ld	s4,80(sp)
ffffffffc020161a:	6aa6                	ld	s5,72(sp)
ffffffffc020161c:	6b06                	ld	s6,64(sp)
ffffffffc020161e:	7be2                	ld	s7,56(sp)
ffffffffc0201620:	7c42                	ld	s8,48(sp)
ffffffffc0201622:	7ca2                	ld	s9,40(sp)
ffffffffc0201624:	7d02                	ld	s10,32(sp)
ffffffffc0201626:	6de2                	ld	s11,24(sp)
ffffffffc0201628:	6109                	addi	sp,sp,128
ffffffffc020162a:	8082                	ret
            padc = '0';
ffffffffc020162c:	87b2                	mv	a5,a2
            goto reswitch;
ffffffffc020162e:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201632:	846a                	mv	s0,s10
ffffffffc0201634:	00140d13          	addi	s10,s0,1
ffffffffc0201638:	fdd6059b          	addiw	a1,a2,-35
ffffffffc020163c:	0ff5f593          	andi	a1,a1,255
ffffffffc0201640:	fcb572e3          	bgeu	a0,a1,ffffffffc0201604 <vprintfmt+0x7c>
            putch('%', putdat);
ffffffffc0201644:	85a6                	mv	a1,s1
ffffffffc0201646:	02500513          	li	a0,37
ffffffffc020164a:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc020164c:	fff44783          	lbu	a5,-1(s0)
ffffffffc0201650:	8d22                	mv	s10,s0
ffffffffc0201652:	f73788e3          	beq	a5,s3,ffffffffc02015c2 <vprintfmt+0x3a>
ffffffffc0201656:	ffed4783          	lbu	a5,-2(s10)
ffffffffc020165a:	1d7d                	addi	s10,s10,-1
ffffffffc020165c:	ff379de3          	bne	a5,s3,ffffffffc0201656 <vprintfmt+0xce>
ffffffffc0201660:	b78d                	j	ffffffffc02015c2 <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
ffffffffc0201662:	fd060c1b          	addiw	s8,a2,-48
                ch = *fmt;
ffffffffc0201666:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020166a:	846a                	mv	s0,s10
                if (ch < '0' || ch > '9') {
ffffffffc020166c:	fd06069b          	addiw	a3,a2,-48
                ch = *fmt;
ffffffffc0201670:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc0201674:	02d86463          	bltu	a6,a3,ffffffffc020169c <vprintfmt+0x114>
                ch = *fmt;
ffffffffc0201678:	00144603          	lbu	a2,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc020167c:	002c169b          	slliw	a3,s8,0x2
ffffffffc0201680:	0186873b          	addw	a4,a3,s8
ffffffffc0201684:	0017171b          	slliw	a4,a4,0x1
ffffffffc0201688:	9f2d                	addw	a4,a4,a1
                if (ch < '0' || ch > '9') {
ffffffffc020168a:	fd06069b          	addiw	a3,a2,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc020168e:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc0201690:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
ffffffffc0201694:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc0201698:	fed870e3          	bgeu	a6,a3,ffffffffc0201678 <vprintfmt+0xf0>
            if (width < 0)
ffffffffc020169c:	f40ddce3          	bgez	s11,ffffffffc02015f4 <vprintfmt+0x6c>
                width = precision, precision = -1;
ffffffffc02016a0:	8de2                	mv	s11,s8
ffffffffc02016a2:	5c7d                	li	s8,-1
ffffffffc02016a4:	bf81                	j	ffffffffc02015f4 <vprintfmt+0x6c>
            if (width < 0)
ffffffffc02016a6:	fffdc693          	not	a3,s11
ffffffffc02016aa:	96fd                	srai	a3,a3,0x3f
ffffffffc02016ac:	00ddfdb3          	and	s11,s11,a3
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02016b0:	00144603          	lbu	a2,1(s0)
ffffffffc02016b4:	2d81                	sext.w	s11,s11
ffffffffc02016b6:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc02016b8:	bf35                	j	ffffffffc02015f4 <vprintfmt+0x6c>
            precision = va_arg(ap, int);
ffffffffc02016ba:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02016be:	00144603          	lbu	a2,1(s0)
            precision = va_arg(ap, int);
ffffffffc02016c2:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02016c4:	846a                	mv	s0,s10
            goto process_precision;
ffffffffc02016c6:	bfd9                	j	ffffffffc020169c <vprintfmt+0x114>
    if (lflag >= 2) {
ffffffffc02016c8:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02016ca:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc02016ce:	01174463          	blt	a4,a7,ffffffffc02016d6 <vprintfmt+0x14e>
    else if (lflag) {
ffffffffc02016d2:	1a088e63          	beqz	a7,ffffffffc020188e <vprintfmt+0x306>
        return va_arg(*ap, unsigned long);
ffffffffc02016d6:	000a3603          	ld	a2,0(s4)
ffffffffc02016da:	46c1                	li	a3,16
ffffffffc02016dc:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc02016de:	2781                	sext.w	a5,a5
ffffffffc02016e0:	876e                	mv	a4,s11
ffffffffc02016e2:	85a6                	mv	a1,s1
ffffffffc02016e4:	854a                	mv	a0,s2
ffffffffc02016e6:	e37ff0ef          	jal	ra,ffffffffc020151c <printnum>
            break;
ffffffffc02016ea:	bde1                	j	ffffffffc02015c2 <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
ffffffffc02016ec:	000a2503          	lw	a0,0(s4)
ffffffffc02016f0:	85a6                	mv	a1,s1
ffffffffc02016f2:	0a21                	addi	s4,s4,8
ffffffffc02016f4:	9902                	jalr	s2
            break;
ffffffffc02016f6:	b5f1                	j	ffffffffc02015c2 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc02016f8:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02016fa:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc02016fe:	01174463          	blt	a4,a7,ffffffffc0201706 <vprintfmt+0x17e>
    else if (lflag) {
ffffffffc0201702:	18088163          	beqz	a7,ffffffffc0201884 <vprintfmt+0x2fc>
        return va_arg(*ap, unsigned long);
ffffffffc0201706:	000a3603          	ld	a2,0(s4)
ffffffffc020170a:	46a9                	li	a3,10
ffffffffc020170c:	8a2e                	mv	s4,a1
ffffffffc020170e:	bfc1                	j	ffffffffc02016de <vprintfmt+0x156>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201710:	00144603          	lbu	a2,1(s0)
            altflag = 1;
ffffffffc0201714:	4c85                	li	s9,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201716:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0201718:	bdf1                	j	ffffffffc02015f4 <vprintfmt+0x6c>
            putch(ch, putdat);
ffffffffc020171a:	85a6                	mv	a1,s1
ffffffffc020171c:	02500513          	li	a0,37
ffffffffc0201720:	9902                	jalr	s2
            break;
ffffffffc0201722:	b545                	j	ffffffffc02015c2 <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201724:	00144603          	lbu	a2,1(s0)
            lflag ++;
ffffffffc0201728:	2885                	addiw	a7,a7,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020172a:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc020172c:	b5e1                	j	ffffffffc02015f4 <vprintfmt+0x6c>
    if (lflag >= 2) {
ffffffffc020172e:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0201730:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0201734:	01174463          	blt	a4,a7,ffffffffc020173c <vprintfmt+0x1b4>
    else if (lflag) {
ffffffffc0201738:	14088163          	beqz	a7,ffffffffc020187a <vprintfmt+0x2f2>
        return va_arg(*ap, unsigned long);
ffffffffc020173c:	000a3603          	ld	a2,0(s4)
ffffffffc0201740:	46a1                	li	a3,8
ffffffffc0201742:	8a2e                	mv	s4,a1
ffffffffc0201744:	bf69                	j	ffffffffc02016de <vprintfmt+0x156>
            putch('0', putdat);
ffffffffc0201746:	03000513          	li	a0,48
ffffffffc020174a:	85a6                	mv	a1,s1
ffffffffc020174c:	e03e                	sd	a5,0(sp)
ffffffffc020174e:	9902                	jalr	s2
            putch('x', putdat);
ffffffffc0201750:	85a6                	mv	a1,s1
ffffffffc0201752:	07800513          	li	a0,120
ffffffffc0201756:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0201758:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc020175a:	6782                	ld	a5,0(sp)
ffffffffc020175c:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc020175e:	ff8a3603          	ld	a2,-8(s4)
            goto number;
ffffffffc0201762:	bfb5                	j	ffffffffc02016de <vprintfmt+0x156>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0201764:	000a3403          	ld	s0,0(s4)
ffffffffc0201768:	008a0713          	addi	a4,s4,8
ffffffffc020176c:	e03a                	sd	a4,0(sp)
ffffffffc020176e:	14040263          	beqz	s0,ffffffffc02018b2 <vprintfmt+0x32a>
            if (width > 0 && padc != '-') {
ffffffffc0201772:	0fb05763          	blez	s11,ffffffffc0201860 <vprintfmt+0x2d8>
ffffffffc0201776:	02d00693          	li	a3,45
ffffffffc020177a:	0cd79163          	bne	a5,a3,ffffffffc020183c <vprintfmt+0x2b4>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020177e:	00044783          	lbu	a5,0(s0)
ffffffffc0201782:	0007851b          	sext.w	a0,a5
ffffffffc0201786:	cf85                	beqz	a5,ffffffffc02017be <vprintfmt+0x236>
ffffffffc0201788:	00140a13          	addi	s4,s0,1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc020178c:	05e00413          	li	s0,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201790:	000c4563          	bltz	s8,ffffffffc020179a <vprintfmt+0x212>
ffffffffc0201794:	3c7d                	addiw	s8,s8,-1
ffffffffc0201796:	036c0263          	beq	s8,s6,ffffffffc02017ba <vprintfmt+0x232>
                    putch('?', putdat);
ffffffffc020179a:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc020179c:	0e0c8e63          	beqz	s9,ffffffffc0201898 <vprintfmt+0x310>
ffffffffc02017a0:	3781                	addiw	a5,a5,-32
ffffffffc02017a2:	0ef47b63          	bgeu	s0,a5,ffffffffc0201898 <vprintfmt+0x310>
                    putch('?', putdat);
ffffffffc02017a6:	03f00513          	li	a0,63
ffffffffc02017aa:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02017ac:	000a4783          	lbu	a5,0(s4)
ffffffffc02017b0:	3dfd                	addiw	s11,s11,-1
ffffffffc02017b2:	0a05                	addi	s4,s4,1
ffffffffc02017b4:	0007851b          	sext.w	a0,a5
ffffffffc02017b8:	ffe1                	bnez	a5,ffffffffc0201790 <vprintfmt+0x208>
            for (; width > 0; width --) {
ffffffffc02017ba:	01b05963          	blez	s11,ffffffffc02017cc <vprintfmt+0x244>
ffffffffc02017be:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
ffffffffc02017c0:	85a6                	mv	a1,s1
ffffffffc02017c2:	02000513          	li	a0,32
ffffffffc02017c6:	9902                	jalr	s2
            for (; width > 0; width --) {
ffffffffc02017c8:	fe0d9be3          	bnez	s11,ffffffffc02017be <vprintfmt+0x236>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc02017cc:	6a02                	ld	s4,0(sp)
ffffffffc02017ce:	bbd5                	j	ffffffffc02015c2 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc02017d0:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02017d2:	008a0c93          	addi	s9,s4,8
    if (lflag >= 2) {
ffffffffc02017d6:	01174463          	blt	a4,a7,ffffffffc02017de <vprintfmt+0x256>
    else if (lflag) {
ffffffffc02017da:	08088d63          	beqz	a7,ffffffffc0201874 <vprintfmt+0x2ec>
        return va_arg(*ap, long);
ffffffffc02017de:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc02017e2:	0a044d63          	bltz	s0,ffffffffc020189c <vprintfmt+0x314>
            num = getint(&ap, lflag);
ffffffffc02017e6:	8622                	mv	a2,s0
ffffffffc02017e8:	8a66                	mv	s4,s9
ffffffffc02017ea:	46a9                	li	a3,10
ffffffffc02017ec:	bdcd                	j	ffffffffc02016de <vprintfmt+0x156>
            err = va_arg(ap, int);
ffffffffc02017ee:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc02017f2:	4719                	li	a4,6
            err = va_arg(ap, int);
ffffffffc02017f4:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc02017f6:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc02017fa:	8fb5                	xor	a5,a5,a3
ffffffffc02017fc:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0201800:	02d74163          	blt	a4,a3,ffffffffc0201822 <vprintfmt+0x29a>
ffffffffc0201804:	00369793          	slli	a5,a3,0x3
ffffffffc0201808:	97de                	add	a5,a5,s7
ffffffffc020180a:	639c                	ld	a5,0(a5)
ffffffffc020180c:	cb99                	beqz	a5,ffffffffc0201822 <vprintfmt+0x29a>
                printfmt(putch, putdat, "%s", p);
ffffffffc020180e:	86be                	mv	a3,a5
ffffffffc0201810:	00001617          	auipc	a2,0x1
ffffffffc0201814:	e4860613          	addi	a2,a2,-440 # ffffffffc0202658 <best_fit_pmm_manager+0x68>
ffffffffc0201818:	85a6                	mv	a1,s1
ffffffffc020181a:	854a                	mv	a0,s2
ffffffffc020181c:	0ce000ef          	jal	ra,ffffffffc02018ea <printfmt>
ffffffffc0201820:	b34d                	j	ffffffffc02015c2 <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
ffffffffc0201822:	00001617          	auipc	a2,0x1
ffffffffc0201826:	e2660613          	addi	a2,a2,-474 # ffffffffc0202648 <best_fit_pmm_manager+0x58>
ffffffffc020182a:	85a6                	mv	a1,s1
ffffffffc020182c:	854a                	mv	a0,s2
ffffffffc020182e:	0bc000ef          	jal	ra,ffffffffc02018ea <printfmt>
ffffffffc0201832:	bb41                	j	ffffffffc02015c2 <vprintfmt+0x3a>
                p = "(null)";
ffffffffc0201834:	00001417          	auipc	s0,0x1
ffffffffc0201838:	e0c40413          	addi	s0,s0,-500 # ffffffffc0202640 <best_fit_pmm_manager+0x50>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc020183c:	85e2                	mv	a1,s8
ffffffffc020183e:	8522                	mv	a0,s0
ffffffffc0201840:	e43e                	sd	a5,8(sp)
ffffffffc0201842:	c79ff0ef          	jal	ra,ffffffffc02014ba <strnlen>
ffffffffc0201846:	40ad8dbb          	subw	s11,s11,a0
ffffffffc020184a:	01b05b63          	blez	s11,ffffffffc0201860 <vprintfmt+0x2d8>
                    putch(padc, putdat);
ffffffffc020184e:	67a2                	ld	a5,8(sp)
ffffffffc0201850:	00078a1b          	sext.w	s4,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0201854:	3dfd                	addiw	s11,s11,-1
                    putch(padc, putdat);
ffffffffc0201856:	85a6                	mv	a1,s1
ffffffffc0201858:	8552                	mv	a0,s4
ffffffffc020185a:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc020185c:	fe0d9ce3          	bnez	s11,ffffffffc0201854 <vprintfmt+0x2cc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201860:	00044783          	lbu	a5,0(s0)
ffffffffc0201864:	00140a13          	addi	s4,s0,1
ffffffffc0201868:	0007851b          	sext.w	a0,a5
ffffffffc020186c:	d3a5                	beqz	a5,ffffffffc02017cc <vprintfmt+0x244>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc020186e:	05e00413          	li	s0,94
ffffffffc0201872:	bf39                	j	ffffffffc0201790 <vprintfmt+0x208>
        return va_arg(*ap, int);
ffffffffc0201874:	000a2403          	lw	s0,0(s4)
ffffffffc0201878:	b7ad                	j	ffffffffc02017e2 <vprintfmt+0x25a>
        return va_arg(*ap, unsigned int);
ffffffffc020187a:	000a6603          	lwu	a2,0(s4)
ffffffffc020187e:	46a1                	li	a3,8
ffffffffc0201880:	8a2e                	mv	s4,a1
ffffffffc0201882:	bdb1                	j	ffffffffc02016de <vprintfmt+0x156>
ffffffffc0201884:	000a6603          	lwu	a2,0(s4)
ffffffffc0201888:	46a9                	li	a3,10
ffffffffc020188a:	8a2e                	mv	s4,a1
ffffffffc020188c:	bd89                	j	ffffffffc02016de <vprintfmt+0x156>
ffffffffc020188e:	000a6603          	lwu	a2,0(s4)
ffffffffc0201892:	46c1                	li	a3,16
ffffffffc0201894:	8a2e                	mv	s4,a1
ffffffffc0201896:	b5a1                	j	ffffffffc02016de <vprintfmt+0x156>
                    putch(ch, putdat);
ffffffffc0201898:	9902                	jalr	s2
ffffffffc020189a:	bf09                	j	ffffffffc02017ac <vprintfmt+0x224>
                putch('-', putdat);
ffffffffc020189c:	85a6                	mv	a1,s1
ffffffffc020189e:	02d00513          	li	a0,45
ffffffffc02018a2:	e03e                	sd	a5,0(sp)
ffffffffc02018a4:	9902                	jalr	s2
                num = -(long long)num;
ffffffffc02018a6:	6782                	ld	a5,0(sp)
ffffffffc02018a8:	8a66                	mv	s4,s9
ffffffffc02018aa:	40800633          	neg	a2,s0
ffffffffc02018ae:	46a9                	li	a3,10
ffffffffc02018b0:	b53d                	j	ffffffffc02016de <vprintfmt+0x156>
            if (width > 0 && padc != '-') {
ffffffffc02018b2:	03b05163          	blez	s11,ffffffffc02018d4 <vprintfmt+0x34c>
ffffffffc02018b6:	02d00693          	li	a3,45
ffffffffc02018ba:	f6d79de3          	bne	a5,a3,ffffffffc0201834 <vprintfmt+0x2ac>
                p = "(null)";
ffffffffc02018be:	00001417          	auipc	s0,0x1
ffffffffc02018c2:	d8240413          	addi	s0,s0,-638 # ffffffffc0202640 <best_fit_pmm_manager+0x50>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02018c6:	02800793          	li	a5,40
ffffffffc02018ca:	02800513          	li	a0,40
ffffffffc02018ce:	00140a13          	addi	s4,s0,1
ffffffffc02018d2:	bd6d                	j	ffffffffc020178c <vprintfmt+0x204>
ffffffffc02018d4:	00001a17          	auipc	s4,0x1
ffffffffc02018d8:	d6da0a13          	addi	s4,s4,-659 # ffffffffc0202641 <best_fit_pmm_manager+0x51>
ffffffffc02018dc:	02800513          	li	a0,40
ffffffffc02018e0:	02800793          	li	a5,40
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02018e4:	05e00413          	li	s0,94
ffffffffc02018e8:	b565                	j	ffffffffc0201790 <vprintfmt+0x208>

ffffffffc02018ea <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc02018ea:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc02018ec:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc02018f0:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc02018f2:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc02018f4:	ec06                	sd	ra,24(sp)
ffffffffc02018f6:	f83a                	sd	a4,48(sp)
ffffffffc02018f8:	fc3e                	sd	a5,56(sp)
ffffffffc02018fa:	e0c2                	sd	a6,64(sp)
ffffffffc02018fc:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc02018fe:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0201900:	c89ff0ef          	jal	ra,ffffffffc0201588 <vprintfmt>
}
ffffffffc0201904:	60e2                	ld	ra,24(sp)
ffffffffc0201906:	6161                	addi	sp,sp,80
ffffffffc0201908:	8082                	ret

ffffffffc020190a <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
ffffffffc020190a:	715d                	addi	sp,sp,-80
ffffffffc020190c:	e486                	sd	ra,72(sp)
ffffffffc020190e:	e0a6                	sd	s1,64(sp)
ffffffffc0201910:	fc4a                	sd	s2,56(sp)
ffffffffc0201912:	f84e                	sd	s3,48(sp)
ffffffffc0201914:	f452                	sd	s4,40(sp)
ffffffffc0201916:	f056                	sd	s5,32(sp)
ffffffffc0201918:	ec5a                	sd	s6,24(sp)
ffffffffc020191a:	e85e                	sd	s7,16(sp)
    if (prompt != NULL) {
ffffffffc020191c:	c901                	beqz	a0,ffffffffc020192c <readline+0x22>
ffffffffc020191e:	85aa                	mv	a1,a0
        cprintf("%s", prompt);
ffffffffc0201920:	00001517          	auipc	a0,0x1
ffffffffc0201924:	d3850513          	addi	a0,a0,-712 # ffffffffc0202658 <best_fit_pmm_manager+0x68>
ffffffffc0201928:	f8afe0ef          	jal	ra,ffffffffc02000b2 <cprintf>
readline(const char *prompt) {
ffffffffc020192c:	4481                	li	s1,0
    while (1) {
        c = getchar();
        if (c < 0) {
            return NULL;
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc020192e:	497d                	li	s2,31
            cputchar(c);
            buf[i ++] = c;
        }
        else if (c == '\b' && i > 0) {
ffffffffc0201930:	49a1                	li	s3,8
            cputchar(c);
            i --;
        }
        else if (c == '\n' || c == '\r') {
ffffffffc0201932:	4aa9                	li	s5,10
ffffffffc0201934:	4b35                	li	s6,13
            buf[i ++] = c;
ffffffffc0201936:	00004b97          	auipc	s7,0x4
ffffffffc020193a:	6f2b8b93          	addi	s7,s7,1778 # ffffffffc0206028 <buf>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc020193e:	3fe00a13          	li	s4,1022
        c = getchar();
ffffffffc0201942:	fe8fe0ef          	jal	ra,ffffffffc020012a <getchar>
        if (c < 0) {
ffffffffc0201946:	00054a63          	bltz	a0,ffffffffc020195a <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc020194a:	00a95a63          	bge	s2,a0,ffffffffc020195e <readline+0x54>
ffffffffc020194e:	029a5263          	bge	s4,s1,ffffffffc0201972 <readline+0x68>
        c = getchar();
ffffffffc0201952:	fd8fe0ef          	jal	ra,ffffffffc020012a <getchar>
        if (c < 0) {
ffffffffc0201956:	fe055ae3          	bgez	a0,ffffffffc020194a <readline+0x40>
            return NULL;
ffffffffc020195a:	4501                	li	a0,0
ffffffffc020195c:	a091                	j	ffffffffc02019a0 <readline+0x96>
        else if (c == '\b' && i > 0) {
ffffffffc020195e:	03351463          	bne	a0,s3,ffffffffc0201986 <readline+0x7c>
ffffffffc0201962:	e8a9                	bnez	s1,ffffffffc02019b4 <readline+0xaa>
        c = getchar();
ffffffffc0201964:	fc6fe0ef          	jal	ra,ffffffffc020012a <getchar>
        if (c < 0) {
ffffffffc0201968:	fe0549e3          	bltz	a0,ffffffffc020195a <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc020196c:	fea959e3          	bge	s2,a0,ffffffffc020195e <readline+0x54>
ffffffffc0201970:	4481                	li	s1,0
            cputchar(c);
ffffffffc0201972:	e42a                	sd	a0,8(sp)
ffffffffc0201974:	f74fe0ef          	jal	ra,ffffffffc02000e8 <cputchar>
            buf[i ++] = c;
ffffffffc0201978:	6522                	ld	a0,8(sp)
ffffffffc020197a:	009b87b3          	add	a5,s7,s1
ffffffffc020197e:	2485                	addiw	s1,s1,1
ffffffffc0201980:	00a78023          	sb	a0,0(a5)
ffffffffc0201984:	bf7d                	j	ffffffffc0201942 <readline+0x38>
        else if (c == '\n' || c == '\r') {
ffffffffc0201986:	01550463          	beq	a0,s5,ffffffffc020198e <readline+0x84>
ffffffffc020198a:	fb651ce3          	bne	a0,s6,ffffffffc0201942 <readline+0x38>
            cputchar(c);
ffffffffc020198e:	f5afe0ef          	jal	ra,ffffffffc02000e8 <cputchar>
            buf[i] = '\0';
ffffffffc0201992:	00004517          	auipc	a0,0x4
ffffffffc0201996:	69650513          	addi	a0,a0,1686 # ffffffffc0206028 <buf>
ffffffffc020199a:	94aa                	add	s1,s1,a0
ffffffffc020199c:	00048023          	sb	zero,0(s1)
            return buf;
        }
    }
}
ffffffffc02019a0:	60a6                	ld	ra,72(sp)
ffffffffc02019a2:	6486                	ld	s1,64(sp)
ffffffffc02019a4:	7962                	ld	s2,56(sp)
ffffffffc02019a6:	79c2                	ld	s3,48(sp)
ffffffffc02019a8:	7a22                	ld	s4,40(sp)
ffffffffc02019aa:	7a82                	ld	s5,32(sp)
ffffffffc02019ac:	6b62                	ld	s6,24(sp)
ffffffffc02019ae:	6bc2                	ld	s7,16(sp)
ffffffffc02019b0:	6161                	addi	sp,sp,80
ffffffffc02019b2:	8082                	ret
            cputchar(c);
ffffffffc02019b4:	4521                	li	a0,8
ffffffffc02019b6:	f32fe0ef          	jal	ra,ffffffffc02000e8 <cputchar>
            i --;
ffffffffc02019ba:	34fd                	addiw	s1,s1,-1
ffffffffc02019bc:	b759                	j	ffffffffc0201942 <readline+0x38>

ffffffffc02019be <sbi_console_putchar>:
uint64_t SBI_REMOTE_SFENCE_VMA_ASID = 7;
uint64_t SBI_SHUTDOWN = 8;

uint64_t sbi_call(uint64_t sbi_type, uint64_t arg0, uint64_t arg1, uint64_t arg2) {
    uint64_t ret_val;
    __asm__ volatile (
ffffffffc02019be:	4781                	li	a5,0
ffffffffc02019c0:	00004717          	auipc	a4,0x4
ffffffffc02019c4:	64873703          	ld	a4,1608(a4) # ffffffffc0206008 <SBI_CONSOLE_PUTCHAR>
ffffffffc02019c8:	88ba                	mv	a7,a4
ffffffffc02019ca:	852a                	mv	a0,a0
ffffffffc02019cc:	85be                	mv	a1,a5
ffffffffc02019ce:	863e                	mv	a2,a5
ffffffffc02019d0:	00000073          	ecall
ffffffffc02019d4:	87aa                	mv	a5,a0
    return ret_val;
}

void sbi_console_putchar(unsigned char ch) {
    sbi_call(SBI_CONSOLE_PUTCHAR, ch, 0, 0);
}
ffffffffc02019d6:	8082                	ret

ffffffffc02019d8 <sbi_set_timer>:
    __asm__ volatile (
ffffffffc02019d8:	4781                	li	a5,0
ffffffffc02019da:	00005717          	auipc	a4,0x5
ffffffffc02019de:	a8e73703          	ld	a4,-1394(a4) # ffffffffc0206468 <SBI_SET_TIMER>
ffffffffc02019e2:	88ba                	mv	a7,a4
ffffffffc02019e4:	852a                	mv	a0,a0
ffffffffc02019e6:	85be                	mv	a1,a5
ffffffffc02019e8:	863e                	mv	a2,a5
ffffffffc02019ea:	00000073          	ecall
ffffffffc02019ee:	87aa                	mv	a5,a0

void sbi_set_timer(unsigned long long stime_value) {
    sbi_call(SBI_SET_TIMER, stime_value, 0, 0);
}
ffffffffc02019f0:	8082                	ret

ffffffffc02019f2 <sbi_console_getchar>:
    __asm__ volatile (
ffffffffc02019f2:	4501                	li	a0,0
ffffffffc02019f4:	00004797          	auipc	a5,0x4
ffffffffc02019f8:	60c7b783          	ld	a5,1548(a5) # ffffffffc0206000 <SBI_CONSOLE_GETCHAR>
ffffffffc02019fc:	88be                	mv	a7,a5
ffffffffc02019fe:	852a                	mv	a0,a0
ffffffffc0201a00:	85aa                	mv	a1,a0
ffffffffc0201a02:	862a                	mv	a2,a0
ffffffffc0201a04:	00000073          	ecall
ffffffffc0201a08:	852a                	mv	a0,a0

int sbi_console_getchar(void) {
    return sbi_call(SBI_CONSOLE_GETCHAR, 0, 0, 0);
ffffffffc0201a0a:	2501                	sext.w	a0,a0
ffffffffc0201a0c:	8082                	ret
