class PickUp extends sprite{
  
  protected boolean finished;
  
  PickUp(float speed, String data, boolean process){
    super(new PVector(), speed, data, process);
  }
  
  public void update(float dt){
    if (!process)
      return;
    //check if inside bounds
    //go down
    position.add( new PVector(0, speed).mult(dt) );
    //show
    show();
  
  }
  
  public void effect(float dt, Player p){}
  
  //setter/getter
  public boolean isFinished(){return finished;}
}
//*********************************************

//*********************************************
class FullHealth extends PickUp{
  FullHealth(){
    super(300, "../assets/pickUp1.png", true);
  }
  
  @Override
  public void effect(float dt, Player p){
     p.setLives( p.getMaxLives() );
     finished = true;
  }
}
//*********************************************

//*********************************************
class IncriseMaxHealth extends PickUp{
  IncriseMaxHealth(){
    super(300, "../assets/pickUp2.png", true);
  }
  
  @Override
  public void effect(float dt, Player p){
     p.setMaxLives( p.getMaxLives() + 1 );
     finished = true;
  }
}
//*********************************************

//*********************************************
class AddBullet extends PickUp{
  AddBullet(){
    super(300, "../assets/pickUp3.png", true);
  }
  
  @Override
  public void effect(float dt, Player p){
     p.setNumBullets( p.getNumBullets() + 1 );
     finished = true;
  }
}
//*********************************************
class AddShieldTime extends PickUp{
  AddShieldTime(){
    super(300, "../assets/pickUp4.png", true);
  }
  
  @Override
  public void effect(float dt, Player p){
     p.setMaxShieldTime( p.getMaxShieldTime() + 1 );
     finished = true;
  }
}
//*********************************************
