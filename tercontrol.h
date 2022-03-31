/**********************************************************************************

	Basic Terminal Control Library 
	Copyright 2022 Zackery Smith
	This library is released under the GPLv3 license

	This library has no dependencies other than the standard C runtime library

***********************************************************************************/
#ifndef TC_H
#define TC_H
#endif

#include <stdio.h>
#include <sys/ioctl.h>
#include <termios.h>
#include <unistd.h>
#include <stdint.h>
#include <pthread.h>
#include <string.h>
#include <stdlib.h>

#ifndef NULL
#define NULL '\0'
#endif

#define TC_NRM  "\x1B[0m"      /* Normalize Color */
#define TC_RED  "\x1B[1;31m"   /* Red */
#define TC_GRN  "\x1B[1;32m"   /* Green */
#define TC_YEL  "\x1B[1;33m"   /* Yellow */
#define TC_BLU  "\x1B[1;34m"   /* Blue */
#define TC_MAG  "\x1B[1;35m"   /* Magenta */
#define TC_CYN  "\x1B[1;36m"   /* Cyan */
#define TC_WHT  "\x1B[1;37m"   /* White */

#define TC_B_NRM  "\x1B[0m"    /* Normalize Bright Color */
#define TC_B_RED  "\x1B[0;31m" /* Bright Red */
#define TC_B_GRN  "\x1B[0;32m" /* Bright Green */
#define TC_B_YEL  "\x1B[0;33m" /* Bright Yellow */
#define TC_B_BLU  "\x1B[0;34m" /* Bright Blue */
#define TC_B_MAG  "\x1B[0;35m" /* Bright Magenta */
#define TC_B_CYN  "\x1B[0;36m" /* Bright Cyan */
#define TC_B_WHT  "\x1B[0;37m" /* Bright White */

#define TC_BG_NRM "\x1B[40m"   /* Normalize Background Color */
#define TC_BG_RED "\x1B[41m"   /* Background Red */
#define TC_BG_GRN "\x1B[42m"   /* Background Green */
#define TC_BG_YEL "\x1B[43m"   /* Background Yellow */
#define TC_BG_BLU "\x1B[44m"   /* Background Blue */
#define TC_BG_MAG "\x1B[45m"   /* Background Magenta*/
#define TC_BG_CYN "\x1B[46m"   /* Background Cyan */
#define TC_BG_WHT "\x1B[47m"   /* Background White */

//def tc_color_id(cid, l): return HEX+("[48" if l == 0 else "[38")+";5;%sm" % (cid)
//def tc_rgb(r, g, b, l): return HEX+("[48" if l == 0 else "[38")+";2;%s;%s;%sm" % (r, g, b)

//////////////////////////////////////
//   Additional formatting (ANSI)   //
//////////////////////////////////////
    
#define TC_BLD  "\x1B[1m"       /* Bold */
#define TC_DIM  "\x1B[2m"       /* Dim */
#define TC_ITAL "\x1B[3m"       /* Standout (italics) */
#define TC_UNDR "\x1B[4m"       /* Underline */
#define TC_BLNK "\x1B[5m"       /* Blink */
#define TC_REV  "\x1B[7m"       /* Reverse */
#define TC_INV  "\x1B[8m"       /* Invisible */

//////////////////////////////////////

#define tc_clear_screen() puts("\x1B[2J")
#define tc_clear_from_top_to_cursor() puts("\x1B[1J")
#define tc_clear_from_cursor_to_bottom() puts("\x1B[0J")

/*
def tc_clear_partial(x, y, width, height):
	olpos = tc_get_cursor()

  tc_set_cursor(x, y)
  for i in range(height):
  	tc_set_cursor(x, y)
    sys.stdout.write(" "*width)
    y += 1
  	tc_set_cursor(olpos[0], olpos[1])
*/

#define tc_clear_entire_line() puts("\x1B[2K")
#define tc_clear_line_till_cursor() puts("\x1B[1K")
#define tc_clear_line_from_cursor() puts("\x1B[0K")

#define tc_set_cursor(X, Y) printf("\033[%d;%dH", Y, X)
void tc_move_cursor(int X, int Y) {
	if(X > 0) { 
		printf("\033[%dC", X);
	} else if(X < 0) {
		printf("\033[%dD", (X*-1));
	}

	if(Y > 0) { 
		printf("\033[%dB", Y);
	} else if(Y < 0) {
		printf("\033[%dA", (Y*-1));
	}
	
}

void tc_get_cols_rows(int *cols, int *rows);

//////////////////////////////
//   Common private modes   //
//////////////////////////////

#define tc_hide_cursor() puts("\033[?25l")
#define tc_show_cursor() puts("\033[?25h")

#define tc_save_screen() puts("\033[?47h")
#define tc_restore_screen() puts("\033?47l")

#define tc_enter_alt_screen() puts("\033[?1049h\033[H")
#define tc_exit_alt_screen() puts("\033[?1049l")

//////////////////////////////

void tc_echo_off();
void tc_echo_on();

void tc_get_cols_rows(int *cols, int *rows){
	struct winsize size;
	ioctl(1, TIOCGWINSZ, &size);
	*cols = size.ws_col;
	*rows = size.ws_row;
}

void tc_echo_off(){
	struct termios term;
	tcgetattr(1, &term);
	term.c_lflag &= ~ECHO;
	tcsetattr(1, TCSANOW, &term);
}

void tc_echo_on(){
	struct termios term;
	tcgetattr(1, &term);
	term.c_lflag |= ECHO;
	tcsetattr(1, TCSANOW, &term);
}

void tc_canon_on(){
	struct termios term;
	tcgetattr(1, &term);
	term.c_lflag |= ICANON;
	tcsetattr(1, TCSANOW, &term);
}

void tc_canon_off(){
	struct termios term;
	tcgetattr(1, &term);
	term.c_lflag &= ~ICANON;
	tcsetattr(1, TCSANOW, &term);
}
