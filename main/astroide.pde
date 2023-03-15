class Astroide extends sprite{
  
   private int maxSpeed = 800;
   private int minDist = 20;
   ArrayList<Astroide> others;
  
  Astroide(PVector __position, float __speed, String path){
    super(__position, __speed, path);
    this.minDist = (int)(2*HitboxRadius);
  }
  
  public void setOthers(ArrayList<Astroide> others){
    this.others = others;
  }
  
  public void move(){
    double dt = 1/frameRate;
    position.y += speed * dt;
    //position.x += 0;
    
    //1200 max
    //900
    if (speed < maxSpeed)
      speed += speed * .001;
    //println("astroide speed: ",speed);
    if ( position.y > height){
      reset();
    }
  }
  public void reset(){
    position.y = random(-50 ,20);
    for (Astroide ass : others){
      if (this.position.dist(ass.getPosition()) < minDist){
        this.position.x += minDist * PVector.angleBetween(this.position,ass.getPosition()) * -1;
        this.position.y += minDist * PVector.angleBetween(this.position,ass.getPosition()) * -1;
      }
    }
    position.x = random(0,width);
  }
  
  @Override
  public void update(){
    move();
    show();
    drawHitbox();
  }
  
}
