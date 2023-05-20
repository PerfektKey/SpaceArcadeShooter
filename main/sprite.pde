class sprite{
  
  protected boolean outOfBounds;// if the sprite is outside of the window set this to true
  protected boolean process;//wether or not to update this sprite
   
  public boolean show = true;
  
  protected PVector position;
  protected float HitboxRadius;
 
  protected float speed;
  
  protected PImage img;
  
  sprite(PVector __position, float __speed, String path, boolean process){
    this.position = __position;
    this.speed = __speed;
    this.img = loadImage(path);
    this.process = process;
    
    
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
   
  public boolean collide(sprite other){
    if (other.process == false)
      return false;
    float a = this.position.dist(other.getPosition());
    return a < (other.getHitbox()+this.HitboxRadius)/2;
  }
  
  public void update(float dt){}
  public void reset(boolean exp){}
  
  public void show(){
    imageMode(CENTER);
    image(img, this.position.x, this.position.y);
  }
  
  //setter and getter
  public void setPosition(PVector p){this.position.x = p.x;this.position.y = p.y;}
  public PVector getPosition(){return new PVector(position.x,position.y);}
  public float getHitbox(){return this.HitboxRadius;}
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
  public PImage getImage(){return this.img;}
}
