#include <stdio.h>
#include "../tercontrol.h"

int main() {
	/*
	tc_set_cursor(5, 5);
	puts("a");
	tc_set_cursor(5, 5);
	puts(" ");
	*/

	/*
	int X, Y = 0;
	tc_get_cursor(&X, &Y);
	printf("(%d, %d)\n", X, Y);
	return 0;
	*/
	
	/*
	tc_enter_alt_screen();
	puts("Line 1");
	puts("Line 2");
	puts("Line 3");
	puts("Line 4");
	tc_clear_partial(1, 1, 0, 0);
	*/

	//printf("%sHello in cyan!%s\n", tc_color_id(69,1), TC_NRM);

	/*
	int cols, rows;
	tc_get_cols_rows(&cols, &rows);
	printf("(%d, %d)\n", cols, rows);
	*/

	printf("%c\n", tc_getch());
}
