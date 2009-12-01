




/* Read Quadrature Encoder
  * Connect Encoder to Pins encoder0PinA, encoder0PinB, and +5V.
  *
  * Sketch by max wolf / www.meso.net
  * v. 0.1 - very basic functions - mw 20061220
  *
  */  
  
#include <stdio.h>   
#include "pins_arduino.h"
#include <DmxSimple.h>


#include "WProgram.h"
int mean ();
void setup();
void loop();
const int Mac250_zuenden = 230;
const int Mac250_reset = 210;
const int Mac250_Shutteroffen = 240;

const int Mac250_rot = 77;
const int Mac250_gelb = 22;
const int Mac250_blau = 99;
const int Mac250_pink = 44;
const int Mac250_gruen = 55;
const int Mac250_orange = 110;


const int Mac250Kanal_Shutter = 1;
const int Mac250Kanal_Dimmer = 2;
const int Mac250Kanal_Farbe = 3;
const int Mac250Kanal_Pan = 10;
const int Mac250Kanal_Tilt = 12;


 int n;
 int i;
 int dmx_wert;
 
 int value = 0;
 int channel;

 int dmx_sig = 2;
 int val[10]; 
 int analogPin = 0;
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
   

  DmxSimple.write(Mac250Kanal_Shutter, Mac250_Shutteroffen);
  delay(1000);
  DmxSimple.write(Mac250Kanal_Dimmer, 255);
  delay(1000);
  DmxSimple.write(Mac250Kanal_Shutter, Mac250_zuenden);
  delay(6000);
  DmxSimple.write(Mac250Kanal_Shutter, Mac250_Shutteroffen);
  DmxSimple.write(Mac250Kanal_Farbe, Mac250_gelb);
  

 } 



 void loop() { 
  
  
   dmx_wert = mean()/2;
   
   if (dmx_wert > 255)
     {
       dmx_wert = 255;
     }
     
  
    
  DmxSimple.write(Mac250Kanal_Pan, dmx_wert);
  DmxSimple.write(Mac250Kanal_Tilt, dmx_wert);

  if (dmx_wert < 40)                          {DmxSimple.write(Mac250Kanal_Farbe, Mac250_gelb);}
  if ((dmx_wert >= 40) && (dmx_wert < 80))    {DmxSimple.write(Mac250Kanal_Farbe, Mac250_rot);}
  if ((dmx_wert >= 80) && (dmx_wert < 120))   {DmxSimple.write(Mac250Kanal_Farbe, Mac250_blau);}
  if ((dmx_wert >= 120) && (dmx_wert < 160))  {DmxSimple.write(Mac250Kanal_Farbe, Mac250_pink);}
  if ((dmx_wert >= 160) && (dmx_wert < 200))  {DmxSimple.write(Mac250Kanal_Farbe, Mac250_gruen);}
  if (dmx_wert >= 200)                        {DmxSimple.write(Mac250Kanal_Farbe, Mac250_orange);}

delay(10);


 } 

int main(void)
{
	init();

	setup();
    
	for (;;)
		loop();
        
	return 0;
}

