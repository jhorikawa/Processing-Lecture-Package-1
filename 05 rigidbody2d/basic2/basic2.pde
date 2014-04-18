import fisica.*;

FWorld world;

void setup(){
  size(500,500);
  
  Fisica.init(this);
  
  world = new FWorld();
  world.setEdges(0,0,width,height);
  
  for(int i = 0; i<300; i++){
    FCircle myCircle = new FCircle(random(5,30));
    myCircle.setPosition(random(width),random(height));
    myCircle.setRotation(random(TWO_PI));
    myCircle.setNoFill();
    world.add(myCircle);
  }
}

void draw(){
  background(255);
  
  world.step();
  world.draw();
}
