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

  //check for collisions between worm head and bonus squares
  for (int j=0; j<squares.length; j++)
  {
    if (dist(mouseX, mouseY, squares[j].x, squares[j].y) <= 20)
    {
      if (squares[j].timer > 40)
      {
        //play bloop sound
        bloop1.play();
        bloop1.rewind();

        //add 100 bonus points, extinguish+reinitialize square, show bonus text
        score += 100;
        squares[j].timer = 100;
        squares[j].dt = 30;
        squares[j].w += 20;
        squares[j].timerBonus = 100;
        squares[j].dtBonus = 0.5;
        fill((squares[j].timerBonus));
        textAlign(CENTER);
        textFont(font, 45);
        text("+100", (mouseX), (mouseY));

        for (int i=0; i<nJoints; i++)
        {
          joints[i].r += 1;
        }
      }
    }
  }
}
