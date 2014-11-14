import gab.opencv.*;
import java.awt.Rectangle;
import processing.video.*;

Capture video; 
Rectangle[] faces;
OpenCV opencv;
int mode = 0; 
int count = 0; 
boolean processed = false;
float[][] reds = new float[640][480];
float[][] greens = new float[640][480];
float[][] blues = new float[640][480];

float avgWidth = 0;
float avgHeight = 0; 
float totalWidth = 0;
float totalHeight = 0; 

void setup() {
  size(640, 480);
  video = new Capture(this, width, height);
  video.start();
  opencv = new OpenCV(this, video);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  faces = opencv.detect();
}

void draw() {
  if (mode == 0) {
    background(0);
    opencv.loadImage(video);
    faces = opencv.detect();
    image(video, 0, 0); 
    if (faces != null) {
      for (int i = 0; i < faces.length; i++) {
        noFill();
        strokeWeight(5);
        stroke(255);
        rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
      }
    }
  } else { 
    background(0);
    if (processed == false) {
      avgWidth = totalWidth/count;
      avgHeight = totalHeight/count;
      for (int i = 0; i < count; i++) {
        PImage face = loadImage("faces/face-"+i+".jpg");

        for (int x = 0; x < face.width; x++) {
          for (int y = 0; y < face.height; y++) {
            reds[x][y] += (int)red(face.get(x, y)); 
            greens[x][y] += (int)green(face.get(x, y));
            blues[x][y] += (int)blue(face.get(x, y));
          }
        }
      }
      for (int x = 0; x < avgWidth; x++) {
        for (int y = 0; y < avgHeight; y++) {
          reds[x][y] = reds[x][y]/count;
          greens[x][y] = greens[x][y]/count;
          blues[x][y] = blues[x][y]/count;
        }
      }
      processed = true;
    }
    for (int x = 0; x < avgWidth; x++) {
      for (int y = 0; y < avgHeight; y++) {
        stroke(reds[x][y], greens[x][y], blues[x][y]);
        point(x+100,y+100);
      }
    }
    fill(255); 
    textSize(30);
    text("total to average: " + count, 100, 450);
  }
}

void keyReleased() {
  if (key == ' ') {
    for (int i = 0; i < faces.length; i++) {
      PImage cropped = createImage(faces[i].width, faces[i].height, RGB);
      cropped.copy(video, faces[i].x, faces[i].y, faces[i].width, faces[i].height, 0, 0, faces[i].width, faces[i].height);
      cropped.updatePixels();
      cropped.save("faces/face-"+count+".jpg");
      totalWidth += faces[i].width;
      totalHeight += faces[i].height;
      count++;
    }
  }
  if (key == '\n') {
    if (mode == 0) {
      mode = 1;
      processed = false;
    } else {
      mode = 0;
    }
  }
}

void captureEvent(Capture cam) {
  cam.read();
}

