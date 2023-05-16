class sprite{
   
  public boolean show = true;
  
  protected PVector position;
  protected float HitboxRadius;
 
  protected float speed;
  
  protected PImage img;
  
  public sprite(PVector __position, float __speed, String path){
    this.position = __position;
    this.speed = __speed;
    this.img = loadImage(path);
    
    
    if (this.img == null){
      println("path %s of %s is invalid ",path ,this);
      exit();
    }
       
   setHitbox();
  }
  
  private void setHitbox(){
    this.HitboxRadius = (this.img.width+this.img.height)/2;
  }
  public void drawHitbox(){
    noFill();
    stroke(0,255,0);
    strokeWeight(this.HitboxRadius*.01);
    circle(this.position.x, this.position.y, HitboxRadius);
  }
  public float getHitbox(){return this.HitboxRadius;}
  
  public PVector getPosition(){return new PVector(position.x,position.y);}
  
   
  public boolean collide(sprite other){
    float a = this.position.dist(other.getPosition());
    return a < (other.getHitbox()+this.HitboxRadius)/2;
  }
  
  public void update(float dt){}
  
  public void show(){
    imageMode(CENTER);
    image(img, this.position.x, this.position.y);
  }
  
  //setter and getter
  public void setPosition(PVector p){this.position.x = p.x;this.position.y = p.y;}
}
