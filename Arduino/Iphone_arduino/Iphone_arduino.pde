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


const int Mac250_zuenden = 230;
const int Mac250_reset = 210;
const int Mac250_Shutteroffen = 240;
const int Mac250_Shutterzu = 0;
const int Mac250_loeschen = 255;

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
const int Mac250Kanal_Fokus = 8;
const int Mac250Kanal_Gobo = 4;



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





  OSCMessage recMes;
  OSCMessage sendMes;
  
  OSCClass osc(&recMes);

  byte serverMac[] = { 0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };
  byte serverIp[]  = { 192, 168, 0, 77 };
  int  serverPort  = 8000;
  
//  byte gateway[]   = { 192, 168, 0, 1 };
//  byte subnet[]    = { 255, 255, 255, 0 };


  byte destIp[]  = { 192, 168, 0, 79};
  int  destPort = 8000;
  
  char *topAddress="/ard";
  char *subAddress[12]={ "/xpos", "/ypos", "/slider1", "/slider2", "/slider3", 
                         "/button1", "/button2", "/button3", 
                         "/button4", "/button5", "/button6",};
                      
                         /*
                     "/button7", 
                        
                        
                        
                            /*
                        "/button8", "/button9",
                         
                        
                         "/button10", "/button11", "/button12"};
  
  
  */
  
  boolean ledFlag;
  boolean  swFlag;
  long    oldPotValue;
  
  
  
void setup() {
  
       //for message logging
     Serial.begin(9600);
     Serial.println();
     Serial.println( "Arduino OSC to DMX Vers. 1.1 " );
     Serial.println();
     Serial.println();
  
  Serial.print( "Setting up web server... " );
    
      Ethernet.begin(serverMac ,serverIp);
 //    Ethernet.begin(serverMac ,serverIp ,gateway ,subnet);
    Serial.println( "done." );
  
     //setting osc recieve server
   Serial.print( "Setting up OSC server... " );
   osc.begin(serverPort);
   Serial.println( "done." );
   
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

    //osc arrive check
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
  
               /*
               if( !strcmp( recMes.getAddress(1) , subAddress[11] ) ){   // button7
                      do_button7();}
                      
                if( !strcmp( recMes.getAddress(1) , subAddress[12] ) ){   // button8
                      do_button8();}
  
                if( !strcmp( recMes.getAddress(1) , subAddress[13] ) ){   // button9
                      do_button9();}
  
                if( !strcmp( recMes.getAddress(1) , subAddress[14] ) ){   // button10
                      do_button10();}
  
                if( !strcmp( recMes.getAddress(1) , subAddress[15] ) ){   // button11
                      do_button11();}
                
                 if( !strcmp( recMes.getAddress(1) , subAddress[16] ) ){   // button12
                      do_button12();}
                
                */
                
          }
 
    }
    
 

}



void do_xpos(){
  

  
  
  float data = recMes.getArgFloat(0);
  
  Serial.print( "xpos: " );
  Serial.println( (data) );
 
  DmxSimple.write(Mac250Kanal_Pan, data*255 );  
   

}

void do_ypos(){
  
  float data = recMes.getArgFloat(0);
 
  Serial.print( "ypos: " );
  Serial.println( data );
  
 
  DmxSimple.write(Mac250Kanal_Tilt, (data  * 255) );  
  
}


void do_slider1(){
  
  //Serial.print( subAddress[0] );
  
  
  float data = recMes.getArgFloat(0);
 
  Serial.print( "slider1: " );
  Serial.print( (data) );
  Serial.print( "   :  ");
  Serial.println( (data  * 255) );
  
  DmxSimple.write(Mac250Kanal_Dimmer, (data * 255) );  
  
}

void do_slider2(){
  
  //Serial.print( subAddress[0] );
  
  
  float data = recMes.getArgFloat(0);
  
  
  Serial.print( "slider2: " );
  Serial.println( (data) );
  
  DmxSimple.write(Mac250Kanal_Fokus, (data* 255) );  
  
}

void do_slider3(){
  
  //Serial.print( subAddress[0] );
  
  
  long data = recMes.getArgInt(0);
 
  
}



void do_button1(){
  
  long data = recMes.getArgInt(0);
  Serial.print( "button: ");
  Serial.println (data );
  DmxSimple.write(Mac250Kanal_Farbe, Mac250_rot);  

 
  
}




