'''
**********************************************************************************

	Basic Terminal Control Library (Supports VT100, ANSI standards,
                                        and some modern terminal support)
	Copyright 2022 Zackery Smith
	This library is released under the GPLv3 license

	This library has no dependencies other than the standard Python library

***********************************************************************************
'''

import sys
import tty
import termios
import re  # Could remove this dependency

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

TC_BG_BLK  =  HEX+"[40m"    # Background Black
TC_BG_RED  =  HEX+"[41m"    # Background Red 
TC_BG_GRN  =  HEX+"[42m"    # Background Green
TC_BG_YEL  =  HEX+"[43m"    # Background Yellow 
TC_BG_BLU  =  HEX+"[44m"    # Background Blue 
TC_BG_MAG  =  HEX+"[45m"    # Background Magenta
TC_BG_CYN  =  HEX+"[46m"    # Background Cyan 
TC_BG_WHT  =  HEX+"[47m"    # Background White 

def tc_color_id(cid, l): return HEX+("[48" if l == 0 else "[38")+";5;%sm" % (cid)
def tc_rgb(r, g, b, l): return HEX+("[48" if l == 0 else "[38")+";2;%s;%s;%sm" % (r, g, b)

####################################
#   Additional formatting (ANSI)   #
####################################

TC_BLD     =  HEX+"[1m"     # Bold
TC_DIM     =  HEX+"[2m"     # Dim
TC_SNSO    =  HEX+"[3m"     # Standout (italics)
TC_UNDR    =  HEX+"[4m"     # Underline
TC_BLNK    =  HEX+"[5m"     # Blink
TC_REV     =  HEX+"[7m"     # Reverse
TC_INV     =  HEX+"[8m"     # Invisible

#####################################

def tc_get_cols_rows():
    from fcntl import ioctl; from struct import unpack, pack
    th, tw, hp, wp = unpack('HHHH', ioctl(0, termios.TIOCGWINSZ, pack('HHHH', 0, 0, 0, 0)))
    return tw, th

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

############################
#   Common private modes   #
############################

def tc_hide_cursor(): sys.stdout.write(HEX+"[?25l")
def tc_show_cursor(): sys.stdout.write(HEX+"[?25h")

def tc_save_screen(): sys.stdout.write(HEX+"[?47h")
def tc_restore_screen(): sys.stdout.write(HEX+"?47l")

def tc_enter_alt_screen(): sys.stdout.write("%s[?1049h%s[H" % (OCT, OCT))
def tc_exit_alt_screen(): sys.stdout.write(OCT+"[?1049l")

############################

def tc_get_cursor():
    # There is a better way to do this function
    tc_echo_off()
    tc_canon_off()
    try:
        temp = ""
        sys.__stdout__.write(HEX+"[6n")
        sys.__stdout__.flush()
        while not temp.endswith('R'):
            temp = temp + sys.stdin.read(1)
        res = re.match(r".*\[(?P<y>\d*);(?P<x>\d*)R", temp)
    finally:
        tc_echo_on()
        tc_canon_on()
    if res:
        return (int(res.group("x")), int(res.group("y")))
def tc_set_cursor(x, y): sys.stdout.write(OCT+"[%s;%sH" % (y, x))
def tc_set_col(x): sys.stdout.write(OCT+"[%sG" % (x))
def tc_move_cursor(x, y): 
    if    x > 0: sys.stdout.write(OCT+"[%sC" % (x))
    elif  x < 0: sys.stdout.write(OCT+"[%sD" % (x*-1))
        
    if    y > 0: sys.stdout.write(OCT+"[%sB" % (y))
    elif  y < 0: sys.stdout.write(OCT+'[%sA' % (y*-1))

def tc_clear_screen(): sys.stdout.write(HEX+"[2J")

def tc_clear_from_top_to_cursor(): sys.stdout.write(HEX+"[1J")
def tc_clear_from_cursor_to_bottom(): sys.stdout.write(HEX+"[0J")
def tc_clear_partial(x, y, width, height):
    olpos = tc_get_cursor()

    tc_set_cursor(x, y)
    for i in range(height):
        tc_set_cursor(x, y)
        sys.stdout.write(" "*width)
        y += 1
    tc_set_cursor(olpos[0], olpos[1])

def tc_clear_entire_line(): sys.stdout.write(HEX+"[2K")
def tc_clear_line_till_cursor(): sys.stdout.write(HEX+"[1K")
def tc_clear_line_from_cursor(): sys.stdout.write(HEX+"[0K")

##################################################
#    Some extra code to handle keyboard input    #
##################################################

# Function key definitions are kind of sketchy.
# I had no good way to test them and get their code.
TC_KEY_ESCAPE       =  HEX        # esc
TC_KEY_F1           =  HEX+"OP"   # F1
TC_KEY_F2           =  HEX+"OQ"   # F2
TC_KEY_F3           =  HEX+"OR"   # F3
TC_KEY_F4           =  HEX+"OS"   # F4
TC_KEY_F5           =  HEX+"15"   # F5
TC_KEY_F6           =  HEX+"17"   # F6
TC_KEY_F7           =  HEX+"18"   # F7
TC_KEY_F8           =  HEX+"19"   # F8
TC_KEY_F9           =  HEX+"20"   # F9
TC_KEY_F10          =  HEX+"21"   # F10
TC_KEY_F11          =  HEX+"23"   # F11
TC_KEY_F12          =  HEX+"24"   # F12

TC_KEY_ARROW_UP     =  HEX+"[A"   # Arrow up
TC_KEY_ARROW_DOWN   =  HEX+"[B"   # Arrow down
TC_KEY_ARROW_LEFT   =  HEX+"[D"   # Arrow left
TC_KEY_ARROW_RIGHT  =  HEX+"[C"   # Arrow right

TC_KEY_TAB          =  "\t"       # Tab
TC_KEY_RETURN       =  "\r"       # Return
TC_KEY_ENTER        =  "\r"       # Enter
TC_KEY_BACKSPACE    =  "\x7f"     # Backspace

TC_FRMF             =  "\x0c"     # Formfeed (ctrl+l)
TC_XMIT             =  "\x04"     # XMIT (ctrl+d)
TC_ETX              =  "\x03"     # ETX (ctrl+c)
TC_KEY_INSERT       =  HEX+"[2~"  # Insert (ins)
TC_KEY_HOME         =  HEX+"[H"   # Home
TC_KEY_PAGE_UP      =  HEX+"[5~"  # Page up
TC_KEY_PAGE_DOWN    =  HEX+"[6~"  # Page down
TC_KEY_DELETE       =  HEX+"[3~"  # Delete (del)
TC_KEY_END          =  HEX+"[F"   # End


def getkey():
    fd = sys.stdin.fileno() 
    settings = termios.tcgetattr(fd)
    try:
        tty.setraw(sys.stdin.fileno())
        ch = sys.stdin.buffer.raw.read(4)
    finally:
        termios.tcsetattr(fd, termios.TCSADRAIN, settings)
            
    if ch.decode("utf-8") == TC_ETX:  # Just in case programmer forgets to add one ;)
        raise KeyboardInterrupt("Default failsafe (ctrl+c)")
    return ch


#################################
#   Quality of life functions   #
#################################

def puts(string): sys.stdout.write(string); sys.stdout.flush()
