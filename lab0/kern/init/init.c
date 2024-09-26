//C语言编写的内核入口点。
//主要包含kern_init()函数，从kern/entry.S跳转过来完成其他初始化工作。
//程序真正的入口点


#include <stdio.h>
#include <string.h>
#include <sbi.h>
int kern_init(void) __attribute__((noreturn));
//__attribute__((noreturn)) 是一个GCC扩展，
// 它告诉编译器这个函数不会返回到调用点。
// 这意味着函数 kern_init 在执行完毕后不会返回，
// 可能是因为它会无限循环或者直接通过系统调用退出程序。


int kern_init(void) {
    extern char edata[], end[];
    memset(edata, 0, end - edata);

    const char *message = "(THU.CST) os is loading ...\n";
    cprintf("%s\n\n", message);
   while (1)
        ;
}
