

#include <stdio.h>   
#include <LiquidCrystal.h>
#include <Tone.h>

#define Kabel1 3
#define Kabel2 4
#define Kabel3 5
#define Kabel4 6
#define LED_PIN 13


#define TONE_PIN 2  // ----------------------------------- T\u00f6ne -----------------------------------
#define OCTAVE_OFFSET 0
#define NOTE_C4  262
#define NOTE_CS4 277
#define NOTE_D4  294
#define NOTE_DS4 311
#define NOTE_E4  330
#define NOTE_F4  349
#define NOTE_FS4 370
#define NOTE_G4  392
#define NOTE_GS4 415
#define NOTE_A4  440
#define NOTE_AS4 466
#define NOTE_B4  494
#define NOTE_C5  523
#define NOTE_CS5 554
#define NOTE_D5  587
#define NOTE_DS5 622
#define NOTE_E5  659
#define NOTE_F5  698
#define NOTE_FS5 740
#define NOTE_G5  784
#define NOTE_GS5 831
#define NOTE_A5  880
#define NOTE_AS5 932
#define NOTE_B5  988
#define NOTE_C6  1047
#define NOTE_CS6 1109
#define NOTE_D6  1175
#define NOTE_DS6 1245
#define NOTE_E6  1319
#define NOTE_F6  1397
#define NOTE_FS6 1480
#define NOTE_G6  1568
#define NOTE_GS6 1661
#define NOTE_A6  1760
#define NOTE_AS6 1865
#define NOTE_B6  1976
#define NOTE_C7  2093
#define NOTE_CS7 2217
#define NOTE_D7  2349
#define NOTE_DS7 2489
#define NOTE_E7  2637
#define NOTE_F7  2794
#define NOTE_FS7 2960
#define NOTE_G7  3136
#define NOTE_GS7 3322
#define NOTE_A7  3520
#define NOTE_AS7 3729
#define NOTE_B7  3951

#define isdigit(n) (n >= '0' && n <= '9')

#include "WProgram.h"
void custom5S();
void customA();
void customB();
void customE();
void customG();
void customN();
void customP();
void customR();
void customU();
void play_rtttl(char *p);
boolean checkWait();
void printscreen ( char screen[4] [21]);
void blink();
void setup();
void loop();
int notes[] = { 0,
NOTE_C4, NOTE_CS4, NOTE_D4, NOTE_DS4, NOTE_E4, NOTE_F4, NOTE_FS4, NOTE_G4, NOTE_GS4, NOTE_A4, NOTE_AS4, NOTE_B4,
NOTE_C5, NOTE_CS5, NOTE_D5, NOTE_DS5, NOTE_E5, NOTE_F5, NOTE_FS5, NOTE_G5, NOTE_GS5, NOTE_A5, NOTE_AS5, NOTE_B5,
NOTE_C6, NOTE_CS6, NOTE_D6, NOTE_DS6, NOTE_E6, NOTE_F6, NOTE_FS6, NOTE_G6, NOTE_GS6, NOTE_A6, NOTE_AS6, NOTE_B6,
NOTE_C7, NOTE_CS7, NOTE_D7, NOTE_DS7, NOTE_E7, NOTE_F7, NOTE_FS7, NOTE_G7, NOTE_GS7, NOTE_A7, NOTE_AS7, NOTE_B7
};

