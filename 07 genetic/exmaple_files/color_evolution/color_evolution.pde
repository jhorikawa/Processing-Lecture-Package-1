/*  

my_first_GA  

    

 A simple implementation of a simple genetic algorithm  

 with reference to:   

 Daniel Shiffman, http://www.shiffman.net/teaching/nature/ga/  

 G.W. Flake, "The Computational Beauty of Nature", http://mitpress.mit.edu/books/FLAOH/cbnhtml/home.html  

    

 version 2:  

 * New display and interactivity  

 * Crossover method according to Flake, generates two children per selected pair of parents  

 * Population array is dynamic  

    

 by João Bravo da Costa  

 4 November 2009  

 */ 


Population p;  
   
PFont font;  
PFont info;  
PFont italic;  
   
// The target is a hexadecimal string translatable into a color  
// format: FF (total opacity) + six hexadecimal characters  
String t = "FF8392BA";    
   
int populationSize = 17;  
boolean restart = false;  
   
color field;   
color dark;   
color c;  
   
void setup(){  
  font = createFont("Arial-Bold", 8);
  info =  createFont("Arial-Bold", 16); 
  italic =  createFont("Arial-Bold", 16);
  colorMode(RGB, 255, 255, 255);  
  field = unhex(t);  
  dark = 102;  
  c = 153;  
   
  size(800, 800);  
  smooth();  
  // Initialize a population with random gene sequences    
  p = new Population(t, populationSize);  
  background(dark);  
  panel();  
}  

void draw(){  
  frameRate(12);   
  // Repeat until the target is reached:  
  if((p.end == false) || (restart == true)){  
    noStroke();  
    fill(field, 42);  
    rectMode(CORNER);  
    rect(0, 0, width, 494);  
    // 1. Selection:  
    // Evaluate every individual's fitness  
    p.evaluateFitness();  
    // Select genes according to their fitness and place them into a mating pool  
    p.select();  
    // 2. Reproduction:  
    // Pick pairs of parents from the mating pool  
    // Combine their genes into a third gene sequence (a child)  
    p.generate();  
    // Replace the population (parents) with the new generation (children)  
    displayInfo();  
  }   
  else {  
    noLoop();  
    noStroke();  
    fill(field);  
    rect(0, 0, width, 494);  
    p.solution.display(p.solution.x, p.solution.y);  
  }  
}  
   
// Pressing the mouse button will restart the program  
void mousePressed(){  
  t = hex(get(mouseX, mouseY));  
  field = unhex(t);  
  background(dark);  
  panel();  
  p = new Population(t, populationSize);  // New population with random genes  
  p.end = false;  // Evolution switch reset  
  loop();         // Cycle restarted  
}  
   
// Function: display evolution statistics  
void displayInfo(){  
  if(p.end == false){  
    noStroke();  
    colorMode(RGB, 255, 255, 255);  
    fill(dark);  
    rectMode(CORNER);  
    rect(0, 494, 306, 270);  
    fill(c);  
    textFont(info);  
    textAlign(RIGHT);  
    text("Number of generations: " + p.generations, 306, 556);  
    text(p.diversity + " genotypes / " + p.popSize + " individuals", 306, 586);  
    text("Mutation rate: " + int(p.mutationRate * 100) + "%", 306, 616);  
    text("Best fitness in generation: " + nf(p.fMax, 1, 3), 306, 646);  
    text("Best fitness yet: " + nf(p.fBest, 1, 3), 306, 676);      
    //println(p.generations + " generations. " + "Best fitness: " + p.fMax + " this generation." + p.fBest + " so far.");  
  }  

  else if(restart == false){  
    noStroke();  
    fill(dark);  
    rectMode(CORNER);  
    rect(0, 560, 306, 200);  // Hides text lines  
    //println(p.generations + " generations. " + "Solution: " + p.solution.dna + "  " + p.solution.fitness);  
  }  
}  
   
// Function: draw static text and a range of colors to choose from  
void panel(){  
  colorMode(RGB, 255, 255, 255);  
  noStroke();  
  fill(dark);  
  rect(0, 494, width, 378);  
  fill(c);  
  textFont(italic);  
  textAlign(CENTER);  
  text("Click anywhere on the screen to pick a color and restart.", 553, height-42);  
  textSize(30);  
  text("Color evolution", 553, 650);  
  pushMatrix();  
  translate(0, height-28);  
  colorMode(HSB, width, 100, 100);  
  for(int i = 0; i < width; i++){  
    for(int j = 0; j < 28; j++){  
      stroke(i, 30, 70);  
      point(i, j);  
    }  
  }  
  popMatrix();  
} 
