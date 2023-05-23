class Ufo extends sprite{
  
  private PVector direction;//the direction it flies in
   
   
  SoundFile shoot = new SoundFile(main.this, "../sound/EnemyShoot.wav");
  
  //all variables reladet to shooting
  private ArrayList<Bullet> Bullets;
  private int bulletAmmount = 10;
  private int bulletIndex = 0;
  private float baseShootIntervial = 1; //how much to wait between shots
  private float ShootIntervial;
  //=================================
  
  Ufo(PVector position, float speed, boolean process){
    super(position, speed, "../assets/ufo.png", process);
    this.direction = new PVector(1,0);
    Bullets = new ArrayList<Bullet>();
    
    //shoot = new SoundFile(main.this, "../sound/EnemyShoot.wav");
  }
  
  public void update(float dt){
    if (!process)
      return;
    move(dt);
    bulletHandler(dt);
    show();
  }
  
  private void move(float dt){
    
    //set the direction
    //if on the end of screen
    if ((position.x > width-5*img.width/2 && direction.x > 0)|| (position.x < 5*img.width/2 && direction.x < 0)){
      direction.y = direction.y * (1+dt) + 0.01;//so we go down
    }else{
      direction.y = 0;
    }
    if (position.x > width-img.width/2)
      direction.x = -abs(direction.x);
     else if (position.x < img.width/2)
       direction.x = abs(direction.x);
    //go down and change direction
    
    
    //go till direction
    //till outside of screen
    
    //update position
    //first create a new vector with {speed}
    //multiply {speed} by {direction}
    //multiply the vector by {dt}
    this.position.add(new PVector(speed * direction.x,speed * direction.y).mult(dt) );
  }
  
  private void bulletHandler(float dt){
    if (!process)
      return;
    ShootIntervial -= dt;//count down
    
    for (int i = 0;i < bulletAmmount;i++){
      if(Bullets.size() < bulletAmmount)
        Bullets.add( new Bullet(new PVector(-100,0), 250, new PVector(0,1), false) );//add more bullets if we donthave enough
      if (Bullets.size() > bulletAmmount)
        Bullets.remove( Bullets.size()-1 );//remove the last bullet if we have too many
      
      Bullets.get(i).setProcess( !Bullets.get(i).outOfBounds() );
      Bullets.get(i).update(dt);
    }
    
    //shoot new shoot
    if (ShootIntervial <= 0){
      
      //shoot.play(); 
      
      //set the bullet up
      Bullets.get(bulletIndex).setPosition(this.position.copy());
      //take care
      bulletIndex++;
      ShootIntervial = baseShootIntervial;
      if (bulletIndex >= Bullets.size()){
        bulletIndex = 0;
      }
    }
  }
  
  public boolean BulletCollide(sprite other){
    for (Bullet b : Bullets){
      if (b.collide(other)){
        b.setPosition(new PVector(-100,0));
        return true;
      }
    }
    return false;
  }
  
  public void ResetBullets(){
    Bullets.clear();//just delete all bullets
  }
  
  
  //setter and getter
}
