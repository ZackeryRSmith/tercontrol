# Place function | Place a char at a X Y position

from tercontrol import *

# Does not set cursor back to orignal place
# This is up to the developer to do. Why?
# Well after all chars are placed you may bring back the cursor.
# This is not something we can really optimise from within the code
# so we trust the developer to do it.
def tc_char_place(x, y, char):
    tc_set_cursor(x, y)
    puts(char)
