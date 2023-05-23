//imports
import java.util.Map;
import java.lang.reflect.InvocationTargetException;

import processing.sound.*;

//variables


//enum for the different game states
// https://forum.processing.org/two/discussion/23409/enums-in-openprocessing.html
public enum GameState{
  Game,
  Menu,
  Options,
  HowToPlay;
}
GameState state = GameState.Menu;//holds the current game state

IS input;

PImage Background;
PImage emptyBox;
Player pl;

SoundFile select;
SoundFile hurt;
SoundFile explosion;
SoundFile powerUp;


//===============================
//all astroid related variables
ArrayList<Asteroid> astroids;
int numAstroids = 5;
//===============================
ArrayList<PickUp> pickUps;
ArrayList<PickUp> InUsePickUps;
PickUp CurrentPickUp;
HashMap<Float, Class> probality;

//=====================
//score related
int Highscore;
int score;// the final score
int timeIn;// the time the game started in millis()
int extraScore;// extra scores like shooting a asteroid
//=====================

//===============================
//all astroid related variables
ArrayList<Ufo> ufos;
int numUfos = 1;
int spawnThresHold = 5000;//at what score they spawn
boolean allDead = false;//if no  ufo is processing this is true
//===============================

/*
IMPORTANT:
*****
you might need to click the window once before key input will be accepted
*****

TODO:
-pickups {finsihed}
-more pickUps {finished}
-missle sometimes goes out of window; change that
-options
-how to play
-ufos sometimes die randomly {finished}
-ufos dont spawn
*/

void setup(){
  size(500,750);
  Background = loadImage("../assets/background.png");
  emptyBox = loadImage("../assets/bar2.png");
  
  input = new IS();
  
  input.addAction("DOWN", Integer.valueOf(int('s')));
  input.addAction("DOWN", Integer.valueOf(int('S')));
  input.addAction("UP",   Integer.valueOf(int('w')));
  input.addAction("UP",   Integer.valueOf(int('W')));
  input.addAction("RIGHT",Integer.valueOf(int('d')));
  input.addAction("RIGHT",Integer.valueOf(int('D')));
  input.addAction("LEFT", Integer.valueOf(int('a')));
  input.addAction("LEFT", Integer.valueOf(int('A')));
  input.addAction("SHOOT",Integer.valueOf(int(' ')));
  input.addAction("RELOAD",Integer.valueOf(int('r')));
  input.addAction("RELOAD",Integer.valueOf(int('R')));
  input.addAction("SHIELD",Integer.valueOf(SHIFT));
  input.addAction("MISSLE",Integer.valueOf(int('c')));//c is better than m, its nearer
  input.addAction("MISSLE",Integer.valueOf(int('C')));
  input.addAction("UsePickUp",Integer.valueOf(int('f')));
  input.addAction("UsePickUp",Integer.valueOf(int('F')));
  input.addAction("UsePickUp",Integer.valueOf(int('x')));
  input.addAction("UsePickUp",Integer.valueOf(int('X')));
  input.addAction("UsePickUp",Integer.valueOf(CONTROL));
  
  input.addAction("select",Integer.valueOf(ENTER));
  input.addAction("select",Integer.valueOf(int(' ')));
  
  
  select    = new SoundFile(this, "../sound/Select.wav");
  hurt      = new SoundFile(this, "../sound/Hurt.wav");
  explosion = new SoundFile(this, "../sound/Explosion.wav");
  powerUp   = new SoundFile(this, "../sound/PowerUp.wav");
  
  
  pl = new Player(new PVector(250,550), input);
  astroids = new ArrayList<Asteroid>();
  ufos = new ArrayList<Ufo>();
  pickUps = new ArrayList<PickUp>();
  timeIn = millis();
  
  //load the highscore
  try{
    JSONObject json = new JSONObject();
    json = loadJSONObject("../data/saveGame.json");
    Highscore = json.getInt("HighScore");
    println(Highscore);
  }catch(NullPointerException e){e.printStackTrace();}
}

void SaveHighScore(){
  JSONObject json = new JSONObject();

  json.setInt("HighScore", Highscore);

  saveJSONObject(json, "../data/saveGame.json");

}

void draw(){
  if (state == GameState.Game)
    Game();
  if (state == GameState.Menu)
    Menu();
  
  //controll logic
  if (pl.isDead()){
    state = GameState.Menu;
    //update the Highscore
    if (score > Highscore)
      Highscore = score;
    SaveHighScore();
  }
}

void keyPressed(){
  input.UpdateKey(keyCode, true);
}
void keyReleased(){
  input.UpdateKey(keyCode, false);
}

