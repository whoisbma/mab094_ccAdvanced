import org.openkinect.*;
import org.openkinect.processing.*;
import processing.pdf.*;

Kinect kinect; 
int w = 640;
int h = 480; 
float[] depthLookUp = new float[2048];
float a = 0; 
int skip = 10;
//float[] vecX = new float[(w/skip) * (h/skip)]; 
//float[] vecY = new float[(w/skip) * (h/skip)]; 
//float[] vecZ = new float[(w/skip) * (h/skip)];

color[][] cols = new color[(w/skip)][(h/skip)]; 

float[][] valZ = new float[w/skip][h/skip];

boolean record = false; 
float moveX = 0; 
float moveY = 0; 
float moveZ = 0; 

void setup() {
  size(800, 600, P3D); 
  kinect = new Kinect(this);
  kinect.start();
  kinect.enableDepth(true); 
  kinect.processDepthImage(false);
  kinect.enableRGB(true); 

  for (int i = 0; i < depthLookUp.length; i++) {
    depthLookUp[i] = rawDepthToMeters(i);
  }
} 

void draw() {
  if (record) {
    beginRaw(PDF, "output.pdf");
  }

  background(250); 
  translate(moveX, moveY, moveZ);
  rotateY(radians(mouseX));
  rotateX(radians(mouseY)); 


  lights(); 
  int mag = 10; 
  //int nn = 0; 
  for (int x = 0; x < w/skip-1; x++) {
    for (int y = 0; y < h/skip-1; y++) {
      //stroke(0);
      noStroke();
      
      

  
      float a = valZ[x][y] * 2;
      float aa = 0; 
      if (a > 255) {
        aa = 255- (a-255); 
      } else {
        aa = a; 
      } 
      color newCol = color(red(cols[x][y]), green(cols[x][y]), blue(cols[x][y]), aa);
      
      fill(x*5, y*5, mouseY,aa); 
      fill(newCol); 
      //fill(cols[x][y]); 
      //noFill();
      //stroke(0);
      //strokeWeight(1); 
      // point(vecX[n], vecY[n], vecZ[n]);



//      if (valZ[x][y] > 100) {
      beginShape(); 
      vertex(x*mag, y*mag, valZ[x][y]); 
      vertex(x*mag, y*mag+mag, valZ[x][y+1]); 
      vertex(x*mag+mag, y*mag, valZ[x+1][y]); 
      endShape(CLOSE); 


      beginShape(); 
      vertex(x*mag+mag, y*mag, valZ[x+1][y]); 
      vertex(x*mag, y*mag+mag, valZ[x][y+1]); 
      vertex(x*mag+mag, y*mag+mag, valZ[x+1][y+1]); 
      endShape(CLOSE);
    }
    //nn++;
   // }
  }
  //println(nn);
  a += 0.015f;

  if (keyPressed) {
    if (key == ' ') {
      getKinect();
    }

    switch(keyCode) {
    case UP : 
      moveY+=10; 
      break;
    case DOWN : 
      moveY-=10; 
      break;
    case LEFT : 
      moveX-=10; 
      break;
    case RIGHT : 
      moveX+=10; 
      break;
    case ALT : 
      moveZ+=10; 
      break;
    case SHIFT : 
      moveZ-=10; 
      break;
    }
  }

  if (record) {
    endRaw();
    record = false;
  }
} 

float rawDepthToMeters(int depthValue) {
  if (depthValue < 2047) {
    return (float)(1.0 / ((double)(depthValue) * -0.0030711016 + 3.3309495161));
  }
  return 0.0f;
}

PVector depthToWorld(int x, int y, int depthValue) {
  final double fx_d = 1.0 / 5.9421434211923247e+02;
  final double fy_d = 1.0 / 5.9104053696870778e+02;
  final double cx_d = 3.3930780975300314e+02;
  final double cy_d = 2.4273913761751615e+02;

  PVector result = new PVector();
  double depth =  depthLookUp[depthValue];//rawDepthToMeters(depthValue);
  result.x = (float)((x - cx_d) * depth * fx_d);
  result.y = (float)((y - cy_d) * depth * fy_d);
  //if ((float)(depth) < 300) {  result.z = 0; }
  /*else  {*/  result.z = (float)(depth); //}
  return result;
}

void getKinect() {

  PImage rgb = kinect.getVideoImage();
  int[] depth = kinect.getRawDepth(); 
  int n = 0; 
  for (int x = 0; x < w/skip; x++) {
    for (int y = 0; y < h/skip; y++) {
      int offset = (x*skip)+(y*skip)*w;
      int rawDepth = depth[offset];
      PVector v = depthToWorld(x*skip, y*skip, rawDepth);
      color c = rgb.get(x*skip, y*skip); 
      stroke(c); 
      strokeWeight(1); 
      float factor = 255; 
      //point(v.x*factor, v.y*factor, factor-v.z*factor);
      //      vecX[n] = v.x*factor;
      //      vecY[n] = v.y*factor;
      //      vecZ[n] = v.z*factor;
      valZ[x][y] = factor-v.z*factor;

      cols[x][y] = c;
      n++;
    }
  }
} 

void stop() {
  kinect.quit();
  super.stop();
}

void keyPressed() {
  if (key == 's') {
    record = true;
  }
}