//char *song = "The Simpsons:d=4,o=5,b=160:c.6,e6,f#6,8a6,g.6,e6,c6,8a,8f#,8f#,8f#,2g,8p,8p,8f#,8f#,8f#,8g,a#.,8c6,8c6,8c6,c6";
//char *song = "Indiana:d=4,o=5,b=250:e,8p,8f,8g,8p,1c6,8p.,d,8p,8e,1f,p.,g,8p,8a,8b,8p,1f6,p,a,8p,8b,2c6,2d6,2e6,e,8p,8f,8g,8p,1c6,p,d6,8p,8e6,1f.6,g,8p,8g,e.6,8p,d6,8p,8g,e.6,8p,d6,8p,8g,f.6,8p,e6,8p,8d6,2c6";
char *song = "Entertainer:d=4,o=5,b=140:8d,8d#,8e,c6,8e,c6,8e,2c.6,8c6,8d6,8d#6,8e6,8c6,8d6,e6,8b,d6,2c6,p,8d,8d#,8e,c6,8e,c6,8e,2c.6,8p,8a,8g,8f#,8a,8c6,e6,8d6,8c6,8a,2d6";
//char *song = "Looney:d=4,o=5,b=140:32p,c6,8f6,8e6,8d6,8c6,a.,8c6,8f6,8e6,8d6,8d#6,e.6,8e6,8e6,8c6,8d6,8c6,8e6,8c6,8d6,8a,8c6,8g,8a#,8a,8f";
//char *song = "Bond:d=4,o=5,b=80:32p,16c#6,32d#6,32d#6,16d#6,8d#6,16c#6,16c#6,16c#6,16c#6,32e6,32e6,16e6,8e6,16d#6,16d#6,16d#6,16c#6,32d#6,32d#6,16d#6,8d#6,16c#6,16c#6,16c#6,16c#6,32e6,32e6,16e6,8e6,16d#6,16d6,16c#6,16c#7,c.7,16g#6,16f#6,g#.6";
//char *song = "MASH:d=8,o=5,b=140:4a,4g,f#,g,p,f#,p,g,p,f#,p,2e.,p,f#,e,4f#,e,f#,p,e,p,4d.,p,f#,4e,d,e,p,d,p,e,p,d,p,2c#.,p,d,c#,4d,c#,d,p,e,p,4f#,p,a,p,4b,a,b,p,a,p,b,p,2a.,4p,a,b,a,4b,a,b,p,2a.,a,4f#,a,b,p,d6,p,4e.6,d6,b,p,a,p,2b";
//char *song = "StarWars:d=4,o=5,b=45:32p,32f#,32f#,32f#,8b.,8f#.6,32e6,32d#6,32c#6,8b.6,16f#.6,32e6,32d#6,32c#6,8b.6,16f#.6,32e6,32d#6,32e6,8c#.6,32f#,32f#,32f#,8b.,8f#.6,32e6,32d#6,32c#6,8b.6,16f#.6,32e6,32d#6,32c#6,8b.6,16f#.6,32e6,32d#6,32e6,8c#6";
//char *song = "GoodBad:d=4,o=5,b=56:32p,32a#,32d#6,32a#,32d#6,8a#.,16f#.,16g#.,d#,32a#,32d#6,32a#,32d#6,8a#.,16f#.,16g#.,c#6,32a#,32d#6,32a#,32d#6,8a#.,16f#.,32f.,32d#.,c#,32a#,32d#6,32a#,32d#6,8a#.,16g#.,d#";
//char *song = "TopGun:d=4,o=4,b=31:32p,16c#,16g#,16g#,32f#,32f,32f#,32f,16d#,16d#,32c#,32d#,16f,32d#,32f,16f#,32f,32c#,16f,d#,16c#,16g#,16g#,32f#,32f,32f#,32f,16d#,16d#,32c#,32d#,16f,32d#,32f,16f#,32f,32c#,g#";
//char *song = "A-Team:d=8,o=5,b=125:4d#6,a#,2d#6,16p,g#,4a#,4d#.,p,16g,16a#,d#6,a#,f6,2d#6,16p,c#.6,16c6,16a#,g#.,2a#";
//char *song = "Flinstones:d=4,o=5,b=40:32p,16f6,16a#,16a#6,32g6,16f6,16a#.,16f6,32d#6,32d6,32d6,32d#6,32f6,16a#,16c6,d6,16f6,16a#.,16a#6,32g6,16f6,16a#.,32f6,32f6,32d#6,32d6,32d6,32d#6,32f6,16a#,16c6,a#,16a6,16d.6,16a#6,32a6,32a6,32g6,32f#6,32a6,8g6,16g6,16c.6,32a6,32a6,32g6,32g6,32f6,32e6,32g6,8f6,16f6,16a#.,16a#6,32g6,16f6,16a#.,16f6,32d#6,32d6,32d6,32d#6,32f6,16a#,16c.6,32d6,32d#6,32f6,16a#,16c.6,32d6,32d#6,32f6,16a#6,16c7,8a#.6";
//char *song = "Jeopardy:d=4,o=6,b=125:c,f,c,f5,c,f,2c,c,f,c,f,a.,8g,8f,8e,8d,8c#,c,f,c,f5,c,f,2c,f.,8d,c,a#5,a5,g5,f5,p,d#,g#,d#,g#5,d#,g#,2d#,d#,g#,d#,g#,c.7,8a#,8g#,8g,8f,8e,d#,g#,d#,g#5,d#,g#,2d#,g#.,8f,d#,c#,c,p,a#5,p,g#.5,d#,g#";
//char *song = "MahnaMahna:d=16,o=6,b=125:c#,c.,b5,8a#.5,8f.,4g#,a#,g.,4d#,8p,c#,c.,b5,8a#.5,8f.,g#.,8a#.,4g,8p,c#,c.,b5,8a#.5,8f.,4g#,f,g.,8d#.,f,g.,8d#.,f,8g,8d#.,f,8g,d#,8c,a#5,8d#.,8d#.,4d#,8d#.";
//char *song = "MissionImp:d=16,o=6,b=95:32d,32d#,32d,32d#,32d,32d#,32d,32d#,32d,32d,32d#,32e,32f,32f#,32g,g,8p,g,8p,a#,p,c7,p,g,8p,g,8p,f,p,f#,p,g,8p,g,8p,a#,p,c7,p,g,8p,g,8p,f,p,f#,p,a#,g,2d,32p,a#,g,2c#,32p,a#,g,2c,a#5,8c,2p,32p,a#5,g5,2f#,32p,a#5,g5,2f,32p,a#5,g5,2e,d#,8d";
//char *song = "KnightRider:d=4,o=5,b=125:16e,16p,16f,16e,16e,16p,16e,16e,16f,16e,16e,16e,16d#,16e,16e,16e,16e,16p,16f,16e,16e,16p,16f,16e,16f,16e,16e,16e,16d#,16e,16e,16e,16d,16p,16e,16d,16d,16p,16e,16d,16e,16d,16d,16d,16c,16d,16d,16d,16d,16p,16e,16d,16d,16p,16e,16d,16e,16d,16d,16d,16c,16d,16d,16d";