//The function that governs the Menu
//some variables for it
float logoRotation;
int RotationDirection = 1;
//
float HighScoreSize = 0;//the Text size
int inciseDirection = 1;
//navigation
int position = 0;//what text we are at
int maxPosition = 1;
//=====================
void Menu(){
  //some temporary variables
  int i = 0;//for position comparing
  background(Background);
  
  HandleNavigation();
  
  //draw all of the text
  textAlign(CENTER);
  fill(#FF8000);
  textSize(48);
  RotateText("look for better name", width/2, height*.25, 0/*logoRotation*/);//rotate the title of the game
  logoRotation += .5 * RotationDirection;
  if (abs(logoRotation) > 5)
    RotationDirection = -RotationDirection;
  
  HighScoreSize += .15 * inciseDirection;//change the size of the Highscore
  if (abs(HighScoreSize) > 2)
    inciseDirection = -inciseDirection;
  textSize(48+HighScoreSize);
  text(str(Highscore),width/2, height*.35);
  fill(255);
  textSize(32);
  
  
  
  if (position == i++) fill(#FF8000); else fill(255);
  text("Start", width/2, height *.5);
  if (position == i++) fill(#FF8000); else fill(255);
  text("Options", width/2, height *.5+40);
}

void HandleNavigation(){
  //change the position
  if (input.pressed("UP"))
    position--;
  else if (input.pressed("DOWN"))
    position++;
  //checking if position is valid
  if (position < 0)
    position = maxPosition;
  if (position > maxPosition)
    position = 0;
  
  //actual action with it?
  if (!input.pressed("select"))
    return;
  select.play();
  if (position == 0){// at text "Start
    startGame();
  }
}

void RotateText(String text, float x, float y, float rotation){
  pushMatrix();
  float angle1 = radians(rotation);
  translate(x, y);
  rotate(angle1);
  text(text, 0, 0);
  line(0, 0, 150, 0);
  popMatrix();
}

//====================================




//The function that governs the game
void Game(){
  background(Background);
  float dt = 1/frameRate;
  pl.update(dt);
  //manage missle of player (bad code!: change)
  if (input.pressed("MISSLE")){
    for (int i = 0;i < numUfos;i++){
      if (ufos.get(i).getProcess()){
        pl.setMissleTarget(ufos.get(i));
        break;
      }
    }
    for (int i = 0;i < numAstroids;i++){
      if (!pl.missleNeedTarget())
        break;
      if (astroids.get(i).getProcess()){
        pl.setMissleTarget(astroids.get(i));
        break;
      }
    }
    //pl.setMissleTarget(ass);
    pl.missleFire();
  }
  //=================
  asteroidHandling(dt);
  ufoHandling(dt);
  PickUpsHandling(dt);
  CollisionHandler();
  
  
  //print/display rounded framerate
  textSize(32);
  fill(#FFFFFF);
  text(str(round(frameRate)), 25, 25);
  score = (millis()-timeIn) + extraScore;
  text(str(score), width/2, 50);
}

void startGame(){
  //sets everything up for the game
  //re create every object
  pl = new Player(new PVector(250,550), input );
  astroids = new ArrayList<Asteroid>();
  ufos = new ArrayList<Ufo>();
  pickUps = new ArrayList<PickUp>();
  InUsePickUps = new ArrayList<PickUp>();
  CurrentPickUp = null;
  
  //set the variables to their standart
  numAstroids = 5;

  pl.setMaxLives(3);
  pl.setLives(3);
  score = 0;// the final score
  timeIn = millis();// the time the game started in millis()
  extraScore = 0;// extra scores like shooting a asteroid

  numUfos = 1;
  spawnThresHold = 5000;//at what score they spawn
  allDead = false;//if no  ufo is processing this is true
  
  state = GameState.Game;
}

//function for handling all of the asteroids
void asteroidHandling(float dt){
  //idk do this comment later
  for (int i = 0;i < numAstroids;i++){//if we use a foreach for loop adding and removing would break the iterator
    if (numAstroids > astroids.size())//add more asteroids until we have {numAstroids}
      astroids.add( new Asteroid(new PVector(-10,-10),300, new PVector(0,1), true ) );
    else if (numAstroids < astroids.size())//remove if we have too many astroids
      astroids.remove(astroids.size()-1);//remove the last
    //update the astroid finally
    astroids.get(i).update(dt);
    //check if it is inside the window
    if (astroids.get(i).outOfBounds())
      astroids.get(i).reset(false);//reset if outside of bounds
    
  }
}
//function for handling all of the ufos
void ufoHandling(float dt){
  
  //
  if (score > spawnThresHold && allDead){
    for (int i = 0;i < numUfos;i++){
      ufos.get(i).ResetBullets();//this makes sure bullets dont just spawn in the middle of the window
      ufos.get(i).setPosition(new PVector(40*(i+1),40));//I dont know as to why they spawn in different y places
      ufos.get(i).setProcess(true);
    }
    if (numUfos < 8)
      numUfos = numUfos * 2;
    if (spawnThresHold < 20000)
      spawnThresHold *= 2;
    else
      spawnThresHold += 20000;
  }
  
  allDead = true;
  //idk do this comment later
  for (int i = 0;i < numUfos;i++){//if we use a foreach for loop adding and removing would break the iterator
    if (i >= ufos.size())//add more asteroids until we have {numAstroids}
      ufos.add( new Ufo(new PVector(), 250, false) );
    else if (numUfos < ufos.size())//remove if we have too many astroids
      ufos.remove(ufos.size()-1);//remove the last element
    //update the astroid finally
    ufos.get(i).update(dt);
    //check if it is processing if it is set {allDead} to false
    if (ufos.get(i).getProcess())
      allDead = false;
    //check if it is inside the window
    if (ufos.get(i).outOfBounds()){
      ufos.get(i).setPosition(new PVector(-100, width*height));//reset if outside of bounds
      ufos.get(i).setProcess(false);
    }
    
    
  }
}

//handling the pickUps
void PickUpsHandling(float dt){
  //update all pickUps
  for (int i = 0;i < pickUps.size();i++){
    //set the current pickUp
    PickUp pu = pickUps.get(i);
    //check if it is outside the window; if yes delete it
    if (pu.outOfBounds()){
      pickUps.remove(i);
      pu = null;
      i--;
      continue;
    }
    //update
    pu.update(dt);
  }
  //handle the CurrentPickUp
  //draw the CurrentPickUp's img
  if (CurrentPickUp != null){
    //
    PImage img = CurrentPickUp.getImage().copy();
    img.resize(2*img.width,2*img.height);
    int x = width-img.width;
    int y = ceil(height*.875);
    image(img, x, y);
  }
  if (input.pressed("UsePickUp") && CurrentPickUp != null){
    InUsePickUps.add(CurrentPickUp);
    CurrentPickUp = null;
    powerUp.play();
  }
  //Handle the PickUps in use
  for (int i = 0;i < InUsePickUps.size();i++){
    //set the current pickUp
    PickUp pu = InUsePickUps.get(i);
    //check if its is finished; if yes then remove
    if (pu.isFinished()){
      InUsePickUps.remove(i);
      pu = null;
      i--;
      continue;
    }
    //update
    pu.effect(dt, pl);
  }
}

//Adds a new pickup o the list
void addNewPickUp(PVector pos){
  float num = random(0, 100);
  //cant use the "newInstance()" method becouse we would need to compile this for it to work and compiling is not liked by Processing
  
  if (num > 70){
    pickUps.add(new AddShieldTime());
  }else
  if (num > 60){
    pickUps.add(new IncriseMaxHealth());
  }else
  if (num > 40){
    pickUps.add(new FullHealth());
  }else
  if (num > 20){
    pickUps.add(new AddBullet());
  }
  if (num > 20) pickUps.get(pickUps.size()-1).setPosition(pos);

}

//Handels all of the collisions
void CollisionHandler(){
  //handel collission between asteroid and eveything else
  for (Asteroid a : astroids){
    if (!a.getProcess())
      continue;
    if (pl.collide(a)){
      a.reset(true);//
      explosion.play();
      if (!pl.UsesShield() && a.getProcess()){
        pl.decriseLive();
        hurt.play();
      }
      //TODO: player will be fling back
    }
    if (pl.BulletCollide(a)){//collision between astroid and players bullet
      a.reset(true);
      extraScore += 500;
      explosion.play();
      //idk what else this should do?
      //create black hole?
    }
  }
  //collision between ufos and player
  for (Ufo u : ufos){
    if (pl.collide(u)){
      u.setPosition(new PVector(-100,0));//basicly set its process to false
      u.setProcess(false);
      explosion.play();
      if (!pl.UsesShield()){//if the player is currently not using a shield
        pl.decriseLive();
        hurt.play();
      }
    }
    if (pl.BulletCollide(u) && u.getProcess()){
      //spawn a package
      addNewPickUp(u.getPosition());
      u.setPosition(new PVector(-100,0));//basicly set its process to false
      u.setProcess(false);
      extraScore += 1000;
    }
    
    if (u.BulletCollide(pl)){
      if (!pl.UsesShield() && u.getProcess()){//if the player is currently not using a shield
        pl.decriseLive();
        hurt.play();
      }
    }
  }
  
  //collision between player and pickUps 
  for (int i = 0;i < pickUps.size();i++){
    PickUp pu = pickUps.get(i);
    if (pl.collide(pu)){
      CurrentPickUp = pu;
      pu = null;
      pickUps.remove(i);
      break;
    }
  }
}
