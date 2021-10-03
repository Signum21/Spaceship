class Line{
  float x1, x2, y1, y2;
  
  Line(float _x1, float _y1, float len){
    x1 = x2 = _x1;
    y1 = _y1;
    y2 = y1 + len;
  }  
  
  void displayInside(PGraphics pg){
     pg.line(x1, y1, x2, y2);
  }
  
  void goDown(float len){
    y1 += len;
    y2 += len;
  } 
  
  boolean isOut(int limit){
    return y1 >= limit;
  }
}
