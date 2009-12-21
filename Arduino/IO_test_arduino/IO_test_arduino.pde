// OSCClass IOtest Arduino sketch
// OSCClass version 1.0.1 (Arduino ver0014)
// Copyright (c) recotana(http://recotana.com).  All right reserved.

#include "Ethernet.h"
#include "OSCClass.h"

#define  SW_PIN  3
#define  LED_PIN 2
#define  POT_PIN  0

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
  char *subAddress[3]={ "/led" , "/switch" , "/pot" };
  
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
     
}

void loop() {

    //osc arrive check
    if ( osc.available() ) {

          //toplevel address matching
          if( !strcmp( recMes.getAddress(0) , topAddress ) ){
                            
              //second level address matching           
                if( !strcmp( recMes.getAddress(1) , subAddress[0] ) ){
                           
                      ledProcess();
                
                }
  
          }
 
    }
    
    swProcess();
    
    potProcess();
    

}

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


void swProcess(){
 
 if( !digitalRead(SW_PIN) ){
   
  long value = 1;
  
  sendMes.setSubAddress( subAddress[1] ); // "/ard/switch"
  sendMes.setArgs( "i", &value );
  osc.sendOsc( &sendMes );
  
//  Serial.print("switch ON!");

 }
   
}

void potProcess(){
  
  int pot=analogRead(POT_PIN);  //adc data = 10bit data
  
  long value=(long)(pot>>2); // delete 1,0 bit  -> adc data max 0x00ff
  
  if( oldPotValue != value ){
  
    sendMes.setSubAddress( subAddress[2] ); // "/ard/pot"
    sendMes.setArgs( "i", &value );
    osc.sendOsc( &sendMes );
  
//    Serial.print("pot:");
//    Serial.println(value);
  }
  oldPotValue = value;
 
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
