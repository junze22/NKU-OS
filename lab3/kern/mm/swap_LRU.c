#include <defs.h>
#include <riscv.h>
#include <stdio.h>
#include <string.h>
#include <swap.h>
#include <swap_LRU.h>
#include <list.h>

// 当前LRU链表指针
extern list_entry_t *curr_ptr;
list_entry_t lru_list_head;

/*
 * (1) _lru_init_mm: Initialize the LRU list and set the private memory manager pointer.
 */
// 初始化LRU链表，设置当前指针和 sm_priv 指针
static int
_lru_init_mm(struct mm_struct* mm)
{
    // 初始化LRU链表头
    list_init(&lru_list_head);
    
    // 设置当前指针指向LRU链表头，即最近访问的页面
    curr_ptr = &lru_list_head;
    
    // 将mm->sm_priv指针指向LRU链表头，用于后续操作
    mm->sm_priv = &lru_list_head;

    return 0;
}

/*
 * (2) _lru_map_swappable: 将页面添加到LRU链表，并标记为最近访问
 * 参数：mm - 内存描述符，addr - 页面的地址，page - 页面对象，swap_in - 是否是交换进的页面
 */
static int
_lru_map_swappable(struct mm_struct* mm, uintptr_t addr, struct Page* page, int swap_in)
{
    // 获取当前进程的LRU链表头
    list_entry_t* head = (list_entry_t*)mm->sm_priv;
    // 获取页面的链表条目
    list_entry_t* entry = &(page->pra_page_link);

    // 确保条目和当前指针有效
    assert(entry != NULL && curr_ptr != NULL);

    // 如果页面是可交换的，将其添加到链表头部（最近访问）
    list_add_after(head, entry);

    // 标记页面已访问
    page->visited = 1;

    // 调试输出当前指针的地址
    cprintf("curr_ptr %p\n", curr_ptr);

    return 0;
}

/*
 * (3) _lru_swap_out_victim: 选择需要交换出去的牺牲页（最久未访问的页面）
 * 参数：mm - 内存描述符，ptr_page - 输出参数，返回交换出去的页面指针，in_tick - 是否是时间片到期
 */
static int
_lru_swap_out_victim(struct mm_struct* mm, struct Page** ptr_page, int in_tick)
{
    // 获取当前进程的LRU链表头
    list_entry_t* head = (list_entry_t*)mm->sm_priv;

    // 确保LRU链表头有效
    assert(head != NULL);

    // 选择牺牲页：LRU链表的最后一个元素即为最久未访问的页面
    list_entry_t* victim_entry = list_prev(&lru_list_head);  // 获取链表的倒数第一个元素

    // 获取牺牲页的页面对象
    struct Page* victim_page = le2page(victim_entry, pra_page_link);

    // 移除牺牲页的条目
    list_del(victim_entry);

    // 设置返回的页面指针为牺牲页
    *ptr_page = victim_page;

    // 打印交换出页面的调试信息
    cprintf("swap_out: page %p, vaddr %lx\n", victim_page, victim_page->pra_vaddr);

    return 0;
}


/*
 * (4) _lru_check_swap: Check the status of page swapping (testing purpose).
 */
