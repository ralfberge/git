



//example use of LCD4Bit library

#undef int
#include <stdio.h> 
#include <Wire.h>

#include <LCD4Bit.h> 
#include "pins_arduino.h"

//create object to control an LCD.  
//number of lines in display=1
LCD4Bit lcd = LCD4Bit(2); 

int  sig          = 3;             // signal
int  value[10]    = {0,0,100,255,0};
int  valueadd[5]  = {0,1,2,4,5};
int  rtc          = 104;
int  potPin       = 1;             // select the input pin for the potentiometer
int  ledPin       = 13;            // select the pin for the LED
int  val          = 0;             // variable to store the value coming from the sensor
char buffer[4]    = "";            // must be large enough to hold your longest string including trailing 0 !!!

int relais1Pin = 5;                // LED connected to digital pin 13
int relais2Pin = 6;                // LED connected to digital pin 13
int inPin = 4;                     // choose the input pin (for a pushbutton)


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



void setup() 
{ 
       pinMode(ledPin, OUTPUT);          //we'll use the debug LED to output a heartbeat
       pinMode(relais1Pin, OUTPUT);      // sets the digital pin as output
       pinMode(relais2Pin, OUTPUT);      // sets the digital pin as output
       pinMode(inPin, INPUT);            // declare pushbutton as input
       
       lcd.init();
       lcd.clear();
    

       lcd.printIn("date:");
   
       lcd.cursorTo(2, 0); 
       lcd.printIn("time:");
   
        

   Wire.begin(); 
       
  /*
       second = 0x00;                                // demo time 
       minute = 0x17; 
       hour   = 0x19; 
       wkDay  = 0x30; 
       day    = 0x18; 
       month  = 0x11; 
       year   = 0x09; 
       ctrl   = 0x00;   
       
    
         setClock() ;

  */ 
 
}

void loop() 
{  
  

/*  val = analogRead(potPin);
       sprintf(buffer,"%4d",val);
       lcd.cursorTo(1, 1); 
       lcd.printIn(buffer); 
*/

val = digitalRead(inPin);                // read input value
  if (val == LOW) {                      // check if the input is HIGH (button released)
    digitalWrite(ledPin, LOW);           // turn LED OFF
        digitalWrite(relais1Pin, LOW);   // turn LED OFF
        digitalWrite(relais2Pin, LOW);   // turn LED OFF
  } 
  
  else {
    
       digitalWrite(ledPin, HIGH);           // turn LED ON
       getClock();
       
       lcd.cursorTo(2, 8); 
       sprintf(buffer,"%02d",bcd2Dec(hour));
       lcd.printIn(buffer);
       lcd.printIn(":");
       sprintf(buffer,"%02d",bcd2Dec(minute));
       lcd.printIn(buffer);
       lcd.printIn(":");
       sprintf(buffer,"%02d",bcd2Dec(second));
       lcd.printIn(buffer);

       lcd.cursorTo(1, 8); 
       sprintf(buffer,"%02d",bcd2Dec(day));
       lcd.printIn(buffer);
       lcd.printIn(".");
       sprintf(buffer,"%02d",bcd2Dec(month));
       lcd.printIn(buffer);
       lcd.printIn(".");
       sprintf(buffer,"%02d",bcd2Dec(year));
       lcd.printIn(buffer);
    
    delay (5000);  // 
    
    digitalWrite(ledPin, HIGH);  // turn LED ON
    digitalWrite(relais1Pin, HIGH);  // turn LED ON
    digitalWrite(relais2Pin, HIGH);  // turn LED ON

    delay (500);

    digitalWrite(relais1Pin, LOW);  // turn LED ON
    digitalWrite(relais2Pin, LOW);  // turn LED ON
   
   
     delay (50000);
   
   
   digitalWrite(relais1Pin, HIGH);  // turn LED ON
   digitalWrite(relais2Pin, HIGH);  // turn LED ON

    delay (500);

    digitalWrite(relais1Pin, LOW);  // turn LED ON
    digitalWrite(relais2Pin, LOW);  // turn LED ON
    
    digitalWrite(ledPin, LOW);  // turn LED ON
   
 delay (10000);
 
 
      digitalWrite(ledPin, LOW);           // turn LED OFF
  }



}


