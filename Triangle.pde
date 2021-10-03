// L = 2H/sqrt(3)

class Triangle{
  int x1, x2, x3, y1, y2, y3, h;
  
  Triangle(int cx, int cy, int _h){
    h = _h;
    x1 = cx; 
    y1 = cy - h/2;
    create();
  }
  
  void display(){
     triangle(x1, y1, x2, y2, x3, y3);
  }
  
  void create(){
    int l = int(h*2/sqrt(3)); 
    x2 = x1 + l/2;
    x3 = x2 - l;
    y2 = y3 = y1 + h;
  }
  
  void goDown(float len){
    y1 += len;
    y2 = y3 = y1 + h;    
  }
  
  boolean isOut(int limit){
    return y1 >= limit;
  }
  
  
  //V---------- Small triangle ----------V 
  
  void goUp(float len){
    y1 -= len;
    y2 = y3 = y1 + h;    
  }
  
  
  //V---------- Trail ----------V 
  
  void reduceH(int len){
    h -= len;
    create();
  }
}
