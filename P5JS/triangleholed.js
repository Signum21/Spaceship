class TriangleHoled extends Triangle{  
    constructor(cx, cy, _h, cy2, _h2){
      super(cx, cy, _h);
      this.y1r = cy - _h/2;
      
      this.h2 = _h2;
      let l = int(this.h2*2/sqrt(3)); 
      this.xb1 = cx; 
      this.xb2 = this.xb1 - l/2;
      this.xb3 = this.xb2 + l;
      this.yb1 = cy2 - this.h2/2;
      this.yb2 = this.yb3 = this.yb1 + this.h2;
    }
    
    display(){
      beginShape();
        vertex(this.x1, this.y1);
        vertex(this.x2, this.y2);
        vertex(this.x3, this.y3);
        
        beginContour();
          vertex(this.xb1, this.yb1);
          vertex(this.xb2, this.yb2);
          vertex(this.xb3, this.yb3);
        endContour();
      endShape(CLOSE);
    }
    
    createMask(maskM){
      let off = 0, diff = 0;
      
      if(this.y1 > this.yb1){
        off = this.y1 - this.yb1;
        diff = this.xb3 - this.xb2 - int((this.h2-off)*2/sqrt(3));
      }      
      maskM.clear();
      
      maskM.beginShape();
        maskM.vertex(this.x1, this.y1);
        maskM.vertex(this.x2, this.y2);
        maskM.vertex(this.x3, this.y3);
        
        if(this.y1 < this.yb2){
          maskM.beginContour();
            maskM.vertex(this.xb1, this.yb1+off);
            maskM.vertex(this.xb2+diff/2, this.yb2);
            maskM.vertex(this.xb3-diff/2, this.yb3);
          maskM.endContour();
        }
      maskM.endShape(CLOSE);
      
      return maskM;
    }
    
    
    //V---------- External ----------V
    
    reset(){
      this.y1 = this.y1r;
      this.y2 = this.y3 = this.y1 + this.h;
    }
    
    contains(pos){
      return this.y1 <= pos;
    }
    
    
    //V---------- Internal ----------V
    
    goDownB(len){
      this.yb1 += len;
      this.yb2 = this.yb3 = this.yb1 + this.h2;    
    }
    
    goUpB(len){
      this.yb1 -= len;
      this.yb2 = this.yb3 = this.yb1 + this.h2;    
    }
    
    getCenterYB1(){
      return this.yb1 + this.h2/2;
    }
  }
  