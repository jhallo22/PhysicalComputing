import ddf.minim.*;
import ddf.minim.analysis.*;

import processing.serial.*;
import org.firmata.*;
import cc.arduino.*;

Serial myPort;  // Create object from Serial class
String val;     // Data received from the serial port


Arduino ardy;

Minim minim;
AudioInput in;
FFT fft;
String note;// name of the note
int n;//int value midi note
color c;//color
float hertz;//frequency in hertz
float midi;//float midi note
int noteNumber;//variable for the midi note
 
 int redVal = 0;
int greenVal = 0;
int blueVal = 0;
int sampleRate= 44100;//sapleRate of 44100
 
float [] max= new float [sampleRate/2];//array that contains the half of the sampleRate size, because FFT only reads the half of the sampleRate frequency. This array will be filled with amplitude values.
float maximum;//the maximum amplitude of the max array
float frequency;//the frequency in hertz
 
void setup()
{
  String portName = Serial.list()[0]; //change the 0 to a 1 or 2 etc. to match your port
  size(400, 200);
//  println(Arduino.list() );
//  ardy = new Arduino(this, "/dev/tty.usbmodem1431", 9600);
 println(Arduino.list());
  ardy = new Arduino(this, "/dev/tty.usbmodem1431", 57600);
  ardy.pinMode(9, Arduino.OUTPUT);
  ardy.pinMode(10, Arduino.OUTPUT);
  ardy.pinMode(11, Arduino.OUTPUT);  

  
  minim = new Minim(this);
  minim.debugOn();
  in = minim.getLineIn(Minim.MONO, 4096, sampleRate);
  fft = new FFT(in.left.size(), sampleRate);
}
 
void draw()
{
//   if ( myPort.available() > 0) 
//  {  // If data is available,
//  val = myPort.readStringUntil('\n');         // read it and store it in val
//  } 
println(val); //print it out in the console
  background(0);//black BG
 
  findNote(); //find note function
 
  textSize(50); //size of the text
 
  text (frequency-6+" hz", 50, 80);//display the frequency in hertz
  pushStyle();
  fill(c);
  text ("note "+note, 50, 150);//display the note name
  popStyle();
  
//  int micVal = myPort.analogRead(0);
  println(frequency-6+" hz", note, c);
  
    ardy.digitalWrite(9, redVal);
  ardy.digitalWrite(10, blueVal);
  ardy.digitalWrite(11, greenVal);
  
}
 
void findNote() {
 
  fft.forward(in.left);
  for (int f=0;f<sampleRate/2;f++) { //analyses the amplitude of each frequency analysed, between 0 and 22050 hertz
    max[f]=fft.getFreq(float(f)); //each index is correspondent to a frequency and contains the amplitude value 
  }
  maximum=max(max);//get the maximum value of the max array in order to find the peak of volume
 
  for (int i=0; i<max.length; i++) {// read each frequency in order to compare with the peak of volume
    if (max[i] == maximum) {//if the value is equal to the amplitude of the peak, get the index of the array, which corresponds to the frequency
      frequency= i;
    }
  }
 
 
  midi= 69+12*(log((frequency-6)/440));// formula that transform frequency to midi numbers
  n= int (midi);//cast to int
 
 
//the octave have 12 tones and semitones. So, if we get a modulo of 12, we get the note names independently of the frequency  



if (n%12==9)
  {
    note = ("a");
    c = color (255, 0, 0);
    redVal = 255;
    greenVal = 0;
    blueVal = 0;
  }
 
  if (n%12==10)
  {
    note = ("a#");
    c = color (255, 0, 80);
        redVal = 255;
    greenVal = 0;
    blueVal = 80;
  }
 
  if (n%12==11)
  {
    note = ("b");
    c = color (255, 0, 150);
    redVal = 255;
    greenVal = 0;
    blueVal = 150;
  }
 
  if (n%12==0)
  {
    note = ("c");
    c = color (200, 0, 255);
    redVal = 200;
    greenVal = 0;
    blueVal = 255;
  }
 
  if (n%12==1)
  {
    note = ("c#");
    c = color (100, 0, 255);
    redVal = 100;
    greenVal = 0;
    blueVal = 255;
  }
 
  if (n%12==2)
  {
    note = ("d");
    c = color (0, 0, 255);
    redVal = 0;
    greenVal = 0;
    blueVal = 255;
  }
 
  if (n%12==3)
  {
    note = ("d#");
    c = color (0, 50, 255);
    redVal = 0;
    greenVal = 50;
    blueVal = 255;
  }
 
  if (n%12==4)
  {
    note = ("e");
    c = color (0, 150, 255);
    redVal = 0;
    greenVal = 150;
    blueVal = 255;
  }
 
  if (n%12==5)
  {
    note = ("f");
    c = color (0, 255, 255);
    redVal = 0;
    greenVal = 255;
    blueVal = 255;
  }
 
  if (n%12==6)
  {
    note = ("f#");
    c = color (0, 255, 0);
    redVal = 0;
    greenVal = 255;
    blueVal = 0;
  }
 
  if (n%12==7)
  {
    note = ("g");
    c = color (255, 255, 0);
    redVal = 255;
    greenVal = 255;
    blueVal = 0;
  }
 
  if (n%12==8)
  {
    note = ("g#");
    c = color (255, 150, 0);
    redVal = 255;
    greenVal = 150;
    blueVal = 0;
  }
  

  
}
 
void stop()
{
  // always close Minim audio classes when you are done with them
  in.close();
  minim.stop();
 
  super.stop();
}
