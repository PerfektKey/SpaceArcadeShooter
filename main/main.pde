import java.util.Map;

PImage bg;
player p;

SceneHandler main;

long HighScore = 0;

void setup(){
  size(500,750);
  bg = loadImage("../assets/background.png");
  p = new player(new PVector(width/2,height*.7), 150, "../assets/schiff.png");
  JSONObject save = new JSONObject();
  if (loadJSONObject("data/gameData.json") != null){
    save = loadJSONObject("data/gameData.json");
    HighScore = save.getLong("HS");
  }
  
  main = new SceneHandler();
  
  Scene test = new Scene(){
    particleGenerator pg = new particleGenerator(new PVector(width/2,height/2),1,0,3,color(255,0,0,200),color(225,225,225,255),new PVector(10,10),new PVector(0,0),new PVector(0,-1.5),new PVector(25,25),new PVector(-1,0),new PVector(1,0));
    @Override
    public void run(){
      float dt = 1/frameRate;
      pg.update(dt);
    }
  };
  
  Scene menu = new Scene(){
    float i = 0;
    @Override
    public void onChange(){
      JSONObject save = new JSONObject();
      save.setLong("HS",HighScore);
      saveJSONObject(save, "data/gameData.json");
    }
    
    @Override
    public void run(){
      pushMatrix();
      textAlign(CENTER);
      textSize(40);
      text("High score:"+HighScore,width/2,60);
      stroke(#FF4603);
      //rotate(radians(sin(i)%180));
      translate(width/2,height/2);
      rotate(radians(sin(i)%360));
      i+= .25;
      text("press ENTER to start",0,0);
      if (keyPressed && key == ENTER)
        main.changeScene("game");
      stroke(255);
      popMatrix();
    }
  };
  Scene game = new Scene(){
    player pl = new player(new PVector(width/2,height*.7), 200, "../assets/schiff.png");;
    ArrayList<Astroide> as = new ArrayList<Astroide>();
    ArrayList<shoot> bullets = new ArrayList<shoot>();
    int shootIndex = 0;
    boolean canShoot = true;
    int lifes = 3;
    PImage heart = loadImage("../assets/heart.png");
    long score = 0;
    long timeIn = 0;
    long gameStart = 0;
    particleGenerator leftThrust = new particleGenerator(new PVector(width/2,height/2),1,0,3,color(255,0,0,200),color(225,225,225,255),new PVector(10,10),new PVector(0,0),new PVector(0,-1.5),new PVector(25,25),new PVector(-1,0),new PVector(1,0));
    //int w = heart.width;
    //heart.resize(10,10);
    
    @Override
    public void onChange(){
      lifes = 3;
      gameStart = millis();
      score = millis() - gameStart;
      timeIn = millis() - gameStart;
      as.clear();
      bullets.clear();
      for (int i = 0;i < 10;i++){
        bullets.add(new shoot(new PVector(0,2*height), 250,"../assets/bullet.png" ));
      }
      for (int i = 0;i < 10;i++){
        as.add(new Astroide(new PVector(0,20+height), 150, "../assets/asteroid.png"));
      }
      for (Astroide ass : as){
        ass.setOthers(as);
        ass.reset();
        
      }
        
    }
    
    @Override
    public void run(){
      if (lifes <= 0){
        if (score > HighScore)
          HighScore = score;
        main.changeScene("menu");        
      }
      timeIn += millis() - timeIn;
      long tmp = score + timeIn/10;
      textSize(32);
      textAlign(CENTER);
      text(str(tmp),width/2,40);
      pl.update();
      PVector diff = new PVector();
      int sizeFact = 2;
      for (int i = 1;i <= lifes;i++)
        image(heart,heart.width*sizeFact*i,heart.height*sizeFact,heart.width*sizeFact,heart.height*sizeFact);
        
      
      if (keyPressed && key == ' ' && canShoot){
        bullets.get(shootIndex).spawn(pl.getPosition());
        canShoot = false;
        shootIndex++;
        if (shootIndex >= bullets.size())
          shootIndex = 0;
      }
      if (!keyPressed)
        canShoot = true;
      for (shoot bullet : bullets)
        bullet.update();
      for (Astroide a : as){
        a.update();
        diff.x = 0;
        diff.y = 0;
        for (shoot bullet : bullets){
          //bullet.update();
          if (bullet.show == true && a.collide(bullet)){
            //println("hit from:",bullet," to:",a);
            a.reset();
            bullet.show = false;
            score += max(100,100 * timeIn/1000);
          }
        }
            
        if (pl.collide(a)){
          //println("collide with: ", a);
          lifes--;
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
  main.addScene(test,"test");
  main.addScene(game,"game");
  main.addScene(menu,"menu");
  main.changeScene("test");
}

void draw(){
  background(bg);
  
  //if (main.currentSceneName == "game" && main.currentScene.lifes == 0)
  main.run();
}
