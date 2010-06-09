// OSCClass IOtest Arduino sketch
// OSCClass version 1.0.1 (Arduino ver0014)
// Copyright (c) recotana(http://recotana.com).  All right reserved.

#include <stdio.h>   

#include "Ethernet.h"
#include "OSCClass.h"

#include "pins_arduino.h"
#include <DmxSimple.h>

#define  SW_PIN  3
#define  LED_PIN 2
#define  POT_PIN  0

 #include "WProgram.h"
void setup();
void loop();
void do_xpos();
void do_ypos();
void do_slider1();
void do_slider2();
void do_slider3();
void do_slider4();
void do_slider5();
void do_slider6();
void do_button1();
void do_button2();
void do_button3();
void do_button4();
void do_button5();
void do_button6();
void do_button7();
void do_button8();
void do_button9();
void do_button16();
void do_segmentA();
void do_segmentB();
void check_OSC();
int n;
 int i;

 int dmx_wert[12] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,};
 int dmx_storeA[12] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,};
 int dmx_storeB[12] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,};
 int dmx_storeC[12] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,};
 int dmx_storeD[12] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,};
 int dmx_storeE[12] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,};
 int dmx_storeF[12] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,};
 
 
 
 
 int delay_schleife = 30;
 int delay_ot = 5000;

 int store_mode = 0;
 int dmx_sig = 2;
 int val[10]; 
 int analogPin = 0;
 int brightness;  




  OSCMessage recMes;
  OSCMessage sendMes;
  
  OSCClass osc(&recMes);

  byte serverMac[] = { 0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };
  byte serverIp[]  = { 192, 168, 0, 19 };
  int  serverPort  = 8000;
  int  horst  = 1;
  int  shift  = 0;
  
//  byte gateway[]   = { 192, 168, 0, 1 };
//  byte subnet[]    = { 255, 255, 255, 0 };


  byte destIp[]  = { 192, 168, 0, 79};
  int  destPort = 8000;
  
  char *topAddress="/ard";
  char *subAddress[15]={ "/xpos", "/ypos", "/slider1", "/slider2", "/slider3", 
                         "/button1", "/button2", "/button3", 
                         "/button4", "/button5", "/button6","/segmentA","/segmentB","/slider4",};
                      
                  
  
  boolean ledFlag;
  boolean  swFlag;
  long    oldPotValue;
  
  
  
void setup() {
  
       //for message logging
     Serial.begin(9600);

    
      Ethernet.begin(serverMac ,serverIp);
 //    Ethernet.begin(serverMac ,serverIp ,gateway ,subnet);

  
     //setting osc recieve server

     osc.begin(serverPort);
     sendMes.setIp( destIp );
     sendMes.setPort( destPort );
     sendMes.setTopAddress( topAddress );
     
     pinMode(SW_PIN, INPUT);
     pinMode(LED_PIN, OUTPUT); 
 
     digitalWrite(LED_PIN, HIGH);  //LED OFF
     ledFlag=false;    
     swFlag=false;
     
     analogReference(DEFAULT);
     oldPotValue=(long)analogRead(POT_PIN);

    //osc message buffer clear
     osc.flush();
     long value = 1;
  
  sendMes.setSubAddress( subAddress[1] ); // "/ard/switch"
  sendMes.setArgs( "i", &value );
  osc.sendOsc( &sendMes );
  
}









void loop() {

  check_OSC();  //osc arrive check
   

   for (i = 0; i <= 11; i++) 
     {
    DmxSimple.write(i+1, dmx_wert[i]); // Set DMX channel 4 to new value
     }
  



}











void do_xpos(){
  

  
  
  float data = recMes.getArgFloat(0);
  
  Serial.print( "xpos: " );
  Serial.println( (data) );
 

   

}

void do_ypos(){
  
  float data = recMes.getArgFloat(0);
 
  Serial.print( "ypos: " );
  Serial.println( data );
  
 

  
}


void do_slider1(){

float data = recMes.getArgFloat(0);  
  
   dmx_wert[0 + shift]= data * 255;
 
  
}



void do_slider2(){

float data = recMes.getArgFloat(0);  

   dmx_wert[1 + shift]= data * 255;
  
  
}



void do_slider3(){

float data = recMes.getArgFloat(0);  
  
   dmx_wert[2 + shift]= data * 255;

}



void do_slider4(){

float data = recMes.getArgFloat(0);  

   dmx_wert[3 + shift]= data * 255;
  
  
}


void do_slider5(){

float data = recMes.getArgFloat(0);  

   dmx_wert[4 + shift]= data * 255;
  
  
}


void do_slider6(){

float data = recMes.getArgFloat(0);  

   dmx_wert[5 + shift]= data * 255;
  
  
}


void do_button1(){
  
   long data = recMes.getArgInt(0);
   for (i = 0; i <= 11; i++) 
     {
      dmx_wert[i]=0;
     }

}




void do_button2(){
  
 long data = recMes.getArgInt(0);
   for (i = 0; i <= 11; i++) 
     {
      dmx_wert[i]=128;
     }

}



void do_button3(){
  
  long data = recMes.getArgInt(0);
   for (i = 0; i <= 11; i++) 
     {
      dmx_wert[i]=255;
     }
  
}