static int
_lru_check_swap(void) {
#ifdef ucore_test
    int score = 0, totalscore = 5;
    cprintf("%d\n", &score);  // 输出当前分数地址
    ++score; 
    cprintf("评分：%d/%d 分\n", score, totalscore);  // 输出当前分数

    *(unsigned char *)0x3000 = 0x0c; 
    assert(pgfault_num==4);  // 验证页错误数为4
    cprintf("操作 0x3000，期望页错误数：%d\n", pgfault_num); 

    *(unsigned char *)0x1000 = 0x0a; 
    assert(pgfault_num==4);  // 验证页错误数为4
    cprintf("操作 0x1000，期望页错误数：%d\n", pgfault_num); 

    *(unsigned char *)0x4000 = 0x0d; 
    assert(pgfault_num==4);  // 验证页错误数为4
    cprintf("操作 0x4000，期望页错误数：%d\n", pgfault_num); 

    *(unsigned char *)0x2000 = 0x0b; 
    assert(pgfault_num==4);  // 验证页错误数为4
    cprintf("操作 0x2000，期望页错误数：%d\n", pgfault_num); 

    *(unsigned char *)0x5000 = 0x0e; 
    assert(pgfault_num==5);  // 验证页错误数为5
    cprintf("操作 0x5000，期望页错误数：%d\n", pgfault_num); 

    *(unsigned char *)0x2000 = 0x0b; 
    assert(pgfault_num==5);  // 验证页错误数为5
    cprintf("操作 0x2000，期望页错误数：%d\n", pgfault_num); 

    ++score; 
    cprintf("评分：%d/%d 分\n", score, totalscore);  // 输出当前分数

    *(unsigned char *)0x1000 = 0x0a; 
    assert(pgfault_num==5);  // 验证页错误数为5
    cprintf("操作 0x1000，期望页错误数：%d\n", pgfault_num); 

    *(unsigned char *)0x2000 = 0x0b; 
    assert(pgfault_num==5);  // 验证页错误数为5
    cprintf("操作 0x2000，期望页错误数：%d\n", pgfault_num); 

    *(unsigned char *)0x3000 = 0x0c; 
    assert(pgfault_num==5);  // 验证页错误数为5
    cprintf("操作 0x3000，期望页错误数：%d\n", pgfault_num); 

    ++score; 
    cprintf("评分：%d/%d 分\n", score, totalscore);  // 输出当前分数

    *(unsigned char *)0x4000 = 0x0d; 
    assert(pgfault_num==5);  // 验证页错误数为5
    cprintf("操作 0x4000，期望页错误数：%d\n", pgfault_num); 

    *(unsigned char *)0x5000 = 0x0e; 
    assert(pgfault_num==5);  // 验证页错误数为5
    cprintf("操作 0x5000，期望页错误数：%d\n", pgfault_num); 

    assert((unsigned char *)0x1000 == 0x0a); 
    cprintf("验证 0x1000 内容是否为 0x0a: %d\n", (unsigned char *)0x1000 == 0x0a); 

    *(unsigned char *)0x1000 = 0x0a; 
    assert(pgfault_num==6);  // 验证页错误数为6
    cprintf("操作 0x1000，期望页错误数：%d\n", pgfault_num); 

    ++score; 
    cprintf("评分：%d/%d 分\n", score, totalscore);  // 输出当前分数
#else
    *(unsigned char *)0x3000 = 0x0c; 
    assert(pgfault_num==4);  // 验证页错误数为4
    cprintf("操作 0x3000，期望页错误数：%d\n", pgfault_num); 

    *(unsigned char *)0x1000 = 0x0a; 
    assert(pgfault_num==4);  // 验证页错误数为4
    cprintf("操作 0x1000，期望页错误数：%d\n", pgfault_num); 

    *(unsigned char *)0x4000 = 0x0d; 
    assert(pgfault_num==4);  // 验证页错误数为4
    cprintf("操作 0x4000，期望页错误数：%d\n", pgfault_num); 

    *(unsigned char *)0x2000 = 0x0b; 
    assert(pgfault_num==4);  // 验证页错误数为4
    cprintf("操作 0x2000，期望页错误数：%d\n", pgfault_num); 

    *(unsigned char *)0x5000 = 0x0e; 
    assert(pgfault_num==5);  // 验证页错误数为5
    cprintf("操作 0x5000，期望页错误数：%d\n", pgfault_num); 

    *(unsigned char *)0x2000 = 0x0b; 
    assert(pgfault_num==5);  // 验证页错误数为5
    cprintf("操作 0x2000，期望页错误数：%d\n", pgfault_num); 


    *(unsigned char *)0x2000 = 0x0b; 
    assert(pgfault_num==5);  // 验证页错误数为5
    cprintf("操作 0x2000，期望页错误数：%d\n", pgfault_num); 

    *(unsigned char *)0x3000 = 0x0c; 
    assert(pgfault_num==5);  // 验证页错误数为5
    cprintf("操作 0x3000，期望页错误数：%d\n", pgfault_num); 

    *(unsigned char *)0x4000 = 0x0d; 
    assert(pgfault_num==5);  // 验证页错误数为5
    cprintf("操作 0x4000，期望页错误数：%d\n", pgfault_num); 

    *(unsigned char *)0x5000 = 0x0e; 
    assert(pgfault_num==5);  // 验证页错误数为5
    cprintf("操作 0x5000，期望页错误数：%d\n", pgfault_num); 


    *(unsigned char *)0x1000 = 0x0a; 
    assert(pgfault_num==6);  // 验证页错误数为6
    cprintf("操作 0x1000，期望页错误数：%d\n", pgfault_num); 
#endif
    return 0;
}


/*
 * (5) _lru_init: Initialize any global data structures for the LRU algorithm.
 */
static int
_lru_init(void)
{
    return 0;
}

/*
 * (6) _lru_set_unswappable: Set a page as unswappable.
 */
static int
_lru_set_unswappable(struct mm_struct* mm, uintptr_t addr)
{
    return 0;
}
static int
_lru_tick_event(struct mm_struct* mm)
{
    return 0;
}

/*
 * Define the swap manager for the LRU page replacement algorithm.
 */
struct swap_manager swap_manager_lru =
{
    .name = "LRU swap manager",
    .init = &_lru_init,
    .init_mm = &_lru_init_mm,
    .tick_event = &_lru_tick_event,
    .map_swappable = &_lru_map_swappable,
    .set_unswappable = &_lru_set_unswappable,
    .swap_out_victim = &_lru_swap_out_victim,
    .check_swap = &_lru_check_swap,
};
