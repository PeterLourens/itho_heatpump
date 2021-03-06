#include <Wire.h>

void setup() {

  Wire.begin(0x40);
  Wire.onReceive(receiveEvent);
  Serial.begin(9600);
}

void loop() {

}


// function that executes whenever data is received from master
// this function is registered as an event, see setup()

void receiveEvent(int howMany)
{
  while(1 < Wire.available()) // loop through all but the last
  {
    int c = Wire.read(); // receive byte as a character
    Serial.print(c);         // print the character
  }
  int x = Wire.read();    // receive byte as an integer
  Serial.println(x);         // print the integer
}
