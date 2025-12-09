#define ADDR_SWITCHES   ((volatile unsigned int*)0x10000000)
#define ADDR_LEDS       ((volatile unsigned int*)0x10000004)
#define ADDR_BUTTONS    ((volatile unsigned int*)0x10000008)
#define ADDR_7SEG       ((volatile unsigned int*)0x1000000c)
#define ADDR_7SEG_DIGIT ((volatile unsigned int*)0x10000010)

// seg = 1000000 or 0x40  // 0
// seg = 1111001 or 0x79 // 1
// seg = 0100100 // 2
// seg = 0110000 // 3
// seg = 0011001 // 4
// seg = 0010010 // 5
// seg = 0000010 // 6
// seg = 1111000 // 7
// seg = 0000000 // 8
// seg = 0010000 // 9


void _start() {

    int target_led_index = 8; 
    int current_led_index = 0;
    unsigned int game_speed_delay;
    int button_pressed_flag;
    
    unsigned int flags; 
    volatile unsigned int i_delay; 
    int i_blink; 

    *ADDR_BUTTONS = 0; 
    *ADDR_LEDS = 0;  
    *ADDR_7SEG = 0;
    *ADDR_7SEG_DIGIT = 0;
    
    while (1) { 
        game_speed_delay = 70000 - ((*ADDR_SWITCHES & 0xFFFF)); 
        *ADDR_BUTTONS = 0; 
        button_pressed_flag = 0;
        for (current_led_index = 0; current_led_index < 16; current_led_index++) {
            *ADDR_LEDS = (1 << current_led_index);
            for (i_delay = 0; i_delay < game_speed_delay; i_delay++) {
            }
            
            flags = *ADDR_BUTTONS; 
            if (flags != 0) { 
                *ADDR_BUTTONS = 0; 
                button_pressed_flag = 1; 
                break;
            }
        } 
        
    
        if (button_pressed_flag == 1) 
        {
            if (current_led_index == target_led_index) {
                *ADDR_LEDS = 0xFFFF;
                *ADDR_7SEG = 0x40;
                *ADDR_7SEG_DIGIT = 0;
                for (i_delay = 0; i_delay < 300000; i_delay++) {}
                *ADDR_LEDS = 0x0000;
                *ADDR_7SEG = 0x79;
                *ADDR_7SEG_DIGIT = 0;
                for (i_delay = 0; i_delay < 300000; i_delay++) {}
                *ADDR_LEDS = 0xFFFF;
                *ADDR_7SEG = 0x24;
                *ADDR_7SEG_DIGIT = 0;
                for (i_delay = 0; i_delay < 300000; i_delay++) {}
            } else {
                *ADDR_LEDS = 0x0000;
                for (i_delay = 0; i_delay < 1000000; i_delay++) {}
            }
        }
        else 
        {
            *ADDR_LEDS = 0x0000;
            for (i_delay = 0; i_delay < 1000000; i_delay++) {}
        }
    }
}