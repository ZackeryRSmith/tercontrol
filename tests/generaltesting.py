from tercontrol import *

# Silent input
tc_echo_off()
usrinput = input("Hidden input: ")
tc_echo_on()
print("\n"+usrinput)

# Clear line
print("Hello", end="")
tc_clear_entire_line()
