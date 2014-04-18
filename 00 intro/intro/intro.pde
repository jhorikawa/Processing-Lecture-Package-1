void setup(){
  size(400,400);
}

void draw(){
  background(0);
  
  //loop
  for(int i = 0; i<20; i++){
    //if condition
    if(i % 4 == 0){
      fill(255,0,0);
    }else{
      fill(255);
    }
    ellipse(20*i,height/2,10,10);
  }
}