void do_button4(){
  
 if (store_mode == 0)
    {
      for (i = 0; i <= 11; i++) 
     {
      dmx_wert[i] = dmx_storeA[i];
     }
    }
    else
    {
       for (i = 0; i <= 11; i++) 
     {
       dmx_storeA[i] = dmx_wert[i];
     }
       store_mode = 0;
    }

  
  
}


void do_button5(){
  
  if (store_mode == 0)
    {
      for (i = 0; i <= 11; i++) 
     {
      dmx_wert[i] = dmx_storeB[i];
     }
    }
    else
    {
       for (i = 0; i <= 11; i++) 
     {
       dmx_storeB[i] = dmx_wert[i];
     }
   store_mode = 0;  
  }

 
  
}


void do_button6(){
 
  if (store_mode == 0)
    {
      for (i = 0; i <= 11; i++) 
     {
      dmx_wert[i] = dmx_storeC[i];
     }
    }
    else
    {
     for (i = 0; i <= 11; i++) 
     {
       dmx_storeC[i] = dmx_wert[i];
     } 
  
     store_mode = 0;
    }
}




void do_button7(){
 
  if (store_mode == 0)
    {
      for (i = 0; i <= 11; i++) 
     {
      dmx_wert[i] = dmx_storeD[i];
     }
    }
    else
    {
     for (i = 0; i <= 11; i++) 
     {
       dmx_storeD[i] = dmx_wert[i];
     } 
  
     store_mode = 0;
    }
}



void do_button8(){
 
  if (store_mode == 0)
    {
      for (i = 0; i <= 11; i++) 
     {
      dmx_wert[i] = dmx_storeE[i];
     }
    }
    else
    {
     for (i = 0; i <= 11; i++) 
     {
       dmx_storeE[i] = dmx_wert[i];
     } 
  
     store_mode = 0;
    }
}





void do_button9(){
 
  if (store_mode == 0)
    {
      for (i = 0; i <= 11; i++) 
     {
      dmx_wert[i] = dmx_storeF[i];
     }
    }
    else
    {
     for (i = 0; i <= 11; i++) 
     {
       dmx_storeF[i] = dmx_wert[i];
     } 
  
     store_mode = 0;
    }
}






void do_button16(){
 
 
       store_mode = 1;
   
  
}

void do_segmentA(){
 
   long data = recMes.getArgInt(0);
   
     shift=0;
     
}

void do_segmentB(){
  

   long data = recMes.getArgInt(0);
   
     shift=6;
  
}


void check_OSC(){
  
 if ( osc.available() ) {

          //toplevel address matching
          if( !strcmp( recMes.getAddress(0) , topAddress ) ){
                            
              //second level address matching           
             
                if( !strcmp( recMes.getAddress(1) , subAddress[0] ) ) {  // xpos    
                      do_xpos();}
  
                if( !strcmp( recMes.getAddress(1) , subAddress[1] ) ){   // ypos   
                      do_ypos();}
                
                if( !strcmp( recMes.getAddress(1) , subAddress[2] ) ){   // slider1
                      do_slider1();}
                
                if( !strcmp( recMes.getAddress(1) , subAddress[3] ) ){   // slider2
                      do_slider2();}
                
                if( !strcmp( recMes.getAddress(1) , subAddress[4] ) ){   // slider3
                      do_slider3();}
                
                if( !strcmp( recMes.getAddress(1) , subAddress[5] ) ){   // button1
                      do_button1();}
                
                if( !strcmp( recMes.getAddress(1) , subAddress[6] ) ){   // button2
                      do_button2();}
                
                if( !strcmp( recMes.getAddress(1) , subAddress[7] ) ){   // button3
                      do_button3();}
                
                if( !strcmp( recMes.getAddress(1) , subAddress[8] ) ){   // button4
                      do_button4();}
  
                if( !strcmp( recMes.getAddress(1) , subAddress[9] ) ){   // button5
                      do_button5();}
  
                if( !strcmp( recMes.getAddress(1) , subAddress[10] ) ){   // button6
                      do_button6();}
  
                if( !strcmp( recMes.getAddress(1) , subAddress[11] ) ){   // segmentA
                      do_segmentA();}
  
                if( !strcmp( recMes.getAddress(1) , subAddress[12] ) ){   // segmentB
                      do_segmentB();}
 
                if( !strcmp( recMes.getAddress(1) , subAddress[13] ) ){   // slider4
                      do_slider4();}
                      
                if( !strcmp( recMes.getAddress(1) , "/slider5" ) ){  
                      do_slider5();}
                
                if( !strcmp( recMes.getAddress(1) , "/slider6" ) ){  
                      do_slider6();}
             
                if( !strcmp( recMes.getAddress(1) , "/button16" ) ){  
                      do_button16();}               
                      
                if( !strcmp( recMes.getAddress(1) , "/button7" ) ){  
                      do_button7();}  
                      
                if( !strcmp( recMes.getAddress(1) , "/button8" ) ){  
                      do_button8();}
                      
                if( !strcmp( recMes.getAddress(1) , "/button9" ) ){  
                      do_button9();}                                     
        }
 
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

