



//example use of LCD4Bit library

#include <stdio.h> 
#include <Wire.h>

#include <LCD4Bit.h> 
#include "pins_arduino.h"

//create object to control an LCD.  
//number of lines in display=1
LCD4Bit lcd = LCD4Bit(2); 

int  sig          = 3; // signal
int  value[10]    = {0,0,100,255,0};
int  valueadd[5]  = {0,1,2,4,5};
int  rtc          = 104;
int  potPin       = 1;    // select the input pin for the potentiometer
int  ledPin       = 13;   // select the pin for the LED
int  val          = 0;    // variable to store the value coming from the sensor
char buffer[4]    = "";   // must be large enough to hold your longest string including trailing 0 !!!



#define R_SECS      0 
#define R_MINS      1 
#define R_HRS       2 
#define R_WKDAY     3 
#define R_DATE      4 
#define R_MONTH     5 
#define R_YEAR      6 
#define R_SQW       7 


byte second = 0x00;                             // default to 01 JAN 2008, midnight 
byte minute = 0x00; 
byte hour = 0x00; 
byte wkDay = 0x02; 
byte day = 0x01; 
byte month = 0x01; 
byte year = 0x08; 
byte ctrl = 0x00; 
 
 
 
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
 
 
 
 
 
 void setClock() 
{ 
  Wire.beginTransmission(rtc); 
  Wire.send(R_SECS); 
  Wire.send(second); 
  Wire.send(minute); 
  Wire.send(hour); 
  Wire.send(wkDay); 
  Wire.send(day); 
  Wire.send(month); 
  Wire.send(year); 
  Wire.send(ctrl); 
  Wire.endTransmission(); 
} 
 
 
 
 int bcd2Dec(byte bcdVal) 

{ 
  return bcdVal / 16 * 10 + bcdVal % 16; 
}
 
 
 
 
void getClock() 
{ 
  Wire.beginTransmission(rtc); 
  Wire.send(0); 
  Wire.endTransmission(); 
  
  delay(10);
  
  Wire.requestFrom(rtc, 8); 
  second = Wire.receive(); 
  minute = Wire.receive(); 
  hour   = Wire.receive(); 
  wkDay  = Wire.receive(); 
  day    = Wire.receive(); 
  month  = Wire.receive(); 
  year   = Wire.receive(); 
  ctrl   = Wire.receive(); 
} 


void printHex2(byte hexVal) 
{ 
  if (hexVal < 0x10) 
    Serial.print("0"); 
    Serial.print(hexVal, HEX); 
} 



void setup() 
{ 
       pinMode(ledPin, OUTPUT);  //we'll use the debug LED to output a heartbeat
       pinMode(sig, OUTPUT);
       
       lcd.init();
       lcd.clear();
       val = analogRead(potPin);
       sprintf(buffer,"%4d",val);
       lcd.printIn("Poti:");
       lcd.cursorTo(1, 10); 
       lcd.printIn(buffer);
   
        
       Wire.begin();
       Serial.begin(9600);

 /*
       second = 0x00;                                // demo time 
       minute = 0x35; 
       hour   = 0x20; 
       wkDay  = 0x02; 
       day    = 0x15; 
       month  = 0x01; 
       year   = 0x08; 
       ctrl   = 0x00;   
       
       setClock() ;
*/
   
 
}

void loop() 
{  
  
       val = analogRead(potPin);
       sprintf(buffer,"%4d",val);
       lcd.cursorTo(1, 10); 
       lcd.printIn(buffer);
 
getClock() ;


/*
  printHex2(hour); 
  Serial.print(":"); 
  printHex2(minute); 
  Serial.print(":"); 
  printHex2(second); 
  Serial.print("  "); 
  printHex2(day); 
  Serial.print("."); 
  printHex2(month); 
  Serial.print(".20"); 
  printHex2(year); 
  Serial.println(); 
*/



       lcd.cursorTo(2, 0); 
       sprintf(buffer,"%02d",bcd2Dec(hour));
       lcd.printIn(buffer);
       lcd.printIn(":");
       sprintf(buffer,"%02d",bcd2Dec(minute));
       lcd.printIn(buffer);
       lcd.printIn(":");
       sprintf(buffer,"%02d",bcd2Dec(second));
       lcd.printIn(buffer);

       lcd.printIn("  ");

       sprintf(buffer,"%02d",bcd2Dec(day));
       lcd.printIn(buffer);
       lcd.printIn(".");
       sprintf(buffer,"%02d",bcd2Dec(month));
       lcd.printIn(buffer);
       lcd.printIn(".");
       sprintf(buffer,"%02d",bcd2Dec(year));
       lcd.printIn(buffer);


if(val<= 150)
{
  if(bcd2Dec(hour)>= 6 && bcd2Dec(hour)<= 8)
  {
    val=255;
  }

  else
  {
    val=0;
  }

  if(bcd2Dec(hour)>= 17 && bcd2Dec(hour)<= 21)
  {
    val=255;
  }

}

else
{
  val=0;
}


  /***** sending the dmx signal *****/
  // sending the break (the break can be between 88us and 1sec)
  digitalWrite(sig, LOW);

  delay(10);

  // sending the start byte
  shiftDmxOut(sig, 0);

    
  for (int count = 1; count <= 512; count++)
  {
    shiftDmxOut(sig, val);
  }


delay (100);

}

