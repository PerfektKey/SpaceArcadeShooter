class Astroide extends sprite{
  
  Astroide(PVector __position, float __speed, String path){
    super(__position, __speed, path);
  }
  
  public void move(){
    double dt = 1/frameRate;
    position.y += speed * dt;
    //position.x += 0;
    
    speed += speed * .001;
    if ( position.y > height){
      reset();
    }
  }
  public void reset(){
    position.y = random(-50,20);
    position.x = random(0,width);
  }
  
  @Override
  public void update(){
    move();
    show();
    drawHitbox();
  }
  
}
