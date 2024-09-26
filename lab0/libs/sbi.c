// libs/sbi.c

// 封装OpenSBI接口为函数。
// 如果想在C语言里使用OpenSBI提供的接口，需要使用内联汇编。
// 这个头文件把OpenSBI的内联汇编调用封装为函数。

// OpenSBI作为运行在M态的软件（或者说固件）, 
// 提供了一些接口供我们编写内核的时候使用。
// 我们可以通过ecall指令(environment call)调用OpenSBI。
// 通过寄存器传递给OpenSBI一个”调用编号“，如果编号在 0-8 之间，
// 则由OpenSBI进行处理，否则交由我们自己的中断处理程序处理（暂未实现）。
// 有时OpenSBI调用需要像函数调用一样传递参数，
// 这里传递参数的方式也和函数调用一样，
// 按照riscv的函数调用约定(calling convention)把参数放到寄存器里。


#include <sbi.h>
#include <defs.h>


uint64_t SBI_SET_TIMER = 0;
uint64_t SBI_CONSOLE_PUTCHAR = 1; 
uint64_t SBI_CONSOLE_GETCHAR = 2;
uint64_t SBI_CLEAR_IPI = 3;
uint64_t SBI_SEND_IPI = 4;
uint64_t SBI_REMOTE_FENCE_I = 5;
uint64_t SBI_REMOTE_SFENCE_VMA = 6;
uint64_t SBI_REMOTE_SFENCE_VMA_ASID = 7;
uint64_t SBI_SHUTDOWN = 8;

uint64_t sbi_call(uint64_t sbi_type, uint64_t arg0, uint64_t arg1, uint64_t arg2) {
    uint64_t ret_val;
    __asm__ volatile (
        "mv x17, %[sbi_type]\n"
        "mv x10, %[arg0]\n"
        "mv x11, %[arg1]\n"
        "mv x12, %[arg2]\n"
        "ecall\n"
        "mv %[ret_val], x10"
        : [ret_val] "=r" (ret_val)
        : [sbi_type] "r" (sbi_type), [arg0] "r" (arg0), [arg1] "r" (arg1), [arg2] "r" (arg2)
        : "memory"
    );
    return ret_val;
}

void sbi_console_putchar(unsigned char ch) {
    sbi_call(SBI_CONSOLE_PUTCHAR, ch, 0, 0);
}

void sbi_set_timer(unsigned long long stime_value) {
    sbi_call(SBI_SET_TIMER, stime_value, 0, 0);
}
