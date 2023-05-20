class Asteroid extends sprite{//pretty much just the Bullet class
  PVector direction; // the direction the bullet flies
  //its between -1 and 1
  
  private float maxSpeed = 500;//astroids get faster, this is the fastest speed
  
  private particleGenerator Explosion;
  final private float baseOnTime = .09;//the ammount of time the particle generator generates
  private float OnTime = 0;
  
  Asteroid(PVector position, float speed, PVector direction, boolean process){
    //add a bit of randomness to the speed, this looks better
    super(position, speed + random(-50,50), "../assets/asteroid.png", true);
    this.direction = direction;
    this.process = process;
    //limit the direction vector to -1 and 1
    //x
    if (direction.x > 1)
      direction.x = 1;
    else if (direction.x < -1)
      direction.x = -1;
    //y  
    if (direction.y > 1)
      direction.y = 1;
    else if (direction.y < -1)
      direction.y = -1;
    //init things
    Explosion = new particleGenerator(
      new PVector(0,0),
      50,
      0.0,
      .05,
      color(255,23,21), color(255,23,21),
      new PVector(7,7), new PVector(2,2),
      new PVector(1,1),
      new PVector(800,800),
      0.0, 360.0
      );
      Explosion.setGenerating(false);
  }
  
  public void update(float dt){
    if (!process)
      return;
    move(dt);
    show();
    Explosion.update(dt);
    if (OnTime > 0)
      OnTime -= dt;
    Explosion.setGenerating(OnTime > 0);
  }
  
  private void move(float dt){
    
    //go to direction
    //till outside of screen
    
    //update position
    //first create a new vector with {speed}
    //multiply {speed} by {direction}
    //multiply the vector by {dt}
    this.position.add(new PVector(speed * direction.x,speed * direction.y).mult(dt) );
    
    //incrise speed by dt * 0.5
    //if this incrise is too fast or slow, fine tune it
    if (speed < maxSpeed)
      speed += dt * 0.5;
  }
  
  public void reset(boolean exp){
    //explode if exp is true
    process = true;
    if (exp){
      //set the generators position zo the asteroids
      Explosion.setPosition(position.copy());
      Explosion.setGenerating(true);
      OnTime = baseOnTime;//the time it stays on
    }
    //set {position.y} to -10 and {position.x} to random(0,width)
    //no if we set {position.y} to -10 it will again be out of bound resulting in a infinite reset() loop
    position.y = 0;
    position.x = random(img.width, width-img.width);
    //perfect
  }
  
  //setter and getter
}
