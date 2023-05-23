class Player extends sprite{
  
  IS inputSystem;
  
  PImage emptyBox;
  PImage FullBoxBlue;
  
  //sound
  SoundFile shoot;
  ///SoundFile rocketExplosion;
  
  //
  int lives = 0;
  int maxLives = 0;
  //===============
  
  //all bullet related variables
  private ArrayList<Bullet> bullets;//the array of bullets
  private int bulletIndex = 0;//the index of the next bullet to fire
  private float BaseReloadTime = 1;//the base time for waiting
  private float reloadTime = 0;//the active counter
  private int BulletAmmount = 10;
  // =========================
  //all shield related variables
  private float shieldTime = 8;//the ammount of time the shield can still be used
  private float maxShieldTime = 2;// the max ammount of time the shield can be used -- has to be a multible of 4 for the energie bar
  private float ShieldRecovery = 0.5;//how much shield time it regenerates per second
  private boolean UsesShield = false;
  //==========================
  //all Missle Related things
  private HomingMissle missle;
  //=========================

  Player(PVector position, IS s){
    super(position, 300, "../assets/schiff.png", true);
    
    inputSystem = s;
    
    //init vars
    emptyBox = loadImage("../assets/bar2.png");
    FullBoxBlue = loadImage("../assets/FullBoxBlue.png");
    bullets = new ArrayList<Bullet>();
    missle = new HomingMissle(300, false);
    
    shoot   = new SoundFile(main.this, "../sound/Shoot.wav");
  }
  
  public void update(float dt){
    //update bullet timer
    if (reloadTime > 0){
      reloadTime -= dt;
      //TODO: show some reloading img or so 
    }
    move(dt);
    MissleHandler(dt);
    bulletHandler(dt);
    ShieldHandler(dt);
    DrawShield();
    drawLives();
    show();
    //draw all of the shots availbale
    int y = 40;//temporary y variable for the box
    int x = 25;//temporary x variable for the box
    for (int i = 0;i < BulletAmmount;i++){
      image(emptyBox,width-x ,height-y);
      //draw the rect if that bullet is not in use
      rectMode(CENTER);
      fill(#FF6105);
      if (i >= bulletIndex && reloadTime <= 0)
        rect(width-x,height-y, 15, 15);
      //incrise the position
      x += 25;
      if ((i+1) % 10 == 0){
        y += 30;
        x = 25;
      }
    }
  }
  
  private void MissleHandler(float dt){
    //if (missle == null)
    //  missle = new HomingMissle(400, false);/**/
    //missle.setProcess( !missle.needTarget() );
    missle.update(dt);
  }
  
  private void ShieldHandler(float dt){
    UsesShield = false;
    if (inputSystem.ispressed("SHIELD")){
      UsesShield = true;
    }
    if (UsesShield)//remove dt from shieldtime if in use
      shieldTime -= dt;
    if (shieldTime < 0)//turn of shield when shield time has run out
      UsesShield = false;
    if (shieldTime < maxShieldTime)//shiedl recovery
      shieldTime += ShieldRecovery * dt;
  }
  private void DrawShield(){
    //draw the shield energie bar
    int x = width-emptyBox.width;
    int y = ceil(height*.8);
    for (int i = 0;i < min(ceil(maxShieldTime),16);i++){
      int ratio = round( maxShieldTime/min(ceil(maxShieldTime),16) );//how many energie points 1 box holds
      if (shieldTime < (i)*ratio)
        image(emptyBox, x, y);
      else
        image(FullBoxBlue, x, y);
      y -= emptyBox.height+5;
    }
    
    //draw shield on player
    if (UsesShield){
      fill(0,0,200,175);
      circle(position.x, position.y, HitboxRadius);
    }
  }
  
  private void drawLives(){
    //draw all of the lives availbale
    int y = 40;//temporary y variable for the box
    int x = 25;//temporary x variable for the box
    for (int i = 0;i < maxLives;i++){
      image(emptyBox,x ,y);
      //draw live
      rectMode(CENTER);
      fill(#FF0000);//full on red
      if (i >= maxLives-lives)
        rect(x,y, 15, 15);
      //incrise the position
      x += 25;
      if ((i+1) % 10 == 0){
        y += 30;
        x = 25;
      }
    }
  }
  
  //move function
  //dt = delta time = time since last frame
  public void move(float dt){
    //the new position vector
    PVector velocity = new PVector();
    
    if (!keyPressed)
      return;
    
    if( inputSystem.ispressed("UP") && ( position.y+img.height/2 > height*.55))
      velocity.y = -(speed * dt);
    if( inputSystem.ispressed("DOWN") && ( position.y+img.height/2 < height))
      velocity.y = (speed * dt);
    
    if (inputSystem.ispressed("LEFT") && position.x-img.width/2 > 0)
      velocity.x = -(speed * dt);
    if (inputSystem.ispressed("RIGHT") && position.x+img.width/2 < width)
      velocity.x = (speed * dt);
    
    position.add(velocity);
  }
  
  //
  private void bulletHandler(float dt){
    //update all bullets and remove or add overflow
    for (int i = 0;i < BulletAmmount;i++){
      if (bullets.size() > BulletAmmount)//remove bullets
        bullets.remove(bullets.size()-1);//remove the last added bullet
      if (bullets.size() < BulletAmmount)//add bullets
        bullets.add(new Bullet(new PVector(-1000,-1000), 250, new PVector(0,-1), false ));
      //set the bullets process to wether or not it is out of bounds
      bullets.get(i).setProcess( !bullets.get(i).outOfBounds() );
      //update the bullet
      bullets.get(i).update(dt);
    }
    
    //reload if key r pressed and we are currently not reloading and we have shoot at the least 1 bullet
    if (inputSystem.pressed("RELOAD") && reloadTime < 0 && bulletIndex > 0){
      reloadTime = BaseReloadTime;
      bulletIndex = 0;
    }

    //check if a new bullet should and can be fired
    if (inputSystem.pressed("SHOOT") && reloadTime <= 0){
      shoot.play();
      //set the bullet up
      bullets.get(bulletIndex).setPosition(this.position);
      bullets.get(bulletIndex).setProcess(true);
      //bullets.get(bulletIndex).setProcess(true); // pretty sure we dont need this
      //incrise the next bullets index
      bulletIndex++;
      //check if we have run out of ammunition
      if (bulletIndex >= bullets.size()){
        //set reload time
        reloadTime = BaseReloadTime;
        //reset the bulletIndex
        bulletIndex = 0;
      }
    }
    
  }
  
  //returns true if any bullet has been hit
  public boolean BulletCollide(sprite other){
      for (Bullet b : bullets){//just use foreach loop with this
        if (!b.collide(other))//if the bullet doesnt hit the sprite continue in the loop
          continue;
        //if we hit stop the bullet {b} from processing and return true
        b.setProcess(false);
        //and set it out of bounds
        b.setPosition(new PVector(-100,-100));//probally set this Pvector to a constant
        return true;
      }
      return false;
  }
  
  //setter and getters
  public ArrayList<Bullet> getBullets(){return bullets;}//since this returns a referenze we dont need a setter
  public boolean UsesShield(){return UsesShield;}
  public void setMissleTarget(sprite other){missle.setTarget(other);}
  public boolean missleNeedTarget(){return missle.needTarget();}
  public void missleFire(){missle.setProcess(true);missle.setPosition(this.position.copy());}
  
  public int getNumBullets(){return BulletAmmount;}
  public void setNumBullets(int i){BulletAmmount = i;}
  public float getReloadTime(){return BaseReloadTime;}
  public void setReloadTime(float f){BaseReloadTime = f;}
  
  public float getMaxShieldTime(){return maxShieldTime;}
  public void setMaxShieldTime(float f){maxShieldTime = f;}
  public float getShieldRecovery(){return ShieldRecovery;}
  public void setShieldRecovery(float f){ShieldRecovery = f;}
  
  public int getLives(){return lives;}
  public void setLives(int i){lives = i;}
  public void decriseLive(){lives -= (lives > 0) ? 1 : 0;}
  public void incriseLive(){lives += (lives < maxLives) ? 1 : 0;}
  public boolean isDead(){return lives <= 0;}
  public int getMaxLives(){return maxLives;}
  public void setMaxLives(int i){maxLives = i;}
}
