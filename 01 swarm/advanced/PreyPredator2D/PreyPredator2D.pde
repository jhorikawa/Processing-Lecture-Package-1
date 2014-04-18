import toxi.processing.*;
import toxi.geom.*;

vWorld world1;
ToxiclibsSupport gfx;

float envSize;

void setup(){
  size(500,500);
  envSize = width/2;

  gfx=new ToxiclibsSupport(this);
  
  world1 = new vWorld();
    
  // create agents
  for (int i = 0; i < 200; i++) {
    world1.addAgent(new vAgentPrey(new Vec2D(random(width),random(height)), new Vec2D(random(-1,1),random(-1,1)), 20, 0.1));
  }
  for (int i = 0; i < 5; i++) {
    world1.addAgent(new vAgentPredator(new Vec2D(random(width),random(height)), new Vec2D(random(-1,1),random(-1,1)), 20, 0.1));
  }
}


void draw(){
  background(120);
  world1.run();
}
