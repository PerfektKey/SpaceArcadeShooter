class HomingMissle extends sprite{
  
  private sprite Target;//the target to pursui
  
  private particleGenerator explosion;
  final private float baseOnTime = .09;//the ammount of time the particle generator generates
  private float OnTime = 0;
  
  HomingMissle(float sp, boolean process){
    super(new PVector(-100,0),sp,"../assets/ROCKET.png", process);
    explosion = getExplosionGenerator(0.1);
  }
  
  void update(float dt){
    explosion.setGenerating(OnTime > 0);
    explosion.update(dt);
    if (OnTime > 0)
      OnTime -= dt;
    if (!process)
      return;
    //check if Target is viable
    if (Target == null)
      return;
    if (Target.process == false){
      Target = null;
      return;
    }
    //check if target hit
    if (collide(Target)){
      //hit!
      process = false;
      Target.process = false;
      Target.reset(false);
      Target = null;
      OnTime = baseOnTime;
      explosion.setPosition(this.position.copy());
    }
    if (Target == null)
      return;
      
    //rotation and the new velocity
    //this took me like 3hours
    PVector distance = PVector.sub(Target.getPosition(), position);
    float theta = distance.heading();
    PVector vel = new PVector(speed * dt, speed * dt).rotate(theta);
    //move to the target
    this.position.add( vel );
    pushMatrix();
    translate(position.x, position.y);
    rotate( vel.heading() + radians(90));//
    image(img, 0, 0);
    popMatrix();
    //show();
  }
  
  //setter/getter
  
  public void setTarget(sprite t){Target = t;}
  public boolean needTarget(){return Target == null;}

}
