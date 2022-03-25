'''
**********************************************************************************

	Basic Terminal Control Library (Supports VT100, and ANSI standards)
	Copyright 2022 Zackery Smith
	This library is released under the GPLv3 license

	This library has no dependencies other than the standard Python library

***********************************************************************************
'''

import os
import sys
import tty
import termios

HEX = "\x1B"
OCT = "\033"

TC_NRM     =  HEX+"[0m"     # Normalize Color 
TC_BLK     =  HEX+"[1;30m"  # Black
TC_RED     =  HEX+"[1;31m"  # Red 
TC_GRN     =  HEX+"[1;32m"  # Green 
TC_YEL     =  HEX+"[1;33m"  # Yellow 
TC_BLU     =  HEX+"[1;34m"  # Blue
TC_MAG     =  HEX+"[1;35m"  # Magenta
TC_CYN     =  HEX+"[1;36m"  # Cyan 
TC_WHT     =  HEX+"[1;37m"  # White 

TC_B_NRM   =  HEX+"[0m"     # Normalize Bright Color 
TC_B_BLK   =  HEX+"[0;30m"  # Bright Black
TC_B_RED   =  HEX+"[0;31m"  # Bright Red 
TC_B_GRN   =  HEX+"[0;32m"  # Bright Green 
TC_B_YEL   =  HEX+"[0;33m"  # Bright Yellow 
TC_B_BLU   =  HEX+"[0;34m"  # Bright Blue 
TC_B_MAG   =  HEX+"[0;35m"  # Bright Magenta 
TC_B_CYN   =  HEX+"[0;36m"  # Bright Cyan 
TC_B_WHT   =  HEX+"[0;37m"  # Bright White 

#TC_BG_NRM  =  HEX+"[40m"    # Normalize Background Color
TC_BG_BLK  =  HEX+"[40m"    # Background Black
TC_BG_RED  =  HEX+"[41m"    # Background Red 
TC_BG_GRN  =  HEX+"[42m"    # Background Green
TC_BG_YEL  =  HEX+"[43m"    # Background Yellow 
TC_BG_BLU  =  HEX+"[44m"    # Background Blue 
TC_BG_MAG  =  HEX+"[45m"    # Background Magenta
TC_BG_CYN  =  HEX+"[46m"    # Background Cyan 
TC_BG_WHT  =  HEX+"[47m"    # Background White 

####################################
#   Additional formatting (ANSI)   #
####################################

TC_BLD     =  HEX+"[1m"  # Bold
TC_DIM     =  HEX+"[2m"  # Dim
TC_SNSO    =  HEX+"[3m"  # Standout (italics)
TC_UNDR    =  HEX+"[4m"  # Underline
TC_BLNK    =  HEX+"[5m"  # Blink
TC_REV     =  HEX+"[7m"  # Reverse
TC_INV     =  HEX+"[8m"  # Invisible

#####################################

def tc_clear_screen(): sys.stdout.write(HEX+"[2J")

def tc_clear_entire_line(): sys.stdout.write(HEX+"[2K")
def tc_clear_line_till_cursor(): sys.stdout.write(HEX+"[1K")
def tc_clear_line_from_cursor(): sys.stdout.write(HEX+"[0K")

def tc_set_cursor(X, Y): sys.stdout.write(OCT+"[%s;%sH" % (Y, X))

def tc_move_cursor(X, Y): 
    if    X > 0: sys.stdout.write(OCT+"[%sC" % (X))
    elif  X < 0: sys.stdout.write(OCT+"[%sD" % (X*-1))
        
    if    Y > 0: sys.stdout.write(OCT+"[%sB" % (Y))
    elif  Y < 0: sys.stdout.write(OCT+'[%sA' % (Y*-1))

def tc_enter_alt_screen(): sys.stdout.write("%s[?1049h%s[H" % (OCT, OCT))
def tc_exit_alt_screen(): sys.stdout.write(OCT+"[?1049l")

def tc_get_cols_rows():
    # For now we use os.get_term_size().
    # I plan on implementing this on my own tomorrow
    return os.get_terminal_size()

def tc_echo_off():
    fd = sys.stdin.fileno()
    settings = termios.tcgetattr(fd)
    settings[3] &= ~termios.ECHO
    termios.tcsetattr(fd, termios.TCSANOW, settings)

def tc_echo_on():
    fd = sys.stdin.fileno()
    settings = termios.tcgetattr(fd)
    settings[3] |= termios.ECHO
    termios.tcsetattr(fd, termios.TCSANOW, settings)

def tc_canon_off():
    fd = sys.stdin.fileno()
    settings = termios.tcgetattr(fd)
    settings[3] &= ~termios.ICANON
    termios.tcsetattr(fd, termios.TCSANOW, settings)

def tc_canon_on():
    fd = sys.stdin.fileno()
    settings = termios.tcgetattr(fd)
    settings[3] |= termios.ICANON
    termios.tcsetattr(fd, termios.TCSANOW, settings)


##################################################
#    Some extra code to handle keyboard input    #
##################################################

# Function key definitions are kind of sketchy.
# I had no good way to test them and get their code.
TC_KEY_ESCAPE       =  HEX
TC_KEY_F1           =  HEX+"OP"
TC_KEY_F2           =  HEX+"OQ"
TC_KEY_F3           =  HEX+"OR"
TC_KEY_F4           =  HEX+"OS"
TC_KEY_F5           =  HEX+"15"
TC_KEY_F6           =  HEX+"17"
TC_KEY_F7           =  HEX+"18"
TC_KEY_F8           =  HEX+"19"
TC_KEY_F9           =  HEX+"20"
TC_KEY_F10          =  HEX+"21"
TC_KEY_F11          =  HEX+"23"
TC_KEY_F12          =  HEX+"24"

TC_KEY_ARROW_UP     =  HEX+"[A"
TC_KEY_ARROW_DOWN   =  HEX+"[B"
TC_KEY_ARROW_LEFT   =  HEX+"[D"
TC_KEY_ARROW_RIGHT  =  HEX+"[C"

TC_KEY_TAB          =  "\t"
TC_KEY_RETURN       =  "\r"
TC_KEY_ENTER        =  "\r"

TC_KEY_INSERT       =  HEX+"[2~"
TC_KEY_HOME         =  HEX+"[H"
TC_KEY_PAGE_UP      =  HEX+"[5~"
TC_KEY_PAGE_DOWN    =  HEX+"[6~"
TC_KEY_DELETE       =  HEX+"[3~"
TC_KEY_END          =  HEX+"[F"


def getch():  # Naming conflicts can occur if python's "getch" module is imported!
    fd = sys.stdin.fileno() 
    settings = termios.tcgetattr(fd)
    try:
        tty.setraw(sys.stdin.fileno())
        ch = sys.stdin.buffer.raw.read(4)
    finally:
        termios.tcsetattr(fd, termios.TCSADRAIN, settings)
            
    if ch.decode("utf-8") == TC_KEY_END:  # Just in case programmer forgets to add one ;)
        raise KeyboardInterrupt("Default failsafe (ctrl+c)")
    return ch
