




/* Read Quadrature Encoder
  * Connect Encoder to Pins encoder0PinA, encoder0PinB, and +5V.
  *
  * Sketch by max wolf / www.meso.net
  * v. 0.1 - very basic functions - mw 20061220
  *
  */  
  
#include <stdio.h>   

#include <LiquidCrystal.h>


LiquidCrystal lcd (12, 11, 7, 8, 9, 10);

 int val; 
 int analogPin = 5;
 char buffer[4]    = "";
 

int delayTime = 20;





 void setup() { 
 
   
 
  
   lcd.begin(20, 4);
   lcd.clear();
   lcd.print("Stepper, Vers. 1.0");
  
  
  
  
  
 
 } 



 void loop() { 


   val = analogRead(analogPin);
   

   lcd.setCursor(0, 2);
   lcd.print("Wert:");
   sprintf(buffer,"%3d",val);
   lcd.setCursor(10, 2);
   lcd.print(buffer);

delay(50);

 } 
