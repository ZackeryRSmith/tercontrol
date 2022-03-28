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
from terminfo import *

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
    th, tw, hp, wp = unpack("HHHH", ioctl(0, termios.TIOCGWINSZ, pack("HHHH", 0, 0, 0, 0)))
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
        while not temp.endswith("R"):
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
    elif  y < 0: sys.stdout.write(OCT+"[%sA" % (y*-1))

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

def puts(*values, end=""): 
    for val in values:
        sys.stdout.write(val)
    sys.stdout.write(end)
    sys.stdout.flush()

# A very crappy way to check for terminal type
term = Term(os.environ["TERM"])
term.load()

# Map terminfo db to a more human usable dict
tc_terminfo_db = {
    # Boolean names
    "auto_left_margin":term.db["booleans"][0],
    "auto_right_margin":term.db["booleans"][1],
    "no_esc_ctlc":term.db["booleans"][2],
    "ceol_standout_glitch":term.db["booleans"][3],
    "eat_newline_glitch":term.db["booleans"][4],
    "erase_overstrike":term.db["booleans"][5],
    "generic_type":term.db["booleans"][6],
    "hard_copy":term.db["booleans"][7],
    "has_meta_key":term.db["booleans"][8],
    "has_status_line":term.db["booleans"][9],
    "insert_null_glitch":term.db["booleans"][10],
    "memory_above":term.db["booleans"][11],
    "memory_below":term.db["booleans"][12],
    "move_insert_mode":term.db["booleans"][13],
    "move_standout_mode":term.db["booleans"][14],
    "over_strike":term.db["booleans"][15],
    "status_line_esc_ok":term.db["booleans"][16],
    "dest_tabs_magic_smso":term.db["booleans"][17],
    "tilde_glitch":term.db["booleans"][18],
    "transparent_underline":term.db["booleans"][19],
    "xon_xoff":term.db["booleans"][20],
    "needs_xon_xoff":term.db["booleans"][21],
    "prtr_silent":term.db["booleans"][22],
    "hard_cursor":term.db["booleans"][23],
    "non_rev_rmcup":term.db["booleans"][24],
    "no_pad_char":term.db["booleans"][25],
    "non_dest_scroll_region":term.db["booleans"][26],
    "can_change":term.db["booleans"][27],
    "back_color_erase":term.db["booleans"][28],
    "hue_lightness_saturation":term.db["booleans"][29],
    "col_addr_glitch":term.db["booleans"][30],
    "cr_cancels_micro_mode":term.db["booleans"][31],
    "has_print_wheel":term.db["booleans"][32],
    "row_addr_glitch":term.db["booleans"][33],
    "semi_auto_right_margin":term.db["booleans"][34],
    "cpi_changes_res":term.db["booleans"][35],
    "lpi_changes_res":term.db["booleans"][26],
    
    # Number names
    "columns":term.db["numbers"][0],
    "init_tabs":term.db["numbers"][1],
    "lines":term.db["numbers"][2],
    "lines_of_memory":term.db["numbers"][3],
    "magic_cookie_glitch":term.db["numbers"][4],
    "padding_baud_rate":term.db["numbers"][5],
    "virtual_terminal":term.db["numbers"][6],
    "width_status_line":term.db["numbers"][7],
    "num_labels":term.db["numbers"][8],
    "label_height":term.db["numbers"][9],
    "label_width":term.db["numbers"][10],
    "max_attributes":term.db["numbers"][11],
    "maximum_windows":term.db["numbers"][12],
    "max_colors":term.db["numbers"][13],
    "max_pairs":term.db["numbers"][14],
    
    "no_color_video":term.db["string_offsets"][0],
    "buffer_capacity":term.db["string_offsets"][1],
    "dot_vert_spacing":term.db["string_offsets"][2],
    "dot_horz_spacing":term.db["string_offsets"][3],
    "max_micro_address":term.db["string_offsets"][4],
    "max_micro_jump":term.db["string_offsets"][5],
    "micro_col_size":term.db["string_offsets"][6],
    "micro_line_size":term.db["string_offsets"][7],
    "number_of_pins":term.db["string_offsets"][8],
    "output_res_char":term.db["string_offsets"][9],
    "output_res_line":term.db["string_offsets"][10],
    "output_res_horz_inch":term.db["string_offsets"][11],
    "output_res_vert_inch":term.db["string_offsets"][12],
    "print_rate":term.db["string_offsets"][13],
    "wide_char_size":term.db["string_offsets"][14],
    "buttons":term.db["string_offsets"][15],
    "bit_image_entwining":term.db["string_offsets"][16],
    "bit_image_type":term.db["string_offsets"][17],
    
    # String names
    "back_tab":term.db["strings"][0],
    "bell":term.db["strings"][1],
    "carriage_return":term.db["strings"][2],
    "change_scroll_region":term.db["strings"][3],
    "clear_all_tabs":term.db["strings"][4],
    "clear_screen":term.db["strings"][5],
    "clr_eol":term.db["strings"][6],
    "clr_eos":term.db["strings"][7],
    "column_address":term.db["strings"][8],
    "command_character":term.db["strings"][9],
    "cursor_address":term.db["strings"][10],
    "cursor_down":term.db["strings"][11],
    "cursor_home":term.db["strings"][12],
    "cursor_invisible":term.db["strings"][13],
    "cursor_left":term.db["strings"][14],
    "cursor_mem_address":term.db["strings"][15],
    "cursor_normal":term.db["strings"][16],
    "cursor_right":term.db["strings"][17],
    "cursor_to_ll":term.db["strings"][18],
    "cursor_up":term.db["strings"][19],
    "cursor_visible":term.db["strings"][20],
    "delete_character":term.db["strings"][21],
    "delete_line":term.db["strings"][22],
    "dis_status_line":term.db["strings"][23],
    "down_half_line":term.db["strings"][24],
    "enter_alt_charset_mode":term.db["strings"][25],
    "enter_blink_mode":term.db["strings"][26],
    "enter_bold_mode":term.db["strings"][27],
    "enter_ca_mode":term.db["strings"][28],
    "enter_delete_mode":term.db["strings"][29],
    "enter_dim_mode":term.db["strings"][30],
    "enter_insert_mode":term.db["strings"][31],
    "enter_secure_mode":term.db["strings"][32],
    "enter_protected_mode":term.db["strings"][33],
    "enter_reverse_mode":term.db["strings"][34],
    "enter_standout_mode":term.db["strings"][35],
    "enter_underline_mode":term.db["strings"][36],
    "erase_chars":term.db["strings"][37],
    "exit_alt_charset_mode":term.db["strings"][38],
    "exit_attribute_mode":term.db["strings"][39],
    "exit_ca_mode":term.db["strings"][40],
    "exit_delete_mode":term.db["strings"][41],
    "exit_insert_mode":term.db["strings"][42],
    "exit_standout_mode":term.db["strings"][43],
    "exit_underline_mode":term.db["strings"][44],
    "flash_screen":term.db["strings"][45],
    "form_feed":term.db["strings"][46],
    "from_status_line":term.db["strings"][47],
    "init_1string":term.db["strings"][48],
    "init_2string":term.db["strings"][49],
    "init_3string":term.db["strings"][50],
    "init_file":term.db["strings"][51],
    "insert_character":term.db["strings"][52],
    "insert_line":term.db["strings"][53],
    "insert_padding":term.db["strings"][54],
    "key_backspace":term.db["strings"][55],
    "key_catab":term.db["strings"][56],
    "key_clear":term.db["strings"][57],
    "key_ctab":term.db["strings"][58],
    "key_dc":term.db["strings"][59],
    "key_dl":term.db["strings"][60],
    "key_down":term.db["strings"][61],
    "key_eic":term.db["strings"][62],
    "key_eol":term.db["strings"][63],
    "key_eos":term.db["strings"][64],
    "key_f0":term.db["strings"][65],
    "key_f1":term.db["strings"][66],
    "key_f10":term.db["strings"][67],
    "key_f2":term.db["strings"][68],
    "key_f3":term.db["strings"][69],
    "key_f4":term.db["strings"][70],
    "key_f5":term.db["strings"][71],
    "key_f6":term.db["strings"][72],
    "key_f7":term.db["strings"][73],
    "key_f8":term.db["strings"][74],
    "key_f9":term.db["strings"][75],
    "key_home":term.db["strings"][76],
    "key_ic":term.db["strings"][77],
    "key_il":term.db["strings"][78],
    "key_left":term.db["strings"][79],
    "key_ll":term.db["strings"][80],
    "key_npage":term.db["strings"][81],
    "key_ppage":term.db["strings"][82],
    "key_right":term.db["strings"][83],
    "key_sf":term.db["strings"][84],
    "key_sr":term.db["strings"][85],
    "key_stab":term.db["strings"][86],
    "key_up":term.db["strings"][87],
    "keypad_local":term.db["strings"][88],
    "keypad_xmit":term.db["strings"][89],
    "lab_f0":term.db["strings"][90],
    "lab_f1":term.db["strings"][91],
    "lab_f10":term.db["strings"][92],
    "lab_f2":term.db["strings"][93],
    "lab_f3":term.db["strings"][94],
    "lab_f4":term.db["strings"][95],
    "lab_f5":term.db["strings"][96],
    "lab_f6":term.db["strings"][97],
    "lab_f7":term.db["strings"][98],
    "lab_f8":term.db["strings"][99],
    "lab_f9":term.db["strings"][100],
    "meta_off":term.db["strings"][101],
    "meta_on":term.db["strings"][102],
    "newline":term.db["strings"][103],
    "pad_char":term.db["strings"][104],
    "parm_dch":term.db["strings"][105],
    "parm_delete_line":term.db["strings"][106],
    "parm_down_cursor":term.db["strings"][107],
    "parm_ich":term.db["strings"][108],
    "parm_index":term.db["strings"][109],
    "parm_insert_line":term.db["strings"][110],
    "parm_left_cursor":term.db["strings"][111],
    "parm_right_cursor":term.db["strings"][112],
    "parm_rindex":term.db["strings"][113],
    "parm_up_cursor":term.db["strings"][114],
    "pkey_key":term.db["strings"][115],
    "pkey_local":term.db["strings"][116],
    "pkey_xmit":term.db["strings"][117],
    "print_screen":term.db["strings"][118],
    "prtr_off":term.db["strings"][119],
    "prtr_on":term.db["strings"][120],
    "repeat_char":term.db["strings"][121],
    "reset_1string":term.db["strings"][122],
    "reset_2string":term.db["strings"][123],
    "reset_3string":term.db["strings"][124],
    "reset_file":term.db["strings"][125],
    "restore_cursor":term.db["strings"][126],
    "row_address":term.db["strings"][127],
    "save_cursor":term.db["strings"][128],
    "scroll_forward":term.db["strings"][129],
    "scroll_reverse":term.db["strings"][130],
    "set_attributes":term.db["strings"][131],
    "set_tab":term.db["strings"][132],
    "set_window":term.db["strings"][133],
    "tab":term.db["strings"][134],
    "to_status_line":term.db["strings"][135],
    "underline_char":term.db["strings"][136],
    "up_half_line":term.db["strings"][137],
    "init_prog":term.db["strings"][138],
    "key_a1":term.db["strings"][139],
    "key_a3":term.db["strings"][140],
    "key_b2":term.db["strings"][141],
    "key_c1":term.db["strings"][142],
    "key_c3":term.db["strings"][143],
    "prtr_non":term.db["strings"][144],
    "char_padding":term.db["strings"][145],
    "acs_chars":term.db["strings"][146],
    "plab_norm":term.db["strings"][147],
    "key_btab":term.db["strings"][148],
    "enter_xon_mode":term.db["strings"][149],
    "exit_xon_mode":term.db["strings"][150],
    "enter_am_mode":term.db["strings"][151],
    "exit_am_mode":term.db["strings"][152],
    "xon_character":term.db["strings"][153],
    "xoff_character":term.db["strings"][154],
    "ena_acs":term.db["strings"][155],
    "label_on":term.db["strings"][156],
    "label_off":term.db["strings"][157],
    "key_beg":term.db["strings"][158],
    "key_cancel":term.db["strings"][159],
    "key_close":term.db["strings"][160],
    "key_command":term.db["strings"][161],
    "key_copy":term.db["strings"][162],
    "key_create":term.db["strings"][163],
    "key_end":term.db["strings"][164],
    "key_enter":term.db["strings"][165],
    "key_exit":term.db["strings"][166],
    "key_find":term.db["strings"][167],
    "key_help":term.db["strings"][168],
    "key_mark":term.db["strings"][169],
    "key_message":term.db["strings"][170],
    "key_move":term.db["strings"][171],
    "key_next":term.db["strings"][172],
    "key_open":term.db["strings"][173],
    "key_options":term.db["strings"][174],
    "key_previous":term.db["strings"][175],
    "key_print":term.db["strings"][176],
    "key_redo":term.db["strings"][178],
    "key_reference":term.db["strings"][179],
    "key_refresh":term.db["strings"][180],
    "key_replace":term.db["strings"][181],
    "key_restart":term.db["strings"][182],
    "key_resume":term.db["strings"][183],
    "key_save":term.db["strings"][184],
    "key_suspend":term.db["strings"][185],
    "key_undo":term.db["strings"][186],
    "key_sbeg":term.db["strings"][187],
    "key_scancel":term.db["strings"][188],
    "key_scommand":term.db["strings"][189],
    "key_scopy":term.db["strings"][190],
    "key_screate":term.db["strings"][191],
    "key_sdc":term.db["strings"][192],
    "key_sdl":term.db["strings"][193],
    "key_select":term.db["strings"][194],
    "key_send":term.db["strings"][195],
    "key_seol":term.db["strings"][196],
    "key_sexit":term.db["strings"][197],
    "key_sfind":term.db["strings"][198],
    "key_shelp":term.db["strings"][199],
    "key_shome":term.db["strings"][200],
    "key_sic":term.db["strings"][201],
    "key_sleft":term.db["strings"][202],
    "key_smessage":term.db["strings"][203],
    "key_smove":term.db["strings"][204],
    "key_snext":term.db["strings"][205],
    "key_soptions":term.db["strings"][206],
    "key_sprevious":term.db["strings"][207],
    "key_sprint":term.db["strings"][208],
    "key_sredo":term.db["strings"][209],
    "key_sreplace":term.db["strings"][210],
    "key_sright":term.db["strings"][211],
    "key_srsume":term.db["strings"][212],
    "key_ssave":term.db["strings"][213],
    "key_ssuspend":term.db["strings"][214],
    "key_sundo":term.db["strings"][215],
    "req_for_input":term.db["strings"][216],
    "key_f11":term.db["strings"][217],
    "key_f12":term.db["strings"][218],
    "key_f13":term.db["strings"][219],
    "key_f14":term.db["strings"][220],
    "key_f15":term.db["strings"][221],
    "key_f16":term.db["strings"][222],
    "key_f17":term.db["strings"][223],
    "key_f18":term.db["strings"][224],
    "key_f19":term.db["strings"][225],
    "key_f20":term.db["strings"][226],
    "key_f21":term.db["strings"][227],
    "key_f22":term.db["strings"][228],
    "key_f23":term.db["strings"][229],
    "key_f24":term.db["strings"][230],
    "key_f25":term.db["strings"][231],
    "key_f26":term.db["strings"][232],
    "key_f27":term.db["strings"][233],
    "key_f28":term.db["strings"][234],
    "key_f29":term.db["strings"][235],
    "key_f30":term.db["strings"][236],
    "key_f31":term.db["strings"][237],
    "key_f32":term.db["strings"][238],
    "key_f33":term.db["strings"][239],
    "key_f34":term.db["strings"][240],
    "key_f35":term.db["strings"][241],
    "key_f36":term.db["strings"][242],
    "key_f37":term.db["strings"][243],
    "key_f38":term.db["strings"][244],
    "key_f39":term.db["strings"][245],
    "key_f40":term.db["strings"][246],
    "key_f41":term.db["strings"][247],
    "key_f42":term.db["strings"][248],
    "key_f43":term.db["strings"][249],
    "key_f44":term.db["strings"][250],
    "key_f45":term.db["strings"][251],
    "key_f46":term.db["strings"][252],
    "key_f47":term.db["strings"][253],
    "key_f48":term.db["strings"][254],
    "key_f49":term.db["strings"][255],
    "key_f50":term.db["strings"][256],
    "key_f51":term.db["strings"][257],
    "key_f52":term.db["strings"][258],
    "key_f53":term.db["strings"][259],
    "key_f54":term.db["strings"][260],
    "key_f55":term.db["strings"][261],
    "key_f56":term.db["strings"][262],
    "key_f57":term.db["strings"][263],
    "key_f58":term.db["strings"][264],
    "key_f59":term.db["strings"][265],
    "key_f60":term.db["strings"][266],
    "key_f61":term.db["strings"][267],
    "key_f62":term.db["strings"][268],
    "key_f63":term.db["strings"][269],
    "clr_bol":term.db["strings"][270],
    "clear_margins":term.db["strings"][271],
    "set_left_margin":term.db["strings"][272],
    "set_right_margin":term.db["strings"][273],
    "label_format":term.db["strings"][274],
    "set_clock":term.db["strings"][275],
    "display_clock":term.db["strings"][276],
    "remove_clock":term.db["strings"][277],
    "create_window":term.db["strings"][278],
    "goto_window":term.db["strings"][279],
    "hangup":term.db["strings"][280],
    "dial_phone":term.db["strings"][281],
    "quick_dial":term.db["strings"][282],
    "tone":term.db["strings"][283],
    "pulse":term.db["strings"][284],
    "flash_hook":term.db["strings"][285],
    "fixed_pause":term.db["strings"][286],
    "wait_tone":term.db["strings"][287],
    "user0":term.db["strings"][288],
    "user1":term.db["strings"][289],
    "user2":term.db["strings"][290],
    "user3":term.db["strings"][291],
    "user4":term.db["strings"][292],
    "user5":term.db["strings"][293],
    "user6":term.db["strings"][294],
    "user7":term.db["strings"][295],
    "user8":term.db["strings"][296],
    "user9":term.db["strings"][297],
    "orig_pair":term.db["strings"][298],
    "orig_colors":term.db["strings"][299],
    "initialize_color":term.db["strings"][300],
    "initialize_pair":term.db["strings"][301],
    "set_color_pair":term.db["strings"][302],
    "set_foreground":term.db["strings"][303],
    "set_background":term.db["strings"][304],
    "change_char_pitch":term.db["strings"][305],
    "change_line_pitch":term.db["strings"][306],
    "change_res_horz":term.db["strings"][307],
    "change_res_vert":term.db["strings"][308],
    "define_char":term.db["strings"][309],
    "enter_doublewide_mode":term.db["strings"][310],
    "enter_draft_quality":term.db["strings"][311],
    "enter_italics_mode":term.db["strings"][312],
    "enter_leftward_mode":term.db["strings"][313],
    "enter_micro_mode":term.db["strings"][314],
    "enter_near_letter_quality":term.db["strings"][315],
    "enter_normal_quality":term.db["strings"][316],
    "enter_shadow_mode":term.db["strings"][317],
    "enter_subscript_mode":term.db["strings"][318],
    "enter_superscript_mode":term.db["strings"][319],
    "enter_upward_mode":term.db["strings"][320],
    "exit_doublewide_mode":term.db["strings"][321],
    "exit_italics_mode":term.db["strings"][322],
    "exit_leftward_mode":term.db["strings"][323],
    "exit_micro_mode":term.db["strings"][324],
    "exit_shadow_mode":term.db["strings"][325],
    "exit_subscript_mode":term.db["strings"][326],
    "exit_superscript_mode":term.db["strings"][327],
    "exit_upward_mode":term.db["strings"][328],
    "micro_column_address":term.db["strings"][329],
    "micro_down":term.db["strings"][330],
    "micro_left":term.db["strings"][331],
    "micro_right":term.db["strings"][332],
    "micro_row_address":term.db["strings"][333],
    "micro_up":term.db["strings"][334],
    "order_of_pins":term.db["strings"][335],
    "parm_down_micro":term.db["strings"][336],
    "parm_left_micro":term.db["strings"][337],
    "parm_right_micro":term.db["strings"][338],
    "parm_up_micro":term.db["strings"][339],
    "select_char_set":term.db["strings"][340],
    "set_bottom_margin":term.db["strings"][341],
    "set_bottom_margin_parm":term.db["strings"][342],
    "set_left_margin_parm":term.db["strings"][343],
    "set_right_margin_parm":term.db["strings"][344],
    "set_top_margin":term.db["strings"][345],
    "set_top_margin_parm":term.db["strings"][346],
    "start_bit_image":term.db["strings"][347],
    "start_char_set_def":term.db["strings"][348],
    "stop_bit_image":term.db["strings"][349],
    "stop_char_set_def":term.db["strings"][350],
    "subscript_characters":term.db["strings"][351],
    "superscript_characters":term.db["strings"][352],
    "these_cause_cr":term.db["strings"][353],
    "zero_motion":term.db["strings"][354],
    "char_set_names":term.db["strings"][355],
    "key_mouse":term.db["strings"][356],
    "mouse_info":term.db["strings"][357],
    "req_mouse_pos":term.db["strings"][358],
    "get_mouse":term.db["strings"][359],
    "set_a_foreground":term.db["strings"][360],
    "set_a_background":term.db["strings"][361],
    "pkey_plab":term.db["strings"][362],
    "device_type":term.db["strings"][363],
    "code_set_init":term.db["strings"][364],
    "set0_des_seq":term.db["strings"][365],
    "set1_des_seq":term.db["strings"][366],
    "set2_des_seq":term.db["strings"][367],
    "set3_des_seq":term.db["strings"][368],
    "set_lr_margin":term.db["strings"][369],
    "set_tb_margin":term.db["strings"][370],
    "bit_image_repeat":term.db["strings"][371],
    "bit_image_newline":term.db["strings"][372],
    "bit_image_carriage_return":term.db["strings"][373],
    "color_names":term.db["strings"][374],
    "define_bit_image_region":term.db["strings"][375],
    "end_bit_image_region":term.db["strings"][376],
    "set_color_band":term.db["strings"][377],
    "set_page_length":term.db["strings"][378],
    "display_pc_char":term.db["strings"][379],
    "enter_pc_charset_mode":term.db["strings"][380],
    "exit_pc_charset_mode":term.db["strings"][381],
    "enter_scancode_mode":term.db["strings"][382],
    "exit_scancode_mode":term.db["strings"][383],
    "pc_term_options":term.db["strings"][384],
    "scancode_escape":term.db["strings"][385],
    "alt_scancode_esc":term.db["strings"][386],
    "enter_horizontal_hl_mode":term.db["strings"][387],
    "enter_left_hl_mode":term.db["strings"][388],
    "enter_low_hl_mode":term.db["strings"][389],
    "enter_right_hl_mode":term.db["strings"][390],
    "enter_top_hl_mode":term.db["strings"][391],
    "enter_vertical_hl_mode":term.db["strings"][392],
    "set_a_attributes":term.db["strings"][393],
    "set_pglen_inch":term.db["strings"][394],
}

