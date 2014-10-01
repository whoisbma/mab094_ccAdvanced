//
//  CamRead.h
//  h02a_moreCamera
//
//  Created by Bryan Ma on 9/21/14.
//
//

#pragma once
#include "ofMain.h"

class CamRead {
    
public:
    void setupVid();
    void updateVid();
    void drawVid();
    void findBlobs(); 
    
    ofVideoGrabber vidGrabber;
    int camWidth;
    int camHeight;
    //ofPixelsRef pixelsRef;
    
    int pxColors[2048];
    
    
};