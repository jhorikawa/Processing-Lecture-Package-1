import fisica.*;

FWorld world;

void setup(){
  size(500,500);
  
  Fisica.init(this);
  
  world = new FWorld();
  world.setEdges(0,0,width,height);
}

void draw(){
  background(255);
  
  world.step();
  world.draw();
}
