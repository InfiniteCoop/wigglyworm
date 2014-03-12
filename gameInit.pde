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
