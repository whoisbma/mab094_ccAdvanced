import ddf.minim.analysis.*;
import ddf.minim.*;
import processing.pdf.*;

Minim minim;
AudioInput in; 
FFT fft;
AudioRecorder recorder; 
AudioPlayer player; 

ArrayList<MeshCube> savedCubes; 

int count = 0; 
static int maxSamples = 12;
static int maxRange = 40; 
static float sampleSize = 25;
static float rangeSize = 7; 
static float cubeSize = 20; 
static float heightMod = 5;

int counter = 0;
float randX = 300;
float randY = 300; 
float redSize = 0;
float randYrot = 0;
float randXrot = 0; 

float[][] savedFFT = new float[maxRange][maxSamples]; 

boolean spacePress = false;

float volume = 0; 
float combinedValues = 0; 


boolean recordPDF = false; 

void setup() {
  background(0); 
  frameRate(60);
  size(1000, 700, P3D); 
  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, 512); 
  fft = new FFT(in.bufferSize(), in.sampleRate());

  fft.logAverages(54, 2);
  //fft.linAverages(maxSamples);

  recorder = minim.createRecorder(in, count+".wav");
  //recorder.save();
  player = minim.loadFile(count+".wav");

  //  player = minim.loadFile(count+".wav");
  //  recorder = minim.createRecorder(in, count+".wav");

  savedCubes = new ArrayList<MeshCube>();
} 

void draw() {
  if (recordPDF) {
    String timestamp = year() + nf(month(), 2) + nf(day(), 2) + "-"  + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2);
    beginRaw(PDF, timestamp+".pdf");
  }

  background(255); 


  camera(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0), width/2.0, height/2.0, 0, 0, 1, 0);
  lights();

  fft.forward(in.mix); 
  //  combinedValues = 0; 
  //  int avg = 0;
  //  for (int i = 0; i < fft.avgSize (); i++) {
  //    combinedValues += fft.getAvg(i);
  //    avg++;

  //  } 
  //  println(avg);
  //  volume = combinedValues / fft.avgSize(); 

  if (spacePress == true) {
    if (!recorder.isRecording() ) {
      recorder.beginRecord();
    }
    for (int i = 0; i < savedFFT[0].length; i++) {
      savedFFT[savedFFT.length-1][i] = fft.getAvg(i);
    }
    for (int i = 0; i < savedFFT.length-1; i++) {
      for (int j = 0; j < savedFFT[0].length; j++) {
        savedFFT[i][j] = savedFFT[i+1][j];
      }
    }
  } else if (recorder.isRecording() ) {
    recorder.endRecord();
  } 

  for (int i = 0; i < savedCubes.size (); i++) {
    MeshCube cube = savedCubes.get(i);
    pushMatrix(); 
    translate(i*300, 100, -300);
    rotateX(radians(mouseY*.3));
    rotateY(radians(mouseX*.36));
    cube.display(); 
    popMatrix();
  } 

  pushMatrix();
  translate(width/2, height/2+100, 240);
  rotateX(radians(100+mouseY*.3));
  rotateY(radians(mouseX*.36));

  //  fill(0);
  //  noStroke();
  //  sphere(20+ sin(frameCount*0.01)*80);
  for (int i = 0; i < savedFFT.length-1; i++) {
    for (int j = savedFFT[0].length-2; j >= 0; j--) {
      pushMatrix();
      translate(i * rangeSize - (maxRange/2 * rangeSize), 0, j * sampleSize - (maxSamples/2 * sampleSize));
      float c = map(savedFFT[i][j], 0, 40, 160, 240);
      float b = map(i, 0, maxRange, 50, 250);
      float g = map(j, 0, maxSamples, 100, 130); 
      //float b = map(storedFFT[i][0], 0, 50, 0, 255);
      //float aa = map(storedFFT[i][j],0,100,0,50);
      //box(2, storedFFT[i][j]*2, 2);
      //stroke(c, g, b, 255);
      strokeWeight(0);
      //stroke(0);
      fill(c, g, b, 255);

      beginShape(); 
      vertex(0, savedFFT[i][j]*heightMod, 0); 
      vertex(rangeSize, savedFFT[i+1][j]*heightMod, 0);
      vertex(0, savedFFT[i][j+1]*heightMod, sampleSize);
      endShape(CLOSE); 
      beginShape(); 
      vertex(rangeSize, savedFFT[i+1][j]*heightMod, 0); 
      vertex(0, savedFFT[i][j+1]*heightMod, sampleSize);
      vertex(rangeSize, savedFFT[i+1][j+1]*heightMod, sampleSize);
      endShape(CLOSE); 

      popMatrix();
    }
  }

  fill(200, 100);
  stroke(0);
  strokeWeight(5); 
  beginShape(); 
  pushMatrix();
  translate(0 - (maxRange/2 * rangeSize), 0, 0 - (maxSamples/2 * sampleSize));
  //translate(0-(savedFFT.length/2 * rangeSize), 0, 0-(savedFFT.length/2 * rangeSize));
  vertex(0, -cubeSize, 0);
  for (int i = 0; i < savedFFT.length; i++) {
    vertex(i*rangeSize, savedFFT[i][0]*heightMod, 0);
  } 
  vertex((savedFFT.length-1)*rangeSize, -cubeSize, 0); 
  endShape(CLOSE); 
  popMatrix(); 

  beginShape();  
  pushMatrix();
  //  translate(0-(savedFFT.length/2 * rangeSize), 0, 0-(savedFFT.length/2 * rangeSize));
  translate(0- (maxRange/2 * rangeSize), 0, 0 - (maxSamples/2 * sampleSize));
  vertex(0, -cubeSize, 0);
  for (int i = 0; i < savedFFT[0].length; i++) { 
    vertex(0, savedFFT[0][i]*heightMod, i*sampleSize);
  } 
  vertex(0, -cubeSize, (savedFFT[0].length-1)*sampleSize); 
  endShape(CLOSE); 
  popMatrix(); 

  beginShape();  
  pushMatrix();
  //translate(((savedFFT.length-1)*rangeSize)-(savedFFT.length/2 * rangeSize), 0, 0-(savedFFT.length/2 * rangeSize));
  translate(((maxRange-1)*rangeSize) - ((maxRange/2) * rangeSize), 0, 0 - (maxSamples/2 * sampleSize));
  vertex(0, -cubeSize, 0);
  for (int i = 0; i < savedFFT[0].length; i++) { 
    vertex(0, savedFFT[savedFFT.length-1][i]*heightMod, i*sampleSize);
  } 
  vertex(0, -cubeSize, (savedFFT[0].length-1)*sampleSize); 
  endShape(CLOSE); 
  popMatrix(); 

  beginShape(); 
  pushMatrix();
  translate(0- (maxRange/2 * rangeSize), 0, (maxSamples-1)*sampleSize - (maxSamples/2 * sampleSize));
  //translate(0-(savedFFT.length/2 * rangeSize), 0, (savedFFT[0].length-1)*sampleSize-(savedFFT.length/2 * rangeSize));
  vertex(0, -cubeSize, 0);
  for (int i = 0; i < savedFFT.length; i++) {
    vertex(i*rangeSize, savedFFT[i][savedFFT[0].length-1]*heightMod, 0);
  } 
  vertex((savedFFT.length-1)*rangeSize, -cubeSize, 0); 
  endShape(CLOSE); 
  popMatrix(); 

  beginShape();
  pushMatrix(); 
  translate(0- (maxRange/2 * rangeSize), 0, 0 - (maxSamples/2 * sampleSize));
  //translate(0-(savedFFT.length/2 * rangeSize), 0, 0-(savedFFT.length/2 * rangeSize));
  vertex((savedFFT.length-1)*rangeSize, -cubeSize, 0);
  vertex((savedFFT.length-1)*rangeSize, -cubeSize, (savedFFT[0].length-1)*sampleSize);
  vertex(0, -cubeSize, (savedFFT[0].length-1)*sampleSize);
  vertex(0, -cubeSize, 0);
  endShape(CLOSE); 
  popMatrix(); 

  //  for (int i = 0; i < storedVols.length; i++) {
  //    pushMatrix();
  //    fill(255, 0, 0, 50);
  //    translate(i*2, 0, 140);
  //    box(2, storedVols[i]*2, 10);
  //    popMatrix();
  //  } 
  popMatrix();
  if (recordPDF) {
    endRaw();
    recordPDF = false;
  }
}

void keyPressed() {
  if (key == ' ') {
    if (spacePress == false) {
      spacePress = true;
      for (int i = 0; i < savedFFT.length-1; i++) {
        for (int j = 0; j < savedFFT[0].length; j++) {
          savedFFT[i][j] = 0;
        }
      }
    }
  }

  if (key == 'p') { 
    int cuePosition = player.length()-600;
    player.cue(cuePosition);
    player.play(); 

    println("full sound length: " + player.length());
    println("cue position: " + cuePosition);
  }
} 

void keyReleased() {
  if (key == ' ') {
    if (spacePress == true) { 
      spacePress = false;
      recorder.save();
      player = minim.loadFile(count+".wav");
      recorder = minim.createRecorder(in, count+".wav");
    }
  }
  if (key == 's') {
    recordPDF = true;
    String timestamp = year() + nf(month(), 2) + nf(day(), 2) + "-"  + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2);
    saveFrame(timestamp+".png");
  }
  if (key == '\n') { 
    float[][] passedFFTs = new float[maxRange][maxSamples]; 
    //    for(int i = 0; i < savedFFT.length; i++) {
    //      System.arraycopy(savedFFT[i],0,passedFFTs[i],0,savedFFT.length);
    //    }
    for (int i = 0; i < savedFFT.length; i++) {
      for (int j = 0; j < savedFFT[i].length; j++) {
        passedFFTs[i][j] = savedFFT[i][j];
      }
    }
    FFTCube newCube = new FFTCube(passedFFTs); 
    savedCubes.add(newCube);
  }
}

void stop() {
  minim.stop();
}

PVector normalizedMouse() { 
  float x = (2.0f * mouseX) / width - 1.0;
  float y = 1.0f - (2.0f * mouseY) / height;
  float z = 1.0f;
  PVector ray_nds = new PVector(x, y, z);
  return ray_nds;
} 


void videoControlStuff() {
  counter++;
  if (keyPressed == true) {
    if (key == 'i') {
      counter = 0;
      redSize += 0.2;
    }
    if (key == 'o') {
      counter = 0;
      redSize = 0;
    }
  } 
  if (redSize > 0 ) {
    redSize -= 0.1;
  }
  if (counter > 73) {
    randX = random(1.0) * width;
    randY = random(1.0) * height;
    randXrot = random(1.0); 
    counter = 0;
  }
  randX+=randXrot;
  randY+=randYrot;
  rotateX(radians(100+randY*.3));
  rotateY(radians(randX*.36));
  if (frameCount % 10 == 0) {
    fill(255, 200);
  } else { 
    fill(0, 220);
  }

  noStroke();
  if (frameCount % 3 == 0) {
    sphere(30);
    fill(255, 0, 0, 100);
    sphere(redSize);
  } else {
    sphere(20+ sin(frameCount*0.01)*80);
    fill(0, 0, 0, 100);
    sphere(redSize);
  }
}

