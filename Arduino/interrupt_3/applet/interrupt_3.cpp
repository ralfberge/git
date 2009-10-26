


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
 int encoder0PinB = 2;
 int encoder0Pos = 0;
 int ledPin = 13;                // LED connected to digital pin 13
 int stepper_enable=5;
 int stepper_position=0;
 int steps=0;
 volatile int encoder = LOW;
 int encoder_old = LOW;
 int minimum = 0;
 int maximum = 500;
 int faktor = 4;
 int val = 0;
 int val_old = 0;

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
     sprintf(buffer,"%3d",val);    
     digitalWrite(stepper_enable, LOW);
     lcd.setCursor(10, 2);
     lcd.print(buffer);
     val_old=val;
     
     digitalWrite(stepper_enable, HIGH);

     steps=val - stepper_position;
     stepper.step(1);
     stepper_position=val;
    } 
    else
    {digitalWrite(stepper_enable, LOW);}





   

   

      
     digitalWrite(stepper_enable, HIGH);
     stepper.step(1);

}




void blink()
{
     if (digitalRead(encoder0PinB) == LOW) {
       encoder--;

     } else {
       encoder++;

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

