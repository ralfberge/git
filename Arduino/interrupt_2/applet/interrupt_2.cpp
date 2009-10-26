


#undef int
#include <stdio.h> 
#include <Stepper.h>
#include <LiquidCrystal.h>



// change this to the number of steps on your motor
#define STEPS 200

//LiquidCrystal(rs, enable, d4, d5, d6, d7) 
  #include "WProgram.h"
void setup();
void loop();
void blink();
LiquidCrystal lcd (12, 11, 7, 8, 9, 10);
  
// create an instance of the stepper class, specifying
// the number of steps of the motor and the pins it's
// attached to

Stepper stepper(STEPS, 7, 9, 8, 10);


 int state = LOW;
 int encoder0PinB = 1;
 int encoder0Pos = 0;
 int ledPin = 13;                // LED connected to digital pin 13
 int stepper_enable=5;
 int stepper_position=0;
 volatile int encoder = LOW;
 int encoder_old = LOW;
 int minimum = 0;
 int maximum = 500;
 int faktor = 4;
 int val = 0;
 int val_old = 0;

 float f=0;

 char buffer[4]    = "";
 
 
void setup()
{

   pinMode(ledPin, OUTPUT);
   attachInterrupt(1, blink, FALLING); // pin 3
   pinMode (encoder0PinB,INPUT);
   pinMode(stepper_enable, OUTPUT);
   digitalWrite(stepper_enable, LOW);
// set the speed of the motor to 30 RPMs
  stepper.setSpeed(80);

   lcd.begin(20, 4);
   lcd.clear();
   lcd.print("Stepper, Vers. 1.0");
   lcd.setCursor(0, 2);
   lcd.print("Position:");
   sprintf(buffer,"%3d",val);
   lcd.setCursor(10, 2);
   lcd.print(buffer);
   
   
 //  Serial.begin (9600);
 
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
    // Serial.print (encoder);
    // Serial.print (" ");
    // Serial.print (val);
    // Serial.print (" ");
     
      val_old=val;
      
         sprintf(buffer,"%3d",val);
         digitalWrite(stepper_enable, LOW);
        
         lcd.setCursor(10, 2);
         lcd.print(buffer);
       
       //lcd.cursorTo(1, 10); 
      // lcd.printIn(buffer);
      
        stepper.step(100);

   } 


digitalWrite(stepper_enable, HIGH);
          if (abs (val - stepper_position) >10)
          { lcd.setCursor(19, 3);
            lcd.blink();}
         
          stepper.step(val - stepper_position);
         
          lcd.noBlink();
   
digitalWrite(stepper_enable, LOW);
stepper_position=val;
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

