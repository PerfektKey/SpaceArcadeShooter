class player extends sprite{
  
  public PVector force;
  private float maxForce;
  private float minForce;
  private float mulForce;
  
  private particleGenerator leftThruster;
  private particleGenerator rightThruster;
  
  public player(PVector __position, float __speed, String path){
    super(__position, __speed, path);
    this.force = new PVector(0,0);
    this.maxForce = 30;
    this.minForce = 11.5;
    this.mulForce = 0.05;
    this.force = new PVector(0,0);
    PVector pl = new PVector(width/2,height/2);//new PVector(position.x-img.width/2,position.y-img.height/2);
    leftThruster = new particleGenerator(pl, 3, .01, .7 ,color(#6208C4),color(100,100,100), new PVector(3,3),new PVector(1,1),new PVector(0,10),new PVector(10,10), new PVector(-2.5,0),new PVector(3,0));
    rightThruster = new particleGenerator(new PVector(0,0), 3, .01, .7 ,color(#6208C4),color(100,100,100), new PVector(3,3),new PVector(1,1),new PVector(0,10),new PVector(10,10), new PVector(-2.5,0),new PVector(3,0));
  }
  
  public void move(){//forcee zu scnell und schlect
    
    double dt = 1/frameRate;
    
    if (!keyPressed){
      int tmp = 2;
      if (this.position.x+this.img.width/2 >= width)
        this.force.x -= (this.minForce*tmp);
      if (this.position.x-this.img.width/2 <= 0)
        this.force.x += (this.minForce*tmp);
        
      if (this.position.y >= height*.7)
        this.force.y -= (this.minForce*tmp);
      if (this.position.y+this.img.height/2 <= height)
        this.force.y += (this.minForce*tmp);
        
        
      if (this.force.x != 0){
        this.position.x += this.force.x * dt;
        this.force.x -= this.force.x * .001;
        if (abs(this.force.x) < this.minForce)
          this.force.x = 0;
      }
      if (this.force.y != 0){
        this.position.y += this.force.y * dt;
        this.force.y -= this.force.y * .001;
        if (abs(this.force.y) < this.minForce)
          this.force.y = 0;
      }
      return;
    }
    if (!keyPressed)
      return;
    if (key == 'D' || key == 'd'){
      if (this.position.x+this.img.width/2 >= width) return;
      this.position.x += speed * dt;
      if (this.force.x <= 0){
        this.force.x = 20;
      }else if (abs(this.force.x) < this.maxForce){
        this.force.x += abs(this.force.x) * this.mulForce;
      }
    }else if (key == 'A' || key == 'a'){
      if (this.position.x-this.img.width/2 <= 0) return;
      this.position.x -= speed * dt;
      if (this.force.x >= 0){
        this.force.x = -20;
      }else if (abs(this.force.x) < this.maxForce){
        this.force.x -= abs(this.force.x) * this.mulForce;
      }
    }else if (key == 'W' || key == 'w'){
      if (this.position.y <= height*.7) return;
      this.position.y -= speed * dt;
      if (this.force.y >= 0){
        this.force.y = -20;
      }else if (abs(this.force.y) < this.maxForce){
        this.force.y -= abs(this.force.y) * this.mulForce;
      }
    }else if (key == 'S' || key == 's'){
      if (this.position.y+this.img.height/2 >= height) return;
      this.position.y += speed * dt;
      if (this.force.y <= 0){
        this.force.y = 20;
      }else if (abs(this.force.y) < this.maxForce){
        this.force.y += abs(this.force.y) * this.mulForce;
      }
    }
  }
  
  public void force(){
    
  }
  
  @Override
  public void update(){
    float dt = 1/frameRate;
    move();
    drawHitbox();
    show();
    
    //update the Thrusters
    leftThruster.setPosition(new PVector(position.x-img.width/4+3.5,position.y+img.height/4));
    rightThruster.setPosition(new PVector(position.x+img.width/4-3.5,position.y+img.height/4));
    rightThruster.update(dt);
    leftThruster.update(dt);
    
  }
}
