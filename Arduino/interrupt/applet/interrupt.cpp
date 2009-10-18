#include "WProgram.h"
//example use of LCD4Bit library



#undef int
#include <stdio.h> 
#include <LCD4Bit.h>
void setup();
void loop();
void blink();
LCD4Bit lcd = LCD4Bit(1);


int state = LOW;


 int encoder0PinB = 1;
 int encoder0Pos = 0;
 int ledPin = 13;                // LED connected to digital pin 13
 volatile int encoder = LOW;
 int encoder_old = LOW;
 int minimum = 0;
 int maximum = 1000;
 int faktor = 10;
 int val = 0;
 int val_old = 0;

 float f=0;

 char buffer[6]    = "";
 
 
void setup()
{
   lcd.init();
   pinMode(ledPin, OUTPUT);
   attachInterrupt(1, blink, FALLING); // pin 2
   pinMode (encoder0PinB,INPUT);
   Serial.begin (9600);
}

void loop()
{
      val=encoder/faktor;
 
      if (val < minimum)
            {val=minimum;
             encoder=minimum*faktor;}
    
      if (val > maximum)
            {val=maximum;
             encoder=maximum*faktor;}

  if (val !=val_old)
   { 
   
     val_old=val;
          
          
     // Serial.print (encoder);
     Serial.print (" ");
     Serial.print (val);
     Serial.print (" ");
     
       


         itoa(val, buffer, 10);
        // sprintf(buffer,"%3d",val);
         lcd.clear();
         lcd.printIn("Poti:     ");
         lcd.printIn(buffer);
       
       //lcd.cursorTo(1, 10); 
      // lcd.printIn(buffer);
       

   } 



digitalWrite(ledPin, state);

}


void blink()
{
     if (digitalRead(encoder0PinB) == LOW) {
       encoder--;

     } else {
       encoder++;

     }
  
     state = !state;
}

 
 
 
 
 
 
 
 
 
 
 
/*
 } 

 void loop() { 
   n = digitalRead(encoder0PinA);
   if ((encoder0PinALast == LOW) && (n == HIGH)) {
     if (digitalRead(encoder0PinB) == LOW) {
       encoder0Pos--;
     } else {
       encoder0Pos++;
     }
     Serial.print (encoder0Pos);
     Serial.print ("/");
   } 
     digitalWrite(ledPin, n);   // sets the LED on
     encoder0PinALast = n;
 } 


/*
attachInterrupt(interrupt, function, mode)

Description

Specifies a function to call when an external interrupt occurs. Replaces any previous function
that was attached to the interrupt. Most Arduino boards have two external interrupts: 

numbers 0 (on digital pin 2) and 1 (on digital pin 3). 

The Arduino Mega has an additional four: numbers 2 (pin 21), 3 (pin 20), 4 (pin 19), and 5 (pin 18).


Parameters

interrupt: the number of the interrupt (int)

function: the function to call when the interrupt occurs; this function must take no parameters
and return nothing. This function is sometimes referred to as an interrupt service routine.

mode defines when the interrupt should be triggered. Four contstants are predefined as valid values:

    * LOW to trigger the interrupt whenever the pin is low,
    * CHANGE to trigger the interrupt whenever the pin changes value
    * RISING to trigger when the pin goes from low to high,
    * FALLING for when the pin goes from high to low. 

Returns

none

Note

Inside the attached function, delay() won't work and the value returned by millis() will not increment. 
Serial data received while in the function may be lost. You should declare as volatile any variables 
that you modify within the attached function. 

*/

int main(void)
{
	init();

	setup();
    
	for (;;)
		loop();
        
	return 0;
}

