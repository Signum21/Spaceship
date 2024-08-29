class Line{
    constructor(_x1, _y1, len){
      this.x1 = this.x2 = _x1;
      this.y1 = _y1;
      this.y2 = this.y1 + len;
    }  
    
    displayInside(pg){
       pg.line(this.x1, this.y1, this.x2, this.y2);
    }
    
    goDown(len){
      this.y1 += len;
      this.y2 += len;
    } 
    
    isOut(limit){
      return this.y1 >= limit;
    }
  }
  