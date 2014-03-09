//In this groundbreaking game, the player controls Timmy the tapeworm with the mouse.
//The longer that Timmy evades the antibiotics, the more points he gains...however, 
//the antibiotics gradually multiply and move faster and faster, and Timmy grows longer 
//and longer, making survival progressively more difficult!
//Timmy can also snack on green nutrients to gain bonus points.


//import sound library here
import ddf.minim.*;
import ddf.minim.analysis.*;

//GLOBAL VARAIBLES
//the three game states
int menu = 1;
int playing = 2;
int lost = 3;

//game state constant
int gameState;

//scoring variables
int score;
int hiScore;
int scoreUpdateBalls;
int scoreUpdateJoints;

//create font for menus and score
PFont font;
PFont fontTitle;
color fontColor;

//starting number of balls
int nBalls;
int nJoints;

//sound control
boolean muted = false;
int gain;

//Timmy can have up to 12 total joints, but he starts with just 6
WormJoint[] joints = new WormJoint[12];

//the 10 antibiotics automatically regenerate once they leave the screen
Ball[] balls = new Ball[100];

Square[] squares = new Square[8];

Minim minim;

AudioPlayer bloop1, bloop2, bloop3;
AudioPlayer pop1;
AudioPlayer soundtrack;

BeatDetect beat;

PImage speakerOn;
PImage speakerOff;

void setup()
{

  //canvas and project setup
  size(800, 450);
  smooth();
  frameRate(30);
  noStroke();

  //font initialization
  font = createFont("ArialRoundedMTBold.vlw", 20);
  fontTitle = createFont("BirchStd.vlw", 20);
  fontColor = color(0, random(100, 255), random(100, 240));
  textFont(font);
  textAlign(CENTER);

  //sound initialization
  minim = new Minim(this);
  bloop1 = minim.loadFile("audio/bloop1.mp3");
  bloop1.setGain(10);
  bloop2 = minim.loadFile("audio/bloop2.mp3");
  bloop3 = minim.loadFile("audio/bloop3.mp3");

  pop1 = minim.loadFile("audio/pop1.mp3");
  pop1.setGain(10);

  soundtrack = minim.loadFile("audio/pretending.mp3");
  soundtrack.loop();
  soundtrack.setGain(-10);
  beat = new BeatDetect();
  
  speakerOn = loadImage("speakerOn.png");
  speakerOff = loadImage("speakerOff.png");



  //initialize the game (function follows)
  gameInit();
}

void draw()
{
  //very slight motion blur
  rectMode(CORNER);
  fill(0);
  rect(0, 0, width, height);

  //sountrack begins quiet, gradually grows louder
  soundtrack.play();
  gain += 1;

  //draw appropriate speaker icon
  soundSpeaker();

  //conditionally draw game modes
  switch(gameState)
  {

    //THIS IS THE IN-GAME STATE
  case 2:
    noCursor();
    //draw, update worm joints, balls, squares
    drawObjects();

    //check for collisions between worm and balls, squares;
    //make changes to score or game state if necessary
    collisions();

    //update score; add new balls and worm joints if necessary.
    scoreUpdate();

    //draw score, high score text in lower corners
    scoreText();
    
beatDetect();

    break;

    //END GAME STATE
  case 3:
    noCursor();

    //draw end game text
    gameOverText();

    break;

    //MENU STATE
  case 1:
    noCursor();

    //Draw and update background wiggly worm
    for (int i=0; i<nJoints; i++) joints[i].draw();

    // Recenter first joint at mouse position
    joints[0].update(mouseX, mouseY);

    // Recenter each following joint at preceding joint
    for (int i=1; i<nJoints; i++)
      joints[i].update(joints[i-1].x, joints[i-1].y);

    //draw main menu text
    menuText();

    break;
  }
}

//if in menu state, mouse click begins game
//if in end game state, mouse click restarts game
void mousePressed()
{
  if (gameState == menu)
  {
    gameState = playing;
  }
  else if (gameState == lost)
  {
    gameInit();
  }
}

void keyPressed() {
  if (key == 'M' || key == 'm')
  {
    if (muted)
    {
      soundtrack.unmute();
      bloop1.unmute();
      pop1.unmute();
    } 
    else {
      soundtrack.mute();
      bloop1.mute();
      pop1.mute();
    }
    muted = !muted;
  }
}

