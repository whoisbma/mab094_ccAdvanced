Sphere s1[] = new Sphere[7];
Sphere s2[] = new Sphere[7];
Sphere m1[] = new Sphere[7]; 
Sphere m2[] = new Sphere[7]; 
Sphere m3[] = new Sphere[7]; 
Sphere m4[] = new Sphere[7]; 
Sphere mm1[] = new Sphere[7]; 
Sphere mm2[] = new Sphere[7]; 

void setup() { 
  size(1000, 700, P3D); 
  noSmooth();
  noCursor();
  for (int i = 0; i < 7; i++) {
    s1[i] = new Sphere(50, -200, 0, i*20, 0);
    s2[i] = new Sphere(50, 200, 0, i*21, 0); 
    m1[i] = new Sphere(15, 140, 0, i*22, 1); 
    m2[i] = new Sphere(15, -140, 0, i*23, 1);
    m3[i] = new Sphere(15, 140, 100, i*23, 1); 
    m4[i] = new Sphere(15, 140, 100, i*23, 1); 
    mm1[i] = new Sphere(7, 40, 0, i*24, 2); 
    mm2[i] = new Sphere(7, -40, 0, i*25, 2);
  }
  stroke(240, 100);
} 

void draw() { 
  background(130);   
  lights(); 
  translate(width/2, -50); 
  for (int i = 0; i < 7; i++) {
    translate(0, i+100);
    pushMatrix(); 
    rotateY(i*15 + frameCount*0.01); 
    s1[i].draw();
    m1[i].draw(); 
    mm1[i].draw();
    mm1[i].pop(); 
    m1[i].pop(); 
    m3[i].draw(); 
    m3[i].pop();
    s1[i].pop(); 
    s2[i].draw();
    m2[i].draw();
    mm2[i].draw();
    mm2[i].pop(); 
    m2[i].pop();  
    m4[i].draw(); 
    m4[i].pop(); 
    s2[i].pop();
    popMatrix();
  }
}

public class Sphere {
  int size; 
  int radius; 
  float rot; 
  float rot1;
  float rot2;
  int col; 
  int type;

  public Sphere(int size, int radius, float rot, int col, int type) {
    this.size = size;
    this.radius = radius;
    this.rot = rot;
    this.col = col; 
    this.type = type;
    rot1 = rot * 0.5;
    rot2 = rot * 0.8;
  } 

  public void draw() {
    pushMatrix(); 
    translate(radius * mouseX*0.005, 0); 

    switch(type) {
    case 0 : 
      sphereDetail(10);
      fill(150-col, col*.8, col*0.7); 
      break;
    case 1 : 
      sphereDetail(4);
      fill(col*0.8, col*.5, 100-col*1.5); 
      break;
    case 2 : 
      sphereDetail(3);
      fill(col*0.4, 100-col, col*.9); 
      break;
    }
    rotateY(rot);
    rotateZ(rot1); 
    rotateX(rot2); 
    sphere(size * mouseX*0.004); 

    noFill();
    box(size*1.7, size*1.7, size*1.7);
    rot = (rot += 0.05) % TWO_PI;
    rot1 = (rot1 += 0.03) % TWO_PI;
    rot2 = (rot2 += 0.02) % TWO_PI;
  } 

  public void pop() {
    popMatrix();
  }
} 

