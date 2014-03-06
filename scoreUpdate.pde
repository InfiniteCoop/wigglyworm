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
  //println(nBalls);
}

//create an additional joint every 2000 points
void addJoint() {
  joints[nJoints] = new WormJoint(mouseX, mouseY, 4);
  nJoints++;
  //play "upgrade" sound
}