// the 8 arrays that form each segment of the custom numbers




byte LT[8] =
{
  B00111,
  B01111,
  B11111,
  B11111,
  B11111,
  B11111,
  B11111,
  B11111
};
byte UB[8] =
{
  B11111,
  B11111,
  B11111,
  B00000,
  B00000,
  B00000,
  B00000,
  B00000
};
byte RT[8] =
{
  B11100,
  B11110,
  B11111,
  B11111,
  B11111,
  B11111,
  B11111,
  B11111
};
byte LL[8] =
{
  B11111,
  B11111,
  B11111,
  B11111,
  B11111,
  B11111,
  B01111,
  B00111
};
byte LB[8] =
{
  B00000,
  B00000,
  B00000,
  B00000,
  B00000,
  B11111,
  B11111,
  B11111
};
byte LR[8] =
{
  B11111,
  B11111,
  B11111,
  B11111,
  B11111,
  B11111,
  B11110,
  B11100
};
byte UMB[8] =
{
  B11111,
  B11111,
  B11111,
  B00000,
  B00000,
  B00000,
  B11111,
  B11111
};
byte LMB[8] =
{
  B11111,
  B00000,
  B00000,
  B00000,
  B00000,
  B11111,
  B11111,
  B11111
};




Tone tone1;
LiquidCrystal lcd (12, 11, 7, 8, 9, 10);
int val; 
int n = LOW;
int PiezoRes = 3980;
int x = 2; // big Letter start
int y = 1;

int status1;
int status2;
int status3;
int status4;


char screen1[4] [21] = {"        HALLO       ", 
                        "Eine schwere Aufgabe", 
                        "   ist zu loesen!   ", 
                        "                    "};

char screen2[4] [21] = {" Welches Kabel muss ", 
                        "stecken, und welches", 
                        " darf nicht, um den ", 
                        " Code zu erhalten?  "};

char screen3[4] [21] = {"                    ", 
                        "     4 Hinweise     ", 
                        " sind zu beachten!  ", 
                        "                    "};


char screen4[4] [21] = {"1. Wenn A stecken   ", 
                        "   muss, dann muss  ", 
                        "   auch B stecken!  ", 
                        "                    "};

char screen5[4] [21] = {"2.Wenn B muss, dann ", 
                        "  muss entweder auch", 
                        "  C stecken oder A  ", 
                        "  darf nicht stecken"};    
    
                        
char screen6[4] [21] = {"3.Wenn D nicht stek-", 
                        "  ken darf, muss A  ", 
                        "  stecken und C darf", 
                        "  nicht stecken.    "};                        
                        
   
                        
                        
