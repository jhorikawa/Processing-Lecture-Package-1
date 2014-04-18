void setup(){
  size(400,400);
}

void draw(){
  background(100);
  noStroke();
  for(int i = 0; i<mouseX; i++){
    fill(255,255-i,255-i);
    ellipse(width/2+i*cos(radians(i*mouseY/10)),height/2+i*sin(radians(i*mouseY/10)),15,15);
  }
}
