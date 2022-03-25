from tercontrol import *

# Clear screen
tc_clear_screen()

# Get cursor position
cpos = tc_get_cursor()

# Set cursor position
tc_set_cursor(0, 0)

# Move cursor
tc_move_cursor(5, 1)

print("Hello, World!")
