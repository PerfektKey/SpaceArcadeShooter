class Bullet extends sprite{
  
  PVector direction; // the direction the bullet flies
  //its between -1 and 1
  
  private boolean outOfBounds = false;// if the bullet is outside of the window set this to true
  
  private boolean process = true;//wether or not to update this bullet
  
  Bullet(PVector position, float speed, PVector direction, boolean process){
    super(position, speed, "../assets/bullet.png");
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
  
  }
  
  public void update(float dt){
    if (!process)
      return;
    move(dt);
    show();
  }
  
  private void move(float dt){
    
    //go till direction
    //till outside of screen
    
    //update position
    //first create a new vector with {speed}
    //multiply {speed} by {direction}
    //multiply the vector by {dt}
    this.position.add(new PVector(speed * direction.x,speed * direction.y).mult(dt) );
  }
  
  //setter and getter
  public boolean outOfBounds(){
    outOfBounds = false;
    //check if outside of the window
    //check x 
    if (position.x < 0 || position.x > width)
      outOfBounds = true;
    //check y
    if (position.y < 0 || position.y > height)
      outOfBounds = true;
    return outOfBounds;
  }
  public void setProcess(boolean b) {process = b;}
  public boolean getProcess() {return process;}
}
