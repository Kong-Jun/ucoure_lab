#include "buddy_pmm.h"
#include "pmm.h"

void 
create_buddy_allacator(struct buddy_allocator *allocator, struct Page *base, size_t size)
{
	assert(allocator != NULL);
	assert(base != NULL);
	assert(size != 0);
	
	size = ROUNDUP(size, 2);
	allocator->ba_size  = sizeof(sizeof(struct buddy_allocator) + sizeof(uint8_t) * (2 * size - 1));
	allocator->mem_size = size;
	allocator->base     = base;

	size_t node_size = size, i;
	for (i = 0; i < 2 * size -1; ++i) {
		if (is_power_of2(i + 1))
			node_size /= 2;
		// allocator->nodes[i] = node_size;
	}
}

void 
buddy_init()
{
	memset(&buddy_allocator_indicator, 0, sizeof(buddy_allocator_indicator))	
}

void 
buddy_init_memmap(struct Page *base, size_t n)
{
	assert(base != NULL);
	assert(n != 0);	
	uintptr_t allocator_vaddress;


	assert(PageReserved(p));
	p->flags = p->property = 0;
	SetPageProperty(p);
	set_page_ref(p, 0);

	/* 第一个buddy_allocator放置在Page数组之后（高地址） */
	if (buddy_allocator_indicator.ba_num == 0) {
		allocator_vaddress = uintptr_t(pages + npage);
	}
	else {
		struct buddy_allocator *p;
		p = (struct buddy_allocator *)buddy_allocator_indicator.ba_address[buddy_allocator_indicator->ba_num - 1];
		allocator_vaddress = (uintptr_t)p + p->ba_size;
	}
	create_buddy_allacator(struct buddy_allocator*(allocator_vaddress), base, n);
	buddy_allocator_indicator.ba_address[buddy_allocator_indicator.ba_num++] = allocator_vaddress;
}
				

struct Page* 
buddy_alloc_pages(size_t n)
{
	if (n == 0)
		return NULL;
	if ((n != 1) && !is_power_of2(n))
		n = ROUNDUP(n, 2);
}

void 
buddy_free_pages(struct Page *base, size_t n);

size_t buddy_nr_free_pages(void);                    

void buddy_check(void);                              

int
is_power_of2(size_t n)
{
	return test_bit(&n, 0);
}

const struct pmm_manager buddy_manager = {
	.name = "buddy_manager",
	.init = buddy_init,
    .init_memmap = buddy_init_memmap,
    .alloc_pages = buddy_alloc_pages,
    .free_pages = buddy_free_pages,
    .nr_free_pages = buddy_nr_free_pages,
    .check = buddy_check,
};