char screen7[4] [21] = {"4.Wenn D stecken    ", 
                        "  muss, dann muss   ", 
                        "  auch A stecken.   ", 
                        "                    "};    
                  
                                 
                  
                        
char screen8[4] [21] = {"Ueberlegen Sie gut, ", 
                        "nach aendern eines  ", 
                        "Kabels beginnt Ihr  ", 
                        "Countdown!          "};                           


char screen9[4] [21] = {"  uups...           ", 
                        "Sofort zurueck      ", 
                        "sonst beginnt der   ", 
                        "Countdown!          "}; 
                        
              


char screen10[4] [21] = {"Glueck gehabt       ", 
                         "der Countdown       ", 
                         "haette fast begonnen", 
                         "                    "}; 

    

char screen11[4] [21] = {"Auf gehts:          ", 
                         "Es bleiben Ihnen    ", 
                         "30 Sek. um die Kabel", 
                         "korrekt zu stecken! "};                         
                        
                        

    
void custom5S()
{
  lcd.setCursor(x, y);
  lcd.write(0);
  lcd.write(6);
  lcd.write(6);
  lcd.setCursor(x, y+1);
  lcd.write(7);
  lcd.write(7);
  lcd.write(5);
}



void customA()
{
  lcd.setCursor(x, y);
  lcd.write(0);
  lcd.write(6);
  lcd.write(2);
  lcd.setCursor(x, y+1);
  lcd.write(3);
  lcd.print(" ");
  lcd.write(5);
}

void customB()
{
  lcd.setCursor(x, y);
  lcd.write(0);
  lcd.write(6);
  lcd.write(5);
  lcd.setCursor(x, y+1);
  lcd.write(3);
  lcd.write(7);
  lcd.write(2);
}

void customE()
{
  lcd.setCursor(x, y);
  lcd.write(0);
  lcd.write(6);
  lcd.write(6);
  lcd.setCursor(x, y+1);
  lcd.write(3);
  lcd.write(7);
  lcd.write(7);
}

void customG()
{
  lcd.setCursor(x, y);
  lcd.write(0);
  lcd.write(1);
  lcd.write(1);
  lcd.setCursor(x, y+1);
  lcd.write(3);
  lcd.write(4);
  lcd.write(2);
}



void customN()
{
  lcd.setCursor(x, y);
  lcd.write(0);
  lcd.write(3);
  lcd.print(" ");
  lcd.write(2);
  lcd.setCursor(x, y+1);
  lcd.write(3);
  lcd.print(" ");
  lcd.write(2);
  lcd.write(5);
}

void customP()
{
  lcd.setCursor(x, y);
  lcd.write(0);
  lcd.write(6);
  lcd.write(2);
  lcd.setCursor(x, y+1);
  lcd.write(3);
}



void customR()
{
  lcd.setCursor(x, y);
  lcd.write(0);
  lcd.write(6);
  lcd.write(5);
  lcd.setCursor(x, y+1);
  lcd.write(3);
  lcd.print(" ");
  lcd.write(2);
}

void customU()
{
  lcd.setCursor(x, y);
  lcd.write(0);  
  lcd.print(" ");
  lcd.write(2);
  lcd.setCursor(x, y+1);
  lcd.write(3);  
  lcd.write(4);  
  lcd.write(5);
}
 
