/*
Writer: uthen
Blog: www.10logic.com
Example:
https://www.olimex.com/Products/MSP430/Booster/MOD-LED8x8/resources/MOD-LED8x8-SCHEMATIC-REV-D.pdf
http://www.sweeting.org/mark/blog/2011/11/27/arduino-74hc595-shift-register-and-a-7-segment-led-display
https://www.sparkfun.com/products/733
http://www.protostack.com/blog/2010/05/introduction-to-74hc595-shift-register-controlling-16-leds/
http://embedded-lab.com/?p=2478
http://embedded-lab.com/blog/?p=2661

*/ 

#define PIN_LATCH       8        // ST_CP         IC PIN12
#define PIN_DATA        9        // DATA or DS    IC PIN14
#define PIN_CLOCK       11       // SH_CP or SRCLK IC PIN11

#define DS_low()       digitalWrite(PIN_DATA, LOW)
#define DS_high()      digitalWrite(PIN_DATA, HIGH)
#define SH_CP_low()    digitalWrite(PIN_CLOCK, LOW)
#define SH_CP_high()   digitalWrite(PIN_CLOCK, HIGH)
#define ST_CP_low()    digitalWrite(PIN_LATCH, LOW)
#define ST_CP_high()   digitalWrite(PIN_LATCH, HIGH)

//char ledBuff[8]={0x3c,0x3c,0x3c,0x3c,0xff,0x7e,0x3c,0x18};  // left
char ledBuff[8]={0x18,0x3c,0x7e,0xff,0x3c,0x3c,0x3c,0x3c};  // rigth
//char ledBuff[8]={0x08,0x0c,0xfe,0xff,0xff,0xfe,0x0c,0x08};  // top
//char ledBuff[8]={0x10,0x30,0x7f,0xff,0xff,0x7f,0x30,0x10};    // down
//char ledBuff[8]={0x04,0x0e,0x9f,0xfe,0xfc,0xf8,0xf8,0xfc};    // keep left1
//char ledBuff[8]={0x01,0x02,0x84,0x88,0x90,0xa0,0xc0,0xfc};    // keep left2

char temp  = 0;
char colum = 0;

void setup() {                
  // initialize the digital pin as an output.
  // Pin 13 has an LED connected on most Arduino boards:
  pinMode(13, OUTPUT);  
  pinMode(PIN_LATCH, OUTPUT); 
  pinMode(PIN_DATA, OUTPUT); 
  pinMode(PIN_CLOCK, OUTPUT);   
}

void output_led_state()
{
   SH_CP_low();
   ST_CP_low();
   
   temp = 1<<colum;
   for(int i=0;i<8;i++){
      if (ledBuff[colum]&(1<<i))
         DS_high();
      else  
         DS_low();

      SH_CP_high();
      SH_CP_low();
   }
   
   for(int i=0;i<8;i++){
      if (temp&0x80)
         DS_high();
      else  
         DS_low();
      
      temp = temp << 1;
      SH_CP_high();
      SH_CP_low();
   }

   ST_CP_high();
   
   colum++;
   
   if(colum>=8)
     colum = 0;
}

void loop() {
  output_led_state();
}

