class Population {  

  ArrayList population;   // Array to hold the current population  
  DNA solution;  

  String target;    // Target for evolution  
  int popSize;        // Number of individuals  
  boolean end;        // Switch for further evolution  
  ArrayList genePool = new ArrayList();  // Dynamic array to store a "mating pool"  
  float mutationRate = 0.01;  // The probability of any genotype mutating  
  int generations;  
  float fRaw;        // Raw measure of fitness  
  float fMax;        // Highest fitness measure in a generation  
  float fBest;       // Highest fitness measure so far  
  int diversity;     // Index of diversity in the gene pool  

  Population(String t, int pS){  
    target = t;  
    popSize = pS;  

    // Create an initial population  
    population = new ArrayList();  
    for(int i = 0; i < popSize; i++){  
      population.add(new DNA());    // The first generation has random genotypes (see DNA constructors)  
    }      
    solution = new DNA();  
    generations = 0;  
  }  

   

  // Function: evaluate every individual's fitness  
  void evaluateFitness(){  
    // Assign a fitness measure to each individual  
    for(int i = 0; i < population.size(); i++){  
      DNA individual = (DNA) population.get(i);    // Cast the object type (necessary with ArrayList)  
      individual.fitnessN = fitnessN(individual.dna, t);  // Refer to fitness functions  
      individual.fitness = fitness(individual.dna, t);  

      if(individual.fitness == 1){  
        end = true;  
        solution = individual;  
      }  
      //println(individual.dna + " Fitness: " + individual.fitness);  
    }  
  }  

   

  // Function: select genotypes into a mating pool according to their fitness  

  // This function follows the "fitness proportionate selection" a.k.a. "roulette wheel" method  

  void select(){  
    // Calculate each individual's mating chances  
    for(int i = 0; i < population.size(); i++){  
      DNA individual = (DNA) population.get(i);  
      int chances = ceil(individual.fitness * 100);    
      for(int j = 0; j < chances; j++){  // Number of ocurrences in the gene pool is proportional to fitness  
        genePool.add(individual);  
      }  
    }    
  }  

  // Function: Create a new generation  

  void generate(){  
    population = new ArrayList();  
    while(population.size() < popSize){  
      population.add(mate()[0]);  // Call to the mate() function creates two children  
      population.add(mate()[1]);  
    }  

    // Draw the individuals to the screen  

    for(int j = 0; j < population.size(); j++){  
      DNA individual = (DNA) population.get(j);  
      float x = random(width);   // Horizontal position is random  
      float y = map(fitness(individual.dna, t), 0, 1, 464, 30);  // Vertical position according to fitness  
      individual.display(x, y);  
      individual.x = x;  
      individual.y = y;  
    }  

    genePool.clear();  // Empty the gene pool  
    generations++;  
  }  

   

  // Function: combine two DNA sequences  

