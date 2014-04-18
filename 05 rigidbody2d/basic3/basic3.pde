import fisica.*;

FWorld world;

void setup(){
  size(500,500);
  
  Fisica.init(this);
  
  world = new FWorld();
  world.setEdges(0,0,width,height);
  
  FCircle myCircle1 = new FCircle(50);
  myCircle1.setPosition(width/3,height/3);
  myCircle1.setRotation(random(TWO_PI));
  myCircle1.setNoFill();
  //
  myCircle1.setDensity(10);
  myCircle1.setRestitution(10);
  myCircle1.setDamping(5);
  myCircle1.setFriction(5);
  //
  world.add(myCircle1);
  
  FCircle myCircle2 = new FCircle(50);
  myCircle2.setPosition(width/3*2,height/3);
  myCircle2.setRotation(random(TWO_PI));
  myCircle2.setNoFill();
  world.add(myCircle2);
  
}

void draw(){
  background(255);
  
  world.step();
  world.draw();
}
