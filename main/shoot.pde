class shoot extends sprite{

  shoot(PVector __position, float __speed, String path){
    super(__position, __speed, path);
  }
  
  @Override
  public void update(){
    if (!show)
      return;
    move();
    show();
  }
  
  public void spawn(PVector pos){
    show = true;
    position = pos;
  }
  
  private void move(){
    double dt = 1/frameRate;
    position.y -= speed * dt;
    if (position.y > img.height+height)
      position.y = -img.height;
    if (position.y < -img.height)
      show = false;
  }
}
