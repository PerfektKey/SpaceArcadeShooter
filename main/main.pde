import java.util.Map;

PImage bg;
player p;

SceneHandler main;

void setup(){
  size(500,750);
  bg = loadImage("../assets/background.png");
  p = new player(new PVector(width/2,height*.7), 150, "../assets/schiff.png");
  Scene game = new Scene(){
    player pl = new player(new PVector(width/2,height*.7), 150, "../assets/schiff.png");;
    ArrayList<Astroide> as = new ArrayList<Astroide>();
    
    @Override
    public void onChange(){
      as.clear();
      for (int i = 0;i < 10;i++){
        as.add(new Astroide(new PVector(50, 2*height), 150, "../assets/asteroid.png"));
      }
    }
    
    @Override
    public void run(){
      pl.update();
      PVector diff = new PVector();
      for (Astroide a : as){
        a.update();
        diff.x = 0;
        diff.y = 0;
        if (pl.collide(a)){
          //println("collide with: ", a);
          diff.x = pl.getPosition().x - a.getPosition().x;
          diff.y = pl.getPosition().y - a.getPosition().y;  
          pl.force.x += diff.x;
          pl.force.y += diff.y;
          a.reset();
          
          break;
        }
      }
    }
    
  };
  //game.add(p);
  
  main = new SceneHandler();
  main.addScene(game,"game");
}

void draw(){
  background(bg);
  
  main.run();
}