void play_rtttl(char *p)
{
  byte default_dur = 4;
  byte default_oct = 6;
  int bpm = 63;
  int num;
  long wholenote;
  long duration;
  byte note;
  byte scale;

  // format: d=N,o=N,b=NNN:
  // find the start (skip name, etc)

  while(*p != ':') p++;    // ignore name
  p++;                     // skip ':'

  // get default duration
  if(*p == 'd')
  {
    p++; p++;              // skip "d="
    num = 0;
    while(isdigit(*p))
    {
      num = (num * 10) + (*p++ - '0');
    }
    if(num > 0) default_dur = num;
    p++;                   // skip comma
  }


  // get default octave
  if(*p == 'o')
  {
    p++; p++;              // skip "o="
    num = *p++ - '0';
    if(num >= 3 && num <=7) default_oct = num;
    p++;                   // skip comma
  }


  // get BPM
  if(*p == 'b')
  {
    p++; p++;              // skip "b="
    num = 0;
    while(isdigit(*p))
    {
      num = (num * 10) + (*p++ - '0');
    }
    bpm = num;
    p++;                   // skip colon
  }


  // BPM usually expresses the number of quarter notes per minute
  wholenote = (60 * 1000L / bpm) * 4;  // this is the time for whole note (in milliseconds)


  // now begin note loop
  while(*p)
  {
    // first, get note duration, if available
    num = 0;
    while(isdigit(*p))
    {
      num = (num * 10) + (*p++ - '0');
    }
    
    if(num) duration = wholenote / num;
    else duration = wholenote / default_dur;  // we will need to check if we are a dotted note after

    // now get the note
    note = 0;

    switch(*p)
    {
      case 'c':
        note = 1;
        break;
      case 'd':
        note = 3;
        break;
      case 'e':
        note = 5;
        break;
      case 'f':
        note = 6;
        break;
      case 'g':
        note = 8;
        break;
      case 'a':
        note = 10;
        break;
      case 'b':
        note = 12;
        break;
      case 'p':
      default:
        note = 0;
    }
    p++;

    // now, get optional '#' sharp
    if(*p == '#')
    {
      note++;
      p++;
    }

    // now, get optional '.' dotted note
    if(*p == '.')
    {
      duration += duration/2;
      p++;
    }
  
    // now, get scale
    if(isdigit(*p))
    {
      scale = *p - '0';
      p++;
    }
    else
    {
      scale = default_oct;
    }

    scale += OCTAVE_OFFSET;

    if(*p == ',')
      p++;       // skip comma for next note (or we may be at the end)

    // now play the note

    if(note)
    {
      tone1.play( notes[(scale - 4) * 12 + note]);
      delay(duration);
      tone1.stop();
    }
    else
    {
      delay(duration);
    }
  }
}


boolean checkWait()

{
 
 for(int i = 0 ; i <= 30; i++) // fade in (from min to max) 
  { 
    if ((status1 != digitalRead(Kabel1)) || 
    (status2 != digitalRead(Kabel2)) || 
    (status3 != digitalRead(Kabel3)) || 
    (status4 != digitalRead(Kabel4)) )     { return true;}
    
   delay(100);                           
  }
 
  return false;
}



void printscreen ( char screen[4] [21])

{
  lcd.clear();
  lcd.setCursor(0, 0);

  for(int j = 0 ; j < 4; j++)
  {
   lcd.setCursor(0, j);
   for(int i = 0 ; i < 20; i++)
   { 
    lcd.print(screen[j] [i] );
   } 
  } 
}


void blink()

{

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
}






void setup() 
{ 

   // assignes each segment a write number
  lcd.createChar(0,LT);
  lcd.createChar(1,UB);
  lcd.createChar(2,RT);
  lcd.createChar(3,LL);
  lcd.createChar(4,LB);
  lcd.createChar(5,LR);
  lcd.createChar(6,UMB);
  lcd.createChar(7,LMB);

 
  
tone1.begin(2);
lcd.begin(20, 4);
pinMode(LED_PIN, OUTPUT);

 for(int i = 0 ; i <= 255; i++) // fade in (from min to max) 
  { 
    analogWrite(LED_PIN, i);           // sets the value (range from 0 to 255) 
   // delay(100);                            // waits for 30 milli seconds to see the dimming effect 
  } 


  pinMode(Kabel1, INPUT);   
  pinMode(Kabel2, INPUT);   
  pinMode(Kabel3, INPUT);   
  pinMode(Kabel4, INPUT);   



//d.print("--------------------


printscreen (screen1);
tone1.play(PiezoRes,120);
delay (5000);
blink();
delay (5000);

} 


