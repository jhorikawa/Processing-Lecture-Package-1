//___________________________PARTICLE PHYSICS FUNCTIONS_________________________//

void addParticleBehaviors(){
  physics.behaviors.clear();
  physics2.behaviors.clear();
  physics3.behaviors.clear();
  addSepCoh();
  addGravity();
}

//adding gravity behavior
void addGravity(){
  waterGravity = new GravityBehavior(new Vec3D(0, 0,-1+0.5*cos(radians(frameCount))));
  //physics.removeBehavior(waterGravity);
  physics.addBehavior(waterGravity);
  //physics2.removeBehavior(waterGravity);
  physics2.addBehavior(waterGravity);
  physics3.addBehavior(waterGravity);
}

void addSepCoh(){
  for(int i = 0; i<physics.particles.size(); i++){
    VerletParticle p = (VerletParticle)physics.particles.get(i);
    float w = p.getWeight();
    AttractionBehavior separationAttractor = new AttractionBehavior(p, sepDist, -.10-.2*w, 0.00f);
    AttractionBehavior cohesionAttractor = new AttractionBehavior(p, 1000, 0.001f, 0.00f);
    
    physics.addBehavior(separationAttractor);
    
    for(int n =0; n<physics2.particles.size(); n++){
      VerletParticle pn = (VerletParticle)physics2.particles.get(n);
      separationAttractor.apply(pn);
    }
    for(int n =0; n<physics3.particles.size(); n++){
      VerletParticle pn = (VerletParticle)physics3.particles.get(n);
      separationAttractor.apply(pn);
    }
  }
}

//adding particles inside the box at random position
void addParticles(){
  for(int i = 0; i<numParticles; i++){
    VerletParticle p = new VerletParticle(random(-boxSize/2,boxSize/2),random(-boxSize/2,boxSize/2),random(-boxSize/2,boxSize/2),weight);
    physics.addParticle(p);
  }
}

void updateConstraint(){
  if(setConstraint){
    for(int i = 0; i<physics.particles.size(); i++){
      VerletParticle p = (VerletParticle)physics.particles.get(i);
      p.constraints = new ArrayList();
      AABB constBox = new AABB(new Vec3D(agent.pos.x,agent.pos.y,agent.pos.z),constBoxSize/2); 
      b = new BoxConstraint(constBox);
      pushMatrix();
      translate(agent.pos.x,agent.pos.y,agent.pos.z);
      noFill();
      strokeWeight(1);
      stroke(255,255,0);
      box(constBoxSize);
      popMatrix();
      p.addConstraint(b);
    }
  }else{
    for(int i = 0; i<physics.particles.size(); i++){
      VerletParticle p = (VerletParticle)physics.particles.get(i);
      p.constraints = new ArrayList();
    }
  }
}

//changing the population of particles
void changeParticles(){
  if(numParticles == 0){
    physics.particles.clear();
  }else{
    if(physics.particles.size() != numParticles){
      int n = numParticles - physics.particles.size();
      while(n<0 && physics.particles.size()>0){
        VerletParticle p = (VerletParticle)physics.particles.get(0);
        physics.particles.remove(0);
        n = numParticles - physics.particles.size();
      }
      if(n>0){
        for(int i = 0; i<abs(n); i++){
          VerletParticle p = new VerletParticle(random(-boxSize/2,boxSize/2),random(-boxSize/2,boxSize/2),random(-boxSize/2,boxSize/2),weight);
          physics.addParticle(p);
        }
      }
    }
  }
}

//change spring length
void changeSpringLength(){
  for(int i = 0; i<physics2.springs.size(); i++){
    VerletSpring s = (VerletSpring)physics2.springs.get(i);
    s.setRestLength(springLength);
  }
  for(int i = 0; i<physics3.springs.size(); i++){
    VerletSpring s = (VerletSpring)physics3.springs.get(i);
    s.setRestLength(springLength);
  }
}

//reset the particles
void resetParticles(){
  physics.particles.clear();
  addParticles();
}

//render particles
void updateParticles(){
  for(int i = 0; i<physics.particles.size();i++){
    VerletParticle p = (VerletParticle)physics.particles.get(i);
    strokeWeight(2);
    stroke(255);
    point(p.x,p.y,p.z);
  }
  
  if(showSpring){
    if(springmode == 0){
      for(int i = 0; i<physics2.particles.size();i++){
        VerletParticle p = (VerletParticle)physics2.particles.get(i);
        strokeWeight(4);
        stroke(255,0,0);
        point(p.x,p.y,p.z);
      }
      
      for(int i = 0; i<physics2.springs.size(); i++){
        VerletSpring s = (VerletSpring)physics2.springs.get(i);
        VerletParticle a = s.a;
        VerletParticle b = s.b;
        strokeWeight(1);
        stroke(0,255,0);
        line(a.x,a.y,a.z,b.x,b.y,b.z);
      }
    }
    
    if(springmode == 1){
      for(int i = 0; i<physics3.particles.size(); i++){
        VerletParticle p = (VerletParticle)physics3.particles.get(i);
        strokeWeight(4);
        stroke(255,0,0);
        point(p.x,p.y,p.z);
      }
      for(int i = 0; i<physics3.springs.size(); i++){
        VerletSpring s = (VerletSpring)physics3.springs.get(i);
        VerletParticle a = s.a;
        VerletParticle b = s.b;
        strokeWeight(1);
        stroke(0,255,0);
        line(a.x,a.y,a.z,b.x,b.y,b.z);
      }
    }
  }
}

//adding spring
void addSprings(){
  for(int n = 0; n<3; n++){
    for(int i = 0; i<=numSprings; i++){
      VerletParticle p = new VerletParticle(-boxSize/3+boxSize/3*n,-boxSize/2+boxSize/numSprings*i,boxSize/2);
      if(i == 0 || i == numSprings){
        p.lock();
      }
      physics2.addParticle(p);
    }
    for(int i = n*numSprings+n; i<(n+1)*numSprings+n;i++){
      VerletParticle p1 = (VerletParticle)physics2.particles.get(i);
      VerletParticle p2 = (VerletParticle)physics2.particles.get(i+1);
      VerletSpring s = new VerletSpring(p1,p2,springLength,1);
      physics2.addSpring(s);
    }
  }
}
