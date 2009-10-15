#include "WProgram.h"
void setup();
void loop();
void blink();
int pin = 13;
volatile int state = LOW;

void setup()
{
  pinMode(pin, OUTPUT);
  attachInterrupt(0, blink, FALLING);
}

void loop()
{
  digitalWrite(pin, state);
}

void blink()
{
  state = !state;
}
int main(void)
{
	init();

	setup();
    
	for (;;)
		loop();
        
	return 0;
}

