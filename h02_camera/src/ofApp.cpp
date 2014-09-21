#include "ofApp.h"
#include "CamReader.h"

//--------------------------------------------------------------
void ofApp::setup(){
    ofBackground(0, 0, 0);
    camWidth = 640;
    camHeight = 480;
    
    vidGrabber.setVerbose(true);
    vidGrabber.initGrabber(camWidth,camHeight);
    ofSetRectMode(OF_RECTMODE_CENTER);
    
}

//--------------------------------------------------------------
void ofApp::update(){
    vidGrabber.update();
    //incr = (incr % 255) + (incrVal);
    incr = mouseX;
//    incr = (incr % 255) + (1);
    //if (incr == 255) {
    //   incrVal = ofRandomf();
   // }
    
    
}

//--------------------------------------------------------------
void ofApp::draw(){
    if (record) {
        ofBeginSaveScreenAsPDF("screenshot-"+ofGetTimestampString()+".pdf", false);
    }
    ofPixelsRef pixelsRef = vidGrabber.getPixelsRef();
    
    for (int i = 0; i < camWidth; i+=1) {
        for (int j = 0; j < camHeight; j+=10) {
            float lightness = pixelsRef.getColor(i,j).getLightness();
            ofSetColor(lightness);
            ofRect(i,j,incr-lightness,incr-lightness);
        }
    }
    if (record) {
        ofEndSaveScreenAsPDF();
        record = false;
    }
    

}

//--------------------------------------------------------------
void ofApp::keyPressed(int key){
    record = true; 
}

//--------------------------------------------------------------
void ofApp::keyReleased(int key){

}

//--------------------------------------------------------------
void ofApp::mouseMoved(int x, int y ){

}

//--------------------------------------------------------------
void ofApp::mouseDragged(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mousePressed(int x, int y, int button){
    

}

//--------------------------------------------------------------
void ofApp::mouseReleased(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::windowResized(int w, int h){

}

//--------------------------------------------------------------
void ofApp::gotMessage(ofMessage msg){

}

//--------------------------------------------------------------
void ofApp::dragEvent(ofDragInfo dragInfo){ 

}
