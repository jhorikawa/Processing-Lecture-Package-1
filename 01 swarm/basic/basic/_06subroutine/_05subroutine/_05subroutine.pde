void setup(){
  size(400,400);
  smooth();
}

void draw(){
  sampleSubroutine1();
  sampleSubroutine2(100);
}

void sampleSubroutine1(){
  fill(255,255,0);
  ellipse(100,height/2,30,30);
}

void sampleSubroutine2(int r){
  fill(255,0,0);
  ellipse(300,height/2,r,r);
}
