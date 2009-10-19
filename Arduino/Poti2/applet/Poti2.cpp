#include "WProgram.h"
void shiftDmxOut(int pin, int theByte);
#include "stdio.h"
#include "LCD4Bit.h"
#include "pins_arduino.h"



//example use of LCD4Bit library

//create object to control an LCD.  
//number of lines in display=1
LCD4Bit lcd = LCD4Bit(2); 

//some messages to display on the LCD


int sig = 3; // signal
int value[513] = {0,0,50,100,256,0};
//             value[0]     adr1,  adr2,  adr3, adr4,  adr5

int valueadd = 3;



int potPin = 1;    // select the input pin for the potentiometer
int ledPin = 13;   // select the pin for the LED
int val = 0;       // variable to store the value coming from the sensor
int valOld = 0; 
char buffer[4];   // must be large enough to hold your longest string including trailing 0 !!!



void shiftDmxOut(int pin, int theByte)
{
  int port_to_output[] = {
    NOT_A_PORT,
    NOT_A_PORT,
    _SFR_IO_ADDR(PORTB),
    _SFR_IO_ADDR(PORTC),
    _SFR_IO_ADDR(PORTD)
    };

    int portNumber = port_to_output[digitalPinToPort(pin)];
  int pinMask = digitalPinToBitMask(pin);

  // the first thing we do is to write te pin to high
  // it will be the mark between bytes. It may be also
  // high from before
  _SFR_BYTE(_SFR_IO8(portNumber)) |= pinMask;
  delayMicroseconds(10);

  // disable interrupts, otherwise the timer 0 overflow interrupt that
  // tracks milliseconds will make us delay longer than we want.
  cli();

  // DMX starts with a start-bit that must always be zero
  _SFR_BYTE(_SFR_IO8(portNumber)) &= ~pinMask;

  // we need a delay of 4us (then one bit is transfered)
  // this seems more stable then using delayMicroseconds
  asm("nop\n nop\n nop\n nop\n nop\n nop\n nop\n nop\n");
  asm("nop\n nop\n nop\n nop\n nop\n nop\n nop\n nop\n");

  asm("nop\n nop\n nop\n nop\n nop\n nop\n nop\n nop\n");
  asm("nop\n nop\n nop\n nop\n nop\n nop\n nop\n nop\n");

  asm("nop\n nop\n nop\n nop\n nop\n nop\n nop\n nop\n");
  asm("nop\n nop\n nop\n nop\n nop\n nop\n nop\n nop\n");

  for (int i = 0; i < 8; i++)
  {
    if (theByte & 01)
    {
      _SFR_BYTE(_SFR_IO8(portNumber)) |= pinMask;
    }
    else
    {
      _SFR_BYTE(_SFR_IO8(portNumber)) &= ~pinMask;
    }

    asm("nop\n nop\n nop\n nop\n nop\n nop\n nop\n nop\n");
    asm("nop\n nop\n nop\n nop\n nop\n nop\n nop\n nop\n");

    asm("nop\n nop\n nop\n nop\n nop\n nop\n nop\n nop\n");
    asm("nop\n nop\n nop\n nop\n nop\n nop\n nop\n nop\n");

    asm("nop\n nop\n nop\n nop\n nop\n nop\n nop\n nop\n");
    asm("nop\n nop\n nop\n nop\n nop\n nop\n nop\n nop\n");

    theByte >>= 1;
  }

  // the last thing we do is to write the pin to high
  // it will be the mark between bytes. (this break is have to be between 8 us and 1 sec)
  _SFR_BYTE(_SFR_IO8(portNumber)) |= pinMask;

  // reenable interrupts.
  sei();
}




void setup() { 
  pinMode(13, OUTPUT);  //we'll use the debug LED to output a heartbeat
  pinMode(sig, OUTPUT);
  lcd.init();
  //optionally, now set up our application-specific display settings, overriding whatever the lcd did in lcd.init()
  //lcd.commandWrite(0x0F);//cursor on, display on, blink on.  (nasty!)
       lcd.clear();
       val = analogRead(potPin);
       sprintf(buffer,"%4d",val);
       lcd.printIn("Poti:");
       lcd.cursorTo(1, 10); 
       lcd.printIn(buffer);
}

void loop() {  
  val = analogRead(potPin);
  
  if (val != valOld)
    {
       lcd.cursorTo(1, 10); 
       sprintf(buffer,"%4d",val);
       lcd.printIn(buffer);
    }
      valOld= val;
  
   /***** sending the dmx signal *****/
  // sending the break (the break can be between 88us and 1sec)
  digitalWrite(sig, LOW);

  delay(val);

  // sending the start byte
  shiftDmxOut(sig, 0);

  for (int count = 1; count <= 512; count++)
  {
    shiftDmxOut(sig, value[count]);
   
  }
 
  /***** sending the dmx signal end *****/

  value[1] += valueadd;  
  if ((value[1] == 0) || (value[1] == 255))
  {
    valueadd *= -1;
  }
  
}



int main(void)
{
	init();

	setup();
    
	for (;;)
		loop();
        
	return 0;
}

