void setup(){
  size(400,400);
}

void draw(){
  if(mouseX>width/2){
    background(255,255,50);
  }else if(mouseX<width/2 && mouseY>height/2){
    background(255,50,50);
  }else{
    background(50,50,255);
  }
  
  stroke(0);
  line(width/2,0,width/2,height);
  line(0,height/2,width/2,height/2);
}
