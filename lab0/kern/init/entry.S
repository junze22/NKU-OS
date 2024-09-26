###0x80200000 why?

###在QEMU模拟的riscv计算机里，我们使用QEMU自带的bootloader: 
###OpenSBI固件，那么在 Qemu 开始执行任何指令之前，
###首先两个文件将被加载到 Qemu 的物理内存中：
###即作为 bootloader 的 OpenSBI.bin 
###被加载到物理内存以物理地址 0x80000000 开头的区域上，
###同时内核镜像 os.bin 被加载到以物理地址 0x80200000 开头的区域上


#OpenSBI启动之后将要跳转到的一段汇编代码。
#在这里进行内核栈的分配，然后转入C语言编写的内核初始化函数。

###整个内核的入口

#include <mmu.h>
#include <memlayout.h>

    .section .text,"ax",%progbits
    .globl kern_entry
kern_entry:
    la sp, bootstacktop

    tail kern_init

.section .data
    # .align 2^12
    .align PGSHIFT
    .global bootstack
bootstack:
    .space KSTACKSIZE
    .global bootstacktop
bootstacktop: