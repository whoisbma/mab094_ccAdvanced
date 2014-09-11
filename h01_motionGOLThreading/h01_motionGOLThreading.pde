/* BMA MOTION AVERAGER/DETECTOR HACK of Golan Levin's Frame Differencing*/

import processing.video.*;

int numPixels;
int[] previousFrame;
Capture video;

int[] savedX;
int[] savedY; 
int[] oldX;
int[] oldY; 
int numSaved = 7000;
int diffThreshold = 200;

GOL gol;
PShader blur;

void setup() {
  size(640, 480, P2D);
  colorMode(HSB);
  blur = loadShader("blur.glsl");
  video = new Capture(this, 640, 480);
  video.start(); 
  numPixels = video.width * video.height;
  previousFrame = new int[numPixels];

  savedX = new int[numSaved];
  savedY = new int[numSaved];
  oldX = new int[numSaved];
  oldY = new int[numSaved];

  background(255); 
  loadPixels();
  noStroke();

  gol = new GOL();
}

void draw() {
  //rectMode(CORNER);
  //fill(255, 1);
  //rect(0, 0, width, height);
  //background(255); 
  filter(blur);
  int biggestDiff = 0;
  for (int i = 0; i < savedX.length; i++) {
    savedX[i] = 0; 
    savedY[i] = 0;
  }
  if (video.available()) {
    video.read(); 
    video.loadPixels();
    thread("doThreadStuff");
    
  }
  // }

  gol.generate();
  gol.display();
  println(savedX[savedX.length-100]);
  for (int i = 0; i < savedX.length; i++ ) {
    gol.click(width-savedX[i], savedY[i]);
    //noStroke();
    fill(100, 255, 0);
    stroke(100, 255, 0);
    point(width-savedX[i], savedY[i]);
    //    rect(width-savedX[i], savedY[i], 8, 8);
    //rect(i*10,(i % width),10,10);
    //if (frameCount % 2 == 0) {
    //if (movementSum > 2000000) {
    //particles.add(new Particle(width-savedX[i], savedY[i]));
    //}
  }



  oldX = savedX;
  oldY = savedY;
}

void doThreadStuff() {
  int movementSum = 0;

  //if (frameCount % int(random(1, 2)) == 0) {

  for (int i = numPixels-1; i > -1; i-=2) { 
    color currColor = video.pixels[i];
    color prevColor = previousFrame[i];
    int currR = (currColor >> 16) & 0xFF;
    int currG = (currColor >> 8) & 0xFF;
    int currB = currColor & 0xFF;
    int prevR = (prevColor >> 16) & 0xFF;
    int prevG = (prevColor >> 8) & 0xFF;
    int prevB = prevColor & 0xFF;
    int diffR = abs(currR - prevR);
    int diffG = abs(currG - prevG);
    int diffB = abs(currB - prevB);
    movementSum += diffR + diffG + diffB;

    int currentDiff = diffR + diffG + diffB;

    if (currentDiff > diffThreshold) {
      //if (currentDiff > biggestDiff) {
      // biggestDiff = currentDiff;
      savedX[savedX.length-1] = i % video.width;
      savedY[savedY.length-1] = i / video.width;

      for (int j = 0; j < savedX.length-1; j++ ) {
        savedX[j] = savedX[j+1];
        savedY[j] = savedY[j+1];
        //}
      }
    }

    int loc = (width - (i % video.width) - 1) + (i / video.width) * width;

    //pixels[loc] = color(currR, currG, currB);
    //pixels[loc] = color(diffR, diffG, diffB);

    // if (currentDiff > diffThreshold) {
    //    pixels[loc] = color(255);
    //  } else {
    //pixels[loc] = color(diffR, diffG, diffB);
    //pixels[loc] = 0xff000000 | (diffR << 16) | (diffG << 8) | diffB;
    //  }
    previousFrame[i] = currColor;
  }
  if (movementSum > 0) {
    //updatePixels();
  }
}
