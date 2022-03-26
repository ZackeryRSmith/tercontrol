from tercontrol import *

tc_enter_alt_screen()
sys.stdout.flush()
print("Hello this is line 1\nA Second line!\nA third line!?\nA four line :O!!")
tc_clear_partial(1, 0, 3, 5)
