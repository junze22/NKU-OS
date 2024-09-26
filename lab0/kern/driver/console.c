// 在QEMU上模拟的时候，唯一的“设备”是虚拟的控制台，通过OpenSBI接口使用。
// 简单封装了OpenSBI的字符读写接口，向上提供给输入输出库。


#include <sbi.h> //定义了操作系统与底层硬件之间的接口函数。
#include <console.h>

/* kbd_intr - try to feed input characters from keyboard */
void kbd_intr(void) {}  //这个函数的目的是处理来自键盘的中断

/* serial_intr - try to feed input characters from serial port */
void serial_intr(void) {} //应该是用来处理来自串行端口的中断

/* cons_init - initializes the console devices */
void cons_init(void) {}  //用于初始化控制台设备

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) { sbi_console_putchar((unsigned char)c); }

//用于将单个字符打印到控制台设备。
//这里使用了sbi_console_putchar函数，
//这表明它将字符输出到了基于SBI的控制台上。


/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int cons_getc(void) {
    int c = 0;
    c = sbi_console_getchar();
    return c;
}

// 这个函数用于从控制台读取下一个输入字符，
// 如果没有字符等待，则返回0。它调用sbi_console_getchar函数来获取字符，
// 这表明它从基于SBI的控制台读取输入。