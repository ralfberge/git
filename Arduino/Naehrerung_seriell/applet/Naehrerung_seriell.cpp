




/* Read Quadrature Encoder
  * Connect Encoder to Pins encoder0PinA, encoder0PinB, and +5V.
  *
  * Sketch by max wolf / www.meso.net
  * v. 0.1 - very basic functions - mw 20061220
  *
  */  
  
#include <stdio.h>   

#include <LiquidCrystal.h>
#include "pins_arduino.h"
#include <DmxSimple.h>


 #include "WProgram.h"
void shiftDmxOut(int pin, int theByte);
int mean ();
void setup();
void loop();
LiquidCrystal lcd (12, 11, 7, 8, 9, 10);
 
 int n;
 int i;
 int dmx_wert;
 int dmx_sig = 2;
 int val[10]; 
 int analogPin = 0;
 char buffer[4]    = "";
 

 int delayTime = 20;

 
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
  // cli();

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
  // sei();
}



int mean ()

{ 
 
   for (int n=0; n <= 9; n++)
   {
     val[n] = analogRead(analogPin);
     delay(10);
   
   }   
 
  for (int n=1; n <= 9; n++)
   {
     val[0] = val[0]+ val[n];
   
   }   
   
 return (val[0]/10);
 } 
 

 void setup() { 
   
   pinMode(dmx_sig, OUTPUT);
   lcd.begin(20, 4);
   lcd.clear();
   lcd.print("Entfernung 1.0");
  
   Serial.begin(9600);
  
  
 } 



 void loop() { 
  
  
   dmx_wert = mean()/2;
   
   if (dmx_wert > 255)
     {
       dmx_wert = 255;
     }
     
   lcd.setCursor(0, 2);
   lcd.print("Wert:");
   sprintf(buffer,"%3d",dmx_wert);
   lcd.setCursor(10, 2);
   lcd.print(buffer);

  Serial.print(dmx_wert); 
  Serial.println(); 
  
    
    
  DmxSimple.write(1, dmx_wert);
  
delay(10);

 } 

int main(void)
{
	init();

	setup();
    
	for (;;)
		loop();
        
	return 0;
}

