//imports
import java.util.Map;

//variables

//enum for the current game state
//holds the current game state
//===============================
//all astroid related variables
ArrayList<Asteroid> astroids;
int numAstroids = 5;
//===============================

PImage Background;
PImage emptyBox;
Player pl;

//=====================
//all game related variables
final int maxLives = 3;
int lives = 3;
//score related
int score;// the final score
int timeIn;// the time the game started in millis()
int extraScore;// extra scores like shooting a asteroid
//=====================

/*
IMPORTANT:
*****
you might need to click the window once before key input will be accepted
*****
*/

void setup(){
  size(500,750);
  Background = loadImage("../assets/background.png");
  emptyBox = loadImage("../assets/bar2.png");
  
  pl = new Player(new PVector(250,550) );
  astroids = new ArrayList<Asteroid>();
  timeIn = millis();
}

void draw(){
  background(Background);
  float dt = 1/frameRate;
  pl.update(dt);
  asteroidHandling(dt);
  CollisionHandler();
  
  //draw all of the shots availbale
  int y = 40;//temporary y variable for the box
  int x = 25;//temporary x variable for the box
  for (int i = 0;i < maxLives;i++){
    image(emptyBox,x ,y);
    //draw the rect if that bullet is not in use
    rectMode(CENTER);
    fill(#FF0000);//full on red
    if (i >= maxLives-lives)
      rect(x,y, 15, 15);
    //incrise the position
    x += 25;
    if ((i+1) % 10 == 0){
      y += 30;
      x = 25;
    }
  }
      //print/display rounded framerate
  textSize(32);
  fill(#FFFFFF);
  text(str(round(frameRate)), 25, 25);
  score = (millis()-timeIn) + extraScore;
  text(str(score), width/2, 50);
}

void keyPressed(){
  pl.keyHandler(key, true);
}
void keyReleased(){
  pl.keyHandler(key, false);
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

//Handels all of the collisions
void CollisionHandler(){
  //handel collission between asteroid and eveything else
  for (Asteroid a : astroids){
    if (pl.collide(a)){
      a.reset(true);//
      lives--;
      //TODO: player will be fling back
    }
    if (pl.BulletCollide(a)){//collision between astroid and players bullet
      a.reset(true);
      //idk what else this should do?
      //create black hole?
    }
  }
}
