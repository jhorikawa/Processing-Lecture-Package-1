class vWorld {
  ArrayList population;
  
  vWorld() {
     population = new ArrayList();
  }

  // cycles through each agent passing the population to it
  void run(){
    for (int i = 0; i < population.size(); i++) {
      vAgent a = (vAgent) population.get(i);  
      a.step(this); 
    }
  }

  // adds an agent to the population
  void addAgent(vAgent a) {
    population.add(a);
  }
}
