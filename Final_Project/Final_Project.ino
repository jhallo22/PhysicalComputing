#include <Servo.h> 
 
Servo myservo;  // create servo object to control a servo 
                // a maximum of eight servo objects can be created 
 
int pos = 0;    // variable to store the servo position 
int lightPin = 0;
int led13 = 13;

void setup(){ 
  myservo.attach(9);  // attaches the servo on pin 9 to the servo object 
  Serial.begin(9600);
  pinMode(led13, INPUT);
  
  
} 


void loop(){
  
  int lightLevel = analogRead(lightPin); //read the current voltage at lightPin(0)
  
  lightLevel = map(lightLevel, 0, 700, 0, 359);
  pos = constrain(lightLevel, 0, 359);

  myservo.write(pos); // set the servo angle 
  lightLevel = constrain(lightLevel, 0, 255);
  Serial.println(lightLevel); // tell me what the current light reading is (from 0-255)
 
  if(lightLevel > 245)  // reads the light level 
  {
    myservo.write(120);              // tell servo to goes from 0 degrees to 180 degrees 
    digitalWrite(led13, HIGH);       // turn on LED
    delay(15);                       // waits 15ms for the servo to reach the position 
    Serial.println("LightOn");       // Tell me if LED is on 
  } 
  if(lightLevel < 245)     // reads the light level 
  {                                
    myservo.write(80);              // tell servo to goes from 180 degrees to 0 degrees 
    digitalWrite(led13, LOW);      // turn off LED
    delay(15);                     // waits 15ms for the servo to reach the position 
    Serial.println("LightOff");    // tell me if LED is off
  } 
}

