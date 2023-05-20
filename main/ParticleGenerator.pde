 class particle{

  private PVector sizeChange;
  private float[] ColorChange;
  private PVector direction;
  private PVector speed;
  private PVector position;
  private PVector size;
  private color Color;
  private float lifeTime;
  private float dtDelay;
  
  public particle(float lifeTime,color Color, PVector position, PVector size,PVector direction,PVector speed,PVector sizeChange,color ColorChange){
    this.lifeTime = lifeTime;
    this.Color = Color;
    this.position = position;
    this.size = size;
    this.direction = direction;
    this.speed = speed;
    this.sizeChange = new PVector((sizeChange.x-size.x)/lifeTime,(sizeChange.y-size.y)/lifeTime);
    //isolate all the rgba values from color
    int ca = (Color >> 24) & 0xFF;
    int cr = (Color >> 16) & 0xFF;  // Faster way of getting red(argb)
    int cg = (Color >> 8) & 0xFF;   // Faster way of getting green(argb)
    int cb = Color & 0xFF;
    //isolate all the rgba values from colorChange
    int cha = (ColorChange >> 24) & 0xFF;
    int chr = (ColorChange >> 16) & 0xFF;  // Faster way of getting red(argb)
    int chg = (ColorChange >> 8) & 0xFF;   // Faster way of getting green(argb)
    int chb = ColorChange & 0xFF;  
    this.ColorChange = new float[4];
    this.ColorChange[0] = (cr-chr)/lifeTime;
    this.ColorChange[1] = (cg-chg)/lifeTime;
    this.ColorChange[2] = (cb-chb)/lifeTime;
    this.ColorChange[3] = (ca-cha)/lifeTime;
    //this.ColorChange = color(round((cr-chr)/(lifeTime)),round((cg-chg)/(lifeTime)),round((cb-chb)/(lifeTime)),round((ca-cha)/(lifeTime)));
  }
  
  public void update(float dt){
    lifeTime -= dt;
    dtDelay += dt;
    //size.add(new PVector(size.x * dt,size.y * dt));
    size.x += sizeChange.x * dt;
    size.y += sizeChange.y * dt;
    if (size.x < 0 || size.y < 0){
      size.x = 0;size.y = 0;
    }
    //position.add(new PVector(direction.x * speed.x,direction.y * speed.y) );
    position.x += (direction.x * speed.x) * dt;
    position.y += (direction.y * speed.y) * dt;
    
    /*float chr = ColorChange[0];
    float chg = ColorChange[1];
    float chb = ColorChange[2];
    float cha = ColorChange[3];
    
    if (dtDelay >= 1){
      int ca = round(((Color >> 24) & 0xFF) + cha * dtDelay);
      int cr = round(((Color >> 16) & 0xFF) + chr * dtDelay);  // Faster way of getting red(argb)
      int cg = round(((Color >> 8) & 0xFF) + chg * dtDelay);   // Faster way of getting green(argb)
      int cb = round(( Color & 0xFF) + chb * dtDelay);
      Color &= 0;
      Color |= (Color | ca) << 24;
      Color |= (Color | cr) << 16;
      Color |= (Color | cg) << 8;
      Color |= (Color | cb);
      dtDelay = 0;
    }*/
    //Color += ColorChange;//arbeite daran
    noStroke();
    rectMode(CENTER);
    fill(Color);
    rect(position.x,position.y,size.x,size.y);
  }
  
  public boolean alive(){return lifeTime > 0;}
}

class particleGenerator{
  
  //variables for the generator
  public PVector position;
  public boolean gen;
  public int genAmm;
  public float timeDiff;//the amount of time differenz in adding new particles
  public float time;//time since last added particle
  public ArrayList<particle> parts;
  
  //variables for particles
  public float maxRotation;
  public float minRotation;
  private PVector psizeChange;
  private color pColorChange;
  private PVector pdirection;
  private PVector pspeed;
  private PVector psize;
  private color pColor;
  private float plifeTime;
  
  public particleGenerator(PVector position,int genAmm,float timeDiff,float plifeTime,int pColor,int pColorChange, PVector psize,PVector psizeChange,PVector pdirection,PVector pspeed,float minR, float maxR){
    //variables for the generator
    this.position = position;
    this.genAmm = genAmm;
    
    this.timeDiff = timeDiff;
    this.time = timeDiff;
    
    //variables for particles
    this.plifeTime = plifeTime;
    this.pColor = pColor;
    this.pColorChange = pColorChange;
    this.psize = psize;
    this.psizeChange = psizeChange;
    this.pdirection = pdirection;
    this.pspeed = pspeed;
    this.maxRotation = maxR;
    this.minRotation = minR;
    
    parts = new ArrayList<particle>();
    
    gen = true;
  }
  
  public void setPosition(PVector p){
    position.x = p.x;
    position.y = p.y;
  }
  public void setGenerating(boolean b){
    gen = b;
  }
  
  public void update(float dt){
    for (int i = 0;i < parts.size();i++){
      if (parts.get(i).alive() == false){
        parts.remove(i);
        continue;
      }
      parts.get(i).update(dt);
    }
    if (!gen)
      return;
    time -= dt;
    if (time > 0)
      return;
    time = timeDiff;
    // Using "right shift" as a faster technique than red(), green(), and blue()
    int a = (pColor >> 24) & 0xFF;
    int r = (pColor >> 16) & 0xFF;  // Faster way of getting red(argb)
    int g = (pColor >> 8) & 0xFF;   // Faster way of getting green(argb)
    int b = pColor & 0xFF;          // Faster way of getting blue(argb)
    for (int i = 0;i < genAmm;i++)// pdirection
      parts.add(new particle(plifeTime+random(-.1,.1),pColor,new PVector(position.x,position.y),new PVector(psize.x,psize.y),pdirection.copy().rotate(random(minRotation, maxRotation)) ,pspeed,new PVector(psizeChange.x,psizeChange.y), pColorChange) );
  }
  
  //const generators
}
particleGenerator getExplosionGenerator(float size){
  return new particleGenerator(
      new PVector(0,0),
      50,
      0.0,
      size,
      color(255,23,21), color(255,23,21),
      new PVector(7,7), new PVector(2,2),
      new PVector(1,1),
      new PVector(800,800),
      0.0, 360.0);
}
