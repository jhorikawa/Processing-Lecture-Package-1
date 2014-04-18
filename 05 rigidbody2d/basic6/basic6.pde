import fisica.*;

FWorld world;

void setup(){
  size(500,500);
  
  Fisica.init(this);
  
  world = new FWorld();
  world.setEdges(0,0,width,height);
  
  FPoly myPoly = new FPoly();
  String lines[] = loadStrings("poly.txt");
  for(int i = 0; i<lines.length; i++){
    float each[] = float(split(lines[i],','));
    myPoly.vertex(each[0],each[1]);
  }
  world.add(myPoly);
  
}

void draw(){
  background(255);
  
  world.step();
  world.draw();
}
