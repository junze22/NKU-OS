//需要调用中断机制的初始化函数。
#include <clock.h>
#include <console.h>
#include <defs.h>
#include <intr.h>
#include <kdebug.h>
#include <kmonitor.h>
#include <pmm.h>
#include <riscv.h>
#include <stdio.h>
#include <string.h>
#include <trap.h>

int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);

int kern_init(void) {
    extern char edata[], end[];
    memset(edata, 0, end - edata);

    cons_init();  // init the console初始化控制台

    const char *message = "(THU.CST) os is loading ...\n";
    cprintf("%s\n\n", message);

    print_kerninfo();//打印内核信息

    // grade_backtrace();
    //trap.h的函数，初始化中断
    idt_init();  // init interrupt descriptor table
                 // 初始化中断描述符表（IDT）


    // rdtime in mbare mode crashes
    //clock.h的函数，初始化时钟中断
    clock_init();  // init clock interrupt
    //初始化时钟中断

    
    //intr.h的函数，使能中断
    intr_enable();  // enable irq interrupt
    //调用intr_enable函数启用中断请求（IRQ）
    while (1)
        ;
}

void __attribute__((noinline))
grade_backtrace2(unsigned long long arg0, unsigned long long arg1, unsigned long long arg2, unsigned long long arg3) {
    mon_backtrace(0, NULL, NULL);
}

void __attribute__((noinline)) grade_backtrace1(int arg0, int arg1) {
    grade_backtrace2(arg0, (unsigned long long)&arg0, arg1, (unsigned long long)&arg1);
}

void __attribute__((noinline)) grade_backtrace0(int arg0, int arg1, int arg2) {
    grade_backtrace1(arg0, arg2);
}

void grade_backtrace(void) { grade_backtrace0(0, (unsigned long long)kern_init, 0xffff0000); }

static void lab1_print_cur_status(void) {
    static int round = 0;
    round++;
}



