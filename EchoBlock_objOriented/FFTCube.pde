public class FFTCube extends MeshCube {
    int myCubeMaxSamples = 12;
    int myCubeMaxRange = 40; 
    float myCubeSampleSize = 20;
    float myCubeRangeSize = 5; 
    float myCubeSize = 20; 
    float myCubeHeightMod = 5;
  
    float randC1, randC2, randC3, randC4, randC5, randC6;

  FFTCube(float[][] _cubeFFTs) {
    this.cubeFFTs = _cubeFFTs;
    randC1 = random(150); 
    randC2 = random(150,250);
    randC3 = random(150); 
    randC4 = random(150,250);
    randC5 = random(150); 
    randC6 = random(150,250); 
    
  } 

  public void update() {
  } 

  public void display() {
    for (int i = 0; i < cubeFFTs.length-1; i++) {
      for (int j = cubeFFTs[0].length-2; j >= 0; j--) {
        pushMatrix();
        translate(i * myCubeRangeSize - (myCubeMaxRange/2 * myCubeRangeSize), 0, j * myCubeSampleSize - (myCubeMaxSamples/2 * myCubeSampleSize));
        float c = map(cubeFFTs[i][j], 0, 40, randC1, randC2);
        float b = map(i, 0, maxRange, randC3, randC4);
        float g = map(j, 0, myCubeMaxSamples, randC5, randC6); 

        strokeWeight(0);
        fill(c, g, b, 255);

        beginShape(); 
        vertex(0, cubeFFTs[i][j]*myCubeHeightMod, 0); 
        vertex(myCubeRangeSize, cubeFFTs[i+1][j]*myCubeHeightMod, 0);
        vertex(0, cubeFFTs[i][j+1]*myCubeHeightMod, myCubeSampleSize);
        endShape(CLOSE); 
        beginShape(); 
        vertex(myCubeRangeSize, cubeFFTs[i+1][j]*heightMod, 0); 
        vertex(0, cubeFFTs[i][j+1]*myCubeHeightMod, myCubeSampleSize);
        vertex(myCubeRangeSize, cubeFFTs[i+1][j+1]*myCubeHeightMod, myCubeSampleSize);
        endShape(CLOSE); 

        popMatrix();
      }
    }
  }
} 
