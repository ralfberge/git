#include <DmxSimple.h>

 const int delay_schleife = 60;
 const int delay_ot = 1000;
 int brightness;  

void setup() {
}

void loop() {
  

for (brightness = 0; brightness <= 255; brightness++) 
  {
    DmxSimple.write(4, 255-brightness); // Set DMX channel 4 to new value
    DmxSimple.write(1, brightness); // Set DMX channel 1 to new value
     delay(delay_schleife);
  }
  delay(delay_ot);


for (brightness = 0; brightness <= 255; brightness++) 
  {
    DmxSimple.write(1, 255-brightness); // Set DMX channel 4 to new value
    DmxSimple.write(2, brightness); // Set DMX channel 1 to new value
     delay(delay_schleife);
  }
  delay(delay_ot);


for (brightness = 0; brightness <= 255; brightness++) 
  {
    DmxSimple.write(2, 255-brightness); // Set DMX channel 4 to new value
    DmxSimple.write(3, brightness); // Set DMX channel 1 to new value
     delay(delay_schleife);
  }
  delay(delay_ot);


for (brightness = 0; brightness <= 255; brightness++) 
  {
    DmxSimple.write(3, 255-brightness); // Set DMX channel 4 to new value
    DmxSimple.write(4, brightness); // Set DMX channel 1 to new value
     delay(delay_schleife);
  }
  delay(delay_ot);
  

}
