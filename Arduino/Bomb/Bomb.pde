




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

 int n = LOW;
 
 
void setup() 
{ 

lcd.begin(20, 4);
lcd.clear();
lcd.print("Stepper, Vers. 1.0");
delay (300); 

} 


void loop() 
{ 

//d.print("--------------------
/*lcd.clear();
lcd.setCursor(7, 0);
lcd.print("HALLO!");
lcd.setCursor(0, 1);
lcd.print("Eine schwere Aufgabe");
lcd.setCursor(0, 2);
lcd.print("   ist zu loesen!");

delay (5000);

lcd.noDisplay();
delay (300); 
lcd.display();
delay (300); 
lcd.noDisplay();
delay (300); 
lcd.display();
delay (300); 
lcd.noDisplay();
delay (300); 
lcd.display();
delay (300); 

delay (5000);
*/
//d.print("--------------------
lcd.clear();
lcd.home();
lcd.print(" Welches Kabel muss");
lcd.setCursor(0, 1);
lcd.print("stecken, und welches");
lcd.setCursor(0, 2);
lcd.print(" darf nicht, um den");
lcd.setCursor(0, 3);
lcd.print(" Code zu erhalten?");

delay (5000);

//d.print("--------------------
lcd.clear();
lcd.setCursor(0, 1);
lcd.print("     4 Hinweise");
lcd.setCursor(1, 2);
lcd.print(" sind zu beachten!");
delay (2000);


//d.print("--------------------
lcd.clear();
lcd.home();
lcd.print("1. Wenn A stecken");
lcd.setCursor(0, 1);
lcd.print("   muss, dann muss");
lcd.setCursor(0, 2);
lcd.print("   auch B stecken!");


delay (8000);


//d.print("--------------------
lcd.clear();
lcd.home();
lcd.print("2.Wenn B muss, dann");
lcd.setCursor(0, 1);
lcd.print("  muss entweder auch");
lcd.setCursor(0, 2);
lcd.print("  C stecken oder A "); 
lcd.setCursor(0, 3);
lcd.print("  darf nicht stecken");


delay (8000);

//d.print("--------------------
lcd.clear();
lcd.home();
lcd.print("3.Wenn D nicht stek-");
lcd.setCursor(0, 1);
lcd.print("  ken darf, muss A");
lcd.setCursor(0, 2);
lcd.print("  stecken und C darf");
lcd.setCursor(0, 3);
lcd.print("  nicht stecken.");

delay (8000);

//d.print("--------------------
lcd.clear();
lcd.home();
lcd.print("4.Wenn D stecken");
lcd.setCursor(0, 1);
lcd.print("  muss, dann muss");
lcd.setCursor(0, 2);
lcd.print("  auch A stecken.");
lcd.setCursor(13, 3);
lcd.print("<press>");

delay (8000);


//d.print("--------------------
lcd.clear();
lcd.home();
lcd.print("Ueberlegen Sie gut");
lcd.setCursor(0, 1);
lcd.print("nach veraendern des");
lcd.setCursor(0, 2);
lcd.print("ersten Kabels haben");
lcd.setCursor(0, 3);
lcd.print("Sie nur 30 Sekunden!");

delay (8000);



lcd.clear();
  for (int i=30; i >= 0; i--){
      lcd.setCursor(8, 1);
      lcd.print("00:");
      if (i < 10){ lcd.print("0"); }
      lcd.print(i);
      delay(1000);
   } 

} 
