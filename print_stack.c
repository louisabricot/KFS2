
#include <stdint.h>
#include <stdlib.h>




int print_stack() {

	uint8_t *stack;
	uint16_t *screen;
	char color = 0x0f;
	uint16_t display;
	int index = -1;
	screen = 0xb8010;
	stack = 0x0;

	while(index++ < 200){
//		uint8_t temp = *stack;	
		*screen =  (color << 8) | (*stack);
		screen++;
		stack++;
	}
	return 0;
}
