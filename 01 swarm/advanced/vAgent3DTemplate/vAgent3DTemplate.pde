import peasy.*;
import toxi.processing.*;
import toxi.geom.*;

PeasyCam cam;
vWorld world1;
ToxiclibsSupport gfx;

float envSize = 300;

void setup(){
  size(500,500,P3D);
  
  cam = new PeasyCam(this, 1100);
  cam.setMinimumDistance(800);
  cam.setMaximumDistance(1400);
  gfx=new ToxiclibsSupport(this);
  
  world1 = new vWorld();
    
  // create agents
  for (int i = 0; i < 200; i++) {
    world1.addAgent(new vAgent(new Vec3D(random(-250,250),random(-250,250),random(-250,250)), new Vec3D(random(-1,1),random(-1,1),random(-1,1)), 10, 0.1));
  }
}


void draw(){
  background(120);
  world1.addBox(envSize);
  world1.run();
}
