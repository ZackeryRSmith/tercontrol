# Some spaghetti code to test Tercontol

from tercontrol import *

# Test all text color
print(f"""{TC_NRM}
{TC_BLK}BLACK {TC_RED}RED {TC_GRN}GREEN {TC_YEL}YELLOW {TC_BLU}BLUE {TC_MAG}MAGENTA {TC_CYN}CYAN {TC_WHT}WHITE

{TC_B_BLK}BRIGHT BLACK {TC_B_RED}BRIGHT RED {TC_B_GRN}BRIGHT GREEN {TC_B_YEL}BRIGHT YELLOW {TC_B_BLU}BRIGHT BLUE {TC_B_MAG}BRIGHT MAGENTA {TC_B_CYN}BRIGHT CYAN {TC_B_WHT}BRIGHT WHITE

{TC_NRM}
{TC_BG_BLK}BG BLACK {TC_BLK}{TC_BG_RED}BG RED {TC_BG_GRN}BG GREEN {TC_BG_YEL}BG YELLOW {TC_BG_BLU}BG BLUE {TC_BG_MAG}BG MAGENTA {TC_BG_CYN}BG CYAN {TC_BG_WHT}BG WHITE{TC_NRM}

""")

for i in range(255):
    print(tc_color_id(i, 0)+"%s " % (i), end="")

print(TC_NRM)
# Test all text atributes 
print(TC_BLD+"Bold"+TC_NRM)
print(TC_DIM+"Dim"+TC_NRM)
print(TC_SNSO+"Standout (Italics)"+TC_NRM)
print(TC_UNDR+"Underline"+TC_NRM)
print(TC_BLNK+"Blink"+TC_NRM)
print(TC_REV+"Reverse"+TC_NRM)
print(TC_INV+"Invisible"+TC_NRM+"<-(Invisible text)")
