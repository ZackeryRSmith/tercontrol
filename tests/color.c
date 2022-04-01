#include <stdio.h>
#include "../tercontrol.h"

int main() {
	for (int i = 0; i < 255; i++) {
		printf("%s%d ", tc_color_id(i, 0), i);
	}
	puts(TC_NRM);

	return 0;
}
