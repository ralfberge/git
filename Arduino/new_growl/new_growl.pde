
#include <SPI.h>
#include <Ethernet.h>
#include <NewSoftSerial.h>

byte mac[] =     { 0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };
byte ip[] =      { 192,168,0,77 };   // local Arduino IP
byte gateway[] = { 192,168,0,1 };    // IP of your gateway
byte subnet[] =  { 255,255,255,0 };   // subnet mask

byte server[] = { 62,80,29,14 }; // buero-berge.com



#define rxPin 3
#define txPin 2
NewSoftSerial mySerial(rxPin, txPin);

// Initialize the Ethernet client library
// with the IP address and port of the server 
// that you want to connect to (port 80 is default for HTTP):
Client client(server, 80);

void setup() {
   
  mySerial.begin(9600);// set the data rate for the SoftwareSerial port

  // start the Ethernet connection:
  Ethernet.begin(mac, ip, gateway, subnet);
  // start the serial library:
  Serial.begin(9600);
  // give the Ethernet shield a second to initialize:
  delay(1000);
  Serial.println("connecting...");
 
  backlightOn();
  clearLCD();  
  selectLine(1);
  mySerial.print("connecting...");
 
  // if you get a connection, report back via serial:
  if (client.connect()) {
    Serial.println("connected");
     selectLine(2);
     mySerial.print("connected");
    
    // Make a HTTP request:
    client.println("GET http://www.buero-berge.com/growlscripts/example.php/?event=Melder&app=Alarmanlage&descr=Einbruch&prior=2&user=all");
    client.println();
  } 
  else {
    // kf you didn't get a connection to the server:
    Serial.println("connection failed");
    
     selectLine(3);
     mySerial.print("connection failed");
  }
}

void loop()
{
  // if there are incoming bytes available 
  // from the server, read them and print them:
  if (client.available()) {
    char c = client.read();
    Serial.print(c);
    
     selectLine(4);
     mySerial.print(c);
  }

  // if the server's disconnected, stop the client:
  if (!client.connected()) {
    Serial.println();
    Serial.println("disconnecting.");
    client.stop();

    // do nothing forevermore:
    for(;;)
      ;
  }
}


void selectLine(int line){  //puts the cursor at line 0 char 0.
 mySerial.print(0xFE, BYTE);   //command flag

 switch (line) {
 case 1:
  mySerial.print(128, BYTE);    //position
  break;
 case 2:
  mySerial.print(192, BYTE);    //position
  break;
 case 3:
  mySerial.print(148, BYTE);    //position
  break;
 case 4:
  mySerial.print(212, BYTE);    //position
  break;
 }
}

void clearLCD(){
  mySerial.print(0xFE, BYTE);   //command flag
  mySerial.print(0x01, BYTE);   //clear command.
}
void backlightOn(){  //turns on the backlight
  Serial.print(0x7C, BYTE);   //command flag for backlight stuff
  Serial.print(157, BYTE);    //light level.
}
void backlightOff(){  //turns off the backlight
  Serial.print(0x7C, BYTE);   //command flag for backlight stuff
  Serial.print(128, BYTE);     //light level for off.
}
void serCommand(){   //a general function to call the command flag for issuing all other commands   
  Serial.print(0xFE, BYTE);
}

