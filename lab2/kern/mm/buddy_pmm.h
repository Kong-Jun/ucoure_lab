#ifndef BUDDY_PMM_H
#define BUDDY_PMM_H
#include "memlayout.h"
#include "pmm.h"
#include <assert.h>
#include <stdio.h>
#include <pmm.h>
#include <list.h>
#include <atomic.h> // for test_bit()


/* 记录buddy_allocator的起始位置和个数*/
struct {
	uint8_t ba_num; // 分配器总数
	uintptr_t ba_address[10];	//分配器起始地址
} buddy_allocator_indicator;

struct buddy_allocator {
	struct Page *base,	// 该分配器的控制的物理内存其起始Page结构
	size_t mem_size,	// 该分配器中的物理页总数
	size_t ba_size, //这个结构的大小（字节数）
	uint8_t nodes[0];	//使用顺序存储建立二叉树, 每个节点代表2的N次方
};

void buddy_init();
void buddy_init_memmap(struct Page *base, size_t n); 
struct Page* buddy_alloc_pages(size_t n);            
void buddy_free_pages(struct Page *base, size_t n);  
size_t buddy_nr_free_pages(void);                    
void buddy_check(void);                              
int is_power_of2(size_t);
extern const struct pmm_manager *pmm_manager;

#endif


