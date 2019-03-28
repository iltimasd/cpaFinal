import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

import processing.video.*;

// Processing Textmode Engine
// Version 0.1 (initial release)
// by Don Miller / NO CARRIER
// http://www.no-carrier.com
// Have fun! :)

PFont font;       // textmode font
PGraphics b;      // screen buffer
PImage img;       // used for face.png

Movie mov;
Minim       minim;
AudioOutput out;
Oscil       wave;
Oscil       wave2;
Oscil       wave3;
Oscil       wave4;


Wavetable[]   table = new Wavetable[4];

float[][] tableStore = new float[48][64];

int   segSize = 4;     // segment size, see renderTextMode tab for (lots) more detail 
int display = 1;  // choose which demo to display, starts with face image
float tick;       // counter, used for sin calcuations for shape rotation

boolean doDraw = true;      // draw or pause
boolean blockMode = false;
boolean fps = false;        // show FPS oboolean textMode = true;    // show buffer (stretched to fit screen) or textmode
void movieEvent(Movie movie) {
  mov.read();
}
void setup() {
  size(1024, 768, P2D);     // need to use P2D as renderer, as we use P3D for buffer
  mov = new Movie(this, "vid.mp4");
  mov.loop();
  img = loadImage("face.png");
  //noSmooth();               // keep it blocky :)
  // noCursor();               // don't need this!
  initTextmode();           // set up buffer, load font for textmode output
  //mov.volume(0);

  minim = new Minim(this);

  // use the getLineOut method of the Minim object to get an AudioOutput object
  out = minim.getLineOut();
  //table[0] = WavetableGenerator.gen10(4096, new float[] {1, random(-1, 1), random(-1, 1), random(-1, 1) });  

  // create a reasonably complex waveform to start, will be slightly different every time
  for (int i=0; i<4; i++) {
    table[i] = Waves.randomNHarms(16);
  }

  wave  = new Oscil( 400, 0.002f, table[0] );
  wave2 = new Oscil( 503.32, 0.002f, table[1] );
    wave3 = new Oscil( 599.32, 0.002f, table[2] );
    wave4=  new Oscil( 712.72, 0.002f, table[3] );


  //table = WavetableGenerator.gen10(4096, new float[] { 1, 0.5, 0.2 });

  // patch the Oscil to the output
  wave.patch( out );
  wave2.patch( out );
  wave3.patch( out );
  wave4.patch( out );
}

void draw() {


  // patch the Oscil to the output
  float newSpeed = map(mouseX, 0, width, 0.1, 2);
  mov.speed(.5);
  b.beginDraw();
  b.image(mov, 0, 0);           // let's show off the textmode engine, shall we?
  b.endDraw();
  fill(255);
  text(nfc(newSpeed, 2) + "X", 10, 30); 
  background(0);
  renderTextMode();     // display textmode...

  for (int i=0; i<4; i++) {

    table[i].setWaveform(  WavetableGenerator.gen10(4096, tableStore[i*12]).getWaveform() );
    table[i].smooth( 64 );
  }




  // draw the waveform we are using in the oscillator
  stroke( 255, 0, 0 );
  strokeWeight(4);
  for ( int i = 0; i < width-1; ++i )
  {
    point( i, height/2 - (height*0.49) * table[0].value( (float)i / width ) );
  }
   stroke( 200,0,0 );
  for ( int i = 0; i < width-1; ++i )
  {
    point( i, height/2 - (height*0.49) * table[1].value( (float)i / width ) );
  }
     stroke( 150, 0, 0 );

    for ( int i = 0; i < width-1; ++i )
  {
    point( i, height/2 - (height*0.49) * table[2].value( (float)i / width ) );
  }
  
       stroke( 100, 0, 0 );

    for ( int i = 0; i < width-1; ++i )
  {
    point( i, height/2 - (height*0.49) * table[3].value( (float)i / width ) );
  }
  //println(frameRate);
}



void keyPressed() {
  //switch( key )
  //{
  //case 'n':
  //  // scale the table so that the largest value is -1/1.
  //  table.normalize();
  //  break;

  //case 's':
  //  // smooth out the table, similar to applying a low pass filter
  //  table.smooth( 64 );
  //  break;

  //case 'r':
  //  // change all negative values to positive values
  //  table.rectify();
  //  break;

  //case 'z':
  //  // add some noise
  //  table.addNoise( 0.1f );
  //  break;

  //case 'q':
  //  table.scale( 1.1f );
  //  break;

  //case 'a':
  //  table.scale( 0.9f );
  //  break;

  //default: 
  //  break;
  //}
}
