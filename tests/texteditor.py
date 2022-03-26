# Very simple text editor 

# TODO:
# A better way to manage threads
# Basic writing and saving file support

from tercontrol import *
from threading import Thread
import sys

def movement():
    while True:
        key = getkey()
        sys.stdout.flush()
        if key == bytes(TC_KEY_ARROW_UP, "utf-8"):
            tc_move_cursor(0, -1)
            sys.stdout.flush()
        elif key == bytes(TC_KEY_ARROW_DOWN, "utf-8"):
            tc_move_cursor(0, 1)
            sys.stdout.flush()
        elif key == bytes(TC_KEY_ARROW_LEFT, "utf-8"):
            tc_move_cursor(-1, 0)
            sys.stdout.flush()
        elif key == bytes(TC_KEY_ARROW_RIGHT, "utf-8"):
            tc_move_cursor(1, 0)
            sys.stdout.flush()


def main():
    tc_enter_alt_screen()
    sys.stdout.flush()
    thd = Thread(target=movement)
    thd.start()
    
    # After while loop is broken this code runs
    thd.join()
    tc_exit_alt_screen()
    sys.stdout.flush()
main()
