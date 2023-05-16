class Player extends sprite{
  
  private HashMap<Character, Boolean> keys = new HashMap<Character, Boolean>(); // boolean map for the pressed keys
  //maybe thsi should be a const(final)?
  
  PImage emptyBox;
  
  //all bullet related variables
  private ArrayList<Bullet> bullets;//the array of bullets
  private int bulletIndex = 0;//the index of the next bullet to fire
  private float BaseReloadTime = 1;//the base time for waiting
  private float reloadTime = 0;//the active counter
  private boolean UseReload = true;//if false no Reload needed
  private boolean oneShot = true;
  private boolean shoot = false;
  private int BulletAmmount = 10;
  // =========================
  //all shield related variables
  private float shieldTime;//the ammount of time the shield can still be used
  private float maxShieldTime;// the max ammount of time the shield can be used
  private float ShieldRecovery;//how much shield time it regenerates per second
  private float shieldRecoveryTimer;//the timer for recovery IDK
  private boolean UsesShield;
  //==========================

  Player(PVector position){
    super(position, 300, "../assets/schiff.png");
    //movement keys
    keys.put('w', false);
    keys.put('a', false);
    keys.put('s', false);
    keys.put('d', false);
    //space key for shooting
    keys.put(' ', false);
    //for reloading
    keys.put('r', false);
    //for toogling shield use
    keys.put('f', false);
    
    //init vars
    emptyBox = loadImage("../assets/bar2.png");
    bullets = new ArrayList<Bullet>();
  }
  
  public void update(float dt){
    //update bullet timer
    if (reloadTime > 0){
      reloadTime -= dt;
      //TODO: show some reloading img or so 
    }
    move(dt);
    bulletHandler(dt);
    ShieldHandler(dt);
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
  
 //update the pressed key
  void keyHandler(char k, boolean b){
        keys.replace(k, b);
  }
  
  private void ShieldHandler(float dt){
    if (UsesShield)//remove dt from shieldtime if in use
      shieldTime -= dt;
    if (shieldTime < 0)//turn of shield when shield time has run out
      UsesShield = false;
    if (shieldTime < maxShieldTime)//shiedl recovery
      shieldTime += shieldRecoveryTimer * dt;
    if (keys.get('f')){
      UsesShield = !UsesShield;
    }
  }
  private void DrawShield(){
    //draw the shield energie bar
    
    //draw shield on player
    if (UsesShield){
      fill(0,0,225,200);
      circle(HitboxRadius, position.x, position.y);
    }
  }
  
  //move function
  //dt = delta time = time since last frame
  public void move(float dt){
    //the new position vector
    PVector velocity = new PVector();
    
    //println(keys.get('w'));
    
    if (!keyPressed)
      return;
    
    if( keys.get('w') && ( position.y+img.height/2 > height*.55))
      velocity.y = -(speed * dt);
    if( keys.get('s') && ( position.y+img.height/2 < height))
      velocity.y = (speed * dt);
    
    if (keys.get('a') && position.x-img.width/2 > 0)
      velocity.x = -(speed * dt);
    if (keys.get('d') && position.x+img.width/2 < width)
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
        bullets.add(new Bullet(new PVector(-100,-100), 250, new PVector(0,-1), false ));
      //set the bullets process to wether or not it is out of bounds
      bullets.get(i).setProcess( !bullets.get(i).outOfBounds() );
      //update the bullet
      bullets.get(i).update(dt);
    }
    
    //reload if key r pressed and we are currently not reloading and we have shoot at the least 1 bullet
    if (keys.get('r') && reloadTime < 0 && bulletIndex > 0){
      reloadTime = BaseReloadTime;
      bulletIndex = 0;
    }
    
    //check if can shoot
    if (!keys.get(' '))
      shoot = false;
    //check if a new bullet should and can be fired
    if (keys.get(' ') && reloadTime <= 0 && !shoot){
      shoot = true;
      //println("new friend");
      //set the bullet up
      bullets.get(bulletIndex).setPosition(this.position);
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
        b.setPosition(new PVector(-100,0));//probally set this Pvector to a constant
        return true;
      }
      return false;
  }
  
  //setter and getters
  public ArrayList<Bullet> getBullets(){return bullets;}//since this returns a referenze we dont need a setter
}
