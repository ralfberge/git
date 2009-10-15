int pin = 13;
int state = LOW;

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
