from tercontrol import *
from time import sleep, perf_counter  # Benchmarking

## Benchmark (in miliseconds)
# tc_color_id                      | ≈ 2.6589996195980348e-06
# tc_rgb                           | ≈ 3.259000095567899e-06

# tc_clear_screen                  | ≈ 3.0840001272736117e-06
# tc_clear_from_top_to_cursor      | ≈ 2.782999672490405e-06
# tc_clear_from_cursor_to_bottom   | ≈ 2.4830001166264992e-06
# tc_clear_entire_line             | ≈ 2.534000032028416e-06
# tc_clear_line_till_cursor        | ≈ 2.5630001800891478e-06
# tc_clear_line_from_cursor        | ≈ 2.5260001166316215e-06

# tc_get_cols_rows                 | ≈ 0.00041888400028256

# tc_echo_off                      | ≈ 0.0004584640000757645
# tc_echo_on                       | ≈ 0.0004171800001131487
# tc_canon_off                     | ≈ 0.0003886880003847182
# tc_canon_on                      | ≈ 0.0005370880003283673
 
# tc_hide_cursor                   | ≈ 0.0005102089999127202
# tc_show_cursor                   | ≈ 0.00042330199994466966

# tc_save_screen                   | ≈ 0.00041300800012322725
# tc_restore_screen                | ≈ 0.00048048299959191354

# tc_enter_alt_screen              | ≈ 0.0006002119998811395
# tc_exit_alt_screen               | ≈ 2.1759997252956964e-06

# tc_get_cursor                    | ≈ 0.019601429001340875
# tc_set_cursor                    | ≈ 4.285000159143237e-06
# tc_set_col                       | ≈ 3.867000032187207e-06 
# tc_move_cursor                   | ≈ 1.0459998520673253e-06

# getkey                           | ≈ 0.017221252000126697

def main():
    start_time = perf_counter()
    #tc_color_id(1, 0)
    #tc_rgb(20, 10, 0, 0)

    #tc_clear_screen()
    #tc_clear_from_top_to_cursor()
    #tc_clear_from_cursor_to_bottom()
    #tc_clear_entire_line()
    #tc_clear_line_till_cursor()
    #tc_clear_line_from_cursor()

    #tc_get_cols_rows()

    #tc_echo_off()         
    #tc_echo_on()        
    #tc_canon_off()      
    #tc_canon_on()       
                      
    #tc_hide_cursor()    
    #tc_show_cursor()     
                      
    #tc_save_screen()      
    #tc_restore_screen()   
                      
    #tc_enter_alt_screen()
    #tc_exit_alt_screen() 

    #tc_get_cursor()
    #tc_set_cursor(0, 0)
    #tc_set_col(0)
    #tc_move_cursor(0, 0)

    #getkey()
    end_time = perf_counter()
    print("It took %s milisecond(s) to complete task" % (end_time-start_time))
