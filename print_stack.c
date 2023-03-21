#include <stdint.h>
#include <stdlib.h>



uint8_t return_ascii(uint8_t nbr)
{
	if (nbr < 10)
		return (nbr + '0');
	else
		return (nbr - 10 + 'A');
}


int print_stack() {

	uint8_t *stack;
	uint16_t *screen;
	char color = 0x0f;
	uint16_t display;
	int index = -1;
	screen = (uint16_t *)0xb8000;
	stack = 0x0;

	while(index++ < 0xffff) {
		uint8_t temp = *stack;

		if (temp >= 32 && temp <= 126)
		{
			*screen =  (color << 8) | temp;
			screen++;
		}
		else{
			*screen =  (color << 8) | (return_ascii(*stack / 16));
			screen++;
			*screen =  (color << 8) | (return_ascii(*stack % 16));
			screen++;
		}
		*screen =  (color << 8) | 32;
		screen++;

		stack++;
	}
	return 0;
}
