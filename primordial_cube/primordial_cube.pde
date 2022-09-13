// /*
//  * This sketch demonstrates the application of the fast Fourier transform (FFT) algorithm
//  * In particular, cube-composed pseudo concentric, expanding, rotating circles
//  * are generated as a function of the amplitude and frequency components of the input signal
//  * The input signal referenced: Bonobo - Elysian;
//  * (This sketch was adapted from Benjamin Farahmand - Atomic Sprocket)
//  */

import com.hamoid.*;
import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;
AudioPlayer player;
AudioInput in;
FFT fft;
float[] x, y, angle;
 
void setup() {
  
  // Set visualization to fullscreen, specifying the P3D renderer
  fullScreen(P3D);
  
  // Initialize an instance of the minim class
  minim = new Minim(this);
  
  // Load music to play and visualize:
  player = minim.loadFile("primordial_cube_mix_1.mp3");
  
  // Create an FFT object that has a time-domain bufferSize and sampleRate of player
  // according to the Nyquist frequency, the size of the spectrum will be bufferSize/2
  fft = new FFT(player.bufferSize(), player.sampleRate()); 
  
  y = new float[fft.specSize()];
  x = new float[fft.specSize()];
  angle = new float[fft.specSize()]; 

  player.loop();
}
 
void draw(){
  
  // Center visualization on screen
  translate(displayWidth/2, displayHeight/2);
  
  // Set black background for each frame
  background(0);
  
  // Perform a forward FFT on the samples in the player's mix buffer,
  // which contains the mix of both the left and right channels of the audio file
  fft.forward(player.mix);
 
  circusOfCriclesTAL0();
  
} 

void circusOfCriclesTAL0(){
  
  // box1Algo: Twins
  for(int i = 0; i < fft.specSize(); i++){
    scale(1,1);
    x[i] = x[i] + fft.getFreq(i)/1000;
    y[i] = y[i] + fft.getBand(i)/1000;
    angle[i] = angle[i] + fft.getFreq(i)/100000;
    rotateX(sin(angle[i]/2));
    rotateY(cos(angle[i]/2));
    rotateZ(tan(angle[i]/2));
    noFill();
    stroke(#FBFCFC);
    strokeWeight(1.5);
    pushMatrix();
    translate((x[i]+250) % width, (y[i]+250) % height);
    box(fft.getBand(i)/20+fft.getFreq(i)/15);
    popMatrix();
  }
  
  // box2Algo: Base
  for(int i = 0; i < fft.specSize(); i++){
    scale(-1, 1);
    x[i] = x[i] + fft.getFreq(i)/1000;
    y[i] = y[i] + fft.getBand(i)/1000;
    angle[i] = angle[i] + fft.getFreq(i)/100000;
    rotateX(sin(angle[i]/2));
    rotateY(cos(angle[i]/2));
    rotateZ(tan(angle[i]/2));
    stroke(#85C1E9);
    fill(#85C1E9);
    pushMatrix();
    translate((x[i]+250) % width, (y[i]+250) % height);
    box(fft.getBand(i)/20+fft.getFreq(i)/15);
    popMatrix();
  }
}

void stop(){
  
  // Close Minim audio classes:
  player.close();
  minim.stop();
  super.stop();
}
