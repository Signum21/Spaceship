// L = 2H/sqrt(3)

class TriangleHoled extends Triangle{  
  final int y1r;
  int xb1, xb2, xb3, yb1, yb2, yb3, h2;
  
  TriangleHoled(int cx, int cy, int _h, int cy2, int _h2){
    super(cx, cy, _h);
    y1r = cy - _h/2;
    
    h2 = _h2;
    int l = int(h2*2/sqrt(3)); 
    xb1 = cx; 
    xb2 = xb1 - l/2;
    xb3 = xb2 + l;
    yb1 = cy2 - h2/2;
    yb2 = yb3 = yb1 + h2;
  }
  
  @Override
  void display(){
    beginShape();
      vertex(x1, y1);
      vertex(x2, y2);
      vertex(x3, y3);
      
      beginContour();
        vertex(xb1, yb1);
        vertex(xb2, yb2);
        vertex(xb3, yb3);
      endContour();
    endShape(CLOSE);
  }
  
  PGraphics createMask(PGraphics mask){
    int off = 0, diff = 0;
    
    if(y1 > yb1){
      off = y1 - yb1;
      diff = xb3 - xb2 - int((h2-off)*2/sqrt(3));
    }
    
    mask.beginDraw();
      mask.clear();
      
      mask.beginShape();
        mask.vertex(x1, y1);
        mask.vertex(x2, y2);
        mask.vertex(x3, y3);
        
        if(y1 < yb2){
          mask.beginContour();
            mask.vertex(xb1, yb1+off);
            mask.vertex(xb2+diff/2, yb2);
            mask.vertex(xb3-diff/2, yb3);
          mask.endContour();
        }
      mask.endShape(CLOSE);
    mask.endDraw();
    
    return mask;
  }
  
  
  //V---------- External ----------V
  
  void reset(){
    y1 = y1r;
    y2 = y3 = y1 + h;
  }
  
  boolean contains(int pos){
    return y1 <= pos;
  }
  
  
  //V---------- Internal ----------V
  
  void goDownB(float len){
    yb1 += len;
    yb2 = yb3 = yb1 + h2;    
  }
  
  void goUpB(float len){
    yb1 -= len;
    yb2 = yb3 = yb1 + h2;    
  }
  
  int getCenterYB1(){
    return yb1 + h2/2;
  }
}
