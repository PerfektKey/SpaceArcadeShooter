class Ufo extends sprite{
  
  int direction = 1;//
  float shootIntervaleBase = 1;//the time in seconds for shooting
  float shootIntervale = 1;//the current time until next shot
  int BulletIndex = 0;//the current index of the current bullet in the "bullets" array
  int maxBullets = 20;//the maximum amount of bullets
  
  ArrayList<shoot> bullets;
  
  public Ufo(PVector __position, float __speed){
    super(__position, __speed, "../assets/u1.png");
    
    direction = round(random(-1,1));
    direction = 1;
    bullets = new ArrayList<shoot>();
    
    for (int i = 0;i < maxBullets;i++){//init array
      bullets.add(new shoot(new PVector(-10,2*height), -200));
      bullets.get(i).show = false;
    }
  }
  
  @Override
  public void update(){
    if (!show)
      return;
    float dt = 1/frameRate;//the delta time
    
    //move left/right
    position.x += speed * direction * dt;//move
    if ( position.x >= width || position.x <= 0 ){//go other way
      direction *= -1;
      position.y += img.height;
      shootIntervale = shootIntervaleBase;//reset shoot timer otherwise two bullets will be in one shot
    }
    shootIntervale -= dt;//remove time till we shoot
    if (shootIntervale <= 0){//shot if time up
      if ((maxBullets-2)*shootIntervaleBase > (height-getPosition().y)/speed )//should we shoot faster?
        shootIntervaleBase -= shootIntervaleBase * .2;
      shootIntervale = shootIntervaleBase;
      bullets.get(BulletIndex).spawn(new PVector(getPosition().x, getPosition().y));
      BulletIndex++;
      if (BulletIndex >= maxBullets)
        BulletIndex = 0;
    }
    
    for (shoot b : bullets){
      b.update();
    }
  }
  
  public void spawn( PVector into ){
    position.x = into.x;
    position.y = into.y;
  }

}
