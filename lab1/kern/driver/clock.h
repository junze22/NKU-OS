//通过OpenSBI的接口, 可以读取当前时间(rdtime), 
//设置时钟事件(sbi_set_timer)，是时钟中断必需的硬件支持。

#ifndef __KERN_DRIVER_CLOCK_H__
#define __KERN_DRIVER_CLOCK_H__

#include <defs.h>

extern volatile size_t ticks;

void clock_init(void);
void clock_set_next_event(void);

#endif /* !__KERN_DRIVER_CLOCK_H__ */

