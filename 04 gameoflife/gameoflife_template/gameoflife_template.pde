import toxi.geom.*;

World world;

int num = 20;
int w = 500;
int h = 500;
int si = w/num;

void setup(){
  size(w,h);
  
  world = new World();
  
  
  for(int i = 0; i<num; i++){
    for(int n = 0; n<num; n++){
      int r = int(random(2));
      boolean b = true;
      if(r == 0){
        b = false;
      }else{
        b = true;
      }
      Node node = new Node(width/num*i, height/num*n,b);
      //node.update(width/num);
      world.addNode(node);
    }
  }
  
  for(int i = 0; i<world.pop.size(); i++){
    Node node = (Node)world.pop.get(i);
    node.makeNeighbors(world.pop);
  }
}

void draw(){
  background(0);
  
  world.update(si);
  world.nextGeneration();
    
}

class Node{
  int x;
  int y;
  Vec2D pos;
  ArrayList neighbors;
  int liveNeighbors;
  boolean state;
  
  Node(int _x, int _y, boolean _state){
    x = _x;
    y = _y;
    pos = new Vec2D(x,y);
    neighbors = new ArrayList();
    state = _state;
    liveNeighbors = 0;
  }
  
  void updateLiveNeighbors(){
    liveNeighbors = 0;
    for(int i =0; i<neighbors.size(); i++){
      int neighbor = (Integer)neighbors.get(i);
      Node other = (Node)world.pop.get(neighbor);
      if(other.state == true){
        liveNeighbors++;
      }
    }
  }
  
  void update(int s){
    updateLiveNeighbors();
    
    if(state == true){
      fill(255,0,0);
    }else{
      fill(255);
    }
    rect(x,y,s,s);
  }
  
  void changeState(boolean b){
    state = b;
  }
  
  void makeNeighbors(ArrayList pop){
    neighbors = new ArrayList();
    for(int i = 0; i<pop.size(); i++){
      Node other = (Node)pop.get(i);
      if(pos.distanceTo(other.pos)<si*1.5 && pos.distanceTo(other.pos) >0){
        neighbors.add(i);
      }
    }
  }
}

class World{
  ArrayList pop;
  World(){
    pop = new ArrayList();
  }
  
  void addNode(Node node){
    pop.add(node);
  }
  
  void update(int s){
    for(int i = 0; i<world.pop.size(); i++){
      Node node = (Node)world.pop.get(i);
      node.update(s);
    }
  }
  
  void nextGeneration(){
    ArrayList newLive = new ArrayList();
    
    for(int i = 0; i<pop.size(); i++){
      Node node = (Node)pop.get(i);
      
      if((node.state == true)&&(node.liveNeighbors == 1)){
        newLive.add(false);
      }
      else if((node.state == true)&&((node.liveNeighbors ==2)||(node.liveNeighbors ==3))){
        newLive.add(true);
      }
      else if((node.state == true)&&(node.liveNeighbors>3)){
        newLive.add(false);
      }
      else if((node.state == false)&&(node.liveNeighbors == 3)){
        newLive.add(true);
      }
      else{
        newLive.add(false);
      }
    }
    
    for(int i = 0; i<pop.size(); i++){
      Node node = (Node)pop.get(i);
      boolean b = (Boolean)newLive.get(i);
      node.changeState(b);
    }
    
  }
}

