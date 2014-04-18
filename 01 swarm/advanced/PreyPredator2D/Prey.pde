class vAgentPrey extends vAgent{
   
 vAgentPrey(     
     Vec2D _pos, 
     Vec2D _vec, 
     float _maxVel,
     float _maxForce){
       
  super(
     _pos, 
     _vec, 
     _maxVel,
     _maxForce);
     
     drawColor = 255;
     agentType = "vAgentPrey";
  }
 
  
   void updatePop(ArrayList pop){  
    
    Vec2D predFlee = this.preditorFlee(pop);
     
    // call population functions
    Vec2D sep = separate(pop);   
    Vec2D ali = align(pop);      
    Vec2D coh = cohesion(pop);   
    
    // weight vector
    sep.scaleSelf(sepScale);
    ali.scaleSelf(aliScale);
    coh.scaleSelf(cohScale);
    
    predFlee.scaleSelf(10);
    
    // add the vectors to acceleration
    acc.addSelf(sep);
    acc.addSelf(ali);
    acc.addSelf(coh);
    
    acc.subSelf(predFlee);
  } 
  
  Vec2D preditorFlee(ArrayList pop){
   // find closest agent
   float closestDist = envSize*envSize;
   int closestAgent = 0;
   for(int i = 0; i<pop.size(); i++){
     vAgent other = (vAgent) pop.get(i);
     if(other.agentType == "vAgentPredator"){
       float dist = pos.distanceTo(other.pos);
       if(i > 0){
         if(dist < closestDist){
           closestDist = dist;
           closestAgent = i;
         }
           
       }else{
         closestDist = dist;
         closestAgent = 0;
       }
     }

   }
    
    // seek closest agent
    vAgent other = (vAgent) pop.get(closestAgent);
    Vec2D target = other.pos.copy();
    return this.steer(target, 50); 
  
  }
   
}