  DNA[] mate(){  

    diversity = 1;     // Reset gene diversity index  
    char[] child1 = new char[8];  
    char[] child2 = new char[8];  
    DNA parent1 = new DNA();  // Placeholders for parents  
    DNA parent2 = new DNA();  
   
    //String dna1 = new String();  // Parent identifiers  
    //String dna2 = new String();  

    // Test the gene pool for diversity  

    for(int i = 1; i < genePool.size(); i++){  
      DNA genotype = (DNA) genePool.get(i);  // With ArrayList, the type must be cast before calling the item  
      DNA previous = (DNA) genePool.get(i-1);  
      String d = previous.dna;  
      if(genotype.dna.equals(d) == false){  
        diversity++;  // Count the number of different genotypes  
      }  
    }  

    if(diversity > 1){  
      int s = genePool.size();  
      for(int i = 0; i < s; i++){  
        int p1 = int(random(genePool.size()));  
        int p2 = int(random(genePool.size()));  

        parent1 = (DNA) genePool.get(p1);  // Parents are genotypes retrieved from the gene pool  
        parent2 = (DNA) genePool.get(p2);  

        // Prevent mating two equal genotypes  

        if(parent1.dna.equals(parent2.dna) == false){  
          // Crossover  
          // Start by picking a random position in the gene sequence for splicing of parent genes  
          // The first two characters (transparency value) are ignored  
          int crossover = int(random(3, parent1.dna.length()));  
          for(int j = 0; j < parent1.dna.length(); j++){  
            if(j < crossover){                      // To the left of the crossover position,  
              child1[j] = parent1.dna.charAt(j);    // clone parent1's genes for child1  
              child2[j] = parent2.dna.charAt(j);    // and parent2's genes for child2  
            }  
            else{                                   // To the right of the crossover position,  
              child1[j] = parent2.dna.charAt(j);    // clone parent2's genes for child1  
              child2[j] = parent1.dna.charAt(j);    // and parent2's genes for child2  
            }  
          }  
          //dna1 = parent1.dna;  
          //dna2 = parent2.dna;  
        }  
      }  
    }  
    // If there is no diversity in the gene pool, clone a parent  
    else{  
      //println("No diversity in the gene pool!");  
      for(int i = 0; i < child1.length; i++){  
        child1[i] = parent1.dna.charAt(i);  // A clone of the parent, which might mutate  
        child2[i] = parent2.dna.charAt(i);  
      }  
    }  
    stroke(255, 36);  
    strokeWeight(2);  
    line(parent1.x, parent1.y, parent2.x, parent2.y);  // Shows which individuals are mating  
   
    DNA[] children = new DNA[2];  
    children[0] = new DNA(child1, mutationRate);  
    children[1] = new DNA(child2, mutationRate);  
    // Display parent's DNA  
    //println(dnachild1.dna + " Parent 1: " + dna1 + " Parent 2: " + dna2);  
   
    return children;  
  }  
   
  // Fitness functions:  
  // Three functions calculate three measures of fitness:  
  // 1: Raw fitness, the percentage of characters in the genotype that match the target string  
  // 2: Scaled fitness, maintains the proportionality of fitness measures irrespective of target length  
  // 3: Normalized fitness, rescales the values for selection calculations  
   
  // Function: calculate "raw" fitness  
  float fitness(String dna, String target){  
    float fRaw = 0;  
    int score = 0;  
    fMax = 0;  
    // Check the genotype for matches with the target string,  
    // character by character  
    for (int i = 2; i < dna.length(); i++) {  // Transparency characters left out  
      if (dna.charAt(i) == target.charAt(i)) {  
        score++;  
      }  
      fRaw = float(score) / float((target.length())-2);  // The percentage of characters that match the target string, excluding the transparency characters  
      // Record new highest fitness scores, if any  
      if(fRaw > fMax){   
        fMax = fRaw;  
      }  
      if(fRaw > fBest){   
        fBest = fRaw;  
      }  
    }  
    return fRaw;  
  }  
   
  // Function: calculate scaled fitness  
  // -- not essencial for further calculations  
  float fitnessS(String dna, String target){  
    float f = fitness(dna, t);  
    //float fS = pow(2, f);  // Exponential scaling  
    //float fS = 2*f;        // Linear scaling  
    float fS = f;            // No scaling  
    //println(fS);  
    return fS;  
  }  
   
  // Function: calculate normalized fitness  
  float fitnessN(String dna, String target){  
    float fN;  
    float fS;  
    float fPopScale = 0;  
    // Calculate the scaled fitness measure for the given genotype  
    float fScale = fitnessS(dna, t);  
    // Calculate the scaled fitness measure for the entire population  
    for(int i = 0; i < population.size(); i++){  
      DNA individual = (DNA) population.get(i);  
      fS = fitnessS(individual.dna, t);  
      fPopScale += fS;  
    }  
    // Normalize the fitness measure for the given genotype  
    // in relation to the entire population  
    // The fitness measures for all genotypes will add up to 1  
    fN = fScale / fPopScale;    
    return fN;  
  }  
} 

