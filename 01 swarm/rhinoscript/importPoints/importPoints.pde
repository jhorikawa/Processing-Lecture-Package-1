import toxi.geom.*;
import peasy.*;

PeasyCam cam;

ArrayList ptsList;

void setup(){
  size(400,400,P3D);
  cam = new PeasyCam(this,800);
  cam.setMinimumDistance(500);
  cam.setMaximumDistance(1300);
  
  //initialize arraylist
  ptsList = new ArrayList();
  
  //import text file including point positions
  String[] lines = loadStrings("points.txt");
  for(int i = 0; i<lines.length; i++){
    float[] pts = float(split(lines[i],','));
    ptsList.add(new Vec3D(pts[0],pts[1],pts[2]));
  }
}

void draw(){
  background(0);
  
  //making box
  stroke(255);
  noFill();
  strokeWeight(1);
  box(800);
  
  //plotting imported points
  for(int i = 0; i<ptsList.size(); i++){
    Vec3D v = (Vec3D)ptsList.get(i);
    strokeWeight(5);
    stroke(255);
    point(v.x,v.y,v.z);
  }
}
