class Triangle{
    constructor(cx, cy, _h){
      this.h = _h;
      this.x1 = cx; 
      this.y1 = cy - this.h/2;
      this.create();
    }
    
    display(){
       triangle(this.x1, this.y1, this.x2, this.y2, this.x3, this.y3);
    }
    
    create(){
      let l = int(this.h*2/sqrt(3)); 
      this.x2 = this.x1 + l/2;
      this.x3 = this.x2 - l;
      this.y2 = this.y3 = this.y1 + this.h;
    }
    
    goDown(len){
      this.y1 += len;
      this.y2 = this.y3 = this.y1 + this.h;    
    }
    
    isOut(limit){
      return this.y1 >= limit;
    }
    
    
    //V---------- Small triangle ----------V 
    
    goUp(len){
      this.y1 -= len;
      this.y2 = this.y3 = this.y1 + this.h;    
    }
    
    
    //V---------- Trail ----------V 
    
    reduceH(len){
      this.h -= len;
      this.create();
    }
  }
  