void do_button2(){
  
  long data = recMes.getArgInt(0);
  Serial.print( "button: ");
  Serial.println(data );
    
  DmxSimple.write(Mac250Kanal_Farbe, Mac250_gruen); 
 
  
}



void do_button3(){
  
  long data = recMes.getArgInt(0);
  Serial.print( "button: ");
  Serial.println(data );
    
  DmxSimple.write(Mac250Kanal_Farbe, Mac250_blau); 
 
  
}


void do_button4(){
  
  long data = recMes.getArgInt(0);
  Serial.print( "button: ");
  Serial.println(data );
    
  DmxSimple.write(Mac250Kanal_Dimmer, 255);   
  DmxSimple.write(Mac250Kanal_Shutter, Mac250_zuenden); 
 
  
}


void do_button5(){
  
  long data = recMes.getArgInt(0);
  Serial.print( "button: ");
  Serial.println(data );
    
  DmxSimple.write(Mac250Kanal_Shutter, Mac250_Shutteroffen); 
 
  
}


void do_button6(){
  
  long data = recMes.getArgInt(0);
  Serial.print( "button: ");
  Serial.println(data );
    
  DmxSimple.write(Mac250Kanal_Dimmer, 255 );    
  DmxSimple.write(Mac250Kanal_Shutter, Mac250_loeschen);
 
  
}


/*
void do_button7(){
  
  long data = recMes.getArgInt(0);
  Serial.print( "button: ");
  Serial.println(data );
 
  
}


void do_button8(){
  
  long data = recMes.getArgInt(0);
  Serial.print( "button: ");
  Serial.println(data );
 
  
}
void do_button9(){
  
  long data = recMes.getArgInt(0);
  Serial.print( "button: ");
  Serial.println(data );
 
  
}

void do_button10(){
  
  long data = recMes.getArgInt(0);
  Serial.print( "button: ");
  Serial.println(data );
 
   DmxSimple.write(Mac250Kanal_Shutter, Mac250_zuenden); 
  
}

void do_button11(){
  
  long data = recMes.getArgInt(0);
  Serial.print( "button: ");
  Serial.println(data );
 
  DmxSimple.write(Mac250Kanal_Shutter, Mac250_Shutteroffen); 
  
}

void do_button12(){
  
  long data = recMes.getArgInt(0);
  Serial.print( "button: ");
  Serial.println(data );
 
   DmxSimple.write(Mac250Kanal_Dimmer, 255 );    
   DmxSimple.write(Mac250Kanal_Shutter, Mac250_loeschen);
  
}

*/

void ledProcess(){
  
  Serial.print( subAddress[0] );
  
  
  long data = recMes.getArgInt(0);
  Serial.println( "led process: " );
  Serial.println(data );
  
 if(ledFlag){  
    ledFlag=false;
    digitalWrite(LED_PIN, HIGH);  //LED_OFF
 }
 else{
    ledFlag=true;
    digitalWrite(LED_PIN, LOW);  //LED ON
 }
  
}





// *********  utility  ***********************************

/*
void logMessage(OSCMessage *mes){
  
    uint8_t *ip=mes->getIp();
  
     //disp ip & port
    Serial.print("from IP:");
    Serial.print(ip[0],DEC);
    Serial.print(".");
    Serial.print(ip[1],DEC);
    Serial.print(".");
    Serial.print(ip[2],DEC);
    Serial.print(".");
    Serial.print(ip[3],DEC);
    Serial.print(" port:");
    Serial.print(mes->getPort(),DEC);
    Serial.print("   ");
    
    //disp adr
    for(int i = 0 ; i < mes->getAddressNum() ; i++){
      
      Serial.print(mes->getAddress(i));
      
    }
    
    
    //disp type tags
    Serial.print("  ,");
    for(int i = 0 ; i < mes->getArgNum() ; i++){
      
      Serial.print(mes->getTypeTag(i));
      
    }
    Serial.print(" ");
   
   
   //disp args
    for(int i = 0 ; i < mes->getArgNum() ; i++){
      
      switch( mes->getTypeTag(i) ){
        
        case 'i': {
                      
                      Serial.print( mes->getArgInt(i) );
                  }
          break;
        
        case 'f':  {
                      
                      Serial.print( mes->getArgFloat(i) );
                  }
          break;
         
      }
      
       Serial.print(" ");
      
    }
    
    Serial.println(""); 
    
}
*/
