/********************************
 Cooper Thomas
 Professor Casey
 Final Project, Computer Science 2
 12 March 2013
 
 In this game, the player uses the mouse to control Timmy the Tapeworm.
 The longer that Timmy evades the red antibiotics, the more points he gains...however, 
 the antibiotics gradually multiply in number, and Timmy grows longer 
 and longer, making survival progressively more difficult.
 
 Timmy can snack on green nutrients (squares) to gain bonus points. He can also "explode" 
 the orange probiotics (triangles), which destroy any antibiotics in their immediate
 vicinity, granting additional bonus points.
 
 ********************************/

//import sound library
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
int scoreUpdateTriangles;
int scoreUpdateJoints;

//create font for menus and score
PFont font;
PFont fontBonus;
color fontColor;

//starting number of balls
int nBalls;
int nJoints;

//sound control
boolean muted = false;
int gain;

//Create up to 12 joints, but begin with just 6 (see gameInit) 
WormJoint[] joints = new WormJoint[12];

//Create up to 100 balls, but begin with just 10
Ball[] balls = new Ball[100];

//Create 8 bonus squares
Square[] squares = new Square[8];

//Create 1 explosive triangle
Triangle triangle = new Triangle();

//Import audio library
Minim minim;

//Instantiate various sound effects, soundtrack
AudioPlayer bloop1, bloop3;
AudioPlayer pop1, pop2;
AudioPlayer gameOver;
AudioPlayer soundtrack;

//Instantiate beat detection objects
BeatDetect beat;
BeatListener bl;

//Instantiate sound on/off PNG icons (drawn in Illustrator)
PImage speakerOn;
PImage speakerOff;

void setup()
{

  //canvas and project setup
  size(800, 450);
  smooth();
  frameRate(30);
  noStroke();

  //initialize the different fonts
  font = createFont("ArialRoundedMTBold.vlw", 20);
  fontBonus = createFont("BadaBoomBB", 48);

  fontColor = color(0, random(100, 255), random(100, 240));  
  textAlign(CENTER);

  //initialize all the sound effects and background music
  minim = new Minim(this);

  bloop1 = minim.loadFile("audio/bloop1.mp3");
  bloop1.setGain(20);

  bloop3 = minim.loadFile("audio/bloop3.mp3");
  bloop3.setGain(40);

  pop1 = minim.loadFile("audio/pop1.mp3");
  pop1.setGain(20);

  pop2 = minim.loadFile("audio/pop2.mp3");
  pop2.setGain(40);

  gameOver = minim.loadFile("audio/gameover.mp3");
  gameOver.setGain(-10);

  soundtrack = minim.loadFile("audio/soundtrack.mp3", 1024);
  soundtrack.setGain(-10);
  soundtrack.loop();

  //new beat tracker
  beat = new BeatDetect(soundtrack.bufferSize(), soundtrack.sampleRate());
  beat.setSensitivity(10);  
  bl = new BeatListener(beat, soundtrack);

  //load sound on/off icons
  speakerOn = loadImage("speakerOn.png");
  speakerOff = loadImage("speakerOff.png");


  //initialize the game (see global function)
  gameInit();
}

void draw()
{

  background(0);

  //begin the soundtrack
  soundtrack.play();

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

    //listen for beat, and make squares, triangle pulse w/ kick and snare
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
      bloop3.unmute();
      pop1.unmute();
      pop2.unmute();
      gameOver.unmute();
    } 
    else {
      soundtrack.mute();
      bloop1.mute();
      bloop3.mute();
      pop1.mute();
      pop2.mute();
      gameOver.mute();
    }
    muted = !muted;
  }
}

