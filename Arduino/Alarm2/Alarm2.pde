

//example use of LCD4Bit library


#include <LCD4Bit.h> 

#include <Wire.h>


//create object to control an LCD.  
//number of lines in display=1
LCD4Bit lcd = LCD4Bit(1); 

//some messages to display on the LCD
char msgs[6][15] = {"apple", "banana", "pineapple", "mango", "watermelon", "pear"};
int NUM_MSGS = 6;
char buffer[4]    = "";

byte _sec =4;
byte _min=8;
byte _hour=3;
byte _day =5;
byte _date=2;
byte _month=6;
byte _year =7;
byte _ctrl =7;
boolean state;


 int bcd2Dec(byte bcdVal) 

{ 
  return bcdVal / 16 * 10 + bcdVal % 16; 
}
 
 

void setup() { 
  pinMode(13, OUTPUT);  //we'll use the debug LED to output a heartbeat

  lcd.init();
  //optionally, now set up our application-specific display settings, overriding whatever the lcd did in lcd.init()
  //lcd.commandWrite(0x0F);//cursor on, display on, blink on.  (nasty!)




Wire.begin();        // join i2c bus (address optional for master)
  Serial.begin(9600);
  pinMode(13, OUTPUT);
  Wire.beginTransmission(104); // transmit to device #104, the ds 1307

    // **********setting time**************
 // Wire.send(sendung, 8); //sec
  Wire.send(_sec); //sec
  Wire.send(_min); //min
  Wire.send(_hour);  //hour
  Wire.send(_day);  //day
  Wire.send(_date); //date
  Wire.send(_month);  //month
 // Wire.send(_year);  //year
       
  Wire.endTransmission();    // stop transmitting



}





void loop() {  

  lcd.clear();

  delay(100);

  Wire.requestFrom(104, 6);    // request 6 bytes from slave ds1307
  while(Wire.available())    // slave may send less than requested
  {
    digitalWrite(13,state); //LED on pin 13 to see if there is activity
    state=!state;
    int c = Wire.receive();
    itoa (bcd2Dec(c), buffer, 10);
    lcd.printIn(buffer);
    
      lcd.printIn(":");

  }



  delay(1000);
  
  
//Display

  //scroll entire display 20 chars to left, delaying 50ms each inc
  lcd.leftScroll(20, 50);
}
