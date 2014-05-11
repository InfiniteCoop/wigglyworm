/********************************

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

//this class is for the bad antibiotic balls. If the worm collides with a ball,
//the game automaticaly ends.
class Ball {
  float x, y;   // current position
  float vx, vy;  // velocity
  float vr; //ball radius multiplier (increases over time)
  float r;   //radius
  float vMin;
  float vMax;
  color c; //ball color
  float spring = 0.2; //ball springiness (for collisions)
  boolean on = false;


  Ball() {
  }

  // Initialize ball offscreen (right of canvas)
  void initialize()
  {
    on = true;
    vMin = -5;
    vMax = -2;
    x = random(width+200, width+600); 
    y = random(0, height);
    vx = random(vMin, vMax); 
    vy = random(-2, 2);
    vr = 1;
    r = vr * random(10, 30);
    c = color(random(100, 255), 0, random(0, 100));
  }

  void draw()
  {
    if (!on) return;
    noStroke(); 
    fill(c, 200);
    ellipse(x, y, 2*r, 2*r);
  }

  void update()
  {
    // initialize if necessary
    if (!on) { 
      if (random(0, 1) < 0.5) initialize(); 
      return;
    }

    //move ball
    x += vx;
    y += vy;

    //reverse ball vy when it hits floor/ceiling
    if (y > height-r || y < r)
    {
      vy = -vy;
    }

    // When ball exits screen, re-initialize
    if (x < 0) {
      on = false;
    }

    vMin += -0.1;
  }

  //check for collisions with other balls
  void bounce() {
    for (int i = 0; i < nBalls; i ++) {
      // if this is myself, continue
      if (this == balls[i]) continue;
      // distance between two balls
      float d = dist(x, y, balls[i].x, balls[i].y);
      // minimum distance between two balls
      float md = r+balls[i].r;
      // if I collide with one of them
      if (d < md && balls[i].x < width) {
        // push back in the opposite direction
        float dx = (x - balls[i].x)/d;
        float dy = (y - balls[i].y)/d;
        // check if perfectly overlapping
        if (dx == 0 && dy == 0) { 
          dx = random(-1, 1); 
          dy = random(-1, 1);
        }
        // compute the speed to add
        float s = min(10, spring*(md-d));
        vx += dx*s;
        vy += dy*s;
      }
    }
  }
}

//This class analyses the soundtrack audio file and listens for beat
class BeatListener implements AudioListener
{
  private BeatDetect beat;
  private AudioPlayer source;
  
  BeatListener(BeatDetect beat, AudioPlayer source)
  {
    this.source = source;
    this.source.addListener(this);
    this.beat = beat;
  }
  
  void samples(float[] samps)
  {
    beat.detect(source.mix);
  }
  
  void samples(float[] sampsL, float[] sampsR)
  {
    beat.detect(source.mix);
  }
}
//a class for the bonus squares. Each square that Timmy consumes grants 100 bonus points.
class Square {
  float x, y;   // current position
  float vx, vy;  // velocity
  float w;   //width
  float timer;   // time left before square disappears
  float timerBonus;  //time left before "BONUS!" message disappears
  float dt;  // extinguishing speed
  float a; //rotation angle
  float da; //rotation rate 
  float dtBonus;  //text extinguishing speed
  float spring = 0.05; //ball springiness (for collisions)
  float red = 50;
  float green = 200;
  float blue = 200;
  float aBlue; //
  float daBlue; //rate of color change
  boolean on = false;

  Square() {
  }

  // Initialize squares offscreen (right of canvas)
  void initialize()
  {
    on = true;
    x = random(width+400, width+800); 
    y = random(0, height);
    vx = random(-10, -4); 
    vy = random(-2, 2);
    w = random(10, 15);
    timer = 255;
    timerBonus = 100;
    dt = random(0.1, 5);
    dtBonus = 0;
    a = 0;
    da = random(-0.5, -0.3);    
    aBlue = TWO_PI;
    daBlue = radians(2);
  }

  void draw()
  {
    
    //update color
    blue = 140 * (1+sin(aBlue));
    if (!on) return;
    fill(red, green, blue, timer);
    
    //draw squares
    pushMatrix();
    translate(x, y);
    rotate(a);
    noStroke();
    rectMode(CENTER);
    rect(0, 0, w, w);
    popMatrix();
  }

  void update()
  {
    // initialize if necessary
    if (!on) { 
      if (random(0, 1) < 0.5) initialize(); 
      return;
    }

    //move squares
    x += vx;
    y += vy;

    //rotate squares
    a += da;

    //update blue color channel
    aBlue += daBlue;

    green = constrain(green, 100, 240);
    blue = constrain(blue, 100, 240);

    //square transparency decay
    timer -= dt;
    timerBonus -= dtBonus;

    //reverse square vy when it hits floor/ceiling
    if (y > height-w || y < w)
    {
      vy = -vy;
    }

    // When square exits screen, re-initialize
    //x + 601 is to ensure reinitialization if 
    //freak collision sends it in positive x direction
    if (x < 0 || x > width+601 || timer < 0) {
      on = false;
    }
  }

  //check for collisions with other squares; rebound, if necessary
  void bounce() {
    for (int i = 0; i < squares.length; i ++) {
      // if this is myself, continue
      if (this == squares[i]) continue;
      // distance between two squares
      float d = dist(x, y, squares[i].x, squares[i].y);
      // minimum distance between two squares
      float md = w+squares[i].w;
      // if I collide with one of them
      if (d < md) {
        // push back in the opposite direction
        float dx = (x - squares[i].x)/d;
        float dy = (y - squares[i].y)/d;
        // check if perfectly overlapping
        if (dx == 0 && dy == 0) { 
          dx = random(-1, 1); 
          dy = random(-1, 1);
        }
        // compute the speed to add
        float s = min(10, spring*(md-d));
        vx += dx*s;
        vy += dy*s;
      }
    }
  }
}

//a class for the probiotic triangle power-up
class Triangle {
  float x, y;   // current position
  float vx, vy;  // velocity
  float l;   //triangle side length
  float timer;   // time left before triangle disappears
  float timerBonus;  //time left before bonus message disappears
  float dt;  // triangle transparency change speed
  float a; //rotation angle
  float da; //rotation rate 
  float dtBonus;  //text extinguishing speed
  boolean on = false;
  boolean explode = false;  //switched on/off by collision with worm head

  Triangle() {
  }

  // Initialize triangles offscreen (right of canvas)
  void initialize()
  {
    on = true;
    explode = false;
    x = random(width*2, width*3); 
    y = random(0, height);
    vx = random(-12, -8); 
    vy = random(-4, 4);
    l = 10;
    timer = 255;
    dt = 20;
    timerBonus = 100;
    dtBonus = 1;
    a = 0;
    da = random(-0.25, -0.05);
  }

  void draw()
  {
    if (!on) return;
    fill(250, 128, 0, timer);
    pushMatrix();
    translate(x, y);
    rotate(a);
    noStroke();
    triangle(0, l, l, -l, -l, -l);    
    popMatrix();
  }

  void update()
  {
    // initialize, if necessary
    if (!on) { 
      if (random(0, 1) < 0.5) initialize(); 
      return;
    }

    //move triangles
    x += vx;
    y += vy;

    //rotate triangles
    a += da;

    //reverse triangle vy when it hits floor/ceiling
    if (y > height-l || y < l)
    {
      vy = -vy;
    }

    // When triangle exits screen or becomes invisible, re-initialize
    if (x < 0-l || timer < 20) {
      on = false;
    }

    //test to see if triangle has collided with worm head (see collisions() function)
    if (explode == true)
    {
      //trigger triangle appearance change
      l += 20;
      timerBonus -= dtBonus;
      timer -= dt;

      //destroy any balls that touch triangle
      for (int i=0; i<nBalls; i++)
      {
        if (dist(triangle.x, triangle.y, balls[i].x, balls[i].y) < triangle.l*2 && triangle.timer > 40)
        {

          //play pop sound
          pop2.play();
          pop2.rewind();

          //remove ball (it will be reinitialized)
          balls[i].on = false;

          //print message
          fill((triangle.timerBonus));
          textAlign(CENTER);
          textFont(fontBonus, 48);
          text("+100!", balls[i].x, balls[i].y);

          //update score
          score += 100;
        }
      }
    }
  }
}

//this class defines Timmy's body, which is comprised of joints, links, and his head

class WormJoint {
  float cx, cy;        // rest position
  float x, y;
  float vx=0, vy=0;    // velocity in the two directions   
  float r;        // joint radius
  float k = 0.08;      // spring constant
  float d = 0.75;      // damping
  float hg = 0.5;  // horizontal gravity
  float red = 50;    //color channels
  float green = 200;
  float blue = 200;
  float a;      //blue color change
  float da;    //rate of blue color change

  // Initialize a worm joint at rest position (x0,y0)
  WormJoint(float x0, float y0, float r0)
  {
    x = x0;
    y = y0;
    r = r0;
    a = TWO_PI;
    da = radians(2);
  }

  void draw()
  {
    //update color
    blue = 140 * (1+sin(a));
    fill(red, green, blue);
    
    //draw worm joints
    stroke(red, green, blue); 
    strokeWeight(4);
    line(cx, cy, x, y);
    fill(red, green, blue); 
    //draw worm eye connectors
    strokeWeight(2);
    line(mouseX, mouseY, mouseX+4, mouseY-12);
    line(mouseX, mouseY, mouseX-4, mouseY-12);
    //draw worm head
    noStroke();
    ellipse(mouseX, mouseY+2, 3*r, 3.5*r);
    ellipse(x, y, 2*r, 2*r);
    //draw worm eyes
    fill(255);
    ellipse(mouseX+4, mouseY-12, 1.5*r, 1.5*r);
    ellipse(mouseX-4, mouseY-12, 1.5*r, 1.5*r);
    fill(0);
    ellipse(mouseX+4, mouseY-12, r-2, r-2);
    ellipse(mouseX-4, mouseY-12, r-2, r-2);
    //draw worm mouth
    stroke(0);
    line(mouseX-2, mouseY+4, mouseX+2, mouseY+4);
  }

  // Update the spring with a new center
  void update(float ncx, float ncy)
  {
    // set the new center
    cx = ncx; 
    cy = ncy;

    // usual spring stuff
    vx -= k * (x-cx); 
    vy -= k * (y-cy); 
    vx -= hg;
    vx *= d; 
    vy *= d;
    x += vx; 
    y += vy;
    a += da;
  
    green = constrain(green, 100, 240);
    blue = constrain(blue, 100, 240);

    //re-shrink joints after he eats a bonus square
    r *= 0.95;
    if (r < 4) r = 4;
    }
  }

//global function to detect soundtrack beat, and make 
//squares and triangles pulse accordingly
void beatDetect()
{
  beat.detect(soundtrack.mix);

  if (beat.isKick())
  {
    triangle.l += 6;
  }
  triangle.l *= 0.85;
  if (triangle.l < 10) triangle.l = 10;  

  for (int i=0; i<squares.length; i++)
  {
    if (beat.isKick())
    {
      squares[i].w += 6;
    }
    squares[i].w *= 0.85;
    if (squares[i].w < 10) squares[i].w = 10;
  }
}

//global function that handles all collisions
void collisions()
{
  //check for collisions between worm and balls
  //if there are any collisions, game over!
  for (int j=0; j<nBalls; j++)
  {
    for (int i=0; i<nJoints; i++)
    {
      if (dist(joints[i].x, joints[i].y, balls[j].x, balls[j].y) <= joints[i].r + balls[j].r)
      {
        gameState = lost;

        //play "game over" sound
        gameOver.play();
        gameOver.rewind();
      }
    }
  }

  //check for collisions between worm head and visible bonus squares
  for (int j=0; j<squares.length; j++)
  {
    if (dist(mouseX, mouseY, squares[j].x, squares[j].y) <= 20)
    {
      if (squares[j].timer > 40)
      {
        //play bloop sound
        bloop1.play();
        bloop1.rewind();

        //add 100 bonus points, extinguish+reinitialize square
        score += 100;
        squares[j].timer = 100;
        squares[j].dt = 30;
        squares[j].w += 20;
        squares[j].timerBonus = 100;
        squares[j].dtBonus = 1;
        
        // show bonus text
        fill((squares[j].timerBonus));
        textAlign(CENTER);
        textFont(fontBonus, 48);
        text("+100!", (mouseX), (mouseY));

        //temporarily swell wormjoints
        for (int i=0; i<nJoints; i++)
        {
          joints[i].r += 1;
        }
      }
    }
  }

  //check for collisions between balls and explosive triangles
  if (dist(mouseX, mouseY, triangle.x, triangle.y) <= triangle.l*2 && triangle.timer == 255)
  {  

    //trigger explosion behavior (see Triangle class) 
    triangle.explode = true;

    //play bloop sound
    bloop3.play();
    bloop3.rewind();
  }
}

//global function responsible for drawing and updating all game objects each frame
void drawObjects()
{
      // Draw and update balls
    for (int i=0; i<nBalls; i++) balls[i].draw();
    for (int i=0; i<nBalls; i++) balls[i].update();
    for (int i=0; i<nBalls; i++) balls[i].bounce();

    //Draw and update squares
    for (int i=0; i<squares.length; i++) squares[i].draw();
    for (int i=0; i<squares.length; i++) squares[i].update();
    for (int i=0; i<squares.length; i++) squares[i].bounce();
    
    //Draw and update probiotic triangle
    triangle.draw();
    triangle.update();

    //Draw and update wiggly worm joints
    for (int i=0; i<nJoints; i++) joints[i].draw();

    // Recenter first joint at the mouse
    joints[0].update(mouseX, mouseY);

    // Recenter each following joint at preceding joint
    for (int i=1; i<nJoints; i++)
      joints[i].update(joints[i-1].x, joints[i-1].y);
}
//global function that initializes the game
void gameInit()
{

  //game begins on menu screen with score of 0, 10 balls, 2 worm joints
  gameState = menu;
  score = 0;
  scoreUpdateBalls = 0;
  scoreUpdateJoints = 0;
  nBalls = 10;
  nJoints = 2;
  
  
  // Construct joints at center of canvas. 
  for (int i=0; i<nJoints; i++)
  {
    joints[i] = new WormJoint(i*width/nJoints, height/2, 4);
  }

  // Create the antibiotic balls
  for (int i=0; i<nBalls; i++) {
    balls[i] = new Ball();
  }

  // Create the tasty nutritional squares
  for (int i=0; i<squares.length; i++) {
    squares[i] = new Square();
  }
  
    // Create the explosive probiotics triangle
    triangle = new Triangle();
}
void gameOverText()
{
    
  //display "GAME OVER" messages
    textAlign(CENTER);
    fill(245,20,0);

    textFont(fontBonus, 60);
    text("You killed Timmy!", (width/2), (height/2) - 40);
    fill(255);
    textFont(font, 20);
    text("Click anywhere to restart game", width/2, height/2 + 20);

    //display score in left corner
    textAlign(LEFT);
    textFont(font, 20);
    text("SCORE: " + score, 20, (height - 30));
    

    //display high score in corner
    textAlign(RIGHT);
    text("HIGH SCORE: " + hiScore, (width - 20), (height - 30));
}
void menuText ()
{
  //display start messages
  textAlign(CENTER);
  fill(fontColor);
  textFont(fontBonus, 100);
  text("WIGGLY WORM", width/2, height/2 - 60);

  textFont(font, 16);
  fill(255);
  text("Use the mouse to help Timmy the misunderstood tapeworm evade the red antibiotics!", 
  width/2, height/2);
  text("Snack on delicious green nutrients to gain bonus points", 
  width/2, height/2 + 30);
    text("Pop the orange probiotics to destroy nearby antibiotics", 
  width/2, height/2 + 60);

  textFont(font, 14);
  text("Click anywhere to begin", width/2, height/2 + 160);

  //display high score in corner
  textFont(font, 20);
  textAlign(RIGHT);
  text("HIGH SCORE: " + hiScore, (width - 20), (height - 30));
}

void scoreText()
{
  //display score in left corner
  textAlign(LEFT);
  fill(255);
  textFont(font);
  text("SCORE: " + score, 20, (height - 30));

  //display high score in right corner
  textAlign(RIGHT);
  text("HIGH SCORE: " + hiScore, (width - 20), (height - 30));
}

void scoreUpdate()
{
  //update score each frame
  score++;


  //update, set high score if current score is greater than previous high score
  hiScore = score > hiScore ? score : hiScore;

  //increase level and number of balls every 2000 points
  if (score / 1000 > scoreUpdateBalls)
  {
    addBall();
    scoreUpdateBalls++;
  }

  else if (score / 2000 > scoreUpdateJoints)
  {   
    
    pop1.play();
    pop1.rewind();
    
    addJoint();
    scoreUpdateJoints++;
    println(nJoints);
  }
}

//create an additional ball every 1000 points
void addBall() {
  balls[nBalls] = new Ball();
  nBalls++;
}

//create an additional joint every 2000 points
void addJoint() {
  joints[nJoints] = new WormJoint(mouseX, mouseY, 4);
  nJoints++;
}

void soundSpeaker()
{
  if (!muted)
  {
    image(speakerOn, width-80, 20);
  }
  else
  {
    image(speakerOff, width-80, 20);
  }
}

