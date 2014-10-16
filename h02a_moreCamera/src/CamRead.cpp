//
//  CamRead.cpp
//  h02a_moreCamera
//
//  Created by Bryan Ma on 9/21/14.
//
//

#include "CamRead.h"


void CamRead::setupVid() {
    camWidth = 640;
    camHeight = 480;
    vidGrabber.setVerbose(true);
    vidGrabber.initGrabber(camWidth,camHeight);
    
    ofEnableAlphaBlending();
    for (int i = 0; i < 2048; i++) {
        pxColors[i] = 0;
    }
    
    

   
}


void CamRead::updateVid() {
    vidGrabber.update();
    unsigned char * pixels = vidGrabber.getPixels();
    int colorVal;
    for (int i = 0; i < camWidth * camHeight * 3; i+=3) {
        colorVal = (pixels[i] << 16 | (pixels[i+1] << 8) | pixels[i+2]);
        pxColors[colorVal / 8096]+=1;
    }
}

void CamRead::drawVid() {
    vidGrabber.draw(0,0);
    for (int i = 0; i < 2048; i++) {
        int intColor = i * 8096;
        int newR = (intColor >> 16) & 0xFF;
        int newG = (intColor >> 8) & 0xFF;
        int newB = intColor & 0xFF;
        ofSetColor(newR, newG, newB);
        ofRect(i/2,0,2,pxColors[i]/4);
    }
}

/*
void CamRead::findBlobs() {
    pixelsRef = vidGrabber.getPixelsRef();
    for(int x = 0; x < camWidth; x++) {
        for(int y = 0; y < camHeight; y++) {
            ofColor thisColor = pixelsRef.getColor(x,y);
            if (x > 0) {
                ofColor westColor = pixelsRef.getColor(x-1,y);
            }
            if (x < camWidth) {
                ofColor eastColor = pixelsRef.getColor(x+1,y);
            }
            if (y > 0) {
                ofColor northColor = pixelsRef.getColor(x, y-1);
            }
            if (y < camHeight) {
                ofColor southColor = pixelsRef.getColor(x, y+1);
            }
        }
    }

}

void CamRead::checkPixel(ofColor _color, int _x, int _y) {
    
}*/



/*
 Flood-fill (node, target-color, replacement-color):
 1. If target-color is equal to replacement-color, return.
 2. If the color of node is not equal to target-color, return.
 3. Set the color of node to replacement-color.
 4. Perform Flood-fill (one step to the west of node, target-color, replacement-color).
 Perform Flood-fill (one step to the east of node, target-color, replacement-color).
 Perform Flood-fill (one step to the north of node, target-color, replacement-color).
 Perform Flood-fill (one step to the south of node, target-color, replacement-color).
 5. Return.

*/