void loop() 
{ 

start:

status1 = digitalRead(Kabel1); 
status2 = digitalRead(Kabel2); 
status3 = digitalRead(Kabel3); 
status4 = digitalRead(Kabel4); 


for(int i = 0 ; i <= 255; i++)  
 {  

tone1.play(PiezoRes,120);

printscreen (screen2);

if (checkWait()) {goto seconds;}
if (checkWait()) {goto seconds;}


tone1.play(PiezoRes,120);
printscreen (screen3);

if (checkWait()) {goto seconds;}

tone1.play(PiezoRes,120);
printscreen (screen4);

if (checkWait()) {goto seconds;}
if (checkWait()) {goto seconds;}



tone1.play(PiezoRes,120);
printscreen (screen5);

if (checkWait()) {goto seconds;}
if (checkWait()) {goto seconds;}


tone1.play(PiezoRes,120);
printscreen (screen6);

if (checkWait()) {goto seconds;}
if (checkWait()) {goto seconds;}
    
    
tone1.play(PiezoRes,120);
printscreen (screen7);

if (checkWait()) {goto seconds;}
if (checkWait()) {goto seconds;}
    
tone1.play(PiezoRes,120);
printscreen (screen8);

if (checkWait()) {goto seconds;}
if (checkWait()) {goto seconds;}
    
   
}



seconds:


printscreen (screen9);
tone1.play(PiezoRes,2000);
delay (3000);

for(int i = 0 ; i <= 100; i++)
  { 
    if ((status1 == digitalRead(Kabel1)) && 
    (status2 == digitalRead(Kabel2)) &&
    (status3 == digitalRead(Kabel3)) && 
    (status4 == digitalRead(Kabel4)) )    
   
    { 
    printscreen (screen10);
    delay (2000);
    goto start;
  }
    
    delay (100);
                         
  }
  
tone1.play(PiezoRes,1200);
printscreen (screen11);
delay (5000);


lcd.clear();
  for (int i=30; i >= 0; i--){
      lcd.setCursor(8, 1);
      lcd.print("00:");
      if (i < 10){ lcd.print("0"); }
      lcd.print(i);
            tone1.play(PiezoRes,120);
      delay(1000);
   } 

 lcd.clear();
 
 
 
 //  ______________________________________Stecken alle Stecke richtig?______________________________
 
 if ((digitalRead(Kabel1) == LOW) && 
    ( digitalRead(Kabel2) == LOW) &&
    ( digitalRead(Kabel3) == LOW) &&  
    ( digitalRead(Kabel4) == LOW) )     
    
    { 
    
   x = 0;
  y = 1;
  
  custom5S();
  x = x + 4;
  customU();
  x = x + 4;
  customP();
  x = x + 4;
  customE();
  x = x + 4;
  customR();
  x = x + 4;
  
blink();


play_rtttl(song);
delay (2000);

blink();


}

else
  {
    
     x = 2;
   y = 1;
  
  customB();
  x = x + 4;
  customA();
  x = x + 4;
  customN();
  x = x + 5;
  customG();
  x = x + 4;
  
  
blink;

 for (int i=100; i >= 10; i--){
      tone1.play(i*10,20);
      delay(20);
   } 
blink;

}

delay(3000);
    
 

}  // loop




