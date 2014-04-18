//import processing.opengl.*;
import toxi.processing.*;
import toxi.geom.*;
import toxi.physics.*;
import toxi.physics.behaviors.*;
import toxi.physics.constraints.*;
import peasy.*;
import volatileprototypes.Panel4P.*;

PeasyCam cam;
Panel4P panel;
VerletPhysics physics;
VerletPhysics physics2;
VerletPhysics physics3;
GravityBehavior waterGravity;
BoxConstraint b;
vAgent agent;
vAgent agent2D;
ToxiclibsSupport gfx;
NavierStokesSolver fluidSolver;
Random rnd = new Random();

//variables for fluid
double visc = 0.0008f;
double diff = 0.25f;
double limitVelocity = 200;
double velocityScale = 16;
double vScale;
int oldMouseX = 1, oldMouseY = 1;

//set variables for controlling parameters
public int fluidmode=0;
public int springmode=0;
public boolean setFluid = false;
public boolean showSpring = false;
public boolean setConstraint = false;
public int numParticles = 500;
public float boxSize = 300;
public float envSize = boxSize/2;
public float sepDist = 70;
public int numSprings = 15;
public float springLength = boxSize/numSprings*1.75;
public float constBoxSize = 100;

int weight = 3;

void setup(){
  size(600,600,P3D);
  
  //initializing fluid solver
  fluidSolver = new NavierStokesSolver();
  frameRate(60);
  
  //initializing camera
  cam = new PeasyCam(this, 500);
  cam.setMinimumDistance(500);
  cam.setMaximumDistance(1200);
  
  //initializing toxiclibcore class
  gfx=new ToxiclibsSupport(this);
  
  //initializing controlling panel
  panel = new Panel4P(this);
  panel.addLabel("p","Switch");
  panel.addButton("resetParticles","Reset");
  panel.addButton("showSpring","Springs",0);
  panel.addButton("setFluid","Fluid",0);
  panel.addButton("setConstraint","Constraint",0);
  panel.addLabel("q","Fluid Control");
  String[] e = {"Mouse","Random"};
  panel.addButtonGroup("fluidmode",e,0);
  panel.addLabel("s","Spring Type");
  String[] sm = {"Spring1","Spring2"};
  panel.addButtonGroup("springmode",sm,0);
  panel.addLabel("c","Parameter Sliders");
  panel.addSlider("numParticles","Number of Particles",0,1000,numParticles,4);
  panel.addSlider("sepDist","Separation Distance",40,100,sepDist);
  panel.addSlider("springLength","Spring Length",10,100,springLength);
  panel.addSlider("constBoxSize","Constraint Box Size",25,200,constBoxSize);
  panel.autoSize();
  
  //initialize wondering agent
  agent = new vAgent(new Vec3D(random(-boxSize/2,boxSize/2),random(-boxSize/2,boxSize/2),random(-boxSize/2,boxSize/2)),
                   new Vec3D(random(-1,1),random(-1,1),random(-1,1)), 4, 0.3);
  agent2D = new vAgent(new Vec3D(random(-boxSize/2,boxSize/2),random(-boxSize/2,boxSize/2),boxSize/2),
                     new Vec3D(random(-1,1),random(-1,1),0), 10, 2);
  

  //setup physics field
  physics = new VerletPhysics();
  physics.setDrag(0.5);
  physics.setWorldBounds(new AABB(boxSize/2));
  addParticles();
  
  //make spring
  physics2 = new VerletPhysics();
  physics2.setDrag(0.5);
  physics2.setWorldBounds(new AABB(boxSize/2));
  addSprings();
  
  //spring network
  physics3 = new VerletPhysics();
  physics3.setDrag(0.5);
  physics3.setWorldBounds(new AABB(boxSize/2));
  
  
  String points[] = loadStrings("points.txt");
  for(int i = 0; i<points.length; i++){
    float pointsPosition[] = float(split(points[i],','));
    VerletParticle p = new VerletParticle(pointsPosition[0],pointsPosition[1],pointsPosition[2]);
    if(i<4){
      p.lock();
    }
    physics3.addParticle(p);
  }
  
  
  int startPoints[] = int(loadStrings("startPoint.txt"));
  int endPoints[] = int(loadStrings("endPoint.txt"));
  for(int i = 0; i<startPoints.length; i++){
    VerletParticle p1 = (VerletParticle)physics3.particles.get(startPoints[i]);
    VerletParticle p2 = (VerletParticle)physics3.particles.get(endPoints[i]);
    VerletSpring s = new VerletSpring(p1,p2,springLength,1);
    physics3.addSpring(s);
  }
}

void draw(){
  background(50);
  
  //fluid related
  updateFluid();
  //agent related
  updateAgent();
  
  //particle physics related
  addParticleBehaviors();
  changeParticles();
  updateParticles();
  changeSpringLength();
  updateConstraint();
  
  physics.update();
  physics2.update();
  physics3.update();
  
  drawBox();
}

//__________________________AGENT FUNCTIONS_________________________//

//update agent position
void updateAgent(){
  agent.selfWander();
}


//___________________________OTHER FUNCTIONS_________________________//

//draw box
void drawBox(){
  stroke(150);
  strokeWeight(1);
  noFill();
  box(boxSize);
  fill(100);
  pushMatrix();
  translate(0,0,-boxSize/2);
  rect(-boxSize/2,-boxSize/2,boxSize,boxSize);
  popMatrix();
}
