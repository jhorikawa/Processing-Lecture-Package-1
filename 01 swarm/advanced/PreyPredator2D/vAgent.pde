// simple 3D agent class - based on code from dan shiffman
// roland snooks | kokkugia.com | 2007

class vAgent{
  
 Vec2D         acc;
 Vec2D         vel;
 Vec2D         pos;
 Vec2D         vec;
 float        maxVel;
 float        maxForce;
 float        sepScale;
 float        aliScale;
 float        cohScale;
 float        rangeOfVision;

 float        wandertheta;
 float        wanderomega;
 
 float        attOffset = 200;
 float        ht = envSize*2;
 int          drawColor;
   
 String       agentType = "vAgent";
 
 Vec2D sumSep = new Vec2D(0,0);
 
 // constructor simple
 vAgent(
     Vec2D _pos, 
     Vec2D _vec, 
     float _maxVel,
     float _maxForce){
   
   acc = new Vec2D(0,0);
   vel = new Vec2D(random(-1,1),random(-1,1));    
   pos = _pos.copy();
   vec = _vec.copy();
   maxVel = _maxVel;
   maxForce = _maxForce;
   
   sepScale = 7;
   aliScale = 0.7;
   cohScale = 1;
    
   rangeOfVision = 50; 

   drawColor = 255;
   
 }
 
 // constructor complete
  vAgent(
     Vec2D _pos, 
     Vec2D _vec, 
     float _maxVel,
     float _maxForce,
     Vec2D _vel,
     float _sepScale,
     float _aliScale,
     float _cohScale,
     float _rangeOfVision){
   
   acc = new Vec2D(0,0);
   vel = _vel.copy();    
   pos = _pos.copy();
   vec = _vec.copy();
   maxVel = _maxVel;
   maxForce = _maxForce;
   
   sepScale = _sepScale;
   aliScale = _aliScale;
   cohScale = _cohScale;
    
   rangeOfVision = _rangeOfVision; 
   drawColor = 255;
 }
 
 
 // calculates new location
 void step(vWorld world){ 
    updatePop(world.population);
    
    vel.addSelf(acc);
    vel.limit(maxVel);  
    pos.addSelf(vel);
    acc = new Vec2D(0,0);  // reset acc to 0 each iteration
    
    borders();
    render();
 }
 
 
 void updatePop(ArrayList pop){  
    
    // call population functions
    Vec2D sep = separate(pop);   
    Vec2D ali = align(pop);      
    Vec2D coh = cohesion(pop);   
    
    // weight vector
    sep.scaleSelf(sepScale);
    ali.scaleSelf(aliScale);
    coh.scaleSelf(cohScale);
    
    // add the vectors to acceleration
    acc.addSelf(sep);
    acc.addSelf(ali);
    acc.addSelf(coh);
  }    
 
 

 // steer
 Vec2D steer(Vec2D target, float threshold) {
    target.subSelf(pos); 
    float dist = target.magnitude();

    if (dist > 0 && dist < threshold) {
      target.normalize();
      target.scaleSelf(maxVel);
      target.subSelf(vel); 
      target.limit(maxForce); 
    } 
    else {
      target = new Vec2D(0,0);
    }
    return target;
  }


  // seek
  void seek(Vec2D target, float threshold) {
    acc.addSelf(steer(target, threshold));
  }
   
   
  // flee  
  void flee(Vec2D target, float threshold){
    acc.subSelf(steer(target, threshold));
  }   
  
  
  // wander
  void wander() {
    float wanderR =8;         
    float wanderD = 60;         
    float change = 0.1;
    wandertheta += random(-change,change);

    Vec2D circleloc = vel.copy(); 
    circleloc.normalize();            
    circleloc.scaleSelf(wanderD);          
    circleloc.addSelf(pos);              

    Vec2D circleOffSet = new Vec2D(wanderR*cos(wandertheta),wanderR*sin(wandertheta));
    //Vec3D circleOffSet = new Vec3D(wanderR*sin(wandertheta)*cos(wanderomega),wanderR*sin(wandertheta)*sin(wanderomega),wanderR*cos(wandertheta));
    circleOffSet.addSelf(circleloc);
    acc.addSelf(steer(circleOffSet,ht)); 
  }  


// separation
  Vec2D separate (ArrayList pop) {
    Vec2D sum = new Vec2D(0,0);
    int count = 0;

    for (int i = 0 ; i < pop.size(); i++) {
      vAgent other = (vAgent) pop.get(i);
      float dist = pos.distanceTo(other.pos);
      
      if ((dist > 0) && (dist < rangeOfVision/1.5)) {
        Vec2D diff = pos.copy(); 
        diff.subSelf(other.pos);
        diff.normalize();
        diff.scaleSelf(1/dist);          
        sum.addSelf(diff);
        count++;                     
      }
    }
    if (count > 0) {
      sum.scaleSelf(1/(float)count);
    }
    sumSep = sum.copy();
    return sum;
  }
 
 
  // alignment
  Vec2D align (ArrayList pop) {
    Vec2D sum = new Vec2D(0,0);
    int count = 0;
    for (int i = 0 ; i < pop.size(); i++) {
      vAgent other = (vAgent) pop.get(i);
      float dist = pos.distanceTo(other.pos);
      if ((dist > 0) && (dist < rangeOfVision)) {
        sum.addSelf(other.vel);
        count++;
      }
    }
    if (count > 0) {
      sum.scaleSelf(1/(float)count);
      sum.limit(maxForce);
    }
    return sum;
  }


  // cohesion
  Vec2D cohesion (ArrayList pop) {
    Vec2D sum = new Vec2D(0,0);   
    int count = 0;
    for (int i = 0 ; i < pop.size(); i++) {
      vAgent other = (vAgent) pop.get(i);
      float dist = pos.distanceTo(other.pos);
      if ((dist > 0) && (dist < rangeOfVision)) {
        sum.addSelf(other.pos); 
        count++;
      }
    }
    if (count > 0) {
      sum.scaleSelf(1/(float)count);
      return steer(sum, ht);
    }
    return sum;
  }


  void render() {
    strokeWeight(2);
    stroke(255);
    Line2D l = new Line2D(pos,pos.add(vel.normalize().scale(5)));
    gfx.line(l);
    point(pos.x,pos.y);
  }
  
  
  void borders() {
    if (pos.x < 0) pos.x = width;
    if (pos.y < 0) pos.y = height;
    if (pos.x > width) pos.x = 0;
    if (pos.y > height) pos.y = 0;
  }

}