/*

void custom0O()
{ // uses segments to build the number 0
  lcd.setCursor(x, y);
  lcd.write(0);  
  lcd.write(1);
  lcd.write(2);
  lcd.setCursor(x, y+1);
  lcd.write(3);  
  lcd.write(4);  
  lcd.write(5);
}

void custom1()
{
  lcd.setCursor(x, y);
  lcd.write(1);
  lcd.write(2);
  lcd.setCursor(x+1,1);
  lcd.write(5);
}

void custom2()
{
  lcd.setCursor(x, y);
  lcd.write(6);
  lcd.write(6);
  lcd.write(2);
  lcd.setCursor(x, y+1);
  lcd.write(3);
  lcd.write(7);
  lcd.write(7);
}

void custom3()
{
  lcd.setCursor(x, y);
  lcd.write(6);
  lcd.write(6);
  lcd.write(2);
  lcd.setCursor(x, y+1);
  lcd.write(7);
  lcd.write(7);
  lcd.write(5);
}

void custom4()
{
  lcd.setCursor(x, y);
  lcd.write(3);
  lcd.write(4);
  lcd.write(2);
  lcd.setCursor(x+2, 1);
  lcd.write(5);
}

void custom6()
{
  lcd.setCursor(x, y);
  lcd.write(0);
  lcd.write(6);
  lcd.write(6);
  lcd.setCursor(x, y+1);
  lcd.write(3);
  lcd.write(7);
  lcd.write(5);
}

void custom7()
{
  lcd.setCursor(x, y);
  lcd.write(1);
  lcd.write(1);
  lcd.write(2);
  lcd.setCursor(x+1, 1);
  lcd.write(0);
}

void custom8()
{
  lcd.setCursor(x, y);
  lcd.write(0);
  lcd.write(6);
  lcd.write(2);
  lcd.setCursor(x, y+1);
  lcd.write(3);
  lcd.write(7);
  lcd.write(5);
}

void custom9()
{
  lcd.setCursor(x, y);
  lcd.write(0);
  lcd.write(6);
  lcd.write(2);
  lcd.setCursor(x+2, 1);
  lcd.write(5);
}

void customC()
{
  lcd.setCursor(x, y);
  lcd.write(0);
  lcd.write(1);
  lcd.write(1);
  lcd.setCursor(x, y+1);
  lcd.write(3);
  lcd.write(4);
  lcd.write(4);
}

void customD()
{
  lcd.setCursor(x, y);
  lcd.write(2);  
  lcd.write(1);
  lcd.write(2);
  lcd.setCursor(x, y+1);
  lcd.write(5);  
  lcd.write(4);  
  lcd.write(5);
}



void customF()
{
  lcd.setCursor(x, y);
  lcd.write(0);
  lcd.write(6);
  lcd.write(6);
  lcd.setCursor(x, y+1);
  lcd.write(3);
}


void customH()
{
  lcd.setCursor(x, y);
  lcd.write(0);
  lcd.write(4);
  lcd.write(2);
  lcd.setCursor(x, y+1);
  lcd.write(3);
  lcd.print(" ");
  lcd.write(5);
}

void customI()
{
  lcd.setCursor(x, y);
  lcd.write(1);
  lcd.write(2);
  lcd.write(1);
  lcd.setCursor(x, y+1);
  lcd.write(4);
  lcd.write(5);
  lcd.write(4);
}

void customJ()
{
  lcd.setCursor(x+2,0);
  lcd.write(2);
  lcd.setCursor(x, y+1);
  lcd.write(4);
  lcd.write(4);
  lcd.write(5);
}

void customK()
{
  lcd.setCursor(x, y);
  lcd.write(0);
  lcd.write(4);
  lcd.write(5);
  lcd.setCursor(x, y+1);
  lcd.write(3);
  lcd.print(" ");
  lcd.write(2);
}

void customL()
{
  lcd.setCursor(x, y);
  lcd.write(0);
  lcd.setCursor(x, y+1);
  lcd.write(3);
  lcd.write(4);
  lcd.write(4);
}

void customM()
{
  lcd.setCursor(x, y);
  lcd.write(0);
  lcd.write(1);
  lcd.write(3);
  lcd.write(1);
  lcd.write(2);
  lcd.setCursor(x, y+1);
  lcd.write(3);
  lcd.print("   ");
  lcd.write(5);
}

void customQ()
{
  lcd.setCursor(x, y);
  lcd.write(0);
  lcd.write(1);
  lcd.write(2);
  lcd.setCursor(x, y+1);
  lcd.write(3);
  lcd.write(4);
  lcd.write(3);
  lcd.write(4);
}


void customT()
{
  lcd.setCursor(x, y);
  lcd.write(1);
  lcd.write(2);
  lcd.write(1);
  lcd.setCursor(x, y+1);
  lcd.print(" ");
  lcd.write(5);
}



void customV()
{
  lcd.setCursor(x, y);
  lcd.write(3);  
  lcd.print("  ");
  lcd.write(5);
  lcd.setCursor(x+1, 1);
  lcd.write(3);  
  lcd.write(5);
}

void customW()
{
  lcd.setCursor(x, y);
  lcd.write(0);
  lcd.print("   ");
  lcd.write(2);
  lcd.setCursor(x, y+1);
  lcd.write(3);
  lcd.write(4);
  lcd.write(0);
  lcd.write(4);
  lcd.write(5);
}

void customX()
{
  lcd.setCursor(x, y);
  lcd.write(3);
  lcd.write(4);
  lcd.write(5);
  lcd.setCursor(x, y+1);
  lcd.write(0);
  lcd.print(" ");
  lcd.write(2);
}

void customY()
{
  lcd.setCursor(x, y);
  lcd.write(3);
  lcd.write(4);
  lcd.write(5);
  lcd.setCursor(x+1,1);
  lcd.write(5);
}

void customZ()
{
  lcd.setCursor(x, y);
  lcd.write(1);
  lcd.write(6);
  lcd.write(5);
  lcd.setCursor(x, y+1);
  lcd.write(0);
  lcd.write(7);
  lcd.write(4);
}


*/

int main(void)
{
	init();

	setup();
    
	for (;;)
		loop();
        
	return 0;
}

