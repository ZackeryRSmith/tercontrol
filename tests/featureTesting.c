#include <stdio.h>
#include "../tercontrol.h"

int main() {
	/*
	int X, Y = 0;
	tc_get_cursor(&X, &Y);
	printf("(%d, %d)\n", X, Y);
	return 0;
	*/
	
	/*
	tc_enter_alt_screen();
	printf("Hello from line 1\nHello from line 2\nHello from line 3\nHello from line 4\n");
	tc_clear_partial(0, 0, 3, 3);
	*/
	
	//printf("%sHello in cyan!%s\n", tc_color_id(69,1), TC_NRM);

	int cols, rows;
	tc_get_cols_rows(&cols, &rows);
	printf("(%d, %d)\n", cols, rows);
}
