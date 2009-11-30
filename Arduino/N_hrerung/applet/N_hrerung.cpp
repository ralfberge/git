




/* Read Quadrature Encoder
  * Connect Encoder to Pins encoder0PinA, encoder0PinB, and +5V.
  *
  * Sketch by max wolf / www.meso.net
  * v. 0.1 - very basic functions - mw 20061220
  *
  */  
  
#include <stdio.h>   

#include <LiquidCrystal.h>



 #include "WProgram.h"
int mean ();
void setup();
void loop();
LiquidCrystal lcd (12, 11, 7, 8, 9, 10);
 int n;
 int val[10]; 
 int analogPin = 5;
 char buffer[4]    = "";
 

int delayTime = 20;





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
   
   
   lcd.begin(20, 4);
   lcd.clear();
   lcd.print("Entfernung 1.0");
  
  
  
  
 } 



 void loop() { 
  

   lcd.setCursor(0, 2);
   lcd.print("Wert:");
   sprintf(buffer,"%3d",mean());
   lcd.setCursor(10, 2);
   lcd.print(buffer);

delay(20);

 } 

int main(void)
{
	init();

	setup();
    
	for (;;)
		loop();
        
	return 0;
}

