class Cell {
  float x, y; 
  float w; 
  
  int state;
  int previous;
  
  float col1 = 0; 
  float range = random(255); 
  float rem = 255-range;
  
  float seed = random(10000); 
  float inc = random(0.5); 
  float siz = random(10); 
  
  Cell(float X, float Y, float W) {
    x = X; 
    y = Y;
    w = W;
    
   // state = int(random(2));
    state = 0; 
    previous = state;
  } 
  
  void savePrevious() {
    previous = state;
  } 
  
  void newState(int s) {
    state = s;
  } 
  
  void display() {
    seed+= inc; 
    col1 = (sin(seed) * range) +rem;

    if (previous == 0 && state == 1) {
      fill(100);
      //w = 8;
      w = 5;
    }
    else if (state == 1) {
      fill(col1,210,200);
     // w = 10+siz;
     w = 6;
    }
    else if (previous == 1 && state == 0) {
      fill(col1); 
//    else fill(255,15);
     // w = 5;
     w = 5;
    }
    else {
      fill(255);
      w = 0;
    } 
    noStroke();
    //stroke(0);
    rectMode(CENTER);
    rect(x,y,w,w);
    //ellipseMode(CORNER);
    //ellipse(x,y,w,w);
  }
}
