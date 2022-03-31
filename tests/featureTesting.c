#include <stdio.h>
#include "../tercontrol.h"

int main() {
	int X, Y = 0;
	tc_get_cursor(&X, &Y);
	printf("(%d, %d)\n", X, Y);
	return 0;
}
