void setup(){
  size(400,400);

  background(50);
  noStroke();
  
  for(int i = 0; i<500; i++){
    Ball b = new Ball((int)random(width),(int)random(height),(int)random(20,40),color(random(255),random(255),random(255)));
    b.update();
  }
}


class Ball{
  int x;
  int y;
  int r;
  color c;
  
  Ball(int _x, int _y, int _r, color _c){
    x = _x;
    y = _y;
    r = _r;
    c = _c;  
  }
  
  void update(){
    fill(c);
    ellipse(x,y,r,r);
  }
}
