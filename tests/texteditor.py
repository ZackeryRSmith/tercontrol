# Very simple text editor 
# Ideology from: http://www.finseth.com/craft/#preface.q

# TODO:
# A better way to manage threads
# Basic writing and saving file support

from tercontrol import *
from threading import Thread
import sys

"""
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
"""


def get_line(prompt="", buffer="", length=100):
    if length < 2: return  # Safety check
    cptr = buffer  # cptr - Capture
    
    puts(prompt)
    while True:
        key = getkey()
        if str(key.decode("utf-8")).isprintable():
            cptr += key.decode("utf-8")
            puts(key.decode("utf-8"))
        
        elif key == bytes(TC_KEY_ARROW_LEFT, "utf-8"):
            tc_move_cursor(-1, 0)
            sys.stdout.flush()
        
        elif key == bytes(TC_KEY_ARROW_RIGHT, "utf-8"):
            tc_move_cursor(1, 0)
            sys.stdout.flush()

        elif key == bytes(TC_KEY_BACKSPACE, "utf-8"):
            if cptr < buffer + len(buffer): pass
            cptr = cptr[:-1]
            puts("\b \b")
        
        elif key == bytes(TC_KEY_ENTER, "utf-8"):
            return cptr

def main():
    print("\n"+get_line("Enter your name: "))

main()
