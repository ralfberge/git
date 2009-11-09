/* Read Quadrature Encoder
  * Connect Encoder to Pins encoder0PinA, encoder0PinB, and +5V.
  *
  * Sketch by max wolf / www.meso.net
  * v. 0.1 - very basic functions - mw 20061220
  *
  */  
  
#include <stdio.h>   
#include <Stepper.h>
#include <LiquidCrystal.h>

#define STEPS 60
#include "WProgram.h"
void setup();
void loop();
Stepper stepper(STEPS, 7, 8, 9, 10);
LiquidCrystal lcd (12, 11, 7, 8, 9, 10);

 int val; 
 int encoder0PinA = 3;
 int encoder0PinB = 2;
 int encoder_min = 100;
 int encoder_max = 1000;
 int encoder0Pos = 100;
 int encoder0PinALast = LOW;
 int n = LOW;
 
  int stepper_enable=5;
  
   char buffer[5]    = "";

 void setup() { 
 
   
   pinMode (encoder0PinA,INPUT);
   pinMode (encoder0PinB,INPUT);
   pinMode (stepper_enable, OUTPUT);
   Serial.begin (9600);
   stepper.setSpeed(250);
   digitalWrite(stepper_enable, HIGH);
   
   lcd.begin(20, 4);
   lcd.clear();
   lcd.print("Stepper, Vers. 1.0");
  
  
  
  
  
 
 } 

 void loop() { 


   n = digitalRead(encoder0PinA);
   if ((encoder0PinALast == LOW) && (n == HIGH)  ) {
     if ((digitalRead(encoder0PinB) == LOW) && (encoder0Pos > encoder_min)) {
        

         digitalWrite(stepper_enable, HIGH);
         encoder0Pos--;
         stepper.step(-1);
    

     
   } else {
   
 if  (encoder0Pos < encoder_max)    {
         digitalWrite(stepper_enable, HIGH);
         encoder0Pos++;
         stepper.step(1);
 }
   
     }


    Serial.print (encoder0Pos);
    Serial.print ("/");
    digitalWrite(stepper_enable, LOW);

   lcd.setCursor(0, 2);
   lcd.print("Position:");
   sprintf(buffer,"%4d",encoder0Pos);
   lcd.setCursor(10, 2);
   lcd.print(buffer);
        
  } 
   encoder0PinALast = n;
   
   
   
 } 

int main(void)
{
	init();

	setup();
    
	for (;;)
		loop();
        
	return 0;
}

