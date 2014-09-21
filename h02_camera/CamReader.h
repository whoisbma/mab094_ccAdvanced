//
//  CamReader.h
//  h02_camera
//
//  Created by Bryan Ma on 9/18/14.
//
//

#pragma once
#include "ofMain.h"

class CamReader {
    
public:
    
    ofVideoGrabber vidGrabber;
    int camWidth;
    int camHeight;
    
    void setupVid();
    void updateVid();
};