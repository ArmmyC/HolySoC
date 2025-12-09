#define ADDR_SWITCHES   ((volatile unsigned int*)0x10000000)
#define ADDR_LEDS       ((volatile unsigned int*)0x10000004)
#define ADDR_BUTTONS    ((volatile unsigned int*)0x10000008)
#define ADDR_7SEG       ((volatile unsigned int*)0x1000000c)
#define ADDR_7SEG_DIGIT ((volatile unsigned int*)0x10000010)

void _start() {
    volatile unsigned int i_delay; 

    // เคลียร์ค่าเริ่มต้น
    *ADDR_BUTTONS = 0; 
    *ADDR_LEDS = 0;  
    *ADDR_7SEG = 0x7F; // ดับ 7-Seg (Active Low)
    *ADDR_7SEG_DIGIT = 0xF; // ดับ Digit (Active Low)

    // หน่วงเวลา (ช่วงนี้ไฟดับ)
    for (i_delay = 0; i_delay < 300000; i_delay++) {}

    // เปิดไฟ LED
    *ADDR_LEDS = 0xFFFF; 
    *ADDR_7SEG = 0; // ดับ 7-Seg (Active Low)
    *ADDR_7SEG_DIGIT = 0; // ดับ Digit (Active Low)

    // --- [FIX] ---
    // ต้องมี Loop เพื่อ "แช่" โปรแกรมไว้ตรงนี้
    // ไม่งั้นมันจะวิ่งกลับไป Reset
    while(1) {
        // CPU จะวนอยู่ตรงนี้ตลอดไป ทำให้ไฟ LED ติดค้าง
    }
}