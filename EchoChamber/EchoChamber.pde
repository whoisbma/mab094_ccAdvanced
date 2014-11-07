import ddf.minim.analysis.*;
import ddf.minim.*;
Minim minim;
AudioInput in; 
FFT fft;

int count = 0; 
AudioRecorder recorder; 

AudioPlayer player; 

float[] storedAvg = new float[63]; 
float[] storedVols = new float[80]; 

float[][] storedFFT = new float[80][63];

boolean spacePress = false;

PImage fade; 

int w;

float rWidth;
float rHeight;

float volume = 0; 
float combinedValues = 0; 

float hVal;

void setup() {
  background(0); 
  size(1000, 700, P3D); 
  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, 512); 
  fft = new FFT(in.bufferSize(), in.sampleRate());

  fft.logAverages(60, 7);

  w = width/fft.avgSize();
  strokeWeight(w);
  strokeCap(SQUARE);

  rWidth = width * 0.99; 
  rHeight = height * 0.995;
  fade = get(0, 0, width, height);
  hVal = 0; 

  recorder = minim.createRecorder(in, count+".wav");
} 

void draw() {
  background(10); 
  lights();

  fft.forward(in.mix); 
  combinedValues = 0; 
  for (int i = 0; i < fft.avgSize (); i++) {
    combinedValues += fft.getAvg(i);
  } 
  volume = combinedValues / fft.avgSize(); 
  if ( volume > 1 ) {
    if (!recorder.isRecording() ) {
      recorder.beginRecord();
    }
    for (int i = 0; i < fft.avgSize (); i++) {
      storedAvg[i] = fft.getAvg(i);
    }

    //store last 100 volumes over the threshold
    storedVols[storedVols.length-1] = volume;
    for (int i = 0; i < storedVols.length-1; i++) {
      storedVols[i] = storedVols[i+1];
    }
  } else if (recorder.isRecording() ) {
    recorder.endRecord();
  } 

  for (int i = 0; i < storedFFT[0].length; i++) {
    storedFFT[storedFFT.length-1][i] = fft.getAvg(i);
  }
  for (int i = 0; i < storedFFT.length-1; i++) {
    for (int j = 0; j < storedFFT[0].length; j++) {
      storedFFT[i][j] = storedFFT[i+1][j];
    }
  }

  //clear the array
  if (spacePress == true) {
    for (int i = 0; i < storedVols.length; i++) {
      storedVols[i] = 0;
    } 
    spacePress = false;
  } 

  pushMatrix();
  translate(width/2-20, height/2-10, 350);
  rotateX(radians(169));
  rotateY(radians(116));
  //println(mouseX); 

  for (int i = 0; i < storedFFT.length-1; i++) {
    for (int j = storedFFT[0].length-2; j >= 0; j--) {
      pushMatrix();
      translate(i * 2, 0, j*2);
      noStroke();
      float c = map(storedFFT[i][j],0,40,150,255);
      float a = map(i,0,80,0,250);
      float g = map(j,0,63,0,255); 
      float b = map(storedFFT[i][0],0,100,0,255);
      //float aa = map(storedFFT[i][j],0,100,0,50);
      //box(2, storedFFT[i][j]*2, 2);
      fill(c,g,a-20,a);

      beginShape(); 
      vertex(0,storedFFT[i][j]*2,0); 
      vertex(2,storedFFT[i+1][j]*2,0);
      vertex(0,storedFFT[i][j+1]*2,2);
      endShape(); 
      
      beginShape(); 
      vertex(2,storedFFT[i+1][j]*2,0); 
      vertex(0,storedFFT[i][j+1]*2,2);
      vertex(2,storedFFT[i+1][j+1]*2,2);
      endShape(); 

      popMatrix();
    }
  }




  for (int i = 0; i < storedVols.length; i++) {
    pushMatrix();
    fill(255, 0, 0, 50);
    translate(i*2, 0, 140);
    box(2, storedVols[i]*2, 10);
    popMatrix();
  } 
  popMatrix();
}

void keyPressed() {
  if (key == ' ') {
    spacePress = true;
    recorder.save();
    player = minim.loadFile(count+".wav");
    //blobs.add(new Createblob(storedVols, player));
    count++; 
    recorder = minim.createRecorder(in, count+".wav");
  }
} 

void keyReleased() {
  if (key == ' ') {
    spacePress = false;
  }
}

void stop() {
  minim.stop();
}

