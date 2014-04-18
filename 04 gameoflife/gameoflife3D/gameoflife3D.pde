import toxi.geom.*;
import peasy.*;

PeasyCam cam;
World world;
int num = 10;
int boxSize = 500;
boolean bloop = true;

void setup(){
  size(500,500,P3D);
  frameRate(15);
  
  cam = new PeasyCam(this, 1000);
  cam.setMinimumDistance(500);
  cam.setMaximumDistance(2000);
  cam.lookAt(boxSize/2,boxSize/2,0);
  
  world = new World();
  
  
  for(int i = 0; i<num; i++){
    for(int n = 0; n<num; n++){
      for(int t = 0; t<num; t++){
        int r = int(random(2));
        boolean b = true;
        if(r == 0){
          b = false;
        }else{
          b = true;
        }
        
        Node node = new Node(boxSize/num*i,boxSize/num*n,boxSize/num*t,b);
        world.addNode(node);
      }
      //Node node = new Node(width/num*i,height/num*n,b);
      //world.addNode(node);
    }
  }
  for(int i = 0; i<world.pop.size(); i++){
    Node node = (Node)world.pop.get(i);
    node.makeNeighbors3D(world.pop);
  }
  
}

void draw(){
  background(0);
  lights();
  //world.update2D(width/num,height/num);
  world.update3D(boxSize/num);
  if(bloop){
    world.nextGeneration();
    frameRate(15);
  }else{
    frameRate(60);
  }
}


class Node{
  int x;
  int y;
  int z;
  Vec3D pos;
  Vec3D pos3D;
  ArrayList neighbors;
  int liveNeighbors;
  boolean state;
  
  Node(int _x, int _y,boolean _state){
    x = _x;
    y = _y;
    pos = new Vec3D(x,y,0);
    neighbors = new ArrayList();
    liveNeighbors = 0;
    state = _state;
  }
  
  Node(int _x, int _y, int _z, boolean _state){
    x = _x;
    y = _y;
    z = _z;
    pos = new Vec3D(x,y,z);
    neighbors = new ArrayList();
    liveNeighbors = 0;
    state = _state;
  }
  
  void updateLiveNeighbors(){
    liveNeighbors = 0;
    for(int i = 0; i<neighbors.size(); i++){
      int neighbor = (Integer)neighbors.get(i);
      Node other = (Node)world.pop.get(neighbor);
      if(other.state){
        liveNeighbors++;
      }
    }
    //println(liveNeighbors);
  }
  
  void update2D(int w, int h){
    if(state){
      int fillC = int(map(liveNeighbors,0,8,0,255));
      fill(fillC,150, 0,200);
    }else{
      fill(255);
    }
    rect(x,y,w,h);
  }
  
  void update3D(int bs){
    strokeWeight(1);
    if(state){
      int fillC = int(map(liveNeighbors,0,6,0,255));
      int alphaC = int(map(liveNeighbors,0,6,200,255));
      stroke(fillC,150,0,50);
      fill(fillC,150, 0,alphaC); 
    }else{
      noStroke();
      //stroke(255);
      noFill();
      //fill(255,100);
    }
    point(x,y,z);
    pushMatrix(); 
    translate(x,y,z);
    box(bs);
    popMatrix();
  }  
  
  void changeState(boolean b){
    state = b;
    
    
  }
  
  void makeNeighbors2D(ArrayList pop){
    neighbors = new ArrayList();
    for(int i = 0; i<pop.size(); i++){
      Node other = (Node)pop.get(i);
      if(pos.distanceTo(other.pos)<width/num*1.5 && pos.distanceTo(other.pos)>0){
        neighbors.add(i);
      }
    }
  }
  
  void makeNeighbors3D(ArrayList pop){
    neighbors = new ArrayList();
    for(int i = 0; i<pop.size(); i++){
      Node other = (Node)pop.get(i);
      if(pos.distanceTo(other.pos)<boxSize/num*1.5 && pos.distanceTo(other.pos)>0){
        neighbors.add(i);
      }
    }
  }
}

void keyReleased(){
  if(key == 's' || key == 'S'){
    if(bloop){
      bloop = false;
    }else{
      bloop = true;
    }
  }
}




