PImage a;

void setup() { 
  size(800,800,P3D);
  a = loadImage("glitch.jpg"); 
  noStroke();
}

void draw() { 
  //background(255);
  textureMode(NORMAL);

  for (int i = 0; i < 10; i++) { 
    beginShape(QUAD);
    texture(a);
      vertex(10*i,10*i,sin(frameCount*0.1)*i*10,0,1);
      vertex(10*i,80*i,sin(frameCount*0.1)*i*10,0,0); 
      vertex(80*i,80*i,cos(frameCount*0.1)*i*10,1,0);    
      vertex(80*i,10*i,sin(frameCount*0.1)*i*10,1,1);
  endShape();
  }
  
    beginShape(TRIANGLE_FAN);
    texture(a);
    vertex(10,10,100,0,0);
    vertex(390,390,100,1,1);
    vertex(10,390,100,0,1);
    vertex(390,10,100,1,0);
  endShape();
  beginShape(QUAD);
  texture(a);
    vertex(410,10,100,0,0);
    vertex(410,390,100,0,1);
    vertex(790,390,100,1,1);
    vertex(790,10,100,1,0);
  endShape();
  beginShape(QUAD);
  texture(a);
    vertex(790,410,100,1,1);
    vertex(410,410,100,0,0);
    vertex(410,790,100,1,1);
    vertex(790,790,100,0,1);
  endShape();
  beginShape(QUAD);
  texture(a);
    vertex(10,790,100,0,1);
    vertex(390,410,100,1,0);
    vertex(10,410,100,1,0);    
    vertex(390,790,100,1,1);
  endShape();
  
  
//  beginShape();
//    texture(a);
//    vertex(100,0,0,0,0);
//    vertex(mouseX,0,0,100,0);
//    vertex(mouseX,200,0,100,100);
//    vertex(100,200,0,0,100);
//  endShape();
}

void keyReleased() {
  saveFrame();
}
